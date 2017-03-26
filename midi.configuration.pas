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

unit midi.configuration;

interface

type
  TMIDIConfiguration = class
  public
    class function GetNumOutputDevices: integer;
    class function GetNumInputDevices: integer;
    class function GetOutputDeviceName(device: integer): string;
    class function GetInputDeviceName(device: integer): string;
  end;

implementation

{ TMIDIConfiguration }

uses
  WinApi.MMSystem;

class function TMIDIConfiguration.GetInputDeviceName(device: integer): string;
var
  caps: TMIDIINCAPS;

begin
  midiInGetDevCaps(device, @caps, sizeof(TMIDIINCAPS));
  result := caps.szPname;
end;

class function TMIDIConfiguration.GetNumInputDevices: integer;
begin
  result := midiInGetNumDevs;
end;

class function TMIDIConfiguration.GetNumOutputDevices: integer;
begin
  result := midiOutGetNumDevs;
end;

class function TMIDIConfiguration.GetOutputDeviceName(device: integer): string;
var
  caps: TMIDIOUTCAPS;

begin
  midiOutGetDevCaps(device, @caps, sizeof(TMIDIOUTCAPS));
  result := caps.szPname;
end;

end.
