#ifndef IFSMAINWIN_H
#define IFSMAINWIN_H

#include <QMainWindow>

namespace Ui {
class ifsMainWin;
}

class ifsMainWin : public QMainWindow
{
  Q_OBJECT
  
public:
  explicit ifsMainWin(QWidget *parent = 0);
  ~ifsMainWin();
  
private:
  Ui::ifsMainWin *ui;
};

#endif // IFSMAINWIN_H
