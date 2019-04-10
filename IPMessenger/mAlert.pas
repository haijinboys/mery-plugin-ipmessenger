unit mAlert;

interface

uses
{$IF CompilerVersion > 22.9}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Menus, Vcl.Imaging.pngimage, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
{$ELSE}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, pngimage, StdCtrls, ExtCtrls, Buttons,
{$IFEND}
  MeryCtrls, mMsgClass, mPerMonitorDpi;

type
  TAlertForm = class(TScaledForm)
    AlertImage: TImage;
    SmallImage: TImage;
    MediumImage: TImage;
    LargeImage: TImage;
    ExtraLargeImage: TImage;
    AlertLabel: TLabel;
    CloseButton: TCloseButton;
    AlertTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormPaint(Sender: TObject);
    procedure AlertLabelClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure AlertTimerTimer(Sender: TObject);
  private
    { Private éŒ¾ }
    FMsgItem: TMsgItem;
    procedure ReadIni;
    procedure UpdateImage;
  public
    { Public éŒ¾ }
    procedure Alert;
    property MsgItem: TMsgItem read FMsgItem write FMsgItem;
  end;

var
  AlertForm: TAlertForm;

implementation

uses
{$IF CompilerVersion > 22.9}
  System.Types, System.IniFiles, Vcl.GraphUtil,
{$ELSE}
  Types, IniFiles, GraphUtil,
{$IFEND}
  ipmsg, mCommon, mMain, mMsg, mPlugin;

{$R *.dfm}

{ TAlertForm }

procedure TAlertForm.FormCreate(Sender: TObject);
begin
  ReadIni;
end;

procedure TAlertForm.FormDestroy(Sender: TObject);
begin
  //
end;

procedure TAlertForm.FormShow(Sender: TObject);
begin
  //
end;

procedure TAlertForm.FormClose(Sender: TObject; var Action: TCloseAction);
const
  Step = 40;
  FadeTime = 2000;
var
  I, Len: Integer;
  Start: DWORD;
begin
  AlphaBlendValue := 255;
  AlphaBlend := True;
  Application.ProcessMessages;
  Start := GetTickCount;
  for I := Step downto 0 do
  begin
    AlphaBlendValue := Trunc(I * (255 / Step));
    Application.ProcessMessages;
    Len := Trunc(Start + (Step - I) * (FadeTime / Step) - GetTickCount);
    if (Len > 0) then
      Sleep(Len);
  end;
  AlphaBlendValue := 0;
  Hide;
end;

procedure TAlertForm.FormPaint(Sender: TObject);
var
  Rect: TRect;
begin
  Rect := Self.ClientRect;
  GradientFillCanvas(Canvas, $00F2E9E9, $00CDB4B5, Rect, gdVertical);
  Canvas.Brush.Style := bsClear;
  Canvas.Pen.Color := $0096908A;
  Canvas.Rectangle(0, 0, ClientWidth, ClientHeight);
end;

procedure TAlertForm.AlertLabelClick(Sender: TObject);
var
  H: THandle;
  P: TPoint;
  Buf: array [0 .. MAX_LISTBUF] of AnsiChar;
begin
  if not Assigned(FMsgItem) then
    Exit;
  AlertTimer.Enabled := False;
  AlphaBlendValue := 0;
  AlphaBlend := True;
  Hide;
  with FMsgr do
  begin
    H := Editor_New(FApplication);
    Editor_InsertString(H, PChar(FMsgItem.Text));
    P.X := 0;
    P.Y := 0;
    Editor_SetCaretPos(H, POS_LOGICAL, @P);
    Editor_SetModified(H, False);
    if (HostList.Count > 0) and (FMsgItem.UnRead) and (FMsgItem.OpenCheck) then
    begin
      StrFmt(Buf, '%d', [FMsgItem.PacketNo]);
      FMsgr.Send(FMsgItem.Addr, IPMSG_READMSG, Buf, '');
    end;
    FMsgItem.UnRead := False;
    RefreshInBoxListView;
  end;
end;

procedure TAlertForm.CloseButtonClick(Sender: TObject);
begin
  AlphaBlendValue := 0;
  AlphaBlend := True;
  Hide;
end;

procedure TAlertForm.AlertTimerTimer(Sender: TObject);
begin
  AlertTimer.Enabled := False;
  Close;
end;

procedure TAlertForm.ReadIni;
var
  S: string;
begin
  if not GetIniFileName(S) then
    Exit;
  with TMemIniFile.Create(S, TEncoding.UTF8) do
    try
      with TScaledForm.DefaultFont do
        if ValueExists('MainForm', 'FontName') then
        begin
          Name := ReadString('MainForm', 'FontName', Name);
          Size := ReadInteger('MainForm', 'FontSize', Size);
        end
        else if CheckWin32Version(6, 2) then
          Assign(Screen.IconFont);
    finally
      Free;
    end;
end;

procedure TAlertForm.UpdateImage;
var
  LImage: TImage;
begin
  inherited;
  if PixelsPerInch >= 288 then
    LImage := ExtraLargeImage
  else if PixelsPerInch >= 192 then
    LImage := LargeImage
  else if PixelsPerInch >= 144 then
    LImage := MediumImage
  else
    LImage := SmallImage;
  AlertImage.Picture.Assign(LImage.Picture);
end;

procedure TAlertForm.Alert;
const
  Step = 40;
  FadeTime = 2000;
var
  I, Len: Integer;
  Start: DWORD;
  TaskBarHandle: HWND;
  TaskBarRect, DesktopRect: TRect;
begin
  DeskTopRect.Top := 0;
  DeskTopRect.Left := 0;
  DeskTopRect.Right := GetSystemMetrics(SM_CXSCREEN);
  DeskTopRect.Bottom := GetSystemMetrics(SM_CYSCREEN);
  TaskBarHandle := FindWindowEx(0, 0, 'Shell_TrayWnd', nil);
  AlphaBlendValue := 0;
  AlphaBlend := True;
  Hide;
  Show;
  UpdateImage;
  if TaskBarHandle <> 0 then
  begin
    GetWindowRect(TaskBarHandle, TaskBarRect);
    if (TaskBarRect.Bottom < DeskTopRect.Bottom - 10) then
    begin
      Left := DeskTopRect.Right - Self.Width - 40;
      Top := TaskBarRect.Bottom + 40;
    end
    else if (TaskBarRect.Right < DeskTopRect.Right - 10) then
    begin
      Left := TaskBarRect.Right + 40;
      Top := DeskTopRect.Bottom - Self.Height - 40;
    end
    else if (DeskTopRect.Left + 10 < TaskBarRect.Left) then
    begin
      Left := TaskBarRect.Left - Self.Width - 40;
      Top := DeskTopRect.Bottom - Self.Height - 40;
    end
    else
    begin
      Left := DeskTopRect.Right - Self.Width - 40;
      Top := TaskBarRect.Top - Self.Height - 40;
    end;
  end
  else
  begin
    Left := DeskTopRect.Right - Self.Width - 40;
    Top := DeskTopRect.Bottom - Self.Height - 40;
  end;
  SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_SHOWWINDOW or SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);
  Start := GetTickCount;
  for I := 0 to Step do
  begin
    AlphaBlendValue := Trunc(I * (255 / Step));
    Application.ProcessMessages;
    Len := Trunc(Start + I * (FadeTime / Step) - GetTickCount);
    if Len > 0 then
      Sleep(Len);
  end;
  AlphaBlendValue := 255;
  AlphaBlend := False;
  with AlertTimer do
  begin
    Enabled := False;
    Enabled := True;
  end;
end;

end.
