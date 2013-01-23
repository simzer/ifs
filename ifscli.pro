TEMPLATE = app
CONFIG += console
CONFIG -= qt

SOURCES += src/ifscli.cpp \
    src/ifsio.cpp \
    src/ifsdistort.cpp \
    src/ifs.cpp

HEADERS += \
    src/progress.h \
    src/ifsio.h \
    src/ifsdistort.h \
    src/ifs.h

