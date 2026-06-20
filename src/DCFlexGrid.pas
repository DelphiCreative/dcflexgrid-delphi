{
  DCFlexGrid - Commercial Master-Detail Grid for Delphi VCL
  ---------------------------------------------------------
  Author  : Diego Cataneo (Delphi Creative)
  GitHub  : https://github.com/DelphiCreative
  YouTube : https://youtube.com/@delphicreative

  License : MIT License

  Description:
    Modern master-detail grid component built from scratch
    with support for themes, filtering, and business rules.

  Positioning:
    Commercial-ready grid package focused on master-detail scenarios,
    theming, filtering and business-rule visualization.

  Support the project:
    Star the repository
    Suggestions and contributions are welcome

  ---------------------------------------------------------
}


unit DCFlexGrid;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  System.Types,
  System.Math,
  System.Variants,
  System.Generics.Collections,
  System.Generics.Defaults,
  System.StrUtils,
  System.TypInfo,
  System.IniFiles,
  System.IOUtils,
  System.JSON,
  Data.DB,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.CheckLst,
  Vcl.ExtCtrls,
  Vcl.Graphics,
  Vcl.Menus,
  Vcl.Dialogs,
  DCFlex.Language,
  DCFlex.Theme,
  DCFlex.Controls,
  DCFlex.PopupMenu;

const
  DC_DEFAULT_ROW_HEIGHT = 34;
  DC_DEFAULT_HEADER_HEIGHT = 38;
  DC_DEFAULT_DETAIL_HEIGHT = 84;
  DC_DEFAULT_DETAIL_GRID_HEADER_HEIGHT = 28;
  DC_DEFAULT_DETAIL_GRID_ROW_HEIGHT = 24;
  DC_DEFAULT_EXPAND_COL_WIDTH = 28;
  DC_DEFAULT_PADDING = 10;
  DC_DEFAULT_SCROLL_STEP = 3;
  DC_DEFAULT_TOOLBAR_HEIGHT = 44;
  DC_DEFAULT_FOOTER_HEIGHT = 34;
  DC_DEFAULT_COLUMN_FILTER_HEIGHT = 34;

type
  TDCMasterDetailGrid = class;

  TDCTextAlignment = (taLeft, taCenter, taRight);
  TDCDetailStyle = (dsText, dsGrid);
  TDCExpandMode = (emSingle, emMultiple);
  TDCSortDirection = (sdNone, sdAscending, sdDescending);
  TDCFooterSummary = (fsNone, fsSum, fsCount, fsAvg, fsMin, fsMax);
  TDCHitTestArea = (htNone, htHeader, htMasterRow, htDetailRow, htExpandButton);


  TDCRulesDesignerLanguage = (rdlPortuguese, rdlEnglish, rdlCustom);
  TDCHighlightTarget = (htRow, htCell);

  TDCGridLang = class(TPersistent)
  public
    Title: string;
    Subtitle: string;
    SectionRuleSetup: string;
    SectionRules: string;
    SectionActions: string;
    FieldCaption: string;
    ConditionCaption: string;
    ValueCaption: string;
    ApplyToCaption: string;
    BackgroundCaption: string;
    FontCaption: string;
    PreviewCaption: string;
    BoldCaption: string;
    ItalicCaption: string;
    UnderlineCaption: string;
    AddRuleCaption: string;
    UpdateRuleCaption: string;
    RemoveSelectedCaption: string;
    ClearAllCaption: string;
    CloseCaption: string;
    CancelCaption: string;
    SampleCaption: string;
    ConfirmClearTitle: string;
    ConfirmClearMessage: string;
    StatusReady: string;
    StatusRuleAdded: string;
    StatusRuleUpdated: string;
    StatusRuleRemoved: string;
    StatusRulesCleared: string;
    StatusEditingRule: string;
    ColField: string;
    ColCondition: string;
    ColValue: string;
    ColApplyTo: string;
    ColBack: string;
    ColFont: string;
    ColStyles: string;
    ColumnCaptionPrefix: string;
    CondEquals: string;
    CondNotEquals: string;
    CondGreaterThan: string;
    CondLessThan: string;
    CondContains: string;
    CondStartsWith: string;
    TargetRowCaption: string;
    TargetCellCaption: string;
    ToolbarSearchHint: string;
    ToolbarClearCaption: string;
    ToolbarRulesCaption: string;
    ColumnFilterHintPrefix: string;
    FooterMenuCaption: string;
    FooterMenuShowCaption: string;
    FooterMenuNoneCaption: string;
    FooterMenuSumCaption: string;
    FooterMenuCountCaption: string;
    FooterMenuAvgCaption: string;
    FooterMenuMinCaption: string;
    FooterMenuMaxCaption: string;
    MenuToolbarCaption: string;
    MenuShowToolbarCaption: string;
    MenuShowRulesCaption: string;
    MenuFiltersCaption: string;
    MenuShowColumnFiltersCaption: string;
    MenuClearColumnFilterCaption: string;
    MenuClearAllFiltersCaption: string;
    MenuChooseColumnsCaption: string;
    MenuAutoFitColumnCaption: string;
    MenuAutoFitAllColumnsCaption: string;
    MenuFreezeToColumnCaption: string;
    MenuClearFrozenColumnsCaption: string;
    MenuExportCaption: string;
    MenuExportCsvCaption: string;
    MenuFooterSummariesCaption: string;
    MenuColumnsCaption: string;
    MenuLayoutCaption: string;
    MenuLayoutSaveCaption: string;
    MenuLayoutLoadCaption: string;
    MenuLayoutResetCaption: string;
    ColumnChooserSelectAllCaption: string;
    ColumnChooserUnselectAllCaption: string;
    ColumnChooserKeepOneVisibleMessage: string;
    procedure Assign(Source: TPersistent); override;
    function Clone: TDCGridLang;
    class function Portuguese: TDCGridLang; static;
    class function English: TDCGridLang; static;
  end;

  TDCGetCellTextEvent = procedure(Sender: TObject; ARow, ACol: Integer;
    var AText: string) of object;

  TDCGetDetailTextEvent = procedure(Sender: TObject; ARow: Integer;
    var AText: string) of object;

  TDCGetDetailRowCountEvent = procedure(Sender: TObject; AMasterRow: Integer;
    var ACount: Integer) of object;

  TDCGetDetailCellTextEvent = procedure(Sender: TObject; AMasterRow, ADetailRow,
    ADetailCol: Integer; var AText: string) of object;

  TDCHeaderClickEvent = procedure(Sender: TObject; ACol: Integer) of object;

  TDCSortColumnEvent = procedure(Sender: TObject; ACol: Integer;
    ADirection: TDCSortDirection) of object;

  TDCBeforeExpandEvent = procedure(Sender: TObject; ARow: Integer;
    var Allow: Boolean) of object;

  TDCAfterExpandEvent = procedure(Sender: TObject; ARow: Integer) of object;

  TDCRowClickEvent = procedure(Sender: TObject; ARow: Integer) of object;

  TDCDetailRowClickEvent = procedure(Sender: TObject; AMasterRow, ADetailRow: Integer) of object;
  TDCRightClickHitEvent = procedure(Sender: TObject; Area: TDCHitTestArea;
    AMasterRow, ADetailRow, ACol: Integer; const ScreenPt: TPoint) of object;
  TDCHeaderRightClickEvent = procedure(Sender: TObject; ACol: Integer;
    const ScreenPt: TPoint) of object;
  TDCMasterRowRightClickEvent = procedure(Sender: TObject; ARow, ACol: Integer;
    const ScreenPt: TPoint) of object;
  TDCDetailRowRightClickEvent = procedure(Sender: TObject; AMasterRow, ADetailRow,
    ACol: Integer; const ScreenPt: TPoint) of object;

  TDCGetMasterRowStyleEvent = procedure(Sender: TObject; ARow: Integer;
    var ABackColor, AFontColor: TColor; var AFontStyles: TFontStyles) of object;

  TDCGetDetailRowStyleEvent = procedure(Sender: TObject; AMasterRow, ADetailRow: Integer;
    var ABackColor, AFontColor: TColor; var AFontStyles: TFontStyles) of object;

  TDCCustomDrawHeaderEvent = procedure(Sender: TObject; ACanvas: TCanvas; const ARect: TRect;
    ACol: Integer; AHovered, ASorted: Boolean; var AHandled: Boolean) of object;

  TDCCustomDrawMasterCellEvent = procedure(Sender: TObject; ACanvas: TCanvas; const ARect: TRect;
    ARow, ACol: Integer; ASelected, AHovered: Boolean; const AText: string; var AHandled: Boolean) of object;

  TDCCustomDrawDetailCellEvent = procedure(Sender: TObject; ACanvas: TCanvas; const ARect: TRect;
    AMasterRow, ADetailRow, ACol: Integer; ASelected, AHovered: Boolean; const AText: string; var AHandled: Boolean) of object;

  TDCGridDataAdapter = class(TPersistent)
  protected
    function GetMasterRowCount: Integer; virtual;
    function GetMasterCellText(ARow, ACol: Integer): string; virtual;
    function GetDetailRowCount(AMasterRow: Integer): Integer; virtual;
    function GetDetailCellText(AMasterRow, ADetailRow, ADetailCol: Integer): string; virtual;
  public
    procedure Changed; virtual;
  end;

  TDCDataSetAdapter = class(TDCGridDataAdapter)
  private
    FDataSet: TDataSet;
    FDetailDataSet: TDataSet;
    FOwnerGrid: TDCMasterDetailGrid;
    FMasterKeyField: string;
    FDetailKeyField: string;
    procedure SetDataSet(const Value: TDataSet);
    procedure SetDetailDataSet(const Value: TDataSet);
    function GetFieldTextByColumn(ARecordIndex, ACol: Integer): string;
    function GetFieldValueByName(ARecordIndex: Integer; const AFieldName: string): Variant;
    function GetMasterKeyValue(ARecordIndex: Integer): Variant;
  public
    constructor Create(AOwnerGrid: TDCMasterDetailGrid);
    procedure Assign(Source: TPersistent); override;
    function GetMasterRowCount: Integer; override;
    function GetMasterCellText(ARow, ACol: Integer): string; override;
    function GetDetailRowCount(AMasterRow: Integer): Integer; override;
    function GetDetailCellText(AMasterRow, ADetailRow, ADetailCol: Integer): string; override;
  published
    property DataSet: TDataSet read FDataSet write SetDataSet;
    property DetailDataSet: TDataSet read FDetailDataSet write SetDetailDataSet;
    property MasterKeyField: string read FMasterKeyField write FMasterKeyField;
    property DetailKeyField: string read FDetailKeyField write FDetailKeyField;
  end;


TDCHighlightRule = class(TPersistent)
private
  FFieldName: string;
  FExpression: string;
  FBackColor: TColor;
  FFontColor: TColor;
  FFontStyles: TFontStyles;
  FTarget: TDCHighlightTarget;
public
  constructor Create(const AExpression: string; ABackColor: TColor; AFontColor: TColor; AFontStyles: TFontStyles; ATarget: TDCHighlightTarget = htRow);
  function Match(const AValue: Variant): Boolean;
published
  property FieldName: string read FFieldName write FFieldName;
  property Expression: string read FExpression write FExpression;
  property BackColor: TColor read FBackColor write FBackColor;
  property FontColor: TColor read FFontColor write FFontColor;
  property FontStyles: TFontStyles read FFontStyles write FFontStyles;
  property Target: TDCHighlightTarget read FTarget write FTarget default htRow;
end;

TDCHighlightRules = class(TObjectList<TDCHighlightRule>)
private
  FOwnerGrid: TDCMasterDetailGrid;
public
  constructor Create(AOwnsObjects: Boolean; AOwnerGrid: TDCMasterDetailGrid = nil);
  function Add(const AExpression: string; ABackColor: TColor; AFontColor: TColor = clNone; AFontStyles: TFontStyles = []; ATarget: TDCHighlightTarget = htRow): TDCHighlightRule; reintroduce;
  function AddForField(const AFieldName, AExpression: string; ABackColor: TColor; AFontColor: TColor = clNone; AFontStyles: TFontStyles = []; ATarget: TDCHighlightTarget = htRow): TDCHighlightRule;
  procedure Edit;
  property OwnerGrid: TDCMasterDetailGrid read FOwnerGrid;
end;

TDCBusinessHighlight = class(TPersistent)
private
  FOwner: TDCMasterDetailGrid;
  FEnabled: Boolean;
  FField: string;
  FRules: TDCHighlightRules;
  procedure Changed;
  procedure SetEnabled(const Value: Boolean);
  procedure SetField(const Value: string);
public
  constructor Create(AOwner: TDCMasterDetailGrid);
  destructor Destroy; override;
  procedure Assign(Source: TPersistent); override;
  procedure Clear;
  function Evaluate(const AValue: Variant; var ABackColor, AFontColor: TColor; var AFontStyles: TFontStyles): Boolean; overload;
  function Evaluate(const AValue: Variant; out ATarget: TDCHighlightTarget; var ABackColor, AFontColor: TColor; var AFontStyles: TFontStyles): Boolean; overload;
  function ToJSON: string;
  procedure FromJSON(const AJSON: string);
  procedure SaveToFile(const AFileName: string);
  procedure LoadFromFile(const AFileName: string);
  property Rules: TDCHighlightRules read FRules;
published
  property Enabled: Boolean read FEnabled write SetEnabled default False;
  property Field: string read FField write SetField;
end;

  TDCFilterMode = (fmContains, fmStartsWith, fmEquals);
  TDCSearchScope = (ssMasterOnly, ssMasterAndDetail);

  TDCDrawCellEvent = procedure(Sender: TObject; ACanvas: TCanvas; const ARect: TRect;
    ARow, ACol: Integer; ASelected, AHovered: Boolean; var AHandled: Boolean) of object;

  TDCDrawDetailEvent = procedure(Sender: TObject; ACanvas: TCanvas; const ARect: TRect;
    ARow: Integer; var AHandled: Boolean) of object;

  TDCGridColumn = class(TCollectionItem)
  private
    FCaption: string;
    FWidth: Integer;
    FVisible: Boolean;
    FAlignment: TDCTextAlignment;
    FFieldName: string;
    FDisplayFormat: string;
    FFooterSummary: TDCFooterSummary;
    FFilterText: string;
    procedure SetFilterText(const Value: string);
    procedure SetFooterSummary(const Value: TDCFooterSummary);
    procedure SetAlignment(const Value: TDCTextAlignment);
    procedure SetCaption(const Value: string);
    procedure SetDisplayFormat(const Value: string);
    procedure SetVisible(const Value: Boolean);
    procedure SetWidth(const Value: Integer);
    procedure SetFieldName(const Value: string);
  protected
    procedure Changed;
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
    function FooterNone: TDCGridColumn;
    function FooterSum: TDCGridColumn;
    function FooterCount: TDCGridColumn;
    function FooterAvg: TDCGridColumn;
    function FooterMin: TDCGridColumn;
    function FooterMax: TDCGridColumn;
  published
    property Caption: string read FCaption write SetCaption;
    property Width: Integer read FWidth write SetWidth default 120;
    property Visible: Boolean read FVisible write SetVisible default True;
    property Alignment: TDCTextAlignment read FAlignment write SetAlignment default taLeft;
    property FieldName: string read FFieldName write SetFieldName;
    property DisplayFormat: string read FDisplayFormat write SetDisplayFormat;
    property FooterSummary: TDCFooterSummary read FFooterSummary write SetFooterSummary default fsNone;
    property FilterText: string read FFilterText write SetFilterText;
  end;

  TDCGridColumns = class(TCollection)
  private
    FOwner: TDCMasterDetailGrid;
    function GetItem(Index: Integer): TDCGridColumn;
    procedure SetItem(Index: Integer; const Value: TDCGridColumn);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TDCMasterDetailGrid);
    function Add: TDCGridColumn;
    procedure Changed;
    property Items[Index: Integer]: TDCGridColumn read GetItem write SetItem; default;
  end;

  TDCGridTheme = class(TPersistent)
  private
    FOwner: TDCMasterDetailGrid;
    FHeaderColor: TColor;
    FHeaderFontColor: TColor;
    FGridBackgroundColor: TColor;
    FRowColor: TColor;
    FAlternateRowColor: TColor;
    FHoverRowColor: TColor;
    FSelectedRowColor: TColor;
    FSelectedTextColor: TColor;
    FDetailColor: TColor;
    FBorderColor: TColor;
    FDetailBorderColor: TColor;
    FTextColor: TColor;
    FDetailTextColor: TColor;
    FExpandButtonColor: TColor;
    FDetailGridHeaderColor: TColor;
    FDetailGridHeaderFontColor: TColor;
    FDetailGridRowColor: TColor;
    FDetailGridAlternateRowColor: TColor;
    FDetailGridLineColor: TColor;
    FSearchHighlightColor: TColor;
    FSearchHighlightTextColor: TColor;
    procedure Changed;
    procedure SetAlternateRowColor(const Value: TColor);
    procedure SetBorderColor(const Value: TColor);
    procedure SetDetailBorderColor(const Value: TColor);
    procedure SetDetailColor(const Value: TColor);
    procedure SetDetailGridAlternateRowColor(const Value: TColor);
    procedure SetDetailGridHeaderColor(const Value: TColor);
    procedure SetDetailGridHeaderFontColor(const Value: TColor);
    procedure SetDetailGridLineColor(const Value: TColor);
    procedure SetDetailGridRowColor(const Value: TColor);
    procedure SetDetailTextColor(const Value: TColor);
    procedure SetExpandButtonColor(const Value: TColor);
    procedure SetGridBackgroundColor(const Value: TColor);
    procedure SetHeaderColor(const Value: TColor);
    procedure SetHeaderFontColor(const Value: TColor);
    procedure SetHoverRowColor(const Value: TColor);
    procedure SetRowColor(const Value: TColor);
    procedure SetSelectedRowColor(const Value: TColor);
    procedure SetSelectedTextColor(const Value: TColor);
    procedure SetTextColor(const Value: TColor);
    procedure SetSearchHighlightColor(const Value: TColor);
    procedure SetSearchHighlightTextColor(const Value: TColor);
  public
    constructor Create(AOwner: TDCMasterDetailGrid);
    procedure Assign(Source: TPersistent); override;
    procedure ApplyThemePalette(const APalette: TDCFlexThemePalette);
    procedure ResetDefault;
  published
    property HeaderColor: TColor read FHeaderColor write SetHeaderColor;
    property HeaderFontColor: TColor read FHeaderFontColor write SetHeaderFontColor;
    property GridBackgroundColor: TColor read FGridBackgroundColor write SetGridBackgroundColor;
    property RowColor: TColor read FRowColor write SetRowColor;
    property AlternateRowColor: TColor read FAlternateRowColor write SetAlternateRowColor;
    property HoverRowColor: TColor read FHoverRowColor write SetHoverRowColor;
    property SelectedRowColor: TColor read FSelectedRowColor write SetSelectedRowColor;
    property SelectedTextColor: TColor read FSelectedTextColor write SetSelectedTextColor;
    property DetailColor: TColor read FDetailColor write SetDetailColor;
    property BorderColor: TColor read FBorderColor write SetBorderColor;
    property DetailBorderColor: TColor read FDetailBorderColor write SetDetailBorderColor;
    property TextColor: TColor read FTextColor write SetTextColor;
    property DetailTextColor: TColor read FDetailTextColor write SetDetailTextColor;
    property ExpandButtonColor: TColor read FExpandButtonColor write SetExpandButtonColor;
    property DetailGridHeaderColor: TColor read FDetailGridHeaderColor write SetDetailGridHeaderColor;
    property DetailGridHeaderFontColor: TColor read FDetailGridHeaderFontColor write SetDetailGridHeaderFontColor;
    property DetailGridRowColor: TColor read FDetailGridRowColor write SetDetailGridRowColor;
    property DetailGridAlternateRowColor: TColor read FDetailGridAlternateRowColor write SetDetailGridAlternateRowColor;
    property DetailGridLineColor: TColor read FDetailGridLineColor write SetDetailGridLineColor;
    property SearchHighlightColor: TColor read FSearchHighlightColor write SetSearchHighlightColor;
    property SearchHighlightTextColor: TColor read FSearchHighlightTextColor write SetSearchHighlightTextColor;
  end;

  TDCMasterDetailGrid = class(TCustomControl)
  private
    FColumns: TDCGridColumns;
    FDetailColumns: TDCGridColumns;
    FTheme: TDCGridTheme;
    FThemeMode: TDCFlexThemeMode;
    FRowCount: Integer;
    FRowHeight: Integer;
    FHeaderHeight: Integer;
    FDetailHeight: Integer;
    FDetailGridHeaderHeight: Integer;
    FDetailGridRowHeight: Integer;
    FDetailVerticalScroll: Boolean;
    FDetailMaxHeight: Integer;
    FDetailScrollMasterRow: Integer;
    FDetailVerticalOffset: Integer;
    FSelectedRow: Integer;
    FExpandedRow: Integer;
    FExpandedRows: TList<Integer>;
    FExpandMode: TDCExpandMode;
    FHoverRow: Integer;
    FTopRow: Integer;
    FShowHeader: Boolean;
    FShowHeaderColumnLines: Boolean;
    FShowRowColumnLines: Boolean;
    FFrozenColumns: Integer;
    FHorizontalOffset: Integer;
    FAllowContextMenuActions: Boolean;
    FAllowHeaderFooterSummaryMenu: Boolean;
    FHeaderFooterPopup: TDCFlexPopupMenu;
    FHeaderFooterPopupColumn: Integer;
    FHeaderPopupShownFromMouse: Boolean;
    FShowExpandButton: Boolean;
    FAlternateColors: Boolean;
    FExpandOnRowClick: Boolean;
    FBorderWidth: Integer;
    FDetailStyle: TDCDetailStyle;
    FAllowColumnResize: Boolean;
    FAllowColumnSort: Boolean;
    FMinColumnWidth: Integer;
    FSortedColumn: Integer;
    FSortDirection: TDCSortDirection;
    FResizingColumn: Integer;
    FDetailResizingColumn: Integer;
    FDetailResizeMasterRow: Integer;
    FDetailScrollDragging: Boolean;
    FDetailScrollDragMasterRow: Integer;
    FDetailScrollDragStartY: Integer;
    FDetailScrollDragStartOffset: Integer;
    FDetailHorizontalOffset: Integer;
    FDetailHorizontalDragging: Boolean;
    FDetailHorizontalDragMasterRow: Integer;
    FDetailHorizontalDragStartX: Integer;
    FDetailHorizontalDragStartOffset: Integer;
    FResizeStartX: Integer;
    FResizeColumnStartWidth: Integer;
    FHeaderHoverColumn: Integer;
    FDetailHeaderHoverColumn: Integer;
    FAllowDetailColumnResize: Boolean;
    FTitleFont: TFont;
    FDetailFont: TFont;
    FOnHeaderClick: TDCHeaderClickEvent;
    FOnSortColumn: TDCSortColumnEvent;
    FOnGetCellText: TDCGetCellTextEvent;
    FOnGetDetailText: TDCGetDetailTextEvent;
    FOnGetDetailRowCount: TDCGetDetailRowCountEvent;
    FOnGetDetailCellText: TDCGetDetailCellTextEvent;
    FOnBeforeExpand: TDCBeforeExpandEvent;
    FOnAfterExpand: TDCAfterExpandEvent;
    FOnRowClick: TDCRowClickEvent;
    FSelectedDetailRow: Integer;
    FHoverDetailRow: Integer;
    FDetailSelectEnabled: Boolean;
    FOnDetailRowClick: TDCDetailRowClickEvent;
    FOnDetailRowDblClick: TDCDetailRowClickEvent;
    FOnRightClickHitTest: TDCRightClickHitEvent;
    FOnHeaderRightClick: TDCHeaderRightClickEvent;
    FOnMasterRowRightClick: TDCMasterRowRightClickEvent;
    FOnDetailRowRightClick: TDCDetailRowRightClickEvent;
    FOnGetMasterRowStyle: TDCGetMasterRowStyleEvent;
    FOnGetDetailRowStyle: TDCGetDetailRowStyleEvent;
    FOnCustomDrawHeader: TDCCustomDrawHeaderEvent;
    FOnCustomDrawMasterCell: TDCCustomDrawMasterCellEvent;
    FOnCustomDrawDetailCell: TDCCustomDrawDetailCellEvent;
    FDataAdapter: TDCGridDataAdapter;
    FDataSetAdapter: TDCDataSetAdapter;
    FBusinessHighlight: TDCBusinessHighlight;
    FOnDrawCell: TDCDrawCellEvent;
    FOnDrawDetail: TDCDrawDetailEvent;
    FLayoutKey: string;
    FLayoutFileName: string;
    FAutoSaveLayout: Boolean;
    FAutoLoadLayout: Boolean;
    FDebugLogEnabled: Boolean;
    FSearchText: string;
    FFilterMode: TDCFilterMode;
    FSearchScope: TDCSearchScope;
    FAutoExpandOnSearch: Boolean;
    FFilteredRows: TList<Integer>;
    FRulesDesignerLanguage: TDCRulesDesignerLanguage;
    FRulesDesignerCustomLanguage: TDCGridLang;
    FLanguageSource: TDCFlexLanguage;
    FRulesDesignerAutoLoadPreferences: Boolean;
    FRulesDesignerAutoSavePreferences: Boolean;
    FShowToolbar: Boolean;
    FToolbarHeight: Integer;
    FToolbarSearchEdit: TEdit;
    FToolbarClearButton: TDCFlexButton;
    FToolbarRulesButton: TDCFlexButton;
    FShowToolbarRulesDesignerButton: Boolean;
    FUpdatingToolbarSearch: Boolean;
    FShowFooter: Boolean;
    FFooterHeight: Integer;
    FShowColumnFilters: Boolean;
    FAllowColumnFiltersMenu: Boolean;
    FColumnFilterHeight: Integer;
    FColumnFilterEdits: TObjectList<TEdit>;
    FColumnFilterPanel: TPanel;
    FUpdatingColumnFilters: Boolean;
    function GetLayoutFileName: string;
    function GetLayoutSectionName: string;
    function GetDefaultLayoutsDirectory: string;
    function GetNamedLayoutFileName(const ALayoutName: string): string;
    function GetDebugLogFileName: string;
    procedure LogDebug(const AMessage: string);
    procedure SetLayoutKey(const Value: string);
    procedure SetLayoutFileName(const Value: string);
    procedure SetAutoSaveLayout(const Value: Boolean);
    procedure SetAutoLoadLayout(const Value: Boolean);
    procedure SetDataAdapter(const Value: TDCGridDataAdapter);
    procedure SetDataSetAdapter(const Value: TDCDataSetAdapter);
    procedure SetBusinessHighlight(const Value: TDCBusinessHighlight);
    procedure SetAllowContextMenuActions(const Value: Boolean);
    procedure SetSearchText(const Value: string);
    procedure SetFilterMode(const Value: TDCFilterMode);
    procedure SetSearchScope(const Value: TDCSearchScope);
    procedure SetAutoExpandOnSearch(const Value: Boolean);
    procedure SetRulesDesignerLanguage(const Value: TDCRulesDesignerLanguage);
    procedure SetLanguageSource(const Value: TDCFlexLanguage);
    procedure LanguageSourceChange(Sender: TObject);
    procedure SetRulesDesignerAutoLoadPreferences(const Value: Boolean);
    procedure SetRulesDesignerAutoSavePreferences(const Value: Boolean);
    procedure SetShowToolbar(const Value: Boolean);
    procedure SetToolbarHeight(const Value: Integer);
    procedure SetShowToolbarRulesDesignerButton(const Value: Boolean);
    procedure SetShowFooter(const Value: Boolean);
    procedure SetFooterHeight(const Value: Integer);
    procedure SetShowColumnFilters(const Value: Boolean);
    procedure SetColumnFilterHeight(const Value: Integer);
    procedure ColumnFilterChanged(Sender: TObject);
    procedure EnsureColumnFilterEditors;
    procedure UpdateColumnFilterLayout;
    procedure ClearColumnFilterEditors;
    function HasColumnFilters: Boolean;
    function RowMatchesColumnFilters(ARow: Integer): Boolean;
    function GetVisibleMasterColumnsWidth: Integer;
    function GetVisibleDetailColumnsWidth: Integer;
    function GetVisibleFrozenColumnsWidth: Integer;
    function IsFrozenColumn(ACol: Integer): Boolean;
    function GetColumnDrawLeft(ACol, ABaseLeft: Integer): Integer;
    function GetHorizontalMax: Integer;
    procedure SetHorizontalOffset(const Value: Integer);
    function GetColumnsStartX(ABaseLeft: Integer): Integer;
    function GetDetailColumnsStartX(ABaseLeft: Integer): Integer;
    function GetColumnFilterText(ACol: Integer): string;
    procedure SetColumnFilterText(ACol: Integer; const AText: string);
    procedure ToolbarSearchChanged(Sender: TObject);
    procedure ToolbarClearClick(Sender: TObject);
    procedure ToolbarRulesClick(Sender: TObject);
    procedure UpdateToolbarLayout;
    procedure UpdateToolbarLanguage;
    procedure ExecuteHeaderLayoutAction(AAction: Integer);
    procedure HeaderFooterPopupClick(Sender: TObject; Item: TDCFlexPopupMenuItem);
    procedure SetHeaderFooterSummary(AValue: TDCFooterSummary);
    procedure ToggleHeaderColumnVisibility(AColumnIndex: Integer);
    function GetCurrentLanguage: TDCGridLang;
    function GetLanguageSourceGridLanguage: TDCGridLang;
    procedure RebuildFilter;
    function GetFilteredRowCount: Integer;
    function GetActualRowCount: Integer;
    function GetRules: TDCHighlightRules;
    function GetActualRowIndex(AVisibleRow: Integer): Integer;
    function GetVisibleIndexOfActualRow(AActualRow: Integer): Integer;
    function RowMatchesSearch(ARow: Integer): Boolean;
    function DetailMatchesSearch(AMasterRow: Integer): Boolean;
    function ApplyBusinessHighlight(ARow: Integer; var ABackColor, AFontColor: TColor; var AFontStyles: TFontStyles; out ATarget: TDCHighlightTarget; out AMatchedFieldName: string): Boolean;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMContextMenu(var Message: TWMContextMenu); message WM_CONTEXTMENU;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
    procedure SetAlternateColors(const Value: Boolean);
    procedure SetBorderWidth(const Value: Integer);
    procedure SetAllowColumnResize(const Value: Boolean);
    procedure SetAllowColumnSort(const Value: Boolean);
    procedure SetColumns(const Value: TDCGridColumns);
    procedure SetDetailColumns(const Value: TDCGridColumns);
    procedure SetDetailGridHeaderHeight(const Value: Integer);
    procedure SetDetailGridRowHeight(const Value: Integer);
    procedure SetDetailVerticalScroll(const Value: Boolean);
    procedure SetDetailMaxHeight(const Value: Integer);
    procedure SetDetailHeight(const Value: Integer);
    procedure SetDetailStyle(const Value: TDCDetailStyle);
    procedure SetDetailSelectEnabled(const Value: Boolean);
    procedure SetExpandOnRowClick(const Value: Boolean);
    procedure SetExpandMode(const Value: TDCExpandMode);
    procedure SetExpandedRow(const Value: Integer);
    procedure SetHeaderHeight(const Value: Integer);
    procedure SetMinColumnWidth(const Value: Integer);
    procedure SetSortDirection(const Value: TDCSortDirection);
    procedure SetSortedColumn(const Value: Integer);
    procedure SetRowCount(const Value: Integer);
    procedure SetRowHeight(const Value: Integer);
    procedure SetSelectedRow(const Value: Integer);
    procedure SetShowExpandButton(const Value: Boolean);
    procedure SetShowHeader(const Value: Boolean);
    procedure SetShowHeaderColumnLines(const Value: Boolean);
    procedure SetShowRowColumnLines(const Value: Boolean);
    procedure SetFrozenColumns(const Value: Integer);
    procedure SetAllowHeaderFooterSummaryMenu(const Value: Boolean);
    procedure BuildHeaderFooterPopup;
    procedure HeaderToolbarVisibilityClick(Sender: TObject);
    procedure HeaderRulesVisibilityClick(Sender: TObject);
    procedure HeaderColumnFiltersVisibilityClick(Sender: TObject);
    procedure HeaderClearThisColumnFilterClick(Sender: TObject);
    procedure HeaderClearAllColumnFiltersClick(Sender: TObject);
    procedure HeaderFooterVisibilityClick(Sender: TObject);
    procedure HeaderLayoutActionClick(Sender: TObject);
    procedure HeaderExportCsvClick(Sender: TObject);
    procedure HeaderColumnChooserClick(Sender: TObject);
    procedure HeaderColumnVisibilityClick(Sender: TObject);
    procedure HeaderAutoFitColumnClick(Sender: TObject);
    procedure HeaderAutoFitAllColumnsClick(Sender: TObject);
    procedure HeaderFreezeToColumnClick(Sender: TObject);
    procedure HeaderClearFrozenColumnsClick(Sender: TObject);
    procedure HeaderFooterSummaryClick(Sender: TObject);
    procedure ShowColumnChooserDialog;
    procedure ShowHeaderFooterSummaryMenu(ACol: Integer; const AScreenPt: TPoint);
    function UsesRowMap: Boolean;
    procedure SortFilteredRows;
    procedure SetTheme(const Value: TDCGridTheme);
    procedure SetThemeMode(const Value: TDCFlexThemeMode);
    procedure SetTitleFont(const Value: TFont);
    procedure SetDetailFont(const Value: TFont);
    procedure SetTopRow(const Value: Integer);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DrawBackground;
    procedure DrawBorder;
    procedure DrawToolbar;
    procedure DrawHeader;
    procedure DrawColumnFiltersBackground;
    procedure DrawRows;
    procedure DrawFooter;
    function GetFrozenColumnsBoundaryX(ABaseLeft: Integer): Integer;
    procedure DrawFrozenColumnsSeparator(const ARect: TRect; ABackColor: TColor);
    procedure DrawFrozenHeaderOverlay(const ARect: TRect; ABackColor: TColor);
    procedure DrawFrozenRowOverlay(ARow: Integer; const ARect: TRect);
    procedure DrawFrozenFooterOverlay(const ARect: TRect; ABackColor: TColor);
    procedure DrawRow(ARow: Integer; const ARect: TRect);
    procedure DrawDetail(ARow: Integer; const ARect: TRect);
    procedure DrawDetailText(ARow: Integer; const ARect: TRect);
    procedure DrawDetailGrid(ARow: Integer; const ARect: TRect);
    function GetAccumulatedDetailHeightBeforeRow(ARow: Integer): Integer;
    function GetContentTop: Integer;
    function GetDetailDisplayText(ARow: Integer): string;
    function GetDetailGridRowCount(AMasterRow: Integer): Integer;
    function GetDetailGridContentHeight(AMasterRow: Integer): Integer;
    function GetDetailGridViewportHeight(AMasterRow: Integer): Integer;
    function GetDetailGridMaxVerticalOffset(AMasterRow: Integer): Integer;
    procedure SetDetailVerticalOffset(AMasterRow, AOffset: Integer);
    function GetDetailHorizontalMax(const AGridRect: TRect): Integer;
    procedure SetDetailHorizontalOffset(AOffset: Integer);
    function GetDetailVerticalScrollRects(AMasterRow: Integer; out ATrackRect, AThumbRect: TRect): Boolean;
    function GetDetailVerticalScrollAtPos(X, Y: Integer; out AMasterRow: Integer; out ATrackRect, AThumbRect: TRect): Boolean;
    function GetDetailHorizontalScrollRects(AMasterRow: Integer; out ATrackRect, AThumbRect: TRect): Boolean;
    function GetDetailHorizontalScrollAtPos(X, Y: Integer; out AMasterRow: Integer; out ATrackRect, AThumbRect: TRect): Boolean;
    procedure DrawDetailVerticalScrollBar(AMasterRow: Integer);
    procedure DrawDetailHorizontalScrollBar(AMasterRow: Integer);
    function GetDetailGridCellText(AMasterRow, ADetailRow, ADetailCol: Integer): string;
    function GetCurrentDetailHeight(AMasterRow: Integer): Integer;
    function GetDetailRect(ARow: Integer): TRect;
    function GetDetailGridRect(ARow: Integer): TRect;
    function GetDetailRowAtPos(X, Y: Integer; out AMasterRow, ADetailRow: Integer): Boolean;
    function GetDisplayText(ARow, ACol: Integer): string;
    function GetExpandButtonRect(const ARowRect: TRect): TRect;
    function GetToolbarRect: TRect;
    function GetFooterRect: TRect;
    function GetHeaderRect: TRect;
    function GetColumnFiltersRect: TRect;
    function GetHeaderColumnAt(X, Y: Integer): Integer;
    function GetHeaderSortColumnAt(X, Y: Integer): Integer;
    function GetHeaderResizeColumn(X, Y: Integer): Integer;
    function GetDetailHeaderResizeColumn(X, Y: Integer; out AMasterRow: Integer): Integer;
    function GetDetailHeaderColumnAt(X, Y: Integer; out AMasterRow: Integer): Integer;
    function GetMasterColumnAtPos(X, Y, ARow: Integer): Integer;
    function GetDetailColumnAtPos(X, Y, AMasterRow: Integer): Integer;
    function PerformHitTest(X, Y: Integer; out AArea: TDCHitTestArea;
      out AMasterRow, ADetailRow, ACol: Integer): Boolean;
    function GetRowAtPos(X, Y: Integer): Integer;
    function GetRowRect(ARow: Integer): TRect;
    function GetRowsRect: TRect;
    function GetVisibleMasterRows: Integer;
    function CalculateFooterSummary(ACol: Integer): string;
    function IsExpandedRowVisible: Boolean;
    function IsRowExpanded(ARow: Integer): Boolean;
    function IsPointOnExpandButton(X, Y: Integer; ARow: Integer): Boolean;
    function IsRowVisible(ARow: Integer): Boolean;
    function MaxTopRow: Integer;
    function NormalizeRowIndex(AValue: Integer): Integer;
    function RowHasDetailVisible(ARow: Integer): Boolean;
    function RowHasDetailContent(ARow: Integer): Boolean;
    procedure CreateWnd; override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Paint; override;
    procedure Resize; override;
    procedure ThemeChanged;
    procedure ColumnsChanged;
    procedure ToggleRowExpand(ARow: Integer);
    procedure UpdateScrollBar;
    procedure EnsureRowVisible(ARow: Integer);
    procedure ToggleSortForColumn(ACol: Integer);
    function MeasureTextWidth(const AText: string; AFont: TFont): Integer;
    procedure AutoSizeMasterColumn(ACol: Integer);
    procedure AutoSizeDetailColumn(ACol: Integer);
    procedure TitleFontChanged(Sender: TObject);
    procedure DetailFontChanged(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CollapseAll;
    procedure CollapseRow; overload;
    procedure CollapseRow(ARow: Integer); overload;
    procedure ExpandRow(ARow: Integer);
    procedure RefreshGrid;
    procedure AutoSizeColumns;
    procedure AutoSizeDetailColumns;
    procedure AutoSizeColumn(AIndex: Integer);
    procedure AutoSizeDetailColumnAt(AIndex: Integer);
    procedure SaveLayout; overload;
    procedure LoadLayout; overload;
    procedure ResetLayout; overload;
    procedure SaveLayout(const ALayoutName: string); overload;
    procedure LoadLayout(const ALayoutName: string); overload;
    procedure ResetLayout(const ALayoutName: string); overload;
    function SaveToJSON: string;
    procedure LoadFromJSON(const AJSON: string);
    procedure SaveConfigToFile(const AFileName: string);
    procedure LoadConfigFromFile(const AFileName: string);
    procedure ExportToCSV(const AFileName: string; AOnlyVisibleColumns: Boolean = True; AOnlyFilteredRows: Boolean = True);
    procedure ClearColumnFilters;
    procedure SetColumnFilter(const AFieldName, AText: string); overload;
    procedure SetColumnFilter(ACol: Integer; const AText: string); overload;
    function GetColumnFilter(const AFieldName: string): string; overload;
    function GetColumnFilter(ACol: Integer): string; overload;
    procedure ShowRulesDesigner;
    procedure ShowVisualRulesDesigner;
    procedure SetRulesDesignerCustomLanguage(ALanguage: TDCGridLang);
    function GetRulesDesignerCustomLanguageClone: TDCGridLang;
    function GetEffectiveRulesDesignerLanguageClone: TDCGridLang;
    function GetDefaultRulesFileName: string;
    function GetDefaultDesignerPreferencesFileName: string;
    procedure LoadRulesFromFile(const AFileName: string = '');
    procedure SaveRulesToFile(const AFileName: string = '');
    procedure ApplyThemePalette(const APalette: TDCFlexThemePalette);
    property TopRow: Integer read FTopRow write SetTopRow;
    property HoverRow: Integer read FHoverRow;
    property FilteredRowCount: Integer read GetFilteredRowCount;
    property Rules: TDCHighlightRules read GetRules;
  published
    property Align;
    property Anchors;
    property Color;
    property Font;
    property ParentColor;
    property ParentFont;
    property PopupMenu;
    property TabStop default True;

    property Columns: TDCGridColumns read FColumns write SetColumns;
    property DetailColumns: TDCGridColumns read FDetailColumns write SetDetailColumns;
    property Theme: TDCGridTheme read FTheme write SetTheme;
    property ThemeMode: TDCFlexThemeMode read FThemeMode write SetThemeMode default dtmLight;
    property TitleFont: TFont read FTitleFont write SetTitleFont;
    property DetailFont: TFont read FDetailFont write SetDetailFont;

    property RowCount: Integer read FRowCount write SetRowCount default 0;
    property RowHeight: Integer read FRowHeight write SetRowHeight default DC_DEFAULT_ROW_HEIGHT;
    property HeaderHeight: Integer read FHeaderHeight write SetHeaderHeight default DC_DEFAULT_HEADER_HEIGHT;
    property DetailHeight: Integer read FDetailHeight write SetDetailHeight default DC_DEFAULT_DETAIL_HEIGHT;
    property DetailGridHeaderHeight: Integer read FDetailGridHeaderHeight write SetDetailGridHeaderHeight default DC_DEFAULT_DETAIL_GRID_HEADER_HEIGHT;
    property DetailGridRowHeight: Integer read FDetailGridRowHeight write SetDetailGridRowHeight default DC_DEFAULT_DETAIL_GRID_ROW_HEIGHT;
    property DetailVerticalScroll: Boolean read FDetailVerticalScroll write SetDetailVerticalScroll default True;
    property DetailMaxHeight: Integer read FDetailMaxHeight write SetDetailMaxHeight default 180;

    property SelectedRow: Integer read FSelectedRow write SetSelectedRow default -1;
    property ExpandedRow: Integer read FExpandedRow write SetExpandedRow stored False;

    property ShowHeader: Boolean read FShowHeader write SetShowHeader default True;
    property ShowHeaderColumnLines: Boolean read FShowHeaderColumnLines write SetShowHeaderColumnLines default True;
    property ShowRowColumnLines: Boolean read FShowRowColumnLines write SetShowRowColumnLines default False;
    property FrozenColumns: Integer read FFrozenColumns write SetFrozenColumns default 0;
    property AllowContextMenuActions: Boolean read FAllowContextMenuActions write SetAllowContextMenuActions default True;
    property AllowHeaderFooterSummaryMenu: Boolean read FAllowHeaderFooterSummaryMenu write SetAllowHeaderFooterSummaryMenu default True;
    property ShowExpandButton: Boolean read FShowExpandButton write SetShowExpandButton default True;
    property AlternateColors: Boolean read FAlternateColors write SetAlternateColors default True;
    property ExpandOnRowClick: Boolean read FExpandOnRowClick write SetExpandOnRowClick default True;
    property ExpandMode: TDCExpandMode read FExpandMode write SetExpandMode default emSingle;
    property AllowColumnResize: Boolean read FAllowColumnResize write SetAllowColumnResize default True;
    property AllowColumnSort: Boolean read FAllowColumnSort write SetAllowColumnSort default True;
    property MinColumnWidth: Integer read FMinColumnWidth write SetMinColumnWidth default 40;
    property SortedColumn: Integer read FSortedColumn write SetSortedColumn default -1;
    property SortDirection: TDCSortDirection read FSortDirection write SetSortDirection default sdNone;
    property BorderWidth: Integer read FBorderWidth write SetBorderWidth default 1;
    property LayoutKey: string read FLayoutKey write SetLayoutKey;
    property LayoutFileName: string read FLayoutFileName write SetLayoutFileName;
    property AutoLoadLayout: Boolean read FAutoLoadLayout write SetAutoLoadLayout default True;
    property AutoSaveLayout: Boolean read FAutoSaveLayout write SetAutoSaveLayout default False;
    property DebugLogEnabled: Boolean read FDebugLogEnabled write FDebugLogEnabled default False;
    property SearchText: string read FSearchText write SetSearchText;
    property ShowToolbar: Boolean read FShowToolbar write SetShowToolbar default False;
    property ToolbarHeight: Integer read FToolbarHeight write SetToolbarHeight default DC_DEFAULT_TOOLBAR_HEIGHT;
    property ShowToolbarRulesDesignerButton: Boolean read FShowToolbarRulesDesignerButton write SetShowToolbarRulesDesignerButton default False;
    property ShowFooter: Boolean read FShowFooter write SetShowFooter default False;
    property FooterHeight: Integer read FFooterHeight write SetFooterHeight default DC_DEFAULT_FOOTER_HEIGHT;
    property ShowColumnFilters: Boolean read FShowColumnFilters write SetShowColumnFilters default False;
    property AllowColumnFiltersMenu: Boolean read FAllowColumnFiltersMenu write FAllowColumnFiltersMenu default False;
    property ColumnFilterHeight: Integer read FColumnFilterHeight write SetColumnFilterHeight default DC_DEFAULT_COLUMN_FILTER_HEIGHT;
    property FilterMode: TDCFilterMode read FFilterMode write SetFilterMode default fmContains;
    property SearchScope: TDCSearchScope read FSearchScope write SetSearchScope default ssMasterOnly;
    property AutoExpandOnSearch: Boolean read FAutoExpandOnSearch write SetAutoExpandOnSearch default False;
    property AllowDetailColumnResize: Boolean read FAllowDetailColumnResize write FAllowDetailColumnResize default True;
    property DetailStyle: TDCDetailStyle read FDetailStyle write SetDetailStyle default dsText;
    property DetailSelectEnabled: Boolean read FDetailSelectEnabled write SetDetailSelectEnabled default True;
    property SelectedDetailRow: Integer read FSelectedDetailRow default -1;
    property HoverDetailRow: Integer read FHoverDetailRow;

    property OnHeaderClick: TDCHeaderClickEvent read FOnHeaderClick write FOnHeaderClick;
    property OnSortColumn: TDCSortColumnEvent read FOnSortColumn write FOnSortColumn;
    property OnGetCellText: TDCGetCellTextEvent read FOnGetCellText write FOnGetCellText;
    property OnGetDetailText: TDCGetDetailTextEvent read FOnGetDetailText write FOnGetDetailText;
    property OnGetDetailRowCount: TDCGetDetailRowCountEvent read FOnGetDetailRowCount write FOnGetDetailRowCount;
    property OnGetDetailCellText: TDCGetDetailCellTextEvent read FOnGetDetailCellText write FOnGetDetailCellText;
    property OnBeforeExpand: TDCBeforeExpandEvent read FOnBeforeExpand write FOnBeforeExpand;
    property OnAfterExpand: TDCAfterExpandEvent read FOnAfterExpand write FOnAfterExpand;
    property OnRowClick: TDCRowClickEvent read FOnRowClick write FOnRowClick;
    property OnDetailRowClick: TDCDetailRowClickEvent read FOnDetailRowClick write FOnDetailRowClick;
    property OnDetailRowDblClick: TDCDetailRowClickEvent read FOnDetailRowDblClick write FOnDetailRowDblClick;
    property OnRightClickHitTest: TDCRightClickHitEvent read FOnRightClickHitTest write FOnRightClickHitTest;
    property OnHeaderRightClick: TDCHeaderRightClickEvent read FOnHeaderRightClick write FOnHeaderRightClick;
    property OnMasterRowRightClick: TDCMasterRowRightClickEvent read FOnMasterRowRightClick write FOnMasterRowRightClick;
    property OnDetailRowRightClick: TDCDetailRowRightClickEvent read FOnDetailRowRightClick write FOnDetailRowRightClick;
    property OnGetMasterRowStyle: TDCGetMasterRowStyleEvent read FOnGetMasterRowStyle write FOnGetMasterRowStyle;
    property OnGetDetailRowStyle: TDCGetDetailRowStyleEvent read FOnGetDetailRowStyle write FOnGetDetailRowStyle;
    property OnCustomDrawHeader: TDCCustomDrawHeaderEvent read FOnCustomDrawHeader write FOnCustomDrawHeader;
    property OnCustomDrawMasterCell: TDCCustomDrawMasterCellEvent read FOnCustomDrawMasterCell write FOnCustomDrawMasterCell;
    property OnCustomDrawDetailCell: TDCCustomDrawDetailCellEvent read FOnCustomDrawDetailCell write FOnCustomDrawDetailCell;
    property DataAdapter: TDCGridDataAdapter read FDataAdapter write SetDataAdapter;
    property DataSetAdapter: TDCDataSetAdapter read FDataSetAdapter write SetDataSetAdapter;
    property BusinessHighlight: TDCBusinessHighlight read FBusinessHighlight write SetBusinessHighlight;
    property OnDrawCell: TDCDrawCellEvent read FOnDrawCell write FOnDrawCell;
    property OnDrawDetail: TDCDrawDetailEvent read FOnDrawDetail write FOnDrawDetail;
    property LanguageSource: TDCFlexLanguage read FLanguageSource
      write SetLanguageSource;
    property RulesDesignerLanguage: TDCRulesDesignerLanguage read FRulesDesignerLanguage write SetRulesDesignerLanguage default rdlPortuguese;
    property RulesDesignerAutoLoadPreferences: Boolean read FRulesDesignerAutoLoadPreferences write SetRulesDesignerAutoLoadPreferences default True;
    property RulesDesignerAutoSavePreferences: Boolean read FRulesDesignerAutoSavePreferences write SetRulesDesignerAutoSavePreferences default True;

    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
  end;

  TDCFlexGrid = class(TDCMasterDetailGrid);

  TDCGrid = class(TDCFlexGrid);


implementation

uses
  DCFlexGrid.VisualRulesDesigner;

const
  DC_GRID_POPUP_SHOW_TOOLBAR = 1001;
  DC_GRID_POPUP_SHOW_RULES = 1002;
  DC_GRID_POPUP_SHOW_FILTERS = 1003;
  DC_GRID_POPUP_CLEAR_THIS_FILTER = 1004;
  DC_GRID_POPUP_CLEAR_ALL_FILTERS = 1005;
  DC_GRID_POPUP_SHOW_FOOTER = 1006;
  DC_GRID_POPUP_LAYOUT_SAVE = 1007;
  DC_GRID_POPUP_LAYOUT_LOAD = 1008;
  DC_GRID_POPUP_LAYOUT_RESET = 1009;
  DC_GRID_POPUP_EXPORT_CSV = 1010;
  DC_GRID_POPUP_CHOOSE_COLUMNS = 1011;
  DC_GRID_POPUP_AUTOFIT_COLUMN = 1012;
  DC_GRID_POPUP_AUTOFIT_ALL_COLUMNS = 1013;
  DC_GRID_POPUP_FREEZE_TO_COLUMN = 1014;
  DC_GRID_POPUP_CLEAR_FROZEN_COLUMNS = 1015;
  DC_GRID_POPUP_SUMMARY_BASE = 4000;

function DCColumnFilterHint(ALang: TDCGridLang; ALanguageMode: TDCRulesDesignerLanguage; const ACaption: string): string; forward;
function DCFormatColumnDisplayText(const AText, ADisplayFormat: string): string; forward;

{ TDCGridLang }

procedure TDCGridLang.Assign(Source: TPersistent);
begin
  if Source is TDCGridLang then
  begin
    Title := TDCGridLang(Source).Title;
    Subtitle := TDCGridLang(Source).Subtitle;
    SectionRuleSetup := TDCGridLang(Source).SectionRuleSetup;
    SectionRules := TDCGridLang(Source).SectionRules;
    SectionActions := TDCGridLang(Source).SectionActions;
    FieldCaption := TDCGridLang(Source).FieldCaption;
    ConditionCaption := TDCGridLang(Source).ConditionCaption;
    ValueCaption := TDCGridLang(Source).ValueCaption;
    ApplyToCaption := TDCGridLang(Source).ApplyToCaption;
    BackgroundCaption := TDCGridLang(Source).BackgroundCaption;
    FontCaption := TDCGridLang(Source).FontCaption;
    PreviewCaption := TDCGridLang(Source).PreviewCaption;
    BoldCaption := TDCGridLang(Source).BoldCaption;
    ItalicCaption := TDCGridLang(Source).ItalicCaption;
    UnderlineCaption := TDCGridLang(Source).UnderlineCaption;
    AddRuleCaption := TDCGridLang(Source).AddRuleCaption;
    UpdateRuleCaption := TDCGridLang(Source).UpdateRuleCaption;
    RemoveSelectedCaption := TDCGridLang(Source).RemoveSelectedCaption;
    ClearAllCaption := TDCGridLang(Source).ClearAllCaption;
    CloseCaption := TDCGridLang(Source).CloseCaption;
    CancelCaption := TDCGridLang(Source).CancelCaption;
    SampleCaption := TDCGridLang(Source).SampleCaption;
    ConfirmClearTitle := TDCGridLang(Source).ConfirmClearTitle;
    ConfirmClearMessage := TDCGridLang(Source).ConfirmClearMessage;
    StatusReady := TDCGridLang(Source).StatusReady;
    StatusRuleAdded := TDCGridLang(Source).StatusRuleAdded;
    StatusRuleUpdated := TDCGridLang(Source).StatusRuleUpdated;
    StatusRuleRemoved := TDCGridLang(Source).StatusRuleRemoved;
    StatusRulesCleared := TDCGridLang(Source).StatusRulesCleared;
    StatusEditingRule := TDCGridLang(Source).StatusEditingRule;
    ColField := TDCGridLang(Source).ColField;
    ColCondition := TDCGridLang(Source).ColCondition;
    ColValue := TDCGridLang(Source).ColValue;
    ColApplyTo := TDCGridLang(Source).ColApplyTo;
    ColBack := TDCGridLang(Source).ColBack;
    ColFont := TDCGridLang(Source).ColFont;
    ColStyles := TDCGridLang(Source).ColStyles;
    ColumnCaptionPrefix := TDCGridLang(Source).ColumnCaptionPrefix;
    CondEquals := TDCGridLang(Source).CondEquals;
    CondNotEquals := TDCGridLang(Source).CondNotEquals;
    CondGreaterThan := TDCGridLang(Source).CondGreaterThan;
    CondLessThan := TDCGridLang(Source).CondLessThan;
    CondContains := TDCGridLang(Source).CondContains;
    CondStartsWith := TDCGridLang(Source).CondStartsWith;
    TargetRowCaption := TDCGridLang(Source).TargetRowCaption;
    TargetCellCaption := TDCGridLang(Source).TargetCellCaption;
    ToolbarSearchHint := TDCGridLang(Source).ToolbarSearchHint;
    ToolbarClearCaption := TDCGridLang(Source).ToolbarClearCaption;
    ToolbarRulesCaption := TDCGridLang(Source).ToolbarRulesCaption;
    ColumnFilterHintPrefix := TDCGridLang(Source).ColumnFilterHintPrefix;
    FooterMenuCaption := TDCGridLang(Source).FooterMenuCaption;
    FooterMenuShowCaption := TDCGridLang(Source).FooterMenuShowCaption;
    FooterMenuNoneCaption := TDCGridLang(Source).FooterMenuNoneCaption;
    FooterMenuSumCaption := TDCGridLang(Source).FooterMenuSumCaption;
    FooterMenuCountCaption := TDCGridLang(Source).FooterMenuCountCaption;
    FooterMenuAvgCaption := TDCGridLang(Source).FooterMenuAvgCaption;
    FooterMenuMinCaption := TDCGridLang(Source).FooterMenuMinCaption;
    FooterMenuMaxCaption := TDCGridLang(Source).FooterMenuMaxCaption;
    MenuToolbarCaption := TDCGridLang(Source).MenuToolbarCaption;
    MenuShowToolbarCaption := TDCGridLang(Source).MenuShowToolbarCaption;
    MenuShowRulesCaption := TDCGridLang(Source).MenuShowRulesCaption;
    MenuFiltersCaption := TDCGridLang(Source).MenuFiltersCaption;
    MenuShowColumnFiltersCaption := TDCGridLang(Source).MenuShowColumnFiltersCaption;
    MenuClearColumnFilterCaption := TDCGridLang(Source).MenuClearColumnFilterCaption;
    MenuClearAllFiltersCaption := TDCGridLang(Source).MenuClearAllFiltersCaption;
    MenuChooseColumnsCaption := TDCGridLang(Source).MenuChooseColumnsCaption;
    MenuAutoFitColumnCaption := TDCGridLang(Source).MenuAutoFitColumnCaption;
    MenuAutoFitAllColumnsCaption := TDCGridLang(Source).MenuAutoFitAllColumnsCaption;
    MenuFreezeToColumnCaption := TDCGridLang(Source).MenuFreezeToColumnCaption;
    MenuClearFrozenColumnsCaption := TDCGridLang(Source).MenuClearFrozenColumnsCaption;
    MenuExportCaption := TDCGridLang(Source).MenuExportCaption;
    MenuExportCsvCaption := TDCGridLang(Source).MenuExportCsvCaption;
    MenuFooterSummariesCaption := TDCGridLang(Source).MenuFooterSummariesCaption;
    MenuColumnsCaption := TDCGridLang(Source).MenuColumnsCaption;
    MenuLayoutCaption := TDCGridLang(Source).MenuLayoutCaption;
    MenuLayoutSaveCaption := TDCGridLang(Source).MenuLayoutSaveCaption;
    MenuLayoutLoadCaption := TDCGridLang(Source).MenuLayoutLoadCaption;
    MenuLayoutResetCaption := TDCGridLang(Source).MenuLayoutResetCaption;
    ColumnChooserSelectAllCaption := TDCGridLang(Source).ColumnChooserSelectAllCaption;
    ColumnChooserUnselectAllCaption := TDCGridLang(Source).ColumnChooserUnselectAllCaption;
    ColumnChooserKeepOneVisibleMessage := TDCGridLang(Source).ColumnChooserKeepOneVisibleMessage;
  end
  else
    inherited;
end;

function TDCGridLang.Clone: TDCGridLang;
begin
  Result := TDCGridLang.Create;
  Result.Assign(Self);
end;

class function TDCGridLang.Portuguese: TDCGridLang;
begin
  Result := TDCGridLang.Create;
  Result.Title := 'Visual Rules Designer';
  Result.Subtitle := 'Configure regras visuais de destaque com uma experiência mais profissional.';
  Result.SectionRuleSetup := 'Configuração da regra';
  Result.SectionRules := 'Regras configuradas';
  Result.SectionActions := 'Ações';
  Result.FieldCaption := 'Campo';
  Result.ConditionCaption := 'Condição';
  Result.ValueCaption := 'Valor';
  Result.ApplyToCaption := 'Aplicar em';
  Result.BackgroundCaption := 'Fundo';
  Result.FontCaption := 'Fonte';
  Result.PreviewCaption := 'Preview';
  Result.BoldCaption := 'Negrito';
  Result.ItalicCaption := 'Itálico';
  Result.UnderlineCaption := 'Sublinhado';
  Result.AddRuleCaption := 'Adicionar regra';
  Result.UpdateRuleCaption := 'Atualizar regra';
  Result.RemoveSelectedCaption := 'Remover selecionada';
  Result.ClearAllCaption := 'Limpar tudo';
  Result.CloseCaption := 'Fechar';
  Result.CancelCaption := 'Cancelar';
  Result.SampleCaption := 'Exemplo';
  Result.ConfirmClearTitle := 'Limpar regras';
  Result.ConfirmClearMessage := 'Todas as regras visuais ser' + #227 + 'o removidas.';
  Result.StatusReady := 'Pronto para configurar novas regras.';
  Result.StatusRuleAdded := 'Regra adicionada com sucesso.';
  Result.StatusRuleUpdated := 'Regra atualizada com sucesso.';
  Result.StatusRuleRemoved := 'Regra removida.';
  Result.StatusRulesCleared := 'Todas as regras foram removidas.';
  Result.StatusEditingRule := 'Editando regra selecionada. Clique em atualizar para salvar.';
  Result.ColField := 'Campo';
  Result.ColCondition := 'Condição';
  Result.ColValue := 'Valor';
  Result.ColApplyTo := 'Aplicação';
  Result.ColBack := 'Fundo';
  Result.ColFont := 'Fonte';
  Result.ColStyles := 'Estilos';
  Result.ColumnCaptionPrefix := 'Coluna';
  Result.CondEquals := 'Igual';
  Result.CondNotEquals := 'Diferente';
  Result.CondGreaterThan := 'Maior que';
  Result.CondLessThan := 'Menor que';
  Result.CondContains := 'Contém';
  Result.CondStartsWith := 'Começa com';
  Result.TargetRowCaption := 'Linha inteira';
  Result.TargetCellCaption := 'Apenas célula';
  Result.ToolbarSearchHint := 'Buscar...';
  Result.ToolbarClearCaption := 'Limpar';
  Result.ToolbarRulesCaption := 'Regras';
  Result.ColumnFilterHintPrefix := 'Filtrar';
  Result.FooterMenuCaption := 'Rodap' + #233;
  Result.FooterMenuShowCaption := 'Exibir rodap' + #233;
  Result.FooterMenuNoneCaption := 'Sem totalizador';
  Result.FooterMenuSumCaption := 'Somar no rodap' + #233;
  Result.FooterMenuCountCaption := 'Contar no rodap' + #233;
  Result.FooterMenuAvgCaption := 'M' + #233 + 'dia no rodap' + #233;
  Result.FooterMenuMinCaption := 'M' + #237 + 'nimo no rodap' + #233;
  Result.FooterMenuMaxCaption := 'M' + #225 + 'ximo no rodap' + #233;
  Result.MenuToolbarCaption := 'Barra de pesquisa';
  Result.MenuShowToolbarCaption := 'Exibir';
  Result.MenuShowRulesCaption := 'Exibir bot' + #227 + 'o Regras';
  Result.MenuFiltersCaption := 'Filtros';
  Result.MenuShowColumnFiltersCaption := 'Exibir filtros por coluna';
  Result.MenuClearColumnFilterCaption := 'Limpar filtro desta coluna';
  Result.MenuClearAllFiltersCaption := 'Limpar todos os filtros';
  Result.MenuChooseColumnsCaption := 'Selecionar colunas...';
  Result.MenuAutoFitColumnCaption := 'Auto ajustar esta coluna';
  Result.MenuAutoFitAllColumnsCaption := 'Auto ajustar todas';
  Result.MenuFreezeToColumnCaption := 'Congelar at' + #233 + ' esta coluna';
  Result.MenuClearFrozenColumnsCaption := 'Remover congelamento';
  Result.MenuExportCaption := 'Exportar';
  Result.MenuExportCsvCaption := 'CSV...';
  Result.MenuFooterSummariesCaption := 'Totalizadores';
  Result.MenuColumnsCaption := 'Colunas';
  Result.MenuLayoutCaption := 'Layout';
  Result.MenuLayoutSaveCaption := 'Salvar';
  Result.MenuLayoutLoadCaption := 'Carregar';
  Result.MenuLayoutResetCaption := 'Resetar';
  Result.ColumnChooserSelectAllCaption := 'Marcar todas';
  Result.ColumnChooserUnselectAllCaption := 'Desmarcar todas';
  Result.ColumnChooserKeepOneVisibleMessage := 'Pelo menos uma coluna deve permanecer vis' + #237 + 'vel.';
end;

class function TDCGridLang.English: TDCGridLang;
begin
  Result := TDCGridLang.Create;
  Result.Title := 'Visual Rules Designer';
  Result.Subtitle := 'Configure visual highlight rules with a polished, product-ready experience.';
  Result.SectionRuleSetup := 'Rule setup';
  Result.SectionRules := 'Configured rules';
  Result.SectionActions := 'Actions';
  Result.FieldCaption := 'Field';
  Result.ConditionCaption := 'Condition';
  Result.ValueCaption := 'Value';
  Result.ApplyToCaption := 'Apply to';
  Result.BackgroundCaption := 'Background';
  Result.FontCaption := 'Font';
  Result.PreviewCaption := 'Preview';
  Result.BoldCaption := 'Bold';
  Result.ItalicCaption := 'Italic';
  Result.UnderlineCaption := 'Underline';
  Result.AddRuleCaption := 'Add rule';
  Result.UpdateRuleCaption := 'Update rule';
  Result.RemoveSelectedCaption := 'Remove selected';
  Result.ClearAllCaption := 'Clear all';
  Result.CloseCaption := 'Close';
  Result.CancelCaption := 'Cancel';
  Result.SampleCaption := 'Sample';
  Result.ConfirmClearTitle := 'Clear rules';
  Result.ConfirmClearMessage := 'All visual rules will be removed.';
  Result.StatusReady := 'Ready to configure new rules.';
  Result.StatusRuleAdded := 'Rule added successfully.';
  Result.StatusRuleUpdated := 'Rule updated successfully.';
  Result.StatusRuleRemoved := 'Rule removed.';
  Result.StatusRulesCleared := 'All rules were removed.';
  Result.StatusEditingRule := 'Editing selected rule. Click update to save changes.';
  Result.ColField := 'Field';
  Result.ColCondition := 'Condition';
  Result.ColValue := 'Value';
  Result.ColApplyTo := 'Apply to';
  Result.ColBack := 'Back';
  Result.ColFont := 'Font';
  Result.ColStyles := 'Styles';
  Result.ColumnCaptionPrefix := 'Column';
  Result.CondEquals := 'Equals';
  Result.CondNotEquals := 'Not equals';
  Result.CondGreaterThan := 'Greater than';
  Result.CondLessThan := 'Less than';
  Result.CondContains := 'Contains';
  Result.CondStartsWith := 'Starts with';
  Result.TargetRowCaption := 'Full row';
  Result.TargetCellCaption := 'Cell only';
  Result.ToolbarSearchHint := 'Search...';
  Result.ToolbarClearCaption := 'Clear';
  Result.ToolbarRulesCaption := 'Rules';
  Result.ColumnFilterHintPrefix := 'Filter';
  Result.FooterMenuCaption := 'Footer';
  Result.FooterMenuShowCaption := 'Show footer';
  Result.FooterMenuNoneCaption := 'No summary';
  Result.FooterMenuSumCaption := 'Sum in footer';
  Result.FooterMenuCountCaption := 'Count in footer';
  Result.FooterMenuAvgCaption := 'Average in footer';
  Result.FooterMenuMinCaption := 'Minimum in footer';
  Result.FooterMenuMaxCaption := 'Maximum in footer';
  Result.MenuToolbarCaption := 'Search toolbar';
  Result.MenuShowToolbarCaption := 'Show';
  Result.MenuShowRulesCaption := 'Show Rules button';
  Result.MenuFiltersCaption := 'Filters';
  Result.MenuShowColumnFiltersCaption := 'Show column filters';
  Result.MenuClearColumnFilterCaption := 'Clear this column filter';
  Result.MenuClearAllFiltersCaption := 'Clear all filters';
  Result.MenuChooseColumnsCaption := 'Choose columns...';
  Result.MenuAutoFitColumnCaption := 'Auto fit this column';
  Result.MenuAutoFitAllColumnsCaption := 'Auto fit all columns';
  Result.MenuFreezeToColumnCaption := 'Freeze up to this column';
  Result.MenuClearFrozenColumnsCaption := 'Remove frozen columns';
  Result.MenuExportCaption := 'Export';
  Result.MenuExportCsvCaption := 'CSV...';
  Result.MenuFooterSummariesCaption := 'Summaries';
  Result.MenuColumnsCaption := 'Columns';
  Result.MenuLayoutCaption := 'Layout';
  Result.MenuLayoutSaveCaption := 'Save';
  Result.MenuLayoutLoadCaption := 'Load';
  Result.MenuLayoutResetCaption := 'Reset';
  Result.ColumnChooserSelectAllCaption := 'Select all';
  Result.ColumnChooserUnselectAllCaption := 'Unselect all';
  Result.ColumnChooserKeepOneVisibleMessage := 'At least one column must remain visible.';
end;

function DCFontStylesToString(const AStyles: TFontStyles): string;
var
  LParts: TStringList;
begin
  LParts := TStringList.Create;
  try
    if fsBold in AStyles then
      LParts.Add('Bold');
    if fsItalic in AStyles then
      LParts.Add('Italic');
    if fsUnderline in AStyles then
      LParts.Add('Underline');
    if fsStrikeOut in AStyles then
      LParts.Add('StrikeOut');

    if LParts.Count = 0 then
      Result := ''
    else
      Result := LParts.CommaText;
  finally
    LParts.Free;
  end;
end;

function DCStringToFontStyles(const AValue: string): TFontStyles;
var
  LParts: TStringList;
  I: Integer;
  LItem: string;
begin
  Result := [];
  if Trim(AValue) = '' then
    Exit;

  LParts := TStringList.Create;
  try
    LParts.CommaText := AValue;
    for I := 0 to LParts.Count - 1 do
    begin
      LItem := Trim(LParts[I]);
      if SameText(LItem, 'Bold') then
        Include(Result, fsBold)
      else if SameText(LItem, 'Italic') then
        Include(Result, fsItalic)
      else if SameText(LItem, 'Underline') then
        Include(Result, fsUnderline)
      else if SameText(LItem, 'StrikeOut') then
        Include(Result, fsStrikeOut);
    end;
  finally
    LParts.Free;
  end;
end;

function BlendColor(AColor1, AColor2: TColor; AAmount: Byte): TColor;
var
  C1, C2: Longint;
  R, G, B: Integer;
begin
  C1 := ColorToRGB(AColor1);
  C2 := ColorToRGB(AColor2);
  R := (GetRValue(C1) * (255 - AAmount) + GetRValue(C2) * AAmount) div 255;
  G := (GetGValue(C1) * (255 - AAmount) + GetGValue(C2) * AAmount) div 255;
  B := (GetBValue(C1) * (255 - AAmount) + GetBValue(C2) * AAmount) div 255;
  Result := RGB(R, G, B);
end;

procedure FillRectColor(ACanvas: TCanvas; const ARect: TRect; AColor: TColor);
begin
  ACanvas.Brush.Style := bsSolid;
  ACanvas.Brush.Color := AColor;
  ACanvas.FillRect(ARect);
end;

procedure DrawRoundedPanel(ACanvas: TCanvas; const ARect: TRect; AFillColor, ABorderColor: TColor; ARadius: Integer = 8);
begin
  ACanvas.Brush.Style := bsSolid;
  ACanvas.Brush.Color := AFillColor;
  ACanvas.Pen.Color := ABorderColor;
  ACanvas.RoundRect(ARect.Left, ARect.Top, ARect.Right, ARect.Bottom, ARadius, ARadius);
end;

procedure DrawAccentBar(ACanvas: TCanvas; const ARect: TRect; AColor: TColor; AWidth: Integer);
var
  LRect: TRect;
begin
  LRect := Rect(ARect.Left, ARect.Top, Min(ARect.Left + AWidth, ARect.Right), ARect.Bottom);
  FillRectColor(ACanvas, LRect, AColor);
end;

{ TDCGridDataAdapter }

function ContainsTextEx(const AText, ASubText: string): Boolean;
begin
  Result := Pos(UpperCase(ASubText), UpperCase(AText)) > 0;
end;


procedure TDCGridDataAdapter.Changed;
begin
end;

function TDCGridDataAdapter.GetDetailCellText(AMasterRow, ADetailRow,
  ADetailCol: Integer): string;
begin
  Result := '';
end;

function TDCGridDataAdapter.GetDetailRowCount(AMasterRow: Integer): Integer;
begin
  Result := 0;
end;

function TDCGridDataAdapter.GetMasterCellText(ARow, ACol: Integer): string;
begin
  Result := '';
end;

function TDCGridDataAdapter.GetMasterRowCount: Integer;
begin
  Result := 0;
end;

{ TDCDataSetAdapter }

procedure TDCDataSetAdapter.Assign(Source: TPersistent);
begin
  if Source is TDCDataSetAdapter then
  begin
    DataSet := TDCDataSetAdapter(Source).DataSet;
    DetailDataSet := TDCDataSetAdapter(Source).DetailDataSet;
    MasterKeyField := TDCDataSetAdapter(Source).MasterKeyField;
    DetailKeyField := TDCDataSetAdapter(Source).DetailKeyField;
  end
  else
    inherited;
end;

constructor TDCDataSetAdapter.Create(AOwnerGrid: TDCMasterDetailGrid);
begin
  inherited Create;
  FOwnerGrid := AOwnerGrid;
  FMasterKeyField := '';
  FDetailKeyField := '';
end;

function TDCDataSetAdapter.GetFieldTextByColumn(ARecordIndex, ACol: Integer): string;
var
  Bmk: TBookmark;
  I: Integer;
  FieldName: string;
begin
  Result := '';
  if (FDataSet = nil) or (not FDataSet.Active) then
    Exit;
  if (ACol < 0) or (ACol >= FOwnerGrid.Columns.Count) then
    Exit;

  FieldName := FOwnerGrid.Columns[ACol].FieldName;
  if Trim(FieldName) = '' then
    Exit;

  FDataSet.DisableControls;
  try
    if Assigned(FOwnerGrid) then FOwnerGrid.LogDebug(Format('DataSetAdapter.GetMasterRowCount dataset=%s active=%s', [FDataSet.Name, BoolToStr(FDataSet.Active, True)]));
    Bmk := FDataSet.Bookmark;
    try
      FDataSet.First;
      for I := 0 to ARecordIndex - 1 do
      begin
        if FDataSet.Eof then Break;
        FDataSet.Next;
      end;
      if (not FDataSet.Eof) and (FDataSet.FindField(FieldName) <> nil) then
        Result := FDataSet.FieldByName(FieldName).AsString;
    finally
      if FDataSet.BookmarkValid(Bmk) then
        FDataSet.Bookmark := Bmk;
    end;
  finally
    FDataSet.EnableControls;
  end;
end;


function TDCDataSetAdapter.GetFieldValueByName(ARecordIndex: Integer; const AFieldName: string): Variant;
var
  Bmk: TBookmark;
  I: Integer;
begin
  Result := Null;
  if (FDataSet = nil) or (not FDataSet.Active) or (Trim(AFieldName) = '') then
    Exit;

  FDataSet.DisableControls;
  try
    Bmk := FDataSet.Bookmark;
    try
      FDataSet.First;
      for I := 0 to ARecordIndex - 1 do
      begin
        if FDataSet.Eof then Break;
        FDataSet.Next;
      end;
      if (not FDataSet.Eof) and (FDataSet.FindField(AFieldName) <> nil) then
        Result := FDataSet.FieldByName(AFieldName).Value;
    finally
      if FDataSet.BookmarkValid(Bmk) then
        FDataSet.Bookmark := Bmk;
    end;
  finally
    FDataSet.EnableControls;
  end;
end;

function TDCDataSetAdapter.GetMasterKeyValue(ARecordIndex: Integer): Variant;
var
  Bmk: TBookmark;
  I: Integer;
begin
  Result := Null;
  if (FDataSet = nil) or (not FDataSet.Active) or (Trim(FMasterKeyField) = '') then
    Exit;

  FDataSet.DisableControls;
  try
    Bmk := FDataSet.Bookmark;
    try
      FDataSet.First;
      for I := 0 to ARecordIndex - 1 do
      begin
        if FDataSet.Eof then Break;
        FDataSet.Next;
      end;
      if (not FDataSet.Eof) and (FDataSet.FindField(FMasterKeyField) <> nil) then
        Result := FDataSet.FieldByName(FMasterKeyField).Value;
    finally
      if FDataSet.BookmarkValid(Bmk) then
        FDataSet.Bookmark := Bmk;
    end;
  finally
    FDataSet.EnableControls;
  end;
end;

function TDCDataSetAdapter.GetMasterCellText(ARow, ACol: Integer): string;
begin
  Result := GetFieldTextByColumn(ARow, ACol);
end;

function TDCDataSetAdapter.GetMasterRowCount: Integer;
var
  Bmk: TBookmark;
begin
  Result := 0;
  if (FDataSet = nil) or (not FDataSet.Active) then
    Exit;

  FDataSet.DisableControls;
  try
    Bmk := FDataSet.Bookmark;
    try
      FDataSet.Last;
      Result := FDataSet.RecordCount;
    finally
      if FDataSet.BookmarkValid(Bmk) then
        FDataSet.Bookmark := Bmk;
    end;
  finally
    FDataSet.EnableControls;
  end;
end;

function TDCDataSetAdapter.GetDetailRowCount(AMasterRow: Integer): Integer;
var
  Bmk: TBookmark;
  MasterValue: Variant;
begin
  Result := 0;
  if (FDetailDataSet = nil) or (not FDetailDataSet.Active) then
    Exit;
  if (Trim(FMasterKeyField) = '') or (Trim(FDetailKeyField) = '') then
    Exit;
  if FDetailDataSet.FindField(FDetailKeyField) = nil then
    Exit;

  MasterValue := GetMasterKeyValue(AMasterRow);
  if VarIsNull(MasterValue) then
    Exit;

  FDetailDataSet.DisableControls;
  try
    if Assigned(FOwnerGrid) then FOwnerGrid.LogDebug(Format('DataSetAdapter.GetDetailRowCount masterRow=%d keyField=%s detailField=%s', [AMasterRow, FMasterKeyField, FDetailKeyField]));
    Bmk := FDetailDataSet.Bookmark;
    try
      FDetailDataSet.First;
      while not FDetailDataSet.Eof do
      begin
        if VarSameValue(FDetailDataSet.FieldByName(FDetailKeyField).Value, MasterValue) then
          Inc(Result);
        FDetailDataSet.Next;
      end;
    finally
      if (Bmk <> nil) and FDetailDataSet.BookmarkValid(Bmk) then
        FDetailDataSet.Bookmark := Bmk;
    end;
  finally
    FDetailDataSet.EnableControls;
  end;
end;

function TDCDataSetAdapter.GetDetailCellText(AMasterRow, ADetailRow, ADetailCol: Integer): string;
var
  Bmk: TBookmark;
  MasterValue: Variant;
  FieldName: string;
  MatchIndex: Integer;
begin
  Result := '';
  if (FDetailDataSet = nil) or (not FDetailDataSet.Active) then
    Exit;
  if (Trim(FMasterKeyField) = '') or (Trim(FDetailKeyField) = '') then
    Exit;
  if (ADetailCol < 0) or (ADetailCol >= FOwnerGrid.DetailColumns.Count) then
    Exit;

  FieldName := FOwnerGrid.DetailColumns[ADetailCol].FieldName;
  if Trim(FieldName) = '' then
    Exit;
  if FDetailDataSet.FindField(FieldName) = nil then
    Exit;

  MasterValue := GetMasterKeyValue(AMasterRow);
  if VarIsNull(MasterValue) then
    Exit;

  FDetailDataSet.DisableControls;
  try
    if Assigned(FOwnerGrid) then FOwnerGrid.LogDebug(Format('DataSetAdapter.GetDetailCellText masterRow=%d detailRow=%d col=%d field=%s', [AMasterRow, ADetailRow, ADetailCol, FieldName]));
    Bmk := FDetailDataSet.Bookmark;
    try
      MatchIndex := -1;
      FDetailDataSet.First;
      while not FDetailDataSet.Eof do
      begin
        if VarSameValue(FDetailDataSet.FieldByName(FDetailKeyField).Value, MasterValue) then
        begin
          Inc(MatchIndex);
          if MatchIndex = ADetailRow then
          begin
            Result := FDetailDataSet.FieldByName(FieldName).AsString;
            Break;
          end;
        end;
        FDetailDataSet.Next;
      end;
    finally
      if FDetailDataSet.BookmarkValid(Bmk) then
        FDetailDataSet.Bookmark := Bmk;
    end;
  finally
    FDetailDataSet.EnableControls;
  end;
end;

procedure TDCDataSetAdapter.SetDataSet(const Value: TDataSet);
begin
  FDataSet := Value;
  if Assigned(FOwnerGrid) then
    FOwnerGrid.RefreshGrid;
end;

procedure TDCDataSetAdapter.SetDetailDataSet(const Value: TDataSet);
begin
  FDetailDataSet := Value;
  if Assigned(FOwnerGrid) then
    FOwnerGrid.RefreshGrid;
end;

{ TDCGridColumn }

procedure TDCGridColumn.Changed;
begin
  if Collection is TDCGridColumns then
    TDCGridColumns(Collection).Changed;
end;

constructor TDCGridColumn.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FCaption := '';
  FWidth := 120;
  FVisible := True;
  FAlignment := taLeft;
  FFieldName := '';
  FDisplayFormat := '';
  FFooterSummary := fsNone;
  FFilterText := '';
end;

function TDCGridColumn.GetDisplayName: string;
begin
  if Trim(FCaption) <> '' then
    Result := FCaption
  else
    Result := inherited GetDisplayName;
end;

procedure TDCGridColumn.SetAlignment(const Value: TDCTextAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    Changed;
  end;
end;

procedure TDCGridColumn.SetCaption(const Value: string);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    Changed;
  end;
end;

procedure TDCGridColumn.SetFieldName(const Value: string);
begin
  if FFieldName <> Value then
  begin
    FFieldName := Value;
    Changed;
  end;
end;

procedure TDCGridColumn.SetDisplayFormat(const Value: string);
begin
  if FDisplayFormat <> Value then
  begin
    FDisplayFormat := Value;
    Changed;
  end;
end;



procedure TDCGridColumn.Assign(Source: TPersistent);
begin
  if Source is TDCGridColumn then
  begin
    FCaption := TDCGridColumn(Source).Caption;
    FWidth := TDCGridColumn(Source).Width;
    FVisible := TDCGridColumn(Source).Visible;
    FAlignment := TDCGridColumn(Source).Alignment;
    FFieldName := TDCGridColumn(Source).FieldName;
    FDisplayFormat := TDCGridColumn(Source).DisplayFormat;
    FFooterSummary := TDCGridColumn(Source).FooterSummary;
    FFilterText := TDCGridColumn(Source).FilterText;
    Changed;
  end
  else
    inherited;
end;

procedure TDCGridColumn.SetFooterSummary(const Value: TDCFooterSummary);
begin
  if FFooterSummary <> Value then
  begin
    FFooterSummary := Value;
    Changed;
  end;
end;

procedure TDCGridColumn.SetFilterText(const Value: string);
begin
  if FFilterText <> Value then
  begin
    FFilterText := Value;
    Changed;
  end;
end;

function TDCGridColumn.FooterNone: TDCGridColumn;
begin
  FooterSummary := fsNone;
  Result := Self;
end;

function TDCGridColumn.FooterSum: TDCGridColumn;
begin
  FooterSummary := fsSum;
  Result := Self;
end;

function TDCGridColumn.FooterCount: TDCGridColumn;
begin
  FooterSummary := fsCount;
  Result := Self;
end;

function TDCGridColumn.FooterAvg: TDCGridColumn;
begin
  FooterSummary := fsAvg;
  Result := Self;
end;

function TDCGridColumn.FooterMin: TDCGridColumn;
begin
  FooterSummary := fsMin;
  Result := Self;
end;

function TDCGridColumn.FooterMax: TDCGridColumn;
begin
  FooterSummary := fsMax;
  Result := Self;
end;

procedure TDCGridColumn.SetVisible(const Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    Changed;
  end;
end;

procedure TDCGridColumn.SetWidth(const Value: Integer);
begin
  if FWidth <> Value then
  begin
    FWidth := Max(40, Value);
    Changed;
  end;
end;

{ TDCGridColumns }

function TDCGridColumns.Add: TDCGridColumn;
begin
  Result := TDCGridColumn(inherited Add);
end;

procedure TDCGridColumns.Changed;
begin
  inherited Changed;
end;

constructor TDCGridColumns.Create(AOwner: TDCMasterDetailGrid);
begin
  inherited Create(TDCGridColumn);
  FOwner := AOwner;
end;

function TDCGridColumns.GetItem(Index: Integer): TDCGridColumn;
begin
  Result := TDCGridColumn(inherited GetItem(Index));
end;

procedure TDCGridColumns.SetItem(Index: Integer; const Value: TDCGridColumn);
begin
  inherited SetItem(Index, Value);
end;

procedure TDCGridColumns.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
  if Assigned(FOwner) then
    FOwner.ColumnsChanged;
end;

{ TDCGridTheme }


constructor TDCHighlightRule.Create(const AExpression: string; ABackColor: TColor; AFontColor: TColor; AFontStyles: TFontStyles; ATarget: TDCHighlightTarget = htRow);
begin
  inherited Create;
  FExpression := Trim(AExpression);
  FBackColor := ABackColor;
  FFontColor := AFontColor;
  FFontStyles := AFontStyles;
  FTarget := ATarget;
end;


function DCNormalizeNumericText(const AValue: string): string;
var
  S: string;
  I: Integer;
  LastComma, LastDot: Integer;
  DecimalSep: Char;
begin
  S := Trim(AValue);
  S := StringReplace(S, #160, ' ', [rfReplaceAll]);
  S := StringReplace(S, 'R$', '', [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, '$', '', [rfReplaceAll]);
  S := StringReplace(S, '€', '', [rfReplaceAll]);
  S := StringReplace(S, '£', '', [rfReplaceAll]);
  S := StringReplace(S, '¥', '', [rfReplaceAll]);
  S := StringReplace(S, ' ', '', [rfReplaceAll]);

  Result := '';
  for I := 1 to Length(S) do
    if CharInSet(S[I], ['0'..'9', ',', '.', '-', '+']) then
      Result := Result + S[I];

  LastComma := LastDelimiter(',', Result);
  LastDot := LastDelimiter('.', Result);

  if (LastComma > 0) and (LastDot > 0) then
  begin
    if LastComma > LastDot then
      DecimalSep := ','
    else
      DecimalSep := '.';
  end
  else if LastComma > 0 then
    DecimalSep := ','
  else
    DecimalSep := '.';

  if DecimalSep = ',' then
  begin
    Result := StringReplace(Result, '.', '', [rfReplaceAll]);
    Result := StringReplace(Result, ',', '.', [rfReplaceAll]);
  end
  else
    Result := StringReplace(Result, ',', '', [rfReplaceAll]);
end;

function DCTryParseFlexibleFloat(const AValue: string; out ANumber: Double): Boolean;
var
  S: string;
  FS: TFormatSettings;
begin
  S := DCNormalizeNumericText(AValue);
  FS := TFormatSettings.Create;
  FS.DecimalSeparator := '.';
  FS.ThousandSeparator := #0;
  Result := (S <> '') and (S <> '-') and (S <> '+') and TryStrToFloat(S, ANumber, FS);
end;

function TDCHighlightRule.Match(const AValue: Variant): Boolean;
var
  S, Expr, RightSide: string;
  N, Cmp: Double;
begin
  Result := False;
  Expr := Trim(FExpression);
  if Expr = '' then
    Exit;

  S := Trim(VarToStr(AValue));

  if Length(Expr) >= 2 then
  begin
    if Copy(Expr, 1, 2) = '<>' then
    begin
      RightSide := Trim(Copy(Expr, 3, MaxInt));
      Result := not SameText(S, RightSide);
      Exit;
    end;

    if (Copy(Expr, 1, 2) = '>=') or (Copy(Expr, 1, 2) = '<=') then
    begin
      RightSide := Trim(Copy(Expr, 3, MaxInt));
      if DCTryParseFlexibleFloat(S, N) and DCTryParseFlexibleFloat(RightSide, Cmp) then
      begin
        if Copy(Expr, 1, 2) = '>=' then
          Result := N >= Cmp
        else
          Result := N <= Cmp;
      end;
      Exit;
    end;
  end;

  if (Length(Expr) > 0) and ((Expr[1] = '>') or (Expr[1] = '<') or (Expr[1] = '=') or (Expr[1] = '^')) then
  begin
    RightSide := Trim(Copy(Expr, 2, MaxInt));

    if Expr[1] = '^' then
    begin
      Result := SameText(Copy(S, 1, Length(RightSide)), RightSide);
      Exit;
    end;

    if DCTryParseFlexibleFloat(S, N) and DCTryParseFlexibleFloat(RightSide, Cmp) then
    begin
      case Expr[1] of
        '>': Result := N > Cmp;
        '<': Result := N < Cmp;
        '=': Result := SameValue(N, Cmp);
      end;
    end
    else if Expr[1] = '=' then
      Result := SameText(S, RightSide);
    Exit;
  end;

  Result := Pos(UpperCase(Expr), UpperCase(S)) > 0;
end;

constructor TDCHighlightRules.Create(AOwnsObjects: Boolean; AOwnerGrid: TDCMasterDetailGrid);
begin
  inherited Create(AOwnsObjects);
  FOwnerGrid := AOwnerGrid;
end;

function TDCHighlightRules.Add(const AExpression: string; ABackColor: TColor; AFontColor: TColor; AFontStyles: TFontStyles; ATarget: TDCHighlightTarget): TDCHighlightRule;
begin
  Result := TDCHighlightRule.Create(AExpression, ABackColor, AFontColor, AFontStyles, ATarget);
  inherited Add(Result);
end;

function TDCHighlightRules.AddForField(const AFieldName, AExpression: string; ABackColor: TColor; AFontColor: TColor; AFontStyles: TFontStyles; ATarget: TDCHighlightTarget): TDCHighlightRule;
begin
  Result := Add(AExpression, ABackColor, AFontColor, AFontStyles, ATarget);
  Result.FieldName := Trim(AFieldName);
end;

procedure TDCHighlightRules.Edit;
begin
  if Assigned(FOwnerGrid) then
    FOwnerGrid.ShowRulesDesigner;
end;

constructor TDCBusinessHighlight.Create(AOwner: TDCMasterDetailGrid);
begin
  inherited Create;
  FOwner := AOwner;
  FRules := TDCHighlightRules.Create(True, AOwner);
end;

destructor TDCBusinessHighlight.Destroy;
begin
  FRules.Free;
  inherited;
end;

procedure TDCBusinessHighlight.Changed;
begin
  if Assigned(FOwner) then
    FOwner.Invalidate;
end;

procedure TDCBusinessHighlight.SetEnabled(const Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    Changed;
  end;
end;

procedure TDCBusinessHighlight.SetField(const Value: string);
begin
  if FField <> Value then
  begin
    FField := Value;
    Changed;
  end;
end;

procedure TDCBusinessHighlight.Assign(Source: TPersistent);
var
  I: Integer;
  S: TDCBusinessHighlight;
begin
  if Source is TDCBusinessHighlight then
  begin
    S := TDCBusinessHighlight(Source);
    FEnabled := S.FEnabled;
    FField := S.FField;
    FRules.Clear;
    for I := 0 to S.Rules.Count - 1 do
      FRules.AddForField(S.Rules[I].FieldName, S.Rules[I].Expression, S.Rules[I].BackColor, S.Rules[I].FontColor, S.Rules[I].FontStyles, S.Rules[I].Target);
    Changed;
  end
  else
    inherited Assign(Source);
end;

procedure TDCBusinessHighlight.Clear;
begin
  FRules.Clear;
  Changed;
end;

function TDCBusinessHighlight.ToJSON: string;
var
  LRoot: TJSONObject;
  LRules: TJSONArray;
  LRule: TDCHighlightRule;
  LItem: TJSONObject;
  LStyles: string;
begin
  LRoot := TJSONObject.Create;
  try
    LRoot.AddPair('enabled', TJSONBool.Create(FEnabled));
    LRoot.AddPair('field', FField);

    LRules := TJSONArray.Create;
    for LRule in FRules do
    begin
      LStyles := DCFontStylesToString(LRule.FontStyles);
      LItem := TJSONObject.Create;
      LItem.AddPair('field', LRule.FieldName);
      LItem.AddPair('expression', LRule.Expression);
      LItem.AddPair('backColor', TJSONNumber.Create(Integer(LRule.BackColor)));
      LItem.AddPair('fontColor', TJSONNumber.Create(Integer(LRule.FontColor)));
      LItem.AddPair('fontStyles', LStyles);
      case LRule.Target of
        htCell: LItem.AddPair('target', 'cell');
      else
        LItem.AddPair('target', 'row');
      end;
      LRules.AddElement(LItem);
    end;
    LRoot.AddPair('rules', LRules);
    Result := LRoot.ToJSON;
  finally
    LRoot.Free;
  end;
end;

procedure TDCBusinessHighlight.FromJSON(const AJSON: string);
var
  LValue: TJSONValue;
  LRoot: TJSONObject;
  LRules: TJSONArray;
  I: Integer;
  LItem: TJSONObject;
  LExpression: string;
  LBackColor: TColor;
  LFontColor: TColor;
  LFontStylesText: string;
  LDecodedStyles: TFontStyles;
  LTargetText: string;
  LTarget: TDCHighlightTarget;
  LFieldName: string;
begin
  if Trim(AJSON) = '' then
    Exit;

  LValue := TJSONObject.ParseJSONValue(AJSON);
  try
    if not (LValue is TJSONObject) then
      Exit;

    LRoot := TJSONObject(LValue);
    FEnabled := SameText(LRoot.GetValue<string>('enabled', 'false'), 'true');
    FField := LRoot.GetValue<string>('field', '');
    FRules.Clear;

    if LRoot.TryGetValue<TJSONArray>('rules', LRules) then
    begin
      for I := 0 to LRules.Count - 1 do
      begin
        if not (LRules.Items[I] is TJSONObject) then
          Continue;
        LItem := TJSONObject(LRules.Items[I]);
        LFieldName := LItem.GetValue<string>('field', FField);
        LExpression := LItem.GetValue<string>('expression', '');
        LBackColor := TColor(LItem.GetValue<Integer>('backColor', Integer(clNone)));
        LFontColor := TColor(LItem.GetValue<Integer>('fontColor', Integer(clNone)));
        LFontStylesText := LItem.GetValue<string>('fontStyles', '');
        LDecodedStyles := DCStringToFontStyles(LFontStylesText);
        LTargetText := Trim(LItem.GetValue<string>('target', 'row'));
        if SameText(LTargetText, 'cell') then
          LTarget := htCell
        else
          LTarget := htRow;
        FRules.AddForField(LFieldName, LExpression, LBackColor, LFontColor, LDecodedStyles, LTarget);
      end;
    end;

    Changed;
  finally
    LValue.Free;
  end;
end;

procedure TDCBusinessHighlight.SaveToFile(const AFileName: string);
begin
  if Trim(AFileName) = '' then
    Exit;
  TDirectory.CreateDirectory(ExtractFilePath(AFileName));
  TFile.WriteAllText(AFileName, ToJSON, TEncoding.UTF8);
end;

procedure TDCBusinessHighlight.LoadFromFile(const AFileName: string);
begin
  if (Trim(AFileName) = '') or (not TFile.Exists(AFileName)) then
    Exit;
  FromJSON(TFile.ReadAllText(AFileName, TEncoding.UTF8));
end;

function TDCBusinessHighlight.Evaluate(const AValue: Variant; var ABackColor, AFontColor: TColor; var AFontStyles: TFontStyles): Boolean;
var
  LTarget: TDCHighlightTarget;
begin
  Result := Evaluate(AValue, LTarget, ABackColor, AFontColor, AFontStyles);
end;

function TDCBusinessHighlight.Evaluate(const AValue: Variant; out ATarget: TDCHighlightTarget; var ABackColor, AFontColor: TColor; var AFontStyles: TFontStyles): Boolean;
var
  I: Integer;
  R: TDCHighlightRule;
begin
  Result := False;
  ATarget := htRow;
  if not FEnabled then
    Exit;
  for I := 0 to FRules.Count - 1 do
  begin
    R := FRules[I];
    if R.Match(AValue) then
    begin
      ATarget := R.Target;
      ABackColor := R.BackColor;
      if R.FontColor <> clNone then
        AFontColor := R.FontColor;
      if R.FontStyles <> [] then
        AFontStyles := R.FontStyles;
      Exit(True);
    end;
  end;
end;

procedure TDCGridTheme.SetSearchHighlightColor(const Value: TColor);
begin
  if FSearchHighlightColor <> Value then
  begin
    FSearchHighlightColor := Value;
    Changed;
  end;
end;

procedure TDCGridTheme.SetSearchHighlightTextColor(const Value: TColor);
begin
  if FSearchHighlightTextColor <> Value then
  begin
    FSearchHighlightTextColor := Value;
    Changed;
  end;
end;

procedure TDCGridTheme.Assign(Source: TPersistent);
var
  S: TDCGridTheme;
begin
  if Source is TDCGridTheme then
  begin
    S := TDCGridTheme(Source);
    FHeaderColor := S.FHeaderColor;
    FHeaderFontColor := S.FHeaderFontColor;
    FGridBackgroundColor := S.FGridBackgroundColor;
    FRowColor := S.FRowColor;
    FAlternateRowColor := S.FAlternateRowColor;
    FHoverRowColor := S.FHoverRowColor;
    FSelectedRowColor := S.FSelectedRowColor;
    FDetailColor := S.FDetailColor;
    FBorderColor := S.FBorderColor;
    FDetailBorderColor := S.FDetailBorderColor;
    FTextColor := S.FTextColor;
    FDetailTextColor := S.FDetailTextColor;
    FExpandButtonColor := S.FExpandButtonColor;
    FDetailGridHeaderColor := S.FDetailGridHeaderColor;
    FDetailGridHeaderFontColor := S.FDetailGridHeaderFontColor;
    FDetailGridRowColor := S.FDetailGridRowColor;
    FDetailGridAlternateRowColor := S.FDetailGridAlternateRowColor;
    FDetailGridLineColor := S.FDetailGridLineColor;
    FSearchHighlightColor := S.FSearchHighlightColor;
    FSearchHighlightTextColor := S.FSearchHighlightTextColor;
    Changed;
  end
  else
    inherited Assign(Source);
end;

procedure TDCGridTheme.ApplyThemePalette(const APalette: TDCFlexThemePalette);
begin
  FHeaderColor := APalette.HeaderBack;
  FHeaderFontColor := APalette.Text;
  FGridBackgroundColor := APalette.Background;
  FRowColor := APalette.Surface;
  FAlternateRowColor := APalette.SurfaceAlt;
  FHoverRowColor := APalette.Hover;
  FSelectedRowColor := APalette.Selection;
  FSelectedTextColor := APalette.SelectionText;
  FDetailColor := APalette.SurfaceAlt;
  FBorderColor := APalette.GridLine;
  FDetailBorderColor := APalette.Border;
  FTextColor := APalette.Text;
  FDetailTextColor := APalette.MutedText;
  FExpandButtonColor := APalette.Accent;
  FDetailGridHeaderColor := APalette.HeaderBack;
  FDetailGridHeaderFontColor := APalette.Text;
  FDetailGridRowColor := APalette.Surface;
  FDetailGridAlternateRowColor := APalette.SurfaceAlt;
  FDetailGridLineColor := APalette.GridLine;
  FSearchHighlightColor := APalette.Warning;
  FSearchHighlightTextColor := APalette.Text;
  Changed;
end;

procedure TDCGridTheme.Changed;
begin
  if Assigned(FOwner) then
    FOwner.ThemeChanged;
end;

constructor TDCGridTheme.Create(AOwner: TDCMasterDetailGrid);
begin
  inherited Create;
  FOwner := AOwner;
  ResetDefault;
end;

procedure TDCGridTheme.ResetDefault;
begin
  FHeaderColor := $00F3F6FA;
  FHeaderFontColor := $0029384B;
  FGridBackgroundColor := $00F6F8FB;
  FRowColor := clWhite;
  FAlternateRowColor := $00F8FAFD;
  FHoverRowColor := $00EEF4FB;
  FSelectedRowColor := $00DDEBFA;
  FSelectedTextColor := $0029384B;
  FDetailColor := $00EEF3F9;
  FBorderColor := $00D7E0EA;
  FDetailBorderColor := $00D9E2EC;
  FTextColor := $002A3442;
  FDetailTextColor := $002D3745;
  FExpandButtonColor := $00697C96;
  FDetailGridHeaderColor := $00E6EDF7;
  FDetailGridHeaderFontColor := $002D3745;
  FDetailGridRowColor := clWhite;
  FDetailGridAlternateRowColor := $00F9FBFE;
  FDetailGridLineColor := $00DFE6EF;
  FSearchHighlightColor := $00FFF2A8;
  FSearchHighlightTextColor := $001F2D3D;
  Changed;
end;

procedure TDCGridTheme.SetAlternateRowColor(const Value: TColor);
begin if FAlternateRowColor <> Value then begin FAlternateRowColor := Value; Changed; end; end;
procedure TDCGridTheme.SetBorderColor(const Value: TColor);
begin if FBorderColor <> Value then begin FBorderColor := Value; Changed; end; end;
procedure TDCGridTheme.SetDetailBorderColor(const Value: TColor);
begin if FDetailBorderColor <> Value then begin FDetailBorderColor := Value; Changed; end; end;
procedure TDCGridTheme.SetDetailColor(const Value: TColor);
begin if FDetailColor <> Value then begin FDetailColor := Value; Changed; end; end;
procedure TDCGridTheme.SetDetailGridAlternateRowColor(const Value: TColor);
begin if FDetailGridAlternateRowColor <> Value then begin FDetailGridAlternateRowColor := Value; Changed; end; end;
procedure TDCGridTheme.SetDetailGridHeaderColor(const Value: TColor);
begin if FDetailGridHeaderColor <> Value then begin FDetailGridHeaderColor := Value; Changed; end; end;
procedure TDCGridTheme.SetDetailGridHeaderFontColor(const Value: TColor);
begin if FDetailGridHeaderFontColor <> Value then begin FDetailGridHeaderFontColor := Value; Changed; end; end;
procedure TDCGridTheme.SetDetailGridLineColor(const Value: TColor);
begin if FDetailGridLineColor <> Value then begin FDetailGridLineColor := Value; Changed; end; end;
procedure TDCGridTheme.SetDetailGridRowColor(const Value: TColor);
begin if FDetailGridRowColor <> Value then begin FDetailGridRowColor := Value; Changed; end; end;
procedure TDCGridTheme.SetDetailTextColor(const Value: TColor);
begin if FDetailTextColor <> Value then begin FDetailTextColor := Value; Changed; end; end;
procedure TDCGridTheme.SetExpandButtonColor(const Value: TColor);
begin if FExpandButtonColor <> Value then begin FExpandButtonColor := Value; Changed; end; end;
procedure TDCGridTheme.SetGridBackgroundColor(const Value: TColor);
begin if FGridBackgroundColor <> Value then begin FGridBackgroundColor := Value; Changed; end; end;
procedure TDCGridTheme.SetHeaderColor(const Value: TColor);
begin if FHeaderColor <> Value then begin FHeaderColor := Value; Changed; end; end;
procedure TDCGridTheme.SetHeaderFontColor(const Value: TColor);
begin if FHeaderFontColor <> Value then begin FHeaderFontColor := Value; Changed; end; end;
procedure TDCGridTheme.SetHoverRowColor(const Value: TColor);
begin if FHoverRowColor <> Value then begin FHoverRowColor := Value; Changed; end; end;
procedure TDCGridTheme.SetRowColor(const Value: TColor);
begin if FRowColor <> Value then begin FRowColor := Value; Changed; end; end;
procedure TDCGridTheme.SetSelectedRowColor(const Value: TColor);
begin if FSelectedRowColor <> Value then begin FSelectedRowColor := Value; Changed; end; end;

procedure TDCGridTheme.SetSelectedTextColor(const Value: TColor);
begin
  if FSelectedTextColor <> Value then
  begin
    FSelectedTextColor := Value;
    Changed;
  end;
end;

procedure TDCGridTheme.SetTextColor(const Value: TColor);
begin if FTextColor <> Value then begin FTextColor := Value; Changed; end; end;

{ TDCMasterDetailGrid }

procedure TDCMasterDetailGrid.CollapseAll;
begin
  if FExpandedRows.Count > 0 then
  begin
    FExpandedRows.Clear;
    FExpandedRow := -1;
    FSelectedDetailRow := -1;
    FHoverDetailRow := -1;
    UpdateScrollBar;
    Invalidate;
  end;
end;

procedure TDCMasterDetailGrid.CollapseRow;
begin
  if (FSelectedRow >= 0) and IsRowExpanded(FSelectedRow) then
    CollapseRow(FSelectedRow)
  else if FExpandedRow <> -1 then
    CollapseRow(FExpandedRow)
  else if FExpandedRows.Count > 0 then
    CollapseRow(FExpandedRows.Last);
end;

procedure TDCMasterDetailGrid.CollapseRow(ARow: Integer);
var
  LIndex: Integer;
begin
  LIndex := FExpandedRows.IndexOf(ARow);
  if LIndex <> -1 then
  begin
    FExpandedRows.Delete(LIndex);
    if FExpandedRow = ARow then
    begin
      if FExpandedRows.Count > 0 then
        FExpandedRow := FExpandedRows.Last
      else
        FExpandedRow := -1;
    end;
    if FSelectedRow = ARow then
    begin
      FSelectedDetailRow := -1;
      FHoverDetailRow := -1;
    end;
    if FDetailScrollMasterRow = ARow then
    begin
      FDetailScrollMasterRow := -1;
      FDetailVerticalOffset := 0;
    end;
    UpdateScrollBar;
    Invalidate;
  end;
end;

procedure TDCMasterDetailGrid.CMFontChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TDCMasterDetailGrid.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if (FHoverRow <> -1) or (FHoverDetailRow <> -1) or (FDetailHeaderHoverColumn <> -1) then
  begin
    FHoverRow := -1;
    FHoverDetailRow := -1;
    FDetailHeaderHoverColumn := -1;
    if FDetailResizingColumn = -1 then
      FDetailResizeMasterRow := -1;
    Invalidate;
  end;
  if (FResizingColumn = -1) and (FDetailResizingColumn = -1) then
    Cursor := crDefault;
end;

procedure TDCMasterDetailGrid.CMEnter(var Message: TCMEnter);
begin
  inherited;
  Invalidate;
end;

procedure TDCMasterDetailGrid.CMExit(var Message: TCMExit);
begin
  inherited;
  Invalidate;
end;

procedure TDCMasterDetailGrid.ColumnsChanged;
begin
  UpdateColumnFilterLayout;

  if (Trim(FSearchText) <> '') or HasColumnFilters then
    RebuildFilter
  else
  begin
    UpdateScrollBar;
    Invalidate;
  end;

  if FAutoSaveLayout and not (csLoading in ComponentState) then
    SaveLayout;
end;

constructor TDCMasterDetailGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csOpaque, csDoubleClicks, csCaptureMouse];
  Width := 520;
  Height := 280;
  TabStop := True;
  DoubleBuffered := True;
  ParentDoubleBuffered := False;
  ParentColor := False;
  Color := clWhite;

  FColumns := TDCGridColumns.Create(Self);
  FDetailColumns := TDCGridColumns.Create(Self);
  FTheme := TDCGridTheme.Create(Self);
  FThemeMode := dtmLight;
  FDataSetAdapter := TDCDataSetAdapter.Create(Self);
  FBusinessHighlight := TDCBusinessHighlight.Create(Self);
  FExpandedRows := TList<Integer>.Create;
  FFilteredRows := TList<Integer>.Create;

  FRowCount := 0;
  FRowHeight := DC_DEFAULT_ROW_HEIGHT;
  FHeaderHeight := DC_DEFAULT_HEADER_HEIGHT;
  FDetailHeight := DC_DEFAULT_DETAIL_HEIGHT;
  FDetailGridHeaderHeight := DC_DEFAULT_DETAIL_GRID_HEADER_HEIGHT;
  FDetailGridRowHeight := DC_DEFAULT_DETAIL_GRID_ROW_HEIGHT;
  FDetailVerticalScroll := True;
  FDetailMaxHeight := 180;
  FDetailScrollMasterRow := -1;
  FDetailVerticalOffset := 0;
  FSelectedRow := -1;
  FExpandedRow := -1;
  FHoverRow := -1;
  FTopRow := 0;
  FShowHeader := True;
  FShowHeaderColumnLines := True;
  FShowRowColumnLines := False;
  FFrozenColumns := 0;
  FHorizontalOffset := 0;
  FAllowContextMenuActions := True;
  FAllowHeaderFooterSummaryMenu := True;
  FHeaderFooterPopupColumn := -1;
  FShowExpandButton := True;
  FAlternateColors := True;
  FExpandOnRowClick := True;
  FAllowColumnResize := True;
  FAllowColumnSort := True;
  FMinColumnWidth := 40;
  FSortedColumn := -1;
  FSortDirection := sdNone;
  FResizingColumn := -1;
  FDetailResizingColumn := -1;
  FDetailResizeMasterRow := -1;
  FDetailScrollDragging := False;
  FDetailScrollDragMasterRow := -1;
  FDetailScrollDragStartY := 0;
  FDetailScrollDragStartOffset := 0;
  FDetailHorizontalOffset := 0;
  FDetailHorizontalDragging := False;
  FDetailHorizontalDragMasterRow := -1;
  FDetailHorizontalDragStartX := 0;
  FDetailHorizontalDragStartOffset := 0;
  FResizeStartX := 0;
  FResizeColumnStartWidth := 0;
  FHeaderHoverColumn := -1;
  FDetailHeaderHoverColumn := -1;
  FAllowDetailColumnResize := True;
  FBorderWidth := 1;
  FDetailStyle := dsText;

  FTitleFont := TFont.Create;
  FTitleFont.Assign(Font);
  FTitleFont.Style := [fsBold];
  FTitleFont.OnChange := TitleFontChanged;

  FDetailFont := TFont.Create;
  FDetailFont.Assign(Font);
  FDetailFont.Color := $00313A47;
  FDetailFont.OnChange := DetailFontChanged;

  FDetailSelectEnabled := True;
  FLayoutKey := '';
  FLayoutFileName := '';
  FAutoLoadLayout := True;
  FAutoSaveLayout := False;
  FDebugLogEnabled := False;
  FSearchText := '';
  FFilterMode := fmContains;
  FSearchScope := ssMasterOnly;
  FAutoExpandOnSearch := False;
  FSelectedDetailRow := -1;
  FHoverDetailRow := -1;
  FRulesDesignerLanguage := rdlPortuguese;
  FRulesDesignerAutoLoadPreferences := True;
  FRulesDesignerAutoSavePreferences := True;
  FRulesDesignerCustomLanguage := nil;

  FShowToolbar := False;
  FToolbarHeight := DC_DEFAULT_TOOLBAR_HEIGHT;
  FShowToolbarRulesDesignerButton := False;
  FUpdatingToolbarSearch := False;

  FToolbarSearchEdit := TEdit.Create(Self);
  FToolbarSearchEdit.Parent := Self;
  FToolbarSearchEdit.ControlStyle := FToolbarSearchEdit.ControlStyle + [csNoDesignVisible];
  FToolbarSearchEdit.BorderStyle := bsNone;
  FToolbarSearchEdit.AutoSize := False;
  FToolbarSearchEdit.Visible := False;
  FToolbarSearchEdit.OnChange := ToolbarSearchChanged;

  FToolbarClearButton := TDCFlexButton.Create(Self);
  FToolbarClearButton.Parent := Self;
  FToolbarClearButton.ControlStyle := FToolbarClearButton.ControlStyle + [csNoDesignVisible];
  FToolbarClearButton.Visible := False;
  FToolbarClearButton.OnClick := ToolbarClearClick;

  FToolbarRulesButton := TDCFlexButton.Create(Self);
  FToolbarRulesButton.Parent := Self;
  FToolbarRulesButton.ControlStyle := FToolbarRulesButton.ControlStyle + [csNoDesignVisible];
  FToolbarRulesButton.Visible := False;
  FToolbarRulesButton.OnClick := ToolbarRulesClick;

  UpdateToolbarLanguage;

  FShowFooter := False;
  FFooterHeight := DC_DEFAULT_FOOTER_HEIGHT;

  FShowColumnFilters := False;
  FAllowColumnFiltersMenu := False;
  FColumnFilterHeight := DC_DEFAULT_COLUMN_FILTER_HEIGHT;

  FColumnFilterPanel := TPanel.Create(Self);
  FColumnFilterPanel.Parent := Self;
  FColumnFilterPanel.ControlStyle := FColumnFilterPanel.ControlStyle + [csNoDesignVisible];
  FColumnFilterPanel.Visible := False;
  FColumnFilterPanel.BevelOuter := bvNone;
  FColumnFilterPanel.ParentColor := False;
  FColumnFilterPanel.Color := clWhite;
  FColumnFilterPanel.TabStop := False;

  FColumnFilterEdits := TObjectList<TEdit>.Create(True);
  FHeaderFooterPopup := TDCFlexPopupMenu.Create(Self);
  FHeaderFooterPopup.ThemeMode := FThemeMode;
  FHeaderFooterPopup.AttachedControl := Self;
  FUpdatingColumnFilters := False;
  FHeaderPopupShownFromMouse := False;
end;

procedure TDCMasterDetailGrid.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or WS_VSCROLL or WS_HSCROLL or WS_TABSTOP;
end;

destructor TDCMasterDetailGrid.Destroy;
begin
  if Assigned(FLanguageSource) then
    FLanguageSource.RemoveChangeListener(LanguageSourceChange);
  FHeaderFooterPopup.Free;
  FColumnFilterEdits.Free;
  FColumnFilterPanel.Free;
  FToolbarRulesButton.Free;
  FToolbarClearButton.Free;
  FToolbarSearchEdit.Free;
  FBusinessHighlight.Free;
  FDataSetAdapter.Free;
  FFilteredRows.Free;
  FRulesDesignerCustomLanguage.Free;
  FExpandedRows.Free;
  FDetailFont.Free;
  FTitleFont.Free;
  FTheme.Free;
  FDetailColumns.Free;
  FColumns.Free;
  inherited Destroy;
end;

procedure TDCMasterDetailGrid.CreateWnd;
begin
  inherited CreateWnd;
  DCFlexApplyNativeDarkMode(Self, FThemeMode = dtmDark);
  UpdateScrollBar;
end;

procedure TDCMasterDetailGrid.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (AComponent = FLanguageSource) then
    SetLanguageSource(nil);
end;

procedure TDCMasterDetailGrid.DrawBackground;
var
  R: TRect;
begin
  FillRectColor(Canvas, ClientRect, FTheme.GridBackgroundColor);

  if FShowHeader then
  begin
    R := Rect(ClientRect.Left, ClientRect.Top, ClientRect.Right, Min(ClientRect.Top + 8, ClientRect.Bottom));
    FillRectColor(Canvas, R, BlendColor(FTheme.HeaderColor, clWhite, 235));
  end;
end;

procedure TDCMasterDetailGrid.DrawBorder;
var
  I: Integer;
  R: TRect;
begin
  if FBorderWidth <= 0 then
    Exit;

  Canvas.Brush.Style := bsClear;
  R := ClientRect;
  for I := 1 to FBorderWidth do
  begin
    if I = 1 then
      Canvas.Pen.Color := BlendColor(FTheme.BorderColor, clWhite, 30)
    else
      Canvas.Pen.Color := BlendColor(FTheme.BorderColor, clBlack, 18);
    Canvas.Rectangle(R.Left + I - 1, R.Top + I - 1, R.Right - I + 1, R.Bottom - I + 1);
  end;
  Canvas.Brush.Style := bsSolid;
end;

procedure TDCMasterDetailGrid.DrawDetail(ARow: Integer; const ARect: TRect);
var
  LHandled: Boolean;
  LInnerRect: TRect;
  LShadowRect: TRect;
begin
  FillRectColor(Canvas, ARect, FTheme.DetailColor);

  Canvas.Pen.Color := FTheme.DetailBorderColor;
  Canvas.MoveTo(ARect.Left + 10, ARect.Top);
  Canvas.LineTo(ARect.Right - 10, ARect.Top);

  LInnerRect := Rect(ARect.Left + 8, ARect.Top + 6, ARect.Right - 8, ARect.Bottom - 8);
  LShadowRect := Rect(LInnerRect.Left + 2, LInnerRect.Top + 2, LInnerRect.Right + 2, LInnerRect.Bottom + 2);

  DrawRoundedPanel(Canvas, LShadowRect, BlendColor(FTheme.DetailBorderColor, clBlack, 8), BlendColor(FTheme.DetailBorderColor, clBlack, 8), 8);
  DrawRoundedPanel(Canvas, LInnerRect, FTheme.DetailGridRowColor, FTheme.DetailBorderColor, 8);

  DrawAccentBar(Canvas, Rect(LInnerRect.Left + 1, LInnerRect.Top + 1, LInnerRect.Left + 5, LInnerRect.Bottom - 1),
    FTheme.ExpandButtonColor, 4);

  InflateRect(LInnerRect, -1, -1);

  LHandled := False;
  if Assigned(FOnDrawDetail) then
    FOnDrawDetail(Self, Canvas, LInnerRect, ARow, LHandled);

  if LHandled then
    Exit;

  case FDetailStyle of
    dsGrid: DrawDetailGrid(ARow, LInnerRect);
  else
    DrawDetailText(ARow, LInnerRect);
  end;
end;


procedure TDCMasterDetailGrid.DrawDetailGrid(ARow: Integer; const ARect: TRect);
var
  DetailRows: Integer;
  GridRect, HeaderRect, CellRect, FullCellRect: TRect;
  Col, Row, X, Y: Integer;
  LClipSave: Integer;
  Column: TDCGridColumn;
  S: string;
  Flags: Cardinal;
  HeaderColor, LRowColor, LFontColor: TColor;
  LFontStyles: TFontStyles;
  LHandled: Boolean;
  LVerticalOffset: Integer;
  LFirstRow: Integer;
  LRowOffset: Integer;
  LContentRight: Integer;
  LContentBottom: Integer;
begin
  GridRect := Rect(ARect.Left + DC_DEFAULT_PADDING + DC_DEFAULT_EXPAND_COL_WIDTH - 8,
                   ARect.Top + 8,
                   ARect.Right - DC_DEFAULT_PADDING,
                   ARect.Bottom - 8);

  if (GridRect.Right <= GridRect.Left) or (GridRect.Bottom <= GridRect.Top) then
    Exit;

  DrawRoundedPanel(Canvas, GridRect, FTheme.DetailGridRowColor, FTheme.DetailGridLineColor, 6);

  LClipSave := SaveDC(Canvas.Handle);
  try
    IntersectClipRect(Canvas.Handle, GridRect.Left + 1, GridRect.Top + 1, GridRect.Right - 1, GridRect.Bottom - 1);

    HeaderRect := Rect(GridRect.Left, GridRect.Top, GridRect.Right,
      GridRect.Top + FDetailGridHeaderHeight);

  Canvas.Font.Assign(FTitleFont);
  Canvas.Font.Style := [fsBold];
  Canvas.Font.Color := FTheme.DetailGridHeaderFontColor;
  Canvas.Brush.Style := bsSolid;

  FDetailHorizontalOffset := EnsureRange(FDetailHorizontalOffset, 0, GetDetailHorizontalMax(GridRect));
  LContentRight := GridRect.Right - 1;
  if GetDetailHorizontalMax(GridRect) > 0 then
    Dec(LContentRight, 1);
  LContentBottom := GridRect.Bottom - 1;
  if GetDetailHorizontalMax(GridRect) > 0 then
    Dec(LContentBottom, 14);

  X := HeaderRect.Left - FDetailHorizontalOffset;
  for Col := 0 to FDetailColumns.Count - 1 do
  begin
    Column := FDetailColumns[Col];
    if not Column.Visible then
      Continue;

    FullCellRect := Rect(X, HeaderRect.Top, X + Column.Width, HeaderRect.Bottom);
    if FullCellRect.Right <= GridRect.Left then
    begin
      Inc(X, Column.Width);
      Continue;
    end;
    if FullCellRect.Left >= LContentRight then
      Break;

    LHandled := False;
    if Assigned(FOnCustomDrawHeader) then
      FOnCustomDrawHeader(Self, Canvas, FullCellRect, Col, (ARow = FDetailResizeMasterRow) and (Col = FDetailHeaderHoverColumn), False, LHandled);

    if not LHandled then
    begin
      if (ARow = FDetailResizeMasterRow) and (Col = FDetailHeaderHoverColumn) then
        HeaderColor := BlendColor(FTheme.DetailGridHeaderColor, FTheme.HoverRowColor, 90)
      else
        HeaderColor := FTheme.DetailGridHeaderColor;

      FillRectColor(Canvas, FullCellRect, HeaderColor);

      CellRect := FullCellRect;
      InflateRect(CellRect, -DC_DEFAULT_PADDING, 0);
      DrawText(Canvas.Handle, PChar(Column.Caption), Length(Column.Caption), CellRect,
        DT_VCENTER or DT_SINGLELINE or DT_LEFT or DT_NOPREFIX or DT_END_ELLIPSIS);

      Canvas.Pen.Color := FTheme.DetailGridLineColor;
      Canvas.MoveTo(FullCellRect.Right - 1, HeaderRect.Top);
      Canvas.LineTo(FullCellRect.Right - 1, LContentBottom);
    end;

    Inc(X, Column.Width);
  end;

  if X < LContentRight then
  begin
    FillRectColor(Canvas, Rect(Max(X, GridRect.Left + 1), HeaderRect.Top, LContentRight, HeaderRect.Bottom),
      FTheme.DetailGridHeaderColor);
    Canvas.Pen.Color := FTheme.DetailGridLineColor;
    Canvas.MoveTo(Max(X, GridRect.Left + 1), HeaderRect.Bottom - 1);
    Canvas.LineTo(LContentRight, HeaderRect.Bottom - 1);
  end;

  DetailRows := GetDetailGridRowCount(ARow);
  if FDetailScrollMasterRow = ARow then
    LVerticalOffset := EnsureRange(FDetailVerticalOffset, 0, GetDetailGridMaxVerticalOffset(ARow))
  else
    LVerticalOffset := 0;

  LFirstRow := 0;
  LRowOffset := 0;
  if FDetailGridRowHeight > 0 then
  begin
    LFirstRow := LVerticalOffset div FDetailGridRowHeight;
    LRowOffset := LVerticalOffset mod FDetailGridRowHeight;
  end;

  Y := HeaderRect.Bottom - LRowOffset;
  Canvas.Font.Assign(FDetailFont);

  for Row := LFirstRow to DetailRows - 1 do
  begin
    if Y >= LContentBottom then
      Break;

    if FDetailSelectEnabled and (ARow = FExpandedRow) and (Row = FSelectedDetailRow) then
      LRowColor := BlendColor(FTheme.SelectedRowColor, clWhite, 90)
    else if (ARow = FExpandedRow) and (Row = FHoverDetailRow) then
      LRowColor := BlendColor(FTheme.HoverRowColor, clWhite, 92)
    else if Odd(Row) then
      LRowColor := FTheme.DetailGridAlternateRowColor
    else
      LRowColor := FTheme.DetailGridRowColor;

    LFontColor := FTheme.TextColor;
    LFontStyles := [];
    if Assigned(FOnGetDetailRowStyle) then
      FOnGetDetailRowStyle(Self, ARow, Row, LRowColor, LFontColor, LFontStyles);

    FillRectColor(Canvas, Rect(GridRect.Left + 1, Y, LContentRight,
      Min(Y + FDetailGridRowHeight, LContentBottom)), LRowColor);

    if FDetailSelectEnabled and (ARow = FExpandedRow) and (Row = FSelectedDetailRow) then
    begin
      FillRectColor(Canvas, Rect(GridRect.Left + 1, Y, GridRect.Left + 5, Min(Y + FDetailGridRowHeight, LContentBottom)), BlendColor(FTheme.SelectedRowColor, clBlack, 10));
    end;

    Canvas.Font.Assign(FDetailFont);
    Canvas.Font.Color := LFontColor;
    Canvas.Font.Style := LFontStyles;

    X := GridRect.Left - FDetailHorizontalOffset;
    for Col := 0 to FDetailColumns.Count - 1 do
    begin
      Column := FDetailColumns[Col];
      if not Column.Visible then
        Continue;

      FullCellRect := Rect(X, Y, X + Column.Width, Min(Y + FDetailGridRowHeight, LContentBottom));
      if FullCellRect.Right <= GridRect.Left then
      begin
        Inc(X, Column.Width);
        Continue;
      end;
      if FullCellRect.Left >= LContentRight then
        Break;
      CellRect := FullCellRect;
      InflateRect(CellRect, -DC_DEFAULT_PADDING, 0);

      S := GetDetailGridCellText(ARow, Row, Col);

      LHandled := False;
      if Assigned(FOnCustomDrawDetailCell) then
        FOnCustomDrawDetailCell(Self, Canvas, FullCellRect, ARow, Row, Col,
          FDetailSelectEnabled and (ARow = FExpandedRow) and (Row = FSelectedDetailRow),
          (ARow = FExpandedRow) and (Row = FHoverDetailRow), S, LHandled);

      if not LHandled then
      begin
        case Column.Alignment of
          taLeft: Flags := DT_LEFT;
          taCenter: Flags := DT_CENTER;
        else
          Flags := DT_RIGHT;
        end;

        if (Trim(FSearchText) <> '') and ContainsTextEx(S, FSearchText) then
        begin
          Canvas.Brush.Style := bsSolid;
          Canvas.Brush.Color := BlendColor(FTheme.SearchHighlightColor, LRowColor, 120);
          Canvas.FillRect(CellRect);
          Canvas.Font.Color := FTheme.SearchHighlightTextColor;
          Canvas.Brush.Style := bsClear;
        end;
        DrawText(Canvas.Handle, PChar(S), Length(S), CellRect,
          DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX or DT_END_ELLIPSIS or Flags);
      end;

      Inc(X, Column.Width);
      Canvas.Pen.Color := FTheme.DetailGridLineColor;
      Canvas.MoveTo(X - 1, Y);
      Canvas.LineTo(X - 1, Min(Y + FDetailGridRowHeight, LContentBottom));
    end;

    Canvas.Pen.Color := FTheme.DetailGridLineColor;
    Canvas.MoveTo(GridRect.Left, Min(Y + FDetailGridRowHeight, LContentBottom));
    Canvas.LineTo(LContentRight, Min(Y + FDetailGridRowHeight, LContentBottom));

    Inc(Y, FDetailGridRowHeight);
  end;

  if Y < LContentBottom then
    FillRectColor(Canvas, Rect(GridRect.Left + 1, Max(Y, HeaderRect.Bottom),
      LContentRight, LContentBottom), FTheme.DetailGridRowColor);

    DrawDetailVerticalScrollBar(ARow);
    DrawDetailHorizontalScrollBar(ARow);

    Canvas.Brush.Style := bsSolid;
  finally
    RestoreDC(Canvas.Handle, LClipSave);
  end;
end;

procedure TDCMasterDetailGrid.DrawDetailText(ARow: Integer; const ARect: TRect);
var
  LText: string;
  LTextRect: TRect;
begin
  Canvas.Brush.Style := bsClear;
  Canvas.Font.Assign(FDetailFont);
  Canvas.Font.Color := FTheme.DetailTextColor;

  LText := GetDetailDisplayText(ARow);
  LTextRect := Rect(
    ARect.Left + DC_DEFAULT_PADDING + DC_DEFAULT_EXPAND_COL_WIDTH - 8,
    ARect.Top + 10,
    ARect.Right - DC_DEFAULT_PADDING,
    ARect.Bottom - 10
  );

  DrawText(Canvas.Handle, PChar(LText), Length(LText), LTextRect,
    DT_LEFT or DT_TOP or DT_WORDBREAK or DT_NOPREFIX);

  Canvas.Brush.Style := bsSolid;
end;

procedure TDCMasterDetailGrid.DrawHeader;
var
  I: Integer;
  X: Integer;
  R: TRect;
  LCol: TDCGridColumn;
  LTextRect: TRect;
  LColRect: TRect;
  Pts: array[0..2] of TPoint;
  LGlyph: string;
  LGlyphRect: TRect;
  LHandled: Boolean;
  LHeaderBase: TColor;
  LHeaderCaption: string;
  LHasFilter: Boolean;
  LFilterIndicatorRect: TRect;
  LClipState: Integer;
begin
  if not FShowHeader then
    Exit;

  R := GetHeaderRect;
  LHeaderBase := FTheme.HeaderColor;

  FillRectColor(Canvas, R, LHeaderBase);
  FillRectColor(Canvas, Rect(R.Left, R.Top, R.Right, Min(R.Top + 6, R.Bottom)), BlendColor(LHeaderBase, clWhite, 35));

  Canvas.Pen.Color := BlendColor(LHeaderBase, clWhite, 45);
  Canvas.MoveTo(R.Left + 1, R.Top);
  Canvas.LineTo(R.Right - 1, R.Top);

  Canvas.Font.Assign(FTitleFont);
  Canvas.Font.Style := [fsBold];
  Canvas.Font.Color := FTheme.HeaderFontColor;
  Canvas.Brush.Style := bsClear;
  SetBkMode(Canvas.Handle, TRANSPARENT);

  X := R.Left;
  if FShowExpandButton then
  begin
    if FShowHeaderColumnLines then
    begin
      Canvas.Pen.Color := BlendColor(FTheme.BorderColor, LHeaderBase, 120);
      Canvas.MoveTo(X + DC_DEFAULT_EXPAND_COL_WIDTH - 1, R.Top + 4);
      Canvas.LineTo(X + DC_DEFAULT_EXPAND_COL_WIDTH - 1, R.Bottom - 4);
    end;
    Inc(X, DC_DEFAULT_EXPAND_COL_WIDTH);
  end;

  LClipState := SaveDC(Canvas.Handle);
  try
    IntersectClipRect(Canvas.Handle, X, R.Top, R.Right, R.Bottom);
    Dec(X, FHorizontalOffset);

    for I := 0 to FColumns.Count - 1 do
    begin
    LCol := FColumns[I];
    if not LCol.Visible then
      Continue;

    LColRect := Rect(X, R.Top, X + LCol.Width, R.Bottom);

    LHandled := False;
    if Assigned(FOnCustomDrawHeader) then
      FOnCustomDrawHeader(Self, Canvas, LColRect, I, I = FHeaderHoverColumn, I = FSortedColumn, LHandled);

    if not LHandled then
    begin
      if I = FSortedColumn then
      begin
        FillRectColor(Canvas, Rect(LColRect.Left, LColRect.Bottom - 3, LColRect.Right, LColRect.Bottom),
          FTheme.ExpandButtonColor);
      end;

      LHasFilter := Trim(LCol.FilterText) <> '';
      if LHasFilter then
      begin
        LFilterIndicatorRect := Rect(LColRect.Left, LColRect.Bottom - 4, LColRect.Right, LColRect.Bottom - 1);
        FillRectColor(Canvas, LFilterIndicatorRect, BlendColor(FTheme.SelectedRowColor, clWhite, 25));
      end;

      LHeaderCaption := LCol.Caption;
      if LHasFilter then
        LHeaderCaption := LHeaderCaption + ' *';

      LTextRect := Rect(X + DC_DEFAULT_PADDING + 1, R.Top, X + LCol.Width - DC_DEFAULT_PADDING - 16, R.Bottom - 2);
      SetBkMode(Canvas.Handle, TRANSPARENT);
      DrawText(Canvas.Handle, PChar(LHeaderCaption), Length(LHeaderCaption), LTextRect,
        DT_VCENTER or DT_SINGLELINE or DT_LEFT or DT_NOPREFIX or DT_END_ELLIPSIS);

      if I = FSortedColumn then
      begin
        LGlyph := '';
        if FSortDirection = sdAscending then
          LGlyph := WideChar($25B2)
        else if FSortDirection = sdDescending then
          LGlyph := WideChar($25BC);

        if LGlyph <> '' then
        begin
          LGlyphRect := Rect(LColRect.Right - 22, LColRect.Top, LColRect.Right - 4, LColRect.Bottom);
          Canvas.Font.Name := 'Segoe UI Symbol';
          Canvas.Font.Style := [];
          Canvas.Font.Size := Max(9, FTitleFont.Size);
          Canvas.Font.Color := FTheme.HeaderFontColor;
          SetBkMode(Canvas.Handle, TRANSPARENT);
          DrawText(Canvas.Handle, PChar(LGlyph), Length(LGlyph), LGlyphRect,
            DT_CENTER or DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX);
          Canvas.Font.Assign(FTitleFont);
          Canvas.Font.Style := [fsBold];
          Canvas.Font.Color := FTheme.HeaderFontColor;
        end;
      end;

      if FShowHeaderColumnLines then
      begin
        Canvas.Pen.Color := BlendColor(FTheme.BorderColor, LHeaderBase, 120);
        Canvas.MoveTo(LColRect.Right - 1, R.Top + 4);
        Canvas.LineTo(LColRect.Right - 1, R.Bottom - 4);
      end;
    end;

    Inc(X, LCol.Width);
    end;
  finally
    RestoreDC(Canvas.Handle, LClipState);
  end;

  DrawFrozenHeaderOverlay(R, LHeaderBase);
  DrawFrozenColumnsSeparator(R, LHeaderBase);

  Canvas.Pen.Color := BlendColor(LHeaderBase, clBlack, 55);
  Canvas.MoveTo(R.Left, R.Bottom - 1);
  Canvas.LineTo(R.Right, R.Bottom - 1);

  Canvas.Pen.Color := BlendColor(FTheme.SelectedRowColor, LHeaderBase, 175);
  Canvas.MoveTo(R.Left, R.Bottom - 2);
  Canvas.LineTo(R.Right, R.Bottom - 2);
  Canvas.Brush.Style := bsSolid;
end;


procedure TDCMasterDetailGrid.DrawColumnFiltersBackground;
var
  I: Integer;
  X: Integer;
  R: TRect;
  LCol: TDCGridColumn;
  LColRect: TRect;
  LBackColor: TColor;
  LClipState: Integer;
begin
  if not FShowColumnFilters then
    Exit;

  R := GetColumnFiltersRect;
  if (R.Bottom <= R.Top) or (R.Right <= R.Left) then
    Exit;

  LBackColor := BlendColor(FTheme.GridBackgroundColor, clWhite, 18);
  FillRectColor(Canvas, R, LBackColor);

  Canvas.Pen.Color := BlendColor(FTheme.BorderColor, clWhite, 25);
  Canvas.MoveTo(R.Left, R.Top);
  Canvas.LineTo(R.Right, R.Top);
  Canvas.MoveTo(R.Left, R.Bottom - 1);
  Canvas.LineTo(R.Right, R.Bottom - 1);

  { Important:
    Column filter editors are native TEdit controls and already render their own
    TextHint. Do not draw filter hint text on the grid canvas here. When frozen
    columns and horizontal scrolling are active, canvas-drawn hints can appear
    behind the frozen area and create visual artifacts. This routine now only
    paints the filter row background and column separators. }

  X := R.Left;
  if FShowExpandButton then
  begin
    FillRectColor(Canvas, Rect(X, R.Top, X + DC_DEFAULT_EXPAND_COL_WIDTH, R.Bottom), LBackColor);
    Canvas.Pen.Color := BlendColor(FTheme.BorderColor, clWhite, 35);
    Canvas.MoveTo(X + DC_DEFAULT_EXPAND_COL_WIDTH - 1, R.Top + 4);
    Canvas.LineTo(X + DC_DEFAULT_EXPAND_COL_WIDTH - 1, R.Bottom - 4);
    Inc(X, DC_DEFAULT_EXPAND_COL_WIDTH);
  end;

  LClipState := SaveDC(Canvas.Handle);
  try
    IntersectClipRect(Canvas.Handle, X, R.Top, R.Right, R.Bottom);

    for I := 0 to FColumns.Count - 1 do
    begin
      LCol := FColumns[I];
      if not LCol.Visible then
        Continue;

      LColRect := Rect(GetColumnDrawLeft(I, R.Left), R.Top,
        GetColumnDrawLeft(I, R.Left) + LCol.Width, R.Bottom);

      if (LColRect.Right <= X) or (LColRect.Left >= R.Right) then
        Continue;

      Canvas.Pen.Color := BlendColor(FTheme.BorderColor, clWhite, 45);
      Canvas.MoveTo(LColRect.Right - 1, LColRect.Top + 5);
      Canvas.LineTo(LColRect.Right - 1, LColRect.Bottom - 5);
    end;
  finally
    RestoreDC(Canvas.Handle, LClipState);
  end;

  DrawFrozenColumnsSeparator(R, LBackColor);

  Canvas.Brush.Style := bsSolid;
end;

function TDCMasterDetailGrid.ApplyBusinessHighlight(ARow: Integer; var ABackColor, AFontColor: TColor; var AFontStyles: TFontStyles; out ATarget: TDCHighlightTarget; out AMatchedFieldName: string): Boolean;
var
  V: Variant;
  I: Integer;
  LRule: TDCHighlightRule;
  LFieldName: string;
begin
  Result := False;
  ATarget := htRow;
  AMatchedFieldName := '';
  if (not Assigned(FBusinessHighlight)) or (not FBusinessHighlight.Enabled) then
    Exit;
  if not (FDataAdapter is TDCDataSetAdapter) then
    Exit;

  for I := 0 to FBusinessHighlight.Rules.Count - 1 do
  begin
    LRule := FBusinessHighlight.Rules[I];
    LFieldName := Trim(LRule.FieldName);
    if LFieldName = '' then
      LFieldName := Trim(FBusinessHighlight.Field);
    if LFieldName = '' then
      Continue;

    V := TDCDataSetAdapter(FDataAdapter).GetFieldValueByName(ARow, LFieldName);
    if VarIsNull(V) then
      Continue;

    if LRule.Match(V) then
    begin
      ATarget := LRule.Target;
      AMatchedFieldName := LFieldName;
      ABackColor := LRule.BackColor;
      if LRule.FontColor <> clNone then
        AFontColor := LRule.FontColor;
      if LRule.FontStyles <> [] then
        AFontStyles := LRule.FontStyles;
      Exit(True);
    end;
  end;
end;

procedure TDCMasterDetailGrid.DrawRow(ARow: Integer; const ARect: TRect);
var
  I: Integer;
  X: Integer;
  LCol: TDCGridColumn;
  LCellRect, LPaintRect: TRect;
  LText: string;
  LFlags: Cardinal;
  LHandled: Boolean;
  LExpandRect: TRect;
  Pts: array[0..2] of TPoint;
  LGlyph: string;
  LGlyphRect: TRect;
  LRowColor, LFontColor: TColor;
  LFontStyles: TFontStyles;
  LStripeColor: TColor;
  LBusinessTarget: TDCHighlightTarget;
  LBusinessMatched: Boolean;
  LBusinessFieldName: string;
  LCellBackColor: TColor;
  LCellFontColor: TColor;
  LCellFontStyles: TFontStyles;
  LMatchedBackColor: TColor;
  LMatchedFontColor: TColor;
  LMatchedFontStyles: TFontStyles;
  LClipState: Integer;
begin
  if ARow = FHoverRow then
    LRowColor := FTheme.HoverRowColor
  else if FAlternateColors and Odd(ARow) then
    LRowColor := FTheme.AlternateRowColor
  else
    LRowColor := FTheme.RowColor;

  LFontColor := FTheme.TextColor;
  LFontStyles := [];
  LBusinessTarget := htRow;
  LBusinessMatched := ApplyBusinessHighlight(ARow, LRowColor, LFontColor, LFontStyles, LBusinessTarget, LBusinessFieldName);
  LMatchedBackColor := LRowColor;
  LMatchedFontColor := LFontColor;
  LMatchedFontStyles := LFontStyles;

  if LBusinessMatched and (LBusinessTarget = htCell) then
  begin
    if ARow = FHoverRow then
      LRowColor := FTheme.HoverRowColor
    else if FAlternateColors and Odd(ARow) then
      LRowColor := FTheme.AlternateRowColor
    else
      LRowColor := FTheme.RowColor;

    LFontColor := FTheme.TextColor;
    LFontStyles := [];
  end;

  if ARow = FSelectedRow then
    LFontStyles := LFontStyles + [fsBold];

  if Assigned(FOnGetMasterRowStyle) then
    FOnGetMasterRowStyle(Self, ARow, LRowColor, LFontColor, LFontStyles);

  FillRectColor(Canvas, ARect, LRowColor);

  if ARow = FSelectedRow then
    LStripeColor := BlendColor(FTheme.ExpandButtonColor, LRowColor, 110)
  else if ARow = FHoverRow then
    LStripeColor := BlendColor(FTheme.ExpandButtonColor, clWhite, 70)
  else
    LStripeColor := BlendColor(LRowColor, FTheme.BorderColor, 215);

  DrawAccentBar(Canvas, Rect(ARect.Left, ARect.Top, ARect.Left + 4, ARect.Bottom), LStripeColor, 4);
  FillRectColor(Canvas, Rect(ARect.Left + 4, ARect.Top, ARect.Right, ARect.Top + 1), BlendColor(LRowColor, clWhite, 30));

  Canvas.Pen.Color := BlendColor(FTheme.BorderColor, clWhite, 28);
  Canvas.MoveTo(ARect.Left, ARect.Bottom - 1);
  Canvas.LineTo(ARect.Right, ARect.Bottom - 1);

  X := ARect.Left;

  if FShowExpandButton then
  begin
    LExpandRect := GetExpandButtonRect(ARect);
    Canvas.Brush.Style := bsClear;
    Canvas.Pen.Color := FTheme.ExpandButtonColor;

    if ARow = FExpandedRow then
      LGlyph := WideChar($25BE)
    else
      LGlyph := WideChar($25B8);

    LGlyphRect := Rect(LExpandRect.Left, LExpandRect.Top - 1, LExpandRect.Right, LExpandRect.Bottom + 1);
    Canvas.Font.Assign(Font);
    Canvas.Font.Name := 'Segoe UI Symbol';
    Canvas.Font.Style := [];
    Canvas.Font.Size := Max(10, Font.Size + 3);
    Canvas.Font.Color := FTheme.ExpandButtonColor;
    SetBkMode(Canvas.Handle, TRANSPARENT);
    DrawText(Canvas.Handle, PChar(LGlyph), Length(LGlyph), LGlyphRect,
      DT_CENTER or DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX);
    Canvas.Brush.Style := bsSolid;

    if FShowRowColumnLines then
    begin
      Canvas.Pen.Color := BlendColor(FTheme.BorderColor, LRowColor, 45);
      Canvas.MoveTo(ARect.Left + DC_DEFAULT_EXPAND_COL_WIDTH - 1, ARect.Top + 2);
      Canvas.LineTo(ARect.Left + DC_DEFAULT_EXPAND_COL_WIDTH - 1, ARect.Bottom - 2);
    end;

    Inc(X, DC_DEFAULT_EXPAND_COL_WIDTH);
  end;

  LClipState := SaveDC(Canvas.Handle);
  try
    IntersectClipRect(Canvas.Handle, X, ARect.Top, ARect.Right, ARect.Bottom);
    Dec(X, FHorizontalOffset);

    Canvas.Font.Assign(Font);
  Canvas.Font.Style := LFontStyles;
  Canvas.Font.Color := LFontColor;
  Canvas.Brush.Style := bsClear;

  for I := 0 to FColumns.Count - 1 do
  begin
    LCol := FColumns[I];
    if not LCol.Visible then
      Continue;

    LPaintRect := Rect(X, ARect.Top, X + LCol.Width, ARect.Bottom);
    LCellRect := LPaintRect;
    LText := GetDisplayText(ARow, I);

    LHandled := False;
    if Assigned(FOnCustomDrawMasterCell) then
      FOnCustomDrawMasterCell(Self, Canvas, LPaintRect, ARow, I, ARow = FSelectedRow, ARow = FHoverRow, LText, LHandled);

    if not LHandled then
    begin
      if Assigned(FOnDrawCell) then
        FOnDrawCell(Self, Canvas, LPaintRect, ARow, I, ARow = FSelectedRow, ARow = FHoverRow, LHandled);

      if not LHandled then
      begin
        case LCol.Alignment of
          taLeft: LFlags := DT_LEFT;
          taCenter: LFlags := DT_CENTER;
        else
          LFlags := DT_RIGHT;
        end;

        InflateRect(LCellRect, -DC_DEFAULT_PADDING, 0);
        LCellBackColor := LRowColor;
        LCellFontColor := LFontColor;
        LCellFontStyles := LFontStyles;

        if LBusinessMatched and (LBusinessTarget = htCell) and SameText(Trim(LCol.FieldName), LBusinessFieldName) then
        begin
          LCellBackColor := LMatchedBackColor;
          if LMatchedFontColor <> clNone then
            LCellFontColor := LMatchedFontColor;
          if LMatchedFontStyles <> [] then
            LCellFontStyles := LCellFontStyles + LMatchedFontStyles;
          Canvas.Brush.Style := bsSolid;
          Canvas.Brush.Color := LCellBackColor;
          Canvas.FillRect(LPaintRect);
          Canvas.Brush.Style := bsClear;
        end;

        Canvas.Font.Style := LCellFontStyles;
        Canvas.Font.Color := LCellFontColor;
        if (Trim(FSearchText) <> '') and ContainsTextEx(LText, FSearchText) then
        begin
          Canvas.Brush.Style := bsSolid;
          Canvas.Brush.Color := BlendColor(FTheme.SearchHighlightColor, LRowColor, 120);
          Canvas.FillRect(LCellRect);
          Canvas.Font.Color := FTheme.SearchHighlightTextColor;
          Canvas.Brush.Style := bsClear;
        end;
        SetBkMode(Canvas.Handle, TRANSPARENT);
        DrawText(Canvas.Handle, PChar(LText), Length(LText), LCellRect,
          DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX or DT_END_ELLIPSIS or LFlags);
      end;
    end;

    if FShowRowColumnLines then
    begin
      Canvas.Pen.Color := BlendColor(FTheme.BorderColor, LCellBackColor, 45);
      Canvas.MoveTo(LPaintRect.Right - 1, ARect.Top + 2);
      Canvas.LineTo(LPaintRect.Right - 1, ARect.Bottom - 2);
    end;

    Inc(X, LCol.Width);
    end;
  finally
    RestoreDC(Canvas.Handle, LClipState);
  end;

  DrawFrozenRowOverlay(ARow, ARect);
  DrawFrozenColumnsSeparator(ARect, LRowColor);

  Canvas.Brush.Style := bsSolid;
end;

procedure TDCMasterDetailGrid.DrawRows;
var
  I, ARow: Integer;
  LRowRect: TRect;
  LRowsRect: TRect;
  LSaveDC: Integer;
begin
  if GetActualRowCount <= 0 then
    Exit;

  LRowsRect := GetRowsRect;
  if (LRowsRect.Bottom <= LRowsRect.Top) or (LRowsRect.Right <= LRowsRect.Left) then
    Exit;

  {
    Keep row/detail painting restricted to the rows viewport.
    This is important when ShowFooter=True because expanded details can be
    taller than the available viewport and would otherwise paint over the
    footer area.
  }
  LSaveDC := SaveDC(Canvas.Handle);
  try
    IntersectClipRect(Canvas.Handle, LRowsRect.Left, LRowsRect.Top, LRowsRect.Right, LRowsRect.Bottom);

    for I := FTopRow to GetActualRowCount - 1 do
    begin
      ARow := GetActualRowIndex(I);
      if ARow < 0 then
        Continue;

      LRowRect := GetRowRect(I);
      if LRowRect.Top >= LRowsRect.Bottom then
        Break;

      if IsRowVisible(I) then
      begin
        DrawRow(ARow, LRowRect);
        if RowHasDetailVisible(ARow) then
          DrawDetail(ARow, GetDetailRect(ARow));
      end;
    end;
  finally
    RestoreDC(Canvas.Handle, LSaveDC);
  end;
end;

procedure TDCMasterDetailGrid.EnsureRowVisible(ARow: Integer);
var
  LVisibleRows: Integer;
  LVisibleRow: Integer;
begin
  if (ARow < 0) or (ARow >= FRowCount) then
    Exit;

  LVisibleRow := GetVisibleIndexOfActualRow(ARow);
  if LVisibleRow < 0 then
    Exit;

  LVisibleRows := GetVisibleMasterRows;

  if LVisibleRow < FTopRow then
    FTopRow := LVisibleRow
  else if (LVisibleRows > 0) and (LVisibleRow > FTopRow + LVisibleRows - 1) then
    FTopRow := Max(0, LVisibleRow - LVisibleRows + 1);

  FTopRow := EnsureRange(FTopRow, 0, MaxTopRow);
  UpdateScrollBar;
end;

procedure TDCMasterDetailGrid.ExpandRow(ARow: Integer);
var
  LAllow: Boolean;
begin
  if (ARow < 0) or (ARow >= FRowCount) then
    Exit;
  if not RowHasDetailContent(ARow) then
    Exit;
  if IsRowExpanded(ARow) then
  begin
    FExpandedRow := ARow;
    Exit;
  end;

  LAllow := True;
  if Assigned(FOnBeforeExpand) then
    FOnBeforeExpand(Self, ARow, LAllow);

  if not LAllow then
    Exit;

  if FExpandMode = emSingle then
    FExpandedRows.Clear;

  FExpandedRows.Add(ARow);
  FExpandedRow := ARow;
  FDetailScrollMasterRow := ARow;
  FDetailVerticalOffset := 0;
  FSelectedDetailRow := -1;
  FHoverDetailRow := -1;
  EnsureRowVisible(ARow);
  UpdateScrollBar;
  Invalidate;

  if Assigned(FOnAfterExpand) then
    FOnAfterExpand(Self, ARow);
end;

function TDCMasterDetailGrid.GetAccumulatedDetailHeightBeforeRow(ARow: Integer): Integer;
var
  I: Integer;
  LVisibleRow: Integer;
begin
  Result := 0;
  if FExpandedRows.Count = 0 then
    Exit;

  for I := 0 to FExpandedRows.Count - 1 do
  begin
    LVisibleRow := GetVisibleIndexOfActualRow(FExpandedRows[I]);
    if (LVisibleRow >= FTopRow) and (LVisibleRow < ARow) then
      Inc(Result, GetCurrentDetailHeight(FExpandedRows[I]));
  end;
end;

function TDCMasterDetailGrid.GetContentTop: Integer;
begin
  Result := 0;
  if FShowToolbar then
    Inc(Result, FToolbarHeight);
  if FShowHeader then
    Inc(Result, FHeaderHeight);
  if FShowColumnFilters then
    Inc(Result, FColumnFilterHeight);
end;

function TDCMasterDetailGrid.GetCurrentDetailHeight(AMasterRow: Integer): Integer;
var
  LGridHeight: Integer;
  LGridWidth: Integer;
begin
  if FDetailStyle = dsGrid then
  begin
    LGridHeight := GetDetailGridContentHeight(AMasterRow);

    if FDetailVerticalScroll and (FDetailMaxHeight > 0) then
      LGridHeight := Min(LGridHeight, FDetailMaxHeight);

    { Reserve the horizontal detail scrollbar in the detail height itself.
      DrawDetailGrid keeps the scrollbar inside the grid rect; without this
      extra height, the scrollbar visually competes with the last detail row. }
    LGridWidth := Max(1, ClientWidth - 56);
    if GetVisibleDetailColumnsWidth > LGridWidth then
      Inc(LGridHeight, 14);

    { Total padding consumed until the detail grid usable area:
      - outer detail card: Top +6 / Bottom +8
      - inner grid area:   Top +8 / Bottom +8
      Total: 30 px }
    Result := 32 + LGridHeight;

    if Result < 66 then
      Result := 66;
  end
  else
    Result := FDetailHeight;
end;

function TDCMasterDetailGrid.GetDetailGridContentHeight(AMasterRow: Integer): Integer;
var
  LRows: Integer;
begin
  LRows := GetDetailGridRowCount(AMasterRow);
  if LRows <= 0 then
    LRows := 1;
  Result := FDetailGridHeaderHeight + (LRows * FDetailGridRowHeight);
end;

function TDCMasterDetailGrid.GetDetailGridViewportHeight(AMasterRow: Integer): Integer;
begin
  Result := GetDetailGridContentHeight(AMasterRow);
  if FDetailVerticalScroll and (FDetailMaxHeight > 0) then
    Result := Min(Result, FDetailMaxHeight);
end;

function TDCMasterDetailGrid.GetDetailGridMaxVerticalOffset(AMasterRow: Integer): Integer;
begin
  Result := Max(0, GetDetailGridContentHeight(AMasterRow) - GetDetailGridViewportHeight(AMasterRow));
end;

procedure TDCMasterDetailGrid.SetDetailVerticalOffset(AMasterRow, AOffset: Integer);
var
  LNewOffset: Integer;
  LInvalidateRect: TRect;
begin
  if AMasterRow < 0 then
    Exit;

  LNewOffset := EnsureRange(AOffset, 0, GetDetailGridMaxVerticalOffset(AMasterRow));
  if (FDetailScrollMasterRow <> AMasterRow) or (FDetailVerticalOffset <> LNewOffset) then
  begin
    FDetailScrollMasterRow := AMasterRow;
    FDetailVerticalOffset := LNewOffset;
    if HandleAllocated then
    begin
      LInvalidateRect := GetDetailRect(AMasterRow);
      InvalidateRect(Handle, @LInvalidateRect, False);
    end
    else
      Invalidate;
  end;
end;

function TDCMasterDetailGrid.GetDetailHorizontalMax(const AGridRect: TRect): Integer;
var
  LViewportWidth: Integer;
begin
  LViewportWidth := Max(1, AGridRect.Right - AGridRect.Left - 2);
  Result := Max(0, GetVisibleDetailColumnsWidth - LViewportWidth);
end;

procedure TDCMasterDetailGrid.SetDetailHorizontalOffset(AOffset: Integer);
var
  LNewOffset: Integer;
  LMaxOffset: Integer;
  LInvalidateRect: TRect;
begin
  if FExpandedRow >= 0 then
    LMaxOffset := GetDetailHorizontalMax(GetDetailGridRect(FExpandedRow))
  else
    LMaxOffset := 0;

  LNewOffset := EnsureRange(AOffset, 0, LMaxOffset);
  if FDetailHorizontalOffset <> LNewOffset then
  begin
    FDetailHorizontalOffset := LNewOffset;
    if HandleAllocated then
    begin
      LInvalidateRect := GetRowsRect;
      InvalidateRect(Handle, @LInvalidateRect, False);
    end
    else
      Invalidate;
  end;
end;

procedure TDCMasterDetailGrid.DrawDetailVerticalScrollBar(AMasterRow: Integer);
var
  LTrackRect: TRect;
  LThumbRect: TRect;
begin
  if not GetDetailVerticalScrollRects(AMasterRow, LTrackRect, LThumbRect) then
    Exit;

  FillRectColor(Canvas, LTrackRect, BlendColor(FTheme.DetailGridRowColor, FTheme.DetailGridLineColor, 120));
  FillRectColor(Canvas, LThumbRect, BlendColor(FTheme.DetailGridLineColor, FTheme.TextColor, 85));
end;

function TDCMasterDetailGrid.GetDetailVerticalScrollRects(AMasterRow: Integer; out ATrackRect,
  AThumbRect: TRect): Boolean;
var
  LContentHeight: Integer;
  LViewportHeight: Integer;
  LMaxOffset: Integer;
  LGridRect: TRect;
  LThumbHeight: Integer;
  LThumbTop: Integer;
  LOffset: Integer;
  LTrackBottom: Integer;
begin
  Result := False;
  ATrackRect := Rect(0, 0, 0, 0);
  AThumbRect := Rect(0, 0, 0, 0);

  if not FDetailVerticalScroll then
    Exit;

  if (AMasterRow < 0) or (FDetailStyle <> dsGrid) or (not RowHasDetailVisible(AMasterRow)) then
    Exit;

  LGridRect := GetDetailGridRect(AMasterRow);
  if (LGridRect.Right <= LGridRect.Left) or (LGridRect.Bottom <= LGridRect.Top) then
    Exit;

  LContentHeight := GetDetailGridContentHeight(AMasterRow);
  LViewportHeight := LGridRect.Bottom - LGridRect.Top;
  if GetDetailHorizontalMax(LGridRect) > 0 then
    Dec(LViewportHeight, 14);
  LViewportHeight := Max(1, LViewportHeight);
  LMaxOffset := Max(0, LContentHeight - LViewportHeight);
  if LMaxOffset <= 0 then
    Exit;

  if FDetailScrollMasterRow = AMasterRow then
    LOffset := FDetailVerticalOffset
  else
    LOffset := 0;

  LTrackBottom := LGridRect.Bottom - 3;
  if GetDetailHorizontalMax(LGridRect) > 0 then
    Dec(LTrackBottom, 14);

  ATrackRect := Rect(LGridRect.Right - 8, LGridRect.Top + FDetailGridHeaderHeight + 2,
    LGridRect.Right - 3, LTrackBottom);
  if (ATrackRect.Bottom <= ATrackRect.Top) then
    Exit;

  LThumbHeight := Max(18, MulDiv(ATrackRect.Bottom - ATrackRect.Top, LViewportHeight, LContentHeight));
  LThumbHeight := Min(LThumbHeight, ATrackRect.Bottom - ATrackRect.Top);
  LThumbTop := ATrackRect.Top;
  if LMaxOffset > 0 then
    Inc(LThumbTop, MulDiv((ATrackRect.Bottom - ATrackRect.Top) - LThumbHeight, LOffset, LMaxOffset));

  AThumbRect := Rect(ATrackRect.Left, LThumbTop, ATrackRect.Right, LThumbTop + LThumbHeight);
  Result := True;
end;

function TDCMasterDetailGrid.GetDetailVerticalScrollAtPos(X, Y: Integer; out AMasterRow: Integer;
  out ATrackRect, AThumbRect: TRect): Boolean;
var
  I: Integer;
  LMasterRow: Integer;
begin
  Result := False;
  AMasterRow := -1;
  ATrackRect := Rect(0, 0, 0, 0);
  AThumbRect := Rect(0, 0, 0, 0);

  if (FExpandedRows.Count = 0) or (FDetailStyle <> dsGrid) then
    Exit;

  for I := 0 to FExpandedRows.Count - 1 do
  begin
    LMasterRow := FExpandedRows[I];
    if GetDetailVerticalScrollRects(LMasterRow, ATrackRect, AThumbRect) and
       PtInRect(ATrackRect, Point(X, Y)) then
    begin
      AMasterRow := LMasterRow;
      Exit(True);
    end;
  end;
end;

procedure TDCMasterDetailGrid.DrawDetailHorizontalScrollBar(AMasterRow: Integer);
var
  LTrackRect: TRect;
  LThumbRect: TRect;
  LBackRect: TRect;
begin
  if not GetDetailHorizontalScrollRects(AMasterRow, LTrackRect, LThumbRect) then
    Exit;

  LBackRect := Rect(LTrackRect.Left - 6, LTrackRect.Top - 4, LTrackRect.Right + 6, LTrackRect.Bottom + 4);
  FillRectColor(Canvas, LBackRect, FTheme.DetailGridRowColor);
  FillRectColor(Canvas, LTrackRect, BlendColor(FTheme.DetailGridRowColor, FTheme.DetailGridLineColor, 120));
  FillRectColor(Canvas, LThumbRect, BlendColor(FTheme.DetailGridLineColor, FTheme.TextColor, 85));
end;

function TDCMasterDetailGrid.GetDetailHorizontalScrollRects(AMasterRow: Integer; out ATrackRect,
  AThumbRect: TRect): Boolean;
var
  LGridRect: TRect;
  LContentWidth: Integer;
  LViewportWidth: Integer;
  LMaxOffset: Integer;
  LThumbWidth: Integer;
  LThumbLeft: Integer;
begin
  Result := False;
  ATrackRect := Rect(0, 0, 0, 0);
  AThumbRect := Rect(0, 0, 0, 0);

  if (AMasterRow < 0) or (FDetailStyle <> dsGrid) or (not RowHasDetailVisible(AMasterRow)) then
    Exit;

  LGridRect := GetDetailGridRect(AMasterRow);
  if (LGridRect.Right <= LGridRect.Left) or (LGridRect.Bottom <= LGridRect.Top) then
    Exit;

  LContentWidth := GetVisibleDetailColumnsWidth;
  LViewportWidth := Max(1, LGridRect.Right - LGridRect.Left - 2);
  LMaxOffset := Max(0, LContentWidth - LViewportWidth);
  if LMaxOffset <= 0 then
    Exit;

  ATrackRect := Rect(LGridRect.Left + 8, LGridRect.Bottom - 10, LGridRect.Right - 12, LGridRect.Bottom - 5);
  if ATrackRect.Right <= ATrackRect.Left then
    Exit;

  LThumbWidth := Max(24, MulDiv(ATrackRect.Right - ATrackRect.Left, LViewportWidth, LContentWidth));
  LThumbWidth := Min(LThumbWidth, ATrackRect.Right - ATrackRect.Left);
  LThumbLeft := ATrackRect.Left;
  Inc(LThumbLeft, MulDiv((ATrackRect.Right - ATrackRect.Left) - LThumbWidth, FDetailHorizontalOffset, LMaxOffset));

  AThumbRect := Rect(LThumbLeft, ATrackRect.Top, LThumbLeft + LThumbWidth, ATrackRect.Bottom);
  Result := True;
end;

function TDCMasterDetailGrid.GetDetailHorizontalScrollAtPos(X, Y: Integer; out AMasterRow: Integer;
  out ATrackRect, AThumbRect: TRect): Boolean;
var
  I: Integer;
  LMasterRow: Integer;
begin
  Result := False;
  AMasterRow := -1;
  ATrackRect := Rect(0, 0, 0, 0);
  AThumbRect := Rect(0, 0, 0, 0);

  if (FExpandedRows.Count = 0) or (FDetailStyle <> dsGrid) then
    Exit;

  for I := 0 to FExpandedRows.Count - 1 do
  begin
    LMasterRow := FExpandedRows[I];
    if GetDetailHorizontalScrollRects(LMasterRow, ATrackRect, AThumbRect) and
       PtInRect(ATrackRect, Point(X, Y)) then
    begin
      AMasterRow := LMasterRow;
      Exit(True);
    end;
  end;
end;

function TDCMasterDetailGrid.GetDetailDisplayText(ARow: Integer): string;
begin
  Result := '';
  if Assigned(FDataAdapter) then
    Result := FDataAdapter.GetMasterCellText(ARow, -1);

  if Assigned(FOnGetDetailText) then
    FOnGetDetailText(Self, ARow, Result);
end;

function TDCMasterDetailGrid.GetDetailGridCellText(AMasterRow, ADetailRow,
  ADetailCol: Integer): string;
var
  LEventValue: string;
begin
  Result := '';
  if Assigned(FDataAdapter) then
    Result := FDataAdapter.GetDetailCellText(AMasterRow, ADetailRow, ADetailCol);

  if Assigned(FOnGetDetailCellText) then
  begin
    LEventValue := Result;
    FOnGetDetailCellText(Self, AMasterRow, ADetailRow, ADetailCol, LEventValue);
    if (LEventValue <> '') or (Result = '') then
      Result := LEventValue;
  end;

  if (ADetailCol >= 0) and (ADetailCol < FDetailColumns.Count) then
    Result := DCFormatColumnDisplayText(Result, FDetailColumns[ADetailCol].DisplayFormat);

  LogDebug(Format('GetDetailGridCellText master=%d row=%d col=%d value="%s"', [AMasterRow, ADetailRow, ADetailCol, Result]));
end;

function TDCMasterDetailGrid.GetDetailGridRowCount(AMasterRow: Integer): Integer;
var
  LEventValue: Integer;
begin
  Result := 0;
  if Assigned(FDataAdapter) then
    Result := FDataAdapter.GetDetailRowCount(AMasterRow);

  if Assigned(FOnGetDetailRowCount) then
  begin
    LEventValue := Result;
    FOnGetDetailRowCount(Self, AMasterRow, LEventValue);
    if (LEventValue > 0) or (Result = 0) then
      Result := LEventValue;
  end;

  if Result < 0 then
    Result := 0;

  LogDebug(Format('GetDetailGridRowCount master=%d count=%d', [AMasterRow, Result]));
end;


function TDCMasterDetailGrid.GetDetailGridRect(ARow: Integer): TRect;
var
  InnerRect: TRect;
begin
  InnerRect := GetDetailRect(ARow);
  InnerRect := Rect(InnerRect.Left + 8, InnerRect.Top + 6, InnerRect.Right - 8, InnerRect.Bottom - 8);
  Result := Rect(InnerRect.Left + DC_DEFAULT_PADDING + DC_DEFAULT_EXPAND_COL_WIDTH - 8,
                 InnerRect.Top + 8,
                 InnerRect.Right - DC_DEFAULT_PADDING,
                 InnerRect.Bottom - 8);
end;

function TDCMasterDetailGrid.GetDetailRowAtPos(X, Y: Integer; out AMasterRow,
  ADetailRow: Integer): Boolean;
var
  GridRect, HeaderRect: TRect;
  DetailRows: Integer;
  RowTop, I, J, LMasterRow: Integer;
  LContentBottom: Integer;
begin
  Result := False;
  AMasterRow := -1;
  ADetailRow := -1;

  if (FExpandedRows.Count = 0) or (FDetailStyle <> dsGrid) then
    Exit;

  for J := 0 to FExpandedRows.Count - 1 do
  begin
    LMasterRow := FExpandedRows[J];
    if not RowHasDetailVisible(LMasterRow) then
      Continue;

    GridRect := GetDetailGridRect(LMasterRow);
    if not PtInRect(GridRect, Point(X, Y)) then
      Continue;

    LContentBottom := GridRect.Bottom;
    if GetDetailHorizontalMax(GridRect) > 0 then
      Dec(LContentBottom, 14);

    HeaderRect := Rect(GridRect.Left, GridRect.Top, GridRect.Right,
      GridRect.Top + FDetailGridHeaderHeight);
    if PtInRect(HeaderRect, Point(X, Y)) then
      Exit;

    DetailRows := GetDetailGridRowCount(LMasterRow);
    if (Y >= HeaderRect.Bottom) and (Y < LContentBottom) and (FDetailGridRowHeight > 0) then
    begin
      I := (Y - HeaderRect.Bottom) div FDetailGridRowHeight;
      if FDetailScrollMasterRow = LMasterRow then
        Inc(I, FDetailVerticalOffset div FDetailGridRowHeight);

      if (I >= 0) and (I < DetailRows) then
      begin
        AMasterRow := LMasterRow;
        ADetailRow := I;
        Exit(True);
      end;
    end;
  end;
end;

function TDCMasterDetailGrid.GetDetailRect(ARow: Integer): TRect;
var
  LRowRect: TRect;
  LDetailHeight: Integer;
  LVisibleRow: Integer;
begin
  LVisibleRow := GetVisibleIndexOfActualRow(ARow);
  if LVisibleRow < 0 then
    LVisibleRow := ARow;
  LRowRect := GetRowRect(LVisibleRow);
  LDetailHeight := GetCurrentDetailHeight(ARow);
  Result := Rect(LRowRect.Left, LRowRect.Bottom, LRowRect.Right, LRowRect.Bottom + LDetailHeight);
end;

function TDCMasterDetailGrid.GetDisplayText(ARow, ACol: Integer): string;
var
  LEventValue: string;
begin
  Result := '';
  if Assigned(FDataAdapter) then
    Result := FDataAdapter.GetMasterCellText(ARow, ACol);

  if Assigned(FOnGetCellText) then
  begin
    LEventValue := Result;
    FOnGetCellText(Self, ARow, ACol, LEventValue);
    if (LEventValue <> '') or (Result = '') then
      Result := LEventValue;
  end;

  if (ACol >= 0) and (ACol < FColumns.Count) then
    Result := DCFormatColumnDisplayText(Result, FColumns[ACol].DisplayFormat);

  LogDebug(Format('GetDisplayText row=%d col=%d value="%s"', [ARow, ACol, Result]));
end;

function TDCMasterDetailGrid.GetExpandButtonRect(const ARowRect: TRect): TRect;
begin
  Result := Rect(
    ARowRect.Left + 4,
    ARowRect.Top + 4,
    ARowRect.Left + DC_DEFAULT_EXPAND_COL_WIDTH - 4,
    ARowRect.Bottom - 4
  );
end;

function TDCMasterDetailGrid.GetHeaderRect: TRect;
var
  LTop: Integer;
begin
  LTop := 0;
  if FShowToolbar then
    Inc(LTop, FToolbarHeight);

  if FShowHeader then
    Result := Rect(0, LTop, ClientWidth, LTop + FHeaderHeight)
  else
    Result := Rect(0, LTop, 0, LTop);
end;


function TDCMasterDetailGrid.GetColumnFiltersRect: TRect;
var
  LHeaderRect: TRect;
begin
  if not FShowColumnFilters then
    Exit(Rect(0, 0, 0, 0));

  LHeaderRect := GetHeaderRect;
  if FShowHeader then
    Result := Rect(0, LHeaderRect.Bottom, ClientWidth, LHeaderRect.Bottom + FColumnFilterHeight)
  else
  begin
    Result := GetToolbarRect;
    Result := Rect(0, Result.Bottom, ClientWidth, Result.Bottom + FColumnFilterHeight);
  end;
end;

function TDCMasterDetailGrid.GetHeaderColumnAt(X, Y: Integer): Integer;
var
  I: Integer;
  CurrentX: Integer;
  LCol: TDCGridColumn;
  P: TPoint;
begin
  Result := -1;
  if not FShowHeader then
    Exit;

  P := Point(X, Y);
  if not PtInRect(GetHeaderRect, P) then
    Exit;

  for I := 0 to FColumns.Count - 1 do
  begin
    LCol := FColumns[I];
    if not LCol.Visible then
      Continue;

    CurrentX := GetColumnDrawLeft(I, 0);
    if (X >= CurrentX) and (X < CurrentX + LCol.Width) then
      Exit(I);
  end;
end;

function TDCMasterDetailGrid.GetHeaderSortColumnAt(X, Y: Integer): Integer;
var
  LCol: Integer;
  LColRect: TRect;
  LColLeft: Integer;
begin
  Result := -1;
  LCol := GetHeaderColumnAt(X, Y);
  if (LCol < 0) or (LCol >= FColumns.Count) or (not FColumns[LCol].Visible) then
    Exit;

  LColLeft := GetColumnDrawLeft(LCol, 0);
  LColRect := Rect(LColLeft, GetHeaderRect.Top, LColLeft + FColumns[LCol].Width,
    GetHeaderRect.Bottom);

  if X >= LColRect.Right - 28 then
    Result := LCol;
end;

function TDCMasterDetailGrid.GetHeaderResizeColumn(X, Y: Integer): Integer;
var
  I: Integer;
  CurrentX: Integer;
  LCol: TDCGridColumn;
  HitTolerance: Integer;
  P: TPoint;
begin
  Result := -1;
  if (not FShowHeader) or (not FAllowColumnResize) then
    Exit;

  P := Point(X, Y);
  if not PtInRect(GetHeaderRect, P) then
    Exit;

  HitTolerance := 4;
  for I := 0 to FColumns.Count - 1 do
  begin
    LCol := FColumns[I];
    if not LCol.Visible then
      Continue;

    CurrentX := GetColumnDrawLeft(I, 0) + LCol.Width;
    if Abs(X - CurrentX) <= HitTolerance then
      Exit(I);
  end;
end;


function TDCMasterDetailGrid.GetDetailHeaderResizeColumn(X, Y: Integer; out AMasterRow: Integer): Integer;
var
  I, J: Integer;
  CurrentX: Integer;
  LCol: TDCGridColumn;
  GridRect, HeaderRect: TRect;
  LMasterRow: Integer;
  HitTolerance: Integer;
begin
  Result := -1;
  AMasterRow := -1;
  if (not FAllowDetailColumnResize) or (FDetailStyle <> dsGrid) or (FExpandedRows.Count = 0) then
    Exit;

  HitTolerance := 4;
  for J := 0 to FExpandedRows.Count - 1 do
  begin
    LMasterRow := FExpandedRows[J];
    if not RowHasDetailVisible(LMasterRow) then
      Continue;

    GridRect := GetDetailGridRect(LMasterRow);
    HeaderRect := Rect(GridRect.Left, GridRect.Top, GridRect.Right, GridRect.Top + FDetailGridHeaderHeight);
    if not PtInRect(HeaderRect, Point(X, Y)) then
      Continue;

    CurrentX := GridRect.Left - FDetailHorizontalOffset;
    for I := 0 to FDetailColumns.Count - 1 do
    begin
      LCol := FDetailColumns[I];
      if not LCol.Visible then
        Continue;
      Inc(CurrentX, LCol.Width);
      if Abs(X - CurrentX) <= HitTolerance then
      begin
        Result := I;
        AMasterRow := LMasterRow;
        Exit;
      end;
    end;
  end;
end;

function TDCMasterDetailGrid.GetDetailHeaderColumnAt(X, Y: Integer; out AMasterRow: Integer): Integer;
var
  I, J: Integer;
  CurrentX: Integer;
  LCol: TDCGridColumn;
  GridRect, HeaderRect: TRect;
  LMasterRow: Integer;
begin
  Result := -1;
  AMasterRow := -1;
  if FDetailStyle <> dsGrid then
    Exit;

  for J := 0 to FExpandedRows.Count - 1 do
  begin
    LMasterRow := FExpandedRows[J];
    if not RowHasDetailVisible(LMasterRow) then
      Continue;

    GridRect := GetDetailGridRect(LMasterRow);
    HeaderRect := Rect(GridRect.Left, GridRect.Top, GridRect.Right, GridRect.Top + FDetailGridHeaderHeight);
    if not PtInRect(HeaderRect, Point(X, Y)) then
      Continue;

    CurrentX := GridRect.Left - FDetailHorizontalOffset;
    for I := 0 to FDetailColumns.Count - 1 do
    begin
      LCol := FDetailColumns[I];
      if not LCol.Visible then
        Continue;

      if (X >= CurrentX) and (X < CurrentX + LCol.Width) then
      begin
        Result := I;
        AMasterRow := LMasterRow;
        Exit;
      end;
      Inc(CurrentX, LCol.Width);
    end;
  end;
end;

function TDCMasterDetailGrid.GetMasterColumnAtPos(X, Y, ARow: Integer): Integer;
var
  I: Integer;
  CurrentX: Integer;
  LCol: TDCGridColumn;
  RowRect: TRect;
begin
  Result := -1;
  if (ARow < 0) or (ARow >= FRowCount) then
    Exit;

  RowRect := GetRowRect(ARow);
  if not PtInRect(RowRect, Point(X, Y)) then
    Exit;

  for I := 0 to FColumns.Count - 1 do
  begin
    LCol := FColumns[I];
    if not LCol.Visible then
      Continue;

    CurrentX := GetColumnDrawLeft(I, RowRect.Left);
    if (X >= CurrentX) and (X < CurrentX + LCol.Width) then
      Exit(I);
  end;
end;

function TDCMasterDetailGrid.GetDetailColumnAtPos(X, Y, AMasterRow: Integer): Integer;
var
  I: Integer;
  CurrentX: Integer;
  LCol: TDCGridColumn;
  GridRect: TRect;
begin
  Result := -1;
  if (AMasterRow < 0) or (AMasterRow >= FRowCount) or (FDetailStyle <> dsGrid) then
    Exit;

  GridRect := GetDetailGridRect(AMasterRow);
  if not PtInRect(GridRect, Point(X, Y)) then
    Exit;

  CurrentX := GridRect.Left - FDetailHorizontalOffset;
  for I := 0 to FDetailColumns.Count - 1 do
  begin
    LCol := FDetailColumns[I];
    if not LCol.Visible then
      Continue;

    if (X >= CurrentX) and (X < CurrentX + LCol.Width) then
      Exit(I);

    Inc(CurrentX, LCol.Width);
  end;
end;

function TDCMasterDetailGrid.PerformHitTest(X, Y: Integer; out AArea: TDCHitTestArea;
  out AMasterRow, ADetailRow, ACol: Integer): Boolean;
var
  LHeaderCol: Integer;
  LRow: Integer;
  LDetailMasterRow: Integer;
  LDetailRow: Integer;
begin
  AArea := htNone;
  AMasterRow := -1;
  ADetailRow := -1;
  ACol := -1;

  if (FShowHeader) and PtInRect(GetHeaderRect, Point(X, Y)) then
  begin
    LHeaderCol := GetHeaderColumnAt(X, Y);
    AArea := htHeader;
    ACol := LHeaderCol;
    Exit(True);
  end;

  if GetDetailRowAtPos(X, Y, LDetailMasterRow, LDetailRow) then
  begin
    AArea := htDetailRow;
    AMasterRow := LDetailMasterRow;
    ADetailRow := LDetailRow;
    ACol := GetDetailColumnAtPos(X, Y, LDetailMasterRow);
    Exit(True);
  end;

  LRow := GetRowAtPos(X, Y);
  if LRow <> -1 then
  begin
    AMasterRow := LRow;
    ACol := GetMasterColumnAtPos(X, Y, LRow);
    if IsPointOnExpandButton(X, Y, LRow) then
      AArea := htExpandButton
    else
      AArea := htMasterRow;
    Exit(True);
  end;

  Result := False;
end;

function TDCMasterDetailGrid.GetRowAtPos(X, Y: Integer): Integer;
var
  I: Integer;
  P: TPoint;
  LRowRect: TRect;
begin
  Result := -1;
  P := Point(X, Y);

  if not PtInRect(GetRowsRect, P) then
    Exit;

  for I := FTopRow to GetActualRowCount - 1 do
  begin
    LRowRect := GetRowRect(I);
    if LRowRect.Top >= GetRowsRect.Bottom then
      Break;
    if PtInRect(LRowRect, P) then
      Exit(I);
  end;
end;

function TDCMasterDetailGrid.GetRowRect(ARow: Integer): TRect;
var
  LTop: Integer;
begin
  LTop := GetContentTop + ((ARow - FTopRow) * FRowHeight) +
    GetAccumulatedDetailHeightBeforeRow(ARow);
  Result := Rect(0, LTop, ClientWidth, LTop + FRowHeight);
end;

function TDCMasterDetailGrid.GetRowsRect: TRect;
begin
  Result := Rect(0, GetContentTop, ClientWidth, ClientHeight);
  if FShowFooter then
    Dec(Result.Bottom, FFooterHeight);
  if Result.Bottom < Result.Top then
    Result.Bottom := Result.Top;
end;

function TDCMasterDetailGrid.GetVisibleMasterRows: Integer;
var
  LHeight: Integer;
begin
  LHeight := (GetRowsRect.Bottom - GetRowsRect.Top);
  if LHeight <= 0 then
    Exit(0);
  Result := Max(1, LHeight div FRowHeight);
end;

function TDCMasterDetailGrid.IsExpandedRowVisible: Boolean;
var
  I: Integer;
  LVisibleRow: Integer;
begin
  Result := False;
  for I := 0 to FExpandedRows.Count - 1 do
  begin
    LVisibleRow := GetVisibleIndexOfActualRow(FExpandedRows[I]);
    if (LVisibleRow >= FTopRow) and IsRowVisible(LVisibleRow) then
      Exit(True);
  end;
end;

function TDCMasterDetailGrid.IsRowExpanded(ARow: Integer): Boolean;
begin
  Result := FExpandedRows.IndexOf(ARow) <> -1;
end;

function TDCMasterDetailGrid.IsPointOnExpandButton(X, Y: Integer; ARow: Integer): Boolean;
begin
  Result := FShowExpandButton and PtInRect(GetExpandButtonRect(GetRowRect(ARow)), Point(X, Y));
end;

function TDCMasterDetailGrid.IsRowVisible(ARow: Integer): Boolean;
var
  R: TRect;
begin
  R := GetRowRect(ARow);
  Result := (R.Bottom > GetRowsRect.Top) and (R.Top < GetRowsRect.Bottom);
end;

function TDCMasterDetailGrid.GetDefaultRulesFileName: string;
var
  LGridName: string;
begin
  LGridName := Trim(Name);
  if LGridName = '' then
    LGridName := ClassName;

  Result := TPath.Combine(TPath.GetDirectoryName(ParamStr(0)),
    TPath.Combine('DCFlexGridRules', LGridName + '.rules.json'));
end;

function TDCMasterDetailGrid.GetDefaultDesignerPreferencesFileName: string;
var
  LGridName: string;
begin
  LGridName := Trim(Name);
  if LGridName = '' then
    LGridName := ClassName;

  Result := TPath.Combine(TPath.GetDirectoryName(ParamStr(0)),
    TPath.Combine('DCFlexGridRules', LGridName + '.designer.json'));
end;

procedure TDCMasterDetailGrid.LoadRulesFromFile(const AFileName: string = '');
var
  LFileName: string;
begin
  LFileName := Trim(AFileName);
  if LFileName = '' then
    LFileName := GetDefaultRulesFileName;

  if Assigned(FBusinessHighlight) then
    FBusinessHighlight.LoadFromFile(LFileName);

  Invalidate;
end;

procedure TDCMasterDetailGrid.SaveRulesToFile(const AFileName: string = '');
var
  LFileName: string;
begin
  LFileName := Trim(AFileName);
  if LFileName = '' then
    LFileName := GetDefaultRulesFileName;

  if Assigned(FBusinessHighlight) then
    FBusinessHighlight.SaveToFile(LFileName);
end;

procedure TDCMasterDetailGrid.Loaded;
begin
  inherited Loaded;

  if Assigned(FDataAdapter) then
    FRowCount := Max(0, FDataAdapter.GetMasterRowCount);

  if (FExpandedRow >= 0) and (FExpandedRow < FRowCount) then
  begin
    if FExpandMode = emSingle then
    begin
      FExpandedRows.Clear;
      FExpandedRows.Add(FExpandedRow);
    end
    else if FExpandedRows.IndexOf(FExpandedRow) = -1 then
      FExpandedRows.Add(FExpandedRow);
  end
  else if FExpandedRows.Count > 0 then
    FExpandedRow := FExpandedRows.Last
  else
    FExpandedRow := -1;

  if FAutoLoadLayout then
    LoadLayout;

  LoadRulesFromFile;

  UpdateScrollBar;
end;

function TDCMasterDetailGrid.MaxTopRow: Integer;
var
  I: Integer;
  LViewportHeight: Integer;
  LAccumulatedHeight: Integer;
  LActualRow: Integer;
begin
  LViewportHeight := (GetRowsRect.Bottom - GetRowsRect.Top);
  if (GetActualRowCount <= 0) or (LViewportHeight <= 0) then
    Exit(0);

  LAccumulatedHeight := 0;
  Result := GetActualRowCount - 1;

  for I := GetActualRowCount - 1 downto 0 do
  begin
    LActualRow := GetActualRowIndex(I);
    Inc(LAccumulatedHeight, FRowHeight);
    if (LActualRow >= 0) and IsRowExpanded(LActualRow) then
      Inc(LAccumulatedHeight, GetCurrentDetailHeight(LActualRow));

    if LAccumulatedHeight > LViewportHeight then
      Break;

    Result := I;
  end;

  if Result < 0 then
    Result := 0;
end;

procedure TDCMasterDetailGrid.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  LRow: Integer;
  LActualRow: Integer;
  LResizeColumn: Integer;
  LHeaderColumn: Integer;
  LSortColumn: Integer;
  LDetailMasterRow: Integer;
  LDetailRow: Integer;
  LTrackRect: TRect;
  LThumbRect: TRect;
  LPage: Integer;
  LCurrentDetailOffset: Integer;
begin
  if Button = mbRight then
  begin
    LHeaderColumn := GetHeaderColumnAt(X, Y);
    if LHeaderColumn <> -1 then
    begin
      SetFocus;
      if Assigned(FOnHeaderRightClick) then
        FOnHeaderRightClick(Self, LHeaderColumn, ClientToScreen(Point(X, Y)));
      if FAllowHeaderFooterSummaryMenu then
      begin
        ShowHeaderFooterSummaryMenu(LHeaderColumn, ClientToScreen(Point(X, Y)));
        FHeaderPopupShownFromMouse := True;
      end;
      Exit;
    end;
    Exit;
  end;

  inherited MouseDown(Button, Shift, X, Y);

  if Button <> mbLeft then
    Exit;

  if FAllowColumnResize then
  begin
    LResizeColumn := GetHeaderResizeColumn(X, Y);
    if LResizeColumn <> -1 then
    begin
      if ssDouble in Shift then
      begin
        AutoSizeColumn(LResizeColumn);
        Exit;
      end;

      FResizingColumn := LResizeColumn;
      FResizeStartX := X;
      FResizeColumnStartWidth := FColumns[LResizeColumn].Width;
      Cursor := crHSplit;
      Exit;
    end;
  end;

  if FAllowDetailColumnResize then
  begin
    LResizeColumn := GetDetailHeaderResizeColumn(X, Y, LDetailMasterRow);
    if LResizeColumn <> -1 then
    begin
      if ssDouble in Shift then
      begin
        AutoSizeDetailColumnAt(LResizeColumn);
        Exit;
      end;

      FDetailResizingColumn := LResizeColumn;
      FDetailResizeMasterRow := LDetailMasterRow;
      FResizeStartX := X;
      FResizeColumnStartWidth := FDetailColumns[LResizeColumn].Width;
      Cursor := crHSplit;
      Exit;
    end;
  end;

  if GetDetailHorizontalScrollAtPos(X, Y, LDetailMasterRow, LTrackRect, LThumbRect) then
  begin
    SelectedRow := LDetailMasterRow;
    FExpandedRow := LDetailMasterRow;
    FSelectedDetailRow := -1;

    if PtInRect(LThumbRect, Point(X, Y)) then
    begin
      FDetailHorizontalDragging := True;
      FDetailHorizontalDragMasterRow := LDetailMasterRow;
      FDetailHorizontalDragStartX := X;
      FDetailHorizontalDragStartOffset := FDetailHorizontalOffset;
      MouseCapture := True;
    end
    else
    begin
      LPage := Max(32, (LTrackRect.Right - LTrackRect.Left) - 32);
      if X < LThumbRect.Left then
        SetDetailHorizontalOffset(FDetailHorizontalOffset - LPage)
      else
        SetDetailHorizontalOffset(FDetailHorizontalOffset + LPage);
    end;

    Invalidate;
    Exit;
  end;

  if GetDetailVerticalScrollAtPos(X, Y, LDetailMasterRow, LTrackRect, LThumbRect) then
  begin
    SelectedRow := LDetailMasterRow;
    FExpandedRow := LDetailMasterRow;
    FSelectedDetailRow := -1;

    if PtInRect(LThumbRect, Point(X, Y)) then
    begin
      FDetailScrollDragging := True;
      FDetailScrollDragMasterRow := LDetailMasterRow;
      FDetailScrollDragStartY := Y;
      if FDetailScrollMasterRow = LDetailMasterRow then
        FDetailScrollDragStartOffset := FDetailVerticalOffset
      else
        FDetailScrollDragStartOffset := 0;
      MouseCapture := True;
    end
    else
    begin
      if FDetailScrollMasterRow = LDetailMasterRow then
        LCurrentDetailOffset := FDetailVerticalOffset
      else
        LCurrentDetailOffset := 0;
      LPage := Max(FDetailGridRowHeight, (LTrackRect.Bottom - LTrackRect.Top) - FDetailGridRowHeight);
      if Y < LThumbRect.Top then
        SetDetailVerticalOffset(LDetailMasterRow, LCurrentDetailOffset - LPage)
      else
        SetDetailVerticalOffset(LDetailMasterRow, LCurrentDetailOffset + LPage);
    end;

    Invalidate;
    Exit;
  end;

  LHeaderColumn := GetHeaderColumnAt(X, Y);
  if LHeaderColumn <> -1 then
  begin
    SetFocus;
    if Assigned(FOnHeaderClick) then
      FOnHeaderClick(Self, LHeaderColumn);
    LSortColumn := GetHeaderSortColumnAt(X, Y);
    if FAllowColumnSort and (LSortColumn <> -1) then
      ToggleSortForColumn(LSortColumn);
    Exit;
  end;

  if FShowHeader and PtInRect(GetHeaderRect, Point(X, Y)) then
    Exit;

  SetFocus;

  if GetDetailRowAtPos(X, Y, LDetailMasterRow, LDetailRow) then
  begin
    SelectedRow := LDetailMasterRow;
    FExpandedRow := LDetailMasterRow;
    if FDetailSelectEnabled then
      FSelectedDetailRow := LDetailRow;

    if (ssDouble in Shift) then
    begin
      if Assigned(FOnDetailRowDblClick) then
        FOnDetailRowDblClick(Self, LDetailMasterRow, LDetailRow);
    end
    else
    begin
      if Assigned(FOnDetailRowClick) then
        FOnDetailRowClick(Self, LDetailMasterRow, LDetailRow);
    end;

    Invalidate;
    Exit;
  end;

  LRow := GetRowAtPos(X, Y);
  if LRow = -1 then
    Exit;

  LActualRow := GetActualRowIndex(LRow);
  if LActualRow = -1 then
    Exit;

  SelectedRow := LActualRow;
  FSelectedDetailRow := -1;

  if Assigned(FOnRowClick) then
    FOnRowClick(Self, LActualRow);

  if IsPointOnExpandButton(X, Y, LRow) or FExpandOnRowClick then
    ToggleRowExpand(LActualRow)
  else
    Invalidate;
end;

procedure TDCMasterDetailGrid.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  LOldHover: Integer;
  LOldDetailHover: Integer;
  LDetailMasterRow: Integer;
  LDetailRow: Integer;
  LNewWidth: Integer;
  LHeaderCol: Integer;
  LRowsRect: TRect;
  LHeaderRect: TRect;
  LTrackRect: TRect;
  LThumbRect: TRect;
  LTrackRange: Integer;
  LOffsetRange: Integer;
  LDelta: Integer;

  procedure InvalidateControlRect(const ARect: TRect);
  var
    LRect: TRect;
  begin
    LRect := ARect;
    if (LRect.Right > LRect.Left) and (LRect.Bottom > LRect.Top) and HandleAllocated then
      Winapi.Windows.InvalidateRect(Handle, @LRect, False);
  end;

begin
  inherited MouseMove(Shift, X, Y);

  if FDetailScrollDragging then
  begin
    if GetDetailVerticalScrollRects(FDetailScrollDragMasterRow, LTrackRect, LThumbRect) then
    begin
      LTrackRange := Max(1, (LTrackRect.Bottom - LTrackRect.Top) - (LThumbRect.Bottom - LThumbRect.Top));
      LOffsetRange := GetDetailGridMaxVerticalOffset(FDetailScrollDragMasterRow);
      LDelta := MulDiv(Y - FDetailScrollDragStartY, LOffsetRange, LTrackRange);
      SetDetailVerticalOffset(FDetailScrollDragMasterRow, FDetailScrollDragStartOffset + LDelta);
    end;
    Cursor := crDefault;
    Exit;
  end;

  if FDetailHorizontalDragging then
  begin
    if GetDetailHorizontalScrollRects(FDetailHorizontalDragMasterRow, LTrackRect, LThumbRect) then
    begin
      LTrackRange := Max(1, (LTrackRect.Right - LTrackRect.Left) - (LThumbRect.Right - LThumbRect.Left));
      LOffsetRange := GetDetailHorizontalMax(GetDetailGridRect(FDetailHorizontalDragMasterRow));
      LDelta := MulDiv(X - FDetailHorizontalDragStartX, LOffsetRange, LTrackRange);
      SetDetailHorizontalOffset(FDetailHorizontalDragStartOffset + LDelta);
    end;
    Cursor := crDefault;
    Exit;
  end;

  if FResizingColumn <> -1 then
  begin
    LNewWidth := FResizeColumnStartWidth + (X - FResizeStartX);
    FColumns[FResizingColumn].Width := Max(FMinColumnWidth, LNewWidth);
    Cursor := crHSplit;
    UpdateColumnFilterLayout;
    UpdateScrollBar;
    Invalidate;
    Exit;
  end;

  if FDetailResizingColumn <> -1 then
  begin
    LNewWidth := FResizeColumnStartWidth + (X - FResizeStartX);
    FDetailColumns[FDetailResizingColumn].Width := Max(FMinColumnWidth, LNewWidth);
    Cursor := crHSplit;
    { Detail resizing must not affect the master horizontal scrollbar. }
    Invalidate;
    Exit;
  end;

  if GetHeaderResizeColumn(X, Y) <> -1 then
    Cursor := crHSplit
  else if GetDetailHeaderResizeColumn(X, Y, LDetailMasterRow) <> -1 then
    Cursor := crHSplit
  else
    Cursor := crDefault;

  LHeaderCol := GetHeaderColumnAt(X, Y);
  if FHeaderHoverColumn <> LHeaderCol then
  begin
    FHeaderHoverColumn := LHeaderCol;
    LHeaderRect := GetHeaderRect;
    InvalidateControlRect(LHeaderRect);
  end;

  LDetailRow := GetDetailHeaderColumnAt(X, Y, LDetailMasterRow);
  if (FDetailHeaderHoverColumn <> LDetailRow) or ((LDetailRow <> -1) and (FDetailResizeMasterRow <> LDetailMasterRow)) then
  begin
    FDetailHeaderHoverColumn := LDetailRow;
    if LDetailRow <> -1 then
      FDetailResizeMasterRow := LDetailMasterRow
    else if FDetailResizingColumn = -1 then
      FDetailResizeMasterRow := -1;
    LRowsRect := GetRowsRect;
    InvalidateControlRect(LRowsRect);
  end;

  LOldHover := FHoverRow;
  FHoverRow := GetActualRowIndex(GetRowAtPos(X, Y));

  LOldDetailHover := FHoverDetailRow;
  if GetDetailRowAtPos(X, Y, LDetailMasterRow, LDetailRow) then
    FHoverDetailRow := LDetailRow
  else
    FHoverDetailRow := -1;

  if (LOldHover <> FHoverRow) or (LOldDetailHover <> FHoverDetailRow) then
  begin
    LRowsRect := GetRowsRect;
    InvalidateControlRect(LRowsRect);
  end;

  if GetDetailVerticalScrollAtPos(X, Y, LDetailMasterRow, LTrackRect, LThumbRect) or
     GetDetailHorizontalScrollAtPos(X, Y, LDetailMasterRow, LTrackRect, LThumbRect) then
    Cursor := crDefault;
end;

procedure TDCMasterDetailGrid.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  LMasterRow: Integer;
begin
  inherited MouseUp(Button, Shift, X, Y);

  if (Button = mbLeft) and (FResizingColumn <> -1) then
  begin
    FResizingColumn := -1;
    if FAutoSaveLayout and not (csLoading in ComponentState) then
      SaveLayout;
    if GetHeaderResizeColumn(X, Y) <> -1 then
      Cursor := crHSplit
    else
      Cursor := crDefault;
    Exit;
  end;

  if (Button = mbLeft) and (FDetailResizingColumn <> -1) then
  begin
    FDetailResizingColumn := -1;
    if FAutoSaveLayout and not (csLoading in ComponentState) then
      SaveLayout;
    if GetDetailHeaderResizeColumn(X, Y, LMasterRow) <> -1 then
      Cursor := crHSplit
    else
      Cursor := crDefault;
    Exit;
  end;

  if (Button = mbLeft) and FDetailScrollDragging then
  begin
    FDetailScrollDragging := False;
    FDetailScrollDragMasterRow := -1;
    MouseCapture := False;
    Cursor := crDefault;
    Exit;
  end;

  if (Button = mbLeft) and FDetailHorizontalDragging then
  begin
    FDetailHorizontalDragging := False;
    FDetailHorizontalDragMasterRow := -1;
    MouseCapture := False;
    Cursor := crDefault;
    Exit;
  end;
end;

procedure TDCMasterDetailGrid.KeyDown(var Key: Word; Shift: TShiftState);
var
  LNewRow: Integer;
  LPageSize: Integer;
begin
  inherited KeyDown(Key, Shift);

  if GetActualRowCount <= 0 then
    Exit;

  if FSelectedRow < 0 then
    FSelectedRow := GetActualRowIndex(0);

  LNewRow := FSelectedRow;
  LPageSize := Max(1, GetVisibleMasterRows - 1);

  case Key of
    VK_UP:
      Dec(LNewRow);
    VK_DOWN:
      Inc(LNewRow);
    VK_PRIOR:
      Dec(LNewRow, LPageSize);
    VK_NEXT:
      Inc(LNewRow, LPageSize);
    VK_HOME:
      LNewRow := 0;
    VK_END:
      LNewRow := GetActualRowCount - 1;
    VK_LEFT:
      begin
        if IsRowExpanded(FSelectedRow) then
          CollapseRow(FSelectedRow);
        Key := 0;
        Invalidate;
        Exit;
      end;
    VK_RIGHT, VK_RETURN, VK_SPACE:
      begin
        ToggleRowExpand(FSelectedRow);
        Key := 0;
        Exit;
      end;
  else
    Exit;
  end;

  LNewRow := EnsureRange(LNewRow, 0, GetActualRowCount - 1);
  LNewRow := GetActualRowIndex(LNewRow);
  if LNewRow <> FSelectedRow then
  begin
    FSelectedRow := LNewRow;
    FSelectedDetailRow := -1;
  end;

  EnsureRowVisible(FSelectedRow);
  Invalidate;
  Key := 0;
end;

function TDCMasterDetailGrid.NormalizeRowIndex(AValue: Integer): Integer;
begin
  if GetActualRowCount <= 0 then
    Exit(-1);
  Result := EnsureRange(AValue, 0, FRowCount - 1);
end;

procedure TDCMasterDetailGrid.Paint;
begin
  inherited Paint;

  { Safety clamp: after detail-column resizing or layout loading, the old
    horizontal offset can be greater than the current master max. In that case
    the master content becomes shifted/cropped even when no horizontal scroll
    is really needed. }
  if FHorizontalOffset > GetHorizontalMax then
    FHorizontalOffset := GetHorizontalMax;
  if FHorizontalOffset < 0 then
    FHorizontalOffset := 0;

  {
    Draw only the non-windowed areas here.
    Toolbar/search and column filters are real VCL child controls (TEdit/TButton),
    so their bounds/z-order must be refreshed after the grid finishes painting.
    Otherwise the canvas painting can visually cover them or leave them behind the grid.
  }
  DrawBackground;
  DrawToolbar;
  DrawHeader;
  DrawColumnFiltersBackground;
  DrawRows;
  DrawFooter;
  DrawBorder;
end;

procedure TDCMasterDetailGrid.RefreshGrid;
begin
  if Assigned(FDataAdapter) then
    FRowCount := Max(0, FDataAdapter.GetMasterRowCount);

  RebuildFilter;
  UpdateScrollBar;
  Invalidate;
end;

procedure TDCMasterDetailGrid.Resize;
begin
  inherited Resize;
  UpdateToolbarLayout;
  UpdateColumnFilterLayout;
  UpdateScrollBar;
  Invalidate;
end;

function TDCMasterDetailGrid.RowHasDetailVisible(ARow: Integer): Boolean;
begin
  Result := (ARow >= 0) and (ARow < FRowCount) and IsRowExpanded(ARow);
end;

function TDCMasterDetailGrid.RowHasDetailContent(ARow: Integer): Boolean;
var
  LText: string;
begin
  Result := False;
  if (ARow < 0) or (ARow >= FRowCount) then
    Exit;

  case FDetailStyle of
    dsGrid:
      Result := (FDetailColumns.Count > 0) and (GetDetailGridRowCount(ARow) > 0);
    dsText:
      begin
        if Assigned(FOnDrawDetail) then
          Exit(True);
        LText := Trim(GetDetailDisplayText(ARow));
        Result := LText <> '';
      end;
  end;
end;

procedure TDCMasterDetailGrid.SetAlternateColors(const Value: Boolean);
begin
  if FAlternateColors <> Value then
  begin
    FAlternateColors := Value;
    Invalidate;
  end;
end;

procedure TDCMasterDetailGrid.SetBorderWidth(const Value: Integer);
begin
  if FBorderWidth <> Value then
  begin
    FBorderWidth := Max(0, Value);
    Invalidate;
  end;
end;

procedure TDCMasterDetailGrid.SetAllowColumnResize(const Value: Boolean);
begin
  if FAllowColumnResize <> Value then
  begin
    FAllowColumnResize := Value;
    if not FAllowColumnResize then
    begin
      FResizingColumn := -1;
      Cursor := crDefault;
    end;
  end;
end;

procedure TDCMasterDetailGrid.SetColumns(const Value: TDCGridColumns);
begin
  FColumns.Assign(Value);
end;

procedure TDCMasterDetailGrid.SetDetailColumns(const Value: TDCGridColumns);
begin
  FDetailColumns.Assign(Value);
end;

procedure TDCMasterDetailGrid.SetDetailGridHeaderHeight(const Value: Integer);
begin
  if FDetailGridHeaderHeight <> Value then
  begin
    FDetailGridHeaderHeight := Max(18, Value);
    UpdateScrollBar;
    Invalidate;
  end;
end;

procedure TDCMasterDetailGrid.SetDetailGridRowHeight(const Value: Integer);
begin
  if FDetailGridRowHeight <> Value then
  begin
    FDetailGridRowHeight := Max(18, Value);
    UpdateScrollBar;
    Invalidate;
  end;
end;

procedure TDCMasterDetailGrid.SetDetailSelectEnabled(const Value: Boolean);
begin
  if FDetailSelectEnabled <> Value then
  begin
    FDetailSelectEnabled := Value;
    if not FDetailSelectEnabled then
    begin
      FSelectedDetailRow := -1;
      FHoverDetailRow := -1;
    end;
    Invalidate;
  end;
end;

procedure TDCMasterDetailGrid.SetDetailVerticalScroll(const Value: Boolean);
begin
  if FDetailVerticalScroll <> Value then
  begin
    FDetailVerticalScroll := Value;
    FDetailVerticalOffset := 0;
    UpdateScrollBar;
    Invalidate;
  end;
end;

procedure TDCMasterDetailGrid.SetDetailMaxHeight(const Value: Integer);
begin
  if FDetailMaxHeight <> Value then
  begin
    FDetailMaxHeight := Max(60, Value);
    FDetailVerticalOffset := 0;
    UpdateScrollBar;
    Invalidate;
  end;
end;

procedure TDCMasterDetailGrid.SetDetailHeight(const Value: Integer);
begin
  if FDetailHeight <> Value then
  begin
    FDetailHeight := Max(40, Value);
    UpdateScrollBar;
    Invalidate;
  end;
end;

procedure TDCMasterDetailGrid.SetDetailStyle(const Value: TDCDetailStyle);
begin
  if FDetailStyle <> Value then
  begin
    FDetailStyle := Value;
    UpdateScrollBar;
    Invalidate;
  end;
end;

procedure TDCMasterDetailGrid.SetExpandOnRowClick(const Value: Boolean);
begin
  if FExpandOnRowClick <> Value then
    FExpandOnRowClick := Value;
end;

procedure TDCMasterDetailGrid.SetExpandMode(const Value: TDCExpandMode);
var
  LLastExpanded: Integer;
begin
  if FExpandMode <> Value then
  begin
    FExpandMode := Value;
    if (FExpandMode = emSingle) and (FExpandedRows.Count > 1) then
    begin
      if FExpandedRow <> -1 then
        LLastExpanded := FExpandedRow
      else
        LLastExpanded := FExpandedRows.Last;
      FExpandedRows.Clear;
      FExpandedRows.Add(LLastExpanded);
      FExpandedRow := LLastExpanded;
    end;
    if FAutoSaveLayout and not (csLoading in ComponentState) then
      SaveLayout;
    UpdateScrollBar;
    Invalidate;
  end;
end;

procedure TDCMasterDetailGrid.SetExpandedRow(const Value: Integer);
begin
  if csLoading in ComponentState then
  begin
    FExpandedRow := Value;
    Exit;
  end;

  if Value < 0 then
    CollapseAll
  else
    ExpandRow(Value);
end;

procedure TDCMasterDetailGrid.SetHeaderHeight(const Value: Integer);
begin
  if FHeaderHeight <> Value then
  begin
    FHeaderHeight := Max(0, Value);
    UpdateScrollBar;
    Invalidate;
  end;
end;

procedure TDCMasterDetailGrid.SetMinColumnWidth(const Value: Integer);
begin
  if FMinColumnWidth <> Max(24, Value) then
  begin
    FMinColumnWidth := Max(24, Value);
    Invalidate;
  end;
end;

procedure TDCMasterDetailGrid.SetRowCount(const Value: Integer);
var
  I: Integer;
begin
  if FRowCount <> Max(0, Value) then
  begin
    FRowCount := Max(0, Value);

    if FSelectedRow >= FRowCount then
      FSelectedRow := -1;

    for I := FExpandedRows.Count - 1 downto 0 do
      if FExpandedRows[I] >= FRowCount then
        FExpandedRows.Delete(I);

    if (FExpandedRow >= FRowCount) or (FExpandedRows.IndexOf(FExpandedRow) = -1) then
    begin
      if FExpandedRows.Count > 0 then
        FExpandedRow := FExpandedRows.Last
      else
        FExpandedRow := -1;
    end;

    FTopRow := EnsureRange(FTopRow, 0, MaxTopRow);
    UpdateScrollBar;
    Invalidate;
  end;
end;

procedure TDCMasterDetailGrid.SetRowHeight(const Value: Integer);
begin
  if FRowHeight <> Value then
  begin
    FRowHeight := Max(22, Value);
    UpdateScrollBar;
    Invalidate;
  end;
end;

procedure TDCMasterDetailGrid.SetSelectedRow(const Value: Integer);
begin
  if FSelectedRow <> Value then
  begin
    FSelectedRow := NormalizeRowIndex(Value);
    Invalidate;
  end;
end;

procedure TDCMasterDetailGrid.SetShowExpandButton(const Value: Boolean);
begin
  if FShowExpandButton <> Value then
  begin
    FShowExpandButton := Value;
    Invalidate;
  end;
end;

procedure TDCMasterDetailGrid.SetShowHeader(const Value: Boolean);
begin
  if FShowHeader <> Value then
  begin
    FShowHeader := Value;
    UpdateScrollBar;
    Invalidate;
  end;
end;

procedure TDCMasterDetailGrid.SetShowHeaderColumnLines(const Value: Boolean);
begin
  if FShowHeaderColumnLines <> Value then
  begin
    FShowHeaderColumnLines := Value;
    Invalidate;
  end;
end;

procedure TDCMasterDetailGrid.SetShowRowColumnLines(const Value: Boolean);
begin
  if FShowRowColumnLines <> Value then
  begin
    FShowRowColumnLines := Value;
    Invalidate;
  end;
end;



function DCCSVValue(const AValue: string): string;
var
  S: string;
begin
  S := AValue;
  S := StringReplace(S, '"', '""', [rfReplaceAll]);
  if (Pos(';', S) > 0) or (Pos('"', S) > 0) or (Pos(#13, S) > 0) or (Pos(#10, S) > 0) then
    Result := '"' + S + '"'
  else
    Result := S;
end;

procedure TDCMasterDetailGrid.ExportToCSV(const AFileName: string; AOnlyVisibleColumns: Boolean;
  AOnlyFilteredRows: Boolean);
var
  LLines: TStringList;
  LLine: string;
  LCol: Integer;
  LRow: Integer;
  LFirst: Boolean;

  procedure AppendValue(const AValue: string);
  begin
    if not LFirst then
      LLine := LLine + ';';
    LLine := LLine + DCCSVValue(AValue);
    LFirst := False;
  end;

begin
  if Trim(AFileName) = '' then
    Exit;

  LLines := TStringList.Create;
  try
    LLine := '';
    LFirst := True;
    for LCol := 0 to FColumns.Count - 1 do
    begin
      if AOnlyVisibleColumns and not FColumns[LCol].Visible then
        Continue;
      AppendValue(FColumns[LCol].Caption);
    end;
    LLines.Add(LLine);

    for LRow := 0 to FRowCount - 1 do
    begin
      if AOnlyFilteredRows and not RowMatchesSearch(LRow) then
        Continue;

      LLine := '';
      LFirst := True;
      for LCol := 0 to FColumns.Count - 1 do
      begin
        if AOnlyVisibleColumns and not FColumns[LCol].Visible then
          Continue;
        AppendValue(GetDisplayText(LRow, LCol));
      end;
      LLines.Add(LLine);
    end;

    if ExtractFilePath(AFileName) <> '' then
      ForceDirectories(ExtractFilePath(AFileName));
    LLines.SaveToFile(AFileName, TEncoding.UTF8);
  finally
    LLines.Free;
  end;
end;

procedure TDCMasterDetailGrid.SetFrozenColumns(const Value: Integer);
begin
  if FFrozenColumns <> Max(0, Value) then
  begin
    FFrozenColumns := Max(0, Value);
    if FAutoSaveLayout and not (csLoading in ComponentState) then
      SaveLayout;
    Invalidate;
  end;
end;

procedure TDCMasterDetailGrid.SetAllowHeaderFooterSummaryMenu(const Value: Boolean);
begin
  if FAllowHeaderFooterSummaryMenu <> Value then
    FAllowHeaderFooterSummaryMenu := Value;
end;

procedure TDCMasterDetailGrid.SetAllowContextMenuActions(const Value: Boolean);
begin
  if FAllowContextMenuActions <> Value then
    FAllowContextMenuActions := Value;
end;

procedure TDCMasterDetailGrid.BuildHeaderFooterPopup;
var
  LItem: TDCFlexPopupMenuItem;
  LLang: TDCGridLang;
  LColumnsItem: TDCFlexPopupMenuItem;
  LFiltersItem: TDCFlexPopupMenuItem;
  LLayoutItem: TDCFlexPopupMenuItem;
  LSummaryItem: TDCFlexPopupMenuItem;
  LToolbarItem: TDCFlexPopupMenuItem;

  function AddItem(AItems: TDCFlexPopupMenuItems; const ACaption: string;
    ATag: Integer; AChecked: Boolean = False;
    AEnabled: Boolean = True): TDCFlexPopupMenuItem;
  begin
    Result := AItems.Add;
    Result.Caption := ACaption;
    Result.Tag := ATag;
    Result.Checked := AChecked;
    Result.Enabled := AEnabled;
  end;

  procedure AddSeparator(AItems: TDCFlexPopupMenuItems);
  begin
    LItem := AItems.Add;
    LItem.Separator := True;
  end;

  procedure AddSummaryItem(AItems: TDCFlexPopupMenuItems; const ACaption: string;
    ASummary: TDCFooterSummary);
  var
    LChecked: Boolean;
  begin
    LChecked := (FHeaderFooterPopupColumn >= 0) and
      (FHeaderFooterPopupColumn < FColumns.Count) and
      (FColumns[FHeaderFooterPopupColumn].FooterSummary = ASummary);
    AddItem(AItems, ACaption, DC_GRID_POPUP_SUMMARY_BASE + Ord(ASummary),
      LChecked);
  end;

begin
  if FHeaderFooterPopup = nil then
    FHeaderFooterPopup := TDCFlexPopupMenu.Create(Self);

  FHeaderFooterPopup.ThemeMode := FThemeMode;
  FHeaderFooterPopup.AttachedControl := Self;
  FHeaderFooterPopup.Items.Clear;
  FHeaderFooterPopup.OnItemClick := HeaderFooterPopupClick;
  LLang := GetCurrentLanguage;

  LToolbarItem := AddItem(FHeaderFooterPopup.Items, LLang.MenuToolbarCaption, 0);
  AddItem(LToolbarItem.Items, LLang.MenuShowToolbarCaption, DC_GRID_POPUP_SHOW_TOOLBAR,
    FShowToolbar);
  AddItem(LToolbarItem.Items, LLang.MenuShowRulesCaption, DC_GRID_POPUP_SHOW_RULES,
    FShowToolbarRulesDesignerButton);

  if FAllowColumnFiltersMenu then
  begin
    LFiltersItem := AddItem(FHeaderFooterPopup.Items, LLang.MenuFiltersCaption, 0);
    AddItem(LFiltersItem.Items, LLang.MenuShowColumnFiltersCaption, DC_GRID_POPUP_SHOW_FILTERS,
      FShowColumnFilters);
    AddSeparator(LFiltersItem.Items);
    AddItem(LFiltersItem.Items, LLang.MenuClearColumnFilterCaption, DC_GRID_POPUP_CLEAR_THIS_FILTER,
      False, (FHeaderFooterPopupColumn >= 0) and
      (FHeaderFooterPopupColumn < FColumns.Count) and
      (Trim(FColumns[FHeaderFooterPopupColumn].FilterText) <> ''));
    AddItem(LFiltersItem.Items, LLang.MenuClearAllFiltersCaption, DC_GRID_POPUP_CLEAR_ALL_FILTERS,
      False, HasColumnFilters);
  end;

  AddItem(FHeaderFooterPopup.Items, LLang.FooterMenuShowCaption,
    DC_GRID_POPUP_SHOW_FOOTER, FShowFooter);

  AddSeparator(FHeaderFooterPopup.Items);

  LLayoutItem := AddItem(FHeaderFooterPopup.Items, LLang.MenuLayoutCaption, 0);
  AddItem(LLayoutItem.Items, LLang.MenuLayoutSaveCaption, DC_GRID_POPUP_LAYOUT_SAVE);
  AddItem(LLayoutItem.Items, LLang.MenuLayoutLoadCaption, DC_GRID_POPUP_LAYOUT_LOAD);
  AddItem(LLayoutItem.Items, LLang.MenuLayoutResetCaption, DC_GRID_POPUP_LAYOUT_RESET);
  AddSeparator(LLayoutItem.Items);
  AddItem(LLayoutItem.Items, LLang.MenuExportCsvCaption, DC_GRID_POPUP_EXPORT_CSV);

  AddSeparator(FHeaderFooterPopup.Items);

  LColumnsItem := AddItem(FHeaderFooterPopup.Items, LLang.MenuColumnsCaption, 0);
  AddItem(LColumnsItem.Items, LLang.MenuChooseColumnsCaption, DC_GRID_POPUP_CHOOSE_COLUMNS);
  AddSeparator(LColumnsItem.Items);
  AddItem(LColumnsItem.Items, LLang.MenuAutoFitColumnCaption, DC_GRID_POPUP_AUTOFIT_COLUMN,
    False, (FHeaderFooterPopupColumn >= 0) and
    (FHeaderFooterPopupColumn < FColumns.Count) and
    FColumns[FHeaderFooterPopupColumn].Visible);
  AddItem(LColumnsItem.Items, LLang.MenuAutoFitAllColumnsCaption, DC_GRID_POPUP_AUTOFIT_ALL_COLUMNS,
    False, FColumns.Count > 0);
  AddSeparator(LColumnsItem.Items);
  AddItem(LColumnsItem.Items, LLang.MenuFreezeToColumnCaption, DC_GRID_POPUP_FREEZE_TO_COLUMN,
    False, (FHeaderFooterPopupColumn >= 0) and
    (FHeaderFooterPopupColumn < FColumns.Count) and
    FColumns[FHeaderFooterPopupColumn].Visible);
  AddItem(LColumnsItem.Items, LLang.MenuClearFrozenColumnsCaption, DC_GRID_POPUP_CLEAR_FROZEN_COLUMNS,
    False, FFrozenColumns > 0);

  AddSeparator(FHeaderFooterPopup.Items);

  LSummaryItem := AddItem(FHeaderFooterPopup.Items,
    LLang.MenuFooterSummariesCaption, 0);
  AddSummaryItem(LSummaryItem.Items, LLang.FooterMenuNoneCaption, fsNone);
  AddSummaryItem(LSummaryItem.Items, LLang.FooterMenuSumCaption, fsSum);
  AddSummaryItem(LSummaryItem.Items, LLang.FooterMenuCountCaption, fsCount);
  AddSummaryItem(LSummaryItem.Items, LLang.FooterMenuAvgCaption, fsAvg);
  AddSummaryItem(LSummaryItem.Items, LLang.FooterMenuMinCaption, fsMin);
  AddSummaryItem(LSummaryItem.Items, LLang.FooterMenuMaxCaption, fsMax);
end;

procedure TDCMasterDetailGrid.HeaderToolbarVisibilityClick(Sender: TObject);
begin
  ShowToolbar := not FShowToolbar;
  Invalidate;
end;

procedure TDCMasterDetailGrid.HeaderRulesVisibilityClick(Sender: TObject);
begin
  ShowToolbarRulesDesignerButton := not FShowToolbarRulesDesignerButton;
  if FShowToolbarRulesDesignerButton then
    ShowToolbar := True;
  Invalidate;
end;

procedure TDCMasterDetailGrid.HeaderColumnFiltersVisibilityClick(Sender: TObject);
begin
  ShowColumnFilters := not FShowColumnFilters;
  Invalidate;
end;

procedure TDCMasterDetailGrid.HeaderClearThisColumnFilterClick(Sender: TObject);
begin
  if (FHeaderFooterPopupColumn >= 0) and
     (FHeaderFooterPopupColumn < FColumns.Count) then
    SetColumnFilterText(FHeaderFooterPopupColumn, '');
end;

procedure TDCMasterDetailGrid.HeaderClearAllColumnFiltersClick(Sender: TObject);
begin
  ClearColumnFilters;
end;

procedure TDCMasterDetailGrid.HeaderFooterPopupClick(Sender: TObject;
  Item: TDCFlexPopupMenuItem);
var
  LSummaryIndex: Integer;
begin
  if not Assigned(Item) or (not Item.Enabled) or Item.Separator then
    Exit;

  if Item.Tag >= DC_GRID_POPUP_SUMMARY_BASE then
  begin
    LSummaryIndex := Item.Tag - DC_GRID_POPUP_SUMMARY_BASE;
    if (LSummaryIndex >= Ord(Low(TDCFooterSummary))) and
      (LSummaryIndex <= Ord(High(TDCFooterSummary))) then
      SetHeaderFooterSummary(TDCFooterSummary(LSummaryIndex));
    Exit;
  end;

  case Item.Tag of
    DC_GRID_POPUP_SHOW_TOOLBAR:
      HeaderToolbarVisibilityClick(nil);
    DC_GRID_POPUP_SHOW_RULES:
      HeaderRulesVisibilityClick(nil);
    DC_GRID_POPUP_SHOW_FILTERS:
      HeaderColumnFiltersVisibilityClick(nil);
    DC_GRID_POPUP_CLEAR_THIS_FILTER:
      HeaderClearThisColumnFilterClick(nil);
    DC_GRID_POPUP_CLEAR_ALL_FILTERS:
      HeaderClearAllColumnFiltersClick(nil);
    DC_GRID_POPUP_SHOW_FOOTER:
      HeaderFooterVisibilityClick(nil);
    DC_GRID_POPUP_LAYOUT_SAVE:
      ExecuteHeaderLayoutAction(1);
    DC_GRID_POPUP_LAYOUT_LOAD:
      ExecuteHeaderLayoutAction(2);
    DC_GRID_POPUP_LAYOUT_RESET:
      ExecuteHeaderLayoutAction(3);
    DC_GRID_POPUP_EXPORT_CSV:
      HeaderExportCsvClick(nil);
    DC_GRID_POPUP_CHOOSE_COLUMNS:
      HeaderColumnChooserClick(nil);
    DC_GRID_POPUP_AUTOFIT_COLUMN:
      HeaderAutoFitColumnClick(nil);
    DC_GRID_POPUP_AUTOFIT_ALL_COLUMNS:
      HeaderAutoFitAllColumnsClick(nil);
    DC_GRID_POPUP_FREEZE_TO_COLUMN:
      HeaderFreezeToColumnClick(nil);
    DC_GRID_POPUP_CLEAR_FROZEN_COLUMNS:
      HeaderClearFrozenColumnsClick(nil);
  end;
end;

procedure TDCMasterDetailGrid.HeaderExportCsvClick(Sender: TObject);
var
  LSaveDialog: TSaveDialog;
begin
  LSaveDialog := TSaveDialog.Create(Self);
  try
    LSaveDialog.Title := GetCurrentLanguage.MenuExportCsvCaption;
    LSaveDialog.Filter := 'CSV (*.csv)|*.csv|Todos os arquivos (*.*)|*.*';
    LSaveDialog.DefaultExt := 'csv';
    LSaveDialog.FileName := 'dcflex-grid.csv';
    if LSaveDialog.Execute then
      ExportToCSV(LSaveDialog.FileName, True, True);
  finally
    LSaveDialog.Free;
  end;
end;

procedure TDCMasterDetailGrid.ExecuteHeaderLayoutAction(AAction: Integer);
var
  LSaveDialog: TSaveDialog;
  LOpenDialog: TOpenDialog;
  LFileName: string;
begin
  case AAction of
    1:
      begin
        LSaveDialog := TSaveDialog.Create(Self);
        try
          LSaveDialog.Title := GetCurrentLanguage.MenuLayoutSaveCaption;
          LSaveDialog.Filter := 'DCFlex Grid Layout (*.layout)|*.layout|JSON (*.json)|*.json|Todos os arquivos (*.*)|*.*';
          LSaveDialog.DefaultExt := 'layout';
          LSaveDialog.FileName := 'dcflex-grid.layout';
          if LSaveDialog.Execute then
            SaveConfigToFile(LSaveDialog.FileName);
        finally
          LSaveDialog.Free;
        end;
      end;

    2:
      begin
        LOpenDialog := TOpenDialog.Create(Self);
        try
          LOpenDialog.Title := GetCurrentLanguage.MenuLayoutLoadCaption;
          LOpenDialog.Filter := 'DCFlex Grid Layout (*.layout)|*.layout|JSON (*.json)|*.json|Todos os arquivos (*.*)|*.*';
          LOpenDialog.DefaultExt := 'layout';
          if LOpenDialog.Execute then
            LoadConfigFromFile(LOpenDialog.FileName);
        finally
          LOpenDialog.Free;
        end;
      end;

    3:
      begin
        LFileName := GetLayoutFileName;
        if TFile.Exists(LFileName) then
          TFile.Delete(LFileName);
      end;
  end;

  Invalidate;
end;

procedure TDCMasterDetailGrid.HeaderLayoutActionClick(Sender: TObject);
begin
  if not (Sender is TMenuItem) then
    Exit;

  ExecuteHeaderLayoutAction(TMenuItem(Sender).Tag);
end;

procedure TDCMasterDetailGrid.HeaderColumnChooserClick(Sender: TObject);
begin
  ShowColumnChooserDialog;
end;

procedure TDCMasterDetailGrid.ShowColumnChooserDialog;
const
  MR_SELECT_ALL = 1001;
  MR_UNSELECT_ALL = 1002;
var
  LForm: TForm;
  LScroll: TScrollBox;
  LBtnOK: TDCFlexButton;
  LBtnCancel: TDCFlexButton;
  LBtnAll: TDCFlexButton;
  LBtnNone: TDCFlexButton;
  LBottom: TPanel;
  LHeader: TPanel;
  LTitle: TLabel;
  LHint: TLabel;
  LCaption: string;
  LButtons: array of TDCFlexToggleButton;
  LVisibleCount: Integer;
  I: Integer;
  LChanged: Boolean;
  LModalResult: Integer;
  LLang: TDCGridLang;
  LPalette: TDCFlexThemePalette;

  function ColumnDisplayName(AIndex: Integer): string;
  begin
    Result := '';
    if (AIndex >= 0) and (AIndex < FColumns.Count) then
    begin
      Result := Trim(FColumns[AIndex].Caption);
      if Result = '' then
        Result := Trim(FColumns[AIndex].FieldName);
    end;
    if Result = '' then
      Result := Format('%s %d', [LLang.ColumnCaptionPrefix, AIndex + 1]);
  end;

  procedure CheckAll(AValue: Boolean);
  var
    J: Integer;
  begin
    for J := 0 to High(LButtons) do
      LButtons[J].Checked := AValue;
  end;

begin
  if FColumns.Count = 0 then
    Exit;

  LLang := GetCurrentLanguage;
  LPalette := DCFlexPaletteForMode(FThemeMode);
  LForm := TForm.Create(Self);
  try
    LForm.BorderStyle := bsDialog;
    LForm.Position := poScreenCenter;
    LForm.Width := 390;
    LForm.Height := 440;
    LForm.Caption := LLang.MenuColumnsCaption;
    LForm.Color := LPalette.Background;
    LForm.Font.Name := 'Segoe UI';
    LForm.Font.Size := 9;
    LForm.Font.Color := LPalette.Text;

    LHeader := TPanel.Create(LForm);
    LHeader.Parent := LForm;
    LHeader.Align := alTop;
    LHeader.Height := 76;
    LHeader.BevelOuter := bvNone;
    LHeader.ParentBackground := False;
    LHeader.Color := LPalette.Background;

    LTitle := TLabel.Create(LForm);
    LTitle.Parent := LHeader;
    LTitle.Left := 20;
    LTitle.Top := 18;
    LTitle.Caption := LLang.MenuColumnsCaption;
    LTitle.Font.Name := 'Segoe UI';
    LTitle.Font.Size := 14;
    LTitle.Font.Style := [fsBold];
    LTitle.Font.Color := LPalette.Text;

    LHint := TLabel.Create(LForm);
    LHint.Parent := LHeader;
    LHint.Left := 20;
    LHint.Top := 45;
    LHint.Caption := LLang.MenuChooseColumnsCaption;
    LHint.Font.Name := 'Segoe UI';
    LHint.Font.Size := 9;
    LHint.Font.Color := LPalette.MutedText;

    LScroll := TScrollBox.Create(LForm);
    LScroll.Parent := LForm;
    LScroll.Align := alClient;
    LScroll.BorderStyle := bsNone;
    LScroll.Color := LPalette.Surface;
    LScroll.ParentColor := False;
    LScroll.VertScrollBar.Tracking := True;
    LScroll.HorzScrollBar.Visible := False;

    SetLength(LButtons, FColumns.Count);
    for I := 0 to FColumns.Count - 1 do
    begin
      LCaption := ColumnDisplayName(I);
      LButtons[I] := TDCFlexToggleButton.Create(LForm);
      LButtons[I].Parent := LScroll;
      LButtons[I].Left := 16;
      LButtons[I].Top := 14 + (I * 34);
      LButtons[I].Width := 328;
      LButtons[I].Height := 28;
      LButtons[I].Caption := LCaption;
      LButtons[I].Checked := FColumns[I].Visible;
      LButtons[I].AllowToggle := True;
      LButtons[I].ApplyThemePalette(LPalette);
    end;

    LBottom := TPanel.Create(LForm);
    LBottom.Parent := LForm;
    LBottom.Align := alBottom;
    LBottom.Height := 92;
    LBottom.BevelOuter := bvNone;
    LBottom.ParentBackground := False;
    LBottom.Color := LPalette.Background;

    LBtnAll := TDCFlexButton.Create(LForm);
    LBtnAll.Parent := LBottom;
    LBtnAll.Left := 18;
    LBtnAll.Top := 14;
    LBtnAll.Width := 132;
    LBtnAll.Height := 30;
    LBtnAll.Caption := LLang.ColumnChooserSelectAllCaption;
    LBtnAll.ModalResult := MR_SELECT_ALL;
    LBtnAll.ApplyThemePalette(LPalette);

    LBtnNone := TDCFlexButton.Create(LForm);
    LBtnNone.Parent := LBottom;
    LBtnNone.Left := 158;
    LBtnNone.Top := 14;
    LBtnNone.Width := 148;
    LBtnNone.Height := 30;
    LBtnNone.Caption := LLang.ColumnChooserUnselectAllCaption;
    LBtnNone.ModalResult := MR_UNSELECT_ALL;
    LBtnNone.ApplyThemePalette(LPalette);

    LBtnOK := TDCFlexButton.Create(LForm);
    LBtnOK.Parent := LBottom;
    LBtnOK.Left := LBottom.Width - 186;
    LBtnOK.Top := 52;
    LBtnOK.Width := 82;
    LBtnOK.Height := 30;
    LBtnOK.Anchors := [akRight, akBottom];
    LBtnOK.Caption := 'OK';
    LBtnOK.ModalResult := mrOk;
    LBtnOK.Default := True;
    LBtnOK.ApplyThemePalette(LPalette);

    LBtnCancel := TDCFlexButton.Create(LForm);
    LBtnCancel.Parent := LBottom;
    LBtnCancel.Left := LBottom.Width - 96;
    LBtnCancel.Top := 52;
    LBtnCancel.Width := 82;
    LBtnCancel.Height := 30;
    LBtnCancel.Anchors := [akRight, akBottom];
    LBtnCancel.Caption := LLang.CancelCaption;
    LBtnCancel.ModalResult := mrCancel;
    LBtnCancel.Cancel := True;
    LBtnCancel.ApplyThemePalette(LPalette);

    repeat
      LModalResult := LForm.ShowModal;
      case LModalResult of
        MR_SELECT_ALL:
          CheckAll(True);
        MR_UNSELECT_ALL:
          CheckAll(False);
      end;
    until (LModalResult <> MR_SELECT_ALL) and (LModalResult <> MR_UNSELECT_ALL);

    if LModalResult = mrOk then
    begin
      LVisibleCount := 0;
      for I := 0 to High(LButtons) do
        if LButtons[I].Checked then
          Inc(LVisibleCount);

      if LVisibleCount = 0 then
      begin
        MessageDlg(LLang.ColumnChooserKeepOneVisibleMessage, mtWarning,
          [mbOK], 0);
        Exit;
      end;

      LChanged := False;
      for I := 0 to FColumns.Count - 1 do
      begin
        if FColumns[I].Visible <> LButtons[I].Checked then
        begin
          FColumns[I].Visible := LButtons[I].Checked;
          LChanged := True;
        end;
      end;

      if LChanged then
      begin
        UpdateColumnFilterLayout;
        UpdateScrollBar;
        Invalidate;
      end;
    end;
  finally
    LForm.Free;
    LLang.Free;
  end;
end;

procedure TDCMasterDetailGrid.HeaderColumnVisibilityClick(Sender: TObject);
begin
  if not (Sender is TMenuItem) then
    Exit;

  if (TMenuItem(Sender).Tag < 0) or (TMenuItem(Sender).Tag >= FColumns.Count) then
    Exit;

  ToggleHeaderColumnVisibility(TMenuItem(Sender).Tag);
  TMenuItem(Sender).Checked := FColumns[TMenuItem(Sender).Tag].Visible;
end;

procedure TDCMasterDetailGrid.ToggleHeaderColumnVisibility(AColumnIndex: Integer);
var
  LVisibleCount: Integer;
  I: Integer;
begin
  if (AColumnIndex < 0) or (AColumnIndex >= FColumns.Count) then
    Exit;

  LVisibleCount := 0;
  for I := 0 to FColumns.Count - 1 do
    if FColumns[I].Visible then
      Inc(LVisibleCount);

  // Evita deixar o grid sem nenhuma coluna visivel.
  if FColumns[AColumnIndex].Visible and (LVisibleCount <= 1) then
    Exit;

  FColumns[AColumnIndex].Visible := not FColumns[AColumnIndex].Visible;
  UpdateColumnFilterLayout;
  UpdateScrollBar;
  Invalidate;
end;

procedure TDCMasterDetailGrid.HeaderAutoFitColumnClick(Sender: TObject);
begin
  if (FHeaderFooterPopupColumn >= 0) and
     (FHeaderFooterPopupColumn < FColumns.Count) and
     FColumns[FHeaderFooterPopupColumn].Visible then
    AutoSizeColumn(FHeaderFooterPopupColumn);
end;

procedure TDCMasterDetailGrid.HeaderAutoFitAllColumnsClick(Sender: TObject);
begin
  AutoSizeColumns;
end;

procedure TDCMasterDetailGrid.HeaderFreezeToColumnClick(Sender: TObject);
var
  I: Integer;
  LVisibleCount: Integer;
begin
  if (FHeaderFooterPopupColumn < 0) or
     (FHeaderFooterPopupColumn >= FColumns.Count) then
    Exit;

  LVisibleCount := 0;
  for I := 0 to FHeaderFooterPopupColumn do
    if FColumns[I].Visible then
      Inc(LVisibleCount);

  FrozenColumns := LVisibleCount;
end;

procedure TDCMasterDetailGrid.HeaderClearFrozenColumnsClick(Sender: TObject);
begin
  FrozenColumns := 0;
end;

procedure TDCMasterDetailGrid.HeaderFooterVisibilityClick(Sender: TObject);
begin
  ShowFooter := not FShowFooter;
  Invalidate;
end;

procedure TDCMasterDetailGrid.HeaderFooterSummaryClick(Sender: TObject);
var
  LSummary: TDCFooterSummary;
begin
  if not (Sender is TMenuItem) then
    Exit;

  if (FHeaderFooterPopupColumn < 0) or (FHeaderFooterPopupColumn >= FColumns.Count) then
    Exit;

  LSummary := TDCFooterSummary(TMenuItem(Sender).Tag);
  SetHeaderFooterSummary(LSummary);
end;

procedure TDCMasterDetailGrid.SetHeaderFooterSummary(AValue: TDCFooterSummary);
begin
  if (FHeaderFooterPopupColumn < 0) or
    (FHeaderFooterPopupColumn >= FColumns.Count) then
    Exit;

  FColumns[FHeaderFooterPopupColumn].FooterSummary := AValue;

  if AValue <> fsNone then
    ShowFooter := True;

  Invalidate;
end;

procedure TDCMasterDetailGrid.ShowHeaderFooterSummaryMenu(ACol: Integer; const AScreenPt: TPoint);
begin
  if (not FAllowHeaderFooterSummaryMenu) or (ACol < 0) or (ACol >= FColumns.Count) then
    Exit;

  FHeaderFooterPopupColumn := ACol;
  BuildHeaderFooterPopup;
  FHeaderFooterPopup.Popup(AScreenPt.X, AScreenPt.Y);
end;

procedure TDCMasterDetailGrid.SetTheme(const Value: TDCGridTheme);
begin
  FTheme.Assign(Value);
  FThemeMode := dtmCustom;
end;

procedure TDCMasterDetailGrid.ApplyThemePalette(const APalette: TDCFlexThemePalette);
begin
  FThemeMode := dtmCustom;
  FTheme.ApplyThemePalette(APalette);
  DCFlexApplyNativeDarkMode(Self, DCFlexIsDarkPalette(APalette));
  if Assigned(FHeaderFooterPopup) then
  begin
    FHeaderFooterPopup.ApplyThemePalette(APalette);
    FHeaderFooterPopup.AttachedControl := Self;
  end;
  UpdateColumnFilterLayout;
  UpdateToolbarLayout;
  Invalidate;
end;

procedure TDCMasterDetailGrid.SetThemeMode(const Value: TDCFlexThemeMode);
begin
  if FThemeMode = Value then
    Exit;

  FThemeMode := Value;
  if FThemeMode = dtmCustom then
    Exit;

  FTheme.ApplyThemePalette(DCFlexPaletteForMode(FThemeMode));
  DCFlexApplyNativeDarkMode(Self, FThemeMode = dtmDark);
  if Assigned(FHeaderFooterPopup) then
  begin
    FHeaderFooterPopup.ThemeMode := FThemeMode;
    FHeaderFooterPopup.AttachedControl := Self;
  end;
  UpdateColumnFilterLayout;
  UpdateToolbarLayout;
  Invalidate;
end;

procedure TDCMasterDetailGrid.SetTopRow(const Value: Integer);
var
  LValue: Integer;
begin
  LValue := EnsureRange(Value, 0, MaxTopRow);
  if FTopRow <> LValue then
  begin
    FTopRow := LValue;
    UpdateScrollBar;
    Invalidate;
  end;
end;

procedure TDCMasterDetailGrid.SetTitleFont(const Value: TFont);
begin
  FTitleFont.Assign(Value);
end;

procedure TDCMasterDetailGrid.SetDetailFont(const Value: TFont);
begin
  FDetailFont.Assign(Value);
end;


function TDCMasterDetailGrid.MeasureTextWidth(const AText: string; AFont: TFont): Integer;
begin
  Canvas.Font.Assign(AFont);
  Result := Canvas.TextWidth(AText);
end;

procedure TDCMasterDetailGrid.AutoSizeMasterColumn(ACol: Integer);
var
  I, W, MaxW: Integer;
  S: string;
begin
  if (ACol < 0) or (ACol >= FColumns.Count) then
    Exit;
  if not FColumns[ACol].Visible then
    Exit;

  MaxW := MeasureTextWidth(FColumns[ACol].Caption, FTitleFont) + (DC_DEFAULT_PADDING * 2) + 18;

  for I := 0 to FRowCount - 1 do
  begin
    S := GetDisplayText(I, ACol);
    W := MeasureTextWidth(S, Font) + (DC_DEFAULT_PADDING * 2) + 6;
    if W > MaxW then
      MaxW := W;
  end;

  FColumns[ACol].Width := Max(FMinColumnWidth, MaxW);
end;

procedure TDCMasterDetailGrid.AutoSizeDetailColumn(ACol: Integer);
var
  I, J, Rows, W, MaxW: Integer;
  S: string;
begin
  if (ACol < 0) or (ACol >= FDetailColumns.Count) then
    Exit;
  if not FDetailColumns[ACol].Visible then
    Exit;

  MaxW := MeasureTextWidth(FDetailColumns[ACol].Caption, FTitleFont) + (DC_DEFAULT_PADDING * 2) + 8;

  for I := 0 to FRowCount - 1 do
  begin
    Rows := GetDetailGridRowCount(I);
    for J := 0 to Rows - 1 do
    begin
      S := GetDetailGridCellText(I, J, ACol);
      W := MeasureTextWidth(S, FDetailFont) + (DC_DEFAULT_PADDING * 2) + 6;
      if W > MaxW then
        MaxW := W;
    end;
  end;

  FDetailColumns[ACol].Width := Max(FMinColumnWidth, MaxW);
end;

procedure TDCMasterDetailGrid.AutoSizeColumns;
var
  I: Integer;
begin
  for I := 0 to FColumns.Count - 1 do
    AutoSizeMasterColumn(I);
  if FAutoSaveLayout and not (csLoading in ComponentState) then
    SaveLayout;
  Invalidate;
end;

procedure TDCMasterDetailGrid.AutoSizeDetailColumns;
var
  I: Integer;
begin
  for I := 0 to FDetailColumns.Count - 1 do
    AutoSizeDetailColumn(I);
  if FAutoSaveLayout and not (csLoading in ComponentState) then
    SaveLayout;
  Invalidate;
end;

procedure TDCMasterDetailGrid.AutoSizeColumn(AIndex: Integer);
begin
  AutoSizeMasterColumn(AIndex);
  if FAutoSaveLayout and not (csLoading in ComponentState) then
    SaveLayout;
  Invalidate;
end;

procedure TDCMasterDetailGrid.AutoSizeDetailColumnAt(AIndex: Integer);
begin
  AutoSizeDetailColumn(AIndex);
  if FAutoSaveLayout and not (csLoading in ComponentState) then
    SaveLayout;
  Invalidate;
end;

procedure TDCMasterDetailGrid.TitleFontChanged(Sender: TObject);
begin
  Invalidate;
end;

procedure TDCMasterDetailGrid.DetailFontChanged(Sender: TObject);
begin
  Invalidate;
end;

procedure TDCMasterDetailGrid.SetAllowColumnSort(const Value: Boolean);
begin
  if FAllowColumnSort <> Value then
  begin
    FAllowColumnSort := Value;
    if not FAllowColumnSort then
    begin
      FSortedColumn := -1;
      FSortDirection := sdNone;
      Invalidate;
    end;
  end;
end;

procedure TDCMasterDetailGrid.SetSortDirection(const Value: TDCSortDirection);
begin
  if FSortDirection <> Value then
  begin
    FSortDirection := Value;
    if FAutoSaveLayout and not (csLoading in ComponentState) then
      SaveLayout;
    Invalidate;
  end;
end;

procedure TDCMasterDetailGrid.SetSortedColumn(const Value: Integer);
begin
  if Value < 0 then
  begin
    FSortedColumn := -1;
    FSortDirection := sdNone;
    Invalidate;
    Exit;
  end;

  if FSortedColumn <> Value then
  begin
    FSortedColumn := EnsureRange(Value, 0, FColumns.Count - 1);
    if FSortDirection = sdNone then
      FSortDirection := sdAscending;
    Invalidate;
  end;
end;

procedure TDCMasterDetailGrid.ToggleSortForColumn(ACol: Integer);
begin
  if (ACol < 0) or (ACol >= FColumns.Count) then
    Exit;

  if FSortedColumn <> ACol then
  begin
    FSortedColumn := ACol;
    FSortDirection := sdAscending;
  end
  else
  begin
    case FSortDirection of
      sdNone: FSortDirection := sdAscending;
      sdAscending: FSortDirection := sdDescending;
      sdDescending: FSortDirection := sdAscending;
    end;
  end;

  if Assigned(FOnSortColumn) then
    FOnSortColumn(Self, FSortedColumn, FSortDirection);

  RebuildFilter;
end;



function DCSanitizeLayoutFileName(const AValue: string): string;
var
  I: Integer;
const
  InvalidChars: TSysCharSet = ['\', '/', ':', '*', '?', '"', '<', '>', '|'];
begin
  Result := Trim(AValue);
  for I := 1 to Length(Result) do
    if CharInSet(Result[I], InvalidChars) or (Ord(Result[I]) < 32) then
      Result[I] := '_';

  Result := StringReplace(Result, ' ', '_', [rfReplaceAll]);

  if Result = '' then
    Result := 'default';
end;

function TDCMasterDetailGrid.GetDefaultLayoutsDirectory: string;
var
  BasePath: string;
begin
  BasePath := GetEnvironmentVariable('APPDATA');
  if Trim(BasePath) = '' then
    BasePath := GetEnvironmentVariable('LOCALAPPDATA');
  if Trim(BasePath) = '' then
    BasePath := ExtractFilePath(ParamStr(0));

  Result := IncludeTrailingPathDelimiter(BasePath) +
    'DelphiCreative' + PathDelim +
    'DCFlexGrid' + PathDelim +
    'Layouts';
end;

function TDCMasterDetailGrid.GetNamedLayoutFileName(const ALayoutName: string): string;
var
  LName: string;
begin
  LName := DCSanitizeLayoutFileName(ALayoutName);
  Result := IncludeTrailingPathDelimiter(GetDefaultLayoutsDirectory) + LName + '.layout';
end;

function TDCMasterDetailGrid.GetLayoutFileName: string;
begin
  if Trim(FLayoutFileName) <> '' then
    Result := FLayoutFileName
  else
    Result := ChangeFileExt(ParamStr(0), '.dcgrid.layout');
end;

function TDCMasterDetailGrid.GetLayoutSectionName: string;
begin
  if Trim(FLayoutKey) <> '' then
    Result := FLayoutKey
  else if Name <> '' then
    Result := Name
  else
    Result := ClassName;
end;

function TDCMasterDetailGrid.GetDebugLogFileName: string;
begin
  Result := ChangeFileExt(ParamStr(0), '.dcgrid.log');
end;

procedure TDCMasterDetailGrid.LogDebug(const AMessage: string);
var
  Line: string;
begin
  if not FDebugLogEnabled then
    Exit;
  Line := FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now) + ' | ' + AMessage + sLineBreak;
  TFile.AppendAllText(GetDebugLogFileName, Line, TEncoding.UTF8);
end;

procedure TDCMasterDetailGrid.SetLayoutKey(const Value: string);
begin
  if FLayoutKey <> Value then
  begin
    FLayoutKey := Value;
    if FAutoLoadLayout and not (csLoading in ComponentState) then
      LoadLayout;
  end;
end;


procedure TDCMasterDetailGrid.SetLayoutFileName(const Value: string);
begin
  if FLayoutFileName <> Value then
  begin
    FLayoutFileName := Value;
    if FAutoLoadLayout and not (csLoading in ComponentState) then
      LoadLayout;
  end;
end;

procedure TDCMasterDetailGrid.SetAutoLoadLayout(const Value: Boolean);
begin
  if FAutoLoadLayout <> Value then
  begin
    FAutoLoadLayout := Value;
    if FAutoLoadLayout and not (csLoading in ComponentState) then
      LoadLayout;
  end;
end;


function DCFooterSummaryToText(AValue: TDCFooterSummary): string;
begin
  case AValue of
    fsSum: Result := 'sum';
    fsCount: Result := 'count';
    fsAvg: Result := 'avg';
    fsMin: Result := 'min';
    fsMax: Result := 'max';
  else
    Result := 'none';
  end;
end;

function DCFormatColumnDisplayText(const AText, ADisplayFormat: string): string;
var
  LValue: Extended;
  LText: string;
  LFormatSettings: TFormatSettings;
begin
  Result := AText;
  if Trim(ADisplayFormat) = '' then
    Exit;

  LText := Trim(AText);
  if LText = '' then
    Exit;

  LFormatSettings := TFormatSettings.Create;
  if TryStrToFloat(LText, LValue, LFormatSettings) then
    Result := FormatFloat(ADisplayFormat, LValue)
  else
  begin
    LText := StringReplace(LText, '.', LFormatSettings.DecimalSeparator, [rfReplaceAll]);
    LText := StringReplace(LText, ',', LFormatSettings.DecimalSeparator, [rfReplaceAll]);
    if TryStrToFloat(LText, LValue, LFormatSettings) then
      Result := FormatFloat(ADisplayFormat, LValue);
  end;
end;

function DCTextToFooterSummary(const AValue: string; ADefault: TDCFooterSummary = fsNone): TDCFooterSummary;
var
  S: string;
begin
  Result := ADefault;
  S := Trim(AValue);
  if SameText(S, 'sum') or SameText(S, 'fsSum') then
    Result := fsSum
  else if SameText(S, 'count') or SameText(S, 'fsCount') then
    Result := fsCount
  else if SameText(S, 'avg') or SameText(S, 'average') or SameText(S, 'fsAvg') then
    Result := fsAvg
  else if SameText(S, 'min') or SameText(S, 'fsMin') then
    Result := fsMin
  else if SameText(S, 'max') or SameText(S, 'fsMax') then
    Result := fsMax
  else if SameText(S, 'none') or SameText(S, 'fsNone') or (S = '') then
    Result := fsNone;
end;

function DCAlignmentToText(AValue: TDCTextAlignment): string;
begin
  case AValue of
    taCenter: Result := 'center';
    taRight: Result := 'right';
  else
    Result := 'left';
  end;
end;

function DCTextToAlignment(const AValue: string; ADefault: TDCTextAlignment = taLeft): TDCTextAlignment;
var
  S: string;
begin
  Result := ADefault;
  S := Trim(AValue);
  if SameText(S, 'center') or SameText(S, 'taCenter') then
    Result := taCenter
  else if SameText(S, 'right') or SameText(S, 'taRight') then
    Result := taRight
  else if SameText(S, 'left') or SameText(S, 'taLeft') then
    Result := taLeft;
end;

function DCSortDirectionToText(AValue: TDCSortDirection): string;
begin
  case AValue of
    sdAscending: Result := 'ascending';
    sdDescending: Result := 'descending';
  else
    Result := 'none';
  end;
end;

function DCTextToSortDirection(const AValue: string; ADefault: TDCSortDirection = sdNone): TDCSortDirection;
begin
  Result := ADefault;
  if SameText(AValue, 'ascending') or SameText(AValue, 'asc') or SameText(AValue, 'sdAscending') then
    Result := sdAscending
  else if SameText(AValue, 'descending') or SameText(AValue, 'desc') or SameText(AValue, 'sdDescending') then
    Result := sdDescending
  else if SameText(AValue, 'none') or SameText(AValue, 'sdNone') or (Trim(AValue) = '') then
    Result := sdNone;
end;

function DCFilterModeToText(AValue: TDCFilterMode): string;
begin
  case AValue of
    fmStartsWith: Result := 'startsWith';
    fmEquals: Result := 'equals';
  else
    Result := 'contains';
  end;
end;

function DCTextToFilterMode(const AValue: string; ADefault: TDCFilterMode = fmContains): TDCFilterMode;
begin
  Result := ADefault;
  if SameText(AValue, 'startsWith') or SameText(AValue, 'fmStartsWith') then
    Result := fmStartsWith
  else if SameText(AValue, 'equals') or SameText(AValue, 'fmEquals') then
    Result := fmEquals
  else if SameText(AValue, 'contains') or SameText(AValue, 'fmContains') then
    Result := fmContains;
end;

function DCSearchScopeToText(AValue: TDCSearchScope): string;
begin
  case AValue of
    ssMasterAndDetail: Result := 'masterAndDetail';
  else
    Result := 'masterOnly';
  end;
end;

function DCTextToSearchScope(const AValue: string; ADefault: TDCSearchScope = ssMasterOnly): TDCSearchScope;
begin
  Result := ADefault;
  if SameText(AValue, 'masterAndDetail') or SameText(AValue, 'ssMasterAndDetail') then
    Result := ssMasterAndDetail
  else if SameText(AValue, 'masterOnly') or SameText(AValue, 'ssMasterOnly') then
    Result := ssMasterOnly;
end;

function DCGetJSONValueText(AObject: TJSONObject; const AName, ADefault: string): string;
var
  LValue: TJSONValue;
begin
  Result := ADefault;
  if AObject = nil then
    Exit;
  LValue := AObject.GetValue(AName);
  if LValue <> nil then
    Result := LValue.Value;
end;

function DCFindColumnByFieldName(AColumns: TDCGridColumns; const AFieldName: string): TDCGridColumn;
var
  I: Integer;
begin
  Result := nil;
  if (AColumns = nil) or (Trim(AFieldName) = '') then
    Exit;
  for I := 0 to AColumns.Count - 1 do
    if SameText(AColumns[I].FieldName, AFieldName) then
      Exit(AColumns[I]);
end;

procedure DCSaveColumnToJSON(AColumn: TDCGridColumn; AArray: TJSONArray);
var
  LItem: TJSONObject;
begin
  if (AColumn = nil) or (AArray = nil) then
    Exit;

  LItem := TJSONObject.Create;
  LItem.AddPair('field', AColumn.FieldName);
  LItem.AddPair('caption', AColumn.Caption);
  LItem.AddPair('width', TJSONNumber.Create(AColumn.Width));
  LItem.AddPair('visible', TJSONBool.Create(AColumn.Visible));
  LItem.AddPair('alignment', DCAlignmentToText(AColumn.Alignment));
  if Trim(AColumn.DisplayFormat) <> '' then
    LItem.AddPair('displayFormat', AColumn.DisplayFormat);
  LItem.AddPair('footerSummary', DCFooterSummaryToText(AColumn.FooterSummary));
  if Trim(AColumn.FilterText) <> '' then
    LItem.AddPair('filterText', AColumn.FilterText);
  AArray.AddElement(LItem);
end;

procedure DCApplyColumnFromJSON(AColumn: TDCGridColumn; AObject: TJSONObject);
var
  S: string;
  W: Integer;
begin
  if (AColumn = nil) or (AObject = nil) then
    Exit;

  S := DCGetJSONValueText(AObject, 'field', AColumn.FieldName);
  if Trim(S) <> '' then
    AColumn.FieldName := S;

  S := DCGetJSONValueText(AObject, 'caption', AColumn.Caption);
  if S <> '' then
    AColumn.Caption := S;

  W := StrToIntDef(DCGetJSONValueText(AObject, 'width', IntToStr(AColumn.Width)), AColumn.Width);
  if W > 0 then
    AColumn.Width := W;

  S := DCGetJSONValueText(AObject, 'visible', BoolToStr(AColumn.Visible, True));
  AColumn.Visible := SameText(S, 'true') or SameText(S, '1');

  AColumn.Alignment := DCTextToAlignment(DCGetJSONValueText(AObject, 'alignment', DCAlignmentToText(AColumn.Alignment)), AColumn.Alignment);
  AColumn.DisplayFormat := DCGetJSONValueText(AObject, 'displayFormat', AColumn.DisplayFormat);
  AColumn.FooterSummary := DCTextToFooterSummary(DCGetJSONValueText(AObject, 'footerSummary', DCFooterSummaryToText(AColumn.FooterSummary)), AColumn.FooterSummary);
  AColumn.FilterText := DCGetJSONValueText(AObject, 'filterText', AColumn.FilterText);
end;

function TDCMasterDetailGrid.SaveToJSON: string;
var
  LRoot: TJSONObject;
  LGrid: TJSONObject;
  LColumns: TJSONArray;
  LDetailColumns: TJSONArray;
  LBusinessHighlightValue: TJSONValue;
  I: Integer;
begin
  LRoot := TJSONObject.Create;
  try
    LRoot.AddPair('schema', 'DCFlexGrid.Config');
    LRoot.AddPair('version', TJSONNumber.Create(1));

    LGrid := TJSONObject.Create;
    LGrid.AddPair('showToolbar', TJSONBool.Create(FShowToolbar));
    LGrid.AddPair('toolbarHeight', TJSONNumber.Create(FToolbarHeight));
    LGrid.AddPair('showToolbarRulesDesignerButton', TJSONBool.Create(FShowToolbarRulesDesignerButton));
    LGrid.AddPair('showFooter', TJSONBool.Create(FShowFooter));
    LGrid.AddPair('footerHeight', TJSONNumber.Create(FFooterHeight));
    LGrid.AddPair('showColumnFilters', TJSONBool.Create(FShowColumnFilters));
    LGrid.AddPair('columnFilterHeight', TJSONNumber.Create(FColumnFilterHeight));
    LGrid.AddPair('showHeader', TJSONBool.Create(FShowHeader));
    LGrid.AddPair('showHeaderColumnLines', TJSONBool.Create(FShowHeaderColumnLines));
    LGrid.AddPair('showRowColumnLines', TJSONBool.Create(FShowRowColumnLines));
    LGrid.AddPair('frozenColumns', TJSONNumber.Create(FFrozenColumns));
    LGrid.AddPair('allowHeaderFooterSummaryMenu', TJSONBool.Create(FAllowHeaderFooterSummaryMenu));
    LGrid.AddPair('showExpandButton', TJSONBool.Create(FShowExpandButton));
    LGrid.AddPair('alternateColors', TJSONBool.Create(FAlternateColors));
    LGrid.AddPair('expandOnRowClick', TJSONBool.Create(FExpandOnRowClick));
    LGrid.AddPair('filterMode', DCFilterModeToText(FFilterMode));
    LGrid.AddPair('searchScope', DCSearchScopeToText(FSearchScope));
    LGrid.AddPair('autoExpandOnSearch', TJSONBool.Create(FAutoExpandOnSearch));
    LGrid.AddPair('sortedColumn', TJSONNumber.Create(FSortedColumn));
    LGrid.AddPair('sortDirection', DCSortDirectionToText(FSortDirection));
    LRoot.AddPair('grid', LGrid);

    LColumns := TJSONArray.Create;
    for I := 0 to FColumns.Count - 1 do
      DCSaveColumnToJSON(FColumns[I], LColumns);
    LRoot.AddPair('columns', LColumns);

    LDetailColumns := TJSONArray.Create;
    for I := 0 to FDetailColumns.Count - 1 do
      DCSaveColumnToJSON(FDetailColumns[I], LDetailColumns);
    LRoot.AddPair('detailColumns', LDetailColumns);

    if Assigned(FBusinessHighlight) then
    begin
      LBusinessHighlightValue := TJSONObject.ParseJSONValue(FBusinessHighlight.ToJSON);
      if LBusinessHighlightValue <> nil then
        LRoot.AddPair('businessHighlight', LBusinessHighlightValue);
    end;

    Result := LRoot.ToJSON;
  finally
    LRoot.Free;
  end;
end;

procedure TDCMasterDetailGrid.LoadFromJSON(const AJSON: string);
var
  LValue: TJSONValue;
  LRoot: TJSONObject;
  LGrid: TJSONObject;
  LColumns: TJSONArray;
  LItem: TJSONObject;
  LColumn: TDCGridColumn;
  LFieldName: string;
  I: Integer;
  LBoolText: string;
  LIntValue: Integer;
  LBusinessHighlightValue: TJSONValue;
  LOldAutoSave: Boolean;
begin
  if Trim(AJSON) = '' then
    Exit;

  LValue := TJSONObject.ParseJSONValue(AJSON);
  if not (LValue is TJSONObject) then
  begin
    LValue.Free;
    Exit;
  end;

  try
    LOldAutoSave := FAutoSaveLayout;
    FAutoSaveLayout := False;
    try
      LRoot := TJSONObject(LValue);

      if LRoot.TryGetValue<TJSONObject>('grid', LGrid) then
      begin
        LBoolText := DCGetJSONValueText(LGrid, 'showToolbar', BoolToStr(FShowToolbar, True));
        SetShowToolbar(SameText(LBoolText, 'true') or SameText(LBoolText, '1'));

        LIntValue := StrToIntDef(DCGetJSONValueText(LGrid, 'toolbarHeight', IntToStr(FToolbarHeight)), FToolbarHeight);
        SetToolbarHeight(LIntValue);

        LBoolText := DCGetJSONValueText(LGrid, 'showToolbarRulesDesignerButton', BoolToStr(FShowToolbarRulesDesignerButton, True));
        SetShowToolbarRulesDesignerButton(SameText(LBoolText, 'true') or SameText(LBoolText, '1'));

        LBoolText := DCGetJSONValueText(LGrid, 'showFooter', BoolToStr(FShowFooter, True));
        SetShowFooter(SameText(LBoolText, 'true') or SameText(LBoolText, '1'));

        LIntValue := StrToIntDef(DCGetJSONValueText(LGrid, 'footerHeight', IntToStr(FFooterHeight)), FFooterHeight);
        SetFooterHeight(LIntValue);

        LBoolText := DCGetJSONValueText(LGrid, 'showColumnFilters', BoolToStr(FShowColumnFilters, True));
        SetShowColumnFilters(SameText(LBoolText, 'true') or SameText(LBoolText, '1'));

        LIntValue := StrToIntDef(DCGetJSONValueText(LGrid, 'columnFilterHeight', IntToStr(FColumnFilterHeight)), FColumnFilterHeight);
        SetColumnFilterHeight(LIntValue);

        LBoolText := DCGetJSONValueText(LGrid, 'showHeader', BoolToStr(FShowHeader, True));
        SetShowHeader(SameText(LBoolText, 'true') or SameText(LBoolText, '1'));

        LBoolText := DCGetJSONValueText(LGrid, 'showHeaderColumnLines', BoolToStr(FShowHeaderColumnLines, True));
        SetShowHeaderColumnLines(SameText(LBoolText, 'true') or SameText(LBoolText, '1'));

        LBoolText := DCGetJSONValueText(LGrid, 'showRowColumnLines', BoolToStr(FShowRowColumnLines, True));
        SetShowRowColumnLines(SameText(LBoolText, 'true') or SameText(LBoolText, '1'));

        LIntValue := StrToIntDef(DCGetJSONValueText(LGrid, 'frozenColumns', IntToStr(FFrozenColumns)), FFrozenColumns);
        SetFrozenColumns(LIntValue);

        LBoolText := DCGetJSONValueText(LGrid, 'allowHeaderFooterSummaryMenu', BoolToStr(FAllowHeaderFooterSummaryMenu, True));
        SetAllowHeaderFooterSummaryMenu(SameText(LBoolText, 'true') or SameText(LBoolText, '1'));

        LBoolText := DCGetJSONValueText(LGrid, 'showExpandButton', BoolToStr(FShowExpandButton, True));
        SetShowExpandButton(SameText(LBoolText, 'true') or SameText(LBoolText, '1'));

        LBoolText := DCGetJSONValueText(LGrid, 'alternateColors', BoolToStr(FAlternateColors, True));
        SetAlternateColors(SameText(LBoolText, 'true') or SameText(LBoolText, '1'));

        LBoolText := DCGetJSONValueText(LGrid, 'expandOnRowClick', BoolToStr(FExpandOnRowClick, True));
        SetExpandOnRowClick(SameText(LBoolText, 'true') or SameText(LBoolText, '1'));

        LBoolText := DCGetJSONValueText(LGrid, 'autoExpandOnSearch', BoolToStr(FAutoExpandOnSearch, True));
        SetAutoExpandOnSearch(SameText(LBoolText, 'true') or SameText(LBoolText, '1'));

        SetFilterMode(DCTextToFilterMode(DCGetJSONValueText(LGrid, 'filterMode', DCFilterModeToText(FFilterMode)), FFilterMode));
        SetSearchScope(DCTextToSearchScope(DCGetJSONValueText(LGrid, 'searchScope', DCSearchScopeToText(FSearchScope)), FSearchScope));

        LIntValue := StrToIntDef(DCGetJSONValueText(LGrid, 'sortedColumn', IntToStr(FSortedColumn)), FSortedColumn);
        SetSortedColumn(LIntValue);
        SetSortDirection(DCTextToSortDirection(DCGetJSONValueText(LGrid, 'sortDirection', DCSortDirectionToText(FSortDirection)), FSortDirection));
      end;

      if LRoot.TryGetValue<TJSONArray>('columns', LColumns) then
      begin
        for I := 0 to LColumns.Count - 1 do
        begin
          if not (LColumns.Items[I] is TJSONObject) then
            Continue;
          LItem := TJSONObject(LColumns.Items[I]);
          LFieldName := DCGetJSONValueText(LItem, 'field', '');
          LColumn := DCFindColumnByFieldName(FColumns, LFieldName);
          if (LColumn = nil) and (I < FColumns.Count) then
            LColumn := FColumns[I];
          if LColumn = nil then
            LColumn := FColumns.Add;
          DCApplyColumnFromJSON(LColumn, LItem);
        end;
      end;

      if LRoot.TryGetValue<TJSONArray>('detailColumns', LColumns) then
      begin
        for I := 0 to LColumns.Count - 1 do
        begin
          if not (LColumns.Items[I] is TJSONObject) then
            Continue;
          LItem := TJSONObject(LColumns.Items[I]);
          LFieldName := DCGetJSONValueText(LItem, 'field', '');
          LColumn := DCFindColumnByFieldName(FDetailColumns, LFieldName);
          if (LColumn = nil) and (I < FDetailColumns.Count) then
            LColumn := FDetailColumns[I];
          if LColumn = nil then
            LColumn := FDetailColumns.Add;
          DCApplyColumnFromJSON(LColumn, LItem);
        end;
      end;

      LBusinessHighlightValue := LRoot.GetValue('businessHighlight');
      if (LBusinessHighlightValue <> nil) and Assigned(FBusinessHighlight) then
        FBusinessHighlight.FromJSON(LBusinessHighlightValue.ToJSON);

      UpdateToolbarLayout;
      RebuildFilter;
      UpdateScrollBar;
      Invalidate;
    finally
      FAutoSaveLayout := LOldAutoSave;
    end;
  except
    on E: Exception do
      LogDebug('LoadFromJSON ignored invalid JSON/config: ' + E.Message);
  end;
  LValue.Free;
end;

procedure TDCMasterDetailGrid.SaveConfigToFile(const AFileName: string);
begin
  if Trim(AFileName) = '' then
    Exit;
  if ExtractFilePath(AFileName) <> '' then
    TDirectory.CreateDirectory(ExtractFilePath(AFileName));
  TFile.WriteAllText(AFileName, SaveToJSON, TEncoding.UTF8);
end;

procedure TDCMasterDetailGrid.LoadConfigFromFile(const AFileName: string);
begin
  if (Trim(AFileName) = '') or (not TFile.Exists(AFileName)) then
    Exit;
  LoadFromJSON(TFile.ReadAllText(AFileName, TEncoding.UTF8));
end;

procedure TDCMasterDetailGrid.SaveLayout(const ALayoutName: string);
begin
  if Trim(ALayoutName) = '' then
    Exit;
  SaveConfigToFile(GetNamedLayoutFileName(ALayoutName));
end;

procedure TDCMasterDetailGrid.LoadLayout(const ALayoutName: string);
begin
  if Trim(ALayoutName) = '' then
    Exit;
  LoadConfigFromFile(GetNamedLayoutFileName(ALayoutName));
end;

procedure TDCMasterDetailGrid.ResetLayout(const ALayoutName: string);
var
  LFileName: string;
begin
  if Trim(ALayoutName) = '' then
    Exit;

  LFileName := GetNamedLayoutFileName(ALayoutName);
  if TFile.Exists(LFileName) then
    TFile.Delete(LFileName);
end;


procedure TDCMasterDetailGrid.SetAutoSaveLayout(const Value: Boolean);
begin
  FAutoSaveLayout := Value;
end;

procedure TDCMasterDetailGrid.SaveLayout;
begin
  SaveConfigToFile(GetLayoutFileName);
end;

procedure TDCMasterDetailGrid.LoadLayout;
begin
  if not FileExists(GetLayoutFileName) then
    Exit;

  LoadConfigFromFile(GetLayoutFileName);
end;

procedure TDCMasterDetailGrid.ResetLayout;
begin
  if TFile.Exists(GetLayoutFileName) then
    TFile.Delete(GetLayoutFileName);
end;


function TDCMasterDetailGrid.GetFilteredRowCount: Integer;
begin
  if UsesRowMap then
    Result := FFilteredRows.Count
  else
    Result := FRowCount;
end;

function TDCMasterDetailGrid.GetActualRowCount: Integer;
begin
  Result := GetFilteredRowCount;
end;

function TDCMasterDetailGrid.GetActualRowIndex(AVisibleRow: Integer): Integer;
begin
  if UsesRowMap then
  begin
    if (AVisibleRow >= 0) and (AVisibleRow < FFilteredRows.Count) then
      Result := FFilteredRows[AVisibleRow]
    else
      Result := -1;
  end
  else
    Result := AVisibleRow;
end;

function TDCMasterDetailGrid.GetVisibleIndexOfActualRow(AActualRow: Integer): Integer;
begin
  if UsesRowMap then
    Result := FFilteredRows.IndexOf(AActualRow)
  else
    Result := AActualRow;
end;

function TDCMasterDetailGrid.UsesRowMap: Boolean;
begin
  Result := (Trim(FSearchText) <> '') or HasColumnFilters or
    ((FSortedColumn >= 0) and (FSortDirection <> sdNone));
end;

procedure TDCMasterDetailGrid.SortFilteredRows;
var
  LColumn: Integer;
  LDirection: TDCSortDirection;
begin
  if (FSortedColumn < 0) or (FSortedColumn >= FColumns.Count) or
    (FSortDirection = sdNone) then
    Exit;

  LColumn := FSortedColumn;
  LDirection := FSortDirection;
  FFilteredRows.Sort(TComparer<Integer>.Construct(
    function(const Left, Right: Integer): Integer
    var
      LLeftText: string;
      LRightText: string;
      LLeftNumber: Double;
      LRightNumber: Double;
      LLeftIsNumber: Boolean;
      LRightIsNumber: Boolean;
    begin
      LLeftText := GetDisplayText(Left, LColumn);
      LRightText := GetDisplayText(Right, LColumn);
      LLeftIsNumber := DCTryParseFlexibleFloat(LLeftText, LLeftNumber);
      LRightIsNumber := DCTryParseFlexibleFloat(LRightText, LRightNumber);

      if LLeftIsNumber and LRightIsNumber then
      begin
        if LLeftNumber < LRightNumber then
          Result := -1
        else if LLeftNumber > LRightNumber then
          Result := 1
        else
          Result := 0;
      end
      else
        Result := CompareText(LLeftText, LRightText);

      if LDirection = sdDescending then
        Result := -Result;
    end));
end;

function TDCMasterDetailGrid.DetailMatchesSearch(AMasterRow: Integer): Boolean;
var
  R, C: Integer;
  S: string;
begin
  Result := False;
  if (Trim(FSearchText) = '') or (FSearchScope <> ssMasterAndDetail) then
    Exit;

  for R := 0 to GetDetailGridRowCount(AMasterRow) - 1 do
  begin
    for C := 0 to FDetailColumns.Count - 1 do
    begin
      if not FDetailColumns[C].Visible then
        Continue;
      S := GetDetailGridCellText(AMasterRow, R, C);
      case FFilterMode of
        fmContains: Result := ContainsTextEx(S, FSearchText);
        fmStartsWith: Result := SameText(Copy(S, 1, Length(FSearchText)), FSearchText);
        fmEquals: Result := SameText(S, FSearchText);
      end;
      if Result then
        Exit;
    end;
  end;
end;

function TDCMasterDetailGrid.RowMatchesSearch(ARow: Integer): Boolean;
var
  I: Integer;
  S: string;
begin
  if not RowMatchesColumnFilters(ARow) then
    Exit(False);

  if Trim(FSearchText) = '' then
    Exit(True);

  Result := False;
  for I := 0 to FColumns.Count - 1 do
  begin
    if not FColumns[I].Visible then
      Continue;
    S := GetDisplayText(ARow, I);
    case FFilterMode of
      fmContains: Result := ContainsTextEx(S, FSearchText);
      fmStartsWith: Result := SameText(Copy(S, 1, Length(FSearchText)), FSearchText);
      fmEquals: Result := SameText(S, FSearchText);
    end;
    if Result then
      Exit;
  end;

  if not Result then
    Result := DetailMatchesSearch(ARow);
end;

procedure TDCMasterDetailGrid.RebuildFilter;
var
  I: Integer;
begin
  FFilteredRows.Clear;
  FTopRow := 0;

  if (Trim(FSearchText) <> '') or HasColumnFilters then
  begin
    { During active filtering, keep layout stable by collapsing expanded rows.
      AutoExpandOnSearch may selectively reopen matching rows below. }
    FExpandedRows.Clear;
    FExpandedRow := -1;

    for I := 0 to FRowCount - 1 do
      if RowMatchesSearch(I) then
      begin
        FFilteredRows.Add(I);
        if FAutoExpandOnSearch and RowMatchesSearch(I) and (FExpandedRows.IndexOf(I) = -1) then
          FExpandedRows.Add(I);
      end;

    if FExpandedRows.Count > 0 then
      FExpandedRow := FExpandedRows.Last;
  end
  else
  begin
    if (FSortedColumn >= 0) and (FSortDirection <> sdNone) then
      for I := 0 to FRowCount - 1 do
        FFilteredRows.Add(I);

    if FAutoExpandOnSearch then
    begin
      FExpandedRows.Clear;
      FExpandedRow := -1;
    end;
  end;

  SortFilteredRows;

  if (FSelectedRow <> -1) and UsesRowMap and (FFilteredRows.IndexOf(FSelectedRow) = -1) then
    FSelectedRow := -1;

  if FTopRow > MaxTopRow then
    FTopRow := MaxTopRow;
  UpdateScrollBar;
  Invalidate;
end;


procedure TDCMasterDetailGrid.EnsureColumnFilterEditors;
var
  I: Integer;
  LEdit: TEdit;
begin
  if FColumnFilterEdits = nil then
    FColumnFilterEdits := TObjectList<TEdit>.Create(True);

  while FColumnFilterEdits.Count < FColumns.Count do
  begin
    LEdit := TEdit.Create(Self);
    LEdit.ControlStyle := LEdit.ControlStyle + [csNoDesignVisible];
    if Assigned(FColumnFilterPanel) then
      LEdit.Parent := FColumnFilterPanel
    else
      LEdit.Parent := Self;
    LEdit.Visible := False;
    LEdit.Text := '';
    LEdit.TabStop := True;
    LEdit.OnChange := ColumnFilterChanged;
    LEdit.Tag := FColumnFilterEdits.Count;
    FColumnFilterEdits.Add(LEdit);
  end;

  while FColumnFilterEdits.Count > FColumns.Count do
    FColumnFilterEdits.Delete(FColumnFilterEdits.Count - 1);

  for I := 0 to FColumnFilterEdits.Count - 1 do
  begin
    FColumnFilterEdits[I].Tag := I;
    if (I < FColumns.Count) and (FColumnFilterEdits[I].Text <> FColumns[I].FilterText) then
    begin
      FUpdatingColumnFilters := True;
      try
        FColumnFilterEdits[I].Text := FColumns[I].FilterText;
      finally
        FUpdatingColumnFilters := False;
      end;
    end;
  end;
end;

procedure TDCMasterDetailGrid.UpdateColumnFilterLayout;
var
  I: Integer;
  R: TRect;
  LEdit: TEdit;
  LCol: TDCGridColumn;
  LEditHeight: Integer;
  LTop: Integer;
  LScrollableLeft: Integer;
  LPanelWidth: Integer;
  LEditLeft: Integer;
  LEditTop: Integer;
  LFrozenBoundary: Integer;
  LColLeft: Integer;
  LEditWidth: Integer;
begin
  if not Assigned(FColumnFilterEdits) then
    Exit;

  EnsureColumnFilterEditors;

  for I := 0 to FColumnFilterEdits.Count - 1 do
    FColumnFilterEdits[I].Visible := False;

  if Assigned(FColumnFilterPanel) then
    FColumnFilterPanel.Visible := False;

  if not FShowColumnFilters then
    Exit;

  R := GetColumnFiltersRect;
  if (R.Bottom <= R.Top) or (R.Right <= R.Left) then
    Exit;

  LFrozenBoundary := GetFrozenColumnsBoundaryX(R.Left);
  LScrollableLeft := LFrozenBoundary;

  { The scrollable filter editors must be clipped after the frozen area. When no
    columns are frozen, the fixed area is only the expand/indicator column. }
  if FFrozenColumns <= 0 then
  begin
    LScrollableLeft := R.Left;
    if FShowExpandButton then
      Inc(LScrollableLeft, DC_DEFAULT_EXPAND_COL_WIDTH);
  end;

  LPanelWidth := R.Right - LScrollableLeft;
  if LPanelWidth <= 0 then
    Exit;

  if Assigned(FColumnFilterPanel) then
  begin
    FColumnFilterPanel.SetBounds(LScrollableLeft, R.Top, LPanelWidth, R.Bottom - R.Top);
    FColumnFilterPanel.BevelOuter := bvNone;
    FColumnFilterPanel.Color := BlendColor(FTheme.GridBackgroundColor, clWhite, 18);
    FColumnFilterPanel.ParentColor := False;
    FColumnFilterPanel.Visible := True;
    FColumnFilterPanel.BringToFront;
  end;

  LEditHeight := Max(23, Min(28, (R.Bottom - R.Top) - 6));
  LTop := ((R.Bottom - R.Top) - LEditHeight) div 2;

  for I := 0 to FColumns.Count - 1 do
  begin
    if I >= FColumnFilterEdits.Count then
      Break;

    LCol := FColumns[I];
    LEdit := FColumnFilterEdits[I];
    LEdit.Visible := False;

    if (not LCol.Visible) or (not FShowColumnFilters) or (LCol.Width < 42) then
      Continue;

    LColLeft := GetColumnDrawLeft(I, R.Left);
    LEditWidth := Max(24, LCol.Width - 10);

    if IsFrozenColumn(I) then
    begin
      { Frozen column filters are native controls parented directly to the grid,
        so they remain fixed and stay above the scrollable filter panel. }
      if LEdit.Parent <> Self then
        LEdit.Parent := Self;

      LEditLeft := LColLeft + 5;
      LEditTop := R.Top + LTop;

      if (LEditLeft + LEditWidth <= R.Left) or (LEditLeft >= LFrozenBoundary) then
        Continue;
    end
    else
    begin
      { Scrollable filters live inside FColumnFilterPanel. Their Left may be
        negative while the column is partially scrolled out; the panel clips the
        native edit correctly without shrinking it. }
      if Assigned(FColumnFilterPanel) and (LEdit.Parent <> FColumnFilterPanel) then
        LEdit.Parent := FColumnFilterPanel;

      LEditLeft := LColLeft - LScrollableLeft + 5;
      LEditTop := LTop;

      if (LEditLeft + LEditWidth <= 0) or (LEditLeft >= LPanelWidth) then
        Continue;
    end;

    LEdit.TextHint := DCColumnFilterHint(GetCurrentLanguage, FRulesDesignerLanguage, LCol.Caption);
    LEdit.Font.Assign(Font);
    LEdit.Font.Color := FTheme.TextColor;
    LEdit.Color := FTheme.RowColor;
    LEdit.ParentColor := False;
    LEdit.Enabled := True;
    LEdit.TabStop := True;
    LEdit.SetBounds(LEditLeft, LEditTop, LEditWidth, LEditHeight);
    LEdit.Visible := True;
    LEdit.BringToFront;
  end;
end;

procedure TDCMasterDetailGrid.ClearColumnFilterEditors;
var
  I: Integer;
begin
  if not Assigned(FColumnFilterEdits) then
    Exit;
  for I := 0 to FColumnFilterEdits.Count - 1 do
    FColumnFilterEdits[I].Visible := False;
  if Assigned(FColumnFilterPanel) then
    FColumnFilterPanel.Visible := False;
end;

function TDCMasterDetailGrid.HasColumnFilters: Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to FColumns.Count - 1 do
    if Trim(FColumns[I].FilterText) <> '' then
      Exit(True);
end;

function TDCMasterDetailGrid.RowMatchesColumnFilters(ARow: Integer): Boolean;
var
  I: Integer;
  LFilter: string;
  LText: string;
  LMatch: Boolean;
begin
  Result := True;
  for I := 0 to FColumns.Count - 1 do
  begin
    if not FColumns[I].Visible then
      Continue;

    LFilter := Trim(FColumns[I].FilterText);
    if LFilter = '' then
      Continue;

    LText := GetDisplayText(ARow, I);
    case FFilterMode of
      fmStartsWith: LMatch := SameText(Copy(LText, 1, Length(LFilter)), LFilter);
      fmEquals: LMatch := SameText(LText, LFilter);
    else
      LMatch := ContainsTextEx(LText, LFilter);
    end;

    if not LMatch then
      Exit(False);
  end;
end;

function TDCMasterDetailGrid.GetColumnFilterText(ACol: Integer): string;
begin
  if (ACol >= 0) and (ACol < FColumns.Count) then
    Result := FColumns[ACol].FilterText
  else
    Result := '';
end;

procedure TDCMasterDetailGrid.SetColumnFilterText(ACol: Integer; const AText: string);
begin
  if (ACol < 0) or (ACol >= FColumns.Count) then
    Exit;

  if FColumns[ACol].FilterText <> AText then
  begin
    FColumns[ACol].FilterText := AText;
    if Assigned(FColumnFilterEdits) and (ACol < FColumnFilterEdits.Count) and
       (FColumnFilterEdits[ACol].Text <> AText) then
    begin
      FUpdatingColumnFilters := True;
      try
        FColumnFilterEdits[ACol].Text := AText;
      finally
        FUpdatingColumnFilters := False;
      end;
    end;
    RebuildFilter;
  end;
end;

procedure TDCMasterDetailGrid.ColumnFilterChanged(Sender: TObject);
var
  LIndex: Integer;
  LEdit: TEdit;
  LSelStart: Integer;
  LSelLength: Integer;
begin
  if FUpdatingColumnFilters then
    Exit;

  if not (Sender is TEdit) then
    Exit;

  LEdit := TEdit(Sender);
  LIndex := LEdit.Tag;
  if (LIndex < 0) or (LIndex >= FColumns.Count) then
    Exit;

  if FColumns[LIndex].FilterText = LEdit.Text then
    Exit;

  LSelStart := LEdit.SelStart;
  LSelLength := LEdit.SelLength;

  FColumns[LIndex].FilterText := LEdit.Text;
  RebuildFilter;

  { RebuildFilter invalidates the grid. Keep the active filter editor focused so
    typing does not require clicking again after each character. }
  if LEdit.HandleAllocated and LEdit.Visible and LEdit.Enabled then
  begin
    if LEdit.CanFocus then
      LEdit.SetFocus;
    LEdit.SelStart := LSelStart;
    LEdit.SelLength := LSelLength;
  end;
end;

procedure TDCMasterDetailGrid.SetShowColumnFilters(const Value: Boolean);
begin
  if FShowColumnFilters <> Value then
  begin
    FShowColumnFilters := Value;
    UpdateColumnFilterLayout;
    UpdateScrollBar;
    if FAutoSaveLayout and not (csLoading in ComponentState) then
      SaveLayout;
    Invalidate;
  end;
end;

procedure TDCMasterDetailGrid.SetColumnFilterHeight(const Value: Integer);
begin
  if FColumnFilterHeight <> Value then
  begin
    FColumnFilterHeight := Max(26, Value);
    UpdateColumnFilterLayout;
    UpdateScrollBar;
    if FAutoSaveLayout and not (csLoading in ComponentState) then
      SaveLayout;
    Invalidate;
  end;
end;

procedure TDCMasterDetailGrid.ClearColumnFilters;
var
  I: Integer;
begin
  FUpdatingColumnFilters := True;
  try
    for I := 0 to FColumns.Count - 1 do
      FColumns[I].FilterText := '';
    if Assigned(FColumnFilterEdits) then
      for I := 0 to FColumnFilterEdits.Count - 1 do
        FColumnFilterEdits[I].Text := '';
  finally
    FUpdatingColumnFilters := False;
  end;
  RebuildFilter;
end;

procedure TDCMasterDetailGrid.SetColumnFilter(const AFieldName, AText: string);
var
  I: Integer;
begin
  for I := 0 to FColumns.Count - 1 do
    if SameText(FColumns[I].FieldName, AFieldName) then
    begin
      SetColumnFilterText(I, AText);
      Exit;
    end;
end;

procedure TDCMasterDetailGrid.SetColumnFilter(ACol: Integer; const AText: string);
begin
  SetColumnFilterText(ACol, AText);
end;

function TDCMasterDetailGrid.GetColumnFilter(const AFieldName: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to FColumns.Count - 1 do
    if SameText(FColumns[I].FieldName, AFieldName) then
      Exit(FColumns[I].FilterText);
end;

function TDCMasterDetailGrid.GetColumnFilter(ACol: Integer): string;
begin
  Result := GetColumnFilterText(ACol);
end;

procedure TDCMasterDetailGrid.SetSearchText(const Value: string);
begin
  if FSearchText <> Value then
  begin
    FSearchText := Value;

    if Assigned(FToolbarSearchEdit) and (FToolbarSearchEdit.Text <> Value) then
    begin
      FUpdatingToolbarSearch := True;
      try
        FToolbarSearchEdit.Text := Value;
      finally
        FUpdatingToolbarSearch := False;
      end;
    end;

    RebuildFilter;
  end;
end;

procedure TDCMasterDetailGrid.SetFilterMode(const Value: TDCFilterMode);
begin
  if FFilterMode <> Value then
  begin
    FFilterMode := Value;
    RebuildFilter;
  end;
end;

procedure TDCMasterDetailGrid.SetSearchScope(const Value: TDCSearchScope);
begin
  if FSearchScope <> Value then
  begin
    FSearchScope := Value;
    RebuildFilter;
  end;
end;

procedure TDCMasterDetailGrid.SetAutoExpandOnSearch(const Value: Boolean);
begin
  if FAutoExpandOnSearch <> Value then
  begin
    FAutoExpandOnSearch := Value;
    RebuildFilter;
  end;
end;

procedure TDCMasterDetailGrid.SetDataSetAdapter(const Value: TDCDataSetAdapter);
begin
  if FDataSetAdapter <> Value then
  begin
    FDataSetAdapter.Assign(Value);
    SetDataAdapter(FDataSetAdapter);
  end
  else
    SetDataAdapter(FDataSetAdapter);
end;


procedure TDCMasterDetailGrid.SetBusinessHighlight(const Value: TDCBusinessHighlight);
begin
  if Assigned(Value) then
    FBusinessHighlight.Assign(Value)
  else
    FBusinessHighlight.Clear;
  Invalidate;
end;

procedure TDCMasterDetailGrid.SetDataAdapter(const Value: TDCGridDataAdapter);
begin
  if FDataAdapter <> Value then
  begin
    FDataAdapter := Value;
    if Assigned(FDataAdapter) then
      FRowCount := Max(0, FDataAdapter.GetMasterRowCount)
    else if csDesigning in ComponentState then
      FRowCount := 0;
    RebuildFilter;
    RefreshGrid;
  end;
end;

procedure TDCMasterDetailGrid.ThemeChanged;
begin
  UpdateColumnFilterLayout;
  UpdateToolbarLayout;
  Invalidate;
end;

procedure TDCMasterDetailGrid.ToggleRowExpand(ARow: Integer);
begin
  if IsRowExpanded(ARow) then
    CollapseRow(ARow)
  else
    ExpandRow(ARow);
end;


procedure TDCMasterDetailGrid.SetRulesDesignerLanguage(const Value: TDCRulesDesignerLanguage);
begin
  if FRulesDesignerLanguage <> Value then
  begin
    FRulesDesignerLanguage := Value;
    UpdateToolbarLanguage;
  end;
end;

procedure TDCMasterDetailGrid.LanguageSourceChange(Sender: TObject);
begin
  UpdateToolbarLanguage;
  UpdateColumnFilterLayout;
  Invalidate;
end;

procedure TDCMasterDetailGrid.SetLanguageSource(const Value: TDCFlexLanguage);
begin
  if FLanguageSource = Value then
    Exit;

  if Assigned(FLanguageSource) then
  begin
    FLanguageSource.RemoveChangeListener(LanguageSourceChange);
    FLanguageSource.RemoveFreeNotification(Self);
  end;

  FLanguageSource := Value;

  if Assigned(FLanguageSource) then
  begin
    FLanguageSource.FreeNotification(Self);
    FLanguageSource.AddChangeListener(LanguageSourceChange);
  end;

  LanguageSourceChange(Self);
end;

procedure TDCMasterDetailGrid.SetRulesDesignerAutoLoadPreferences(const Value: Boolean);
begin
  FRulesDesignerAutoLoadPreferences := Value;
end;

procedure TDCMasterDetailGrid.SetRulesDesignerAutoSavePreferences(const Value: Boolean);
begin
  FRulesDesignerAutoSavePreferences := Value;
end;

procedure TDCMasterDetailGrid.SetRulesDesignerCustomLanguage(ALanguage: TDCGridLang);
begin
  FreeAndNil(FRulesDesignerCustomLanguage);
  if Assigned(ALanguage) then
  begin
    FRulesDesignerCustomLanguage := ALanguage.Clone;
    FRulesDesignerLanguage := rdlCustom;
  end;
  UpdateToolbarLanguage;
end;


function TDCMasterDetailGrid.GetRulesDesignerCustomLanguageClone: TDCGridLang;
begin
  if Assigned(FRulesDesignerCustomLanguage) then
    Result := FRulesDesignerCustomLanguage.Clone
  else
    Result := nil;
end;

function TDCMasterDetailGrid.GetEffectiveRulesDesignerLanguageClone: TDCGridLang;
begin
  Result := GetCurrentLanguage;
end;

function TDCMasterDetailGrid.GetRules: TDCHighlightRules;
begin
  if Assigned(FBusinessHighlight) then
    Result := FBusinessHighlight.Rules
  else
    Result := nil;
end;




function DCColumnFilterHint(ALang: TDCGridLang; ALanguageMode: TDCRulesDesignerLanguage; const ACaption: string): string;
var
  LPrefix: string;
begin
  LPrefix := '';
  try
    if Assigned(ALang) then
      LPrefix := Trim(ALang.ColumnFilterHintPrefix);

    if LPrefix = '' then
    begin
      if ALanguageMode = rdlEnglish then
        LPrefix := 'Filter'
      else
        LPrefix := 'Filtrar';
    end;

    if Trim(ACaption) <> '' then
      Result := LPrefix + ' ' + ACaption
    else
      Result := LPrefix;
  finally
    ALang.Free;
  end;
end;

function TDCMasterDetailGrid.GetLanguageSourceGridLanguage: TDCGridLang;

  procedure ApplyText(var ATarget: string; const AKey: string);
  begin
    ATarget := FLanguageSource.Text(dlsGrid, AKey, ATarget);
  end;

begin
  Result := nil;
  if not Assigned(FLanguageSource) then
    Exit;

  case FLanguageSource.Language of
    dlcPortuguese:
      Result := TDCGridLang.Portuguese;
    dlcEnglish:
      Result := TDCGridLang.English;
    dlcCustom:
      begin
        case FRulesDesignerLanguage of
          rdlPortuguese:
            Result := TDCGridLang.Portuguese;
          rdlEnglish:
            Result := TDCGridLang.English;
          rdlCustom:
            if Assigned(FRulesDesignerCustomLanguage) then
              Result := FRulesDesignerCustomLanguage.Clone
            else
              Result := TDCGridLang.English;
        else
          Result := TDCGridLang.English;
        end;
      end;
  else
    Result := TDCGridLang.English;
  end;

  ApplyText(Result.Title, 'rules.title');
  ApplyText(Result.Subtitle, 'rules.subtitle');
  ApplyText(Result.SectionRuleSetup, 'rules.section.rule.setup');
  ApplyText(Result.SectionRules, 'rules.section.rules');
  ApplyText(Result.SectionActions, 'rules.section.actions');
  ApplyText(Result.FieldCaption, 'rules.field');
  ApplyText(Result.ConditionCaption, 'rules.condition');
  ApplyText(Result.ValueCaption, 'rules.value');
  ApplyText(Result.ApplyToCaption, 'rules.apply.to');
  ApplyText(Result.BackgroundCaption, 'rules.background');
  ApplyText(Result.FontCaption, 'rules.font');
  ApplyText(Result.PreviewCaption, 'rules.preview');
  ApplyText(Result.BoldCaption, 'rules.bold');
  ApplyText(Result.ItalicCaption, 'rules.italic');
  ApplyText(Result.UnderlineCaption, 'rules.underline');
  ApplyText(Result.AddRuleCaption, 'rules.add');
  ApplyText(Result.UpdateRuleCaption, 'rules.update');
  ApplyText(Result.RemoveSelectedCaption, 'rules.remove.selected');
  ApplyText(Result.ClearAllCaption, 'rules.clear.all');
  ApplyText(Result.CloseCaption, 'rules.close');
  ApplyText(Result.CancelCaption, 'rules.cancel');
  ApplyText(Result.SampleCaption, 'rules.sample');
  ApplyText(Result.ConfirmClearTitle, 'rules.confirm.clear.title');
  ApplyText(Result.ConfirmClearMessage, 'rules.confirm.clear.message');
  ApplyText(Result.StatusReady, 'rules.status.ready');
  ApplyText(Result.StatusRuleAdded, 'rules.status.added');
  ApplyText(Result.StatusRuleUpdated, 'rules.status.updated');
  ApplyText(Result.StatusRuleRemoved, 'rules.status.removed');
  ApplyText(Result.StatusRulesCleared, 'rules.status.cleared');
  ApplyText(Result.StatusEditingRule, 'rules.status.editing');
  ApplyText(Result.ColField, 'rules.column.field');
  ApplyText(Result.ColCondition, 'rules.column.condition');
  ApplyText(Result.ColValue, 'rules.column.value');
  ApplyText(Result.ColApplyTo, 'rules.column.apply.to');
  ApplyText(Result.ColBack, 'rules.column.back');
  ApplyText(Result.ColFont, 'rules.column.font');
  ApplyText(Result.ColStyles, 'rules.column.styles');
  ApplyText(Result.ColumnCaptionPrefix, 'column.caption.prefix');
  ApplyText(Result.CondEquals, 'rules.condition.equals');
  ApplyText(Result.CondNotEquals, 'rules.condition.not.equals');
  ApplyText(Result.CondGreaterThan, 'rules.condition.greater.than');
  ApplyText(Result.CondLessThan, 'rules.condition.less.than');
  ApplyText(Result.CondContains, 'rules.condition.contains');
  ApplyText(Result.CondStartsWith, 'rules.condition.starts.with');
  ApplyText(Result.TargetRowCaption, 'rules.target.row');
  ApplyText(Result.TargetCellCaption, 'rules.target.cell');
  ApplyText(Result.ToolbarSearchHint, 'toolbar.search.hint');
  ApplyText(Result.ToolbarClearCaption, 'toolbar.clear');
  ApplyText(Result.ToolbarRulesCaption, 'toolbar.rules');
  ApplyText(Result.ColumnFilterHintPrefix, 'column.filter.hint.prefix');
  ApplyText(Result.FooterMenuCaption, 'footer.menu.caption');
  ApplyText(Result.FooterMenuShowCaption, 'footer.menu.show');
  ApplyText(Result.FooterMenuNoneCaption, 'footer.menu.none');
  ApplyText(Result.FooterMenuSumCaption, 'footer.menu.sum');
  ApplyText(Result.FooterMenuCountCaption, 'footer.menu.count');
  ApplyText(Result.FooterMenuAvgCaption, 'footer.menu.avg');
  ApplyText(Result.FooterMenuMinCaption, 'footer.menu.min');
  ApplyText(Result.FooterMenuMaxCaption, 'footer.menu.max');
  ApplyText(Result.MenuToolbarCaption, 'menu.toolbar');
  ApplyText(Result.MenuShowToolbarCaption, 'menu.show.toolbar');
  ApplyText(Result.MenuShowRulesCaption, 'menu.show.rules');
  ApplyText(Result.MenuFiltersCaption, 'menu.filters');
  ApplyText(Result.MenuShowColumnFiltersCaption, 'menu.show.column.filters');
  ApplyText(Result.MenuClearColumnFilterCaption, 'menu.clear.column.filter');
  ApplyText(Result.MenuClearAllFiltersCaption, 'menu.clear.all.filters');
  ApplyText(Result.MenuChooseColumnsCaption, 'menu.choose.columns');
  ApplyText(Result.MenuAutoFitColumnCaption, 'menu.auto.fit.column');
  ApplyText(Result.MenuAutoFitAllColumnsCaption, 'menu.auto.fit.all.columns');
  ApplyText(Result.MenuFreezeToColumnCaption, 'menu.freeze.to.column');
  ApplyText(Result.MenuClearFrozenColumnsCaption, 'menu.clear.frozen.columns');
  ApplyText(Result.MenuExportCaption, 'menu.export');
  ApplyText(Result.MenuExportCsvCaption, 'menu.export.csv');
  ApplyText(Result.MenuFooterSummariesCaption, 'menu.footer.summaries');
  ApplyText(Result.MenuColumnsCaption, 'menu.columns');
  ApplyText(Result.MenuLayoutCaption, 'menu.layout');
  ApplyText(Result.MenuLayoutSaveCaption, 'menu.layout.save');
  ApplyText(Result.MenuLayoutLoadCaption, 'menu.layout.load');
  ApplyText(Result.MenuLayoutResetCaption, 'menu.layout.reset');
  ApplyText(Result.ColumnChooserSelectAllCaption, 'column.chooser.select.all');
  ApplyText(Result.ColumnChooserUnselectAllCaption, 'column.chooser.unselect.all');
  ApplyText(Result.ColumnChooserKeepOneVisibleMessage,
    'column.chooser.keep.one.visible');
end;

function TDCMasterDetailGrid.GetCurrentLanguage: TDCGridLang;
begin
  if Assigned(FLanguageSource) then
    Exit(GetLanguageSourceGridLanguage);

  Result := nil;
  case FRulesDesignerLanguage of
    rdlPortuguese:
      Result := TDCGridLang.Portuguese;
    rdlEnglish:
      Result := TDCGridLang.English;
    rdlCustom:
      if Assigned(FRulesDesignerCustomLanguage) then
        Result := FRulesDesignerCustomLanguage.Clone
      else
        Result := TDCGridLang.Portuguese;
  else
    Result := TDCGridLang.Portuguese;
  end;
end;

procedure TDCMasterDetailGrid.UpdateToolbarLanguage;
var
  LLang: TDCGridLang;
begin
  if not Assigned(FToolbarSearchEdit) or not Assigned(FToolbarClearButton) or not Assigned(FToolbarRulesButton) then
    Exit;

  LLang := GetCurrentLanguage;
  try
    if Assigned(LLang) then
    begin
      if Trim(LLang.ToolbarSearchHint) <> '' then
        FToolbarSearchEdit.TextHint := LLang.ToolbarSearchHint
      else if FRulesDesignerLanguage = rdlEnglish then
        FToolbarSearchEdit.TextHint := 'Search...'
      else
        FToolbarSearchEdit.TextHint := 'Buscar...';

      if Trim(LLang.ToolbarClearCaption) <> '' then
        FToolbarClearButton.Caption := LLang.ToolbarClearCaption
      else if FRulesDesignerLanguage = rdlEnglish then
        FToolbarClearButton.Caption := 'Clear'
      else
        FToolbarClearButton.Caption := 'Limpar';

      if Trim(LLang.ToolbarRulesCaption) <> '' then
        FToolbarRulesButton.Caption := LLang.ToolbarRulesCaption
      else if FRulesDesignerLanguage = rdlEnglish then
        FToolbarRulesButton.Caption := 'Rules'
      else
        FToolbarRulesButton.Caption := 'Regras';
    end;
  finally
    LLang.Free;
  end;

  UpdateToolbarLayout;
  UpdateColumnFilterLayout;
end;

procedure TDCMasterDetailGrid.SetShowToolbar(const Value: Boolean);
begin
  if FShowToolbar <> Value then
  begin
    FShowToolbar := Value;
    UpdateToolbarLayout;
    if FAutoSaveLayout and not (csLoading in ComponentState) then
      SaveLayout;
    UpdateScrollBar;
    Invalidate;
  end;
end;

procedure TDCMasterDetailGrid.SetToolbarHeight(const Value: Integer);
begin
  if FToolbarHeight <> Value then
  begin
    FToolbarHeight := Max(32, Value);
    UpdateToolbarLayout;
    if FAutoSaveLayout and not (csLoading in ComponentState) then
      SaveLayout;
    UpdateScrollBar;
    Invalidate;
  end;
end;

procedure TDCMasterDetailGrid.SetShowToolbarRulesDesignerButton(const Value: Boolean);
begin
  if FShowToolbarRulesDesignerButton <> Value then
  begin
    FShowToolbarRulesDesignerButton := Value;
    UpdateToolbarLayout;
    if FAutoSaveLayout and not (csLoading in ComponentState) then
      SaveLayout;
    Invalidate;
  end;
end;

procedure TDCMasterDetailGrid.SetShowFooter(const Value: Boolean);
begin
  if FShowFooter <> Value then
  begin
    FShowFooter := Value;
    UpdateScrollBar;
    if FAutoSaveLayout and not (csLoading in ComponentState) then
      SaveLayout;
    Invalidate;
  end;
end;

procedure TDCMasterDetailGrid.SetFooterHeight(const Value: Integer);
begin
  if FFooterHeight <> Value then
  begin
    FFooterHeight := Max(24, Value);
    UpdateScrollBar;
    if FAutoSaveLayout and not (csLoading in ComponentState) then
      SaveLayout;
    Invalidate;
  end;
end;

procedure TDCMasterDetailGrid.ToolbarSearchChanged(Sender: TObject);
begin
  if FUpdatingToolbarSearch then
    Exit;
  SearchText := FToolbarSearchEdit.Text;
end;

procedure TDCMasterDetailGrid.ToolbarClearClick(Sender: TObject);
begin
  SearchText := '';
  if Assigned(FToolbarSearchEdit) then
  begin
    FToolbarSearchEdit.SetFocus;
    FToolbarSearchEdit.SelectAll;
  end;
end;

procedure TDCMasterDetailGrid.ToolbarRulesClick(Sender: TObject);
begin
  ShowVisualRulesDesigner;
end;

procedure TDCMasterDetailGrid.UpdateToolbarLayout;
var
  R: TRect;
  LClearButtonWidth: Integer;
  LRulesButtonWidth: Integer;
  LButtonHeight: Integer;
  LTop: Integer;
  LEditRight: Integer;
  LSearchFrame: TRect;
  LSearchWidth: Integer;
  LRight: Integer;
begin
  if not Assigned(FToolbarSearchEdit) or not Assigned(FToolbarClearButton) or not Assigned(FToolbarRulesButton) then
    Exit;

  FToolbarSearchEdit.Visible := FShowToolbar;
  FToolbarClearButton.Visible := FShowToolbar;
  FToolbarRulesButton.Visible := FShowToolbar and FShowToolbarRulesDesignerButton;

  FToolbarSearchEdit.Enabled := FShowToolbar;
  FToolbarClearButton.Enabled := FShowToolbar;
  FToolbarRulesButton.Enabled := FToolbarRulesButton.Visible;

  FToolbarSearchEdit.ParentColor := False;
  FToolbarSearchEdit.ParentFont := False;
  FToolbarSearchEdit.Color := FTheme.RowColor;
  FToolbarSearchEdit.Font.Assign(Font);
  FToolbarSearchEdit.Font.Name := 'Segoe UI';
  FToolbarSearchEdit.Font.Size := 9;
  FToolbarSearchEdit.Font.Color := FTheme.TextColor;
  FToolbarClearButton.Font.Name := 'Segoe UI';
  FToolbarClearButton.Font.Size := 9;
  FToolbarClearButton.Font.Style := [];
  FToolbarClearButton.BackColor := FTheme.RowColor;
  FToolbarClearButton.TextColor := FTheme.TextColor;
  FToolbarClearButton.BorderColor := FTheme.BorderColor;
  FToolbarClearButton.HoverColor := FTheme.HoverRowColor;
  FToolbarClearButton.PressedColor := FTheme.SelectedRowColor;
  FToolbarClearButton.AccentColor := FTheme.ExpandButtonColor;
  FToolbarRulesButton.Font.Name := 'Segoe UI';
  FToolbarRulesButton.Font.Size := 9;
  FToolbarRulesButton.Font.Style := [];
  FToolbarRulesButton.BackColor := FTheme.RowColor;
  FToolbarRulesButton.TextColor := FTheme.TextColor;
  FToolbarRulesButton.BorderColor := FTheme.BorderColor;
  FToolbarRulesButton.HoverColor := FTheme.HoverRowColor;
  FToolbarRulesButton.PressedColor := FTheme.SelectedRowColor;
  FToolbarRulesButton.AccentColor := FTheme.ExpandButtonColor;

  if not FShowToolbar then
    Exit;

  R := GetToolbarRect;
  InflateRect(R, -DC_DEFAULT_PADDING, 0);

  Canvas.Font.Assign(FToolbarClearButton.Font);
  LClearButtonWidth := Max(78, Canvas.TextWidth(FToolbarClearButton.Caption) + 34);
  LRulesButtonWidth := Max(88, Canvas.TextWidth(FToolbarRulesButton.Caption) + 34);
  LButtonHeight := Max(23, Min(28, (R.Bottom - R.Top) - 18));
  LTop := R.Top + ((R.Bottom - R.Top) - LButtonHeight) div 2;

  LRight := R.Right;

  if FToolbarRulesButton.Visible then
  begin
    FToolbarRulesButton.SetBounds(LRight - LRulesButtonWidth, LTop, LRulesButtonWidth, LButtonHeight);
    LRight := FToolbarRulesButton.Left - DC_DEFAULT_PADDING;
  end
  else
    FToolbarRulesButton.SetBounds(0, 0, 0, 0);

  FToolbarClearButton.SetBounds(LRight - LClearButtonWidth, LTop, LClearButtonWidth, LButtonHeight);

  LEditRight := FToolbarClearButton.Left - DC_DEFAULT_PADDING;
  if LEditRight < R.Left + 80 then
    LEditRight := R.Right;

  LSearchWidth := Max(80, LEditRight - R.Left);
  LSearchFrame := Rect(R.Left, LTop, R.Left + LSearchWidth, LTop + LButtonHeight);
  FToolbarSearchEdit.SetBounds(LSearchFrame.Left + 8, LSearchFrame.Top + 4,
    Max(20, LSearchFrame.Right - LSearchFrame.Left - 16),
    Max(16, LSearchFrame.Bottom - LSearchFrame.Top - 8));

  FToolbarSearchEdit.BringToFront;
  FToolbarClearButton.BringToFront;
  if FToolbarRulesButton.Visible then
    FToolbarRulesButton.BringToFront;
end;

function TDCMasterDetailGrid.GetToolbarRect: TRect;
begin
  if FShowToolbar then
    Result := Rect(0, 0, ClientWidth, FToolbarHeight)
  else
    Result := Rect(0, 0, ClientWidth, 0);
end;

function TDCMasterDetailGrid.GetFooterRect: TRect;
var
  LBottom: Integer;
begin
  LBottom := ClientHeight;
  if FBorderWidth > 0 then
    Dec(LBottom, FBorderWidth);

  if FShowFooter then
  begin
    Result := Rect(0, Max(GetContentTop, LBottom - FFooterHeight), ClientWidth, LBottom);
    if Result.Bottom < Result.Top then
      Result.Bottom := Result.Top;
  end
  else
    Result := Rect(0, LBottom, ClientWidth, LBottom);
end;

procedure TDCMasterDetailGrid.DrawToolbar;
var
  R: TRect;
  LSearchFrame: TRect;
  LSearchBorder: TColor;
begin
  if not FShowToolbar then
    Exit;

  R := GetToolbarRect;
  FillRectColor(Canvas, R, FTheme.GridBackgroundColor);

  if Assigned(FToolbarSearchEdit) and FToolbarSearchEdit.Visible then
  begin
    LSearchFrame := FToolbarSearchEdit.BoundsRect;
    InflateRect(LSearchFrame, 8, 4);
    LSearchBorder := FTheme.BorderColor;
    if FToolbarSearchEdit.Focused then
      LSearchBorder := FTheme.ExpandButtonColor;
    DrawRoundedPanel(Canvas, LSearchFrame, FTheme.RowColor, LSearchBorder, 4);
  end;

  Canvas.Pen.Color := FTheme.BorderColor;
  Canvas.MoveTo(R.Left, R.Bottom - 1);
  Canvas.LineTo(R.Right, R.Bottom - 1);
end;

function TryDCFlexTextToFloat(const AText: string; out AValue: Double): Boolean;
var
  S: string;
  FS: TFormatSettings;
begin
  S := Trim(AText);
  S := StringReplace(S, 'R$', '', [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, '$', '', [rfReplaceAll]);
  S := StringReplace(S, '€', '', [rfReplaceAll]);
  S := StringReplace(S, '£', '', [rfReplaceAll]);
  S := StringReplace(S, ' ', '', [rfReplaceAll]);

  FS := TFormatSettings.Create;
  FS.DecimalSeparator := ',';
  FS.ThousandSeparator := '.';
  Result := TryStrToFloat(S, AValue, FS);
  if Result then
    Exit;

  FS.DecimalSeparator := '.';
  FS.ThousandSeparator := ',';
  Result := TryStrToFloat(S, AValue, FS);
end;

function TDCMasterDetailGrid.CalculateFooterSummary(ACol: Integer): string;
var
  I: Integer;
  LActualRow: Integer;
  LValue: Double;
  LSum: Double;
  LCount: Integer;
  LMin: Double;
  LMax: Double;
  LText: string;
  LSummary: TDCFooterSummary;
begin
  Result := '';
  if (ACol < 0) or (ACol >= FColumns.Count) then
    Exit;

  LSummary := FColumns[ACol].FooterSummary;
  if LSummary = fsNone then
    Exit;

  LSum := 0;
  LCount := 0;
  LMin := 0;
  LMax := 0;

  for I := 0 to GetActualRowCount - 1 do
  begin
    LActualRow := GetActualRowIndex(I);
    if LActualRow < 0 then
      Continue;

    LText := GetDisplayText(LActualRow, ACol);
    if LSummary = fsCount then
    begin
      if Trim(LText) <> '' then
        Inc(LCount);
      Continue;
    end;

    if TryDCFlexTextToFloat(LText, LValue) then
    begin
      if LCount = 0 then
      begin
        LMin := LValue;
        LMax := LValue;
      end
      else
      begin
        if LValue < LMin then
          LMin := LValue;
        if LValue > LMax then
          LMax := LValue;
      end;
      LSum := LSum + LValue;
      Inc(LCount);
    end;
  end;

  case LSummary of
    fsCount:
      Result := IntToStr(LCount);
    fsSum:
      if LCount > 0 then
        Result := FormatFloat('#,##0.00', LSum);
    fsAvg:
      if LCount > 0 then
        Result := FormatFloat('#,##0.00', LSum / LCount);
    fsMin:
      if LCount > 0 then
        Result := FormatFloat('#,##0.00', LMin);
    fsMax:
      if LCount > 0 then
        Result := FormatFloat('#,##0.00', LMax);
  end;
end;

procedure TDCMasterDetailGrid.DrawFooter;
var
  I: Integer;
  X: Integer;
  R: TRect;
  LCol: TDCGridColumn;
  LColRect: TRect;
  LTextRect: TRect;
  LText: string;
  LFlags: Cardinal;
  LFooterColor: TColor;
  LGridRight: Integer;
  LClipState: Integer;
begin
  if not FShowFooter then
    Exit;

  R := GetFooterRect;
  if (R.Bottom <= R.Top) or (R.Right <= R.Left) then
    Exit;

  LFooterColor := BlendColor(FTheme.GridBackgroundColor, FTheme.HeaderColor, 180);

  { Footer must always be drawn after rows and over the grid background. }
  FillRectColor(Canvas, R, LFooterColor);

  Canvas.Pen.Color := FTheme.BorderColor;
  Canvas.MoveTo(R.Left, R.Top);
  Canvas.LineTo(R.Right, R.Top);
  Canvas.MoveTo(R.Left, R.Bottom - 1);
  Canvas.LineTo(R.Right, R.Bottom - 1);

  Canvas.Font.Assign(Font);
  Canvas.Font.Style := Canvas.Font.Style + [fsBold];
  Canvas.Font.Color := FTheme.TextColor;
  Canvas.Brush.Style := bsClear;
  SetBkMode(Canvas.Handle, TRANSPARENT);

  X := R.Left;
  if FShowExpandButton then
  begin
    Canvas.Pen.Color := BlendColor(FTheme.BorderColor, LFooterColor, 90);
    Canvas.MoveTo(X + DC_DEFAULT_EXPAND_COL_WIDTH - 1, R.Top + 6);
    Canvas.LineTo(X + DC_DEFAULT_EXPAND_COL_WIDTH - 1, R.Bottom - 6);
    Inc(X, DC_DEFAULT_EXPAND_COL_WIDTH);
  end;

  LClipState := SaveDC(Canvas.Handle);
  try
    IntersectClipRect(Canvas.Handle, X, R.Top, R.Right, R.Bottom);
    Dec(X, FHorizontalOffset);

    LGridRight := X;
  for I := 0 to FColumns.Count - 1 do
    if FColumns[I].Visible then
      Inc(LGridRight, FColumns[I].Width);

  for I := 0 to FColumns.Count - 1 do
  begin
    LCol := FColumns[I];
    if not LCol.Visible then
      Continue;

    LColRect := Rect(X, R.Top, X + LCol.Width, R.Bottom);
    LTextRect := Rect(LColRect.Left + DC_DEFAULT_PADDING, LColRect.Top,
      LColRect.Right - DC_DEFAULT_PADDING, LColRect.Bottom);
    LText := CalculateFooterSummary(I);

    case LCol.Alignment of
      taCenter: LFlags := DT_CENTER;
      taRight: LFlags := DT_RIGHT;
    else
      LFlags := DT_LEFT;
    end;

    if LText <> '' then
      DrawText(Canvas.Handle, PChar(LText), Length(LText), LTextRect,
        LFlags or DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX or DT_END_ELLIPSIS);

    Canvas.Pen.Color := BlendColor(FTheme.BorderColor, LFooterColor, 90);
    Canvas.MoveTo(LColRect.Right - 1, LColRect.Top + 6);
    Canvas.LineTo(LColRect.Right - 1, LColRect.Bottom - 6);

    Inc(X, LCol.Width);
  end;

  if LGridRight < R.Right then
  begin
    FillRectColor(Canvas, Rect(LGridRight, R.Top + 1, R.Right, R.Bottom - 1), LFooterColor);
  end;

  finally
    RestoreDC(Canvas.Handle, LClipState);
  end;

  DrawFrozenFooterOverlay(R, LFooterColor);
  DrawFrozenColumnsSeparator(R, LFooterColor);

  Canvas.Brush.Style := bsSolid;
end;


function TDCMasterDetailGrid.GetFrozenColumnsBoundaryX(ABaseLeft: Integer): Integer;
var
  I: Integer;
  LVisibleFrozenCount: Integer;
begin
  Result := ABaseLeft;

  if FShowExpandButton then
    Inc(Result, DC_DEFAULT_EXPAND_COL_WIDTH);

  if FFrozenColumns <= 0 then
    Exit;

  LVisibleFrozenCount := 0;
  for I := 0 to FColumns.Count - 1 do
  begin
    if not FColumns[I].Visible then
      Continue;

    if LVisibleFrozenCount >= FFrozenColumns then
      Break;

    Inc(Result, FColumns[I].Width);
    Inc(LVisibleFrozenCount);
  end;
end;


procedure TDCMasterDetailGrid.DrawFrozenHeaderOverlay(const ARect: TRect; ABackColor: TColor);
var
  I: Integer;
  X: Integer;
  LVisibleFrozenCount: Integer;
  LCol: TDCGridColumn;
  LColRect: TRect;
  LTextRect: TRect;
  LGlyph: string;
  LGlyphRect: TRect;
  LHeaderCaption: string;
  LHasFilter: Boolean;
  LSaveDC: Integer;
begin
  if FFrozenColumns <= 0 then
    Exit;

  X := ARect.Left;
  if FShowExpandButton then
    Inc(X, DC_DEFAULT_EXPAND_COL_WIDTH);

  LSaveDC := SaveDC(Canvas.Handle);
  try
    IntersectClipRect(Canvas.Handle, X, ARect.Top, GetFrozenColumnsBoundaryX(ARect.Left), ARect.Bottom);

    LVisibleFrozenCount := 0;
    for I := 0 to FColumns.Count - 1 do
    begin
      LCol := FColumns[I];
      if not LCol.Visible then
        Continue;
      if LVisibleFrozenCount >= FFrozenColumns then
        Break;

      LColRect := Rect(X, ARect.Top, X + LCol.Width, ARect.Bottom);
      FillRectColor(Canvas, LColRect, ABackColor);
      if I = FSortedColumn then
      begin
        FillRectColor(Canvas, Rect(LColRect.Left, LColRect.Bottom - 3, LColRect.Right, LColRect.Bottom),
          FTheme.ExpandButtonColor);
      end;

      Canvas.Font.Assign(FTitleFont);
      Canvas.Font.Style := [fsBold];
      Canvas.Font.Color := FTheme.HeaderFontColor;
      Canvas.Brush.Style := bsClear;
      SetBkMode(Canvas.Handle, TRANSPARENT);

      LHasFilter := Trim(LCol.FilterText) <> '';
      LHeaderCaption := LCol.Caption;
      if LHasFilter then
        LHeaderCaption := LHeaderCaption + ' *';

      LTextRect := Rect(LColRect.Left + DC_DEFAULT_PADDING + 1, LColRect.Top,
        LColRect.Right - DC_DEFAULT_PADDING - 16, LColRect.Bottom - 2);
      DrawText(Canvas.Handle, PChar(LHeaderCaption), Length(LHeaderCaption), LTextRect,
        DT_VCENTER or DT_SINGLELINE or DT_LEFT or DT_NOPREFIX or DT_END_ELLIPSIS);

      if I = FSortedColumn then
      begin
        if FSortDirection = sdAscending then
          LGlyph := WideChar($25B2)
        else if FSortDirection = sdDescending then
          LGlyph := WideChar($25BC)
        else
          LGlyph := '';

        if LGlyph <> '' then
        begin
          LGlyphRect := Rect(LColRect.Right - 22, LColRect.Top, LColRect.Right - 4, LColRect.Bottom);
          Canvas.Font.Name := 'Segoe UI Symbol';
          Canvas.Font.Style := [];
          Canvas.Font.Size := Max(9, FTitleFont.Size);
          Canvas.Font.Color := FTheme.HeaderFontColor;
          DrawText(Canvas.Handle, PChar(LGlyph), Length(LGlyph), LGlyphRect,
            DT_CENTER or DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX);
        end;
      end;

      if FShowHeaderColumnLines then
      begin
        Canvas.Pen.Color := BlendColor(FTheme.BorderColor, ABackColor, 120);
        Canvas.MoveTo(LColRect.Right - 1, ARect.Top + 4);
        Canvas.LineTo(LColRect.Right - 1, ARect.Bottom - 4);
      end;

      Inc(X, LCol.Width);
      Inc(LVisibleFrozenCount);
    end;
  finally
    RestoreDC(Canvas.Handle, LSaveDC);
  end;
end;

procedure TDCMasterDetailGrid.DrawFrozenRowOverlay(ARow: Integer; const ARect: TRect);
var
  I: Integer;
  X: Integer;
  LVisibleFrozenCount: Integer;
  LCol: TDCGridColumn;
  LCellRect: TRect;
  LPaintRect: TRect;
  LText: string;
  LFlags: Cardinal;
  LRowColor: TColor;
  LFontColor: TColor;
  LFontStyles: TFontStyles;
  LBusinessTarget: TDCHighlightTarget;
  LBusinessMatched: Boolean;
  LBusinessFieldName: string;
  LSaveDC: Integer;
begin
  if FFrozenColumns <= 0 then
    Exit;

  if ARow = FHoverRow then
    LRowColor := FTheme.HoverRowColor
  else if FAlternateColors and Odd(ARow) then
    LRowColor := FTheme.AlternateRowColor
  else
    LRowColor := FTheme.RowColor;

  LFontColor := FTheme.TextColor;
  LFontStyles := [];
  LBusinessMatched := ApplyBusinessHighlight(ARow, LRowColor, LFontColor, LFontStyles, LBusinessTarget, LBusinessFieldName);
  if LBusinessMatched and (LBusinessTarget = htCell) then
  begin
    if ARow = FHoverRow then
      LRowColor := FTheme.HoverRowColor
    else if FAlternateColors and Odd(ARow) then
      LRowColor := FTheme.AlternateRowColor
    else
      LRowColor := FTheme.RowColor;
    LFontColor := FTheme.TextColor;
    LFontStyles := [];
  end;

  if ARow = FSelectedRow then
    LFontStyles := LFontStyles + [fsBold];
  if Assigned(FOnGetMasterRowStyle) then
    FOnGetMasterRowStyle(Self, ARow, LRowColor, LFontColor, LFontStyles);

  X := ARect.Left;
  if FShowExpandButton then
    Inc(X, DC_DEFAULT_EXPAND_COL_WIDTH);

  LSaveDC := SaveDC(Canvas.Handle);
  try
    IntersectClipRect(Canvas.Handle, X, ARect.Top, GetFrozenColumnsBoundaryX(ARect.Left), ARect.Bottom);

    Canvas.Font.Assign(Font);
    Canvas.Font.Style := LFontStyles;
    Canvas.Font.Color := LFontColor;
    Canvas.Brush.Style := bsClear;
    SetBkMode(Canvas.Handle, TRANSPARENT);

    LVisibleFrozenCount := 0;
    for I := 0 to FColumns.Count - 1 do
    begin
      LCol := FColumns[I];
      if not LCol.Visible then
        Continue;
      if LVisibleFrozenCount >= FFrozenColumns then
        Break;

      LPaintRect := Rect(X, ARect.Top, X + LCol.Width, ARect.Bottom);
      FillRectColor(Canvas, LPaintRect, LRowColor);

      LCellRect := LPaintRect;
      InflateRect(LCellRect, -DC_DEFAULT_PADDING, 0);
      LText := GetDisplayText(ARow, I);
      case LCol.Alignment of
        taLeft: LFlags := DT_LEFT;
        taCenter: LFlags := DT_CENTER;
      else
        LFlags := DT_RIGHT;
      end;
      DrawText(Canvas.Handle, PChar(LText), Length(LText), LCellRect,
        DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX or DT_END_ELLIPSIS or LFlags);

      if FShowRowColumnLines then
      begin
        Canvas.Pen.Color := BlendColor(FTheme.BorderColor, LRowColor, 45);
        Canvas.MoveTo(LPaintRect.Right - 1, ARect.Top + 2);
        Canvas.LineTo(LPaintRect.Right - 1, ARect.Bottom - 2);
      end;

      Inc(X, LCol.Width);
      Inc(LVisibleFrozenCount);
    end;
  finally
    RestoreDC(Canvas.Handle, LSaveDC);
  end;
end;

procedure TDCMasterDetailGrid.DrawFrozenFooterOverlay(const ARect: TRect; ABackColor: TColor);
var
  I: Integer;
  X: Integer;
  LVisibleFrozenCount: Integer;
  LCol: TDCGridColumn;
  LColRect: TRect;
  LTextRect: TRect;
  LText: string;
  LFlags: Cardinal;
  LSaveDC: Integer;
begin
  if (FFrozenColumns <= 0) or (not FShowFooter) then
    Exit;

  X := ARect.Left;
  if FShowExpandButton then
    Inc(X, DC_DEFAULT_EXPAND_COL_WIDTH);

  LSaveDC := SaveDC(Canvas.Handle);
  try
    IntersectClipRect(Canvas.Handle, X, ARect.Top, GetFrozenColumnsBoundaryX(ARect.Left), ARect.Bottom);

    Canvas.Font.Assign(Font);
    Canvas.Font.Style := Canvas.Font.Style + [fsBold];
    Canvas.Font.Color := FTheme.TextColor;
    Canvas.Brush.Style := bsClear;
    SetBkMode(Canvas.Handle, TRANSPARENT);

    LVisibleFrozenCount := 0;
    for I := 0 to FColumns.Count - 1 do
    begin
      LCol := FColumns[I];
      if not LCol.Visible then
        Continue;
      if LVisibleFrozenCount >= FFrozenColumns then
        Break;

      LColRect := Rect(X, ARect.Top, X + LCol.Width, ARect.Bottom);
      FillRectColor(Canvas, LColRect, ABackColor);
      LTextRect := Rect(LColRect.Left + DC_DEFAULT_PADDING, LColRect.Top,
        LColRect.Right - DC_DEFAULT_PADDING, LColRect.Bottom);
      LText := CalculateFooterSummary(I);

      case LCol.Alignment of
        taCenter: LFlags := DT_CENTER;
        taRight: LFlags := DT_RIGHT;
      else
        LFlags := DT_LEFT;
      end;

      if LText <> '' then
        DrawText(Canvas.Handle, PChar(LText), Length(LText), LTextRect,
          LFlags or DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX or DT_END_ELLIPSIS);

      Canvas.Pen.Color := BlendColor(FTheme.BorderColor, ABackColor, 90);
      Canvas.MoveTo(LColRect.Right - 1, LColRect.Top + 6);
      Canvas.LineTo(LColRect.Right - 1, LColRect.Bottom - 6);

      Inc(X, LCol.Width);
      Inc(LVisibleFrozenCount);
    end;
  finally
    RestoreDC(Canvas.Handle, LSaveDC);
  end;
end;

procedure TDCMasterDetailGrid.DrawFrozenColumnsSeparator(const ARect: TRect; ABackColor: TColor);
var
  LX: Integer;
begin
  if FFrozenColumns <= 0 then
    Exit;

  LX := GetFrozenColumnsBoundaryX(ARect.Left);
  if (LX <= ARect.Left) or (LX >= ARect.Right) then
    Exit;

  Canvas.Pen.Color := BlendColor(FTheme.SelectedRowColor, ABackColor, 80);
  Canvas.MoveTo(LX - 1, ARect.Top + 2);
  Canvas.LineTo(LX - 1, ARect.Bottom - 2);

  Canvas.Pen.Color := BlendColor(FTheme.BorderColor, ABackColor, 45);
  Canvas.MoveTo(LX, ARect.Top + 2);
  Canvas.LineTo(LX, ARect.Bottom - 2);
end;

procedure TDCMasterDetailGrid.ShowRulesDesigner;
begin
  ShowVisualRulesDesigner;
end;

procedure TDCMasterDetailGrid.ShowVisualRulesDesigner;
begin
  ShowDCFlexGridVisualRulesDesigner(Self);
end;


function TDCMasterDetailGrid.GetVisibleFrozenColumnsWidth: Integer;
var
  I: Integer;
  LVisibleFrozenCount: Integer;
begin
  Result := 0;
  if FFrozenColumns <= 0 then
    Exit;

  LVisibleFrozenCount := 0;
  for I := 0 to FColumns.Count - 1 do
  begin
    if not FColumns[I].Visible then
      Continue;
    if LVisibleFrozenCount >= FFrozenColumns then
      Break;
    Inc(Result, FColumns[I].Width);
    Inc(LVisibleFrozenCount);
  end;
end;

function TDCMasterDetailGrid.IsFrozenColumn(ACol: Integer): Boolean;
var
  I: Integer;
  LVisibleIndex: Integer;
begin
  Result := False;
  if (FFrozenColumns <= 0) or (ACol < 0) or (ACol >= FColumns.Count) then
    Exit;
  if not FColumns[ACol].Visible then
    Exit;

  LVisibleIndex := 0;
  for I := 0 to FColumns.Count - 1 do
  begin
    if not FColumns[I].Visible then
      Continue;
    if I = ACol then
      Exit(LVisibleIndex < FFrozenColumns);
    Inc(LVisibleIndex);
  end;
end;

function TDCMasterDetailGrid.GetColumnDrawLeft(ACol, ABaseLeft: Integer): Integer;
var
  I: Integer;
  LStartX: Integer;
  LVisibleIndex: Integer;
begin
  LStartX := ABaseLeft;
  if FShowExpandButton then
    Inc(LStartX, DC_DEFAULT_EXPAND_COL_WIDTH);

  Result := LStartX;
  if (ACol < 0) or (ACol >= FColumns.Count) then
    Exit;

  if IsFrozenColumn(ACol) then
  begin
    for I := 0 to ACol - 1 do
      if FColumns[I].Visible then
        Inc(Result, FColumns[I].Width);
  end
  else
  begin
    Result := LStartX + GetVisibleFrozenColumnsWidth - FHorizontalOffset;
    LVisibleIndex := 0;
    for I := 0 to ACol - 1 do
    begin
      if not FColumns[I].Visible then
        Continue;
      if LVisibleIndex >= FFrozenColumns then
        Inc(Result, FColumns[I].Width);
      Inc(LVisibleIndex);
    end;
  end;
end;

function TDCMasterDetailGrid.GetVisibleMasterColumnsWidth: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to FColumns.Count - 1 do
    if FColumns[I].Visible then
      Inc(Result, FColumns[I].Width);
end;

function TDCMasterDetailGrid.GetVisibleDetailColumnsWidth: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to FDetailColumns.Count - 1 do
    if FDetailColumns[I].Visible then
      Inc(Result, FDetailColumns[I].Width);
end;

function TDCMasterDetailGrid.GetHorizontalMax: Integer;
var
  LViewportWidth: Integer;
  LContentWidth: Integer;
  LFrozenWidth: Integer;
begin
  LViewportWidth := ClientWidth;
  if FShowExpandButton then
    Dec(LViewportWidth, DC_DEFAULT_EXPAND_COL_WIDTH);

  LFrozenWidth := GetVisibleFrozenColumnsWidth;
  Dec(LViewportWidth, LFrozenWidth);

  { Important:
    The master horizontal scrollbar must be driven only by master columns.
    When columns are frozen, only the non-frozen portion participates in
    horizontal scrolling. }
  LContentWidth := GetVisibleMasterColumnsWidth - LFrozenWidth;
  Result := Max(0, LContentWidth - Max(1, LViewportWidth));
end;

procedure TDCMasterDetailGrid.SetHorizontalOffset(const Value: Integer);
var
  LNewValue: Integer;
  LInvalidateRect: TRect;
begin
  LNewValue := EnsureRange(Value, 0, GetHorizontalMax);
  if FHorizontalOffset <> LNewValue then
  begin
    FHorizontalOffset := LNewValue;
    UpdateColumnFilterLayout;
    UpdateScrollBar;

    { Horizontal scrolling only affects the grid surface below the toolbar.
      Do not invalidate the toolbar area here, otherwise the real toolbar
      controls can flicker while the user drags the horizontal scrollbar. }
    LInvalidateRect := Rect(0, GetHeaderRect.Top, ClientWidth, ClientHeight);
    if HandleAllocated then
      Winapi.Windows.InvalidateRect(Handle, @LInvalidateRect, False)
    else
      Invalidate;
  end;
end;

function TDCMasterDetailGrid.GetColumnsStartX(ABaseLeft: Integer): Integer;
begin
  Result := ABaseLeft;
  if FShowExpandButton then
    Inc(Result, DC_DEFAULT_EXPAND_COL_WIDTH);
  Dec(Result, FHorizontalOffset);
end;

function TDCMasterDetailGrid.GetDetailColumnsStartX(ABaseLeft: Integer): Integer;
begin
  { Detail columns are isolated from the master horizontal scroll.
    The master scrollbar must never shift the detail grid content.
    A dedicated detail horizontal scroll can be added later. }
  Result := ABaseLeft;
end;

procedure TDCMasterDetailGrid.UpdateScrollBar;
var
  SI: TScrollInfo;
  LPageRows: Integer;
  LHorizontalMax: Integer;
  LHorizontalPage: Integer;
begin
  if not HandleAllocated then
    Exit;

  LPageRows := GetVisibleMasterRows;

  FillChar(SI, SizeOf(SI), 0);
  SI.cbSize := SizeOf(SI);
  SI.fMask := SIF_RANGE or SIF_PAGE or SIF_POS;
  SI.nMin := 0;
  SI.nMax := Max(0, MaxTopRow + LPageRows - 1);
  SI.nPage := Max(1, LPageRows);
  SI.nPos := FTopRow;
  SetScrollInfo(Handle, SB_VERT, SI, True);

  LHorizontalMax := GetHorizontalMax;
  if FHorizontalOffset > LHorizontalMax then
  begin
    FHorizontalOffset := LHorizontalMax;
    UpdateColumnFilterLayout;
  end;
  if FHorizontalOffset < 0 then
  begin
    FHorizontalOffset := 0;
    UpdateColumnFilterLayout;
  end;

  LHorizontalPage := ClientWidth;
  if FShowExpandButton then
    Dec(LHorizontalPage, DC_DEFAULT_EXPAND_COL_WIDTH);
  LHorizontalPage := Max(1, LHorizontalPage);

  { Important: keep the master horizontal scrollbar driven only by master
    columns. If the master does not need horizontal scrolling, hide the bar
    completely so resizing/detail columns cannot leave the grid in a stale
    shifted state. }
  ShowScrollBar(Handle, SB_HORZ, LHorizontalMax > 0);

  FillChar(SI, SizeOf(SI), 0);
  SI.cbSize := SizeOf(SI);
  SI.fMask := SIF_RANGE or SIF_PAGE or SIF_POS;
  SI.nMin := 0;
  SI.nMax := LHorizontalMax + LHorizontalPage - 1;
  SI.nPage := LHorizontalPage;
  SI.nPos := FHorizontalOffset;
  SetScrollInfo(Handle, SB_HORZ, SI, True);
end;

procedure TDCMasterDetailGrid.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  Message.Result := Message.Result or DLGC_WANTARROWS or DLGC_WANTCHARS or DLGC_WANTTAB;
end;

procedure TDCMasterDetailGrid.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  Message.Result := 1;
end;


procedure TDCMasterDetailGrid.WMContextMenu(var Message: TWMContextMenu);
var
  ScreenPt: TPoint;
  ClientPt: TPoint;
  Area: TDCHitTestArea;
  MasterRow: Integer;
  DetailRow: Integer;
  Col: Integer;
begin
  if FHeaderPopupShownFromMouse then
  begin
    FHeaderPopupShownFromMouse := False;
    Message.Result := 1;
    Exit;
  end;

  if not FAllowContextMenuActions then
  begin
    Message.Result := 1;
    Exit;
  end;

  ScreenPt := SmallPointToPoint(Message.Pos);
  if (ScreenPt.X = -1) and (ScreenPt.Y = -1) then
    ScreenPt := Mouse.CursorPos;

  ClientPt := ScreenToClient(ScreenPt);

  if PerformHitTest(ClientPt.X, ClientPt.Y, Area, MasterRow, DetailRow, Col) then
  begin
    case Area of
      htDetailRow:
        begin
          SelectedRow := MasterRow;
          FExpandedRow := MasterRow;
          if FDetailSelectEnabled then
            FSelectedDetailRow := DetailRow;
          if Assigned(FOnDetailRowRightClick) then
            FOnDetailRowRightClick(Self, MasterRow, DetailRow, Col, ScreenPt);
        end;
      htMasterRow, htExpandButton:
        begin
          SelectedRow := MasterRow;
          FSelectedDetailRow := -1;
          if Assigned(FOnMasterRowRightClick) then
            FOnMasterRowRightClick(Self, MasterRow, Col, ScreenPt);
        end;
      htHeader:
        begin
          if Col < 0 then
          begin
            Message.Result := 1;
            Exit;
          end;

          if Assigned(FOnHeaderRightClick) then
            FOnHeaderRightClick(Self, Col, ScreenPt);

          if FAllowHeaderFooterSummaryMenu and (Col >= 0) then
            ShowHeaderFooterSummaryMenu(Col, ScreenPt);
        end;
    end;

    if Assigned(FOnRightClickHitTest) then
      FOnRightClickHitTest(Self, Area, MasterRow, DetailRow, Col, ScreenPt);

    Invalidate;
    Message.Result := 1;
    Exit;
  end;

  Message.Result := 1;
end;

procedure TDCMasterDetailGrid.WMHScroll(var Message: TWMHScroll);
var
  LNewOffset: Integer;
  LPage: Integer;
begin
  inherited;

  LNewOffset := FHorizontalOffset;
  LPage := Max(16, ClientWidth div 2);

  case Message.ScrollCode of
    SB_LINELEFT:
      Dec(LNewOffset, 24);
    SB_LINERIGHT:
      Inc(LNewOffset, 24);
    SB_PAGELEFT:
      Dec(LNewOffset, LPage);
    SB_PAGERIGHT:
      Inc(LNewOffset, LPage);
    SB_THUMBPOSITION,
    SB_THUMBTRACK:
      LNewOffset := Message.Pos;
    SB_LEFT:
      LNewOffset := 0;
    SB_RIGHT:
      LNewOffset := GetHorizontalMax;
  end;

  SetHorizontalOffset(LNewOffset);
  Message.Result := 0;
end;

procedure TDCMasterDetailGrid.WMMouseWheel(var Message: TWMMouseWheel);
var
  LNewTop: Integer;
  LClientPt: TPoint;
  I: Integer;
  LMasterRow: Integer;
  LGridRect: TRect;
  LMaxOffset: Integer;
  LNewDetailOffset: Integer;
begin
  LClientPt := ScreenToClient(Point(Message.XPos, Message.YPos));

  if FDetailVerticalScroll and (FDetailStyle = dsGrid) then
  begin
    for I := 0 to FExpandedRows.Count - 1 do
    begin
      LMasterRow := FExpandedRows[I];
      LGridRect := GetDetailGridRect(LMasterRow);
      if PtInRect(LGridRect, LClientPt) then
      begin
        LMaxOffset := GetDetailGridMaxVerticalOffset(LMasterRow);
        if LMaxOffset > 0 then
        begin
          if FDetailScrollMasterRow <> LMasterRow then
          begin
            FDetailScrollMasterRow := LMasterRow;
            FDetailVerticalOffset := 0;
          end;

          LNewDetailOffset := FDetailVerticalOffset - Sign(Message.WheelDelta) * FDetailGridRowHeight;
          SetDetailVerticalOffset(LMasterRow, LNewDetailOffset);
          Message.Result := 1;
          Exit;
        end;
      end;
    end;
  end;

  LNewTop := FTopRow - Sign(Message.WheelDelta) * DC_DEFAULT_SCROLL_STEP;
  TopRow := LNewTop;
  Message.Result := 1;
end;

procedure TDCMasterDetailGrid.WMVScroll(var Message: TWMVScroll);
var
  LNewTop: Integer;
begin
  inherited;

  LNewTop := FTopRow;
  case Message.ScrollCode of
    SB_LINEUP:
      Dec(LNewTop);
    SB_LINEDOWN:
      Inc(LNewTop);
    SB_PAGEUP:
      Dec(LNewTop, GetVisibleMasterRows);
    SB_PAGEDOWN:
      Inc(LNewTop, GetVisibleMasterRows);
    SB_THUMBPOSITION,
    SB_THUMBTRACK:
      LNewTop := Message.Pos;
    SB_TOP:
      LNewTop := 0;
    SB_BOTTOM:
      LNewTop := MaxTopRow;
  end;

  TopRow := LNewTop;
end;

end.
