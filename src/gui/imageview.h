#ifndef IMAGEVIEW_H
#define IMAGEVIEW_H

#include <QGraphicsScene>
#include <QMouseEvent>
#include <QGraphicsView>

#include "ifs.h"

class imageView : public QGraphicsView
{
    Q_OBJECT
public:
    explicit imageView(QWidget *parent = 0);
    void openImage(QString fileName);
    void Transform();
    QPointF transformToImageSpace(QPointF p);
    QPointF transformFromImageSpace(QPointF p);
    void drawLayer(TLayer &pic, int w, int h);
protected:
    //Holds the current centerpoint for the view, used for panning and zooming
    QPointF CurrentCenterPoint;

    //From panning the view
    QPoint LastPanPoint;

    //Set the current centerpoint in the
    void SetCenter(const QPointF& centerPoint);
    QPointF GetCenter() { return CurrentCenterPoint; }

    void mousePressEvent(QMouseEvent *event);
    void mouseMoveEvent(QMouseEvent *event);
    void mouseReleaseEvent(QMouseEvent *event);
    void wheelEvent(QWheelEvent *event);
    void resizeEvent(QResizeEvent* event);
private:
    QImage *image;
    QGraphicsPixmapItem *pixmap;
    QPointF mouseDown;
    QPointF lastCenter;
    QPointF imagePos;
    bool    panningLocked;
    bool    mousePressed;
    void    zoom(QPoint center, qreal scaleFactor);
    
signals:

public slots:
    void panningLock(void)    { panningLocked = true;  }
    void panningRelease(void) { panningLocked = false; }
    void fitToScreen();
};

#endif // IMAGEVIEW_H
