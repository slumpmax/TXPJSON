unit XPVariant;

interface

uses
  StrUtils, SysUtils, Math;

type
  TXPVarType = (
    XP_UNDEFINED  = 0,
    XP_NULL       = 1,
    XP_INTEGER    = 2,
    XP_BOOLEAN    = 3,
    XP_FLOAT      = 4,
    XP_STRING     = 5,
    XP_ARRAY      = 6,
    XP_KEY        = 7
  );

  TXPVarInteger = class(TInterfacedObject, IInterface)
  public
    Value: Integer;
    constructor Create(AValue: Integer = 0);
  end;

  TXPVarBoolean = class(TInterfacedObject, IInterface)
  public
    Value: Boolean;
    constructor Create(AValue: Boolean = False);
  end;

  TXPVarFloat = class(TInterfacedObject, IInterface)
  public
    Value: Double;
    constructor Create(AValue: Double = 0.0);
  end;

  TXPVarString = class(TInterfacedObject, IInterface)
  public
    Value: string;
    constructor Create(AValue: string = '');
  end;

  TXPVarKey = class;
  TXPVarArray = class;

  XPVar = record
  private
    FInterface: IInterface;
    FType: TXPVarType;
    procedure SetType(AType: TXPVarType);
    function GetValueOfInt(AKey: Integer): XPVar;
    procedure SetValueOfInt(AKey: Integer; AValue: XPVar);
    function GetValueOfBool(AKey: Boolean): XPVar;
    procedure SetValueOfBool(AKey: Boolean; AValue: XPVar);
    function GetValues(AKey: string): XPVar;
    procedure SetValues(AKey: string; AValue: XPVar);
    function GetJSON: string;
    procedure SetJSON(AValue: string);
    function GetJSONPretty: string;
    function GetAsInteger: Integer;
    function GetAsBoolean: Boolean;
    function GetAsFloat: Double;
    function GetAsString: string;
    function GetAsArray: TXPVarArray;
    function GetAsKey: TXPVarKey;
    procedure SetAsInteger(AValue: Integer);
    procedure SetAsBoolean(AValue: Boolean);
    procedure SetAsFloat(AValue: Double);
    procedure SetAsString(AValue: string);
    function EncodeText(AIndent: Integer = -1): string;
    procedure SetAsKey(AValue: TXPVarKey);
  public
    procedure Clear;
    function EscapeString(AString: string): string;

    class operator Implicit(AValue: Pointer): XPVar;
    class operator Implicit(AValue: Boolean): XPVar;
    class operator Implicit(AValue: Integer): XPVar;
    class operator Implicit(AValue: Double): XPVar;
    class operator Implicit(AValue: string): XPVar;
    class operator Implicit(AValue: TXPVarKey): XPVar;
    class operator Implicit(AValue: TXPVarArray): XPVar;

    class operator Implicit(AValue: XPVar): Boolean;
    class operator Implicit(AValue: XPVar): Integer;
    class operator Implicit(AValue: XPVar): Double;
    class operator Implicit(AValue: XPVar): string;

    class operator Negative(AValue: XPVar): XPVar;

    class operator Add(A: XPVar; B: Integer): XPVar;
    class operator Subtract(A: XPVar; B: Integer): XPVar;
    class operator Subtract(A: Integer; B: XPVar): XPVar;

    property AsInteger: Integer read GetAsInteger write SetAsInteger;
    property AsInt: Integer read GetAsInteger write SetAsInteger;

    property AsBoolean: Boolean read GetAsBoolean write SetAsBoolean;
    property AsBool: Boolean read GetAsBoolean write SetAsBoolean;

    property AsFloat: Double read GetAsFloat write SetAsFloat;

    property AsString: string read GetAsString write SetAsString;
    property AsStr: string read GetAsString write SetAsString;

    property AsArray: TXPVarArray read GetAsArray;
    property AsKey: TXPVarKey read GetAsKey write SetAsKey;

    property JSON: string read GetJSON write SetJSON;
    property JSONPretty: string read GetJSONPretty write SetJSON;
    property Text: string read GetJSON write SetJSON;
    property TextPretty: string read GetJSONPretty write SetJSON;

    property ValueType: TXPVarType read FType write SetType;
    property Values[AKey: Integer]: XPVar read GetValueOfInt write SetValueOfInt; default;
    property Values[AKey: Boolean]: XPVar read GetValueOfBool write SetValueOfBool; default;
    property Values[AKey: string]: XPVar read GetValues write SetValues; default;
  end;

//  IXPVarKey = interface
//    function GetKey: string;
//    function GetValue: XPVar;
//    function SetValue(AValue: XPVar);
//    property Key: string read GetKey;
//    property Value: XPVar read GetValue write SetValue;
//  end;

  TXPVarKey = class(TInterfacedObject, IInterface)
  public
    Key: string;
    Value: XPVar;
    constructor Create; overload;
    constructor Create(AKey: string; AValue: XPVar); overload;
    constructor Create(AKey: Integer; AValue: XPVar); overload;
    constructor Create(AKey: Boolean; AValue: XPVar); overload;
  end;

  XPVarItem = record
    Key: string;
    Value: XPVar;
  end;

  XPVarCodec = record
  private
    FPos, FMaxPos: Integer;
    FText: string;
    function GetChar: Char;
    function GetTrim: Char;
    function GetNumber: XPVar;
    function GetString: string;
    function GetValue: XPVar;
  public
    function Decode(AText: string): XPVar;
  end;
  TXPJson = XPVar;

//  IXPVarArray = interface
//    function GetValues(AKey: string): XPVar;
//    procedure SetValues(AKey: string; AValue: XPVar);
//    function GetAssociated: Boolean;
//    procedure SetAssociated(AValue: Boolean);
//    function GetKeys(AIndex: Integer): string;
//    function GetItems(AIndex: Integer): XPVarItem;
//    procedure Clear;
//    function Count: Integer;
//    function IndexOf(AKey: string; AStart: Integer = -1; AStop: Integer = -1): Integer;
//    procedure Assign(AArray: TXPVarArray);
//    function Push(AValue: XPVar): Integer;
//    property Associated: Boolean read GetAssociated write SetAssociated;
//    property Keys[AIndex: Integer]: string read GetKeys;
//    property Items[AIndex: Integer]: XPVarItem read GetItems;
//    property Values[AKey: string]: XPVar read GetValues write SetValues; default;
//  end;

  TXPVarArray = class(TInterfacedObject, IInterface)
  private
    FIndex: Integer;
    FAssociated: Boolean;
    FItems: array of XPVarItem;
    function GetValues(AKey: string): XPVar;
    procedure SetValues(AKey: string; AValue: XPVar);
    function GetAssociated: Boolean;
    procedure SetAssociated(AValue: Boolean);
    function GetKeys(AIndex: Integer): string;
    function GetItems(AIndex: Integer): XPVarItem;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function Count: Integer;
    function IndexOf(AKey: string; AStart: Integer = -1; AStop: Integer = -1): Integer;
    procedure Assign(AArray: TXPVarArray);
    function Push(AValue: XPVar): Integer;
    property Associated: Boolean read GetAssociated write SetAssociated;
    property Keys[AIndex: Integer]: string read GetKeys;
    property Items[AIndex: Integer]: XPVarItem read GetItems;
    property Values[AKey: string]: XPVar read GetValues write SetValues; default;
  end;

function JsonArrayOf(AValues: array of XPVar): XPVar;
function XPArray(AValues: array of XPVar): XPVar;
function XPKey(AKey: string; AValue: XPVar): XPVar;
function XPNone: XPVar;
function XPNull: XPVar;

implementation

function JsonArrayOf(AValues: array of XPVar): XPVar;
begin
  Result := XPArray(AValues);
end;

function XPArray(AValues: array of XPVar): XPVar;
var
  arr: TXPVarArray;
  n: Integer;
begin
  Result.SetType(XP_ARRAY);
  arr := Result.AsArray;
  for n := 0 to High(AValues) do arr.Push(AValues[n]);
end;

function XPKey(AKey: string; AValue: XPVar): XPVar;
begin
  Result.SetType(XP_KEY);
  with TXPVarKey(Result.FInterface) do
  begin
    Key := AKey;
    Value := AValue;
  end;
end;

function XPNone: XPVar;
begin
  Result.SetType(XP_UNDEFINED);
end;

function XPNull: XPVar;
begin
  Result.SetType(XP_NULL);
end;

{ XPVar }

procedure XPVar.SetAsBoolean(AValue: Boolean);
begin
  FInterface := TXPVarBoolean.Create(AValue);
  FType := XP_BOOLEAN;
end;

procedure XPVar.SetAsFloat(AValue: Double);
begin
  FInterface := TXPVarFloat.Create(AValue);
  FType := XP_FLOAT;
end;

procedure XPVar.SetAsInteger(AValue: Integer);
begin
  FInterface := TXPVarInteger.Create(AValue);
  FType := XP_INTEGER;
end;

procedure XPVar.SetAsKey(AValue: TXPVarKey);
begin
  FInterface := TXPVarKey.Create(0, AValue);
  FType := XP_KEY;
end;

procedure XPVar.SetAsString(AValue: string);
begin
  FInterface := TXPVarString.Create(AValue);
  FType := XP_STRING;
end;

procedure XPVar.SetJSON(AValue: string);
var
  codec: XPVarCodec;
begin
  Clear;
  Self := codec.Decode(AValue);
end;

procedure XPVar.SetType(AType: TXPVarType);
begin
  case AType of
    XP_INTEGER  : FInterface := TXPVarInteger.Create;
    XP_BOOLEAN  : FInterface := TXPVarBoolean.Create;
    XP_FLOAT    : FInterface := TXPVarFloat.Create;
    XP_STRING   : FInterface := TXPVarString.Create;
    XP_ARRAY    : FInterface := TXPVarArray.Create;
    XP_KEY      : FInterface := TXPVarKey.Create;
  else
    FInterface := nil;
  end;
  FType := AType;
end;

procedure XPVar.SetValueOfBool(AKey: Boolean; AValue: XPVar);
begin
  SetValues(IfThen(AKey, '1', '0'), AValue);
end;

procedure XPVar.SetValueOfInt(AKey: Integer; AValue: XPVar);
begin
  SetValues(IntToStr(AKey), AValue);
end;

procedure XPVar.SetValues(AKey: string; AValue: XPVar);
begin
  AsArray[AKey] := AValue;
end;

class operator XPVar.Subtract(A: Integer; B: XPVar): XPVar;
begin
  case B.FType of
    XP_INTEGER: Result := A - B.AsInteger;
    XP_BOOLEAN: Result := A - IfThen(B.AsBoolean, 1, 0);
    XP_FLOAT: Result := Double(A) - B.AsFloat;
    XP_STRING: Result := IntToStr(A) + B.AsString;
    XP_ARRAY:
    begin
      Result := A;
      Result.AsArray.Push(B);
    end;
  else
    Result := -B;
  end;
end;

class operator XPVar.Subtract(A: XPVar; B: Integer): XPVar;
begin
  case A.FType of
    XP_INTEGER: Result := A.AsInteger - B;
    XP_BOOLEAN: Result := IfThen(A.AsBoolean, 1, 0) - B;
    XP_FLOAT: Result := A.AsFloat - Double(B);
    XP_STRING: Result := A.AsString + IntToStr(B);
    XP_ARRAY:
    begin
      Result := A;
      Result.AsArray.Push(B);
    end;
  else
    Result := -B;
  end;
end;

class operator XPVar.Add(A: XPVar; B: Integer): XPVar;
begin
  case A.FType of
    XP_INTEGER: Result.AsInteger := A.AsInteger + B;
    XP_BOOLEAN: Result.AsInteger := A.AsInteger + B;
    XP_FLOAT: Result.AsFloat := A.AsFloat + B;
    XP_STRING: Result.AsString := A.AsString + IntToStr(B);
    XP_ARRAY:
    begin
      Result := A.AsArray;
      Result.AsArray.Push(B);
    end
  else
    Result.AsInteger := B;
  end;
end;

procedure XPVar.Clear;
begin
  SetType(XP_UNDEFINED);
end;

function XPVar.EncodeText(AIndent: Integer): string;
var
  arr: TXPVarArray;
  n: Integer;
  spc, spc2, ret: string;
begin
  Result := '';
  if AIndent >= 0 then
  begin
    spc := DupeString(' ', AIndent);
    spc2 := spc + '  ';
    ret := #13#10;
  end
  else
  begin
    spc := '';
    spc2 := '';
    ret := ' ';
  end;
  case FType of
    XP_UNDEFINED, XP_NULL: Result := 'null';
    XP_INTEGER: Result := IntToStr(AsInteger);
    XP_BOOLEAN: Result := IfThen(AsBoolean, 'true', 'false');
    XP_FLOAT: Result := FloatToStr(AsFloat);
    XP_STRING: Result := '"' + EscapeString(AsString) + '"';
    XP_ARRAY:
    begin
      arr := AsArray;
      for n := 0 to arr.Count - 1 do
      begin
        if Result <> '' then Result := Result + ',' + ret;
        Result := Result + spc2;
        if arr.Associated then Result := Result + '"' + EscapeString(arr.Items[n].Key) + '": ';
        Result := Result + arr.Items[n].Value.EncodeText(IfThen(AIndent >= 0, AIndent + 2, -1));
      end;
      if arr.Associated then
        Result := '{' + ret + Result + ret + spc + '}'
      else Result := '[' + ret + Result + ret + spc + ']';
    end;
  end;
end;

function XPVar.EscapeString(AString: string): string;
var
  n, nmax: Integer;
  c, d: Char;
begin
  Result := '';
  nmax := Length(AString);
  n := 1;
  while n <= nmax do
  begin
    c := ASTring[n];
    if n < nmax then
      d := AString[n + 1]
    else d := #0;
    case c of
      #9: Result := Result + '\t';
      #10: Result := Result + '\n';
      #13:
      begin
        if d = #10 then
        begin
          Result := Result + '\n';
          Inc(n);
        end
        else Result := Result + '\r';
      end;
      '"': Result := Result + '\"';
      '\': Result := Result + '\\';
    else
      Result := Result + c;
    end;
    Inc(n);
  end;
end;

function XPVar.GetAsArray: TXPVarArray;
begin
  if FType = XP_ARRAY then
    if TXPVarArray(FInterface).FRefCount > 1 then
    begin
      Result := TXPVarArray.Create;
      Result.Assign(TXPVarArray(FInterface));
      FInterface := Result;
    end
    else Result := TXPVarArray(FInterface)
  else
  begin
    Result := TXPVarArray.Create;
    case FType of
      XP_INTEGER: TXPVarArray(Result).Push(AsInteger);
      XP_BOOLEAN: TXPVarArray(Result).Push(AsBoolean);
      XP_FLOAT: TXPVarArray(Result).Push(AsFloat);
      XP_STRING: TXPVarArray(Result).Push(AsString);
      XP_KEY: TXPVarArray(Result).Push(AsKey);
    end;
    FInterface := Result;
    FType := XP_ARRAY;
  end;
end;

function XPVar.GetAsBoolean: Boolean;
var
  s: string;
begin
  case FType of
    XP_INTEGER: Result := TXPVarInteger(FInterface).Value <> 0;
    XP_BOOLEAN: Result := TXPVarBoolean(FInterface).Value;
    XP_FLOAT: Result := TXPVarFloat(FInterface).Value <> 0.0;
    XP_STRING:
    begin
      s := UpperCase(TXPVarString(FInterface).Value);
      Result := (s = 'TRUE') or (StrToFloatDef(s, 0.0) <> 0.0);
    end;
    XP_KEY: Result := TXPVarKey(FInterface).Value.AsBoolean;
    XP_ARRAY: Result := False;
  else
    Result := False;
  end;
end;

function XPVar.GetAsFloat: Double;
begin
  case FType of
    XP_INTEGER: Result := TXPVarInteger(FInterface).Value;
    XP_BOOLEAN: Result := IfThen(TXPVarBoolean(FInterface).Value, 1.0, 0.0);
    XP_FLOAT: Result := TXPVarFloat(FInterface).Value;
    XP_STRING: Result := StrToFloatDef(TXPVarString(FInterface).Value, 0.0);
    XP_KEY: Result := TXPVarKey(FInterface).Value.AsFloat;
    XP_ARRAY: Result := 0.0;
  else
    Result := 0.0;
  end;
end;

function XPVar.GetAsInteger: Integer;
begin
  case FType of
    XP_INTEGER: Result := TXPVarInteger(FInterface).Value;
    XP_BOOLEAN: Result := IfThen(TXPVarBoolean(FInterface).Value, 1, 0);
    XP_FLOAT: Result := Round(TXPVarFloat(FInterface).Value);
    XP_STRING: Result := StrToIntDef(TXPVarString(FInterface).Value, 0);
    XP_KEY: Result := TXPVarKey(FInterface).Value.AsInteger;
    XP_ARRAY: Result := 0;
  else
    Result := 0;
  end;
end;

function XPVar.GetAsKey: TXPVarKey;
begin
  if FType = XP_KEY then
    Result := TXPVarKey(FInterface)
  else
  begin
    Result := TXPVarKey.Create;
    case FType of
      XP_INTEGER: TXPVarKey(Result).Value := AsInteger;
      XP_BOOLEAN: TXPVarKey(Result).Value := AsBoolean;
      XP_FLOAT: TXPVarKey(Result).Value := AsFloat;
      XP_STRING: TXPVarKey(Result).Value := AsString;
      XP_ARRAY: TXPVarKey(Result).Value := AsArray;
    end;
    FInterface := Result;
    FType := XP_KEY;
  end;
end;

function XPVar.GetAsString: string;
begin
  case FType of
    XP_INTEGER: Result := IntToStr(TXPVarInteger(FInterface).Value);
    XP_BOOLEAN: Result := IfThen(TXPVarBoolean(FInterface).Value, '1', '0');
    XP_FLOAT: Result := FloatToStr(TXPVarFloat(FInterface).Value);
    XP_STRING: Result := TXPVarString(FInterface).Value;
    XP_KEY: Result := TXPVarKey(FInterface).Value.AsString;
    XP_ARRAY: Result := 'Array';
  else
    Result := '';
  end;
end;

function XPVar.GetJSON: string;
begin
  Result := EncodeText;
end;

function XPVar.GetJSONPretty: string;
begin
  Result := EncodeText(0);
end;

function XPVar.GetValueOfBool(AKey: Boolean): XPVar;
begin
  Result := GetValues(IfThen(AKey, '1', '0'));
end;

function XPVar.GetValueOfInt(AKey: Integer): XPVar;
begin
  Result := GetValues(IntToStr(AKey));
end;

function XPVar.GetValues(AKey: string): XPVar;
begin
  if FType = XP_ARRAY then
    Result := AsArray[AKey]
  else raise Exception.Create('Can not get member on non ARRAY type.');
end;

class operator XPVar.Implicit(AValue: Pointer): XPVar;
begin
  if (AValue <> nil) then raise Exception.Create('Can not assign pointer to XPVar');
  Result.SetType(XP_NULL);
end;

class operator XPVar.Implicit(AValue: Double): XPVar;
begin
  Result.AsFloat := AValue;
end;

class operator XPVar.Implicit(AValue: Integer): XPVar;
begin
  Result.AsInteger := AValue;
end;

class operator XPVar.Implicit(AValue: Boolean): XPVar;
begin
  Result.AsBoolean := AValue;
end;

class operator XPVar.Implicit(AValue: string): XPVar;
begin
  Result.AsString := AValue;
end;

class operator XPVar.Implicit(AValue: XPVar): string;
begin
  Result := AValue.AsString;
end;

class operator XPVar.Implicit(AValue: TXPVarKey): XPVar;
begin
  Result.AsKey := AValue;
end;

class operator XPVar.Negative(AValue: XPVar): XPVar;
begin
  case AValue.ValueType of
    XP_INTEGER: Result := -AValue.AsInteger;
    XP_BOOLEAN: Result := not AValue.AsBoolean;
    XP_FLOAT: Result := -AValue.AsFloat;
    XP_STRING: Result := ReverseString(AValue.AsString);
    XP_KEY:
    begin
      Result := AValue;
      TXPVarKey(Result.FInterface).Value := -Result.AsKey.Value;
    end
  else
    Result := AValue;
  end;
end;

class operator XPVar.Implicit(AValue: TXPVarArray): XPVar;
begin
  Result.Clear;
  Result.AsArray.Assign(TXPVarArray(AValue));
end;

class operator XPVar.Implicit(AValue: XPVar): Double;
begin
  Result := AValue.AsFloat;
end;

class operator XPVar.Implicit(AValue: XPVar): Integer;
begin
  Result := AValue.AsInteger;
end;

class operator XPVar.Implicit(AValue: XPVar): Boolean;
begin
  Result := AValue.AsBoolean;
end;

{ TXPVarArray }

procedure TXPVarArray.Assign(AArray: TXPVarArray);
var
  n: Integer;
begin
  SetLength(FItems, Length(AArray.FItems));
  for n := 0 to Length(AArray.FItems) - 1 do
  begin
    FItems[n] := AArray.FItems[n];
  end;
  FIndex := AArray.FIndex;
  FAssociated := AArray.FAssociated;
end;

procedure TXPVarArray.Clear;
var
  n: Integer;
begin
  n := Length(FItems);
  while n > 0 do
  begin
    Dec(n);
    FItems[n].Value.SetType(XP_UNDEFINED);
  end;
  FItems := nil;
end;

function TXPVarArray.Count: Integer;
begin
  Result := Length(FItems);
end;

constructor TXPVarArray.Create;
begin
  FItems := nil;
  FIndex := 0;
  FAssociated := False;
end;

destructor TXPVarArray.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function TXPVarArray.GetAssociated: Boolean;
begin
  Result := FAssociated;
end;

function TXPVarArray.GetItems(AIndex: Integer): XPVarItem;
begin
  Result := FItems[AIndex];
end;

function TXPVarArray.GetKeys(AIndex: Integer): string;
begin
  Result := FItems[AIndex].Key;
end;

function TXPVarArray.GetValues(AKey: string): XPVar;
var
  n: Integer;
begin
  n := IndexOf(AKey);
  if n >= 0 then
    Result := FItems[n].Value
  else Result := nil;
end;

function TXPVarArray.IndexOf(AKey: string; AStart, AStop: Integer): Integer;
var
  n: integer;
begin
  Result := -1;
  n := Length(FItems);
  while (Result < 0) and (n > 0) do
  begin
    Dec(n);
    if FItems[n].Key = AKey then Result := n;
  end;
end;

function TXPVarArray.Push(AValue: XPVar): Integer;
var
  key: TXPVarKey;
begin
  if AValue.FType = XP_KEY then
  begin
    key := AValue.AsKey;
    SetValues(key.Key, key.Value);
    Result := IndexOf(key.Key);
  end
  else
  begin
    Result := FIndex;
    SetValues(IntToStr(Result), AValue);
  end;
end;

procedure TXPVarArray.SetAssociated(AValue: Boolean);
begin
  FAssociated := AValue;
end;

procedure TXPVarArray.SetValues(AKey: string; AValue: XPVar);
var
  v: XPVarItem;
  n: Integer;
begin
  n := IndexOf(AKey);
  if n >= 0 then
    FItems[n].Value := AValue
  else
  begin
    n := Length(FItems);
    v.Key := AKey;
    v.Value := AValue;
    Insert(v, FItems, n);
    if IntToStr(FIndex) = AKey then
      Inc(FIndex)
    else FAssociated := True;
  end;
end;

{ TXPVarString }

constructor TXPVarString.Create(AValue: string);
begin
  Value := AValue;
end;

{ TXPVarInteger }

constructor TXPVarInteger.Create(AValue: Integer);
begin
  Value := AValue;
end;

{ TXPVarBoolean }

constructor TXPVarBoolean.Create(AValue: Boolean);
begin
  Value := AValue;
end;

{ TXPVarFloat }

constructor TXPVarFloat.Create(AValue: Double);
begin
  Value := AValue;
end;

{ XPVarCodec }

function XPVarCodec.Decode(AText: string): XPVar;
begin
  FText := AText;
  FPos := 1;
  FMaxPos := Length(FText);
  Result := GetValue;
end;

function XPVarCodec.GetChar: Char;
begin
  if FPos <= FMaxPos then
    Result := FText[FPos]
  else Result := #26;
end;

function XPVarCodec.GetNumber: XPVar;
var
  apos: Integer;
  s: string;
  dm: Boolean;
  c: Char;
begin
  apos := FPos;
  c := GetChar;
  while (c >= '0') and (c <= '9') do
  begin
    Inc(FPos);
    c := GetChar;
  end;
  dm := c = '.';
  if dm then
  begin
    Inc(FPos);
    c := GetChar;
    while (c >= '0') and (c <= '9') do
    begin
      Inc(FPos);
      c := GetChar;
    end;
  end;
  s := Copy(FText, apos, FPos - apos);
  if dm then
    Result := StrToFloatDef(s, 0.0)
  else Result := StrToIntDef(s, 0);
end;

function XPVarCodec.GetString: string;
var
  c: Char;
begin
  Result := '';
  if GetTrim <> '"' then raise Exception.Create('Invalid JSON string.');
  Inc(FPos);
  c := GetTrim;
  while (c <> '"') and (c <> #26) do
  begin
    case c of
      '\':
      begin
        Inc(FPos);
        c := GetChar;
        case c of
          '\': Result := Result + '\';
          '/': Result := Result + '/';
          '"': Result := Result + '"';
          'b': Result := Result + #8;
          'f': Result := Result + #12;
          'n': Result := Result + #10;
          'r': Result := Result + #13;
          't': Result := Result + #9;
          'u':
          begin
            Result := Result + Copy(FText, FPos + 1, 4);
            Inc(FPos, 5);
          end
        else
          Result := Result + c;
        end;
      end;
    else
      Result := Result + c;
    end;
    Inc(FPos);
    c := GetChar;
  end;
  if GetChar <> '"' then raise Exception.Create('Invalid JSON string.');
  Inc(FPos);
end;

function XPVarCodec.GetTrim: Char;
begin
  Result := GetChar;
  while ((Result = ' ') or (Result = #13) or (Result = #10) or (Result = #9)) do
  begin
    Inc(FPos);
    Result := GetChar;
  end;
end;

function XPVarCodec.GetValue: XPVar;
var
  arr: TXPVarArray;
  v: XPVar;
  s: string;
  c: Char;
begin
  Result.Clear;
  c := UpCase(GetTrim);
  case c of
    'N':
      if UpperCase(Copy(FText, FPos, 4)) = 'NULL' then
      begin
        Result := XPNull;
        Inc(FPos, 4);
      end
      else raise Exception.Create('Invalid JSON value.');
    'T':
      if UpperCase(Copy(FText, FPos, 4)) = 'TRUE' then
      begin
        Result := True;
        Inc(FPos, 4);
      end
      else raise Exception.Create('Invalid JSON value.');
    'F':
      if UpperCase(Copy(FText, FPos, 5)) = 'FALSE' then
      begin
        Result := False;
        Inc(FPos, 5);
      end
      else raise Exception.Create('Invalid JSON value.');
    '[':
    begin
      Inc(FPos);
      arr := Result.AsArray;
      v := GetValue;
      while v.ValueType <> XP_UNDEFINED do
      begin
        arr.Push(v);
        c := GetTrim;
        if c = ',' then
        begin
          Inc(FPos);
          v := GetValue;
        end
        else v.Clear;
      end;
      c := GetTrim;
      if c = ']' then
        Inc(FPos)
      else raise Exception.Create('Invalid JSON array.');
    end;
    '{':
    begin
      Inc(FPos);
      arr := Result.AsArray;
      c := GetTrim;
      while (c <> '}') and (c <> #26) do
      begin
        s := GetString;
        if GetTrim <> ':' then raise Exception.Create('Invalid JSON object.');
        Inc(FPos);
        v := GetValue;
        arr[s] := v;
        c := GetTrim;
        if c = ',' then
        begin
          Inc(FPos);
          c := GetTrim;
        end
        else c := '}';
      end;
      if GetTrim <> '}' then raise Exception.Create('Invalid JSON object');
      Inc(FPos);
    end;
    '0'..'9','.': Result := GetNumber;
    '+':
    begin
      Inc(FPos);
      Result := GetNumber;
    end;
    '-':
    begin
      Inc(FPos);
      Result := -GetNumber;
    end;
    '"': Result := GetString;
  else
    raise Exception.Create('Invalid JSON data.');
  end;
end;

{ TXPVarKey }

constructor TXPVarKey.Create;
begin
  Key := '';
  Value.SetType(XP_UNDEFINED);
end;

constructor TXPVarKey.Create(AKey: string; AValue: XPVar);
begin
  Key := AKey;
  Value := AValue;
end;

constructor TXPVarKey.Create(AKey: Boolean; AValue: XPVar);
begin
  Key := IfThen(AKey, '1', '0');
  Value := AValue;
end;

constructor TXPVarKey.Create(AKey: Integer; AValue: XPVar);
begin
  Key := IntToStr(AKey);
  Value := AValue;
end;

end.
