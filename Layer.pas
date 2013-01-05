unit Layer;

{$MODE Delphi}

interface

uses Map,rasterMap,BasicMap,SimpleMaps,Blending,Propertyes,ProgressControll,BaseTypes,ImageConstants;

type TLayer = class
  private
    MOpacity : array[main..blue] of integer;
    Mvisible : array[main..blue] of boolean;
    Mselected : array[main..blue] of boolean;
    MSubOpened : boolean;
    procedure setSubOpened(value : boolean);
    function getOpacity(Index: TComponentType): integer;
    procedure setOpacity(Index: TComponentType; Value: integer);
    function getVisible(Index: TComponentType): boolean;
    procedure setVisible(Index: TComponentType; Value:  boolean);
    function getSelected(Index: TComponentType): boolean;
    procedure setSelected(Index: TComponentType; Value:  boolean);
    function MWidth:integer;
    function MHeight:integer;
    function MLeft:integer;
    function MTop:integer;
  public
    name : string;
    SubLayers : Array of TLayer;
    Parent : TLayer;
    OnChange : procedure of Object;
    OnSelect : procedure of Object;
    OnVisible : procedure of Object;
    OnOpen : procedure of Object;
    OnParentChange : procedure of Object;
    OnSelectedLayerChange : procedure of Object;
    OnLayerSelect : procedure of Object;
    colorMap : TLayerMaps;
    alphaMap : TLayerMaps;
    mainBlending : TLayerBlendingFunction;
    blending : array[red..blue] of TBlendingFunction;
    blendingProperty : array[main..blue] of TProperty;
    lock : array[main..blue] of boolean;
    WinComponent : TObject;
    constructor create;overload;
    constructor create(im : TLayer);overload;
    constructor createEmpty(im : TLayer);
    constructor create(l,t,w,h:integer);overload;
    constructor CreateIMG(w,h:integer);overload;
    constructor CreateIMG(w,h,a:integer);overload;
    constructor CreateBkIMG(w,h:integer);
    class function createImage(Left,Top,Width,Height : integer;
                               name:String;BKColor : Color):TLayer;
    function GetCanvas(NewLeft,NewTop,NewWidth,NewHeight:integer):TLayer;
    Procedure sizeUpdate;
    procedure init;
    Procedure Render(im : TLayer;pc : TProgressControll);
    procedure resize(NewLeft,NewTop,NewWidth,NewHeight,mode:integer);
    function Duplicate:TLayer;
    procedure Free;
    procedure pasteBlending(blend : TBlendingFunction; blendProp : TProperty);overload;
    procedure pasteBlending(blend : TBlendingFunction; blendProp : TProperty; comp : TComponentType);overload;
    procedure pasteBlending(blend : TLayerBlendingFunction; blendProp : TProperty);overload;
    procedure pasteBlending(source : TLayer);overload;
    procedure pasteLayer(layer : TLayer;index : integer);
    procedure delLayer(layer : TLayer);
    function cutlayer(layer : TLayer):TLayer;
    procedure newLayer(index : integer);
    procedure setParent(parent : TLayer;index : integer);
    function index : integer;
    procedure moveTo(mainIndex : integer;subIndex : integer);
    class function getIndexedLayer(layer:TLayer;mainIndex:integer):TLayer;
    function MainIndex : integer;
    function SubIndex : integer;
    function MainLayer:TLayer;
    function getSelectedLayer : TLayer;
    function IsParent(maybeparent : TLayer):boolean;
    property opacity[Index: TComponentType]: integer read getOpacity write setOpacity;
    property visible[Index: TComponentType]: boolean read getVisible write setVisible;
    property selected[Index: TComponentType]: boolean read getSelected write setSelected;
  published
    property Left : integer read MLeft;
    property Top : integer read MTop;
    property Width : integer read MWidth;
    property Height : integer read MHeight;
    property subOpened : boolean read MSubOpened write setSubOpened;
    property color1:TMap read colorMap[red] write colorMap[red];
    property color2:TMap read colorMap[green] write colorMap[green];
    property color3:TMap read colorMap[blue] write colorMap[blue];
    property alpha1:TMap read alphaMap[red] write alphaMap[red];
    property alpha2:TMap read alphaMap[green] write alphaMap[green];
    property alpha3:TMap read alphaMap[blue] write alphaMap[blue];
end;

implementation

constructor TLayer.Create;
begin
   init;
end;

procedure TLayer.init;
   var t : TComponentType;
begin
   for t:=main to blue do begin
      if t<>main then begin
         blending[t] := none;
      end;
      MOpacity[t] := 100;
      selected[t] := false;
      lock[t]:=true;
      visible[t]:=true;
      blendingProperty[t]:=nil;
   end;
   mainBlending := nil;
end;

class function TLayer.createImage(Left,Top,Width,Height : integer;
                                  name:String; BKColor : Color):TLayer;
   var t : TComponentType;
begin
   result := TLayer.create;
   result.name:=name;
   result.Parent:=nil;
   for t:=red to blue do begin
      result.colorMap[t]:=TBasicMap.Create(Left,Top,Width,Height,BKColor[t]);
      result.alphaMap[t]:=TBasicMap.Create(Left,Top,Width,Height,255);
   end;
end;

procedure TLayer.Render;
   var i : integer;
       tempMap : TMap;
       tempMaps : TLayerMaps;
       SubRenderedLayer : TLayer;
       t:TComponentType;
begin
   if visible[main] then begin
      if SubLayers<>nil then
         SubRenderedLayer := self.Duplicate
      else
         SubRenderedLayer := self;
      for i:=high(SubLayers) downto low(SubLayers) do
         Sublayers[i].Render(SubRenderedLayer,pc);
      if assigned(mainBlending) then begin
         tempMaps := MainBlending(im.colormap,SubRenderedLayer.colorMap,blendingProperty[main],pc);
         for t:=red to blue do
            if visible[t] then begin
               alpha(im.colorMap[t],tempMaps[t],im.alphaMap[t],SubRenderedLayer.alphaMap[t],opacity[t]);
               tempMaps[t].Free;
            end;
      end else begin
         for t:=red to blue do
            if visible[t] then begin
               tempMap := Blending[t](im.colormap[t],SubRenderedLayer.colorMap[t],blendingProperty[t],pc);
               alpha(im.colorMap[t],tempMap,im.alphaMap[t],SubRenderedLayer.alphaMap[t],opacity[t]);
               tempMap.Free;
            end;
      end;
      if SubRenderedLayer <> self then SubRenderedLayer.Free;
   end;
end;

procedure TLayer.Free;
   var t:TComponentType;
       i : integer;
begin
   for i:=low(SubLayers) to high(SubLayers) do begin
      SubLayers[i].Free;
   end;
   SubLayers:=nil;
   blendingProperty[main].Free;
   for t:=red to blue do begin
      colorMap[t].Free;
      alphaMap[t].Free;
      blendingProperty[t].Free;
   end;
   inherited Free;
end;

procedure TLayer.sizeUpdate;
   var xmin,xmax,ymin,ymax:integer;
begin
   alpha1.sizeUpdate(xmin,ymin,xmax,ymax,true);
   color1.sizeUpdate(xmin,ymin,xmax,ymax,false);
   alpha2.sizeUpdate(xmin,ymin,xmax,ymax,true);
   color2.sizeUpdate(xmin,ymin,xmax,ymax,false);
   alpha3.sizeUpdate(xmin,ymin,xmax,ymax,true);
   color3.sizeUpdate(xmin,ymin,xmax,ymax,false);
end;

function TLayer.GetCanvas(NewLeft,NewTop,
              NewWidth,NewHeight:integer):TLayer;
begin
   Result:=TLayer.create;
   Result.color1:=color1.GetCanvas(NewLeft,NewTop,NewWidth,NewHeight);
   Result.color2:=color2.GetCanvas(NewLeft,NewTop,NewWidth,NewHeight);
   Result.color3:=color3.GetCanvas(NewLeft,NewTop,NewWidth,NewHeight);
   Result.alpha1:=alpha1.GetCanvas(NewLeft,NewTop,NewWidth,NewHeight);
   Result.alpha2:=alpha2.GetCanvas(NewLeft,NewTop,NewWidth,NewHeight);
   Result.alpha3:=alpha3.GetCanvas(NewLeft,NewTop,NewWidth,NewHeight);
end;

constructor TLayer.create(l,t,w,h:integer);
begin
  color1 := TRasterMap.create(l,t,w,h);
  color2 := TRasterMap.create(l,t,w,h);
  color3 := TRasterMap.create(l,t,w,h);
  alpha1 := TRasterMap.create(l,t,w,h);
  alpha2 := TRasterMap.create(l,t,w,h);
  alpha3 := TRasterMap.create(l,t,w,h);
  init;
end;

constructor TLayer.create(im : TLayer);
begin
  color1 := TRasterMap.create(im.color1);
  color2 := TRasterMap.create(im.color2);
  color3 := TRasterMap.create(im.color3);
  alpha1 := im.alpha1.duplicate;
  alpha2 := im.alpha2.duplicate;
  alpha3 := im.alpha3.duplicate;
  init;
end;

constructor TLayer.createEmpty(im : TLayer);
begin
  color1 := TRasterMap.create(im.color1);
  color2 := TRasterMap.create(im.color2);
  color3 := TRasterMap.create(im.color3);
  alpha1 := TRasterMap.create(im.alpha1);
  alpha2 := TRasterMap.create(im.alpha2);
  alpha3 := TRasterMap.create(im.alpha3);
  init;
end;

constructor TLayer.CreateIMG(w,h:integer);
begin
  color1 := TRasterMap.create(0,0,w,h);
  color2 := TRasterMap.create(0,0,w,h);
  color3 := TRasterMap.create(0,0,w,h);
  alpha1 := TRasterMap.create(0,0,w,h);
  alpha2 := TRasterMap.create(0,0,w,h);
  alpha3 := TRasterMap.create(0,0,w,h);
  static(alpha1,
         TContainerProperty.Create('static',
         [TValueProperty.Color('Color',255)]),
         TProgressControll.Create(nil,nil));
  static(alpha2,
         TContainerProperty.Create('static',
         [TValueProperty.Color('Color',255)]),
         TProgressControll.Create(nil,nil));
  static(alpha3,
         TContainerProperty.Create('static',
         [TValueProperty.Color('Color',255)]),
         TProgressControll.Create(nil,nil));
  init;
end;

// Made by esth
constructor TLayer.CreateIMG(w,h,a:integer);
  var i, j : integer;
  Ra,Ga,Ba : TPixelArray;
begin
  color1 := TRasterMap.create(0,0,w,h);
  color2 := TRasterMap.create(0,0,w,h);
  color3 := TRasterMap.create(0,0,w,h);
  alpha1 := TRasterMap.create(0,0,w,h);
  alpha2 := TRasterMap.create(0,0,w,h);
  alpha3 := TRasterMap.create(0,0,w,h);
  init;
  for j:=0 to color1.MHeight-1 do begin
    Ra:=TRasterMap(self.AlphaMap[red]).getline(j);
    Ga:=TRasterMap(self.AlphaMap[green]).getline(j);
    Ba:=TRasterMap(self.AlphaMap[blue]).getline(j);
    for i:=0 to color1.MWidth-1 do begin
            Ra[i]:=a;
            Ga[i]:=a;
            Ba[i]:=a;
    end;
  end;
end;

constructor TLayer.CreateBkIMG(w,h:integer);
begin
   color1 := TBasicMap.create(0,0,w,h,0);
   color2 := TBasicMap.create(0,0,w,h,0);
   color3 := TBasicMap.create(0,0,w,h,0);
   alpha1 := TBasicMap.create(0,0,w,h,0);
   alpha2 := alpha1;
   alpha3 := alpha1;
   init;
end;

// mode - a resamplig módja, jelenleg nincs implemetálva a választhatóság
procedure TLayer.resize(NewLeft,NewTop,NewWidth,NewHeight,mode:integer);
   var i : integer;
   t:TComponentType;
begin
   for t:=red to blue do
      if t<>main then begin
        self.colorMap[t].resize(NewLeft,NewTop,NewWidth,NewHeight,mode);
        self.alphaMap[t].resize(NewLeft,NewTop,NewWidth,NewHeight,mode);
      end;
    for i:=low(self.SubLayers) to high(self.SubLayers) do
      self.SubLayers[i].resize(NewLeft,NewTop,NewWidth,NewHeight,mode);
end; // of resize

function TLayer.Duplicate:TLayer;
   var t:TComponentType;
       i:integer;
begin
   result:=TLayer.create;
   result.Parent := Parent;
   result.name := name + ' copy';
   result.mainBlending:=mainBlending;
   for t:=red to blue do begin
      if t<>main then begin
        result.colorMap[t]:=colorMap[t].Duplicate;
        result.alphaMap[t]:=alphaMap[t].Duplicate;
        result.blending:=blending;
      end;
      result.MOpacity[t] := MOpacity[t];
      if BlendingProperty[t]<>nil then
         result.blendingProperty[t]:=BlendingProperty[t].copy
      else
         result.blendingProperty[t]:=nil;
      result.visible[t]:=visible[t];
      result.lock[t]:=lock[t];
      result.selected[t]:=selected[t];
   end;
   setLength(result.SubLayers,length(Sublayers));
   for i:=low(SubLayers) to high(SubLayers) do
      result.SubLayers[i]:=subLayers[i].Duplicate;
end;

function TLayer.getOpacity(Index: TComponentType): integer;
begin
   result:=self.MOpacity[index];
end;

procedure TLayer.setOpacity(Index: TComponentType; Value: integer);
   var t:TComponentType;
begin
   if value<>MOpacity[t] then begin
      if index = main then begin
         for t:=main to blue do MOpacity[t] := value;
      end else begin
         MOpacity[index] := value;
      end;
      if assigned(MainLayer.OnSelectedLayerChange) then MainLayer.OnSelectedLayerChange;
   end;
end;

procedure TLayer.pasteBlending(source : TLayer);
   var i:TComponentType;
begin
   for i:=main to blue do begin
      opacity[i] := source.opacity[i];
      blendingProperty[i].Free;
      blendingProperty[i] := source.blendingProperty[i].copy;
      if i<>main then blending[i]:= source.blending[i];
   end;
   mainBlending := source.mainBlending;
end;

procedure TLayer.pasteBlending(blend : TLayerBlendingFunction; blendProp : TProperty);
   var i:TComponentType;
begin
   for i:=main to blue do begin
      blendingProperty[i].Free;
      blendingProperty[i] := nil;
   end;
   blending[red]:=nil;
   blending[green]:=nil;
   blending[blue]:=nil;
   blendingProperty[main]:=blendProp;
   mainBlending := blend;
end;

procedure TLayer.pasteBlending(blend : TBlendingFunction; blendProp : TProperty);
   var i:TComponentType;
begin
   mainBlending := nil;
   for i:=main to blue do begin
      blendingProperty[i].Free;
      blendingProperty[i] := nil;
   end;
   blending[red]:=blend;
   blending[green]:=blend;
   blending[blue]:=blend;
   blendingProperty[red]:=blendProp;
   blendingProperty[green]:=blendProp;
   blendingProperty[blue]:=blendProp;
end;

procedure TLayer.pasteBlending(blend : TBlendingFunction; blendProp : TProperty; comp : TComponentType);
begin
  if @MainBlending<>nil then
      pasteBlending(blend,blendProp)
   else begin
      blending[comp]:=blend;
      blendingProperty[comp].free;
      blendingProperty[comp]:=nil;
      blendingProperty[comp]:=blendProp;
   end;
end;

function TLayer.getSelectedLayer : TLayer;
   var i:integer;
begin
   result := nil;
   if self.selected[main] then result:=self
   else
      for i:=low(sublayers) to high(subLayers) do begin
         result:=subLayers[i].getSelectedLayer;
         if result<>nil then exit;
      end;
end;

function TLayer.index : integer;
   var i : integer;
begin
   result:=-1;
   if parent <> nil then
      for i := low(parent.sublayers) to high(parent.subLayers) do
         if parent.sublayers[i]=self then begin
            result:=i;
            exit;
         end;
end;

function TLayer.IsParent(maybeparent : TLayer):boolean;
begin
   if (parent = maybeParent) then result:=true
   else
      if parent<>nil then
         result:= parent.IsParent(maybeParent)
      else
         result:=False;
end;

procedure TLayer.pasteLayer(layer : TLayer;index : integer);
   var i : integer;
begin
   setlength(subLayers,length(subLayers)+1);
   for i := high(subLayers) downto index +1 do
      subLayers[i]:=subLayers[i-1];
   subLayers[index] := layer;
   layer.Parent:=self;
   subOpened := true;
end;

procedure TLayer.delLayer(layer : TLayer);
   var i : integer;
begin
   for i := layer.index to high(subLayers)-1 do
      subLayers[i]:=subLayers[i+1];
   setlength(sublayers,length(sublayers)-1);
   layer.Free;
   if length(sublayers)=0 then subOpened := false;
end;

function TLayer.cutlayer(layer : TLayer):TLayer;
   var i : integer;
begin
   for i := layer.index to high(subLayers)-1 do
      subLayers[i]:=subLayers[i+1];
   setlength(sublayers,length(sublayers)-1);
   result := layer;
   if length(sublayers)=0 then subOpened := false;
end;

procedure TLayer.newLayer(index : integer);
   var i : integer;
begin
   setlength(subLayers,length(subLayers));
   for i := high(subLayers) downto index +1 do
      subLayers[i]:=subLayers[i-1];
   subLayers[index] := TLayer.create;
   subLayers[index].Parent:=self;
   subOpened := true;
end;

procedure TLayer.setParent;
begin
   if (self.Parent <> parent) or (self.index<>index) then begin
      if self.Parent <> nil then self.Parent.cutLayer(self);
      parent.pasteLayer(self,index);
      self.MainLayer.selected[main] := false;
      self.selected[main]:=true;
      if assigned(OnParentChange) then OnParentChange;
      if assigned(MainLayer.OnSelectedLayerChange) then MainLayer.OnSelectedLayerChange;      
   end;
end;

function TLayer.getVisible(Index: TComponentType): boolean;
begin
   result := MVisible[index];
end;

procedure TLayer.setVisible(Index: TComponentType; Value:  boolean);
begin
   if MVisible[index] <> value then begin
      MVisible[index] := value;
      if assigned(OnVisible) then OnVisible;
      if assigned(MainLayer.OnSelectedLayerChange) then MainLayer.OnSelectedLayerChange;
   end;
end;

function TLayer.getSelected(Index: TComponentType): boolean;
begin
   result := MSelected[index];
end;

procedure TLayer.setSelected(Index: TComponentType; Value:  boolean);
  var i:integer;
begin
   if MSelected[index] <> value then begin
      MSelected[index] := value;
      if assigned(OnSelect) then OnSelect;
      if value then
         if assigned(MainLayer.onLayerSelect) then MainLayer.onLayerSelect;
   end;
   if value=false then
      for i:=low(subLayers) to high(SubLayers) do
          subLayers[i].selected[index]:=value;
end;

procedure TLayer.setSubOpened(value : boolean);
begin
   if MSubOpened <> value then begin
      MSubOpened := value;
      if assigned(OnOpen) then OnOpen;
   end;
end;

function TLayer.MainLayer:TLayer;
begin
   if parent = nil then
      result := self
   else
      result := parent.MainLayer;
end;

function TLayer.MWidth:integer;
   var left:integer;
begin
   left:=MLeft;
   result:=color1.MWidth+color1.MLeft-left;
   if color2.MWidth+color2.MLeft-left>result then
      result:=color2.MWidth+color2.MLeft-left;
   if color3.MWidth+color3.MLeft-left>result then
      result:=color3.MWidth+color3.MLeft-left;
end;

procedure TLayer.moveTo(mainIndex : integer;subIndex : integer);
   var prev : TLayer;
       si,i : integer;
begin
   prev := TLayer.getIndexedLayer(self,self.MainIndex-1);
   si:=prev.SubIndex;
   if SubIndex > si then begin
      self.setParent(prev,0);
   end else begin
      for i := si-1 downto subindex do prev := prev.Parent;
      self.setParent(prev.Parent,prev.index+1);
   end;
end;

class function TLayer.getIndexedLayer(layer:TLayer;mainIndex:integer):TLayer;
   var back : boolean;
       res : integer;
begin
   res:=0;
   back := false;
   result:=layer.MainLayer;
   while res<>mainIndex do begin
      if (result.SubLayers<>nil) and (not Back) then begin
         result:=result.SubLayers[0];
         inc(res);
      end else begin
         if result.Parent<>nil then begin
            if result.index<high(result.Parent.subLayers) then begin
               result := result.Parent.subLayers[result.index+1];
               back := false;
               inc(res);
            end else begin
               result := result.Parent;
               back := true;
            end;
         end else begin
            res := mainIndex;
            result:=nil;
         end;
      end;
   end;
end;

function TLayer.MainIndex : integer;
   var l:TLayer;
       back : boolean;
begin
   result:=0;
   back := false;
   l:=self.MainLayer;
   while l<>self do begin
      if (l.SubLayers<>nil) and (not Back) then begin
         l:=l.SubLayers[0];
         inc(result);
      end else begin
         if l.Parent<>nil then begin
            if l.index<high(l.Parent.subLayers) then begin
               l := l.Parent.subLayers[l.index+1];
               back := false;
               inc(result);
            end else begin
               l := l.Parent;
               back := true;
            end;
         end else begin
            result := -1;
            l:=self;
         end;
      end;
   end;
end;

function TLayer.SubIndex : integer;
   var l:TLayer;
begin
   result:=0;
   l := self;
   while (l.parent <> nil) do begin
      inc(result);
      l:=l.Parent;
   end;
end;
 
function TLayer.MHeight:integer;
   var Top:integer;
begin
   Top:=MTop;
   result:=color1.MHeight+color1.MTop-Top;
   if color2.MHeight+color2.MTop-Top>result then
      result:=color2.MHeight+color2.MTop-Top;
   if color3.MHeight+color3.MTop-Top>result then
      result:=color3.MHeight+color3.MTop-Top;
end;

function TLayer.MLeft:integer;
begin
     result:=Color2.MLeft;
     if color1.MLeft<result then result:=Color1.MLeft;
     if color3.Mleft<result then result:=Color3.MLeft;
end;

function TLayer.MTop:integer;
begin
   result:=Color2.MTop;
   if color1.MTop<result then result:=Color1.MTop;
   if color3.MTop<result then result:=Color3.MTop;
end;

end.
