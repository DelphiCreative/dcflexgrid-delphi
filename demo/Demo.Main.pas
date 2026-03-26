unit Demo.Main;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Vcl.Dialogs,
  Data.DB,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  FireDAC.Comp.Client,
  FireDAC.Comp.DataSet,
  FireDAC.Phys,
  FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef,
  FireDAC.UI.Intf,
  DCFlexGrid, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.VCLUI.Wait,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat;

type
  TForm1 = class(TForm)
    pnlHeader: TPanel;
    lblTitle: TLabel;
    lblSubTitle: TLabel;
    pnlSidebar: TPanel;

    PageControl1: TPageControl;
    tsBehavior: TTabSheet;
    tsTheme: TTabSheet;
    sbTheme: TScrollBox;
    tsAdvanced: TTabSheet;
    chkDetailSelectEnabled: TCheckBox;
    lblDetailHeight: TLabel;
    tbDetailHeight: TTrackBar;
    chkDebugLog: TCheckBox;
    lblMinColumnWidth: TLabel;
    tbMinColumnWidth: TTrackBar;
    btnApplyRecommended: TButton;
    btnExpandSelected: TButton;
    btnCollapseSelected: TButton;
    lblAdvancedInfo: TLabel;

    chkBusinessEngine: TCheckBox;
    lblBusinessField: TLabel;
    edtBusinessField: TEdit;
    lblRuleExpr: TLabel;
    edtRuleExpr: TEdit;
    lblRuleBackColor: TLabel;
    cbxRuleBackColor: TColorBox;
    lblRuleFontColor: TLabel;
    cbxRuleFontColor: TColorBox;
    btnAddRule: TButton;
    btnClearRules: TButton;
    btnPresetFinance: TButton;
    lstBusinessRules: TListBox;
    lblSearch: TLabel;
    edtSearch: TEdit;
    lblFilterMode: TLabel;
    cbFilterMode: TComboBox;
    lblSearchScope: TLabel;
    cbSearchScope: TComboBox;
    chkAutoExpandSearch: TCheckBox;
    chkExpandOnRowClick: TCheckBox;
    chkAlternateColors: TCheckBox;
    chkShowHeader: TCheckBox;
    chkShowExpandButton: TCheckBox;
    chkAllowSort: TCheckBox;
    chkDarkTheme: TCheckBox;
    chkBusinessHighlight: TCheckBox;
    lblRowHeight: TLabel;
    tbRowHeight: TTrackBar;
    lblHeaderHeight: TLabel;
    tbHeaderHeight: TTrackBar;
    lblDetailRowHeight: TLabel;
    tbDetailRowHeight: TTrackBar;
    lblDetailHeaderHeight: TLabel;
    tbDetailHeaderHeight: TTrackBar;
    lblDetailStyle: TLabel;
    cbDetailStyle: TComboBox;
    lblExpandMode: TLabel;
    cbExpandMode: TComboBox;
    lblThemeColors: TLabel;
    lblHeaderColor: TLabel;
    cbxHeaderColor: TColorBox;
    lblRowColor: TLabel;
    cbxRowColor: TColorBox;
    lblAltRowColor: TLabel;
    cbxAltRowColor: TColorBox;
    lblHoverColor: TLabel;
    cbxHoverColor: TColorBox;
    lblSelectedColor: TLabel;
    cbxSelectedColor: TColorBox;
    lblSelectedTextColor: TLabel;
    cbxSelectedTextColor: TColorBox;
    lblSearchHighlightColor: TLabel;
    cbxSearchHighlightColor: TColorBox;
    lblSearchHighlightTextColor: TLabel;
    cbxSearchHighlightTextColor: TColorBox;
    lblDetailColor: TLabel;
    cbxDetailColor: TColorBox;
    lblTextColor: TLabel;
    cbxTextColor: TColorBox;

    lblHeaderFontColor: TLabel;
    cbxHeaderFontColor: TColorBox;
    lblGridBackgroundColor: TLabel;
    cbxGridBackgroundColor: TColorBox;
    lblBorderColor: TLabel;
    cbxBorderColor: TColorBox;
    lblDetailBorderColor: TLabel;
    cbxDetailBorderColor: TColorBox;
    lblDetailTextColor: TLabel;
    cbxDetailTextColor: TColorBox;
    lblExpandButtonColor: TLabel;
    cbxExpandButtonColor: TColorBox;
    lblDetailGridHeaderColor: TLabel;
    cbxDetailGridHeaderColor: TColorBox;
    lblDetailGridHeaderFontColor: TLabel;
    cbxDetailGridHeaderFontColor: TColorBox;
    lblDetailGridRowColor: TLabel;
    cbxDetailGridRowColor: TColorBox;
    lblDetailGridAltColor: TLabel;
    cbxDetailGridAltColor: TColorBox;
    lblDetailGridLineColor: TLabel;
    cbxDetailGridLineColor: TColorBox;
    btnExpandAll: TButton;
    btnCollapseAll: TButton;
    btnAutoSize: TButton;
    btnSaveLayout: TButton;
    btnLoadLayout: TButton;
    btnResetLayout: TButton;
    btnExportTheme: TButton;
    memThemeCode: TMemo;

    btnHeaderColor: TButton;
    btnRowColor: TButton;
    btnAltRowColor: TButton;
    btnHoverColor: TButton;
    btnSelectedColor: TButton;
    btnSelectedTextColor: TButton;
    btnSearchHighlightColor: TButton;
    btnSearchHighlightTextColor: TButton;
    btnDetailColor: TButton;
    btnTextColor: TButton;
    btnHeaderFontColor: TButton;
    btnGridBackgroundColor: TButton;
    btnBorderColor: TButton;
    btnDetailBorderColor: TButton;
    btnDetailTextColor: TButton;
    btnExpandButtonColor: TButton;
    btnDetailGridHeaderColor: TButton;
    btnDetailGridHeaderFontColor: TButton;
    btnDetailGridRowColor: TButton;
    btnDetailGridAltColor: TButton;
    btnDetailGridLineColor: TButton;
    shpHeaderColor: TPanel;
    shpRowColor: TPanel;
    shpAltRowColor: TPanel;
    shpHoverColor: TPanel;
    shpSelectedColor: TPanel;
    shpSelectedTextColor: TPanel;
    shpSearchHighlightColor: TPanel;
    shpSearchHighlightTextColor: TPanel;
    shpDetailColor: TPanel;
    shpTextColor: TPanel;
    shpHeaderFontColor: TPanel;
    shpGridBackgroundColor: TPanel;
    shpBorderColor: TPanel;
    shpDetailBorderColor: TPanel;
    shpDetailTextColor: TPanel;
    shpExpandButtonColor: TPanel;
    shpDetailGridHeaderColor: TPanel;
    shpDetailGridHeaderFontColor: TPanel;
    shpDetailGridRowColor: TPanel;
    shpDetailGridAltColor: TPanel;
    shpDetailGridLineColor: TPanel;
    lblHeaderColorHex: TLabel;
    lblRowColorHex: TLabel;
    lblAltRowColorHex: TLabel;
    lblHoverColorHex: TLabel;
    lblSelectedColorHex: TLabel;
    lblSelectedTextColorHex: TLabel;
    lblSearchHighlightColorHex: TLabel;
    lblSearchHighlightTextColorHex: TLabel;
    lblDetailColorHex: TLabel;
    lblTextColorHex: TLabel;
    lblHeaderFontColorHex: TLabel;
    lblGridBackgroundColorHex: TLabel;
    lblBorderColorHex: TLabel;
    lblDetailBorderColorHex: TLabel;
    lblDetailTextColorHex: TLabel;
    lblExpandButtonColorHex: TLabel;
    lblDetailGridHeaderColorHex: TLabel;
    lblDetailGridHeaderFontColorHex: TLabel;
    lblDetailGridRowColorHex: TLabel;
    lblDetailGridAltColorHex: TLabel;
    lblDetailGridLineColorHex: TLabel;
    pnlMain: TPanel;
    lblStatus: TLabel;
    DCGrid1: TDCFlexGrid;
    FDConnection1: TFDConnection;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    qryOrders: TFDQuery;
    qryItems: TFDQuery;
    ColorDialog1: TColorDialog;
    procedure FormCreate(Sender: TObject);
    procedure DCGrid1SortColumn(Sender: TObject; ACol: Integer; ADirection: TDCSortDirection);
    procedure DCGrid1DetailRowClick(Sender: TObject; AMasterRow, ADetailRow: Integer);
    procedure DCGrid1DetailRowDblClick(Sender: TObject; AMasterRow, ADetailRow: Integer);
    procedure DCGrid1RightClickHitTest(Sender: TObject; Area: TDCHitTestArea; AMasterRow, ADetailRow, ACol: Integer; const ScreenPt: TPoint);
    procedure DCGrid1GetMasterRowStyle(Sender: TObject; ARow: Integer; var ABackColor, AFontColor: TColor; var AFontStyles: TFontStyles);
    procedure DCGrid1GetDetailRowStyle(Sender: TObject; AMasterRow, ADetailRow: Integer; var ABackColor, AFontColor: TColor; var AFontStyles: TFontStyles);
  private
    FDBPath: string;
    procedure PrepareDatabase;
    procedure SeedData;
    procedure OpenData(const AOrderBy: string = '');
    function BuildOrdersSQL(const AOrderBy: string): string;
    procedure ApplyGridSettings;
    procedure ApplyTheme;
    procedure LoadThemeEditorsFromGrid;
    procedure ApplyThemeEditorsToGrid;
    procedure ConfigureColorBoxes;
    procedure UpdateThemePreview;
    procedure ChooseThemeColor(AColorBox: TColorBox);
    procedure FillThemeCodeMemo;
    procedure UpdateAdvancedLabels;
    procedure ApplyAdvancedSettings;
    procedure ApplyRecommendedPreset;
    procedure RefreshBusinessRulesUI;
    procedure ApplyBusinessHighlightUI;
    procedure AddBusinessRule(const AExpr: string; ABackColor, AFontColor: TColor; AFontStyles: TFontStyles = []);
    procedure LoadBusinessHighlightPreset;
    procedure UpdateStatus;
    procedure UpdateLabels;
  published
    procedure edtSearchChange(Sender: TObject);
    procedure cbFilterModeChange(Sender: TObject);
    procedure cbSearchScopeChange(Sender: TObject);
    procedure chkAutoExpandSearchClick(Sender: TObject);
    procedure GenericSettingClick(Sender: TObject);
    procedure TrackBarChange(Sender: TObject);
    procedure cbDetailStyleChange(Sender: TObject);
    procedure cbExpandModeChange(Sender: TObject);
    procedure btnExpandAllClick(Sender: TObject);
    procedure btnCollapseAllClick(Sender: TObject);
    procedure btnAutoSizeClick(Sender: TObject);
    procedure btnSaveLayoutClick(Sender: TObject);
    procedure btnLoadLayoutClick(Sender: TObject);
    procedure btnResetLayoutClick(Sender: TObject);
    procedure btnExportThemeClick(Sender: TObject);
    procedure cbThemeColorChange(Sender: TObject);
    procedure btnThemeChooseClick(Sender: TObject);
    procedure btnApplyRecommendedClick(Sender: TObject);
    procedure btnExpandSelectedClick(Sender: TObject);
    procedure btnCollapseSelectedClick(Sender: TObject);
    procedure chkBusinessEngineClick(Sender: TObject);
    procedure btnAddRuleClick(Sender: TObject);
    procedure btnClearRulesClick(Sender: TObject);
    procedure btnPresetFinanceClick(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.PrepareDatabase;
begin
  FDBPath := TPath.Combine(ExtractFilePath(Application.ExeName), 'dcgrid_showcase.db');

  FDConnection1.Connected := False;
  FDConnection1.Params.Clear;
  FDConnection1.Params.DriverID := 'SQLite';
  FDConnection1.Params.Database := FDBPath;
  FDConnection1.LoginPrompt := False;
  FDConnection1.Connected := True;

  FDConnection1.ExecSQL(
    'CREATE TABLE IF NOT EXISTS orders (' +
    '  pedido INTEGER PRIMARY KEY, ' +
    '  cliente TEXT NOT NULL, ' +
    '  cidade TEXT NOT NULL, ' +
    '  total_value NUMERIC NOT NULL, ' +
    '  prioridade TEXT NOT NULL, ' +
    '  status TEXT NOT NULL, ' +
    '  total_fmt TEXT NOT NULL' +
    ')'
  );

  FDConnection1.ExecSQL(
    'CREATE TABLE IF NOT EXISTS order_items (' +
    '  id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
    '  pedido INTEGER NOT NULL, ' +
    '  produto TEXT NOT NULL, ' +
    '  qtde INTEGER NOT NULL, ' +
    '  valor_fmt TEXT NOT NULL' +
    ')'
  );

  SeedData;
end;

procedure TForm1.SeedData;
var
  LCount: Integer;
begin
  LCount := FDConnection1.ExecSQLScalar('SELECT COUNT(*) FROM orders');
  if LCount > 0 then
    Exit;

  FDConnection1.ExecSQL('INSERT INTO orders (pedido, cliente, cidade, total_value, prioridade, status, total_fmt) VALUES (1001, ''John Smith'', ''New York'', 439.70, ''High'', ''Paid'', ''$439.70'')');
  FDConnection1.ExecSQL('INSERT INTO orders (pedido, cliente, cidade, total_value, prioridade, status, total_fmt) VALUES (1002, ''Emily Johnson'', ''Los Angeles'', 879.70, ''Critical'', ''Pending'', ''$879.70'')');
  FDConnection1.ExecSQL('INSERT INTO orders (pedido, cliente, cidade, total_value, prioridade, status, total_fmt) VALUES (1003, ''Michael Brown'', ''Chicago'', 559.70, ''Medium'', ''Paid'', ''$559.70'')');
  FDConnection1.ExecSQL('INSERT INTO orders (pedido, cliente, cidade, total_value, prioridade, status, total_fmt) VALUES (1004, ''Diego Cataneo'', ''São Paulo'', 139.90, ''Low'', ''Delivered'', ''$139.90'')');
  FDConnection1.ExecSQL('INSERT INTO orders (pedido, cliente, cidade, total_value, prioridade, status, total_fmt) VALUES (1005, ''Olivia Davis'', ''Houston'', 369.80, ''High'', ''Processing'', ''$369.80'')');
  FDConnection1.ExecSQL('INSERT INTO orders (pedido, cliente, cidade, total_value, prioridade, status, total_fmt) VALUES (1006, ''Sophia Wilson'', ''Miami'', 259.80, ''Medium'', ''Paid'', ''$259.80'')');

  FDConnection1.ExecSQL('INSERT INTO order_items (pedido, produto, qtde, valor_fmt) VALUES (1001, ''Mouse gamer'', 2, ''R$ 89,90'')');
  FDConnection1.ExecSQL('INSERT INTO order_items (pedido, produto, qtde, valor_fmt) VALUES (1001, ''Teclado mecânico'', 1, ''R$ 259,90'')');
  FDConnection1.ExecSQL('INSERT INTO order_items (pedido, produto, qtde, valor_fmt) VALUES (1002, ''Monitor 24"'', 1, ''R$ 799,90'')');
  FDConnection1.ExecSQL('INSERT INTO order_items (pedido, produto, qtde, valor_fmt) VALUES (1002, ''Cabo HDMI'', 2, ''R$ 39,90'')');
  FDConnection1.ExecSQL('INSERT INTO order_items (pedido, produto, qtde, valor_fmt) VALUES (1003, ''SSD 1TB'', 1, ''R$ 449,90'')');
  FDConnection1.ExecSQL('INSERT INTO order_items (pedido, produto, qtde, valor_fmt) VALUES (1003, ''Case USB'', 1, ''R$ 79,90'')');
  FDConnection1.ExecSQL('INSERT INTO order_items (pedido, produto, qtde, valor_fmt) VALUES (1003, ''Pasta térmica'', 1, ''R$ 29,90'')');
  FDConnection1.ExecSQL('INSERT INTO order_items (pedido, produto, qtde, valor_fmt) VALUES (1004, ''Notebook stand'', 1, ''R$ 139,90'')');
  FDConnection1.ExecSQL('INSERT INTO order_items (pedido, produto, qtde, valor_fmt) VALUES (1005, ''Hub USB-C'', 1, ''R$ 119,90'')');
  FDConnection1.ExecSQL('INSERT INTO order_items (pedido, produto, qtde, valor_fmt) VALUES (1005, ''Capa protetora'', 1, ''R$ 49,90'')');
  FDConnection1.ExecSQL('INSERT INTO order_items (pedido, produto, qtde, valor_fmt) VALUES (1005, ''Mouse pad'', 1, ''R$ 29,90'')');
  FDConnection1.ExecSQL('INSERT INTO order_items (pedido, produto, qtde, valor_fmt) VALUES (1006, ''Webcam Full HD'', 1, ''R$ 259,80'')');
end;

function TForm1.BuildOrdersSQL(const AOrderBy: string): string;
begin
  Result :=
    'SELECT pedido, cliente, cidade, prioridade, status, total_value, total_fmt ' +
    'FROM orders ';
  if Trim(AOrderBy) <> '' then
    Result := Result + 'ORDER BY ' + AOrderBy;
end;

procedure TForm1.OpenData(const AOrderBy: string);
begin
  qryOrders.Close;
  qryOrders.Connection := FDConnection1;
  qryOrders.SQL.Text := BuildOrdersSQL(AOrderBy);
  qryOrders.Open;

  qryItems.Close;
  qryItems.Connection := FDConnection1;
  qryItems.SQL.Text :=
    'SELECT pedido, produto, CAST(qtde AS TEXT) AS qtde, valor_fmt ' +
    'FROM order_items ' +
    'ORDER BY pedido, id';
  qryItems.Open;

  DCGrid1.DataSetAdapter.DataSet := qryOrders;
  DCGrid1.DataSetAdapter.DetailDataSet := qryItems;
  DCGrid1.DataSetAdapter.MasterKeyField := 'pedido';
  DCGrid1.DataSetAdapter.DetailKeyField := 'pedido';
  DCGrid1.DataAdapter := DCGrid1.DataSetAdapter;
  DCGrid1.RefreshGrid;
end;


procedure TForm1.LoadThemeEditorsFromGrid;
begin
  cbxHeaderColor.Selected := DCGrid1.Theme.HeaderColor;
  cbxHeaderFontColor.Selected := DCGrid1.Theme.HeaderFontColor;
  cbxGridBackgroundColor.Selected := DCGrid1.Theme.GridBackgroundColor;
  cbxRowColor.Selected := DCGrid1.Theme.RowColor;
  cbxAltRowColor.Selected := DCGrid1.Theme.AlternateRowColor;
  cbxHoverColor.Selected := DCGrid1.Theme.HoverRowColor;
  cbxSelectedColor.Selected := DCGrid1.Theme.SelectedRowColor;
  cbxSelectedTextColor.Selected := DCGrid1.Theme.SelectedTextColor;
  cbxSearchHighlightColor.Selected := DCGrid1.Theme.SearchHighlightColor;
  cbxSearchHighlightTextColor.Selected := DCGrid1.Theme.SearchHighlightTextColor;
  cbxDetailColor.Selected := DCGrid1.Theme.DetailColor;
  cbxBorderColor.Selected := DCGrid1.Theme.BorderColor;
  cbxDetailBorderColor.Selected := DCGrid1.Theme.DetailBorderColor;
  cbxTextColor.Selected := DCGrid1.Theme.TextColor;
  cbxDetailTextColor.Selected := DCGrid1.Theme.DetailTextColor;
  cbxExpandButtonColor.Selected := DCGrid1.Theme.ExpandButtonColor;
  cbxDetailGridHeaderColor.Selected := DCGrid1.Theme.DetailGridHeaderColor;
  cbxDetailGridHeaderFontColor.Selected := DCGrid1.Theme.DetailGridHeaderFontColor;
  cbxDetailGridRowColor.Selected := DCGrid1.Theme.DetailGridRowColor;
  cbxDetailGridAltColor.Selected := DCGrid1.Theme.DetailGridAlternateRowColor;
  cbxDetailGridLineColor.Selected := DCGrid1.Theme.DetailGridLineColor;
end;

procedure TForm1.ApplyThemeEditorsToGrid;
begin
  DCGrid1.Theme.HeaderColor := cbxHeaderColor.Selected;
  DCGrid1.Theme.HeaderFontColor := cbxHeaderFontColor.Selected;
  DCGrid1.Theme.GridBackgroundColor := cbxGridBackgroundColor.Selected;
  DCGrid1.Theme.RowColor := cbxRowColor.Selected;
  DCGrid1.Theme.AlternateRowColor := cbxAltRowColor.Selected;
  DCGrid1.Theme.HoverRowColor := cbxHoverColor.Selected;
  DCGrid1.Theme.SelectedRowColor := cbxSelectedColor.Selected;
  DCGrid1.Theme.SelectedTextColor := cbxSelectedTextColor.Selected;
  DCGrid1.Theme.SearchHighlightColor := cbxSearchHighlightColor.Selected;
  DCGrid1.Theme.SearchHighlightTextColor := cbxSearchHighlightTextColor.Selected;
  DCGrid1.Theme.DetailColor := cbxDetailColor.Selected;
  DCGrid1.Theme.BorderColor := cbxBorderColor.Selected;
  DCGrid1.Theme.DetailBorderColor := cbxDetailBorderColor.Selected;
  DCGrid1.Theme.TextColor := cbxTextColor.Selected;
  DCGrid1.Theme.DetailTextColor := cbxDetailTextColor.Selected;
  DCGrid1.Theme.ExpandButtonColor := cbxExpandButtonColor.Selected;
  DCGrid1.Theme.DetailGridHeaderColor := cbxDetailGridHeaderColor.Selected;
  DCGrid1.Theme.DetailGridHeaderFontColor := cbxDetailGridHeaderFontColor.Selected;
  DCGrid1.Theme.DetailGridRowColor := cbxDetailGridRowColor.Selected;
  DCGrid1.Theme.DetailGridAlternateRowColor := cbxDetailGridAltColor.Selected;
  DCGrid1.Theme.DetailGridLineColor := cbxDetailGridLineColor.Selected;
  DCGrid1.RefreshGrid;
  FillThemeCodeMemo;
end;

procedure TForm1.ApplyTheme;
begin
  if chkDarkTheme.Checked then
  begin
    Color := $0023292E;
    pnlHeader.Color := $0023292E;
    pnlSidebar.Color := $002B3137;
    pnlMain.Color := $0023292E;
    lblTitle.Font.Color := clWhite;
    lblSubTitle.Font.Color := $00D7D7D7;
    lblStatus.Font.Color := clWhite;

    DCGrid1.Color := $0023292E;
    DCGrid1.Theme.HeaderColor := $00303A46;
    DCGrid1.Theme.HeaderFontColor := clWhite;
    DCGrid1.Theme.GridBackgroundColor := $0023292E;
    DCGrid1.Theme.RowColor := $002B3137;
    DCGrid1.Theme.AlternateRowColor := $00303841;
    DCGrid1.Theme.HoverRowColor := $00404854;
    DCGrid1.Theme.SelectedRowColor := $00526578;
    DCGrid1.Theme.SelectedTextColor := clWhite;
    DCGrid1.Theme.SearchHighlightColor := $004B5D73;
    DCGrid1.Theme.SearchHighlightTextColor := clWhite;
    DCGrid1.Theme.TextColor := clWhite;
    DCGrid1.Theme.DetailColor := $00262D34;
    DCGrid1.Theme.DetailTextColor := clWhite;
    DCGrid1.Theme.DetailGridHeaderColor := $00303A46;
    DCGrid1.Theme.DetailGridHeaderFontColor := clWhite;
    DCGrid1.Theme.DetailGridRowColor := $002B3137;
    DCGrid1.Theme.DetailGridAlternateRowColor := $00303841;
  end
  else
  begin
    Color := clBtnFace;
    pnlHeader.Color := clWhite;
    pnlSidebar.Color := $00F5F7FA;
    pnlMain.Color := clWhite;
    lblTitle.Font.Color := clBlack;
    lblSubTitle.Font.Color := $00606060;
    lblStatus.Font.Color := $00313A47;

    DCGrid1.Color := clWhite;
    DCGrid1.Theme.HeaderColor := $00F3F6FB;
    DCGrid1.Theme.HeaderFontColor := $00313A47;
    DCGrid1.Theme.GridBackgroundColor := clWhite;
    DCGrid1.Theme.RowColor := clWhite;
    DCGrid1.Theme.AlternateRowColor := $00FAFBFD;
    DCGrid1.Theme.HoverRowColor := $00F0F6FF;
    DCGrid1.Theme.SelectedRowColor := $00E5F0FF;
    DCGrid1.Theme.SelectedTextColor := $00313A47;
    DCGrid1.Theme.SearchHighlightColor := $00FFF59D;
    DCGrid1.Theme.SearchHighlightTextColor := clBlack;
    DCGrid1.Theme.TextColor := $00313A47;
    DCGrid1.Theme.DetailColor := $00FBFCFE;
    DCGrid1.Theme.DetailTextColor := $00313A47;
    DCGrid1.Theme.DetailGridHeaderColor := $00F6F8FC;
    DCGrid1.Theme.DetailGridHeaderFontColor := $00313A47;
    DCGrid1.Theme.DetailGridRowColor := clWhite;
    DCGrid1.Theme.DetailGridAlternateRowColor := $00FAFBFD;
  end;
  LoadThemeEditorsFromGrid;
  DCGrid1.RefreshGrid;
end;

procedure TForm1.ApplyGridSettings;
begin
  DCGrid1.ExpandOnRowClick := chkExpandOnRowClick.Checked;
  DCGrid1.AlternateColors := chkAlternateColors.Checked;
  DCGrid1.ShowHeader := chkShowHeader.Checked;
  DCGrid1.ShowExpandButton := chkShowExpandButton.Checked;
  DCGrid1.AllowColumnSort := chkAllowSort.Checked;
  DCGrid1.AutoExpandOnSearch := chkAutoExpandSearch.Checked;

  case cbFilterMode.ItemIndex of
    1: DCGrid1.FilterMode := fmStartsWith;
    2: DCGrid1.FilterMode := fmEquals;
  else
    DCGrid1.FilterMode := fmContains;
  end;

  case cbSearchScope.ItemIndex of
    1: DCGrid1.SearchScope := ssMasterAndDetail;
  else
    DCGrid1.SearchScope := ssMasterOnly;
  end;

  if cbDetailStyle.ItemIndex = 1 then
    DCGrid1.DetailStyle := dsText
  else
    DCGrid1.DetailStyle := dsGrid;

  if cbExpandMode.ItemIndex = 1 then
    DCGrid1.ExpandMode := emSingle
  else
    DCGrid1.ExpandMode := emMultiple;

  if chkBusinessHighlight.Checked then
  begin
    DCGrid1.OnGetMasterRowStyle := DCGrid1GetMasterRowStyle;
    DCGrid1.OnGetDetailRowStyle := DCGrid1GetDetailRowStyle;
  end
  else
  begin
    DCGrid1.OnGetMasterRowStyle := nil;
    DCGrid1.OnGetDetailRowStyle := nil;
  end;

  ApplyTheme;
  ApplyThemeEditorsToGrid;
  ApplyAdvancedSettings;
  UpdateLabels;
  UpdateStatus;
end;

procedure TForm1.UpdateLabels;
begin
  lblRowHeight.Caption := Format('RowHeight: %d', [tbRowHeight.Position]);
  lblHeaderHeight.Caption := Format('HeaderHeight: %d', [tbHeaderHeight.Position]);
  lblDetailRowHeight.Caption := Format('DetailRowHeight: %d', [tbDetailRowHeight.Position]);
  lblDetailHeaderHeight.Caption := Format('DetailHeaderHeight: %d', [tbDetailHeaderHeight.Position]);
  UpdateAdvancedLabels;
end;



procedure TForm1.ConfigureColorBoxes;
const
  CStyle: TColorBoxStyle = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeDefault, cbCustomColor, cbPrettyNames, cbCustomColors];
begin
  cbxHeaderColor.Style := CStyle;
  cbxRowColor.Style := CStyle;
  cbxAltRowColor.Style := CStyle;
  cbxHoverColor.Style := CStyle;
  cbxSelectedColor.Style := CStyle;
  cbxSelectedTextColor.Style := CStyle;
  cbxSearchHighlightColor.Style := CStyle;
  cbxSearchHighlightTextColor.Style := CStyle;
  cbxDetailColor.Style := CStyle;
  cbxTextColor.Style := CStyle;
  cbxHeaderFontColor.Style := CStyle;
  cbxGridBackgroundColor.Style := CStyle;
  cbxBorderColor.Style := CStyle;
  cbxDetailBorderColor.Style := CStyle;
  cbxDetailTextColor.Style := CStyle;
  cbxExpandButtonColor.Style := CStyle;
  cbxDetailGridHeaderColor.Style := CStyle;
  cbxDetailGridHeaderFontColor.Style := CStyle;
  cbxDetailGridRowColor.Style := CStyle;
  cbxDetailGridAltColor.Style := CStyle;
  cbxDetailGridLineColor.Style := CStyle;
end;

procedure TForm1.UpdateThemePreview;
  function HexColor(AColor: TColor): string;
  begin
    Result := '$' + IntToHex(ColorToRGB(AColor), 8);
  end;
  procedure SetPreview(APanel: TPanel; ALabel: TLabel; AColor: TColor);
  begin
    APanel.Color := AColor;
    ALabel.Caption := HexColor(AColor);
  end;
begin
  SetPreview(shpHeaderColor, lblHeaderColorHex, cbxHeaderColor.Selected);
  SetPreview(shpRowColor, lblRowColorHex, cbxRowColor.Selected);
  SetPreview(shpAltRowColor, lblAltRowColorHex, cbxAltRowColor.Selected);
  SetPreview(shpHoverColor, lblHoverColorHex, cbxHoverColor.Selected);
  SetPreview(shpSelectedColor, lblSelectedColorHex, cbxSelectedColor.Selected);
  SetPreview(shpSelectedTextColor, lblSelectedTextColorHex, cbxSelectedTextColor.Selected);
  SetPreview(shpSearchHighlightColor, lblSearchHighlightColorHex, cbxSearchHighlightColor.Selected);
  SetPreview(shpSearchHighlightTextColor, lblSearchHighlightTextColorHex, cbxSearchHighlightTextColor.Selected);
  SetPreview(shpDetailColor, lblDetailColorHex, cbxDetailColor.Selected);
  SetPreview(shpTextColor, lblTextColorHex, cbxTextColor.Selected);
  SetPreview(shpHeaderFontColor, lblHeaderFontColorHex, cbxHeaderFontColor.Selected);
  SetPreview(shpGridBackgroundColor, lblGridBackgroundColorHex, cbxGridBackgroundColor.Selected);
  SetPreview(shpBorderColor, lblBorderColorHex, cbxBorderColor.Selected);
  SetPreview(shpDetailBorderColor, lblDetailBorderColorHex, cbxDetailBorderColor.Selected);
  SetPreview(shpDetailTextColor, lblDetailTextColorHex, cbxDetailTextColor.Selected);
  SetPreview(shpExpandButtonColor, lblExpandButtonColorHex, cbxExpandButtonColor.Selected);
  SetPreview(shpDetailGridHeaderColor, lblDetailGridHeaderColorHex, cbxDetailGridHeaderColor.Selected);
  SetPreview(shpDetailGridHeaderFontColor, lblDetailGridHeaderFontColorHex, cbxDetailGridHeaderFontColor.Selected);
  SetPreview(shpDetailGridRowColor, lblDetailGridRowColorHex, cbxDetailGridRowColor.Selected);
  SetPreview(shpDetailGridAltColor, lblDetailGridAltColorHex, cbxDetailGridAltColor.Selected);
  SetPreview(shpDetailGridLineColor, lblDetailGridLineColorHex, cbxDetailGridLineColor.Selected);
end;

procedure TForm1.ChooseThemeColor(AColorBox: TColorBox);
begin
  ColorDialog1.Color := AColorBox.Selected;
  if ColorDialog1.Execute then
  begin
    AColorBox.Selected := ColorDialog1.Color;
    ApplyThemeEditorsToGrid;
    UpdateStatus;
  end;
end;

procedure TForm1.FillThemeCodeMemo;
  function ColorToDelphi(AColor: TColor): string;
  begin
    Result := '$' + IntToHex(ColorToRGB(AColor), 8);
  end;
begin
  memThemeCode.Lines.BeginUpdate;
  try
    memThemeCode.Lines.Clear;
    memThemeCode.Lines.Add('// Theme preset for DCGrid');
    memThemeCode.Lines.Add('DCGrid1.Theme.HeaderColor := ' + ColorToDelphi(DCGrid1.Theme.HeaderColor) + ';');
    memThemeCode.Lines.Add('DCGrid1.Theme.HeaderFontColor := ' + ColorToDelphi(DCGrid1.Theme.HeaderFontColor) + ';');
    memThemeCode.Lines.Add('DCGrid1.Theme.GridBackgroundColor := ' + ColorToDelphi(DCGrid1.Theme.GridBackgroundColor) + ';');
    memThemeCode.Lines.Add('DCGrid1.Theme.RowColor := ' + ColorToDelphi(DCGrid1.Theme.RowColor) + ';');
    memThemeCode.Lines.Add('DCGrid1.Theme.AlternateRowColor := ' + ColorToDelphi(DCGrid1.Theme.AlternateRowColor) + ';');
    memThemeCode.Lines.Add('DCGrid1.Theme.HoverRowColor := ' + ColorToDelphi(DCGrid1.Theme.HoverRowColor) + ';');
    memThemeCode.Lines.Add('DCGrid1.Theme.SelectedRowColor := ' + ColorToDelphi(DCGrid1.Theme.SelectedRowColor) + ';');
    memThemeCode.Lines.Add('DCGrid1.Theme.DetailColor := ' + ColorToDelphi(DCGrid1.Theme.DetailColor) + ';');
    memThemeCode.Lines.Add('DCGrid1.Theme.BorderColor := ' + ColorToDelphi(DCGrid1.Theme.BorderColor) + ';');
    memThemeCode.Lines.Add('DCGrid1.Theme.DetailBorderColor := ' + ColorToDelphi(DCGrid1.Theme.DetailBorderColor) + ';');
    memThemeCode.Lines.Add('DCGrid1.Theme.TextColor := ' + ColorToDelphi(DCGrid1.Theme.TextColor) + ';');
    memThemeCode.Lines.Add('DCGrid1.Theme.DetailTextColor := ' + ColorToDelphi(DCGrid1.Theme.DetailTextColor) + ';');
    memThemeCode.Lines.Add('DCGrid1.Theme.ExpandButtonColor := ' + ColorToDelphi(DCGrid1.Theme.ExpandButtonColor) + ';');
    memThemeCode.Lines.Add('DCGrid1.Theme.DetailGridHeaderColor := ' + ColorToDelphi(DCGrid1.Theme.DetailGridHeaderColor) + ';');
    memThemeCode.Lines.Add('DCGrid1.Theme.DetailGridHeaderFontColor := ' + ColorToDelphi(DCGrid1.Theme.DetailGridHeaderFontColor) + ';');
    memThemeCode.Lines.Add('DCGrid1.Theme.DetailGridRowColor := ' + ColorToDelphi(DCGrid1.Theme.DetailGridRowColor) + ';');
    memThemeCode.Lines.Add('DCGrid1.Theme.DetailGridAlternateRowColor := ' + ColorToDelphi(DCGrid1.Theme.DetailGridAlternateRowColor) + ';');
    memThemeCode.Lines.Add('DCGrid1.Theme.DetailGridLineColor := ' + ColorToDelphi(DCGrid1.Theme.DetailGridLineColor) + ';');
  finally
    memThemeCode.Lines.EndUpdate;
  end;
end;

procedure TForm1.UpdateAdvancedLabels;
begin
  lblDetailHeight.Caption := Format('DetailHeight: %d', [tbDetailHeight.Position]);
  lblMinColumnWidth.Caption := Format('MinColumnWidth: %d', [tbMinColumnWidth.Position]);
end;

procedure TForm1.ApplyAdvancedSettings;
begin
  DCGrid1.DetailSelectEnabled := chkDetailSelectEnabled.Checked;
  DCGrid1.DebugLogEnabled := chkDebugLog.Checked;
  DCGrid1.DetailHeight := tbDetailHeight.Position;
  DCGrid1.MinColumnWidth := tbMinColumnWidth.Position;
  UpdateAdvancedLabels;
  DCGrid1.RefreshGrid;
end;

procedure TForm1.ApplyRecommendedPreset;
begin
  chkExpandOnRowClick.Checked := True;
  chkAlternateColors.Checked := True;
  chkShowHeader.Checked := True;
  chkShowExpandButton.Checked := True;
  chkAllowSort.Checked := True;
  chkBusinessHighlight.Checked := True;
  chkAutoExpandSearch.Checked := False;
  chkDarkTheme.Checked := False;
  chkDetailSelectEnabled.Checked := True;
  chkDebugLog.Checked := False;
  chkBusinessEngine.Checked := True;
  edtBusinessField.Text := 'total_value';
  chkDetailSelectEnabled.Checked := True;

  cbFilterMode.ItemIndex := 0;
  cbSearchScope.ItemIndex := 1;
  cbDetailStyle.ItemIndex := 0;
  cbExpandMode.ItemIndex := 0;

  tbRowHeight.Position := 34;
  tbHeaderHeight.Position := 38;
  tbDetailRowHeight.Position := 24;
  tbDetailHeaderHeight.Position := 28;
  tbDetailHeight.Position := 84;
  tbMinColumnWidth.Position := 48;

  ApplyGridSettings;
  ApplyAdvancedSettings;
  lblStatus.Caption := 'Recommended preset applied';
end;


procedure TForm1.RefreshBusinessRulesUI;
var
  I: Integer;
  R: TDCHighlightRule;
begin
  lstBusinessRules.Items.BeginUpdate;
  try
    lstBusinessRules.Items.Clear;
    for I := 0 to DCGrid1.BusinessHighlight.Rules.Count - 1 do
    begin
      R := DCGrid1.BusinessHighlight.Rules[I];
      lstBusinessRules.Items.Add(Format('%s | Back=%d | Font=%d', [R.Expression, R.BackColor, R.FontColor]));
    end;
  finally
    lstBusinessRules.Items.EndUpdate;
  end;
end;

procedure TForm1.ApplyBusinessHighlightUI;
begin
  DCGrid1.BusinessHighlight.Enabled := chkBusinessEngine.Checked;
  DCGrid1.BusinessHighlight.Field := Trim(edtBusinessField.Text);
  RefreshBusinessRulesUI;
  DCGrid1.RefreshGrid;
  UpdateStatus;
end;

procedure TForm1.AddBusinessRule(const AExpr: string; ABackColor, AFontColor: TColor; AFontStyles: TFontStyles);
begin
  DCGrid1.BusinessHighlight.Rules.Add(AExpr, ABackColor, AFontColor, AFontStyles);
  ApplyBusinessHighlightUI;
end;

procedure TForm1.LoadBusinessHighlightPreset;
begin
  DCGrid1.BusinessHighlight.Clear;
  chkBusinessEngine.Checked := True;
  edtBusinessField.Text := 'total_value';
  AddBusinessRule('>700', $00DFF6DD, $000E5A12, [fsBold]);
  AddBusinessRule('<200', $00FADBD8, clMaroon, []);
end;

procedure TForm1.UpdateStatus;
begin
  lblStatus.Caption := Format(
    'Rows: %d | Filtered: %d | DetailStyle: %s | ExpandMode: %s | BH rules: %d',
    [qryOrders.RecordCount,
     DCGrid1.FilteredRowCount,
     cbDetailStyle.Text,
     cbExpandMode.Text,
     DCGrid1.BusinessHighlight.Rules.Count]
  );
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  PrepareDatabase;

  DCGrid1.Columns.Clear;
  DCGrid1.DetailColumns.Clear;

  with DCGrid1.Columns.Add do
  begin
    Caption := 'Pedido';
    Width := 90;
    Alignment := taLeft;
    FieldName := 'pedido';
  end;

  with DCGrid1.Columns.Add do
  begin
    Caption := 'Cliente';
    Width := 180;
    Alignment := taLeft;
    FieldName := 'cliente';
  end;

  with DCGrid1.Columns.Add do
  begin
    Caption := 'Cidade';
    Width := 130;
    Alignment := taLeft;
    FieldName := 'cidade';
  end;

  with DCGrid1.Columns.Add do
  begin
    Caption := 'Prioridade';
    Width := 110;
    Alignment := taLeft;
    FieldName := 'prioridade';
  end;

  with DCGrid1.Columns.Add do
  begin
    Caption := 'Status';
    Width := 110;
    Alignment := taLeft;
    FieldName := 'status';
  end;

  with DCGrid1.Columns.Add do
  begin
    Caption := 'Total';
    Width := 100;
    Alignment := taRight;
    FieldName := 'total_fmt';
  end;

  with DCGrid1.DetailColumns.Add do
  begin
    Caption := 'Produto';
    Width := 300;
    Alignment := taLeft;
    FieldName := 'produto';
  end;

  with DCGrid1.DetailColumns.Add do
  begin
    Caption := 'Qtde';
    Width := 70;
    Alignment := taCenter;
    FieldName := 'qtde';
  end;

  with DCGrid1.DetailColumns.Add do
  begin
    Caption := 'Valor';
    Width := 110;
    Alignment := taRight;
    FieldName := 'valor_fmt';
  end;

  ConfigureColorBoxes;
  tbRowHeight.Position := DCGrid1.RowHeight;
  tbHeaderHeight.Position := DCGrid1.HeaderHeight;
  tbDetailRowHeight.Position := DCGrid1.DetailGridRowHeight;
  tbDetailHeaderHeight.Position := DCGrid1.DetailGridHeaderHeight;
  tbDetailHeight.Position := DCGrid1.DetailHeight;
  tbMinColumnWidth.Position := DCGrid1.MinColumnWidth;

  cbFilterMode.Items.Text := 'Contém' + sLineBreak + 'Começa com' + sLineBreak + 'Igual';
  cbFilterMode.ItemIndex := 0;

  cbSearchScope.Items.Text := 'Master only' + sLineBreak + 'Master + Detail';
  cbSearchScope.ItemIndex := 1;

  cbDetailStyle.Items.Text := 'Grid' + sLineBreak + 'Text';
  cbDetailStyle.ItemIndex := 0;

  cbExpandMode.Items.Text := 'Multiple' + sLineBreak + 'Single';
  cbExpandMode.ItemIndex := 0;

  chkExpandOnRowClick.Checked := True;
  chkAlternateColors.Checked := True;
  chkShowHeader.Checked := True;
  chkShowExpandButton.Checked := True;
  chkAllowSort.Checked := True;
  chkBusinessHighlight.Checked := True;
  chkAutoExpandSearch.Checked := False;
  chkDarkTheme.Checked := False;

  edtSearch.OnChange := edtSearchChange;
  cbFilterMode.OnChange := cbFilterModeChange;
  cbSearchScope.OnChange := cbSearchScopeChange;
  chkAutoExpandSearch.OnClick := chkAutoExpandSearchClick;
  cbxHeaderColor.OnChange := cbThemeColorChange;
  cbxRowColor.OnChange := cbThemeColorChange;
  cbxAltRowColor.OnChange := cbThemeColorChange;
  cbxHoverColor.OnChange := cbThemeColorChange;
  cbxSelectedColor.OnChange := cbThemeColorChange;
  cbxSelectedTextColor.OnChange := cbThemeColorChange;
  cbxSearchHighlightColor.OnChange := cbThemeColorChange;
  cbxSearchHighlightTextColor.OnChange := cbThemeColorChange;
  cbxDetailColor.OnChange := cbThemeColorChange;
  cbxTextColor.OnChange := cbThemeColorChange;
  cbxHeaderFontColor.OnChange := cbThemeColorChange;
  cbxGridBackgroundColor.OnChange := cbThemeColorChange;
  cbxBorderColor.OnChange := cbThemeColorChange;
  cbxDetailBorderColor.OnChange := cbThemeColorChange;
  cbxDetailTextColor.OnChange := cbThemeColorChange;
  cbxExpandButtonColor.OnChange := cbThemeColorChange;
  cbxDetailGridHeaderColor.OnChange := cbThemeColorChange;
  cbxDetailGridHeaderFontColor.OnChange := cbThemeColorChange;
  cbxDetailGridRowColor.OnChange := cbThemeColorChange;
  cbxDetailGridAltColor.OnChange := cbThemeColorChange;
  cbxDetailGridLineColor.OnChange := cbThemeColorChange;
  cbxHeaderFontColor.OnChange := cbThemeColorChange;
  cbxGridBackgroundColor.OnChange := cbThemeColorChange;
  cbxBorderColor.OnChange := cbThemeColorChange;
  cbxDetailBorderColor.OnChange := cbThemeColorChange;
  cbxDetailTextColor.OnChange := cbThemeColorChange;
  cbxExpandButtonColor.OnChange := cbThemeColorChange;
  cbxDetailGridHeaderColor.OnChange := cbThemeColorChange;
  cbxDetailGridHeaderFontColor.OnChange := cbThemeColorChange;
  cbxDetailGridRowColor.OnChange := cbThemeColorChange;
  cbxDetailGridAltColor.OnChange := cbThemeColorChange;
  cbxDetailGridLineColor.OnChange := cbThemeColorChange;
  btnApplyRecommended.OnClick := btnApplyRecommendedClick;
  btnExpandSelected.OnClick := btnExpandSelectedClick;
  btnCollapseSelected.OnClick := btnCollapseSelectedClick;
  btnExportTheme.OnClick := btnExportThemeClick;
  btnHeaderColor.OnClick := btnThemeChooseClick;
  btnRowColor.OnClick := btnThemeChooseClick;
  btnAltRowColor.OnClick := btnThemeChooseClick;
  btnHoverColor.OnClick := btnThemeChooseClick;
  btnSelectedColor.OnClick := btnThemeChooseClick;
  btnSelectedTextColor.OnClick := btnThemeChooseClick;
  btnSearchHighlightColor.OnClick := btnThemeChooseClick;
  btnSearchHighlightTextColor.OnClick := btnThemeChooseClick;
  btnDetailColor.OnClick := btnThemeChooseClick;
  btnTextColor.OnClick := btnThemeChooseClick;
  btnHeaderFontColor.OnClick := btnThemeChooseClick;
  btnGridBackgroundColor.OnClick := btnThemeChooseClick;
  btnBorderColor.OnClick := btnThemeChooseClick;
  btnDetailBorderColor.OnClick := btnThemeChooseClick;
  btnDetailTextColor.OnClick := btnThemeChooseClick;
  btnExpandButtonColor.OnClick := btnThemeChooseClick;
  btnDetailGridHeaderColor.OnClick := btnThemeChooseClick;
  btnDetailGridHeaderFontColor.OnClick := btnThemeChooseClick;
  btnDetailGridRowColor.OnClick := btnThemeChooseClick;
  btnDetailGridAltColor.OnClick := btnThemeChooseClick;
  btnDetailGridLineColor.OnClick := btnThemeChooseClick;

  OpenData('');
  ApplyRecommendedPreset;
end;

procedure TForm1.DCGrid1SortColumn(Sender: TObject; ACol: Integer; ADirection: TDCSortDirection);
const
  SortMap: array[0..5] of string = ('pedido', 'cliente', 'cidade', 'prioridade', 'status', 'total_value');
begin
  case ADirection of
    sdAscending: OpenData(SortMap[ACol] + ' ASC');
    sdDescending: OpenData(SortMap[ACol] + ' DESC');
  else
    OpenData('');
  end;
  UpdateStatus;
end;

procedure TForm1.DCGrid1DetailRowClick(Sender: TObject; AMasterRow, ADetailRow: Integer);
begin
  lblStatus.Caption := Format('Detail click -> master %d / detail %d', [AMasterRow + 1, ADetailRow + 1]);
end;

procedure TForm1.DCGrid1DetailRowDblClick(Sender: TObject; AMasterRow, ADetailRow: Integer);
begin
  ShowMessage(Format('Double click on detail row %d', [ADetailRow + 1]));
end;

procedure TForm1.DCGrid1RightClickHitTest(Sender: TObject; Area: TDCHitTestArea; AMasterRow, ADetailRow, ACol: Integer; const ScreenPt: TPoint);
begin
  case Area of
    htHeader: lblStatus.Caption := Format('Right click on header %d', [ACol + 1]);
    htMasterRow: lblStatus.Caption := Format('Right click on master row %d', [AMasterRow + 1]);
    htExpandButton: lblStatus.Caption := Format('Right click on expand button row %d', [AMasterRow + 1]);
    htDetailRow: lblStatus.Caption := Format('Right click on detail row %d', [ADetailRow + 1]);
  end;
end;

procedure TForm1.DCGrid1GetMasterRowStyle(Sender: TObject; ARow: Integer; var ABackColor, AFontColor: TColor; var AFontStyles: TFontStyles);
var
  LTotal: Double;
  LPriority: string;
begin
  if (qryOrders.Active) and (ARow >= 0) and (ARow < qryOrders.RecordCount) then
  begin
    qryOrders.RecNo := ARow + 1;
    LTotal := qryOrders.FieldByName('total_value').AsFloat;
    LPriority := qryOrders.FieldByName('prioridade').AsString;

    if SameText(LPriority, 'Crítica') then
    begin
      ABackColor := $00DDEBFF;
      AFontColor := clNavy;
      AFontStyles := [fsBold];
    end
    else if LTotal >= 500 then
    begin
      ABackColor := $00EAF7E7;
      AFontColor := $000E5A12;
    end;
  end;
end;

procedure TForm1.DCGrid1GetDetailRowStyle(Sender: TObject; AMasterRow, ADetailRow: Integer; var ABackColor, AFontColor: TColor; var AFontStyles: TFontStyles);
begin
  if Odd(ADetailRow) then
    AFontStyles := [fsItalic];
end;

procedure TForm1.edtSearchChange(Sender: TObject);
begin
  DCGrid1.SearchText := edtSearch.Text;
  UpdateStatus;
end;

procedure TForm1.cbFilterModeChange(Sender: TObject);
begin
  ApplyGridSettings;
end;

procedure TForm1.cbSearchScopeChange(Sender: TObject);
begin
  ApplyGridSettings;
end;

procedure TForm1.chkAutoExpandSearchClick(Sender: TObject);
begin
  ApplyGridSettings;
end;

procedure TForm1.GenericSettingClick(Sender: TObject);
begin
  ApplyGridSettings;
end;

procedure TForm1.TrackBarChange(Sender: TObject);
begin
  DCGrid1.RowHeight := tbRowHeight.Position;
  DCGrid1.HeaderHeight := tbHeaderHeight.Position;
  DCGrid1.DetailGridRowHeight := tbDetailRowHeight.Position;
  DCGrid1.DetailGridHeaderHeight := tbDetailHeaderHeight.Position;
  ApplyGridSettings;
end;

procedure TForm1.cbDetailStyleChange(Sender: TObject);
begin
  ApplyGridSettings;
end;

procedure TForm1.cbExpandModeChange(Sender: TObject);
begin
  ApplyGridSettings;
end;

procedure TForm1.btnExpandAllClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to DCGrid1.RowCount - 1 do
    DCGrid1.ExpandRow(I);
  UpdateStatus;
end;

procedure TForm1.btnCollapseAllClick(Sender: TObject);
begin
  DCGrid1.CollapseRow;
  UpdateStatus;
end;

procedure TForm1.btnAutoSizeClick(Sender: TObject);
begin
  DCGrid1.AutoSizeColumns;
  DCGrid1.AutoSizeDetailColumns;
  UpdateStatus;
end;

procedure TForm1.btnSaveLayoutClick(Sender: TObject);
begin
  DCGrid1.SaveLayout;
  lblStatus.Caption := 'Layout saved';
end;

procedure TForm1.btnLoadLayoutClick(Sender: TObject);
begin
  DCGrid1.LoadLayout;
  lblStatus.Caption := 'Layout loaded';
end;

procedure TForm1.btnResetLayoutClick(Sender: TObject);
begin
  DCGrid1.ResetLayout;
  lblStatus.Caption := 'Layout reset';
end;

procedure TForm1.btnExportThemeClick(Sender: TObject);
begin
  FillThemeCodeMemo;
  memThemeCode.SelectAll;
  memThemeCode.CopyToClipboard;
  lblStatus.Caption := 'Theme code copied to clipboard';
end;

procedure TForm1.cbThemeColorChange(Sender: TObject);
begin
  ApplyThemeEditorsToGrid;
  UpdateStatus;
end;

procedure TForm1.btnThemeChooseClick(Sender: TObject);
begin
  if Sender = btnHeaderColor then ChooseThemeColor(cbxHeaderColor)
  else if Sender = btnRowColor then ChooseThemeColor(cbxRowColor)
  else if Sender = btnAltRowColor then ChooseThemeColor(cbxAltRowColor)
  else if Sender = btnHoverColor then ChooseThemeColor(cbxHoverColor)
  else if Sender = btnSelectedColor then ChooseThemeColor(cbxSelectedColor)
  else if Sender = btnSelectedTextColor then ChooseThemeColor(cbxSelectedTextColor)
  else if Sender = btnSearchHighlightColor then ChooseThemeColor(cbxSearchHighlightColor)
  else if Sender = btnSearchHighlightTextColor then ChooseThemeColor(cbxSearchHighlightTextColor)
  else if Sender = btnDetailColor then ChooseThemeColor(cbxDetailColor)
  else if Sender = btnTextColor then ChooseThemeColor(cbxTextColor)
  else if Sender = btnHeaderFontColor then ChooseThemeColor(cbxHeaderFontColor)
  else if Sender = btnGridBackgroundColor then ChooseThemeColor(cbxGridBackgroundColor)
  else if Sender = btnBorderColor then ChooseThemeColor(cbxBorderColor)
  else if Sender = btnDetailBorderColor then ChooseThemeColor(cbxDetailBorderColor)
  else if Sender = btnDetailTextColor then ChooseThemeColor(cbxDetailTextColor)
  else if Sender = btnExpandButtonColor then ChooseThemeColor(cbxExpandButtonColor)
  else if Sender = btnDetailGridHeaderColor then ChooseThemeColor(cbxDetailGridHeaderColor)
  else if Sender = btnDetailGridHeaderFontColor then ChooseThemeColor(cbxDetailGridHeaderFontColor)
  else if Sender = btnDetailGridRowColor then ChooseThemeColor(cbxDetailGridRowColor)
  else if Sender = btnDetailGridAltColor then ChooseThemeColor(cbxDetailGridAltColor)
  else if Sender = btnDetailGridLineColor then ChooseThemeColor(cbxDetailGridLineColor);
end;

procedure TForm1.btnApplyRecommendedClick(Sender: TObject);
begin
  ApplyRecommendedPreset;
end;

procedure TForm1.btnExpandSelectedClick(Sender: TObject);
begin
  if DCGrid1.SelectedRow >= 0 then
    DCGrid1.ExpandRow(DCGrid1.SelectedRow);
  UpdateStatus;
end;

procedure TForm1.btnCollapseSelectedClick(Sender: TObject);
begin
  if DCGrid1.SelectedRow >= 0 then
    DCGrid1.CollapseRow(DCGrid1.SelectedRow)
  else
    DCGrid1.CollapseRow;
  UpdateStatus;
end;

procedure TForm1.chkBusinessEngineClick(Sender: TObject);
begin
  ApplyBusinessHighlightUI;
end;

procedure TForm1.btnAddRuleClick(Sender: TObject);
begin
  if Trim(edtRuleExpr.Text) = '' then
    Exit;
  AddBusinessRule(edtRuleExpr.Text, cbxRuleBackColor.Selected, cbxRuleFontColor.Selected, []);
end;

procedure TForm1.btnClearRulesClick(Sender: TObject);
begin
  DCGrid1.BusinessHighlight.Clear;
  ApplyBusinessHighlightUI;
end;

procedure TForm1.btnPresetFinanceClick(Sender: TObject);
begin
  LoadBusinessHighlightPreset;
end;

end.
