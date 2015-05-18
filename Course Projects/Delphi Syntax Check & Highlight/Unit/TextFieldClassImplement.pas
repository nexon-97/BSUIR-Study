// ======================================
// ======= CLASS TLinesCounter ==========
// ======================================
constructor TLinesCounter.Create(Control: TControl);
begin
	inherited Create(Control);

  InitLinesCounter;
end;

procedure TLinesCounter.InitLinesCounter;
begin
  fLineStart := 1;
  fLinesCount := 1;
end;

procedure TLinesCounter.SetLinesCount(value: LongWord);
begin
  fLinesCount := value;
end;

procedure TLinesCounter.SetStartLine(value: LongWord);
begin
  fLineStart := value;
end;

procedure TLinesCounter.RedrawWidget;
var i: LongWord;
begin
  Canvas.Pen.Color := ProgramForm.Color;
  Canvas.Brush.Color := ProgramForm.Color;
  Canvas.Rectangle(0, 0, Width, Height);
  Canvas.Brush.Color := $FFC9AD;
  Canvas.Rectangle(0, 0, Width, TempHeight);

  Canvas.Font := CodeFont;
  Canvas.Font.Style := [fsBold];

  for i := 0 to fLinesCount - 1 do
    Canvas.TextOut(5, 4 + i * (-CodeFont.Height + LINE_SPACING), IntToStr(i + fLineStart));
end;


// ======================================
// ===== CLASS TNexonFileManager ========
// ======================================

constructor TNexonFileManager.Create;
begin
  InitManager;
end;

destructor TNexonFileManager.Destroy;
begin
  fFilesList.Free;
  fFileContents.Free;
end;

procedure TNexonFileManager.InitManager;
begin
  fFilesList := TStringList.Create;
  fFileContents := TStringList.Create;
end;

procedure TNexonFileManager.AddFile(filename, contents: String);
begin
  fFilesList.Add(filename);
  fFileContents.Add(contents);
end;

function TNexonFileManager.GetFilesCount: Word;
begin
  Result := fFilesList.Count;
end;

function TNexonFileManager.GetFileName(index: Word): String;
begin
  Result := fFilesList[index];
end;

function TNexonFileManager.GetFileContents(index: Word): String;
begin
  Result := fFileContents[index];
end;

function TNexonFileManager.GetActiveFileName: String;
begin
  Result := fFilesList[fActiveView];
end;

function TNexonFileManager.GetActiveFileContents: String;
begin
  Result := fFileContents[fActiveView];
end;

procedure TNexonFileManager.SetActiveView(view: Word);
begin
  fActiveView := view;
end;

procedure TNexonFileManager.RemoveCurrentFile;
begin
  FilenamesTabCanChange := False;

  fFilesList.Delete(fActiveView);
  fFileContents.Delete(fActiveView);
  if (fFilesList.Count = 0) then
    begin
      AddFile(DEFAULT_NEWFILE_NAME, EMPTY_STRING);
      fActiveView := 0;
    end
  else
    Dec(fActiveView);

  UpdateFilenamesTab;
  UpdateActiveTextField;

  FilenamesTabCanChange := True;
end;

procedure TNexonFileManager.SaveActiveFile;
begin
  SaveTextToFile(GetActiveFileName, GetActiveFileContents);
end;

procedure TNexonFileManager.SaveActiveFileTo(path: String);
begin
  SaveTextToFile(path, GetActiveFileContents);
end;

procedure TNexonFileManager.UpdateActiveFileContents;
begin
  fFileContents[fActiveView] := CodeField.GetText;
end;

procedure TNexonFileManager.SetFileContents(filename, text: String);
begin

end;
