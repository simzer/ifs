
CPPSRC = $(shell ls src/*.cpp)

OBJS = $(CPPSRC:.cpp=.o)

all: $(OBJS)
	g++ -o ifsc $(OBJS) -lm

%.o: src/%.cpp
	g++ -O3 -Wall -c -o $@ $<

clean:
	rm -rf  src/*.o
