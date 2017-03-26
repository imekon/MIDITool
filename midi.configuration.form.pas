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

unit midi.configuration.form;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TMIDIConfigurationForm = class(TForm)
    Label1: TLabel;
    OutputDeviceList: TListBox;
    Label2: TLabel;
    InputDeviceList: TListBox;
    OKBtn: TButton;
    CancelBtn: TButton;
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
    m_selectedInput, m_selectedOutput: integer;
  public
    { Public declarations }
    procedure Init(inputDevices, outputDevices: TStrings;
      selectedInput, selectedOutput: integer);

    property SelectedInput: integer read m_selectedInput;
    property SelectedOutput: integer read m_selectedOutput;
  end;

implementation

{$R *.dfm}

{ TMIDIConfigurationForm }

procedure TMIDIConfigurationForm.Init(inputDevices, outputDevices: TStrings;
  selectedInput, selectedOutput: integer);
begin
  m_selectedInput := selectedInput;
  m_selectedOutput := selectedOutput;

  OutputDeviceList.Items := outputDevices;
  InputDeviceList.Items := inputDevices;

  if selectedOutput <> -1 then
    OutputDeviceList.Selected[selectedOutput] := true;

  if selectedInput <> -1 then
    InputDeviceList.Selected[selectedInput] := true;
end;

procedure TMIDIConfigurationForm.OKBtnClick(Sender: TObject);
var
  i: integer;

begin
  m_selectedInput := -1;
  for i := 0 to InputDeviceList.Items.Count - 1 do
  begin
    if InputDeviceList.Selected[i] then
    begin
      m_selectedInput := i;
      break;
    end;
  end;

  m_selectedOutput := -1;
  for i := 0 to OutputDeviceList.Items.Count - 1 do
  begin
    if OutputDeviceList.Selected[i] then
    begin
      m_selectedOutput := i;
      break;
    end;
  end;
end;

end.
