
#include <stdlib.h>
#include <math.h>
#include "ifsdistort.h"

const TDistortion IFSDistorts[28] = {
  None,
  Sinusoidal, Spheical, Swirl, Horseshoe, Polar, Handkerchief,
  Heart, Disc, Spiral, Hiperbolic, Diamond, Ex, Julia, Weave,
  sandGlass, Television, Floverbox, Scape, HyperCircle, Weaves,
  Grass, Tube, Sphere, Geo, Gravity, Snail, Spirals
};

inline double sqr(double x) { return(x*x); }
inline double sign(double x) { 
  return ( x < 0 ? -1 : 
           x > 0 ?  1 : 0); 
}

void None(double &x, double &y) {}

void Sinusoidal(double &x, double &y) {
  x = sin(x);
  y = sin(y);
}

void Spheical(double &x, double &y) {
  double r;
  r = sqrt(x*x+y*y);
  if (r == 0) r = 0.0000001;
  x = x/sqr(r);
  y = y/sqr(r);
}

void Swirl(double &x, double &y) {
  double r, fi;
  r = sqrt(x*x+y*y);
  if (r == 0) r = 0.0000001;
  fi = (x != 0) ? atan2(y,x) : 100000;
  x = r*cos(fi+r);
  y = r*sin(fi+r);
}

void Horseshoe(double &x, double &y) {
  double r, fi;
  r = sqrt(x*x+y*y);
  if (r == 0) r = 0.0000001;
  fi = (x != 0) ? atan2(y,x) : 100000;
  x = r*cos(2*fi);
  y = r*sin(2*fi);
}

void Polar(double &x, double &y) {
  double r, fi;
  r = sqrt(x*x+y*y);
  if (r == 0) r = 0.0000001;
  fi = (x != 0) ? atan2(y,x) : 100000;
  x = fi/M_PI;
  y = r-1;
}

void Handkerchief(double &x, double &y) {
  double r, fi;
  r = sqrt(x*x+y*y);
  if (r == 0) r = 0.0000001;
  fi = (x != 0) ? atan2(y,x) : 100000;
  x = r*sin(fi+r);
  y = r*cos(fi-r);
}

void Heart(double &x, double &y) {
  double r, fi;
  r = sqrt(x*x+y*y);
  if (r == 0) r = 0.0000001;
  fi = (x != 0) ? atan2(y,x) : 100000;
  x = r*sin(fi*r);
  y = r*cos(fi*r);
}

void Disc(double &x, double &y) {
  double r, fi;
  r = sqrt(x*x+y*y);
  if (r == 0) r = 0.0000001;
  fi = (x != 0) ? atan2(y,x) : 100000;
  x = fi*sin(M_PI*r)/M_PI;
  y = fi*cos(M_PI*r)/M_PI;
}

void Spiral(double &x, double &y) {
  double r, fi;
  r = sqrt(x*x+y*y);
  if (r == 0) r = 0.0000001;
  fi = (x != 0) ? atan2(y,x) : 100000;
  x = (cos(fi)+sin(r))/r;
  y = (sin(fi)-cos(r))/r;
}

void Hiperbolic(double &x, double &y) {
  double r, fi;
  r = sqrt(x*x+y*y);
  if (r == 0) r = 0.0000001;
  fi = (x != 0) ? atan2(y,x) : 100000;
  x = sin(fi)/r;
  y = cos(fi)*r;
}

void Diamond(double &x, double &y) {
  double r, fi;
  r = sqrt(x*x+y*y);
  if (r == 0) r = 0.0000001;
  fi = (x != 0) ? atan2(y,x) : 100000;
  x = sin(fi)*cos(r);
  y = cos(fi)*sin(r);
}

void Ex(double &x, double &y) {
  double r, fi;
  r = sqrt(x*x+y*y);
  if (r == 0) r = 0.0000001;
  fi = (x != 0) ? atan2(y,x) : 100000;
  x = r*pow(sin(fi+r),3);
  y = r*pow(cos(fi-r),3);
}

void Julia(double &x, double &y) {
  double om;
  double r, fi;
  r = sqrt(x*x+y*y);
  if (r == 0) r = 0.0000001;
  fi = (x != 0) ? atan2(y,x) : 100000;
  om = (rand() % 2)*M_PI;
  x = sqrt(r)*cos(fi/2+om);
  y = sqrt(r)*sin(fi/2+om);
}

void Weave(double &x, double &y) {
  double om;
  double r, fi;
  r = sqrt(x*x+y*y);
  if (r == 0) r = 0.0000001;
  fi = (x != 0) ? atan2(y,x) : 100000;
  om = sin((fi)/r);
  x = r*sign(om)*sqr(om);
  om = cos((fi)/r);
  y = r*sign(om)*sqr(om);
}

void sandGlass(double &x, double &y) {
  double r;
  r = sqrt(x*x+y*y);
  if (r == 0) r = 0.0000001;
  x = sin(x)/r;
  y = cos(x)/r;
}

void Television(double &x, double &y) {
  double r;
  r = sqrt(x*x+y*y);
  if (r == 0) r = 0.0000001;
  x = sin(x)/sqrt(r);
  y = sin(y)/sqrt(r);
}

void Floverbox(double &x, double &y) {
  double r;
  r = sqrt(x*x+y*y);
  if (r == 0) r = 0.0000001;
  x = sin(x)/r;
  y = cos(y)/r;
}

void Scape(double &x, double &y) {
  double r, fi;
  r = sqrt(x*x+y*y);
  if (r == 0) r = 0.0000001;
  fi = (x != 0) ? atan2(y,x) : 100000;
  y = (r/M_PI-fi)/4;
  x = (fi*(1-r))/2;
}

void HyperCircle(double &x, double &y) {
  double r, fi;
  r = sqrt(x*x+y*y);
  if (r == 0) r = 0.0000001;
  fi = (x != 0) ? atan2(y,x) : 100000;
  
  if (x != 0) x = sin(r*M_PI*fi)*atan(M_PI+fi)/1.5;
  if (y != 0) y = cos(r*M_PI*fi)*tan(M_PI-fi)/1.5;
}

void Weaves(double &x, double &y) {
  x = x+sin(y*10)/10;
  y = y+sin(x*10)/10;
}

void Grass(double &x, double &y) {
  if ((x != 0) and (y != 0)) {
    x = (log(sqrt(fabs(x))+sqrt(fabs(y)))*sin(x));
    y = (log(sqrt(fabs(x))+sqrt(fabs(y)))*cos(x));
  }
}

void Tube(double &x, double &y) {
  double om = x;
  if (y != 0) {
    x = (1/y)*cos(om);
    y = (1/y)*sin(om);
  }
}

void Sphere(double &x, double &y) {
  double om = x * M_PI;
  x = cos(om)*cos(y*M_PI);
  y = sin(om)*cos(y*M_PI);
}

void Geo(double &x, double &y) {
  double om = x*M_PI;
  x = cos(om)*cos(y*M_PI);
  y = sin(y*M_PI);
}

void Gravity(double &x, double &y) {
  double om;
  double r;
  r = sqrt(x*x+y*y);
  if (r == 0) r = 0.0000001;
  if ((x != 1) and (y != 1)) {
    om = x;
    x = 2*(1-r)/(y-1)+1;
    y = 2*(1-r)/(om-1)+1;
  }
}

void Snail(double &x, double &y) {
  double om = sqrt(fabs(2*(x/2-trunc(x/2))));
  x = 0.5*(sqr(om)-1)+om*(om*sin(20*om)+cos(M_PI*y))/2;
  y = 1-2*sqr(om)*(1-sin(M_PI*y)/2);
}

void Spirals(double &x, double &y) {
  double om = sqrt(fabs(2*(x/2-trunc(x/2))));
  x = om*cos(6*M_PI*om)*(1+sin(M_PI*y))/2;
  y = om*sin(6*M_PI*om)*(1+sin(M_PI*y))/2;
}

