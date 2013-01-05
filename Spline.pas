unit Spline;

interface

uses Math;

type TPoint = record
   X : double;
   Y : double;
end;

type T3DPoint = record
   X : double;
   Y : double;
   Z : double;
end;

type TCubicSpline = array[0..3] of TPoint;

type TPointArray = array of TPoint;
type TRunvarArray = array of double;

type T3DPointGrid = array of array of T3DPoint;

function point(X,Y : double):TPoint;
function CubicSpline(p0,p1,p2,p3 : TPoint):TCubicSpline;

function BSpline(P0,P1,P2 : TPoint; u : double):TPoint;overload;
function BSpline(p : TCubicSpline; u : double):TPoint;overload;
function BSpline(P : array of TPoint; u : double; k : integer):TPoint;overload;
function BSpline(P : T3DPointGrid;u,v:double; k,l : integer) : T3DPoint;overload;
procedure rasterizeBSpline(bSpline : TCubicSpline;var points : TPointArray;uniformSpacing:double);overload;
procedure rasterizeBSpline(bSpline : TCubicSpline;var points : TPointArray;nonUniformSpacing:integer);overload;

function Bezier(P0,P1:TPoint;u:double):TPoint;overload;
function Bezier(P0,P1,P2:TPoint;u:double):TPoint;overload;
function Bezier(P : TCubicSpline;u:double):TPoint;overload;
function Bezier(P : T3DPointGrid;u,v:double) : T3DPoint;overload;

function BeziersTangent(bezier : TCubicSpline;u:double):TPoint;
function BeziersRadius(bezier : TCubicSpline;u:double):TPoint;
procedure deCasteljau(b : TCubicSpline;var b1,b2 : TCubicSpline; u : double);
procedure assignBezier(base : TCubicSpline; var new : TCubicSpline; l:double);overload;
procedure assignBezier(base : TCubicSpline; var new : TCubicSpline; l,n:double);overload;
function assignBezier(base : TCubicSpline; p : TPoint;l,n : double):TCubicSpline;overload;
procedure assignBezier(base : T3DPointGrid; var new : T3DPointGrid; l:double; orient{0..3} : integer);overload;
procedure rasterizeBezier(bezier : TCubicSpline;var points : TPointArray;uniformSpacing:double);overload;
procedure rasterizeBezier(bezier : TCubicSpline;var points : TPointArray;nonUniformSpacing:integer);overload;
procedure rasterizeBezier(bezier : TCubicSpline;var points : TPointArray;
          var us : TRunvararray;nul,one : double;uniformSpacing:integer);overload;
function bezierToHermite(bezier : TCubicSpline):TCubicSpline;
function hermiteToBezier(hermite : TCubicSpline):TCubicSpline;
function lengthPolyline(bezier : TCubicSpline):double;

function Fergusson(P0,P1,P0d,P1d : TPoint;u:double):TPoint;
function Hermite(x,f,fd:array of double;xs : double):double;overload;
//function Hermite(x,y,f,fd:array of array of double;xs : double):double;overload;

implementation

function point(X,Y : double):TPoint;
begin
   result.X := X;
   result.Y := Y;
end;

function CubicSpline(p0,p1,p2,p3 : TPoint):TCubicSpline;
begin
   result[0] := p0;
   result[1] := p1;
   result[2] := p2;
   result[3] := p3;
end;

function BSpline(P0,P1,P2 : TPoint; u : double):TPoint;
   var a1,a2,a3 : double;
begin
   a1 := u*u-2*u+1;
   a2 := -2*u*u+2*u+1;
   a3 := u*u;
   result.X := 0.5*(a1*P0.X + a2*P1.X + a3*P2.X);
   result.Y := 0.5*(a1*P0.Y + a2*P1.Y + a3*P2.Y);
end;

// 0 <= U <= 1
function BSpline(P : TCubicSpline; u : double):TPoint;
   var a1,a2,a3,a4 : double;
begin
   a1 := - 1*u*u*u + 3*u*u - 3*u +1;
   a2 :=   3*u*u*u - 6*u*u +     +4;
   a3 := - 3*u*u*u + 3*u*u + 3*u +1;
   a4 :=   1*u*u*u;
   result.X := (1/6)*(a1*P[0].X + a2*P[1].X + a3*P[2].X + a4*P[3].X);
   result.Y := (1/6)*(a1*P[0].Y + a2*P[1].Y + a3*P[2].Y + a4*P[3].Y);
end;

// B-Spline interpolacio
// k - fokszam, u - futovaltozo (0-n), p - pontok, k - gorbe fokszama
function BSpline(p : array of TPoint; u : double; k : integer):TPoint;
   var i,n : integer;

   function t(i:integer):integer;
   begin
      if i < k+1 then result := 0;
      if (k+1 <= i) and (i <= n) then result := i - k;
      if i > n then result:= n - k + 1;
   end;

   function Nik(i,l:integer;u:double):double;
      var v1,v2 : double;
   begin
      v1 := t(i+l)-t(i);
      if v1 <> 0 then v1 := (u-t(i)) / v1;
      v2 := (t(i+l+1)-t(i+1));
      if v2 <> 0 then v2 := (t(i+l+1)-u) / v2;
      result := v1 * Nik(i,l-1,u) + v2 * Nik(i+1,l-1,u);
   end;

begin
   n := high(p)-low(p);
   result.X := 0;
   result.Y := 0;
   // betenni !!!!!!!!!!!!!!!!!
   // 0 <= i <= n+k+1
   // 0 <= u <= n-k+1
   for i := 0 to high(p)-low(p) do begin
      result.X := result.X + Nik(i,k,u)*p[i+low(p)].X;
      result.Y := result.Y + Nik(i,k,u)*p[i+low(p)].Y;
   end;
end;

function BSpline(P : T3DPointGrid;u,v:double; k,l : integer) : T3DPoint;overload;
   var i,j,m,n,base,nbase,kbase : integer;
       Niku,Njlv : double;

   function t(i:integer):integer;
   begin
      if i < kbase+1 then result := 0;
      if (kbase+1 <= i) and (i <= nbase) then result := i - kbase;
      if i > nbase then result:= nbase - kbase + 1;
   end;

   function Nik(i,l:integer;u:double):double;
      var v1,v2 : double;
   begin
      v1 := t(i+l)-t(i);
      if v1 <> 0 then v1 := (u-t(i)) / v1;
      v2 := (t(i+l+1)-t(i+1));
      if v2 <> 0 then v2 := (t(i+l+1)-u) / v2;
      result := v1 * Nik(i,l-1,u) + v2 * Nik(i+1,l-1,u);
   end;

begin
   m := high(p)-low(p);
   n := high(p[low(p)])-low(p[low(p)]);
   result.X := 0;
   result.Y := 0;
   result.Z := 0;
   // betenni !!!!!!!!!!!!!!!!!
   // 0 <= u <= m-k+1
   // 0 <= v <= n-l+1
   for i := low(p) to high(p) do begin
      for j := low(p[i]) to high(p[i]) do begin
         nbase := m;
         kbase := k;
         Niku := Nik(i-low(p),k,u);
         nbase := n;
         kbase := l;
         Njlv := Nik(j-low(p[i]),l,v);
         result.X := result.X + Njlv*Niku*p[i,j].X;
         result.Y := result.Y + Njlv*Niku*p[i,j].Y;
         result.Z := result.Z + Njlv*Niku*p[i,j].Z;
      end;
   end;
end;

function Bezier(P0,P1:TPoint;u:double):TPoint;
begin
   result.X := (1 - u) * P0.X + u * P1.X;
   result.Y := (1 - u) * P0.Y + u * P1.Y;
end;

function Bezier(P0,P1,P2:TPoint;u:double):TPoint;
begin
   result.X := sqr(1-u) * P0.X + 2 * (1-u) * u * P1.X + sqr(u) * P2.X;
   result.Y := sqr(1-u) * P0.Y + 2 * (1-u) * u * P1.Y + sqr(u) * P2.Y;
end;

function Bezier(P : TCubicSpline;u:double):TPoint;
   function sqr3(x : double):double;
   begin
      result := x*x*x;
   end;
begin
   result.X := sqr3(1-u)*P[0].X + 3*sqr(1-u)*u*P[1].X + 3*(1-u)*sqr(u)*p[2].X + sqr3(u)*P[3].X;
   result.Y := sqr3(1-u)*P[0].Y + 3*sqr(1-u)*u*P[1].Y + 3*(1-u)*sqr(u)*p[2].Y + sqr3(u)*P[3].Y;
end;

//derivate of Bezier
function BeziersTangent(bezier : TCubicSpline;u:double):TPoint;
begin
   result.X := - 3*sqr(1-u)*bezier[0].X + 3*sqr(1-u)*bezier[1].X
               - 6*(1-u)*u*bezier[1].X + 6*(1-u)*u*bezier[2].X
               - 3*u*u*bezier[2].X + 3*u*u*bezier[3].X;
   result.Y := - 3*sqr(1-u)*bezier[0].Y + 3*sqr(1-u)*bezier[1].Y
               - 6*(1-u)*u*bezier[1].Y + 6*(1-u)*u*bezier[2].Y
               - 3*u*u*bezier[2].Y + 3*u*u*bezier[3].Y;
end;

//second derivate of bezier
function BeziersRadius(bezier : TCubicSpline;u:double):TPoint;
begin
   result.X := 6*(1-u)*bezier[0].X + 6*u*bezier[3].X
               + (-6*(1-u)+6*u-6*(1-u))*bezier[1].X
               + (-6*u+6*(1-u)-6*u)*bezier[2].X;
   result.Y := 6*(1-u)*bezier[0].Y + 6*u*bezier[3].Y
               + (-6*(1-u)+6*u-6*(1-u))*bezier[1].Y
               + (-6*u+6*(1-u)-6*u)*bezier[2].Y;
end;

// cut a bezier to 2 bezier in point in u
procedure deCasteljau(b : TCubicSpline;var b1,b2 : TCubicSpline; u : double);
   var i,j,n:integer;
       p : array[0..3,0..3] of TPoint;
begin
   n := 3;
   for i := 0 to 3 do P[0,i] := b[i];
   for j := 1 to n do
      for i := 0 to n-j do begin
         P[j,i].X := (1-u)*P[j-1,i].X + u*P[j-1,i+1].X;
         P[j,i].Y := (1-u)*P[j-1,i].Y + u*P[j-1,i+1].Y;
      end;
   b1[0] := P[0,0];
   b1[1] := P[1,0];
   b1[2] := P[2,0];
   b1[3] := P[3,0];
   b2[0] := P[3,0];
   b2[1] := P[2,1];
   b2[2] := P[1,2];
   b2[3] := P[0,3];
end;

function Bezier(P : T3DPointGrid;u,v:double) : T3DPoint;
   var u1,u2,u3,u4,v1,v2,v3,v4 : double;
begin
   u1 := (1-u)*(1-u)*(1-u);
   u2 := 3*u*(1-u)*(1-u);
   u3 := 3*u*u*(1-u);
   u4 := u*u*u;
   v1 := (1-v)*(1-v)*(1-v);
   v2 := 3*v*(1-v)*(1-v);
   v3 := 3*v*v*(1-v);
   v4 := v*v*v;
   result.X := (u1*P[0,0].X + u2*P[1,0].X + u3*P[2,0].X + u4*P[3,0].X) * v1 +
               (u1*P[0,1].X + u2*P[1,1].X + u3*P[2,1].X + u4*P[3,1].X) * v2 +
               (u1*P[0,2].X + u2*P[1,2].X + u3*P[2,2].X + u4*P[3,2].X) * v3 +
               (u1*P[0,3].X + u2*P[1,3].X + u3*P[2,3].X + u4*P[3,3].X) * v4;
   result.Y := (u1*P[0,0].Y + u2*P[1,0].Y + u3*P[2,0].Y + u4*P[3,0].Y) * v1 +
               (u1*P[0,1].Y + u2*P[1,1].Y + u3*P[2,1].Y + u4*P[3,1].Y) * v2 +
               (u1*P[0,2].Y + u2*P[1,2].Y + u3*P[2,2].Y + u4*P[3,2].Y) * v3 +
               (u1*P[0,3].Y + u2*P[1,3].Y + u3*P[2,3].Y + u4*P[3,3].Y) * v4;
   result.Z := (u1*P[0,0].Z + u2*P[1,0].Z + u3*P[2,0].Z + u4*P[3,0].Z) * v1 +
               (u1*P[0,1].Z + u2*P[1,1].Z + u3*P[2,1].Z + u4*P[3,1].Z) * v2 +
               (u1*P[0,2].Z + u2*P[1,2].Z + u3*P[2,2].Z + u4*P[3,2].Z) * v3 +
               (u1*P[0,3].Z + u2*P[1,3].Z + u3*P[2,3].Z + u4*P[3,3].Z) * v4;
end;

procedure assignBezier(base : TCubicSpline; var new : TCubicSpline; l:double);
begin
   new[0].X := base[3].X;
   new[1].X := new[0].X + l * (base[3].X-base[2].X);
   new[0].Y := base[3].Y;
   new[1].Y := new[0].Y + l * (base[3].Y-base[2].Y);
end;

procedure assignBezier(base : TCubicSpline; var new : TCubicSpline; l,n:double);
begin
   new[0].X := base[3].X;
   new[1].X := new[0].X + l * (base[3].X-base[2].X);
   new[0].Y := base[3].Y;
   new[1].Y := new[0].Y + l * (base[3].Y-base[2].Y);
   new[2].X := l*l*base[1].X - (2*l*l+2*l+n/2)*base[2].X + (l*l+2*l+1+n/2)*base[3].X;
   new[2].Y := l*l*base[1].Y - (2*l*l+2*l+n/2)*base[2].Y + (l*l+2*l+1+n/2)*base[3].Y;
end;

function assignBezier(base : TCubicSpline; p : TPoint; l,n:double):TCubicSpline;
begin
   result[0].X := base[3].X;
   result[1].X := result[0].X + l * (base[3].X-base[2].X);
   result[0].Y := base[3].Y;
   result[1].Y := result[0].Y + l * (base[3].Y-base[2].Y);
   result[2].X := l*l*base[1].X - (2*l*l+2*l+n/2)*base[2].X + (l*l+2*l+1+n/2)*base[3].X;
   result[2].Y := l*l*base[1].Y - (2*l*l+2*l+n/2)*base[2].Y + (l*l+2*l+1+n/2)*base[3].Y;
   result[3].X := p.X;
   result[3].Y := p.Y;
end;

procedure assignBezier(base : T3DPointGrid; var new : T3DPointGrid; l:double; orient : integer);
   var i : integer;
       ii : array[0..3] of integer;
begin
   for i:= 0 to 3 do if orient < 2 then ii[i]:=i else ii[i]:=3-i;
   for i := 0 to 3 do begin
     if orient mod 2 = 0 then begin
     new[ii[0],i].X:=base[ii[3],i].X;
     new[ii[1],i].X:=new[ii[0],i].X+l*(base[ii[3],i].X-base[ii[2],i].X);
     new[ii[0],i].Y:=base[ii[3],i].Y;
     new[ii[1],i].Y:=new[ii[0],i].Y+l*(base[ii[3],i].Y-base[ii[2],i].Z);
     new[ii[0],i].Z:=base[ii[3],i].Z;
     new[ii[1],i].Z:=new[ii[0],i].Z+l*(base[ii[3],i].Z-base[ii[2],i].Z);
     end else begin
     new[i,ii[0]].X:=base[i,ii[3]].X;
     new[i,ii[1]].X:=new[i,ii[0]].X+l*(base[i,ii[3]].X-base[i,ii[2]].X);
     new[i,ii[0]].Y:=base[i,ii[3]].Y;
     new[i,ii[1]].Y:=new[i,ii[0]].Y+l*(base[i,ii[3]].Y-base[i,ii[2]].Y);
     new[i,ii[0]].Z:=base[i,ii[3]].Z;
     new[i,ii[1]].Z:=new[i,ii[0]].Z+l*(base[i,ii[3]].Z-base[i,ii[2]].Z);
     end;
   end;
end;

// Fergusson interpolation
// p0,p1 - talppontok, p0d,p1d - derivaltak a talppontban
function Fergusson(P0,P1,P0d,P1d : TPoint;u:double):TPoint;
   var F1u,F2u,F3u,F4u : double;
begin
   F1u := (1-u)*(1-u)*(1+2*u);
   F2u := u*u*(3-2*u);
   F3u := (1-u)*(1-u)*u;
   F4u := -u*u*(1-u);
   result.X := F1u * P0.X + F2u * P1.X + F3u * P0d.X + F4u * P1d.X;
   result.Y := F1u * P0.Y + F2u * P1.Y + F3u * P0d.Y + F4u * P1d.Y;
end;

// hermite interpolaccio
// x - x ertekek, f - f(x) fuggv ertekek, fd - f`(x) derivaltak, xs - futovaltozo
function Hermite(x,f,fd:array of double;xs : double):double;
   var i:integer;
   hi,t,Ki,Li :double;
begin
   if (xs<x[low(x)]) or (xs>x[high(x)]) then begin
      result := Math.nan;
      exit;
   end;
   for i := low(x) to high(x) do begin
      if (xs = x[i]) then begin
         result := x[i];
         exit;
      end;
      if (i<>high(x)) and (xs > x[i]) and (xs < x[i+1]) then break;
   end;
   hi := x[i+1]-x[i];
   t := (xs-x[i])/hi;
   Ki := -2*(f[i+1]-f[i])/hi;
   Li := -Ki+(f[i+1]-f[i])/hi-fd[i];
   result := f[i]+(xs-x[i])*(fd[i]+t*(Li+t*Ki));
end;

function lengthPolyline(bezier : TCubicSpline):double;
begin
   result := sqrt(sqr(bezier[1].X-bezier[0].X) + sqr(bezier[1].Y-bezier[0].Y));
   result := result + sqrt(sqr(bezier[2].X-bezier[1].X) + sqr(bezier[2].Y-bezier[1].Y));
   result := result + sqrt(sqr(bezier[3].X-bezier[2].X) + sqr(bezier[3].Y-bezier[2].Y));
end;

function bezierToHermite(bezier : TCubicSpline):TCubicSpline;
begin
   result[0].X := bezier[0].X;
   result[1].X := bezier[3].X;
   result[2].X := - 3*bezier[0].X + 3*bezier[1].X;
   result[3].X := - 3*bezier[2].X + 3*bezier[3].X;
   result[0].Y := bezier[0].Y;
   result[1].Y := bezier[3].Y;
   result[2].Y := - 3*bezier[0].Y + 3*bezier[1].Y;
   result[3].Y := - 3*bezier[2].Y + 3*bezier[3].Y;
end;

function hermiteToBezier(hermite : TCubicSpline):TCubicSpline;
begin
   result[0].X := hermite[0].X;
   result[1].X := hermite[0].X + hermite[2].X/3;
   result[2].X := hermite[1].X - hermite[3].X/3;
   result[3].X := hermite[1].X;
   result[0].Y := hermite[0].Y;
   result[1].Y := hermite[0].Y + hermite[2].Y/3;
   result[2].Y := hermite[1].Y - hermite[3].Y/3;
   result[3].Y := hermite[1].Y;
end;

procedure rasterizeBezier(bezier : TCubicSpline;var points : TPointArray;nonUniformSpacing:integer);
   var p : TPoint;
       i,l : integer;
       u : double;
begin
   l := round(lengthPolyline(bezier)/nonUniformSpacing);
   setlength(points,l+1);
   for i := 0 to l do begin
       u := i/l;
       p := spline.bezier(bezier,u);
       points[i].X:=p.X;
       points[i].Y:=p.Y;
   end;
end;

procedure rasterizeBezier(bezier : TCubicSpline;var points : TPointArray;uniformSpacing:double);
   var b1,b2 : TCubicSpline;
begin
   if lengthPolyline(bezier) <= uniformSpacing then begin
       setlength(points,length(points)+1);
       points[high(points)].X:=round(bezier[0].X);
       points[high(points)].Y:=round(bezier[0].Y);
   end else begin
       deCasteljau(bezier,b1,b2,0.5);
       rasterizeBezier(b1,points,uniformSpacing);
       rasterizeBezier(b2,points,uniformSpacing);
   end;
end;

procedure rasterizeBezier(bezier : TCubicSpline;var points : TPointArray;
          var us : TRunvarArray;nul,one : double;uniformSpacing:integer);
   var b1,b2 : TCubicSpline;
begin
   if lengthPolyline(bezier) <= uniformSpacing then begin
       setlength(points,length(points)+1);
       setlength(us,length(us)+1);
       points[high(points)].X:=round(bezier[0].X);
       points[high(points)].Y:=round(bezier[0].Y);
       us[high(points)]:=nul;
   end else begin
       deCasteljau(bezier,b1,b2,0.5);
       rasterizeBezier(b1,points,us,nul,nul+0.5*(one-nul),uniformSpacing);
       rasterizeBezier(b2,points,us,nul+0.5*(one-nul),one,uniformSpacing);
   end;
end;

procedure rasterizeBSpline(bSpline : TCubicSpline;var points : TPointArray;uniformSpacing:double);
   var b1,b2 : TCubicSpline;
begin
 {  if lengthPolyline(bSpline) <= uniformSpacing then begin
       setlength(points,length(points)+1);
       points[high(points)].X:=round(bSpline[0].X);
       points[high(points)].Y:=round(bSpline[0].Y);
   end else begin
//     cutBSpline(bSpline,b1,b2,0.5);
       rasterizeBezier(b1,points,uniformSpacing);
       rasterizeBezier(b2,points,uniformSpacing);
   end;  }
end;

procedure rasterizeBSpline(bSpline : TCubicSpline;var points : TPointArray;nonUniformSpacing:integer);
   var p : TPoint;
       i,l : integer;
       u : double;
begin
   l := round(lengthPolyline(BSpline)/nonUniformSpacing);
   setlength(points,l+1);
   for i := 0 to l do begin
       u := i/l;
       p := spline.BSpline(BSpline,u);
       points[i].X:=p.X;
       points[i].Y:=p.Y;
   end;
end;

end.
