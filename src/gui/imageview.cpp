
#include <QDebug>
#include <QGraphicsPixmapItem>
#include <QGraphicsTextItem>

#include "imageview.h"
/* Zoom and panning:
 * http://www.qtcentre.org/wiki/index.php?title=QGraphicsView:_Smooth_Panning_and_Zooming
 */

imageView::imageView(QWidget *parent) : QGraphicsView(parent)
{    
    panningLocked  = false;
    mousePressed = false;
    setRenderHints(QPainter::Antialiasing | QPainter::SmoothPixmapTransform);

    QGraphicsScene *scene = new QGraphicsScene();
    setScene(scene);
    setBackgroundBrush(QBrush(Qt::lightGray, Qt::SolidPattern));
    setCursor(Qt::CrossCursor);
}

void imageView::drawLayer(TLayer &pic, int w, int h) {
   int i, j;
   QImage *image = new QImage(w, h, QImage::Format_ARGB32);
   if (image) {
    // delete image;
   }
   for (j = 0; j < h; j++) {
     QRgb *line = (QRgb*)image->scanLine(j);
     for (i = 0; i < w; i++) {
       line[i] = (QRgb)(0xFF000000)
          | ((QRgb)(0x00FF0000 & (pic[i + j * w][0] << 16)))
          | ((QRgb)(0x0000FF00 & (pic[i + j * w][1] << 8)))
          | ((QRgb)(0x000000FF & (pic[i + j * w][2] << 0)));
     }
   }
   if (pixmap) {
   //scene()->removeItem(pixmap);
   //delete pixmap;
   }
   pixmap = new QGraphicsPixmapItem(QPixmap::fromImage(*image));
   pixmap->setPos(0,0);
   scene()->addItem(pixmap);
}

void imageView::openImage(QString fileName)
{
    // todo: free image and pixmap if already loaded
    image = new QImage(fileName);
    pixmap = new QGraphicsPixmapItem(QPixmap::fromImage(*(image)));
    pixmap->setPos(0,0);
    scene()->addItem(pixmap);
}

QPointF imageView::transformToImageSpace(QPointF p)
{
    QPointF res;
    res.setX( (p.x() - pixmap->boundingRect().x())
              / pixmap->boundingRect().width() );
    res.setY( (p.y() - pixmap->boundingRect().y())
              / pixmap->boundingRect().height() );
    return res;
}

QPointF imageView::transformFromImageSpace(QPointF p)
{
    QPointF res;
    res.setX( p.x() * pixmap->boundingRect().width()
              + pixmap->boundingRect().x());
    res.setY( p.y() * pixmap->boundingRect().height()
              + pixmap->boundingRect().y());
    return res;
}

void imageView::fitToScreen()
{
    this->fitInView(scene()->sceneRect());
}

void imageView::SetCenter(const QPointF& centerPoint)
{
    QRectF visibleArea = mapToScene(rect()).boundingRect();
    QRectF sceneBounds = sceneRect();

    double boundX = visibleArea.width() / 2.0;
    double boundY = visibleArea.height() / 2.0;
    double boundWidth = sceneBounds.width() - 2.0 * boundX;
    double boundHeight = sceneBounds.height() - 2.0 * boundY;

    QRectF bounds(boundX, boundY, boundWidth, boundHeight);

    if(bounds.contains(centerPoint)) {
        CurrentCenterPoint = centerPoint;
    } else {
        if(visibleArea.contains(sceneBounds)) {
            CurrentCenterPoint = sceneBounds.center();
        } else {
            CurrentCenterPoint = centerPoint;
            if(centerPoint.x() > bounds.x() + bounds.width()) {
                CurrentCenterPoint.setX(bounds.x() + bounds.width());
            } else if(centerPoint.x() < bounds.x()) {
                CurrentCenterPoint.setX(bounds.x());
            }
            if(centerPoint.y() > bounds.y() + bounds.height()) {
                CurrentCenterPoint.setY(bounds.y() + bounds.height());
            } else if(centerPoint.y() < bounds.y()) {
                CurrentCenterPoint.setY(bounds.y());
            }

        }
    }
    centerOn(CurrentCenterPoint);
}

void imageView::mousePressEvent(QMouseEvent* event)
{
    QGraphicsView::mousePressEvent(event);
    if(!panningLocked) {
        LastPanPoint = event->pos();
    }
}

void imageView::mouseReleaseEvent(QMouseEvent* event)
{
    if(!panningLocked) {
        LastPanPoint = QPoint();
    }
    QGraphicsView::mouseReleaseEvent(event);
}

void imageView::mouseMoveEvent(QMouseEvent* event)
{
    QGraphicsView::mouseMoveEvent(event);
    if(!panningLocked) {
        if(!LastPanPoint.isNull()) {
            QPointF delta = mapToScene(LastPanPoint) - mapToScene(event->pos());
            LastPanPoint = event->pos();
            SetCenter(GetCenter() + delta);
        }
    }
}

void imageView::zoom(QPoint center, qreal scaleFactor)
{
    QPointF pointBeforeScale(mapToScene(center));
    QPointF screenCenter = GetCenter();
    scale(scaleFactor, scaleFactor);
    QPointF pointAfterScale(mapToScene(center));
    QPointF offset = pointBeforeScale - pointAfterScale;
    QPointF newCenter = screenCenter + offset;
    SetCenter(newCenter);
}


void imageView::wheelEvent(QWheelEvent* event)
{
    double scaleFactor = 1.15;
    QGraphicsView::wheelEvent(event);
    zoom(event->pos(), (event->delta() > 0) ? scaleFactor : 1.0 / scaleFactor);
}

void imageView::resizeEvent(QResizeEvent* event)
{
    QRectF visibleArea = mapToScene(rect()).boundingRect();
    SetCenter(visibleArea.center());
    QGraphicsView::resizeEvent(event);
}
