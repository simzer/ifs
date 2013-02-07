#ifndef IFSMAINWIN_H
#define IFSMAINWIN_H

#include <QThread>
#include <QMainWindow>
#include "imageview.h"
#include "qifs.h"

namespace Ui {
class ifsMainWin;
}

class MainIFSFieldCalc : public QThread
{
    Q_OBJECT
private:
    CGModelWithIO *ifs;
    int w, h;
    void run();
public:
    void setIFS(CGModelWithIO *ifs, int w, int h);
};

class MainIFSDraw : public QThread
{
    Q_OBJECT
private:
    imageView *view;
    CGModelWithIO *ifs;
    int w, h;
    void run();
public:
    void setView(imageView *view) { this->view = view; }
    void setIFS(CGModelWithIO *ifs, int w, int h);
};

class ifsMainWin : public QMainWindow
{
  Q_OBJECT

public:
  explicit ifsMainWin(QWidget *parent = 0);
  ~ifsMainWin();
  
private slots:
  void on_actionAbout_triggered();
  void on_actionOpen_IFS_triggered();

private:
  Ui::ifsMainWin *ui;
  imageView *mainView;
  QIFS mainIFS;
  MainIFSFieldCalc IFSCalc;
  MainIFSDraw IFSDraw;
};

#endif // IFSMAINWIN_H
