unit Form_Main;

interface

uses
  XPJSON,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormMain = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

// TXPJSon     ---> XPVar / TXPJson
// JsonArrayOf ---> XPArray / JsonArrayOf
// Text        ---> JSON / Text
// TextPretty  ---> JSONPretty / TextPretty
// AsInteger   ---> AsInteger / AsInt
// AsBoolean   ---> AsBoolean / AsBool
// AsString    ---> AsString / AsStr

procedure TFormMain.Button1Click(Sender: TObject);
var
  k0, k1, k2, k3, k4, k5, k6, k7, k8, k9, k10: XPVar;
  // k0, k1, k2, k3, k4, k5, k6, k7, k8, k9, k10: TXPJson;
begin
  k1 := 56;
  k2 := 78.901 - k1;
  k1[7] := 66;
  k3[5] := 'Delphi' + k2;
  k4['ID'] := nil;
  k5 := XPArray([1, 2, 3, 4, 5.5, 'abc', True, False, nil]);
//  k5 := JsonArrayOf([1, 2, 3, 4, 5.5, 'abc', True, False, nil]);
  k6 := k5;
  k6['7'] := 'A';
  k6['9'] := 'B';
  k7 := k6;
  k7['flag'] := 'end';
  k8.Text := k6.Text;
  k8['members'] := XPArray(['continue', 123]);
//  k8['members'] := JsonArrayOf(['continue', 123]);
  k9 := XPArray([
    XPKey('ID', 2),
    XPKey('Data', XPArray([
      XPKey('Name', 'Tom'),
      XPKey('Credit', 678901.23),
      XPKey('Favarite', XPArray(['Banana', 'Durian', 'Lychee']))
    ])),
    'no key'
  ]);
  k10.Text := Memo2.Text;
  Memo1.Lines.Add(Format('k0: %s', [k0.JSON]));
  Memo1.Lines.Add(Format('k1: %s', [k1.JSON]));
  Memo1.Lines.Add(Format('k2: %s', [k2.JSON]));
  Memo1.Lines.Add(Format('k3: %s', [k3.JSON]));
  Memo1.Lines.Add(Format('k4: %s', [k4.JSON]));
  Memo1.Lines.Add(Format('k5: %s', [k5.JSON]));
  Memo1.Lines.Add(Format('k6: %s', [k6.JSON]));
  Memo1.Lines.Add(Format('k7: %s', [k7.JSON]));
  Memo1.Lines.Add(Format('k8: %s', [k8.JSON]));
  Memo1.Lines.Add(Format('k9: %s', [k9.JSONPretty]));
  Memo1.Lines.Add(Format('k10: %s', [k10.JSONPretty]));
//  Memo1.Lines.Add(Format('k8: %s', [k8.Text]));
//  Memo1.Lines.Add(Format('k9: %s', [k9.TextPretty]));
end;

end.
