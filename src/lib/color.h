
#ifndef _COLOR_H_
#define _COLOR_H_

#include "mathadd.h"

class Color {
public:
  double r, g, b;
  Color(double r, double g, double b) 
    : r(r), g(g), b(b) {}
  void limitTo255() {
    r = fmin(fmax(0.0,r),256.0-1e-20);
    g = fmin(fmax(0.0,g),256.0-1e-20);
    b = fmin(fmax(0.0,b),256.0-1e-20);     
  }
  Color operator*(double mul) {
    Color res = *this;
    res.r *= mul;
    res.g *= mul;
    res.b *= mul; 
    return res;    
  }
  Color operator/(double div) {
    Color res = *this;
    res.r /= div;
    res.g /= div;
    res.b /= div; 
    return res;    
  }
  Color operator+(double add) {
    Color res = *this;
    res.r += add;
    res.g += add;
    res.b += add; 
    return res;   
  }
  Color operator+(const Color &add) {
    Color res = *this;
    res.r += add.r;
    res.g += add.g;
    res.b += add.b;    
    return res;
  }
};

#endif