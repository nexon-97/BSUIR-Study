unit XmlCodeUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XmlDOM, XMLIntf, MSXmlDOM, XMLDoc, UnitMain;

type
  TXmlCodeForm = class(TForm)
    Label1: TLabel;
    XMLDocument: TXMLDocument;
    DisplayXmlMemo: TMemo;
    Button1: TButton;
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure RefreshXmlDocument;
procedure CreateXmlDocument;
procedure ClearXmlDocument;
procedure ParseXmlToMemo;
function ParseNodeText(node: IXMLNode; tabSize: LongInt) : String;
function ParseConst(const rawString: String; var LValue, RValue, ValueType: String) : Boolean;

procedure FindConstants;

procedure ParseProgramSection;
procedure ParseCodeIntoExpressionsList;
procedure BuildCodeXmlModel;

var
  XmlCodeFrame    : TXmlCodeForm;
  XmlMainNode     : IXMLNode;
  CodeToCheck     : String;
  ExpressionsList : TStringList;

implementation

uses ErrorDisplayFormUnit;

{$R *.dfm}

procedure ParseCodeIntoExpressionsList;
var i, j              : LongInt;
    currentExpression : String;
begin
  ExpressionsList.Clear;
  currentExpression := EMPTY_STRING;

  // Parse code into expressions
  for i := 0 to CodeField.Lines.Count - 1 do
    begin
      j := 1;

      while (j <= Length(CodeField.Lines[i])) do
        begin
          if (Ord(CodeField.Lines[i][j]) >= KEY_SPACE) then
            begin

              if ((CodeField.Lines[i][j] = ';') and (CodeField.LineStyles[i][j] = TextStyle(TEXT_STYLE_NONE))) then
                begin
                  ExpressionsList.Add(Trim(currentExpression));
                  currentExpression := EMPTY_STRING;
                end
              else if (
                (CodeField.LineStyles[i][j] <> TextStyle(TEXT_STYLE_COMMENT))
                  and
                (CodeField.LineStyles[i][j] <> TextStyle(TEXT_STYLE_MULTILINE_COMMENT))
              ) then
                begin
                  if (
                    (
                      (CodeField.LineStyles[i][j] = TextStyle(TEXT_STYLE_KEYWORD))
                        and
                      (
                        ((j < Length(CodeField.LineStyles[i])) and (CodeField.LineStyles[i][j + 1] <> TextStyle(TEXT_STYLE_KEYWORD)))
                          or
                        (j = Length(CodeField.LineStyles[i]))
                      )
                    )
                  ) then
                    begin
                      if (
                        (Pos('t', currentExpression) <> Length(currentExpression)) and
                        (Pos('downt', currentExpression) <> Length(currentExpression))
                      ) then
                        begin
                          ExpressionsList.Add(Trim(currentExpression + CodeField.Lines[i][j]));
                          currentExpression := EMPTY_STRING;
                        end
                      else
                        currentExpression := currentExpression + CodeField.Lines[i][j];
                    end
                  else
                    currentExpression := currentExpression + CodeField.Lines[i][j];
                end;
                
            end;

          Inc(j);
        end;
    end;

    ExpressionsList.Add(currentExpression);
end;

procedure BuildCodeXmlModel;
var i, j           : LongInt;
    currentSection : Byte;
    errorCode      : Byte;
    currentLine    : String;
    identifier     : String;
    lineOffset     : LongInt;
begin
  errorCode := 0;
  currentSection := NO_SECTION;

  ParseCodeIntoExpressionsList;

  //FindConstants;
end;

procedure ParseProgramSection;
begin

end;

procedure TXmlCodeForm.FormResize(Sender: TObject);
begin
  DisplayXmlMemo.Left := 5;
  DisplayXmlMemo.Top := 25;
  DisplayXmlMemo.Width := ClientWidth - 10;
  DisplayXmlMemo.Height := ClientHeight - 70;
end;

procedure CreateXmlDocument;
var LNodeElement, NodeText: IXMLNode;
begin
  with XmlCodeFrame do
    begin
      XMLDocument.Active := True;

      XmlMainNode := XMLDocument.CreateNode('DelphiDocument', ntElement, '');
      XMLDocument.DocumentElement := XmlMainNode;

      XMLDocument.Active := False;
    end;
end;

procedure ParseXmlToMemo;
var LNodeElement, NodeText : IXMLNode;
    i                      : LongInt;
begin
  with XmlCodeFrame do
    begin
      XMLDocument.Active := True;
      
      if Assigned(XmlMainNode) then
        DisplayXmlMemo.Lines.Add(ParseNodeText(XmlMainNode, 0));

      for i := 0 to ExpressionsList.Count - 1 do
        DisplayXmlMemo.Lines.Add(ExpressionsList[i]);

      XMLDocument.Active := False;
    end;
end;

function ParseNodeText(node: IXMLNode; tabSize: LongInt) : String;
var hasChildren: Boolean;
    childrenString, attributes, tabs: String;
    nodeList : IXMLNodeList;
    i: LongInt;
begin
  Result := '';

  if Assigned(node) then
    begin
      nodeList := node.ChildNodes;
      hasChildren := nodeList.Count > 0;

      tabs := '';
      for i := 1 to tabSize do
        tabs := tabs + #32#32#32;

      attributes := '';
      for i := 0 to node.AttributeNodes.Count - 1 do
        attributes := attributes + #32 + node.AttributeNodes[i].NodeName + '="' + node.AttributeNodes[i].NodeValue + '"';

      if not hasChildren then
        Result := tabs + '<' + node.NodeName + attributes + '/>'
      else
        begin
          childrenString := '';
          nodeList := node.ChildNodes;

          for i := 0 to node.ChildNodes.Count - 1 do
            childrenString := childrenString + ParseNodeText(node.ChildNodes[i], tabSize + 1) + #13#10;

          Result := tabs + '<' + node.NodeName + attributes + '>' + #13#10 + childrenString + tabs + '</' + node.NodeName + '>';
        end;
    end;
end;

procedure FindConstants;
var constText   : String;
    tempString  : String;
    keyPos, i   : LongInt;
    identifier  : String;
    breakerPos  : LongInt;
    funcSuccess : Boolean;
    constName   : String;
    constValue  : String;
    constType   : String;
    LConstNode  : IXMLNode;
    LConstValue : IXMLNode;
    strState    : Byte;
begin
  constText := CodeToCheck;

  // Process all 'const' sections
  repeat
    keyPos := Pos(DELPHI_CONST_KEYWORD, constText);

    if (keyPos > 0) then
      begin
        // Add const section node
        LConstNode := XmlMainNode.AddChild('ConstSection', -1);

        constText := Copy(constText, keyPos + Length(DELPHI_CONST_KEYWORD) + 1, Length(constText));

        repeat
          breakerPos := 0;
          strState := TEXT_STYLE_NONE;
          for i := 1 to Length(constText) do
            begin
              if ((strState = TEXT_STYLE_NONE) and (constText[i] = DELPHI_OPERATOR_END)) then
                begin
                  breakerPos := i;
                  break;  
                end
              else if (constText[i] = DELPHI_STRING_BORDER) then
                begin
                  if (strState = TEXT_STYLE_STRING) then
                    strState := TEXT_STYLE_NONE
                  else if (strState = TEXT_STYLE_NONE) then
                    strState := TEXT_STYLE_STRING;
                end
              else if ((strState = TEXT_STYLE_NONE) and((i <= Length(constText) - 1) and (constText[i] = '/') and (constText[i + 1] = '/'))) then
                begin
                  strState := TEXT_STYLE_COMMENT;
                end
              else if (constText[i] = #10) then
                strState := TEXT_STYLE_NONE;
            end;

          //breakerPos := Pos(DELPHI_OPERATOR_END, constText);

          if (breakerPos > 0) then
            begin
              funcSuccess := ParseConst(Copy(constText, 1, breakerPos - 1), constName, constValue, constType);
              constText := Copy(constText, breakerPos + 1, Length(constText));
            end
          else
            begin
              funcSuccess := ParseConst(constText, constName, constValue, constType);
              constText := EMPTY_STRING;
            end;

          // Add 'const' node
          if funcSuccess then
            begin
              LConstValue := LConstNode.AddChild('Const', -1);
              LConstValue.Attributes['id'] := constName;
              LConstValue.Attributes['value'] := constValue;

              if (Length(constType) > 0) then
                LConstValue.Attributes['type'] := constType;
            end;
            
        until ((breakerPos = 0) or (not funcSuccess));
      end;

  until (keyPos = 0);
end;

procedure RefreshXmlDocument;
begin
  XmlCodeFrame.DisplayXmlMemo.Clear;
  ClearXmlDocument;

  BuildCodeXmlModel;

  ParseXmlToMemo;
end;

procedure ClearXmlDocument;
var hasChildren                      : Boolean;
    childrenString, attributes, tabs : String;
    i                                : LongInt;
    myNode, currentNode              : IXMLNode;
begin
  if Assigned(XmlMainNode) then
    for i := 0 to XmlMainNode.ChildNodes.Count - 1 do
      XmlMainNode.ChildNodes.Remove(XmlMainNode.ChildNodes[0]);
end;

function ParseConst(const rawString: String; var LValue, RValue, ValueType: String) : Boolean;
var i          : LongInt;
    LValueRead : Boolean;
    srcString  : String;
    typeDefine : Boolean;
begin
  LValue := EMPTY_STRING;
  RValue := EMPTY_STRING;
  ValueType := EMPTY_STRING;
  Result := True;

  LValueRead := False;
  typeDefine := False;

  for i := 1 to Length(rawString) do
    if (rawString[i] = DELPHI_TYPE_DEFINITOR) then
      begin
        LValueRead := True;
        typeDefine := True;
      end
    else if (rawString[i] = DELPHI_CONST_ASSIGNMENT) then
      begin
        LValueRead := True;
        typeDefine := False;
      end
    else
      begin
        if (not LValueRead) then
          LValue := LValue + rawString[i]
        else if typeDefine then
          ValueType := ValueType + rawString[i]
        else
          RValue := RValue + rawString[i];
      end;

  // Trim output values
  LValue := Trim(LValue);
  RValue := Trim(RValue);
  ValueType := Trim(ValueType);

  Result := IsIdentifier(LValue) and ((Length(ValueType) = 0) or IsIdentifier(ValueType));
end;

procedure TXmlCodeForm.FormCreate(Sender: TObject);
var a, b, c : String;
begin
  ExpressionsList := TStringList.Create;
  
  CreateXmlDocument;
end;

procedure TXmlCodeForm.Button1Click(Sender: TObject);
begin
  ErrorDisplayForm.Show;
end;

end.
