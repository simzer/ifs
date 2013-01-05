unit basicMap;

{$MODE Delphi}

interface

uses Map;

type TBasicMap = class(TMap)

    Value : integer;
    Constructor Create(NewLeft,NewTop,NewWidth,NewHeight,NewValue:integer);reintroduce;overLoad;
    Constructor Create(im : TMap;NewValue:integer);reintroduce;overLoad;
    function Duplicate:Tmap;override;
    function GetCanvas(NewLeft,NewTop,
              NewWidth,NewHeight:integer):Tmap;override;{not available}
    function GetPixel(x,y:integer):integer;override;
    procedure SetPixel(x,y,pix:integer);override; {not available}
    procedure DrawPixel(x,y,pix:integer);override;{not available}
    function GetAlPixel(x,y:double):integer;override;
    procedure SetAlPixel(x,y:double;pix:integer);override; {not available}
    procedure DrawAlPixel(x,y:double;pix:integer);override;{not available}
end;

implementation

Constructor TBasicMap.Create(NewLeft,NewTop,
              NewWidth,NewHeight,NewValue:integer);
begin
  CanvasReSize(NewLeft,NewTop,NewWidth,NewHeight);
  Value:=NewValue;
end;

Constructor TBasicMap.Create(im : TMap;NewValue:integer);
begin
  CanvasReSize(im.mLeft,im.mTop,im.mWidth,im.mHeight);
  Value:=NewValue;
end;

function TBasicMap.Duplicate:Tmap;
begin
  result:=TBasicMap.Create(MLeft,MTop,MWidth,MHeight,Value);
end;

function TBasicMap.GetCanvas(NewLeft,NewTop,
             NewWidth,NewHeight:integer):Tmap;
begin
  result:=nil;
end;

function TBasicMap.GetPixel(x,y:integer):integer;
begin
  if (((x>=MLeft)and(x<MLeft+MWidth))
   and((y>=MTop)and(y<Mtop+MHeight))) then
   result:=Value else result:=-1;
end;

procedure TBasicMap.SetPixel(x,y,pix:integer);
begin
end;

procedure TBasicMap.DrawPixel(x,y,pix:integer);
begin
end;

function TBasicMap.GetAlPixel(x,y:double):integer;
begin
  if (((x>=MLeft)and(x<MLeft+MWidth))
   and((y>=MTop)and(y<Mtop+MHeight))) then
   result:=Value else result:=-1;
end;

procedure TBasicMap.SetAlPixel(x,y:double;pix:integer);
begin
end;

procedure TBasicMap.DrawAlPixel(x,y:double;pix:integer);
begin
end;

end.

