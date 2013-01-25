#ifndef IFSMAINWIN_H
#define IFSMAINWIN_H

#include <QMainWindow>
#include "ifs.h"
#include "ifsio.h"

namespace Ui {
class ifsMainWin;
}

class ifsMainWin : public QMainWindow
{
  Q_OBJECT

  CGModelWithIO *mainIFS;
  void drawMainIFS(TLayer pic);
public:
  explicit ifsMainWin(QWidget *parent = 0);
  ~ifsMainWin();
  
private slots:
  void on_actionAbout_triggered();

  void on_actionOpen_IFS_triggered();

private:
  Ui::ifsMainWin *ui;
};

#endif // IFSMAINWIN_H
