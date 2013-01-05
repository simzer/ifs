unit function1D;

{$MODE Delphi}

{/**
 * class of Dinamic Analitic texture
 * dinamikus analitikus textura osztaly
 * @author Shaman
 * @version 1.1, 3/05/2004
 * @since   I-mage 1.0
 */}
interface

uses Map,math,rasterMap,Interpolation,Spline;

type TFunction1D = class
   basePoint : array of record
      x: double;
      y: double;
   end;
   activePoint : integer;
   Rendered : boolean;
   Sorted : boolean;
   tiled : boolean;
   RenderedValues : array of double;
   xL,xH,yL,yH : double;
   interpolate : function(x0,x1,x2,x3,u: double) : double;
   onChange : procedure of object;
   class function getTeszt:TFunction1D;
   class function getPenta:TFunction1D;
   class function getQuadra:TFunction1D;
   class function getStar(num,minY,maxY:double):TFunction1D;
   constructor create(xLow,xHigh,yLow,yHigh : double;interpolationType:integer);
   procedure setInterpolationType(interpolationType:integer);
   procedure addBasePoint(x,y: double);
   procedure removeBasePoint(n:integer);overLoad;
   procedure removeBasePoint(x,y:double);overLoad;
   procedure setBasePoint(n:integer;x,y:double);
   procedure Render(quality:integer);
   procedure sort;
   function f(x:double):double;
end;

type TFunction1DArray = array of TFunction1D;

function Function1DGroup : TFunction1DArray;

implementation

function Function1DGroup : TFunction1DArray;
begin
   setLength(result,4);
   result[0]:=TFunction1D.getTeszt;
   result[1]:=TFunction1D.getQuadra;
   result[2]:=TFunction1D.getPenta;
   result[3]:=TFunction1D.getStar(8,0,1);
end;

class function TFunction1D.getTeszt:TFunction1D;
begin
   result:=TFunction1D.create(0,1,0,1,0);
   result.setInterpolationType(2);
   result.addBasePoint(0,0);
   result.addBasePoint(0.3,0.7);
   result.addBasePoint(0.5,0.3);
   result.addBasePoint(0.7,1);
   result.addBasePoint(1,0.5);
end;

class function TFunction1D.getPenta:TFunction1D;
begin
   result:=TFunction1D.create(0,1,0,1,0);
   result.addBasePoint(0.0,1);
   result.addBasePoint(0.1,0.5);
   result.addBasePoint(0.2,1);
   result.addBasePoint(0.3,0.5);
   result.addBasePoint(0.4,1);
   result.addBasePoint(0.5,0.5);
   result.addBasePoint(0.6,1);
   result.addBasePoint(0.7,0.5);
   result.addBasePoint(0.8,1);
   result.addBasePoint(0.9,0.5);
   result.addBasePoint(1.0,1);
end;

class function TFunction1D.getQuadra:TFunction1D;
begin
   result:=TFunction1D.create(0,1,0,1,0);
   result.addBasePoint(0.0,1);
   result.addBasePoint(0.125,0.5);
   result.addBasePoint(0.25,1);
   result.addBasePoint(0.375,0.5);
   result.addBasePoint(0.5,1);
   result.addBasePoint(0.625,0.5);
   result.addBasePoint(0.75,1);
   result.addBasePoint(0.875,0.5);
   result.addBasePoint(1.0,1);
end;

class function TFunction1D.getStar(num,minY,maxY:double):TFunction1D;
  var i:integer;
begin
  result:=TFunction1D.create(0,1,0,1,0);
  for i:=0 to trunc(num)-1 do begin
     result.addBasePoint(i/num,maxY);
     result.addBasePoint(i/num+0.5/num,minY);
  end;
   result.addBasePoint(1,maxY);
end;

constructor TFunction1D.create(xLow,xHigh,yLow,yHigh : double;interpolationType:integer);
begin
   rendered:=false;
   sorted := false;
   xL:=xLow;
   xH:=xHigh;
   yL:=yLow;
   yH:=yHigh;
   case interpolationType of
      0: interpolate := linear;
      1: interpolate := cosine;
      2: interpolate := sqrBlend;
   end;
end;

procedure TFunction1D.setInterpolationType(interpolationType:integer);
begin
   rendered:=false;
   case interpolationType of
      0: interpolate := linear;
      1: interpolate := cosine;
      2: interpolate := sqrBlend;
   end;
end;

procedure TFunction1D.addBasePoint(x,y: double);
   var i,shift:integer;
begin
   rendered:=false;
   setlength(basePoint,length(basePoint)+1);
   shift:=-1;
   for i:=high(basepoint) downto 1 do begin
      basePoint[i]:=basePoint[i+shift];
      if (x>basepoint[i+shift].x) and (shift=-1) then begin
         basePoint[i].x:=x;
         basePoint[i].y:=y;
         shift:=0;
      end;
   end;
   if shift=-1 then begin
      basePoint[0].x:=x;
      basePoint[0].y:=y;
   end;
end;

procedure TFunction1D.removeBasePoint(n:integer);
   var i,shift:integer;
begin
   if length(basepoint)<=2 then exit;
   rendered:=false;
   shift:=0;
   for i:=0 to high(basepoint)-1 do begin
      if i=n then shift:=1;
      basePoint[i]:=basePoint[i+shift];
   end;
   setlength(basePoint,length(basePoint)-1);
end;

procedure TFunction1D.removeBasePoint(x,y:double);
   var i,shift:integer;
begin
   if length(basepoint)<=2 then exit;
   rendered:=false;
   shift:=0;
   for i:=0 to high(basepoint)-1 do begin
      if (basePoint[i].x=x) and (basePoint[i].y=y) then shift:=1;
      basePoint[i]:=basePoint[i+shift];
   end;
   setlength(basePoint,length(basePoint)-1);
end;

procedure TFunction1D.setBasePoint(n:integer;x,y:double);
begin
   sorted := false;
   if x<xL then x:=xL;
   if x>xH then x:=xH;
   if y<yl then y:=yL;
   if y>yh then y:=yH;
   basePoint[n].x:=x;
   basePoint[n].y:=y;
   if assigned(onChange) then onchange;
end;

procedure TFunction1D.Render(quality:integer);
   var i,n:integer;
       x,x0,x1,x2,x3,y0,y1,y2,y3,y,di:double;
   var i0,i1 : integer;
begin
   setLength(renderedValues,quality+1);
   if not sorted then sort;
   for n:=low(basepoint) to high(basepoint)+1 do begin
      if n-2>=low(basepoint) then begin
         x0:=basepoint[n-2].x;
         y0:=basePoint[n-2].y;
      end else begin
         if tiled then begin
            x0:=basepoint[length(basePoint)+n-2].x-xH;
            y0:=basepoint[length(basePoint)+n-2].y;
         end else begin
            x0:=xL;
            y0:=basePoint[low(basepoint)].y;
         end;
      end;
      if n=low(basepoint) then begin
         if tiled then begin
            x1:=basepoint[length(basePoint)+n-1].x-xH;
            y1:=basepoint[length(basePoint)+n-1].y;
         end else begin
            x1:=xL;
            y1:=basePoint[n].y;
         end;
      end else begin
         x1:=basepoint[n-1].x;
         y1:=basePoint[n-1].y;
      end;
      if n=high(basepoint)+1 then begin
         if tiled then begin
            x2:=basepoint[-length(basePoint)+n].x+xH;
            y2:=basepoint[-length(basePoint)+n].y;
         end else begin
            x2:=xH;
            y2:=basePoint[n-1].y;
         end;
      end else begin
         x2:=basepoint[n].x;
         y2:=basePoint[n].y;
      end;
      if n+1<=high(basepoint) then begin
         x3:=basepoint[n+1].x;
         y3:=basepoint[n+1].y;
      end else begin
         if tiled then begin
            x3:=basepoint[-length(basePoint)+n+1].x+xH;
            y3:=basepoint[-length(basePoint)+n+1].y;
         end else begin
            x3:=xH;
            y3:=basePoint[high(basepoint)].y;
         end;
      end;
      i0:=round(quality*(x1-xL)/(xH-xL));
      i1:=round(quality*(x2-xL)/(xH-xL));
      for i:=max(0,i0) to min(quality,i1) do begin
         if i1<>i0 then
            di := (i-i0)/(i1-i0)
         else begin
            di := 1;
            y1 := (y1+y2)/2;
            y2 := y1;
         end;
         y:=interpolate(y0,y1,y2,y3,di);
         y:=max(yL,min(yH,y));
         renderedvalues[i]:=y;
      end;
   end;
   rendered:=true;
end;

function TFunction1D.f(x:double):double;
   var i,xn,xnn:integer;
       x0,x1,x2,x3,y0,y1,y2,y3 : double;
begin
   if not sorted then sort;
   if (x>=xL) and (x<=xH) then begin
      if rendered then begin
         x1:=high(renderedValues)*(x-xL)/(xH-xL);
         xn:=trunc(x1);
         xnn:=min(high(renderedValues),(xn+1));
         x2:=x1-xn;
         result := renderedvalues[xn]*(1-x2)+renderedvalues[xnn]*x2;
      end else begin
         result:=basePoint[0].y;
         for i:=0 to high(basePoint) do
            if (x>=basePoint[i].x) and (x<=basePoint[i+1].x) then begin
               x0:=basePoint[max(0,i-1)].x;
               x1:=basePoint[i].x;
               x2:=basePoint[min(high(basepoint),i+1)].x;
               x3:=basePoint[min(high(basepoint),i+2)].x;
               y0:=basePoint[max(0,i-1)].y;
               y1:=basePoint[i].y;
               y2:=basePoint[min(high(basepoint),i+1)].y;
               y3:=basePoint[min(high(basepoint),i+2)].y;
               break;
            end;
         result:=interpolate(y0,y1,y2,y3,(x-x1)/(x2-x1));
         result:=max(yL,min(yH,result));
      end;
   end else result:=0;
end;

procedure TFunction1D.sort;
  var xt,yt : double;
      i,j : integer;
begin
   sorted := true;
   for j:=high(BasePoint) downto 1 do begin
      for i:= 1 to j do begin
         if basePoint[i-1].x>basePoint[i].x then begin
            xt:=basePoint[i-1].x;
            yt:=basePoint[i-1].y;
            basePoint[i-1].y:=basePoint[i].y;
            basePoint[i-1].x:=basePoint[i].x;
            basePoint[i].y:=yt;
            basePoint[i].x:=xt;
            if i=activePoint then activePoint:=i-1
            else if activePoint=i-1 then activePoint:=i;
         end;
      end;
   end;
end;

end.

