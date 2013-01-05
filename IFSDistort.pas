unit IFSDistort;

{$MODE Delphi}

interface

uses math;

type IFSDistortFunction = Procedure(var x,y:double);

Procedure Sinusoidal(var x,y:double);
Procedure Spheical(var x,y:double);
Procedure Swirl(var x,y:double);
Procedure Horseshoe(var x,y:double);
Procedure Polar(var x,y:double);
Procedure Handkerchief(var x,y:double);
Procedure Heart(var x,y:double);
Procedure Disc(var x,y:double);
Procedure Spiral(var x,y:double);
Procedure Hiperbolic(var x,y:double);
Procedure Diamond(var x,y:double);
Procedure Ex(var x,y:double);
Procedure Julia(var x,y:double);
Procedure Weave(var x,y:double);
Procedure sandGlass(var x,y:double);
Procedure Television(var x,y:double);
Procedure Floverbox(var x,y:double);
Procedure Scape(var x,y:double);
Procedure HyperCircle(var x,y:double);
Procedure Weaves(var x,y:double);
Procedure Grass(var x,y:double);
Procedure Tube(var x,y:double);
Procedure Sphere(var x,y:double);
Procedure Geo(var x,y:double);
Procedure Gravity(var x,y:double);
Procedure Snail(var x,y:double);
Procedure Spirals(var x,y:double);

const IFSDistorts : array[1..27] of IFSDistortFunction =
   (Sinusoidal, Spheical, Swirl, Horseshoe, Polar, Handkerchief,
    Heart, Disc, Spiral, Hiperbolic, Diamond, Ex, Julia, Weave,
    sandGlass, Television, Floverbox, Scape, HyperCircle, Weaves,
    Grass, Tube, Sphere, Geo, Gravity, Snail, Spirals);

procedure defTetraederBase;
procedure tetraSymmetry(var x,y,z : double);

implementation

var E : array of array[0..2] of double;

procedure defTetraederBase;
   var i:integer;
       d : double;
begin
   setlength(E,4);
   E[0][0] := -1/2;     E[0][1] := -sqrt(3)/6;  E[0][2] := -sqrt(2)/(4*sqrt(3));
   E[1][0] := 1/2;      E[1][1] := -sqrt(3)/6;  E[1][2] := -sqrt(2)/(4*sqrt(3));
   E[2][0] := 0;        E[2][1] := sqrt(3)/3;   E[2][2] := -sqrt(2)/(4*sqrt(3));
   E[3][0] := 0;        E[3][1] := 0;           E[3][2] := sqrt(2)*sqrt(3)/4;
   for i := 0 to 3 do begin
      d := sqrt(sqr(E[i][0])+sqr(E[i][1])+sqr(E[i][2]));
      E[0][0] := E[0][0]/d;
      E[0][1] := E[0][1]/d;
      E[0][2] := E[0][2]/d;
   end;
end;

procedure tetraSymmetry(var x,y,z : double);
   var i,j,n1,n2,n0 : integer;
       xn,zn,yn,d : double;
       en,t : array[0..2,0..2] of double;
begin
   n0 := 0;
   n1 := 1;
   n2 := 2;
   xn := e[n0][0]*x + e[n1][0]*y + e[n2][0]*z;
   yn := e[n0][1]*x + e[n1][1]*y + e[n2][1]*z;
   zn := e[n0][2]*x + e[n1][2]*y + e[n2][2]*z+d-d;
   n0 := 2;
   n1 := 1;
   n2 := 3;
   d := e[n0][0]*e[n1][1]*e[n2][2] + e[n1][0]*e[n2][1]*e[n0][2] + e[n2][0]*e[n0][1]*e[n1][2]
      - e[n0][0]*e[n2][1]*e[n1][2] - e[n1][0]*e[n0][1]*e[n2][2] - e[n2][0]*e[n1][1]*e[n0][2];
   en[0][0] := -(-e[n1][1]*e[n2][2]+e[n2][1]*e[n1][2]);
   en[0][1] := -e[n0][1]*e[n2][2]+e[n0][2]*e[n2][1];
   en[0][2] := -(-e[n0][1]*e[n1][2]+e[n0][2]*e[n1][1]);
   en[1][0] := -e[n1][0]*e[n2][2]+e[n2][0]*e[n1][2];
   en[1][1] := e[n0][0]*e[n2][2]-e[n2][0]*e[n0][2];
   en[1][2] := -(e[n0][0]*e[n1][2]-e[n1][0]*e[n0][2]);
   en[2][0] := e[n1][0]*e[n2][1]-e[n2][0]*e[n1][1];
   en[2][1] := -e[n0][0]*e[n2][1]+e[n2][0]*e[n0][1];
   en[2][2] := e[n0][0]*e[n1][1]-e[n0][1]*e[n1][0];

   x := (en[0][0]*xn + en[0][1]*yn + en[0][2]*zn)/d;
   y := (en[1][0]*xn + en[1][1]*yn + en[1][2]*zn)/d;
   z := (en[2][0]*xn + en[2][1]*yn + en[2][2]*zn)/d;
end;

Procedure Sinusoidal(var x,y:double);
begin
   x:=sin(x);
   y:=sin(y);
end;

Procedure Spheical(var x,y:double);
   var r:double;
begin
  r:=sqrt(x*x+y*y);
  if r=0 then r:=0.0000001;
  x:=x/sqr(r);
  y:=y/sqr(r);
end;

Procedure Swirl(var x,y:double);
   var r,fi:double;
begin
  r:=sqrt(x*x+y*y);
  if r=0 then r:=0.0000001;
  if x<>0 then fi:=arctan2(y,x) else fi:=100000;
  x:=r*cos(fi+r);
  y:=r*sin(fi+r);
end;

Procedure Horseshoe(var x,y:double);
   var r,fi:double;
begin
  r:=sqrt(x*x+y*y);
  if r=0 then r:=0.0000001;
  if x<>0 then fi:=arctan2(y,x) else fi:=100000;
  x:=r*cos(2*fi);
  y:=r*sin(2*fi);
end;

Procedure Polar(var x,y:double);
   var r,fi:double;
begin
  r:=sqrt(x*x+y*y);
  if r=0 then r:=0.0000001;
  if x<>0 then fi:=arctan2(y,x) else fi:=100000;
  x:=fi/pi;
  y:=r-1;
end;

Procedure Handkerchief(var x,y:double);
   var r,fi:double;
begin
  r:=sqrt(x*x+y*y);
  if r=0 then r:=0.0000001;
  if x<>0 then fi:=arctan2(y,x) else fi:=100000;
  x:=r*sin(fi+r);
  y:=r*cos(fi-r);
end;

Procedure Heart(var x,y:double);
   var r,fi:double;
begin
  r:=sqrt(x*x+y*y);
  if r=0 then r:=0.0000001;
  if x<>0 then fi:=arctan2(y,x) else fi:=100000;
  x:=r*sin(fi*r);
  y:=r*cos(fi*r);
end;

Procedure Disc(var x,y:double);
   var r,fi:double;
begin
  r:=sqrt(x*x+y*y);
  if r=0 then r:=0.0000001;
  if x<>0 then fi:=arctan2(y,x) else fi:=100000;
  x:=fi*sin(pi*r)/pi;
  y:=fi*cos(pi*r)/pi;
end;

Procedure Spiral(var x,y:double);
   var r,fi:double;
begin
  r:=sqrt(x*x+y*y);
  if r=0 then r:=0.0000001;
  if x<>0 then fi:=arctan2(y,x) else fi:=100000;
  x:=(cos(fi)+sin(r))/r;
  y:=(sin(fi)-cos(r))/r;
end;

Procedure Hiperbolic(var x,y:double);
   var r,fi:double;
begin
  r:=sqrt(x*x+y*y);
  if r=0 then r:=0.0000001;
  if x<>0 then fi:=arctan2(y,x) else fi:=100000;
  x:=sin(fi)/r;
  y:=cos(fi)*r;
end;

Procedure Diamond(var x,y:double);
   var r,fi:double;
begin
  r:=sqrt(x*x+y*y);
  if r=0 then r:=0.0000001;
  if x<>0 then fi:=arctan2(y,x) else fi:=100000;
  x:=sin(fi)*cos(r);
  y:=cos(fi)*sin(r);
end;

Procedure Ex(var x,y:double);
   var r,fi:double;
begin
  r:=sqrt(x*x+y*y);
  if r=0 then r:=0.0000001;
  if x<>0 then fi:=arctan2(y,x) else fi:=100000;
  x:=r*power(sin(fi+r),3);
  y:=r*power(cos(fi-r),3);
end;

Procedure Julia(var x,y:double);
   var r,fi,om:double;
begin
  r:=sqrt(x*x+y*y);
  if r=0 then r:=0.0000001;
  if x<>0 then fi:=arctan2(y,x) else fi:=100000;
  om:=trunc(random(2))*pi;
  x:=sqrt(r)*cos(fi/2+om);
  y:=sqrt(r)*sin(fi/2+om);
end;

Procedure Weave(var x,y:double);
   var r,fi,om:double;
begin
  r:=sqrt(x*x+y*y);
  if r=0 then r:=0.0000001;
  if x<>0 then fi:=arctan2(y,x) else fi:=100000;
  om:=sin((fi)/r);
  x:=r*sign(om)*sqr(om);
  om:=cos((fi)/r);
  y:=r*sign(om)*sqr(om);
end;

Procedure sandGlass(var x,y:double);
   var r:double;
begin
  r:=sqrt(x*x+y*y);
  if r=0 then r:=0.0000001;
  x:=sin(x)/r;
  y:=cos(x)/r;
end;

Procedure Television(var x,y:double);
   var r:double;
begin
  r:=sqrt(x*x+y*y);
  if r=0 then r:=0.0000001;
  x:=sin(x)/sqrt(r);
  y:=sin(y)/sqrt(r);
end;

Procedure Floverbox(var x,y:double);
   var r:double;
begin
  r:=sqrt(x*x+y*y);
  if r=0 then r:=0.0000001;
  x:=sin(x)/r;
  y:=cos(y)/r;
end;

Procedure Scape(var x,y:double);
   var r,fi:double;
begin
  r:=sqrt(x*x+y*y);
  if r=0 then r:=0.0000001;
  if x<>0 then fi:=arctan2(y,x) else fi:=100000;
  y:=(r/pi-fi)/4;
  x:=(fi*(1-r))/2;
end;

Procedure HyperCircle(var x,y:double);
   var r,fi:double;
begin
  r:=sqrt(x*x+y*y);
  if r=0 then r:=0.0000001;
  if x<>0 then fi:=arctan2(y,x) else fi:=100000;
  if x<>0 then x:=sin(r*pi*fi)*arctan(pi+fi)/1.5;
  if y<>0 then y:=cos(r*pi*fi)*tan(pi-fi)/1.5;
end;

Procedure Weaves(var x,y:double);
begin
   x:=x+sin(y*10)/10;
   y:=y+sin(x*10)/10;
end;

Procedure Grass(var x,y:double);
begin
   if (x<>0) and (y<>0) then begin
      x:=(ln(sqrt(abs(x))+sqrt(abs(y)))*sin(x));
      y:=(ln(sqrt(abs(x))+sqrt(abs(y)))*cos(x));
   end;
end;

Procedure Tube(var x,y:double);
   var om:double;
begin
   om:=x;
   if y<>0 then begin
      x:=(1/y)*cos(om);
      y:=(1/y)*sin(om);
   end;
end;

Procedure Sphere(var x,y:double);
   var om:double;
begin
   om:=x*pi;
   x:=cos(om)*cos(y*pi);
   y:=sin(om)*cos(y*pi);
end;

Procedure Geo(var x,y:double);
   var om:double;
begin
   om:=x*pi;
   x:=cos(om)*cos(y*pi);
   y:=sin(y*pi);
end;

Procedure Gravity(var x,y:double);
   var r,om:double;
begin
   r:=sqrt(x*x+y*y);
   if r=0 then r:=0.0000001;
   if (x<>1) and (y<>1) then begin
      om:=x;
      x:=2*(1-r)/(y-1)+1;
      y:=2*(1-r)/(om-1)+1;
   end;
end;

Procedure Snail(var x,y:double);
   var om:double;
begin
   om:=sqrt(abs(2*(x/2-trunc(x/2))));
   x:=0.5*(sqr(om)-1)+om*(om*sin(20*om)+cos(pi*y))/2;
   y:=1-2*sqr(om)*(1-sin(pi*y)/2);
end;

Procedure Spirals(var x,y:double);
   var om:double;
begin
   om:=sqrt(abs(2*(x/2-trunc(x/2))));
   x:=om*cos(6*pi*om)*(1+sin(pi*y))/2;
   y:=om*sin(6*pi*om)*(1+sin(pi*y))/2;
end;

end.
