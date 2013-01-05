unit MapAccessories;

{$MODE Delphi}

interface

uses Map,Math;

function checkOverlay(bottom,top:Tmap) : boolean;overload;
function checkOverlay(bottom,top,mask:Tmap) : boolean;overload;
procedure getOverlayRect(bottom,top:Tmap;var xmin,xmax,ymin,ymax : integer);overload;
procedure getOverlayRect(bottom,top,mask:Tmap;var xmin,xmax,ymin,ymax : integer);overload;

implementation

function checkOverlay(bottom,top:Tmap) : boolean;
begin
        if (bottom.MLeft+bottom.MWidth-1 < top.MLeft) then result := false
        else
        if (top.MLeft+top.MWidth-1 < bottom.MLeft) then result := false
        else
        if (bottom.MTop+bottom.MHeight-1 < top.MTop) then result := false
        else
        if (top.MTop+top.MHeight-1 < bottom.MTop) then result := false
        else
        result := true;
end;

function checkOverlay(bottom,top,mask:Tmap) : boolean;
begin
   if mask = nil then
      result := checkOverlay(bottom,top)
   else
      result:= checkOverlay(bottom,top)
           and checkOverlay(bottom,mask)
           and checkOverlay(mask,top);
end;

// Gets the area of overlay
procedure getOverlayRect(bottom,top:Tmap;var xmin,xmax,ymin,ymax : integer);
begin
      if checkOverlay(bottom,top) then begin
         xmin := max(bottom.MLeft,top.MLeft);
         ymin := max(bottom.MTop,top.MTop);
         xmax := min(bottom.MLeft+bottom.MWidth,top.MLeft+top.MWidth)-1;
         ymax := min(bottom.MTop+bottom.MHeight,top.MTop+top.MHeight)-1;
      end else begin
         xmin := 0;
         ymin := 0;
         xmax := -1;
         ymax := -1;
      end;
end;

procedure getOverlayRect(bottom,top,mask:Tmap;var xmin,xmax,ymin,ymax : integer);
begin
   if (top=nil) or (bottom=nil) then begin
      if mask<>nil then begin
         if top = nil then getOverLayRect(bottom,mask,xmin,xmax,ymin,ymax);
         if bottom = nil then getOverLayRect(mask,top,xmin,xmax,ymin,ymax);
      end else begin
         if top = nil then getOverLayRect(bottom,bottom,xmin,xmax,ymin,ymax);
         if bottom = nil then getOverLayRect(top,top,xmin,xmax,ymin,ymax);
      end;
      exit;
   end;
   getOverLayRect(bottom,top,xmin,xmax,ymin,ymax);
   if mask <> nil then begin
      if checkOverlay(bottom,top,mask) then begin
         xmin := max(mask.MLeft,xmin);
         ymin := max(mask.MTop,ymin);
         xmax := min(mask.MLeft+mask.MWidth,xmax+1)-1;
         ymax := min(mask.MTop+mask.MHeight,ymax+1)-1;
      end;
   end;
end;

end.
