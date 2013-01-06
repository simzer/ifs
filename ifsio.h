
#ifndef __IFSIO_H__
#define __IFSIO_H__

#include "ifs.h"

class CGModelWithIO : public CGModel {
  private:  
    static void ignoreLines(FILE *f, int i);
    static double getfloat(FILE *f, int linenum);
    static double getint(FILE *f, int linenum);
  public:
    CGModelWithIO(CGModelProperties p) : CGModel(p) {};
    void saveIFS(char *filename);
    void loadIFS(char *filename);
};

#endif
