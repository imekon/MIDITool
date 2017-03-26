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

unit midi.output;

interface

uses
  WinApi.Windows, WinApi.MMSystem;

type
  TMIDIOutput = class
  private
    m_handle: HMIDIOUT;
  public
    constructor Create(device: integer);
    destructor Destroy; override;
    procedure Send(msg, param1, param2: integer);
  end;

implementation

{ TMIDIOutput }

constructor TMIDIOutput.Create(device: integer);
begin
  midiOutOpen(@m_handle, device, 0, cardinal(self), CALLBACK_NULL);
end;

destructor TMIDIOutput.Destroy;
begin
  midiOutClose(m_handle);
  inherited;
end;

procedure TMIDIOutput.Send(msg, param1, param2: integer);
var
  data: cardinal;

begin
  data := (msg and $FF) + ((param1 and $FF) shl 8) + ((param2 and $FF) shl 16);
  midiOutShortMsg(m_handle, data);
end;

end.
