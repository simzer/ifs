 
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
  int i, imax, j;

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
  FILE *f;
  int i, j;
  
  f = fopen(filename, "w");
  fprintf(f,"i-Mage Iterated Function System (IFS) format for i-Mage IFS Builder\n");
  fprintf(f,"Parameters:\n");
  fprintf(f,"Combinated distort function count:\n%d\n", conbination);
  fprintf(f,"function's number:\n%lf\n", FunctionNum);
  fprintf(f,"Centralize:\n%lf\n", p.centralize);
  fprintf(f,"Curve:\n%lf\n", p.curved);
  fprintf(f,"Field width:\n%d\n", width);
  fprintf(f,"Field height:\n%d\n", height);
  fprintf(f,"Iteration:\n%d\n", p.iteration);
  fprintf(f,"Density:\n%lf\n", p.density);
  fprintf(f,"Distortion type:\n%d\n", p.DistorType);
  fprintf(f,"Gamma Correction:\n%lf\n", p.GammaCorrection);
  fprintf(f,"Rotation angle:\n%lf\n", angle);
  fprintf(f,"Angled array:\n%lf\n", p.angledarray);
  fprintf(f,"x scale\n%lf\n", XScale);
  fprintf(f,"y scale\n%lf\n", YScale);
  fprintf(f,"x offset\n%lf\n", XOffset);
  fprintf(f,"y offset\n%lf\n", YOffset);
  fprintf(f,"Function number:\n%d\n",FUNCTIONNUM);
  for (i = 0; i < FUNCTIONNUM; i++) {
    fprintf(f,"%d. function`s weights:\n", i);
    for (j = 0; j <= 11; j++) fprintf(f,"%lf\n", a[i][j]);
  }
  fprintf(f,"Function`s Color (R,G,B):\n");
  for (i = 0; i < FUNCTIONNUM; i++) 
    fprintf(f, "%d\n%d\n%d\n", c[i][0], c[i][1], c[i][2]);
  fprintf(f,"Distort function`s for combine:\n");
  for (i = 0; i <= 9; i++) fprintf(f,"%d\n", daFunctions[i]);
  fprintf(f,"Distort function`s weights (x,y) for combine:\n");
  for (i = 1; i <= 27; i++) {
    fprintf(f,"%lf\n", da[i].x);
    fprintf(f,"%lf\n", da[i].y);
  }
  fprintf(f,"Distort function`s Weights:\n");
  for (i = 0; i <= 2; i++) fprintf(f,"%lf\n", distortWeights[0][i]);
  fprintf(f,"Symmetry Horizontal:\n%lf\n", p.symmetryHor);
  fprintf(f,"Symmetry Vertical:\n%lf\n", p.symmetryVer);
  fprintf(f,"Background Color (Red,Green,Blue):\n%d\n%d\n%d\n",
         bckColor.red, bckColor.green, bckColor.blue);
  fprintf(f,"Foreground Color (Red,Green,Blue,alpha):\n%d\n%d\n%d\n%d\n",
         color.red, color.green, color.blue, color.alpha);
  fprintf(f,"Brightness:\n%d\n", p.brightness);
  fprintf(f,"Contrast:\n%d\n", p.contrast);
  fprintf(f,"Blur:\n%lf\n", p.blur);
  fprintf(f,"Move Fraction:\n%lf\n", p.MoveFrac);
  fprintf(f,"Move Limit:\n%lf\n", p.MoveLimit);
  fclose(f);
}
