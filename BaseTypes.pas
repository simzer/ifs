unit BaseTypes;

{$MODE Delphi}

interface

uses Map,ProgressControll,Propertyes;

function none(bottom, top : TMap; p: TProperty; pc : TProgressControll): TMap;

implementation

function none;
begin
    result:=top.Duplicate;
end;

end.
 