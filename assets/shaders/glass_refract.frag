#version 460 core
precision highp float;

layout(location = 0) out vec4 fragColor;

/* Float-uniformit: indeksit 0.. */
layout(location = 0) uniform vec2  u_resolution;  // (w,h)
layout(location = 2) uniform float u_time;        // sekunteja
layout(location = 3) uniform float u_refract;     // 0..1 refraktion voimakkuus
layout(location = 4) uniform float u_gloss;       // 0..1 kiillon voimakkuus

/* Samplerille EI layout-qualifieria Impellerissa */
uniform sampler2D u_tex;

void main() {
  vec2 res = u_resolution;
  vec2 uv  = gl_FragCoord.xy / res;

  // Linssin keskipiste ruudun keskellä (kortti piirtää tämän omaan local-rectiin)
  vec2 center = vec2(0.5, 0.5);
  vec2 p = uv - center;
  float r = length(p);

  // Paksu linssi: pehmeä “bump”-profiili, säätö rauhallinen
  float bump = smoothstep(0.95, 0.0, r); // 0 keskellä -> 1 reunoilla
  vec2 refr = normalize(p) * (u_refract * 0.025 * bump);

  // Näyte taustasta refraktion siirrolla
  vec4 col = texture(u_tex, uv + refr);

  // Reunavalo + sisävarjo lisää paksuutta
  float edge = smoothstep(0.88, 0.60, r);
  col.rgb *= mix(1.0, 0.92, edge);   // sisävarjo
  col.rgb += edge * 0.06;            // reunavalo

  // Leveä, lähes huomaamaton kiilto diagonaalisesti
  vec2 glossDir = normalize(vec2(0.8, -0.6));
  float band = 1.0 - smoothstep(0.0, 0.35, abs(dot(glossDir, p) * 2.0));
  col.rgb += u_gloss * band * 0.10;

  fragColor = col;
}