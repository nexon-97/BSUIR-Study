unit StyleConfiguratorUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, UnitMain, ComCtrls;

type
  TStyleConfiguratorForm = class(TForm)
    GroupBox1: TGroupBox;
    LangListBox: TListBox;
    Label1: TLabel;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    StyleOptionListBox: TListBox;
    GroupBox3: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    FontColorPreview: TImage;
    BackColorPreview: TImage;
    Label5: TLabel;
    SaveStyleBtn: TButton;
    ApplyStyleBtn: TButton;
    CancelBtn: TButton;
    GroupBox4: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    FontPickerBox: TComboBox;
    fsBoldCheckBox: TCheckBox;
    fsItalicCheckBox: TCheckBox;
    fsUnderlineCheckBox: TCheckBox;
    Label8: TLabel;
    FontSizeEdit: TEdit;
    FontSizeUpDown: TUpDown;
    textColorPicker: TColorDialog;
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure StyleOptionListBoxClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ApplyStyleBtnClick(Sender: TObject);
    procedure SaveStyleBtnClick(Sender: TObject);
    procedure fsBoldCheckBoxClick(Sender: TObject);
    procedure fsItalicCheckBoxClick(Sender: TObject);
    procedure fsUnderlineCheckBoxClick(Sender: TObject);
    procedure FontColorPreviewClick(Sender: TObject);
    procedure BackColorPreviewClick(Sender: TObject);
    procedure FontPickerBoxChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  StyleConfiguratorForm : TStyleConfiguratorForm;
  newCodeStyles         : array of TFontStyle;

implementation

{$R *.dfm}

procedure TStyleConfiguratorForm.FormCreate(Sender: TObject);
begin
  SetLength(newCodeStyles, DELPHI_STYLES_COUNT);

  LangListBox.ItemIndex := 5;

  FontColorPreview.Canvas.Pen.Width := 2;
  BackColorPreview.Canvas.Pen.Width := 2;
end;

procedure TStyleConfiguratorForm.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TStyleConfiguratorForm.StyleOptionListBoxClick(Sender: TObject);
begin
  FontColorPreview.Canvas.Brush.Color := newCodeStyles[StyleOptionListBox.ItemIndex].textColor;
  FontColorPreview.Canvas.Rectangle(1, 1, 39, 39);

  BackColorPreview.Canvas.Brush.Color := newCodeStyles[StyleOptionListBox.ItemIndex].backColor;
  BackColorPreview.Canvas.Rectangle(1, 1, 39, 39);

  fsBoldCheckBox.Checked := newCodeStyles[StyleOptionListBox.ItemIndex].bold;
  fsItalicCheckBox.Checked := newCodeStyles[StyleOptionListBox.ItemIndex].italic;
  fsUnderlineCheckBox.Checked := newCodeStyles[StyleOptionListBox.ItemIndex].underlined;
end;

procedure TStyleConfiguratorForm.FormActivate(Sender: TObject);
var i : LongInt;
begin
  for i := 0 to High(newCodeStyles) do
    newCodeStyles[i] := fontStyles[i];

  StyleOptionListBox.ItemIndex := 0;
  StyleOptionListBoxClick(nil);
end;

procedure TStyleConfiguratorForm.ApplyStyleBtnClick(Sender: TObject);
var i : LongInt;
begin
  for i := 0 to High(newCodeStyles) do
    fontStyles[i] := newCodeStyles[i];

  CodeField.Refresh;
end;

procedure TStyleConfiguratorForm.SaveStyleBtnClick(Sender: TObject);
var configFile : TextFile;
    i          : LongInt;
    a, b, c    : Byte;
begin
  ApplyStyleBtnClick(nil);
  CancelBtnClick(nil);

  // Save configs to file
  AssignFile(configFile, CODE_VIEWER_STYLE_FILE);
  Rewrite(configFile);

  for i := 0 to High(newCodeStyles) do
    begin
      WriteLn(configFile, fontStyles[i].fontName);
      WriteLn(configFile, fontStyles[i].fontSize);

      a := 0;
      b := 0;
      c := 0;
      if fontStyles[i].bold       then a := 1;
      if fontStyles[i].italic     then b := 1;
      if fontStyles[i].underlined then c := 1;
      WriteLn(configFile, a);
      WriteLn(configFile, b);
      WriteLn(configFile, c);
      
      WriteLn(configFile, fontStyles[i].textColor);
      WriteLn(configFile, fontStyles[i].backColor);
      WriteLn(configFile);
    end;

  CloseFile(configFile);
end;

procedure TStyleConfiguratorForm.fsBoldCheckBoxClick(Sender: TObject);
begin
  newCodeStyles[StyleOptionListBox.ItemIndex].bold := fsBoldCheckBox.Checked;
end;

procedure TStyleConfiguratorForm.fsItalicCheckBoxClick(Sender: TObject);
begin
  newCodeStyles[StyleOptionListBox.ItemIndex].italic := fsItalicCheckBox.Checked;
end;

procedure TStyleConfiguratorForm.fsUnderlineCheckBoxClick(Sender: TObject);
begin
  newCodeStyles[StyleOptionListBox.ItemIndex].underlined := fsUnderlineCheckBox.Checked;
end;

procedure TStyleConfiguratorForm.FontColorPreviewClick(Sender: TObject);
begin
  // Pick color
  textColorPicker.Color := newCodeStyles[StyleOptionListBox.ItemIndex].textColor;

  if textColorPicker.Execute then
    newCodeStyles[StyleOptionListBox.ItemIndex].textColor := textColorPicker.Color;

  StyleOptionListBoxClick(nil);
end;

procedure TStyleConfiguratorForm.BackColorPreviewClick(Sender: TObject);
begin
  // Pick color
  textColorPicker.Color := newCodeStyles[StyleOptionListBox.ItemIndex].backColor;

  if textColorPicker.Execute then
    newCodeStyles[StyleOptionListBox.ItemIndex].backColor := textColorPicker.Color;

  StyleOptionListBoxClick(nil);
end;

procedure TStyleConfiguratorForm.FontPickerBoxChange(Sender: TObject);
begin
  newCodeStyles[StyleOptionListBox.ItemIndex].fontName := FontPickerBox.Text;
end;

end.
