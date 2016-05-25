unit Cls_ChannelUtils;

{$WARN SYMBOL_PLATFORM OFF}

interface
  uses
    ComObj, ActiveX, AxCtrls, Classes, StdVcl,

    ChannelUtils_TLB;

  type
    TCoCannalUtils = class(TAutoObject, IConnectionPointContainer, ICoChannelUtils)
      private
        { Private declarations }
        FConnectionPoints: TConnectionPoints;
        FConnectionPoint: TConnectionPoint;
        FEvents: ICoChannelUtilsEvents;
        { note: FEvents maintains a *single* event sink. For access to more
          than one event sink, use FConnectionPoint.SinkList, and iterate
          through the list of sinks. }
      public
        procedure Initialize; override;
      protected
        function Create(AKind: TPortKind; out AValue: IUnknown): WordBool; safecall;
        { Protected declarations }
        property ConnectionPoints: TConnectionPoints read FConnectionPoints implements IConnectionPointContainer;
        procedure EventSinkChanged(const EventSink: IUnknown); override;
        { TODO: Change all instances of type [ICoPortUtilsEvents] to [ICoCannalUtilsEvents].}
        {    Delphi was not able to update this file to reflect
             the change of the name of your event interface
             because of the presence of instance variables.
             The type library was updated but you must update
             this implementation file by hand. }
    end;

implementation
  uses
    ComServ,
    Cls_IComPort,
    Cls_ISocket;

procedure TCoCannalUtils.EventSinkChanged(const EventSink: IUnknown);
begin
  FEvents := EventSink as ICoChannelUtilsEvents;
end;

procedure TCoCannalUtils.Initialize;
begin
  inherited Initialize;
  FConnectionPoints := TConnectionPoints.Create(Self);
  if AutoFactory.EventTypeInfo <> nil then
    FConnectionPoint := FConnectionPoints.CreateConnectionPoint(
      AutoFactory.EventIID, ckSingle, EventConnect )
  else FConnectionPoint := nil;
end;

function TCoCannalUtils.Create(AKind: TPortKind; out AValue: IUnknown): WordBool;
begin Result := False;
  case Ord( AKind ) of
    pkComPort:
      AValue := TIComPort.Create( FEvents );
    pkSocket:
      AValue := TISocket.Create( FEvents );
  end;
  Result := Assigned( AValue );
end;

initialization
  TAutoObjectFactory.Create(ComServer, TCoCannalUtils, Class_CoChannelUtils,
    ciMultiInstance, tmFree);
//  if Comserver.StartMode = smAutomation then
//    ComObj.CoAddRefServerProcess;
finalization
//  if Comserver.StartMode = smAutomation then
//    ComObj.CoReleaseServerProcess;
end.
