unit ErrorDisplayFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TErrorDisplayForm = class(TForm)
    CheckRichEdit: TRichEdit;
    CloseFormButton: TButton;
    procedure CloseFormButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure DisplayOutputMessage(messageType: Byte; errorLine: LongInt; messageText: String);
procedure ClearCheckMessages;

var
  ErrorDisplayForm : TErrorDisplayForm;
  CheckedFileName  : String;

implementation

{$R *.dfm}

procedure TErrorDisplayForm.CloseFormButtonClick(Sender: TObject);
begin
  Hide;
end;

procedure TErrorDisplayForm.FormCreate(Sender: TObject);
begin
  CheckRichEdit.Lines.Add('[Проверка]');
  CheckRichEdit.SelStart := 0;
  CheckRichEdit.SelLength := Length(CheckRichEdit.Text);
  CheckRichEdit.SelAttributes.Color := clGreen;
  CheckRichEdit.SelAttributes.Style := [fsBold];
  CheckRichEdit.SelLength := 0;
  CheckRichEdit.SelStart := Length(CheckRichEdit.Text);
end;

procedure TErrorDisplayForm.FormResize(Sender: TObject);
begin
  CloseFormButton.Left := (ClientWidth - CloseFormButton.Width) div 2;
  CloseFormButton.Top := ClientHeight - 40;

  CheckRichEdit.Width := ClientWidth - 10;
  CheckRichEdit.Height := ClientHeight - 55;
end;

procedure ClearCheckMessages;
begin
  with ErrorDisplayForm do
    while (CheckRichEdit.Lines.Count > 1) do
      begin
        CheckRichEdit.Lines.Delete(1);
      end;
end;

procedure DisplayOutputMessage(messageType: Byte; errorLine: LongInt; messageText: String);
var i                : LongInt;
    offset           : LongInt;
    len              : LongInt;
    errorMessageText : String;
    hintColor        : TColor;
begin
  with ErrorDisplayForm do
    begin
      case messageType of
          0:
            begin
              errorMessageText := '[Ошибка] ';
              hintColor := clRed;
            end;
          1:
            begin
              errorMessageText := '[Подсказка] ';
              hintColor := $FF9400;
            end;
        end;

      CheckRichEdit.Lines.Add(errorMessageText + CheckedFileName + ':' + IntToStr(errorLine + 1) + ' - ' + messageText);

      offset := 0;
      for i := 0 to CheckRichEdit.Lines.Count - 2 do
        Inc(offset, Length(CheckRichEdit.Lines[i]) + 2);

      CheckRichEdit.SelStart := offset;
      CheckRichEdit.SelLength := Length(errorMessageText) - 1;
      CheckRichEdit.SelAttributes.Color := hintColor;
      CheckRichEdit.SelAttributes.Style := [fsBold];

      len := Length(CheckRichEdit.Lines[CheckRichEdit.Lines.Count - 1]);
      len := len - Length(messageText) - Length(errorMessageText) - 3;
      CheckRichEdit.SelStart := offset + Length(errorMessageText);
      CheckRichEdit.SelLength := len;
      CheckRichEdit.SelAttributes.Color := clBlue;
      CheckRichEdit.SelAttributes.Style := [];
      
      CheckRichEdit.SelLength := 0;
    end;
end;

end.
