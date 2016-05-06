unit Cls_ISocket;

interface
  uses
    System.Win.ObjComAuto, //TObjectDispatch.
    Winapi.ActiveX,

    ChannelUtils_TLB,

    Cls_SocketCtrl,

    Cls_Buffer,
    Cls_Warder,

    Tmp_Result;

  type
    {$REGION ' TISocket '}
    TISocket = class( TObjectDispatch, ChannelUtils_TLB.ISocket, IWarderClass<TISocket> )
      const
        cTagHost = '127.0.0.1';
        cTagPort = 0;
      private
        FSocket   : TSocketCtrl<IUnknown>;
        FEvents   : ICoChannelUtilsEvents;
      private
        //Класс надзиратель.
        FWarder   : IWarderClass<TISocket>;
      private
        function Get_Host: WideString; safecall;
        function Get_Port: Integer; safecall;
        function Get_TotalTime: Word; safecall;
        function Get_Reconnect: Int64; safecall;
        procedure Set_Host(const AValue: WideString); safecall;
        procedure Set_Port(AValue: Integer); safecall;
        procedure Set_TotalTime(AValue: Word); safecall;
        procedure Set_Reconnect(AValue: Int64); safecall;
      private
        function GetWarder(): IWarderClass<TISocket>;
      public
        property Host: WideString read Get_Host write Set_Host;
        property Port: Integer read Get_Port write Set_Port;
        property TotalTime: Word read Get_TotalTime write Set_TotalTime;
        property Reconnect: Int64 read Get_Reconnect write Set_Reconnect;
      public
        property Warder: IWarderClass<TISocket> read GetWarder implements IWarderClass<TISocket>;
      private
        procedure OnExchange(const ASendBuf, ARecvBuf: TBuffer; const AErrCode: Cardinal; const AResult: TExecuteResult);
        procedure OnWrite(const ABuffer: TBuffer; const ABytesTrans, AErrCode: Cardinal; const AResult: TExecuteResult);
        procedure OnRead(const ABuffer: TBuffer; const ABytesTrans, AErrCode: Cardinal; const AResult: TExecuteResult);
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
        constructor Create(AEvents: ICoChannelUtilsEvents); overload;
        destructor Destroy; override;
    end;
    TISocketWarder = class( TWarderClass<TISocket> );

implementation
  uses
    System.Variants,
    System.SysUtils;

{$REGION ' TISocket '}
//Создание/Разрушение класса.
constructor TISocket.Create(AEvents: ICoChannelUtilsEvents);
begin
  inherited Create( nil );
  FWarder := TISocketWarder.Create( Self, nil );
  FEvents := AEvents;
  FSocket := TSocketCtrl<IUnknown>.Create( cTagHost, cTagPort, FWarder );
    FSocket.OnExchange  := Self.OnExchange;
    FSocket.OnWrite     := Self.OnWrite;
    FSocket.OnRead      := Self.OnRead;
end;
destructor TISocket.Destroy;
begin
  FSocket.Free;
  FEvents := nil;
  FWarder := nil;
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
  Result := FSocket.ClientSocket.Custom.Address;
end;
function TISocket.Get_Port: Integer;
begin
  Result := FSocket.ClientSocket.Custom.Port;
end;
function TISocket.Get_TotalTime: Word;
begin
  Result := FSocket.ExchangeTM;
end;
function TISocket.Get_Reconnect: Int64;
begin
  Result := FSocket.ClientSocket.Reconnect.Interval;
end;
procedure TISocket.Set_Host(const AValue: WideString);
begin
  FSocket.ClientSocket.Custom.Address := AValue;
end;
procedure TISocket.Set_Port(AValue: Integer);
begin
  FSocket.ClientSocket.Custom.Port := AValue;
end;
procedure TISocket.Set_TotalTime(AValue: Word);
begin
  FSocket.ExchangeTM := AValue;
end;
procedure TISocket.Set_Reconnect(AValue: Int64);
begin
  FSocket.ClientSocket.Reconnect.Interval := AValue;
  FSocket.ClientSocket.Reconnect.Enabled  := ( AValue > 0 );
end;
{$ENDREGION}

{$REGION ' События. '}
procedure TISocket.OnExchange(const ASendBuf, ARecvBuf: TBuffer; const AErrCode: Cardinal; const AResult: TExecuteResult);
begin
  if Assigned( Self.FEvents ) then
    Self.FEvents.OnExchange( ASendBuf.ToVariant(), ARecvBuf.ToVariant(), TResultExec( AResult ));
end;
procedure TISocket.OnRead(const ABuffer: TBuffer; const ABytesTrans, AErrCode: Cardinal; const AResult: TExecuteResult);
begin
  if Assigned( Self.FEvents ) then
    Self.FEvents.OnWrite( ABuffer.ToVariant(), ABytesTrans, AErrCode, TResultExec( AResult ));
end;
procedure TISocket.OnWrite(const ABuffer: TBuffer; const ABytesTrans, AErrCode: Cardinal; const AResult: TExecuteResult);
begin
  if Assigned( Self.FEvents ) then
    Self.FEvents.OnRead( ABuffer.ToVariant(), ABytesTrans, AErrCode, TResultExec( AResult ));
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
  try
    FSocket.ClientSocket.Custom.Active := True;
  except
    on E:Exception do
      Self.Warder.CrtError(E.Message);
  end;
end;
procedure TISocket.Close;
begin
  try
    FSocket.ClientSocket.Custom.Active := False;
  except
    on E:Exception do
      Self.Warder.CrtError(E.Message);
  end;
end;
{$ENDREGION}
end.
