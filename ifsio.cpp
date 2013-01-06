 
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "ifs.h"
#include "ifsdistort.h"
#include "ifsio.h"

void CGModelWithIO::ignoreLines(FILE *f, int i) {
  char s[1024];
  while( i > 0 ) {
    fgets(s, sizeof(s), f);
    i--;
  }
}

double CGModelWithIO::getfloat(FILE *f, int linenum) {
  double res;
  char s[1024];
  ignoreLines(f, linenum - 1);
  fgets(s, sizeof(s), f);
  for(int i = 0; i < strlen(s); i++) if (s[i] == ',') s[i] = '.';
  sscanf(s, "%lf", &res);
  return res;
}

double CGModelWithIO::getint(FILE *f, int linenum) {
  int res;
  char s[1024];
  ignoreLines(f, linenum - 1);
  fgets(s, sizeof(s), f);
  sscanf(s, "%d", &res);
  return res;
}

void CGModelWithIO::loadIFS(char *filename) {
  FILE *f = fopen(filename, "r");
  int i, imax, j, dt;
  char s[256];
  
  conbination = getint(f, 4);
  FunctionNum = getfloat(f, 2);
  p.centralize = getfloat(f, 2);
  p.curved = getfloat(f, 2);
  width = getint(f, 2);
  height = getint(f, 2);
  p.iteration = getint(f, 2);
  p.density = getfloat(f, 2);
  p.DistorType = getint(f, 2);
  p.GammaCorrection = getfloat(f, 2);
  angle = getfloat(f, 2);
  p.angledarray = getfloat(f, 2);
  XScale = getfloat(f, 2);
  YScale = getfloat(f, 2);
  XOffset = getfloat(f, 2);
  YOffset = getfloat(f, 2);
  imax = getint(f, 2)-1;
  for (i = 0; i <= imax; i++) {
    ignoreLines(f, 1);
    for (j = 0; j <= 11; j++) {
       a[i][j] = getfloat(f, 1);
    }
  }
  ignoreLines(f, 1);
  for(i = 0; i < FUNCTIONNUM; i++) {
    c[i][0] = getint(f, 1);
    c[i][1] = getint(f, 1);
    c[i][2] = getint(f, 1);
  }
  ignoreLines(f, 1);
  for(i = 0; i <= 9; i++) {
    daFunctions[i] = getint(f, 1);
  }
  ignoreLines(f, 1);
  for(i = 1; i <= 27; i++) {
    da[i].x = getfloat(f, 1);
    da[i].y = getfloat(f, 1);
  }
  ignoreLines(f, 1);
  for(i = 0; i <= 2; i++) {
    distortWeights[0][i] = getfloat(f, 1);
  }
  p.symmetryHor = getfloat(f, 2);
  p.symmetryVer = getfloat(f, 2);
  bckColor.red = getint(f, 2);
  bckColor.green = getint(f, 1);
  bckColor.blue = getint(f, 1);
  color.red = getint(f, 2);
  color.green = getint(f, 1);
  color.blue = getint(f, 1);
  color.alpha = getint(f, 1);
  p.brightness = getint(f, 2);
  p.contrast = getint(f, 2);
  p.blur = getfloat(f, 2);
  p.MoveFrac = getfloat(f, 2);
  p.MoveLimit = getfloat(f, 2);
  
  fclose(f);
  setDistorts();
  addColor(color.red,color.green,color.blue,bckColor.red,bckColor.green,bckColor.blue,color.alpha);
}

void CGModelWithIO::saveIFS(char *filename) {
/*  FILE f;
  int i, j;
  char ch;
  
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
  end;*/
}
