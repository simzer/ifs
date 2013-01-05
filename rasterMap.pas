unit rasterMap;

{$MODE Delphi}

interface

uses Map,Interpolation;

type TPixelArray = array of byte;

type
  TRasterMap = class(TMap)
    Pixels : array of TPixelArray;
    Constructor Create(NewLeft,NewTop,NewWidth,NewHeight:integer);
              reintroduce;overLoad;
    Constructor Create(map:Tmap);reintroduce;overLoad;
    function Duplicate:TMap;reintroduce;overload;override;
    function GetCanvas(NewLeft,NewTop,
              NewWidth,NewHeight:integer):Tmap;reintroduce;overload;override;
    function GetPixel(x,y:integer):integer;reintroduce;overload;override;
    procedure SetPixel(x,y,pix:integer);reintroduce;overload;override;
    procedure DrawPixel(x,y,pix:integer);reintroduce;overload;override;
    function GetAlPixel(x,y:double):integer;reintroduce;overload;override;
    function GetTiledPixel(x,y:integer):integer;reintroduce;overload;override;
    function GetLimitedPixel(x,y:integer):integer;reintroduce;overload;override;
    function GetAlLimitedPixel(x,y:double):integer;reintroduce;overload;override;
    function GetAlTiledPixel(x,y:double):integer;reintroduce;overload;override;
    procedure SetAlPixel(x,y:double;pix:integer);reintroduce;overload;override;
    procedure DrawAlPixel(x,y:double;pix:integer);reintroduce;overload;override;
    procedure resize(NewLeft,NewTop,NewWidth,NewHeight,mode:integer);reintroduce;overload;override;
    procedure sizeUpdate(var minx,miny,maxx,maxy:integer;check:boolean);reintroduce;overload;override;
    Procedure CanvasReSize(NewLeft,NewTop,NewWidth,NewHeight:integer);overload;
    function getLine(y : integer):TPixelArray;
  end;

implementation

function TRasterMap.getLine(y : integer):TPixelArray;
begin
  if ((y-MTop>=low(pixels))  and (y-MTop<=high(pixels))) then
       result:=Pixels[y-MTop]
     else
       result:=nil;
end;

Procedure TRasterMap.CanvasReSize(NewLeft,NewTop,NewWidth,NewHeight:integer);
begin
   self:=TRasterMap(getcanvas(NewLeft,NewTop,NewWidth,NewHeight));
end;

// mode - a resamplig módja, jelenleg nincs implemetálva a választhatóság
procedure TRasterMap.resize(NewLeft,NewTop,NewWidth,NewHeight,mode:integer);
  var i,j:integer;
      x,y:double;
      res:TMap;
begin
  Res:=TRasterMap.Create(NewLeft,NewTop,NewWidth,NewHeight);
  for i:=newLeft to NewLeft+NewWidth-1 do
     for j:=newTop to newTop+NewHeight-1 do begin
        x:=mleft+(mwidth-1)*(i-newLeft)/(NewWidth-1);
        y:=mtop+(mheight-1)*(j-newTop)/(NewHeight-1);
        res.setpixel(i,j,getAlLimitedPixel(x,y));
     end;
  MWidth:=res.MWidth;
  MHeight:=res.MHeight;
  MLeft:=res.MLeft;
  MTop:=res.MTop;
  pixels:=TRasterMap(res).pixels;
//  self:=TRasterMap(res);
end;

procedure TRasterMap.sizeUpdate(var minx,miny,maxx,maxy:integer;check:boolean);
  var i,j,c:integer;
begin
   if check then begin
      minX:=mtop+mheight;
      minY:=mleft+mwidth;
      maxX:=mtop;
      maxY:=mleft;
      for j:=mtop to mtop+mheight do begin
         For i:=mleft to mleft+mwidth do begin
            c:=pixels[i-mleft][j-mtop];
            if c<>0 then begin
               if i>maxx then maxx:=i;
               if i<minx then minx:=i;
               if j>maxY then maxY:=j;
               if j<minY then minY:=j;
            end;
         end;
      end;
   end;
   if (maxX<minX) or (maxY<minY) then begin
      mleft:=0;
      mtop:=0;
      mwidth:=0;
      mheight:=0;
      pixels:=nil;
   end;
   if (mleft<>minX) or (mtop<>minY) or (mwidth<>maxX-minX+1) or (mheight<>maxY-minY+1) then begin
      canvasResize(minX,minY,maxX-minX+1,maxY-minY+1);
   end;
end;

Constructor TRasterMap.Create(NewLeft,NewTop,NewWidth,NewHeight:integer);
begin
  MWidth:=NewWidth;
  MHeight:=NewHeight;
  MLeft:=NewLeft;
  MTop:=NewTop;
  setlength(pixels,Mheight,Mwidth);
end;

constructor TRasterMap.Create(map:Tmap);
begin
  if Map=nil then
    self:=nil
  else begin
    MWidth:=Map.MWidth;
    MHeight:=Map.MHeight;
    MLeft:=Map.MLeft;
    MTop:=Map.MTop;
    setlength(pixels,MHeight,MWidth);
  end;
end;

function TRasterMap.Duplicate:TMap;
   var i:integer;
       res:TrasterMap;
begin
   res:=TRasterMap.Create(MLeft,MTop,MWidth,MHeight);
   for i:=0 to high(Pixels) do res.pixels[i]:=
      Copy(pixels[i],0,length(pixels[i]));
   result:=res;
end;

function TRasterMap.GetCanvas(NewLeft,NewTop,
              NewWidth,NewHeight:integer):Tmap;
  var i,j:integer;
begin
  Result:=TRasterMap.Create(NewLeft,NewTop,NewWidth,NewHeight);
  For i:=newLeft to NewLeft+NewWidth-1 do
      for j:=newTop to newTop+NewHeight-1 do
  begin
     Result.setpixel(i,j,getPixel(i,j));
  end;
end;
  
function TRasterMap.GetPixel(x,y:integer):integer;
begin
  if (((x>=Mleft) and (x<MLeft+MWidth)) and
      ((y>=MTop)  and (y<MTop+MHeight))) then
       result:=Pixels[y-MTop][x-MLeft]
     else
       result:=0;
end;

procedure TRasterMap.SetPixel(x,y,pix:integer);
begin
  if (((x>=Mleft) and (x<MLeft+MWidth)) and
      ((y>=MTop)  and (y<MTop+MHeight))) then
       Pixels[y-MTop][x-MLeft]:=pix;
end;

procedure TRasterMap.DrawPixel(x,y,pix:integer);
begin
   if x<MLeft then Canvasresize(x,MTop,MWidth+Mleft-x,MHeight);
   if y<MTop then Canvasresize(MLeft,y,MWidth,MHeight+MTop-y);
   if x>=MLeft+MWidth then
      Canvasresize(MLeft,MTop,x-MLeft+1,MHeight);
   if y>=MTop+MHeight then
      Canvasresize(MLeft,MTop,MWidth,y-MTop+1);
   SetPixel(x,y,pix);
end;

function TRasterMap.GetAlPixel(x,y:double):integer;
  var x0,y0,res:double;
      x1,y1,x2,y2:integer;
begin
  if (((x>=MLeft) and (x<=MLeft+MWidth-1)) and
      ((y>=MTop) and (y<=MTop+MHeight-1))) then
  begin
     x1:=trunc(x);
     x0:=x-x1;
     y1:=trunc(y);
     y0:=y-y1;
     x1:=x1-MLeft;
     y1:=y1-MTop;
     if x1=x then x2:=x1 else x2:=x1+1;
     if y1=y then y2:=y1 else y2:=y1+1;
     res:=cosine(pixels[y1][x1],pixels[y1][x2],pixels[y2][x1],pixels[y2][x2],x0,y0);
     result:=round(res);
  end else result:=0;
end;

procedure TRasterMap.SetAlPixel(x,y:double;pix:integer);
  var x0,y0,a1,a2,a3,a4:double;
      c,x1,y1,x2,y2:integer;
begin
  if (((x>=MLeft) and (x<=MLeft+MWidth-1)) and
      ((y>=MTop) and (y<=MTop+MHeight-1))) then
  begin
     x1:=trunc(x);
     x0:=x-x1;
     y1:=trunc(y);
     y0:=y-y1;
     x2:=x1+1;
     y2:=y1+1;
     a1:=(1-x0)*(1-y0);
     a2:=(x0*(1-y0));
     a3:=((1-x0)*y0);
     a4:=(x0*y0);
     c:=trunc((1-a1)*getpixel(x1,y1)+a1*pix);
     Pixels[y1-MTop][x1-MLeft]:=c;
     if (x2<MLeft+MWidth) then begin
       c:=trunc((1-a2)*getpixel(x2,y1)+a2*pix);
       Pixels[y1-MTop][x2-MLeft]:=c;
     end;
     if (y2<MTop+MHeight) then begin
       c:=trunc((1-a3)*getpixel(x1,y2)+a3*pix);
       Pixels[y2-MTop][x1-MLeft]:=c;
       if (x2<MLeft+MWidth) then begin
         c:=trunc((1-a4)*getpixel(x2,y2)+a4*pix);
         Pixels[y2-MTop][x2-MLeft]:=c;
       end;
     end;
  end;
end;

procedure TRasterMap.DrawAlPixel(x,y:double;pix:integer);
  var x0,y0:double;
      x1,y1,x2,y2,pixOld:integer;
begin
  if (((x>=MLeft) and (x<=MLeft+MWidth-1)) and
      ((y>=MTop) and (y<=MTop+MHeight-1))) then
     SetAlPixel(x,y,pix)
  else begin
     x1:=trunc(x);
     x0:=x-x1;
     y1:=trunc(y);
     y0:=y-y1;
     x1:=x1-MLeft;
     y1:=y1-MTop;
     if x1=x then x2:=x1 else x2:=x1+1;
     if y1=y then y2:=y1 else y2:=y1+1;
     pixOld:=getpixel(x1,y1);
     drawpixel(x1,y1,Round(x0*y0*pixOld+(1-x0)*(1-y0)*pix));
     pixOld:=getpixel(x2,y1);
     drawpixel(x2,y1,Round((1-x0)*y0*pixOld+x0*(1-y0)*pix));
     pixOld:=getpixel(x1,y2);
     drawpixel(x1,y2,Round(x0*(1-y0)*pixOld+(1-x0)*y0*pix));
     pixOld:=getpixel(x2,y2);
     drawpixel(x2,y2,Round((1-x0)*(1-y0)*pixOld+x0*y0*pix));
  end;
end;

function TRasterMap.GetAlTiledPixel(x,y:double):integer;
  var x0,y0,x3,y3,res:double;
      x1,y1,x2,y2:integer;
begin
   while x>MLeft+MWidth-1 do x:=x-MWidth;
   while y>MTop+MHeight-1 do y:=y-MHeight;
   while x<MLeft do x:=x+MWidth;
   while y<MTop do y:=y+MHeight;
{   x3:=x-mLeft;
   y3:=y-mTop;
   if x3>=MWidth then x3:=(mwidth*(x3/mwidth-trunc(x3/mwidth)));
   if y3>=MHeight then y3:=(mHeight*(y3/mHeight-trunc(y3/mHeight)));
   if x3<0 then x3:=(mwidth*(x3/mwidth+trunc(abs(x3)/mwidth))+1);
   if y3<0 then y3:=(mHeight*(y3/mHeight+trunc(abs(y3)/mHeight))+1);
}   if (((x>=MLeft) and (x<=MLeft+MWidth-1)) and
       ((y>=MTop) and (y<=MTop+MHeight-1))) then begin
   x3:=x;y3:=y;
   x1:=trunc(x3);
   x0:=x3-x1;
   y1:=trunc(y3);
   y0:=y3-y1;
   if x1=x3 then x2:=x1 else x2:=x1+1;
   if y1=y3 then y2:=y1 else y2:=y1+1;
   res:=cosine(pixels[y1][x1],pixels[y1][x2],pixels[y2][x1],pixels[y2][x2],x0,y0);
   result:=round(res);
   end;
end;


function TRasterMap.GetTiledPixel(x,y:integer):integer;
   var x0,y0:integer;
begin
   while x>MLeft+MWidth-1 do x:=x-MWidth;
   while y>MTop+MHeight-1 do y:=y-MHeight;
   while x<MLeft do x:=x+MWidth;
   while y<MTop do y:=y+MHeight;
   result:=pixels[y-mtop][x-mleft];
{   x0:=x-mLeft;
   y0:=y-mTop;
   if x0>=MWidth then x0:=round(mwidth*(x0/mwidth-trunc(x0/mwidth)));
   if y0>=MHeight then y0:=round(mHeight*(y0/mHeight-trunc(y0/mHeight)));
   if x0<0 then x0:=mwidth-1-round(mwidth*(abs(x0-1)/mwidth+trunc(abs(x0-1)/mwidth)));
   if y0<0 then y0:=mwidth-1-round(mHeight*(abs(y0-1)/mHeight+trunc(abs(y0-1)/mHeight)));
   result:=pixels[x0][y0];                                                               }
end;

function TRasterMap.GetLimitedPixel(x,y:integer):integer;
  var x0,y0:integer;
begin
  x0:=x;
  y0:=y;
  if x0<Mleft then x0:=MLeft;
  if y0<Mtop then y0:=MTop;
  if x0>Mleft+Mwidth-1 then x0:=Mleft+Mwidth-1;
  if y0>Mtop+Mheight-1 then y0:=MTop+MHeight-1;
  result:=Pixels[y0-MTop][x0-MLeft];
end;

function TRasterMap.GetAlLimitedPixel(x,y:double):integer;
  var x0,y0,xo,yo,res:double;
  x1,y1,x2,y2:integer;
begin
  xo:=x;
  yo:=y;
  if xo<Mleft then xo:=MLeft;
  if yo<Mtop then yo:=MTop;
  if xo>Mleft+Mwidth-1 then xo:=Mleft+Mwidth-1;
  if yo>Mtop+Mheight-1 then yo:=MTop+MHeight-1;
     x1:=trunc(xo);
     x0:=xo-x1;
     y1:=trunc(yo);
     y0:=yo-y1;
     x1:=x1-MLeft;
     y1:=y1-MTop;
     if x1=xo then x2:=x1 else x2:=x1+1;
     if y1=yo then y2:=y1 else y2:=y1+1;
     res:=cosine(pixels[y1][x1],pixels[y1][x2],pixels[y2][x1],pixels[y2][x2],x0,y0);
     result:=round(res);
end;

end.

