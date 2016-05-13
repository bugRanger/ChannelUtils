unit Cls_IComPort;

interface
  uses
    System.Win.ObjComAuto, //TObjectDispatch.
    System.SysUtils,
    Winapi.ActiveX,

    ChannelUtils_TLB,

    Cls_ISession,

    Cls_TComPort,

    Cls_Buffer,
    Cls_Warder,

    Tmp_Result;

  type
    {$REGION ' TIComPort '}
    TIComPort = class( TObjectDispatch, ChannelUtils_TLB.IComPort, IWarderClass<TIComPort> )
      private
        FComPort  : TComPort;
        FEvents   : ICoChannelUtilsEvents;
        FSession  : TISession;
      private
        //����� �����������.
        FWarder   : IWarderClass<TIComPort>;
      private
        function Get_Number: Word; safecall;
        function Get_BaudRate: Word; safecall;
        function Get_ByteSize: ChannelUtils_TLB.TByteSize; safecall;
        function Get_Parity: ChannelUtils_TLB.TParity; safecall;
        function Get_StopBits: ChannelUtils_TLB.TStopBits; safecall;
        function Get_BufSize: Word; safecall;
        function Get_ReadIntervalTimeout: Word; safecall;
        function Get_ReadTotalTimeoutConstant: Word; safecall;
        function Get_ReadTotalTimeoutMultiplier: Word; safecall;
        function Get_WriteTotalTimeoutConstant: Word; safecall;
        function Get_WriteTotalTimeoutMultiplier: Word; safecall;
        function Get_Session: ISession; safecall;
        procedure Set_Number(AValue: Word); safecall;
        procedure Set_BaudRate(AValue: Word); safecall;
        procedure Set_ByteSize(AValue: ChannelUtils_TLB.TByteSize); safecall;
        procedure Set_Parity(AValue: ChannelUtils_TLB.TParity); safecall;
        procedure Set_StopBits(AValue: ChannelUtils_TLB.TStopBits); safecall;
        procedure Set_BufSize(AValue: Word); safecall;
        procedure Set_ReadIntervalTimeout(AValue: Word); safecall;
        procedure Set_ReadTotalTimeoutConstant(AValue: Word); safecall;
        procedure Set_ReadTotalTimeoutMultiplier(AValue: Word); safecall;
        procedure Set_WriteTotalTimeoutConstant(AValue: Word); safecall;
        procedure Set_WriteTotalTimeoutMultiplier(AValue: Word); safecall;
      private
        function GetWarder(): IWarderClass<TIComPort>;
      public
        property Number: Word read Get_Number write Set_Number;
        property BaudRate: Word read Get_BaudRate write Set_BaudRate;
        property ByteSize: ChannelUtils_TLB.TByteSize read Get_ByteSize write Set_ByteSize;
        property Parity: ChannelUtils_TLB.TParity read Get_Parity write Set_Parity;
        property StopBits: ChannelUtils_TLB.TStopBits read Get_StopBits write Set_StopBits;
        property BufSize: Word read Get_BufSize write Set_BufSize;
        property Session: ChannelUtils_TLB.ISession read Get_Session;
      public
        property ReadIntervalTimeout: Word read Get_ReadIntervalTimeout write Set_ReadIntervalTimeout;
        property ReadTotalTimeoutConstant: Word read Get_ReadTotalTimeoutConstant write Set_ReadTotalTimeoutConstant;
        property ReadTotalTimeoutMultiplier: Word read Get_ReadTotalTimeoutMultiplier write Set_ReadTotalTimeoutMultiplier;
        property WriteTotalTimeoutConstant: Word read Get_WriteTotalTimeoutConstant write Set_WriteTotalTimeoutConstant;
        property WriteTotalTimeoutMultiplier: Word read Get_WriteTotalTimeoutMultiplier write Set_WriteTotalTimeoutMultiplier;
      public
        property Warder: IWarderClass<TIComPort> read GetWarder implements IWarderClass<TIComPort>;
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
        constructor Create(AEvents: ICoChannelUtilsEvents = nil); overload;
        destructor Destroy; override;
    end;
    TIComPortWarder = class( TWarderClass<TIComPort> );
    {$ENDREGION}

implementation
  uses
    Fnc_ConvVariant;

{$REGION ' TIComPort '}
constructor TIComPort.Create(AEvents: ICoChannelUtilsEvents);
begin
  inherited Create( nil );
  //�����������.
  FWarder := TIComPortWarder.Create( Self, nil );
    FWarder.OnInfo  := Self.OnInfo;
    FWarder.OnError := Self.OnError;
  //����������.
  FEvents   := AEvents;
  //��������.
  FComPort  := TComPort.Create( FWarder );
    FComPort.OnExchangeByte := Self.OnExchange;
    FComPort.OnWriteByte := Self.OnWrite;
    FComPort.OnReadByte := Self.OnRead;
  //������ ������.
  FSession := TISession.Create( FComPort.Session );
end;
destructor TIComPort.Destroy;
begin//������������.
  FComPort.Free;
  //���������.
  FSession  := nil;
  FEvents   := nil;
  FWarder   := nil;
  inherited;
end;

{$REGION ' ���������/���������� ��������. '}
//��������� ��������.
function TIComPort.GetWarder: IWarderClass<TIComPort>;
begin
  Result := FWarder;
end;
function TIComPort.Get_Number: Word;
begin
  Result := FComPort.ComNumber;
end;
function TIComPort.Get_BaudRate: Word;
begin
  Result := FComPort.BaudRate;
end;
function TIComPort.Get_ByteSize: ChannelUtils_TLB.TByteSize;
begin
  Result := ChannelUtils_TLB.TByteSize( FComPort.ByteSize );
end;
function TIComPort.Get_Parity: ChannelUtils_TLB.TParity;
begin
  Result := ChannelUtils_TLB.TParity( FComPort.Parity );
end;
function TIComPort.Get_StopBits: ChannelUtils_TLB.TStopBits;
begin
  Result := ChannelUtils_TLB.TStopBits( FComPort.StopBits );
end;
function TIComPort.Get_BufSize: Word;
begin
  Result := FComPort.BufSize;
end;
function TIComPort.Get_Session: ISession;
begin
  Result := FSession;
end;
function TIComPort.Get_ReadIntervalTimeout: Word;
begin
  Result := FComPort.ReadIntervalTimeout;
end;
function TIComPort.Get_ReadTotalTimeoutConstant: Word;
begin
  Result := FComPort.ReadTotalTimeoutConstant;
end;
function TIComPort.Get_ReadTotalTimeoutMultiplier: Word;
begin
  Result := FComPort.ReadTotalTimeoutMultiplier;
end;
function TIComPort.Get_WriteTotalTimeoutConstant: Word;
begin
  Result := FComPort.WriteTotalTimeoutConstant;
end;
function TIComPort.Get_WriteTotalTimeoutMultiplier: Word;
begin
  Result := FComPort.WriteTotalTimeoutMultiplier;
end;
//���������� ��������.
procedure TIComPort.Set_Number(AValue: Word);
begin
  FComPort.ComNumber := AValue;
end;
procedure TIComPort.Set_BaudRate(AValue: Word);
begin
  FComPort.BaudRate := AValue;
end;
procedure TIComPort.Set_BufSize(AValue: Word);
begin
  FComPort.BufSize := AValue;
end;
procedure TIComPort.Set_ByteSize(AValue: ChannelUtils_TLB.TByteSize);
begin
  FComPort.ByteSize := TByteSize( AValue );
end;
procedure TIComPort.Set_Parity(AValue: ChannelUtils_TLB.TParity);
begin
  FComPort.Parity := TParity( AValue );
end;
procedure TIComPort.Set_StopBits(AValue: ChannelUtils_TLB.TStopBits);
begin
  FComPort.StopBits := TStopBits( AValue );
end;
procedure TIComPort.Set_ReadIntervalTimeout(AValue: Word);
begin
  FComPort.ReadIntervalTimeout := AValue;
end;
procedure TIComPort.Set_ReadTotalTimeoutConstant(AValue: Word);
begin
  FComPort.ReadTotalTimeoutConstant := AValue;
end;
procedure TIComPort.Set_ReadTotalTimeoutMultiplier(AValue: Word);
begin
  FComPort.ReadTotalTimeoutMultiplier := AValue;
end;
procedure TIComPort.Set_WriteTotalTimeoutConstant(AValue: Word);
begin
  FComPort.WriteTotalTimeoutConstant := AValue;
end;
procedure TIComPort.Set_WriteTotalTimeoutMultiplier(AValue: Word);
begin
  FComPort.WriteTotalTimeoutMultiplier := AValue;
end;
{$ENDREGION}

{$REGION ' �������. '}
procedure TIComPort.OnExchange(const ASendBuf, ARecvBuf: TBuffer; const AErrCode: Cardinal; const AResult: TExecuteResult);
begin
  if Assigned( Self.FEvents ) then
    Self.FEvents.OnExchange( ASendBuf.ToVariant(), ARecvBuf.ToVariant(), TResultExec( AResult ));
end;
procedure TIComPort.OnWrite(const ABuffer: TBuffer; const ABytesTrans, AErrCode: Cardinal; const AResult: TExecuteResult);
begin
  if Assigned( Self.FEvents ) then
    Self.FEvents.OnWrite( ABuffer.ToVariant(), ABytesTrans, AErrCode, TResultExec( AResult ));
end;
procedure TIComPort.OnRead(const ABuffer: TBuffer; const ABytesTrans,  AErrCode: Cardinal; const AResult: TExecuteResult);
begin
  if Assigned( Self.FEvents ) then
    Self.FEvents.OnRead( ABuffer.ToVariant(), ABytesTrans, AErrCode, TResultExec( AResult ));
end;

procedure TIComPort.OnInfo(const AGUID: TGUID; const AText: string; const AType: TWarderMessage);
begin
  if AType in [ tmSelf, tmComPort ] then
    Self.FEvents.OnInfo( TConvVariant.FromRecord<TGUID>( AGUID ), AText );
end;
procedure TIComPort.OnError(const AGUID: TGUID; const AText: string; const AType: TWarderMessage; const AError: Exception);
begin
  if Assigned( Self.FEvents ) then
    if AType in [ tmSelf, tmComPort ] then
    case Assigned( AError ) of
      True:
        Self.FEvents.OnError( TConvVariant.FromRecord<TGUID>( AGUID ), AText, AError.Message );
      False:
        Self.FEvents.OnError( TConvVariant.FromRecord<TGUID>( AGUID ), AText, string.Empty );
    end;
end;
{$ENDREGION}

//�������� ���������.
function TIComPort.Connected: WordBool;
begin
  Result := FComPort.Connected;
end;
//�����/������/������.
function TIComPort.Exchange(AQuery: PSafeArray; out AReturn: PSafeArray): TResultExec;
  var
    lQuery, lReturn : TBuffer;
begin//�������.
  lQuery.Clear();
  lReturn.Clear();
  try
    lQuery  := TBuffer.ToBuffer( AQuery );
    Result  := TResultExec( FComPort.ExchangeByte( lQuery, lReturn ));
    AReturn := lReturn.ToPSafeArray();
  finally//�������.
    lReturn.Clear();
    lQuery.Clear();
  end;
end;
function TIComPort.Write(AQuery: PSafeArray; var ABytesTrans, AErrorCode: Word): TResultExec;
  var
    lBytes : Cardinal absolute ABytesTrans;
    lError : Cardinal absolute AErrorCode;
begin
  Result := TResultExec( FComPort.WriteByte( TBuffer.ToBuffer( AQuery ), lBytes, lError ));
end;
function TIComPort.Read(out AReturn: PSafeArray; var ABytesTrans, AErrorCode: Word): TResultExec;
  var
    lReturn : TBuffer;
    lBytes  : Cardinal absolute ABytesTrans;
    lError  : Cardinal absolute AErrorCode;
begin//�������.
  lReturn.Clear();
  try
    Result  := TResultExec( FComPort.ReadByte( lReturn, lBytes, lError ));
    AReturn := lReturn.ToPSafeArray();
  finally//�������.
    lReturn.Clear();
  end;
end;

//���������/��������� ���� (��� ������ ������).
procedure TIComPort.Open;
  const
    cMethodName = 'Open';
    cLUID : TGUID = '{81856462-820A-4347-BEA6-0858F8B8E9B1}';
begin
  try
    FComPort.Open( 0, True );
  except
    on E:Exception do
      Self.Warder.CallError( cLUID, cMethodName, tmComPort, E );
  end;
end;
procedure TIComPort.Close;
  const
    cMethodName = 'Close';
    cLUID : TGUID = '{57825B93-6221-48AD-959E-6902F88F4F4C}';
begin
  try
    FComPort.Close();
  except
    on E:Exception do
      Self.Warder.CallError( cLUID, cMethodName, tmComPort, E );
  end;
end;
{$ENDREGION}
end.
