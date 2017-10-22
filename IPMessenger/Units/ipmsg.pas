// TIPMsg.pas, version 1.0b2
// Copyright(c) Tomoaki Takebayashi(tota@os.rim.or.jp)

Unit ipmsg;

interface

// modified begin
(*
uses
  Windows, WinSock, SysUtils, Classes, Messages, Forms, Dialogs;
*)
uses
{$IF CompilerVersion > 22.9}
  Winapi.Windows, Winapi.WinSock, System.SysUtils, System.Classes,
  Winapi.Messages, Vcl.Dialogs;
{$ELSE}
  Windows, WinSock, SysUtils, Classes, Messages, Dialogs;
{$IFEND}
// modified end

const
// Const	//////////////////////////////////////////////////////////////////////////////////////////
	//	header
	IPMSG_VERSION			= $0001;
	IPMSG_DEFAULT_PORT		= $0979;

	//	command
	IPMSG_NOOPERATION		= $00000000;

	IPMSG_BR_ENTRY			= $00000001;
	IPMSG_BR_EXIT			= $00000002;
	IPMSG_ANSENTRY			= $00000003;
	IPMSG_BR_ABSENCE		= $00000004;

	IPMSG_BR_ISGETLIST		= $00000010;
	IPMSG_OKGETLIST			= $00000011;
	IPMSG_GETLIST			= $00000012;
	IPMSG_ANSLIST			= $00000013;

	IPMSG_SENDMSG			= $00000020;
	IPMSG_RECVMSG			= $00000021;
	IPMSG_READMSG			= $00000030;
	IPMSG_DELMSG			= $00000031;

	IPMSG_GETINFO			= $00000040;
	IPMSG_SENDINFO			= $00000041;

	IPMSG_GETABSENCEINFO	= $00000050;
	IPMSG_SENDABSENCEINFO	= $00000051;

	//	option for all command
	IPMSG_ABSENCEOPT		= $00000100;
	IPMSG_SERVEROPT			= $00000200;
	IPMSG_DIALUPOPT			= $00010000;

	//	option for send command
	IPMSG_SENDCHECKOPT		= $00000100;
	IPMSG_SECRETOPT			= $00000200;
	IPMSG_BROADCASTOPT		= $00000400;
	IPMSG_MULTICASTOPT		= $00000800;
	IPMSG_NOPOPUPOPT		= $00001000;
	IPMSG_AUTORETOPT		= $00002000;
	IPMSG_RETRYOPT			= $00004000;
	IPMSG_PASSWORDOPT		= $00008000;
	IPMSG_NOLOGOPT			= $00020000;
	IPMSG_NEWMUTIOPT		= $00040000;
	IPMSG_NOADDLISTOPT		= $00080000;

	HOSTLIST_DELIMIT		= '\a';
	HOSTLIST_DUMMY			= '\b';

	//	end of IP Messenger Communication Protocol version 1.0 define

	//	IP Messenger for Windows  internal define
	IPMSG_TIMERINTERVAL			= 500;
	IPMSG_GETLIST_FINISH		= 0;

	IPMSG_BROADCAST_TIMER		= $0101;
	IPMSG_SEND_TIMER			= $0102;
	IPMSG_DELETE_TIMER			= $0103;
	IPMSG_LISTGET_TIMER			= $0104;
	IPMSG_LISTGETRETRY_TIMER	= $0105;
	IPMSG_ENTRY_TIMER			= $0106;

	IPMSG_DEFAULT_LISTGETMSEC	= 3000;
	IPMSG_DEFAULT_RETRYMSEC		= 2000;
	IPMSG_DEFAULT_RETRYMAX		= 3;
	IPMSG_DEFAULT_DELAY			= 500;
	IPMSG_DEFAULT_UPDATETIME	= 10;
	IPMSG_DEFAULT_QUOTE			= '>';
	IPMSG_DEFAULT_ABSENCE		= 'ただいま、席をはずしております。';

	IPMSG_NICKNAME				= 1;
	IPMSG_FULLNAME				= 2;

	IPMSG_NAMESORT			= $00000000;
	IPMSG_IPADDRSORT		= $00000001;
	IPMSG_HOSTSORT			= $00000002;
	IPMSG_NOGROUPSORTOPT	= $00000100;
	IPMSG_ICMPSORTOPT		= $00000200;
	IPMSG_NOKANJISORTOPT	= $00000400;
	IPMSG_ALLREVSORTOPT		= $00000800;
	IPMSG_GROUPREVSORTOPT	= $00001000;
	IPMSG_SUBREVSORTOPT		= $00002000;

	WM_RECVDATA				= (WM_USER + 130);	//パケットが届いたときに、Windowsが送ってくるメッセージの定義

	MAX_UDPBUF				= 8192;
	MAX_BUF					= 1024;
	MAX_NAMEBUF				= 50;
	MAX_LISTBUF				= (MAX_NAMEBUF * 2 + 100);

	NO_NAME					= 'no_name';

type
	TMsgTypes = (mtNone, mtSecret, mtPassword);
	TMsgInfo  = (miRead, miRecv);
	
// Event	//////////////////////////////////////////////////////////////////////////////////////////
  // modified begin
  (*
	TOnMsgArrived = procedure(Sender: TObject; UserName, HostName, Msg : AnsiString; mt : TMsgTypes) of object;
  *)
  TOnMsgArrived = procedure(Sender: TObject; UserName, HostName, Msg : AnsiString; mt : TMsgTypes; Addr, PacketNo: ULONG) of object;
  // modified end
	TOnMemberChanged = procedure(Sender : TObject) of object;
  // modified begin
  (*
	TOnMsgInfo = procedure(Sender : TObject; addr : ULONG; mi : TMsgInfo) of object;
  *)
	TOnMsgInfo = procedure(Sender : TObject; addr : ULONG; mi : TMsgInfo; PacketNo: ULONG) of object;
  // modified end

// Record	 //////////////////////////////////////////////////////////////////////////////////////////
	THostSub = record
		userName : array[0..MAX_NAMEBUF] of AnsiChar;
		hostName : array[0..MAX_NAMEBUF] of AnsiChar;
		addr	 : ULONG;
	end;

	TMsgBuf = record
		hostSub	 : THostSub;
		version	 : integer;
		portNo	 : integer;
		packetNo : ULONG;
		command	 : ULONG;
		msgBuf	 : array[0..MAX_UDPBUF] of AnsiChar;
		exOffset : integer;		// expand message offset in msgBuf
	end;

	TRecvBuf = record
		addr	 : TSockAddrin;
		addrSize : integer;
		size	 : integer;
		msgBuf	 : array[0..MAX_UDPBUF] of AnsiChar;
	end;

// TBroadCastObj  ////////////////////////////////////////////////////////////////////////////////////
	TBroadCastObj = class
	private
		FAddr : ULONG;
  // modified begin
  (*
	published
  *)
  public
  // modified end
		property addr : ULONG read FAddr write FAddr;
	end;

// THost	//////////////////////////////////////////////////////////////////////////////////////////
	THost = class
	private
		FHostSub   : THostSub;
		FHostStatus: ULONG;
		FUpdateTime: integer;
		FNickName  : array[0..MAX_NAMEBUF] of AnsiChar;
		FGroupName : array[0..MAX_NAMEBUF] of AnsiChar;

		FSendCheck : boolean;

		function	getGroupName : AnsiString;
		procedure	setGroupName(val : AnsiString);
		function	getnickName : AnsiString;
		procedure	setnickName(val : AnsiString);
	public
		constructor Create;
		procedure	SetHostData(hostSub : THostSub; command : ULONG; nickName, groupName : AnsiString);
  // modified begin
  (*
	published
  *)
  // modified end
		property	addr	   : ULONG	 read FHostSub.addr write FHostSub.addr;
		property	hostStatus : ULONG	 read FHostStatus write FHostStatus;
		property	updateTime : integer read FupdateTime write FUpdateTime;

		property	groupName  : AnsiString	 read getgroupName write setgroupName;
		property	nickName   : AnsiString	 read getnickName write setnickName;

		property	hostSub	   : THostSub read FHostSub;
		property	SendCheck  : boolean  read FSendCheck write FSendCheck;
	end;

// TBroadcastList ///////////////////////////////////////////////////////////////////////////////////////
	TBroadcastList = class
	private
		FBroadcastObjs : TList;
	protected
		function  GetBroadcastObjs(index : integer) : TBroadcastObj;
		function  GetCount : integer;
	public
		constructor Create;
		destructor	Destroy; override;

		function  Add(Obj : TBroadcastObj) : boolean;
		procedure Delete(Obj : TBroadcastObj);
		procedure Clear;

		function  IndexOf(addr : ULONG) : integer;

		property  Objs[index : integer] : TBroadcastObj read GetBroadcastObjs; default;
		property  Count : integer read GetCount;
	end;

// THostList //////////////////////////////////////////////////////////////////////////////////////////
	THostList = class
	private
    // modified begin
    (*
		FHosts : TList;
    *)
    // modified end
		FItems : TStringList;
	protected
    // modified begin
		FHosts : TList;
    // modified end
		function  GetHosts(index : integer) : THost;
		function  GetCount : integer;
		function  GetSendEntryCount : integer;
	public
		constructor Create;
		destructor	Destroy; override;

		function  Add(host : THost) : boolean;
		procedure Delete(host : THost);
		procedure Clear;

		function  IndexOf(addr : ULONG) : integer;

		property  Hosts[index : integer] : THost read GetHosts; default;
		property  Items : TStringList read FItems;
		property  Count : integer read GetCount;
		property  SendEntryCount : integer read GetSendEntryCount;
	end;

// TMsgMng //////////////////////////////////////////////////////////////////////////////////////////
	TMsgMng = class(TComponent)
	private
		FPort	 : integer;
		procedure SetPort(value : integer);
	protected
		{ Protected Declarations }
		udp_sd : integer;

    // modified begin
    (*
		packetNo : ULONG;
    *)
    // modified end
		recv_flg : boolean;

		hAsyncWnd : HWND;
		uAsyncMsg : UINT;
		lAsyncMode: UINT;

		Local	  : THostSub;
		Status	  : boolean;

		function UdpRecv(var buf : TRecvBuf): boolean;
		function UdpSend(host_addr : ULONG;	 buf, exMsg : AnsiString;	len : integer): boolean;
		procedure CloseSocket;

		function	WSockInit(recv_flg : boolean): boolean;
		function	WSockReset: boolean;
		procedure	WSockTerm;
	public
		{ Public Declarations }
		flg : boolean;
    // modified begin
    packetNo : ULONG;
    // modified end

		constructor Create(AOwner: TComponent); override;
		destructor Destroy; override;

		function AsyncSelectRegist(THandle : HWND; uMsg : UINT;	 mode : UINT): boolean;

		function MakeMsg(var buf : AnsiString; command : ULONG; msg : AnsiString): ULONG;
		function Recv(var msg : TMsgBuf): boolean;
		function ResolveMsg(buf : TRecvBuf;	 var msg : TMsgBuf): boolean;
		function Send(host, command : ULONG; msg, exMsg : AnsiString): boolean;

		procedure PutSocketError(msg : AnsiString);
	published
		property port : integer read FPort write SetPort;
	end;

// TIPMsg ///////////////////////////////////////////////////////////////////////////////////////////
	TIPMsg = class(TMsgMng)
	private
		{ Private Declarations }
		FAbsenceCheck: boolean;
		FDialUpCheck: boolean;
		FOnMemberChanged: TOnMemberChanged;
		FOnMsgArrived: TOnMsgArrived;
		FOnMsgInfo : TOnMsgInfo;
		FOpenCheck: boolean;
		FPasswordCheck: boolean;
		FSecretCheck: boolean;
		FSendCheck: boolean;

		FAbsenceStr : array[0..MAX_BUF] of AnsiChar;
		FGroupNameStr : array[0..MAX_NAMEBUF] of AnsiChar;
		FNickNameStr : array[0..MAX_NAMEBUF] of AnsiChar;

		FMemberCnt	: integer;		// メンバ数

		function GetAbsenceCheck: boolean;
		procedure SetAbsenceCheck(Val: boolean);
		function GetAbsenceStr: AnsiString;
		procedure SetAbsenceStr(Val: AnsiString);
		function GetGroupNameStr: AnsiString;
		procedure SetGroupNameStr(Val: AnsiString);
		function GetNickNameStr: AnsiString;
		procedure SetNickNameStr(Val: AnsiString);
	protected
		{ Protected Declarations }
		Handle	   : HWND;
		StartTime	: ULONG;		// 開始時間(?)

		EntryTimerStatus : UINT;	// エントリタイマー情報
		TerminateFlg : boolean;		// 終了フラグ

		LastPacketNo	: ULONG;		// 最後のパケット番号
		LastPacketHost : ULONG;		// 最後のパケットを送信したホスト情報

		Delaytime : integer;
		ListGet : boolean;
		ListGetMSec : UINT;
		RetryMSec : UINT;
		RetryMax  : UINT;
		UpdateTime : integer;

		procedure AddHost(hostSub : THostSub; command : ULONG; nickName, groupName : AnsiString);
		procedure AddHostList(var msg : TMsgBuf);
		procedure BroadcastEntry(mode : ULONG);
		procedure BroadcastEntrySub(addr, mode : ULONG);
		procedure DelAllHost;
		procedure DelHost(addr : ULONG);
		procedure EntryHost;
		procedure ExitHost;

		function  HostStatus: ULONG;
		procedure IncommingData(var Msg : TMessage; Error : WORD);
		function  IsLastPacket(var msg : TMsgBuf): boolean;
		function  IsSameHost(hostSub1, hostSub2 : THostSub): boolean;
		procedure MsgAnsEntry(var msg : TMsgBuf);
		procedure MsgAnsList(var msg : TMsgBuf);
		procedure MsgBrAbsence(var msg : TMsgBuf);
		procedure MsgBrEntry(var msg : TMsgBuf);
		procedure MsgBrExit(var msg : TMsgBuf);
		procedure MsgBrlsGetList(var msg : TMsgBuf);
		procedure MsgGetAbsenceInfo(var msg : TMsgBuf);
		procedure MsgGetInfo(var msg : TMsgBuf);
		procedure MsgGetList(var msg : TMsgBuf);
		procedure MsgInfoSub(var msg : TMsgBuf);
		procedure MsgOkGetList(var msg : TMsgBuf);
		procedure MsgReadMsg(var msg : TMsgBuf);
		procedure MsgRecvMsg(var msg : TMsgBuf);
		procedure MsgSendAbsenceInfo(var msg : TMsgBuf);
		procedure MsgSendInfo(var msg : TMsgBuf);
		procedure MsgSendMsg(var msg : TMsgBuf);
		procedure OnTimer(timerID : WParam);
		procedure SendHostList(var msg : TMsgBuf);
		procedure Terminate;
		procedure WndProc(var AMsg: TMessage);
	public
		{ Public Declarations }
		HostList	  : THostList;
		BroadcastList : TBroadcastList;
		DialUpList	  : TBroadcastList;

		constructor Create(AOwner: TComponent); override;
		destructor	Destroy; override;
		procedure Close;
		procedure Open;

		function BroadcastSend(msg : AnsiString) : boolean;
		function NormalSend(msg : AnsiString) : boolean;

		procedure RefreshHost(unRemoveFlg : boolean);

		property AbsenceCheck: boolean read GetAbsenceCheck write SetAbsenceCheck Default False;
		property DialUpCheck: boolean read FDialUpCheck write FDialUpCheck Default False;
		property MemberCnt : integer read FMemberCnt write FMemberCnt Default 0;
		property OpenCheck: boolean read FOpenCheck write FOpenCheck Default False;
		property PasswordCheck: boolean read FPasswordCheck write FPasswordCheck Default False;
		property SecretCheck: boolean read FSecretCheck write FSecretCheck Default False;
		property SendCheck: boolean read FSendCheck write FSendCheck Default False;
	published
		property AbsenceStr: AnsiString read GetAbsenceStr write SetAbsenceStr;
		property GroupNameStr: AnsiString read GetGroupNameStr write SetGroupNameStr;
		property NickNameStr: AnsiString read GetNickNameStr write SetNickNameStr;
		property OnMemberChanged: TOnMemberChanged read FOnMemberChanged write FOnMemberChanged;
		property OnMsgArrived: TOnMsgArrived read FOnMsgArrived write FOnMsgArrived;
		property OnMsgInfo : TOnMsgInfo read FOnMsgInfo write FOnMsgInfo;
	end;

procedure Register;
function  Get_Mode(command : ULONG): ULONG;
function  GET_OPT(command : ULONG): ULONG;
function  strtok(var src : AnsiString; delimiter : AnsiString) : AnsiString;

implementation

// THost	//////////////////////////////////////////////////////////////////////////////////////////
constructor THost.Create;
begin
	inherited Create;

	with FHostSub do begin
		StrCopy(userName, #0);
		StrCopy(hostName, #0);
		addr := $0;
	end;

	StrCopy(FNickName, #0);
	StrCopy(FGroupName, #0);
end;

function	THost.getGroupName : AnsiString;
begin
	Result := StrPas(FGroupName);
end;

procedure	THost.setGroupName(val : AnsiString);
begin
	if val <> StrPas(FGroupName) then
		StrLCopy(FGroupName, PAnsiChar(val) ,sizeof(FGroupName) - 1);
end;

function	THost.getNickName : AnsiString;
begin
	Result := StrPas(FNickName);
end;

procedure	THost.setNickName(val : AnsiString);
begin
	if val <> StrPas(FNickName) then
		StrLCopy(FNickName, PAnsiChar(val), sizeof(FNickName) - 1);
end;

procedure THost.SetHostData(hostSub : THostSub; command : ULONG; nickName, groupName : AnsiString);
begin
	with FHostSub do begin
		StrCopy(userName, hostSub.userName);
		StrCopy(hostName, hostSub.hostName);
		addr := hostSub.addr;
	end;
	StrLCopy(FNickName, PAnsiChar(nickName), sizeof(FNickName) - 1);
	StrLCopy(FGroupName, PAnsiChar(groupName), sizeof(FGroupName) - 1);

	hostStatus := GET_OPT(command);
	updateTime := DateTimeToFileDate(Date);
end;

// TBroadcastList //////////////////////////////////////////////////////////////////////////////////////////
constructor TBroadcastList.Create;
begin
	inherited Create;
	FBroadcastObjs := TList.Create;
end;

destructor	TBroadcastList.Destroy;
begin
	FBroadcastObjs.Free;
	inherited Destroy;
end;

function  TBroadcastList.GetBroadcastObjs(index : integer) : TBroadcastObj;
begin
	Result := TBroadcastObj(FBroadcastObjs[index]);
end;

function  TBroadcastList.GetCount : integer;
begin
	Result := FBroadcastObjs.Count;
end;

function  TBroadcastList.Add(Obj : TBroadcastObj) : boolean;
begin
	Result := (FBroadcastObjs.Add(Obj) >= 0);
end;

procedure TBroadcastList.Delete(Obj : TBroadcastObj);
var
	i : integer;
begin
	for i := 0 to FBroadcastObjs.Count -1 do begin
		if TBroadcastObj(FBroadcastObjs[i]) = Obj then begin
			FBroadcastObjs.Delete(i);
			Break;
		end;
	end;
end;

procedure TBroadcastList.Clear;
begin
	FBroadcastObjs.Clear;
end;

function  TBroadcastList.IndexOf(addr : ULONG) : integer;
var
	i : integer;
begin
	Result := -1;
	for i := 0 to FBroadcastObjs.Count -1 do begin
		if TBroadcastObj(FBroadcastObjs[i]).addr = addr then begin
			Result := i;
			Break;
		end;
	end;
end;

// THostList //////////////////////////////////////////////////////////////////////////////////////////
constructor THostList.Create;
begin
	inherited Create;
	FHosts := TList.Create;
	FItems := TStringList.Create;
end;

destructor	THostList.Destroy;
begin
  // modified begin
  Clear;
  // modified end
	FItems.Free;
	FHosts.Free;
	inherited Destroy;
end;

function  THostList.GetHosts(index : integer) : THost;
begin
	Result := THost(FHosts[index]);
end;

function  THostList.GetCount : integer;
begin
	Result := FHosts.Count;
end;

function  THostList.GetSendEntryCount : integer;
var
	i : integer;
begin
	Result := 0;
	for i := 0 to FHosts.Count - 1 do begin
		if THost(FHosts[i]).SendCheck then
			Result := Result + 1;
	end;
end;

function  THostList.Add(Host : THost) : boolean;
var
	s : AnsiString;
begin
	Result := (FHosts.Add(Host) >= 0);
	if host.nickname <> '' then
		s := host.nickname
	else
		s := host.hostSub.userName;
	if host.groupName <> '' then
		s := s + '/' + host.groupName;
	FItems.Add(string(s));
end;

procedure THostList.Delete(Host : THost);
var
	i : integer;
begin
	for i := 0 to FHosts.Count -1 do begin
		if THost(FHosts[i]) = Host then begin
      // modified begin
      THost(FHosts[I]).Free;
      // modified end
			FHosts.Delete(i);
			FItems.Delete(i);
			Break;
		end;
	end;
end;

procedure THostList.Clear;
// modified begin
var
  I: Integer;
// modified end
begin
  // modified begin
  for I := 0 to Count - 1 do
    THost(FHosts[I]).Free;
  // modified end
	FHosts.Clear;
	FItems.Clear;
end;

function  THostList.IndexOf(addr : ULONG) : integer;
var
	i : integer;
begin
	Result := -1;
	for i := 0 to FHosts.Count -1 do begin
		if THost(FHosts[i]).addr = addr then begin
			Result := i;
			Break;
		end;
	end;
end;

// TMsgMng //////////////////////////////////////////////////////////////////////////////////////////
constructor TMsgMng.Create(AOwner: TComponent);
var
	size : DWORD;
begin
	inherited Create(AOwner);

	Status := FALSE;

	packetNo := DateTimeToFileDate(Date);

	udp_sd := INVALID_SOCKET;
	FPort := IPMSG_DEFAULT_PORT;
	hAsyncWnd := 0;

	size := sizeof(Local.hostName);
	if	not GetComputerNameA(Local.hostName, size) then
	begin
		PutSocketError('gethostname() Error');
		Exit;
	end;

	size := sizeof(Local.userName);
	if not GetUserNameA(Local.userName, size) then
		strlcopy(Local.userName, NO_NAME, sizeof(Local.userName));

	Status := TRUE;
end;

destructor TMsgMng.Destroy;
begin
	WSockTerm();
	inherited Destroy;
end;

function TMsgMng.AsyncSelectRegist(THandle : HWND; uMsg : UINT;	 mode : UINT): boolean;
begin
	hAsyncWnd := THandle;
	uAsyncMsg := uMsg;
	lAsyncMode := FD_READ;

	if WSAAsyncSelect(udp_sd, hAsyncWnd, uAsyncMsg, lAsyncMode) = SOCKET_ERROR then
	begin
		PutSocketError('WSASelect');
		Result := False;
		Exit;
	end;
	Result := TRUE;
end;

procedure TMsgMng.CloseSocket;
begin
	if udp_sd <> INVALID_SOCKET then
	begin
    // modified begin
    (*
		winsock.closesocket(udp_sd);
    *)
    {$IF CompilerVersion > 22.9}
  		Winapi.winsock.closesocket(udp_sd);
    {$ELSE}
		  winsock.closesocket(udp_sd);
    {$IFEND}
    // modified end
		udp_sd := INVALID_SOCKET;
	end;
end;

function TMsgMng.MakeMsg(var buf : AnsiString; command : ULONG; msg : AnsiString): ULONG;
	procedure DeleteNL(var s : AnsiString);
	var
		i : integer;
	begin
		for i := 1 to Length(s) do
			if s[i] = #13 then begin
				Delete(s, i, 1);
			end;
	end;
begin
	buf := AnsiString(format('%d:%d:%s:%s:%d:', [IPMSG_VERSION, packetNo, Local.userName, Local.hostName, command]));

	DeleteNL(msg);
	buf := buf + msg;

	// パケット番号を更新して終了。
	inc(packetNo);
	Result := packetNo;
end;

procedure TMsgMng.PutSocketError(msg : AnsiString);
var
	buf : AnsiString;
begin
  case WSAGetLastError() of
	WSAEINTR		   : buf := 'Interrupted system call';
	WSAEBADF		   : buf := 'Bad file number';
	WSAEACCES		   : buf := 'Permission denied';
	WSAEFAULT		   : buf := 'Bad address';
	WSAEINVAL		   : buf := 'Invalid argument';
	WSAEMFILE		   : buf := 'Too many open files';
	WSAEWOULDBLOCK	   : buf := 'Operation would block';
	WSAEINPROGRESS	   : buf := 'Operation now in progress';
	WSAEALREADY		   : buf := 'Operation already in progress';
	WSAENOTSOCK		   : buf := 'Socket operation on nonsocket';
	WSAEDESTADDRREQ	   : buf := 'Destination address required';
	WSAEMSGSIZE		   : buf := 'Message too long';
	WSAEPROTOTYPE	   : buf := 'Protocol wrong type for socket';
	WSAENOPROTOOPT	   : buf := 'Protocol not available';
	WSAEPROTONOSUPPORT : buf := 'Protocol not supported';
	WSAESOCKTNOSUPPORT : buf := 'Socket not supported';
	WSAEOPNOTSUPP	   : buf := 'Operation not supported on socket';
	WSAEPFNOSUPPORT	   : buf := 'Protocol family not supported';
	WSAEAFNOSUPPORT	   : buf := 'Address family not supported';
	WSAEADDRINUSE	   : buf := 'Address already in use';
	WSAEADDRNOTAVAIL   : buf := 'Can''t assign requested address';
	WSAENETDOWN		   : buf := 'Network is down';
	WSAENETUNREACH	   : buf := 'Network is unreachable';
	WSAENETRESET	   : buf := 'Network dropped connection on reset';
	WSAECONNABORTED	   : buf := 'Software caused connection abort';
	WSAECONNRESET	   : buf := 'Connection reset by peer';
	WSAENOBUFS		   : buf := 'No buffer space available';
	WSAEISCONN		   : buf := 'Socket is already connected';
	WSAENOTCONN		   : buf := 'Socket is not connected';
	WSAESHUTDOWN	   : buf := 'Can''t send after socket shutdown';
	WSAETOOMANYREFS	   : buf := 'Too many references:can''t splice';
	WSAETIMEDOUT	   : buf := 'Connection timed out';
	WSAECONNREFUSED	   : buf := 'Connection refused';
	WSAELOOP		   : buf := 'Too many levels of symbolic links';
	WSAENAMETOOLONG	   : buf := 'File name is too long';
	WSAEHOSTDOWN	   : buf := 'Host is down';
	WSAEHOSTUNREACH	   : buf := 'No route to host';
	WSAENOTEMPTY	   : buf := 'Directory is not empty';
	WSAEPROCLIM		   : buf := 'Too many processes';
	WSAEUSERS		   : buf := 'Too many users';
	WSAEDQUOT		   : buf := 'Disk quota exceeded';
	WSAESTALE		   : buf := 'Stale NFS file handle';
	WSAEREMOTE		   : buf := 'Too many levels of remote in path';
	WSASYSNOTREADY	   : buf := 'Network subsystem is unusable';
	WSAVERNOTSUPPORTED : buf := 'Winsock DLL cannot support this application';
	WSANOTINITIALISED  : buf := 'Winsock not initialized';
	WSAHOST_NOT_FOUND  : buf := 'Host not found';
	WSATRY_AGAIN	   : buf := 'Non authoritative - host not found';
	WSANO_RECOVERY	   : buf := 'Non recoverable error';
	WSANO_DATA		   : buf := 'Valid name, no data record of requested type'
  else
	buf := 'Not a Winsock error';
  end;

  buf := msg + '(' + buf + ')';
  showMessage(string(buf));
end;

function TMsgMng.Recv(var msg : TMsgBuf): boolean;
var
	buf : TRecvBuf;
begin
	if (UdpRecv(buf) <> TRUE) or (buf.size = 0) then
	begin
		Result := False;
		Exit;
	end;

	Result := ResolveMsg(buf, msg);
end;

function TMsgMng.ResolveMsg(buf : TRecvBuf;	 var msg : TMsgBuf): boolean;
var
	exStr :PAnsiChar;
	len : integer;
	cnt : integer;
	tok : AnsiString;
	buff: AnsiString;
begin
	exStr := nil;
	msg.exOffset := 0;

	buff := StrPas(buf.msgBuf);
	len := strlen(buf.msgBuf);
	if buf.size > len +1 then
		exStr := buf.msgBuf + len +1;

	msg.hostSub.addr := buf.addr.sin_addr.s_addr;
	msg.portNo := ntohs(buf.addr.sin_port);

	Result := False;
	tok := strtok(buff,':');
	if tok = '' then
		Exit;

	msg.version := StrToInt(string(tok));
	if msg.version <> IPMSG_VERSION then
		Exit;

	tok := strtok(buff,':');
	if tok = '' then
		Exit;
	msg.packetNo := StrToInt(string(tok));

	tok := strtok(buff,':');
	if tok = '' then
		Exit;
	strlcopy(msg.hostSub.userName, PAnsiChar(tok), sizeof(msg.hostSub.userName));

	tok := strtok(buff,':');
	if tok = '' then
		Exit;
	strlcopy(msg.hostSub.hostName, PAnsiChar(tok), sizeof(msg.hostSub.hostName));

	tok := strtok(buff,':');
	if tok = '' then
		Exit;
	msg.command := StrToInt(string(tok));

	cnt := 1;
	if buff <> '' then	// 改行をUNIX形式からDOS形式に変換
	begin
		// #10を#13#10に変換	もし、MAX_UDPBUF-1よりサイズがでかければ、ヌルをいれて切る。
		while (buff[cnt] <> #0) and (cnt < MAX_UDPBUF - 1) do begin
			if buff[cnt] = #10 then begin
				Insert(#13, buff, cnt);
				inc(cnt);
			end;
			inc(cnt);
		end;
	end;

	StrLCopy(msg.msgBuf, PAnsiChar(buff), sizeof(msg.msgBuf) - 1);

	msg.exOffset := StrLen(msg.msgBuf) + 1;
	if exStr <> nil then
	begin
		inc(msg.exOffset);
		strlcopy(msg.msgBuf + msg.exOffset, PAnsiChar(exStr), sizeof(msg.msgBuf) - msg.exOffset);
	end;
  // modified begin
  if exStr = nil then
  begin
    inc(msg.exOffset);
    strlcopy(msg.msgBuf + msg.exOffset, #0, sizeof(msg.msgBuf) - msg.exOffset);
  end;
  // modified end

	Result := True;
end;


function TMsgMng.Send(host, command : ULONG; msg, exMsg : AnsiString): boolean;
var
	buf : array[0..MAX_UDPBUF] of AnsiChar;
	trans_len : integer;
	s : AnsiString;
begin
	Setlength(s, MAX_UDPBUF);
	MakeMsg(s, command, msg);
	StrLCopy(buf, PAnsiChar(s), sizeof(buf) - 1);

	trans_len := strlen(buf) +1;

	Result := UdpSend(host, buf, exMsg, trans_len); // debug
end;

procedure TMsgMng.SetPort(value : integer);
begin
	if value <> FPort then
		FPort := value;
end;

function TMsgMng.UdpRecv(var buf : TRecvBuf): boolean;
begin
	FillChar(buf, sizeof(buf), #0);
	buf.addrSize := sizeof(buf.addr);

	buf.size := recvfrom(udp_sd, buf.msgBuf, sizeof(buf.msgBuf), 0, buf.addr, buf.addrSize);
	if buf.size = SOCKET_ERROR then
	begin
		Result := False;
		Exit;
	end;

//	showMessage('UdpRecv_buf.size: ' + intToStr(buf.size));
	Result := True;
end;

function TMsgMng.UdpSend(host_addr : ULONG;	 buf, exMsg : AnsiString;	len : integer): boolean;
var
	addr : TSockAddrin;
	msg	 : array[0..MAX_UDPBUF] of AnsiChar;
begin
	FillChar(addr, sizeof(addr), #0); // memset
	addr.sin_family			:= AF_INET;
	addr.sin_port			:= htons(port);
	addr.sin_addr.s_addr	:= host_addr;

	StrLCopy(msg, PAnsiChar(buf), sizeof(msg) - 1);
//	  showMessage(IntToHex(Integer(@msg), 4));
	if exMsg <> '' then
	begin
		strlcopy(msg + len, PAnsiChar(exMsg), sizeof(msg) - len);
    // modified begin
    (*
		len := len + strlen(PAnsiChar(exMsg)) +1;
    *)
    len := len + integer(strlen(PAnsiChar(exMsg))) +1;
    // modified end
	end;

//	showMessage('UdpSend_len: ' + intToStr(len));
	if sendto(udp_sd, msg, len, 0, addr, sizeof(addr)) = SOCKET_ERROR then
	begin
		if WSAGetLastError() <> WSAENETDOWN then	//回復の見込みがないなら、エラー
		begin
			PutSocketError('sendto() Error');
			Result := False;
			Exit;
		end;

		if WSockReset() <> TRUE then
		begin
			Result := False;
			Exit;
		end;

		if not Boolean(hAsyncWnd) and AsyncSelectRegist(hAsyncWnd, uAsyncMsg, lAsyncMode) then
		begin
			Result := False;
			Exit;
		end;

		if sendto(udp_sd, buf, len, 0, addr, sizeof(addr)) = SOCKET_ERROR then
		begin
			PutSocketError('sendto2() Error');
			Result := False;
						Exit;
		end;
	end;

	Result := True;
end;

function TMsgMng.WSockInit(recv_flg : boolean): boolean;
var
	WSAData	   : TWSAData;
	addr	   : TSockAddrin;
	flg		   : LongBool;
	buf_size   : integer;
	size	   : longint;
begin
	if WSAStartup($0101, WSAData) <> 0 then
	begin
		PutSocketError('WSAStart() Error');
		Result := FALSE;
		Exit;
	end;

	udp_sd := socket(AF_INET, SOCK_DGRAM, 0);
	if udp_sd = INVALID_SOCKET then
	begin
		PutSocketError('socket(SOCK_DGRAM) Error');
		Result := False;
		Exit;
	end;

	if not recv_flg then
	begin
		Result := True;
		Exit;
	end;

	addr.sin_family			:= AF_INET;
	addr.sin_addr.s_addr	:= htonl(INADDR_ANY);
	addr.sin_port			:= htons(port);

	if bind(udp_sd, addr, sizeof(addr)) <> 0 then
	begin
		PutSocketError('bind() Error');
		Result := False;
		Exit;
	end;

	flg := TRUE;	// Non Block
	if ioctlsocket(udp_sd, FIONBIO, size) <> 0 then
	begin
		PutSocketError('ioctlsocket() Error');
		Result := False;
		Exit;
	end;

	flg := TRUE;			// allow broadcast
	if setsockopt(udp_sd, SOL_SOCKET, SO_BROADCAST, PAnsiChar(@flg), sizeof(flg)) <> 0 then
	begin
		PutSocketError('setsockopt1() Error');
		Result := False;
		Exit;
	end;

	buf_size := MAX_UDPBUF;
	if setsockopt(udp_sd, SOL_SOCKET, SO_SNDBUF, PAnsiChar(@buf_size), sizeof(buf_size)) <> 0 then
		PutSocketError('setsockopt2() Error');

	buf_size := MAX_UDPBUF;
	if setsockopt(udp_sd, SOL_SOCKET, SO_RCVBUF, PAnsiChar(@buf_size), sizeof(buf_size)) <> 0 then
		PutSocketError('setsockopt3() Error');

	Result := True;
end;

function TMsgMng.WSockReset: boolean;
begin
	WSockTerm();
	Result := WSockInit(TRUE);
end;

procedure TMsgMng.WSockTerm;
begin
	CloseSocket();
end;

// TIPMsg ///////////////////////////////////////////////////////////////////////////////////////////
constructor TIPMsg.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);

	DialUpList :=	TBroadcastList.Create;
	BroadcastList := TBroadcastList.Create;
	HostList   := THostList.Create;

	Handle := AllocateHWnd(WndProc);

	MemberCnt := 0;									// メンバ数の初期化
	StartTime := DateTimeToFileDate(Date);			// 時間の取得
	LastPacketNo := 0;								// ラストパケットNoの初期化
	LastPacketHost := 0;							// ラストパケットのホストの初期化
	EntryTimerStatus := 0;							// エントリタイマの初期化
	TerminateFlg := FALSE;							// 終了フラグの初期化

	SendCheck := FALSE;
	ListGet	  := FALSE;
	ListGetMSec := IPMSG_DEFAULT_LISTGETMSEC;
	RetryMSec	:= IPMSG_DEFAULT_RETRYMSEC;
	RetryMax	:= IPMSG_DEFAULT_RETRYMAX;
	OpenCheck	:= TRUE;
	AbsenceCheck := FALSE;
	DelayTime	 := IPMSG_DEFAULT_DELAY;
	SecretCheck	 := FALSE;
	DialUpCheck	 := FALSE;
	UpdateTime	 := IPMSG_DEFAULT_UPDATETIME;

	FillChar(FGroupNameStr, sizeof(FGroupNameStr), #0);
	FillChar(FNickNameStr, sizeof(FNickNameStr), #0);
	AbsenceStr := IPMSG_DEFAULT_ABSENCE;
end;

destructor TIPMsg.Destroy;
begin
	DeallocateHWnd(Handle);

	HostList.Free;
	DialUpList.free;
	BroadcastList.free;
	inherited Destroy;
end;

procedure TIPMsg.AddHost(hostSub : THostSub; command : ULONG; nickName, groupName : AnsiString);
var
	host	: THost;
	obj		: TBroadcastObj;
	found	: boolean;
	i		: integer;
begin
	if (get_mode(command) = IPMSG_BR_ENTRY) and ((command and IPMSG_DIALUPOPT) <> 0) and (not IsSameHost(hostsub, local)) then
	begin
		// ここでは、DialUpLstをTListの変数として扱っている。 -- Delphi version.
		found := false;
		if DialUpList.Count > 0 then
			for i := 0 to DialUpList.Count - 1 do
				if DialUpList.objs[i].addr = hostSub.addr then begin
					found := True;
					break;
				end;

		if not found then begin
			obj := TBroadcastObj.Create;
			obj.addr := hostSub.addr;
			DialUpList.add(obj);
		end;
	end;

	if hostList.Count > 0 then
		for i := 0 to hostList.Count - 1 do begin
			if IsSameHost(hostSub, hostList.Hosts[i].hostSub) then
			begin
				hostList.hosts[i].addr := hostSub.addr;
				if (((command xor hostList.hosts[i].hostStatus) and IPMSG_ABSENCEOPT) <> 0)
					or (AnsiStrcomp(PAnsiChar(hostList.hosts[i].nickName), PAnsiChar(nickName)) <> 0)
					or (AnsiStrcomp(PAnsiChar(hostList.hosts[i].groupName), PAnsiChar(groupName)) <> 0) then
				begin
					hostList.hosts[i].SetHostData(hostSub, command, nickName, groupName);

					// メンバリストの更新が発生。（追加）
					if Assigned(FOnMemberChanged) then
						FOnMemberChanged(self);
				end;
				hostList.hosts[i].updateTime := DateTimeToFileDate(Date);
				hostList.hosts[i].hostStatus := Get_opt(command);
				Exit;
			end;
			if hostSub.addr = hostList.hosts[i].addr then	// 通常はありえない
			begin
				// メンバリストの更新が発生。（削除）
				if Assigned(FOnMemberChanged) then
					FOnMemberChanged(self);

				hostList.hosts[i].SetHostData(hostSub, command, nickName, groupName);

				// メンバリストの更新が発生。（追加）
				if Assigned(FOnMemberChanged) then
					FOnMemberChanged(self);

				Exit;
			end;
		end;

	host := THost.Create;
	host.SetHostData(hostSub, command, nickName, groupName);
	hostList.Add(host); //mod

	memberCnt := memberCnt + 1;

	// メンバリストの更新が発生。（追加）
	if Assigned(FOnMemberChanged) then
		FOnMemberChanged(self);
end;

procedure TIPMsg.AddHostList(var msg : TMsgBuf);
var
	hostSub : THostSub;
	host_status : ULONG;
	total_num, continue_flg : integer;
	host_cnt  : integer;
	tok, nickName, groupName : AnsiString;
	buff : AnsiString;
begin
	buff := StrPas(msg.msgBuf);
	tok := strtok(buff, HOSTLIST_DELIMIT);
	if tok = '' then
		Exit;
	continue_flg := StrToInt(string(tok));

	tok := strtok(buff, HOSTLIST_DELIMIT);
	if tok = '' then
		Exit;
	total_num := StrToInt(string(tok));

	host_cnt := 0;
	tok := strtok(buff, HOSTLIST_DELIMIT);
	while tok <> '' do begin
		nickName := '';
		groupName := '';
		strlcopy(hostSub.userName, PAnsiChar(tok), sizeof(hostSub.userName));

		tok := strtok(buff, HOSTLIST_DELIMIT);
		if tok = '' then
			break;
		strlcopy(hostSub.hostName, PAnsiChar(tok), sizeof(hostSub.hostName));

		tok := strtok(buff, HOSTLIST_DELIMIT);
		if tok = '' then
			break;
		host_status := StrToInt(string(tok));

		tok := strtok(buff, HOSTLIST_DELIMIT);
		if tok = '' then
			break;
		hostSub.addr := inet_addr(PAnsiChar(tok));

		nickName := strtok(buff, HOSTLIST_DELIMIT);
		if nickName = '' then
			break;
		if Ansistrcomp(PAnsiChar(nickName), HOSTLIST_DUMMY) = 0 then
			nickName := '';

		groupName := strtok(buff, HOSTLIST_DELIMIT);
		if groupName = '' then
			break;
		if Ansistrcomp(PAnsiChar(groupName), HOSTLIST_DUMMY) = 0 then
			groupName := '';

		AddHost(hostSub, IPMSG_BR_ENTRY or host_status, nickName, groupName);

		Inc(host_cnt);
		tok := strtok(buff, HOSTLIST_DELIMIT);
	end;

	SetLength(buff, MAX_BUF);
	if (continue_flg <> 0) or (host_cnt < total_num) then
	begin
		buff := AnsiString(format('%d', [host_cnt]));
		Send(msg.hostSub.addr, IPMSG_GETLIST, buff, '');
		if SetTimer(Handle, IPMSG_LISTGETRETRY_TIMER, ListGetMSec, nil) <> 0 then
			entryTimerStatus := IPMSG_LISTGETRETRY_TIMER;
	end else begin
		startTime := IPMSG_GETLIST_FINISH;
		BroadcastEntry(IPMSG_BR_ENTRY);
	end;
end;

procedure TIPMsg.BroadcastEntry(mode : ULONG);
var
	i : integer;
begin
	 if BroadcastList.Count > 0 then
		for i := 0 to BroadcastList.Count - 1 do
			BroadcastEntrySub(broadcastList.objs[i].addr, IPMSG_NOOPERATION);

	 if BroadcastList.Count > 0 then
		Sleep(DelayTime);

   // modified begin
   (*
	 Send(not 0, mode or HostStatus, NickNameStr, GroupNameStr);	// local network broadcast
   *)
   Send(ULONG(not 0), mode or HostStatus, NickNameStr, GroupNameStr);	// local network broadcast
   // modified end

	 if BroadcastList.Count > 0 then
		for i := 0 to BroadcastList.Count - 1 do
			BroadcastEntrySub(broadcastList.objs[i].addr, mode);

	 if DialUpList.Count > 0 then
		for i := 0 to DialUpList.Count - 1 do
			BroadcastEntrySub(DialUpList.objs[i].addr, mode);

	if mode = IPMSG_BR_ENTRY then
		SetTimer(Handle, IPMSG_ENTRY_TIMER, 5000, nil);
end;

procedure TIPMsg.BroadcastEntrySub(addr, mode : ULONG);
begin
	if mode = IPMSG_NOOPERATION then
		Send(addr, mode, '', '')
	else
	begin
		if DialUpCheck then
			Send(addr, mode or IPMSG_DIALUPOPT or HostStatus, NickNameStr, GroupNameStr)
		else
			Send(addr, mode or HostStatus, NickNameStr,GroupNameStr);
	end;
end;

procedure TIPMsg.Close;
begin
	Terminate;
	WSockTerm;
end;

procedure TIPMsg.DelAllHost;
begin
	hostList.Clear;
	memberCnt := 0;

	if Assigned(FOnMemberChanged) then
		FOnMemberChanged(self);
end;

procedure TIPMsg.DelHost(addr : ULONG);
var
	i		: integer;
begin
	i := hostList.IndexOf(addr);
	if i <> -1 then begin
		hostList.Delete(hostList.hosts[i]);
		membercnt := memberCnt - 1;

		if Assigned(FOnMemberChanged) then
			FOnMemberChanged(self);
	end;
end;

procedure TIPMsg.EntryHost;
begin
	StartTime := DateTimeToFileDate(Date);

	if ListGet then
	begin
		if SetTimer(Handle, IPMSG_LISTGET_TIMER, ListGetMSec, nil) <> 0 then
			EntryTimerStatus := IPMSG_LISTGET_TIMER;
		BroadcastEntry(IPMSG_BR_ISGETLIST);
	end
	else
		BroadcastEntry(IPMSG_BR_ENTRY);
end;

procedure TIPMsg.ExitHost;
begin
	BroadcastEntry(IPMSG_BR_EXIT);
end;

function TIPMsg.GetAbsenceCheck: boolean;
begin
	Result := FAbsenceCheck;
end;

function TIPMsg.GetAbsenceStr: AnsiString;
begin
	Result := StrPas(FAbsenceStr);
end;

function TIPMsg.GetGroupNameStr: AnsiString;
begin
	Result := StrPas(FGroupNameStr);
end;

function TIPMsg.GetNickNameStr: AnsiString;
begin
	Result := StrPas(FNickNameStr);
end;

function TIPMsg.HostStatus: ULONG;
begin
	if DialUpCheck then
	begin
		if AbsenceCheck then
			Result := IPMSG_DIALUPOPT or IPMSG_ABSENCEOPT
		else
			Result := IPMSG_DIALUPOPT;
	end else begin
		if AbsenceCheck then
			Result := IPMSG_ABSENCEOPT
		else
			Result := 0;
	end;
end;

procedure TIPMsg.IncommingData(var Msg : TMessage; Error : WORD);
var
	msgBuf	: TMsgBuf;
begin
	if not Recv(msgBuf) then
		Exit;

	case GET_MODE(msgBuf.command) of
	IPMSG_BR_ENTRY:				MsgBrEntry(msgBuf);
	IPMSG_BR_EXIT:				MsgBrExit(msgBuf);
	IPMSG_ANSENTRY:				MsgAnsEntry(msgBuf);
	IPMSG_BR_ABSENCE:			MsgBrAbsence(msgBuf);
	IPMSG_SENDMSG:				MsgSendMsg(msgBuf);
	IPMSG_RECVMSG:				MsgRecvMsg(msgBuf);
	IPMSG_READMSG:				MsgReadMsg(msgBuf);
	IPMSG_BR_ISGETLIST:			MsgBrlsGetList(msgBuf);
	IPMSG_OKGETLIST:			MsgOkGetList(msgBuf);
	IPMSG_GETLIST:				MsgGetList(msgBuf);
	IPMSG_ANSLIST:				MsgAnsList(msgBuf);
	IPMSG_GETINFO:				MsgGetInfo(msgBuf);
	IPMSG_SENDINFO:				MsgSendInfo(msgBuf);
	IPMSG_GETABSENCEINFO:		MsgGetAbsenceInfo(msgBuf);
	IPMSG_SENDABSENCEINFO:		MsgSendAbsenceInfo(msgBuf);
	end;
end;

function TIPMsg.IsLastPacket(var msg : TMsgBuf): boolean;
begin
	Result := True;
	if LastPacketHost = msg.hostSub.addr then
		if (LastPacketNo = msg.packetNo) and (msg.packetNo <> IPMSG_DEFAULT_PORT) then	// 最後の条件は、Mac版のバグよけ
			Exit;

	Result := False;
end;

function TIPMsg.IsSameHost(hostSub1, hostSub2 : THostSub): boolean;
begin
  // modified begin
  (*
	if AnsiStrComp(hostSub1.hostName, hostSub2.hostName) <> 0 then
		Result := FALSE;
  *)
	if AnsiStrComp(hostSub1.hostName, hostSub2.hostName) <> 0 then
  begin
		Result := FALSE;
    Exit;
  end;
  // modified end

	if AnsiStrComp(hostSub1.userName, hostSub2.userName) <> 0 then
		Result := False
	else
		Result := True;
end;

procedure TIPMsg.MsgAnsEntry(var msg : TMsgBuf);
begin
	if msg.portNo <> port then
		Exit;
	AddHost(msg.hostSub, msg.command, msg.msgBuf, msg.msgBuf + msg.exOffset);
end;

procedure TIPMsg.MsgAnsList(var msg : TMsgBuf);
begin
	if StartTime <> IPMSG_GETLIST_FINISH then
		AddHostList(msg);
end;

procedure TIPMsg.MsgBrAbsence(var msg : TMsgBuf);
begin
	if msg.portNo <> port then
		Exit;
	AddHost(msg.hostSub, msg.command, msg.msgBuf, msg.msgBuf + msg.exOffset);
end;

procedure TIPMsg.MsgBrEntry(var msg : TMsgBuf);
begin
	if msg.portNo <> port then // プロパティの内部変数との比較に変更
		Exit;

	if LastPacketHost = msg.hostSub.addr then
		LastPacketHost := 0;

	Send(msg.hostSub.addr, IPMSG_ANSENTRY or HostStatus, NickNameStr, GroupNameStr);
	AddHost(msg.hostSub, msg.command, msg.msgBuf, msg.msgBuf + msg.exOffset); // これは、４番目の引数でグループ名を渡している。
end;

procedure TIPMsg.MsgBrExit(var msg : TMsgBuf);
begin
	DelHost(msg.hostSub.addr);
end;

procedure TIPMsg.MsgBrlsGetList(var msg : TMsgBuf);
begin
	if (StartTime + (ListGetMSec / 1000) < DateTimeToFileDate(Date)) and (ListGet = FALSE or (IPMSG_RETRYOPT and msg.command <> 0)) then
		Send(msg.hostSub.addr, IPMSG_OKGETLIST, '', '');
end;

procedure TIPMsg.MsgGetAbsenceInfo(var msg : TMsgBuf);
begin
	if IsLastPacket(msg) then
		Exit;

	LastPacketHost := msg.hostSub.addr;
	LastPacketNo	:= msg.packetNo;

	if AbsenceCheck then
		Send(msg.hostSub.addr, IPMSG_SENDABSENCEINFO, AbsenceStr, '')
	else
		Send(msg.hostSub.addr, IPMSG_SENDABSENCEINFO, 'Not Absence mode', '');
end;

procedure TIPMsg.MsgGetInfo(var msg : TMsgBuf);
var
	buf : array[0..MAX_BUF] of AnsiChar;
begin
	if IsLastPacket(msg) then
		Exit;

	LastPacketHost := msg.hostSub.addr;
	LastPacketNo	:= msg.packetNo;
	StrFmt(buf, 'Delphi version %f', [1.0]);
	Send(msg.hostSub.addr, IPMSG_SENDINFO, buf, '');
end;

procedure TIPMsg.MsgGetList(var msg : TMsgBuf);
begin
	SendHostList(msg);
end;

procedure TIPMsg.MsgInfoSub(var msg : TMsgBuf);
var
//	title	  : array[0..MAX_LISTBUF] of AnsiChar;
	msg_text  : AnsiString;
//	show_mode : integer;
	title	  : AnsiString;
begin
	setLength(title, MAX_LISTBUF);
	msg_text := msg.msgBuf;

	strtok(title, '(');

	case msg.command of
		IPMSG_RECVMSG:
			begin
				if SendCheck = FALSE then
					Exit;
//				msg_text := '送信されました';

				if Assigned(FOnMsgInfo) then
          // modified begin
          (*
					FOnMsgInfo(self, msg.hostSub.addr, miRecv);
          *)
          FOnMsgInfo(self, msg.hostSub.addr, miRecv, StrToIntDef(string(msg.msgBuf), 0));
          // modified end
			end;

		IPMSG_READMSG:
			begin
				if OpenCheck = FALSE then
					Exit;
//				msg_text := '開封されました';

				if Assigned(FOnMsgInfo) then
          // modified begin
          (*
					FOnMsgInfo(self, msg.hostSub.addr, miRead);
          *)
          FOnMsgInfo(self, msg.hostSub.addr, miRead, StrToIntDef(string(msg.msgBuf), 0));
          // modified end
			end;

	end;
//	if Assigned(FOnMsgInfo) then
//		FOnMsgInfo(self, msg.hostSub.addr, msg.command);
end;

procedure TIPMsg.MsgOkGetList(var msg : TMsgBuf);
begin
	if StartTime <> IPMSG_GETLIST_FINISH then
		Send(msg.hostSub.addr, IPMSG_GETLIST, '', '');
end;

procedure TIPMsg.MsgReadMsg(var msg : TMsgBuf);
begin
	MsgInfoSub(msg);
end;

procedure TIPMsg.MsgRecvMsg(var msg : TMsgBuf);
begin
	MsgInfoSub(msg);
end;

procedure TIPMsg.MsgSendAbsenceInfo(var msg : TMsgBuf);
begin
	MsgInfoSub(msg);
end;

procedure TIPMsg.MsgSendInfo(var msg : TMsgBuf);
begin
	MsgInfoSub(msg);
end;

procedure TIPMsg.MsgSendMsg(var msg : TMsgBuf);
var
	buf : array[0..MAX_LISTBUF] of AnsiChar;
	mt	: TMsgTypes;
begin
	if IsLastPacket(msg) then
	begin
		if ((msg.command and IPMSG_SENDCHECKOPT) <> 0) and (msg.command and (IPMSG_BROADCASTOPT or IPMSG_AUTORETOPT) = 0) then
		begin
			StrFmt(buf, '%d', [msg.packetNo]);
			Send(msg.hostSub.addr, IPMSG_RECVMSG, buf, '');
		end;
		Exit;
	end;

  // modified begin
	LastPacketHost := msg.hostSub.addr;
	LastPacketNo	:= msg.packetNo;
  // modified end

	// メッセージ受信。ここで、ユーザ定義のメソッドを呼び出す。
	if msg.command and IPMSG_PASSWORDOPT <> 0 then
		mt := mtPassword
	else if msg.command and IPMSG_SECRETOPT <> 0 then
		mt := mtSecret
	else
		mt := mtNone;
	if Assigned(FOnMsgArrived) then
    // modified begin
    (*
		FOnMsgArrived(self, msg.hostSub.userName, msg.hostSub.hostName, msg.msgBuf, mt);
    *)
    FOnMsgArrived(self, msg.hostSub.userName, msg.hostSub.hostName, msg.msgBuf, mt, msg.hostSub.addr, msg.packetNo);
    // modified end

	if (msg.command and IPMSG_BROADCASTOPT = 0) and (msg.command and IPMSG_AUTORETOPT = 0) then
	begin
		if (msg.command and IPMSG_SENDCHECKOPT) <> 0 then
		begin
			StrFmt(buf, '%d', [msg.packetNo]);
			Send(msg.hostSub.addr, IPMSG_RECVMSG, buf, '');
		end;
		if AbsenceCheck then
			Send(msg.hostSub.addr, IPMSG_SENDMSG or IPMSG_AUTORETOPT, AbsenceStr, '');
		if (msg.command and IPMSG_NOADDLISTOPT = 0) and (hostList.IndexOf(msg.hostSub.addr) = -1) then
			BroadcastEntrySub(msg.hostSub.addr, IPMSG_BR_ENTRY);
	end;

  // modified begin
  (*
	LastPacketHost := msg.hostSub.addr;
	LastPacketNo	:= msg.packetNo;
  *)
  // modified end
end;

procedure TIPMsg.OnTimer(timerID : WParam);
var
	i : integer;
begin
	if TerminateFlg then
	begin
		KillTimer(Handle, timerID);
		Exit;
	end;

	case timerID of
	IPMSG_LISTGET_TIMER:
		begin
			KillTimer(Handle, IPMSG_LISTGET_TIMER);
			EntryTimerStatus := 0;
			if StartTime <> IPMSG_GETLIST_FINISH then
			begin
				StartTime := DateTimeToFileDate(Date);
				if SetTimer(Handle, IPMSG_LISTGETRETRY_TIMER, ListGetMSec, nil) <> 0 then
					EntryTimerStatus := IPMSG_LISTGETRETRY_TIMER;
				BroadcastEntry(IPMSG_BR_ISGETLIST or IPMSG_RETRYOPT);
			end;
			Exit;
		end;

	IPMSG_LISTGETRETRY_TIMER:	// 例外かshowMessageでエラーを表示する。
		begin
			KillTimer(Handle, IPMSG_LISTGETRETRY_TIMER);
			EntryTimerStatus := 0;
			if StartTime <> IPMSG_GETLIST_FINISH then
			begin
				StartTime := IPMSG_GETLIST_FINISH;
				BroadcastEntry(IPMSG_BR_ENTRY);
			end;
			Exit;
		end;

	IPMSG_DELETE_TIMER:
		begin
			KillTimer(Handle, IPMSG_DELETE_TIMER);
			Exit;
		end;

	IPMSG_ENTRY_TIMER:
		begin
			KillTimer(Handle, IPMSG_ENTRY_TIMER);

			for i := 0 to broadcastList.Count - 1 do
				BroadcastEntrySub(broadcastList.objs[i].addr, IPMSG_BR_ENTRY);

			for i := 0 to DialUpList.Count - 1 do
				BroadcastEntrySub(DialUpList.objs[i].addr, IPMSG_BR_ENTRY);

			Exit;
		end;
	end;
end;

procedure TIPMsg.Open;
begin
	if not WSockInit(true) then
		Halt; // 例外処理(?)

	AsyncSelectRegist(Handle, WM_RECVDATA, FD_READ);
	if Status then
		EntryHost;
  // modified begin
  TerminateFlg := False;
  // modified end
end;

procedure TIPMsg.RefreshHost(unRemoveFlg : boolean);
var
	now_time : TDateTime;
	i : integer;
begin
	if ListGet and (EntryTimerStatus <> 0) then
		Exit;

	now_time := DateTimeToFileDate(Date);

	if not unRemoveFlg then
	begin
		if UpdateTime = 0 then
			DelAllHost
		else begin
			for i := 0 to hostList.Count - 1 do begin
				if hostList.hosts[i].updateTime + UpdateTime < now_time then
					DelHost(hostList.hosts[i].addr);
			end;
		end;
	end;
	EntryHost;
end;

procedure TIPMsg.SendHostList(var msg : TMsgBuf);
var
	start_no : integer;
	len		 : integer;
	host_cnt : integer;
	ptr : PAnsiChar;
	continue_flg : boolean;
	i : integer;
	buf, tmp: AnsiString;
begin
	SetLength(buf, MAX_UDPBUF);
	SetLength(tmp, MAX_BUF);
	start_no := StrToInt(string(msg.msgBuf));
	host_cnt := 0;
	continue_flg := false;

	buf := AnsiString(format('%d%s%4d%s', [continue_flg, HOSTLIST_DELIMIT, 0, HOSTLIST_DELIMIT]));
	ptr := PAnsiChar(buf) + Length(buf);

	for i := 0 to hostlist.Count - 1 do begin
		if start_no > 0 then begin
			Dec(start_no);
			continue;
		end;
		with hostlist.hosts[i] do begin
			if nickName = '' then
				nickName := HOSTLIST_DUMMY;
			if groupName = '' then
				groupName := HOSTLIST_DUMMY;

			tmp := AnsiString(format('%s%s%s%s%d%s%s%s%s%s%s%s', [	hostSub.userName, HOSTLIST_DELIMIT, hostSub.hostName, HOSTLIST_DELIMIT,
														hostStatus, HOSTLIST_DELIMIT,
														inet_ntoa(TInAddr(hostSub.addr)), HOSTLIST_DELIMIT,
														nickName, HOSTLIST_DELIMIT,groupName, HOSTLIST_DELIMIT]));
		end;
		len := Length(tmp);
		if len + 1 >= MAX_UDPBUF then
		begin
			continue_flg := TRUE;
			break;
		end;
		StrLCopy(ptr, PAnsiChar(tmp), len +1);
		Inc(ptr, len);
		Inc(host_cnt);
	end;

	tmp := AnsiString(format('%d%s%4d', [continue_flg, HOSTLIST_DELIMIT, host_cnt]));
	len := length(tmp);
	StrLCopy(PAnsiChar(buf), PAnsiChar(tmp), len);
	Send(msg.hostSub.addr, IPMSG_ANSLIST, buf, '');
end;

procedure TIPMsg.SetAbsenceCheck(Val: boolean);
begin
	if Val <> FAbsenceCheck then begin
		FAbsenceCheck := not FAbsenceCheck;
		BroadcastEntry(IPMSG_BR_ABSENCE);
	end;
end;

procedure TIPMsg.SetAbsenceStr(Val: AnsiString);
begin
	if val <> StrPas(FAbsenceStr) then
		StrLCopy(FAbsenceStr, PAnsiChar(val), sizeof(FAbsenceStr) - 1);
end;

procedure TIPMsg.SetGroupNameStr(Val: AnsiString);
begin
	if val <> StrPas(FGroupNameStr) then
		StrLCopy(FGroupNameStr, PAnsiChar(val), sizeof(FGroupNameStr) - 1);
end;

procedure TIPMsg.SetNickNameStr(Val: AnsiString);
begin
	if val <> StrPas(FNickNameStr) then
		StrLCopy(FNickNameStr, PAnsiChar(val), sizeof(FNickNameStr) - 1);
end;

procedure TIPMsg.Terminate;
begin
	if TerminateFlg then
		Exit;
	TerminateFlg := TRUE;

	if Status then
		ExitHost;

	CloseSocket();

	DelAllHost;
end;

procedure TIPMsg.WndProc(var AMsg: TMessage);
var
  Error: word;
begin
  with AMsg do
	case Msg of
	  WM_RECVDATA:
		begin
		  Error:= WSAGetSelectError(LParam);
		  case WSAGetSelectEvent(LParam) of
			FD_READ	 : IncommingData(AMsg, Error);
		  else
			if Error <> 0 then
				putsocketError('WndProc');
		  end;
		end;
	  WM_TIMER:
		  OnTimer(WParam);
	else
	  Result := DefWindowProc(Handle, Msg, WParam, LParam);
	end;
end;

function Get_Mode(command : ULONG): ULONG;
begin
	Result := command and $000000ff;
end;

function GET_OPT(command : ULONG): ULONG;
begin
	Result := command and $ffffff00;
end;

function TIPMsg.BroadcastSend(msg : AnsiString) : boolean;
var
	command : ULONG;
	msgBuf : array[0..MAX_UDPBUF] of AnsiChar;
	i : integer;
	s : AnsiString;
begin
	command := IPMSG_SENDMSG or IPMSG_BROADCASTOPT;

	if SecretCheck then begin
		command := command or IPMSG_SECRETOPT;
		SecretCheck := false;
	end;

	if PasswordCheck then begin
		command := command or IPMSG_PASSWORDOPT;
		PasswordCheck := false;
	end;

	MakeMsg(s, command, msg);
	StrLCopy(msgBuf, PAnsiChar(s), sizeof(msgBuf) - 1);
//	  StrPCopy(msgBuf, s);

	if Broadcastlist.Count > 0 then
		for i := 0 to broadcastList.count - 1 do
			Send(broadcastList.objs[i].addr, IPMSG_NOOPERATION, '', '');

	if BroadcastList.count > 0 then
		Sleep(DelayTime);

  // modified begin
  (*
	UdpSend(not 0, msgBuf, '', strlen(msgBuf) +1);	// local network broadcast
  *)
  UdpSend(ULONG(not 0), msgBuf, '', strlen(msgBuf) +1);	// local network broadcast
  // modified end

	if broadcastList.count > 0 then
		for i := 0 to BroadcastList.Count - 1 do
			UdpSend(broadcastList.objs[i].addr, msgBuf, '', strlen(msgBuf) + 1);

	if DialUpList.Count > 0 then
		for i := 0 to DialupList.Count - 1 do
			UdpSend(broadcastlist.objs[i].addr, msgbuf, '', strlen(msgbuf) + 1);

	Result := true;
end;

function TIPMsg.NormalSend(msg : AnsiString) : boolean;
var
	command : ULONG;
	buf : array[0..MAX_UDPBUF] of AnsiChar;
	s : AnsiString;
	i : integer;
begin
	if hostList.sendEntryCount <= 0 then begin
		Result := False;
		Exit;
	end;

	command := IPMSG_SENDMSG or IPMSG_SENDCHECKOPT;

	if SecretCheck then begin
		command := command or IPMSG_SECRETOPT;
		SecretCheck := false;
	end;

	if PasswordCheck then begin
		command := command or IPMSG_PASSWORDOPT or IPMSG_SECRETOPT;
		PasswordCheck := false;
	end;

	if hostList.sendEntryCount > 1 then
		command := command or IPMSG_MULTICASTOPT;

	packetNo := MakeMsg(s, command, msg);

	// バッファにメッセージを格納。
//	StrPCopy(buf, s);
	StrLCopy(buf, PAnsiChar(s), sizeof(buf) - 1);

	for i := 0 to hostList.Count - 1 do
		if hostList.hosts[i].sendCheck then begin
			UdpSend(hostList.hosts[i].addr, buf, '', strlen(buf) +1);
			hostList.hosts[i].sendCheck := false;
		end;
	Result := True;

//	timerID := SetTimer(FHandle, IPMSG_SEND_TIMER, RetryMSec, nil);
end;

function strtok(var src : AnsiString; delimiter : AnsiString) : AnsiString;
var
	i : integer;
begin
	if delimiter = '' then begin
		Result := src;
		src := '';
		Exit;
	end;

	i := AnsiPos(string(delimiter), string(src));
	if i > 0 then begin
		Result := Copy(src, 1, i-1);
		Delete(src, 1, i);
	end else
		Result := '';
end;

procedure Register;
begin
  RegisterComponents('Samples', [TIPMsg]);
end;

end.
