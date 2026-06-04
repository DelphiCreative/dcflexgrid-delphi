unit DCFlex.Controls;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.Classes,
  System.SysUtils,
  System.Types,
  Vcl.StdCtrls,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.ExtCtrls,
  Vcl.Dialogs,
  Vcl.Forms,
  DCFlex.Language;

type
  TDCFlexColorPickerLanguage = (cplEnglish, cplPortuguese);

  TDCFlexColorPicker = class(TComboBox)
  private
    FSelected: TColor;
    FAllowCustomColor: Boolean;
    FPaletteLoaded: Boolean;
    FPaletteLanguage: TDCFlexColorPickerLanguage;
    FLanguageSource: TDCFlexLanguage;
    function GetSelected: TColor;
    procedure SetSelected(const Value: TColor);
    procedure SetLanguageSource(const Value: TDCFlexLanguage);
    procedure SetPaletteLanguage(const Value: TDCFlexColorPickerLanguage);
    function ColorText(AColor: TColor): string;
    procedure AddColorItem(const ACaption: string; AColor: TColor);
    procedure EnsureColorItem(AColor: TColor);
    procedure ApplySelectedIndex;
    function PaletteText(const AEnglish, APortuguese: string): string;
    procedure LanguageSourceChange(Sender: TObject);
  protected
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
    procedure DblClick; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetParent(AParent: TWinControl); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoadDefaultPalette;
    function DisplayText(AColor: TColor): string;
    function SelectCustomColor: Boolean;
  published
    property AllowCustomColor: Boolean read FAllowCustomColor write FAllowCustomColor default True;
    property LanguageSource: TDCFlexLanguage read FLanguageSource
      write SetLanguageSource;
    property PaletteLanguage: TDCFlexColorPickerLanguage read FPaletteLanguage write SetPaletteLanguage default cplEnglish;
    property Selected: TColor read GetSelected write SetSelected default clBlack;
  end;

  TDCFlexColorPaletteButton = class(TCustomControl)
  private
    FAllowCustomColor: Boolean;
    FBorderColor: TColor;
    FHoverColor: TColor;
    FMouseOver: Boolean;
    FOnChange: TNotifyEvent;
    FPaletteLanguage: TDCFlexColorPickerLanguage;
    FLanguageSource: TDCFlexLanguage;
    FSelected: TColor;
    procedure CMEnter(var Message: TMessage); message CM_ENTER;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMExit(var Message: TMessage); message CM_EXIT;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    function PaletteText(const AEnglish, APortuguese: string): string;
    procedure SetBorderColor(const Value: TColor);
    procedure SetHoverColor(const Value: TColor);
    procedure SetLanguageSource(const Value: TDCFlexLanguage);
    procedure SetPaletteLanguage(const Value: TDCFlexColorPickerLanguage);
    procedure SetSelected(const Value: TColor);
    procedure LanguageSourceChange(Sender: TObject);
  protected
    procedure Change; virtual;
    procedure Click; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DropDown;
    function SelectCustomColor: Boolean;
  published
    property Align;
    property Anchors;
    property AllowCustomColor: Boolean read FAllowCustomColor write FAllowCustomColor default True;
    property BorderColor: TColor read FBorderColor write SetBorderColor default $00D0D7DE;
    property Color default clWhite;
    property Enabled;
    property Height default 26;
    property Hint;
    property HoverColor: TColor read FHoverColor write SetHoverColor default $00F1F5F9;
    property LanguageSource: TDCFlexLanguage read FLanguageSource
      write SetLanguageSource;
    property PaletteLanguage: TDCFlexColorPickerLanguage read FPaletteLanguage write SetPaletteLanguage default cplEnglish;
    property ParentShowHint;
    property PopupMenu;
    property Selected: TColor read FSelected write SetSelected default clBlack;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Visible;
    property Width default 42;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnClick;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
  end;


  TDCFlexToggleButton = class(TCustomControl)
  private
    FAllowToggle: Boolean;
    FChecked: Boolean;
    FMouseDown: Boolean;
    FMouseOver: Boolean;
    FBorderRadius: Integer;
    FNormalColor: TColor;
    FHoverColor: TColor;
    FCheckedColor: TColor;
    FPressedColor: TColor;
    FDisabledColor: TColor;
    FBorderColor: TColor;
    FHoverBorderColor: TColor;
    FCheckedBorderColor: TColor;
    FDisabledBorderColor: TColor;
    FCheckedFontColor: TColor;
    FDisabledFontColor: TColor;
    FOnChange: TNotifyEvent;
    FGroupIndex: Integer;
    FAllowAllUp: Boolean;
    FAutoSizeToCaption: Boolean;
    procedure SetAllowToggle(const Value: Boolean);
    procedure SetChecked(const Value: Boolean);
    procedure SetBorderRadius(const Value: Integer);
    procedure SetNormalColor(const Value: TColor);
    procedure SetHoverColor(const Value: TColor);
    procedure SetCheckedColor(const Value: TColor);
    procedure SetPressedColor(const Value: TColor);
    procedure SetDisabledColor(const Value: TColor);
    procedure SetBorderColor(const Value: TColor);
    procedure SetHoverBorderColor(const Value: TColor);
    procedure SetCheckedBorderColor(const Value: TColor);
    procedure SetDisabledBorderColor(const Value: TColor);
    procedure SetCheckedFontColor(const Value: TColor);
    procedure SetDisabledFontColor(const Value: TColor);
    procedure SetGroupIndex(const Value: Integer);
    procedure SetAllowAllUp(const Value: Boolean);
    procedure SetAutoSizeToCaption(const Value: Boolean);
    procedure UpdateExclusiveGroup;
    procedure UpdateAutoSizeToCaption;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Click; override;
    procedure Change; virtual;
    function GetBackColor: TColor; virtual;
    function GetBorderPaintColor: TColor; virtual;
    function GetTextColor: TColor; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Toggle;
  published
    property Align;
    property Anchors;
    property AllowToggle: Boolean read FAllowToggle write SetAllowToggle default True;
    property BorderRadius: Integer read FBorderRadius write SetBorderRadius default 6;
    property Caption;
    property Checked: Boolean read FChecked write SetChecked default False;
    property GroupIndex: Integer read FGroupIndex write SetGroupIndex default 0;
    property AllowAllUp: Boolean read FAllowAllUp write SetAllowAllUp default True;
    property AutoSizeToCaption: Boolean read FAutoSizeToCaption write SetAutoSizeToCaption default False;
    property Constraints;
    property Cursor;
    property Enabled;
    property Font;
    property Height default 28;
    property Hint;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Visible;
    property Width default 80;

    property NormalColor: TColor read FNormalColor write SetNormalColor default clWhite;
    property HoverColor: TColor read FHoverColor write SetHoverColor default $00F5F5F5;
    property CheckedColor: TColor read FCheckedColor write SetCheckedColor default $00E8F0FE;
    property PressedColor: TColor read FPressedColor write SetPressedColor default $00D8E8FD;
    property DisabledColor: TColor read FDisabledColor write SetDisabledColor default $00F0F0F0;
    property BorderColor: TColor read FBorderColor write SetBorderColor default $00D0D0D0;
    property HoverBorderColor: TColor read FHoverBorderColor write SetHoverBorderColor default $00A8A8A8;
    property CheckedBorderColor: TColor read FCheckedBorderColor write SetCheckedBorderColor default $0080A8E8;
    property DisabledBorderColor: TColor read FDisabledBorderColor write SetDisabledBorderColor default $00D8D8D8;
    property CheckedFontColor: TColor read FCheckedFontColor write SetCheckedFontColor default clBlack;
    property DisabledFontColor: TColor read FDisabledFontColor write SetDisabledFontColor default clGrayText;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
  end;


  TDCFlexFlowLayout = class(TCustomControl)
  private
    FAutoHeight: Boolean;
    FBackColor: TColor;
    FHorizontalSpacing: Integer;
    FLayoutLock: Boolean;
    FPaddingBottom: Integer;
    FPaddingLeft: Integer;
    FPaddingRight: Integer;
    FPaddingTop: Integer;
    FVerticalSpacing: Integer;
    FWrap: Boolean;
    procedure SetAutoHeight(const Value: Boolean);
    procedure SetBackColor(const Value: TColor);
    procedure SetHorizontalSpacing(const Value: Integer);
    procedure SetPaddingBottom(const Value: Integer);
    procedure SetPaddingLeft(const Value: Integer);
    procedure SetPaddingRight(const Value: Integer);
    procedure SetPaddingTop(const Value: Integer);
    procedure SetVerticalSpacing(const Value: Integer);
    procedure SetWrap(const Value: Boolean);
  protected
    procedure AlignControls(AControl: TControl; var Rect: TRect); override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
    procedure Resize; override;
    procedure LayoutControls; virtual;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Align;
    property Anchors;
    property AutoHeight: Boolean read FAutoHeight write SetAutoHeight default False;
    property BackColor: TColor read FBackColor write SetBackColor default $00FAFAFA;
    property Constraints;
    property Cursor;
    property Enabled;
    property Font;
    property Height default 44;
    property Hint;
    property HorizontalSpacing: Integer read FHorizontalSpacing write SetHorizontalSpacing default 4;
    property PaddingLeft: Integer read FPaddingLeft write SetPaddingLeft default 8;
    property PaddingTop: Integer read FPaddingTop write SetPaddingTop default 6;
    property PaddingRight: Integer read FPaddingRight write SetPaddingRight default 8;
    property PaddingBottom: Integer read FPaddingBottom write SetPaddingBottom default 6;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop default False;
    property VerticalSpacing: Integer read FVerticalSpacing write SetVerticalSpacing default 4;
    property Visible;
    property Wrap: Boolean read FWrap write SetWrap default True;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
  end;


  TDCFlexToolbar = class(TCustomControl)
  private
    FBackColor: TColor;
    FBorderColor: TColor;
    FButtonSpacing: Integer;
    FButtonHeight: Integer;
    FAutoButtonWidth: Boolean;
    FAutoButtonMinWidth: Integer;
    FSeparatorWidth: Integer;
    FSeparatorColor: TColor;
    FPaddingLeft: Integer;
    FPaddingTop: Integer;
    FPaddingRight: Integer;
    FPaddingBottom: Integer;
    procedure SetBackColor(const Value: TColor);
    procedure SetBorderColor(const Value: TColor);
    procedure SetButtonSpacing(const Value: Integer);
    procedure SetButtonHeight(const Value: Integer);
    procedure SetAutoButtonWidth(const Value: Boolean);
    procedure SetAutoButtonMinWidth(const Value: Integer);
    procedure SetSeparatorWidth(const Value: Integer);
    procedure SetSeparatorColor(const Value: TColor);
    procedure SetPaddingLeft(const Value: Integer);
    procedure SetPaddingTop(const Value: Integer);
    procedure SetPaddingRight(const Value: Integer);
    procedure SetPaddingBottom(const Value: Integer);
    function GetContentHeight: Integer;
    function GetButtonWidth(const ACaption: string; ARequestedWidth: Integer): Integer;
  protected
    procedure Paint; override;
    procedure Resize; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Loaded; override;
    procedure AlignControls(AControl: TControl; var Rect: TRect); override;
    procedure LayoutControls; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    function AddToggleButton(const ACaption: string; AWidth: Integer = 0;
      AGroupIndex: Integer = 0; AChecked: Boolean = False): TDCFlexToggleButton;
    procedure AddSeparator(AWidth: Integer = 0);
    procedure AddSpace(AWidth: Integer = 8);
  published
    property Align default alTop;
    property Anchors;
    property BackColor: TColor read FBackColor write SetBackColor default $00FAFAFA;
    property BorderColor: TColor read FBorderColor write SetBorderColor default $00E0E0E0;
    property ButtonSpacing: Integer read FButtonSpacing write SetButtonSpacing default 4;
    property ButtonHeight: Integer read FButtonHeight write SetButtonHeight default 0;
    property AutoButtonWidth: Boolean read FAutoButtonWidth write SetAutoButtonWidth default True;
    property AutoButtonMinWidth: Integer read FAutoButtonMinWidth write SetAutoButtonMinWidth default 40;
    property SeparatorWidth: Integer read FSeparatorWidth write SetSeparatorWidth default 8;
    property SeparatorColor: TColor read FSeparatorColor write SetSeparatorColor default $00D8D8D8;
    property PaddingLeft: Integer read FPaddingLeft write SetPaddingLeft default 8;
    property PaddingTop: Integer read FPaddingTop write SetPaddingTop default 6;
    property PaddingRight: Integer read FPaddingRight write SetPaddingRight default 8;
    property PaddingBottom: Integer read FPaddingBottom write SetPaddingBottom default 6;
    property Constraints;
    property Cursor;
    property Enabled;
    property Font;
    property Height default 42;
    property Hint;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop default False;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
  end;

implementation

constructor TDCFlexColorPicker.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAllowCustomColor := True;
  FSelected := clBlack;
  FPaletteLoaded := False;
  FPaletteLanguage := cplEnglish;
  Style := csOwnerDrawFixed;
  ItemHeight := 22;
  Height := 24;
end;

destructor TDCFlexColorPicker.Destroy;
begin
  if Assigned(FLanguageSource) then
    FLanguageSource.RemoveChangeListener(LanguageSourceChange);
  inherited Destroy;
end;

procedure TDCFlexColorPicker.AddColorItem(const ACaption: string; AColor: TColor);
begin
  Items.AddObject(ACaption, TObject(NativeInt(AColor)));
end;

procedure TDCFlexColorPicker.ApplySelectedIndex;
var
  I: Integer;
begin
  if not FPaletteLoaded then
    Exit;

  EnsureColorItem(FSelected);
  for I := 0 to Items.Count - 1 do
    if TColor(NativeInt(Items.Objects[I])) = FSelected then
    begin
      ItemIndex := I;
      Exit;
    end;
end;

function TDCFlexColorPicker.ColorText(AColor: TColor): string;
var
  C: Longint;
begin
  if AColor = clNone then
    Exit('None');

  C := ColorToRGB(AColor);
  Result := Format('#%.2x%.2x%.2x', [GetRValue(C), GetGValue(C), GetBValue(C)]);
  Result := UpperCase(Result);
end;

procedure TDCFlexColorPicker.DblClick;
begin
  if not SelectCustomColor then
    inherited;
end;

procedure TDCFlexColorPicker.LanguageSourceChange(Sender: TObject);
begin
  if Assigned(FLanguageSource) then
  begin
    if FLanguageSource.Language = dlcPortuguese then
      SetPaletteLanguage(cplPortuguese)
    else
      SetPaletteLanguage(cplEnglish);
  end;
  FPaletteLoaded := False;
  if HandleAllocated and Assigned(Parent) then
    LoadDefaultPalette;
end;

function TDCFlexColorPicker.DisplayText(AColor: TColor): string;
var
  I: Integer;
begin
  if not FPaletteLoaded then
    LoadDefaultPalette;

  for I := 0 to Items.Count - 1 do
    if TColor(NativeInt(Items.Objects[I])) = AColor then
      Exit(Items[I]);

  Result := PaletteText('Custom ', 'Personalizada ') + ColorText(AColor);
end;

procedure TDCFlexColorPicker.DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  SwatchRect, TextRect: TRect;
  LSwatchHeight: Integer;
  LColor: TColor;
  LText: string;
begin
  if odSelected in State then
  begin
    Canvas.Brush.Style := bsSolid;
    Canvas.Brush.Color := clHighlight;
  end
  else
  begin
    Canvas.Brush.Style := bsSolid;
    Canvas.Brush.Color := Color;
  end;
  Canvas.FillRect(Rect);
  if (Index < 0) or (Index >= Items.Count) then
    Exit;

  LColor := TColor(NativeInt(Items.Objects[Index]));
  LText := Items[Index];

  LSwatchHeight := Rect.Bottom - Rect.Top - 4;
  if LSwatchHeight < 11 then
    LSwatchHeight := 11;
  if LSwatchHeight > 15 then
    LSwatchHeight := 15;

  SwatchRect := Rect;
  SwatchRect.Left := SwatchRect.Left + 7;
  SwatchRect.Top := Rect.Top + ((Rect.Bottom - Rect.Top) - LSwatchHeight) div 2;
  SwatchRect.Right := SwatchRect.Left + 24;
  SwatchRect.Bottom := SwatchRect.Top + LSwatchHeight;

  Canvas.Brush.Style := bsSolid;
  if LColor = clNone then
    Canvas.Brush.Color := clWhite
  else
    Canvas.Brush.Color := LColor;
  Canvas.Pen.Color := $00AEB7C2;
  Canvas.Rectangle(SwatchRect);

  if LColor = clNone then
  begin
    Canvas.Pen.Color := clRed;
    Canvas.MoveTo(SwatchRect.Left + 2, SwatchRect.Bottom - 2);
    Canvas.LineTo(SwatchRect.Right - 2, SwatchRect.Top + 2);
  end;

  TextRect := Rect;
  TextRect.Left := SwatchRect.Right + 8;
  TextRect.Right := TextRect.Right - 6;
  Canvas.Brush.Style := bsClear;
  if odSelected in State then
    Canvas.Font.Color := clHighlightText
  else
    Canvas.Font.Color := Font.Color;
  DrawText(Canvas.Handle, PChar(LText), Length(LText), TextRect,
    DT_LEFT or DT_VCENTER or DT_SINGLELINE or DT_END_ELLIPSIS or DT_NOPREFIX);
  Canvas.Brush.Style := bsSolid;
end;

procedure TDCFlexColorPicker.EnsureColorItem(AColor: TColor);
var
  I: Integer;
begin
  for I := 0 to Items.Count - 1 do
    if TColor(NativeInt(Items.Objects[I])) = AColor then
      Exit;

  AddColorItem(PaletteText('Custom ', 'Personalizada ') + ColorText(AColor), AColor);
end;

function TDCFlexColorPicker.GetSelected: TColor;
begin
  if (ItemIndex >= 0) and (ItemIndex < Items.Count) then
    Result := TColor(NativeInt(Items.Objects[ItemIndex]))
  else
    Result := FSelected;
end;

procedure TDCFlexColorPicker.LoadDefaultPalette;
begin
  if HandleAllocated and (not Assigned(Parent)) then
    Exit;

  Items.BeginUpdate;
  try
    Items.Clear;
    AddColorItem(PaletteText('None', 'Nenhuma'), clNone);
    AddColorItem(PaletteText('Black', 'Preto'), clBlack);
    AddColorItem(PaletteText('White', 'Branco'), clWhite);
    AddColorItem(PaletteText('Light Gray', 'Cinza claro'), RGB(236, 239, 243));
    AddColorItem(PaletteText('Gray', 'Cinza'), RGB(148, 163, 184));
    AddColorItem(PaletteText('Slate', 'Ard' + #243 + 'sia'), RGB(80, 90, 102));
    AddColorItem(PaletteText('Dark Slate', 'Ard' + #243 + 'sia escuro'), RGB(37, 52, 69));

    AddColorItem(PaletteText('Light Blue', 'Azul claro'), RGB(221, 235, 255));
    AddColorItem(PaletteText('Blue', 'Azul'), RGB(59, 130, 246));
    AddColorItem(PaletteText('Dark Blue', 'Azul escuro'), RGB(30, 64, 175));
    AddColorItem(PaletteText('Indigo', 'Indigo'), RGB(99, 102, 241));
    AddColorItem(PaletteText('Purple', 'Roxo'), RGB(139, 92, 246));
    AddColorItem(PaletteText('Lavender', 'Lavanda'), RGB(233, 221, 255));

    AddColorItem(PaletteText('Light Green', 'Verde claro'), RGB(221, 246, 229));
    AddColorItem(PaletteText('Green', 'Verde'), RGB(34, 197, 94));
    AddColorItem(PaletteText('Dark Green', 'Verde escuro'), RGB(22, 101, 52));
    AddColorItem(PaletteText('Mint', 'Menta'), RGB(223, 247, 242));
    AddColorItem(PaletteText('Teal', 'Azul petr' + #243 + 'leo'), RGB(20, 184, 166));
    AddColorItem(PaletteText('Cyan', 'Ciano'), RGB(165, 243, 252));

    AddColorItem(PaletteText('Light Yellow', 'Amarelo claro'), RGB(255, 244, 194));
    AddColorItem(PaletteText('Yellow', 'Amarelo'), RGB(250, 204, 21));
    AddColorItem(PaletteText('Soft Amber', #194 + 'mbar suave'), RGB(255, 235, 221));
    AddColorItem(PaletteText('Amber', #194 + 'mbar'), RGB(245, 158, 11));
    AddColorItem(PaletteText('Orange', 'Laranja'), RGB(249, 115, 22));
    AddColorItem(PaletteText('Coral', 'Coral'), RGB(255, 127, 127));
    AddColorItem(PaletteText('Light Red', 'Vermelho claro'), RGB(255, 215, 215));
    AddColorItem(PaletteText('Red', 'Vermelho'), RGB(239, 68, 68));

    AddColorItem(PaletteText('Light Pink', 'Rosa claro'), RGB(252, 225, 239));
    AddColorItem(PaletteText('Pink', 'Rosa'), RGB(236, 72, 153));
    AddColorItem(PaletteText('Rose', 'Rose'), RGB(244, 63, 94));
    AddColorItem(PaletteText('Brown', 'Marrom'), RGB(120, 83, 57));
    FPaletteLoaded := True;
    ApplySelectedIndex;
  finally
    Items.EndUpdate;
  end;
end;

function TDCFlexColorPicker.PaletteText(const AEnglish,
  APortuguese: string): string;
var
  LKey: string;
begin
  LKey := 'color.' + LowerCase(StringReplace(AEnglish, ' ', '.', [rfReplaceAll]));
  LKey := StringReplace(LKey, '...', '', [rfReplaceAll]);
  while (LKey <> '') and (LKey[Length(LKey)] = '.') do
    Delete(LKey, Length(LKey), 1);
  if Assigned(FLanguageSource) then
    Exit(FLanguageSource.Text(dlsCommon, LKey, AEnglish));

  if FPaletteLanguage = cplPortuguese then
    Result := APortuguese
  else
    Result := AEnglish;
end;

function TDCFlexColorPicker.SelectCustomColor: Boolean;
var
  Dlg: TColorDialog;
begin
  Result := False;
  if not FAllowCustomColor then
    Exit;

  Dlg := TColorDialog.Create(Self);
  try
    if Selected = clNone then
      Dlg.Color := clBlack
    else
      Dlg.Color := Selected;
    if Dlg.Execute then
    begin
      Selected := Dlg.Color;
      Result := True;
    end;
  finally
    Dlg.Free;
  end;
end;

procedure TDCFlexColorPicker.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if Assigned(AParent) then
  begin
    if not FPaletteLoaded then
      LoadDefaultPalette;
  end;
end;

procedure TDCFlexColorPicker.SetPaletteLanguage(
  const Value: TDCFlexColorPickerLanguage);
begin
  if FPaletteLanguage <> Value then
  begin
    FSelected := GetSelected;
    FPaletteLanguage := Value;
    FPaletteLoaded := False;
    if HandleAllocated and Assigned(Parent) then
      LoadDefaultPalette;
  end;
end;

procedure TDCFlexColorPicker.SetSelected(const Value: TColor);
begin
  FSelected := Value;
  ApplySelectedIndex;
end;

procedure TDCFlexColorPicker.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FLanguageSource) then
    SetLanguageSource(nil);
end;

procedure TDCFlexColorPicker.SetLanguageSource(const Value: TDCFlexLanguage);
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

type
  TDCFlexColorPalettePopup = class(TForm)
  private
    FButton: TDCFlexColorPaletteButton;
    FCellSize: Integer;
    FColumns: Integer;
    FHotIndex: Integer;
    FPaletteTop: Integer;
    FStandardTop: Integer;
    procedure ApplyHotIndex;
    function ColorAt(AIndex: Integer): TColor;
    function CancelRect: TRect;
    function ColorByHotIndex(AIndex: Integer): TColor;
    function CustomColorRect: TRect;
    function FindSelectedIndex: Integer;
    function HotCount: Integer;
    function HotRect(AIndex: Integer): TRect;
    procedure MoveHotIndex(ADelta: Integer);
    function PaletteCount: Integer;
    function PaletteRect(AIndex: Integer): TRect;
    function StandardColorAt(AIndex: Integer): TColor;
    function StandardCount: Integer;
    function StandardRect(AIndex: Integer): TRect;
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer); override;
    procedure Paint; override;
  public
    constructor CreatePopup(AOwner: TComponent;
      AButton: TDCFlexColorPaletteButton); reintroduce;
  end;

{ TDCFlexColorPalettePopup }

constructor TDCFlexColorPalettePopup.CreatePopup(AOwner: TComponent;
  AButton: TDCFlexColorPaletteButton);
begin
  inherited CreateNew(AOwner);
  FButton := AButton;
  FCellSize := 20;
  FColumns := 10;
  FPaletteTop := 38;
  FStandardTop := FPaletteTop + (5 * FCellSize) + 22;
  BorderStyle := bsNone;
  Color := clWhite;
  KeyPreview := True;
  Position := poDesigned;
  Width := 228;
  Height := FStandardTop + FCellSize + 46;
  Font.Name := 'Segoe UI';
  Font.Size := 9;
  FHotIndex := FindSelectedIndex;
end;

procedure TDCFlexColorPalettePopup.ApplyHotIndex;
begin
  if (FHotIndex < 0) or (FHotIndex >= HotCount) then
    Exit;

  FButton.Selected := ColorByHotIndex(FHotIndex);
  Close;
end;

function TDCFlexColorPalettePopup.ColorAt(AIndex: Integer): TColor;
begin
  case AIndex of
    0: Result := clNone;
    1: Result := clBlack;
    2: Result := RGB(67, 67, 67);
    3: Result := RGB(102, 102, 102);
    4: Result := RGB(153, 153, 153);
    5: Result := RGB(183, 183, 183);
    6: Result := RGB(217, 217, 217);
    7: Result := RGB(239, 239, 239);
    8: Result := clWhite;
    9: Result := RGB(221, 235, 247);
    10: Result := RGB(152, 0, 0);
    11: Result := RGB(255, 0, 0);
    12: Result := RGB(255, 153, 0);
    13: Result := RGB(255, 255, 0);
    14: Result := RGB(0, 255, 0);
    15: Result := RGB(0, 255, 255);
    16: Result := RGB(74, 134, 232);
    17: Result := RGB(0, 0, 255);
    18: Result := RGB(153, 0, 255);
    19: Result := RGB(255, 0, 255);
    20: Result := RGB(230, 184, 175);
    21: Result := RGB(244, 204, 204);
    22: Result := RGB(252, 229, 205);
    23: Result := RGB(255, 242, 204);
    24: Result := RGB(217, 234, 211);
    25: Result := RGB(208, 224, 227);
    26: Result := RGB(201, 218, 248);
    27: Result := RGB(207, 226, 243);
    28: Result := RGB(217, 210, 233);
    29: Result := RGB(234, 209, 220);
    30: Result := RGB(204, 65, 37);
    31: Result := RGB(224, 102, 102);
    32: Result := RGB(246, 178, 107);
    33: Result := RGB(255, 217, 102);
    34: Result := RGB(147, 196, 125);
    35: Result := RGB(118, 165, 175);
    36: Result := RGB(109, 158, 235);
    37: Result := RGB(61, 133, 198);
    38: Result := RGB(142, 124, 195);
    39: Result := RGB(194, 123, 160);
    40: Result := RGB(234, 209, 220);
  else
    Result := clWhite;
  end;
end;

function TDCFlexColorPalettePopup.CancelRect: TRect;
begin
  Result := Rect(Width - 68, Height - 34, Width - 12, Height - 10);
end;

function TDCFlexColorPalettePopup.ColorByHotIndex(AIndex: Integer): TColor;
begin
  if AIndex < PaletteCount then
    Result := ColorAt(AIndex)
  else
    Result := StandardColorAt(AIndex - PaletteCount);
end;

function TDCFlexColorPalettePopup.CustomColorRect: TRect;
begin
  Result := Rect(12, Height - 34, Width - 76, Height - 10);
end;

function TDCFlexColorPalettePopup.FindSelectedIndex: Integer;
var
  I: Integer;
  LColor: TColor;
begin
  Result := 0;
  for I := 0 to HotCount - 1 do
  begin
    LColor := ColorByHotIndex(I);
    if ((LColor = clNone) and (FButton.Selected = clNone)) or
      ((LColor <> clNone) and (FButton.Selected <> clNone) and
      (ColorToRGB(LColor) = ColorToRGB(FButton.Selected))) then
    begin
      Result := I;
      Exit;
    end;
  end;
end;

function TDCFlexColorPalettePopup.HotCount: Integer;
begin
  Result := PaletteCount + StandardCount;
end;

function TDCFlexColorPalettePopup.HotRect(AIndex: Integer): TRect;
begin
  if AIndex < PaletteCount then
    Result := PaletteRect(AIndex)
  else
    Result := StandardRect(AIndex - PaletteCount);
end;

procedure TDCFlexColorPalettePopup.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  case Key of
    VK_LEFT:
      MoveHotIndex(-1);
    VK_RIGHT:
      MoveHotIndex(1);
    VK_UP:
      MoveHotIndex(-FColumns);
    VK_DOWN:
      MoveHotIndex(FColumns);
    VK_HOME:
      begin
        FHotIndex := 0;
        Invalidate;
      end;
    VK_END:
      begin
        FHotIndex := HotCount - 1;
        Invalidate;
      end;
    VK_RETURN, VK_SPACE:
      ApplyHotIndex;
    VK_ESCAPE:
      Close;
  else
    Exit;
  end;
  Key := 0;
end;

procedure TDCFlexColorPalettePopup.MoveHotIndex(ADelta: Integer);
begin
  Inc(FHotIndex, ADelta);
  if FHotIndex < 0 then
    FHotIndex := 0;
  if FHotIndex >= HotCount then
    FHotIndex := HotCount - 1;
  Invalidate;
end;

function TDCFlexColorPalettePopup.PaletteCount: Integer;
begin
  Result := 41;
end;

function TDCFlexColorPalettePopup.PaletteRect(AIndex: Integer): TRect;
var
  LCol: Integer;
  LRow: Integer;
begin
  LCol := AIndex mod FColumns;
  LRow := AIndex div FColumns;
  Result := Rect(12 + (LCol * FCellSize), FPaletteTop + (LRow * FCellSize),
    12 + (LCol * FCellSize) + 18, FPaletteTop + (LRow * FCellSize) + 18);
end;

procedure TDCFlexColorPalettePopup.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  I: Integer;
  R: TRect;
begin
  inherited;
  if Button <> mbLeft then
    Exit;

  R := Rect(12, 8, Width - 12, 28);
  if PtInRect(R, Point(X, Y)) then
  begin
    FButton.Selected := clNone;
    Close;
    Exit;
  end;

  for I := 0 to PaletteCount - 1 do
    if PtInRect(PaletteRect(I), Point(X, Y)) then
    begin
      FButton.Selected := ColorAt(I);
      Close;
      Exit;
    end;

  for I := 0 to StandardCount - 1 do
    if PtInRect(StandardRect(I), Point(X, Y)) then
    begin
      FButton.Selected := StandardColorAt(I);
      Close;
      Exit;
    end;

  R := CustomColorRect;
  if PtInRect(R, Point(X, Y)) then
  begin
    if FButton.SelectCustomColor then
      Close;
    Exit;
  end;

  R := CancelRect;
  if PtInRect(R, Point(X, Y)) then
  begin
    Close;
    Exit;
  end;
end;

procedure TDCFlexColorPalettePopup.Paint;
var
  I: Integer;
  R: TRect;
  LColor: TColor;
begin
  inherited;
  Canvas.Brush.Color := clWhite;
  Canvas.FillRect(ClientRect);
  Canvas.Pen.Color := $00D5DAE0;
  Canvas.Rectangle(ClientRect);

  Canvas.Font.Assign(Font);
  Canvas.Font.Color := $00333A45;
  Canvas.Brush.Style := bsClear;
  R := Rect(12, 8, Width - 12, 28);
  DrawText(Canvas.Handle,
    PChar(FButton.PaletteText('Reset', 'Redefinir')), -1, R,
    DT_LEFT or DT_VCENTER or DT_SINGLELINE);
  Canvas.Brush.Style := bsSolid;

  for I := 0 to PaletteCount - 1 do
  begin
    R := PaletteRect(I);
    LColor := ColorAt(I);
    if LColor = clNone then
      Canvas.Brush.Color := clWhite
    else
      Canvas.Brush.Color := LColor;
    Canvas.Pen.Color := $00CBD5E1;
    Canvas.Rectangle(R);
    if LColor = clNone then
    begin
      Canvas.Pen.Color := clRed;
      Canvas.MoveTo(R.Left + 3, R.Bottom - 4);
      Canvas.LineTo(R.Right - 3, R.Top + 3);
    end;
    if ((LColor = clNone) and (FButton.Selected = clNone)) or
      ((LColor <> clNone) and (FButton.Selected <> clNone) and
      (ColorToRGB(LColor) = ColorToRGB(FButton.Selected))) then
    begin
      Canvas.Pen.Color := $002563EB;
      Canvas.Brush.Style := bsClear;
      InflateRect(R, -1, -1);
      Canvas.Rectangle(R);
      Canvas.Brush.Style := bsSolid;
    end;
    if I = FHotIndex then
    begin
      R := HotRect(I);
      Canvas.Pen.Color := $000F172A;
      Canvas.Brush.Style := bsClear;
      InflateRect(R, -2, -2);
      Canvas.Rectangle(R);
      Canvas.Brush.Style := bsSolid;
    end;
  end;

  R := Rect(12, FStandardTop - 18, Width - 12, FStandardTop - 2);
  Canvas.Font.Style := [fsBold];
  Canvas.Font.Size := Font.Size - 1;
  Canvas.Font.Color := $00647586;
  Canvas.Brush.Style := bsClear;
  DrawText(Canvas.Handle,
    PChar(FButton.PaletteText('STANDARD', 'PADRAO')), -1, R,
    DT_LEFT or DT_VCENTER or DT_SINGLELINE);
  Canvas.Font.Style := [];
  Canvas.Font.Size := Font.Size;
  Canvas.Brush.Style := bsSolid;

  for I := 0 to StandardCount - 1 do
  begin
    R := StandardRect(I);
    LColor := StandardColorAt(I);
    Canvas.Brush.Color := LColor;
    Canvas.Pen.Color := $00CBD5E1;
    Canvas.Rectangle(R);
    if (PaletteCount + I) = FHotIndex then
    begin
      R := HotRect(PaletteCount + I);
      Canvas.Pen.Color := $000F172A;
      Canvas.Brush.Style := bsClear;
      InflateRect(R, -2, -2);
      Canvas.Rectangle(R);
      Canvas.Brush.Style := bsSolid;
    end;
  end;

  R := CustomColorRect;
  Canvas.Brush.Color := $00F8FAFC;
  Canvas.Pen.Color := $00E1E6EC;
  Canvas.Rectangle(R);
  Canvas.Brush.Style := bsClear;
  DrawText(Canvas.Handle,
    PChar(FButton.PaletteText('Custom color...', 'Cor personalizada...')), -1,
    R, DT_CENTER or DT_VCENTER or DT_SINGLELINE);

  R := CancelRect;
  Canvas.Brush.Style := bsSolid;
  Canvas.Brush.Color := clWhite;
  Canvas.Pen.Color := $00E1E6EC;
  Canvas.Rectangle(R);
  Canvas.Brush.Style := bsClear;
  DrawText(Canvas.Handle,
    PChar(FButton.PaletteText('Cancel', 'Cancelar')), -1,
    R, DT_CENTER or DT_VCENTER or DT_SINGLELINE);
  Canvas.Brush.Style := bsSolid;
end;

function TDCFlexColorPalettePopup.StandardColorAt(AIndex: Integer): TColor;
begin
  case AIndex of
    0: Result := clBlack;
    1: Result := clWhite;
    2: Result := RGB(66, 133, 244);
    3: Result := RGB(234, 67, 53);
    4: Result := RGB(251, 188, 5);
    5: Result := RGB(52, 168, 83);
    6: Result := RGB(255, 109, 1);
    7: Result := RGB(70, 189, 198);
  else
    Result := clWhite;
  end;
end;

function TDCFlexColorPalettePopup.StandardCount: Integer;
begin
  Result := 8;
end;

function TDCFlexColorPalettePopup.StandardRect(AIndex: Integer): TRect;
begin
  Result := Rect(12 + (AIndex * FCellSize), FStandardTop,
    12 + (AIndex * FCellSize) + 18, FStandardTop + 18);
end;

{ TDCFlexColorPaletteButton }

constructor TDCFlexColorPaletteButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csCaptureMouse, csClickEvents, csOpaque];
  Width := 42;
  Height := 26;
  TabStop := True;
  Color := clWhite;
  FAllowCustomColor := True;
  FBorderColor := $00D0D7DE;
  FHoverColor := $00F1F5F9;
  FPaletteLanguage := cplEnglish;
  FSelected := clBlack;
end;

destructor TDCFlexColorPaletteButton.Destroy;
begin
  if Assigned(FLanguageSource) then
    FLanguageSource.RemoveChangeListener(LanguageSourceChange);
  inherited Destroy;
end;

procedure TDCFlexColorPaletteButton.Change;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TDCFlexColorPaletteButton.Click;
begin
  inherited;
  DropDown;
end;

procedure TDCFlexColorPaletteButton.CMEnter(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TDCFlexColorPaletteButton.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TDCFlexColorPaletteButton.CMExit(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TDCFlexColorPaletteButton.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  FMouseOver := True;
  Invalidate;
end;

procedure TDCFlexColorPaletteButton.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  FMouseOver := False;
  Invalidate;
end;

procedure TDCFlexColorPaletteButton.DropDown;
var
  LPopup: TDCFlexColorPalettePopup;
  P: TPoint;
begin
  if not Enabled then
    Exit;

  LPopup := TDCFlexColorPalettePopup.CreatePopup(Self, Self);
  try
    P := ClientToScreen(Point(0, Height));
    LPopup.Left := P.X;
    LPopup.Top := P.Y;
    LPopup.ShowModal;
  finally
    LPopup.Free;
  end;
end;

procedure TDCFlexColorPaletteButton.KeyDown(var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_RETURN) or (Key = VK_SPACE) then
  begin
    Key := 0;
    DropDown;
  end;
end;

procedure TDCFlexColorPaletteButton.LanguageSourceChange(Sender: TObject);
begin
  if Assigned(FLanguageSource) then
  begin
    if FLanguageSource.Language = dlcPortuguese then
      SetPaletteLanguage(cplPortuguese)
    else
      SetPaletteLanguage(cplEnglish);
  end;
  Invalidate;
end;

procedure TDCFlexColorPaletteButton.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FLanguageSource) then
    SetLanguageSource(nil);
end;

function TDCFlexColorPaletteButton.PaletteText(const AEnglish,
  APortuguese: string): string;
var
  LKey: string;
begin
  LKey := 'color.' + LowerCase(StringReplace(AEnglish, ' ', '.', [rfReplaceAll]));
  LKey := StringReplace(LKey, '...', '', [rfReplaceAll]);
  while (LKey <> '') and (LKey[Length(LKey)] = '.') do
    Delete(LKey, Length(LKey), 1);
  if Assigned(FLanguageSource) then
    Exit(FLanguageSource.Text(dlsCommon, LKey, AEnglish));

  if FPaletteLanguage = cplPortuguese then
    Result := APortuguese
  else
    Result := AEnglish;
end;

procedure TDCFlexColorPaletteButton.Paint;
var
  R: TRect;
  SwatchRect: TRect;
  Arrow: array[0..2] of TPoint;
  ArrowX: Integer;
  ArrowY: Integer;
  LBackColor: TColor;
begin
  LBackColor := Color;
  if FMouseOver then
    LBackColor := FHoverColor;
  if not Enabled then
    LBackColor := $00F0F0F0;

  Canvas.Brush.Color := LBackColor;
  Canvas.Pen.Color := FBorderColor;
  Canvas.Rectangle(ClientRect);

  SwatchRect := Rect(8, 6, Width - 21, Height - 6);
  if SwatchRect.Bottom - SwatchRect.Top < 12 then
  begin
    SwatchRect.Top := (Height - 12) div 2;
    SwatchRect.Bottom := SwatchRect.Top + 12;
  end;
  Canvas.Brush.Color := clWhite;
  Canvas.Pen.Color := $00B8C1CC;
  Canvas.Rectangle(SwatchRect);
  InflateRect(SwatchRect, -1, -1);
  if FSelected = clNone then
  begin
    Canvas.Brush.Color := clWhite;
    Canvas.FillRect(SwatchRect);
    Canvas.Pen.Color := clRed;
    Canvas.MoveTo(SwatchRect.Left, SwatchRect.Bottom - 1);
    Canvas.LineTo(SwatchRect.Right - 1, SwatchRect.Top);
  end
  else
  begin
    Canvas.Brush.Color := FSelected;
    Canvas.FillRect(SwatchRect);
  end;

  ArrowX := Width - 15;
  ArrowY := Height div 2;
  Canvas.Brush.Color := $005F6B7A;
  Canvas.Pen.Color := $005F6B7A;
  Arrow[0] := Point(ArrowX, ArrowY - 1);
  Arrow[1] := Point(ArrowX + 5, ArrowY - 1);
  Arrow[2] := Point(ArrowX + 2, ArrowY + 2);
  Canvas.Polygon(Arrow);

  if Focused and Enabled then
  begin
    R := ClientRect;
    InflateRect(R, -3, -3);
    Canvas.Brush.Style := bsClear;
    Canvas.Pen.Color := $002563EB;
    Canvas.Rectangle(R);
    Canvas.Brush.Style := bsSolid;
  end;
end;

function TDCFlexColorPaletteButton.SelectCustomColor: Boolean;
var
  Dlg: TColorDialog;
begin
  Result := False;
  if not FAllowCustomColor then
    Exit;

  Dlg := TColorDialog.Create(Self);
  try
    if FSelected = clNone then
      Dlg.Color := clBlack
    else
      Dlg.Color := FSelected;
    if Dlg.Execute then
    begin
      Selected := Dlg.Color;
      Result := True;
    end;
  finally
    Dlg.Free;
  end;
end;

procedure TDCFlexColorPaletteButton.SetBorderColor(const Value: TColor);
begin
  if FBorderColor <> Value then
  begin
    FBorderColor := Value;
    Invalidate;
  end;
end;

procedure TDCFlexColorPaletteButton.SetHoverColor(const Value: TColor);
begin
  if FHoverColor <> Value then
  begin
    FHoverColor := Value;
    Invalidate;
  end;
end;

procedure TDCFlexColorPaletteButton.SetLanguageSource(
  const Value: TDCFlexLanguage);
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

procedure TDCFlexColorPaletteButton.SetPaletteLanguage(
  const Value: TDCFlexColorPickerLanguage);
begin
  if FPaletteLanguage <> Value then
    FPaletteLanguage := Value;
end;

procedure TDCFlexColorPaletteButton.SetSelected(const Value: TColor);
begin
  if FSelected <> Value then
  begin
    FSelected := Value;
    Invalidate;
    Change;
  end;
end;

{ TDCFlexToggleButton }

constructor TDCFlexToggleButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csCaptureMouse, csClickEvents, csDoubleClicks, csOpaque];
  Width := 80;
  Height := 28;
  TabStop := True;
  FAllowToggle := True;
  FChecked := False;
  FGroupIndex := 0;
  FAllowAllUp := True;
  FAutoSizeToCaption := False;
  FBorderRadius := 6;
  FNormalColor := clWhite;
  FHoverColor := $00F5F5F5;
  FCheckedColor := $00E8F0FE;
  FPressedColor := $00D8E8FD;
  FDisabledColor := $00F0F0F0;
  FBorderColor := $00D0D0D0;
  FHoverBorderColor := $00A8A8A8;
  FCheckedBorderColor := $0080A8E8;
  FDisabledBorderColor := $00D8D8D8;
  FCheckedFontColor := clBlack;
  FDisabledFontColor := clGrayText;
  Font.Name := 'Segoe UI';
  Font.Size := 9;
  Caption := 'Toggle';
end;

procedure TDCFlexToggleButton.Change;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TDCFlexToggleButton.Click;
begin
  if FAllowToggle then
    Toggle;
  inherited Click;
end;

procedure TDCFlexToggleButton.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TDCFlexToggleButton.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  FMouseOver := True;
  Invalidate;
end;

procedure TDCFlexToggleButton.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  FMouseOver := False;
  FMouseDown := False;
  Invalidate;
end;

procedure TDCFlexToggleButton.CMTextChanged(var Message: TMessage);
begin
  inherited;
  UpdateAutoSizeToCaption;
  Invalidate;
end;

procedure TDCFlexToggleButton.CMFontChanged(var Message: TMessage);
begin
  inherited;
  UpdateAutoSizeToCaption;
  Invalidate;
end;

function TDCFlexToggleButton.GetBackColor: TColor;
begin
  if not Enabled then
    Exit(FDisabledColor);

  if FMouseDown then
    Exit(FPressedColor);

  if FChecked then
    Exit(FCheckedColor);

  if FMouseOver then
    Exit(FHoverColor);

  Result := FNormalColor;
end;

function TDCFlexToggleButton.GetBorderPaintColor: TColor;
begin
  if not Enabled then
    Exit(FDisabledBorderColor);

  if FChecked then
    Exit(FCheckedBorderColor);

  if FMouseOver then
    Exit(FHoverBorderColor);

  Result := FBorderColor;
end;

function TDCFlexToggleButton.GetTextColor: TColor;
begin
  if not Enabled then
    Exit(FDisabledFontColor);

  if FChecked then
    Exit(FCheckedFontColor);

  Result := Font.Color;
end;

procedure TDCFlexToggleButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);

  if (Button = mbLeft) and Enabled then
  begin
    FMouseDown := True;
    SetFocus;
    Invalidate;
  end;
end;

procedure TDCFlexToggleButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);

  if Button = mbLeft then
  begin
    FMouseDown := False;
    Invalidate;
  end;
end;

procedure TDCFlexToggleButton.Paint;
var
  R: TRect;
  LFlags: Cardinal;
  LBackColor: TColor;
  LBorderColor: TColor;
  LTextColor: TColor;
begin
  inherited;

  R := ClientRect;
  LBackColor := GetBackColor;
  LBorderColor := GetBorderPaintColor;
  LTextColor := GetTextColor;

  Canvas.Brush.Color := LBackColor;
  Canvas.Pen.Color := LBorderColor;
  Canvas.Pen.Width := 1;

  if FBorderRadius > 0 then
    Canvas.RoundRect(R.Left, R.Top, R.Right, R.Bottom, FBorderRadius, FBorderRadius)
  else
    Canvas.Rectangle(R);

  Canvas.Font.Assign(Font);
  Canvas.Font.Color := LTextColor;
  Canvas.Brush.Style := bsClear;

  InflateRect(R, -8, 0);
  LFlags := DT_SINGLELINE or DT_CENTER or DT_VCENTER or DT_END_ELLIPSIS;
  DrawText(Canvas.Handle, PChar(Caption), Length(Caption), R, LFlags);
  Canvas.Brush.Style := bsSolid;
end;

procedure TDCFlexToggleButton.SetAllowToggle(const Value: Boolean);
begin
  if FAllowToggle <> Value then
    FAllowToggle := Value;
end;

procedure TDCFlexToggleButton.SetAllowAllUp(const Value: Boolean);
begin
  if FAllowAllUp <> Value then
    FAllowAllUp := Value;
end;

procedure TDCFlexToggleButton.SetAutoSizeToCaption(const Value: Boolean);
begin
  if FAutoSizeToCaption <> Value then
  begin
    FAutoSizeToCaption := Value;
    UpdateAutoSizeToCaption;
  end;
end;

procedure TDCFlexToggleButton.SetBorderColor(const Value: TColor);
begin
  if FBorderColor <> Value then
  begin
    FBorderColor := Value;
    Invalidate;
  end;
end;

procedure TDCFlexToggleButton.SetBorderRadius(const Value: Integer);
var
  LValue: Integer;
begin
  LValue := Value;
  if LValue < 0 then
    LValue := 0;

  if FBorderRadius <> LValue then
  begin
    FBorderRadius := LValue;
    Invalidate;
  end;
end;

procedure TDCFlexToggleButton.SetChecked(const Value: Boolean);
begin
  if FChecked <> Value then
  begin
    FChecked := Value;

    if FChecked then
      UpdateExclusiveGroup;

    Invalidate;
    Change;
  end;
end;

procedure TDCFlexToggleButton.SetCheckedBorderColor(const Value: TColor);
begin
  if FCheckedBorderColor <> Value then
  begin
    FCheckedBorderColor := Value;
    Invalidate;
  end;
end;

procedure TDCFlexToggleButton.SetCheckedColor(const Value: TColor);
begin
  if FCheckedColor <> Value then
  begin
    FCheckedColor := Value;
    Invalidate;
  end;
end;

procedure TDCFlexToggleButton.SetCheckedFontColor(const Value: TColor);
begin
  if FCheckedFontColor <> Value then
  begin
    FCheckedFontColor := Value;
    Invalidate;
  end;
end;

procedure TDCFlexToggleButton.SetDisabledBorderColor(const Value: TColor);
begin
  if FDisabledBorderColor <> Value then
  begin
    FDisabledBorderColor := Value;
    Invalidate;
  end;
end;

procedure TDCFlexToggleButton.SetDisabledColor(const Value: TColor);
begin
  if FDisabledColor <> Value then
  begin
    FDisabledColor := Value;
    Invalidate;
  end;
end;

procedure TDCFlexToggleButton.SetDisabledFontColor(const Value: TColor);
begin
  if FDisabledFontColor <> Value then
  begin
    FDisabledFontColor := Value;
    Invalidate;
  end;
end;

procedure TDCFlexToggleButton.SetHoverBorderColor(const Value: TColor);
begin
  if FHoverBorderColor <> Value then
  begin
    FHoverBorderColor := Value;
    Invalidate;
  end;
end;

procedure TDCFlexToggleButton.SetHoverColor(const Value: TColor);
begin
  if FHoverColor <> Value then
  begin
    FHoverColor := Value;
    Invalidate;
  end;
end;

procedure TDCFlexToggleButton.SetNormalColor(const Value: TColor);
begin
  if FNormalColor <> Value then
  begin
    FNormalColor := Value;
    Invalidate;
  end;
end;

procedure TDCFlexToggleButton.SetPressedColor(const Value: TColor);
begin
  if FPressedColor <> Value then
  begin
    FPressedColor := Value;
    Invalidate;
  end;
end;

procedure TDCFlexToggleButton.SetGroupIndex(const Value: Integer);
begin
  if Value < 0 then
    Exit;

  if FGroupIndex <> Value then
  begin
    FGroupIndex := Value;
    if FChecked then
      UpdateExclusiveGroup;
  end;
end;

procedure TDCFlexToggleButton.Toggle;
begin
  if FChecked and (FGroupIndex > 0) and (not FAllowAllUp) then
    Exit;

  Checked := not FChecked;
end;

procedure TDCFlexToggleButton.UpdateAutoSizeToCaption;
var
  LWidth: Integer;
begin
  if not FAutoSizeToCaption then
    Exit;

  Canvas.Font.Assign(Font);
  LWidth := Canvas.TextWidth(Caption) + 24;
  if LWidth < 28 then
    LWidth := 28;

  if Width <> LWidth then
    Width := LWidth;
end;

procedure TDCFlexToggleButton.UpdateExclusiveGroup;
var
  I: Integer;
  LControl: TControl;
  LToggle: TDCFlexToggleButton;
begin
  if (FGroupIndex <= 0) or (Parent = nil) then
    Exit;

  for I := 0 to Parent.ControlCount - 1 do
  begin
    LControl := Parent.Controls[I];
    if (LControl <> Self) and (LControl is TDCFlexToggleButton) then
    begin
      LToggle := TDCFlexToggleButton(LControl);
      if (LToggle.GroupIndex = FGroupIndex) and LToggle.Checked then
        LToggle.Checked := False;
    end;
  end;
end;


{ TDCFlexFlowLayout }

constructor TDCFlexFlowLayout.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csAcceptsControls, csCaptureMouse, csClickEvents, csDoubleClicks, csOpaque];
  Width := 360;
  Height := 44;
  TabStop := False;
  FAutoHeight := False;
  FBackColor := $00FAFAFA;
  FHorizontalSpacing := 4;
  FVerticalSpacing := 4;
  FPaddingLeft := 8;
  FPaddingTop := 6;
  FPaddingRight := 8;
  FPaddingBottom := 6;
  FWrap := True;
  Font.Name := 'Segoe UI';
  Font.Size := 9;
end;

procedure TDCFlexFlowLayout.AlignControls(AControl: TControl; var Rect: TRect);
begin
  inherited AlignControls(AControl, Rect);
  LayoutControls;
end;

procedure TDCFlexFlowLayout.LayoutControls;
var
  I: Integer;
  LAvailableRight: Integer;
  LControl: TControl;
  LLineHeight: Integer;
  LMaxBottom: Integer;
  LTop: Integer;
  LX: Integer;
begin
  if csLoading in ComponentState then
    Exit;

  if not Assigned(Parent) then
    Exit;

  if not HandleAllocated then
    Exit;

  if FLayoutLock then
    Exit;

  FLayoutLock := True;
  try

    LX := FPaddingLeft;
    LTop := FPaddingTop;
    LLineHeight := 0;
    LMaxBottom := LTop;
    LAvailableRight := ClientWidth - FPaddingRight;

    if LAvailableRight < FPaddingLeft then
      LAvailableRight := FPaddingLeft;

    for I := 0 to ControlCount - 1 do
    begin
      LControl := Controls[I];
      if not LControl.Visible then
        Continue;

      if LControl.Align <> alNone then
        Continue;

      if FWrap and (LX > FPaddingLeft) and
         (LX + LControl.Width > LAvailableRight) then
      begin
        LX := FPaddingLeft;
        Inc(LTop, LLineHeight + FVerticalSpacing);
        LLineHeight := 0;
      end;

      LControl.SetBounds(LX, LTop, LControl.Width, LControl.Height);
      Inc(LX, LControl.Width + FHorizontalSpacing);

      if LControl.Height > LLineHeight then
        LLineHeight := LControl.Height;
      if LTop + LControl.Height > LMaxBottom then
        LMaxBottom := LTop + LControl.Height;
    end;

    if FAutoHeight then
    begin
      LMaxBottom := LMaxBottom + FPaddingBottom;
      if LMaxBottom < FPaddingTop + FPaddingBottom then
        LMaxBottom := FPaddingTop + FPaddingBottom;
      if Height <> LMaxBottom then
        Height := LMaxBottom;
    end;
  finally
    FLayoutLock := False;
  end;
end;

procedure TDCFlexFlowLayout.Loaded;
begin
  inherited Loaded;
  LayoutControls;
end;

procedure TDCFlexFlowLayout.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation in [opInsert, opRemove] then
    LayoutControls;
end;

procedure TDCFlexFlowLayout.Paint;
begin
  inherited;
  Canvas.Brush.Color := FBackColor;
  Canvas.FillRect(ClientRect);
end;

procedure TDCFlexFlowLayout.Resize;
begin
  inherited Resize;
  LayoutControls;
  Invalidate;
end;

procedure TDCFlexFlowLayout.SetAutoHeight(const Value: Boolean);
begin
  if FAutoHeight <> Value then
  begin
    FAutoHeight := Value;
    LayoutControls;
  end;
end;

procedure TDCFlexFlowLayout.SetBackColor(const Value: TColor);
begin
  if FBackColor <> Value then
  begin
    FBackColor := Value;
    Invalidate;
  end;
end;

procedure TDCFlexFlowLayout.SetHorizontalSpacing(const Value: Integer);
var
  LValue: Integer;
begin
  LValue := Value;
  if LValue < 0 then
    LValue := 0;

  if FHorizontalSpacing <> LValue then
  begin
    FHorizontalSpacing := LValue;
    LayoutControls;
  end;
end;

procedure TDCFlexFlowLayout.SetPaddingBottom(const Value: Integer);
var
  LValue: Integer;
begin
  LValue := Value;
  if LValue < 0 then
    LValue := 0;

  if FPaddingBottom <> LValue then
  begin
    FPaddingBottom := LValue;
    LayoutControls;
  end;
end;

procedure TDCFlexFlowLayout.SetPaddingLeft(const Value: Integer);
var
  LValue: Integer;
begin
  LValue := Value;
  if LValue < 0 then
    LValue := 0;

  if FPaddingLeft <> LValue then
  begin
    FPaddingLeft := LValue;
    LayoutControls;
  end;
end;

procedure TDCFlexFlowLayout.SetPaddingRight(const Value: Integer);
var
  LValue: Integer;
begin
  LValue := Value;
  if LValue < 0 then
    LValue := 0;

  if FPaddingRight <> LValue then
  begin
    FPaddingRight := LValue;
    LayoutControls;
  end;
end;

procedure TDCFlexFlowLayout.SetPaddingTop(const Value: Integer);
var
  LValue: Integer;
begin
  LValue := Value;
  if LValue < 0 then
    LValue := 0;

  if FPaddingTop <> LValue then
  begin
    FPaddingTop := LValue;
    LayoutControls;
  end;
end;

procedure TDCFlexFlowLayout.SetVerticalSpacing(const Value: Integer);
var
  LValue: Integer;
begin
  LValue := Value;
  if LValue < 0 then
    LValue := 0;

  if FVerticalSpacing <> LValue then
  begin
    FVerticalSpacing := LValue;
    LayoutControls;
  end;
end;

procedure TDCFlexFlowLayout.SetWrap(const Value: Boolean);
begin
  if FWrap <> Value then
  begin
    FWrap := Value;
    LayoutControls;
  end;
end;


{ TDCFlexToolbar }

constructor TDCFlexToolbar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csAcceptsControls, csCaptureMouse, csClickEvents, csDoubleClicks, csOpaque];
  Align := alTop;
  Width := 320;
  Height := 42;
  TabStop := False;
  FBackColor := $00FAFAFA;
  FBorderColor := $00E0E0E0;
  FButtonSpacing := 4;
  FButtonHeight := 0;
  FAutoButtonWidth := True;
  FAutoButtonMinWidth := 40;
  FSeparatorWidth := 8;
  FSeparatorColor := $00D8D8D8;
  FPaddingLeft := 8;
  FPaddingTop := 6;
  FPaddingRight := 8;
  FPaddingBottom := 6;
  Font.Name := 'Segoe UI';
  Font.Size := 9;
end;

function TDCFlexToolbar.AddToggleButton(const ACaption: string; AWidth,
  AGroupIndex: Integer; AChecked: Boolean): TDCFlexToggleButton;
begin
  Result := TDCFlexToggleButton.Create(Self);
  Result.Parent := Self;
  Result.Caption := ACaption;
  Result.Width := GetButtonWidth(ACaption, AWidth);
  Result.Height := GetContentHeight;
  Result.GroupIndex := AGroupIndex;
  Result.AutoSizeToCaption := FAutoButtonWidth and (AWidth <= 0);
  Result.Checked := AChecked;
  Result.Font.Assign(Font);
  LayoutControls;
end;

procedure TDCFlexToolbar.AddSeparator(AWidth: Integer);
var
  LSeparator: TPanel;
begin
  if AWidth < 1 then
    AWidth := FSeparatorWidth;
  if AWidth < 1 then
    AWidth := 1;

  LSeparator := TPanel.Create(Self);
  LSeparator.Parent := Self;
  LSeparator.Width := AWidth;
  LSeparator.Height := GetContentHeight;
  LSeparator.BevelOuter := bvNone;
  LSeparator.Color := FBackColor;
  LSeparator.ParentBackground := False;
  LSeparator.Enabled := False;
  LSeparator.Tag := 1;
  LayoutControls;
end;

procedure TDCFlexToolbar.AddSpace(AWidth: Integer);
var
  LSpace: TPanel;
begin
  if AWidth < 1 then
    AWidth := 8;

  LSpace := TPanel.Create(Self);
  LSpace.Parent := Self;
  LSpace.Width := AWidth;
  LSpace.Height := GetContentHeight;
  LSpace.BevelOuter := bvNone;
  LSpace.Color := FBackColor;
  LSpace.ParentBackground := False;
  LSpace.Enabled := False;
  LSpace.Tag := 2;
  LayoutControls;
end;

procedure TDCFlexToolbar.AlignControls(AControl: TControl; var Rect: TRect);
begin
  inherited AlignControls(AControl, Rect);
  LayoutControls;
end;
function TDCFlexToolbar.GetButtonWidth(const ACaption: string;
  ARequestedWidth: Integer): Integer;
var
  LTextWidth: Integer;
begin
  if ARequestedWidth > 0 then
    Exit(ARequestedWidth);

  if not FAutoButtonWidth then
    Exit(FAutoButtonMinWidth);

  Canvas.Font.Assign(Font);
  LTextWidth := Canvas.TextWidth(ACaption) + 24;
  Result := LTextWidth;
  if Result < FAutoButtonMinWidth then
    Result := FAutoButtonMinWidth;
end;

function TDCFlexToolbar.GetContentHeight: Integer;
begin
  if FButtonHeight > 0 then
    Result := FButtonHeight
  else
    Result := Height - FPaddingTop - FPaddingBottom;

  if Result < 1 then
    Result := 1;
end;


procedure TDCFlexToolbar.LayoutControls;
var
  I: Integer;
  LLeft: Integer;
  LTop: Integer;
  LHeight: Integer;
  LControl: TControl;
  LWidth: Integer;
begin
  if csLoading in ComponentState then
    Exit;

  LLeft := FPaddingLeft;
  LTop := FPaddingTop;
  LHeight := GetContentHeight;

  for I := 0 to ControlCount - 1 do
  begin
    LControl := Controls[I];
    if not LControl.Visible then
      Continue;

    if LControl.Align <> alNone then
      Continue;

    LWidth := LControl.Width;
    if LWidth < 1 then
      LWidth := 1;

    if (LControl is TPanel) and (LControl.Tag = 1) then
    begin
      LControl.SetBounds(LLeft + (LWidth div 2), LTop + 4, 1, LHeight - 8);
      TPanel(LControl).Color := FSeparatorColor;
      Inc(LLeft, LWidth + FButtonSpacing);
      Continue;
    end;

    LControl.SetBounds(LLeft, LTop, LWidth, LHeight);
    Inc(LLeft, LWidth + FButtonSpacing);
  end;
end;

procedure TDCFlexToolbar.Loaded;
begin
  inherited Loaded;
  LayoutControls;
end;

procedure TDCFlexToolbar.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation in [opInsert, opRemove] then
    LayoutControls;
end;

procedure TDCFlexToolbar.Paint;
var
  R: TRect;
begin
  inherited;
  R := ClientRect;
  Canvas.Brush.Color := FBackColor;
  Canvas.FillRect(R);

  Canvas.Pen.Color := FBorderColor;
  Canvas.MoveTo(R.Left, R.Bottom - 1);
  Canvas.LineTo(R.Right, R.Bottom - 1);
end;

procedure TDCFlexToolbar.Resize;
begin
  inherited Resize;
  LayoutControls;
  Invalidate;
end;

procedure TDCFlexToolbar.SetBackColor(const Value: TColor);
begin
  if FBackColor <> Value then
  begin
    FBackColor := Value;
    LayoutControls;
    Invalidate;
  end;
end;

procedure TDCFlexToolbar.SetBorderColor(const Value: TColor);
begin
  if FBorderColor <> Value then
  begin
    FBorderColor := Value;
    Invalidate;
  end;
end;

procedure TDCFlexToolbar.SetButtonSpacing(const Value: Integer);
var
  LValue: Integer;
begin
  LValue := Value;
  if LValue < 0 then
    LValue := 0;

  if FButtonSpacing <> LValue then
  begin
    FButtonSpacing := LValue;
    LayoutControls;
    Invalidate;
  end;
end;


procedure TDCFlexToolbar.SetAutoButtonMinWidth(const Value: Integer);
var
  LValue: Integer;
begin
  LValue := Value;
  if LValue < 1 then
    LValue := 1;

  if FAutoButtonMinWidth <> LValue then
  begin
    FAutoButtonMinWidth := LValue;
    LayoutControls;
    Invalidate;
  end;
end;

procedure TDCFlexToolbar.SetAutoButtonWidth(const Value: Boolean);
begin
  if FAutoButtonWidth <> Value then
  begin
    FAutoButtonWidth := Value;
    LayoutControls;
    Invalidate;
  end;
end;

procedure TDCFlexToolbar.SetButtonHeight(const Value: Integer);
var
  LValue: Integer;
begin
  LValue := Value;
  if LValue < 0 then
    LValue := 0;

  if FButtonHeight <> LValue then
  begin
    FButtonHeight := LValue;
    LayoutControls;
    Invalidate;
  end;
end;

procedure TDCFlexToolbar.SetSeparatorColor(const Value: TColor);
begin
  if FSeparatorColor <> Value then
  begin
    FSeparatorColor := Value;
    LayoutControls;
    Invalidate;
  end;
end;

procedure TDCFlexToolbar.SetSeparatorWidth(const Value: Integer);
var
  LValue: Integer;
begin
  LValue := Value;
  if LValue < 1 then
    LValue := 1;

  if FSeparatorWidth <> LValue then
  begin
    FSeparatorWidth := LValue;
    LayoutControls;
    Invalidate;
  end;
end;

procedure TDCFlexToolbar.SetPaddingBottom(const Value: Integer);
var
  LValue: Integer;
begin
  LValue := Value;
  if LValue < 0 then
    LValue := 0;

  if FPaddingBottom <> LValue then
  begin
    FPaddingBottom := LValue;
    LayoutControls;
    Invalidate;
  end;
end;

procedure TDCFlexToolbar.SetPaddingLeft(const Value: Integer);
var
  LValue: Integer;
begin
  LValue := Value;
  if LValue < 0 then
    LValue := 0;

  if FPaddingLeft <> LValue then
  begin
    FPaddingLeft := LValue;
    LayoutControls;
    Invalidate;
  end;
end;

procedure TDCFlexToolbar.SetPaddingRight(const Value: Integer);
var
  LValue: Integer;
begin
  LValue := Value;
  if LValue < 0 then
    LValue := 0;

  if FPaddingRight <> LValue then
  begin
    FPaddingRight := LValue;
    LayoutControls;
    Invalidate;
  end;
end;

procedure TDCFlexToolbar.SetPaddingTop(const Value: Integer);
var
  LValue: Integer;
begin
  LValue := Value;
  if LValue < 0 then
    LValue := 0;

  if FPaddingTop <> LValue then
  begin
    FPaddingTop := LValue;
    LayoutControls;
    Invalidate;
  end;
end;


end.
