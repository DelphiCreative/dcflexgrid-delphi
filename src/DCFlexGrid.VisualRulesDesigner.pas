unit DCFlexGrid.VisualRulesDesigner;

interface

uses
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  System.JSON,
  System.Math,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Controls,
  Vcl.Graphics,
  DCFlex.Language,
  DCFlex.Theme,
  DCFlex.Dialogs,
  DCFlexGrid,
  DCFlex.Controls;

type
  TDCFlexGridVisualRulesDesigner = class(TForm)
  private
    FGrid: TDCMasterDetailGrid;
    FLanguage: TDCGridLang;
    FEditingIndex: Integer;
    FOriginalExpandOnRowClick: Boolean;
    FOriginalShowExpandButton: Boolean;

    pnlHeader: TPanel;
    pnlEditor: TPanel;
    pnlFooter: TPanel;
    pnlPreview: TPanel;

    lblTitle: TLabel;
    lblSubtitle: TLabel;
    lblSectionRules: TLabel;
    lblSectionActions: TLabel;
    lblSectionRuleSetup: TLabel;
    lblField: TLabel;
    lblCondition: TLabel;
    lblValue: TLabel;
    lblApplyTo: TLabel;
    lblBack: TLabel;
    lblFont: TLabel;
    lblPreview: TLabel;
    lblPreviewHint: TLabel;
    lblStatus: TLabel;

    cbField: TDCFlexComboBox;
    cbCondition: TDCFlexComboBox;
    edtValue: TDCFlexEdit;
    cbTarget: TDCFlexComboBox;
    cbBack: TDCFlexColorPaletteButton;
    cbFont: TDCFlexColorPaletteButton;
    chkBold: TDCFlexToggleButton;
    chkItalic: TDCFlexToggleButton;
    chkUnderline: TDCFlexToggleButton;

    btnAdd: TDCFlexButton;
    btnRemove: TDCFlexButton;
    btnClear: TDCFlexButton;
    btnClose: TDCFlexButton;

    grdRules: TDCFlexGrid;
    pnlSample: TPanel;
    lblSample: TLabel;

    procedure BuildUI;
    procedure LoadFields;
    procedure LoadConditions;
    procedure LoadTargets;
    procedure RefreshRulesGrid;
    procedure UpdatePreview;
    procedure SyncSelectedRuleToEditor;
    procedure ClearEditor;
    procedure ApplyLanguage;
    procedure ApplyTheme;
    procedure SetLanguage(ALanguage: TDCGridLang);
    procedure SetStatus(const AText: string);
    procedure NormalizeDpiScale;
    procedure BeginDesignerMode;
    procedure EndDesignerMode;
    function BuildRulesFileName: string;
    function BuildPreferencesFileName: string;
    procedure AutoLoadRules;
    procedure AutoSaveRules;
    procedure AutoLoadPreferences;
    procedure AutoSavePreferences;
    procedure ApplyGridLanguage;
    function BuildExpression: string;
    function ConditionFromExpression(const AExpr: string): string;
    function ValueFromExpression(const AExpr: string): string;
    function StylesToText(const AStyles: TFontStyles): string;
    function FindFieldIndexByFieldName(const AFieldName: string): Integer;
    function GetSelectedFieldName: string;
    function GetSelectedTarget: TDCHighlightTarget;
    function TargetToText(ATarget: TDCHighlightTarget): string;
    procedure AddRuleClick(Sender: TObject);
    procedure RemoveRuleClick(Sender: TObject);
    procedure ClearRulesClick(Sender: TObject);
    procedure CloseClick(Sender: TObject);
    procedure EditorChanged(Sender: TObject);
    procedure RulesGridGetCellText(Sender: TObject; ARow, ACol: Integer; var AText: string);
    procedure RulesGridRowClick(Sender: TObject; ARow: Integer);
    procedure RulesGridDblClick(Sender: TObject);
  protected
    procedure DoClose(var Action: TCloseAction); override;
  public
    constructor CreateDesigner(AOwner: TComponent; AGrid: TDCMasterDetailGrid); reintroduce;
    destructor Destroy; override;
    procedure ApplyCustomLanguage(ALanguage: TDCGridLang);
  end;

procedure ShowDCFlexGridVisualRulesDesigner(AGrid: TDCMasterDetailGrid);

implementation

function ShowRulesDesignerConfirm(AOwner: TComponent; ALanguage: TDCGridLang): Boolean;
var
  LTitleText: string;
  LMessageText: string;
  LCancelText: string;
  LClearText: string;
begin
  LTitleText := Trim(ALanguage.ConfirmClearTitle);
  if LTitleText = '' then
    LTitleText := ALanguage.ClearAllCaption;

  LMessageText := Trim(ALanguage.ConfirmClearMessage);
  if LMessageText = '' then
    LMessageText := 'All visual rules will be removed.';

  LCancelText := Trim(ALanguage.CancelCaption);
  if LCancelText = '' then
    LCancelText := 'Cancel';

  LClearText := Trim(ALanguage.ClearAllCaption);
  if LClearText = '' then
    LClearText := 'Clear all';

  Result := DCFlexConfirm(AOwner, LTitleText, LMessageText, LClearText,
    LClearText, LCancelText, ddkWarning) = dcrConfirm;
end;

{ TDCFlexGridVisualRulesDesigner }

constructor TDCFlexGridVisualRulesDesigner.CreateDesigner(AOwner: TComponent; AGrid: TDCMasterDetailGrid);
begin
  inherited CreateNew(AOwner);
  FGrid := AGrid;
  FLanguage := nil;
  FEditingIndex := -1;

  BorderStyle := bsDialog;
  BorderIcons := [biSystemMenu];
  Position := poScreenCenter;
  Width := 1040;
  Height := 620;
  Color := clWhite;
  Font.Name := 'Segoe UI';
  Font.Size := 9;
  KeyPreview := True;
  Caption := 'Visual Rules Designer';

  BeginDesignerMode;
  BuildUI;
  NormalizeDpiScale;
  ApplyGridLanguage;
  LoadFields;
  LoadConditions;
  LoadTargets;
  AutoLoadRules;
  RefreshRulesGrid;
  AutoLoadPreferences;
  ApplyTheme;
  UpdatePreview;
  SetStatus(FLanguage.StatusReady);
end;

destructor TDCFlexGridVisualRulesDesigner.Destroy;
begin
  FLanguage.Free;
  inherited;
end;

procedure TDCFlexGridVisualRulesDesigner.DoClose(var Action: TCloseAction);
begin
  AutoSaveRules;
  AutoSavePreferences;
  EndDesignerMode;
  inherited;
end;

procedure TDCFlexGridVisualRulesDesigner.ApplyCustomLanguage(ALanguage: TDCGridLang);
begin
  SetLanguage(ALanguage);
end;

procedure TDCFlexGridVisualRulesDesigner.SetLanguage(ALanguage: TDCGridLang);
begin
  if not Assigned(ALanguage) then
    Exit;
  FLanguage.Free;
  FLanguage := ALanguage;
  ApplyLanguage;
  LoadConditions;
  LoadTargets;
  RefreshRulesGrid;
  UpdatePreview;
end;

procedure TDCFlexGridVisualRulesDesigner.BuildUI;
const
  UI_LABEL_FONT_SIZE = 8;
  UI_INPUT_FONT_SIZE = 8;
  UI_INPUT_HEIGHT = 24;
  UI_SECTION_FONT_SIZE = 10;
  UI_SMALL_BUTTON_FONT_SIZE = 8;
var
  LTopDivider: TShape;
  LEditorCard: TPanel;
  LRulesHeader: TPanel;
  LPreviewCard: TPanel;
  LFooterDivider: TShape;
begin
  Color := $00F5F7FA;

  pnlHeader := TPanel.Create(Self);
  pnlHeader.Parent := Self;
  pnlHeader.Align := alTop;
  pnlHeader.Height := 72;
  pnlHeader.BevelOuter := bvNone;
  pnlHeader.Color := clWhite;
  pnlHeader.ParentBackground := False;

  lblTitle := TLabel.Create(Self);
  lblTitle.Parent := pnlHeader;
  lblTitle.Left := 24;
  lblTitle.Top := 14;
  lblTitle.Font.Name := 'Segoe UI Semibold';
  lblTitle.Font.Size := 15;
  lblTitle.Font.Style := [fsBold];
  lblTitle.Font.Color := $00253445;
  lblTitle.Transparent := True;

  lblSubtitle := TLabel.Create(Self);
  lblSubtitle.Parent := pnlHeader;
  lblSubtitle.Left := 24;
  lblSubtitle.Top := 45;
  lblSubtitle.Font.Name := 'Segoe UI';
  lblSubtitle.Font.Size := 9;
  lblSubtitle.Font.Color := $006B7785;
  lblSubtitle.Transparent := True;

  LTopDivider := TShape.Create(Self);
  LTopDivider.Parent := pnlHeader;
  LTopDivider.Align := alBottom;
  LTopDivider.Height := 1;
  LTopDivider.Brush.Color := $00E2E8F0;
  LTopDivider.Pen.Style := psClear;

  pnlEditor := TPanel.Create(Self);
  pnlEditor.Parent := Self;
  pnlEditor.Align := alTop;
  pnlEditor.Height := 198;
  pnlEditor.BevelOuter := bvNone;
  pnlEditor.Color := $00F5F7FA;
  pnlEditor.ParentBackground := False;

  LEditorCard := TPanel.Create(Self);
  LEditorCard.Parent := pnlEditor;
  LEditorCard.Align := alClient;
  LEditorCard.AlignWithMargins := True;
  LEditorCard.Margins.Left := 18;
  LEditorCard.Margins.Top := 14;
  LEditorCard.Margins.Right := 18;
  LEditorCard.Margins.Bottom := 10;
  LEditorCard.BevelOuter := bvNone;
  LEditorCard.Color := clWhite;
  LEditorCard.ParentBackground := False;

  lblSectionRuleSetup := TLabel.Create(Self);
  lblSectionRuleSetup.Parent := LEditorCard;
  lblSectionRuleSetup.Left := 20;
  lblSectionRuleSetup.Top := 16;
  lblSectionRuleSetup.Font.Name := 'Segoe UI Semibold';
  lblSectionRuleSetup.Font.Style := [fsBold];
  lblSectionRuleSetup.Font.Size := UI_SECTION_FONT_SIZE;
  lblSectionRuleSetup.Font.Color := $00253445;
  lblSectionRuleSetup.Caption := 'Rule setup';

  lblField := TLabel.Create(Self);
  lblField.Parent := LEditorCard;
  lblField.Left := 20;
  lblField.Top := 50;
  lblField.Font.Name := 'Segoe UI';
  lblField.Font.Size := UI_LABEL_FONT_SIZE;
  lblField.Font.Color := $004A5663;

  cbField := TDCFlexComboBox.Create(Self);
  cbField.Parent := LEditorCard;
  cbField.Left := 20;
  cbField.Top := 70;
  cbField.Width := 184;
  cbField.Height := UI_INPUT_HEIGHT;
  cbField.Font.Name := 'Segoe UI';
  cbField.Font.Size := UI_INPUT_FONT_SIZE;
  cbField.Style := csDropDownList;
  cbField.OnChange := EditorChanged;

  lblCondition := TLabel.Create(Self);
  lblCondition.Parent := LEditorCard;
  lblCondition.Left := 226;
  lblCondition.Top := 50;
  lblCondition.Font.Name := 'Segoe UI';
  lblCondition.Font.Size := UI_LABEL_FONT_SIZE;
  lblCondition.Font.Color := $004A5663;

  cbCondition := TDCFlexComboBox.Create(Self);
  cbCondition.Parent := LEditorCard;
  cbCondition.Left := 226;
  cbCondition.Top := 70;
  cbCondition.Width := 184;
  cbCondition.Height := UI_INPUT_HEIGHT;
  cbCondition.Font.Name := 'Segoe UI';
  cbCondition.Font.Size := UI_INPUT_FONT_SIZE;
  cbCondition.Style := csDropDownList;
  cbCondition.OnChange := EditorChanged;

  lblValue := TLabel.Create(Self);
  lblValue.Parent := LEditorCard;
  lblValue.Left := 432;
  lblValue.Top := 50;
  lblValue.Font.Name := 'Segoe UI';
  lblValue.Font.Size := UI_LABEL_FONT_SIZE;
  lblValue.Font.Color := $004A5663;

  edtValue := TDCFlexEdit.Create(Self);
  edtValue.Parent := LEditorCard;
  edtValue.Left := 432;
  edtValue.Top := 70;
  edtValue.Width := 324;
  edtValue.Height := UI_INPUT_HEIGHT;
  edtValue.Font.Name := 'Segoe UI';
  edtValue.Font.Size := UI_INPUT_FONT_SIZE;
  edtValue.OnChange := EditorChanged;

  lblApplyTo := TLabel.Create(Self);
  lblApplyTo.Parent := LEditorCard;
  lblApplyTo.Left := 778;
  lblApplyTo.Top := 50;
  lblApplyTo.Font.Name := 'Segoe UI';
  lblApplyTo.Font.Size := UI_LABEL_FONT_SIZE;
  lblApplyTo.Font.Color := $004A5663;

  cbTarget := TDCFlexComboBox.Create(Self);
  cbTarget.Parent := LEditorCard;
  cbTarget.Left := 778;
  cbTarget.Top := 70;
  cbTarget.Width := 184;
  cbTarget.Height := UI_INPUT_HEIGHT;
  cbTarget.Font.Name := 'Segoe UI';
  cbTarget.Font.Size := UI_INPUT_FONT_SIZE;
  cbTarget.Style := csDropDownList;
  cbTarget.OnChange := EditorChanged;

  lblBack := TLabel.Create(Self);
  lblBack.Parent := LEditorCard;
  lblBack.Left := 20;
  lblBack.Top := 114;
  lblBack.Font.Name := 'Segoe UI';
  lblBack.Font.Size := UI_LABEL_FONT_SIZE;
  lblBack.Font.Color := $004A5663;

  cbBack := TDCFlexColorPaletteButton.Create(Self);
  cbBack.Parent := LEditorCard;
  cbBack.Left := 20;
  cbBack.Top := 134;
  cbBack.Width := 184;
  cbBack.Height := UI_INPUT_HEIGHT;
  cbBack.Font.Name := 'Segoe UI';
  cbBack.Font.Size := UI_INPUT_FONT_SIZE;
  cbBack.OnChange := EditorChanged;

  lblFont := TLabel.Create(Self);
  lblFont.Parent := LEditorCard;
  lblFont.Left := 226;
  lblFont.Top := 114;
  lblFont.Font.Name := 'Segoe UI';
  lblFont.Font.Size := UI_LABEL_FONT_SIZE;
  lblFont.Font.Color := $004A5663;

  cbFont := TDCFlexColorPaletteButton.Create(Self);
  cbFont.Parent := LEditorCard;
  cbFont.Left := 226;
  cbFont.Top := 134;
  cbFont.Width := 184;
  cbFont.Height := UI_INPUT_HEIGHT;
  cbFont.Font.Name := 'Segoe UI';
  cbFont.Font.Size := UI_INPUT_FONT_SIZE;
  cbFont.OnChange := EditorChanged;

  chkBold := TDCFlexToggleButton.Create(Self);
  chkBold.Parent := LEditorCard;
  chkBold.Left := 432;
  chkBold.Top := 132;
  chkBold.Width := 104;
  chkBold.Height := 28;
  chkBold.Font.Name := 'Segoe UI';
  chkBold.Font.Size := UI_LABEL_FONT_SIZE;
  chkBold.Font.Style := [fsBold];
  chkBold.OnChange := EditorChanged;

  chkItalic := TDCFlexToggleButton.Create(Self);
  chkItalic.Parent := LEditorCard;
  chkItalic.Left := 542;
  chkItalic.Top := 132;
  chkItalic.Width := 104;
  chkItalic.Height := 28;
  chkItalic.Font.Name := 'Segoe UI';
  chkItalic.Font.Size := UI_LABEL_FONT_SIZE;
  chkItalic.Font.Style := [fsItalic];
  chkItalic.OnChange := EditorChanged;

  chkUnderline := TDCFlexToggleButton.Create(Self);
  chkUnderline.Parent := LEditorCard;
  chkUnderline.Left := 652;
  chkUnderline.Top := 132;
  chkUnderline.Width := 104;
  chkUnderline.Height := 28;
  chkUnderline.Font.Name := 'Segoe UI';
  chkUnderline.Font.Size := UI_LABEL_FONT_SIZE;
  chkUnderline.Font.Style := [fsUnderline];
  chkUnderline.OnChange := EditorChanged;

  btnAdd := TDCFlexButton.Create(Self);
  btnAdd.Parent := LEditorCard;
  btnAdd.Left := 778;
  btnAdd.Top := 132;
  btnAdd.Width := 184;
  btnAdd.Height := 28;
  btnAdd.OnClick := AddRuleClick;
  btnAdd.Font.Name := 'Segoe UI Semibold';
  btnAdd.Font.Style := [fsBold];
  btnAdd.Font.Size := UI_SMALL_BUTTON_FONT_SIZE;
  btnAdd.Caption := 'Apply';

  LPreviewCard := TPanel.Create(Self);
  LPreviewCard.Parent := LEditorCard;
  LPreviewCard.Left := 20;
  LPreviewCard.Top := 184;
  LPreviewCard.Width := 966;
  LPreviewCard.Height := 64;
  LPreviewCard.BevelOuter := bvNone;
  LPreviewCard.Color := $00F8FAFD;
  LPreviewCard.ParentBackground := False;
  LPreviewCard.Visible := False;

  lblPreview := TLabel.Create(Self);
  lblPreview.Parent := LPreviewCard;
  lblPreview.Left := 12;
  lblPreview.Top := 8;
  lblPreview.Font.Name := 'Segoe UI Semibold';
  lblPreview.Font.Style := [fsBold];
  lblPreview.Font.Size := UI_LABEL_FONT_SIZE + 1;
  lblPreview.Font.Color := $00253445;

  lblPreviewHint := TLabel.Create(Self);
  lblPreviewHint.Parent := LPreviewCard;
  lblPreviewHint.Left := 160;
  lblPreviewHint.Top := 10;
  lblPreviewHint.Font.Name := 'Segoe UI';
  lblPreviewHint.Font.Size := UI_LABEL_FONT_SIZE;
  lblPreviewHint.Font.Color := $00737F8A;
  lblPreviewHint.Caption := 'Live preview of the currently configured visual style.';

  pnlPreview := TPanel.Create(Self);
  pnlPreview.Parent := LPreviewCard;
  pnlPreview.Left := 12;
  pnlPreview.Top := 30;
  pnlPreview.Width := 942;
  pnlPreview.Height := 24;
  pnlPreview.BevelOuter := bvNone;
  pnlPreview.BevelInner := bvNone;
  pnlPreview.BorderWidth := 0;
  pnlPreview.Color := $00EEF3F8;
  pnlPreview.ParentBackground := False;

  pnlSample := TPanel.Create(Self);
  pnlSample.Parent := pnlPreview;
  pnlSample.Align := alClient;
  pnlSample.BevelOuter := bvNone;
  pnlSample.Color := clWhite;
  pnlSample.ParentBackground := False;

  lblSample := TLabel.Create(Self);
  lblSample.Parent := pnlSample;
  lblSample.Left := 12;
  lblSample.Top := 4;
  lblSample.Font.Name := 'Segoe UI';
  lblSample.Font.Size := UI_INPUT_FONT_SIZE;

  LRulesHeader := TPanel.Create(Self);
  LRulesHeader.Parent := Self;
  LRulesHeader.Align := alClient;
  LRulesHeader.Padding.Left := 20;
  LRulesHeader.Padding.Top := 12;
  LRulesHeader.Padding.Right := 20;
  LRulesHeader.Padding.Bottom := 12;
  LRulesHeader.AlignWithMargins := True;
  LRulesHeader.Margins.Left := 18;
  LRulesHeader.Margins.Right := 18;
  LRulesHeader.Margins.Bottom := 8;
  LRulesHeader.BevelOuter := bvNone;
  LRulesHeader.Color := clWhite;
  LRulesHeader.ParentBackground := False;

  lblSectionRules := TLabel.Create(Self);
  lblSectionRules.Parent := LRulesHeader;
  lblSectionRules.Align := alTop;
  lblSectionRules.Left := 20;
  lblSectionRules.Top := 12;
  lblSectionRules.Font.Name := 'Segoe UI Semibold';
  lblSectionRules.Font.Style := [fsBold];
  lblSectionRules.Font.Size := UI_SECTION_FONT_SIZE;
  lblSectionRules.Font.Color := $00253445;
  lblSectionRules.Transparent := True;

  grdRules := TDCFlexGrid.Create(Self);
  grdRules.Parent := LRulesHeader;
  grdRules.Align := alClient;
  grdRules.AlignWithMargins := True;
  grdRules.Margins.Top := 8;
  grdRules.Margins.Left := 0;
  grdRules.Margins.Right := 0;
  grdRules.Margins.Bottom := 0;
  grdRules.Theme.ResetDefault;
  grdRules.Theme.HeaderColor := $00F3F6FA;
  grdRules.Theme.HeaderFontColor := $0029384B;
  grdRules.Theme.RowColor := clWhite;
  grdRules.Theme.AlternateRowColor := $00F9FBFD;
  grdRules.Theme.SelectedRowColor := $00E4EEF9;
  grdRules.Theme.SelectedTextColor := $00253445;
  grdRules.Theme.HoverRowColor := $00F1F6FB;
  grdRules.RowCount := 0;
  grdRules.ShowExpandButton := False;
  grdRules.ExpandOnRowClick := False;
  grdRules.AllowContextMenuActions := False;
  grdRules.AllowHeaderFooterSummaryMenu := False;
  grdRules.AllowColumnFiltersMenu := False;
  grdRules.ShowToolbarRulesDesignerButton := False;
  grdRules.DetailStyle := dsText;
  grdRules.ShowHeader := True;
  grdRules.RowHeight := 34;
  grdRules.HeaderHeight := 36;
  if Assigned(FGrid) then
    grdRules.Font.Size := FGrid.Font.Size;
  grdRules.AllowColumnResize := False;
  grdRules.AllowColumnSort := False;
  grdRules.AlternateColors := True;
  grdRules.OnGetCellText := RulesGridGetCellText;
  grdRules.OnRowClick := RulesGridRowClick;
  grdRules.OnDblClick := RulesGridDblClick;
  grdRules.Columns.Clear;
  with grdRules.Columns.Add do begin FieldName := 'field'; Width := 160; end;
  with grdRules.Columns.Add do begin FieldName := 'condition'; Width := 150; end;
  with grdRules.Columns.Add do begin FieldName := 'value'; Width := 150; end;
  with grdRules.Columns.Add do begin FieldName := 'applyto'; Width := 120; end;
  with grdRules.Columns.Add do begin FieldName := 'back'; Width := 120; end;
  with grdRules.Columns.Add do begin FieldName := 'font'; Width := 120; end;
  with grdRules.Columns.Add do begin FieldName := 'styles'; Width := 90; end;

  pnlFooter := TPanel.Create(Self);
  pnlFooter.Parent := Self;
  pnlFooter.Align := alBottom;
  pnlFooter.Height := 68;
  pnlFooter.BevelOuter := bvNone;
  pnlFooter.Color := clWhite;
  pnlFooter.ParentBackground := False;

  LFooterDivider := TShape.Create(Self);
  LFooterDivider.Parent := pnlFooter;
  LFooterDivider.Align := alTop;
  LFooterDivider.Height := 1;
  LFooterDivider.Brush.Color := $00E2E8F0;
  LFooterDivider.Pen.Style := psClear;

  lblSectionActions := TLabel.Create(Self);
  lblSectionActions.Parent := pnlFooter;
  lblSectionActions.Left := 20;
  lblSectionActions.Top := 10;
  lblSectionActions.Font.Name := 'Segoe UI Semibold';
  lblSectionActions.Font.Style := [fsBold];
  lblSectionActions.Font.Size := UI_SECTION_FONT_SIZE;
  lblSectionActions.Font.Color := $00253445;

  btnRemove := TDCFlexButton.Create(Self);
  btnRemove.Parent := pnlFooter;
  btnRemove.Left := 20;
  btnRemove.Top := 30;
  btnRemove.Width := 142;
  btnRemove.Height := 32;
  btnRemove.Font.Name := 'Segoe UI';
  btnRemove.Font.Size := UI_SMALL_BUTTON_FONT_SIZE;
  btnRemove.OnClick := RemoveRuleClick;

  btnClear := TDCFlexButton.Create(Self);
  btnClear.Parent := pnlFooter;
  btnClear.Left := 170;
  btnClear.Top := 30;
  btnClear.Width := 118;
  btnClear.Height := 32;
  btnClear.Font.Name := 'Segoe UI';
  btnClear.Font.Size := UI_SMALL_BUTTON_FONT_SIZE;
  btnClear.OnClick := ClearRulesClick;

  lblStatus := TLabel.Create(Self);
  lblStatus.Parent := pnlFooter;
  lblStatus.Left := 308;
  lblStatus.Top := 38;
  lblStatus.Font.Name := 'Segoe UI';
  lblStatus.Font.Size := UI_LABEL_FONT_SIZE;
  lblStatus.Font.Color := $00616A74;

  btnClose := TDCFlexButton.Create(Self);
  btnClose.Parent := pnlFooter;
  btnClose.Width := 110;
  btnClose.Height := 32;
  btnClose.Font.Name := 'Segoe UI';
  btnClose.Font.Size := UI_SMALL_BUTTON_FONT_SIZE;
  btnClose.Top := 30;
  btnClose.Left := 910;
  btnClose.Anchors := [akTop, akRight];
  btnClose.OnClick := CloseClick;
end;

procedure TDCFlexGridVisualRulesDesigner.ApplyLanguage;
begin
  if not Assigned(FLanguage) then
    Exit;

  Caption := FLanguage.Title;
  lblTitle.Caption := FLanguage.Title;
  lblSubtitle.Caption := FLanguage.Subtitle;
  lblSectionRuleSetup.Caption := FLanguage.SectionRuleSetup;
  lblSectionRules.Caption := FLanguage.SectionRules;
  lblSectionActions.Caption := FLanguage.SectionActions;
  lblField.Caption := FLanguage.FieldCaption;
  lblCondition.Caption := FLanguage.ConditionCaption;
  lblValue.Caption := FLanguage.ValueCaption;
  lblApplyTo.Caption := FLanguage.ApplyToCaption;
  lblBack.Caption := FLanguage.BackgroundCaption;
  lblFont.Caption := FLanguage.FontCaption;
  lblPreview.Caption := FLanguage.PreviewCaption;
  lblPreviewHint.Caption := FLanguage.Subtitle;
  chkBold.Caption := FLanguage.BoldCaption;
  chkItalic.Caption := FLanguage.ItalicCaption;
  chkUnderline.Caption := FLanguage.UnderlineCaption;
  btnAdd.Caption := FLanguage.AddRuleCaption;
  btnRemove.Caption := FLanguage.RemoveSelectedCaption;
  btnClear.Caption := FLanguage.ClearAllCaption;
  btnClose.Caption := FLanguage.CloseCaption;
  lblSample.Caption := FLanguage.SampleCaption;

  if grdRules.Columns.Count >= 7 then
  begin
    grdRules.Columns[0].Caption := FLanguage.ColField;
    grdRules.Columns[1].Caption := FLanguage.ColCondition;
    grdRules.Columns[2].Caption := FLanguage.ColValue;
    grdRules.Columns[3].Caption := FLanguage.ColApplyTo;
    grdRules.Columns[4].Caption := FLanguage.ColBack;
    grdRules.Columns[5].Caption := FLanguage.ColFont;
    grdRules.Columns[6].Caption := FLanguage.ColStyles;
  end;
end;

procedure TDCFlexGridVisualRulesDesigner.BeginDesignerMode;
begin
  if not Assigned(FGrid) then
    Exit;
  FOriginalExpandOnRowClick := FGrid.ExpandOnRowClick;
  FOriginalShowExpandButton := FGrid.ShowExpandButton;
  FGrid.ExpandOnRowClick := False;
  FGrid.ShowExpandButton := False;
end;

procedure TDCFlexGridVisualRulesDesigner.EndDesignerMode;
begin
  if not Assigned(FGrid) then
    Exit;
  FGrid.ExpandOnRowClick := FOriginalExpandOnRowClick;
  FGrid.ShowExpandButton := FOriginalShowExpandButton;
end;

function TDCFlexGridVisualRulesDesigner.BuildRulesFileName: string;
var
  LGridName: string;
begin
  if not Assigned(FGrid) then
    Exit('');

  LGridName := Trim(FGrid.Name);
  if LGridName = '' then
    LGridName := FGrid.ClassName;

  Result := TPath.Combine(TPath.GetDirectoryName(ParamStr(0)),
    TPath.Combine('DCFlexGridRules', LGridName + '.rules.json'));
end;


function TDCFlexGridVisualRulesDesigner.BuildPreferencesFileName: string;
var
  LGridName: string;
begin
  if not Assigned(FGrid) then
    Exit('');

  LGridName := Trim(FGrid.Name);
  if LGridName = '' then
    LGridName := FGrid.ClassName;

  Result := TPath.Combine(TPath.GetDirectoryName(ParamStr(0)),
    TPath.Combine('DCFlexGridRules', LGridName + '.designer.json'));
end;

procedure TDCFlexGridVisualRulesDesigner.ApplyGridLanguage;
var
  LCustom: TDCGridLang;
  LPaletteLanguage: TDCFlexColorPickerLanguage;
begin
  LPaletteLanguage := cplPortuguese;

  if not Assigned(FGrid) then
  begin
    SetLanguage(TDCGridLang.Portuguese);
  end
  else if Assigned(FGrid.LanguageSource) then
  begin
    LCustom := FGrid.GetEffectiveRulesDesignerLanguageClone;
    if Assigned(LCustom) then
      SetLanguage(LCustom)
    else
      SetLanguage(TDCGridLang.Portuguese);

    if FGrid.LanguageSource.Language = dlcEnglish then
      LPaletteLanguage := cplEnglish;
  end
  else
  begin
    case FGrid.RulesDesignerLanguage of
      rdlEnglish:
        begin
          SetLanguage(TDCGridLang.English);
          LPaletteLanguage := cplEnglish;
        end;
      rdlCustom:
        begin
          LCustom := FGrid.GetRulesDesignerCustomLanguageClone;
          if Assigned(LCustom) then
            SetLanguage(LCustom)
          else
            SetLanguage(TDCGridLang.Portuguese);
        end;
    else
      SetLanguage(TDCGridLang.Portuguese);
    end;
  end;

  cbBack.PaletteLanguage := LPaletteLanguage;
  cbFont.PaletteLanguage := LPaletteLanguage;
end;

procedure TDCFlexGridVisualRulesDesigner.AutoLoadPreferences;
var
  LFileName: string;
  LJSON: TJSONObject;
  LArr: TJSONArray;
  I: Integer;
  LValue: TJSONValue;
begin
  if (not Assigned(FGrid)) or (not FGrid.RulesDesignerAutoLoadPreferences) then
    Exit;

  LFileName := BuildPreferencesFileName;
  if not FileExists(LFileName) then
    Exit;

  LJSON := TJSONObject.ParseJSONValue(TFile.ReadAllText(LFileName, TEncoding.UTF8)) as TJSONObject;
  try
    if not Assigned(LJSON) then
      Exit;

    Width := EnsureRange(LJSON.GetValue<Integer>('width', Width), 960, 1080);
    Height := EnsureRange(LJSON.GetValue<Integer>('height', Height), 560, 620);
    Left := LJSON.GetValue<Integer>('left', Left);
    Top := LJSON.GetValue<Integer>('top', Top);

    { Language is intentionally not restored from preferences.
      The public property configured on the grid must always win. }

    LValue := LJSON.GetValue('selectedRule');
    if Assigned(LValue) then
      grdRules.SelectedRow := StrToIntDef(LValue.Value, -1);

    LArr := LJSON.GetValue<TJSONArray>('columnWidths');
    if Assigned(LArr) then
      for I := 0 to Min(LArr.Count - 1, grdRules.Columns.Count - 1) do
        grdRules.Columns[I].Width := Min(grdRules.Columns[I].Width,
          StrToIntDef(LArr.Items[I].Value, grdRules.Columns[I].Width));

    if (grdRules.SelectedRow >= 0) and (grdRules.SelectedRow < FGrid.BusinessHighlight.Rules.Count) then
      SyncSelectedRuleToEditor;
  finally
    LJSON.Free;
  end;
end;

procedure TDCFlexGridVisualRulesDesigner.AutoSavePreferences;
var
  LFileName: string;
  LJSON: TJSONObject;
  LArr: TJSONArray;
  I: Integer;
  LLang: string;
begin
  if (not Assigned(FGrid)) or (not FGrid.RulesDesignerAutoSavePreferences) then
    Exit;

  LFileName := BuildPreferencesFileName;
  ForceDirectories(TPath.GetDirectoryName(LFileName));

  case FGrid.RulesDesignerLanguage of
    rdlEnglish: LLang := 'English';
    rdlCustom: LLang := 'Custom';
  else
    LLang := 'Portuguese';
  end;

  LJSON := TJSONObject.Create;
  try
    LJSON.AddPair('left', TJSONNumber.Create(Left));
    LJSON.AddPair('top', TJSONNumber.Create(Top));
    LJSON.AddPair('width', TJSONNumber.Create(Width));
    LJSON.AddPair('height', TJSONNumber.Create(Height));
    LJSON.AddPair('selectedRule', TJSONNumber.Create(grdRules.SelectedRow));
    LJSON.AddPair('language', LLang);

    LArr := TJSONArray.Create;
    for I := 0 to grdRules.Columns.Count - 1 do
      LArr.Add(grdRules.Columns[I].Width);
    LJSON.AddPair('columnWidths', LArr);

    TFile.WriteAllText(LFileName, LJSON.ToJSON, TEncoding.UTF8);
  finally
    LJSON.Free;
  end;
end;

procedure TDCFlexGridVisualRulesDesigner.AutoLoadRules;
var
  LFileName: string;
begin
  if not Assigned(FGrid) then
    Exit;
  LFileName := BuildRulesFileName;
  if FileExists(LFileName) then
    FGrid.BusinessHighlight.LoadFromFile(LFileName);
end;

procedure TDCFlexGridVisualRulesDesigner.AutoSaveRules;
var
  LFileName: string;
begin
  if not Assigned(FGrid) then
    Exit;
  LFileName := BuildRulesFileName;
  if LFileName <> '' then
    FGrid.BusinessHighlight.SaveToFile(LFileName);
end;

procedure TDCFlexGridVisualRulesDesigner.LoadFields;
var
  I: Integer;
  Col: TDCGridColumn;
  LDisplayName: string;
begin
  cbField.Items.BeginUpdate;
  try
    cbField.Items.Clear;
    if Assigned(FGrid) then
    begin
      for I := 0 to FGrid.Columns.Count - 1 do
      begin
        Col := FGrid.Columns[I];
        if not Col.Visible then
          Continue;

        LDisplayName := Trim(Col.Caption);
        if LDisplayName = '' then
          LDisplayName := Trim(Col.FieldName);
        if LDisplayName = '' then
          Continue;

        cbField.Items.AddObject(LDisplayName, Col);
      end;
      if Trim(FGrid.BusinessHighlight.Field) <> '' then
        cbField.ItemIndex := FindFieldIndexByFieldName(FGrid.BusinessHighlight.Field);
    end;
    if (cbField.ItemIndex < 0) and (cbField.Items.Count > 0) then
      cbField.ItemIndex := 0;
  finally
    cbField.Items.EndUpdate;
  end;
end;

procedure TDCFlexGridVisualRulesDesigner.LoadConditions;
begin
  cbCondition.Items.BeginUpdate;
  try
    cbCondition.Items.Clear;
    cbCondition.Items.Add(FLanguage.CondEquals);
    cbCondition.Items.Add(FLanguage.CondNotEquals);
    cbCondition.Items.Add(FLanguage.CondGreaterThan);
    cbCondition.Items.Add(FLanguage.CondLessThan);
    cbCondition.Items.Add(FLanguage.CondContains);
    cbCondition.Items.Add(FLanguage.CondStartsWith);
    if cbCondition.Items.Count > 0 then
      cbCondition.ItemIndex := 0;
  finally
    cbCondition.Items.EndUpdate;
  end;
end;


procedure TDCFlexGridVisualRulesDesigner.LoadTargets;
begin
  cbTarget.Items.BeginUpdate;
  try
    cbTarget.Items.Clear;
    cbTarget.Items.AddObject(FLanguage.TargetRowCaption, TObject(Ord(htRow)));
    cbTarget.Items.AddObject(FLanguage.TargetCellCaption, TObject(Ord(htCell)));
    if cbTarget.Items.Count > 0 then
      cbTarget.ItemIndex := 0;
  finally
    cbTarget.Items.EndUpdate;
  end;
end;


function TDCFlexGridVisualRulesDesigner.FindFieldIndexByFieldName(const AFieldName: string): Integer;
var
  I: Integer;
  Col: TDCGridColumn;
begin
  Result := -1;
  for I := 0 to cbField.Items.Count - 1 do
  begin
    if not (cbField.Items.Objects[I] is TDCGridColumn) then
      Continue;
    Col := TDCGridColumn(cbField.Items.Objects[I]);
    if SameText(Trim(Col.FieldName), Trim(AFieldName)) then
      Exit(I);
  end;
end;

function TDCFlexGridVisualRulesDesigner.GetSelectedFieldName: string;
var
  Col: TDCGridColumn;
begin
  Result := '';
  if cbField.ItemIndex < 0 then
    Exit;

  if cbField.Items.Objects[cbField.ItemIndex] is TDCGridColumn then
  begin
    Col := TDCGridColumn(cbField.Items.Objects[cbField.ItemIndex]);
    Result := Trim(Col.FieldName);
    if Result = '' then
      Result := Trim(Col.Caption);
  end
  else
    Result := Trim(cbField.Text);
end;


function TDCFlexGridVisualRulesDesigner.GetSelectedTarget: TDCHighlightTarget;
begin
  Result := htRow;
  if cbTarget.ItemIndex < 0 then
    Exit;
  Result := TDCHighlightTarget(NativeInt(cbTarget.Items.Objects[cbTarget.ItemIndex]));
end;

function TDCFlexGridVisualRulesDesigner.TargetToText(ATarget: TDCHighlightTarget): string;
begin
  case ATarget of
    htCell: Result := FLanguage.TargetCellCaption;
  else
    Result := FLanguage.TargetRowCaption;
  end;
end;

function TDCFlexGridVisualRulesDesigner.BuildExpression: string;
var
  V: string;
begin
  V := Trim(edtValue.Text);
  case cbCondition.ItemIndex of
    0: Result := '=' + V;
    1: Result := '<>' + V;
    2: Result := '>' + V;
    3: Result := '<' + V;
    5: Result := '^' + V;
  else
    Result := V;
  end;
end;

function TDCFlexGridVisualRulesDesigner.ConditionFromExpression(const AExpr: string): string;
var
  E: string;
begin
  E := Trim(AExpr);
  if Copy(E, 1, 2) = '<>' then
    Result := FLanguage.CondNotEquals
  else if Copy(E, 1, 2) = '>=' then
    Result := FLanguage.CondGreaterThan
  else if Copy(E, 1, 2) = '<=' then
    Result := FLanguage.CondLessThan
  else if (E <> '') and (E[1] = '=') then
    Result := FLanguage.CondEquals
  else if (E <> '') and (E[1] = '>') then
    Result := FLanguage.CondGreaterThan
  else if (E <> '') and (E[1] = '<') then
    Result := FLanguage.CondLessThan
  else if (E <> '') and (E[1] = '^') then
    Result := FLanguage.CondStartsWith
  else
    Result := FLanguage.CondContains;
end;

function TDCFlexGridVisualRulesDesigner.ValueFromExpression(const AExpr: string): string;
var
  E: string;
begin
  E := Trim(AExpr);
  if (Copy(E, 1, 2) = '<>') or (Copy(E, 1, 2) = '>=') or (Copy(E, 1, 2) = '<=') then
    Result := Trim(Copy(E, 3, MaxInt))
  else if (E <> '') and CharInSet(E[1], ['=', '>', '<', '^']) then
    Result := Trim(Copy(E, 2, MaxInt))
  else
    Result := E;
end;

function TDCFlexGridVisualRulesDesigner.StylesToText(const AStyles: TFontStyles): string;
begin
  Result := '';
  if fsBold in AStyles then
    Result := Result + 'B';
  if fsItalic in AStyles then
    Result := Result + 'I';
  if fsUnderline in AStyles then
    Result := Result + 'U';
  if Result = '' then
    Result := '-';
end;

procedure TDCFlexGridVisualRulesDesigner.RefreshRulesGrid;
begin
  if not Assigned(FGrid) then
    Exit;
  grdRules.RowCount := FGrid.BusinessHighlight.Rules.Count;
  grdRules.RefreshGrid;
end;

procedure TDCFlexGridVisualRulesDesigner.UpdatePreview;
var
  Styles: TFontStyles;
begin
  Styles := [];
  if chkBold.Checked then Include(Styles, fsBold);
  if chkItalic.Checked then Include(Styles, fsItalic);
  if chkUnderline.Checked then Include(Styles, fsUnderline);

  pnlSample.Color := cbBack.Selected;
  lblSample.Font.Color := cbFont.Selected;
  lblSample.Font.Style := Styles;
  if Trim(edtValue.Text) <> '' then
    lblSample.Caption := edtValue.Text
  else
    lblSample.Caption := FLanguage.SampleCaption;
end;

procedure TDCFlexGridVisualRulesDesigner.SetStatus(const AText: string);
begin
  lblStatus.Caption := AText;
end;

procedure TDCFlexGridVisualRulesDesigner.ApplyTheme;
var
  LMode: TDCFlexThemeMode;
  LPalette: TDCFlexThemePalette;
  LDark: Boolean;
  LBack: TColor;
  LSurface: TColor;
  LSurfaceAlt: TColor;
  LText: TColor;
  LMuted: TColor;
  LBorder: TColor;

  procedure ApplyControl(AControl: TControl);
  var
    I: Integer;
    LWinControl: TWinControl;
  begin
    if AControl is TWinControl then
      DCFlexApplyNativeDarkMode(TWinControl(AControl), LDark);

    if AControl is TPanel then
    begin
      TPanel(AControl).Color := LSurface;
      TPanel(AControl).ParentBackground := False;
    end
    else if AControl is TLabel then
      TLabel(AControl).Font.Color := LText
    else if AControl is TDCFlexEdit then
    begin
      TDCFlexEdit(AControl).ThemeMode := LMode;
      TDCFlexEdit(AControl).BackColor := LPalette.InputBack;
      TDCFlexEdit(AControl).TextColor := LText;
      TDCFlexEdit(AControl).BorderColor := LBorder;
      TDCFlexEdit(AControl).FocusedBorderColor := LPalette.Accent;
    end
    else if AControl is TEdit then
    begin
      TEdit(AControl).Color := LPalette.InputBack;
      TEdit(AControl).Font.Color := LText;
    end
    else if AControl is TMemo then
    begin
      TMemo(AControl).Color := LPalette.InputBack;
      TMemo(AControl).Font.Color := LText;
    end
    else if AControl is TDCFlexComboBox then
    begin
      TDCFlexComboBox(AControl).ThemeMode := LMode;
      TDCFlexComboBox(AControl).BackColor := LPalette.InputBack;
      TDCFlexComboBox(AControl).TextColor := LText;
      TDCFlexComboBox(AControl).BorderColor := LBorder;
      TDCFlexComboBox(AControl).HoverColor := LPalette.Hover;
      TDCFlexComboBox(AControl).AccentColor := LPalette.Accent;
    end
    else if AControl is TComboBox then
    begin
      TComboBox(AControl).Color := LPalette.InputBack;
      TComboBox(AControl).Font.Color := LText;
    end
    else if AControl is TDCFlexButton then
    begin
      TDCFlexButton(AControl).ThemeMode := LMode;
      TDCFlexButton(AControl).BackColor := LPalette.Surface;
      TDCFlexButton(AControl).TextColor := LText;
      TDCFlexButton(AControl).BorderColor := LBorder;
      TDCFlexButton(AControl).HoverColor := LPalette.Hover;
      TDCFlexButton(AControl).PressedColor := LPalette.Pressed;
      TDCFlexButton(AControl).AccentColor := LPalette.Accent;
    end;

    if AControl is TWinControl then
    begin
      LWinControl := TWinControl(AControl);
      for I := 0 to LWinControl.ControlCount - 1 do
        ApplyControl(LWinControl.Controls[I]);
    end;
  end;
begin
  LMode := dtmLight;
  if Assigned(FGrid) then
    LMode := FGrid.ThemeMode;

  LPalette := DCFlexPaletteForMode(LMode);
  LDark := LMode = dtmDark;
  LBack := LPalette.Background;
  LSurface := LPalette.Surface;
  LSurfaceAlt := LPalette.SurfaceAlt;
  LText := LPalette.Text;
  LMuted := LPalette.MutedText;
  LBorder := LPalette.Border;

  if not LDark then
  begin
    LBack := LPalette.SurfaceAlt;
    LSurface := LPalette.PopupBack;
    LSurfaceAlt := LPalette.HeaderBack;
    LBorder := LPalette.GridLine;
  end;

  DCFlexApplyNativeDarkMode(Self, LDark);
  Color := LBack;
  ApplyControl(Self);

  pnlHeader.Color := LBack;
  pnlEditor.Color := LBack;
  pnlFooter.Color := LSurface;
  lblTitle.Font.Color := LText;
  lblSubtitle.Font.Color := LMuted;
  lblSectionRuleSetup.Font.Color := LText;
  lblSectionRules.Font.Color := LText;
  lblSectionActions.Font.Color := LText;
  lblField.Font.Color := LMuted;
  lblCondition.Font.Color := LMuted;
  lblValue.Font.Color := LMuted;
  lblApplyTo.Font.Color := LMuted;
  lblBack.Font.Color := LMuted;
  lblFont.Font.Color := LMuted;
  lblStatus.Font.Color := LMuted;

  pnlPreview.Color := LBorder;
  pnlSample.Color := LSurface;
  lblSample.Font.Color := LText;

  if not LDark then
  begin
    pnlHeader.Color := LPalette.PopupBack;
    pnlEditor.Color := LBack;
    pnlFooter.Color := LPalette.PopupBack;
  end;

  cbBack.ThemeMode := LMode;
  cbBack.BorderColor := LBorder;
  cbBack.HoverColor := LPalette.Hover;
  cbBack.Font.Color := LText;
  cbFont.ThemeMode := LMode;
  cbFont.BorderColor := LBorder;
  cbFont.HoverColor := LPalette.Hover;
  cbFont.Font.Color := LText;
  chkBold.ThemeMode := LMode;
  chkItalic.ThemeMode := LMode;
  chkUnderline.ThemeMode := LMode;
  btnAdd.ThemeMode := LMode;
  btnRemove.ThemeMode := LMode;
  btnClear.ThemeMode := LMode;
  btnClose.ThemeMode := LMode;

  grdRules.ThemeMode := LMode;
  if LDark then
  begin
    grdRules.Theme.HeaderColor := LSurfaceAlt;
    grdRules.Theme.HeaderFontColor := LText;
    grdRules.Theme.GridBackgroundColor := LSurface;
    grdRules.Theme.RowColor := LSurface;
    grdRules.Theme.AlternateRowColor := LSurfaceAlt;
    grdRules.Theme.HoverRowColor := LPalette.Hover;
    grdRules.Theme.SelectedRowColor := LPalette.Selection;
    grdRules.Theme.SelectedTextColor := LPalette.SelectionText;
    grdRules.Theme.BorderColor := LBorder;
    grdRules.Theme.TextColor := LText;
  end;
  if not LDark then
  begin
    grdRules.Theme.HeaderColor := LSurfaceAlt;
    grdRules.Theme.HeaderFontColor := LText;
    grdRules.Theme.GridBackgroundColor := LSurface;
    grdRules.Theme.RowColor := LSurface;
    grdRules.Theme.AlternateRowColor := $00FCFAF8;
    grdRules.Theme.HoverRowColor := LPalette.Hover;
    grdRules.Theme.SelectedRowColor := LPalette.Selection;
    grdRules.Theme.SelectedTextColor := LPalette.SelectionText;
    grdRules.Theme.BorderColor := LBorder;
    grdRules.Theme.TextColor := LText;
  end;
end;

procedure TDCFlexGridVisualRulesDesigner.NormalizeDpiScale;
var
  LCurrentPPI: Integer;
begin
  LCurrentPPI := PixelsPerInch;
  if LCurrentPPI <= 96 then
    Exit;

  ScaleBy(96, LCurrentPPI);
  PixelsPerInch := 96;
end;

procedure TDCFlexGridVisualRulesDesigner.ClearEditor;
begin
  edtValue.Text := '';
  cbCondition.ItemIndex := 0;
  cbTarget.ItemIndex := 0;
  chkBold.Checked := False;
  chkItalic.Checked := False;
  chkUnderline.Checked := False;
  FEditingIndex := -1;
  btnAdd.Caption := FLanguage.AddRuleCaption;
  UpdatePreview;
end;

procedure TDCFlexGridVisualRulesDesigner.EditorChanged(Sender: TObject);
begin
  UpdatePreview;
end;

procedure TDCFlexGridVisualRulesDesigner.AddRuleClick(Sender: TObject);
var
  Styles: TFontStyles;
  Expr: string;
  LRule: TDCHighlightRule;
begin
  if not Assigned(FGrid) then Exit;
  if cbField.ItemIndex < 0 then Exit;
  if Trim(edtValue.Text) = '' then Exit;

  FGrid.BusinessHighlight.Enabled := True;
  if Trim(FGrid.BusinessHighlight.Field) = '' then
    FGrid.BusinessHighlight.Field := GetSelectedFieldName;

  Styles := [];
  if chkBold.Checked then Include(Styles, fsBold);
  if chkItalic.Checked then Include(Styles, fsItalic);
  if chkUnderline.Checked then Include(Styles, fsUnderline);

  Expr := BuildExpression;

  if (FEditingIndex >= 0) and (FEditingIndex < FGrid.BusinessHighlight.Rules.Count) then
  begin
    LRule := FGrid.BusinessHighlight.Rules[FEditingIndex];
    LRule.FieldName := GetSelectedFieldName;
    LRule.Expression := Expr;
    LRule.BackColor := cbBack.Selected;
    LRule.FontColor := cbFont.Selected;
    LRule.FontStyles := Styles;
    LRule.Target := GetSelectedTarget;
    SetStatus(FLanguage.StatusRuleUpdated);
  end
  else
  begin
    FGrid.BusinessHighlight.Rules.AddForField(GetSelectedFieldName, Expr, cbBack.Selected, cbFont.Selected, Styles, GetSelectedTarget);
    grdRules.SelectedRow := FGrid.BusinessHighlight.Rules.Count - 1;
    SetStatus(FLanguage.StatusRuleAdded);
  end;

  FGrid.RefreshGrid;
  RefreshRulesGrid;
  AutoSaveRules;
  ClearEditor;
end;

procedure TDCFlexGridVisualRulesDesigner.RemoveRuleClick(Sender: TObject);
var
  Idx: Integer;
begin
  if not Assigned(FGrid) then Exit;
  Idx := grdRules.SelectedRow;
  if (Idx < 0) or (Idx >= FGrid.BusinessHighlight.Rules.Count) then Exit;
  FGrid.BusinessHighlight.Rules.Delete(Idx);
  FGrid.RefreshGrid;
  RefreshRulesGrid;
  AutoSaveRules;
  ClearEditor;
  SetStatus(FLanguage.StatusRuleRemoved);
end;

procedure TDCFlexGridVisualRulesDesigner.ClearRulesClick(Sender: TObject);
begin
  if not Assigned(FGrid) then Exit;
  if FGrid.BusinessHighlight.Rules.Count = 0 then Exit;
  if not ShowRulesDesignerConfirm(Self, FLanguage) then Exit;
  FGrid.BusinessHighlight.Clear;
  FGrid.RefreshGrid;
  RefreshRulesGrid;
  AutoSaveRules;
  ClearEditor;
  SetStatus(FLanguage.StatusRulesCleared);
end;

procedure TDCFlexGridVisualRulesDesigner.CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TDCFlexGridVisualRulesDesigner.RulesGridGetCellText(Sender: TObject; ARow,
  ACol: Integer; var AText: string);
var
  R: TDCHighlightRule;
  Idx: Integer;
  LFieldName: string;
begin
  AText := '';
  if not Assigned(FGrid) then Exit;
  if (ARow < 0) or (ARow >= FGrid.BusinessHighlight.Rules.Count) then Exit;
  R := FGrid.BusinessHighlight.Rules[ARow];
  case ACol of
    0:
      begin
        LFieldName := Trim(R.FieldName);
        if LFieldName = '' then
          LFieldName := Trim(FGrid.BusinessHighlight.Field);
        AText := LFieldName;
        Idx := FindFieldIndexByFieldName(LFieldName);
        if Idx >= 0 then
          AText := cbField.Items[Idx];
      end;
    1: AText := ConditionFromExpression(R.Expression);
    2: AText := ValueFromExpression(R.Expression);
    3: AText := TargetToText(R.Target);
    4: AText := cbBack.DisplayText(R.BackColor);
    5: AText := cbFont.DisplayText(R.FontColor);
    6: AText := StylesToText(R.FontStyles);
  end;
end;

procedure TDCFlexGridVisualRulesDesigner.SyncSelectedRuleToEditor;
var
  Idx: Integer;
  R: TDCHighlightRule;
  LFieldName: string;
begin
  if not Assigned(FGrid) then Exit;
  Idx := grdRules.SelectedRow;
  if (Idx < 0) or (Idx >= FGrid.BusinessHighlight.Rules.Count) then Exit;
  R := FGrid.BusinessHighlight.Rules[Idx];
  LFieldName := Trim(R.FieldName);
  if LFieldName = '' then
    LFieldName := Trim(FGrid.BusinessHighlight.Field);
  cbField.ItemIndex := FindFieldIndexByFieldName(LFieldName);
  cbCondition.ItemIndex := cbCondition.Items.IndexOf(ConditionFromExpression(R.Expression));
  edtValue.Text := ValueFromExpression(R.Expression);
  cbTarget.ItemIndex := cbTarget.Items.IndexOf(TargetToText(R.Target));
  cbBack.Selected := R.BackColor;
  cbFont.Selected := R.FontColor;
  chkBold.Checked := fsBold in R.FontStyles;
  chkItalic.Checked := fsItalic in R.FontStyles;
  chkUnderline.Checked := fsUnderline in R.FontStyles;
  FEditingIndex := Idx;
  btnAdd.Caption := FLanguage.UpdateRuleCaption;
  UpdatePreview;
end;

procedure TDCFlexGridVisualRulesDesigner.RulesGridRowClick(Sender: TObject; ARow: Integer);
begin
  SyncSelectedRuleToEditor;
end;

procedure TDCFlexGridVisualRulesDesigner.RulesGridDblClick(Sender: TObject);
begin
  SyncSelectedRuleToEditor;
  SetStatus(FLanguage.StatusEditingRule);
end;

procedure ShowDCFlexGridVisualRulesDesigner(AGrid: TDCMasterDetailGrid);
var
  Dlg: TDCFlexGridVisualRulesDesigner;
begin
  Dlg := TDCFlexGridVisualRulesDesigner.CreateDesigner(nil, AGrid);
  try
    Dlg.ShowModal;
  finally
    Dlg.Free;
  end;
end;

end.
