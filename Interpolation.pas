unit Interpolation;

interface

uses math;

type TInterpolation1D = function(x1,x2,u: double) : double;
type TInterpolation2D = function(x11,x21,x12,x22,u,v : double):double;

function linear(x1,x2,u: double) : double;overload;             // 1D linear interpolation
function linear(x0,x1,x2,x3,u: double) : double;overload;       // 1D linear interpolation
function linear(x11,x21,x12,x22,u,v : double) : double;overload;// 2D linear interpolation
function cosine(x1,x2,u : double) : double;overload;            // 1D cosine interpolation
function cosine(x0,x1,x2,x3,u : double) : double;overload;// 1D cosine interpolation
function cosine(x11,x21,x12,x22,u,v : double):double;overload;  // 2D cosine interpolation
function cubic(x1,x2,u : double) : double;overload;             // 1D cubic interpolation
function cubic(x11,x21,x12,x22,u,v : double):double;overload;   // 2D cubic interpolation
function sqrBlend(x0,x1,x2,x3,u : double) : double;overload;
function sqrBlend(x00,x10,x20,x30,x01,x11,x21,x31,x02,x12,x22,x32,x03,x13,x23,x33,u,v:double):double;overload;

function triangleInt(x,y,x1,y1,d1,x2,y2,d2,x3,y3,d3:double):double;

implementation

function linear(x1,x2,u: double) : double;
begin
	result := (x1*(1-u)+x2*u);
end;

function linear(x0,x1,x2,x3,u: double) : double;
begin
	result := (x1*(1-u)+x2*u);
end;

function linear(x11,x21,x12,x22,u,v : double) : double;overload;
begin
     result:=((1-u)*x11+u*x21)*(1-v)+v*((1-u)*x12+u*x22);
end;

function cosine(x1,x2,u : double) : double;
begin
	u := (1-cos(u*pi))*0.5;
	result:= x1*(1-u)+x2*u;
end;

function cosine(x0,x1,x2,x3,u : double) : double;
begin
	u := (1-cos(u*pi))*0.5;
	result:= x1*(1-u)+x2*u;
end;

function cosine(x11,x21,x12,x22,u,v : double):double;
begin
	u := (1-cos(u*pi))*0.5;
	v := (1-cos(v*pi))*0.5;
	result:=(x11*(1-u)+x21*u)*(1-v)+(x12*(1-u)+x22*u)*v;
end;

function cubic(x1,x2,u : double) : double;
begin
        u :=(4/9)*power(u,6)-(17/9)*power(u,4)+(22/9)*sqr(u);
	result:= x1*(1-u)+x2*u;
end;

function cubic(x11,x21,x12,x22,u,v : double):double;
begin
        u :=(4/9)*power(u,6)-(17/9)*power(u,4)+(22/9)*sqr(u);
        v :=(4/9)*power(v,6)-(17/9)*power(v,4)+(22/9)*sqr(v);
	result:=(x11*(1-u)+x21*u)*(1-v)+(x12*(1-u)+x22*u)*v;
end;

function sqrBlend(x0,x1,x2,x3,u : double) : double;
        var a1,b1,a2,b2:double;
begin
        a1:=(x0+x2-2*x1)/2;
        b1:=(x2-x0)/2;
        a2:=(x1+x3-2*x2)/2;
        b2:=(x3-x1)/2;
        x1:=a1*sqr(u)+b1*u+x1;
        x2:=a2*sqr(u-1)+b2*(u-1)+x2;
	result:= x1*(1-u)+x2*u;
end;

function sqrBlend(x00,x10,x20,x30,x01,x11,x21,x31,
                  x02,x12,x22,x32,x03,x13,x23,x33,u,v:double):double;
   var a11,b11,c11,d11,e11,f11,g11,h11,i11 : double;
   var a12,b12,c12,d12,e12,f12,g12,h12,i12 : double;
   var a21,b21,c21,d21,e21,f21,g21,h21,i21 : double;
   var a22,b22,c22,d22,e22,f22,g22,h22,i22 : double;
begin
   a11:=( x00-2*x10+x20-2*x01+4*x11-2*x21+x02-2*x12+x22)/4;
   b11:=(-x00+2*x10-x20+x02-2*x12+x22)/4;
   c11:=(-x00+x20+2*x01-2*x21-x02+x22)/4;
   d11:=(x01-2*x11+x21)/2;
   e11:=(x00-x20-x02+x22)/4;
   f11:=(x10-2*x11+x12)/2;
   g11:=(-x01+x21)/2;
   h11:=(-x10+x12)/2;
   i11:=x11;
   a12:=( x01-2*x11+x21-2*x02+4*x12-2*x22+x03-2*x13+x23)/4;
   b12:=(-x01+2*x11-x21+x03-2*x13+x23)/4;
   c12:=(-x01+x21+2*x02-2*x22-x03+x23)/4;
   d12:=(x02-2*x12+x22)/2;
   e12:=(x01-x21-x03+x23)/4;
   f12:=(x11-2*x12+x13)/2;
   g12:=(-x02+x22)/2;
   h12:=(-x11+x13)/2;
   i12:=x12;
   a22:=( x11-2*x21+x31-2*x12+4*x22-2*x32+x13-2*x23+x33)/4;
   b22:=(-x11+2*x21-x31+x13-2*x23+x33)/4;
   c22:=(-x11+x31+2*x12-2*x32-x13+x33)/4;
   d22:=(x12-2*x22+x32)/2;
   e22:=(x11-x31-x13+x33)/4;
   f22:=(x21-2*x22+x23)/2;
   g22:=(-x12+x32)/2;
   h22:=(-x21+x23)/2;
   i22:=x22;
   a21:=( x10-2*x20+x30-2*x11+4*x21-2*x31+x12-2*x22+x32)/4;
   b21:=(-x10+2*x20-x30+x12-2*x22+x32)/4;
   c21:=(-x10+x30+2*x11-2*x31-x12+x32)/4;
   d21:=(x11-2*x21+x31)/2;
   e21:=(x10-x30-x12+x32)/4;
   f21:=(x20-2*x21+x22)/2;
   g21:=(-x11+x31)/2;
   h21:=(-x20+x22)/2;
   i21:=x21;
   x11:=a11*sqr(u)*sqr(v)+b11*sqr(u)*v+c11*u*sqr(v)+d11*sqr(u)
        +e11*u*v+f11*sqr(v)+g11*u+h11*v+i11;
   x12:=a12*sqr(u)*sqr((v-1))+b12*sqr(u)*(v-1)+c12*u*sqr((v-1))+d12*sqr(u)
        +e12*u*(v-1)+f12*sqr((v-1))+g12*u+h12*(v-1)+i12;
   x21:=a21*sqr((u-1))*sqr(v)+b21*sqr((u-1))*v+c21*(u-1)*sqr(v)+d21*sqr((u-1))
        +e21*(u-1)*v+f21*sqr(v)+g21*(u-1)+h21*v+i21;
   x22:=a22*sqr((u-1))*sqr((v-1))+b22*sqr((u-1))*(v-1)+c22*(u-1)*sqr((v-1))+d22*sqr((u-1))
        +e22*(u-1)*(v-1)+f22*sqr((v-1))+g22*(u-1)+h22*(v-1)+i22;
   result:=(x11*(1-u)+x21*u)*(1-v)+(x12*(1-u)+x22*u)*v;
end;

function triangleInt(x,y,x1,y1,d1,x2,y2,d2,x3,y3,d3:double):double;
   var T123,T12,T23,T31:double;
begin
{   T123 := abs( x1*y2 + y1*x3 + x2*y3 - x1*y3 - y1*x2 - y2*x3 );
   T12  := abs( x1*y2 + y1*x  + x2*y  - x1*y  - y1*x2 - y2*x  );
   T23  := abs( x *y2 + y *x3 + x2*y3 - x *y3 - y *x2 - y2*x3 );
   T31  := abs( x1*y  + y1*x3 + x *y3 - x1*y3 - y1*x  - y *x3 ); }
   T123 := abs( (x3-x1)*(y2-y1)-(x2-x1)*(y3-y1) );
   T12  := abs( (x -x1)*(y2-y1)-(x2-x1)*(y -y1) );
   T23  := abs( (x3-x )*(y2-y )-(x2-x )*(y3-y ) );
   T31  := abs( (x3-x1)*(y -y1)-(x -x1)*(y3-y1) );
   If T123<>0 then result:=(d1*T23+d2*T31+d3*T12)/T123 else result:=d1;
//   result:=(sqrt(sqr(x-x1)+sqr(y-y1))*d2+sqrt(sqr(x-x2)+sqr(y-y2))*d1)
//          /(sqrt(sqr(x-x1)+sqr(y-y1))+sqrt(sqr(x-x2)+sqr(y-y2)));
end;


end.

// Köbös 3x^2-2x^3

// monoton köbös Hermite interpoláció
// intervallum t[k]..t[k+1]

// d[k] = (f[k+1] - f[k-1])/2
// delta[k] = f[k+1]-f[k]
// a3 = d[k]+d[k+1]-delta[k]
// a2 = 3*delta[k]-2*d[k]-d[k+1]
// a1 = d[k]
// a0 = f[k]
// f(t) = a3*(t-t[k])^3+a2*(t-t[k])^2+a1*(t-t[k])+a0

