#version 460 core
precision highp float;

layout(location = 0) out vec4 fragColor;
layout(location = 0) uniform float u_time;
layout(location = 1) uniform vec2  u_resolution;

/*** fBm: pehmeä, matalakontrastinen “savukenttä” ***/
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
  float v=0.0, a=0.55;
  // suuuuri skaala -> isot muodot
  for(int i=0;i<5;i++){ v += a*noise(p); p *= 0.75; a *= 0.55; }
  return v;
}

void main(){
  vec2 res = u_resolution;
  vec2 uv = (gl_FragCoord.xy / res) - 0.5;
  uv.x *= res.x / res.y;

  // ERITTÄIN hidas liike + laaja “hengitys”
  float t = u_time * 0.006;
  vec2 flow1 = vec2(t*0.25, -t*0.18);
  vec2 flow2 = vec2(-t*0.17, t*0.21);

  float n1 = fbm(uv*0.9  + flow1);
  float n2 = fbm(uv*1.15 + flow2);
  float m  = smoothstep(0.35, 0.65, mix(n1, n2, 0.45));

  // Sävytys: savumainen violetti ↔ vihreä, taustalla musta jää “aukkoihin”
  vec3 violet = vec3(0.30, 0.00, 0.38); // desaturoitu
  vec3 green  = vec3(0.00, 0.34, 0.22);
  vec3 smoke  = mix(violet, green, m);

  // Hieno vignetti lisää “syvyyttä”
  float r = length(uv);
  float vign = smoothstep(0.95, 0.35, r); // keskusta kirkkaampi
  smoke *= vign;

  fragColor = vec4(smoke, 1.0);
}
