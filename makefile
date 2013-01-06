
CPPSRC = $(shell ls *.cpp)

OBJS = $(CPPSRC:.cpp=.o)

all: $(OBJS)
	g++ -o ifsc $(OBJS) -lm

pas:
	fpc -O3 -Fo /usr/lib/lazarus/0.9.30.4/lcl/units/i386-linux -Mdelphi ifscli.pas

%.o: %.cpp
	g++ -O3 -Wall -c -o $@ $<

clean:
	rm -rf *.ppu *.o
