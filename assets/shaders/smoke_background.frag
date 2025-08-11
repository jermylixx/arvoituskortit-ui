#version 460 core
precision highp float;

layout(location = 0) out vec4 fragColor;
layout(location = 0) uniform float u_time;
layout(location = 1) uniform vec2  u_resolution;

/*** fBm – pehmeä, savumainen kenttä (laajat muodot, matala kontrasti) ***/
float hash(vec2 p){ return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453123); }
float noise(vec2 p){
  vec2 i = floor(p), f = fract(p);
  float a = hash(i);
  float b = hash(i + vec2(1.0,0.0));
  float c = hash(i + vec2(0.0,1.0));
  float d = hash(i + vec2(1.0,1.0));
  vec2 u = f*f*(3.0-2.0*f);
  return mix(mix(a,b,u.x), mix(c,d,u.x), u.y);
}
float fbm(vec2 p){
  float v=0.0, a=0.58;
  for(int i=0;i<5;i++){ v += a*noise(p); p *= 0.72; a *= 0.56; }
  return v;
}

void main(){
  vec2 res = u_resolution;
  vec2 uv = (gl_FragCoord.xy / res) - 0.5;
  uv.x *= res.x / res.y;

  // ERITTÄIN hidas, laaja aaltoilu
  float t = u_time * 0.006;
  vec2 flow1 = vec2(t*0.23, -t*0.17);
  vec2 flow2 = vec2(-t*0.19,  t*0.21);

  float n1 = fbm(uv*0.85 + flow1);
  float n2 = fbm(uv*1.10 + flow2);
  float m  = smoothstep(0.30, 0.70, mix(n1, n2, 0.45));

  // Selkeä vihreä ↔ violetti, musta saa jäädä syvyydeksi
  vec3 violet = vec3(0.65, 0.18, 0.92);
  vec3 green  = vec3(0.12, 0.86, 0.58);
  vec3 col    = mix(violet, green, m);

  // EI vignettiä testiksi (palautetaan kevyt versio myöhemmin)
  fragColor = vec4(col, 1.0);

}
