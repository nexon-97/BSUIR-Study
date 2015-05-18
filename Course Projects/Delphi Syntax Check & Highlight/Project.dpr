program Project;

uses
  Forms,
  UnitMain in 'UnitMain.pas' {ProgramForm},
  XmlCodeUnit in 'XmlCodeUnit.pas' {XmlCodeForm},
  StyleConfiguratorUnit in 'StyleConfiguratorUnit.pas' {StyleConfiguratorForm},
  ErrorDisplayFormUnit in 'ErrorDisplayFormUnit.pas' {ErrorDisplayForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TProgramForm, ProgramForm);
  Application.CreateForm(TXmlCodeForm, XmlCodeFrame);
  Application.CreateForm(TStyleConfiguratorForm, StyleConfiguratorForm);
  Application.CreateForm(TErrorDisplayForm, ErrorDisplayForm);
  Application.Run;
end.
