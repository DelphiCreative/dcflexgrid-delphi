unit DCFlexGrid.Fluent;

interface

uses
  System.Classes,
  Vcl.Graphics,
  Data.DB,
  DCFlexGrid,
  DCFlexGrid.Themes;

type
  IDCGridColumnBuilder = interface
    ['{6E5F3E20-EC73-4A55-B95A-B2B677D93B6A}']
    function FieldName(const AValue: string): IDCGridColumnBuilder;
    function Caption(const AValue: string): IDCGridColumnBuilder;
    function Width(AValue: Integer): IDCGridColumnBuilder;
    function Visible(AValue: Boolean = True): IDCGridColumnBuilder;
    function Hidden: IDCGridColumnBuilder;
    function AlignLeft: IDCGridColumnBuilder;
    function AlignCenter: IDCGridColumnBuilder;
    function AlignRight: IDCGridColumnBuilder;
    function AsText: IDCGridColumnBuilder;
    function AsInteger: IDCGridColumnBuilder;
    function AsCurrency: IDCGridColumnBuilder;
    function AsDate: IDCGridColumnBuilder;
    function AsStatus: IDCGridColumnBuilder;
    function Done: TDCMasterDetailGrid;
    function &End: TDCMasterDetailGrid;
  end;

  TDCGridColumnBuilder = class(TInterfacedObject, IDCGridColumnBuilder)
  private
    FGrid: TDCMasterDetailGrid;
    FColumn: TDCGridColumn;
  public
    constructor Create(AGrid: TDCMasterDetailGrid; AColumn: TDCGridColumn);
    function FieldName(const AValue: string): IDCGridColumnBuilder;
    function Caption(const AValue: string): IDCGridColumnBuilder;
    function Width(AValue: Integer): IDCGridColumnBuilder;
    function Visible(AValue: Boolean = True): IDCGridColumnBuilder;
    function Hidden: IDCGridColumnBuilder;
    function AlignLeft: IDCGridColumnBuilder;
    function AlignCenter: IDCGridColumnBuilder;
    function AlignRight: IDCGridColumnBuilder;
    function AsText: IDCGridColumnBuilder;
    function AsInteger: IDCGridColumnBuilder;
    function AsCurrency: IDCGridColumnBuilder;
    function AsDate: IDCGridColumnBuilder;
    function AsStatus: IDCGridColumnBuilder;
    function Done: TDCMasterDetailGrid;
    function &End: TDCMasterDetailGrid;
  end;

  TDCFlexGridFluentHelper = class helper for TDCMasterDetailGrid
  private
    function AddConfiguredColumn(ACollection: TDCGridColumns; const AFieldName,
      ACaption: string; AWidth: Integer; AAlignment: TDCTextAlignment): TDCGridColumn;
    function BeginConfiguredColumn(ACollection: TDCGridColumns; const AFieldName: string): IDCGridColumnBuilder;
  public
    function ClearColumns: TDCMasterDetailGrid;
    function ClearDetailColumns: TDCMasterDetailGrid;

    function AddColumn(const AFieldName, ACaption: string; AWidth: Integer = 120;
      AAlignment: TDCTextAlignment = taLeft): TDCMasterDetailGrid;
    function AddTextColumn(const AFieldName, ACaption: string; AWidth: Integer = 120): TDCMasterDetailGrid;
    function AddCenterColumn(const AFieldName, ACaption: string; AWidth: Integer = 90): TDCMasterDetailGrid;
    function AddRightColumn(const AFieldName, ACaption: string; AWidth: Integer = 100): TDCMasterDetailGrid;
    function AddIntegerColumn(const AFieldName, ACaption: string; AWidth: Integer = 80): TDCMasterDetailGrid;
    function AddCurrencyColumn(const AFieldName, ACaption: string; AWidth: Integer = 100): TDCMasterDetailGrid;
    function AddDateColumn(const AFieldName, ACaption: string; AWidth: Integer = 100): TDCMasterDetailGrid;
    function AddStatusColumn(const AFieldName, ACaption: string; AWidth: Integer = 110): TDCMasterDetailGrid;
    function Column(const AFieldName: string): IDCGridColumnBuilder;

    function AddDetailColumn(const AFieldName, ACaption: string; AWidth: Integer = 120;
      AAlignment: TDCTextAlignment = taLeft): TDCMasterDetailGrid;
    function AddDetailTextColumn(const AFieldName, ACaption: string; AWidth: Integer = 120): TDCMasterDetailGrid;
    function AddDetailCenterColumn(const AFieldName, ACaption: string; AWidth: Integer = 90): TDCMasterDetailGrid;
    function AddDetailRightColumn(const AFieldName, ACaption: string; AWidth: Integer = 100): TDCMasterDetailGrid;
    function AddDetailIntegerColumn(const AFieldName, ACaption: string; AWidth: Integer = 80): TDCMasterDetailGrid;
    function AddDetailCurrencyColumn(const AFieldName, ACaption: string; AWidth: Integer = 100): TDCMasterDetailGrid;
    function AddDetailDateColumn(const AFieldName, ACaption: string; AWidth: Integer = 100): TDCMasterDetailGrid;
    function AddDetailStatusColumn(const AFieldName, ACaption: string; AWidth: Integer = 110): TDCMasterDetailGrid;
    function DetailColumn(const AFieldName: string): IDCGridColumnBuilder;

    function WithRowHeight(AValue: Integer): TDCMasterDetailGrid;
    function WithHeaderHeight(AValue: Integer): TDCMasterDetailGrid;
    function WithDetailHeight(AValue: Integer): TDCMasterDetailGrid;
    function WithDetailGridHeaderHeight(AValue: Integer): TDCMasterDetailGrid;
    function WithDetailGridRowHeight(AValue: Integer): TDCMasterDetailGrid;
    function WithExpandMode(AValue: TDCExpandMode): TDCMasterDetailGrid;
    function WithDetailStyle(AValue: TDCDetailStyle): TDCMasterDetailGrid;
    function WithSearch(const AValue: string; AFilterMode: TDCFilterMode = fmContains;
      ASearchScope: TDCSearchScope = ssMasterOnly): TDCMasterDetailGrid;
    function WithLayout(const ALayoutKey: string; AAutoLoad: Boolean = True;
      AAutoSave: Boolean = False): TDCMasterDetailGrid;
    function WithMinColumnWidth(AValue: Integer): TDCMasterDetailGrid;
    function WithAlternateColors(AValue: Boolean = True): TDCMasterDetailGrid;
    function WithHeaderVisible(AValue: Boolean = True): TDCMasterDetailGrid;
    function WithExpandButton(AValue: Boolean = True): TDCMasterDetailGrid;
    function WithSort(AValue: Boolean = True): TDCMasterDetailGrid;
    function WithColumnResize(AValue: Boolean = True): TDCMasterDetailGrid;
    function WithDetailColumnResize(AValue: Boolean = True): TDCMasterDetailGrid;
    function WithAutoExpandOnSearch(AValue: Boolean = True): TDCMasterDetailGrid;
    function WithDefaultVisuals: TDCMasterDetailGrid;
    function WithReadOnlyLayout: TDCMasterDetailGrid;
    function WithInteractiveLayout: TDCMasterDetailGrid;
    function WithSearchContains(const AValue: string; ASearchScope: TDCSearchScope = ssMasterOnly): TDCMasterDetailGrid;
    function WithSearchStartsWith(const AValue: string; ASearchScope: TDCSearchScope = ssMasterOnly): TDCMasterDetailGrid;
    function WithSearchEquals(const AValue: string; ASearchScope: TDCSearchScope = ssMasterOnly): TDCMasterDetailGrid;
    function WithSearchMasterOnly: TDCMasterDetailGrid;
    function WithSearchMasterAndDetail: TDCMasterDetailGrid;
    function WithSingleExpand: TDCMasterDetailGrid;
    function WithMultipleExpand: TDCMasterDetailGrid;
    function WithDetailTextStyle: TDCMasterDetailGrid;
    function WithDetailGridStyle: TDCMasterDetailGrid;
    function WithBorderWidth(AValue: Integer): TDCMasterDetailGrid;
    function WithExpandOnRowClick(AValue: Boolean = True): TDCMasterDetailGrid;
    function WithDetailSelection(AValue: Boolean = True): TDCMasterDetailGrid;
    function WithTitleFontSize(AValue: Integer): TDCMasterDetailGrid;
    function WithDetailFontSize(AValue: Integer): TDCMasterDetailGrid;
    function WithTitleBold(AValue: Boolean = True): TDCMasterDetailGrid;
    function WithDetailBold(AValue: Boolean = True): TDCMasterDetailGrid;
    function WithThemePreset(APreset: TDCGridThemePreset): TDCMasterDetailGrid;
    function WithMetricsPreset(APreset: TDCGridMetricsPreset): TDCMasterDetailGrid;
    function WithProfessionalTheme: TDCMasterDetailGrid;
    function WithDarkModernTheme: TDCMasterDetailGrid;
    function WithERPBlueTheme: TDCMasterDetailGrid;
    function WithGreenTheme: TDCMasterDetailGrid;
    function WithMinimalTheme: TDCMasterDetailGrid;
    function WithCompactMetrics: TDCMasterDetailGrid;
    function WithComfortableMetrics: TDCMasterDetailGrid;
    function BindDataSets(AMasterDataSet, ADetailDataSet: TDataSet;
      const AMasterKeyField, ADetailKeyField: string): TDCMasterDetailGrid;
  end;

implementation

{ TDCGridColumnBuilder }

constructor TDCGridColumnBuilder.Create(AGrid: TDCMasterDetailGrid; AColumn: TDCGridColumn);
begin
  inherited Create;
  FGrid := AGrid;
  FColumn := AColumn;
end;

function TDCGridColumnBuilder.FieldName(const AValue: string): IDCGridColumnBuilder;
begin
  FColumn.FieldName := AValue;
  Result := Self;
end;

function TDCGridColumnBuilder.Caption(const AValue: string): IDCGridColumnBuilder;
begin
  FColumn.Caption := AValue;
  Result := Self;
end;

function TDCGridColumnBuilder.Width(AValue: Integer): IDCGridColumnBuilder;
begin
  FColumn.Width := AValue;
  Result := Self;
end;

function TDCGridColumnBuilder.Visible(AValue: Boolean): IDCGridColumnBuilder;
begin
  FColumn.Visible := AValue;
  Result := Self;
end;

function TDCGridColumnBuilder.Hidden: IDCGridColumnBuilder;
begin
  Result := Visible(False);
end;

function TDCGridColumnBuilder.AlignLeft: IDCGridColumnBuilder;
begin
  FColumn.Alignment := taLeft;
  Result := Self;
end;

function TDCGridColumnBuilder.AlignCenter: IDCGridColumnBuilder;
begin
  FColumn.Alignment := taCenter;
  Result := Self;
end;

function TDCGridColumnBuilder.AlignRight: IDCGridColumnBuilder;
begin
  FColumn.Alignment := taRight;
  Result := Self;
end;

function TDCGridColumnBuilder.AsText: IDCGridColumnBuilder;
begin
  Result := AlignLeft;
end;

function TDCGridColumnBuilder.AsInteger: IDCGridColumnBuilder;
begin
  Result := AlignCenter;
end;

function TDCGridColumnBuilder.AsCurrency: IDCGridColumnBuilder;
begin
  Result := AlignRight;
end;

function TDCGridColumnBuilder.AsDate: IDCGridColumnBuilder;
begin
  Result := AlignCenter;
end;

function TDCGridColumnBuilder.AsStatus: IDCGridColumnBuilder;
begin
  Result := AlignLeft;
end;

function TDCGridColumnBuilder.Done: TDCMasterDetailGrid;
begin
  FGrid.RefreshGrid;
  Result := FGrid;
end;

function TDCGridColumnBuilder.&End: TDCMasterDetailGrid;
begin
  Result := Done;
end;

{ TDCFlexGridFluentHelper }

function TDCFlexGridFluentHelper.AddConfiguredColumn(ACollection: TDCGridColumns;
  const AFieldName, ACaption: string; AWidth: Integer;
  AAlignment: TDCTextAlignment): TDCGridColumn;
begin
  Result := ACollection.Add;
  Result.FieldName := AFieldName;
  Result.Caption := ACaption;
  Result.Width := AWidth;
  Result.Alignment := AAlignment;
end;

function TDCFlexGridFluentHelper.BeginConfiguredColumn(
  ACollection: TDCGridColumns; const AFieldName: string): IDCGridColumnBuilder;
var
  LColumn: TDCGridColumn;
begin
  LColumn := ACollection.Add;
  LColumn.FieldName := AFieldName;
  LColumn.Caption := AFieldName;
  Result := TDCGridColumnBuilder.Create(Self, LColumn);
end;

function TDCFlexGridFluentHelper.ClearColumns: TDCMasterDetailGrid;
begin
  Columns.Clear;
  RefreshGrid;
  Result := Self;
end;

function TDCFlexGridFluentHelper.ClearDetailColumns: TDCMasterDetailGrid;
begin
  DetailColumns.Clear;
  RefreshGrid;
  Result := Self;
end;

function TDCFlexGridFluentHelper.AddColumn(const AFieldName, ACaption: string;
  AWidth: Integer; AAlignment: TDCTextAlignment): TDCMasterDetailGrid;
begin
  AddConfiguredColumn(Columns, AFieldName, ACaption, AWidth, AAlignment);
  RefreshGrid;
  Result := Self;
end;

function TDCFlexGridFluentHelper.AddTextColumn(const AFieldName,
  ACaption: string; AWidth: Integer): TDCMasterDetailGrid;
begin
  Result := AddColumn(AFieldName, ACaption, AWidth, taLeft);
end;

function TDCFlexGridFluentHelper.AddCenterColumn(const AFieldName,
  ACaption: string; AWidth: Integer): TDCMasterDetailGrid;
begin
  Result := AddColumn(AFieldName, ACaption, AWidth, taCenter);
end;

function TDCFlexGridFluentHelper.AddRightColumn(const AFieldName,
  ACaption: string; AWidth: Integer): TDCMasterDetailGrid;
begin
  Result := AddColumn(AFieldName, ACaption, AWidth, taRight);
end;

function TDCFlexGridFluentHelper.AddIntegerColumn(const AFieldName,
  ACaption: string; AWidth: Integer): TDCMasterDetailGrid;
begin
  Result := AddColumn(AFieldName, ACaption, AWidth, taCenter);
end;

function TDCFlexGridFluentHelper.AddCurrencyColumn(const AFieldName,
  ACaption: string; AWidth: Integer): TDCMasterDetailGrid;
begin
  Result := AddColumn(AFieldName, ACaption, AWidth, taRight);
end;

function TDCFlexGridFluentHelper.AddDateColumn(const AFieldName, ACaption: string;
  AWidth: Integer): TDCMasterDetailGrid;
begin
  Result := AddColumn(AFieldName, ACaption, AWidth, taCenter);
end;

function TDCFlexGridFluentHelper.AddStatusColumn(const AFieldName,
  ACaption: string; AWidth: Integer): TDCMasterDetailGrid;
begin
  Result := AddColumn(AFieldName, ACaption, AWidth, taLeft);
end;

function TDCFlexGridFluentHelper.Column(
  const AFieldName: string): IDCGridColumnBuilder;
begin
  Result := BeginConfiguredColumn(Columns, AFieldName);
end;

function TDCFlexGridFluentHelper.AddDetailColumn(const AFieldName,
  ACaption: string; AWidth: Integer; AAlignment: TDCTextAlignment): TDCMasterDetailGrid;
begin
  AddConfiguredColumn(DetailColumns, AFieldName, ACaption, AWidth, AAlignment);
  RefreshGrid;
  Result := Self;
end;

function TDCFlexGridFluentHelper.AddDetailTextColumn(const AFieldName,
  ACaption: string; AWidth: Integer): TDCMasterDetailGrid;
begin
  Result := AddDetailColumn(AFieldName, ACaption, AWidth, taLeft);
end;

function TDCFlexGridFluentHelper.AddDetailCenterColumn(const AFieldName,
  ACaption: string; AWidth: Integer): TDCMasterDetailGrid;
begin
  Result := AddDetailColumn(AFieldName, ACaption, AWidth, taCenter);
end;

function TDCFlexGridFluentHelper.AddDetailRightColumn(const AFieldName,
  ACaption: string; AWidth: Integer): TDCMasterDetailGrid;
begin
  Result := AddDetailColumn(AFieldName, ACaption, AWidth, taRight);
end;

function TDCFlexGridFluentHelper.AddDetailIntegerColumn(const AFieldName,
  ACaption: string; AWidth: Integer): TDCMasterDetailGrid;
begin
  Result := AddDetailColumn(AFieldName, ACaption, AWidth, taCenter);
end;

function TDCFlexGridFluentHelper.AddDetailCurrencyColumn(const AFieldName,
  ACaption: string; AWidth: Integer): TDCMasterDetailGrid;
begin
  Result := AddDetailColumn(AFieldName, ACaption, AWidth, taRight);
end;

function TDCFlexGridFluentHelper.AddDetailDateColumn(const AFieldName,
  ACaption: string; AWidth: Integer): TDCMasterDetailGrid;
begin
  Result := AddDetailColumn(AFieldName, ACaption, AWidth, taCenter);
end;

function TDCFlexGridFluentHelper.AddDetailStatusColumn(const AFieldName,
  ACaption: string; AWidth: Integer): TDCMasterDetailGrid;
begin
  Result := AddDetailColumn(AFieldName, ACaption, AWidth, taLeft);
end;

function TDCFlexGridFluentHelper.DetailColumn(
  const AFieldName: string): IDCGridColumnBuilder;
begin
  Result := BeginConfiguredColumn(DetailColumns, AFieldName);
end;

function TDCFlexGridFluentHelper.WithRowHeight(AValue: Integer): TDCMasterDetailGrid;
begin
  RowHeight := AValue;
  Result := Self;
end;

function TDCFlexGridFluentHelper.WithHeaderHeight(AValue: Integer): TDCMasterDetailGrid;
begin
  HeaderHeight := AValue;
  Result := Self;
end;

function TDCFlexGridFluentHelper.WithDetailHeight(AValue: Integer): TDCMasterDetailGrid;
begin
  DetailHeight := AValue;
  Result := Self;
end;

function TDCFlexGridFluentHelper.WithDetailGridHeaderHeight(AValue: Integer): TDCMasterDetailGrid;
begin
  DetailGridHeaderHeight := AValue;
  Result := Self;
end;

function TDCFlexGridFluentHelper.WithDetailGridRowHeight(AValue: Integer): TDCMasterDetailGrid;
begin
  DetailGridRowHeight := AValue;
  Result := Self;
end;

function TDCFlexGridFluentHelper.WithExpandMode(AValue: TDCExpandMode): TDCMasterDetailGrid;
begin
  ExpandMode := AValue;
  Result := Self;
end;

function TDCFlexGridFluentHelper.WithDetailStyle(AValue: TDCDetailStyle): TDCMasterDetailGrid;
begin
  DetailStyle := AValue;
  Result := Self;
end;

function TDCFlexGridFluentHelper.WithSearch(const AValue: string;
  AFilterMode: TDCFilterMode; ASearchScope: TDCSearchScope): TDCMasterDetailGrid;
begin
  FilterMode := AFilterMode;
  SearchScope := ASearchScope;
  SearchText := AValue;
  Result := Self;
end;

function TDCFlexGridFluentHelper.WithLayout(const ALayoutKey: string;
  AAutoLoad, AAutoSave: Boolean): TDCMasterDetailGrid;
begin
  LayoutKey := ALayoutKey;
  AutoLoadLayout := AAutoLoad;
  AutoSaveLayout := AAutoSave;
  Result := Self;
end;

function TDCFlexGridFluentHelper.WithMinColumnWidth(AValue: Integer): TDCMasterDetailGrid;
begin
  MinColumnWidth := AValue;
  Result := Self;
end;

function TDCFlexGridFluentHelper.WithAlternateColors(AValue: Boolean): TDCMasterDetailGrid;
begin
  AlternateColors := AValue;
  Result := Self;
end;

function TDCFlexGridFluentHelper.WithHeaderVisible(AValue: Boolean): TDCMasterDetailGrid;
begin
  ShowHeader := AValue;
  Result := Self;
end;

function TDCFlexGridFluentHelper.WithExpandButton(AValue: Boolean): TDCMasterDetailGrid;
begin
  ShowExpandButton := AValue;
  Result := Self;
end;

function TDCFlexGridFluentHelper.WithSort(AValue: Boolean): TDCMasterDetailGrid;
begin
  AllowColumnSort := AValue;
  Result := Self;
end;

function TDCFlexGridFluentHelper.WithColumnResize(AValue: Boolean): TDCMasterDetailGrid;
begin
  AllowColumnResize := AValue;
  Result := Self;
end;

function TDCFlexGridFluentHelper.WithDetailColumnResize(AValue: Boolean): TDCMasterDetailGrid;
begin
  AllowDetailColumnResize := AValue;
  Result := Self;
end;

function TDCFlexGridFluentHelper.WithAutoExpandOnSearch(AValue: Boolean): TDCMasterDetailGrid;
begin
  AutoExpandOnSearch := AValue;
  Result := Self;
end;

function TDCFlexGridFluentHelper.WithDefaultVisuals: TDCMasterDetailGrid;
begin
  AlternateColors := True;
  ShowHeader := True;
  ShowExpandButton := True;
  Result := Self;
end;

function TDCFlexGridFluentHelper.WithReadOnlyLayout: TDCMasterDetailGrid;
begin
  AllowColumnSort := False;
  AllowColumnResize := False;
  AllowDetailColumnResize := False;
  AutoSaveLayout := False;
  Result := Self;
end;

function TDCFlexGridFluentHelper.WithInteractiveLayout: TDCMasterDetailGrid;
begin
  AllowColumnSort := True;
  AllowColumnResize := True;
  AllowDetailColumnResize := True;
  Result := Self;
end;

function TDCFlexGridFluentHelper.WithSearchContains(const AValue: string;
  ASearchScope: TDCSearchScope): TDCMasterDetailGrid;
begin
  Result := WithSearch(AValue, fmContains, ASearchScope);
end;

function TDCFlexGridFluentHelper.WithSearchStartsWith(const AValue: string;
  ASearchScope: TDCSearchScope): TDCMasterDetailGrid;
begin
  Result := WithSearch(AValue, fmStartsWith, ASearchScope);
end;

function TDCFlexGridFluentHelper.WithSearchEquals(const AValue: string;
  ASearchScope: TDCSearchScope): TDCMasterDetailGrid;
begin
  Result := WithSearch(AValue, fmEquals, ASearchScope);
end;

function TDCFlexGridFluentHelper.WithSearchMasterOnly: TDCMasterDetailGrid;
begin
  SearchScope := ssMasterOnly;
  Result := Self;
end;

function TDCFlexGridFluentHelper.WithSearchMasterAndDetail: TDCMasterDetailGrid;
begin
  SearchScope := ssMasterAndDetail;
  Result := Self;
end;

function TDCFlexGridFluentHelper.WithSingleExpand: TDCMasterDetailGrid;
begin
  ExpandMode := emSingle;
  Result := Self;
end;

function TDCFlexGridFluentHelper.WithMultipleExpand: TDCMasterDetailGrid;
begin
  ExpandMode := emMultiple;
  Result := Self;
end;

function TDCFlexGridFluentHelper.WithDetailTextStyle: TDCMasterDetailGrid;
begin
  DetailStyle := dsText;
  Result := Self;
end;

function TDCFlexGridFluentHelper.WithDetailGridStyle: TDCMasterDetailGrid;
begin
  DetailStyle := dsGrid;
  Result := Self;
end;

function TDCFlexGridFluentHelper.WithBorderWidth(AValue: Integer): TDCMasterDetailGrid;
begin
  BorderWidth := AValue;
  Result := Self;
end;

function TDCFlexGridFluentHelper.WithExpandOnRowClick(AValue: Boolean): TDCMasterDetailGrid;
begin
  ExpandOnRowClick := AValue;
  Result := Self;
end;

function TDCFlexGridFluentHelper.WithDetailSelection(AValue: Boolean): TDCMasterDetailGrid;
begin
  DetailSelectEnabled := AValue;
  Result := Self;
end;

function TDCFlexGridFluentHelper.WithTitleFontSize(AValue: Integer): TDCMasterDetailGrid;
begin
  TitleFont.Size := AValue;
  Invalidate;
  Result := Self;
end;

function TDCFlexGridFluentHelper.WithDetailFontSize(AValue: Integer): TDCMasterDetailGrid;
begin
  DetailFont.Size := AValue;
  Invalidate;
  Result := Self;
end;

function TDCFlexGridFluentHelper.WithTitleBold(AValue: Boolean): TDCMasterDetailGrid;
begin
  if AValue then
    TitleFont.Style := TitleFont.Style + [fsBold]
  else
    TitleFont.Style := TitleFont.Style - [fsBold];
  Invalidate;
  Result := Self;
end;

function TDCFlexGridFluentHelper.WithDetailBold(AValue: Boolean): TDCMasterDetailGrid;
begin
  if AValue then
    DetailFont.Style := DetailFont.Style + [fsBold]
  else
    DetailFont.Style := DetailFont.Style - [fsBold];
  Invalidate;
  Result := Self;
end;

function TDCFlexGridFluentHelper.WithThemePreset(
  APreset: TDCGridThemePreset): TDCMasterDetailGrid;
begin
  TDCGridThemeManager.ApplyPreset(Self, APreset);
  Result := Self;
end;

function TDCFlexGridFluentHelper.WithMetricsPreset(
  APreset: TDCGridMetricsPreset): TDCMasterDetailGrid;
begin
  TDCGridThemeManager.ApplyMetricsPreset(Self, APreset);
  Result := Self;
end;

function TDCFlexGridFluentHelper.WithProfessionalTheme: TDCMasterDetailGrid;
begin
  Result := WithThemePreset(gtpProfessional);
end;

function TDCFlexGridFluentHelper.WithDarkModernTheme: TDCMasterDetailGrid;
begin
  Result := WithThemePreset(gtpDarkModern);
end;

function TDCFlexGridFluentHelper.WithERPBlueTheme: TDCMasterDetailGrid;
begin
  Result := WithThemePreset(gtpERPBlue);
end;

function TDCFlexGridFluentHelper.WithGreenTheme: TDCMasterDetailGrid;
begin
  Result := WithThemePreset(gtpGreen);
end;

function TDCFlexGridFluentHelper.WithMinimalTheme: TDCMasterDetailGrid;
begin
  Result := WithThemePreset(gtpMinimal);
end;

function TDCFlexGridFluentHelper.WithCompactMetrics: TDCMasterDetailGrid;
begin
  Result := WithMetricsPreset(gmpCompact);
end;

function TDCFlexGridFluentHelper.WithComfortableMetrics: TDCMasterDetailGrid;
begin
  Result := WithMetricsPreset(gmpComfortable);
end;

function TDCFlexGridFluentHelper.BindDataSets(AMasterDataSet,
  ADetailDataSet: TDataSet; const AMasterKeyField,
  ADetailKeyField: string): TDCMasterDetailGrid;
begin
  DataSetAdapter.DataSet := AMasterDataSet;
  DataSetAdapter.DetailDataSet := ADetailDataSet;
  DataSetAdapter.MasterKeyField := AMasterKeyField;
  DataSetAdapter.DetailKeyField := ADetailKeyField;
  DataAdapter := DataSetAdapter;
  RefreshGrid;
  Result := Self;
end;

end.
