program ifscli;

uses
  Classes, ProgressControll,
  math, IFS, IFSIO;
  

procedure doProcessMessages;
begin
end;

procedure doProgress(progress:integer);
begin
  write(chr(27), '[s  ', progress, '%   ', chr(27), '[u');
end;
  
var kep : TLayer;
    CG : CGModel;
    i, j, w, h, err : integer;
    F : TextFile;
    progress : TProgressControll;
    infile, outfile : string;

begin
  writeln('IFS Illusions Command line interface');
  writeln('usage: ifscli -w WIDTH -h HEIGHT -o OUTPUTFILE INPUTFILE');

  val(ParamStr(2), w, err);
  val(ParamStr(4), h, err);
  outfile := ParamStr(6);
  infile := ParamStr(7);
  
  writeln('Initializing...');
  progress := TProgressControll.Create(doProgress,doProcessMessages);
  
  writeln('Loading...');
  
  CG := CGModel.Create(0,0,0,100,75,1,6,2000,0,0,0,0,0,0,0);
  CG := LoadIFS(infile,CG);

  writeln('Rendering...');  
  kep := CG.CGMap(progress,w,h);
  
  writeln('Saving...');
  AssignFile(F, outfile); 
  Rewrite(F);
  Writeln(F, 'P3');
  Writeln(F, w,' ',h);
  Writeln(F, '255');
  for j:=0 to h-1 do begin
    for i:=0 to w-1 do begin
      write(F, kep[i][j][0], ' ');
      write(F, kep[i][j][1], ' ');
      write(F, kep[i][j][2], ' ');
      writeln(F);
    end;
  end;
   
  writeln('Closing...');  
  CloseFile(F);
  CG.free;
end.
