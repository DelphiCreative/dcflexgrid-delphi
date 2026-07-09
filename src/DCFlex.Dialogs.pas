unit DCFlex.Dialogs;

interface

uses
  System.Classes,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Graphics,
  DCFlex.Language,
  DCFlex.Theme;

type
  TDCFlexDialogKind = (ddkInformation, ddkWarning, ddkDanger);
  TDCFlexConfirmResult = (dcrCancel, dcrConfirm);

  TDCFlexDialogBase = class(TForm)
  private
    FAccentColor: TColor;
    FBodyColor: TColor;
    FFooterColor: TColor;
    FHeaderColor: TColor;
    FTextColor: TColor;
    FThemeMode: TDCFlexThemeMode;
    FThemePalette: TDCFlexThemePalette;
    FTitleText: string;
  protected
    procedure ApplyBaseStyle; virtual;
    procedure BuildBaseLayout(const ATitle: string; AClientWidth,
      AClientHeight: Integer); virtual;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ApplyThemePalette(const APalette: TDCFlexThemePalette); virtual;
    property AccentColor: TColor read FAccentColor write FAccentColor;
    property BodyColor: TColor read FBodyColor write FBodyColor;
    property FooterColor: TColor read FFooterColor write FFooterColor;
    property HeaderColor: TColor read FHeaderColor write FHeaderColor;
    property TextColor: TColor read FTextColor write FTextColor;
    property ThemeMode: TDCFlexThemeMode read FThemeMode write FThemeMode;
    property TitleText: string read FTitleText write FTitleText;
  end;

function DCFlexConfirm(AOwner: TComponent; const ATitle, AMessage,
  ADetail, AConfirmCaption, ACancelCaption: string;
  AKind: TDCFlexDialogKind = ddkDanger;
  ALanguageSource: TDCFlexLanguage = nil): TDCFlexConfirmResult;
function DCFlexConfirmThemed(AOwner: TComponent; const ATitle, AMessage,
  ADetail, AConfirmCaption, ACancelCaption: string;
  AKind: TDCFlexDialogKind; ALanguageSource: TDCFlexLanguage;
  AThemeMode: TDCFlexThemeMode): TDCFlexConfirmResult;
function DCFlexInputQuery(AOwner: TComponent; const ATitle, ALabel,
  AOkCaption, ACancelCaption: string; var AValue: string;
  ALanguageSource: TDCFlexLanguage = nil): Boolean;
function DCFlexInputQueryThemed(AOwner: TComponent; const ATitle, ALabel,
  AOkCaption, ACancelCaption: string; var AValue: string;
  ALanguageSource: TDCFlexLanguage; AThemeMode: TDCFlexThemeMode): Boolean;

implementation

uses
  Winapi.Windows,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  DCFlex.Controls;

type
  TDCFlexConfirmDialog = class(TDCFlexDialogBase)
  private
    FCancelCaption: string;
    FConfirmCaption: string;
    FDetail: string;
    FKind: TDCFlexDialogKind;
    FMessage: string;
    procedure BuildUI;
  public
    constructor CreateConfirm(AOwner: TComponent; const ATitle, AMessage,
      ADetail, AConfirmCaption, ACancelCaption: string;
      AKind: TDCFlexDialogKind; AThemeMode: TDCFlexThemeMode = dtmLight); reintroduce;
  end;

  TDCFlexInputDialog = class(TDCFlexDialogBase)
  private
    FCancelCaption: string;
    FLabelText: string;
    FOkCaption: string;
    FValue: string;
    FEdit: TDCFlexEdit;
    procedure BuildUI;
  public
    constructor CreateInput(AOwner: TComponent; const ATitle, ALabel,
      AOkCaption, ACancelCaption, AValue: string;
      AThemeMode: TDCFlexThemeMode = dtmLight); reintroduce;
    property Value: string read FValue;
  end;

{ TDCFlexDialogBase }

procedure TDCFlexDialogBase.ApplyBaseStyle;
begin
  BorderStyle := bsDialog;
  BorderIcons := [biSystemMenu];
  Position := poScreenCenter;
  Color := FBodyColor;
  Font.Name := 'Segoe UI';
  Font.Size := 9;
  Font.Color := FTextColor;
  KeyPreview := True;
  Constraints.MinWidth := 360;
  Constraints.MinHeight := 180;
end;

procedure TDCFlexDialogBase.BuildBaseLayout(const ATitle: string;
  AClientWidth, AClientHeight: Integer);
begin
  Caption := ATitle;
  TitleText := ATitle;
  ClientWidth := AClientWidth;
  ClientHeight := AClientHeight;
end;

procedure TDCFlexDialogBase.ApplyThemePalette(
  const APalette: TDCFlexThemePalette);
begin
  FThemeMode := dtmCustom;
  FThemePalette := APalette;
  FAccentColor := APalette.Accent;
  FBodyColor := APalette.Background;
  FFooterColor := APalette.Surface;
  FHeaderColor := APalette.Background;
  FTextColor := APalette.Text;
  Color := FBodyColor;
  Font.Color := FTextColor;
end;

constructor TDCFlexDialogBase.Create(AOwner: TComponent);
begin
  inherited CreateNew(AOwner);
  FThemeMode := dtmLight;
  FThemePalette := DCFlexLightPalette;
  FAccentColor := $00F86F62;
  FBodyColor := $00FBF8F6;
  FFooterColor := $00F7F7F7;
  FHeaderColor := clWhite;
  FTextColor := $00253445;
  ApplyBaseStyle;
end;

procedure TDCFlexDialogBase.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if Key = VK_ESCAPE then
  begin
    ModalResult := mrCancel;
    Key := 0;
  end
  else if Key = VK_RETURN then
  begin
    ModalResult := mrOk;
    Key := 0;
  end;
end;

{ TDCFlexConfirmDialog }

procedure TDCFlexConfirmDialog.BuildUI;
var
  LBody: TPanel;
  LDetailPanel: TPanel;
  LFooter: TPanel;
  LMessage: TLabel;
  LDetail: TLabel;
  LConfirm: TDCFlexButton;
  LCancel: TDCFlexButton;
begin
  case FKind of
    ddkInformation: AccentColor := $00D49B32;
    ddkWarning: AccentColor := $0000A5FF;
  else
    AccentColor := $004B55E6;
  end;

  LBody := TPanel.Create(Self);
  LBody.Parent := Self;
  LBody.Align := alClient;
  LBody.BevelOuter := bvNone;
  LBody.Color := BodyColor;
  LBody.ParentBackground := False;

  LMessage := TLabel.Create(Self);
  LMessage.Parent := LBody;
  LMessage.Left := 24;
  LMessage.Top := 30;
  LMessage.Width := ClientWidth - 48;
  LMessage.Height := 36;
  LMessage.AutoSize := False;
  LMessage.WordWrap := True;
  LMessage.Caption := FMessage;
  LMessage.Font.Color := TextColor;

  LDetailPanel := TPanel.Create(Self);
  LDetailPanel.Parent := LBody;
  LDetailPanel.Left := 24;
  LDetailPanel.Top := 78;
  LDetailPanel.Width := ClientWidth - 48;
  LDetailPanel.Height := 34;
  LDetailPanel.BevelOuter := bvNone;
  LDetailPanel.Color := FThemePalette.Surface;
  LDetailPanel.ParentBackground := False;

  LDetail := TLabel.Create(Self);
  LDetail.Parent := LDetailPanel;
  LDetail.Left := 12;
  LDetail.Top := 8;
  LDetail.Width := LDetailPanel.Width - 24;
  LDetail.Height := 18;
  LDetail.AutoSize := False;
  LDetail.Caption := FDetail;
  LDetail.Font.Name := 'Segoe UI Semibold';
  LDetail.Font.Style := [fsBold];
  LDetail.Font.Color := TextColor;

  LFooter := TPanel.Create(Self);
  LFooter.Parent := Self;
  LFooter.Align := alBottom;
  LFooter.Height := 56;
  LFooter.BevelOuter := bvNone;
  LFooter.Color := FooterColor;
  LFooter.ParentBackground := False;

  LCancel := TDCFlexButton.Create(Self);
  LCancel.Parent := LFooter;
  LCancel.SetBounds(ClientWidth - 24 - 96, 14, 96, 28);
  LCancel.Caption := FCancelCaption;
  LCancel.ApplyThemePalette(FThemePalette);
  LCancel.Cancel := True;
  LCancel.ModalResult := mrCancel;

  LConfirm := TDCFlexButton.Create(Self);
  LConfirm.Parent := LFooter;
  LConfirm.SetBounds(LCancel.Left - 112 - 10, 14, 112, 28);
  LConfirm.Caption := FConfirmCaption;
  LConfirm.ApplyThemePalette(FThemePalette);
  LConfirm.AccentColor := AccentColor;
  LConfirm.Default := True;
  LConfirm.ModalResult := mrOk;
end;

constructor TDCFlexConfirmDialog.CreateConfirm(AOwner: TComponent;
  const ATitle, AMessage, ADetail, AConfirmCaption,
  ACancelCaption: string; AKind: TDCFlexDialogKind;
  AThemeMode: TDCFlexThemeMode);
begin
  inherited Create(AOwner);
  if AThemeMode <> dtmLight then
    ApplyThemePalette(DCFlexPaletteForMode(AThemeMode));
  FMessage := AMessage;
  FDetail := ADetail;
  FConfirmCaption := AConfirmCaption;
  FCancelCaption := ACancelCaption;
  FKind := AKind;
  BuildBaseLayout(ATitle, 440, 190);
  BuildUI;
end;

{ TDCFlexInputDialog }

procedure TDCFlexInputDialog.BuildUI;
var
  LBody: TPanel;
  LFooter: TPanel;
  LLabel: TLabel;
  LOk: TDCFlexButton;
  LCancel: TDCFlexButton;
begin
  LBody := TPanel.Create(Self);
  LBody.Parent := Self;
  LBody.Align := alClient;
  LBody.BevelOuter := bvNone;
  LBody.Color := BodyColor;
  LBody.ParentBackground := False;

  LLabel := TLabel.Create(Self);
  LLabel.Parent := LBody;
  LLabel.Left := 24;
  LLabel.Top := 22;
  LLabel.Caption := FLabelText;
  LLabel.Font.Color := TextColor;

  FEdit := TDCFlexEdit.Create(Self);
  FEdit.Parent := LBody;
  FEdit.Left := 24;
  FEdit.Top := 46;
  FEdit.Width := ClientWidth - 48;
  FEdit.Height := 30;
  FEdit.Text := FValue;
  FEdit.ApplyThemePalette(FThemePalette);
  FEdit.SelectAll;

  LFooter := TPanel.Create(Self);
  LFooter.Parent := Self;
  LFooter.Align := alBottom;
  LFooter.Height := 56;
  LFooter.BevelOuter := bvNone;
  LFooter.Color := FooterColor;
  LFooter.ParentBackground := False;

  LCancel := TDCFlexButton.Create(Self);
  LCancel.Parent := LFooter;
  LCancel.SetBounds(ClientWidth - 24 - 96, 14, 96, 28);
  LCancel.Caption := FCancelCaption;
  LCancel.ApplyThemePalette(FThemePalette);
  LCancel.Cancel := True;
  LCancel.ModalResult := mrCancel;

  LOk := TDCFlexButton.Create(Self);
  LOk.Parent := LFooter;
  LOk.SetBounds(LCancel.Left - 112 - 10, 14, 112, 28);
  LOk.Caption := FOkCaption;
  LOk.ApplyThemePalette(FThemePalette);
  LOk.Default := True;
  LOk.ModalResult := mrOk;

  ActiveControl := FEdit;
end;

constructor TDCFlexInputDialog.CreateInput(AOwner: TComponent; const ATitle,
  ALabel, AOkCaption, ACancelCaption, AValue: string;
  AThemeMode: TDCFlexThemeMode);
begin
  inherited Create(AOwner);
  if AThemeMode <> dtmLight then
    ApplyThemePalette(DCFlexPaletteForMode(AThemeMode));
  FLabelText := ALabel;
  FOkCaption := AOkCaption;
  FCancelCaption := ACancelCaption;
  FValue := AValue;
  BuildBaseLayout(ATitle, 430, 152);
  BuildUI;
end;

function DCFlexConfirm(AOwner: TComponent; const ATitle, AMessage,
  ADetail, AConfirmCaption, ACancelCaption: string;
  AKind: TDCFlexDialogKind; ALanguageSource: TDCFlexLanguage): TDCFlexConfirmResult;
begin
  Result := DCFlexConfirmThemed(AOwner, ATitle, AMessage, ADetail,
    AConfirmCaption, ACancelCaption, AKind, ALanguageSource, dtmLight);
end;

function DCFlexConfirmThemed(AOwner: TComponent; const ATitle, AMessage,
  ADetail, AConfirmCaption, ACancelCaption: string;
  AKind: TDCFlexDialogKind; ALanguageSource: TDCFlexLanguage;
  AThemeMode: TDCFlexThemeMode): TDCFlexConfirmResult;
var
  LDialog: TDCFlexConfirmDialog;
  LConfirmCaption: string;
  LCancelCaption: string;
begin
  LConfirmCaption := AConfirmCaption;
  LCancelCaption := ACancelCaption;
  if Assigned(ALanguageSource) then
  begin
    if LConfirmCaption = '' then
      LConfirmCaption := ALanguageSource.Text(dlsCommon, 'confirm', 'Confirm');
    if LCancelCaption = '' then
      LCancelCaption := ALanguageSource.Text(dlsCommon, 'cancel', 'Cancel');
  end;
  if LConfirmCaption = '' then
    LConfirmCaption := 'Confirm';
  if LCancelCaption = '' then
    LCancelCaption := 'Cancel';

  LDialog := TDCFlexConfirmDialog.CreateConfirm(AOwner, ATitle, AMessage,
    ADetail, LConfirmCaption, LCancelCaption, AKind, AThemeMode);
  try
    if LDialog.ShowModal = mrOk then
      Result := dcrConfirm
    else
      Result := dcrCancel;
  finally
    LDialog.Free;
  end;
end;

function DCFlexInputQuery(AOwner: TComponent; const ATitle, ALabel,
  AOkCaption, ACancelCaption: string; var AValue: string;
  ALanguageSource: TDCFlexLanguage): Boolean;
begin
  Result := DCFlexInputQueryThemed(AOwner, ATitle, ALabel, AOkCaption,
    ACancelCaption, AValue, ALanguageSource, dtmLight);
end;

function DCFlexInputQueryThemed(AOwner: TComponent; const ATitle, ALabel,
  AOkCaption, ACancelCaption: string; var AValue: string;
  ALanguageSource: TDCFlexLanguage; AThemeMode: TDCFlexThemeMode): Boolean;
var
  LDialog: TDCFlexInputDialog;
  LOkCaption: string;
  LCancelCaption: string;
begin
  LOkCaption := AOkCaption;
  LCancelCaption := ACancelCaption;
  if Assigned(ALanguageSource) then
  begin
    if LOkCaption = '' then
      LOkCaption := ALanguageSource.Text(dlsCommon, 'ok', 'OK');
    if LCancelCaption = '' then
      LCancelCaption := ALanguageSource.Text(dlsCommon, 'cancel', 'Cancel');
  end;
  if LOkCaption = '' then
    LOkCaption := 'OK';
  if LCancelCaption = '' then
    LCancelCaption := 'Cancel';

  LDialog := TDCFlexInputDialog.CreateInput(AOwner, ATitle, ALabel,
    LOkCaption, LCancelCaption, AValue, AThemeMode);
  try
    Result := LDialog.ShowModal = mrOk;
    if Result then
      AValue := LDialog.FEdit.Text;
  finally
    LDialog.Free;
  end;
end;

end.
