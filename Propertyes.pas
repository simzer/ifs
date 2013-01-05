unit Propertyes;

{$MODE Delphi}

interface

uses Map,ProgressControll,function1D,ImageConstants;

type TPropertyAttribute = (PABasic,PAAdvanced,PAHidden);

 //-----------
//  Absrtact Property objectum
type TProperty = class
   name : shortString;
   MIsactive : boolean;
   propertyType : integer;
   Attr : TPropertyAttribute;
   WinComponent : TObject;
   onChange : procedure of Object;
   onIsActiveChange : procedure(sender : Tproperty) of Object;
  private
   procedure SetIsActive(val :boolean);
  public
   property IsActive: boolean read MIsactive write SetIsActive;
   function copy : TProperty;reintroduce;virtual;abstract;
   Constructor Create(aName:shortString;aPropertyType:integer);
   function getValue : Variant;reintroduce;virtual;abstract;
   procedure setValue(val : Variant);reintroduce;virtual;abstract;
   function getObject : TObject;reintroduce;virtual;abstract;
   function getFunction : pointer;reintroduce;virtual;abstract;
   // get(pro...) - nem orokli mindegyik osztaly
   function get(propertyName:shortString):TProperty;
end;

type TBlendingFunction = function(bottom, top : TMap; p: TProperty; pc : TProgressControll): TMap;
type TTextureFunction = function(Size:TMap;p : TProperty;pc:TProgressControll):TMap;
type TLayerBlendingFunction = function(bottom, top : TLayerMaps; p: TProperty; pc : TProgressControll):TLayerMaps;

 //-----------
//  Property tarolo objectum
type TContainerProperty = class(TProperty)// propertyType : 0
   properties : array of TProperty;
   activeProperty : TProperty;
   active : integer;
   border : integer;
   width : integer;
   onActiveChange : procedure(sender : Tproperty) of Object;
   Constructor Create(aName:shortString;aProperties : array of TProperty);overload;
   class function Texture(aName:shortString;TextureFunction:TTextureFunction;TextureProperty:array of TProperty):TContainerProperty;
   class function Blending(aName:shortString;BlendingFunction:TBlendingFunction;blendingProperty:array of TProperty):TContainerProperty;
{7}class function TextureContainer(aName:shortString;aProperties : array of TProperty):TContainerProperty;
{8}class function BlendingContainer(aName:shortString;aProperties : array of TProperty):TContainerProperty;
{3}class function MapContainer(aName:shortString;aProperties : array of TProperty):TContainerProperty;
   procedure ActiveChange(sender : Tproperty);
   procedure Change;
   function copy : TProperty;reintroduce;overload;override;
   function get(propertyName:shortString):TProperty;reintroduce;
   function getActive:TProperty;
end;

 //-----------
//   Erteket tarolo objectum
type TValueProperty = class(TProperty)// propertyType : 1
   value : double;
   minValue : double;
   maxValue : double;
   constructor Create(aName:shortString;aValue,min,max:double);overload;
   class function Fraction(aName:shortString;aValue:double):TValueProperty;
   class function Color(aName:shortString;aValue:double):TValueProperty;
   function copy : TProperty;reintroduce;overload;override;
   function getValue : Variant;reintroduce;overload;override;
   procedure setValue(val : Variant);reintroduce;overload;override;
end;

 //-----------
//   1D-s fuggvenyt tarolo objectum
type TFunction1DProperty = class(TProperty)// propertyType : 9
   function1D : TFunction1D;
   constructor Create(aName:shortString;aFunct : TFunction1D);overload;
   function copy : TProperty;reintroduce;overload;override;
   function getObject : TObject;reintroduce;overload;override;
end;

 //-----------
//   Map-et tarolo objectum
type TMapProperty = class(TProperty)// propertyType : 2
   Map : TMap;
   constructor Create(aName:shortString;aMap : TMap);overload;
   function copy : TProperty;reintroduce;overload;override;
   function getObject : TObject;reintroduce;overload;override;
end;

 //-------------
//   BlendingFunction-t tarolo objectum
type TBlendingFunctionProperty = class(TProperty)// propertyType : 4
   blendingFunction : TBlendingFunction;
   constructor Create(aName:shortString;bf:TBlendingFunction);overload;
   function copy : TProperty;reintroduce;overload;override;
   function getFunction : pointer;reintroduce;overload;override;
end;

type TBlendingGroup = array of TBlendingFunctionProperty;

//-------------
//   TextureFunction-t tarolo objectum
type TTextureFunctionProperty = class(TProperty)// propertyType : 5
   textureFunction : TTextureFunction;
   constructor Create(aName:shortString;tf:TTextureFunction);overload;
   function copy : TProperty;reintroduce;overload;override;
   function getFunction : pointer;reintroduce;overload;override;
end;

 //-----------
//   ordinal tarolo objectum
type TOrdinalProperty = class(TProperty)// propertyType : 6
   value : integer;
   strings : array of shortstring;
   constructor Create(aName:shortString;aValue:integer;s:array of ShortString);overload;
   function copy : TProperty;reintroduce;overload;override;
   function getValue : Variant;reintroduce;overload;override;
   procedure setValue(val : Variant);reintroduce;overload;override;
end;


implementation


//-----------
//  Absrtact Property objectum
//-------------------------

Constructor TProperty.Create(aname:shortString;apropertyType:integer);
begin
   name := aName;
   propertyType := aPropertyType;
end;

function TProperty.get(propertyName:shortString):TProperty;
   var i:integer;
begin
   if propertyType = 0 then
      result:=TContainerProperty(self).get(propertyName)
   else
      result:=nil;
end;

procedure TProperty.SetIsActive(val :boolean);
begin
   self.MIsactive:=val;
   if val then
     if assigned(self.onIsactiveChange) then onIsActiveChange(self);
end;

//-----------
//  Property tarolo objectum
//-----------------------

Constructor TContainerProperty.Create(aName:shortString;aProperties : array of TProperty);
   var i,n : integer;
begin
   inherited Create(aName,0);
   setlength(properties,high(aProperties)-low(aProperties)+1);
   active := 0;
   n:=0;
   for i:=low(aProperties) to high(aProperties) do begin
      properties[n] := aProperties[i];
      properties[n].onIsActiveChange := ActiveChange;
      properties[n].onChange := Self.Change;
      if properties[n] is TContainerProperty then
         TContainerProperty(properties[n]).onActiveChange:=ActiveChange;
      inc(n);
   end;
end;

class function TContainerProperty.Texture;
begin
   result:=Create(aName,[
      TTextureFunctionProperty.create('texture',TextureFunction),
      TContainerProperty.Create('properties',TextureProperty)
   ]);
end;

class function TContainerProperty.Blending;
begin
   result:=Create(aName,[
      TBlendingFunctionProperty.create('blending',BlendingFunction),
      TContainerProperty.Create('properties',BlendingProperty)
   ]);
end;

class function TContainerProperty.TextureContainer(aName:shortString;aProperties : array of TProperty):TContainerProperty;
begin
  result:=create(aName,aProperties);
  result.propertyType:=7;
end;

class function TContainerProperty.BlendingContainer(aName:shortString;aProperties : array of TProperty):TContainerProperty;
begin
  result:=create(aName,aProperties);
  result.propertyType:=8;
end;

class function TContainerProperty.MapContainer(aName:shortString;aProperties : array of TProperty):TContainerProperty;
begin
  result:=create(aName,aProperties);
  result.propertyType:=3;
end;

function TContainerProperty.copy : TProperty;
   var p : array of TProperty;
   var i,n : integer;
begin
   setLength(p,high(properties)-low(properties)+1);
   n:=0;
   for i:=low(properties) to high(properties) do begin
      p[n]:=properties[i].copy;
      inc(n);
   end;
   result:=TContainerProperty.Create(name,p);
end;

function TContainerProperty.get(propertyName:shortString):TProperty;
   var i:integer;
begin
   result := nil;
   for i:=low(properties) to high(properties) do begin
      if propertyName=properties[i].name then begin
         result := properties[i];
         exit;
      end;
      if properties[i].propertyType=0 then begin
          Result := TContainerProperty(properties[i]).get(propertyName);
          if Result <> nil then exit;
      end;
   end;
end;

procedure TContainerProperty.Change;
begin
   if Assigned(onChange) then onChange;
end;

procedure TContainerProperty.ActiveChange(sender : Tproperty);
begin
   activeProperty := Sender;
   if Assigned(onActiveChange) then onactiveChange(sender);
end;

function TContainerProperty.getActive:TProperty;
begin
   result := activeProperty;
end;

//-----------
//   Erteket tarolo objectum
//-----------------------

constructor TValueProperty.Create(aName:shortString;aValue,min,max:double);
begin
   inherited Create(aName,1);
   value := aValue;
   minValue := min;
   maxValue := max;
end;

class function TValueProperty.Fraction(aName:shortString;aValue:double):TValueProperty;
begin
   result:=TValueProperty.Create(aName,aValue,0,100);
end;

class function TValueProperty.Color(aName:shortString;aValue:double):TValueProperty;
begin
   result:=TValueProperty.Create(aName,aValue,0,255);
end;

function TValueProperty.copy : TProperty;
begin
   result:=TValueProperty.Create(Name,Value,minValue,maxValue);
end;

function TValueProperty.getValue : Variant;
begin
   result := value;
end;

procedure TValueProperty.setValue(val : Variant);
begin
   if (val>=minValue) and (val<=maxValue) and (val <> value) then begin
      value := val;
      if assigned(onChange) then onChange;
   end;
end;

//-----------
//   Ordinal-t tarolo objectum
//-----------------------

constructor TOrdinalProperty.Create(aName:shortString;aValue:integer;s:array of shortString);
   var i,n : integer;
begin
   inherited Create(aName,6);
   value := aValue;
   n:=0;
   for i:=low(s) to high(s) do begin
      setLength(strings,length(strings)+1);
      strings[n] := s[i];
      inc(n);
   end;
end;

function TOrdinalProperty.copy : TProperty;
   var s: array of shortString;
begin
   result:=TOrdinalProperty.Create(Name,Value,strings);
end;

function TOrdinalProperty.getValue : Variant;
begin
   result := value;
end;

procedure TOrdinalProperty.setValue(val : Variant);
begin
   if val <> value then begin
      value := val;
      if assigned(onChange) then onChange;
   end;
end;

//-----------
//   Map-et tarolo objectum
//-----------------------

constructor TMapProperty.Create(aName:shortString;aMap : TMap);
begin
   inherited Create(aName,2);
   map := aMap;
end;

function TMapProperty.copy : TProperty;
begin
   result:=TMapProperty.Create(name,map);
end;

function TMapProperty.getObject : TObject;
begin
   result := map;
end;

//-------------
//   1D-s fuggvenyt tarolo objectum
//------------------------------

constructor TFunction1DProperty.Create(aName:shortString;aFunct : TFunction1D);
begin
   inherited Create(aName,9);
   self.function1D := afunct;
end;

function TFunction1DProperty.copy : TProperty;
begin
   result:=TFunction1DProperty.Create(name,function1D);
end;

function TFunction1DProperty.getObject : TObject;
begin
   result:=self.function1D;
end;

//-------------
//   Blendinget tarolo objectum
//------------------------------

constructor TBlendingFunctionProperty.Create(aName:shortString;bf:TBlendingFunction);
begin
   inherited Create(aName,4);
   blendingFunction := bf;
end;

function TBlendingFunctionProperty.copy : TProperty;
begin
   result := TBlendingFunctionProperty.Create(name,blendingFunction);
end;

function TBlendingFunctionProperty.getFunction : pointer;
begin
   result:=@blendingFunction;
end;

//-------------
//   Texturat tarolo objectum
//------------------------------

constructor TTextureFunctionProperty.Create(aName:shortString;tf:TTextureFunction);
begin
   inherited Create(aName,4);
   textureFunction := tf;
end;

function TTextureFunctionProperty.copy : TProperty;
begin
   result := TTextureFunctionProperty.Create(name,TextureFunction);
end;

function TTextureFunctionProperty.getFunction : pointer;
begin
   result:=@TextureFunction;
end;

end.
