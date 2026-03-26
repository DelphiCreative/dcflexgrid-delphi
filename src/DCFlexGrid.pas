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
  System.StrUtils,
  System.IniFiles,
  System.IOUtils,
  Data.DB,
  Vcl.Controls,
  Vcl.Graphics;

const
  DC_DEFAULT_ROW_HEIGHT = 34;
  DC_DEFAULT_HEADER_HEIGHT = 38;
  DC_DEFAULT_DETAIL_HEIGHT = 84;
  DC_DEFAULT_DETAIL_GRID_HEADER_HEIGHT = 28;
  DC_DEFAULT_DETAIL_GRID_ROW_HEIGHT = 24;
  DC_DEFAULT_EXPAND_COL_WIDTH = 28;
  DC_DEFAULT_PADDING = 10;
  DC_DEFAULT_SCROLL_STEP = 3;

type
  TDCMasterDetailGrid = class;

  TDCTextAlignment = (taLeft, taCenter, taRight);
  TDCDetailStyle = (dsText, dsGrid);
  TDCExpandMode = (emSingle, emMultiple);
  TDCSortDirection = (sdNone, sdAscending, sdDescending);
  TDCHitTestArea = (htNone, htHeader, htMasterRow, htDetailRow, htExpandButton);

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
  FExpression: string;
  FBackColor: TColor;
  FFontColor: TColor;
  FFontStyles: TFontStyles;
public
  constructor Create(const AExpression: string; ABackColor: TColor; AFontColor: TColor; AFontStyles: TFontStyles);
  function Match(const AValue: Variant): Boolean;
published
  property Expression: string read FExpression write FExpression;
  property BackColor: TColor read FBackColor write FBackColor;
  property FontColor: TColor read FFontColor write FFontColor;
  property FontStyles: TFontStyles read FFontStyles write FFontStyles;
end;

TDCHighlightRules = class(TObjectList<TDCHighlightRule>)
public
  function Add(const AExpression: string; ABackColor: TColor; AFontColor: TColor = clNone; AFontStyles: TFontStyles = []): TDCHighlightRule; reintroduce;
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
  function Evaluate(const AValue: Variant; var ABackColor, AFontColor: TColor; var AFontStyles: TFontStyles): Boolean;
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
    procedure SetAlignment(const Value: TDCTextAlignment);
    procedure SetCaption(const Value: string);
    procedure SetVisible(const Value: Boolean);
    procedure SetWidth(const Value: Integer);
    procedure SetFieldName(const Value: string);
  protected
    procedure Changed;
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
  published
    property Caption: string read FCaption write SetCaption;
    property Width: Integer read FWidth write SetWidth default 120;
    property Visible: Boolean read FVisible write SetVisible default True;
    property Alignment: TDCTextAlignment read FAlignment write SetAlignment default taLeft;
    property FieldName: string read FFieldName write SetFieldName;
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
    FRowCount: Integer;
    FRowHeight: Integer;
    FHeaderHeight: Integer;
    FDetailHeight: Integer;
    FDetailGridHeaderHeight: Integer;
    FDetailGridRowHeight: Integer;
    FSelectedRow: Integer;
    FExpandedRow: Integer;
    FExpandedRows: TList<Integer>;
    FExpandMode: TDCExpandMode;
    FHoverRow: Integer;
    FTopRow: Integer;
    FShowHeader: Boolean;
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
    function GetLayoutFileName: string;
    function GetLayoutSectionName: string;
    function GetDebugLogFileName: string;
    procedure LogDebug(const AMessage: string);
    procedure SetLayoutKey(const Value: string);
    procedure SetLayoutFileName(const Value: string);
    procedure SetAutoSaveLayout(const Value: Boolean);
    procedure SetAutoLoadLayout(const Value: Boolean);
    procedure SetDataAdapter(const Value: TDCGridDataAdapter);
    procedure SetDataSetAdapter(const Value: TDCDataSetAdapter);
    procedure SetBusinessHighlight(const Value: TDCBusinessHighlight);
    procedure SetSearchText(const Value: string);
    procedure SetFilterMode(const Value: TDCFilterMode);
    procedure SetSearchScope(const Value: TDCSearchScope);
    procedure SetAutoExpandOnSearch(const Value: Boolean);
    procedure RebuildFilter;
    function GetFilteredRowCount: Integer;
    function GetActualRowCount: Integer;
    function GetActualRowIndex(AVisibleRow: Integer): Integer;
    function GetVisibleIndexOfActualRow(AActualRow: Integer): Integer;
    function RowMatchesSearch(ARow: Integer): Boolean;
    function DetailMatchesSearch(AMasterRow: Integer): Boolean;
    procedure ApplyBusinessHighlight(ARow: Integer; var ABackColor, AFontColor: TColor; var AFontStyles: TFontStyles);
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMContextMenu(var Message: TWMContextMenu); message WM_CONTEXTMENU;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
    procedure SetAlternateColors(const Value: Boolean);
    procedure SetBorderWidth(const Value: Integer);
    procedure SetAllowColumnResize(const Value: Boolean);
    procedure SetAllowColumnSort(const Value: Boolean);
    procedure SetColumns(const Value: TDCGridColumns);
    procedure SetDetailColumns(const Value: TDCGridColumns);
    procedure SetDetailGridHeaderHeight(const Value: Integer);
    procedure SetDetailGridRowHeight(const Value: Integer);
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
    procedure SetTheme(const Value: TDCGridTheme);
    procedure SetTitleFont(const Value: TFont);
    procedure SetDetailFont(const Value: TFont);
    procedure SetTopRow(const Value: Integer);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DrawBackground;
    procedure DrawBorder;
    procedure DrawHeader;
    procedure DrawRows;
    procedure DrawRow(ARow: Integer; const ARect: TRect);
    procedure DrawDetail(ARow: Integer; const ARect: TRect);
    procedure DrawDetailText(ARow: Integer; const ARect: TRect);
    procedure DrawDetailGrid(ARow: Integer; const ARect: TRect);
    function GetAccumulatedDetailHeightBeforeRow(ARow: Integer): Integer;
    function GetContentTop: Integer;
    function GetDetailDisplayText(ARow: Integer): string;
    function GetDetailGridRowCount(AMasterRow: Integer): Integer;
    function GetDetailGridCellText(AMasterRow, ADetailRow, ADetailCol: Integer): string;
    function GetCurrentDetailHeight(AMasterRow: Integer): Integer;
    function GetDetailRect(ARow: Integer): TRect;
    function GetDetailGridRect(ARow: Integer): TRect;
    function GetDetailRowAtPos(X, Y: Integer; out AMasterRow, ADetailRow: Integer): Boolean;
    function GetDisplayText(ARow, ACol: Integer): string;
    function GetExpandButtonRect(const ARowRect: TRect): TRect;
    function GetHeaderRect: TRect;
    function GetHeaderColumnAt(X, Y: Integer): Integer;
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
    function IsExpandedRowVisible: Boolean;
    function IsRowExpanded(ARow: Integer): Boolean;
    function IsPointOnExpandButton(X, Y: Integer; ARow: Integer): Boolean;
    function IsRowVisible(ARow: Integer): Boolean;
    function MaxTopRow: Integer;
    function NormalizeRowIndex(AValue: Integer): Integer;
    function RowHasDetailVisible(ARow: Integer): Boolean;
    procedure Loaded; override;
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
    procedure SaveLayout;
    procedure LoadLayout;
    procedure ResetLayout;
    property TopRow: Integer read FTopRow write SetTopRow;
    property HoverRow: Integer read FHoverRow;
    property FilteredRowCount: Integer read GetFilteredRowCount;
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
    property TitleFont: TFont read FTitleFont write SetTitleFont;
    property DetailFont: TFont read FDetailFont write SetDetailFont;

    property RowCount: Integer read FRowCount write SetRowCount default 0;
    property RowHeight: Integer read FRowHeight write SetRowHeight default DC_DEFAULT_ROW_HEIGHT;
    property HeaderHeight: Integer read FHeaderHeight write SetHeaderHeight default DC_DEFAULT_HEADER_HEIGHT;
    property DetailHeight: Integer read FDetailHeight write SetDetailHeight default DC_DEFAULT_DETAIL_HEIGHT;
    property DetailGridHeaderHeight: Integer read FDetailGridHeaderHeight write SetDetailGridHeaderHeight default DC_DEFAULT_DETAIL_GRID_HEADER_HEIGHT;
    property DetailGridRowHeight: Integer read FDetailGridRowHeight write SetDetailGridRowHeight default DC_DEFAULT_DETAIL_GRID_ROW_HEIGHT;

    property SelectedRow: Integer read FSelectedRow write SetSelectedRow default -1;
    property ExpandedRow: Integer read FExpandedRow write SetExpandedRow stored False;

    property ShowHeader: Boolean read FShowHeader write SetShowHeader default True;
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


constructor TDCHighlightRule.Create(const AExpression: string; ABackColor: TColor; AFontColor: TColor; AFontStyles: TFontStyles);
begin
  inherited Create;
  FExpression := Trim(AExpression);
  FBackColor := ABackColor;
  FFontColor := AFontColor;
  FFontStyles := AFontStyles;
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

  S := VarToStr(AValue);

  if (Copy(Expr, 1, 2) = '>=') or (Copy(Expr, 1, 2) = '<=') then
  begin
    Cmp := StrToFloatDef(Trim(Copy(Expr, 3, MaxInt)), 0);
    N := StrToFloatDef(StringReplace(S, ',', '.', [rfReplaceAll]), 0);
    if Copy(Expr, 1, 2) = '>=' then
      Result := N >= Cmp
    else
      Result := N <= Cmp;
    Exit;
  end;

  if (Expr[1] = '>') or (Expr[1] = '<') or (Expr[1] = '=') then
  begin
    RightSide := Trim(Copy(Expr, 2, MaxInt));
    if TryStrToFloat(StringReplace(S, ',', '.', [rfReplaceAll]), N) and
       TryStrToFloat(StringReplace(RightSide, ',', '.', [rfReplaceAll]), Cmp) then
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

function TDCHighlightRules.Add(const AExpression: string; ABackColor: TColor; AFontColor: TColor; AFontStyles: TFontStyles): TDCHighlightRule;
begin
  Result := TDCHighlightRule.Create(AExpression, ABackColor, AFontColor, AFontStyles);
  inherited Add(Result);
end;

constructor TDCBusinessHighlight.Create(AOwner: TDCMasterDetailGrid);
begin
  inherited Create;
  FOwner := AOwner;
  FRules := TDCHighlightRules.Create(True);
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
      FRules.Add(S.Rules[I].Expression, S.Rules[I].BackColor, S.Rules[I].FontColor, S.Rules[I].FontStyles);
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

function TDCBusinessHighlight.Evaluate(const AValue: Variant; var ABackColor, AFontColor: TColor; var AFontStyles: TFontStyles): Boolean;
var
  I: Integer;
  R: TDCHighlightRule;
begin
  Result := False;
  if not FEnabled then
    Exit;
  for I := 0 to FRules.Count - 1 do
  begin
    R := FRules[I];
    if R.Match(AValue) then
    begin
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
  FHeaderColor := $00333A46;
  FHeaderFontColor := clWhite;
  FGridBackgroundColor := $00FBFCFD;
  FRowColor := clWhite;
  FAlternateRowColor := $00F7F9FB;
  FHoverRowColor := $00FFF3E6;
  FSelectedRowColor := $00FFE5C5;
  FSelectedTextColor := $002A2F38;
  FDetailColor := $00F3F6FA;
  FBorderColor := $00D7DDE6;
  FDetailBorderColor := $00E0E6EE;
  FTextColor := $002A2F38;
  FDetailTextColor := $00313A47;
  FExpandButtonColor := $005E6A7C;
  FDetailGridHeaderColor := $00E9EEF5;
  FDetailGridHeaderFontColor := $00313A47;
  FDetailGridRowColor := clWhite;
  FDetailGridAlternateRowColor := $00F8FAFC;
  FDetailGridLineColor := $00DCE2EA;
  FSearchHighlightColor := $00FFF59D;
  FSearchHighlightTextColor := clBlack;
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
  UpdateScrollBar;
  if FAutoSaveLayout and not (csLoading in ComponentState) then
    SaveLayout;
  Invalidate;
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
  FSelectedRow := -1;
  FExpandedRow := -1;
  FHoverRow := -1;
  FTopRow := 0;
  FShowHeader := True;
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
end;

procedure TDCMasterDetailGrid.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or WS_VSCROLL or WS_TABSTOP;
end;

destructor TDCMasterDetailGrid.Destroy;
begin
  FBusinessHighlight.Free;
  FDataSetAdapter.Free;
  FFilteredRows.Free;
  FExpandedRows.Free;
  FDetailFont.Free;
  FTitleFont.Free;
  FTheme.Free;
  FDetailColumns.Free;
  FColumns.Free;
  inherited Destroy;
end;

procedure TDCMasterDetailGrid.DrawBackground;
begin
  Canvas.Brush.Color := FTheme.GridBackgroundColor;
  Canvas.FillRect(ClientRect);
end;

procedure TDCMasterDetailGrid.DrawBorder;
var
  I: Integer;
  R: TRect;
begin
  if FBorderWidth <= 0 then
    Exit;

  Canvas.Brush.Style := bsClear;
  Canvas.Pen.Color := FTheme.BorderColor;
  R := ClientRect;
  for I := 1 to FBorderWidth do
    Canvas.Rectangle(R.Left + I - 1, R.Top + I - 1, R.Right - I + 1, R.Bottom - I + 1);
  Canvas.Brush.Style := bsSolid;
end;

procedure TDCMasterDetailGrid.DrawDetail(ARow: Integer; const ARect: TRect);
var
  LHandled: Boolean;
  LInnerRect: TRect;
begin
  Canvas.Brush.Color := BlendColor(FTheme.DetailColor, clWhite, 96);
  Canvas.FillRect(ARect);

  Canvas.Pen.Color := FTheme.DetailBorderColor;
  Canvas.MoveTo(ARect.Left, ARect.Top);
  Canvas.LineTo(ARect.Right, ARect.Top);

  LInnerRect := Rect(ARect.Left + 8, ARect.Top + 6, ARect.Right - 8, ARect.Bottom - 8);
  Canvas.Brush.Color := clWhite;
  Canvas.FillRect(LInnerRect);
  Canvas.Pen.Color := BlendColor(FTheme.DetailBorderColor, clWhite, 40);
  Canvas.Rectangle(LInnerRect);

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
  Column: TDCGridColumn;
  S: string;
  Flags: Cardinal;
  HeaderColor, LRowColor, LFontColor: TColor;
  LFontStyles: TFontStyles;
  LHandled: Boolean;
begin
  GridRect := Rect(ARect.Left + DC_DEFAULT_PADDING + DC_DEFAULT_EXPAND_COL_WIDTH - 8,
                   ARect.Top + 8,
                   ARect.Right - DC_DEFAULT_PADDING,
                   ARect.Bottom - 8);

  if (GridRect.Right <= GridRect.Left) or (GridRect.Bottom <= GridRect.Top) then
    Exit;

  Canvas.Brush.Color := clWhite;
  Canvas.FillRect(GridRect);
  Canvas.Pen.Color := FTheme.DetailGridLineColor;
  Canvas.Rectangle(GridRect);

  HeaderRect := Rect(GridRect.Left, GridRect.Top, GridRect.Right,
    GridRect.Top + FDetailGridHeaderHeight);

  Canvas.Font.Assign(FTitleFont);
  Canvas.Font.Style := [fsBold];
  Canvas.Font.Color := FTheme.DetailGridHeaderFontColor;
  Canvas.Brush.Style := bsSolid;

  X := HeaderRect.Left;
  for Col := 0 to FDetailColumns.Count - 1 do
  begin
    Column := FDetailColumns[Col];
    if not Column.Visible then
      Continue;

    FullCellRect := Rect(X, HeaderRect.Top, X + Column.Width, HeaderRect.Bottom);

    LHandled := False;
    if Assigned(FOnCustomDrawHeader) then
      FOnCustomDrawHeader(Self, Canvas, FullCellRect, Col, (ARow = FDetailResizeMasterRow) and (Col = FDetailHeaderHoverColumn), False, LHandled);

    if not LHandled then
    begin
      if (ARow = FDetailResizeMasterRow) and (Col = FDetailHeaderHoverColumn) then
        HeaderColor := BlendColor(FTheme.DetailGridHeaderColor, clWhite, 22)
      else
        HeaderColor := FTheme.DetailGridHeaderColor;

      Canvas.Brush.Color := HeaderColor;
      Canvas.FillRect(FullCellRect);

      CellRect := FullCellRect;
      InflateRect(CellRect, -DC_DEFAULT_PADDING, 0);
      DrawText(Canvas.Handle, PChar(Column.Caption), Length(Column.Caption), CellRect,
        DT_VCENTER or DT_SINGLELINE or DT_LEFT or DT_NOPREFIX or DT_END_ELLIPSIS);

      Canvas.Pen.Color := FTheme.DetailGridLineColor;
      Canvas.MoveTo(FullCellRect.Right - 1, HeaderRect.Top);
      Canvas.LineTo(FullCellRect.Right - 1, GridRect.Bottom);
    end;

    Inc(X, Column.Width);
  end;

  DetailRows := GetDetailGridRowCount(ARow);
  Y := HeaderRect.Bottom;
  Canvas.Font.Assign(FDetailFont);

  for Row := 0 to DetailRows - 1 do
  begin
    if Y >= GridRect.Bottom then
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

    Canvas.Brush.Color := LRowColor;
    Canvas.FillRect(Rect(GridRect.Left + 1, Y, GridRect.Right - 1,
      Min(Y + FDetailGridRowHeight, GridRect.Bottom - 1)));

    if FDetailSelectEnabled and (ARow = FExpandedRow) and (Row = FSelectedDetailRow) then
    begin
      Canvas.Brush.Color := BlendColor(FTheme.SelectedRowColor, clBlack, 10);
      Canvas.FillRect(Rect(GridRect.Left + 1, Y, GridRect.Left + 4, Min(Y + FDetailGridRowHeight, GridRect.Bottom - 1)));
    end;

    Canvas.Font.Assign(FDetailFont);
    Canvas.Font.Color := LFontColor;
    Canvas.Font.Style := LFontStyles;

    X := GridRect.Left;
    for Col := 0 to FDetailColumns.Count - 1 do
    begin
      Column := FDetailColumns[Col];
      if not Column.Visible then
        Continue;

      FullCellRect := Rect(X, Y, X + Column.Width, Min(Y + FDetailGridRowHeight, GridRect.Bottom - 1));
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
      Canvas.LineTo(X - 1, Min(Y + FDetailGridRowHeight, GridRect.Bottom - 1));
    end;

    Canvas.Pen.Color := FTheme.DetailGridLineColor;
    Canvas.MoveTo(GridRect.Left, Min(Y + FDetailGridRowHeight, GridRect.Bottom - 1));
    Canvas.LineTo(GridRect.Right, Min(Y + FDetailGridRowHeight, GridRect.Bottom - 1));

    Inc(Y, FDetailGridRowHeight);
  end;

  Canvas.Brush.Style := bsSolid;
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
  LHandled: Boolean;
begin
  if not FShowHeader then
    Exit;

  R := GetHeaderRect;
  Canvas.Brush.Color := FTheme.HeaderColor;
  Canvas.FillRect(R);

  Canvas.Pen.Color := BlendColor(FTheme.HeaderColor, clWhite, 25);
  Canvas.MoveTo(R.Left, R.Top);
  Canvas.LineTo(R.Right, R.Top);

  Canvas.Font.Assign(FTitleFont);
  Canvas.Font.Style := [fsBold];
  Canvas.Font.Color := FTheme.HeaderFontColor;
  Canvas.Brush.Style := bsClear;

  X := R.Left;
  if FShowExpandButton then
    Inc(X, DC_DEFAULT_EXPAND_COL_WIDTH);

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
      if I = FHeaderHoverColumn then
      begin
        Canvas.Brush.Color := BlendColor(FTheme.HeaderColor, clWhite, 18);
        Canvas.FillRect(LColRect);
        Canvas.Brush.Style := bsClear;
      end;

      if I = FSortedColumn then
      begin
        Canvas.Brush.Color := BlendColor(FTheme.HeaderColor, clBlack, 28);
        Canvas.FillRect(LColRect);
        Canvas.Brush.Style := bsClear;
      end;

      LTextRect := Rect(X + DC_DEFAULT_PADDING, R.Top, X + LCol.Width - DC_DEFAULT_PADDING - 14, R.Bottom);
      DrawText(Canvas.Handle, PChar(LCol.Caption), Length(LCol.Caption), LTextRect,
        DT_VCENTER or DT_SINGLELINE or DT_LEFT or DT_NOPREFIX or DT_END_ELLIPSIS);

      if I = FSortedColumn then
      begin
        Canvas.Brush.Color := FTheme.HeaderFontColor;
        if FSortDirection = sdAscending then
        begin
          Pts[0] := Point(LColRect.Right - 14, LColRect.Bottom - 12);
          Pts[1] := Point(LColRect.Right - 6, LColRect.Bottom - 12);
          Pts[2] := Point(LColRect.Right - 10, LColRect.Top + 10);
          Canvas.Polygon(Pts);
        end
        else if FSortDirection = sdDescending then
        begin
          Pts[0] := Point(LColRect.Right - 14, LColRect.Top + 12);
          Pts[1] := Point(LColRect.Right - 6, LColRect.Top + 12);
          Pts[2] := Point(LColRect.Right - 10, LColRect.Bottom - 10);
          Canvas.Polygon(Pts);
        end;
        Canvas.Brush.Style := bsClear;
      end;

      Canvas.Pen.Color := $00505866;
      Canvas.MoveTo(X + LCol.Width - 1, R.Top + 6);
      Canvas.LineTo(X + LCol.Width - 1, R.Bottom - 6);
    end;

    Inc(X, LCol.Width);
  end;

  Canvas.Pen.Color := BlendColor(FTheme.HeaderColor, clBlack, 50);
  Canvas.MoveTo(R.Left, R.Bottom - 1);
  Canvas.LineTo(R.Right, R.Bottom - 1);

  Canvas.Pen.Color := BlendColor(FTheme.SelectedRowColor, FTheme.HeaderColor, 180);
  Canvas.MoveTo(R.Left, R.Bottom - 2);
  Canvas.LineTo(R.Right, R.Bottom - 2);
  Canvas.Brush.Style := bsSolid;
end;


procedure TDCMasterDetailGrid.ApplyBusinessHighlight(ARow: Integer; var ABackColor, AFontColor: TColor; var AFontStyles: TFontStyles);
var
  V: Variant;
begin
  if (not Assigned(FBusinessHighlight)) or (not FBusinessHighlight.Enabled) then
    Exit;
  if Trim(FBusinessHighlight.Field) = '' then
    Exit;
  if not (FDataAdapter is TDCDataSetAdapter) then
    Exit;

  V := TDCDataSetAdapter(FDataAdapter).GetFieldValueByName(ARow, FBusinessHighlight.Field);
  if VarIsNull(V) then
    Exit;

  FBusinessHighlight.Evaluate(V, ABackColor, AFontColor, AFontStyles);
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
  LRowColor, LFontColor: TColor;
  LFontStyles: TFontStyles;
begin
  if ARow = FSelectedRow then
    LRowColor := FTheme.SelectedRowColor
  else if ARow = FHoverRow then
    LRowColor := FTheme.HoverRowColor
  else if FAlternateColors and Odd(ARow) then
    LRowColor := FTheme.AlternateRowColor
  else
    LRowColor := FTheme.RowColor;

  LFontColor := FTheme.TextColor;
  if ARow = FSelectedRow then
    LFontStyles := [fsBold]
  else
    LFontStyles := [];

  if ARow <> FSelectedRow then
    ApplyBusinessHighlight(ARow, LRowColor, LFontColor, LFontStyles);

  if Assigned(FOnGetMasterRowStyle) then
    FOnGetMasterRowStyle(Self, ARow, LRowColor, LFontColor, LFontStyles);

  Canvas.Brush.Color := LRowColor;
  Canvas.FillRect(ARect);

  if ARow = FSelectedRow then
  begin
    Canvas.Brush.Color := BlendColor(FTheme.ExpandButtonColor, clWhite, 20);
    Canvas.FillRect(Rect(ARect.Left, ARect.Top, ARect.Left + 4, ARect.Bottom));
  end;

  Canvas.Pen.Color := BlendColor(FTheme.BorderColor, clWhite, 20);
  Canvas.MoveTo(ARect.Left, ARect.Bottom - 1);
  Canvas.LineTo(ARect.Right, ARect.Bottom - 1);

  X := ARect.Left;

  if FShowExpandButton then
  begin
    LExpandRect := GetExpandButtonRect(ARect);
    Canvas.Brush.Style := bsClear;
    Canvas.Pen.Color := FTheme.ExpandButtonColor;

    if ARow = FExpandedRow then
    begin
      Pts[0] := Point(LExpandRect.Left + 5, LExpandRect.Top + 8);
      Pts[1] := Point(LExpandRect.Right - 5, LExpandRect.Top + 8);
      Pts[2] := Point((LExpandRect.Left + LExpandRect.Right) div 2, LExpandRect.Bottom - 6);
    end
    else
    begin
      Pts[0] := Point(LExpandRect.Left + 7, LExpandRect.Top + 5);
      Pts[1] := Point(LExpandRect.Right - 6, (LExpandRect.Top + LExpandRect.Bottom) div 2);
      Pts[2] := Point(LExpandRect.Left + 7, LExpandRect.Bottom - 5);
    end;

    Canvas.Brush.Color := BlendColor(FTheme.ExpandButtonColor, clWhite, 10);
    Canvas.Polygon(Pts);
    Canvas.Brush.Style := bsSolid;
    Inc(X, DC_DEFAULT_EXPAND_COL_WIDTH);
  end;

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
        Canvas.Font.Color := LFontColor;
        if (Trim(FSearchText) <> '') and ContainsTextEx(LText, FSearchText) then
        begin
          Canvas.Brush.Style := bsSolid;
          Canvas.Brush.Color := BlendColor(FTheme.SearchHighlightColor, LRowColor, 120);
          Canvas.FillRect(LCellRect);
          Canvas.Font.Color := FTheme.SearchHighlightTextColor;
          Canvas.Brush.Style := bsClear;
        end;
        DrawText(Canvas.Handle, PChar(LText), Length(LText), LCellRect,
          DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX or DT_END_ELLIPSIS or LFlags);
      end;
    end;

    Inc(X, LCol.Width);
  end;

  if Focused and (ARow = FSelectedRow) then
  begin
    Canvas.Brush.Style := bsClear;
    Canvas.Pen.Color := BlendColor(FTheme.ExpandButtonColor, clWhite, 10);
    DrawFocusRect(Canvas.Handle, Rect(ARect.Left + 6, ARect.Top + 4, ARect.Right - 6, ARect.Bottom - 4));
  end;

  Canvas.Brush.Style := bsSolid;
end;

procedure TDCMasterDetailGrid.DrawRows;
var
  I, ARow: Integer;
  LRowRect: TRect;
begin
  if GetActualRowCount <= 0 then
    Exit;

  for I := FTopRow to GetActualRowCount - 1 do
  begin
    ARow := GetActualRowIndex(I);
    if ARow < 0 then
      Continue;

    LRowRect := GetRowRect(I);
    if LRowRect.Top >= ClientHeight then
      Break;

    if IsRowVisible(I) then
    begin
      DrawRow(ARow, LRowRect);
      if RowHasDetailVisible(ARow) then
        DrawDetail(ARow, GetDetailRect(ARow));
    end;
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
begin
  Result := 0;
  if FExpandedRows.Count = 0 then
    Exit;

  for I := 0 to FExpandedRows.Count - 1 do
    if (FExpandedRows[I] >= FTopRow) and (FExpandedRows[I] < ARow) then
      Inc(Result, GetCurrentDetailHeight(FExpandedRows[I]));
end;

function TDCMasterDetailGrid.GetContentTop: Integer;
begin
  if FShowHeader then
    Result := FHeaderHeight
  else
    Result := 0;
end;

function TDCMasterDetailGrid.GetCurrentDetailHeight(AMasterRow: Integer): Integer;
var
  LRows: Integer;
  LGridHeight: Integer;
begin
  if FDetailStyle = dsGrid then
  begin
    LRows := GetDetailGridRowCount(AMasterRow);
    if LRows <= 0 then
      LRows := 1;

    LGridHeight := FDetailGridHeaderHeight + (LRows * FDetailGridRowHeight);

    { Total padding consumed until the detail grid usable area:
      - outer detail card: Top +6 / Bottom +8
      - inner grid area:   Top +8 / Bottom +8
      Total: 30 px }
    Result := 34 + LGridHeight;

    if Result < 66 then
      Result := 66;
  end
  else
    Result := FDetailHeight;
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

    HeaderRect := Rect(GridRect.Left, GridRect.Top, GridRect.Right,
      GridRect.Top + FDetailGridHeaderHeight);
    if PtInRect(HeaderRect, Point(X, Y)) then
      Exit;

    DetailRows := GetDetailGridRowCount(LMasterRow);
    RowTop := HeaderRect.Bottom;
    for I := 0 to DetailRows - 1 do
    begin
      if PtInRect(Rect(GridRect.Left, RowTop, GridRect.Right,
        RowTop + FDetailGridRowHeight), Point(X, Y)) then
      begin
        AMasterRow := LMasterRow;
        ADetailRow := I;
        Exit(True);
      end;
      Inc(RowTop, FDetailGridRowHeight);
      if RowTop >= GridRect.Bottom then
        Break;
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
begin
  if FShowHeader then
    Result := Rect(0, 0, ClientWidth, FHeaderHeight)
  else
    Result := Rect(0, 0, 0, 0);
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

  CurrentX := 0;
  if FShowExpandButton then
    Inc(CurrentX, DC_DEFAULT_EXPAND_COL_WIDTH);

  for I := 0 to FColumns.Count - 1 do
  begin
    LCol := FColumns[I];
    if not LCol.Visible then
      Continue;

    if (X >= CurrentX) and (X < CurrentX + LCol.Width) then
      Exit(I);

    Inc(CurrentX, LCol.Width);
  end;
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
  CurrentX := 0;
  if FShowExpandButton then
    Inc(CurrentX, DC_DEFAULT_EXPAND_COL_WIDTH);

  for I := 0 to FColumns.Count - 1 do
  begin
    LCol := FColumns[I];
    if not LCol.Visible then
      Continue;

    Inc(CurrentX, LCol.Width);
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

    CurrentX := GridRect.Left;
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

    CurrentX := GridRect.Left;
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

  CurrentX := RowRect.Left;
  if FShowExpandButton then
    Inc(CurrentX, DC_DEFAULT_EXPAND_COL_WIDTH);

  for I := 0 to FColumns.Count - 1 do
  begin
    LCol := FColumns[I];
    if not LCol.Visible then
      Continue;

    if (X >= CurrentX) and (X < CurrentX + LCol.Width) then
      Exit(I);

    Inc(CurrentX, LCol.Width);
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

  CurrentX := GridRect.Left;
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
    if LRowRect.Top >= ClientHeight then
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
end;

function TDCMasterDetailGrid.GetVisibleMasterRows: Integer;
var
  LHeight: Integer;
begin
  LHeight := ClientHeight - GetContentTop;
  if LHeight <= 0 then
    Exit(0);
  Result := Max(1, LHeight div FRowHeight);
end;

function TDCMasterDetailGrid.IsExpandedRowVisible: Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to FExpandedRows.Count - 1 do
    if (FExpandedRows[I] >= FTopRow) and IsRowVisible(FExpandedRows[I]) then
      Exit(True);
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
  Result := (R.Bottom > GetContentTop) and (R.Top < ClientHeight);
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

  UpdateScrollBar;
end;

function TDCMasterDetailGrid.MaxTopRow: Integer;
var
  I: Integer;
  LViewportHeight: Integer;
  LAccumulatedHeight: Integer;
  LActualRow: Integer;
begin
  LViewportHeight := ClientHeight - GetContentTop;
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
  LDetailMasterRow: Integer;
  LDetailRow: Integer;
begin
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

  LHeaderColumn := GetHeaderColumnAt(X, Y);
  if LHeaderColumn <> -1 then
  begin
    SetFocus;
    if Assigned(FOnHeaderClick) then
      FOnHeaderClick(Self, LHeaderColumn);
    if FAllowColumnSort then
      ToggleSortForColumn(LHeaderColumn);
    Exit;
  end;

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
  LNeedInvalidate: Boolean;
begin
  inherited MouseMove(Shift, X, Y);

  if FResizingColumn <> -1 then
  begin
    LNewWidth := FResizeColumnStartWidth + (X - FResizeStartX);
    FColumns[FResizingColumn].Width := Max(FMinColumnWidth, LNewWidth);
    Cursor := crHSplit;
    Invalidate;
    Exit;
  end;

  if FDetailResizingColumn <> -1 then
  begin
    LNewWidth := FResizeColumnStartWidth + (X - FResizeStartX);
    FDetailColumns[FDetailResizingColumn].Width := Max(FMinColumnWidth, LNewWidth);
    Cursor := crHSplit;
    Invalidate;
    Exit;
  end;

  if GetHeaderResizeColumn(X, Y) <> -1 then
    Cursor := crHSplit
  else if GetDetailHeaderResizeColumn(X, Y, LDetailMasterRow) <> -1 then
    Cursor := crHSplit
  else
    Cursor := crDefault;

  LNeedInvalidate := False;

  LHeaderCol := GetHeaderColumnAt(X, Y);
  if FHeaderHoverColumn <> LHeaderCol then
  begin
    FHeaderHoverColumn := LHeaderCol;
    LNeedInvalidate := True;
  end;

  LDetailRow := GetDetailHeaderColumnAt(X, Y, LDetailMasterRow);
  if (FDetailHeaderHoverColumn <> LDetailRow) or ((LDetailRow <> -1) and (FDetailResizeMasterRow <> LDetailMasterRow)) then
  begin
    FDetailHeaderHoverColumn := LDetailRow;
    if LDetailRow <> -1 then
      FDetailResizeMasterRow := LDetailMasterRow
    else if FDetailResizingColumn = -1 then
      FDetailResizeMasterRow := -1;
    LNeedInvalidate := True;
  end;

  LOldHover := FHoverRow;
  FHoverRow := GetActualRowIndex(GetRowAtPos(X, Y));

  LOldDetailHover := FHoverDetailRow;
  if GetDetailRowAtPos(X, Y, LDetailMasterRow, LDetailRow) then
    FHoverDetailRow := LDetailRow
  else
    FHoverDetailRow := -1;

  if (LOldHover <> FHoverRow) or (LOldDetailHover <> FHoverDetailRow) then
    LNeedInvalidate := True;

  if LNeedInvalidate then
    Invalidate;
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
  DrawBackground;
  DrawHeader;
  DrawRows;
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
  UpdateScrollBar;
  Invalidate;
end;

function TDCMasterDetailGrid.RowHasDetailVisible(ARow: Integer): Boolean;
begin
  Result := IsRowExpanded(ARow) and IsRowVisible(ARow);
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

procedure TDCMasterDetailGrid.SetTheme(const Value: TDCGridTheme);
begin
  FTheme.Assign(Value);
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

  Invalidate;
end;


function TDCMasterDetailGrid.GetLayoutFileName: string;
begin
  if Trim(FLayoutFileName) <> '' then
    Result := FLayoutFileName
  else
    Result := ChangeFileExt(ParamStr(0), '.dcgrid.ini');
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

procedure TDCMasterDetailGrid.SetAutoSaveLayout(const Value: Boolean);
begin
  FAutoSaveLayout := Value;
end;

procedure TDCMasterDetailGrid.SaveLayout;
var
  Ini: TIniFile;
  I: Integer;
  Section: string;
begin
  Ini := TIniFile.Create(GetLayoutFileName);
  try
    Section := GetLayoutSectionName;
    Ini.WriteInteger(Section, 'ColumnCount', FColumns.Count);
    for I := 0 to FColumns.Count - 1 do
      Ini.WriteInteger(Section, Format('ColWidth%d', [I]), FColumns[I].Width);

    Ini.WriteInteger(Section, 'DetailColumnCount', FDetailColumns.Count);
    for I := 0 to FDetailColumns.Count - 1 do
      Ini.WriteInteger(Section, Format('DetailColWidth%d', [I]), FDetailColumns[I].Width);

    Ini.WriteInteger(Section, 'SortedColumn', FSortedColumn);
    Ini.WriteInteger(Section, 'SortDirection', Ord(FSortDirection));
    Ini.WriteInteger(Section, 'ExpandMode', Ord(FExpandMode));
  finally
    Ini.Free;
  end;
end;

procedure TDCMasterDetailGrid.LoadLayout;
var
  Ini: TIniFile;
  I: Integer;
  Section: string;
  V: Integer;
begin

  if not FileExists(GetLayoutFileName) then
    Exit;

  Ini := TIniFile.Create(GetLayoutFileName);
  try
    Section := GetLayoutSectionName;
    if not Ini.SectionExists(Section) then
      Exit;

    for I := 0 to FColumns.Count - 1 do
    begin
      V := Ini.ReadInteger(Section, Format('ColWidth%d', [I]), FColumns[I].Width);
      FColumns[I].Width := Max(FMinColumnWidth, V);
    end;

    for I := 0 to FDetailColumns.Count - 1 do
    begin
      V := Ini.ReadInteger(Section, Format('DetailColWidth%d', [I]), FDetailColumns[I].Width);
      FDetailColumns[I].Width := Max(FMinColumnWidth, V);
    end;

    FSortedColumn := Ini.ReadInteger(Section, 'SortedColumn', FSortedColumn);
    V := Ini.ReadInteger(Section, 'SortDirection', Ord(FSortDirection));
    if (V >= Ord(Low(TDCSortDirection))) and (V <= Ord(High(TDCSortDirection))) then
      FSortDirection := TDCSortDirection(V);

    V := Ini.ReadInteger(Section, 'ExpandMode', Ord(FExpandMode));
    if (V >= Ord(Low(TDCExpandMode))) and (V <= Ord(High(TDCExpandMode))) then
      FExpandMode := TDCExpandMode(V);
  finally
    Ini.Free;
  end;

  UpdateScrollBar;
  Invalidate;
end;

procedure TDCMasterDetailGrid.ResetLayout;
var
  Ini: TIniFile;
  Section: string;
begin
  Ini := TIniFile.Create(GetLayoutFileName);
  try
    Section := GetLayoutSectionName;
    Ini.EraseSection(Section);
  finally
    Ini.Free;
  end;
end;


function TDCMasterDetailGrid.GetFilteredRowCount: Integer;
begin
  if FSearchText <> '' then
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
  if FSearchText <> '' then
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
  if FSearchText <> '' then
    Result := FFilteredRows.IndexOf(AActualRow)
  else
    Result := AActualRow;
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

  if Trim(FSearchText) <> '' then
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
    if FAutoExpandOnSearch then
    begin
      FExpandedRows.Clear;
      FExpandedRow := -1;
    end;
  end;

  if (FSelectedRow <> -1) and (Trim(FSearchText) <> '') and (FFilteredRows.IndexOf(FSelectedRow) = -1) then
    FSelectedRow := -1;

  if FTopRow > MaxTopRow then
    FTopRow := MaxTopRow;
  UpdateScrollBar;
  Invalidate;
end;

procedure TDCMasterDetailGrid.SetSearchText(const Value: string);
begin
  if FSearchText <> Value then
  begin
    FSearchText := Value;
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
  Invalidate;
end;

procedure TDCMasterDetailGrid.ToggleRowExpand(ARow: Integer);
begin
  if IsRowExpanded(ARow) then
    CollapseRow(ARow)
  else
    ExpandRow(ARow);
end;

procedure TDCMasterDetailGrid.UpdateScrollBar;
var
  SI: TScrollInfo;
  LPageRows: Integer;
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
          if Assigned(FOnHeaderRightClick) then
            FOnHeaderRightClick(Self, Col, ScreenPt);
        end;
    end;

    if Assigned(FOnRightClickHitTest) then
      FOnRightClickHitTest(Self, Area, MasterRow, DetailRow, Col, ScreenPt);

    Invalidate;
  end;

  inherited;
end;

procedure TDCMasterDetailGrid.WMMouseWheel(var Message: TWMMouseWheel);
var
  LNewTop: Integer;
begin
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