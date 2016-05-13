unit Cls_ISession;

interface
  uses
    System.Win.ObjComAuto,  //TObjectDispatch.
    Winapi.ActiveX,         //Largeuint.

    ChannelUtils_TLB,  //ISession.
    Cls_Session;  //TSession;

  type
    TCounter = Cls_Session.TCounter;
    TTypeCounter = Cls_Session.TTypeCounter;
    TTypeCounterExec = Cls_Session.TTypeCounterExec;

    TTimer = Cls_Session.TTimer;
    TTypeTimer = Cls_Session.TTypeTimer;
    TTypeTimerExec = Cls_Session.TTypeTimerExec;

  type
    {$REGION ' TISession '}
    TISession = class( TObjectDispatch, ChannelUtils_TLB.ISession )
      private
        FSession : Cls_Session.ISession;
      private
        //Получение значения.
        function Get_StartDT: TDateTime; safecall;
        function Get_FinishDT: TDateTime; safecall;
        function Get_Duration: Largeuint; safecall;
        function Get_Success: Largeuint; safecall;
        function Get_Fail: Largeuint; safecall;
        //Присвоение значения.
        procedure SetStartDT(const AValue: TDateTime);
        procedure SetFinishDT(const AValue: TDateTime);
        procedure SetSuccess(const AValue: Largeuint);
        procedure SetFail(const AValue: Largeuint);
      public
        property StartDT: TDateTime read Get_StartDT write SetStartDT;
        property FinishDT: TDateTime read Get_FinishDT write SetFinishDT;
        property Duration: Largeuint read Get_Duration;
        property Success: Largeuint read Get_Success write SetSuccess;
        property Fail: Largeuint read Get_Fail write SetFail;
      public
        procedure Counters(const ATpCounter: array of TTypeCounter; const ATpExec: TTypeCounterExec = tceClear; const AConst: TCounter = 1);
        procedure Timers(const ATpTimer: array of TTypeTimer; const ATpExec: TTypeTimerExec = tteClear; const AConst: TTimer = 0);
      public
        constructor Create(ASession : TSession = nil); overload;
        destructor Destroy; override;
    end;
    {$ENDREGION}

implementation

{$REGION ' TISession '}
//Создание/Разрушение класса.
constructor TISession.Create(ASession : TSession);
begin
  inherited Create(nil);
  if not Assigned( ASession ) then
    FSession := TSession.Create
  else
    FSession := ASession;
end;
destructor TISession.Destroy;
begin
  FSession := nil;
  inherited;
end;

//Получение значения.
function TISession.Get_StartDT: TDateTime;
begin
  Result := FSession.StartDT;
end;
function TISession.Get_FinishDT: TDateTime;
begin
  Result := FSession.FinishDT;
end;
function TISession.Get_Duration: Largeuint;
begin
  Result := FSession.Duration;
end;
function TISession.Get_Success: Largeuint;
begin
  Result := FSession.Success;
end;
function TISession.Get_Fail: Largeuint;
begin
  Result := FSession.Fail;
end;
//Присвоение значения.
procedure TISession.SetStartDT(const AValue: TDateTime);
begin
  FSession.StartDT := AValue;
end;
procedure TISession.SetFinishDT(const AValue: TDateTime);
begin
  FSession.FinishDT := AValue;
end;
procedure TISession.SetSuccess(const AValue: Largeuint);
begin
  FSession.Success := AValue;
end;

procedure TISession.Counters(const ATpCounter: array of TTypeCounter;
  const ATpExec: TTypeCounterExec; const AConst: TCounter);
begin
  FSession.Counters( ATpCounter, ATpExec, AConst );
end;
procedure TISession.Timers(const ATpTimer: array of TTypeTimer;
  const ATpExec: TTypeTimerExec; const AConst: TTimer);
begin
  FSession.Timers( ATpTimer, ATpExec, AConst );
end;

procedure TISession.SetFail(const AValue: Largeuint);
begin
  FSession.Fail := AValue;
end;
{$ENDREGION}
end.
