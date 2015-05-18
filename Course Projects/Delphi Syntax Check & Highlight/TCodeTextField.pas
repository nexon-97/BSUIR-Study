type

  // Stack type
  TEditHistoryElementPtr = ^TEditHistoryElement;
  TEditHistoryElement = record
    editType : Byte;
    text     : String;
    point    : TPoint;
  end;

  TStackPtr = ^TStack;
  TStackElementPtr = ^TStackElement;

  TStack = record
    top: TStackElementPtr;
  end;
  TStackElement = record
    data: TEditHistoryElementPtr;
    above, below: TStackElementPtr;
  end;

function CreateStack : TStackPtr;
procedure PushElementToStack(data: TEditHistoryElementPtr; stack: TStackPtr);
function PopElementFromStack(stack: TStackPtr) : TEditHistoryElementPtr;
procedure MoveToStackTop(stack: TStackPtr);

type
  TTextCaret = class (TImage)
    private
      fRealHeight: Word;

      procedure InitCaret;
  
    public
      constructor Create(Control: TControl); reintroduce; overload;

      procedure SetHeight(height: Word);

    protected

    published
      property RealHeight: Word read fRealHeight write fRealHeight;

  end;


  TCodeTextField = class(TImage)
    private
      fLines              : TStringList;
      fLineStyles         : TStringList;
      fWidgetFont         : TFont;
      fLineDisplayStart   : LongInt;
      fDisplayLength      : LongInt;
      fSize               : TPoint;
      fBackColor          : TColor;
      fSelectionColor     : TColor;
      fCaretPos           : TPoint;
      fCaretObject        : TTextCaret;
      fSelStart           : TPoint;
      fSelEnd             : TPoint;
      fFontSize           : TPoint;
      fEditStack          : TStackPtr;

      procedure InitTextField;
      procedure SetSize(size: TPoint);

      procedure RedrawLines;
      procedure RedrawLinesFromCaretPos;
      procedure RedrawLine(line: LongInt);

      procedure SetTextStyle(style: Byte);

      function ComparePositions(p1, p2: TPoint) : Integer;
      function GetCharStyle(pos: TPoint) : Byte;

      procedure PushToEditStack(editType: Byte; stringInfo: String; pointInfo: TPoint);

      procedure ResetLineStyle(line: LongInt);
      procedure SetLineStyle(line, _from, _to: LongInt; style: Byte); overload;
      procedure SetLineStyle(line: LongInt; style: String); overload;

      procedure OnLineTextChanged(line: LongInt);
      procedure RefreshLineStyles(_from, _to: LongInt);

      function IsPreviousLineMultilineComment(line: LongInt) : Boolean;
      procedure ProcessStrings(line: LongInt);
      procedure ProcessKeywords(line: LongInt);
      procedure ProcessDigits(line: LongInt);

      // Input methods
      procedure ResetSelection;
      procedure AppendChar(c: Char);
      procedure ProcessBackSpace;
      procedure ProcessEnter;

      function IsCharSelected(pos: TPoint) : Boolean;

      function GetFormattedCode : String;

    protected
        { Protected declarations }
    public
      constructor Create(Control: TControl); reintroduce; overload;

      procedure Refresh;
      procedure RefreshCaretPos;

      function GetLineCount : Integer;
      procedure TypeLetter(c: Char);
      procedure MoveCaret(dir, flags: Byte);
      procedure SetCaretPos(pos: TPoint);
      procedure SetStartLine(line: LongInt);
      procedure SetDisplayLength(len: LongInt);

      function GetSelectionLength : LongInt;
      function GetSelectionText : String;

      procedure SelectAll;
      procedure OnDeletePressed;
      procedure OnHomePressed(shiftPressed: Boolean);
      procedure OnEndPressed(shiftPressed: Boolean);
  
      procedure RemoveSelection;
      procedure CopySelection;
      procedure CutToClipboard;
      procedure PasteFromClipboard;
      procedure LoadText(text: String);
      function GetText : String;

      procedure SetWidgetFont(font: TFont);

      procedure OnTextFieldPress(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

      procedure Undo;
      procedure Redo;

      function GetLastDisplayedLine : LongInt;
  
    published
      property Lines: TStringList read fLines;
      property LineStyles: TStringList read fLineStyles;
      property LinesCount: Integer read GetLineCount;
      property Font: TFont read fWidgetFont write SetWidgetFont;
      property WidgetSize: TPoint read fSize write SetSize;
      property CaretPos: TPoint read fCaretPos write SetCaretPos;
      property CaretObj: TTextCaret read fCaretObject write fCaretObject;
      property SelectionColor: TColor read fSelectionColor write fSelectionColor;
      property StartLine: LongInt read fLineDisplayStart write SetStartLine;
      property DisplayLength: LongInt read fDisplayLength write SetDisplayLength;
      property FormattedCode : String read GetFormattedCode;
  
  end;
 