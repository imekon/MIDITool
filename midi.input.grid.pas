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

unit midi.input.grid;

interface

uses
  midi.input, trace.console;

type
  TMIDICell = packed record
    Value: byte;
    Updated: boolean;
  end;

  TMIDIInputGrid = class(TMIDIInput)
  private
    m_grid: array [0..127] of TMIDICell;
  protected
    procedure Callback(msg, param1, param2: cardinal); override;
  public
    constructor Create(log: TTrace; device: integer); override;
    function GetValue(index: integer; var value: integer): boolean;
  end;

implementation

{ TMIDIInputGrid }

procedure TMIDIInputGrid.Callback(msg, param1, param2: cardinal);
var
  code, p1, p2: byte;

begin
  Decode(param1, code, p1, p2);
  if (code = $B0) or (code = $90) then
  begin
    m_lock.Acquire;
    m_grid[p1].Value := p2;
    m_grid[p1].Updated := true;
    m_lock.Release;
  end
  else if code = $90 then
  begin
    m_lock.Acquire;
    m_grid[p1].Value := 0;
    m_grid[p1].Updated := true;
    m_lock.Release;
  end;
end;

constructor TMIDIInputGrid.Create(log: TTrace; device: integer);
var
  i: integer;

begin
  inherited;

  for i := Low(m_grid) to High(m_grid) do
    with m_grid[i] do
    begin
      Value := 0;
      Updated := false;
    end;
end;

function TMIDIInputGrid.GetValue(index: integer; var value: integer): boolean;
begin
  result := false;
  m_lock.Acquire;
  if m_grid[index].Updated then
  begin
    value := m_grid[index].Value;
    m_grid[index].Updated := false;
    result := true;
  end;
  m_lock.Release;
end;

end.
