library ChannelUtils;

uses
  ComServ,
  Cls_ComPort in '..\_source\Exchange\Cls_ComPort.pas',
  Cls_Exchange in '..\_source\Exchange\Cls_Exchange.pas',
  Cls_Warder in '..\_source\Log\Cls_Warder.pas',
  Cls_Others in '..\_source\Others\Cls_Others.pas',
  Cls_Session in '..\_source\Others\Cls_Session.pas',
  ChannelUtils_TLB in 'Source\ComInterfaces\ChannelUtils_TLB.pas',
  Cls_ChannelUtils in 'Source\ComInterfaces\Cls_ChannelUtils.pas' {CoChannelUtils: CoClass},
  Cls_Buffer in '..\_source\Exchange\Cls_Buffer.pas',
  Cls_SysTimer in '..\_source\Exchange\Cls_SysTimer.pas',
  Tmp_Result in '..\_source\Exchange\Tmp_Result.pas',
  Cls_IComPort in 'Source\ComInterfaces\Main\Cls_IComPort.pas',
  Cls_SocketCtrl in '..\_source\Exchange\Cls_SocketCtrl.pas',
  Fnc_ConvVariant in '..\_source\Others\Fnc_ConvVariant.pas',
  Cls_ISocket in 'Source\ComInterfaces\Main\Cls_ISocket.pas',
  Cls_ISession in 'Source\ComInterfaces\Main\Cls_ISession.pas',
  Cls_ThreadCls in '..\_source\Exchange\Cls_ThreadCls.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer,
  DllInstall;

{$R *.TLB}
{$R *.RES}

begin
//  IsMultiThread := True;
end.
