unit mMsgClass;

interface

uses
{$IF CompilerVersion > 22.9}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.Contnrs;
{$ELSE}
  Windows, Messages, SysUtils, Variants, Classes, Contnrs;
{$IFEND}


type
  TMsgItem = class(TObject)
  private
    { Private éŒ¾ }
    FUnRead: Boolean;
    FUserName: string;
    FDateTime: TDateTime;
    FText: string;
    FAddr: ULONG;
    FPacketNo: ULONG;
    FOpenCheck: Boolean;
  public
    { Public éŒ¾ }
    constructor Create(AUnRead: Boolean; AUserName: string; ADateTime: TDateTime; AText: string; AAddr, APacketNo: ULONG; AOpenCheck: Boolean);
    property UnRead: Boolean read FUnRead write FUnRead;
    property UserName: string read FUserName write FUserName;
    property DateTime: TDateTime read FDateTime write FDateTime;
    property Text: string read FText write FText;
    property Addr: ULONG read FAddr write FAddr;
    property PacketNo: ULONG read FPacketNo write FPacketNo;
    property OpenCheck: Boolean read FOpenCheck write FOpenCheck;
  end;

  TMsgList = class(TObjectList)
  private
    { Private éŒ¾ }
    function Get(Index: Integer): TMsgItem;
    procedure Put(Index: Integer; const Value: TMsgItem);
    procedure DoSort(const Index: Integer);
  public
    { Public éŒ¾ }
    procedure SortByColumnIndex(const Index: NativeInt);
    function IndexOfSub(const Addr, PacketNo: ULONG): NativeInt;
    property Items[Index: Integer]: TMsgItem read Get write Put; default;
  end;

var
  FMsgSortIndex: NativeInt = 0;
  FMsgSortFlag: NativeInt = 1;

implementation

uses
{$IF CompilerVersion > 22.9}
  System.DateUtils;
{$ELSE}
  DateUtils;
{$IFEND}

{ TMsgItem }

constructor TMsgItem.Create(AUnRead: Boolean; AUserName: string;
  ADateTime: TDateTime; AText: string; AAddr, APacketNo: ULONG;
  AOpenCheck: Boolean);
begin
  FUnRead := AUnRead;
  FUserName := AUserName;
  FDateTime := ADateTime;
  FText := AText;
  FAddr := AAddr;
  FPacketNo := APacketNo;
  FOpenCheck := AOpenCheck;
end;

{ TMsgList }

function MessageSortByColumn(Item1, Item2: Pointer): Integer;
begin
  Result := 0;
  case FMsgSortIndex of
    0:
      Result := FMsgSortFlag * CompareText(TMsgItem(Item1).UserName, TMsgItem(Item2).UserName);
    1:
      Result := FMsgSortFlag * CompareDateTime(TMsgItem(Item1).DateTime, TMsgItem(Item2).DateTime);
  end;
end;

function TMsgList.Get(Index: Integer): TMsgItem;
begin
  Result := TMsgItem( inherited Get(Index));
end;

procedure TMsgList.Put(Index: Integer; const Value: TMsgItem);
begin
  inherited Put(Index, Value);
end;

function TMsgList.IndexOfSub(const Addr, PacketNo: ULONG): NativeInt;
begin
  for Result := 0 to Count - 1 do
    if (Get(Result).Addr = Addr) and (Get(Result).PacketNo = PacketNo) then
      Exit;
  Result := -1;
end;

procedure TMsgList.DoSort(const Index: Integer);
begin
  FMsgSortIndex := Index;
  Sort(MessageSortByColumn);
  FMsgSortFlag := -FMsgSortFlag;
end;

procedure TMsgList.SortByColumnIndex(const Index: NativeInt);
begin
  if Count < 1 then
    Exit;
  DoSort(Index);
end;

end.
