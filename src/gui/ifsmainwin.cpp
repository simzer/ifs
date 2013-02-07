
#include <QMessageBox>
#include <QGraphicsView>
#include <QGraphicsPixmapItem>
#include <QFileDialog>
#include <QSlider>
#include <QThread>

#include <time.h>

#include "ifs.h"
#include "ifsio.h"

#include "ifsmainwin.h"
#include "ui_ifsmainwin.h"


void MainIFSFieldCalc::setIFS(CGModelWithIO *ifs, int w, int h) {
  this->ifs = ifs;
  this->w = w;
  this->h = h;
}

void MainIFSDraw::setIFS(CGModelWithIO *ifs, int w, int h) {
  this->ifs = ifs;
  this->w = w;
  this->h = h;
}

void MainIFSFieldCalc::run()
{
  ifs->p.density = 100000;
  ifs->CreateField(0, w, h, 0, false);
}

void MainIFSDraw::run()
{
  TLayer pic;
  while(1) {
    if (ifs->isFieldInitialised()) {
      ifs->CGMap(0, w, h, pic, 0, 0);
      view->drawLayer(pic, w, h);
      free(pic);
    }
    usleep(10000);
  }
}

ifsMainWin::ifsMainWin(QWidget *parent) :
  QMainWindow(parent),
  ui(new Ui::ifsMainWin)
{
  ui->setupUi(this);
  mainView = new imageView(this);
  ui->centralWidget->setLayout(new QGridLayout(this));
  ui->centralWidget->layout()->addWidget(mainView);

  connect(ui->sliderContrast,   SIGNAL(valueChanged(int)), &mainIFS, SLOT(setContrast(int)));
  connect(ui->sliderBrightness, SIGNAL(valueChanged(int)), &mainIFS, SLOT(setBrightness(int)));
  connect(ui->sliderGamma,       SIGNAL(valueChanged(int)), &mainIFS, SLOT(setGamma(int)));
}

ifsMainWin::~ifsMainWin()
{
  delete ui;
  IFSCalc.exit();
  IFSDraw.exit();
}

void ifsMainWin::on_actionAbout_triggered()
{
  const QString version("2.0");
  QMessageBox::about(this,
                     QString("About IFS Illusions"),
                     QString("<b>IFS Illusions ") + version + QString("</b><br />")
                     + QString("Licensed under GPL v3<br />")
                     + QString("Copyright 2005-2013 IFSIllusions Developer Team"));
}

void ifsMainWin::on_actionOpen_IFS_triggered()
{
  QString fileName = QFileDialog::getOpenFileName(this, tr("Open IFS source file"),
                                                   "",
                                                   tr("Files (*.ifs)"));
  if (!fileName.isNull()) {
    if (mainIFS.ifs) free(mainIFS.ifs);
    mainIFS.ifs = new CGModelWithIO({0,0,0,100,0.75,1,6,2000,0,0,0,0,0,0,0});
    mainIFS.ifs->loadIFS(fileName.toAscii().data());
    int w = 640;
    int h = 480;
    IFSCalc.setIFS(mainIFS.ifs, w, h);
    IFSCalc.start();
    IFSDraw.setIFS(mainIFS.ifs, w, h);
    IFSDraw.setView(mainView);
    IFSDraw.start();
  }
}
