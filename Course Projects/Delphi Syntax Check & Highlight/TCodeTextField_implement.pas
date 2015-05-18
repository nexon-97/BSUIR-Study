constructor TCodeTextField.Create(Control: TControl);
begin
	inherited Create(Control);

  InitTextField;
end;

procedure TCodeTextField.InitTextField;
begin
  fLines := TStringList.Create;
  fLineStyles := TStringList.Create;

  fLineDisplayStart := 0;
  fDisplayLength := 1;

  Cursor := crIBeam;

  fFontSize := Point(20, 10);

  fSize := Point(0, 0);
  fCaretPos := Point(0, 0);
  fSelStart := fCaretPos;
  fSelEnd := fCaretPos;
  fBackColor := clWhite;
  
  fEditStack := CreateStack;

  OnMouseDown := OnTextFieldPress;
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

procedure TCodeTextField.SelectAll;
begin
  fCaretPos.y := fLines.Count - 1;
  fCaretPos.x := Length(fLines[fCaretPos.y]);
  fSelStart := Point(0, 0);
  fSelEnd := fCaretPos;

  Refresh;
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
      fLines[fCaretPos.y] := tempString;

      tempString := Copy(fLineStyles[fCaretPos.y], 0, fCaretPos.x) + Copy(fLineStyles[fCaretPos.y], fCaretPos.x + 2, Length(fLineStyles[fCaretPos.y]));
      SetLineStyle(fCaretPos.y, tempString);

      OnLineTextChanged(fCaretPos.y);
      RedrawLine(fCaretPos.y);
    end
  else if (fCaretPos.y < fLines.Count - 1) then
    begin
      tempString := fLines[fCaretPos.y] + fLines[fCaretPos.y + 1];
      fLines[fCaretPos.y] := tempString;

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

  // Process caret movement
  case dir of
    DIR_LEFT:
      begin
        if (fCaretPos.x > 0) then
          Dec(fCaretPos.x)
        else if (fCaretPos.y > 0) then
          begin
            Dec(fCaretPos.y);
            fCaretPos.x := Length(fLines[fCaretPos.y]);
          end;
      end;
    DIR_RIGHT:
      begin
        if (fCaretPos.x < Length(fLines[fCaretPos.y])) then
          Inc(fCaretPos.x)
        else if (fCaretPos.y < fLines.Count - 1) then
          begin
            Inc(fCaretPos.y);
            fCaretPos.x := 0;
          end;
      end;
    DIR_UP:
        if (fCaretPos.y > 0) then
          begin
            Dec(fCaretPos.y);
            if (Length(fLines[fCaretPos.y]) < fCaretPos.x) then
              fCaretPos.x := Length(fLines[fCaretPos.y]);
          end;
    DIR_DOWN:
        if (fCaretPos.y < fLines.Count - 1) then
          begin
            Inc(fCaretPos.y);
            if (Length(fLines[fCaretPos.y]) < fCaretPos.x) then
              fCaretPos.x := Length(fLines[fCaretPos.y]);
          end;
  end;

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

function TCodeTextField.GetLineCount : Integer;
begin
  Result := fLines.Count;
end;

procedure TCodeTextField.Refresh;
begin
  Canvas.Brush.Color := ProgramForm.Color;
  Canvas.Pen.Color := ProgramForm.Color;
  Canvas.Rectangle(0, 0, Width, Height);
  // Refill
  Canvas.Pen.Color := clBlack;
  Canvas.Brush.Color := fBackColor;
  Canvas.Rectangle(0, 0, fSize.x, fSize.y);

  ProgramForm.CodeScrollVertical.Max := fLines.Count;

  RedrawLines;
end;

procedure TCodeTextField.RedrawLines;
var i: LongInt;
begin
  for i := fLineDisplayStart to GetLastDisplayedLine do
    RedrawLine(i);
end;

procedure TCodeTextField.RedrawLinesFromCaretPos;
var i: LongInt;
begin
  for i := fCaretPos.y to GetLastDisplayedLine do
    RedrawLine(i);
end;

procedure TCodeTextField.RedrawLine(line: LongInt);
var i : LongInt;
begin
  // Draw only visible lines
  if (line in [fLineDisplayStart..GetLastDisplayedLine]) then
    begin
      // Redraw background
      Canvas.Brush.Color := clWhite;
      Canvas.Pen.Color := clWhite;
      Canvas.Rectangle(1, 4 + fFontSize.y * line, fSize.x - 1, 4 + fFontSize.y * (line + 1));

      // Draw characters
      for i := 1 to Length(fLines[line]) do
        begin
          SetTextStyle( GetCharStyle(Point(i, line)) );
          
          if IsCharSelected(Point(i, line)) then
            begin
              Canvas.Brush.Color := fontStyles[TEXT_STYLE_SELECTED].backColor;
              Canvas.Pen.Color := fontStyles[TEXT_STYLE_SELECTED].backColor;
              Canvas.Rectangle(3 + fFontSize.x * (i - 1), 4 + fFontSize.y * line, 4 + fFontSize.x * i, 4 + fFontSize.y * (line + 1));
              Canvas.Font.Color := fontStyles[TEXT_STYLE_SELECTED].textColor;
            end;

          if (fLines[line][i] > Chr(KEY_SPACE)) then
            Canvas.TextOut(5 + fFontSize.x * (i - 1), 4 + fFontSize.y * line, fLines[line][i]);
        end;
    end;
end;

procedure TCodeTextField.RefreshCaretPos;
begin
  fCaretObject.Left := Left + 5 + fCaretPos.x * fFontSize.x;
  fCaretObject.Top := Top + 4 + fCaretPos.y * fFontSize.y;

  // Force show caret
  CodeField.CaretObj.Visible := True;
  BlinkTimerValue := 0;
end;

function TCodeTextField.GetLastDisplayedLine : LongInt;
begin
  Result := fLineDisplayStart + fDisplayLength - 1;
  if (Result > fLines.Count - 1) then
    Result := fLines.Count - 1;
end;

// Procedure to apply different font styles
procedure TCodeTextField.SetTextStyle(style: Byte);
var currentStyle : TFontStyle;
    styleSet     : set of fsBold..fsUnderline;
begin
  if (style in [0..DELPHI_STYLES_COUNT - 1]) then
    currentStyle := fontStyles[style]
  else
    currentStyle := fontStyles[TEXT_STYLE_NONE];

  Canvas.Font.Name := currentStyle.fontName;
  Canvas.Font.Size := currentStyle.fontSize;
  Canvas.Font.Color := currentStyle.textColor;
  Canvas.Brush.Color := currentStyle.backColor;

  if (currentStyle.bold)       then Include(styleSet, fsBold);
  if (currentStyle.italic)     then Include(styleSet, fsItalic);
  if (currentStyle.underlined) then Include(styleSet, fsUnderline);

  Canvas.Font.Style := styleSet;
end;

// Function to get selection length from selStart - selEnd points
function TCodeTextField.GetSelectionLength : LongInt;
var i: LongInt;
begin
  Result := 0;

  for i := fSelStart.y to fSelEnd.y do
    begin
      Inc(Result, Length(fLines[i]));

      if (i = fSelStart.y) then
        Dec(Result, fSelStart.x);
      if (i = fSelEnd.y) then
        Dec(Result, Length(fLines[i]) - fSelEnd.x);
    end;
end;

function TCodeTextField.GetSelectionText : String;
var i, a, b: LongInt;
    t: String;
begin
  Result := '';

  for i := fSelStart.y to fSelEnd.y do
    begin
      t := fLines[i];

      a := 1;
      b := Length(t);
      
      if (i = fSelStart.y) then
        a := fSelStart.x + 1; // Crop left side
      if (i = fSelEnd.y) then
        b := fSelEnd.x; // Crop left side

      Result := Result + Copy(t, a, b - a + 1);

      if (i <> fSelEnd.y) then
        Result := Result + #13#10;
    end;
end;

function TCodeTextField.ComparePositions(p1, p2: TPoint) : Integer;
begin
  Result := 0;
  if (p1.y = p2.y) then
    begin
      if (p1.x > p2.x) then
        Result := 1
      else if (p1.x < p2.x) then
        Result := -1;
    end
  else if (p1.y > p2.y) then
    Result := 1
  else
    Result := -1;
end;

procedure TCodeTextField.RemoveSelection;
var i : LongInt;
    t : String;
begin
  t := Copy(fLines[fSelStart.y], 0, fSelStart.x) + Copy(fLines[fSelEnd.y], fSelEnd.x + 1, Length(fLines[fSelEnd.y]));
  fLines[fSelStart.y] := t;

  for i := 1 to (fSelEnd.y - fSelStart.y) do
    begin
      fLines.Delete(fSelStart.y + 1);
      fLineStyles.Delete(fSelStart.y + 1);
    end;

  fSelEnd := fSelStart;
  fCaretPos := fSelStart;

  RefreshCaretPos;
  OnLineTextChanged(fCaretPos.y);
  RedrawLinesFromCaretPos;
end;

procedure TCodeTextField.CopySelection;
begin
  Clipboard.AsText := GetSelectionText;
end;

procedure TCodeTextField.CutToClipboard;
begin
  CopySelection;
  RemoveSelection;
end;

procedure TCodeTextField.PasteFromClipboard;
var i, n: LongInt;
    s, t: String;
    list: TStringList;
begin
  RemoveSelection;

  s := Clipboard.AsText;
  list := TStringList.Create;

  repeat
    n := Pos(#13#10, s);

    if (n <> 0) then
      begin
        list.Add(Copy(s, 0, n - 1));
        s := Copy(s, n + 2, Length(s));
      end
    else
      begin
        list.Add(s);
        s := '';
      end;

  until (n = 0);

  if (list.Count > 0) then
    begin
      t := Copy(fLines[fCaretPos.y], fCaretPos.x + 1, Length(fLines[fCaretPos.y]));
      s := Copy(fLines[fCaretPos.y], 0, fCaretPos.x) + list[0];
      fLines[fCaretPos.y] := s;

      for i := 1 to list.Count - 1 do
        begin
          fLines.Insert(fCaretPos.y + i, list[i]);
        end;

      s := fLines[fCaretPos.y + (list.Count - 1)] + t;
      fLines[fCaretPos.y + (list.Count - 1)] := s;
    end;

  Refresh;
  RefreshCaretPos;
end;

procedure TCodeTextField.OnHomePressed(shiftPressed: Boolean);
begin
  fCaretPos.x := 0;
  fSelStart := fCaretPos;
  if not shiftPressed then
    fSelEnd := fCaretPos;

  RefreshCaretPos;
end;

procedure TCodeTextField.OnEndPressed(shiftPressed: Boolean);
begin
  fCaretPos.x := Length(fLines[fCaretPos.y]);
  fSelEnd := fCaretPos;
  if not shiftPressed then
    fSelStart := fCaretPos;

  RefreshCaretPos;
end;

procedure TCodeTextField.SetCaretPos(pos: TPoint);
begin
  if (fLines.Count = 0) then
    pos := Point(0, 0)
  else if (pos.y >= fLines.Count) then
    begin
      pos.y := fLines.Count - 1;
      pos.x := Length(fLines[pos.y]);
    end;
  if ((fLines.Count > 0) and (pos.x > Length(fLines[pos.y]))) then
    pos.x := Length(fLines[pos.y]);

  fCaretPos := pos;
  fSelStart := pos;
  fSelEnd := pos;

  RefreshCaretPos;
end;

procedure TCodeTextField.OnTextFieldPress(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i, j: LongInt;
begin
  i := (Y - 4) div fFontSize.y;
  j := X div fFontSize.x;

  SetCaretPos(Point(j, i));
end;

procedure TCodeTextField.LoadText(text: String);
var i, n       : LongInt;
    tempString : String;
begin
  fSelStart := Point(0, 0);
  fSelEnd := fSelStart;
  
  fLines.Clear;
  fLineStyles.Clear;

  if (Length(text) > 0) then
    begin

      repeat
        n := Pos(#13#10, text);

        if (n <> 0) then
          begin
            tempString := Copy(text, 1, n - 1);
            fLines.Add(tempString);

            for i := 1 to Length(tempString) do
              tempString[i] := TextStyle(TEXT_STYLE_NONE);
            fLineStyles.Add(tempString);
            
            text := Copy(text, n + 2, Length(text));
          end
        else
          begin
            fLines.Add(text);

            tempString := text;
            for i := 1 to Length(tempString) do
              tempString[i] := TextStyle(TEXT_STYLE_NONE);
            fLineStyles.Add(tempString);

            text := '';
          end;

      until (n = 0);

    end;

  if (fLines.Count = 0) then
    begin
      fLines.Add(EMPTY_STRING);
      fLineStyles.Add(EMPTY_STRING);
    end;

  fCaretPos := Point(0, 0);
  fSelStart := fCaretPos;
  fSelEnd := fCaretPos;

  // Rebuild code highlight
  for i := 0 to fLines.Count - 1 do
    OnLineTextChanged(i);

  Refresh;
  RefreshCaretPos;
end;

function TCodeTextField.GetText : String;
var i: LongInt;
begin
  Result := '';

  for i := 0 to fLines.Count - 2 do
    Result := Result + fLines[i] + #13#10;

  if (fLines.Count > 0) then
    Result := Result + fLines[fLines.Count - 1];
end;

procedure TCodeTextField.SetStartLine(line: LongInt);
begin
  fLineDisplayStart := line;

  Refresh;
  RefreshCaretPos;
end;

procedure TCodeTextField.SetDisplayLength(len: LongInt);
begin
  fDisplayLength := len;

  Refresh;
  RefreshCaretPos;
end;

function TCodeTextField.GetCharStyle(pos: TPoint) : Byte;
begin
  if ((pos.y >= fLineStyles.Count) or (pos.x > Length(fLineStyles[pos.y]))) then
    Result := TEXT_STYLE_NONE
  else
    Result := Ord(fLineStyles[pos.y][pos.x]);
end;

procedure TCodeTextField.SetWidgetFont(font: TFont);
begin
  fWidgetFont := font;
  Canvas.Font := fWidgetFont;

  fFontSize := Point(
    Canvas.TextWidth('#') + CHAR_SPACING,
    -fWidgetFont.Height + LINE_SPACING
  );
end;

procedure TCodeTextField.Undo;
begin

end;

procedure TCodeTextField.Redo;
begin

end;

procedure TCodeTextField.PushToEditStack(editType: Byte; stringInfo: String; pointInfo: TPoint);
var historyElement: TEditHistoryElementPtr;
begin
  New(historyElement);
  historyElement^.editType := editType;
  historyElement^.text := stringInfo;
  historyElement^.point := pointInfo;

  PushElementToStack(historyElement, fEditStack);
end;

procedure TCodeTextField.ResetLineStyle(line: LongInt);
var i          : LongInt;
    tempString : String;
begin
  if ((line < fLineStyles.Count) and (line < fLines.Count)) then
    begin
      SetLength(tempString, Length(fLines[line]));

      for i := 1 to Length(tempString) do
        tempString[i] := TextStyle(TEXT_STYLE_NONE);

      fLineStyles[line] := tempString;
    end;
end;

procedure TCodeTextField.SetLineStyle(line, _from, _to: LongInt; style: Byte);
var i, len     : LongInt;
    tempString : String;
begin
  len := Length(fLines[line]);

  if (_from < 1) then
    _from := 1;
  if (_to > len) then
    _to := len;

  tempString := fLineStyles[line];

  for i := _from to _to do
    tempString[i] := TextStyle(style);

  fLineStyles[line] := tempString;
end;

procedure TCodeTextField.SetLineStyle(line: LongInt; style: String);
begin
  fLineStyles[line] := style;
end;

procedure TCodeTextField.OnLineTextChanged(line: LongInt);
var lastChar : Char;
begin
  lastChar := #0;
  if ((line in [0..fLineStyles.Count - 1]) and (Length(fLineStyles[line]) > 0)) then
    lastChar := fLineStyles[line][Length(fLineStyles[line])];

  ResetLineStyle(line);

  if (line in [0..fLineStyles.Count - 1]) then
    begin
      ProcessStrings(line);
      ProcessKeywords(line);
      ProcessDigits(line);

      if (
        (Length(fLineStyles[line]) = 0)
          or
        (fLineStyles[line][Length(fLineStyles[line])] = TextStyle(TEXT_STYLE_MULTILINE_COMMENT))
          or
        (
          (lastChar = TextStyle(TEXT_STYLE_MULTILINE_COMMENT))
            and
          (lastChar <> fLineStyles[line][Length(fLineStyles[line])])
        )
      ) then
        OnLineTextChanged(line + 1);
    end;

  RedrawLine(line);
end;

procedure TCodeTextField.RefreshLineStyles(_from, _to: LongInt);
var i : LongInt;
begin
  for i := _from to _to do
    OnLineTextChanged(i);
end;

function TCodeTextField.IsPreviousLineMultilineComment(line: LongInt) : Boolean;
begin
  Result := False;

  if (line in [1..fLines.Count - 1]) then
    begin
      Dec(line);

      if (Length(fLineStyles[line]) > 0) then
        Result := (
          (fLineStyles[line][Length(fLineStyles[line])] = TextStyle(TEXT_STYLE_MULTILINE_COMMENT))
            and
          (fLines[line][Length(fLines[line])] <> DELPHI_MULTILINE_CLOSER)
        )
      else
        Result := IsPreviousLineMultilineComment(line);
    end;
end;

procedure TCodeTextField.AppendChar(c: Char);
var tempString : String;
    len, i     : LongInt;
begin
  if (fCaretPos.y in [0..fLines.Count - 1]) then
    begin
      // Expand line
      tempString := fLines[fCaretPos.y];
      SetLength(tempString, Length(tempString) + 1);

      // Process 'out of range' situation
      len := Length(fLines[fCaretPos.y]);
      if (fCaretPos.x > len) then
        fCaretPos.x := len;

      // Shift text to the right
      for i := Length(tempString) downto fCaretPos.x + 1 do
        tempString[i] := tempString[i - 1];

      Inc(fCaretPos.x);
      tempString[fCaretPos.x] := c;
      fLines[fCaretPos.y] := tempString;

      // Call line style rebuild
      OnLineTextChanged(fCaretPos.y);
    end;
end;

procedure TCodeTextField.ProcessBackSpace;
var tempString : String;
    i          : LongInt;
begin
  if (GetSelectionLength > 0) then
    RemoveSelection
  else if (fCaretPos.x > 0) then
    begin
      Dec(fCaretPos.x);

      tempString := fLines[fCaretPos.y];

      // Shift characters to the left
      for i := fCaretPos.x + 1 to Length(tempString) - 1 do
        tempString[i] := tempString[i + 1];

      // Update string
      SetLength(tempString, Length(tempString) - 1);
      fLines[fCaretPos.y] := tempString;

      // Rebuild line style
      OnLineTextChanged(fCaretPos.y);
    end
  else if (fCaretPos.y > 0) then
    begin
      fCaretPos.x := Length(fLines[fCaretPos.y - 1]);

      tempString := fLines[fCaretPos.y - 1] + fLines[fCaretPos.y];
      fLines[fCaretPos.y - 1] := tempString;

      // Remove line from lists
      fLines.Delete(fCaretPos.y);
      fLineStyles.Delete(fCaretPos.y);

      Dec(fCaretPos.y);

      // Rebuild line style
      OnLineTextChanged(fCaretPos.y);

      RedrawLinesFromCaretPos;
    end;

  ResetSelection;
end;

procedure TCodeTextField.ResetSelection;
begin
  fSelStart := fCaretPos;
  fSelEnd := fCaretPos;
end;

procedure TCodeTextField.ProcessStrings(line: LongInt);
var currentState : Byte;
    i            : LongInt;
    tempString   : String;
begin
  currentState := TEXT_STYLE_NONE;
  if IsPreviousLineMultilineComment(line) then
    currentState := TEXT_STYLE_MULTILINE_COMMENT;
  tempString := fLineStyles[line];

  for i := 1 to Length(fLines[line]) do
    begin
      if (currentState = TEXT_STYLE_NONE) then
        begin
          if (fLines[line][i] = DELPHI_MULTILINE_OPENER) then
            currentState := TEXT_STYLE_MULTILINE_COMMENT
          else if (fLines[line][i] = DELPHI_STRING_BORDER) then
            currentState := TEXT_STYLE_STRING
          else if ((i < Length(fLines[line])) and (Copy(fLines[line], i, 2) = DELPHI_COMMENT_BEGINNER)) then
            currentState := TEXT_STYLE_COMMENT;

          tempString[i] := TextStyle(currentState);
        end
      else
        begin
          tempString[i] := TextStyle(currentState);

          if (currentState = TEXT_STYLE_STRING) then
            if (fLines[line][i] = DELPHI_STRING_BORDER) then
              currentState := TEXT_STYLE_NONE;
          if (currentState = TEXT_STYLE_MULTILINE_COMMENT) then
            if (fLines[line][i] = DELPHI_MULTILINE_CLOSER) then
              currentState := TEXT_STYLE_NONE;
        end;
    end;

  SetLineStyle(line, tempString);
end;

procedure TCodeTextField.ProcessKeywords(line: LongInt);
var keywordAllowed : Boolean;
    c              : Char;
    currentList    : TUserListPtr;
    currentElement : TUserListElementPtr;
    i, j           : LongInt;
    breakerElement : TUserListElementPtr;
begin
  i := 1;

  while (i <= Length(fLines[line])) do
    begin
      keywordAllowed := (i = 1) or ((not IsSymbol(fLines[line][i - 1]) and (not IsDigit(fLines[line][i - 1]))));
      keywordAllowed := keywordAllowed and (fLineStyles[line][i] = TextStyle(TEXT_STYLE_NONE));

      if (IsSymbol(fLines[line][i]) and keywordAllowed) then
        begin
          c := UpCase(fLines[line][i]);

          currentList := keywordsList;
          currentElement := FindElement(c, currentList);

          if Assigned(currentElement) then
            begin
              j := 1;

              while Assigned(currentElement) do
                begin
                  currentList := currentElement^.childList;

                  breakerElement := FindElement(KEYWORD_BREAKER, currentList);
                  if (
                    Assigned(breakerElement) and
                    (not IsSymbol(fLines[line][i + j])) and
                    (not IsDigit(fLines[line][i + j]))
                  ) then
                    begin
                      SetLineStyle(line, i, i + j - 1, TEXT_STYLE_KEYWORD);
                      Inc(i, j - 1);

                      break;
                    end
                  else
                    begin
                      c := UpCase(fLines[line][i + j]);

                      currentElement := FindElement(c, currentList);

                      if Assigned(currentElement) then
                        Inc(j)
                      else
                        continue;
                    end;
                end;
            end;
        end;

        Inc(i);
    end;
end;

procedure TCodeTextField.ProcessDigits(line: LongInt);
var i          : LongInt;
    tempString : String;
begin
  tempString := fLineStyles[line];

  for i := 1 to Length(fLines[line]) do
    begin
      if (tempString[i] = TextStyle(TEXT_STYLE_NONE)) then
        if IsDigit(fLines[line][i]) then
          if ((i = 1) or (not IsSymbol(fLines[line][i - 1]))) then
            if ((i = Length(fLines[line])) or (not IsSymbol(fLines[line][i + 1]))) then
              tempString[i] := TextStyle(TEXT_STYLE_NUMBER);
    end;

  SetLineStyle(line, tempString);
end;

procedure TCodeTextField.ProcessEnter;
var lineNew   : String;
    lineOld   : String;
    lineStyle : String;
begin
  lineNew := Copy(fLines[fCaretPos.y], fCaretPos.x + 1, Length(fLines[fCaretPos.y]));
  lineOld := Copy(fLines[fCaretPos.y], 0, fCaretPos.x);

  fLines[fCaretPos.y] := lineOld;
  SetLength(lineStyle, Length(lineNew));

  OnLineTextChanged(fCaretPos.y);
  
  if (fCaretPos.y = fLines.Count - 1) then
    begin
      // Add to the end
      fLines.Add(lineNew);
      fLineStyles.Add(lineStyle);
    end
  else
    begin
      // Insert string into the list
      fLines.Insert(fCaretPos.y + 1, lineNew);
      fLineStyles.Insert(fCaretPos.y + 1, lineStyle);
    end;

  OnLineTextChanged(fCaretPos.y + 1);

  // Refresh line styles
  RedrawLinesFromCaretPos;

  // Update caret pos
  fCaretPos.x := 0;
  Inc(fCaretPos.y);
end;

function TCodeTextField.IsCharSelected(pos: TPoint) : Boolean;
var posStart, posEnd : TPoint;
begin
  posStart := Point(fSelStart.x, fSelStart.y);
  posEnd := Point(fSelEnd.x + 1, fSelEnd.y);

  Result := ((comparePositions(pos, posStart) > 0) and (comparePositions(pos, posEnd) < 0));
end;

function TCodeTextField.GetFormattedCode : String;
var i, j    : LongInt;
    isSpace : Boolean;
begin
  Result := EMPTY_STRING;

  for i := 0 to fLines.Count - 1 do
    begin
      isSpace := True;

      for j := 1 to Length(fLines[i]) do
        begin
          if (
            (
              (Ord(fLines[i][j]) = KEY_SPACE)
                and
              (not isSpace)
            )
              or
            (Ord(fLines[i][j]) >= KEY_SPACE)
          ) then
            Result := Result + fLines[i][j];

          isSpace := Ord(fLines[i][j]) = KEY_SPACE;
        end;

      if (Length(fLines[i]) > 0) then
        Result := Result + #13#10;
    end;
end;


constructor TTextCaret.Create(Control: TControl);
begin
  inherited Create(Control);

  InitCaret;
end;

procedure TTextCaret.InitCaret;
begin
  Width := 1;
  Height := 22;
  SetHeight(Height);

  Cursor := crIBeam;
end;

procedure TTextCaret.SetHeight(height: Word);
begin
  fRealHeight := height;

  Canvas.Brush.Color := ProgramForm.Color;
  Canvas.Rectangle(0, 0, Width, Height);
end;
