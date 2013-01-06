
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include "ifs.h"

inline double frand() { return ((double)rand() / RAND_MAX); }
inline int lrand(int max) { return ((int)(max * (double)rand() / RAND_MAX)); }
inline double sqr(double x) { return(x*x); }
inline double sign(double x) { 
  return ( x < 0 ? -1 : 
           x > 0 ?  1 : 0); 
}
inline double fmax (double a, double b ) { return (a<b)?b:a; }
inline int lmax (int a, int b ) { return (a<b)?b:a; }
inline int lmin (int a, int b ) { return (a>b)?b:a; }

CGModel::CGModel(CGModelProperties p) {
  int i;
  SetProperties(p);
  XScale = YScale = ZScale = 1;
  XOffset = YOffset = ZOffset = 0;
  CreateWeights(10);
  CreateColors(10);
  addColor(0,0,0,0,0,0,0);
  for (i = 1; i <= 27; i++) {
    da[i].x = sqr(frand());
    da[i].y = sqr(frand());
  }
  for (i = 0; i <= 9; i++) { daFunctions[i] = 1 + 27.0 * rand() / RAND_MAX; }
}

void CGModel::setDistorts()
{
  int i, j, dt;
  for (j = 0; j < DISTORTNUM; j++) {
    for (i = 0; i <= 2; i++) {
      distortWeights[j][i] = frand();       
      dt = ((p.DistorType > 0) && (p.DistorType<28) && (i==0)) 
           ? p.DistorType 
           : 1+lrand(27);
      distorsions[j][i] = IFSDistorts[dt];
    }
  }
  distorsion = distorsions[0][0];
}

void CGModel::SetProperties(CGModelProperties p) {
  srand(time(NULL));
  this->p = p;
  conbination = 10;
  angle = (p.angledarray > 1) ? 2*M_PI/p.angledarray : 0;
  FunctionNum = 1 + 9 * (1-p.structure/100);
  setDistorts();
}

void CGModel::addColor(uint8_t r, uint8_t g, uint8_t b,
                       uint8_t bckr, uint8_t bckg, uint8_t bckb,
                       uint8_t alpha)
{
  int i;
  bckColor.red = bckr;
  bckColor.green = bckg;
  bckColor.blue = bckb;
  if ((r==0) && (g==0) && (b==0)) r = g = b = 1;
  color.red = r;
  color.green = g;
  color.blue = b;
  color.alpha = alpha;
  for (i = 0; i < FUNCTIONNUM; i++) {
    c2[i][0] = (int)(((double)alpha*r+(255.0-alpha)*c[i][0])/255);
    c2[i][1] = (int)(((double)alpha*g+(255.0-alpha)*c[i][1])/255);
    c2[i][2] = (int)(((double)alpha*b+(255.0-alpha)*c[i][2])/255);
  }
}

void CGModel::CreateWeights(int n) {
  int i, j;
  for (i = 0; i < n; i++) {
    for (j = 0; j < WEIGHTNUM; j++) {
      a[i][j] = 2*frand()-1;
      ai[i][j] = sqrt(1-sqr(a[i][j]))*sign(2*frand()-1);
      b[i][j] = 2*frand()-1;
    }
  }
}

void CGModel::CreateColors(int n) {
  int i;
  for (i = 0; i < n; i++) {
    c[i][0] = lrand(256);
    c[i][1] = lrand(256);
    c[i][2] = lrand(256);
  }
}

void CGModel::calculateFunctionWeights() {
  int i, n, nn;
  double t, sum1 = 0, sum2 = 0;
  double mul[6];
  for (i = 0; i < FUNCTIONNUM; i++) {
    mul[0] = 1;
    mul[1] = (0.4+0.4*sign(abs(a[i][1])-0.5)*4*sqr(abs(a[i][1])-0.5))*mul[0];
    mul[2] = ((0.5-mul[1])+(3/24)*sqr(a[i][2])+(5/24)*a[i][2]+(1/3))*(mul[0]+mul[1]);
    mul[3] = mul[1];
    mul[4] = mul[0];
    mul[5] = mul[0]*mul[1];
    if (a[i][5]>a[i][0]) {
      t = mul[0];
      mul[0] = mul[1];
      mul[0] = t;
    }
    for (n = 0; n < 6; n++) {
      nn = (n == 0) ? 7 :
           (n == 1) ? 6 : n + 6;
      a2[i][n] = sign(a[i][n])*mul[n]*p.centralize+(1-p.centralize)*a[i][n];
      a2[i][nn] = sign(a[i][n+6])*mul[n]*p.centralize+(1-p.centralize)*a[i][nn];
      if (n >= 3) {
        a2[i][n] = a2[i][n] * p.curved;
        a2[i][nn] = a2[i][nn] * p.curved;
      } else {
        sum1 += fabs(a2[i][n]);
        sum2 += fabs(a2[i][nn]);
      }
    }
    if (sum1 != 0) 
      for (n = 0; n < 6; n++)
        a2[i][n] = a2[i][n]/sum1*p.centralize+(1-p.centralize)*a2[i][n];
    if (sum2 != 0)
      for (n = 6; n < 12; n++)
        a2[i][n] = a2[i][n]/sum2*p.centralize+(1-p.centralize)*a2[i][n];
  }
}

void CGModel::CreateField(TProgressControll pp) {
  int i,j,k,xm,ym;
  double x,y,xs,ys,xt,yt,typd,d,d1,d2;
  double r,g,b,ra;
  int typ;
  double xnew,ynew;
  double an[24];
  uint8_t cn[3];
  double dist,fi;
  double tx,ty;
  double ip,ipn,cip, osx,osy;
  int osi,osj;
  double xs0,ys0;
  TDistortion Distorsions0[3];
  double distortweights0[3];

  field = new TColorOverSamplPixel[width * height];
  calculateFunctionWeights();
  int imax = (int)(width*height*p.density/(100*p.iteration));
  double xprev = 0, yprev = 0;
  int typprev = 0;
  double mf = pow(100,p.MoveFrac);
  double ml = fmax(0.25,p.MoveLimit)/* *2 */;
  x = 2*frand()-1;
  y = 2*frand()-1;
  r = g = b = 0;
  int counter = 0;
  probcomp = 0.33;
  ipPow = 100;
  colorContrast = 50;
  cip = pow(10,((100-colorContrast)/50-1));
  ip = pow(10,(-ipPow/50));
  for (i = 0; i <= imax; i++) {
    pp(trunc(100*i/imax));
    for (j = 1; j <= p.iteration; j++) {
      counter++;
      if (frand() < probcomp) { 
        typd = typprev;
      } else {
        typd = frand()*FunctionNum/*-1*/;
        if (trunc(typd)==typprev) typd = typd+1;
      }
      typ = (int)typd;
      ipn = (ipPow == 100) 
            ? ((typd-typ <= 0.5) ? 1 : 0)
            : (1-(sign(typd-typ-0.5)*pow(fabs(2*(typd-typ-0.5)),ip)))/2;
      for (k = 0; k <= 11; k++) 
        an[k] = a2[typ][k]*ipn+a2[typ+1][k]*(1-ipn);
      for (k = 0; k <= 2; k++) 
        cn[k] = (int)(c2[typ][k]*ipn+c2[typ+1][k]*(1-ipn));

      d = (mf == 100) ? 1 : pow(frand(),1/mf);
      d1 = d*ml+(1-d)*frand();
      d2 = d*ml+(1-d)*frand();

      r = (1-ml)*r + ml*(cip*r+cn[0])/(cip+1);
      g = (1-ml)*g + ml*(cip*g+cn[1])/(cip+1);
      b = (1-ml)*b + ml*(cip*b+cn[2])/(cip+1);

      tx = ml*x + (1-ml)*xprev;
      ty = ml*y + (1-ml)*yprev;
      xnew = a2[typ][0]*tx+a2[typ][1]*ty+a2[typ][2]
             +a2[typ][3]*tx*tx+a2[typ][4]*ty*ty+a2[typ][5]*tx*ty;
      ynew = a2[typ][6]*tx+a2[typ][7]*ty+a2[typ][8]
             +a2[typ][9]*tx*tx+a2[typ][10]*ty*ty+a2[typ][11]*tx*ty;
      tx = xnew;
      ty = ynew;

      xnew = d1*x + (1-d1)*xprev;
      ynew = d2*y + (1-d2)*yprev;
      xprev = x;
      yprev = y;
      x = xnew;
      y = ynew;

      xnew = a2[typ][0]*x+a2[typ][1]*y+a2[typ][2]
             +a2[typ][3]*x*x+a2[typ][4]*y*y+a2[typ][5]*x*y;
      ynew = a2[typ][6]*x+a2[typ][7]*y+a2[typ][8]
             +a2[typ][9]*x*x+a2[typ][10]*y*y+a2[typ][11]*x*y;

      xnew = xnew;
      ynew = ynew;
      typprev = typ;

      if ((fabs(xnew)>10) || (fabs(ynew)>10)) {
        x = 2*frand()-1;
        y = 2*frand()-1;
        tx = x;
        ty = y;
        counter = 0;
      } else {
        x = x+(xnew-x)*(1+(frand()-0.5)*0.1*p.blur);
        y = y+(ynew-y)*(1+(frand()-0.5)*0.1*p.blur);
      }
      x = (x-XOffset)/XScale;
      y = (y-YOffset)/YScale;
      if ((p.DistorType>0) && (p.DistorType<28)) distorsion(x,y);
      if (p.DistorType==28) {
        xs = ys = xs0 = ys0 = 0;
        for (k = 0; k <= 2; k++) {
          xt = x;
          yt = y;
          xt = x;
          yt = y;
          distorsions[typ][k](xt,yt);
          xs += distortWeights[typ][k] * xt;
          ys += distortWeights[typ][k] * yt;
          if (j == 1) {
            xs0 = xs;
            ys0 = ys;
          } else {
            xt = x;
            yt = y;
            Distorsions0[k](xt,yt);
            xs0 = xs0+distortweights0[k] * xt;
            ys0 = ys0+distortweights0[k] * yt;
          }
          Distorsions0[k] = distorsions[typ][k];
          distortweights0[k] = distortWeights[typ][k];
        }
        x = (1-ml)*xs + ml*(3*xs+xs0)/4;
        y = (1-ml)*ys + ml*(3*ys+ys0)/4;
      }
      if (p.DistorType == 29) Distort(x,y);
      if (frand() < (p.symmetryHor/2)) x = -x;
      if (frand() < (p.symmetryVer/2)) y = -y;
      if (angle > 0) {
        dist = sqrt(x*x+y*y);
        fi = atan2(y,x);
        ra = (int)(frand() * p.angledarray);
        x = dist*cos(fi+angle*ra);
        y = dist*sin(fi+angle*ra);
      }
      if ((x>=-1) && (x<1) && (y>=-1) && (y<1) 
          && (counter >=20)) 
      {
        osx = (x+1)*(width/2.0);
        osy = (y+1)*(height/2.0);
        xm = (int)(osx);
        ym = (int)(osy);
        osi = (int)(3*(osx-xm));
        osj = (int)(3*(osy-ym));
        field[xm + ym * width][0][osi][osj] += 255;
        field[xm + ym * width][1][osi][osj] += r;
        field[xm + ym * width][2][osi][osj] += g;
        field[xm + ym * width][3][osi][osj] += b;
      }
      x = tx;
      y = ty;
    }
  }
}
  
void CGModel::CGMap(TProgressControll pp, int w, int h, TLayer &result) {
  int i, j, k, l;
  double r, g, b, r0, g0, b0, a;
  double max = 0, ref;
  
  width = w;
  height = h;
  
  CreateField(pp);
  
  result = new TPixel[width * height];
  for (j = 0; j < height; j++) 
    for (i = 0; i < width; i++) 
      for (k = 0; k <= 2; k++)   
        for (l = 0; l <= 2; l++)  {
            ref = field[i + j * width][0][k][l];
            if (ref>max) max = ref;
        }
  if (max != 0) {
    for (j = 0; j < height; j++) {
      for (i = 0; i < width; i++) {
        a = r = g = b =0;
        for (k = 0; k <= 2; k++)   
          for (l = 0; l <= 2; l++)  {
            ref = field[i + j * width][0][k][l];
            if (ref != 0) {
              r0 = field[i + j * width][1][k][l]/ref;
              g0 = field[i + j * width][2][k][l]/ref;
              b0 = field[i + j * width][3][k][l]/ref;
            } else {
              r0 = bckColor.red/255.0;
              g0 = bckColor.green/255.0;
              b0 = bckColor.blue/255.0;
            }
            r += r0;
            g += g0;
            b += b0; 
            if (ref>a) a = ref;
          }  
        a /= max;
        if (a != 0) {
          a = log(1+100*a)/log(101);
          a = pow(a, 1.0/p.GammaCorrection);
        }
        r = 255 * r / 9;
        g = 255 * g / 9;
        b = 255 * b / 9;
        r = r * (p.contrast+50)/100.0 + p.brightness; 
        g = g * (p.contrast+50)/100.0 + p.brightness; 
        b = b * (p.contrast+50)/100.0 + p.brightness; 
        r = r*a + (1-a)*bckColor.red;
        g = g*a + (1-a)*bckColor.green;
        b = b*a + (1-a)*bckColor.blue;
        result[i + j * width][0] = lmin(lmax(0,(int)(r)),255);
        result[i + j * width][1] = lmin(lmax(0,(int)(g)),255);
        result[i + j * width][2] = lmin(lmax(0,(int)(b)),255);
      }
    }
  }
  free(field);
}

void CGModel::Distort(double &x, double &y) {
  int dt;
  double x0, y0;
  dt = (int)(frand()*conbination);
  x0 = x;
  y0 = y;
  IFSDistorts[daFunctions[dt]](x,y);
  x = x0 * (1-da[dt].x) + x * da[dt].x;
  y = y0 * (1-da[dt].y) + y * da[dt].y;
}

