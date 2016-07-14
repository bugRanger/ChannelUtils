unit Cls_ISocket;

interface
  uses
    System.Win.ObjComAuto, //TObjectDispatch.
    System.SysUtils,
    Winapi.ActiveX,   //PSafeArray.

    ChannelUtils_TLB,

    Cls_ISession,

    Cls_SocketCtrl,

    Cls_Buffer,
    Cls_Warder,

    Tmp_Result;

  type
    {$REGION ' TISocket '}
    TISocket = class( TObjectDispatch, ChannelUtils_TLB.ISocket, IReconnect,
      IWarderClass<TISocket> )
      const
        cTagHost = '127.0.0.1';
        cTagPort = 0;
      private
        FSocket   : TSocketCtrl<IUnknown>;
        FEvents   : ICoChannelUtilsEvents;
        FSession  : TISession;
      private
        //Класс надзиратель.
        FWarder   : IWarderClass<TISocket>;
      private
        function Get_Host: WideString; safecall;
        function Get_Port: Integer; safecall;
        function Get_TotalTime: Word; safecall;
        function Get_ReactivateTime: Int64; safecall;
        function Get_Reconnect: IReconnect; safecall;
        function Get_Attempts: UInt64; safecall;
        function Get_Interval: UInt64; safecall;
        function Get_Session: ISession; safecall;
        procedure Set_Host(const AValue: WideString); safecall;
        procedure Set_Port(AValue: Integer); safecall;
        procedure Set_TotalTime(AValue: Word); safecall;
        procedure Set_ReactivateTime(AValue: Int64); safecall;
        procedure Set_Attempts(AValue: UInt64); safecall;
        procedure Set_Interval(AValue: UInt64); safecall;
      private
        function GetWarder(): IWarderClass<TISocket>;
      public
        property Host: WideString read Get_Host write Set_Host;
        property Port: Integer read Get_Port write Set_Port;
        property TotalTime: Word read Get_TotalTime write Set_TotalTime;
        property ReactivateTime: Int64 read Get_ReactivateTime write Set_ReactivateTime;
        property Reconnect: IReconnect read Get_Reconnect;
        property Session: ChannelUtils_TLB.ISession read Get_Session;
      public
        property Warder: IWarderClass<TISocket> read GetWarder implements IWarderClass<TISocket>;
      private
        procedure OnExchange(const ASendBuf, ARecvBuf: TBuffer; const AErrCode: Cardinal; const AResult: TExecuteResult);
        procedure OnWrite(const ABuffer: TBuffer; const ABytesTrans, AErrCode: Cardinal; const AResult: TExecuteResult);
        procedure OnRead(const ABuffer: TBuffer; const ABytesTrans, AErrCode: Cardinal; const AResult: TExecuteResult);
      private
        procedure OnInfo(const AGUID: TGUID; const AText: string; const AType: TWarderMessage);
        procedure OnError(const AGUID: TGUID; const AText: string; const AType: TWarderMessage; const AError: Exception);
      public
        function Exchange(AQuery: PSafeArray; out AReturn: PSafeArray): TResultExec; safecall;
        function Write(AQuery: PSafeArray; var ABytesTrans: Word; var AErrorCode: Word): TResultExec; safecall;
        function Read(out AReturn: PSafeArray; var ABytesTrans: Word; var AErrorCode: Word): TResultExec; safecall;
      public
        function Connected: WordBool; safecall;
      public
        procedure Open; safecall;
        procedure Close; safecall;
      public
        constructor Create(AClose: THandle = INVALID_HANDLE_VALUE; AEvents: ICoChannelUtilsEvents = nil); overload;
        destructor Destroy; override;
    end;
    TISocketWarder = class( TWarderClass<TISocket> );
    {$ENDREGION}

implementation
  uses
    System.Variants,
    Winapi.Windows,

    Fnc_ConvVariant;

{$REGION ' TISocket '}
//Создание/Разрушение класса.
constructor TISocket.Create(AClose: THandle; AEvents: ICoChannelUtilsEvents);
begin
  inherited Create( nil );
  //Надзиратель.
  FWarder := TISocketWarder.Create( Self, nil );
    FWarder.OnInfo  := Self.OnInfo;
    FWarder.OnError := Self.OnError;
  //Присвоение.
  FEvents := AEvents;
  //Создание.
  FSocket := TSocketCtrl<IUnknown>.Create( nil, cTagHost, cTagPort, AClose, FWarder );
    FSocket.OnExchange  := Self.OnExchange;
    FSocket.OnWrite     := Self.OnWrite;
    FSocket.OnRead      := Self.OnRead;
  //Сессия канала.
  FSession := TISession.Create( FSocket.Session );
end;
destructor TISocket.Destroy;
begin//Освобождение.
  FSocket.Free;
  //Обнуление.
  FSession  := nil;
  FEvents   := nil;
  FWarder   := nil;
  inherited;
end;

{$REGION ' Получение/Присвоение значения. '}
//Получение/Присвоение значений.
function TISocket.GetWarder: IWarderClass<TISocket>;
begin
  Result := FWarder;
end;

function TISocket.Get_Host: WideString;
begin
  Result := FSocket.ClientSocket.Custom.Host;
end;
function TISocket.Get_Port: Integer;
begin
  Result := FSocket.ClientSocket.Custom.Port;
end;
function TISocket.Get_TotalTime: Word;
begin
  Result := FSocket.ExchangeTM;
end;
function TISocket.Get_ReactivateTime: Int64;
begin
  Result := FSocket.ClientSocket.Reconnect.Interval;
end;
function TISocket.Get_Reconnect: IReconnect;
begin
  Result := Self as IReconnect;
end;
function TISocket.Get_Attempts: UInt64;
begin
  Result := FSocket.Attempts;
end;
function TISocket.Get_Interval: UInt64;
begin
  Result := FSocket.Interval;
end;
function TISocket.Get_Session: ISession;
begin
  Result := FSession;
end;

procedure TISocket.Set_Host(const AValue: WideString);
begin
  FSocket.ClientSocket.Custom.Host := AValue;
end;
procedure TISocket.Set_Port(AValue: Integer);
begin
  FSocket.ClientSocket.Custom.Port := AValue;
end;
procedure TISocket.Set_TotalTime(AValue: Word);
begin
  FSocket.ExchangeTM := AValue;
end;
procedure TISocket.Set_ReactivateTime(AValue: Int64);
begin//Сначало указываем что будет запуск, потом значение.
  //Иначе таймер сразу пойдет на выполнение, что приведет к двойному открытию.
  FSocket.ClientSocket.Reconnect.Interval := AValue;
end;
procedure TISocket.Set_Attempts(AValue: UInt64);
begin
  FSocket.Attempts := AValue;
end;
procedure TISocket.Set_Interval(AValue: UInt64);
begin
  FSocket.Interval := AValue;
end;
{$ENDREGION}
{$REGION ' События. '}
procedure TISocket.OnExchange(const ASendBuf, ARecvBuf: TBuffer; const AErrCode: Cardinal; const AResult: TExecuteResult);
begin
  if Assigned( Self.FEvents ) then
    Self.FEvents.OnExchange( ASendBuf.ToVariant(), ARecvBuf.ToVariant(), TResultExec( AResult ));
end;
procedure TISocket.OnWrite(const ABuffer: TBuffer; const ABytesTrans, AErrCode: Cardinal; const AResult: TExecuteResult);
begin
  if Assigned( Self.FEvents ) then
    Self.FEvents.OnWrite( ABuffer.ToVariant(), ABytesTrans, AErrCode, TResultExec( AResult ));
end;
procedure TISocket.OnRead(const ABuffer: TBuffer; const ABytesTrans, AErrCode: Cardinal; const AResult: TExecuteResult);
begin
  if Assigned( Self.FEvents ) then
    Self.FEvents.OnRead( ABuffer.ToVariant(), ABytesTrans, AErrCode, TResultExec( AResult ));
end;

procedure TISocket.OnInfo(const AGUID: TGUID; const AText: string; const AType: TWarderMessage);
begin
  if AType in [ tmSelf, tmSocket ] then
    Self.FEvents.OnInfo( TConvVariant.FromRecord<TGUID>( AGUID ), AText );
end;
procedure TISocket.OnError(const AGUID: TGUID; const AText: string; const AType: TWarderMessage; const AError: Exception);
begin
  if Assigned( Self.FEvents ) then
    if AType in [ tmSelf, tmSocket ] then
  case Assigned( AError ) of
    True:
      Self.FEvents.OnError( TConvVariant.FromRecord<TGUID>( AGUID ), AText, AError.Message );
    False:
      Self.FEvents.OnError( TConvVariant.FromRecord<TGUID>( AGUID ), AText, string.Empty );
  end;
end;
{$ENDREGION}

//Проверка связи.
function TISocket.Connected: WordBool;
begin
  Result := FSocket.Connected();
end;

//Обмен/Запись/Чтение.
function TISocket.Exchange(AQuery: PSafeArray; out AReturn: PSafeArray): TResultExec;
  var
    lQuery, lReturn : TBuffer;
begin//Очищаем.
  lQuery.Clear();
  lReturn.Clear();
  try
    lQuery  := TBuffer.ToBuffer( AQuery );
    Result  := TResultExec( FSocket.ExchangeByte( lQuery, lReturn ));
    AReturn := lReturn.ToPSafeArray();
  finally//Очищаем.
    lReturn.Clear();
    lQuery.Clear();
  end;
end;
function TISocket.Write(AQuery: PSafeArray; var ABytesTrans: Word; var AErrorCode: Word): TResultExec;
  var
    lBytes : Cardinal absolute ABytesTrans;
    lError : Cardinal absolute AErrorCode;
begin
  Result := TResultExec( FSocket.WriteByte( TBuffer.ToBuffer( AQuery ), lBytes, lError ));
end;
function TISocket.Read(out AReturn: PSafeArray; var ABytesTrans: Word; var AErrorCode: Word): TResultExec;
  var
    lReturn : TBuffer;
    lBytes  : Cardinal absolute ABytesTrans;
    lError  : Cardinal absolute AErrorCode;
begin//Очищаем.
  lReturn.Clear();
  try
    Result  := TResultExec( FSocket.ReadByte( lReturn, lBytes, lError ));
    AReturn := lReturn.ToPSafeArray();
  finally//Очищаем.
    lReturn.Clear();
  end;
end;

//Открываем/Закрываем сокет.
procedure TISocket.Open;
begin
  FSocket.Execute( smOpen );
end;
procedure TISocket.Close;
begin
  FSocket.Execute( smClose );
end;
{$ENDREGION}
end.
