#version 300 es
precision highp float;

// Flutter runtime header (required by flutter_shaders)
#include <flutter/runtime_effect.glsl>

// Uniform order matches setFloat indices in Dart:
// 0: width, 1: height, 2: time, 3: refract, 4: gloss
uniform float uWidth;
uniform float uHeight;
uniform float uTime;
uniform float uRefract;  // 0.0 – 1.5
uniform float uGloss;    // 0.0 – 1.0

// Background image captured from RepaintBoundary
uniform sampler2D uTex0; // setImageSampler(0, background)

out vec4 fragColor;

// Simple hash-based value noise (cheap, no diagonal banding)
float hash(vec2 p) {
  p = fract(p * vec2(123.34, 345.45));
  p += dot(p, p + 34.345);
  return fract(p.x * p.y);
}

float noise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  float a = hash(i);
  float b = hash(i + vec2(1.0, 0.0));
  float c = hash(i + vec2(0.0, 1.0));
  float d = hash(i + vec2(1.0, 1.0));
  vec2 u = f * f * (3.0 - 2.0 * f);
  return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

vec2 swirl(vec2 uv, float t) {
  // subtle animated micro-distortion to avoid perfectly static glass
  float n = noise(uv * 3.5 + t * 0.05);
  float a = (n - 0.5) * 0.02; // very tiny
  return uv + vec2(cos(a), sin(a)) * (n - 0.5) * 0.003;
}

void main() {
  vec2 frag = FlutterFragCoord().xy;
  vec2 res = vec2(uWidth, uHeight);
  vec2 uv = frag / res;

  // Distance to nearest edge (0 at edge, ~0.5 at center)
  float d = min(min(uv.x, uv.y), min(1.0 - uv.x, 1.0 - uv.y));

  // Edge emphasis: 1.0 at very edge, 0.0 at center
  float edge = 1.0 - smoothstep(0.02, 0.14, d);

  // Refract direction from center outwards
  vec2 fromCenter = uv - 0.5;
  vec2 dir = normalize(fromCenter + 1e-6);

  // Edge-weighted refraction amount, tiny in the center, stronger at edges
  float refrAmt = uRefract * (0.006 * edge + 0.001);

  // Add faint organic wobble to avoid "perfect pane" look
  vec2 uvDistorted = swirl(uv, uTime) + dir * refrAmt;

  // Sample the background with refraction, clamp to avoid sampling outside
  uvDistorted = clamp(uvDistorted, vec2(0.0), vec2(1.0));
  vec4 bg = texture(uTex0, uvDistorted);

  // Subtle violet tint, almost transparent
  vec3 violet = vec3(0.64, 0.40, 0.95);
  float tintAmount = 0.06; // very light
  vec3 tinted = mix(bg.rgb, mix(bg.rgb, violet, tintAmount), 0.5);

  // Fresnel-ish edge brightening for thin glass edge perception
  float fresnel = pow(1.0 - clamp(length(fromCenter) * 1.6, 0.0, 1.0), 2.0);
  float edgeLight = edge * (0.06 + 0.10 * uGloss) * (1.0 - fresnel);
  tinted += edgeLight;

  // Final alpha: nearly invisible at center, slightly stronger at edges
  float alpha = mix(0.06, 0.14, edge);

  fragColor = vec4(tinted, alpha);
}
