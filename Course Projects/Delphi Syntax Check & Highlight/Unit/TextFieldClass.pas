type TTextAttributes = record 
  Font : TFont;
  BackColor : TColor; 
end;

// ======================================
// ======= CLASS TLinesCounter ==========
// ======================================
type
	TLinesCounter = class(TImage)
private
    fLineStart: LongWord;
    fLinesCount: LongWord;
    fTempHeight: Word;

    procedure InitLinesCounter;
    procedure RedrawWidget;

protected
    procedure SetLinesCount(value: LongWord);
    procedure SetStartLine(value: LongWord);

public
    constructor Create(Control: TControl); reintroduce; overload;

    property LinesCount: LongWord read fLinesCount write SetLinesCount;
    property StartLine: LongWord read fLineStart write SetStartLine;
    property TempHeight: Word read fTempHeight write fTempHeight;

published
    { Published declarations }
    
end;

// ======================================
// ===== CLASS TNexonFileManager ========
// ======================================
type FILE_DESCRIPTION = record
  filename: String;
end;

type
	TNexonFileManager = class
private
    fFilesList: TStringList;
    fFileContents: TStringList;
    fActiveView: Word;

    procedure InitManager;
    procedure SetActiveView(view: Word);

protected
    { Protected declarations }

public
    constructor Create;
    destructor Destroy; override;

    procedure AddFile(filename, contents: String);
    procedure RemoveCurrentFile;

    function GetFilesCount: Word;
    function GetFileName(index: Word): String;
    function GetFileContents(index: Word): String;

    function GetActiveFileName: String;
    function GetActiveFileContents: String;

    procedure UpdateActiveFileContents;
    procedure SaveActiveFile;
    procedure SaveActiveFileTo(path: String);

    procedure SetFileContents(filename, text: String);

    property ActiveView: Word read fActiveView write SetActiveView;
    
end;
