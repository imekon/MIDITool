// Copyright (c) 2017 Pete Goodwin
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

unit main;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls,
  midi.input.queue, midi.output, trace.console;

type
  TMainForm = class(TForm)
    MIDIButton: TButton;
    StatusBox: TListBox;
    InputMessageTick: TTimer;
    InputDeviceLabel: TLabel;
    OutputDeviceLabel: TLabel;
    StatusEdit: TEdit;
    Param1Edit: TEdit;
    Param2Edit: TEdit;
    Send: TButton;
    procedure MIDIButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OnInputTick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SendClick(Sender: TObject);
  private
    { Private declarations }
    m_log: TTrace;
    m_selectedInput, m_selectedOutput: integer;
    m_midiInput: TMIDIInputQueue;
    m_midiOutput: TMIDIOutput;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses midi.configuration.form, midi.configuration;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  m_selectedInput := -1;
  m_selectedOutput := -1;
  m_midiInput := nil;
  m_midiOutput := nil;
  m_log := TTraceDummy.Create;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  if Assigned(m_midiInput) then
    m_midiInput.Free;

  if Assigned(m_midiOutput) then
    m_midiOutput.Free;

  m_log.Free;
end;

procedure TMainForm.MIDIButtonClick(Sender: TObject);
var
  i, n: integer;
  outputs, inputs: TStringList;
  dlg: TMIDIConfigurationForm;

begin
  n := TMIDIConfiguration.GetNumOutputDevices;
  outputs := TStringList.Create;
  for i := 0 to n - 1 do
    outputs.Add(TMIDIConfiguration.GetOutputDeviceName(i));

  n := TMIDIConfiguration.GetNumInputDevices;
  inputs := TStringList.Create;
  for i := 0 to n - 1 do
    inputs.Add(TMIDIConfiguration.GetInputDeviceName(i));

  dlg := TMIDIConfigurationForm.Create(self);
  dlg.Init(inputs, outputs, m_selectedInput, m_selectedOutput);
  try
    if dlg.ShowModal = mrOK then
    begin
      m_selectedInput := dlg.SelectedInput;
      m_selectedOutput := dlg.SelectedOutput;

      if Assigned(m_midiInput) then
      begin
        m_midiInput.Free;
        m_midiInput := nil;
      end;

      if m_selectedInput <> -1 then
      begin
        m_midiInput := TMIDIInputQueue.Create(m_log, m_selectedInput);
        InputDeviceLabel.Caption := 'Connected: ' + TMIDIConfiguration.GetInputDeviceName(m_selectedInput);
      end;

      if Assigned(m_midiOutput) then
      begin
        m_midiOutput.Free;
        m_midiOutput := nil;
      end;

      if m_selectedOutput <> -1 then
      begin
        m_midiOutput := TMIDIOutput.Create(m_selectedOutput);
        OutputDeviceLabel.Caption := 'Connected: ' + TMIDIConfiguration.GetOutputDeviceName(m_selectedOutput);
      end;
    end;
  finally
    dlg.Free;
  end;
end;

procedure TMainForm.OnInputTick(Sender: TObject);
var
  line: integer;
  midiMessage: TMIDIMessage;

begin
  if Assigned(m_midiInput) then
  begin
    if m_midiInput.GetInput(midiMessage) then
    begin
      line := StatusBox.Items.Add(Format('%02x %02x %02x', [midiMessage.status, midiMessage.param1, midiMessage.param2]));
      StatusBox.TopIndex := line;
    end;
  end;
end;

procedure TMainForm.SendClick(Sender: TObject);
var
  status, param1, param2: integer;

begin
  if assigned(m_midiOutput) then
  begin
    status := StrToInt(StatusEdit.Text);
    param1 := StrToInt(Param1Edit.Text);
    param2 := StrToInt(Param1Edit.Text);

    m_midiOutput.Send(status, param1, param2);
  end;
end;

end.
