unit ImageConstants;

{$MODE Delphi}

interface

uses Map;

type BTType = (BTNormal,BTRaised,BTLowered);
type IconSizeType = (small,medium,large,exLarge,cons);
type TComponentType = (main, red, green, blue);
type TLayerMaps = array[red..blue] of tmap;
type Color = array[red..blue] of byte;

const
   BTNHighLight : Color = (225,225,255);
   BTNShadow  : Color = (0,0,100);
   BTNFace : Color = (220,220,240);
   BTNGlow  : Color = (255,255,255);
   BTNHovered  : Color = (255,192,64);
   BTNSelected  : Color = (100,130,240);
   BTNBlack : Color = (0,60,116);
   BTNBoarderLight : Color = (127,157,185);
   BKGridHighLight : Color = (255,255,255);
   BKGridShadow : Color = (175,175,175);
   HeaderGradLeft : Color = (255,255,255);
//   HeaderGradLeft : Color = (255,255,255);
   HeaderGradRight : Color = (214,215,224);
//   HeaderGradRight : Color = (197,210,240);
   SelHeaderGradLeft : Color = (120,120,145);
//   SelHeaderGradLeft : Color = (1,72,178);
   SelHeaderGradRight : Color = (180,182,200);
//   SelHeaderGradRight : Color = (40,91,197);
   HeaderBK : Color = (190,193,208);
//   HeaderBK : Color = (100,135,220);
   HeaderBoarder : Color = (255,255,255);
//   HeaderBoarder : Color = (255,255,255);
   HeaderWindow : Color = (240,241,245);
//   HeaderWindow : Color = (239,243,255);
   HeaderText : Color = (63,61,61);
//   HeaderText : Color = (33,93,198);
   WinGreenLight : Color = (155,234,156);
   WinGreen : Color = (34,192,32);
   WinGreenDark : Color = (38,124,8);


const IconSizes : array[small..exLarge,1..2] of integer =
((44,33),
 (64,48),
 (80,60),
 (96,72));

type TLayerContainerConstants = class
   FIconWidth : integer;
   FIconHeight : integer;
   procedure setIconSize(val : IconSizeType);
end;

var LCConstants : TLayerContainerConstants;


function RGB(R,G,B:byte):Color;
function ColorToInt(c : Color):integer;

implementation


function RGB(R,G,B:byte):Color;
begin
   Result[red]:=r;
   Result[green]:=g;
   Result[blue]:=b;
end;

function ColorToInt(c : Color):integer;
begin
   result :=  (c[red] and $000000FF) or
              ((c[green] shl 8) and $0000FF00) or
              ((c[blue] shl 16) and $00FF0000);
end;

procedure TLayerContainerConstants.setIconSize(val : IconSizeType);
begin
   FIconWidth := IconSizes[val][1];
   FIconHeight := IconSizes[val][2];
end;

end.
