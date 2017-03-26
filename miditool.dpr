program miditool;

uses
  Vcl.Forms,
  main in 'main.pas' {MainForm},
  midi.configuration.form in 'midi.configuration.form.pas' {MIDIConfigurationForm},
  midi.configuration in 'midi.configuration.pas',
  midi.input.grid in 'midi.input.grid.pas',
  midi.input in 'midi.input.pas',
  midi.input.queue in 'midi.input.queue.pas',
  midi.output in 'midi.output.pas',
  trace.console in 'trace.console.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
