unit mMsg;

interface

uses
{$IF CompilerVersion > 22.9}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
{$ELSE}
  Windows, Messages, SysUtils, Variants, Classes,
{$IFEND}
  ipmsg, mFrame, mIPMessenger, mAlert, mMsgClass;

type
  TStatus = (stOnline,
    stBusy,
    stAway,
    stOffline);

  THostListEx = class(THostList)
  private
    { Private 宣言 }
    procedure DoSort(const Index: Integer; var SortList: TList);
  public
    { Public 宣言 }
    procedure SortByColumnIndex(const Index: Integer);
  end;

  TMsgr = class
  private
    { Private 宣言 }
    FList: TFrameList;
    FIPMsg: TIPMsg;
    FPort: Integer;
    FUserName: string;
    FGroupName: string;
    FDisplayAlerts: Boolean;
    FStatus: TStatus;
    FInBoxList: TMsgList;
    FOutBoxList: TMsgList;
    FAlertForm: TAlertForm;
    procedure SetPort(const Value: Integer);
    procedure SetUserName(const Value: string);
    procedure SetGroupName(const Value: string);
    procedure SetMyStatus(const Value: TStatus);
    function GetHostList: THostListEx;
    procedure SetHostList(const Value: THostListEx);
    procedure ReadIni;
    procedure WriteIni;
  protected
    { Private 宣言 }
  public
    { Public 宣言 }
    constructor Create;
    destructor Destroy; override;
    procedure MsgrMemberChanged(Sender: TObject);
    procedure MsgrMsgArrived(Sender: TObject; UserName, HostName, Msg: AnsiString; mt: TMsgTypes; Addr, PacketNo: ULONG);
    procedure MsgrMsgInfo(Sender: TObject; addr: ULONG; mi: TMsgInfo; PacketNo: ULONG);
    procedure Open;
    procedure Close;
    procedure Send(Host, Command: ULONG; Msg, ExMsg: AnsiString);
    procedure SendMessage(Host: THost; Msg: string; Secret: Boolean);
    procedure Refresh;
    procedure RefreshInBoxListView;
    procedure RefreshOutBoxListView;
    procedure RefreshHostListView;
    property List: TFrameList read FList write FList;
    property Port: Integer read FPort write SetPort;
    property UserName: string read FUserName write SetUserName;
    property GroupName: string read FGroupName write SetGroupName;
    property DisplayAlert: Boolean read FDisplayAlerts write FDisplayAlerts;
    property Status: TStatus read FStatus write SetMyStatus;
    property HostList: THostListEx read GetHostList write SetHostList;
    property InBoxList: TMsgList read FInBoxList;
    property OutBoxList: TMsgList read FOutBoxList;
  end;

var
  FMsgr: TMsgr;
  FHostSortIndex: Integer = 0;
  FHostSortFlag: Integer = 1;

implementation

uses
{$IF CompilerVersion > 22.9}
  System.IniFiles, System.Contnrs,
{$ELSE}
  IniFiles,
{$IFEND}
  mCommon, mMain;

{ THostListEx }

function HostSortByColumn(Item1, Item2: Pointer): Integer;
var
  S1, S2: AnsiString;
begin
  Result := 0;
  case FHostSortIndex of
    0:
      begin
        if THost(Item1).nickName = '' then
          S1 := THost(Item1).hostSub.userName
        else
          S1 := THost(Item1).nickName;
        if THost(Item2).nickName = '' then
          S2 := THost(Item2).hostSub.userName
        else
          S2 := THost(Item2).nickName;
        Result := FHostSortFlag * CompareText(string(S1), string(S2));
      end;
    1:
      Result := FHostSortFlag * CompareText(string(THost(Item1).groupName), string(THost(Item2).groupName));
    2:
      Result := FHostSortFlag * CompareText(string(THost(Item1).hostSub.hostName), string(THost(Item2).hostSub.hostName));
  end;
end;

procedure THostListEx.DoSort(const Index: Integer; var SortList: TList);
begin
  FHostSortIndex := Index;
  SortList.Sort(HostSortByColumn);
  FHostSortFlag := -FHostSortFlag;
end;

procedure THostListEx.SortByColumnIndex(const Index: Integer);
begin
  if Count < 1 then
    Exit;
  DoSort(Index, FHosts);
end;

{ TIPMessenger }

procedure TMsgr.SetPort(const Value: Integer);
begin
  FPort := Value;
  FIPMsg.port := FPort;
end;

procedure TMsgr.SetUserName(const Value: string);
begin
  FUserName := Value;
  FIPMsg.NickNameStr := AnsiToUtf8(FUserName);
end;

procedure TMsgr.SetGroupName(const Value: string);
begin
  FGroupName := Value;
  FIPMsg.GroupNameStr := AnsiToUtf8(FGroupName);
end;

procedure TMsgr.SetMyStatus(const Value: TStatus);
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
  LUserName: AnsiString;
begin
  FStatus := Value;
  if FUserName = '' then
    LUserName := AnsiToUtf8(GetUserName)
  else
    LUserName := AnsiToUtf8(FUserName);
  case FStatus of
    stOnline:
      begin
        FIPMsg.NickNameStr := LUserName;
        if HostList.Count <= 0 then
          FIPMsg.Open;
        Refresh;
      end;
    stBusy:
      begin
        FIPMsg.NickNameStr := LUserName + ' (取り込み中)';
        if HostList.Count <= 0 then
          FIPMsg.Open;
        Refresh;
      end;
    stAway:
      begin
        FIPMsg.NickNameStr := LUserName + ' (退席中)';
        if HostList.Count <= 0 then
          FIPMsg.Open;
        Refresh;
      end;
    stOffline:
      begin
        FIPMsg.NickNameStr := LUserName;
        if HostList.Count > 0 then
          FIPMsg.Close;
      end;
  end;
end;

function TMsgr.GetHostList: THostListEx;
begin
  Result := THostListEx(FIPMsg.HostList);
end;

procedure TMsgr.SetHostList(const Value: THostListEx);
begin
  FIPMsg.HostList := Value;
end;

procedure TMsgr.ReadIni;
var
  S: string;
begin
  if not GetIniFileName(S) then
    Exit;
  with TMemIniFile.Create(S, TEncoding.UTF8) do
    try
      // ポート
      Port := ReadInteger('IPMessenger', 'Port', 2425);
      // ユーザ
      UserName := ReadString('IPMessenger', 'UserName', UserName);
      // グループ
      GroupName := ReadString('IPMessenger', 'GroupName', GroupName);
      // 通知を表示する
      DisplayAlert := ReadBool('IPMessenger', 'DisplayAlert', DisplayAlert);
      // 状態
      Status := TStatus(ReadInteger('IPMessenger', 'Status', Integer(stOffline)));
    finally
      Free;
    end;
end;

procedure TMsgr.WriteIni;
var
  S: string;
begin
  if FIniFailed or (not GetIniFileName(S)) then
    Exit;
  try
    with TMemIniFile.Create(S, TEncoding.UTF8) do
      try
        // ポート
        WriteInteger('IPMessenger', 'Port', Port);
        // ユーザ
        WriteString('IPMessenger', 'UserName', UserName);
        // グループ
        WriteString('IPMessenger', 'GroupName', GroupName);
        // 通知を表示する
        WriteBool('IPMessenger', 'DisplayAlert', DisplayAlert);
        // 状態
        WriteInteger('IPMessenger', 'Status', Integer(Status));
        UpdateFile;
      finally
        Free;
      end;
  except
    FIniFailed := True;
  end;
end;

constructor TMsgr.Create;
begin
  FIPMsg := TIPMsg.Create(nil);
  FIPMsg.OnMemberChanged := MsgrMemberChanged;
  FIPMsg.OnMsgArrived := MsgrMsgArrived;
  FIPMsg.OnMsgInfo := MsgrMsgInfo;
  FUserName := '';
  FGroupName := '';
  FDisplayAlerts := True;
  FInBoxList := TMsgList.Create;
  FOutBoxList := TMsgList.Create;
  FAlertForm := TAlertForm.Create(nil);
  FHostSortIndex := 0;
  FHostSortFlag := 1;
  ReadIni;
end;

destructor TMsgr.Destroy;
begin
  if HostList.Count > 0 then
    FIPMsg.Close;
  WriteIni;
  if Assigned(FAlertForm) then
    FAlertForm.Free;
  if Assigned(FOutBoxList) then
    FOutBoxList.Free;
  if Assigned(FInBoxList) then
    FInBoxList.Free;
  if Assigned(FIPMsg) then
    FIPMsg.Free;
  inherited;
end;

procedure TMsgr.MsgrMemberChanged(Sender: TObject);
begin
  if not Assigned(FList) then
    Exit;
  RefreshHostListView;
end;

procedure TMsgr.MsgrMsgArrived(Sender: TObject;
  UserName, HostName, Msg: AnsiString; mt: TMsgTypes; Addr, PacketNo: ULONG);
var
  Index: Integer;
  LUserName: AnsiString;
  LMsg: TMsgItem;
begin
  if not Assigned(FList) then
    Exit;
  LMsg := nil;
  Index := HostList.IndexOf(Addr);
  if (Index > -1) and (Index < HostList.Count) then
  begin
    if HostList[Index].nickName <> '' then
      LUserName := HostList[Index].nickName
    else
      LUserName := UserName;
  end
  else
    LUserName := UserName;
  case mt of
    mtNone:
      LMsg := TMsgItem.Create(True, string(LUserName), Now, string(Msg), Addr, PacketNo, False);
    mtSecret, mtPassword:
      LMsg := TMsgItem.Create(True, string(LUserName), Now, string(Msg), Addr, PacketNo, True);
  end;
  if Assigned(LMsg) then
  begin
    FInBoxList.Insert(0, LMsg);
    if FDisplayAlerts then
      with FAlertForm do
      begin
        MsgItem := LMsg;
        AlertLabel.Caption := string(LUserName) + ' からの新着メッセージが届きました。';
        Alert;
      end;
  end;
  RefreshInBoxListView;
end;

procedure TMsgr.MsgrMsgInfo(Sender: TObject; addr: ULONG; mi: TMsgInfo; PacketNo: ULONG);
var
  Index: Integer;
begin
  Index := HostList.IndexOf(Addr);
  if (Index > -1) and (Index < HostList.Count) then
  begin
    case mi of
      miRecv:
        begin
          //
        end;
      miRead:
        begin
          Index := FOutBoxList.IndexOfSub(addr, PacketNo);
          if (Index > -1) and (Index < FOutBoxList.Count) then
            FOutBoxList[Index].UnRead := False;
          RefreshOutBoxListView;
        end;
    end;
  end;
end;

procedure TMsgr.Close;
begin
  FIPMsg.Close;
end;

procedure TMsgr.Open;
begin
  FIPMsg.Open;
end;

procedure TMsgr.Send(Host, Command: ULONG; Msg, ExMsg: AnsiString);
begin
  FIPMsg.Send(Host, Command, Msg, ExMsg);
end;

procedure TMsgr.SendMessage(Host: THost; Msg: string; Secret: Boolean);
var
  I: Integer;
  LUserName: AnsiString;
begin
  for I := 0 to HostList.Count - 1 do
    HostList[I].SendCheck := False;
  Host.SendCheck := True;
  FIPMsg.SecretCheck := Secret;
  FIPMsg.OpenCheck := True;
  FIPMsg.PasswordCheck := False;
  FIPMsg.NormalSend(AnsiString(Msg));
  if Host.nickName = '' then
    LUserName := Host.hostSub.userName
  else
    LUserName := Host.nickName;
  FOutBoxList.Insert(0, TMsgItem.Create(True, string(LUserName), Now, Msg, Host.addr, Pred(FIPMsg.packetNo), False));
  RefreshOutBoxListView;
  Inc(FIPMsg.packetNo);
end;

procedure TMsgr.Refresh;
begin
  FIPMsg.RefreshHost(False);
end;

procedure TMsgr.RefreshHostListView;
var
  I: Integer;
  LForm: TMainForm;
begin
  for I := 0 to FList.Count - 1 do
  begin
    LForm := TIPMessengerFrame(FList[I]).Form;
    if Assigned(LForm) then
      LForm.RefreshHostListView;
  end;
end;

procedure TMsgr.RefreshInBoxListView;
var
  I: Integer;
  LForm: TMainForm;
begin
  for I := 0 to FList.Count - 1 do
  begin
    LForm := TIPMessengerFrame(FList[I]).Form;
    if Assigned(LForm) then
      LForm.RefreshInBoxListView;
  end;
end;

procedure TMsgr.RefreshOutBoxListView;
var
  I: Integer;
  LForm: TMainForm;
begin
  for I := 0 to FList.Count - 1 do
  begin
    LForm := TIPMessengerFrame(FList[I]).Form;
    if Assigned(LForm) then
      LForm.RefreshOutBoxListView;
  end;
end;

end.
