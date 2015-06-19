unit mProp;

interface

uses
{$IF CompilerVersion > 22.9}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls,
{$ELSE}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
{$IFEND}
  MeryCtrls, mMain, mPerMonitorDpi;

type
  TPropForm = class(TScaledForm)
    BarPosLabel: TLabel;
    BarPosComboBox: TComboBox;
    PortLabel: TLabel;
    PortSpinEdit: TSpinEditEx;
    UserNameLabel: TLabel;
    UserNameEdit: TEdit;
    GroupNameLabel: TLabel;
    GroupNameEdit: TEdit;
    DisplayAlertCheckBox: TCheckBox;
    Bevel: TBevel;
    OKButton: TButton;
    CancelButton: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private éŒ¾ }
  public
    { Public éŒ¾ }
  end;

function Prop(AOwner: TComponent; var APos: NativeInt; var APort: NativeInt;
  var AUserName: string; var AGroupName: string;
  var ADisplayAlert: Boolean): Boolean;

var
  PropForm: TPropForm;

implementation

{$R *.dfm}


uses
{$IF CompilerVersion > 22.9}
  System.Math,
{$ELSE}
  Math,
{$IFEND}
  mCommon;

function Prop(AOwner: TComponent; var APos: NativeInt; var APort: NativeInt;
  var AUserName: string; var AGroupName: string;
  var ADisplayAlert: Boolean): Boolean;
begin
  with TPropForm.Create(AOwner) do
    try
      BarPosComboBox.ItemIndex := APos;
      PortSpinEdit.Value := APort;
      UserNameEdit.Text := AUserName;
      GroupNameEdit.Text := AGroupName;
      DisplayAlertCheckBox.Checked := ADisplayAlert;
      Result := ShowModal = mrOk;
      if Result then
      begin
        APos := BarPosComboBox.ItemIndex;
        APort := PortSpinEdit.Value;
        AUserName := UserNameEdit.Text;
        AGroupName := GroupNameEdit.Text;
        ADisplayAlert := DisplayAlertCheckBox.Checked;
      end;
    finally
      Release;
    end;
end;

procedure TPropForm.FormCreate(Sender: TObject);
begin
  if Win32MajorVersion < 6 then
    with Font do
    begin
      Name := 'Tahoma';
      Size := 8;
    end;
  with Font do
  begin
    ChangeScale(FFont.Size, Size);
    Name := FFont.Name;
    Size := FFont.Size;
  end;
end;

procedure TPropForm.FormDestroy(Sender: TObject);
begin
  //
end;

procedure TPropForm.FormShow(Sender: TObject);
begin
  //
end;

procedure TPropForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //
end;

end.
