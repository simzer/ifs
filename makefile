
all:
	fpc -O3 -Fo /usr/lib/lazarus/0.9.30.4/lcl/units/i386-linux -Mdelphi ifscli.pas

clean:
	rm -rf *.ppu *.o
