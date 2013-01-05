unit ProgressControll;

{$MODE Delphi}

interface

type TProcessMessages=procedure;
type TProgress=procedure(progress:integer);

type TprogressControll = class
   actual : boolean;
   onProgress : TProgress;
   onProcessMessages:TProcessMessages;
   constructor Create(p:TProgress;pm:TProcessMessages);
   procedure start;
   procedure cancel;
   procedure finish;
   function isActual(progress:integer):boolean;
end;

implementation

procedure VirtualProcessMessages;
begin
//
end;

procedure VirtualProgress(progress:integer);
begin
//
end;

constructor TprogressControll.Create(p:TProgress;pm:TProcessMessages);
begin
   if assigned(p) then
      onProgress := p
   else
      onProgress := VirtualProgress;
   if assigned(pm) then
      onProcessMessages:= pm
   else
      onProcessMessages:= VirtualProcessMessages;
end;

procedure TprogressControll.Start;
begin
   if assigned(self) then begin
      actual:=True;
      onProgress(0);
   end;
end;

procedure TprogressControll.Finish;
begin
   if assigned(self) then begin
      actual:=False;
      onProgress(0);
   end;
end;

procedure TprogressControll.Cancel;
begin
   if assigned(self) then begin
      actual:=False;
      onProgress(0);
   end;
end;

function TprogressControll.isActual;
begin
   if assigned(self) then begin
      onprocessmessages;
      result:=actual;
      if actual then onProgress(progress);
   end;
end;

end.
