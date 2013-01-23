
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/shm.h>
#include <sys/stat.h>
#include "progress.h"
#include "ifs.h"
#include "ifsio.h"

static void savePFM(TLayer pic, char* outfile, int w, int h);

void doProgress(int progress) { 
  printf("\033[s  %d   \033[u", progress); fflush(stdout);
}

int main(int argc, char **argv) {
  CGModelWithIO *CG;
  int w, h;
  char *infile;
  char *outfile;
  int numberOfChildren = 16;
  pid_t *childpid = (pid_t*)malloc(numberOfChildren * sizeof(pid_t));
  int *fds = (int*)malloc(numberOfChildren * sizeof(int));
  fd_set rfds;

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

  for (int i = 0; i < numberOfChildren; i++) {
    int fd[2];
    pipe(fd);
    pid_t p;
    if ((p = fork()) == 0) {
      close(fd[0]);
      CG->p.density /= numberOfChildren;
      CG->CreateField(i == 0 ? doProgress : 0, w, h, fd[1]);
      free(CG);
      close(fd[1]);
      exit(0);
    } else {
      close(fd[1]);
      childpid[i] = p;
      fds[i] = fd[0];
    }
  }

  TLayer pic;
  CG->CGMap(0, w, h, pic, fds, numberOfChildren);
  savePFM(pic, outfile, w, h);
  printf("Closing...\n");
  free(pic);
  free(CG);
}

static void savePFM(TLayer pic, char* outfile, int w, int h) {
  int i, j;
  FILE *F;
  printf("Saving %s ...\n", outfile);
  F = fopen(outfile, "w");
  fprintf(F, "P3\n");
  fprintf(F, "%d %d\n", w, h);
  fprintf(F, "255\n");
  for (j = 0; j < h; j++) {
    for (i = 0; i < w; i++) {
      fprintf(F, "%d ", pic[i + j * w][0]);
      fprintf(F, "%d ", pic[i + j * w][1]);
      fprintf(F, "%d ", pic[i + j * w][2]);
      fprintf(F, "\n");
    }
  }
  fclose(F);
}
