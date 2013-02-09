
#ifndef __IFS_H__
#define __IFS_H__

#include <stdint.h>
#include "progress.h"
#include "ifsdistort.h"

#define WEIGHTNUM 48
#define FUNCTIONNUM 10
#define DISTORTNUM 10

typedef double CGFunctionWeight[WEIGHTNUM];
typedef float oversampledPixel[3][3];
typedef oversampledPixel TColorOverSamplPixel[4];
typedef double TDistortWeights[3];
typedef uint8_t TPixel[3];
typedef TPixel *TLayer;

typedef struct {
  double x;
  double y;
} TPoint;

typedef struct {
  uint8_t alpha;
  uint8_t red;
  uint8_t green;
  uint8_t blue;
} TColor;

typedef struct {
  int i, j, x, y;
  double r, g, b, a;
} tFieldPoint;

typedef struct {
  double centralize;
  double curved;
  int DistorType;
  int iteration;
  double structure;
  double angledarray;
  double GammaCorrection;
  double density;
  double symmetryHor;
  double symmetryVer;
  double MoveFrac;
  double MoveLimit;
  int brightness;
  int contrast;
  double blur;
} CGModelProperties;

class CGModel {
  protected:        
    double FunctionNum;
    CGFunctionWeight a[FUNCTIONNUM];
    CGFunctionWeight ai[FUNCTIONNUM];
    CGFunctionWeight a2[FUNCTIONNUM];
    CGFunctionWeight b[FUNCTIONNUM];
    TPixel c[FUNCTIONNUM];
    TPixel c2[FUNCTIONNUM];
    TDistortWeights distortWeights[DISTORTNUM];
    int daFunctions[10];
    TPoint da[28];
    TColor bckColor;
    TColor color;
    double probcomp;
    int ipPow;
    double colorContrast;
    double RotY;
    double RotZ;
    double camdistance;
    TDistortion distorsion;
    TDistortion distorsions[DISTORTNUM][3];
    int conbination;
    int width;
    int height;
    double angle;
    double XScale,YScale,ZScale;
    double XOffset,YOffset,ZOffset;
    TColorOverSamplPixel **field;
    void SetProperties(CGModelProperties p);
    void setDistorts();
    void CreateWeights(int n);
    void CreateColors(int n);
    void calculateFunctionWeights();
    void addColor(uint8_t r, uint8_t g, uint8_t b,
                  uint8_t bckr, uint8_t bckg, uint8_t bckb,
                  uint8_t alpha);
    void Distort(double &x, double &y);
    double searchFieldMax();
    void allocateField();
    void deallocateField();
    void addFieldPoint(tFieldPoint &p);
    void fillFields(int *fd, int nfd);
  public:
    CGModelProperties p;
    CGModel(CGModelProperties p);
    void CreateField(TProgressControll pp, int w, int h, int fd);
    void CGMap(TProgressControll pp, int w, int h, TLayer &result, int *fd, int nfd);
};

#endif
