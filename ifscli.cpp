
#include <stdlib.h>
#include <stdio.h>

#include "progress.h"
#include "ifs.h"
#include "ifsio.h"

void doProgress(int progress) { 
  printf("\033[s  %d   \033[u", progress);
}

int main(int argc, char **argv) {
  TLayer kep;
  CGModelWithIO *CG;
  int i, j, w, h, err;
  FILE *F;
  char *infile;
  char *outfile;

  srand(time(NULL));
  
  printf("IFS Illusions Command line interface\n");
  printf("usage: ifscli -w WIDTH -h HEIGHT -o OUTPUTFILE INPUTFILE\n");

  w = atoi(argv[2]);
  h = atoi(argv[4]);
  outfile = argv[6];
  infile = argv[7];
   
  printf("Loading %s ...\n", infile);
  CG = new CGModelWithIO({0,0,0,100,0.75,1,6,2000,0,0,0,0,0,0,0});
  CG->loadIFS(infile);

  printf("Rendering %d x %d ...\n", w, h);
  CG->CGMap(doProgress, w, h, kep);
  
  printf("Saving %s ...\n", outfile);
  F = fopen(outfile, "w"); 
  fprintf(F, "P3\n");
  fprintf(F, "%d %d\n", w, h);
  fprintf(F, "255\n");
  for (j = 0; j < h; j++) {
    for (i = 0; i < w; i++) {
      fprintf(F, "%d ", kep[i + j * w][0]);
      fprintf(F, "%d ", kep[i + j * w][1]);
      fprintf(F, "%d ", kep[i + j * w][2]);
      fprintf(F, "\n");
    }
  }
   
  printf("Closing...\n");  
  fclose(F);
  free(CG);
  free(kep);
}
