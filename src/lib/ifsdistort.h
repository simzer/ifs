
#ifndef __IFSDISTORT_H__
#define __IFSDISTORT_H__

typedef void (*TDistortion)(double &x, double &y);

void None(double &x, double &y);
void Sinusoidal(double &x, double &y);
void Spheical(double &x, double &y);
void Swirl(double &x, double &y);
void Horseshoe(double &x, double &y);
void Polar(double &x, double &y);
void Handkerchief(double &x, double &y);
void Heart(double &x, double &y);
void Disc(double &x, double &y);
void Spiral(double &x, double &y);
void Hiperbolic(double &x, double &y);
void Diamond(double &x, double &y);
void Ex(double &x, double &y);
void Julia(double &x, double &y);
void Weave(double &x, double &y);
void sandGlass(double &x, double &y);
void Television(double &x, double &y);
void Floverbox(double &x, double &y);
void Scape(double &x, double &y);
void HyperCircle(double &x, double &y);
void Weaves(double &x, double &y);
void Grass(double &x, double &y);
void Tube(double &x, double &y);
void Sphere(double &x, double &y);
void Geo(double &x, double &y);
void Gravity(double &x, double &y);
void Snail(double &x, double &y);
void Spirals(double &x, double &y);

extern const TDistortion IFSDistorts[];

#endif