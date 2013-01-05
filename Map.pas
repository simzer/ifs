unit map;

{$MODE Delphi}

interface

type TMap = class
    MLeft:integer;
    MTop:integer;
    MWidth:integer;
    MHeight:Integer;

    constructor Create(NewLeft,NewTop,
              NewWidth,NewHeight:integer);reintroduce;virtual;Abstract;

    procedure getRect(var xmin,xmax,ymin,ymax:integer);
    function isPixel(x,y:double):boolean;
    function Duplicate:TMap;reintroduce;virtual;Abstract;
    function GetCanvas(NewLeft,NewTop,
              NewWidth,NewHeight:integer):Tmap;
              reintroduce;virtual;Abstract;

    Procedure Move(NewLeft,NewTop:integer);
    Procedure Size(NewWidth,NewHeight:integer);
    Procedure CanvasReSize(NewLeft,NewTop,
                           NewWidth,NewHeight:integer);

    function GetPixel(x,y:integer):integer;reintroduce;virtual;Abstract;
    procedure SetPixel(x,y,pix:integer);reintroduce;virtual;Abstract;
    procedure DrawPixel(x,y,pix:integer);reintroduce;virtual;Abstract;
    function GetAlPixel(x,y:double):integer;reintroduce;virtual;Abstract;
    function GetTiledPixel(x,y:integer):integer;reintroduce;virtual;Abstract;
    function GetAlTiledPixel(x,y:double):integer;reintroduce;virtual;Abstract;
    function GetLimitedPixel(x,y:integer):integer;reintroduce;virtual;Abstract;
    function GetAlLimitedPixel(x,y:double):integer;reintroduce;virtual;Abstract;
    procedure SetAlPixel(x,y:double;pix:integer);reintroduce;virtual;Abstract;
    procedure DrawAlPixel(x,y:double;pix:integer);reintroduce;virtual;Abstract;
    procedure sizeUpdate(var minx,miny,maxx,maxy:integer;check:boolean);reintroduce;virtual;Abstract;
    procedure resize(NewLeft,NewTop,NewWidth,NewHeight, mode:integer);reintroduce;virtual;Abstract;
end;

implementation

function TMap.isPixel(x,y:double):boolean;
begin
  if (((x>=Mleft) and (x<MLeft+MWidth)) and
      ((y>=MTop)  and (y<MTop+MHeight))) then
       result:=true
     else
       result:=false;
end;

procedure TMap.getRect(var xmin,xmax,ymin,ymax:integer);
begin
   xmin:=MLeft;
   xmax:=MLeft+Mwidth-1;
   ymin:=MTop;
   ymax:=MTop+MHeight-1;
end;

Procedure TMap.Move(NewLeft,NewTop:integer);
begin
  Mleft:=NewLeft;
  MTop:=NewTop;
end;

Procedure TMap.Size(NewWidth,NewHeight:integer);
begin
  MWidth:=NewWidth;
  Mheight:=NewHeight;
end;

Procedure TMap.CanvasReSize(NewLeft,NewTop,
                           NewWidth,NewHeight:integer);
begin
  Mleft:=NewLeft;
  MTop:=NewTop;
  MWidth:=NewWidth;
  Mheight:=NewHeight;
end;

end.
