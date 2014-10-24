#define PROCESSING_COLOR_SHADER

#define PI 3.1415926535897932384626433832795

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

//precision lowp float;

uniform float time;
uniform vec2 resolution;

vec3 fade(vec3 t) {
  return vec3(1.0,1.0,1.0);//t*t*t*(t*(t*6.0-15.0)+10.0);
}

vec2 rotate(vec2 point, float rads) {
	float cs = cos(rads);
	float sn = sin(rads);
	return point * mat2(cs, -sn, sn, cs);
}

vec4 randomizer4(const vec4 x)
{
    vec4 z = mod(x, vec4(5612.0));
    z = mod(z, vec4(3.1415927 * 2.0));
    return(fract(cos(z) * vec4(56812.5453)));
}

// Fast computed noise
// http://www.gamedev.net/topic/502913-fast-computed-noise/

const float A = 1.0;
const float B = 57.0;
const float C = 113.0;
const vec3 ABC = vec3(A, B, C);
const vec4 A3 = vec4(0, B, C, C+B);
const vec4 A4 = vec4(A, A+B, C+A, C+A+B);

float cnoise4(const in vec3 xx)
{
    vec3 x = mod(xx + 32768.0, 65536.0);
    vec3 ix = floor(x);
    vec3 fx = fract(x);
    vec3 wx = fx*fx*(3.0-2.0*fx);
    float nn = dot(ix, ABC);

    vec4 N1 = nn + A3;
    vec4 N2 = nn + A4;
    vec4 R1 = randomizer4(N1);
    vec4 R2 = randomizer4(N2);
    vec4 R = mix(R1, R2, wx.x);
    float re = mix(mix(R.x, R.y, wx.y), mix(R.z, R.w, wx.y), wx.z);

    return 1.0 - 2.0 * re;
}
float surface3 ( vec3 coord, float frequency ) {

	float n = 0.0;

	n += 1.0	* abs( cnoise4( coord * frequency ) );
	n += 0.5	* abs( cnoise4( coord * frequency * 2.0 ) );
	n += 0.25	* abs( cnoise4( coord * frequency * 4.0 ) );
	n += 0.125	* abs( cnoise4( coord * frequency * 8.0 ) );
	n += 0.0625	* abs( cnoise4( coord * frequency * 16.0 ) );

	return n;
}

vec4 nebula()
 {
      float rads = radians(time*3.15);
      vec2 position = gl_FragCoord.xy / resolution.xy;
      position += rotate(position, rads);
      float n = surface3(vec3(position*sin(time*0.1), time * 0.05)*mat3(1,0,0,0,.8,.6,0,-.6,.8),0.9);
      float n2 = surface3(vec3(position*cos(time*0.1), time * 0.04)*mat3(1,0,0,0,.8,.6,0,-.6,.8),0.8);
          float lum = length(n);
          float lum2 = length(n2);

      vec3 tc = pow(vec3(1.0-lum),vec3(sin(position.x)+cos(time)+4.0,8.0+sin(time)+4.0,8.0));
      vec3 tc2 = pow(vec3(1.1-lum2),vec3(5.0,position.y+cos(time)+7.0,sin(position.x)+sin(time)+2.0));
      vec3 curr_color = (tc*0.8) + (tc2*0.5);

      //Let's draw some stars

      float scale = sin(0.3 * time) + 5.0;
      vec2 position2 = (((gl_FragCoord.xy / resolution) - 0.5) * scale);
      float gradient = 0.0;
      vec3 color = vec3(0.0);
      float fade = 0.0;
      float z = 0.0;
       vec2 centered_coord = position2 - vec2(sin(time*0.1),sin(time*0.1));
      centered_coord = rotate(centered_coord, rads);

      for (float i=1.0; i<=60.0; i++)
      {
        vec2 star_pos = vec2(sin(i) * 250.0, sin(i*i*i) * 250.0);
        float z = mod(i*i - 10.0*time, 256.0);
        float fade = (256.0 - z) /256.0;
        vec2 blob_coord = star_pos / z;
        gradient += ((fade / 384.0) / pow(length(centered_coord - blob_coord), 1.5)) * ( fade);
      }

      curr_color += gradient;

      return vec4(curr_color, 1.0);
}

// uniform float time;
// uniform vec2 resolution;

const float Pi = 3.14159;

float sinApprox(float x) {
    x = Pi + (2.0 * Pi) * floor(x / (2.0 * Pi)) - x;
    return (4.0 / Pi) * x - (4.0 / Pi / Pi) * x * abs(x);
}

float cosApprox(float x) {
    return sinApprox(x + 0.5 * Pi);
}

vec4 plasma()
{
	vec2 p=(2.0*gl_FragCoord.xy-resolution)/max(resolution.x,resolution.y);
	for(int i=1;i<50;i++)
	{
		vec2 newp=p;
		newp.x+=0.6/float(i)*sin(float(i)*p.y+time/40.0+0.3*float(i))+1.0;
		newp.y+=0.6/float(i)*sin(float(i)*p.x+time/40.0+0.3*float(i+10))-1.4;
		p=newp;
	}
	vec3 col=vec3(0.5*sin(3.0*p.x)+0.5,0.5*sin(3.0*p.y)+0.5,sin(p.x+p.y));
	//gl_FragColor=vec4(col, 1.0);
	//gl_FragColor=vec4(1.0,0.0,0.5, 1.0);
  return vec4(col, 1.0);
}

//uniform float time;

// Component wise blending
#define Blend(base, blend, funcf)       vec3(funcf(base.r, blend.r), funcf(base.g, blend.g), funcf(base.b, blend.b))
// Blend Funcs
#define BlendScreenf(base, blend)       (1.0 - ((1.0 - base) * (1.0 - blend)))
#define BlendMultiply(base, blend)       (base * blend)
#define BlendScreen(base, blend)       Blend(base, blend, BlendScreenf)

vec3 nrand3( vec2 co )
{
   vec3 a = fract( cos( co.x*8.3e-3 + co.y )*vec3(1.3e5, 4.7e5, 2.9e5) );
   vec3 b = fract( sin( co.x*0.3e-3 + co.y )*vec3(8.1e5, 1.0e5, 0.1e5) );
   vec3 c = mix(a, b, 0.5);
   return c;
}

float snoise(vec3 uv, float res)
{
   const vec3 s = vec3(1e0, 1e2, 1e4);

   uv *= res;

   vec3 uv0 = floor(mod(uv, res))*s;
   vec3 uv1 = floor(mod(uv+vec3(1.), res))*s;

   vec3 f = fract(uv); f = f*f*(3.0-2.0*f);

   vec4 v = vec4(uv0.x+uv0.y+uv0.z, uv1.x+uv0.y+uv0.z,
                 uv0.x+uv1.y+uv0.z, uv1.x+uv1.y+uv0.z);

   vec4 r = fract(sin(v*1e-3)*1e5);
   float r0 = mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y);

   r = fract(sin((v + uv1.z - uv0.z)*1e-3)*1e5);
   float r1 = mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y);

   return mix(r0, r1, f.z)*2.-0.3;
}

vec3 clouds(vec2 tc,float iter)
{
	tc /= 1000.0;
   float color = 0.0;
   for(int i = 0; i <= 3; i++)
   {
      float power = pow(2.0, float(i));
      color += (0.5 / power) * snoise(vec3(tc,0.0), power*11.0);
   }
   return vec3(color,color,color);
}

vec3 getcolor(vec2 coords,float intensity)
{
	coords = coords/6000.0;
	return normalize(vec3(snoise(vec3(coords,0.0),intensity),
                  snoise(vec3(coords,0.1),intensity),
                  snoise(vec3(coords,0.2),intensity)   ));
}

vec3 genstars(float starsize, float density, float intensity, vec2 seed)
{
	vec3 rnd = nrand3( floor(seed*(1.0/starsize)) );
	vec3 stars = vec3(pow(rnd.y,density))*intensity;
	rnd = clouds(seed,1.0);
	return BlendMultiply(stars,rnd);
}

vec4 blending(void)
{
	vec2 offset = vec2(time,time);
	float n = 30.0;
	vec3 stars = clouds(gl_FragCoord.xy+offset*n,5.0);
	vec3 color = getcolor(gl_FragCoord.xy+offset*n,11.0)*0.2;
	color = BlendMultiply(stars,color);
	stars = genstars(3.0,16.0,1.0,gl_FragCoord.xy+offset*n);
	color = BlendScreen(color,stars);
	n=20.0;
	stars = genstars(2.0,16.0,1.0,gl_FragCoord.xy+offset*n);
	n=10.0;
	color = BlendScreen(color,stars);
	stars = genstars(1.0,16.0,1.0,gl_FragCoord.xy+offset*n)*0.8;
	color = BlendScreen(color,stars);
 return vec4(color,1);
}

void main( void ) {
  gl_FragColor = nebula() * blending() * plasma();
}
