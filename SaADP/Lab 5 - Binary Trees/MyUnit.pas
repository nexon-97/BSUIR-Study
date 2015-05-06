unit MyUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, System.Types, Vcl.StdCtrls, Vcl.ExtDlgs, Vcl.ComCtrls;

const
  FONT_NAME = 'Cambria';
  FONT_SIZE = 13;
  NODE_RADIUS = 35;
  TOP_OFFSET = 50;
  LEVELS_OFFSET = 2;
  NODE_COLOR = $FF9400;
  NODE_PROCESS_COLOR = $006AFF;
  NODE_PASS_COLOR = $66E5FF;
  RIGHT_PADDING = 320;
  TREE_IMAGE_MAX_SIZE = 5000;
  INPUT_FILE = 'inputData.txt';

  LEFT_DETOUR_MODE = 1;
  RIGHT_DETOUR_MODE = 2;
  SYMMETRIC_DETOUR_MODE = 3;

type
  TTreePtr = ^TTree;
  TTree = record
    data: LongInt;
    left, right: TTreePtr;
  end;

type
  TMyForm = class(TForm)
    TreeViewer: TScrollBox;
    TreeImage: TImage;
    ActionsBox: TGroupBox;
    LeftDetourBtn: TButton;
    RightDetourBtn: TButton;
    SymmetricDetourBtn: TButton;
    LoadTreeBtn: TButton;
    DeleteTreeBtn: TButton;
    TreeOpenFileDialog: TOpenTextFileDialog;
    VertexEdit: TEdit;
    AddVertexBtn: TButton;
    DetourLabel: TLabel;
    AnimationTimer: TTimer;
    AnimProgressBar: TProgressBar;
    VisualizationLabel: TLabel;
    DataLabel: TLabel;
    TimerDelayEdit: TEdit;
    Label2: TLabel;
    SetTimerTickBtn: TButton;
    StopAnimBtn: TButton;
    StitchBtn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure DeleteTreeBtnClick(Sender: TObject);
    procedure LoadTreeBtnClick(Sender: TObject);
    procedure AddVertexBtnClick(Sender: TObject);
    procedure LeftDetourBtnClick(Sender: TObject);
    procedure RightDetourBtnClick(Sender: TObject);
    procedure SymmetricDetourBtnClick(Sender: TObject);
    procedure AnimationTimerTimer(Sender: TObject);
    procedure SetTimerTickBtnClick(Sender: TObject);
    procedure StopAnimBtnClick(Sender: TObject);
    procedure StitchBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function CreateTree(data: LongInt) : TTreePtr;
function GetTreeDepth(tree: TTreePtr) : LongInt;
procedure ClearCanvas;
procedure DrawTree(tree: TTreePtr; depth, x, y: LongInt);
procedure AddBinarySearchTreeElement(tree: TTreePtr; data: LongInt);
procedure LoadInputFile(path: String);
procedure LeftDetour(tree: TTreePtr);
procedure RightDetour(tree: TTreePtr);
procedure SymmetricDetour(tree: TTreePtr);
procedure EnableControlButtons(enable: Boolean);
procedure StitchTree(tree: TTreePtr);

var
  MyForm: TMyForm;
  myTree: TTreePtr;
  treeDepth: LongInt;
  horizSection, verticalSection: LongInt;
  activeAnimation: Byte;
  myAnimationTree: TTreePtr;
  currentAnimTree: LongInt;
  animationSequence: TList;
  animCheckState: TList;
  animDataValues: TStringList;
  bytePointers: array [0..1] of Byte;

implementation

{$R *.dfm}

procedure EnableControlButtons(enable: Boolean);
begin
  MyForm.LeftDetourBtn.Enabled := enable;
  MyForm.RightDetourBtn.Enabled := enable;
  MyForm.SymmetricDetourBtn.Enabled := enable;
  MyForm.LoadTreeBtn.Enabled := enable;
  MyForm.DeleteTreeBtn.Enabled := enable;
  MyForm.VertexEdit.Enabled := enable;
  MyForm.AddVertexBtn.Enabled := enable;
  MyForm.DataLabel.Enabled := enable;
  MyForm.StitchBtn.Enabled := enable;
end;

procedure LeftDetour(tree: TTreePtr);
var dataStr : String;
begin
  if Assigned(tree) then
    begin
      animationSequence.Add(tree);
      animCheckState.Add(@bytePointers[1]);
      dataStr := IntToStr(tree^.data);
      animDataValues.Add(dataStr + '*, ');

      LeftDetour(tree^.left);
      animDataValues.Add(dataStr + ', ');
      animationSequence.Add(tree);
      animCheckState.Add(@bytePointers[0]);

      LeftDetour(tree^.right);
      animDataValues.Add(dataStr + ', ');
      animationSequence.Add(tree);
      animCheckState.Add(@bytePointers[0]);
    end
  else
    begin
      animDataValues.Add('~, ');
      animationSequence.Add(nil);
      animCheckState.Add(@bytePointers[0]);
    end;
end;

procedure RightDetour(tree: TTreePtr);
var dataStr : String;
begin
  if Assigned(tree) then
    begin
      animationSequence.Add(tree);
      animCheckState.Add(@bytePointers[0]);
      dataStr := IntToStr(tree^.data);
      animDataValues.Add(dataStr + ', ');

      RightDetour(tree^.left);
      animDataValues.Add(dataStr + ', ');
      animationSequence.Add(tree);
      animCheckState.Add(@bytePointers[0]);
      RightDetour(tree^.right);
      animDataValues.Add(dataStr + '*, ');
      animationSequence.Add(tree);
      animCheckState.Add(@bytePointers[1]);
    end
  else
    begin
      animDataValues.Add(dataStr + '~, ');
      animationSequence.Add(nil);
      animCheckState.Add(@bytePointers[0]);
    end;
end;

procedure SymmetricDetour(tree: TTreePtr);
var dataStr : String;
begin
  if Assigned(tree) then
    begin
      animationSequence.Add(tree);
      animCheckState.Add(@bytePointers[0]);
      dataStr := IntToStr(tree^.data);
      animDataValues.Add(dataStr + ', ');

      SymmetricDetour(tree^.left);
      animDataValues.Add(dataStr + '*, ');
      animationSequence.Add(tree);
      animCheckState.Add(@bytePointers[1]);
      SymmetricDetour(tree^.right);
      animDataValues.Add(dataStr + ', ');
      animationSequence.Add(tree);
      animCheckState.Add(@bytePointers[0]);
    end
  else
    begin
      animDataValues.Add(dataStr + '~, ');
      animationSequence.Add(nil);
      animCheckState.Add(@bytePointers[0]);
    end;
end;

procedure StitchTree(tree: TTreePtr);
begin

end;

procedure LoadInputFile(path: String);
var f: TextFile;
    i, n, a: LongInt;
begin
  AssignFile(f, path);
  Reset(f);

  Read(f, n);
  if (n > 0) then
    begin
      Read(f, a);
      myTree := CreateTree(a);
      for i := 2 to n do
        begin
          Read(f, a);
          AddBinarySearchTreeElement(myTree, a);
        end;
    end
  else
    MessageBox(MyForm.Handle, 'Неверно задано дерево!', 'Ошибка ввода', MB_ICONERROR);

  CloseFile(f);
end;

procedure AddBinarySearchTreeElement(tree: TTreePtr; data: LongInt);
begin
  if Assigned(tree) then
    begin
      if (data <= tree^.data) then
        if not Assigned(tree^.left) then
          tree^.left := CreateTree(data)
        else
          AddBinarySearchTreeElement(tree^.left, data)
      else
        if not Assigned(tree^.right) then
          tree^.right := CreateTree(data)
        else
          AddBinarySearchTreeElement(tree^.right, data);
    end;
end;

function GetTreeDepth(tree: TTreePtr) : LongInt;
var l, r: LongInt;
begin
  Result := 0;

  if Assigned(tree) then
    begin
      l := GetTreeDepth(tree^.left);
      r := GetTreeDepth(tree^.right);
      if (l > r) then Result := l + 1
      else            Result := r + 1;
    end;
end;

procedure ClearCanvas;
begin
  with MyForm.TreeImage.Canvas do
    begin
      Pen.Color := MyForm.Color;
      Brush.Color := MyForm.Color;
      Rectangle(0, 0, MyForm.TreeImage.Width, MyForm.TreeImage.Height);
    end;
end;

procedure DrawTree(tree: TTreePtr; depth, x, y: LongInt);
var t: String;
    nodePos: TPoint;
    sectionSize: LongInt;
    b: ^Boolean;
begin
  if Assigned(tree) then
    begin
      sectionSize := MyForm.TreeImage.Width div (1 shl y);
      nodePos := Point(x * sectionSize, (y - 1) * verticalSection + NODE_RADIUS + LEVELS_OFFSET);

      if Assigned(tree^.left) then
        begin
          MyForm.TreeImage.Canvas.MoveTo(nodePos.x, nodePos.y);
          MyForm.TreeImage.Canvas.LineTo(nodePos.x - sectionSize div 2, y * verticalSection + NODE_RADIUS + LEVELS_OFFSET);
          DrawTree(tree^.left, depth, x * 2 - 1, y + 1);
        end;
      if Assigned(tree^.right) then
        begin
          MyForm.TreeImage.Canvas.MoveTo(nodePos.x, nodePos.y);
          MyForm.TreeImage.Canvas.LineTo(nodePos.x + sectionSize div 2, y * verticalSection + NODE_RADIUS + LEVELS_OFFSET);
          DrawTree(tree^.right, depth, x * 2 + 1, y + 1);
        end;

      if (myAnimationTree = tree) then
        if (animCheckState[currentAnimTree] = @bytePointers[1]) then
          MyForm.TreeImage.Canvas.Brush.Color := NODE_PROCESS_COLOR
        else
          MyForm.TreeImage.Canvas.Brush.Color := NODE_PASS_COLOR
      else
        MyForm.TreeImage.Canvas.Brush.Color := NODE_COLOR;
      
      MyForm.TreeImage.Canvas.Ellipse(
        nodePos.x - NODE_RADIUS div 2, nodePos.y - NODE_RADIUS div 2,
        nodePos.x + NODE_RADIUS div 2, nodePos.y + NODE_RADIUS div 2
      );
      t := IntToStr(tree^.data);
      MyForm.TreeImage.Canvas.TextOut(
        nodePos.x - MyForm.TreeImage.Canvas.TextWidth(t) div 2,
        nodePos.y + MyForm.TreeImage.Canvas.Font.Height div 2 - 3,
        t
      );
    end;
end;

function CreateTree(data: LongInt) : TTreePtr;
begin
  New(Result);
  Result^.data := data;
  Result^.left := nil;
  Result^.right := nil;
end;

procedure TMyForm.AddVertexBtnClick(Sender: TObject);
begin
  if Assigned(myTree) then
    AddBinarySearchTreeElement(myTree, StrToInt(VertexEdit.Text))
  else
    mYTree := CreateTree(StrToInt(VertexEdit.Text));

  Refresh;
end;

procedure TMyForm.AnimationTimerTimer(Sender: TObject);
var t: String;
begin
  // Timer click process
  if (activeAnimation in [1..3]) then
    begin
      Inc(currentAnimTree);
      if (currentAnimTree >= animationSequence.Count) then
        begin
          animationSequence.Clear;
          animCheckState.Clear;
          animDataValues.Clear;
          currentAnimTree := -1;
          myAnimationTree := nil;
          EnableControlButtons(True);

          AnimProgressBar.Enabled := False;
          AnimProgressBar.Position := 0;
          AnimProgressBar.Visible := False;
          VisualizationLabel.Visible := False;
          StopAnimBtn.Visible := False;
        end
      else
        begin
          myAnimationTree := animationSequence[currentAnimTree];

          if (currentAnimTree = animationSequence.Count - 1) then
            begin
              t := animDataValues[currentAnimTree];
              SetLength(t, Length(t) - 2);
              animDataValues[currentAnimTree] := t;
            end;

          MyForm.DetourLabel.Caption := MyForm.DetourLabel.Caption + animDataValues[currentAnimTree];
          AnimProgressBar.Position := ((currentAnimTree + 1) * 1000) div animationSequence.Count;
        end;

      Refresh;
    end;
end;

procedure TMyForm.DeleteTreeBtnClick(Sender: TObject);
begin
  myTree := nil;
  DetourLabel.Caption := '';

  Refresh;
end;

procedure TMyForm.FormCreate(Sender: TObject);
begin
  TreeViewer.Top := TOP_OFFSET;
  TreeViewer.Width := ClientWidth - RIGHT_PADDING;
  TreeViewer.Height := ClientHeight - 15;
  TreeImage.Width := TREE_IMAGE_MAX_SIZE;
  TreeImage.Height := TREE_IMAGE_MAX_SIZE;
  DetourLabel.Left := 10;
  DetourLabel.Top := 10;
  DetourLabel.Caption := '';

  LoadInputFile(INPUT_FILE);

  animationSequence := TList.Create;
  animCheckState := TList.Create;
  animDataValues := TStringList.Create;
  myAnimationTree := nil;
  currentAnimTree := -1;

  AnimProgressBar.Enabled := False;

  Refresh;
end;

procedure TMyForm.FormPaint(Sender: TObject);
var needWidth: LongInt;
begin
  ClearCanvas;

  TreeImage.Canvas.Brush.Color := NODE_COLOR;
  TreeImage.Canvas.Pen.Color := clBlack;
  TreeImage.Canvas.Pen.Width := 2;
  TreeImage.Canvas.Font.Name := FONT_NAME;
  TreeImage.Canvas.Font.Size := FONT_SIZE;

  treeDepth := GetTreeDepth(myTree);
  needWidth := (NODE_RADIUS + 2) * (1 shl (treeDepth - 1));
  verticalSection := (ClientHeight - 80) div (treeDepth + 1);

  if (TreeViewer.Width > needWidth) then
    needWidth := TreeViewer.Width;
  TreeImage.Width := needWidth;
  TreeImage.Height := treeDepth * verticalSection + NODE_RADIUS + LEVELS_OFFSET;

  DrawTree(myTree, treeDepth, 1, 1);
end;

procedure TMyForm.FormResize(Sender: TObject);
begin
  TreeViewer.Width := ClientWidth - RIGHT_PADDING - 10;
  TreeViewer.Height := ClientHeight - 15 - TOP_OFFSET;

  ActionsBox.Left := TreeViewer.Left + TreeViewer.Width + 10;
  ActionsBox.Top := TreeViewer.Top;
  ActionsBox.Height := TreeViewer.Height;
end;

procedure TMyForm.LeftDetourBtnClick(Sender: TObject);
begin
  DetourLabel.Caption := 'Прямой обход: ';

  EnableControlButtons(False);
  activeAnimation := LEFT_DETOUR_MODE;
  AnimProgressBar.Enabled := True;
  AnimProgressBar.Visible := True;
  VisualizationLabel.Visible := True;
  StopAnimBtn.Visible := True;

  LeftDetour(myTree);
end;

procedure TMyForm.LoadTreeBtnClick(Sender: TObject);
var path: String;
begin
  if (TreeOpenFileDialog.Execute) then
    begin
      path := TreeOpenFileDialog.FileName;

      if FileExists(path) then
        begin
          DeleteTreeBtnClick(nil);
          LoadInputFile(path);
        end;
    end;
end;

procedure TMyForm.RightDetourBtnClick(Sender: TObject);
begin
  DetourLabel.Caption := 'Обратный обход: ';

  EnableControlButtons(False);
  activeAnimation := RIGHT_DETOUR_MODE;
  AnimProgressBar.Enabled := True;
  AnimProgressBar.Visible := True;
  VisualizationLabel.Visible := True;
  StopAnimBtn.Visible := True;

  RightDetour(myTree);
end;

procedure TMyForm.SetTimerTickBtnClick(Sender: TObject);
begin
  AnimationTimer.Interval := StrToInt(TimerDelayEdit.Text);
end;

procedure TMyForm.StitchBtnClick(Sender: TObject);
begin
  StitchTree(myTree);
end;

procedure TMyForm.StopAnimBtnClick(Sender: TObject);
begin
  currentAnimTree := animationSequence.Count;
end;

procedure TMyForm.SymmetricDetourBtnClick(Sender: TObject);
begin
  DetourLabel.Caption := 'Симметричный обход: ';

  EnableControlButtons(False);
  activeAnimation := SYMMETRIC_DETOUR_MODE;
  AnimProgressBar.Enabled := True;
  AnimProgressBar.Visible := True;
  VisualizationLabel.Visible := True;
  StopAnimBtn.Visible := True;

  SymmetricDetour(myTree);
end;

end.
