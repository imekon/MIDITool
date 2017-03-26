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

unit midi.input.queue;

interface

uses
  System.Generics.Collections, midi.input, trace.console;

type
  TMIDIMessage = packed record
    status: byte;
    param1: byte;
    param2: byte;
    reserved: byte;
    timecode: cardinal;
  end;

  TMIDIInputQueue = class(TMIDIInput)
  protected
    m_queue: TQueue<TMIDIMessage>;

    procedure Callback(msg, param1, param2: cardinal); override;

  public
    constructor Create(log: TTrace; device: integer); override;
    destructor Destroy; override;
    function GetInput(var midiMessage: TMIDIMessage): boolean;
  end;

implementation

procedure TMIDIInputQueue.Callback(msg, param1, param2: cardinal);
var
  code, p1, p2: byte;
  midiMessage: TMIDIMessage;

begin
  m_log.Log('Callback: %x %x %x', [msg, param1, param2]);

  if param1 = 0 then
    exit;

  m_lock.Acquire;
  Decode(param1, code, p1, p2);
  midiMessage.status := code;
  midiMessage.param1 := p1;
  midiMessage.param2 := p2;
  midiMessage.timecode := param2;
  m_queue.Enqueue(midiMessage);
  m_lock.Release;
end;

constructor TMIDIInputQueue.Create(log: TTrace; device: integer);
begin
  inherited;
  m_queue := TQueue<TMIDIMessage>.Create;
end;

destructor TMIDIInputQueue.Destroy;
begin
  m_queue.Free;
  inherited;
end;

function TMIDIInputQueue.GetInput(var midiMessage: TMIDIMessage): boolean;
begin
  result := false;
  m_lock.Acquire;
  if m_queue.Count > 0 then
  begin
    midiMessage := m_queue.Dequeue;
    result := true;
  end;
  m_lock.Release;
end;

end.
