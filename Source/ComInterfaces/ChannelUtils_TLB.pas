unit ChannelUtils_TLB;

// ************************************************************************ //
// WARNING
// -------
// The types declared in this file were generated from data read from a
// Type Library. If this type library is explicitly or indirectly (via
// another type library referring to this type library) re-imported, or the
// 'Refresh' command of the Type Library Editor activated while editing the
// Type Library, the contents of this file will be regenerated and all
// manual modifications will be lost.
// ************************************************************************ //

// $Rev: 52393 $
// File generated on 02.08.2016 13:50:11 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\Projects\InDeveloping\ChannelUtils\Source\ComInterfaces\ChannelUtils (1)
// LIBID: {7992BFC5-ABE3-4242-816B-DA90AE41D75D}
// LCID: 0
// Helpfile:
// HelpString: SoftCaten interface ChannelUtils
// DepndLst:
//   (1) v2.0 stdole, (C:\Windows\system32\stdole2.tlb)
// SYS_KIND: SYS_WIN32
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers.
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
{$ALIGN 4}

interface

uses Winapi.Windows, System.Classes, System.Variants, System.Win.StdVCL, Vcl.Graphics, Vcl.OleServer, Winapi.ActiveX;


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:
//   Type Libraries     : LIBID_xxxx
//   CoClasses          : CLASS_xxxx
//   DISPInterfaces     : DIID_xxxx
//   Non-DISP interfaces: IID_xxxx
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  ChannelUtilsMajorVersion = 1;
  ChannelUtilsMinorVersion = 0;

  LIBID_ChannelUtils: TGUID = '{7992BFC5-ABE3-4242-816B-DA90AE41D75D}';

  IID_ICoChannelUtils: TGUID = '{D3B687E1-48C5-4DA2-88E8-781F5B34935B}';
  IID_ISession: TGUID = '{C5C46EE4-B117-44B4-A9B5-CB705C9FAC46}';
  IID_IComPort: TGUID = '{EF7B9287-2F23-4A8C-8876-36FF41A2B00C}';
  IID_ISocket: TGUID = '{788F821C-DC1E-4EDD-8FE6-B943A94131EA}';
  DIID_ICoChannelUtilsEvents: TGUID = '{1F94FBFD-0AEF-4C39-ABCC-B1F1C41CB3E0}';
  CLASS_CoChannelUtils: TGUID = '{74C42692-DB68-4FB8-953A-5B278CD55419}';
  IID_IReconnect: TGUID = '{DCBA7ACB-CA98-47CF-9620-47E66FBF6F53}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library
// *********************************************************************//
// Constants for enum TByteSize
type
  TByteSize = TOleEnum;
const
  bs5 = $00000005;
  bs6 = $00000006;
  bs7 = $00000007;
  bs8 = $00000008;

// Constants for enum TParity
type
  TParity = TOleEnum;
const
  ptNONE = $00000000;
  ptODD = $00000001;
  ptEVEN = $00000002;
  ptMARK = $00000003;
  ptSPASE = $00000004;

// Constants for enum TStopBits
type
  TStopBits = TOleEnum;
const
  sbONE = $00000000;
  sbONE5 = $00000001;
  sbTWO = $00000002;

// Constants for enum TPortKind
type
  TPortKind = TOleEnum;
const
  pkComPort = $00000000;
  pkSocket = $00000001;

// Constants for enum TResultExec
type
  TResultExec = TOleEnum;
const
  exGood = $00000000;
  exError = $00000001;
  exClose = $00000002;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary
// *********************************************************************//
  ICoChannelUtils = interface;
  ICoChannelUtilsDisp = dispinterface;
  ISession = interface;
  ISessionDisp = dispinterface;
  IComPort = interface;
  IComPortDisp = dispinterface;
  ISocket = interface;
  ISocketDisp = dispinterface;
  ICoChannelUtilsEvents = dispinterface;
  IReconnect = interface;
  IReconnectDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library
// (NOTE: Here we map each CoClass to its Default Interface)
// *********************************************************************//
  CoChannelUtils = ICoChannelUtils;


// *********************************************************************//
// Interface: ICoChannelUtils
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D3B687E1-48C5-4DA2-88E8-781F5B34935B}
// *********************************************************************//
  ICoChannelUtils = interface(IDispatch)
    ['{D3B687E1-48C5-4DA2-88E8-781F5B34935B}']
    function Create(AKind: TPortKind; out AValue: IUnknown; AClose: LongWord): WordBool; safecall;
  end;

// *********************************************************************//
// DispIntf:  ICoChannelUtilsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D3B687E1-48C5-4DA2-88E8-781F5B34935B}
// *********************************************************************//
  ICoChannelUtilsDisp = dispinterface
    ['{D3B687E1-48C5-4DA2-88E8-781F5B34935B}']
    function Create(AKind: TPortKind; out AValue: IUnknown; AClose: LongWord): WordBool; dispid 201;
  end;

// *********************************************************************//
// Interface: ISession
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C5C46EE4-B117-44B4-A9B5-CB705C9FAC46}
// *********************************************************************//
  ISession = interface(IDispatch)
    ['{C5C46EE4-B117-44B4-A9B5-CB705C9FAC46}']
    function Get_StartDT: TDateTime; safecall;
    function Get_FinishDT: TDateTime; safecall;
    function Get_Duration: Largeuint; safecall;
    function Get_Success: Largeuint; safecall;
    function Get_Fail: Largeuint; safecall;
    property StartDT: TDateTime read Get_StartDT;
    property FinishDT: TDateTime read Get_FinishDT;
    property Duration: Largeuint read Get_Duration;
    property Success: Largeuint read Get_Success;
    property Fail: Largeuint read Get_Fail;
  end;

// *********************************************************************//
// DispIntf:  ISessionDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C5C46EE4-B117-44B4-A9B5-CB705C9FAC46}
// *********************************************************************//
  ISessionDisp = dispinterface
    ['{C5C46EE4-B117-44B4-A9B5-CB705C9FAC46}']
    property StartDT: TDateTime readonly dispid 201;
    property FinishDT: TDateTime readonly dispid 202;
    property Duration: Largeuint readonly dispid 203;
    property Success: Largeuint readonly dispid 204;
    property Fail: Largeuint readonly dispid 205;
  end;

// *********************************************************************//
// Interface: IComPort
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF7B9287-2F23-4A8C-8876-36FF41A2B00C}
// *********************************************************************//
  IComPort = interface(IDispatch)
    ['{EF7B9287-2F23-4A8C-8876-36FF41A2B00C}']
    function Get_Number: Word; safecall;
    procedure Set_Number(AValue: Word); safecall;
    function Get_BaudRate: LongWord; safecall;
    procedure Set_BaudRate(AValue: LongWord); safecall;
    function Get_ByteSize: TByteSize; safecall;
    procedure Set_ByteSize(AValue: TByteSize); safecall;
    function Get_Parity: TParity; safecall;
    procedure Set_Parity(AValue: TParity); safecall;
    function Get_StopBits: TStopBits; safecall;
    procedure Set_StopBits(AValue: TStopBits); safecall;
    function Get_BufSize: Word; safecall;
    procedure Set_BufSize(AValue: Word); safecall;
    function Get_Reconnect: IReconnect; safecall;
    function Get_Session: ISession; safecall;
    function Get_ReadIntervalTimeout: Word; safecall;
    procedure Set_ReadIntervalTimeout(AValue: Word); safecall;
    function Get_ReadTotalTimeoutConstant: Word; safecall;
    procedure Set_ReadTotalTimeoutConstant(AValue: Word); safecall;
    function Get_ReadTotalTimeoutMultiplier: Word; safecall;
    procedure Set_ReadTotalTimeoutMultiplier(AValue: Word); safecall;
    function Get_WriteTotalTimeoutConstant: Word; safecall;
    procedure Set_WriteTotalTimeoutConstant(AValue: Word); safecall;
    function Get_WriteTotalTimeoutMultiplier: Word; safecall;
    procedure Set_WriteTotalTimeoutMultiplier(AValue: Word); safecall;
    procedure Open; safecall;
    procedure Close; safecall;
    function Connected: WordBool; safecall;
    function Exchange(AQuery: PSafeArray; out AReturn: PSafeArray): TResultExec; safecall;
    function Read(out AReturn: PSafeArray; var ABytesTrans: Word; var AErrorCode: Word): TResultExec; safecall;
    function Write(AQuery: PSafeArray; var ABytesTrans: Word; var AErrorCode: Word): TResultExec; safecall;
    property Number: Word read Get_Number write Set_Number;
    property BaudRate: LongWord read Get_BaudRate write Set_BaudRate;
    property ByteSize: TByteSize read Get_ByteSize write Set_ByteSize;
    property Parity: TParity read Get_Parity write Set_Parity;
    property StopBits: TStopBits read Get_StopBits write Set_StopBits;
    property BufSize: Word read Get_BufSize write Set_BufSize;
    property Reconnect: IReconnect read Get_Reconnect;
    property Session: ISession read Get_Session;
    property ReadIntervalTimeout: Word read Get_ReadIntervalTimeout write Set_ReadIntervalTimeout;
    property ReadTotalTimeoutConstant: Word read Get_ReadTotalTimeoutConstant write Set_ReadTotalTimeoutConstant;
    property ReadTotalTimeoutMultiplier: Word read Get_ReadTotalTimeoutMultiplier write Set_ReadTotalTimeoutMultiplier;
    property WriteTotalTimeoutConstant: Word read Get_WriteTotalTimeoutConstant write Set_WriteTotalTimeoutConstant;
    property WriteTotalTimeoutMultiplier: Word read Get_WriteTotalTimeoutMultiplier write Set_WriteTotalTimeoutMultiplier;
  end;

// *********************************************************************//
// DispIntf:  IComPortDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF7B9287-2F23-4A8C-8876-36FF41A2B00C}
// *********************************************************************//
  IComPortDisp = dispinterface
    ['{EF7B9287-2F23-4A8C-8876-36FF41A2B00C}']
    property Number: Word dispid 201;
    property BaudRate: LongWord dispid 202;
    property ByteSize: TByteSize dispid 203;
    property Parity: TParity dispid 204;
    property StopBits: TStopBits dispid 205;
    property BufSize: Word dispid 206;
    property Reconnect: IReconnect readonly dispid 219;
    property Session: ISession readonly dispid 218;
    property ReadIntervalTimeout: Word dispid 207;
    property ReadTotalTimeoutConstant: Word dispid 208;
    property ReadTotalTimeoutMultiplier: Word dispid 209;
    property WriteTotalTimeoutConstant: Word dispid 210;
    property WriteTotalTimeoutMultiplier: Word dispid 211;
    procedure Open; dispid 212;
    procedure Close; dispid 213;
    function Connected: WordBool; dispid 217;
    function Exchange(AQuery: {NOT_OLEAUTO(PSafeArray)}OleVariant;
                      out AReturn: {NOT_OLEAUTO(PSafeArray)}OleVariant): TResultExec; dispid 214;
    function Read(out AReturn: {NOT_OLEAUTO(PSafeArray)}OleVariant; var ABytesTrans: Word;
                  var AErrorCode: Word): TResultExec; dispid 215;
    function Write(AQuery: {NOT_OLEAUTO(PSafeArray)}OleVariant; var ABytesTrans: Word;
                   var AErrorCode: Word): TResultExec; dispid 216;
  end;

// *********************************************************************//
// Interface: ISocket
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {788F821C-DC1E-4EDD-8FE6-B943A94131EA}
// *********************************************************************//
  ISocket = interface(IDispatch)
    ['{788F821C-DC1E-4EDD-8FE6-B943A94131EA}']
    function Get_Host: WideString; safecall;
    procedure Set_Host(const AValue: WideString); safecall;
    function Get_Port: Integer; safecall;
    procedure Set_Port(AValue: Integer); safecall;
    function Get_TotalTime: Word; safecall;
    procedure Set_TotalTime(AValue: Word); safecall;
    function Get_ReactivateTime: Int64; safecall;
    procedure Set_ReactivateTime(Value: Int64); safecall;
    function Get_Reconnect: IReconnect; safecall;
    function Get_Session: ISession; safecall;
    procedure Open; safecall;
    procedure Close; safecall;
    function Connected: WordBool; safecall;
    function Exchange(AQuery: PSafeArray; out AReturn: PSafeArray): TResultExec; safecall;
    function Read(out AReturn: PSafeArray; var ABytesTrans: Word; var AErrorCode: Word): TResultExec; safecall;
    function Write(AQuery: PSafeArray; var ABytesTrans: Word; var AErrorCode: Word): TResultExec; safecall;
    property Host: WideString read Get_Host write Set_Host;
    property Port: Integer read Get_Port write Set_Port;
    property TotalTime: Word read Get_TotalTime write Set_TotalTime;
    property ReactivateTime: Int64 read Get_ReactivateTime write Set_ReactivateTime;
    property Reconnect: IReconnect read Get_Reconnect;
    property Session: ISession read Get_Session;
  end;

// *********************************************************************//
// DispIntf:  ISocketDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {788F821C-DC1E-4EDD-8FE6-B943A94131EA}
// *********************************************************************//
  ISocketDisp = dispinterface
    ['{788F821C-DC1E-4EDD-8FE6-B943A94131EA}']
    property Host: WideString dispid 201;
    property Port: Integer dispid 202;
    property TotalTime: Word dispid 203;
    property ReactivateTime: Int64 dispid 204;
    property Reconnect: IReconnect readonly dispid 206;
    property Session: ISession readonly dispid 205;
    procedure Open; dispid 212;
    procedure Close; dispid 213;
    function Connected: WordBool; dispid 217;
    function Exchange(AQuery: {NOT_OLEAUTO(PSafeArray)}OleVariant;
                      out AReturn: {NOT_OLEAUTO(PSafeArray)}OleVariant): TResultExec; dispid 214;
    function Read(out AReturn: {NOT_OLEAUTO(PSafeArray)}OleVariant; var ABytesTrans: Word;
                  var AErrorCode: Word): TResultExec; dispid 215;
    function Write(AQuery: {NOT_OLEAUTO(PSafeArray)}OleVariant; var ABytesTrans: Word;
                   var AErrorCode: Word): TResultExec; dispid 216;
  end;

// *********************************************************************//
// DispIntf:  ICoChannelUtilsEvents
// Flags:     (0)
// GUID:      {1F94FBFD-0AEF-4C39-ABCC-B1F1C41CB3E0}
// *********************************************************************//
  ICoChannelUtilsEvents = dispinterface
    ['{1F94FBFD-0AEF-4C39-ABCC-B1F1C41CB3E0}']
    function OnExchange(AQuery: {NOT_OLEAUTO(PSafeArray)}OleVariant;
                        AReturn: {NOT_OLEAUTO(PSafeArray)}OleVariant; AResult: TResultExec): HResult; dispid 201;
    function OnWrite(AQuery: {NOT_OLEAUTO(PSafeArray)}OleVariant; ABytesTrans: Word;
                     AErrorCode: Word; AResult: TResultExec): HResult; dispid 202;
    function OnRead(AReturn: {NOT_OLEAUTO(PSafeArray)}OleVariant; ABytesTrans: Word;
                    AErrorCode: Word; AResult: TResultExec): HResult; dispid 203;
    function OnError(AGUID: OleVariant; const AText: WideString; const AMessage: WideString): HResult; dispid 204;
    function OnInfo(AGUID: OleVariant; const AMessage: WideString): HResult; dispid 205;
  end;

// *********************************************************************//
// Interface: IReconnect
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DCBA7ACB-CA98-47CF-9620-47E66FBF6F53}
// *********************************************************************//
  IReconnect = interface(IDispatch)
    ['{DCBA7ACB-CA98-47CF-9620-47E66FBF6F53}']
    function Get_Attempts: Largeuint; safecall;
    procedure Set_Attempts(AValue: Largeuint); safecall;
    function Get_Interval: Largeuint; safecall;
    procedure Set_Interval(AValue: Largeuint); safecall;
    property Attempts: Largeuint read Get_Attempts write Set_Attempts;
    property Interval: Largeuint read Get_Interval write Set_Interval;
  end;

// *********************************************************************//
// DispIntf:  IReconnectDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DCBA7ACB-CA98-47CF-9620-47E66FBF6F53}
// *********************************************************************//
  IReconnectDisp = dispinterface
    ['{DCBA7ACB-CA98-47CF-9620-47E66FBF6F53}']
    property Attempts: Largeuint dispid 201;
    property Interval: Largeuint dispid 202;
  end;

// *********************************************************************//
// The Class CoCoChannelUtils provides a Create and CreateRemote method to
// create instances of the default interface ICoChannelUtils exposed by
// the CoClass CoChannelUtils. The functions are intended to be used by
// clients wishing to automate the CoClass objects exposed by the
// server of this typelibrary.
// *********************************************************************//
  CoCoChannelUtils = class
    class function Create: ICoChannelUtils;
    class function CreateRemote(const MachineName: string): ICoChannelUtils;
  end;

implementation

uses System.Win.ComObj;

class function CoCoChannelUtils.Create: ICoChannelUtils;
begin
  Result := CreateComObject(CLASS_CoChannelUtils) as ICoChannelUtils;
end;

class function CoCoChannelUtils.CreateRemote(const MachineName: string): ICoChannelUtils;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CoChannelUtils) as ICoChannelUtils;
end;

end.

