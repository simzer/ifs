unit IFS;

{$MODE Delphi}

interface

uses Math,SysUtils,ProgressControll;

type CGFunctionWeight = array[0..47] of double;

type oversampledPixel = array[0..2,0..2] of double;

type TProgressProcedure = procedure(progress:integer);

type TPixel = array[0..2] of byte;
type TLayer = array of array of TPixel;

type CGModel = class
        a:array of CGFunctionWeight;
        ai:array of CGFunctionWeight;
        a2:array of CGFunctionWeight;
        b: array of CGFunctionWeight;
        c: array of array[0..2] of byte;
        c2: array of array[0..2] of byte;
        distortWeights:array of array[0..2] of double;
        daFunctions:array[0..9] of integer;
        da:array [1..27] of record
         x,y:double;
        end;
        bckColor : record
          red,green,blue:byte;
        end;
        color : record
          red,green,blue,alpha:byte;
        end;
        brightness,contrast:integer;
        blur:double;
        probcomp : double;
        ipPow : integer;
        colorContrast : double;
        RotY,RotZ : double;
        camdistance : double;
        distorsion : procedure(var x,y:double);
        distorsions : array of array[0..2] of procedure(var x,y:double);
        conbination:integer;
        centralize:double;
        curved:double;
        width,height:integer;
        iteration : integer;
        density:double;
        DistorType : integer;
        GammaCorrection : double;
        angle:double;
        angledarray:double;
        FunctionNum: double;
        symmetryHor:double;
        symmetryVer:double;
        MoveFrac : double;
        MoveLimit : double;
        XScale,YScale,ZScale:double;
        XOffset,YOffset,ZOffset:double;
        field : array of array of array[0..3] of oversampledPixel;
        function getChild : CGModel;
        function Copy : CGModel;
        Constructor Create();overload;
        Constructor Create(Centr,curv,dist,iter,struct:integer;arrays,gamma,dens,symH,symV,movF,movL:double;bright,contr,blurr:integer);overload;
        Procedure SetProperties(Centr,curv,dist,iter,struct:integer;arrays,gamma,dens,symH,symV,movF,movL:double;brigth,contr,blurr:integer);
        Procedure CreateWeights(n:integer);
        Procedure CreateColors(n:integer);
        Procedure calculateFunctionWeights;
        Procedure addColor(r,g,b,bckr,bckg,bckb,alpha:byte);
        procedure CopyWeights(cg : cgmodel);
        procedure CopyColors(cg : cgmodel);
        function CreateField(pp : TProgressControll):boolean;
        function CGMap(pp : TProgressControll;w,h:integer):TLayer;
        Procedure Distort(var x,y:double);
end;

implementation

uses IFSDistort;

constructor CGModel.Create();
begin;
end;

function CGModel.Copy : CGModel;
   var i,n : integer;
begin
   result := CGModel.Create;
   result.iteration := self.iteration;
   result.blur:=self.blur;
   result.density:=self.density;
   result.Centralize:=self.centralize;
   result.Curved:=self.curved;
   result.distorType:=self.DistorType;
   result.gammaCorrection:=self.GammaCorrection;
   result.symmetryHor:=self.symmetryHor;
   result.symmetryVer:=self.symmetryVer;
   result.MoveFrac:=self.MoveFrac;
   result.MoveLimit:=self.MoveLimit;
   result.angledArray:=self.angledarray;
   result.xScale:=self.xScale;
   result.YScale:=self.YScale;
   result.XOffset:=self.XOffset;
   result.YOffset:=self.YOffset;
   result.conbination:=self.conbination;
   result.brightness:=self.brightness;
   result.contrast:=self.contrast;
   result.angle:=self.angle;
   result.FunctionNum:=self.FunctionNum;
   result.bckColor.red:=self.bckColor.red;
   result.bckColor.green:=self.bckColor.green;
   result.bckColor.blue:=self.bckColor.blue;
   result.color.red:=self.color.red;
   result.color.green:=self.color.green;
   result.color.blue:=self.color.blue;
   result.color.alpha:=self.color.alpha;
   result.CopyWeights(self);
   result.CopyColors(self);
   setlength(distortWeights,length(self.distortWeights));
   setlength(distorsions,length(self.distorsions));
   for n := 0 to high(distortWeights) do
      for i:=0 to 2 do begin
         result.distortWeights[n][i]:=self.distortWeights[n][i];
         result.distorsions[n][i]:=self.distorsions[n][i];
      end;
   result.distorsion:=self.distorsion;
   for i:=1 to 27 do begin
      result.da[i].x:=self.da[i].x;
      result.da[i].y:=self.da[i].y;
   end;
   for i:=0 to 9 do result.daFunctions[i]:=self.daFunctions[i];
end;

function CGModel.getChild : CGModel;
      var i,j : integer;
          d1,d2,f : double;
          frac : integer;
begin
   frac := 20; // 5%
   result := self.Copy;
   for i:=0 to length(result.a)-1 do begin
       for j:=0 to high(a[i]) do begin
          d1:=result.a[i][j];
          d2:=2*Random-1;
          f := random * frac /100;
          result.a[i][j]:=d1*(1-f)+d2*f;
       end;
    end;
end;

Constructor CGModel.Create(Centr,curv,dist,iter,struct:integer;arrays,gamma,dens,symH,symV,movF,movL:double;bright,contr,blurr:integer);
    var i,j,dt:integer;
begin
    iteration := iter;
    blur:=blurr/100;
    density:=dens;
    Centralize:=centr/100;
    Curved:=curv/100;
    distorType:=dist;
    gammaCorrection:=gamma;
    symmetryHor:=symH;
    symmetryVer:=symV;
    moveFrac := movF;
    moveLimit := movL;
    angledArray:=arrays;
    xScale:=1;
    YScale:=1;
    ZScale:=1;
    XOffset:=0;
    YOffset:=0;
    ZOffset:=0;
    conbination:=10;
    brightness:=bright;
    contrast:=Contr;
    if arrays>1 then angle:=2*system.pi/arrays else angle:=0;
    FunctionNum:=1+9*(1-Struct/100);
    CreateWeights(10);
    CreateColors(10);
    addColor(0,0,0,0,0,0,0);
    setlength(distortWeights,10);
    setlength(distorsions,10);
    for j := 0 to 9 do begin
       for i:=0 to 2 do begin
          distortWeights[j][i]:=random;
          if (distortype>0) and (distortype<28) and (i=0) then dt:=distortype else dt:=1+random(27);
          distorsions[j][i] := IFSDistorts[dt];
       end;
    end;
    distorsion:=distorsions[0][0];
    for i:=1 to 27 do begin
       da[i].x:=sqr(random);
       da[i].y:=sqr(random);
    end;
    for i:=0 to 9 do daFunctions[i]:=1+random(27);
end;

Procedure CGModel.SetProperties;
    var i,j,dt:integer;
begin
    if Centr<>-1 then Centralize:=centr/100;
    if Curv<>-1 then Curved:=curv/100;
    blur:=blurr/100;
    //prev iteration := iter;
    iteration := trunc(power(10,round(1+(((log10(iter))-1)*3))));
    density:=dens;
    distorType:=dist;
    symmetryHor:=symH;
    symmetryVer:=symV;
    moveLimit := movL;
    moveFrac := movF;
    gammaCorrection:=gamma;
    angledArray:=arrays;
    conbination:=10;
    brightness:=brigth;
    contrast:=Contr;
    FunctionNum:=1+9*(1-Struct/100);
    if arrays>1 then angle:=2*system.pi/arrays else angle:=0;

    setlength(distortWeights,10);
    for j := 0 to 9 do begin
       for i:=0 to 2 do begin
          distortWeights[j][i]:=random;
          if (distortype>0) and (distortype<28) and (i=0) then dt:=distortype else dt:=1+random(27);
          distorsions[j][i] := IFSDistorts[dt];
       end;
   end;
   distorsion:=distorsions[0][0];
end;

Procedure CGModel.addColor(r,g,b,bckr,bckg,bckb,alpha:byte);
var i:integer;
begin
  bckColor.red:=bckr;
  bckColor.green:=bckg;
  bckColor.blue:=bckb;
  if (r=0) and (g=0) and (b=0) then begin
     R:=1;
     G:=1;
     B:=1;
  end;
  Color.red:=r;
  Color.green:=g;
  Color.blue:=b;
  Color.alpha:=alpha;
  for i:=0 to high(c) do begin
     c2[i][0]:=trunc((alpha*r+(255-alpha)*c[i][0])/255);
     c2[i][1]:=trunc((alpha*g+(255-alpha)*c[i][1])/255);
     c2[i][2]:=trunc((alpha*b+(255-alpha)*c[i][2])/255);
  end;
end;

Procedure CGModel.CreateWeights(n:integer);
   var i,j : integer;
begin
    setlength(a,n);
    setlength(ai,n);
    setlength(b,n);
    for i:=0 to n-1 do begin
       for j:=0 to high(a[i]) do begin
             a[i][j]:=2*Random-1;
             ai[i][j]:=sqrt(1-sqr(a[i][j]))*sign(2*Random-1);
             b[i][j]:=2*Random-1;
       end;
    end;
end;

procedure CGModel.CopyWeights(cg : cgmodel);
   var i,j : integer;
begin
    setlength(a,length(cg.a));
    setlength(b,length(cg.a));
    for i:=0 to length(cg.a)-1 do begin
       for j:=0 to high(a[i]) do begin
             a[i][j]:=cg.a[i][j];
             b[i][j]:=cg.b[i][j];
       end;
    end;
end;


Procedure CGModel.CreateColors(n:integer);
   var i : integer;
begin
    setLength(c,n);
    setLength(c2,n);
    for i:=0 to n-1 do begin
       c[i][0]:=Random(256);
       c[i][1]:=Random(256);
       c[i][2]:=Random(256);
    end;
end;

procedure CGModel.CopyColors(cg : cgmodel);
   var i : integer;
begin
    setLength(c,length(cg.c));
    setLength(c2,length(cg.c));
    for i:=0 to length(cg.c)-1 do begin
       c[i][0]:=cg.c[i][0];
       c[i][1]:=cg.c[i][1];
       c[i][2]:=cg.c[i][2];
       c2[i][0]:=cg.c2[i][0];
       c2[i][1]:=cg.c2[i][1];
       c2[i][2]:=cg.c2[i][2];
    end;
end;

Procedure CGModel.calculateFunctionWeights;
    var i,n,nn:integer;
        t,sum1,sum2 : double;
        mul : array [0..5] of double;
begin
   setlength(a2,length(a));
   for i:=0 to high(a) do begin
      mul[0]:=1;
      mul[1]:=(0.4+0.4*sign(abs(a[i][1])-0.5)*4*sqr(abs(a[i][1])-0.5))*mul[0];
      mul[2]:=((0.5-mul[1])+(3/24)*sqr(a[i][2])+(5/24)*a[i][2]+(1/3))*(mul[0]+mul[1]);
      mul[3]:=mul[1];
      mul[4]:=mul[0];
      mul[5]:=mul[0]*mul[1];
      if a[i][5]>a[i][0] then begin
         t:=mul[0];
         mul[0]:=mul[1];
         mul[0]:=t;
      end;
      sum1:=0;
      sum2:=0;
      for n:=0 to 5 do begin
         if n = 0 then
                nn := 7
         else
                if n = 1 then nn := 6 else nn := n+6;
         a2[i][n]:=sign(a[i][n])*mul[n]*centralize+(1-centralize)*a[i][n];
         a2[i][nn]:=sign(a[i][n+6])*mul[n]*centralize+(1-centralize)*a[i][nn];
         if n>=3 then begin
            a2[i][n] := a2[i][n] * curved;
            a2[i][nn] := a2[i][nn] * curved;
         end else begin
            sum1:=sum1+abs(a2[i][n]);
            sum2:=sum2+abs(a2[i][nn]);
         end;
      end;
      if sum1<>0 then
      for n:=0 to 5 do a2[i][n]:=a2[i][n]/sum1*centralize+(1-centralize)*a2[i][n];
      if sum2<>0 then
      for n:=6 to 11 do a2[i][n]:=a2[i][n]/sum2*centralize+(1-centralize)*a2[i][n];
   end;
end;

function CGModel.CreateField;
  var imax,i,j,n,k,cgt,xm,ym,typMax:integer;
      dx,dy,x,y,xs,ys,xt,yt,typd,d,d1,d2:double;
      R,G,B,r0,g0,b0,ra:double;
  var typ,typ2,typPrev:integer;
      v1,v2,xnew,ynew:double;
      an : array[0..23] of double;
      cn : array[0..2] of byte;
  var xp,yp:double;
  var dist,fi:double;
  var xmul,ymul,cmul:double;
      xnew2,ynew2,tx,ty,txnew,tynew : double;
      xprev,yprev,dprev,mf,ml : double;
      constFunct,counter : integer;
      ip,ipn,cip, osx,osy : double;
      osi,osj : integer;

  var xs0,ys0 : double;
      Distorsions0 : array[0..2] of procedure(var x,y:double);
      distortweights0 : array[0..2] of double;


begin
   pp.start;
   result:=true;
   SetLength(field,width,height);
   calculateFunctionWeights; 
   imax:=trunc(width*height*density/(100*iteration));
   xprev := 0;
   yprev := 0;
   typprev := 0;
   dprev := 1;
   mf := power(100,moveFrac);
   ml := max(0.25,movelimit){*2};
   x:=2*Random-1;
   y:=2*Random-1;
   R:=0;
   G:=0;
   B:=0;
   counter := 0;
   probcomp := 0.33;
   ippow := 100;
   colorContrast := 50;
   cip := power(10,((100-colorContrast)/50-1));
   ip := power(10,(-ippow/50));
   For i:=0 to imax do begin
      if not pp.isActual(trunc(100*i/imax)) then begin
         result:=false;
         setlength(a2,0);
         exit;
      end;
      for j:=1 to iteration do begin
         inc(counter);
         if random<probcomp then typd := typprev else begin
            typd:=random*functionnum{-1};
            if trunc(typd)=typprev then typd := typd+1;
         end;
         typ:=trunc(typd);
         if ippow = 100 then if typd-typ<=0.5 then ipn := 1 else ipn := 0 else
            ipn := (1-(sign(typd-typ-0.5)*power(abs(2*(typd-typ-0.5)),ip)))/2;
         for k := 0 to 11 do
            an[k] := a2[typ][k]*ipn+a2[typ+1][k]*(1-ipn);
         for k := 0 to 2 do
            cn[k] := trunc(c2[typ][k]*ipn+c2[typ+1][k]*(1-ipn));

         d := random;
         if mf = 100 then d := 1 else d := power(d,1/mf);
         d1 := d*ml+(1-d)*random;
         d2 := d*ml+(1-d)*random;

         R:=(1-ml)*R + ml*(cip*R+cn[0])/(cip+1);
         G:=(1-ml)*G + ml*(cip*G+cn[1])/(cip+1);
         B:=(1-ml)*B + ml*(cip*B+cn[2])/(cip+1);

         tx := ml*x+(1-ml)*xprev;
         ty := ml*y+(1-ml)*yprev;
         xnew:=a2[typ][0]*tx+a2[typ][1]*ty+a2[typ][2]
                +a2[typ][3]*tx*tx+a2[typ][4]*ty*ty+a2[typ][5]*tx*ty
//              + a2[typ][12]*sin(a2[typ][13]*tx+a2[typ][14]*pi)
//              + a2[typ][15]*sin(a2[typ][16]*ty+a2[typ][17]*pi)
              ;
         ynew:=a2[typ][6]*tx+a2[typ][7]*ty+a2[typ][8]
              +a2[typ][9]*tx*tx+a2[typ][10]*ty*ty+a2[typ][11]*tx*ty
//              + a2[typ][18]*sin(a2[typ][19]*tx+a2[typ][20]*pi)
//              + a2[typ][21]*sin(a2[typ][22]*ty+a2[typ][23]*pi)
              ;
         tx := xnew
//         /3
         ;
         ty := ynew
//         /3
         ;

         xnew := d1*x+(1-d1)*xprev;
         ynew := d2*y+(1-d2)*yprev;
         xprev := x;
         yprev := y;
         x := xnew;
         y := ynew;

         xnew:=a2[typ][0]*x+a2[typ][1]*y+a2[typ][2]
              +a2[typ][3]*x*x+a2[typ][4]*y*y+a2[typ][5]*x*y
//prev            + a2[typ][12]*sin(a2[typ][13]*x+a2[typ][14]*pi)
//prev              + a2[typ][15]*sin(a2[typ][16]*y+a2[typ][17]*pi)
              ;
         ynew:=a2[typ][6]*x+a2[typ][7]*y+a2[typ][8]
              +a2[typ][9]*x*x+a2[typ][10]*y*y+a2[typ][11]*x*y
//prev              + a2[typ][18]*sin(a2[typ][19]*x+a2[typ][20]*pi)
//prev              + a2[typ][21]*sin(a2[typ][22]*y+a2[typ][23]*pi)
              ;

         xnew := xnew;
         ynew := ynew;
//prev          xnew := xnew /3;
//prev         ynew := ynew /3;

         typprev := typ;

         if (abs(xnew)>10) or (abs(ynew)>10) then begin
            x:=2*random-1;
            y:=2*random-1;
            tx :=x;
            ty :=y;
            counter := 0;
         end else begin
            x:=x+(xnew-x)*(1+(random-0.5)*0.1*blur);
            y:=y+(ynew-y)*(1+(random-0.5)*0.1*blur);
         end;
         X:=(X-XOffset)/XScale;
         Y:=(Y-YOffset)/YScale;
         if (distorType>0) and (distorType<28) then Distorsion(x,y);
         if (distorType=28) then begin
            xs:=0;
            ys:=0;
            xs0:=0;
            ys0:=0;
            for k:=0 to 2 do begin
               xt:=x;
               yt:=y;
               xt:=x;
               yt:=y;
               Distorsions[typ][k](xt,yt);
               xs:=xs+distortweights[typ][k]*xt;
               ys:=ys+distortweights[typ][k]*yt;
               if j = 1 then begin
                  xs0 := xs;
                  ys0 := ys;
               end else begin
                  xt:=x;
                  yt:=y;
                  Distorsions0[k](xt,yt);
                  xs0:=xs0+distortweights0[k]*xt;
                  ys0:=ys0+distortweights0[k]*yt;
               end;
               Distorsions0[k] := Distorsions[typ][k];
               distortweights0[k] := distortweights[typ][k];
            end;
            x:=(1-ml)*xs + ml*(3*xs+xs0)/4;
            y:=(1-ml)*ys + ml*(3*ys+ys0)/4;
         end;
         if (distortype=29) then distort(x,y);
         if (random<(symmetryHor/2)) then x:=-x;
         if (random<(symmetryVer/2)) then y:=-y;
         if angle>0 then begin
             dist:=sqrt(x*x+y*y);
             fi:=arctan2(y,x);
             ra:=trunc(random*angledArray);
             x:=dist*cos(fi+angle*ra);
             y:=dist*sin(fi+angle*ra);
         end;
         if (x>=-1) and (x<1) and (y>=-1) and (y<1) and
            (counter >=20) then begin
            osx := (x+1)*(width/2);
            osy := (y+1)*(height/2);
            xm:=trunc(osx);
            ym:=trunc(osy);
            osi := trunc(3*(osx-xm));
            osj := trunc(3*(osy-ym));
            field[Xm,Ym,0][osi,osj]:=field[Xm,Ym,0][osi,osj]+255;
            field[Xm,Ym,1][osi,osj]:=field[Xm,Ym,1][osi,osj]+R;
            field[Xm,Ym,2][osi,osj]:=field[Xm,Ym,2][osi,osj]+G;
            field[Xm,Ym,3][osi,osj]:=field[Xm,Ym,3][osi,osj]+B;
         end;
         x := tx;
         y := ty;
      end;
   end;
   pp.finish;
   setlength(a2,0);
end;

function CGModel.CGMap;
   var i,j,k,l:integer;
       R,G,B,max,r0,g0,b0,a,ref:double;
begin
   width:=w;
   height:=h;
   if not CreateField(pp) then begin
      result:=nil;
      Field:=nil;
      exit;
   end;
   setlength(result, width, height);
   max:=0;
   for j:=0 to height-1 do begin
      for i:=0 to width-1 do begin
         for k := 0 to 2 do for l := 0 to 2 do begin
            ref:=Field[i,j,0][k,l];
            if ref>max then
                max:=ref;
         end;
      end;
   end;
   if max<>0 then begin
     for j:=0 to height-1 do begin
       for i:=0 to width-1 do begin
         a := 0;
         R := 0;
         G := 0;
         B := 0;
         for k := 0 to 2 do for l := 0 to 2 do begin
            ref := Field[i,j,0][k,l];
            if ref<>0 then begin
               r0:=Field[i,j,1][k,l]/ref;
               g0:=Field[i,j,2][k,l]/ref;
               b0:=Field[i,j,3][k,l]/ref;
            end else begin
               r0:=bckColor.red/255;
               g0:=bckColor.green/255;
               b0:=bckColor.blue/255;
            end;
            r:=r+r0;
            g:=g+g0;
            b:=b+b0; 
            if ref>a then a:=ref;
          end;  
          if false then begin
            if ref <> 0 then a:=ln(a)/ln(max) else a := 0;
            a:=power(a,1/gammaCorrection);
          end else begin
            a:=a/max;
            if a<>0 then begin
               a:=ln(1+100*a)/ln(101);
               a:=power(a,1/gammaCorrection);
            end;
          end;
//          a:=a+brightness/100;
//          a :=((a*255-128)*(tan((contrast+100)*pi/401))+128)/255;  
        r := 255 * r / 9;
        g := 255 * g / 9;
        b := 255 * b / 9;
        r := r * (contrast+50)/100 + brightness; 
        g := g * (contrast+50)/100 + brightness; 
        b := b * (contrast+50)/100 + brightness; 
        r:=r*a+(1-a)*bckColor.red;
        g:=g*a+(1-a)*bckColor.green;
        b:=b*a+(1-a)*bckColor.blue;
        Result[i][j][0] := math.min(math.Max(0,trunc(R)),255);
        Result[i][j][1] := math.min(math.Max(0,trunc(G)),255);
        Result[i][j][2] := math.min(math.Max(0,trunc(B)),255);
       end;
     end;
   end;
   Field:=nil;
end;

Procedure CGModel.Distort(var x,y:double);
  var dt:integer;
  x0,y0:double;
begin
  dt:=random(Conbination);
  x0:=x;y0:=y;
  IFSDistorts[daFunctions[dt]](x,y);
  x:=x0*(1-da[dt].x)+x*da[dt].x;
  y:=y0*(1-da[dt].y)+y*da[dt].y;
end;

end.



