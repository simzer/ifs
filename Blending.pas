unit Blending;

{$MODE Delphi}

{/**
 * class of Blending filter
 * blending filtes textura osztaly
 * @author Shaman
 * @version 1.2, 23/01/2008
 * @since   Effectbank 1.0.0
 */}
interface

uses Map,Math,rasterMap,Propertyes,ProgressControll,MapAccessories,BaseTypes;

procedure alpha(bottom, top, botAlp, topAlp : TMap;opac:integer);
                            
procedure allanon(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
procedure linearLight(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
procedure colorDodge(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
procedure colorBurn(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
procedure vividLight(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
procedure pinLight(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
procedure softLight(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
procedure HardLight(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
procedure Overlay(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
procedure light(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
procedure dark(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
procedure ekvivalence(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
procedure Burn(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
procedure GammaDark(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
procedure GammaLight(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
procedure Pitagoras(result,bottom, top: TMap; p: TProperty; pc : TProgressControll);
procedure GeomMean(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
procedure Exclusion(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
procedure AddSub(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
procedure arctan(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
procedure multiply(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
procedure bleach(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
procedure screen(result, bottom, top : TMap; p: TProperty; pc : TProgressControll);
procedure divide(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
procedure add(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
procedure sub(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
procedure diff(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
procedure difference(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
procedure paralel(result,bottom, top: TMap; p: TProperty; pc : TProgressControll);
procedure darken(result,bottom, top: TMap; p: TProperty; pc : TProgressControll);
procedure lighten(result,bottom, top: TMap; p: TProperty; pc : TProgressControll);
procedure texture(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
procedure andop(result,bottom, top: TMap; p: TProperty; pc : TProgressControll);
procedure orop(result,bottom, top: TMap; p: TProperty; pc : TProgressControll);
procedure xorop(result,bottom, top: TMap; p: TProperty; pc : TProgressControll);

implementation

procedure alpha(bottom, top, botAlp, topAlp : TMap;opac:integer);
   var xmin,ymin,xmax,ymax,x,y,bLeft,tLeft,baLeft,taLeft : integer;
       t,b,ta,ba : TPixelArray;
       alp : double;
       opacity:integer;
begin
   getOverlayRect(bottom,top,xmin,xmax,ymin,ymax);
   bLeft := bottom.MLeft;
   tLeft := top.MLeft;
   baLeft := botAlp.MLeft;
   taLeft := topAlp.MLeft;
   opacity := round(255*opac/100);
   for y := ymin to ymax do begin
      t:=TRasterMap(top).getLine(y);
      b:=TRasterMap(bottom).getLine(y);
      ta:=TRasterMap(topAlp).getLine(y);
      ba:=TRasterMap(botAlp).getLine(y);
      for x := xmin to xmax do begin
         alp := opacity*ta[x-baLeft]/256;
         b[x-bLeft]:=round((b[x-bLeft]*(255-alp)+t[x-tLeft]*alp)/256);
         ba[x-baLeft]:=max(ba[x-baLeft],opacity);
      end;
   end;
end; // End of alpha

procedure allanon(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
   var xmin,ymin,xmax,ymax,x,y,bLeft,tLeft : integer;
       t,b,r : TPixelArray;
begin
   getOverlayRect(bottom,top,xmin,xmax,ymin,ymax);
//   result:=TRasterMap.Create(xmin,ymin,xmax-xmin+1,ymax-ymin+1);
   bLeft := bottom.MLeft;
   tLeft := top.MLeft;
   pc.start;
   for y := ymin to ymax do begin
      if not pc.isActual(trunc(100*(y-ymin)/(ymax-ymin))) then exit;
      t:=TRasterMap(top).getLine(y);
      b:=TRasterMap(bottom).getLine(y);
      r:=TRasterMap(result).getLine(y);
      for x := xmin to xmax do begin
         r[x-bLeft]:=(b[x-bLeft]+t[x-tLeft]) shr 1;
      end;
   end;
   pc.finish;
end;

procedure softLight(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
   var xmin,ymin,xmax,ymax,x,y,bLeft,tLeft : integer;
       t,b,r : TPixelArray;
begin
   getOverlayRect(bottom,top,xmin,xmax,ymin,ymax);
  // result:=TRasterMap.Create(xmin,ymin,xmax-xmin+1,ymax-ymin+1);
   bLeft := bottom.MLeft;
   tLeft := top.MLeft;
   pc.start;
   for y := ymin to ymax do begin
      if not pc.isActual(trunc(100*(y-ymin)/(ymax-ymin))) then exit;
      t:=TRasterMap(top).getLine(y);
      b:=TRasterMap(bottom).getLine(y);
      r:=TRasterMap(result).getLine(y);
      for x := xmin to xmax do begin
         r[x-bLeft]:=round(255*power(b[x-bLeft]/255,power(2,(2*(128-t[x-tLeft])/255))));
      end;
   end;
   pc.finish;
end;

procedure HardLight(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
   var xmin,ymin,xmax,ymax,x,y,bLeft,tLeft : integer;
       t,b,r : TPixelArray;
begin
   getOverlayRect(bottom,top,xmin,xmax,ymin,ymax);
   //result:=TRasterMap.Create(xmin,ymin,xmax-xmin+1,ymax-ymin+1);
   bLeft := bottom.MLeft;
   tLeft := top.MLeft;
   pc.start;
   for y := ymin to ymax do begin
      if not pc.isActual(trunc(100*(y-ymin)/(ymax-ymin))) then exit;
      t:=TRasterMap(top).getLine(y);
      b:=TRasterMap(bottom).getLine(y);
      r:=TRasterMap(result).getLine(y);
      for x := xmin to xmax do begin
         if t[x-tLeft]<128 then
            r[x-bLeft]:=round(2*b[x-bLeft]*t[x-tLeft]/255)
         else
            r[x-bLeft]:=round(255-2*(255-b[x-bLeft])*(255-t[x-tLeft])/255);
      end;
   end;
   pc.finish;
end;

procedure Overlay(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
   var xmin,ymin,xmax,ymax,x,y,bLeft,tLeft : integer;
       t,b,r : TPixelArray;
begin
   getOverlayRect(bottom,top,xmin,xmax,ymin,ymax);
   //result:=TRasterMap.Create(xmin,ymin,xmax-xmin+1,ymax-ymin+1);
   bLeft := bottom.MLeft;
   tLeft := top.MLeft;
   pc.start;
   for y := ymin to ymax do begin
      if not pc.isActual(trunc(100*(y-ymin)/(ymax-ymin))) then exit;
      t:=TRasterMap(top).getLine(y);
      b:=TRasterMap(bottom).getLine(y);
      r:=TRasterMap(result).getLine(y);
      for x := xmin to xmax do begin
         if b[x-bLeft]<128 then
            r[x-bLeft]:=round(2*b[x-bLeft]*t[x-tLeft]/255)
         else
            r[x-bLeft]:=round(255-2*(255-b[x-bLeft])*(255-t[x-tLeft])/255);
      end;
   end;
   pc.finish;
end;

procedure linearLight(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
   var xmin,ymin,xmax,ymax,x,y,bLeft,tLeft : integer;
       t,b,r : TPixelArray;
begin
   getOverlayRect(bottom,top,xmin,xmax,ymin,ymax);
//   result:=TRasterMap.Create(xmin,ymin,xmax-xmin+1,ymax-ymin+1);
   bLeft := bottom.MLeft;
   tLeft := top.MLeft;
   pc.start;
   for y := ymin to ymax do begin
      if not pc.isActual(trunc(100*(y-ymin)/(ymax-ymin))) then exit;
      t:=TRasterMap(top).getLine(y);
      b:=TRasterMap(bottom).getLine(y);
      r:=TRasterMap(result).getLine(y);
      for x := xmin to xmax do begin
         r[x-bLeft]:= min(255,max(0,(b[x-bLeft]+2*t[x-tLeft])-256));
      end;
   end;
   pc.finish;
end;

procedure colorDodge(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
   var xmin,ymin,xmax,ymax,x,y,bLeft,tLeft : integer;
       t,b,r : TPixelArray;
begin
   getOverlayRect(bottom,top,xmin,xmax,ymin,ymax);
 //  result:=TRasterMap.Create(xmin,ymin,xmax-xmin+1,ymax-ymin+1);
   bLeft := bottom.MLeft;
   tLeft := top.MLeft;
   pc.start;
   for y := ymin to ymax do begin
      if not pc.isActual(trunc(100*(y-ymin)/(ymax-ymin))) then exit;
      t:=TRasterMap(top).getLine(y);
      b:=TRasterMap(bottom).getLine(y);
      r:=TRasterMap(result).getLine(y);
      for x := xmin to xmax do begin
         if t[x-bLeft]<>255 then
            r[x-bLeft]:= min(255,max(0,round( 255*b[x-bLeft]/(255-t[x-bLeft]) )));
      end;
   end;
   pc.finish;
end;


procedure colorBurn(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
   var xmin,ymin,xmax,ymax,x,y,bLeft,tLeft : integer;
       t,b,r : TPixelArray;
begin
   getOverlayRect(bottom,top,xmin,xmax,ymin,ymax);
   // result:=TRasterMap.Create(xmin,ymin,xmax-xmin+1,ymax-ymin+1);
   bLeft := bottom.MLeft;
   tLeft := top.MLeft;
   pc.start;
   for y := ymin to ymax do begin
      if not pc.isActual(trunc(100*(y-ymin)/(ymax-ymin))) then exit;
      t:=TRasterMap(top).getLine(y);
      b:=TRasterMap(bottom).getLine(y);
      r:=TRasterMap(result).getLine(y);
      for x := xmin to xmax do begin
         if t[x-bLeft]<>0 then
            r[x-bLeft]:= min(255,max(0,round(255-255*(255-b[x-bLeft])/t[x-bLeft] )));
      end;
   end;
   pc.finish;
end;

procedure vividLight(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
   var xmin,ymin,xmax,ymax,x,y,bLeft,tLeft : integer;
       t,b,r : TPixelArray;
begin
   getOverlayRect(bottom,top,xmin,xmax,ymin,ymax);
   //result:=TRasterMap.Create(xmin,ymin,xmax-xmin+1,ymax-ymin+1);
   bLeft := bottom.MLeft;
   tLeft := top.MLeft;
   pc.start;
   for y := ymin to ymax do begin
      if not pc.isActual(trunc(100*(y-ymin)/(ymax-ymin))) then exit;
      t:=TRasterMap(top).getLine(y);
      b:=TRasterMap(bottom).getLine(y);
      r:=TRasterMap(result).getLine(y);
      for x := xmin to xmax do begin
         if t[x-bLeft]<128 then begin
            if (t[x-bLeft]<>0) then
               r[x-bLeft]:= min(255,max(0,round(255-255*(255-b[x-bLeft])/(2*t[x-bLeft]) )));
            end else begin
               if (t[x-bLeft]<>255) then
               r[x-bLeft]:= min(255,max(0,round( 255*b[x-bLeft]/(2*(255-t[x-bLeft])) )));
            end;
      end;
   end;
   pc.finish;
end;

procedure pinLight(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
   var xmin,ymin,xmax,ymax,x,y,bLeft,tLeft : integer;
       t,b,r : TPixelArray;
begin
   getOverlayRect(bottom,top,xmin,xmax,ymin,ymax);
   //result:=TRasterMap.Create(xmin,ymin,xmax-xmin+1,ymax-ymin+1);
   bLeft := bottom.MLeft;
   tLeft := top.MLeft;
   pc.start;
   for y := ymin to ymax do begin
      if not pc.isActual(trunc(100*(y-ymin)/(ymax-ymin))) then exit;
      t:=TRasterMap(top).getLine(y);
      b:=TRasterMap(bottom).getLine(y);
      r:=TRasterMap(result).getLine(y);
      for x := xmin to xmax do begin
         r[x-bLeft]:= max(0,max(2*t[x-bLeft]-255,min(b[x-bLeft],2*t[x-bLeft])));
      end;
   end;
   pc.finish;
end;

procedure light(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
   var xmin,ymin,xmax,ymax,x,y,bLeft,tLeft : integer;
       t,b,r : TPixelArray;
begin
   getOverlayRect(bottom,top,xmin,xmax,ymin,ymax);
   //result:=TRasterMap.Create(xmin,ymin,xmax-xmin+1,ymax-ymin+1);
   bLeft := bottom.MLeft;
   tLeft := top.MLeft;
   pc.start;
   for y := ymin to ymax do begin
      if not pc.isActual(trunc(100*(y-ymin)/(ymax-ymin))) then exit;
      t:=TRasterMap(top).getLine(y);
      b:=TRasterMap(bottom).getLine(y);
      r:=TRasterMap(result).getLine(y);
      for x := xmin to xmax do begin
         r[x-bLeft]:= round((b[x-bLeft]*(255-t[x-bLeft])+sqr(t[x-bLeft]))/255);
      end;
   end;
   pc.finish;
end;

procedure dark(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
   var xmin,ymin,xmax,ymax,x,y,bLeft,tLeft : integer;
       t,b,r : TPixelArray;
begin
   getOverlayRect(bottom,top,xmin,xmax,ymin,ymax);
   //result:=TRasterMap.Create(xmin,ymin,xmax-xmin+1,ymax-ymin+1);
   bLeft := bottom.MLeft;
   tLeft := top.MLeft;
   pc.start;
   for y := ymin to ymax do begin
      if not pc.isActual(trunc(100*(y-ymin)/(ymax-ymin))) then exit;
      t:=TRasterMap(top).getLine(y);
      b:=TRasterMap(bottom).getLine(y);
      r:=TRasterMap(result).getLine(y);
      for x := xmin to xmax do begin
         r[x-bLeft]:=round(((b[x-bLeft]+(255-t[x-bLeft]))*t[x-bLeft])/255);
      end;
   end;
   pc.finish;
end;

procedure ekvivalence(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
   var xmin,ymin,xmax,ymax,x,y,bLeft,tLeft : integer;
       t,b,r : TPixelArray;
begin
   getOverlayRect(bottom,top,xmin,xmax,ymin,ymax);
   //result:=TRasterMap.Create(xmin,ymin,xmax-xmin+1,ymax-ymin+1);
   bLeft := bottom.MLeft;
   tLeft := top.MLeft;
   pc.start;
   for y := ymin to ymax do begin
      if not pc.isActual(trunc(100*(y-ymin)/(ymax-ymin))) then exit;
      t:=TRasterMap(top).getLine(y);
      b:=TRasterMap(bottom).getLine(y);
      r:=TRasterMap(result).getLine(y);
      for x := xmin to xmax do begin
         r[x-bLeft]:=255-abs(b[x-bLeft]-t[x-bLeft]);
      end;
   end;
   pc.finish;
end;

procedure Burn(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
   var xmin,ymin,xmax,ymax,x,y,bLeft,tLeft : integer;
       t,b,r : TPixelArray;
begin
   getOverlayRect(bottom,top,xmin,xmax,ymin,ymax);
   //result:=TRasterMap.Create(xmin,ymin,xmax-xmin+1,ymax-ymin+1);
   bLeft := bottom.MLeft;
   tLeft := top.MLeft;
   pc.start;
   for y := ymin to ymax do begin
      if not pc.isActual(trunc(100*(y-ymin)/(ymax-ymin))) then exit;
      t:=TRasterMap(top).getLine(y);
      b:=TRasterMap(bottom).getLine(y);
      r:=TRasterMap(result).getLine(y);
      for x := xmin to xmax do begin
         r[x-bLeft]:=max(0,(b[x-bLeft]+t[x-bLeft]-255));
      end;
   end;
   pc.finish;
end;

procedure GammaLight(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
   var xmin,ymin,xmax,ymax,x,y,bLeft,tLeft : integer;
       t,b,r : TPixelArray;
begin
   getOverlayRect(bottom,top,xmin,xmax,ymin,ymax);
 //  result:=TRasterMap.Create(xmin,ymin,xmax-xmin+1,ymax-ymin+1);
   bLeft := bottom.MLeft;
   tLeft := top.MLeft;
   pc.start;
   for y := ymin to ymax do begin
      if not pc.isActual(trunc(100*(y-ymin)/(ymax-ymin))) then exit;
      t:=TRasterMap(top).getLine(y);
      b:=TRasterMap(bottom).getLine(y);
      r:=TRasterMap(result).getLine(y);
      for x := xmin to xmax do begin
         r[x-bLeft]:=round(255*power(b[x-bLeft]/255,t[x-bLeft]/255));
      end;
   end;
   pc.finish;
end;

procedure GammaDark(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
   var xmin,ymin,xmax,ymax,x,y,bLeft,tLeft : integer;
       t,b,r : TPixelArray;
begin
   getOverlayRect(bottom,top,xmin,xmax,ymin,ymax);
   //result:=TRasterMap.Create(xmin,ymin,xmax-xmin+1,ymax-ymin+1);
   bLeft := bottom.MLeft;
   tLeft := top.MLeft;
   pc.start;
   for y := ymin to ymax do begin
      if not pc.isActual(trunc(100*(y-ymin)/(ymax-ymin))) then exit;
      t:=TRasterMap(top).getLine(y);
      b:=TRasterMap(bottom).getLine(y);
      r:=TRasterMap(result).getLine(y);
      for x := xmin to xmax do begin
         if t[x-bLeft]<>0 then
            r[x-bLeft]:=round(255*power(b[x-bLeft]/255,255/t[x-bLeft]));
      end;
   end;
   pc.finish;
end;

procedure GeomMean(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
   var xmin,ymin,xmax,ymax,x,y,bLeft,tLeft : integer;
       t,b,r : TPixelArray;
begin
   getOverlayRect(bottom,top,xmin,xmax,ymin,ymax);
   //result:=TRasterMap.Create(xmin,ymin,xmax-xmin+1,ymax-ymin+1);
   bLeft := bottom.MLeft;
   tLeft := top.MLeft;
   pc.start;
   for y := ymin to ymax do begin
      if not pc.isActual(trunc(100*(y-ymin)/(ymax-ymin))) then exit;
      t:=TRasterMap(top).getLine(y);
      b:=TRasterMap(bottom).getLine(y);
      r:=TRasterMap(result).getLine(y);
      for x := xmin to xmax do begin
         r[x-bLeft]:=round(sqrt(b[x-bLeft]*t[x-bLeft]));
      end;
   end;
   pc.finish;
end;

procedure Pitagoras(result,bottom, top: TMap; p: TProperty; pc : TProgressControll);
   var xmin,ymin,xmax,ymax,x,y,bLeft,tLeft : integer;
       t,b,r : TPixelArray;
begin
   getOverlayRect(bottom,top,xmin,xmax,ymin,ymax);
   //result:=TRasterMap.Create(xmin,ymin,xmax-xmin+1,ymax-ymin+1);
   bLeft := bottom.MLeft;
   tLeft := top.MLeft;
   pc.start;
   for y := ymin to ymax do begin
      if not pc.isActual(trunc(100*(y-ymin)/(ymax-ymin))) then exit;
      t:=TRasterMap(top).getLine(y);
      b:=TRasterMap(bottom).getLine(y);
      r:=TRasterMap(result).getLine(y);
      for x := xmin to xmax do begin
         r[x-bLeft]:=round( sqrt(sqr(b[x-bLeft])+sqr(t[x-bLeft])) / sqrt(2) );
      end;
   end;
   pc.finish;
end;

procedure Exclusion(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
   var xmin,ymin,xmax,ymax,x,y,bLeft,tLeft : integer;
       t,b,r : TPixelArray;
begin
   getOverlayRect(bottom,top,xmin,xmax,ymin,ymax);
   //result:=TRasterMap.Create(xmin,ymin,xmax-xmin+1,ymax-ymin+1);
   bLeft := bottom.MLeft;
   tLeft := top.MLeft;
   pc.start;
   for y := ymin to ymax do begin
      if not pc.isActual(trunc(100*(y-ymin)/(ymax-ymin))) then exit;
      t:=TRasterMap(top).getLine(y);
      b:=TRasterMap(bottom).getLine(y);
      r:=TRasterMap(result).getLine(y);
      for x := xmin to xmax do begin
         r[x-bLeft]:=round(b[x-bLeft]+t[x-bLeft]-2*(b[x-bLeft]*t[x-bLeft])/255);
      end;
   end;
   pc.finish;
end;

procedure AddSub(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
   var xmin,ymin,xmax,ymax,x,y,bLeft,tLeft : integer;
       t,b,r : TPixelArray;
begin
   getOverlayRect(bottom,top,xmin,xmax,ymin,ymax);
   //result:=TRasterMap.Create(xmin,ymin,xmax-xmin+1,ymax-ymin+1);
   bLeft := bottom.MLeft;
   tLeft := top.MLeft;
   pc.start;
   for y := ymin to ymax do begin
      if not pc.isActual(trunc(100*(y-ymin)/(ymax-ymin))) then exit;
      t:=TRasterMap(top).getLine(y);
      b:=TRasterMap(bottom).getLine(y);
      r:=TRasterMap(result).getLine(y);
      for x := xmin to xmax do begin
         r[x-bLeft]:= min(255,max(0,round(abs(sqr(b[x-bLeft])-sqr(t[x-bLeft]))/255)));
      end;
   end;
   pc.finish;
end;

procedure arctan(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
   var xmin,ymin,xmax,ymax,x,y,bLeft,tLeft : integer;
       t,b,r : TPixelArray;
begin
   getOverlayRect(bottom,top,xmin,xmax,ymin,ymax);
   //result:=TRasterMap.Create(xmin,ymin,xmax-xmin+1,ymax-ymin+1);
   bLeft := bottom.MLeft;
   tLeft := top.MLeft;
   pc.start;
   for y := ymin to ymax do begin
      if not pc.isActual(trunc(100*(y-ymin)/(ymax-ymin))) then exit;
      t:=TRasterMap(top).getLine(y);
      b:=TRasterMap(bottom).getLine(y);
      r:=TRasterMap(result).getLine(y);
      for x := xmin to xmax do begin
         if b[x-bLeft]<>0 then
            r[x-bLeft]:= round(2*255*arctan2(t[x-bLeft],255-b[x-bLeft])/pi);
      end;
   end;
   pc.finish;
end;

procedure multiply(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
   var xmin,ymin,xmax,ymax,x,y,bLeft,tLeft : integer;
       t,b,r : TPixelArray;
begin
   getOverlayRect(bottom,top,xmin,xmax,ymin,ymax);
   //result:=TRasterMap.Create(xmin,ymin,xmax-xmin+1,ymax-ymin+1);
   bLeft := bottom.MLeft;
   tLeft := top.MLeft;
   pc.start;
   for y := ymin to ymax do begin
      if not pc.isActual(trunc(100*(y-ymin)/(ymax-ymin))) then exit;
      t:=TRasterMap(top).getLine(y);
      b:=TRasterMap(bottom).getLine(y);
      r:=TRasterMap(result).getLine(y);
      for x := xmin to xmax do begin
         r[x-bLeft] := round(b[x-bLeft]*t[x-bLeft]/255);
      end;
   end;
   pc.finish;
end;

procedure bleach(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
   var xmin,ymin,xmax,ymax,x,y,bLeft,tLeft : integer;
       t,b,r : TPixelArray;
begin
   getOverlayRect(bottom,top,xmin,xmax,ymin,ymax);
   //result:=TRasterMap.Create(xmin,ymin,xmax-xmin+1,ymax-ymin+1);
   bLeft := bottom.MLeft;
   tLeft := top.MLeft;
   pc.start;
   for y := ymin to ymax do begin
      if not pc.isActual(trunc(100*(y-ymin)/(ymax-ymin))) then exit;
      t:=TRasterMap(top).getLine(y);
      b:=TRasterMap(bottom).getLine(y);
      r:=TRasterMap(result).getLine(y);
      for x := xmin to xmax do begin
         r[x-bLeft]:= round((255-b[x-bLeft])*(255-t[x-bLeft])/255);
      end;
   end;
   pc.finish;
end;

procedure screen(result, bottom, top : TMap; p: TProperty; pc : TProgressControll);
   var xmin,ymin,xmax,ymax,x,y,bLeft,tLeft : integer;
       t,b,r : TPixelArray;
begin
   getOverlayRect(bottom,top,xmin,xmax,ymin,ymax);
  // result:=TRasterMap.Create(xmin,ymin,xmax-xmin+1,ymax-ymin+1);
   bLeft := bottom.MLeft;
   tLeft := top.MLeft;
   pc.start;
   for y := ymin to ymax do begin
      if not pc.isActual(trunc(100*(y-ymin)/(ymax-ymin))) then exit;
      t:=TRasterMap(top).getLine(y); // Line in the top blended layer
      b:=TRasterMap(bottom).getLine(y); // Line in the bottom blended layer
      r:=TRasterMap(result).getLine(y); // Line in the result layer
      for x := xmin to xmax do begin
         r[x-bLeft]:= round(255-((255-b[x-bLeft])*(255-t[x-bLeft])/255));
      end;
   end;
   pc.finish;
end;

procedure divide(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
   var xmin,ymin,xmax,ymax,x,y,bLeft,tLeft : integer;
       t,b,r : TPixelArray;
begin
   getOverlayRect(bottom,top,xmin,xmax,ymin,ymax);
   //result:=TRasterMap.Create(xmin,ymin,xmax-xmin+1,ymax-ymin+1);
   bLeft := bottom.MLeft;
   tLeft := top.MLeft;
   pc.start;
   for y := ymin to ymax do begin
      if not pc.isActual(trunc(100*(y-ymin)/(ymax-ymin))) then exit;
      t:=TRasterMap(top).getLine(y);
      b:=TRasterMap(bottom).getLine(y);
      r:=TRasterMap(result).getLine(y);
      for x := xmin to xmax do begin
         if t[x-bLeft]<>255 then
            r[x-bLeft]:=round(255*log2(1+b[x-bLeft]/(255-t[x-bLeft]))/8);
      end;
   end;
   pc.finish;
end;

procedure add(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
   var xmin,ymin,xmax,ymax,x,y,bLeft,tLeft : integer;
       t,b,r : TPixelArray;
begin
   getOverlayRect(bottom,top,xmin,xmax,ymin,ymax);
   //result:=TRasterMap.Create(xmin,ymin,xmax-xmin+1,ymax-ymin+1);
   bLeft := bottom.MLeft;
   tLeft := top.MLeft;
   pc.start;
   for y := ymin to ymax do begin
      if not pc.isActual(trunc(100*(y-ymin)/(ymax-ymin))) then exit;
      t:=TRasterMap(top).getLine(y);
      b:=TRasterMap(bottom).getLine(y);
      r:=TRasterMap(result).getLine(y);
      for x := xmin to xmax do begin
         r[x-bLeft]:= min(t[x-bLeft]+b[x-bLeft],255);
      end;
   end;
   pc.finish;
end;

procedure sub(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
   var xmin,ymin,xmax,ymax,x,y,bLeft,tLeft : integer;
       t,b,r : TPixelArray;
begin
   getOverlayRect(bottom,top,xmin,xmax,ymin,ymax);
   //result:=TRasterMap.Create(xmin,ymin,xmax-xmin+1,ymax-ymin+1);
   bLeft := bottom.MLeft;
   tLeft := top.MLeft;
   pc.start;
   for y := ymin to ymax do begin
      if not pc.isActual(trunc(100*(y-ymin)/(ymax-ymin))) then exit;
      t:=TRasterMap(top).getLine(y);
      b:=TRasterMap(bottom).getLine(y);
      r:=TRasterMap(result).getLine(y);
      for x := xmin to xmax do begin
         r[x-bLeft]:= max(b[x-bLeft]-t[x-bLeft],0);
      end;
   end;
   pc.finish;
end;

procedure diff(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
   var xmin,ymin,xmax,ymax,x,y,bLeft,tLeft : integer;
       t,b,r : TPixelArray;
begin
   getOverlayRect(bottom,top,xmin,xmax,ymin,ymax);
   //result:=TRasterMap.Create(xmin,ymin,xmax-xmin+1,ymax-ymin+1);
   bLeft := bottom.MLeft;
   tLeft := top.MLeft;
   pc.start;
   for y := ymin to ymax do begin
      if not pc.isActual(trunc(100*(y-ymin)/(ymax-ymin))) then exit;
      t:=TRasterMap(top).getLine(y);
      b:=TRasterMap(bottom).getLine(y);
      r:=TRasterMap(result).getLine(y);
      for x := xmin to xmax do begin
         if (b[x-bLeft]>t[x-bLeft]) then
            r[x-bLeft]:= b[x-bLeft]-t[x-bLeft]
         else
            r[x-bLeft]:= t[x-bLeft]-b[x-bLeft];
      end;
   end;
   pc.finish;
end;

procedure difference(result, bottom, top : TMap; p: TProperty; pc : TProgressControll);
   var xmin,ymin,xmax,ymax,x,y,bLeft,tLeft : integer;
       t,b,r : TPixelArray;
begin
   getOverlayRect(bottom,top,xmin,xmax,ymin,ymax);
   //result:=TRasterMap.Create(xmin,ymin,xmax-xmin+1,ymax-ymin+1);
   bLeft := bottom.MLeft;
   tLeft := top.MLeft;
   pc.start;
   for y := ymin to ymax do begin
      if not pc.isActual(trunc(100*(y-ymin)/(ymax-ymin))) then exit;
      t:=TRasterMap(top).getLine(y);
      b:=TRasterMap(bottom).getLine(y);
      r:=TRasterMap(result).getLine(y);
      for x := xmin to xmax do begin
         r[x-bLeft]:=max(min(255,b[x-bLeft]-t[x-bLeft]+128),0);
      end;
   end;
   pc.finish;
end;

procedure paralel(result,bottom, top: TMap; p: TProperty; pc : TProgressControll);
   var xmin,ymin,xmax,ymax,x,y,bLeft,tLeft : integer;
       t,b,r : TPixelArray;
begin
   getOverlayRect(bottom,top,xmin,xmax,ymin,ymax);
   //result:=TRasterMap.Create(xmin,ymin,xmax-xmin+1,ymax-ymin+1);
   bLeft := bottom.MLeft;
   tLeft := top.MLeft;
   pc.start;
   for y := ymin to ymax do begin
      if not pc.isActual(trunc(100*(y-ymin)/(ymax-ymin))) then exit;
      t:=TRasterMap(top).getLine(y);
      b:=TRasterMap(bottom).getLine(y);
      r:=TRasterMap(result).getLine(y);
      for x := xmin to xmax do begin
         if (b[x-bLeft]>0) and (t[x-tleft]>0) then
            r[x-bLeft]:= min(max(round(510/(255/b[x-bLeft]+255/t[x-tleft])),0),255)
         else
            r[x-bLeft]:=0;
      end;
   end;
   pc.finish;
end;

procedure darken(result,bottom, top: TMap; p: TProperty; pc : TProgressControll);
   var xmin,ymin,xmax,ymax,x,y,bLeft,tLeft : integer;
       t,b,r : TPixelArray;
begin
   getOverlayRect(bottom,top,xmin,xmax,ymin,ymax);
   //result:=TRasterMap.Create(xmin,ymin,xmax-xmin+1,ymax-ymin+1);
   bLeft := bottom.MLeft;
   tLeft := top.MLeft;
   pc.start;
   for y := ymin to ymax do begin
      if not pc.isActual(trunc(100*(y-ymin)/(ymax-ymin))) then exit;
      t:=TRasterMap(top).getLine(y);
      b:=TRasterMap(bottom).getLine(y);
      r:=TRasterMap(result).getLine(y);
      for x := xmin to xmax do begin
         if (b[x-bLeft]>t[x-tleft]) then
            r[x-bLeft]:= t[x-tleft];
      end;
   end;
   pc.finish;
end;

procedure lighten(result,bottom, top: TMap; p: TProperty; pc : TProgressControll);
   var xmin,ymin,xmax,ymax,x,y,bLeft,tLeft : integer;
       t,b,r : TPixelArray;
begin
   getOverlayRect(bottom,top,xmin,xmax,ymin,ymax);
   //result:=TRasterMap.Create(xmin,ymin,xmax-xmin+1,ymax-ymin+1);
   bLeft := bottom.MLeft;
   tLeft := top.MLeft;
   pc.start;
   for y := ymin to ymax do begin
      if not pc.isActual(trunc(100*(y-ymin)/(ymax-ymin))) then exit;
      t:=TRasterMap(top).getLine(y);
      b:=TRasterMap(bottom).getLine(y);
      r:=TRasterMap(result).getLine(y);
      for x := xmin to xmax do begin
         if (b[x-bLeft]<t[x-tleft]) then
            r[x-bLeft]:= t[x-tleft];
      end;
   end;
   pc.finish;
end;

procedure texture(result,bottom, top : TMap; p: TProperty; pc : TProgressControll);
   var xmin,ymin,xmax,ymax,x,y,bLeft,tLeft : integer;
       t,b,r : TPixelArray;
begin
   getOverlayRect(bottom,top,xmin,xmax,ymin,ymax);
   //result:=TRasterMap.Create(xmin,ymin,xmax-xmin+1,ymax-ymin+1);
   bLeft := bottom.MLeft;
   tLeft := top.MLeft;
   pc.start;
   for y := ymin to ymax do begin
      if not pc.isActual(trunc(100*(y-ymin)/(ymax-ymin))) then exit;
      t:=TRasterMap(top).getLine(y);
      b:=TRasterMap(bottom).getLine(y);
      r:=TRasterMap(result).getLine(y);
      for x := xmin to xmax do begin
         r[x-bLeft]:= max(min(t[x-tleft]+b[x-bLeft]-128,255),0);
      end;
   end;
   pc.finish;
end;

procedure andop(result,bottom, top: TMap; p: TProperty; pc : TProgressControll);
   var xmin,ymin,xmax,ymax,x,y,bLeft,tLeft : integer;
       t,b,r : TPixelArray;
begin
   getOverlayRect(bottom,top,xmin,xmax,ymin,ymax);
   //result:=TRasterMap.Create(xmin,ymin,xmax-xmin+1,ymax-ymin+1);
   bLeft := bottom.MLeft;
   tLeft := top.MLeft;
   pc.start;
   for y := ymin to ymax do begin
      if not pc.isActual(trunc(100*(y-ymin)/(ymax-ymin))) then exit;
      t:=TRasterMap(top).getLine(y);
      b:=TRasterMap(bottom).getLine(y);
      r:=TRasterMap(result).getLine(y);
      for x := xmin to xmax do begin
         r[x-bLeft]:= t[x-tleft] and b[x-bLeft];
      end;
   end;
   pc.finish;
end;

procedure orop(result,bottom, top: TMap; p: TProperty; pc : TProgressControll);
   var xmin,ymin,xmax,ymax,x,y,bLeft,tLeft : integer;
       t,b,r : TPixelArray;
begin
   getOverlayRect(bottom,top,xmin,xmax,ymin,ymax);
   //result:=TRasterMap.Create(xmin,ymin,xmax-xmin+1,ymax-ymin+1);
   bLeft := bottom.MLeft;
   tLeft := top.MLeft;
   pc.start;
   for y := ymin to ymax do begin
      if not pc.isActual(trunc(100*(y-ymin)/(ymax-ymin))) then exit;
      t:=TRasterMap(top).getLine(y);
      b:=TRasterMap(bottom).getLine(y);
      r:=TRasterMap(result).getLine(y);
      for x := xmin to xmax do begin
         r[x-bLeft]:= t[x-tleft] or b[x-bLeft];
      end;
   end;
   pc.finish;
end;

procedure xorop(result,bottom, top: TMap; p: TProperty; pc : TProgressControll);
   var xmin,ymin,xmax,ymax,x,y,bLeft,tLeft : integer;
       t,b,r : TPixelArray;
begin
   getOverlayRect(bottom,top,xmin,xmax,ymin,ymax);
   //result:=TRasterMap.Create(xmin,ymin,xmax-xmin+1,ymax-ymin+1);
   bLeft := bottom.MLeft;
   tLeft := top.MLeft;
   pc.start;
   for y := ymin to ymax do begin
      if not pc.isActual(trunc(100*(y-ymin)/(ymax-ymin))) then exit;
      t:=TRasterMap(top).getLine(y);
      b:=TRasterMap(bottom).getLine(y);
      r:=TRasterMap(result).getLine(y);
      for x := xmin to xmax do begin
         r[x-bLeft]:= t[x-tleft] xor b[x-bLeft];
      end;
   end;
   pc.finish;
end;

end.

// alpha:   bottom = bottom*(255-top_alpha)+top*top_alpha

// 1.  allanon:     bottom = (bottom+top)/2
// 2.  multiply:    bottom = (bottom*top)/255
// 3.  bleach:      bottom =(255-bottom)*(255-top)/255
// 4.  screen :     bottom = 255-((255-bottom)*(255-top)/255)
// 5.  divide:      bottom = bottom / top
// 6.  add:(dodge)  bottom = bottom + top
// 7.  sub:         bottom = bottom - top
// 8.  diff:        bottom = abs(bottom-top)
// 9.  difference   bottom = bottom-top+128
// 10. paralel:     bottom = 510/(255/b+255/t)
// 11. darken:      bottom = min(top,bottom)
// 12. lighten:     bottom = max(bottom,top)
// 13. texture:     bottom = bottom + top - 128
// 14. light:       bottom = (bottom*(255-top)+top*top)/255
// 15. dark:        bottom = (bottom*top+(255-top)*top)/255
// 16. ekvivalence  bottom = 255- abs(bottom-top)
// 17. addSub       bottom = abs(sqr(bottom)-sqr(top))/255
// 18. pitagoras    bottom = sqrt(sqr(bottom)+sqr(top))/sqrt(2)
// 19. arctan       bottom = arctan(2*255*arctan2(top,255-bottom)/pi)
// 20. exclusion    bottom = bottom + top -2*bottom*top/255
// 21. geomMean     bottom = sqrt(bottom*top)
// 22. gamma Dark   bottom = 255*power(bottom/255,top/255)
// 23. gamma Light  bottom = 255*power(bottom/255,255/top)
// 24. burn         bottom = bottom+top-255
// 25. linearLight  bottom = bottom+2*top-256;
// 26. colorDodge   bottom = 255*bottom/(255-top);
// 26. colorBurn    bottom = 255-255*(255-b)/t;
// 27. pinLight     bottom = max(2*top-255,min(bottom,2*top))
// 28. hardLight    bottom = t<128:  2*bottom*top/255
//                           t>=128: 255-2*(255-bottom)*(255-top)/255);
// 29. softLight    bottom = 255*power(bottom/255,power(2,(2*(128-top)/255))))
// 30. vividLight   bottom = t<128:  255-255*(255-bottom)/(2*top)
//                           t>=128: 255*bottom/(2*(255-top))
// 31. overlay      bottom = b<128:  2*bottom*top/255
//                           b>=128: 255-2*(255-bottom)*(255-top)/255);
// 32. andop:       bottom = bottom AND top
// 33. orop:        bottom = bottom OR top
// 34. xorop:       bottom = bottom XOR top
// bottom-scaled noise: a = a + min(a,255-a)*(b-treshold)/max(treshold,255-treshold)
// noise: a = a + (b-treshold);

