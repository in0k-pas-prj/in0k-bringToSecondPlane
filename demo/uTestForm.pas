{$define
[Test - отметка для GitExtensions -- это ТЕСТы
}unit uTestForm;

{$mode objfpc}{$H+}

interface

uses Forms;

type

 tTestForm = class(TForm)
  protected
    procedure CreateWnd; override;
  end;

implementation
uses uMainForm;

{$R *.lfm}

procedure tTestForm.CreateWnd;
var cptn:string;
begin
    inherited;
    str(Screen.FormIndex(self),cptn);
    Name   :='Form'+cptn;
    Caption:= Name;
    MainForm.form_place(self,Screen.FormIndex(self));
end;

end.

