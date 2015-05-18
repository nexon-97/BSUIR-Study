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

procedure DisplayOutputMessage(messageType: Byte; messageText: String);

var
  ErrorDisplayForm: TErrorDisplayForm;

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
  CheckRichEdit.SelAttributes.Color := clBlue;
  CheckRichEdit.SelAttributes.Style := [fsBold];
  CheckRichEdit.SelLength := 0;
  CheckRichEdit.SelStart := Length(CheckRichEdit.Text);

  DisplayOutputMessage(0, 'Form created');
  DisplayOutputMessage(0, 'Form created');
  DisplayOutputMessage(0, 'Form created');
end;

procedure TErrorDisplayForm.FormResize(Sender: TObject);
begin
  CloseFormButton.Left := (ClientWidth - CloseFormButton.Width) div 2;
  CloseFormButton.Top := ClientHeight - 40;

  CheckRichEdit.Width := ClientWidth - 10;
  CheckRichEdit.Height := ClientHeight - 55;
end;

procedure DisplayOutputMessage(messageType: Byte; messageText: String);
var i      : LongInt;
    offset : LongInt;
begin
  with ErrorDisplayForm do
    begin
      CheckRichEdit.Lines.Add('[Ошибка]: ' + messageText);

      offset := 0;
      for i := 0 to CheckRichEdit.Lines.Count - 2 do
        Inc(offset, Length(CheckRichEdit.Lines[i]) + 2);

      CheckRichEdit.SelStart := offset;
      CheckRichEdit.SelLength := 9;
      CheckRichEdit.SelAttributes.Color := clRed;
      CheckRichEdit.SelAttributes.Style := [fsBold];
      
      CheckRichEdit.SelLength := 0;
    end;
end;

end.
