
#include <QMessageBox>
#include <QGraphicsView>
#include <QGraphicsPixmapItem>
#include <QFileDialog>

#include <time.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/shm.h>
#include <sys/stat.h>

#include "ifs.h"
#include "ifsio.h"

#include "ifsmainwin.h"
#include "ui_ifsmainwin.h"

ifsMainWin::ifsMainWin(QWidget *parent) :
  QMainWindow(parent),
  ui(new Ui::ifsMainWin)
{
  ui->setupUi(this);
}

ifsMainWin::~ifsMainWin()
{
  delete ui;
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
    if (mainIFS != 0) free(mainIFS);
    mainIFS = new CGModelWithIO({0,0,0,100,0.75,1,6,2000,0,0,0,0,0,0,0});
    mainIFS->loadIFS(fileName.toAscii().data());
    int fd[2];
    pipe(fd);
    pid_t p;
    if ((p = fork()) == 0) {
      close(fd[0]);
      CG->CreateField(0, w, h, fd[1]);
      free(CG);
      close(fd[1]);
      exit(0);
    }
    close(fd[1]);
    childpid[i] = p;
    int fds[1];
    fds[0] = fd[0];
    TLayer pic;
    CG->CGMap(0, w, h, pic, fds, 1);
    drawMainIFS(pic);
  }
}


void ifsMainWin::drawMainIFS(TLayer pic) {
  int w, h, i, j;
  w = mainImage->width();
  h = mainImage->height();
  for (j = 0; j < h; j++) {
    QRgb *line = (QRgb*)image->scanLine(j);
    for (i = 0; i < w; i++) {
      line[i] =
           (0x000000FF & ((QRgb)( (pic[i + j * w][0] & 0x000000FF) >> 0  ) << 0))
         | (0x0000FF00 & ((QRgb)( (pic[i + j * w][1] & 0x0000FF00) >> 8  ) << 8))
         | (0x00FF0000 & ((QRgb)( (pic[i + j * w][2] & 0x00FF0000) >> 16 ) << 16));
    }
  }
  mainImage->scene()->removeItem(mainImage->pixmap);
  delete mainImage->pixmap;
  pixmap = new QGraphicsPixmapItem(QPixmap::fromImage(*image));
  pixmap->setPos(0,0);
  scene()->addItem(pixmap);
  pixmap->setZValue(-1);
}

