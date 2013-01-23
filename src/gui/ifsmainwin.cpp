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
