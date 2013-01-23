#include <QtGui/QApplication>
#include "ifsmainwin.h"

int main(int argc, char *argv[])
{
  QApplication a(argc, argv);
  ifsMainWin w;
  w.show();
  
  return a.exec();
}
