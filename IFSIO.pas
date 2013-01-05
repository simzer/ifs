unit IFSIO;

{$MODE Delphi}


interface

uses IFS, SysUtils, IFSDistort;

Procedure SaveIFS(filename : string; IFS : CGModel);
function LoadIFS(filename : string; cg : CGModel):CGModel;

implementation

Procedure SaveIFS(filename : string; IFS : CGModel);
   var f : textfile;
       i,j:integer;
       ch:char;
begin
  with IFS do begin
   ch:=decimalseparator;
   decimalseparator:=',';
   assignfile(f,filename);
   rewrite(f);
   writeln(f,'i-Mage Iterated Function System (IFS) format for i-Mage IFS Builder');
   writeln(f,'Parameters:');
   writeln(f,'Combinated distort function count:');
   writeln(f,inttostr(Conbination));
   writeln(f,'function''s number:');
   writeln(f,FormatFloat('0.0000',functionnum));
   writeln(f,'Centralize:');
   writeln(f,FormatFloat('0.0000',centralize));
   writeln(f,'Curve:');
   writeln(f,FormatFloat('0.0000',curved));
   writeln(f,'Field width:');
   writeln(f,inttostr(Width));
   writeln(f,'Field height:');
   writeln(f,inttostr(height));
   writeln(f,'Iteration:');
   writeln(f,inttostr(iteration));
   writeln(f,'Density:');
   writeln(f,FormatFloat('0.0000',density));
   writeln(f,'Distortion type:');
   writeln(f,inttostr(distorType));
   writeln(f,'Gamma Correction:');
   writeln(f,FormatFloat('0.0000',GammaCorrection));
   writeln(f,'Rotation angle:');
   writeln(f,FormatFloat('0.0000',angle));
   writeln(f,'Angled array:');
   writeln(f,FormatFloat('0.0000',angledarray));
   writeln(f,'x scale');
   writeln(f,FormatFloat('0.0000',xScale));
   writeln(f,'y scale');
   writeln(f,FormatFloat('0.0000',YScale));
   writeln(f,'x offset');
   writeln(f,FormatFloat('0.0000',XOffset));
   writeln(f,'y offset');
   writeln(f,FormatFloat('0.0000',YOffset));
   writeln(f,'Function number:');
   writeln(f,length(a));
   for i:=0 to high(a) do begin
      Writeln(f,inttoStr(i)+'. function`s weights:');
      for j:=0 to 11 do writeln(f,FormatFloat('0.0000',a[i,j]));
   end;
   writeln(f,'Function`s Color (R,G,B):');
   For i:=0 to high(a) do begin
      Writeln(f,inttostr(c[i,0]));
      Writeln(f,inttostr(c[i,1]));
      Writeln(f,inttostr(c[i,2]));
   end;
   writeln(f,'Distort function`s for combine:');
   For i:=0 to 9 do begin
      Writeln(f,inttostr(daFunctions[i]));
   end;
   writeln(f,'Distort function`s weights (x,y) for combine:');
   For i:=1 to 27 do begin
      Writeln(f,FormatFloat('0.0000',da[i].x));
      Writeln(f,FormatFloat('0.0000',da[i].y));
   end;
   writeln(f,'Distort function`s Weights:');
   For i:=0 to 2 do begin
      Writeln(f,FormatFloat('0.0000',distortWeights[0][i]));
   end;
   writeln(f,'Symmetry Horizontal:');
   writeln(f,FormatFloat('0.0000',symmetryHor));
   writeln(f,'Symmetry Vertical:');
   writeln(f,FormatFloat('0.0000',symmetryVer));
   writeln(f,'Background Color (Red,Green,Blue):');
   writeln(f,inttoStr(bckColor.red));
   writeln(f,inttoStr(bckColor.green));
   writeln(f,inttoStr(bckColor.blue));
   writeln(f,'Foreground Color (Red,Green,Blue,alpha):');
   writeln(f,inttoStr(Color.red));
   writeln(f,inttoStr(Color.green));
   writeln(f,inttoStr(Color.blue));
   writeln(f,inttoStr(Color.alpha));
   writeln(f,'Brightness:');
   writeln(f,inttoStr(brightness));
   writeln(f,'Contrast:');
   writeln(f,inttoStr(Contrast));
   writeln(f,'Blur:');
   writeln(f,FormatFloat('0.0000',blur));
   writeln(f,'Move Fraction:');
   writeln(f,FormatFloat('0.0000',moveFrac));
   writeln(f,'Move Limit:');
   writeln(f,FormatFloat('0.0000',moveLimit));
   decimalseparator:=ch;
   close(f);
  end;
end;

function LoadIFS(filename : string; cg : CGModel):CGModel;
   var f : textfile;
       i,imax,j,dt:integer;
       s:string;
       ch:char;
begin
  result := cg;//CGModel.Create;
  with result do begin
   ch:=decimalseparator;
   decimalseparator:=',';
   assignfile(f,filename);
   reset(f);
   readln(f,s);   readln(f,s);   readln(f,s);   readln(f,s);
   Conbination:=strtoint(s);
   readln(f,s);   readln(f,s);
   functionnum:=strtoFloat(s);
   readln(f,s);   readln(f,s);
   centralize:=strtoFloat(s);
   readln(f,s);   readln(f,s);
   curved:=strtoFloat(s);
   readln(f,s);   readln(f,s);
   Width:=strtoint(s);
   readln(f,s);   readln(f,s);
   height:=strtoint(s);
   readln(f,s);   readln(f,s);
   iteration:=strtoint(s);
   readln(f,s);   readln(f,s);
   density:=strtoFloat(s);
   readln(f,s);   readln(f,s);
   distorType:=strtoint(s);
   readln(f,s);   readln(f,s);
   GammaCorrection:=strtoFloat(s);
   readln(f,s);   readln(f,s);
   angle:=strtoFloat(s);
   readln(f,s);   readln(f,s);
   angledarray:=strtoFloat(s);
   readln(f,s);   readln(f,s);
   xScale:=strtoFloat(s);
   readln(f,s);   readln(f,s);
   YScale:=strtoFloat(s);
   readln(f,s);   readln(f,s);
   XOffset:=strtoFloat(s);
   readln(f,s);   readln(f,s);
   YOffset:=strtoFloat(s);
   readln(f,s);   readln(f,s);
   imax:=strtoint(s)-1;
   {setlength(a,imax+1);
   setlength(c,imax+1);}
   for i:=0 to imax do begin
      readln(f,s);
      for j:=0 to 11 do begin
         readln(f,s);
         a[i,j]:=strtofloat(s);
      end;
   end;
  readln(f,s);
   For i:=0 to high(a) do begin
      readln(f,s);
      c[i,0]:=strtoint(s);
      readln(f,s);
      c[i,1]:=strtoint(s);
      readln(f,s);
      c[i,2]:=strtoint(s);
   end;
   readln(f,s);
   For i:=0 to 9 do begin
      readln(f,s);
      daFunctions[i]:=strtoint(s);
   end;
   readln(f,s);
   For i:=1 to 27 do begin
      readln(f,s);
      da[i].x:=strtofloat(s);
      readln(f,s);
      da[i].y:=strtofloat(s);
   end;
   readln(f,s);
   {setlength(distortWeights,3);}
   For i:=0 to 2 do begin
      readln(f,s);
      distortWeights[0][i]:=strtofloat(s);
   end;
   readln(f,s);   readln(f,s);
   SymmetryHor:=strtofloat(s);
   readln(f,s);   readln(f,s);
   SymmetryVer:=strtofloat(s);
   readln(f,s);   readln(f,s);
   bckColor.red:=strtoint(s);
   readln(f,s);
   bckColor.green:=strtoint(s);
   readln(f,s);
   bckColor.blue:=strtoint(s);
   readln(f,s);   readln(f,s);
   Color.red:=strtoint(s);
   readln(f,s);
   Color.green:=strtoint(s);
   readln(f,s);
   Color.blue:=strtoint(s);
   readln(f,s);
   Color.alpha:=strtoint(s);
   readln(f,s);   readln(f,s);
   brightness:=strtoint(s);
   readln(f,s);   readln(f,s);
   Contrast:=strtoint(s);
   readln(f,s);   readln(f,s);
   Blur:=strtofloat(s);
   readln(f,s);   readln(f,s);
   MoveFrac:=strtofloat(s);
   readln(f,s);   readln(f,s);
   moveLimit:=strtofloat(s);
   close(f);
   decimalseparator:=ch;

    {setlength(distorsions,10);}
    for j := 0 to 9 do begin
       for i:=0 to 2 do begin
          distortWeights[j][i]:=random;
          if (distortype>0) and (distortype<28) and (i=0) then dt:=distortype else dt:=1+random(27);
          case dt of
          1 : distorsions[j][i] := Sinusoidal;
          2 : distorsions[j][i] := Spheical;
          3 : distorsions[j][i] := Swirl;
          4 : distorsions[j][i] := Horseshoe;
          5 : distorsions[j][i] := Polar;
          6 : distorsions[j][i] := Handkerchief;
          7 : distorsions[j][i] := Heart;
          8 : distorsions[j][i] := Disc;
          9 : distorsions[j][i] := Spiral;
          10: distorsions[j][i] := Hiperbolic;
          11: distorsions[j][i] := Diamond;
          12: distorsions[j][i] := Ex;
          13: distorsions[j][i] := Julia;
          14: distorsions[j][i] := Weave;
          15: distorsions[j][i] := sandGlass;
          16: distorsions[j][i] := Television;
          17: distorsions[j][i] := Floverbox;
          18: distorsions[j][i] := Scape;
          19: distorsions[j][i] := HyperCircle;
          20: distorsions[j][i] := Weaves;
          21: distorsions[j][i] := Grass;
          22: distorsions[j][i] := Tube;
          23: distorsions[j][i] := Sphere;
          24: distorsions[j][i] := Geo;
          25: distorsions[j][i] := Gravity;
          26: distorsions[j][i] := Snail;
          27: distorsions[j][i] := Spirals;
          end;
       end;
    end;
    distorsion:=distorsions[0][0];
    addColor(color.red,color.green,color.blue,bckColor.red,bckColor.green,bckColor.blue,color.alpha);
   end;
end;

end.
