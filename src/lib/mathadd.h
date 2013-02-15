
#ifndef _MATHADD_H_
#define _MATHADD_H_

#include <cmath>

inline double frand() { 
  return (rand() / (RAND_MAX+1.0)); 
}

inline int lrand(int max) { 
  return ((int)((double)max * rand() / (RAND_MAX+1.0))); 
}

inline double sqr(double x) { 
  return(x*x); 
}

inline double sign(double x) { 
  return ( (x < 0) ? -1 : 
           (x > 0) ?  1 : 0); 
}

inline double fmax (double a, double b ) { 
  return((a<b)?b:a); 
}

inline double fmin (double a, double b ) { 
  return((a>b)?b:a); 
}

inline int lmax (int a, int b ) { 
  return((a<b)?b:a); 
}

inline int lmin (int a, int b ) { 
  return((a>b)?b:a); 
}

#endif
