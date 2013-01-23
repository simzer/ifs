#-------------------------------------------------
#
# Project created by QtCreator 2013-01-23T15:55:11
#
#-------------------------------------------------

QT       += core gui

TARGET = ifsgui
TEMPLATE = app

INCLUDEPATH += src/lib \
               src/gui

SOURCES += src/gui/ifsgui.cpp\
           src/gui/ifsmainwin.cpp \
           src/lib/ifsio.cpp \
           src/lib/ifsdistort.cpp \
           src/lib/ifs.cpp

HEADERS  += src/gui/ifsmainwin.h \
            src/lib/ifsio.h \
            src/lib/ifsdistort.h \
            src/lib/progress.h \
            src/lib/ifs.h

FORMS    += src/gui/ifsmainwin.ui
