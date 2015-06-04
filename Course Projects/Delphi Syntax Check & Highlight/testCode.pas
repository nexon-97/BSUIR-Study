Program testCode;

Uses SysUtils, System.Types, Forms, AdditionalUnit;

type
  PListElement = ^TListElement;
  TListElement = record
    data : LongInt;
    prev, next : PListElement;
  end;
  TMas = SomeArray;

const HELLO_MESSAGE : String = 'Hello, World!';
      otherConst             = 5;

function BitchFunction(a, b: yayechko) : Word;
var soska : Woman;
begin

end;

function SomeTestFunction(var param1, param2: Word; a: ^LongInt) : Boolean;
begin
  WriteLn('Some kind of shouting!');

  repeat
    writeln('a');
  until ('a' = 'b');

  for i := Length(myStr) downto 1 do
    begin
      WriteLn('Yeshko');

      if CorrectStatement then
        Alert('Alibaba!');

      WriteLn('Yeshko2');

      while (axis = 'left') do
        begin
          SingASong;
          Dance;

          Inc(myObject.mood);
        end;
    end;
end;

procedure TCodeTextField.SetSize(size: TPoint);
begin
  fSize := size;
  Refresh;
end;

procedure TCodeTextField.TypeLetter(c: Char);
begin
  if (Ord(c) = KEY_BACKSPACE) then
    ProcessBackSpace
  else if (Ord(c) = KEY_ENTER) then
    ProcessEnter
  else if (Ord(c) >= KEY_SPACE) then
    AppendChar(c);

  RefreshCaretPos;
end;

procedure TCodeTextField.OnDeletePressed;
var tempString: String;
begin
  if (GetSelectionLength > 0) then
    RemoveSelection
  else if (fCaretPos.x < Length(fLines[fCaretPos.y])) then
    begin
      tempString := Copy(fLines[fCaretPos.y], 0, fCaretPos.x) + Copy(fLines[fCaretPos.y], fCaretPos.x + 2, Length(fLines[fCaretPos.y]));

      tempString := Copy(fLineStyles[fCaretPos.y], 0, fCaretPos.x) + Copy(fLineStyles[fCaretPos.y], fCaretPos.x + 2, Length(fLineStyles[fCaretPos.y]));
      SetLineStyle(fCaretPos.y, tempString);

      OnLineTextChanged(fCaretPos.y);
      RedrawLine(fCaretPos.y);
    end
  else if (fCaretPos.y < fLines.Count - 1) then
    begin
      tempString := fLines.y + 1;

      fLines.Delete(fCaretPos.y + 1);
      fLineStyles.Delete(fCaretPos.y + 1);

      OnLineTextChanged(fCaretPos.y);
      RedrawLinesFromCaretPos;
    end;

  RefreshCaretPos;
end;

// Procedure to process caret (arrow keys movements)
procedure TCodeTextField.MoveCaret(dir, flags: Byte);
var isSelecting  : Boolean;
    caretMoveDir : Integer;
    posOld       : TPoint;
begin
  posOld := fCaretPos;
  isSelecting := (flags and KEY_FLAG_LSHIFT <> 0);

  // Refresh selection borders
  if not isSelecting then
    begin
      fSelStart := fCaretPos;
      fSelEnd := fCaretPos;
    end
  else
    begin
      // Define caret movement direction
      caretMoveDir := comparePositions(fCaretPos, posOld);

      if (caretMoveDir = 1) then
        begin
          if (comparePositions(fCaretPos, fSelEnd) = 1) then
            fSelEnd := fCaretPos
          else
            fSelStart := fCaretPos;
        end
      else if (caretMoveDir = -1) then
        begin
          if (comparePositions(fCaretPos, fSelStart) = -1) then
            fSelStart := fCaretPos
          else
            fSelEnd := fCaretPos;
        end;
    end;

  RefreshCaretPos;
end;