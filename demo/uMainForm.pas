{$define
[Test - отметка для GitExtensions -- это ТЕСТы
}unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  Interfaces,
  InterfaceBase,
  //---
  uBringToSecond_LCL,
  uBringToSecond,
  //----
  uTestForm,
  //----
  LazVersion,
  LCLType, LCLIntf, LCLPlatformDef,
  SysUtils, Forms, StdCtrls, ExtCtrls, Classes;

type

  { TMainForm }

  TMainForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  protected
  protected
    function  _CTRLs_get_widest_nLabel_:tLabel;
    procedure _CTRLs_btn_setLEFT_(const target:tLabel);
    function  _CTRLs_get_widest_Button_:tButton;
    procedure _CTRLs_btn_setWDTH_(const target:tButton);
    function  _CTRLs_get_widest_lCaptn_:tLabel;
    procedure _CTRLs_mem_setWDTH_(const target:tLabel);
  protected
    procedure CreateWnd; override;
  protected
    Form1:TForm;
    Form2:TForm;
    Form3:TForm;
  public
    procedure form_place(const form:TCustomForm; const indx:integer);
    procedure info_Write;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

//==============================================================================
// ДЕМО
//

procedure TMainForm.Button1Click(Sender: TObject);
begin
    uBringToSecond_LCL.bringToSecond(Form1);
    info_Write;
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
    uBringToSecond.bringToSecond(Form2);
    info_Write;
end;

//==============================================================================
// СЛУЖЕБНОЕ
//

const
 _cTXT_Lazarus_='Lazarus';
 _cTXT_FPC_    ='FPC';

function _aboutString_:string;
begin
    result:='';
    //---
    result:=FormatDateTime('YYYYmmdd',now);
    result:=result+' ';
    //--- target
    result:=result+lowerCase({$I %FPCTARGETCPU%})+'-'+lowerCase({$I %FPCTARGETOS%})+'-'+LCLPlatformDisplayNames[GetDefaultLCLWidgetType];
    result:=result+' ';
    //--- lazarus
    result:=result+_cTXT_Lazarus_+':'+laz_version;
    result:=result+' ';
    //--- FPC
    result:=result+_cTXT_FPC_+':'+{$I %FPCVERSION%};
end;

//------------------------------------------------------------------------------

function TMainForm._CTRLs_get_widest_nLabel_:tLabel;
var w:integer;
begin
    w:=0;
    result:=nil;
    //
    if w<Label1.Width then begin
        result:=Label1;
        w:=Label1.Width;
    end;
    if w<Label2.Width then begin
        result:=Label2;
        w:=Label2.Width;
    end;
end;

procedure TMainForm._CTRLs_btn_setLEFT_(const target:tLabel);
begin
    Button1.AnchorSideLeft.Control:=target;
    Button2.AnchorSideLeft.Control:=target;
end;

function TMainForm._CTRLs_get_widest_Button_:tButton;
var w:integer;
begin
    w:=0;
    result:=nil;
    //
    if w<Button1.Width then begin
        result:=Button1;
        w:=Button1.Width;
    end;
    if w<Button2.Width then begin
        result:=Button2;
        w:=Button2.Width;
    end;
end;

procedure TMainForm._CTRLs_btn_setWDTH_(const target:tButton);
begin
    Button1.Width:=target.Width;
    Button1.AutoSize:=false;
    Button2.Width:=target.Width;
    Button2.AutoSize:=false;
end;

function TMainForm._CTRLs_get_widest_lCaptn_:tLabel;
var w:integer;
begin
    w:=0;
    result:=nil;
    //
    if w<Label3.Width then begin
        result:=Label3;
        w:=Label3.Width;
    end;
    if w<Label4.Width then begin
        result:=Label4;
        w:=Label4.Width;
    end;
end;

procedure TMainForm._CTRLs_mem_setWDTH_(const target:tLabel);
begin
    Memo1.AnchorSideRight.Control:=target;
end;

//------------------------------------------------------------------------------

procedure TMainForm.CreateWnd;
begin
    inherited;
    //
   _CTRLs_btn_setLEFT_(_CTRLs_get_widest_nLabel_);
   _CTRLs_btn_setWDTH_(_CTRLs_get_widest_Button_);
    //
    with _CTRLs_get_widest_lCaptn_ do
    self.Constraints.MinWidth:=Left+width;
    self.Constraints.MinHeight:=memo1.Top+self.Canvas.TextHeight('W')*6;
    //
    memo1.Constraints.MinWidth:=Canvas.TextWidth('W'+_aboutString_);
    if self.Constraints.MinWidth<memo1.Constraints.MinWidth
    then self.Constraints.MinWidth:=memo1.Constraints.MinWidth;
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
    info_Write;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
    {$ifOpt D+}
    Button2.ShowHint:=true;
    Button2.Hint:=cBringToSecondUNIT+'.'+Button2.Caption;
    {$endIf}
    //
    Form1:=tTestForm.Create(Application);
    Form2:=tTestForm.Create(Application);
    Form3:=tTestForm.Create(Application);
end;

//------------------------------------------------------------------------------

procedure TMainForm.info_Write;
var i:integer;
    f:TCustomForm;
begin
    memo1.Lines.BeginUpdate;
    memo1.Lines.Clear;
    memo1.Lines.Add(_aboutString_);
    //---
    for i:=0 to Screen.CustomFormZOrderCount-1 do begin
        f:=Screen.CustomFormsZOrdered[i];
        //---
        memo1.Lines.Add('['+inttostr(i)+'] F.Index='+inttostr(Screen.CustomFormIndex(f))+' '+' '+f.ClassName+'('+f.Name+')');
    end;
    //---
    memo1.Lines.EndUpdate;
end;

//------------------------------------------------------------------------------

procedure TMainForm.form_place(const form:TCustomForm; const indx:integer);
var delta:integer;
begin
    if form<>self then begin
        form.Width :=Screen.PrimaryMonitor.Width div 4;
        form.Height:=Screen.PrimaryMonitor.Height div 4;
        //---
        delta:=GetSystemMetrics(SM_CYCAPTION)*indx;
        if delta=0 then delta:=self.Canvas.GetTextHeight('H')*indx; //< это чисто для LCLgtk3
        //---
        form.Left:=Screen.PrimaryMonitor.Left+((Screen.PrimaryMonitor.Width -form.Width)  div 2)+delta;
        form.Top :=Screen.PrimaryMonitor.Top +((Screen.PrimaryMonitor.Height-form.Height) div 2)-delta;
    end;
end;

end.

