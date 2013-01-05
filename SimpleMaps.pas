unit SimpleMaps;

{$MODE Delphi}

{/**
 * class of Static Analitic texture
 * statikus analitikus textura osztaly
 * @author Shaman
 * @version 1.2, 3/05/2008
 * @since   Effectbank 0.8.0
 */}
interface

uses Map,math,rasterMap,BaseTypes,ProgressControll,Propertyes, Progress;

var LensFlareBaseParams : array[0..63] of string =
 ('548',          '', 'double', 'slider', '30',  '30',  '5',    '500',
'592',          '', 'double', 'slider', '100',  '100',  '5',    '500',
'528',          '', 'double', 'slider', '90',  '90',  '10',    '200',
'517',          '', 'double', 'slider', '1',  '1',  '1',    '50',
'593',          '', 'double', 'slider', '0,02',  '0,02',  '0',    '1',
'423',          '', 'double', 'slider', '10',  '10',  '1',    '100',
'565',          '', 'double', 'slider', '200',  '200',  '0',    '200',
'13',          '', 'double', 'slider', '0,1',  '0,1',  '0',    '6');
var StaticParams : array[0..7] of string =
 ('13',          '', 'integer', 'slider', '128',  '128',  '0',    '255');
var Sine1DParams : array[0..31] of string =
 ('567',          '', 'integer', 'slider', '10',  '10',  '1',    '200',
 '95',          '', 'boolean', 'checkbox', '-1',  '-1',  '0',    '-1',
 '96',          '', 'boolean', 'checkbox', '-1',  '-1',  '0',    '-1',
 '94',          '', 'boolean', 'checkbox', '-1',  '-1',  '0',    '-1');
var Sine2DParams : array[0..39] of string =
 ('568',          '', 'integer', 'slider', '10',  '10',  '1',    '200',
 '569',          '', 'integer', 'slider', '10',  '10',  '1',    '200',
 '95',          '', 'boolean', 'checkbox', '-1',  '-1',  '0',    '-1',
 '96',          '', 'boolean', 'checkbox', '-1',  '-1',  '0',    '-1',
 '94',          '', 'boolean', 'checkbox', '-1',  '-1',  '0',    '-1');
var sineWeaveParams : array[0..39] of string =
 ('567',          '', 'integer', 'slider', '30',  '30',  '15',    '250',
 '541',          '', 'integer', 'slider', '10',  '10',  '5',    '95',
 '95',          '', 'boolean', 'checkbox', '-1',  '-1',  '0',    '-1',
 '96',          '', 'boolean', 'checkbox', '-1',  '-1',  '0',    '-1',
 '94',          '', 'boolean', 'checkbox', '-1',  '-1',  '0',    '-1');
var WeaveParams : array[0..55] of string =
 ('568',          '', 'integer', 'slider', '60',  '60',  '15',    '250',
 '569',          '', 'integer', 'slider', '60',  '60',  '15',    '250',
 '570',          '', 'integer', 'slider', '25',  '25',  '5',    '95',
 '571',          '', 'integer', 'slider', '5',  '5',  '5',    '95',
 '95',          '', 'boolean', 'checkbox', '-1',  '-1',  '0',    '-1',
 '96',          '', 'boolean', 'checkbox', '-1',  '-1',  '0',    '-1',
 '94',          '', 'boolean', 'checkbox', '-1',  '-1',  '0',    '-1');
 var Sines1DParams : array[0..55] of string =
 ('572',          '', 'integer', 'slider', '3',  '3',  '3',    '50',
 '573',          '', 'integer', 'slider', '15',  '15',  '10',    '250',
 '521',          '', 'integer', 'slider', '1',  '1',  '1',    '10',
 '518',          '', 'integer', 'slider', '2',  '2',  '2',    '20',
  '95',          '', 'boolean', 'checkbox', '-1',  '-1',  '0',    '-1',
 '96',          '', 'boolean', 'checkbox', '-1',  '-1',  '0',    '-1',
 '94',          '', 'boolean', 'checkbox', '-1',  '-1',  '0',    '-1');
  var GridderParams : array[0..15] of string =
 ('572',          '', 'integer', 'slider', '3',  '3',  '3',    '50',
 '573',          '', 'integer', 'slider', '15',  '15',  '10',    '250');
// function SimpleGroup:TContainerProperty;

procedure black(var pic : TMap);
procedure Static(var pic : TMap;color :byte);overLoad;

procedure Sines1D(var pic:TMap;WLMin,WLMax,ampVar:double;num : integer);
procedure Weave(var pic : TMap;Xsize,Ysize,WidHor,WidVer:integer);
procedure Piramids(var pic : TMap; sizex:integer;fold:boolean);
procedure LensFlareBase(var pic : TMap;R,R2,rComa,dComa,aComa,dRay,lengthRay,intRay:double);
procedure Hexagon(var pic : TMap; y,mode:integer);
procedure piramid(var pic : TMap; x,y:integer);
procedure sineWeave(pic : TMap; wavelength, width:integer);
function Static(size : TMap;p: TProperty; pc : TProgressControll): TMap;overLoad;
procedure Static(result, size : TMap;p: TProperty; pc : TProgressControll);overLoad;

procedure GradVer(var pic : TMap;c1,c2:integer);
procedure GradHor(var pic : TMap;c1,c2:integer);
procedure Sawtooth1D(var pic : TMap; waveLength:double);
procedure Sine1D(var pic : TMap; waveLength:double);
procedure SinePolar(var pic : TMap;waveLength,x,y:double);
procedure Grids(var pic : TMap; Length1,Length2:integer);
procedure AbsSine2D(pic : TMap; waveLengthX,waveLengthY:double);
procedure Sawtooth2D(var pic : TMap; waveLengthX,waveLengthY:double);
procedure SineSawtooth2D(var pic : TMap; waveLengthX,waveLengthY:double);
procedure Sine2D(pic : TMap;waveLengthX,waveLengthY:double);
procedure SineBrick(var pic : TMap;waveLengthX,waveLengthY:double);
procedure SineGrid(pic : TMap; waveLengthX,waveLengthY:double);
procedure SineDavid(pic : TMap; waveLengthX,waveLengthY:double);
procedure SineHexa(var pic : TMap;waveLengthX,waveLengthY:double);
procedure SineBear(var pic : TMap; waveLengthX,waveLengthY:double);
procedure RandomMap(var pic:TMap);

implementation

procedure black(var pic : TMap);
   var i,j:integer;
      xmin,ymin,xmax,ymax : integer;
      r : TPixelArray;
begin
   pic.getRect(xmin,xmax,ymin,ymax);
   for j := ymin to ymax do begin
      r := TRasterMap(pic).getLine(j);
      for i := xmin to xmax do begin
         r[i-xmin]:=0;
      end;
   end;
end;

procedure Static(var pic : TMap;color :byte);
   var i,j:integer;
      xmin,ymin,xmax,ymax : integer;
      r : TPixelArray;
begin
   pic.getRect(xmin,xmax,ymin,ymax);
   for j:=ymin to ymax do begin
      r:=TRasterMap(pic).getLine(j);
      for i:=xmin to xmax do begin
         r[i-xmin]:=color;
      end;
   end;
end;

procedure Static(result, size : TMap;p: TProperty; pc : TProgressControll);
   var i,j:integer;
       color:byte;
      xmin,ymin,xmax,ymax : integer;
      r : TPixelArray;
begin
   pc.start;
   color := p.get('Color').getValue;
  // color :=255;
   size.getRect(xmin,xmax,ymin,ymax);
   For j:=ymin to ymax do begin
      if not pc.isActual(trunc(100*(j-ymin)/(ymax-ymin))) then Exit;
      r:=TRasterMap(Result).getLine(j);
      For i:=xmin to xmax do begin
         r[i-xmin]:=color;
      end;
   end;
   pc.finish;
end;

function Static(size : TMap;p: TProperty; pc : TProgressControll): TMap;overLoad;
   var i,j:integer;
       color:byte;
      xmin,ymin,xmax,ymax : integer;
      r : TPixelArray;
begin
   pc.start;
   //color := p.get('Color').getValue;
   color :=255;
   size.getRect(xmin,xmax,ymin,ymax);
   result := TRasterMap.create(size);
   For j:=ymin to ymax do begin
      if not pc.isActual(trunc(100*(j-ymin)/(ymax-ymin))) then Exit;
      r:=TRasterMap(Result).getLine(j);
      For i:=xmin to xmax do begin
         r[i-xmin]:=color;
      end;
   end;
   pc.finish;
end;


procedure Sines1D(var pic:TMap;WLMin,WLMax,ampVar:double;num : integer);
   var n,i,j,w,h:integer;
       minWL,maxWL,minA,maxA,sum,z,x:double;
       A,WL,Offset,Ang:array of double;
       //WLMin,WLMax,ampVar:double;
       //num : integer;
       xmin,xmax,ymin,ymax : integer;
       r : TPixelArray;
begin
 //  result := TRasterMap.create(Size);
   pic.getRect(xmin,xmax,ymin,ymax);
// Init
   Randomize;
   setLength(A,num);
   setLength(WL,num);
   setLength(Offset,num);
   setLength(Ang,num);
   minA:=infinity;
   maxA:=0;
   minWL:=infinity;
   maxWL:=0;
   sum:=0;
   for n:=0 to num-1 do begin
      A[n]:=Random;
      WL[n]:=Random;
      Ang[n]:=pi*Random;
      if A[n]>maxA then maxA:=A[n];
      if A[n]<minA then minA:=A[n];
      if WL[n]>maxWL then maxWL:=WL[n];
      if WL[n]<minWL then minWL:=WL[n];
   end;
   for n:=0 to num-1 do begin
      A[n]:=1+ampVar*(A[n]-minA)/(maxA-minA);
      WL[n]:=WLMin+(WLMax-WLMin)*(WL[n]-minWL)/(maxWL-minWL);
      Offset[n]:=WL[n]*random;
      sum:=sum+A[n];
   end;
   for n:=0 to num-1 do A[n]:=A[n]/sum;
// Calculation
   For j:=ymin to ymax do begin
      if actprogress(trunc(100*(j-ymin)/(ymax-ymin))) then begin
         setLength(A,0);
         setLength(WL,0);
         setLength(Offset,0);
         setLength(Ang,0);
         exit;
      end;
      r:=TRasterMap(pic).getLine(j);
      for i:=xmin to xmax do begin
         z:=0;
         for n:=0 to num-1 do begin
            x:=sin(ang[n])*i-cos(ang[n])*j;
            x:=offset[n]+x/WL[n];
            z:=z+A[n]*sin(x);
         end;
         r[i-xmin]:=trunc((z/2+0.5)*255);
      end;
   end;
// finalize
   setLength(A,0);
   setLength(WL,0);
   setLength(Offset,0);
   setLength(Ang,0);
end;

procedure Weave(var pic : TMap;Xsize,Ysize,WidHor,WidVer:integer);
   var w,h,i,j:integer;
     x,y,cVer2,cHor2,cVer,cHor,c:double;
      xmin,ymin,xmax,ymax : integer;
      r : TPixelArray;
begin
   pic.getRect(xmin,xmax,ymin,ymax);
   w:=pic.MWidth;
   h:=pic.MHeight;
   for j:=ymin to ymax do begin
      if actprogress(trunc(100*(j-ymin)/(ymax-ymin))) then Exit;
      r:=TRasterMap(pic).getLine(j);
      for i:=xmin to xmax do begin
         x:=i mod Xsize;
         y:=j mod Ysize;
         cVer:=0;
         if abs(x-xsize/4)<=widVer/2 then
            cver:=sqrt(sqr(widver/2)-sqr(x-xsize/4))/(widver/2);
         if abs(x-3*xsize/4)<=widVer/2 then
            cver:=sqrt(sqr(widver/2)-sqr(x-3*xsize/4))/(widver/2);
         cHor:=0;
         if abs(y-ysize/4)<=widHor/2 then
            cHor:=sqrt(sqr(widHor/2)-sqr(y-ysize/4))/(widHor/2);
         if abs(y-3*ysize/4)<=widHor/2 then
            cHor:=sqrt(sqr(widHor/2)-sqr(y-3*ysize/4))/(widHor/2);
         if cHor>0 then cHor:=cHor*63+128+64*sin(2*pi*x/Xsize)*(-sign(y-ysize/2));
         if cVer>0 then cVer:=cVer*63+128+64*sin(2*pi*y/Ysize)*sign(x-xsize/2);
         c:=max(cVer,cHor);
         r[i-xmin]:=trunc(c);
      end;
   end;
end;

procedure Piramids(var pic : TMap; sizex:integer;fold:boolean);
   var w,h,i,j,c:integer;
     x,y,d:double;
      xmin,ymin,xmax,ymax : integer;
      r : TPixelArray;
begin
   pic.getRect(xmin,xmax,ymin,ymax);
   w:=pic.MWidth;
   h:=pic.MHeight;
   for j:=ymin to ymax do begin
      if actprogress(trunc(100*(j-ymin)/(ymax-ymin))) then exit;
      r:=TRasterMap(pic).getLine(j);
      for i:=xmin to xmax do begin
         x:=i mod sizex;
         y:=j mod sizex;
         d:=abs(x-sizex/2)+abs(y-sizex/2);
         if d>sizex/2 then d:=sizex-d;
         d:=2*d/sizex;
         if fold then begin
            d:=2*d;
            if d>1 then d:=2-d;
         end;
         r[i-xmin]:=trunc(d*255);
      end;
   end;
end;

procedure LensFlareBase(var pic : TMap;R,R2,rComa,dComa,aComa,dRay,lengthRay,intRay:double);
   var i,j,xn:integer;
       x,y,c,c1,c12,c2,c3,c3Mul:double;
       rayInts,drayInts,dRays:array of double;
       dRayInt:double;
      xmin,ymin,xmax,ymax : integer;
      rpa : TPixelArray;
begin
   pic.getRect(xmin,xmax,ymin,ymax);
   randomize;
   drayInt:=0.1;
   setlength(rayInts,trunc(pic.MWidth/round(dray))+2);
   setlength(drayInts,trunc(pic.MWidth/round(dray))+2);
   setlength(drays,trunc(pic.MWidth/round(dray))+2);
   for i:=0 to high(rayInts) do rayInts[i]:=power(random,3)*sqr(((1+cos(i/high(rayInts)))/2))*intRay;
   for i:=0 to high(drayInts) do drayInts[i]:=(1+sqr(random))*dRayInt;
   for i:=0 to high(drayInts) do drays[i]:=2+random(8);
   for j:=ymin to ymax do begin
      if actprogress(trunc(100*(j-ymin)/(ymax-ymin))) then Exit;
      rpa:=TRasterMap(pic).getLine(j);
      for i:=xmin to xmax do begin
        y:=pic.MHeight-1-j;
        x:=(i mod Round(dRay))*2*pi/Round(dRay);
        xn:=i div Round(dRay);
        if i>trunc(pic.mwidth/2) then
                xn:=(i-trunc(pic.mwidth/2)) div Round(dRay);
        c1:=(1+1*exp(-0.5*power(y/r,1.5)))/2;
        c12:=1*exp(-0.5*sqr(y/r2));
        c1:=c1*c12;
        c2:=aComa*exp(-0.5*sqr((y-rComa)/dComa));
        c3Mul:=(RayInts[xn]-dRayInt*(pic.MHeight-j)/pic.MHeight);
        if c3Mul<0 then c3mul:=0;
        c3:=c3mul*power((1-cos(x))/2,dRays[xn]);
        c:=exp(ln(1+c1)+ln(1+c2)+ln(1+c3))-1;
        c:=c1+c2+c3;
        rpa[i-xmin]:=min(max(trunc(c*255),0),255);
      end;
   end;
end;

procedure Hexagon(var pic : TMap; y,mode:integer);
   var w,h,i,j,c,dx,dy:integer;
     cx,cy,d,d1,d2,d3:double;
      xmin,ymin,xmax,ymax : integer;
      r : TPixelArray;
begin
    // mode: 0-sawtooth;1-sine;2-sinesawtooth
   pic.getRect(xmin,xmax,ymin,ymax);
   w:=pic.MWidth;
   h:=pic.MHeight;
   dy:=y;
   dx:=trunc(y*sqrt(3));
   for j:=ymin to ymax do begin
      if actprogress(trunc(100*(j-ymin)/(ymax-ymin))) then exit;
      r:=TRasterMap(pic).getLine(j);
      for i:=xmin to xmax do begin
        if  (6*(i mod dx)/dx+1-2*abs((j mod dy)-dy/2)/dy>1)
        and (6*(2*dx/3 - (i mod dx))/dx+1-2*abs((j mod dy)-dy/2)/dy>1)
        then begin
           d1:=1-(j mod dy)/dy;
           d2:=1+(((j mod dy)/dy-3*((i+trunc(dx/6)) mod dx)/dx))/2;
           d3:=1-(((j mod dy)/dy+3*((i mod dx)-dx/6)/dx))/2;
        end else if ((j mod dy)/dy>0.5) then begin
             d1:=1-((j+trunc(dy/2)) mod dy)/dy;
             d2:=1+(((j mod dy)/dy-3*((i+trunc(5*dx/6)) mod dx)/dx))/2;
             d3:=2-(((j mod dy)/dy+3*((i+trunc(5*dx/6)) mod dx)/dx))/2;
           end else begin
             d1:=1-((j+trunc(dy/2)) mod dy)/dy;
             d2:=1+(((j mod dy)/dy-3*((i+trunc(3*dx/6)) mod dx)/dx))/2;
             d3:=1-(((j mod dy)/dy+3*((i+trunc(3*dx/6)) mod dx)/dx))/2;
           end;
        case mode of
        1: begin
           d1:=sin(d1*pi);
           d2:=sin(d2*pi);
           d3:=sin(d3*pi);
        end;
        2: begin
           d1:=sin(d1*pi/2);
           d2:=sin(d2*pi/2);
           d3:=sin(d3*pi/2);
           d1:=sin(d1*pi/2);
           d2:=sin(d2*pi/2);
           d3:=sin(d3*pi/2);
        end;
        end;
        d:=(d1+d2+d3)/3;
        if (d<0) or (d>1) then d:=0;
        r[i-xmin]:=trunc(d*255);
      end;
   end;
end;

procedure piramid(var pic : TMap; x,y:integer);
   var w,h,i,j,c:integer;
     cx,cy,d:double;
      xmin,ymin,xmax,ymax : integer;
      r : TPixelArray;
begin
   pic.getRect(xmin,xmax,ymin,ymax);
   w:=pic.MWidth;
   h:=pic.MHeight;
   for j:=ymin to ymax do begin
      if actprogress(trunc(100*(j-ymin)/(ymax-ymin))) then exit;
      r:=TRasterMap(pic).getLine(j);
      for i:=xmin to xmax do begin
         d:=0;
         if i<x then cx:=i/x else cx:=1-(i-x)/(w-x);
         if j<y then cy:=j/y else cy:=1-(j-y)/(h-y);
         if (cx-cy+1<>0) then
         if cy>=cx then d:=cx/(cx-cy+1);
         if (cy-cx+1<>0) then
         if cy<=cx then d:=cy/(cy-cx+1);
         d:=1-(Cos(d*pi)+1)/2;
         r[i-xmin]:=trunc(d*255);
      end;
   end;
end;

procedure sineWeave(pic : TMap; wavelength, width:integer);
   var c,cx,cy,x,y:double;
       a,b,i,j,wx:integer;
      xmin,ymin,xmax,ymax : integer;
      r : TPixelArray;
begin
   pic.getRect(xmin,xmax,ymin,ymax);
   wx:=waveLength;
   a:=trunc(wx*(1-width/100));
   b:=trunc(wx*width/100);
   for j:=ymin to ymax do begin
      if actprogress(trunc(100*(j-ymin)/(ymax-ymin))) then exit;
      r:=TRasterMap(pic).getLine(j);
      for i:=xmin to xmax do begin
        c:=0;
        if ((i div wx)+(j div wx)) mod 2 =0 then begin
           cx:=((i mod wx)+a/2)/(b+2*a);
           cy:=(abs((j mod wx)-(a+b)/2)-b/2)/(b+2*a);
           cy:=abs(sin(cy*pi));
           cx:=abs(sin(cx*pi));
           if ((i mod wx>a/2) and (i mod wx<b+a/2)) and
              ((j mod wx<a/2) or (j mod wx>b+a/2))
              then c:=cy;
           if ((j mod wx>a/2) and (j mod wx<b+a/2))
              then c:=cx;
        end else begin
           cy:=((j mod wx)+a/2)/(b+2*a);
           cx:=(abs((i mod wx)-(a+b)/2)-b/2)/(b+2*a);
           cy:=abs(sin(cy*pi));
           cx:=abs(sin(cx*pi));
           if ((j mod wx>a/2) and (j mod wx<b+a/2)) and
              ((i mod wx<a/2) or (i mod wx>b+a/2))
              then c:=cx;
           if ((i mod wx>a/2) and (i mod wx<b+a/2))
              then c:=cy;
        end;
         r[i-xmin]:=trunc(c*255);
      end;
   end;
end;

procedure GradVer(var pic : TMap;c1,c2:integer);
   var i,j:integer;
      xmin,ymin,xmax,ymax : integer;
      r : TPixelArray;
begin
   pic.getRect(xmin,xmax,ymin,ymax);
   for j:=ymin to ymax do begin
      if actprogress(trunc(100*(j-ymin)/(ymax-ymin))) then exit;
      r:=TRasterMap(pic).getLine(j);
      for i:=xmin to xmax do begin
         r[i-xmin]:=c1+trunc((c2-c1)*j/pic.MHeight);
      end;
   end;
end;

procedure GradHor(var pic : TMap;c1,c2:integer);
   var i,j:integer;
      xmin,ymin,xmax,ymax : integer;
      r : TPixelArray;
begin
   pic.getRect(xmin,xmax,ymin,ymax);
   for j:=ymin to ymax do begin
      if actprogress(trunc(100*(j-ymin)/(ymax-ymin))) then exit;
      r:=TRasterMap(pic).getLine(j);
      for i:=xmin to xmax do begin
         r[i-xmin]:=c1+trunc((c2-c1)*i/pic.MWidth);
      end;
   end;
end;

procedure Sawtooth1D(var pic : TMap; waveLength:double);
   var c,x,y:double;
       i,j,wl:integer;
       xmin,ymin,xmax,ymax : integer;
      r : TPixelArray;
begin
   pic.getRect(xmin,xmax,ymin,ymax);
   // result := TRasterMap.create(size);
   wl:=trunc(waveLength);
   for j:=ymin to ymax do begin
      if actprogress(trunc(100*(j-ymin)/(ymax-ymin))) then exit;
      r:=TRasterMap(pic).getLine(j);
      c:=(j mod wl)/wl;
      c:=cos(c*pi/2);
      for i:=xmin to xmax do begin
         r[i-xmin]:=trunc(c*255);
      end;
   end;
end;

procedure Sine1D(var pic : TMap; waveLength:double);
   var c,x,y,wl:double;
       i,j:integer;
      xmin,ymin,xmax,ymax : integer;
      r : TPixelArray;
begin
   pic.getRect(xmin,xmax,ymin,ymax);
   //result := TRasterMap.create(size);
   wl := waveLength/(2*pi);
   for j := ymin to ymax do begin
      if actprogress(trunc(100*(j-ymin)/(ymax-ymin))) then exit;
      r:=TRasterMap(pic).getLine(j);
      y:=j/wl;
      c:=sin(y);
      c:=(1+c)/2;
      for i:=xmin to xmax do begin
         r[i-xmin]:=trunc(c*255);
      end;
   end;
end;

procedure SinePolar(var pic : TMap;waveLength,x,y:double);
   var c,r,wl:double;
       i,j:integer;
      xmin,ymin,xmax,ymax : integer;
      rpa : TPixelArray;
begin
   pic.getRect(xmin,xmax,ymin,ymax);
   wl:=waveLength/(2*pi);
   for j:=ymin to ymax do begin
      if actprogress(trunc(100*(j-ymin)/(ymax-ymin))) then Exit;
      rpa:=TRasterMap(pic).getLine(j);
      for i:=xmin to xmax do begin
         r:=sqrt(sqr(i-x)+sqr(j-y));
         r:=r/wl;
         c:=sin(r);
         c:=(1+c)/2;
         rpa[i-xmin]:=trunc(c*255);
      end;
   end;
end;

procedure Grids(var pic : TMap; Length1,Length2:integer);
  var i,j,n1,n2,n3:integer;
      w1,w2,m:double;
      xmin,ymin,xmax,ymax : integer;
      r : TPixelArray;
begin
   pic.getRect(xmin,xmax,ymin,ymax);
   randomize;
   for j:=ymin to ymax do begin
      if actprogress(trunc(100*(j-ymin)/(ymax-ymin))) then exit;
      r:=TRasterMap(pic).getLine(j);
      n3:=round( random(round(Length2/2)) - (Length2/4) );
      for i:=xmin to xmax do begin
         n1:=round(random(2)-1);
         n2:=round(random(2)-1);
         if (i mod Length1+n1 = 0) or (i mod Length2+n2+n3 = 0) or
            (j mod Length1+n1 = 0) or (j mod Length2+n2+n3 = 0) then
            m:=0 else m:=1;
         r[i-xmin]:=trunc(m*255);
      end;
   end;
end;

procedure AbsSine2D(pic : TMap; waveLengthX,waveLengthY:double);
   var c,x,y,wx,wy:double;
       i,j:integer;
       xmin,ymin,xmax,ymax : integer;
       r : TPixelArray;
begin
   pic.getRect(xmin,xmax,ymin,ymax);
   wX:=waveLengthX/(2*pi);
   wY:=waveLengthY/(2*pi);
   for j:=ymin to ymax do begin
      if actprogress(trunc(100*(j-ymin)/(ymax-ymin))) then exit;
      r:=TRasterMap(pic).getLine(j);
      y:=j/wY;
      y:=abs(sin(y));
      for i:=xmin to xmax do begin
         x:=i/wX;
         c:=abs(sin(x))+y;
         c:=c/2;
         r[i-xmin]:=trunc(c*255);
      end;
   end;
end;

procedure Sawtooth2D(var pic : TMap; waveLengthX,waveLengthY:double);
   var c,cx,cy,x,y:double;
       i,j,wx,wy:integer;
       xmin,ymin,xmax,ymax : integer;
       r : TPixelArray;
begin
   pic.getRect(xmin,xmax,ymin,ymax);
   wx:=trunc(waveLengthX);
   wy:=trunc(waveLengthY);
   for j:=ymin to ymax do begin
      if actprogress(trunc(100*(j-ymin)/(ymax-ymin))) then Exit;
      r:=TRasterMap(pic).getLine(j);
      cy:=(j mod wy)/wy;
      cy:=cos(cy*pi/2);
      for i:=xmin to xmax do begin
         cx:=(i mod wx)/wx;
         cx:=cos(cx*pi/2);
         c:=min(cx,cy);
         r[i-xmin]:=trunc(c*255);
      end;
   end;
end;

procedure SineSawtooth2D(var pic : TMap; waveLengthX,waveLengthY:double);
   var c,cx,cy,x,y:double;
       i,j,wx,wy:integer;
       xmin,ymin,xmax,ymax : integer;
       r : TPixelArray;
begin
   pic.getRect(xmin,xmax,ymin,ymax);
   wx:=trunc(waveLengthX);
   wy:=trunc(waveLengthY);
   for j:=ymin to ymax do begin
      if actprogress(trunc(100*(j-ymin)/(ymax-ymin))) then Exit;
      r:=TRasterMap(pic).getLine(j);
      cy:=(j mod wy)/wy;
      cy:=cos(cy*pi/2);
      for i:=xmin to xmax do begin
         cx:=(i mod wx)/wx;
         cx:=cos(cx*pi/2);
         c:=cx*cy;
         r[i-xmin]:=trunc(c*255);
      end;
   end;
end;

procedure Sine2D(pic : TMap;waveLengthX,waveLengthY:double);
   var c,x,y,wx,wy:double;
       i,j:integer;
       xmin,ymin,xmax,ymax : integer;
       r : TPixelArray;
begin
   pic.getRect(xmin,xmax,ymin,ymax);
   wX:=waveLengthX/(2*pi);
   wY:=waveLengthY/(2*pi);
   for j:=ymin to ymax do begin
      if actprogress(trunc(100*(j-ymin)/(ymax-ymin))) then exit;
      r:=TRasterMap(pic).getLine(j);
      y:=j/wY;
      for i:=xmin to xmax do begin
         x:=i/wX;
         c:=sin(x)*sin(y);
         c:=(1+c)/2;
         r[i-xmin]:=trunc(c*255);
      end;
   end;
end;

procedure SineBrick(var pic : TMap;waveLengthX,waveLengthY:double);
   var c,x,y,wx,wy:double;
       i,j:integer;
       xmin,ymin,xmax,ymax : integer;
       r : TPixelArray;
begin
   pic.getRect(xmin,xmax,ymin,ymax);
   wX:=waveLengthX/(2*pi);
   wY:=waveLengthY/(2*pi);
   for j:=ymin to ymax do begin
      if actprogress(trunc(100*(j-ymin)/(ymax-ymin))) then exit;
      r:=TRasterMap(pic).getLine(j);
      y:=j/wY;
      for i:=xmin to xmax do begin
         x:=i/wX;
         c:=(1+sin(x+(pi/2)*sign(sin(y))))*(abs(sin(y)));
         c:=c/2;
         r[i-xmin]:=trunc(c*255);
      end;
   end;
end;

procedure SineGrid(pic : TMap; waveLengthX,waveLengthY:double);
  var i,j:integer;
      wX,wY,m:double;
       xmin,ymin,xmax,ymax : integer;
       r : TPixelArray;
begin
   pic.getRect(xmin,xmax,ymin,ymax);
   wX:=waveLengthX/(2*pi);
   wY:=waveLengthY/(2*pi);
   for j:=ymin to ymax do begin
      if actprogress(trunc(100*(j-ymin)/(ymax-ymin))) then exit;
      r:=TRasterMap(pic).getLine(j);
      for i:=xmin to xmax do begin
         m := (1+cos(i/wX))*(1+cos(j/wY));
         m:=m/4;
         r[i-xmin]:=trunc(m*255);
      end;
   end;
end;

procedure SineDavid(pic : TMap; waveLengthX,waveLengthY:double);
   var c,x,y,wx,wy,k:double;
       i,j:integer;
       xmin,ymin,xmax,ymax : integer;
       r : TPixelArray;
begin
   pic.getRect(xmin,xmax,ymin,ymax);
   k:=sqrt(3)/2;
   wX:=waveLengthX/(2*pi);
   wY:=waveLengthY/(2*pi);
   for j:=ymin to ymax do begin
      if actprogress(trunc(100*(j-ymin)/(ymax-ymin))) then exit;
      r:=TRasterMap(pic).getLine(j);
      y:=j/wY;
      for i:=xmin to xmax do begin
        x:=i/wX;
        c:=(1+cos(y))*(1+cos(k*x+0.5*y))*(1+cos(k*x-0.5*y))/8;
        r[i-xmin]:=trunc(c*255);
      end;
   end;
end;

procedure SineHexa(var pic : TMap;waveLengthX,waveLengthY:double);
   var c,x,y,wx,wy,k:double;
       i,j:integer;
       xmin,ymin,xmax,ymax : integer;
       r : TPixelArray;
begin
   pic.getRect(xmin,xmax,ymin,ymax);
   k:=sqrt(3)/2;
   wX:=waveLengthX/(pi);
   wY:=waveLengthY/(pi);
   for j:=ymin to ymax do begin
      if actprogress(trunc(100*(j-ymin)/(ymax-ymin))) then exit;
      r:=TRasterMap(pic).getLine(j);
      y:=j/wY;
      for i:=xmin to xmax do begin
        x:=i/wX;
        c:=abs(sin(y)*sin(k*x+0.5*y)*sin(k*x-0.5*y));
        r[i-xmin]:=trunc(c*255);
      end;
   end;
end;

procedure SineBear(var pic : TMap; waveLengthX,waveLengthY:double);
   var c,x,y:double;
       i,j:integer;
       A : Array[0..9] of double;
       xmin,ymin,xmax,ymax : integer;
       r : TPixelArray;
begin
   pic.getRect(xmin,xmax,ymin,ymax);
   Randomize;
   for i:=0 to 9 do A[i]:=1+Random(200)/100;
   for j:=ymin to ymax do begin
      if actprogress(trunc(100*(j-ymin)/(ymax-ymin))) then Exit;
      r := TRasterMap(pic).getLine(j);
      y:=j/waveLengthY;
      for i:=xmin to xmax do begin
        x:=i/waveLengthX;
        c:=A[4]*sin(A[0]*sin(A[6]*x)+A[1]*cos(A[7]*y))
          +A[5]*cos(A[2]*cos(A[8]*x)+A[3]*sin(A[9]*y));
        c:=1+c/2;
        r[i-xmin]:=trunc(c*255);
      end;
   end;
end;

procedure RandomMap(var pic:TMap);
   var c:integer;
   var xmin,ymin,xmax,ymax,x,y : integer;
       r : TPixelArray;
begin
   pic.getRect(xmin,xmax,ymin,ymax);
   Randomize;
   for y:=ymin to ymax do
   begin
     if actprogress(trunc(100*(y-ymin)/(ymax-ymin))) then exit;
     r:=TRasterMap(pic).getLine(y);
     for x:=xmin to xmax do begin
        c:=Random(256);
        r[x-xmin]:=c;
     end;
   end;
end;   // End of RandomMap


{
function SimpleGroup:TContainerProperty;
begin
   result :=
   TContainerProperty.TextureContainer('simpleMaps',[
      TContainerProperty.Texture('Static',Static,[TValueProperty.Color('Color',255)]),
      TContainerProperty.Texture('Sine1D',Sine1D,[TValueProperty.Create('waveLength',10,0,200)]),
      TContainerProperty.Texture('SinePolar',SinePolar,[
         TValueProperty.Create('waveLength',10,0,200),
         TValueProperty.Create('x',320,0,640),
         TValueProperty.Create('y',320,0,640)]),
      TContainerProperty.Texture('Sine2D',Sine2D,[
         TValueProperty.Create('waveLengthX',10,0,200),
         TValueProperty.Create('waveLengthY',10,0,200)]),
      TContainerProperty.Texture('SineGrid',SineGrid,[
         TValueProperty.Create('waveLengthX',10,0,200),
         TValueProperty.Create('waveLengthY',10,0,200)]),
      TContainerProperty.Texture('SineBrick',SineBrick,[
         TValueProperty.Create('waveLengthX',10,0,200),
         TValueProperty.Create('waveLengthY',10,0,200)]),
      TContainerProperty.Texture('SineDavid',SineDavid,[
         TValueProperty.Create('waveLengthX',10,0,200),
         TValueProperty.Create('waveLengthY',10,0,200)]),
      TContainerProperty.Texture('SineHexa',SineHexa,[
         TValueProperty.Create('waveLengthX',10,0,200),
         TValueProperty.Create('waveLengthY',10,0,200)]),
      TContainerProperty.Texture('SineBear',SineBear,[
         TValueProperty.Create('waveLengthX',10,0,200),
         TValueProperty.Create('waveLengthY',10,0,200)]),
      TContainerProperty.Texture('Grids',Grids,[
         TValueProperty.Create('Length1',10,0,200),
         TValueProperty.Create('Length2',10,0,200)]),
      TContainerProperty.Texture('RandomMap',RandomMap,[]),
      TContainerProperty.Texture('Sawtooth1D',Sawtooth1D,[
         TValueProperty.Create('waveLength',10,0,200)]),
      TContainerProperty.Texture('Sawtooth2D',Sawtooth2D,[
         TValueProperty.Create('waveLengthX',10,0,200),
         TValueProperty.Create('waveLengthY',10,0,200)]),
      TContainerProperty.Texture('SineSawtooth2D',SineSawtooth2D,[
         TValueProperty.Create('waveLengthX',10,0,200),
         TValueProperty.Create('waveLengthY',10,0,200)]),
      TContainerProperty.Texture('AbsSine2d',AbsSine2d,[
         TValueProperty.Create('waveLengthX',20,0,200),
         TValueProperty.Create('waveLengthY',20,0,200)]),
      TContainerProperty.Texture('sineWeave',sineWeave,[
         TValueProperty.Create('waveLength',10,0,200),
         TValueProperty.Create('width',60,0,200)]),
      TContainerProperty.Texture('piramid',piramid,[
         TValueProperty.Create('x',10,0,300),
         TValueProperty.Create('y',10,0,300)]),
      TContainerProperty.Texture('Piramids',piramids,[
         TValueProperty.Create('sizex',15,0,200),
         TValueProperty.Create('fold',10,0,200)]),
      TContainerProperty.Texture('GradVer',GradVer,[
         TValueProperty.Color('c1',0),
         TValueProperty.Color('c2',255)]),
      TContainerProperty.Texture('GradHor',GradHor,[
         TValueProperty.Color('c1',0),
         TValueProperty.Color('c2',255)]),
      TContainerProperty.Texture('Weave',Weave,[
         TValueProperty.Create('Xsize',20,0,200),
         TValueProperty.Create('Ysize',20,0,200),
         TValueProperty.Create('WidHor',10,0,200),
         TValueProperty.Create('WidVer',10,0,200)]),
      TContainerProperty.Texture('Sines1D',Sines1D,[
         TValueProperty.Create('WLMin',10,0,200),
         TValueProperty.Create('WLMax',2,0,200),
         TValueProperty.Create('ampVar',1,0,200),
         TValueProperty.Create('num',10,0,200)]),
      TContainerProperty.Texture('Hexagon',Hexagon,[
         TOrdinalProperty.Create('mode',0,['sawtooth','sine','sinesawtooth']),
         TValueProperty.Create('y',10,0,200)]),
      TContainerProperty.Texture('LensFlareBase',LensFlareBase,[
         TValueProperty.Create('R',20,0,200),
         TValueProperty.Create('R2',20,0,200),
         TValueProperty.Create('rComa',20,0,200),
         TValueProperty.Create('dComa',20,0,200),
         TValueProperty.Create('aComa',20,0,200),
         TValueProperty.Create('dRay',20,0,200),
         TValueProperty.Create('lengthRay',20,0,200),
         TValueProperty.Create('intRay',20,0,200)])
   ]);
end;    }

end.


