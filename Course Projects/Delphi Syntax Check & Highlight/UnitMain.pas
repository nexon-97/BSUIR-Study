unit UnitMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, Tabs, ComCtrls, ExtCtrls, RichEdit, ClipBrd,
  Buttons;

{$Include Unit\TextFieldClass}
{$Include TCodeTextField}

type
  TProgramForm = class(TForm)
    MainMenu: TMainMenu;
    FileMenu: TMenuItem;
    HelpBtn: TMenuItem;
    NewMenuBtn: TMenuItem;
    Open: TMenuItem;
    Save: TMenuItem;
    SaveAs: TMenuItem;
    CloseBtn: TMenuItem;
    AboutMenuBtn: TMenuItem;
    EditMenu: TMenuItem;
    CopyBtn: TMenuItem;
    CutBtn: TMenuItem;
    Paste: TMenuItem;
    DeleteBtn: TMenuItem;
    SelectAll: TMenuItem;
    Settings: TMenuItem;
    Preferences: TMenuItem;
    Style: TMenuItem;
    ExitBtn: TMenuItem;
    FilenamesTab: TTabSet;
    FontDialog1: TFontDialog;
    ColorDialog: TColorDialog;
    BlinkTimer: TTimer;
    SaveFileDialog: TSaveDialog;
    ToolsPanel: TPanel;
    OpenFileBitBtn: TSpeedButton;
    NewFileBitBtn: TSpeedButton;
    CloseFileBitBtn: TSpeedButton;
    PrintBitBtn: TSpeedButton;
    CutBitBtn: TSpeedButton;
    CopyBitBtn: TSpeedButton;
    PasteBitBtn: TSpeedButton;
    ImageSeparator1: TImage;
    ImageSeparator2: TImage;
    UndoBitBtn: TSpeedButton;
    RedoBitBtn: TSpeedButton;
    Separator1: TMenuItem;
    Separator2: TMenuItem;
    Print: TMenuItem;
    Separator3: TMenuItem;
    Undo: TMenuItem;
    Redo: TMenuItem;
    Separator4: TMenuItem;
    SaveBitBtn: TSpeedButton;
    ImageSeparator3: TImage;
    SpellCheckBitBtn: TSpeedButton;
    CodeScrollVertical: TScrollBar;
    CodeScrollHorizontal: TScrollBar;
    procedure FormResize(Sender: TObject);
    procedure StyleClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FilenamesTabChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure OpenClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CloseFileClick(Sender: TObject);
    procedure ExitClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BlinkTimerTimer(Sender: TObject);
    procedure SelectAllClick(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure CopyClick(Sender: TObject);
    procedure CutClick(Sender: TObject);
    procedure PasteClick(Sender: TObject);
    procedure NewMenuBtnClick(Sender: TObject);
    procedure SaveAsClick(Sender: TObject);
    procedure OpenFileBitBtnClick(Sender: TObject);
    procedure NewFileBitBtnClick(Sender: TObject);
    procedure CloseFileBitBtnClick(Sender: TObject);
    procedure AboutMenuBtnClick(Sender: TObject);
    procedure CutBitBtnClick(Sender: TObject);
    procedure CopyBitBtnClick(Sender: TObject);
    procedure PasteBitBtnClick(Sender: TObject);
    procedure SpellCheckBitBtnClick(Sender: TObject);
    procedure UndoClick(Sender: TObject);
    procedure RedoClick(Sender: TObject);
    procedure SaveBitBtnClick(Sender: TObject);
  private

  public
    
  end;

var
  ProgramForm           : TProgramForm;
  TextLinesCounter      : TLinesCounter;
  FilesManager          : TNexonFileManager;
  OpenFileDlg           : TOpenDialog;
  CodeField             : TCodeTextField;
  CodeFont              : TFont;
  TextCaret             : TTextCaret;
  BlinkTimerValue       : LongWord;
  BlinkFrequency        : Word;
  FilenamesTabCanChange : Boolean;

{$Include TextFieldProcedures}

implementation

uses XmlCodeUnit, StyleConfiguratorUnit, ErrorDisplayFormUnit;

{$R *.dfm}

{$Include TCodeTextField_implement}
{$Include Unit\TextFieldClassImplement}
{$Include TextFieldProceduresSrc}

procedure TProgramForm.FormResize(Sender: TObject);
begin
  // Resize by screen
  FitTextFieldIntoWindow;
end;

procedure TProgramForm.StyleClick(Sender: TObject);
begin
  // Open style window
  StyleConfiguratorForm.ShowModal;
end;

procedure TProgramForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;
  BlinkTimerValue := 0;
  BlinkFrequency := DEFAULT_BLINK_RATE;

  LoadKeywords;

  CodeFont := TFont.Create;
  CodeFont.Name := DEFAULT_FONT_NAME;
  CodeFont.Size := DEFAULT_FONT_SIZE;

  CodeField := TCodeTextField.Create(Self);
  CodeField.Parent := Self;
  CodeField.Visible := True;
  CodeField.Width := FIELD_WIDTH_MAX;
  CodeField.Height := FIELD_HEIGHT_MAX;
  CodeField.SelectionColor := DEFAULT_SELECTION_COLOR;
  CodeField.Font := CodeFont;

  TextCaret := TTextCaret.Create(Self);
  TextCaret.Parent := Self;
  TextCaret.Visible := True;
  CodeField.CaretObj := TextCaret;

  InitCodeStyles;
  InitFileManager;
  InitOpenFileDialog;
  InitLinesCounter;

  FilenamesTabCanChange := True;
end;

procedure TProgramForm.FilenamesTabChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
begin
  // On tab change handler
  if (FilenamesTabCanChange) then
    begin
      // Save current view to buffer
      FilesManager.UpdateActiveFileContents;

      FilesManager.ActiveView := NewTab;
      CodeField.LoadText(FilesManager.GetActiveFileContents);
    end;
end;

procedure TProgramForm.OpenClick(Sender: TObject);
var path : String;
begin
  FilenamesTabCanChange := False;

  // On File Open Dialog
  if OpenFileDlg.Execute then
  begin
    path := OpenFileDlg.FileName;

    if FileExists(path) then
    begin
      FilesManager.UpdateActiveFileContents;
      FilesManager.AddFile(ExtractFileName(path), LoadFileToStr(path));
      FilesManager.ActiveView := FilesManager.GetFilesCount - 1;

      UpdateActiveTextField;
      UpdateFilenamesTab;
    end;
  end;

  FilenamesTabCanChange := True;
end;

procedure TProgramForm.FormDestroy(Sender: TObject);
begin
  Cleanup;
end;

procedure TProgramForm.CloseFileClick(Sender: TObject);
begin
  CloseCurrentFile;
end;

procedure TProgramForm.ExitClick(Sender: TObject);
begin
  Close;
end;

procedure TProgramForm.SaveClick(Sender: TObject);
begin
  FilesManager.UpdateActiveFileContents;
  FilesManager.SaveActiveFile;
end;

procedure TProgramForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if not (GetKeyState(VK_LCONTROL) and $8000 = $8000) then
    CodeField.TypeLetter(Key);
end;

procedure TProgramForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var flags: Byte;
begin
  flags := 0;
  if (GetKeyState(VK_LCONTROL) and $8000 = $8000) then
    flags := (flags or KEY_FLAG_LCTRL);
  if (GetKeyState(VK_LSHIFT) and $8000 = $8000) then
    flags := (flags or KEY_FLAG_LSHIFT);

  case (Key) of
    VK_LEFT:
      CodeField.MoveCaret(DIR_LEFT, flags);
    VK_RIGHT:
      CodeField.MoveCaret(DIR_RIGHT, flags);
    VK_UP:
      CodeField.MoveCaret(DIR_UP, flags);
    VK_DOWN:
      CodeField.MoveCaret(DIR_DOWN, flags);
    VK_DELETE:
      CodeField.OnDeletePressed;
    VK_HOME:
      CodeField.OnHomePressed((flags and KEY_FLAG_LSHIFT) <> 0);
    VK_END:
      CodeField.OnEndPressed((flags and KEY_FLAG_LSHIFT) <> 0);
  end;
end;

procedure TProgramForm.BlinkTimerTimer(Sender: TObject);
begin
  // Make blinking
  Inc(BlinkTimerValue);
  if (BlinkTimerValue mod BlinkFrequency = 0) then
    CodeField.CaretObj.Visible := not TextCaret.Visible;
end;

procedure TProgramForm.SelectAllClick(Sender: TObject);
begin
  CodeField.SelectAll;
end;

procedure TProgramForm.DeleteClick(Sender: TObject);
begin
  CodeField.OnDeletePressed;
end;

procedure TProgramForm.CopyClick(Sender: TObject);
begin
  CodeField.CopySelection;
end;

procedure TProgramForm.CutClick(Sender: TObject);
begin
  CodeField.CutToClipboard;
end;

procedure TProgramForm.PasteClick(Sender: TObject);
begin
  CodeField.PasteFromClipboard;
end;

procedure TProgramForm.NewMenuBtnClick(Sender: TObject);
begin
  FilenamesTabCanChange := False;

  // Save current view to buffer
  FilesManager.UpdateActiveFileContents;
  
  FilesManager.AddFile(DEFAULT_NEWFILE_NAME, EMPTY_STRING);
  FilesManager.ActiveView := FilesManager.GetFilesCount - 1;

  UpdateFilenamesTab;
  CodeField.LoadText(FilesManager.GetActiveFileContents);

  FilenamesTabCanChange := True;
end;

procedure TProgramForm.SaveAsClick(Sender: TObject);
var path : String;
begin
  // On File Save Dialog
  if SaveFileDialog.Execute then
  begin
    path := SaveFileDialog.FileName;
    FilesManager.UpdateActiveFileContents;
    FilesManager.SaveActiveFileTo(path);
  end;
end;

procedure TProgramForm.OpenFileBitBtnClick(Sender: TObject);
begin
  OpenClick(nil);
end;

procedure TProgramForm.NewFileBitBtnClick(Sender: TObject);
begin
  NewMenuBtnClick(nil);
end;

procedure TProgramForm.CloseFileBitBtnClick(Sender: TObject);
begin
  CloseFileClick(nil);
end;

procedure TProgramForm.AboutMenuBtnClick(Sender: TObject);
begin
  // Display program info
  MessageBox(
    handle,
    ABOUT_TEXT,
    PChar('About'),
    MB_ICONINFORMATION + MB_OK
  );
end;

procedure TProgramForm.CutBitBtnClick(Sender: TObject);
begin
  CutClick(nil);
end;

procedure TProgramForm.CopyBitBtnClick(Sender: TObject);
begin
  CopyClick(nil);
end;

procedure TProgramForm.PasteBitBtnClick(Sender: TObject);
begin
  PasteClick(nil);
end;

procedure TProgramForm.SpellCheckBitBtnClick(Sender: TObject);
begin
  // Spell-check
  CodeToCheck := CodeField.FormattedCode;
  RefreshXmlDocument;
  XmlCodeFrame.ShowModal;
end;

procedure TProgramForm.UndoClick(Sender: TObject);
begin
  CodeField.Undo;
end;

procedure TProgramForm.RedoClick(Sender: TObject);
begin
  CodeField.Redo;
end;

procedure TProgramForm.SaveBitBtnClick(Sender: TObject);
begin
  SaveClick(nil);
end;

end.
