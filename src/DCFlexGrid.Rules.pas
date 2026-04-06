unit DCFlexGrid.Rules;

interface

uses
  System.Classes, System.SysUtils, System.StrUtils, Vcl.Graphics;

type
  TDCGridRuleOperator = (
    roEquals,
    roNotEquals,
    roGreaterThan,
    roLessThan,
    roContains,
    roStartsWith
  );

  TDCGridRuleStyle = record
    BackColor: TColor;
    FontColor: TColor;
    FontStyles: TFontStyles;
  end;

  TDCGridRule = class
  private
    FFieldName: string;
    FOperator: TDCGridRuleOperator;
    FValue: string;
    FStyle: TDCGridRuleStyle;
    function NormalizeText(const AValue: string): string;
    function TryParseGridFloat(const AValue: string; out ANumber: Double): Boolean;
  public
    function Match(const AValue: string): Boolean;

    property FieldName: string read FFieldName write FFieldName;
    property Operator_: TDCGridRuleOperator read FOperator write FOperator;
    property Value: string read FValue write FValue;
    property Style: TDCGridRuleStyle read FStyle write FStyle;
  end;

implementation

function TDCGridRule.NormalizeText(const AValue: string): string;
begin
  Result := UpperCase(Trim(AValue));
end;

function TDCGridRule.TryParseGridFloat(const AValue: string; out ANumber: Double): Boolean;
var
  LValue: string;
  LFormat: TFormatSettings;
begin
  LValue := Trim(AValue);
  LFormat := TFormatSettings.Create;

  Result := TryStrToFloat(LValue, ANumber, LFormat);
  if Result then
    Exit;

  LValue := StringReplace(LValue, '.', '', [rfReplaceAll]);
  LValue := StringReplace(LValue, ',', '.', [rfReplaceAll]);
  LFormat.DecimalSeparator := '.';
  Result := TryStrToFloat(LValue, ANumber, LFormat);
end;

function TDCGridRule.Match(const AValue: string): Boolean;
var
  LFloatValue, LRuleValue: Double;
  LTextValue, LRuleText: string;
begin
  LTextValue := NormalizeText(AValue);
  LRuleText := NormalizeText(FValue);

  case FOperator of
    roEquals:
      Result := LTextValue = LRuleText;
    roNotEquals:
      Result := LTextValue <> LRuleText;
    roContains:
      Result := Pos(LRuleText, LTextValue) > 0;
    roStartsWith:
      Result := StartsText(LRuleText, LTextValue);
    roGreaterThan:
      if TryParseGridFloat(AValue, LFloatValue) and TryParseGridFloat(FValue, LRuleValue) then
        Result := LFloatValue > LRuleValue
      else
        Result := False;
    roLessThan:
      if TryParseGridFloat(AValue, LFloatValue) and TryParseGridFloat(FValue, LRuleValue) then
        Result := LFloatValue < LRuleValue
      else
        Result := False;
  else
    Result := False;
  end;
end;

end.
