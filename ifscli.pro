TEMPLATE = app
CONFIG += console
CONFIG -= qt

SOURCES += src/cli/ifscli.cpp \
    src/lib/ifsio.cpp \
    src/lib/ifsdistort.cpp \
    src/lib/ifs.cpp

HEADERS += \
    src/lib/progress.h \
    src/lib/ifsio.h \
    src/lib/ifsdistort.h \
    src/lib/ifs.h

