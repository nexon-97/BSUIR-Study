unit XmlCodeUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XMLDOM, XMLIntf, MSXMLDOM, XMLDoc, UnitMain;

const
  ERR_MSG_ELSE = #39 + ';' + #39 + ' недопустимо перед ' + #39 + 'ELSE' + #39;
  ERR_MSG_BRACES_COUNT = 'Неверное количество скобок';
  ERR_MSG_BRACE_CLOSED_EARLY = 'Закрывающая скобка раньше открывающей';
  ERR_MSG_PROC_PARAMS = 'Ошибка в объявлении параметров процедуры';
  ERR_MSG_INCORRECT_PROC_NAME = 'Некорректное название процедуры';
  ERR_MSG_INCORRECT_IDENTIFIER_NAME = 'Некорректное имя идентификатора';
  ERR_MSG_INCORRECT_VAR_NAME = 'Некорректное название переменной';
  ERR_MSG_VAR_DECLARATION_EXPECTED = 'Ожидалось объявление переменной';
  ERR_MSG_VAR_DECLARATION_WRONG = 'Ошибка в объявлении переменной';
  ERR_MSG_CONST_DECLARATION_EXPECTED = 'Ожидалось объявление константы';
  ERR_MSG_INCORRECT_TYPE_NAME = 'Некорректное имя типа';
  ERR_MSG_INCORRECT_RANGE = 'Некорректный диапазон';
  ERR_MSG_RANGE_BORDERS = 'Правая граница диапазона меньше левой';
  ERR_MSG_NO_USES_MODULE_DEFINED = 'Ожидалось объявление модуля';
  ERR_MSG_INVALID_TYPE_DECLARATION = 'Ошибка в объявлении типа';
  ERR_MSG_FOR_LOOP_DECLARATION = 'Ошибка в объявлении цикла FOR';
  ERR_MSG_INCORRECT_STATEMENT = 'Некорректное выражение';
  ERR_MSG_THEN_EXPECTED = 'Ожидалось ' + #39 + 'THEN' + #39 + ' после условного выражения';
  ERR_MSG_FUNCTION_DEFINITION_EXPECTED = 'Ожидалось определение функции';
  ERR_MSG_PROC_DEFINITION_EXPECTED = 'Ожидалось определение процедуры';
  ERR_MSG_WHILE_DO_EXPECTED = 'Ожидалось ' + #39 + 'DO' + #39 + ' после условного выражения';
  ERR_MSG_CONDITION_EXPECTED = 'Ожидалось условие';

type
  PSingleParameter = ^TSingleParameter;

  TSingleParameter = record
    parameterNames : TStringList;
    attributes     : TStringList;
    parameterType  : String;
  end;

type
  TXmlCodeForm = class(TForm)
    Label1: TLabel;
    XMLDocument: TXMLDocument;
    DisplayXmlMemo: TMemo;
    ShowCheckStatusBtn: TButton;
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

function SplitBySubString(const src, substr: String) : TStringList;
function IsRangeValid(src: String) : Boolean;

procedure ParseCodeIntoExpressionsList;
procedure AddExpressionLine(const line: LongInt);
procedure CheckExpressionsList;
procedure BuildCodeXmlModel;

function GetLineVariable(const src: String; var varNames : TStringList; var varType: String) : Boolean;
function GetLineType(const src: String; var typeName, typeId: String; var recordNode: IXMLNode) : Boolean;
function MatchProcedureDeclarationTemplate(const src: String; var procName, className: String; var parameters: TList) : Boolean;
function MatchFunctionDeclarationTemplate(const src: String; var funcName, className, retType: String; var parameters: TList) : Boolean;

procedure ProcessFORStatement(var node: IXMLNode);
procedure ProcessWHILEStatement(var node: IXMLNode);
procedure ProcessREPEATStatement(var node: IXMLNode);
procedure ProcessIFStatement(var node: IXMLNode);
procedure ProcessOrdinaryStatement(var node: IXMLNode);

procedure ParseProgramSection;
procedure CheckElseErrors;
procedure CheckGlobalVariablesSection;
procedure CheckUsesSection;
procedure CheckTypeSection;
procedure CheckProcedure;
procedure CheckFunction;
procedure ProcessComplexOperator(var operatorNode: IXMLNode);
procedure ProcessSingleOperator(var operatorNode: IXMLNode);

function CheckParametersList(const src: String; var params: TList) : Boolean;
function GetParameter(const src: String; var success: Boolean) : PSingleParameter;

function IsValidArrayDeclaration(const rangePart, typePart: String; var rangeStr, arrayType: String) : Boolean;

var
  XmlCodeFrame    : TXmlCodeForm;
  XmlMainNode     : IXMLNode;
  CodeToCheck     : String;
  ExpressionsList : TStringList;
  ExpressionLines : TList;
  currentNode     : IXmlNode;
  childNode       : IXmlNode;
  checkedLine     : LongInt;

implementation

uses ErrorDisplayFormUnit, StrUtils;

{$R *.dfm}

procedure ProcessOrdinaryStatement(var node: IXMLNode);
var assignPos : LongInt;
    lvalue    : String;
    rvalue    : String;
    innerNode : IXMLNode;
begin
  if (checkedLine < ExpressionsList.Count) then
    begin
      assignPos := Pos(':=', ExpressionsList[checkedLine]);

      if (assignPos > 0) then
        begin
          innerNode := node.AddChild('Assignment', -1);
          lvalue := Trim(Copy(ExpressionsList[checkedLine], 1, assignPos - 1));
          rvalue := Trim(Copy(ExpressionsList[checkedLine], assignPos + 2, Length(ExpressionsList[checkedLine])));

          if (Length(lvalue) > 0) then
            innerNode.Attributes['LValue'] := lvalue;
          if (Length(rvalue) > 0) then
            innerNode.Attributes['RValue'] := rvalue;

          if not (IsVariable(lvalue) and IsCorrectStatement(rvalue)) then
            DisplayOutputMessage(0, LongInt(ExpressionLines[checkedLine]^), ERR_MSG_INCORRECT_STATEMENT)
        end
      else
        begin
          if IsCorrectStatement(ExpressionsList[checkedLine]) then
            begin
              innerNode := node.AddChild('ProcedureCall', -1);

              if (Length(ExpressionsList[checkedLine]) > 0) then
                innerNode.Attributes['statement'] := ExpressionsList[checkedLine];
            end
          else
            DisplayOutputMessage(0, LongInt(ExpressionLines[checkedLine]^), ERR_MSG_INCORRECT_STATEMENT);
        end;
    end;

end;

// Process 'IF' statement
procedure ProcessIFStatement(var node: IXMLNode);
var breakerPos : LongInt;
    src        : String;
    branchNode : IXMLNode;
begin
  Inc(checkedLine);

  if (checkedLine < ExpressionsList.Count) then
    begin
      src := ExpressionsList[checkedLine];

      breakerPos := Pos(' THEN', UpperCase(src));
      if (breakerPos = Length(src) - 4) then
        begin
          src := Trim(Copy(src, 1, Length(src) - 5));

          if not IsCorrectStatement(src) then
            DisplayOutputMessage(0, LongInt(ExpressionLines[checkedLine]^), ERR_MSG_INCORRECT_STATEMENT)
          else
            begin
              if ((Length(src) >= 2) and (src[1] = '(') and (src[Length(src)] = ')')) then
                src := Trim(Copy(src, 2, Length(src) - 2));
              if (Length(src) > 0) then
                node.Attributes['condition'] := src
              else
                DisplayOutputMessage(0, LongInt(ExpressionLines[checkedLine]^), ERR_MSG_CONDITION_EXPECTED);

              branchNode := node.AddChild('TrueBranch', -1);
              Inc(checkedLine);
              ProcessSingleOperator(branchNode);

              if ((checkedLine < ExpressionsList.Count) and (UpperCase(ExpressionsList[checkedLine]) = 'ELSE')) then
                begin
                  branchNode := node.AddChild('ElseBranch', -1);
                  Inc(checkedLine);
                  ProcessSingleOperator(branchNode);
                end;
            end;
        end
      else
        DisplayOutputMessage(0, LongInt(ExpressionLines[checkedLine]^), ERR_MSG_THEN_EXPECTED);
    end;
end;

procedure ProcessREPEATStatement(var node: IXMLNode);
var src     : String;
    endCond : Boolean;
begin
  Inc(checkedLine);

  endCond := False;
  while ((not endCond) and (checkedLine < ExpressionsList.Count)) do
    begin
      src := ExpressionsList[checkedLine];
      if (UpperCase(src) = 'UNTIL') then
        begin
          endCond := True;
          Inc(checkedLine);

          if ((checkedLine < ExpressionsList.Count) and IsCorrectStatement(ExpressionsList[checkedLine])) then
            node.Attributes['condition'] := ExpressionsList[checkedLine];
          Inc(checkedLine);
        end
      else
        ProcessSingleOperator(node);
    end;
end;

// Process 'WHILE' statement
procedure ProcessWHILEStatement(var node: IXMLNode);
var breakerPos : LongInt;
    src        : String;
begin
  Inc(checkedLine);

  if (checkedLine < ExpressionsList.Count) then
    begin
      src := ExpressionsList[checkedLine];

      breakerPos := Pos(' DO', UpperCase(src));

      if (breakerPos = 0) then
        DisplayOutputMessage(0, LongInt(ExpressionLines[checkedLine]^), ERR_MSG_WHILE_DO_EXPECTED)
      else
        begin
          src := Trim(Copy(src, 1, breakerPos - 1));

          if IsCorrectStatement(src) then
            node.Attributes['condition'] := src;

          // Get loop operator
          if (checkedLine + 1 < ExpressionsList.Count) then
            begin
              Inc(checkedLine);
              ProcessSingleOperator(node);
            end;
        end;
    end;
end;

// Process 'FOR' statement
procedure ProcessFORStatement(var node: IXMLNode);
var breakerPos : LongInt;
    breakerLen : LongInt;
    src        : String;
    initPart   : String;
    varName    : String;
    assignment : LongInt;
    condPart   : String;
begin
  Inc(checkedLine);

  if (checkedLine < ExpressionsList.Count) then
    begin
      src := ExpressionsList[checkedLine];

      breakerPos := Pos(' downto', src);
      if (breakerPos > 0) then
        begin
          breakerLen := Length(' downto');

          if (checkedLine + 1 < ExpressionsList.Count) then
            begin
              Inc(checkedLine);
              src := src + ' ' + ExpressionsList[checkedLine];
            end;
        end
      else
        begin
          breakerPos := Pos(' to', src);

          breakerLen := 0;
          if (breakerPos > 0) then
            breakerLen := Length(' to');
        end;

      if (breakerPos = 0) then
        DisplayOutputMessage(0, LongInt(ExpressionLines[checkedLine]^), ERR_MSG_FOR_LOOP_DECLARATION)
      else
        begin
          initPart := Trim(Copy(src, 1, breakerPos - 1));
          condPart := Trim(Copy(src, breakerPos + breakerLen, Length(src)));

          if (Pos('DO', UpperCase(condPart)) = Length(condPart) - 1) then
            begin
              SetLength(condPart, Length(condPart) - 2);
              condPart := Trim(condPart);

              // Divide parameterName
              assignment := Pos(':=', initPart);
              if (assignment = 0) then
                DisplayOutputMessage(0, LongInt(ExpressionLines[checkedLine]^), ERR_MSG_FOR_LOOP_DECLARATION)
              else
                begin
                  varName := Trim(Copy(initPart, 1, assignment - 1));
                  initPart := Trim(Copy(initPart, assignment + 2, Length(initPart)));
                end;
            end;

          if (IsVariable(varName) and IsCorrectStatement(initPart) and IsCorrectStatement(condPart)) then
            begin
              node.Attributes['variable'] := varName;
              node.Attributes['startValue'] := initPart;
              node.Attributes['endCond'] := condPart;
            end;

          // Get loop operator
          if (checkedLine + 1 < ExpressionsList.Count) then
            begin
              Inc(checkedLine);
              ProcessSingleOperator(node);
            end;
        end;
    end;
end;

procedure ProcessComplexOperator(var operatorNode: IXMLNode);
begin
  Inc(checkedLine);

  while ((checkedLine < ExpressionsList.Count) and (UpperCase(ExpressionsList[checkedLine]) <> 'END')) do
    begin
      if (UpperCase(ExpressionsList[checkedLine]) = 'BEGIN') then
        begin
          ProcessSingleOperator(operatorNode);
        end
      else if (UpperCase(ExpressionsList[checkedLine]) = 'IF') then
        begin
          ProcessSingleOperator(operatorNode);
        end
      else if (UpperCase(ExpressionsList[checkedLine]) = 'WHILE') then
        begin
          ProcessSingleOperator(operatorNode);
        end
      else if (UpperCase(ExpressionsList[checkedLine]) = 'REPEAT') then
        begin
          ProcessSingleOperator(operatorNode);
        end
      else if (UpperCase(ExpressionsList[checkedLine]) = 'FOR') then
        begin
          ProcessSingleOperator(operatorNode);
        end
      else
        begin
          ProcessSingleOperator(operatorNode);
        end;
    end;

  Inc(checkedLine);
end;

procedure ProcessSingleOperator(var operatorNode: IXMLNode);
var innerOperator : IXMLNode;
    src           : String;
begin
  if ((checkedLine < ExpressionsList.Count)) then
    begin
      src := UpperCase(ExpressionsList[checkedLine]);

      if (src = 'BEGIN') then
        begin
          innerOperator := operatorNode.AddChild('ComplexOperator');
          //Inc(checkedLine);
          ProcessComplexOperator(innerOperator);
        end
      else if (src = 'IF') then
        begin
          // Process 'IF' statement
          innerOperator := operatorNode.AddChild('If');
          ProcessIFStatement(innerOperator);
        end
      else if (src = 'WHILE') then
        begin
          // Process 'WHILE' statement
          innerOperator := operatorNode.AddChild('WhileLoop');
          ProcessWHILEStatement(innerOperator);
        end
      else if (src = 'REPEAT') then
        begin
          // Process 'REPEAT' statement
          innerOperator := operatorNode.AddChild('RepeatLoop');
          ProcessREPEATStatement(innerOperator);
        end
      else if (src = 'FOR') then
        begin
          innerOperator := operatorNode.AddChild('ForLoop');
          ProcessFORStatement(innerOperator);
        end
      else
        begin
          //innerOperator := operatorNode.AddChild('Operator');
          ProcessOrdinaryStatement(operatorNode);
          Inc(checkedLine);
        end;
    end;
end;

function MatchProcedureDeclarationTemplate(const src: String; var procName, className: String; var parameters: TList) : Boolean;
var braceLeft, dotPos : LongInt;
    i                 : LongInt;
    procDesc          : String;
    procParams        : String;
    checkParams       : Boolean;
begin
  braceLeft := Pos('(', src);
  if (braceLeft > 0) then
    begin
      procDesc := Copy(src, 1, braceLeft - 1);
      procParams := Copy(src, braceLeft, Length(src));
    end
  else
    procDesc := src;

  procDesc := Trim(procDesc);
  procParams := Trim(procParams);

  dotPos := Pos('.', procDesc);
  if (dotPos > 0) then
    begin
      className := Copy(procDesc, 1, dotPos - 1);
      procName := Copy(procDesc, dotPos + 1, Length(procDesc));
      Result := IsIdentifier(procName) and IsIdentifier(className);
    end
  else
    begin
      procName := procDesc;
      Result := IsIdentifier(procName);
    end;

  if not Result then
    DisplayOutputMessage(0, LongInt(ExpressionLines[checkedLine]^), ERR_MSG_INCORRECT_PROC_NAME);

  Result := IsIdentifier(procName) and ((Length(className) = 0) or (IsIdentifier(className)));

  checkParams := False;
  for i := 1 to Length(procParams) do
    if not (procParams[i] in [' ','(',')']) then
      begin
        checkParams := True;
        break;
      end;

  if (
    Result
      and
    ((Length(procParams) > 2) and checkParams and (procParams[1] = '(') and (procParams[Length(procParams)] = ')'))
  ) then
    Result := CheckParametersList(Copy(procParams, 2, Length(procParams) - 2), parameters);
end;

function MatchFunctionDeclarationTemplate(const src: String; var funcName, className, retType: String; var parameters: TList) : Boolean;
var braceLeft      : LongInt;
    braceRight     : LongInt;
    dotPos         : LongInt;
    i              : LongInt;
    semicolon      : LongInt;
    procDesc       : String;
    procParams     : String;
begin
  Result := False;
  for i := Length(src) downto 1 do
    if (src[i] = ':') then
      begin
        retType := Trim(retType);
        InvertString(retType);
        Result := IsCorrectTypeName(retType);
        semicolon := i;
        procDesc := Trim(Copy(src, 1, semicolon - 1));
        break;
      end
    else
      retType := retType + src[i];

  if Result then
    begin
      braceLeft := Pos('(', procDesc);
      braceRight := Pos(')', procDesc);

      if ((braceRight = Length(procDesc)) and (braceLeft > 0)) then
        begin
          procParams := Trim(Copy(procDesc, braceLeft + 1, braceRight - braceLeft - 1));
          procDesc := Trim(Copy(procDesc, 1, braceLeft - 1));
        end
      else if not ((braceRight = 0) and (braceLeft = 0)) then
        Result := False;

      dotPos := Pos('.', procDesc);
      if (dotPos > 0) then
        begin
          className := Copy(procDesc, 1, dotPos - 1);
          funcName := Copy(procDesc, dotPos + 1, Length(procDesc));
          Result := IsIdentifier(funcName) and IsIdentifier(className);
        end
      else
        begin
          funcName := procDesc;
          Result := IsIdentifier(funcName);
        end;

      if not Result then
        DisplayOutputMessage(0, LongInt(ExpressionLines[checkedLine]^), ERR_MSG_INCORRECT_PROC_NAME);

      if (Length(procParams) > 0) then
        Result := CheckParametersList(procParams, parameters);
    end;
end;

procedure CheckTypeSection;
var typeName   : String;
    typeId     : String;
    typesRead  : Boolean;
    recordNode : IXMLNode;
begin
  childNode := currentNode.AddChild('TypeSection', -1);
  typesRead := False;

  while (
    (checkedLine + 1 < ExpressionsList.Count)
      and
    (GetLineType(ExpressionsList[checkedLine + 1], typeName, typeId, recordNode))
  ) do
    begin
      childNode := childNode.AddChild('Type', -1);

      childNode.Attributes['name'] := typeName;
      childNode.Attributes['id'] := typeId;
      if (typeId = 'record') then
        begin
          recordNode.ParentNode.ChildNodes.Remove(recordNode);
          childNode.ChildNodes.Add(recordNode);
        end;

      childNode := childNode.ParentNode;

      typesRead := True;
      Inc(checkedLine);
    end;
    
  Inc(checkedLine);

  if not typesRead then
    DisplayOutputMessage(0, LongInt(ExpressionLines[checkedLine]^), ERR_MSG_VAR_DECLARATION_EXPECTED);
end;

procedure CheckProcedure;
var procName, className : String;
    parameters          : TList;
    i, j                : LongInt;
    paramListElement    : PSingleParameter;
    varNames            : TStringList;
    varType             : String;
    operatorNode        : IXMLNode;
    expectDefinition    : Boolean;
begin
  Inc(checkedLine);

  if (checkedLine < ExpressionsList.Count) then
    if MatchProcedureDeclarationTemplate(ExpressionsList[checkedLine], procName, className, parameters) then
      begin
        childNode := currentNode.AddChild('Procedure', -1);

        if (Length(className) > 0) then
          childNode.Attributes['namespace'] := className;
        childNode.Attributes['name'] := procName;

        // Add parameters info
        if Assigned(parameters) then
          begin
            childNode := childNode.AddChild('ParametersList', -1);

            for i := 0 to parameters.Count - 1 do
              begin
                paramListElement := parameters[i];

                for j := 0 to paramListElement^.parameterNames.Count - 1 do
                  begin
                    childNode := childNode.AddChild('Parameter', -1);

                    childNode.Attributes['name'] := paramListElement^.parameterNames[j];
                    childNode.Attributes['type'] := paramListElement^.parameterType;
                    if (Length(paramListElement^.attributes[j]) > 0) then
                      childNode.Attributes['modifier'] := paramListElement^.attributes[j];

                    childNode := childNode.ParentNode;
                  end;
              end;

            childNode := childNode.ParentNode;
          end;

        expectDefinition := False;
        // Check variables
        if (checkedLine + 1 < ExpressionsList.Count) and (UpperCase(ExpressionsList[checkedLine + 1]) = 'VAR') then
          begin
            expectDefinition := True;
            Inc(checkedLine);

            childNode := childNode.AddChild('VarSection', -1);
            while (
              (checkedLine + 1 < ExpressionsList.Count)
                and
              (GetLineVariable(ExpressionsList[checkedLine + 1], varNames, varType))
            ) do
              begin
                for i := 0 to varNames.Count - 1 do
                  begin
                    childNode := childNode.AddChild('Variable', -1);

                    childNode.Attributes['name'] := varNames[i];
                    childNode.Attributes['type'] := varType;

                    childNode := childNode.ParentNode;
                  end;

                Inc(checkedLine);
              end;

            childNode := childNode.ParentNode;
          end;

        // Check operators list
        if (checkedLine + 1 < ExpressionsList.Count) and (UpperCase(ExpressionsList[checkedLine + 1]) = 'BEGIN') then
          begin
            Inc(checkedLine);

            operatorNode := childNode.AddChild('ProcedureBody');
            ProcessSingleOperator(operatorNode);
          end
        else if expectDefinition then
          DisplayOutputMessage(0, LongInt(ExpressionLines[checkedLine]^), ERR_MSG_PROC_DEFINITION_EXPECTED);
      end;
end;

procedure CheckFunction;
var funcName, className : String;
    retType             : String;
    parameters          : TList;
    i, j                : LongInt;
    paramListElement    : PSingleParameter;
    varNames            : TStringList;
    varType             : String;
    operatorNode        : IXMLNode;
    expectDefinition    : Boolean;
begin
  Inc(checkedLine);

  if (checkedLine < ExpressionsList.Count) then
    if MatchFunctionDeclarationTemplate(ExpressionsList[checkedLine], funcName, className, retType, parameters) then
      begin
        childNode := currentNode.AddChild('Function', -1);

        if (Length(className) > 0) then
          childNode.Attributes['namespace'] := className;
        childNode.Attributes['name'] := funcName;
        childNode.Attributes['returnType'] := retType;

        // Add parameters info
        if Assigned(parameters) then
          begin
            childNode := childNode.AddChild('ParametersList', -1);

            for i := 0 to parameters.Count - 1 do
              begin
                paramListElement := parameters[i];

                for j := 0 to paramListElement^.parameterNames.Count - 1 do
                  begin
                    childNode := childNode.AddChild('Parameter', -1);

                    childNode.Attributes['name'] := paramListElement^.parameterNames[j];
                    childNode.Attributes['type'] := paramListElement^.parameterType;
                    if (Length(paramListElement^.attributes[j]) > 0) then
                      childNode.Attributes['modifier'] := paramListElement^.attributes[j];

                    childNode := childNode.ParentNode;
                  end;
              end;

              childNode := childNode.ParentNode;
          end;

        expectDefinition := False;
        // Check variables
        if (checkedLine + 1 < ExpressionsList.Count) and (UpperCase(ExpressionsList[checkedLine + 1]) = 'VAR') then
          begin
            expectDefinition := True;
            Inc(checkedLine);

            childNode := childNode.AddChild('VarSection', -1);
            while (
              (checkedLine + 1 < ExpressionsList.Count)
                and
              (GetLineVariable(ExpressionsList[checkedLine + 1], varNames, varType))
            ) do
              begin
                for i := 0 to varNames.Count - 1 do
                  begin
                    childNode := childNode.AddChild('Variable', -1);

                    childNode.Attributes['name'] := varNames[i];
                    childNode.Attributes['type'] := varType;

                    childNode := childNode.ParentNode;
                  end;

                Inc(checkedLine);
              end;

            childNode := childNode.ParentNode;
          end;

        // Check operators list
        if (checkedLine + 1 < ExpressionsList.Count) and (UpperCase(ExpressionsList[checkedLine + 1]) = 'BEGIN') then
          begin
            Inc(checkedLine);

            operatorNode := childNode.AddChild('FunctionBody');
            ProcessSingleOperator(operatorNode);
          end
        else if expectDefinition then
          DisplayOutputMessage(0, LongInt(ExpressionLines[checkedLine]^), ERR_MSG_FUNCTION_DEFINITION_EXPECTED);
      end;
end;

procedure CheckGlobalVariablesSection;
var varNames : TStringList;
    varType  : String;
    i        : LongInt;
    varsRead : Boolean;
begin
  childNode := currentNode.AddChild('VarSection', -1);
  varsRead := False;

  while (
    (checkedLine + 1 < ExpressionsList.Count)
      and
    (GetLineVariable(ExpressionsList[checkedLine + 1], varNames, varType))
  ) do
    begin
      for i := 0 to varNames.Count - 1 do
        begin
          childNode := childNode.AddChild('Variable', -1);

          childNode.Attributes['name'] := varNames[i];
          childNode.Attributes['type'] := varType;

          childNode := childNode.ParentNode;
        end;

      varsRead := True;
      Inc(checkedLine);
    end;

  if not varsRead then
    DisplayOutputMessage(0, LongInt(ExpressionLines[checkedLine]^), ERR_MSG_VAR_DECLARATION_EXPECTED);
end;

function GetLineType(const src: String; var typeName, typeId: String; var recordNode: IXMLNode) : Boolean;
var dividerPos : LongInt;
    i          : LongInt;
    isRecord   : Boolean;
    varsRead   : Boolean;
    fieldNode  : IXMLNode;
    varNames   : TStringList;
    varType    : String;
begin
  dividerPos := Pos('=', src);
  Result := (dividerPos > 0);

  isRecord := False;
  if Result then
    begin
      typeName := Trim(Copy(src, 1, dividerPos - 1));
      typeId := Trim(Copy(src, dividerPos + 1, Length(src)));

      isRecord := typeId = 'record';
      Result := IsIdentifier(typeName) and (IsCorrectTypeName(typeId) or isRecord);
    end;

  if (not Result) and ((not IsKeyword(1, src)) or (UpperCase(src) = 'END')) then
    DisplayOutputMessage(0, LongInt(ExpressionLines[checkedLine + 1]^), ERR_MSG_INVALID_TYPE_DECLARATION)
  else if isRecord then
    begin
      // Process as record
      varsRead := False;
      recordNode := childNode.AddChild('Record', -1);

      Inc(checkedLine);
      while (
        (checkedLine + 1 < ExpressionsList.Count)
          and
        (
          GetLineVariable(ExpressionsList[checkedLine + 1], varNames, varType)
            or
          (UpperCase(ExpressionsList[checkedLine + 1]) = 'END')
        )
      ) do
        begin
          Inc(checkedLine);

          if not (UpperCase(ExpressionsList[checkedLine]) = 'END') then
            begin
              for i := 0 to varNames.Count - 1 do
                begin
                  fieldNode := recordNode.AddChild('Field', -1);

                  fieldNode.Attributes['name'] := varNames[i];
                  fieldNode.Attributes['type'] := varType;
                end;

              varsRead := True;
            end
          else
            begin
              Dec(checkedLine);
              break;
            end;
        end;

      if not varsRead then
        DisplayOutputMessage(0, LongInt(ExpressionLines[checkedLine]^), ERR_MSG_VAR_DECLARATION_EXPECTED);
    end;
end;

function GetLineVariable(const src: String; var varNames : TStringList; var varType: String) : Boolean;
var dividerPos : LongInt;
    i          : LongInt;
    namePart   : String;
    typePart   : String;
    rangeStr   : String;
    arrayType  : String;
begin
  dividerPos := Pos(':', src);
  Result := (dividerPos > 0);

  if Result then
    begin
      namePart := Trim(Copy(src, 1, dividerPos - 1));
      typePart := Trim(Copy(src, dividerPos + 1, Length(src)));
    end;

  if Result then
    begin
      varNames := SplitBySubString(namePart, ',');
      for i := 0 to varNames.Count - 1 do
        if not IsIdentifier(varNames[i]) then
          begin
            Result := False;
            DisplayOutputMessage(0, LongInt(ExpressionLines[checkedLine + 1]^), ERR_MSG_INCORRECT_VAR_NAME);
            break;
          end;
    end;

  if Result then
    begin
      if IsCorrectTypeName(typePart) then
        varType := typePart
      else if ((UpperCase(typePart) = 'ARRAY') and (checkedLine + 3 < ExpressionsList.Count)) then
        begin
          Result := IsValidArrayDeclaration(
            ExpressionsList[checkedLine + 2], ExpressionsList[checkedLine + 3],
            rangeStr, arrayType
          );

          if Result then
            begin
              varType := typePart;
              Inc(checkedLine, 2);
            end;
          end
      else
        DisplayOutputMessage(0, LongInt(ExpressionLines[checkedLine + 1]^), ERR_MSG_INCORRECT_TYPE_NAME);
    end;
end;

function MatchConstTemplate(src: String; var constName, constType, constValue: String) : Boolean;
var divPos, typePos : LongInt;
begin
  divPos := Pos('=', src);
  typePos := Pos(':', src);

  Result := (divPos > 0);

  if Result then
    begin
      if (typePos > 0) then
        begin
          constType := Copy(src, typePos + 1, divPos - typePos - 1);
          constType := Trim(constType);

          constName := Copy(src, 1, typePos - 1);
          constName := Trim(constName);

          Result := IsIdentifier(constType) and IsIdentifier(constName);
        end
      else
        begin
          constName := Copy(src, 1, divPos - 1);
          constName := Trim(constName);
        end;

      constValue := Copy(src, divPos + 1, Length(src));
      constValue := Trim(constValue);
    end;
end;

procedure ParseCodeIntoExpressionsList;
var i, j              : LongInt;
    currentExpression : String;
    braceState        : LongInt;
    braceError        : Boolean;
begin
  ExpressionsList.Clear;
  ExpressionLines.Clear;
  currentExpression := EMPTY_STRING;
  braceState := 0;
  braceError := False;

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
                  if (Length(Trim(currentExpression)) > 0)  then
                    if (braceState = 0) then
                      begin
                        ExpressionsList.Add(Trim(currentExpression));
                        AddExpressionLine(i);
                        currentExpression := EMPTY_STRING;
                      end
                    else
                      currentExpression := currentExpression + ';';
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
                        (Pos('xo', currentExpression) <> Length(currentExpression) - 1) and
                        (Pos('sh', currentExpression) <> Length(currentExpression) - 1) and
                        (Pos('mo', currentExpression) <> Length(currentExpression) - 1) and
                        (Pos('di', currentExpression) <> Length(currentExpression) - 1) and
                        (Pos('no', currentExpression) <> Length(currentExpression) - 1)
                      ) then
                        begin
                          if (Length(Trim(currentExpression + CodeField.Lines[i][j])) > 0) then
                            begin
                              if (braceState = 0) then
                                begin
                                  ExpressionsList.Add(Trim(currentExpression + CodeField.Lines[i][j]));
                                  AddExpressionLine(i);
                                  currentExpression := EMPTY_STRING;
                                end
                              else
                                currentExpression := currentExpression + CodeField.Lines[i][j];
                            end;
                        end
                      else
                        currentExpression := currentExpression + CodeField.Lines[i][j];
                    end
                  else
                    begin
                      if not (Ord(CodeField.LineStyles[i][j]) in [TEXT_STYLE_COMMENT, TEXT_STYLE_MULTILINE_COMMENT, TEXT_STYLE_STRING]) then
                        begin
                          if (CodeField.Lines[i][j] = '(') then
                            Inc(braceState)
                          else if (CodeField.Lines[i][j] = ')') then
                            Dec(braceState);

                          if (braceState < 0) then
                            braceError := True;
                        end;

                      currentExpression := currentExpression + CodeField.Lines[i][j];
                    end;
                end;

            end;

          Inc(j);
        end;
    end;

    ExpressionsList.Add(currentExpression);
    AddExpressionLine(CodeField.Lines.Count);

    i := 0;
    while (i < ExpressionsList.Count) do
      begin
        if (Pos('ELSE', UpperCase(ExpressionsList[i])) = Length(ExpressionsList[i]) - 3) then
          begin
            currentExpression := Trim(Copy(ExpressionsList[i], 1, Length(ExpressionsList[i]) - 4));
            if (Length(currentExpression) > 0) then
              begin
                ExpressionsList[i] := currentExpression;
                ExpressionsList.Insert(i + 1, 'else');
                ExpressionLines.Insert(i + 1, ExpressionLines[i]);
                Inc(i);
              end;
          end;

        Inc(i);
      end;

    if (braceError or (braceState <> 0)) then
      DisplayOutputMessage(0, CodeField.Lines.Count, ERR_MSG_BRACES_COUNT);
end;

procedure CheckExpressionsList;
var
  variablesDefined   : LongInt;
  varName, varType   : String;
  varValue           : String;
begin
  checkedLine := 0;
  currentNode := XmlMainNode;

  while (checkedLine < ExpressionsList.Count) do
    begin
      if (Length(ExpressionsList[checkedLine]) > 0) then
        begin
          if (IsKeyword(1, ExpressionsList[checkedLine])) then
            begin
              if (UpperCase(ExpressionsList[checkedLine]) = 'PROGRAM') then
                ParseProgramSection
              else if (UpperCase(ExpressionsList[checkedLine]) = 'USES') then
                CheckUsesSection
              else if (UpperCase(ExpressionsList[checkedLine]) = 'TYPE') then
                CheckTypeSection
              else if (UpperCase(ExpressionsList[checkedLine]) = 'VAR') then
                CheckGlobalVariablesSection
              else if (UpperCase(ExpressionsList[checkedLine]) = 'CONST') then
                begin
                  variablesDefined := 0;
                  currentNode := currentNode.AddChild('ConstSection', -1);

                  varType := EMPTY_STRING;
                  Inc(checkedLine);
                  while (
                    (checkedLine < ExpressionsList.Count)
                      and
                    (MatchConstTemplate(ExpressionsList[checkedLine], varName, varType, varValue))
                  ) do
                    begin
                      Inc(variablesDefined);

                      childNode := currentNode.AddChild('Const', -1);
                      childNode.Attributes['name'] := varName;
                      if (Length(varType) > 0) then
                        childNode.Attributes['type'] := varType;
                      childNode.Attributes['value'] := varValue;

                      varType := EMPTY_STRING;
                      Inc(checkedLine);
                    end;

                  // Exit from variable section
                  currentNode := currentNode.ParentNode;

                  if (variablesDefined = 0) then
                    DisplayOutputMessage(0, LongInt(ExpressionLines[checkedLine]^), ERR_MSG_CONST_DECLARATION_EXPECTED);
               end
              else if (UpperCase(ExpressionsList[checkedLine]) = 'PROCEDURE') then
                CheckProcedure
              else if (UpperCase(ExpressionsList[checkedLine]) = 'FUNCTION') then
                CheckFunction
              else
                begin
                  childNode := currentNode.AddChild('UnhandledKeyword', -1);
                  childNode.Attributes['id'] := ExpressionsList[checkedLine];
                  Inc(checkedLine);
                end;
            end
          else
            begin
              childNode := currentNode.AddChild('UnhandledExpression', -1);
              childNode.Attributes['text'] := ExpressionsList[checkedLine];
              Inc(checkedLine);
            end;
        end
      else
        break;
    end;
end;

procedure BuildCodeXmlModel;
begin
  CheckElseErrors;
  ParseCodeIntoExpressionsList;
  CheckExpressionsList;
end;

procedure ParseProgramSection;
var programNode : IXMLNOde;
begin
  if (checkedLine + 1 < ExpressionsList.Count) then
    begin
      Inc(checkedLine);

      if not IsIdentifier(ExpressionsList[checkedLine]) then
        DisplayOutputMessage(
          0, LongInt(ExpressionLines[checkedLine]^),
          ExpressionsList[checkedLine] + ERR_MSG_INCORRECT_IDENTIFIER_NAME
        )
      else
        begin
          // Add program description to DOM
          programNode := XmlMainNode.AddChild('ProgramSection', -1);
          programNode.Attributes['name'] := ExpressionsList[checkedLine];

          Inc(checkedLine);
        end;
    end
  else
    DisplayOutputMessage(
      0, 0,
      'Ожидалось описание секции ' + #39 + 'PROGRAM' + #39 + ', конец файла достигнут'
    );
end;

procedure TXmlCodeForm.FormResize(Sender: TObject);
begin
  DisplayXmlMemo.Left := 5;
  DisplayXmlMemo.Top := 35;
  DisplayXmlMemo.Width := ClientWidth - 10;
  DisplayXmlMemo.Height := ClientHeight - 80;

  ShowCheckStatusBtn.Top := ClientHeight - ShowCheckStatusBtn.Height - 5;
end;

procedure TXmlCodeForm.FormCreate(Sender: TObject);
begin
  ExpressionsList := TStringList.Create;
  ExpressionLines := TList.Create;

  CreateXmlDocument;
end;

procedure TXmlCodeForm.Button1Click(Sender: TObject);
begin
  ErrorDisplayForm.Show;
end;

function IsRangeValid(src: String) : Boolean;
var rangeParts : TStringList;
    left       : LongInt;
    right      : LongInt;
begin
  Result := (Length(src) > 2) and (src[1] = '[') and (src[Length(src)] = ']');

  if Result then
    begin
      src := Copy(src, 2, Length(src) - 2);
      rangeParts := SplitBySubString(src, '..');
      if (rangeParts.Count = 2) then
        begin
          Result := IsNumber(rangeParts[0], left) and IsNumber(rangeParts[1], right);

          if Result then
            begin
              Result := left <= right;

              if not Result then
                DisplayOutputMessage(0, LongInt(ExpressionLines[checkedLine]^), ERR_MSG_RANGE_BORDERS);
            end;
        end;
    end;

  if not Result then
    DisplayOutputMessage(0, LongInt(ExpressionLines[checkedLine]^), 'Неверно задан диапазон');
end;

procedure CheckElseErrors;
var i, j, k, offset, pos : LongInt;
    found             : Boolean;
begin
  for i := 0 to CodeField.Lines.Count - 1 do
    begin
      offset := 1;

      repeat
        pos := PosEx('ELSE', UpperCase(CodeField.Lines[i]), offset);

        if (pos > 0) then
          begin
            if (CodeField.LineStyles[i][pos] = TextStyle(TEXT_STYLE_KEYWORD)) then
              begin
                found := False;

                k := i;
                Dec(pos);

                while ((not found) and (k >= 0)) do
                  begin
                    for j := pos downto 1 do
                      if (Ord(CodeField.Lines[k][j]) > KEY_SPACE) then
                        begin
                          if (CodeField.Lines[k][j] = ';') then
                            DisplayOutputMessage(0, k, ERR_MSG_ELSE);

                          found := True;
                          break;
                        end;

                    Dec(k);

                    if (k >= 0) then
                      pos := Length(CodeField.Lines[k]);
                  end;
              end;

            Inc(offset, 4);
          end;

      until (pos = 0);
    end;
end;

procedure AddExpressionLine(const line: LongInt);
var expressionLine : ^LongInt;
begin
  New(expressionLine);
  expressionLine^ := line;
  ExpressionLines.Add(expressionLine);
end;

procedure ParseXmlToMemo;
//var i : LongInt;
begin
  with XmlCodeFrame do
    begin
      XMLDocument.Active := True;
      
      if Assigned(XmlMainNode) then
        DisplayXmlMemo.Lines.Add(ParseNodeText(XmlMainNode, 0));

      XMLDocument.Active := False;
    end;
end;

{FUNCTIONS, THAT ARE OBVIOUSLY CORRECT}

function GetParameter(const src: String; var success: Boolean) : PSingleParameter;
var paramParts : String;
    breaker    : LongInt;
    i          : LongInt;
    paramsList : TStringList;
    keyword    : String;
begin
  New(Result);
  Result^.parameterNames := TStringList.Create;
  Result^.attributes := TStringList.Create;

  breaker := Pos(':', src);
  if (breaker > 0) then
    begin
      Result^.parameterType := Trim(Copy(src, breaker + 1, Length(src)));
      paramParts := Trim(Copy(src, 1, breaker - 1));
      success := IsCorrectTypeName(Result^.parameterType);
    end
  else
    success := False;

  if success then
    begin
      paramsList := SplitBySubString(paramParts, ',');

      for i := 0 to paramsList.Count - 1 do
        begin
          if not IsIdentifier(paramsList[i]) then
            begin
              // Check keyword prefix
              keyword := EMPTY_STRING;
              if (Pos('CONST ', UpperCase(paramsList[i])) = 1) then
                keyword := 'const'
              else if (Pos('VAR ', UpperCase(paramsList[i])) = 1) then
                keyword := 'var';

              if (Length(keyword) > 0) then
                begin
                  paramsList[i] := Trim(Copy(paramsList[i], Length(keyword) + 1, Length(paramsList[i])));
                  success := IsIdentifier(paramsList[i]);
                end
              else
                begin
                  success := False;
                  break;
                end;
            end;

          if success then
            begin
              Result^.parameterNames.Add(paramsList[i]);

              if (Length(keyword) > 0) then
                Result^.attributes.Add(keyword)
              else
                Result^.attributes.Add(EMPTY_STRING);
            end;
        end;
    end;
end;

procedure CheckUsesSection;
var modules : TStringList;
    i       : LongInt;
begin
  childNode := currentNode.AddChild('UsesSection', -1);
  
  if (checkedLine + 1 < ExpressionsList.Count) then
    begin
      Inc(checkedLine);

      modules := SplitBySubString(ExpressionsList[checkedLine], ',');

      if (modules.Count > 0) then
        begin
          for i := 0 to modules.Count - 1 do
            if (IsModuleName(modules[i])) then
              begin
                childNode := childNode.AddChild('Module', -1);

                childNode.Attributes['name'] := modules[i];

                childNode := childNode.ParentNode;
              end
            else
              DisplayOutputMessage(0, LongInt(ExpressionLines[checkedLine]^), ERR_MSG_INCORRECT_IDENTIFIER_NAME);

          Inc(checkedLine);
        end
      else
        DisplayOutputMessage(0, LongInt(ExpressionLines[checkedLine]^), ERR_MSG_NO_USES_MODULE_DEFINED);
    end;
end;

function CheckParametersList(const src: String; var params: TList) : Boolean;
var temp       : String;
    i          : LongInt;
    parameter  : PSingleParameter;
    success    : Boolean;
    paramsList : TStringList;
begin
  Result := True;

  params := TList.Create;
  temp := EMPTY_STRING;

  // Parse by ';'
  paramsList := SplitBySubString(src, ';');

  for i := 0 to paramsList.Count - 1 do
    begin
      parameter := GetParameter(paramsList[i], success);

      if not success then
        begin
          Result := False;
          break;
        end
      else
        params.Add(parameter);
    end;

  if not Result then
    DisplayOutputMessage(0, LongInt(ExpressionLines[checkedLine]^), ERR_MSG_PROC_PARAMS);
end;

function ParseNodeText(node: IXMLNode; tabSize: LongInt) : String;
var hasChildren: Boolean;
    childrenString, attributes, tabs: String;
    nodeList : IXMLNodeList;
    i: LongInt;
    tempText : String;
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
        attributes := attributes + #32 +
                      node.AttributeNodes[i].NodeName + '="' +
                      node.AttributeNodes[i].NodeValue + '"';

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

procedure RefreshXmlDocument;
begin
  XmlCodeFrame.DisplayXmlMemo.Clear;
  ClearXmlDocument;

  BuildCodeXmlModel;

  ParseXmlToMemo;
end;

procedure ClearXmlDocument;
var i : LongInt;
begin
  if Assigned(XmlMainNode) then
    for i := 0 to XmlMainNode.ChildNodes.Count - 1 do
      XmlMainNode.ChildNodes.Remove(XmlMainNode.ChildNodes[0]);
end;

procedure CreateXmlDocument;
begin
  with XmlCodeFrame do
    begin
      XMLDocument.Active := True;

      XmlMainNode := XMLDocument.CreateNode('DelphiDocument', ntElement, '');
      XMLDocument.DocumentElement := XmlMainNode;

      XMLDocument.Active := False;
    end;
end;

function IsValidArrayDeclaration(const rangePart, typePart: String; var rangeStr, arrayType: String) : Boolean;
var ofPos    : LongInt;
begin
  arrayType := typePart;
  Result := IsCorrectTypeName(arrayType);

  if Result then
    begin
      ofPos := Pos('of', rangePart);

      if (ofPos > 0) and (ofPos = (Length(rangePart) - 1)) then
        begin
          rangeStr := Trim(Copy(rangePart, 1, ofPos - 1));
          Result := IsRangeValid(rangeStr);
        end
      else
        Result := False;
    end;
end;

function SplitBySubString(const src, substr: String) : TStringList;
var breakerPos   : LongInt;
    searchOffset : LongInt;
begin
  Result := TStringList.Create;

  searchOffset := 1;
  repeat
    breakerPos := PosEx(substr, src, searchOffset);

    if (breakerPos > 0) then
      Result.Add(Trim(Copy(src, searchOffset, breakerPos - searchOffset)))
    else
      Result.Add(Trim(Copy(src, searchOffset, Length(src))));

    searchOffset := breakerPos + Length(substr);
  until (breakerPos = 0);
end;

end.
