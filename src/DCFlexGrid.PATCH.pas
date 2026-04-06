// PATCHED EXCERPT - integrate into your existing grid

uses
  DCFlexGrid.Rules,
  System.Generics.Collections;

type
  TDCMasterDetailGrid = class
  private
    FRules: TObjectList<TDCGridRule>;
    procedure ApplyRules(const AFieldName, AValue: string; ACanvas: TCanvas; var ARect: TRect);
  public
    function AddRule: TDCGridRule;
    constructor Create;
    destructor Destroy; override;
  end;

constructor TDCMasterDetailGrid.Create;
begin
  inherited;
  FRules := TObjectList<TDCGridRule>.Create(True);
end;

destructor TDCMasterDetailGrid.Destroy;
begin
  FRules.Free;
  inherited;
end;

function TDCMasterDetailGrid.AddRule: TDCGridRule;
begin
  Result := TDCGridRule.Create;
  FRules.Add(Result);
end;

procedure TDCMasterDetailGrid.ApplyRules(const AFieldName, AValue: string; ACanvas: TCanvas; var ARect: TRect);
var
  R: TDCGridRule;
begin
  for R in FRules do
  begin
    if SameText(R.FieldName, AFieldName) and R.Match(AValue) then
    begin
      if R.Style.BackColor <> clNone then
      begin
        ACanvas.Brush.Color := R.Style.BackColor;
        ACanvas.FillRect(ARect);
      end;

      if R.Style.FontColor <> clNone then
        ACanvas.Font.Color := R.Style.FontColor;

      ACanvas.Font.Style := ACanvas.Font.Style + R.Style.FontStyles;
    end;
  end;
end;
