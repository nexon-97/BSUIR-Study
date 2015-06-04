procedure FitTextFieldIntoWindow;
begin
  ProgramForm.FilenamesTab.Left := 0;
  ProgramForm.FilenamesTab.Top := TOOLBOX_HEIGHT;
  ProgramForm.FilenamesTab.Width := ProgramForm.ClientWidth;

  ProgramForm.ToolsPanel.Width := ProgramForm.ClientWidth + 4;

  CodeField.Left := TEXT_FIELD_MARGIN + 50;
  CodeField.Top := ProgramForm.FilenamesTab.Height + TOOLBOX_HEIGHT + TEXT_FIELD_MARGIN;
  CodeField.WidgetSize := Point(
      ProgramForm.ClientWidth - TEXT_FIELD_MARGIN * 2 - 70,
      ProgramForm.ClientHeight - ProgramForm.FilenamesTab.Height - TOOLBOX_HEIGHT - TEXT_FIELD_MARGIN * 2 - 20
  );

  TextLinesCounter.Left := TEXT_FIELD_MARGIN;
  TextLinesCounter.Top := ProgramForm.FilenamesTab.Height + TOOLBOX_HEIGHT + TEXT_FIELD_MARGIN;
  TextLinesCounter.LinesCount := CodeField.WidgetSize.y div (-CodeFont.Height + LINE_SPACING);
  TextLinesCounter.TempHeight := CodeField.WidgetSize.y;

  CodeField.DisplayLength := TextLinesCounter.LinesCount;

  ProgramForm.CodeScrollVertical.Left := CodeField.Left + CodeField.WidgetSize.x + 4;
  ProgramForm.CodeScrollVertical.Top := CodeField.Top + 1;
  ProgramForm.CodeScrollVertical.Height := CodeField.WidgetSize.y - 2;
  ProgramForm.CodeScrollHorizontal.Left := CodeField.Left + 1;
  ProgramForm.CodeScrollHorizontal.Top := CodeField.Top + CodeField.WidgetSize.y + 4;
  ProgramForm.CodeScrollHorizontal.Width := CodeField.WidgetSize.x - 2;

  ProgramForm.CodeScrollVertical.Max := CodeField.Lines.Count - LongInt(TextLinesCounter.LinesCount);

  RefreshLinesDisplay;
  CodeField.RefreshCaretPos;
end;

function IsSymbol(c: Char) : Boolean;
begin
  Result := (c in ['A'..'Z', '_', 'a'..'z']);
end;

function IsSign(c: Char) : Boolean;
begin
  Result := (c in ['!'..'/', ':'..'@', '['..'^', #96, '{'..'~']);
end;

function IsDigit(c: Char) : Boolean;
begin
  Result := (c in ['0'..'9']);
end;

function IsIdentifier(key: String) : Boolean;
var i : LongInt;
begin
  Result := not IsKeyword(1, key);

  if ((Length(key) = 0) or ((Length(key) > 0) and (not IsSymbol(key[1])))) then
    Result := False;

  if Result then
    for i := 2 to Length(key) do
      begin
        if (not (IsSymbol(key[i]) or IsDigit(key[i]))) then
          begin
            Result := False;
            break;
          end;
      end;
end;

function IsCorrectTypeName(const key: String) : Boolean;
begin
  Result := Length(key) > 0;

  if Result then
    Result := IsIdentifier(key) or
              ((key[1] = '^') and IsIdentifier(Copy(key, 2, Length(key) - 1))) or
              (UpperCase(key) = 'ARRAY');
end;

function IsKeyword(pos: LongInt; str: String) : Boolean;
var c              : Char;
    i              : LongInt;
    currentList    : TUserListPtr;
    currentElement : TUserListElementPtr;
    breakerElement : TUserListElementPtr;
begin
  Result := False;

  currentList := keywordsList;

  for i := 1 to Length(str) do
    begin
      c := UpCase(str[i]);

      currentElement := FindElement(c, currentList);
      
      if not Assigned(currentElement) then
        begin
          currentList := nil;
          break;
        end
      else
        currentList := currentElement^.childList;
    end;

  breakerElement := FindElement(KEYWORD_BREAKER, currentList);
  if Assigned(breakerElement) then
    Result := True;
end;

procedure LoadKeywords;
var f : TextFile;
    i : Word;
begin
  AssignFile(f, DELPHI_KEYWORDS_FILE);
  Reset(f);

  SetLength(keywords, 256);
  i := 0;
  while not EoF(f) do
    begin
      ReadLn(f, keywords[i]);
      Inc(i);
    end;
  SetLength(keywords, i);

  CloseFile(f);

  BuildKeywordsTree;
end;

procedure InitFileManager;
begin
  // Init file manager
  FilesManager := TNexonFileManager.Create;
  // Load test code template
  FilesManager.AddFile(SAMPLE_FILE_NAME, LoadFileToStr(SAMPLE_FILE_NAME));
  FilesManager.ActiveView := 0;

  UpdateFilenamesTab;
  UpdateActiveTextField;
end;

procedure InitOpenFileDialog;
begin
  // Init open file dialog
  OpenFileDlg := TOpenDialog.Create(ProgramForm);
  // Make start point at program execution directory
  OpenFileDlg.InitialDir := GetCurrentDir;
  // Setting up file filters
  OpenFileDlg.Filter := OPEN_FILE_FILTER;
  OpenFileDlg.FilterIndex := 2;

  ProgramForm.SaveFileDialog.Filter := OPEN_FILE_FILTER;
  ProgramForm.SaveFileDialog.FilterIndex := 2;
  ProgramForm.SaveFileDialog.InitialDir := GetCurrentDir;
end;

procedure InitLinesCounter;
begin
  { CREATE LINES COUNTER }
  TextLinesCounter := TLinesCounter.Create(ProgramForm);
  TextLinesCounter.Parent := ProgramForm;
  TextLinesCounter.Visible := True;
  TextLinesCounter.Width := 50;
  TextLinesCounter.Height := 1500; // Big height to avoid redraw error... [try to fix later]
end;

function LoadFileToStr(const fileName: TFileName): String;
var FileStream: TFileStream;
    FSSize: LongInt;
begin
  Result := EMPTY_STRING;

  if FileExists(fileName) then
    begin
      FileStream := TFileStream.Create(fileName, fmOpenRead);
      FSSize := FileStream.Size;

      SetLength(Result, FSSize);
      FileStream.Read(Result[1], FSSize);

      FileStream.Free;
    end;
end;

procedure SaveTextToFile(const fileName: TFileName; const contents: String);
var tempFile: TextFile;
begin
  AssignFile(tempFile, fileName);
  Rewrite(tempFile);

  Write(tempFile, contents);

  CloseFile(tempFile);
end;

procedure RefreshLinesDisplay;
begin
  TextLinesCounter.RedrawWidget;
end;

procedure UpdateActiveTextField;
begin
  CodeField.LoadText(FilesManager.GetActiveFileContents);
  
  ProgramForm.CodeScrollVertical.Position := 0;
  ProgramForm.CodeScrollVertical.Min := 0;
end;

procedure UpdateFilenamesTab;
var i: Word;
begin
  // Fill file tabs from manager info
  with ProgramForm do
  begin
    FilenamesTab.Tabs.Clear;
    for i := 0 to FilesManager.GetFilesCount - 1 do
      FilenamesTab.Tabs.Add(' ' + FilesManager.GetFileName(i) + ' ');
    FilenamesTab.TabIndex := FilesManager.ActiveView;
  end;
end;

procedure CloseCurrentFile;
begin
  // Close current file
  FilesManager.RemoveCurrentFile;
end;

procedure Cleanup;
begin
  OpenFileDlg.Free;
end;


function FindElement(data: Char; list: TUserListPtr) : TUserListElementPtr;
var listElement: TUserListElementPtr;
begin
  Result := nil;

  if Assigned(list) then
    begin
      // Search for letter
      listElement := list^.first;

      while (listElement <> nil) do
        begin
          if (listElement^.letter = data) then
            begin
              Result := listElement;
              break;
            end;

          listElement := listElement^.next;
        end;
    end;
end;

procedure AddElement(data: Char; list: TUserListPtr);
var listElement: TUserListElementPtr;
begin
  // Create list element
  New(listElement);
  listElement^.letter := data;
  listElement^.childList := nil;
  listElement^.next := nil;

  if (list^.last <> nil) then
    begin
      // Push back element
      list^.last^.next := listElement;
      list^.last := listElement;
    end
  else
    begin
      // Insert first element
      list^.first := listElement;
      list^.last := list^.first;
    end;
end;

procedure BuildKeywordsTree;
var currentList: TUserListPtr;
    newList: TUserListPtr;
    currentElement: TUserListElementPtr;
    i, j: LongInt;
    c: Char;
    t: String;
begin
  keywordsList := CreateUserList;

  for i := 0 to High(keywords) do
    begin
      currentList := keywordsList;
      t := keywords[i] + KEYWORD_BREAKER;

      for j := 1 to Length(t) do
        begin
          c := UpCase(t[j]);
          currentElement := FindElement(c, currentList);

          if (currentElement <> nil) then
            currentList := currentElement^.childList
          else
            begin
              AddElement(c, currentList);
              newList := CreateUserList;
              // Append new list to the element
              currentList^.last^.childList := newList;

              currentList := newList;
            end;
        end;
    end;
end;

function CreateUserList : TUserListPtr;
begin
  New(Result);

  Result^.first := nil;
  Result^.last := nil;
end;

function CreateStack : TStackPtr;
begin
  New(Result);

  Result^.top := nil;
end;

procedure PushElementToStack(data: TEditHistoryElementPtr; stack: TStackPtr);
var element : TStackElementPtr;
begin
  New(element);

  element^.data := data;

  element^.below := stack^.top;
  element^.below^.above := element;
  element^.above := nil;

  stack^.top := element;
end;

function PopElementFromStack(stack: TStackPtr) : TEditHistoryElementPtr;
begin
  Result := nil;

  if Assigned(stack^.top) then
    begin
      Result := stack^.top^.data;
      stack^.top := stack^.top^.below;
    end
  else
    begin
      Result^.editType := HISTORY_EDITMODE_NONE;
    end;
end;

procedure MoveToStackTop(stack: TStackPtr);
begin
  if Assigned(stack^.top^.above) then
    stack^.top := stack^.top^.above;
end;

function TextStyle(code: Byte) : Char;
begin
  Result := Chr(code);
end;

procedure InitCodeStyles;
var configFile : TextFile;
    i          : LongInt;
    a, b, c    : Byte;
begin
  SetLength(fontStyles, DELPHI_STYLES_COUNT);

  if FileExists(CODE_VIEWER_STYLE_FILE) then
    begin
      // Load configs from file
      AssignFile(configFile, CODE_VIEWER_STYLE_FILE);
      Reset(configFile);

      for i := 0 to DELPHI_STYLES_COUNT - 1 do
        begin
          ReadLn(configFile, fontStyles[i].fontName);
          ReadLn(configFile, fontStyles[i].fontSize);
          ReadLn(configFile, a);
          ReadLn(configFile, b);
          ReadLn(configFile, c);
          ReadLn(configFile, fontStyles[i].textColor);
          ReadLn(configFile, fontStyles[i].backColor);
          ReadLn(configFile);

          fontStyles[i].bold := (a <> 0);
          fontStyles[i].italic := (b <> 0);
          fontStyles[i].underlined := (c <> 0);
        end;

      CloseFile(configFile);
    end
  else
    begin
      // Load default options
      fontStyles[TEXT_STYLE_NONE].fontName := DEFAULT_FONT_NAME;
      fontStyles[TEXT_STYLE_NONE].fontSize := DEFAULT_FONT_SIZE;
      fontStyles[TEXT_STYLE_NONE].bold := False;
      fontStyles[TEXT_STYLE_NONE].italic := False;
      fontStyles[TEXT_STYLE_NONE].underlined := False;
      fontStyles[TEXT_STYLE_NONE].textColor := clBlack;
      fontStyles[TEXT_STYLE_NONE].backColor := clWhite;

      fontStyles[TEXT_STYLE_SELECTED].fontName := DEFAULT_FONT_NAME;
      fontStyles[TEXT_STYLE_SELECTED].fontSize := DEFAULT_FONT_SIZE;
      fontStyles[TEXT_STYLE_SELECTED].bold := True;
      fontStyles[TEXT_STYLE_SELECTED].italic := False;
      fontStyles[TEXT_STYLE_SELECTED].underlined := False;
      fontStyles[TEXT_STYLE_SELECTED].textColor := clWhite;
      fontStyles[TEXT_STYLE_SELECTED].backColor := $FF9400;

      fontStyles[TEXT_STYLE_COMMENT].fontName := DEFAULT_FONT_NAME;
      fontStyles[TEXT_STYLE_COMMENT].fontSize := DEFAULT_FONT_SIZE;
      fontStyles[TEXT_STYLE_COMMENT].bold := False;
      fontStyles[TEXT_STYLE_COMMENT].italic := False;
      fontStyles[TEXT_STYLE_COMMENT].underlined := False;
      fontStyles[TEXT_STYLE_COMMENT].textColor := clGreen;
      fontStyles[TEXT_STYLE_COMMENT].backColor := clWhite;

      fontStyles[TEXT_STYLE_STRING].fontName := DEFAULT_FONT_NAME;
      fontStyles[TEXT_STYLE_STRING].fontSize := DEFAULT_FONT_SIZE;
      fontStyles[TEXT_STYLE_STRING].bold := False;
      fontStyles[TEXT_STYLE_STRING].italic := False;
      fontStyles[TEXT_STYLE_STRING].underlined := False;
      fontStyles[TEXT_STYLE_STRING].textColor := clRed;
      fontStyles[TEXT_STYLE_STRING].backColor := clWhite;

      fontStyles[TEXT_STYLE_NUMBER].fontName := DEFAULT_FONT_NAME;
      fontStyles[TEXT_STYLE_NUMBER].fontSize := DEFAULT_FONT_SIZE;
      fontStyles[TEXT_STYLE_NUMBER].bold := True;
      fontStyles[TEXT_STYLE_NUMBER].italic := False;
      fontStyles[TEXT_STYLE_NUMBER].underlined := False;
      fontStyles[TEXT_STYLE_NUMBER].textColor := $006AFF;
      fontStyles[TEXT_STYLE_NUMBER].backColor := clWhite;

      fontStyles[TEXT_STYLE_MULTILINE_COMMENT].fontName := DEFAULT_FONT_NAME;
      fontStyles[TEXT_STYLE_MULTILINE_COMMENT].fontSize := DEFAULT_FONT_SIZE;
      fontStyles[TEXT_STYLE_MULTILINE_COMMENT].bold := False;
      fontStyles[TEXT_STYLE_MULTILINE_COMMENT].italic := False;
      fontStyles[TEXT_STYLE_MULTILINE_COMMENT].underlined := False;
      fontStyles[TEXT_STYLE_MULTILINE_COMMENT].textColor := $7F4A00;
      fontStyles[TEXT_STYLE_MULTILINE_COMMENT].backColor := clWhite;

      fontStyles[TEXT_STYLE_KEYWORD].fontName := DEFAULT_FONT_NAME;
      fontStyles[TEXT_STYLE_KEYWORD].fontSize := DEFAULT_FONT_SIZE;
      fontStyles[TEXT_STYLE_KEYWORD].bold := True;
      fontStyles[TEXT_STYLE_KEYWORD].italic := False;
      fontStyles[TEXT_STYLE_KEYWORD].underlined := False;
      fontStyles[TEXT_STYLE_KEYWORD].textColor := clBlue;
      fontStyles[TEXT_STYLE_KEYWORD].backColor := clWhite;
    end;
end;

procedure UpdateCodeVerticalScrollPos(pos: LongInt);
begin
  VerticalScrollChange := False;

  ProgramForm.CodeScrollVertical.Position := pos;
  TextLinesCounter.StartLine := ProgramForm.CodeScrollVertical.Position;

  VerticalScrollChange := True;
end;

procedure UpdateCodeVerticalScrollRange(range: LongInt);
begin
  VerticalScrollChange := False;

  ProgramForm.CodeScrollVertical.Max := range;

  VerticalScrollChange := True;
end;

procedure InvertString(var src: String);
var i : LongInt;
    t : Char;
begin
  for i := 0 to (Length(src) - 1) div 2 do
    begin
      t := src[i + 1];
      src[i + 1] := src[Length(src) - i];
      src[Length(src) - i] := t;
    end;
end;

function IsNumber(const src: String; var convertedNumber: LongInt) : Boolean;
var i          : LongInt;
    tempString : String;
begin
  Result := Length(src) > 0;
  tempString := src;

  if Result then
    if (src[1] = '-') then
      begin
        tempString := '-';

        // Skip trash between '-' and number beginning
        for i := 2 to Length(src) do
          if (Ord(src[i]) > 32) then
            begin
              tempString := tempString + Copy(src, i, Length(src));
              break;
            end;
      end;

  if Result then
    for i := 1 to Length(tempString) do
      if not (IsDigit(tempString[i]) or ((i = 1) and (tempString[1] = '-'))) then
        begin
          Result := False;
          break;
        end;

  if Result then
    convertedNumber := StrToInt(tempString);
end;

function IsModuleName(const src: String) : Boolean;
var i       : LongInt;
    modules : TStringList;
begin
  modules := SplitBySubString(src, '.');

  Result := True;
  for i := 0 to modules.Count - 1 do
    if not IsIdentifier(modules[i]) then
      begin
        Result := False;
        break;
      end;
end;

function IsDereference(const src: String) : Boolean;
begin
  Result := (Length(src) > 0);

  if Result then
    begin
      if ((not IsIdentifier(src)) and (Length(src) > 1)) then
        begin
          Result := IsIdentifier(Trim(Copy(src, 1, Length(src) - 1))) and (src[Length(src)] = '^');
        end
      else
        Result := True;
    end;
end;

function IsVariable(const src: String) : Boolean;
var i      : LongInt;
    fields : TStringList;
begin
  fields := SplitBySubString(src, '.');

  Result := True;
  for i := 0 to fields.Count - 1 do
    if not IsIdentifier(fields[i]) then
      if not ((i = fields.Count - 1) and (IsDereference(fields[i]))) then
        begin
          Result := False;
          break;
        end;
end;

function IsBinaryOperator(const src: String) : Boolean;
begin
  Result := (src = 'div') or (src = 'mod') or (src = '*')   or
            (src = '/')   or (src = 'and') or (src = 'or')  or
            (src = 'xor') or (src = 'shl') or (src = 'shr') or
            (src = '<')   or (src = '>')   or (src = '<>')  or
            (src = '<=')  or (src = '>=')  or (src = '=');
end;

function IsPrefixOperator(const src: String) : Boolean;
begin
  Result := (src = '+') or (src = '-') or (src = 'not');
end;

function IsOperator(const src: String) : Boolean;
begin
  Result := IsPrefixOperator(src) or IsBinaryOperator(src);
end;

function IsCorrectStatement(const src: String) : Boolean;
var statements     : TStringList;
    srcCopy        : String;
    i, f           : LongInt;
    braceState     : LongInt;
    quadBraceState : LongInt;
    lastCrop       : LongInt;
    prevOperand    : Boolean;
begin
  srcCopy := EMPTY_STRING;

  Result := False;
  if (Length(src) > 0) then
    begin
      srcCopy := src[1];
      // Get rid from waste
      for i := 2 to Length(src) do
        if not ((src[i] = ' ') and (src[i - 1] = ' ')) then
          srcCopy := srcCopy + src[i];

      // Format string
      statements := TStringList.Create;
      braceState := 0;
      quadBraceState := 0;
      lastCrop := 1;
      Result := True;
      for i := 1 to Length(srcCopy) do
        begin
          if ((srcCopy[i] = ' ') and (braceState = 0) and (quadBraceState = 0)) then
            begin
              if (i <> lastCrop) then
                statements.Add(Copy(srcCopy, lastCrop, i - lastCrop));
              lastCrop := i + 1;
            end
          else if ((srcCopy[i] in ['+', '-', '*', '/']) and (braceState = 0) and (quadBraceState = 0)) then
            begin
              statements.Add(srcCopy[i]);
              lastCrop := i + 1;
            end
          else if (srcCopy[i] = '[') then
            Inc(quadBraceState)
          else if (srcCopy[i] = ']') then
            begin
              Dec(quadBraceState);
              
              if (quadBraceState < 0) then
                begin
                  Result := False;
                  break;
                end;
            end
          else if (srcCopy[i] = '(') then
            Inc(braceState)
          else if (srcCopy[i] = ')') then
            begin
              Dec(braceState);
              
              if (braceState < 0) then
                begin
                  Result := False;
                  break;
                end;
            end;
        end;
      statements.Add(Copy(srcCopy, lastCrop, Length(srcCopy)));

      // Check operators order errors
      prevOperand := False;
      if Result then
        for i := 0 to statements.Count - 1 do
          begin
            if (IsBinaryOperator(statements[i])) then
              begin
                if (not prevOperand) then
                  begin
                    Result := False;
                    break;
                  end;

                prevOperand := False;
              end
            else if IsPrefixOperator(statements[i]) then
              begin
                prevOperand := False;
              end
            else
              begin
                if prevOperand then
                  begin
                    Result := False;
                    break;
                  end;
                  
                prevOperand := True;
              end;
              
            srcCopy := statements[i];
            srcCopy := EMPTY_STRING;
          end;

      if Result then
        for i := 0 to statements.Count - 1 do
          begin
            if not (
              IsArrayElementCall(statements[i]) or
              IsNumber(statements[i], f) or
              IsBinaryOperator(statements[i]) or
              IsOperator(statements[i]) or
              IsProcedureCall(statements[i])
            ) then
              begin
                Result := False;
                break;
              end;
          end;
    end;
end;

function IsArrayElementCall(const src: String) : Boolean;
var braceLeft      : LongInt;
    braceRight     : LongInt;
    offset         : LongInt;
    lValue         : String;
    statementParts : TStringList;
begin
  offset := 1;
  statementParts := TStringList.Create;

  repeat
    braceLeft := PosEx('[', src, offset);
    braceRight := PosEx(']', src, offset);

    if ((braceLeft > 0) and (braceRight > 0) and (braceLeft < braceRight)) then
      begin
        if (offset = 1) then
          lValue := Trim(Copy(src, offset, braceLeft - 1));

        statementParts.Add(Trim(Copy(src, braceLeft + 1, braceRight - braceLeft - 1)));
        offset := braceRight + 1;
      end
    else if not ((braceLeft = 0) and (braceRight = 0)) then
      Result := False;

  until (braceLeft = 0) or (braceRight = 0);
end;

function IsProcedureCall(const src: String) : Boolean;
var braceLeft     : LongInt;
    braceRight    : LongInt;
    paramsSection : String;
begin
  Result := Length(src) > 0;

  if Result then
    begin
      Result := IsIdentifier(src) or IsVariable(src);

      if not Result then
        begin
          braceLeft := Pos('(', src);
          braceRight := Length(src) - (Pos(')', ReverseString(src)) - 1);

          if (braceLeft > 0) and (braceRight > 0) then
            begin
              paramsSection := Trim(Copy(src, braceLeft, braceRight - braceLeft + 1));
              Result := True;
            end;
        end;
    end;
end;
