// Constants
const
  TEXT_FIELD_MARGIN = 5;
  EMPTY_STRING = '';
  DEFAULT_FONT_NAME = 'Courier New';
  DEFAULT_FONT_SIZE = 14;
  DEFAULT_NEWFILE_NAME = 'new.pas';
  SAMPLE_FILE_NAME = 'testCode.pas';

  FIELD_WIDTH_MAX = 3000;
  FIELD_HEIGHT_MAX = 1500;

  TOOLBOX_HEIGHT = 37;

  DIR_LEFT = 1;
  DIR_RIGHT = 2;
  DIR_UP = 3;
  DIR_DOWN = 4;

  LINE_SPACING = 2;
  CHAR_SPACING = 0;

  TEXT_STYLE_NONE = 0;
  TEXT_STYLE_SELECTED = 1;
  TEXT_STYLE_COMMENT = 2;
  TEXT_STYLE_STRING = 3;
  TEXT_STYLE_NUMBER = 4;
  TEXT_STYLE_MULTILINE_COMMENT = 5;
  TEXT_STYLE_KEYWORD = 6;

  KEY_BACKSPACE = 8;
  KEY_ENTER = 13;
  KEY_SPACE = 32;
  
  KEY_FLAG_LCTRL = 1;
  KEY_FLAG_LSHIFT = 2;

  DEFAULT_BLINK_RATE = 5;
  DEFAULT_SELECTION_COLOR = $FF9400;

  ABOUT_TEXT =
      'Delphi Notepad' + #13#10 +
      'Made by Nexon' + #13#10#13#10 +
      'nexon.97@mail.ru';
  CAUTION_TEXT = 'Внимание';
  EXIT_MESSAGE = 'Вы уверены, что хотите выйти из программы?' + #13#10 +
                 'Все несохраненные данные будут утеряны!' + #13#10 + 
                 'Выйти?';

  OPEN_FILE_FILTER =
      'Project Group File (*.bpg)|*.bpg|' +
      'Delphi File (*.pas;*.bpg;*.dpr;*.dpk;*.dpkw)|*.pas;*.bpg;*.dpr;*.dpk;*.dpkw|' +
      'Delphi Project (*.dpr;*.bpg)|*.dpr;*.bpg|' +
      'Delphi Package (*.dpk;*.dpkw)|*.dpk;*.dpkw|' +
      'Delphi Unit (*.pas)|*.pas|' +
      'Delphi Form (*.xfm;*.dfm)|*.xfm;*.dfm|' +
      'Pascal project (*.pas)|*.pas|' +
      'Text File (*.txt)|*.txt|' +
      'SQL File (*.sql)|*.sql|' +
      'HTML File (*.html;*.htm)|*.html;*.htm|' +
      'Web Document (*.xml;*.xsl;*.wsdl;*.xsd)|*.xml;*.xsl;*.wsdl;*.xsd|' +
      'Batch File (*.bat)|*.bat|' +
      'Type Library (*.tlb;*.dll;*.ocx;*.exe;*.olb)|*.tlb;*.dll;*.ocx;*.exe;*.olb|' +
      'All Files (*.*)|*.*';

  DELPHI_KEYWORDS_FILE = 'data\delphi_keywords.txt';

  HISTORY_EDITMODE_NONE = 0;
  HISTORY_EDITMODE_DELETE = 1;
  HISTORY_EDITMODE_INSERT = 2;

  DELPHI_MULTILINE_OPENER = '{';
  DELPHI_MULTILINE_CLOSER = '}';
  KEYWORD_BREAKER = '$';

  DELPHI_STRING_BORDER = #39;
  DELPHI_COMMENT_BEGINNER = '//';
  DELPHI_TYPE_DEFINITOR = ':';
  DELPHI_CONST_KEYWORD = 'const';
  DELPHI_CONST_ASSIGNMENT = '=';
  DELPHI_OPERATOR_END = ';';

  DELPHI_STYLES_COUNT = 7;

  CODE_VIEWER_STYLE_FILE = 'editorConfig.dat';

  NO_SECTION = 0;
  CONST_SECTION = 1;
  VAR_SECTION = 2;
  TYPE_SECTION = 3;
  PROGRAM_SECTION = 4;
  USES_SECTION = 5;
  PROCEDURE_DECLARATION_SECTION = 6;
  FUNCTION_DECLARATION_SECTION = 7;
  PROCEDURE_IMPLEMENTATION_SECTION = 8;
  FUNCTION_IMPLEMENTATION_SECTION = 9;

// User list types
type
  TUserListPtr = ^TUserList;
  TUserListElementPtr = ^TUserListElement;

  TUserList = record
    first, last : TUserListElementPtr;
  end;
  TUserListElement = record
    letter    : Char;
    childList : TUserListPtr;
    next      : TUserListElementPtr;
  end;

  TFontStyle = record
    fontName                 : String;
    fontSize                 : LongInt;
    bold, italic, underlined : Boolean;
    textColor, backColor     : TColor;
  end;

var
  keywords     : array of String;
  keywordsList : TUserListPtr;
  fontStyles   : array of TFontStyle;

// User list procedures
function CreateUserList : TUserListPtr;
function FindElement(data: Char; list: TUserListPtr) : TUserListElementPtr;
procedure AddElement(data: Char; list: TUserListPtr);
procedure BuildKeywordsTree;

procedure Cleanup;

function LoadFileToStr(const fileName: TFileName): String;
procedure SaveTextToFile(const fileName: TFileName; const contents: String);

procedure InitLinesCounter;
procedure InitFileManager;
procedure InitOpenFileDialog;
procedure InitCodeStyles;

procedure FitTextFieldIntoWindow;
procedure LoadKeywords;
procedure RefreshLinesDisplay;

procedure UpdateActiveTextField;
procedure UpdateFilenamesTab;
procedure CloseCurrentFile;

procedure InvertString(var src: String);

function IsSymbol(c: Char) : Boolean;
function IsSign(c: Char) : Boolean;
function IsDigit(c: Char) : Boolean;
function IsIdentifier(key: String) : Boolean;
function IsCorrectTypeName(const key: String) : Boolean;
function IsKeyword(pos: LongInt; str: String) : Boolean;
function IsNumber(const src: String; var convertedNumber: LongInt) : Boolean;
function IsModuleName(const src: String) : Boolean;
function IsDereference(const src: String) : Boolean;
function IsVariable(const src: String) : Boolean;

function IsOperator(const src: String) : Boolean;
function IsBinaryOperator(const src: String) : Boolean;
function IsPrefixOperator(const src: String) : Boolean;
function IsArrayElementCall(const src: String) : Boolean;
function IsProcedureCall(const src: String) : Boolean;
function IsCorrectStatement(const src: String) : Boolean;

function TextStyle(code: Byte) : Char;

procedure UpdateCodeVerticalScrollPos(pos: LongInt);
procedure UpdateCodeVerticalScrollRange(range: LongInt);
