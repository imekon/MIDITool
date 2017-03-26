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

unit midi.input;

interface

uses
  WinApi.Windows, WinApi.MMSystem, System.SyncObjs, trace.console;

type
  TMIDIInput = class
  protected
    m_log: TTrace;
    m_handle: HMIDIIN;
    m_lock: TCriticalSection;
    procedure Callback(msg, param1, param2: cardinal); virtual; abstract;
    procedure Decode(param: integer; var code, param1, param2: byte);
  public
    constructor Create(log: TTrace; device: integer); virtual;
    destructor Destroy; override;
  end;

implementation

{ TMIDIInput }

procedure InputCallback(handle: HMIDIIN; msg: UInt; instance, param1, param2: cardinal); stdcall;
var
  midiInput: TMIDIInput;

begin
  midiInput := TMIDIInput(instance);
  midiInput.Callback(msg, param1, param2);
end;

constructor TMIDIInput.Create(log: TTrace; device: integer);
begin
  m_log := log;
  m_lock := TCriticalSection.Create;
  m_log.Log('MIDI input created for device %d', [device]);
  midiInOpen(@m_handle, device, cardinal(@InputCallback), cardinal(self), CALLBACK_FUNCTION);
  midiInStart(m_handle);
end;

procedure TMIDIInput.Decode(param: integer; var code, param1, param2: byte);
begin
  code := param and $FF;
  param1 := (param shr 8) and $FF;
  param2 := (param shr 16) and $FF;
end;

destructor TMIDIInput.Destroy;
begin
  midiInStop(m_handle);
  midiInClose(m_handle);
  m_lock.Free;
  inherited;
end;

end.
