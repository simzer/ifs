
#include <cstdio>
#include <cstdlib>
#include <cstring>

#include <fcntl.h>
#include <math.h>
#include <unistd.h>
#include "ifs.h"

CGModel::CGModel(CGModelProperties p) {
  int i;
  SetProperties(p);
  XScale = YScale = ZScale = 1;
  XOffset = YOffset = ZOffset = 0;
  CreateWeights(10);
  CreateColors(10);
  addColor(0,0,0,0,0,0,0);
  field = 0;
  for (i = 1; i <= 27; i++) {
    da[i].x = sqr(frand());
    da[i].y = sqr(frand());
  }
  for (i = 0; i <= 9; i++) { daFunctions[i] = 1 + 27.0 * rand() / RAND_MAX; }
}

CGModel::~CGModel() {
  deallocateField();
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
  this->p = p;
  conbination = 10;
  angle = (p.angledarray > 1) ? 2.0*M_PI/p.angledarray : 0;
  FunctionNum = 1 + 9 * (1-p.structure/100.0);
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
    c2[i][0] = (int)(((double)alpha*r+(255.0-alpha)*c[i][0])/255.0);
    c2[i][1] = (int)(((double)alpha*g+(255.0-alpha)*c[i][1])/255.0);
    c2[i][2] = (int)(((double)alpha*b+(255.0-alpha)*c[i][2])/255.0);
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
  double t, sum1, sum2;
  double mul[6];
  for (i = 0; i < FUNCTIONNUM; i++) {
    mul[0] = 1.0;
    mul[1] = (0.4+0.4*sign(fabs(a[i][1])-0.5)*4.0*sqr(fabs(a[i][1])-0.5))*mul[0];
    mul[2] = ((0.5-mul[1])+(3.0/24.0)*sqr(a[i][2])+(5.0/24.0)*a[i][2]+(1.0/3.0))*(mul[0]+mul[1]);
    mul[3] = mul[1];
    mul[4] = mul[0];
    mul[5] = mul[0]*mul[1];
    if (a[i][5]>a[i][0]) {
      t = mul[0];
      mul[0] = mul[1];
      mul[0] = t;
    }
    sum1 = 0;
    sum2 = 0;
    for (n = 0; n < 6; n++) {
      nn = (n == 0) ? 7 :
           (n == 1) ? 6 : n + 6;
      a2[i][n] = sign(a[i][n])*mul[n]*p.centralize+(1.0-p.centralize)*a[i][n];
      a2[i][nn] = sign(a[i][n+6])*mul[n]*p.centralize+(1.0-p.centralize)*a[i][nn];
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

<<<<<<< TREE
void CGModel::CreateField(TProgressControll pp, int w, int h, int fd, bool usePipe) {
=======
void CGModel::quadraticFunction(int type, double x, double y, double *xnew, double *ynew) {
  *xnew =   a2[type][0]*x   + a2[type][1]*y    + a2[type][2]
          + a2[type][3]*x*x + a2[type][4]*y*y  + a2[type][5]*x*y;
  *ynew =   a2[type][6]*x   + a2[type][7]*y    + a2[type][8]
          + a2[type][9]*x*x + a2[type][10]*y*y + a2[type][11]*x*y;
}

void CGModel::CreateField(TProgressControll pp, int w, int h, int fd) {
>>>>>>> MERGE-SOURCE
  int i,j,k,xm,ym;
  double x,y,xs,ys,xt,yt,typd,d,d1,d2;
  double r,g,b,ra;
  int typ;
  double xnew,ynew;
  uint8_t cn[3];
  double dist,fi;
  double tx,ty;
  double ip,ipn,cip, osx,osy;
  int osi,osj;
  double xs0,ys0;
  TDistortion Distorsions0[3];
  double distortweights0[3];

  printf(".");
  if (   (   (w != width)
          || (h != height)
          || (field == 0) )
       && (!usePipe) ) {
    width = w;
    height = h;
    // todo: remove to init function, not threadsafe here
    fieldInitialised = false;
    deallocateField();
    allocateField(w, h);
    fieldInitialised = true;
  }
  calculateFunctionWeights();
  int imax = (int)((double)width*height*p.density/(100.0*p.iteration));
  double xprev = 0.0, yprev = 0.0;
  int typprev = 0;
  double mf = pow(100.0,p.MoveFrac);
  double ml = fmax(0.25,p.MoveLimit)/* *2 */;
  x = 2.0*frand()-1.0;
  y = 2.0*frand()-1.0;
  r = g = b = 0.0;
  int counter = 0;
  probcomp = 0.33; //todo: make it parameter?
  ipPow = 100; //todo: make it parameter?
  colorContrast = 50; //todo: make it parameter?
  cip = pow(10.0,((100.0-colorContrast)/50.0-1.0));
  ip = pow(10.0,(-ipPow/50.0));
  for (i = 0; i <= imax; i++) {
    if (pp != 0) pp((int)(100.0*i/imax));
    for (j = 1; j <= p.iteration; j++) {
      counter++;
      if (frand() < probcomp) { 
        typd = typprev;
      } else {
        typd = frand()*FunctionNum/*-1*/;
        if ((int)(typd)==typprev) typd = typd+1;
      }
      typ = (int)typd;
      ipn = (ipPow == 100) 
            ? ((typd-typ <= 0.5) ? 1.0 : 0.0)
            : ((1.0-(sign(typd-typ-0.5)*pow(fabs(2.0*(typd-typ-0.5)),ip)))/2.0);
      for (k = 0; k <= 2; k++) 
        cn[k] = (int)(c2[typ][k]*ipn+c2[typ+1][k]*(1.0-ipn));
      
      d = (mf == 100) ? 1.0 : pow(frand(),1.0/mf);
      d1 = d*ml+(1.0-d)*frand();
      d2 = d*ml+(1.0-d)*frand();

      r = (1.0-ml)*r + ml*(cip*r+cn[0])/(cip+1.0);
      g = (1.0-ml)*g + ml*(cip*g+cn[1])/(cip+1.0);
      b = (1.0-ml)*b + ml*(cip*b+cn[2])/(cip+1.0);

      tx = ml*x + (1-ml)*xprev;
      ty = ml*y + (1-ml)*yprev;
      quadraticFunction(typ, tx, ty, &xnew, &ynew);
      tx = xnew;
      ty = ynew;

      xnew = d1*x + (1.0-d1)*xprev;
      ynew = d2*y + (1.0-d2)*yprev;
      xprev = x;
      yprev = y;
      x = xnew;
      y = ynew;
      quadraticFunction(typ, x, y, &xnew, &ynew);
      typprev = typ;

      if ((fabs(xnew)>10.0) || (fabs(ynew)>10.0)) {
        x = 2.0*frand()-1.0;
        y = 2.0*frand()-1.0;
        tx = x;
        ty = y;
        counter = 0;
      } else {
        x = x+(xnew-x)*(1.0+(frand()-0.5)*0.1*p.blur);
        y = y+(ynew-y)*(1.0+(frand()-0.5)*0.1*p.blur);
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
        x = (1.0-ml)*xs + ml*(3.0*xs+xs0)/4.0;
        y = (1.0-ml)*ys + ml*(3.0*ys+ys0)/4.0;
      }
      if (p.DistorType == 29) Distort(x,y);
      if (frand() < (p.symmetryHor/2.0)) x = -x;
      if (frand() < (p.symmetryVer/2.0)) y = -y;
      if (angle > 0.0) {
        dist = sqrt(x*x+y*y);
        fi = atan2(y,x);
        ra = (int)(frand() * p.angledarray);
        x = dist*cos(fi+angle*ra);
        y = dist*sin(fi+angle*ra);
      }
      if ((x>=-1.0) && (x<1.0) && (y>=-1.0) && (y<1.0) 
          && (counter >=20)) 
      {
        osx = (x+1.0)*(width/2.0);
        osy = (y+1.0)*(height/2.0);
        xm = (int)(osx);
        ym = (int)(osy);
        osi = (int)(3*(osx-xm));
        osj = (int)(3*(osy-ym));

        tFieldPoint p = { osi, osj, xm, ym, r, g, b, 255.0 };
        if (usePipe) {
          static tFieldPoint ps[1000];
          static int pcnt = 0;
          ps[pcnt] = p;
          pcnt ++;
          if (pcnt == sizeof(ps)/sizeof(tFieldPoint)) {
            write(fd, ps, sizeof(ps));
            pcnt = 0;
          }
        } else {
          renderFieldPoint(p);
        } 
      }
      x = tx;
      y = ty;
    }
  }
}
  
<<<<<<< TREE
void CGModel::renderFieldPoint(tFieldPoint &p) {
=======
double CGModel::searchFieldMax() {  
  double max = 0;
  for (int j = 0; j < height; j++) 
    for (int i = 0; i < width; i++) 
      for (int k = 0; k <= 2; k++)   
        for (int l = 0; l <= 2; l++)  {
          double ref = field[j][i][0][k][l];
          if (ref>max) max = ref;
        }
  return max;
}

void CGModel::addFieldPoint(tFieldPoint &p) {
>>>>>>> MERGE-SOURCE
  field[p.y][p.x][0][p.i][p.j] += p.a;
  field[p.y][p.x][1][p.i][p.j] += p.r;
  field[p.y][p.x][2][p.i][p.j] += p.g;
  field[p.y][p.x][3][p.i][p.j] += p.b;
}

<<<<<<< TREE
void CGModel::allocateField(int width, int height) {
=======
void CGModel::allocateField() {
>>>>>>> MERGE-SOURCE
  field = new TColorOverSamplPixel*[height];
  for (int i = 0; i < height; i++) {
    field[i] = new TColorOverSamplPixel[width];
<<<<<<< TREE
    memset(field[i], 0, width * sizeof(TColorOverSamplPixel));
  }
=======
  }  
>>>>>>> MERGE-SOURCE
}

void CGModel::deallocateField() {
<<<<<<< TREE
  if (field != 0) {
    for(int i = 0; i < height; i++) free(field[i]);
    free(field);
  }
  field = 0;
=======
  for(int i = 0; i < height; i++) free(field[i]);
  free(field);
>>>>>>> MERGE-SOURCE
}

<<<<<<< TREE
void CGModel::collectFieldPoints(int *fd, int nfd) {
=======
void CGModel::fillFields(int *fd, int nfd) {
>>>>>>> MERGE-SOURCE
  tFieldPoint ps[1000];
  int finished = 0;
  int pointCnt = 0;
  while(finished == 0) {
    finished = 1;
    for(int j = 0; j < nfd; j++) {
      int nbytes = read(fd[j], ps, sizeof(ps));
      if (nbytes > 0) {
        finished = 0;
<<<<<<< TREE
        for(int i = 0; i < nbytes/sizeof(tFieldPoint); i++) {
          renderFieldPoint(ps[i]);
=======
        for(unsigned int i = 0; i < nbytes/sizeof(tFieldPoint); i++) {
          addFieldPoint(ps[i]);
>>>>>>> MERGE-SOURCE
          pointCnt++;
        }
      }
    }
<<<<<<< TREE
  }
=======
  }  
  printf("Points processed: %d\n", pointCnt);
}

Color CGModel::getSubPixelColor(int i, int j, int k, int l) {
  double ref = field[j][i][0][k][l];
  if (ref != 0) {
    Color c0(field[j][i][1][k][l]/ref,
             field[j][i][2][k][l]/ref,
             field[j][i][3][k][l]/ref);              
    c0 = c0 * 255;
    c0 = c0 * ((p.contrast+100)/100.0) + p.brightness;
    c0.limitTo255();
    return(c0);
  } else {
    return Color(0, 0, 0);            
  }
}

double CGModel::getSubPixelAlpha(int i, int j, int k, int l, double max) {
  double a = field[j][i][0][k][l] / max;
  if (a != 0) {
    a = log(1+100*a)/log(101);
    a = pow(a, 1.0/p.GammaCorrection);
  }
  return(a);
}

Color CGModel::getPixelColor(int i, int j, double max) {
  Color c(0, 0, 0);
  Color bg(bckColor.red, bckColor.green, bckColor.blue);
  for (int k = 0; k <= 2; k++) {
    for (int l = 0; l <= 2; l++)  {
      double a = getSubPixelAlpha(i, j, k, l, max);
      Color c0 = getSubPixelColor(i, j, k, l);
      c = c + c0 * a + bg * (1.0-a);
    }
  }
  c = c / 9.0;
  return(c);  
>>>>>>> MERGE-SOURCE
}

void CGModel::CGMap(TProgressControll pp, int w, int h, TLayer &result, int *fd, int nfd) {
<<<<<<< TREE
  int i, j, k, l;
  double r, g, b, r0, g0, b0, a;
  double max = 0, ref;
=======
>>>>>>> MERGE-SOURCE
  width = w;
  height = h;
<<<<<<< TREE

  if (nfd > 0) {
    allocateField(w, h);
    collectFieldPoints(fd, nfd);
  }
=======
  allocateField();
  fillFields(fd, nfd);
>>>>>>> MERGE-SOURCE
  result = new TPixel[width * height];
  double max = searchFieldMax();
  if (max != 0) {
    for (int j = 0; j < height; j++) {
      for (int i = 0; i < width; i++) {
        Color c = getPixelColor(i, j, max);
        result[i + j * width][0] = lmin(lmax(0,(int)(c.r)),255);
        result[i + j * width][1] = lmin(lmax(0,(int)(c.g)),255);
        result[i + j * width][2] = lmin(lmax(0,(int)(c.b)),255);
      }
    }
  }
<<<<<<< TREE
=======
  deallocateField();
>>>>>>> MERGE-SOURCE
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

