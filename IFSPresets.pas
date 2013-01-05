unit IFSPresets;

{$MODE Delphi}

interface

uses IFS;

function getIMageLogo:CGModel;
function getHenon:CGModel;
function getGasket:CGModel;
function getGold:CGModel;
function getLeaf:CGModel;
function getMapleLeaf:CGModel;
function getLeaf2:CGModel;
function getSpiral:CGModel;
function getTree:CGModel;
function getTree2:CGModel;

implementation

function getIMageLogo:CGModel;
   var i,j:integer;
       distors:double;
begin
   randomize;
   distors:=0.006;
   result:=CGModel.Create(0,100,0,100,75,1,4,1000,0,0,0,0,0,0,0);
   with result do begin
   functionnum:=4;
   xScale:=1.7;
   YScale:=1.7;
   XOffset:=0;
   YOffset:=0;
   a[0][3]:=-0.6;       a[0][4]:=-0.35; a[0][5]:=0.4;   a[0][0]:=-0.63;
   a[0][1]:=-0.7;       a[0][2]:=0.6;   a[0][9]:=0.22;  a[0][10]:=0.83;
   a[0][11]:=-0.57;      a[0][6]:=-0.17; a[0][7]:=-0.44;a[0][8]:=-0.84;
   for i:=low(a) to high(a) do for j:=0 to 11 do a[i,j]:=a[0,j]*(1+(distors*random)-(distors/2));
   end;
end;

function getHenon:CGModel;
   var i,j:integer;
       distors:double;
begin
   randomize;
   distors:=0.03;
   result:=CGModel.Create(0,100,0,50,75,1,4,1000,0,0,0,0,0,0,0);
   with result do begin
   functionnum:=4;
   xScale:=1.5;
   YScale:=0.6;
   XOffset:=0;
   YOffset:=0;
   a[0][3]:=-1.4;       a[0][4]:=0; a[0][5]:=0;   a[0][0]:=0;
   a[0][1]:=1;       a[0][2]:=1;   a[0][9]:=0;  a[0][10]:=0;
   a[0][11]:=0;      a[0][6]:=0.3; a[0][7]:=0;a[0][8]:=0;
   for i:=low(a) to high(a) do for j:=0 to 11 do
      a[i,j]:=a[0,j]*(1+(distors*random)-(distors/2));
   end;
end;

function getGasket:CGModel;
begin
   result:=CGModel.Create(0,0,0,50,75,1,2.2,400,0,0,0,0,0,0,0);
   with result do begin
   functionnum:=3;
   xScale:=0.5;
   YScale:=0.5;
   XOffset:=0.5;
   YOffset:=0.5;
   a[0][0]:=0.5;a[1][0]:=0.5; a[2][0]:=0.5;
   a[0][1]:=0;  a[1][1]:=0;   a[2][1]:=0;
   a[0][2]:=0;  a[1][2]:=0.5; a[2][2]:=0;
   a[0][6]:=0;  a[1][6]:=0;   a[2][6]:=0;
   a[0][7]:=0.5;a[1][7]:=0.5; a[2][7]:=0.5;
   a[0][8]:=0;  a[1][8]:=0;   a[2][8]:=0.5;
   end;
end;

function getGold:CGModel;
begin
   result:=CGModel.Create(0,0,0,100,75,1,6,2000,0,0,0,0,0,0,0);
   with result do begin
   functionnum:=3;
   xScale:=2;
   YScale:=2;
   XOffset:=2;
   YOffset:=2;
   a[0][0]:=0.5;a[1][0]:=1;   a[2][0]:=1;
   a[0][1]:=0;  a[1][1]:=0;   a[2][1]:=0;
   a[0][2]:=0;  a[1][2]:=1;   a[2][2]:=0;
   a[0][6]:=0;  a[1][6]:=0;   a[2][6]:=0;
   a[0][7]:=0.5;a[1][7]:=1;   a[2][7]:=1;
   a[0][8]:=0;  a[1][8]:=0;   a[2][8]:=1;
   end;
end;

function getLeaf:CGModel;
begin
   result:=CGModel.Create(0,0,0,100,75,1,6,2000,0,0,0,0,0,0,0);
   with result do begin
   functionnum:=4;
   xScale:=4;
   YScale:=-4;
   XOffset:=0;
   YOffset:=4;
   a[0][0]:=0;  a[1][0]:=0.2;   a[2][0]:=-0.15; a[3][0]:=0.75;
   a[0][1]:=0;  a[1][1]:=-0.26; a[2][1]:=0.28;  a[3][1]:=0.04;
   a[0][2]:=0;  a[1][2]:=0;     a[2][2]:=0;     a[3][2]:=0;
   a[0][6]:=0;  a[1][6]:=0.23;  a[2][6]:=0.26;  a[3][6]:=-0.04;
   a[0][7]:=0.16;a[1][7]:=0.22; a[2][7]:=0.24;  a[3][7]:=0.85;
   a[0][8]:=0;  a[1][8]:=1.6;   a[2][8]:=0.44;  a[3][8]:=1.6;
   end;
end;

function getLeaf2:CGModel;
begin
   result:=CGModel.Create(0,0,0,100,75,1,6,2000,0,0,0,0,0,0,0);
   with result do begin
   functionnum:=4;
   xScale:=0.5;
   YScale:=-0.5;
   XOffset:=0.5;
   YOffset:=0.5;
   a[0][0]:=0;     a[1][0]:=0.7248;   a[2][0]:=0.1583; a[3][0]:=0.3386;
   a[0][1]:=0.2439;a[1][1]:=0.0337;   a[2][1]:=-0.1297;a[3][1]:=0.3694;
   a[0][2]:=0;     a[1][2]:=0.2060;   a[2][2]:=0.1383; a[3][2]:=0.0679;
   a[0][6]:=0;     a[1][6]:=-0.0253;  a[2][6]:=0.3550; a[3][6]:=0.2227;
   a[0][7]:=0.3053;a[1][7]:=0.7426;   a[2][7]:=0.3676; a[3][7]:=-0.0756;
   a[0][8]:=0;     a[1][8]:=0.2538;   a[2][8]:=0.1750; a[3][8]:=0.0826;
   end;
end;

function getMapleLeaf:CGModel;
begin
   result:=CGModel.Create(0,0,0,100,75,1,6,1000,0,0,0,0,0,0,0);
   with result do begin
   functionnum:=4;
   xScale:=4;
   YScale:=-4;
   XOffset:=0;
   YOffset:=0;
   a[0][0]:=0.1400;  a[1][0]:=0.4300;   a[2][0]:=0.4500; a[3][0]:=0.4900;
   a[0][1]:=0.0100;  a[1][1]:=0.5200;   a[2][1]:=-0.4900;a[3][1]:=0;
   a[0][2]:=-0.0800; a[1][2]:=1.4900;   a[2][2]:=-1.6200; a[3][2]:=0.0200;
   a[0][6]:=0;       a[1][6]:=-0.4500;  a[2][6]:=0.4700; a[3][6]:=0;
   a[0][7]:=0.5100;  a[1][7]:=0.5000;   a[2][7]:=0.4700; a[3][7]:=0.5100;
   a[0][8]:=-1.3100; a[1][8]:=-0.7500;  a[2][8]:=-0.7400; a[3][8]:=1.62;
   end;
end;

function getSpiral:CGModel;
begin
   result:=CGModel.Create(0,0,0,300,75,1,7,1000,0,0,0,0,0,0,0);
   with result do begin
   functionnum:=3;
   xScale:=10;
   YScale:=5;
   XOffset:=0;
   YOffset:=5;
   a[0][0]:=0.787879;  a[1][0]:=-0.121212;   a[2][0]:=0.181818;
   a[0][1]:=-0.424242; a[1][1]:=0.257576;    a[2][1]:=-0.136364;
   a[0][2]:=1.758647;  a[1][2]:=-6.721654;   a[2][2]:=6.086107;
   a[0][6]:=0.242424;  a[1][6]:=0.151515;    a[2][6]:=0.090909;
   a[0][7]:=0.859848;  a[1][7]:=0.053030;    a[2][7]:=0.181818;
   a[0][8]:=1.408065;  a[1][8]:=1.377236;    a[2][8]:=1.568035;
   end;
end;

function getTree:CGModel;
begin
   result:=CGModel.Create(0,0,0,100,75,1,6,2000,0,0,0,0,0,0,0);
   with result do begin
   functionnum:=5;
   xScale:=0.5;
   YScale:=-0.5;
   XOffset:=0.5;
   YOffset:=0.5;
   a[0][0]:=0.1950;  a[1][0]:=0.4620;   a[2][0]:=-0.6370; a[3][0]:=-0.0350; a[4][0]:=-0.0580;
   a[0][1]:=-0.4880; a[1][1]:=0.4140;   a[2][1]:=0;       a[3][1]:=0.0700;  a[4][1]:=-0.07;
   a[0][2]:=0.4431;  a[1][2]:=0.2511;   a[2][2]:=0.8562;  a[3][2]:=0.4884;  a[4][2]:=0.5976;
   a[0][6]:=0.3440;  a[1][6]:=-0.2520;  a[2][6]:=0;       a[3][6]:=-0.469;  a[4][6]:=0.4530;
   a[0][7]:=0.4430;  a[1][7]:=0.3610;   a[2][7]:=0.5010;  a[3][7]:=0.0220;  a[4][7]:=-0.111;
   a[0][8]:=0.2452;  a[1][8]:=0.5692;   a[2][8]:=0.2512;  a[3][8]:=0.5069;  a[4][8]:=0.0969;
   end;
end;

function getTree2:CGModel;
begin
   result:=CGModel.Create(0,0,0,100,75,1,6,2000,0,0,0,0,0,0,0);
   with result do begin
   functionnum:=6;
   xScale:=1;
   YScale:=-1.2;
   XOffset:=0;
   YOffset:=1;
   a[0][0]:=0.05; a[1][0]:=0.05; a[2][0]:=0.6*cos(0.6980);  a[3][0]:=0.5*cos(0.3490);
   a[4][0]:=0.5*cos(-0.5240);   a[5][0]:=0.55*cos(-0.6980) ;
   a[0][1]:=0;    a[1][1]:=0;    a[2][1]:=-0.5*sin(0.6980); a[3][1]:=-0.45*sin(0.3492);
   a[4][1]:=-0.55*sin(-0.5240); a[5][1]:=-0.4*sin(-0.6980) ;
   a[0][2]:=0;    a[1][2]:=0;    a[2][2]:=0;                a[3][2]:=0;     a[4][2]:=0;     a[5][2]:=0;
   a[0][6]:=0;    a[1][6]:=0;    a[2][6]:=0.6*sin(0.6980);  a[3][6]:=0.5*sin(0.3490);
   a[4][6]:=0.5*sin(-0.5240);   a[5][6]:=0.55*sin(-0.6980) ;
   a[0][7]:=0.6;  a[1][7]:=-0.5; a[2][7]:=0.5*cos(0.6980);  a[3][7]:=0.45*cos(0.3492);
   a[4][7]:=0.55*cos(-0.5240);  a[5][7]:=0.4*cos(-0.6980) ;
   a[0][8]:=0;    a[1][8]:=1;    a[2][8]:=0.6;              a[3][8]:=1.1;   a[4][8]:=1;     a[5][8]:=0.7;
   end;
end;

end.

{
parketta
    0: begin
      xnew:=x/2;
      ynew:=y/2;
    end;
    1: begin
      xnew:=(x-dx)/2;
      ynew:=(y)/2;
    end;
    2: begin
      xnew:=(x)/2;
      ynew:=(y-dy)/2;
    end;
    3: begin
      xnew:=(x+dx)/3;
      ynew:=(y+dy)/3;
    end;

maltai kereszt
    0: begin
      xnew:=x/2;
      ynew:=y/2;
    end;
    1: begin
      xnew:=(x-dx)/2;
      ynew:=(y)/2;
    end;
    2: begin
      xnew:=(x)/2;
      ynew:=(y-dy)/2;
    end;

X   X
  X
X   X
    0: begin
      xnew:=x/d;
      ynew:=y/d;
    end;
    1: begin
      xnew:=(x+dx)/d;
      ynew:=(y-dy)/d;
    end;
    2: begin
      xnew:=(x-dx)/d;
      ynew:=(y+dy)/d;
    end;
    3: begin
      xnew:=(x-dx)/d;
      ynew:=(y-dy)/d;
    end;
    4: begin
      xnew:=(x+dx)/d;
      ynew:=(y+dy)/d;
    end;

}


