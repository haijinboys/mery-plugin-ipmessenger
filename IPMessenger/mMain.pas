// -----------------------------------------------------------------------------
// IPメッセンジャー
//
// Copyright (c) Kuro. All Rights Reserved.
// e-mail: info@haijin-boys.com
// www:    http://www.haijin-boys.com/
// -----------------------------------------------------------------------------

unit mMain;

interface

uses
{$IF CompilerVersion > 22.9}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Menus, Vcl.ImgList, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
{$ELSE}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ImgList, StdCtrls, ExtCtrls, ComCtrls,
{$IFEND}
  mPerMonitorDpi;

type
  TMainForm = class(TScaledForm)
    HostPopupMenu: TPopupMenu;
    SendThisMenuItem: TMenuItem;
    SendSelMenuItem: TMenuItem;
    N1: TMenuItem;
    StatusMenuItem: TMenuItem;
    OnlineMenuItem: TMenuItem;
    BusyMenuItem: TMenuItem;
    AwayMenuItem: TMenuItem;
    OfflineMenuItem: TMenuItem;
    N2: TMenuItem;
    RefreshMenuItem: TMenuItem;
    N3: TMenuItem;
    PropMenuItem: TMenuItem;
    InBoxPopupMenu: TPopupMenu;
    InBoxOpenMenuItem: TMenuItem;
    InBoxDeleteMenuItem: TMenuItem;
    OutBoxPopupMenu: TPopupMenu;
    OutBoxOpenMenuItem: TMenuItem;
    OutBoxDeleteMenuItem: TMenuItem;
    ImageList: TImageList;
    HostListView: TListView;
    Splitter: TSplitter;
    PageControl: TPageControl;
    InBoxTabSheet: TTabSheet;
    OutBoxTabSheet: TTabSheet;
    InBoxListView: TListView;
    OutBoxListView: TListView;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure HostPopupMenuPopup(Sender: TObject);
    procedure SendThisMenuItemClick(Sender: TObject);
    procedure SendSelMenuItemClick(Sender: TObject);
    procedure StatusMenuItemClick(Sender: TObject);
    procedure OnlineMenuItemClick(Sender: TObject);
    procedure BusyMenuItemClick(Sender: TObject);
    procedure AwayMenuItemClick(Sender: TObject);
    procedure OfflineMenuItemClick(Sender: TObject);
    procedure RefreshMenuItemClick(Sender: TObject);
    procedure PropMenuItemClick(Sender: TObject);
    procedure InBoxPopupMenuPopup(Sender: TObject);
    procedure InBoxOpenMenuItemClick(Sender: TObject);
    procedure InBoxDeleteMenuItemClick(Sender: TObject);
    procedure OutBoxPopupMenuPopup(Sender: TObject);
    procedure OutBoxOpenMenuItemClick(Sender: TObject);
    procedure OutBoxDeleteMenuItemClick(Sender: TObject);
    procedure HostListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure HostListViewData(Sender: TObject; Item: TListItem);
    procedure InBoxListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure InBoxListViewData(Sender: TObject; Item: TListItem);
    procedure InBoxListViewDblClick(Sender: TObject);
    procedure InBoxListViewKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure OutBoxListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure OutBoxListViewData(Sender: TObject; Item: TListItem);
    procedure OutBoxListViewDblClick(Sender: TObject);
    procedure OutBoxListViewKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private 宣言 }
    FEditor: THandle;
    FBarPos: NativeInt;
    FUpdateIPMessenger: Boolean;
    FListViewWidth: NativeInt;
    FListViewHeight: NativeInt;
    procedure ReadIni;
    procedure WriteIni;
    procedure InBoxOpen;
    procedure InBoxDelete;
    procedure OutBoxOpen;
    procedure OutBoxDelete;
  public
    { Public 宣言 }
    procedure IPMessengerAll;
    procedure SetScale(const Value: NativeInt);
    function SetProperties: Boolean;
    procedure RefreshHostListView;
    procedure RefreshInBoxListView;
    procedure RefreshOutBoxListView;
    procedure UpdateBarPos;
    property BarPos: NativeInt read FBarPos write FBarPos;
    property UpdateIPMessenger: Boolean read FUpdateIPMessenger write FUpdateIPMessenger;
    property Editor: THandle read FEditor write FEditor;
  end;

var
  MainForm: TMainForm;
  FApplication: THandle;
  FFont: TFont;

implementation

uses
{$IF CompilerVersion > 22.9}
  System.Types, System.IniFiles,
{$ELSE}
  Types, IniFiles,
{$IFEND}
  ipmsg, mCommon, mPlugin, mProp, mMsg, mMsgClass;

{$R *.dfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
begin
  if Win32MajorVersion < 6 then
    with Font do
    begin
      Name := 'Tahoma';
      Size := 8;
    end;
  FEditor := ParentWindow;
  FFont.Assign(Font);
  FUpdateIPMessenger := False;
  FListViewWidth := 320;
  FListViewHeight := 320;
  ReadIni;
  with Font do
  begin
    ChangeScale(FFont.Size, Size);
    Name := FFont.Name;
    Size := FFont.Size;
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  WriteIni;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  //
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //
end;

procedure TMainForm.HostPopupMenuPopup(Sender: TObject);
var
  Len: NativeInt;
begin
  Len := Editor_GetSelText(FEditor, 0, nil);
  SendThisMenuItem.Enabled := (HostListView.SelCount > 0) and
    (Assigned(HostListView.Selected.SubItems.Objects[0]));
  SendSelMenuItem.Enabled := (Len > 0) and
    (HostListView.SelCount > 0) and
    (Assigned(HostListView.Selected.SubItems.Objects[0]));
  RefreshMenuItem.Enabled := FMsgr.HostList.Count > 0;
end;

procedure TMainForm.SendThisMenuItemClick(Sender: TObject);
var
  S: string;
  I, Len: NativeInt;
  P1, P2: TPoint;
  H: THost;
begin
  with HostListView, FMsgr do
  begin
    if Selected = nil then
      Exit;
    I := Selected.Index;
    if HostList.Count = 0 then
    begin
      Invalidate;
      Exit;
    end;
    if (I < 0) or (I >= HostList.Count) then
      Exit;
    H := THost(HostListView.Items[I].SubItems.Objects[0]);
    Editor_Redraw(FEditor, False);
    try
      Editor_GetSelStart(FEditor, POS_LOGICAL, @P1);
      Editor_GetSelEnd(FEditor, POS_LOGICAL, @P2);
      Editor_Convert(FEditor, FLAG_CONVERT_SELECT_ALL);
      Len := Editor_GetSelText(FEditor, 0, nil);
      if Len <= 1 then
        Exit;
      SetLength(S, Len - 1);
      Editor_GetSelText(FEditor, Len, @S[1]);
      SendMessage(H, S, True);
      Editor_SetCaretPos(FEditor, POS_LOGICAL, @P1);
      Editor_SetCaretPosEx(FEditor, POS_LOGICAL, @P2, True);
    finally
      Editor_Redraw(FEditor, True);
    end;
  end;
end;

procedure TMainForm.SendSelMenuItemClick(Sender: TObject);
var
  S: string;
  I, Len: NativeInt;
  H: THost;
begin
  with HostListView, FMsgr do
  begin
    if Selected = nil then
      Exit;
    I := Selected.Index;
    if HostList.Count = 0 then
    begin
      Invalidate;
      Exit;
    end;
    if (I < 0) or (I >= HostList.Count) then
      Exit;
    H := THost(Items[I].SubItems.Objects[0]);
    Editor_Redraw(FEditor, False);
    try
      Len := Editor_GetSelText(FEditor, 0, nil);
      if Len <= 1 then
        Exit;
      SetLength(S, Len - 1);
      Editor_GetSelText(FEditor, Len, @S[1]);
      SendMessage(H, S, True);
    finally
      Editor_Redraw(FEditor, True);
    end;
  end;
end;

procedure TMainForm.StatusMenuItemClick(Sender: TObject);
begin
  OnlineMenuItem.Checked := False;
  BusyMenuItem.Checked := False;
  AwayMenuItem.Checked := False;
  OfflineMenuItem.Checked := False;
  case FMsgr.Status of
    stBusy:
      BusyMenuItem.Checked := True;
    stAway:
      AwayMenuItem.Checked := True;
    stOffline:
      OfflineMenuItem.Checked := True;
  else
    OnlineMenuItem.Checked := True;
  end;
end;

procedure TMainForm.OnlineMenuItemClick(Sender: TObject);
begin
  FMsgr.Status := stOnline;
end;

procedure TMainForm.BusyMenuItemClick(Sender: TObject);
begin
  FMsgr.Status := stBusy;
end;

procedure TMainForm.AwayMenuItemClick(Sender: TObject);
begin
  FMsgr.Status := stAway;
end;

procedure TMainForm.OfflineMenuItemClick(Sender: TObject);
begin
  FMsgr.Status := stOffline;
end;

procedure TMainForm.RefreshMenuItemClick(Sender: TObject);
begin
  with HostListView do
    if (SelCount <= 0) or (not Assigned(Selected.SubItems.Objects[0])) then
      Exit;
  FMsgr.Refresh;
end;

procedure TMainForm.PropMenuItemClick(Sender: TObject);
begin
  SetProperties;
end;

procedure TMainForm.InBoxPopupMenuPopup(Sender: TObject);
begin
  with InBoxListView do
  begin
    InBoxOpenMenuItem.Enabled := (SelCount > 0);
    InBoxDeleteMenuItem.Enabled := (SelCount > 0);
  end;
end;

procedure TMainForm.InBoxOpenMenuItemClick(Sender: TObject);
begin
  InBoxOpen;
end;

procedure TMainForm.InBoxDeleteMenuItemClick(Sender: TObject);
begin
  InBoxDelete;
end;

procedure TMainForm.OutBoxPopupMenuPopup(Sender: TObject);
begin
  with OutBoxListView do
  begin
    OutBoxOpenMenuItem.Enabled := (SelCount > 0);
    OutBoxDeleteMenuItem.Enabled := (SelCount > 0);
  end;
end;

procedure TMainForm.OutBoxOpenMenuItemClick(Sender: TObject);
begin
  OutBoxOpen;
end;

procedure TMainForm.OutBoxDeleteMenuItemClick(Sender: TObject);
begin
  OutBoxDelete;
end;

procedure TMainForm.HostListViewColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  if HostListView.Items.Count < 2 then
    Exit;
  with FMsgr do
  begin
    HostList.SortByColumnIndex(Column.Index);
    RefreshHostListView;
  end;
end;

procedure TMainForm.HostListViewData(Sender: TObject; Item: TListItem);
  function GetUserName: string;
  var
    UserChar: array [0 .. 256] of WideChar;
    UserSize: Cardinal;
  begin
    UserSize := Sizeof(UserChar) - 1;
{$IF CompilerVersion > 22.9}
    if Winapi.Windows.GetUserNameW(UserChar, UserSize) then
{$ELSE}
    if Windows.GetUserNameW(UserChar, UserSize) then
{$IFEND}
    begin
      UserChar[UserSize] := #0;
      Result := UserChar;
    end
    else
      Result := '';
  end;

var
  AUserName: string;
  H: THost;
begin
  if not Assigned(FMsgr) then
    Exit;
  with FMsgr do
  begin
    if (HostList.Count < 0) or ((HostList.Count > 0) and (HostList.Count <= Item.Index)) then
      Exit;
    if HostList.Count = 0 then
    begin
      if UserName = '' then
        AUserName := GetUserName
      else
        AUserName := UserName;
      Item.StateIndex := 3;
      Item.Caption := AUserName;
      Item.SubItems.AddObject('', nil);
      Item.SubItems.Add('');
    end
    else
    begin
      H := HostList[Item.Index];
      if H.nickName <> '' then
        AUserName := string(H.nickName)
      else
        AUserName := string(H.hostSub.userName);
      if Pos('(取り込み中)', AUserName) > 0 then
        Item.StateIndex := 1
      else if Pos('(退席中)', AUserName) > 0 then
        Item.StateIndex := 2
      else
        Item.StateIndex := 0;
      Item.Caption := AUserName;
      Item.SubItems.AddObject(string(H.groupName), H);
      Item.SubItems.Add(string(H.hostSub.hostName));
    end;
  end;
end;

procedure TMainForm.InBoxListViewColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  if InBoxListView.Items.Count < 2 then
    Exit;
  with FMsgr do
  begin
    InBoxList.SortByColumnIndex(Column.Index);
    RefreshInBoxListView;
  end;
end;

procedure TMainForm.InBoxListViewData(Sender: TObject; Item: TListItem);
var
  Msg: TMsgItem;
begin
  if not Assigned(FMsgr) then
    Exit;
  with FMsgr do
  begin
    if (InBoxList.Count <= 0) or (InBoxList.Count <= Item.Index) then
      Exit;
    Msg := InBoxList[Item.Index];
    if Msg.UnRead then
      Item.StateIndex := 4
    else
      Item.StateIndex := 5;
    Item.Caption := Msg.UserName;
    Item.SubItems.AddObject(FormatDateTime('yyyy/mm/dd hh:nn', Msg.DateTime), Msg);
    Item.SubItems.Add(IntToStr(Msg.Addr));
    Item.SubItems.Add(IntToStr(Msg.PacketNo));
    Item.SubItems.Add(IntToStr(Integer(Msg.OpenCheck)));
  end;
end;

procedure TMainForm.InBoxListViewDblClick(Sender: TObject);
begin
  InBoxOpen;
end;

procedure TMainForm.InBoxListViewKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
  begin
    InBoxDelete;
    Key := 0;
  end;
end;

procedure TMainForm.OutBoxListViewColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  if OutBoxListView.Items.Count < 2 then
    Exit;
  with FMsgr do
  begin
    OutBoxList.SortByColumnIndex(Column.Index);
    RefreshOutBoxListView;
  end;
end;

procedure TMainForm.OutBoxListViewData(Sender: TObject; Item: TListItem);
var
  Msg: TMsgItem;
begin
  if not Assigned(FMsgr) then
    Exit;
  with FMsgr do
  begin
    if (OutBoxList.Count <= 0) or (OutBoxList.Count <= Item.Index) then
      Exit;
    Msg := OutBoxList[Item.Index];
    if Msg.UnRead then
      Item.StateIndex := 4
    else
      Item.StateIndex := 5;
    Item.Caption := Msg.UserName;
    Item.SubItems.AddObject(FormatDateTime('yyyy/mm/dd hh:nn', Msg.DateTime), Msg);
    Item.SubItems.Add(IntToStr(Msg.Addr));
    Item.SubItems.Add(IntToStr(Msg.PacketNo));
  end;
end;

procedure TMainForm.OutBoxListViewDblClick(Sender: TObject);
begin
  OutBoxOpen;
end;

procedure TMainForm.OutBoxListViewKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
  begin
    OutBoxDelete;
    Key := 0;
  end;
end;

procedure TMainForm.ReadIni;
var
  S: string;
  I: NativeInt;
begin
  if not GetIniFileName(S) then
    Exit;
  with TMemIniFile.Create(S, TEncoding.UTF8) do
    try
      with FFont do
        if ValueExists('MainForm', 'FontName') then
        begin
          Name := ReadString('MainForm', 'FontName', Name);
          Size := ReadInteger('MainForm', 'FontSize', Size);
          Height := MulDiv(Height, 96, Screen.PixelsPerInch);
        end
        else if (Win32MajorVersion > 6) or ((Win32MajorVersion = 6) and (Win32MinorVersion >= 2)) then
        begin
          Assign(Screen.IconFont);
          Height := MulDiv(Height, 96, Screen.PixelsPerInch);
        end;
      FListViewWidth := ReadInteger('IPMessenger', 'ListViewWidth', FListViewWidth);
      FListViewHeight := ReadInteger('IPMessenger', 'ListViewHeight', FListViewHeight);
      for I := 0 to 2 do
        HostListView.Columns[I].Width := ReadInteger('IPMessenger', 'HostColumnWidth' + IntToStr(I), HostListView.Columns[I].Width);
      for I := 0 to 1 do
        InBoxListView.Columns[I].Width := ReadInteger('IPMessenger', 'InBoxColumnWidth' + IntToStr(I), InBoxListView.Columns[I].Width);
      for I := 0 to 1 do
        OutBoxListView.Columns[I].Width := ReadInteger('IPMessenger', 'OutBoxColumnWidth' + IntToStr(I), OutBoxListView.Columns[I].Width);
    finally
      Free;
    end;
end;

procedure TMainForm.WriteIni;
var
  S: string;
  I: NativeInt;
begin
  if FIniFailed or (not GetIniFileName(S)) then
    Exit;
  try
    with TMemIniFile.Create(S, TEncoding.UTF8) do
      try
        WriteInteger('IPMessenger', 'CustomBarPos', FBarPos);
        WriteInteger('IPMessenger', 'ListViewWidth', HostListView.Width);
        WriteInteger('IPMessenger', 'ListViewHeight', HostListView.Height);
        for I := 0 to 2 do
          WriteInteger('IPMessenger', 'HostColumnWidth' + IntToStr(I), HostListView.Columns[I].Width);
        for I := 0 to 1 do
          WriteInteger('IPMessenger', 'InBoxColumnWidth' + IntToStr(I), InBoxListView.Columns[I].Width);
        for I := 0 to 1 do
          WriteInteger('IPMessenger', 'OutBoxColumnWidth' + IntToStr(I), OutBoxListView.Columns[I].Width);
        UpdateFile;
      finally
        Free;
      end;
  except
    FIniFailed := True;
  end;
end;

procedure TMainForm.InBoxOpen;
var
  H: THandle;
  P: TPoint;
  Item: TListItem;
  Msg: TMsgItem;
  Buf: array [0 .. MAX_LISTBUF] of AnsiChar;
begin
  with FMsgr do
  begin
    if InBoxListView.SelCount = 0 then
      Exit;
    Item := InBoxListView.Selected;
    InBoxListView.Items.BeginUpdate;
    try
      while (Item <> nil) do
      begin
        Msg := TMsgItem(Item.SubItems.Objects[0]);
        H := Editor_New(FApplication);
        Editor_InsertString(H, PWideChar(Msg.Text));
        P.X := 0;
        P.Y := 0;
        Editor_SetCaretPos(H, POS_LOGICAL, @P);
        Editor_SetModified(H, False);
        if (HostList.Count > 0) and (Msg.UnRead) and (Msg.OpenCheck) then
        begin
          StrFmt(Buf, '%d', [Msg.PacketNo]);
          FMsgr.Send(Msg.Addr, IPMSG_READMSG, Buf, '');
        end;
        Msg.UnRead := False;
        Item := InBoxListView.GetNextItem(Item, sdAll, [isSelected]);
      end;
    finally
      InBoxListView.Items.EndUpdate;
    end;
    RefreshInBoxListView;
  end;
end;

procedure TMainForm.InBoxDelete;
var
  I: NativeInt;
  Item: TListItem;
begin
  with FMsgr do
  begin
    if InBoxListView.SelCount = 0 then
      Exit;
    Item := InBoxListView.Selected;
    I := 0;
    InBoxListView.Items.BeginUpdate;
    try
      while (Item <> nil) do
      begin
        InBoxList.Delete(Item.Index - I);
        Item := InBoxListView.GetNextItem(Item, sdAll, [isSelected]);
        Inc(I);
      end;
    finally
      InBoxListView.Items.EndUpdate;
      InBoxListView.ClearSelection;
    end;
    RefreshInBoxListView;
  end;
end;

procedure TMainForm.OutBoxOpen;
var
  H: THandle;
  P: TPoint;
  Item: TListItem;
  Msg: TMsgItem;
begin
  with FMsgr do
  begin
    if OutBoxListView.SelCount = 0 then
      Exit;
    Item := OutBoxListView.Selected;
    OutBoxListView.Items.BeginUpdate;
    try
      while (Item <> nil) do
      begin
        Msg := TMsgItem(Item.SubItems.Objects[0]);
        H := Editor_New(FApplication);
        Editor_InsertString(H, PWideChar(Msg.Text));
        P.X := 0;
        P.Y := 0;
        Editor_SetCaretPos(H, POS_LOGICAL, @P);
        Editor_SetModified(H, False);
        Item := OutBoxListView.GetNextItem(Item, sdAll, [isSelected]);
      end;
    finally
      OutBoxListView.Items.EndUpdate;
    end;
    RefreshOutBoxListView;
  end;
end;

procedure TMainForm.OutBoxDelete;
var
  I: NativeInt;
  Item: TListItem;
begin
  with FMsgr do
  begin
    if OutBoxListView.SelCount = 0 then
      Exit;
    Item := OutBoxListView.Selected;
    I := 0;
    OutBoxListView.Items.BeginUpdate;
    try
      while (Item <> nil) do
      begin
        OutBoxList.Delete(Item.Index - I);
        Item := OutBoxListView.GetNextItem(Item, sdAll, [isSelected]);
        Inc(I);
      end;
    finally
      OutBoxListView.Items.EndUpdate;
      OutBoxListView.ClearSelection;
    end;
    RefreshOutBoxListView;
  end;
end;

procedure TMainForm.IPMessengerAll;
begin
  RefreshHostListView;
  RefreshInBoxListView;
  RefreshOutBoxListView;
end;

procedure TMainForm.SetScale(const Value: NativeInt);
var
  P: NativeInt;
begin
  P := PixelsPerInch;
  PixelsPerInch := Value;
  with Font do
    Height := MulDiv(Height, Self.PixelsPerInch, P);
end;

function TMainForm.SetProperties: Boolean;
var
  APort: NativeInt;
  AUserName, AGroupName: string;
  ADisplayAlert: Boolean;
  AOnline: Boolean;
begin
  Result := False;
  APort := FMsgr.Port;
  AUserName := FMsgr.UserName;
  AGroupName := FMsgr.GroupName;
  ADisplayAlert := FMsgr.DisplayAlert;
  if Prop(Self, FBarPos, APort, AUserName, AGroupName, ADisplayAlert) then
  begin
    AOnline := False;
    if (FMsgr.HostList.Count > 0) and (FMsgr.Status <> stOffline) then
    begin
      AOnline := True;
      FMsgr.Close;
    end;
    FMsgr.Port := APort;
    FMsgr.UserName := AUserName;
    FMsgr.GroupName := AGroupName;
    FMsgr.DisplayAlert := ADisplayAlert;
    WriteIni;
    FUpdateIPMessenger := True;
    if AOnline then
      FMsgr.Open;
    Result := True;
  end;
end;

procedure TMainForm.RefreshHostListView;
begin
  if not Assigned(FMsgr) then
    Exit;
  with HostListView do
  begin
    if FMsgr.HostList.Count = 0 then
      Items.Count := 1
    else
      Items.Count := FMsgr.HostList.Count;
    Refresh;
  end;
end;

procedure TMainForm.RefreshInBoxListView;
begin
  if not Assigned(FMsgr) then
    Exit;
  with InBoxListView do
  begin
    Items.Count := FMsgr.InBoxList.Count;
    Refresh;
  end;
end;

procedure TMainForm.RefreshOutBoxListView;
begin
  if not Assigned(FMsgr) then
    Exit;
  with OutBoxListView do
  begin
    Items.Count := FMsgr.OutBoxList.Count;
    Refresh;
  end;
end;

procedure TMainForm.UpdateBarPos;
begin
  case FBarPos of
    CUSTOM_BAR_LEFT, CUSTOM_BAR_RIGHT:
      begin
        HostListView.Align := alTop;
        HostListView.Height := FListViewHeight;
        Splitter.Align := alTop;
        Splitter.Top := HostListView.Height;
      end;
    CUSTOM_BAR_TOP, CUSTOM_BAR_BOTTOM:
      begin
        HostListView.Align := alLeft;
        HostListView.Width := FListViewWidth;
        Splitter.Align := alLeft;
        Splitter.Left := HostListView.Width;
      end;
  end;
end;

initialization

FFont := TFont.Create;

finalization

if Assigned(FFont) then
  FreeAndNil(FFont);

end.
