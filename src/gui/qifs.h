#ifndef QIFS_H
#define QIFS_H

#include <QObject>

#include "ifsio.h"

class QIFS : public QObject
{
  Q_OBJECT

public:
  CGModelWithIO *ifs;
  explicit QIFS(QObject *parent = 0);
  
signals:
  
public slots:
  void setContrast(int value) { if (ifs != 0) ifs->p.contrast = value; }
  void setBrightness(int value) { if (ifs != 0) ifs->p.brightness = value; }
  void setGamma(int value) { if (ifs != 0) ifs->p.GammaCorrection = value; }
};

#endif // QIFS_H
