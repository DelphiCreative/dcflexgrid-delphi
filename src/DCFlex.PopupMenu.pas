unit DCFlex.PopupMenu;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.Classes,
  System.SysUtils,
  System.Types,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Graphics,
  DCFlex.Language,
  DCFlex.Theme;

type
  TDCFlexPopupMenu = class;
  TDCFlexPopupMenuItems = class;

  TDCFlexPopupMenuItem = class(TCollectionItem)
  private
    FCaption: string;
    FChecked: Boolean;
    FEnabled: Boolean;
    FHint: string;
    FItems: TDCFlexPopupMenuItems;
    FLanguageKey: string;
    FSeparator: Boolean;
    FTag: Integer;
    FVisible: Boolean;
    FOnClick: TNotifyEvent;
    procedure SetCaption(const Value: string);
    procedure SetChecked(const Value: Boolean);
    procedure SetEnabled(const Value: Boolean);
    procedure SetHint(const Value: string);
    procedure SetItems(const Value: TDCFlexPopupMenuItems);
    procedure SetLanguageKey(const Value: string);
    procedure SetSeparator(const Value: Boolean);
    procedure SetVisible(const Value: Boolean);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function HasItems: Boolean;
  published
    property Caption: string read FCaption write SetCaption;
    property Checked: Boolean read FChecked write SetChecked default False;
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property Hint: string read FHint write SetHint;
    property Items: TDCFlexPopupMenuItems read FItems write SetItems;
    property LanguageKey: string read FLanguageKey write SetLanguageKey;
    property Separator: Boolean read FSeparator write SetSeparator default False;
    property Tag: Integer read FTag write FTag default 0;
    property Visible: Boolean read FVisible write SetVisible default True;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
  end;

  TDCFlexPopupMenuItems = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TDCFlexPopupMenuItem;
    procedure SetItem(Index: Integer; const Value: TDCFlexPopupMenuItem);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDCFlexPopupMenuItem;
    property Items[Index: Integer]: TDCFlexPopupMenuItem read GetItem
      write SetItem; default;
  end;

  TDCFlexPopupMenuClickEvent = procedure(Sender: TObject;
    Item: TDCFlexPopupMenuItem) of object;

  TDCFlexPopupMenu = class(TComponent)
  private
    FAttachedControl: TControl;
    FBackColor: TColor;
    FBorderColor: TColor;
    FCheckColor: TColor;
    FDisabledTextColor: TColor;
    FFont: TFont;
    FHoverColor: TColor;
    FItemHeight: Integer;
    FItems: TDCFlexPopupMenuItems;
    FLanguageSource: TDCFlexLanguage;
    FSeparatorColor: TColor;
    FTextColor: TColor;
    FThemeMode: TDCFlexThemeMode;
    FOldAttachedWndProc: TWndMethod;
    FOnItemClick: TDCFlexPopupMenuClickEvent;
    procedure AttachedWndProc(var Message: TMessage);
    procedure HookAttachedControl;
    procedure FontChanged(Sender: TObject);
    procedure ItemsChanged;
    procedure LanguageSourceChange(Sender: TObject);
    procedure SetAttachedControl(const Value: TControl);
    procedure SetBackColor(const Value: TColor);
    procedure SetBorderColor(const Value: TColor);
    procedure SetCheckColor(const Value: TColor);
    procedure SetDisabledTextColor(const Value: TColor);
    procedure SetFont(const Value: TFont);
    procedure SetHoverColor(const Value: TColor);
    procedure SetItemHeight(const Value: Integer);
    procedure SetItems(const Value: TDCFlexPopupMenuItems);
    procedure SetLanguageSource(const Value: TDCFlexLanguage);
    procedure SetSeparatorColor(const Value: TColor);
    procedure SetTextColor(const Value: TColor);
    procedure SetThemeMode(const Value: TDCFlexThemeMode);
    procedure UnhookAttachedControl;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function ItemCaption(AItem: TDCFlexPopupMenuItem): string; virtual;
    procedure DoItemClick(AItem: TDCFlexPopupMenuItem); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Popup(X, Y: Integer); overload;
    procedure Popup(AControl: TControl; X, Y: Integer); overload;
    procedure Close;
    procedure ApplyThemePalette(const APalette: TDCFlexThemePalette);
  published
    property AttachedControl: TControl read FAttachedControl
      write SetAttachedControl;
    property BackColor: TColor read FBackColor write SetBackColor default clWhite;
    property BorderColor: TColor read FBorderColor write SetBorderColor default $00D8DEE8;
    property CheckColor: TColor read FCheckColor write SetCheckColor default $00F86F62;
    property DisabledTextColor: TColor read FDisabledTextColor
      write SetDisabledTextColor default clGrayText;
    property Font: TFont read FFont write SetFont;
    property HoverColor: TColor read FHoverColor write SetHoverColor default $00F3F6FA;
    property ItemHeight: Integer read FItemHeight write SetItemHeight default 30;
    property Items: TDCFlexPopupMenuItems read FItems write SetItems;
    property LanguageSource: TDCFlexLanguage read FLanguageSource
      write SetLanguageSource;
    property SeparatorColor: TColor read FSeparatorColor write SetSeparatorColor default $00E7EAF0;
    property TextColor: TColor read FTextColor write SetTextColor default clBlack;
    property ThemeMode: TDCFlexThemeMode read FThemeMode write SetThemeMode default dtmLight;
    property OnItemClick: TDCFlexPopupMenuClickEvent read FOnItemClick
      write FOnItemClick;
  end;

implementation

type
  TDCFlexPopupMenuWindow = class(TCustomForm)
  private
    FHoverIndex: Integer;
    FItems: TDCFlexPopupMenuItems;
    FChildWindow: TDCFlexPopupMenuWindow;
    FMenu: TDCFlexPopupMenu;
    FParentWindow: TDCFlexPopupMenuWindow;
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
    procedure ExecuteItem(AItem: TDCFlexPopupMenuItem);
    function ItemRect(AIndex: Integer): TRect;
    function ItemAt(Y: Integer): Integer;
    procedure ShowSubMenu(AIndex: Integer);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Deactivate; override;
    procedure DoClose(var Action: TCloseAction); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
  public
    constructor CreatePopup(AOwner: TComponent; AMenu: TDCFlexPopupMenu;
      AItems: TDCFlexPopupMenuItems = nil;
      AParentWindow: TDCFlexPopupMenuWindow = nil);
    procedure PopupAt(X, Y: Integer);
  end;

var
  ActivePopupWindow: TDCFlexPopupMenuWindow = nil;

const
  DC_POPUP_CHECK_GLYPH = #$2713;
  DC_POPUP_SUBMENU_GLYPH = #$203A;

{ TDCFlexPopupMenuItem }

procedure TDCFlexPopupMenuItem.Assign(Source: TPersistent);
begin
  if Source is TDCFlexPopupMenuItem then
  begin
    FCaption := TDCFlexPopupMenuItem(Source).Caption;
    FChecked := TDCFlexPopupMenuItem(Source).Checked;
    FEnabled := TDCFlexPopupMenuItem(Source).Enabled;
    FHint := TDCFlexPopupMenuItem(Source).Hint;
    FLanguageKey := TDCFlexPopupMenuItem(Source).LanguageKey;
    FSeparator := TDCFlexPopupMenuItem(Source).Separator;
    FTag := TDCFlexPopupMenuItem(Source).Tag;
    FVisible := TDCFlexPopupMenuItem(Source).Visible;
    FOnClick := TDCFlexPopupMenuItem(Source).OnClick;
    FItems.Assign(TDCFlexPopupMenuItem(Source).Items);
    Changed(False);
  end
  else
    inherited Assign(Source);
end;

constructor TDCFlexPopupMenuItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FEnabled := True;
  FVisible := True;
  FItems := TDCFlexPopupMenuItems.Create(Self);
end;

destructor TDCFlexPopupMenuItem.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

function TDCFlexPopupMenuItem.GetDisplayName: string;
begin
  if FSeparator then
    Result := '-'
  else if FCaption <> '' then
    Result := FCaption
  else if FLanguageKey <> '' then
    Result := FLanguageKey
  else
    Result := inherited GetDisplayName;
end;

function TDCFlexPopupMenuItem.HasItems: Boolean;
begin
  Result := Assigned(FItems) and (FItems.Count > 0);
end;

procedure TDCFlexPopupMenuItem.SetCaption(const Value: string);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    Changed(False);
  end;
end;

procedure TDCFlexPopupMenuItem.SetChecked(const Value: Boolean);
begin
  if FChecked <> Value then
  begin
    FChecked := Value;
    Changed(False);
  end;
end;

procedure TDCFlexPopupMenuItem.SetEnabled(const Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    Changed(False);
  end;
end;

procedure TDCFlexPopupMenuItem.SetHint(const Value: string);
begin
  if FHint <> Value then
  begin
    FHint := Value;
    Changed(False);
  end;
end;

procedure TDCFlexPopupMenuItem.SetItems(const Value: TDCFlexPopupMenuItems);
begin
  FItems.Assign(Value);
end;

procedure TDCFlexPopupMenuItem.SetLanguageKey(const Value: string);
begin
  if FLanguageKey <> Value then
  begin
    FLanguageKey := Value;
    Changed(False);
  end;
end;

procedure TDCFlexPopupMenuItem.SetSeparator(const Value: Boolean);
begin
  if FSeparator <> Value then
  begin
    FSeparator := Value;
    Changed(False);
  end;
end;

procedure TDCFlexPopupMenuItem.SetVisible(const Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    Changed(False);
  end;
end;

{ TDCFlexPopupMenuItems }

function TDCFlexPopupMenuItems.Add: TDCFlexPopupMenuItem;
begin
  Result := TDCFlexPopupMenuItem(inherited Add);
end;

constructor TDCFlexPopupMenuItems.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, TDCFlexPopupMenuItem);
end;

function TDCFlexPopupMenuItems.GetItem(Index: Integer): TDCFlexPopupMenuItem;
begin
  Result := TDCFlexPopupMenuItem(inherited GetItem(Index));
end;

procedure TDCFlexPopupMenuItems.SetItem(Index: Integer;
  const Value: TDCFlexPopupMenuItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TDCFlexPopupMenuItems.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
  if GetOwner is TDCFlexPopupMenu then
    TDCFlexPopupMenu(GetOwner).ItemsChanged;
  if GetOwner is TDCFlexPopupMenuItem then
    TDCFlexPopupMenuItem(GetOwner).Changed(False);
end;

{ TDCFlexPopupMenu }

procedure TDCFlexPopupMenu.AttachedWndProc(var Message: TMessage);
var
  LPoint: TPoint;
begin
  if Message.Msg = WM_CONTEXTMENU then
  begin
    if not Assigned(FAttachedControl) then
      Exit;

    if Message.LParam = -1 then
    begin
      LPoint := Point(FAttachedControl.Width div 2, FAttachedControl.Height div 2);
      LPoint := FAttachedControl.ClientToScreen(LPoint);
    end
    else
      LPoint := SmallPointToPoint(TSmallPoint(Message.LParam));

    Popup(LPoint.X, LPoint.Y);
    Message.Result := 1;
    Exit;
  end;

  if Assigned(FOldAttachedWndProc) then
    FOldAttachedWndProc(Message);
end;

procedure TDCFlexPopupMenu.Close;
begin
  if Assigned(ActivePopupWindow) then
    ActivePopupWindow.Close;
end;

constructor TDCFlexPopupMenu.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBackColor := clWhite;
  FBorderColor := $00D8DEE8;
  FCheckColor := $00F86F62;
  FDisabledTextColor := clGrayText;
  FHoverColor := $00F3F6FA;
  FItemHeight := 30;
  FItems := TDCFlexPopupMenuItems.Create(Self);
  FSeparatorColor := $00E7EAF0;
  FTextColor := clBlack;
  FThemeMode := dtmLight;
  FFont := TFont.Create;
  FFont.Name := 'Segoe UI';
  FFont.Size := 9;
  FFont.OnChange := FontChanged;
end;

procedure TDCFlexPopupMenu.ApplyThemePalette(
  const APalette: TDCFlexThemePalette);
begin
  FThemeMode := dtmCustom;
  FBackColor := APalette.PopupBack;
  FBorderColor := APalette.Border;
  FCheckColor := APalette.Accent;
  FDisabledTextColor := APalette.DisabledText;
  FHoverColor := APalette.Hover;
  FSeparatorColor := APalette.Border;
  FTextColor := APalette.Text;
  FFont.Color := APalette.Text;
  ItemsChanged;
end;

destructor TDCFlexPopupMenu.Destroy;
begin
  UnhookAttachedControl;
  if Assigned(FLanguageSource) then
    FLanguageSource.RemoveChangeListener(LanguageSourceChange);
  if Assigned(ActivePopupWindow) and (ActivePopupWindow.FMenu = Self) then
    ActivePopupWindow.Close;
  FItems.Free;
  FFont.Free;
  inherited Destroy;
end;

procedure TDCFlexPopupMenu.HookAttachedControl;
begin
  if Assigned(FAttachedControl) and not Assigned(FOldAttachedWndProc) then
  begin
    FAttachedControl.FreeNotification(Self);
    FOldAttachedWndProc := FAttachedControl.WindowProc;
    FAttachedControl.WindowProc := AttachedWndProc;
  end;
end;

procedure TDCFlexPopupMenu.DoItemClick(AItem: TDCFlexPopupMenuItem);
begin
  if Assigned(AItem) and Assigned(AItem.OnClick) then
    AItem.OnClick(AItem);
  if Assigned(FOnItemClick) then
    FOnItemClick(Self, AItem);
end;

procedure TDCFlexPopupMenu.FontChanged(Sender: TObject);
begin
  ItemsChanged;
end;

function TDCFlexPopupMenu.ItemCaption(AItem: TDCFlexPopupMenuItem): string;
begin
  if Assigned(AItem) and Assigned(FLanguageSource) and
    (AItem.LanguageKey <> '') then
    Result := FLanguageSource.Text(dlsCommon, AItem.LanguageKey, AItem.Caption)
  else if Assigned(AItem) then
    Result := AItem.Caption
  else
    Result := '';
end;

procedure TDCFlexPopupMenu.ItemsChanged;
begin
  if Assigned(ActivePopupWindow) and (ActivePopupWindow.FMenu = Self) then
    ActivePopupWindow.Invalidate;
end;

procedure TDCFlexPopupMenu.LanguageSourceChange(Sender: TObject);
begin
  ItemsChanged;
end;

procedure TDCFlexPopupMenu.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FAttachedControl) then
  begin
    FAttachedControl := nil;
    FOldAttachedWndProc := nil;
  end;
  if (Operation = opRemove) and (AComponent = FLanguageSource) then
    FLanguageSource := nil;
end;

procedure TDCFlexPopupMenu.Popup(AControl: TControl; X, Y: Integer);
var
  LPoint: TPoint;
begin
  if Assigned(AControl) then
  begin
    LPoint := AControl.ClientToScreen(Point(X, Y));
    Popup(LPoint.X, LPoint.Y);
  end
  else
    Popup(X, Y);
end;

procedure TDCFlexPopupMenu.Popup(X, Y: Integer);
var
  LWindow: TDCFlexPopupMenuWindow;
begin
  Close;
  LWindow := TDCFlexPopupMenuWindow.CreatePopup(Application, Self, FItems, nil);
  ActivePopupWindow := LWindow;
  LWindow.PopupAt(X, Y);
end;

procedure TDCFlexPopupMenu.SetBackColor(const Value: TColor);
begin
  if FBackColor <> Value then
  begin
    FBackColor := Value;
    ItemsChanged;
  end;
end;

procedure TDCFlexPopupMenu.SetAttachedControl(const Value: TControl);
begin
  if FAttachedControl = Value then
    Exit;

  UnhookAttachedControl;
  FAttachedControl := Value;
  HookAttachedControl;
end;

procedure TDCFlexPopupMenu.SetBorderColor(const Value: TColor);
begin
  if FBorderColor <> Value then
  begin
    FBorderColor := Value;
    ItemsChanged;
  end;
end;

procedure TDCFlexPopupMenu.SetCheckColor(const Value: TColor);
begin
  if FCheckColor <> Value then
  begin
    FCheckColor := Value;
    ItemsChanged;
  end;
end;

procedure TDCFlexPopupMenu.SetDisabledTextColor(const Value: TColor);
begin
  if FDisabledTextColor <> Value then
  begin
    FDisabledTextColor := Value;
    ItemsChanged;
  end;
end;

procedure TDCFlexPopupMenu.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TDCFlexPopupMenu.SetHoverColor(const Value: TColor);
begin
  if FHoverColor <> Value then
  begin
    FHoverColor := Value;
    ItemsChanged;
  end;
end;

procedure TDCFlexPopupMenu.SetItemHeight(const Value: Integer);
var
  LValue: Integer;
begin
  LValue := Value;
  if LValue < 20 then
    LValue := 20;
  if FItemHeight <> LValue then
  begin
    FItemHeight := LValue;
    ItemsChanged;
  end;
end;

procedure TDCFlexPopupMenu.SetItems(const Value: TDCFlexPopupMenuItems);
begin
  FItems.Assign(Value);
end;

procedure TDCFlexPopupMenu.SetLanguageSource(const Value: TDCFlexLanguage);
begin
  if FLanguageSource = Value then
    Exit;

  if Assigned(FLanguageSource) then
    FLanguageSource.RemoveChangeListener(LanguageSourceChange);
  FLanguageSource := Value;
  if Assigned(FLanguageSource) then
  begin
    FLanguageSource.FreeNotification(Self);
    FLanguageSource.AddChangeListener(LanguageSourceChange);
  end;
  ItemsChanged;
end;

procedure TDCFlexPopupMenu.SetSeparatorColor(const Value: TColor);
begin
  if FSeparatorColor <> Value then
  begin
    FSeparatorColor := Value;
    ItemsChanged;
  end;
end;

procedure TDCFlexPopupMenu.SetTextColor(const Value: TColor);
begin
  if FTextColor <> Value then
  begin
    FTextColor := Value;
    ItemsChanged;
  end;
end;

procedure TDCFlexPopupMenu.SetThemeMode(const Value: TDCFlexThemeMode);
var
  LPalette: TDCFlexThemePalette;
begin
  if FThemeMode = Value then
    Exit;

  FThemeMode := Value;
  if FThemeMode = dtmCustom then
    Exit;

  LPalette := DCFlexPaletteForMode(FThemeMode);
  FBackColor := LPalette.PopupBack;
  FBorderColor := LPalette.Border;
  FCheckColor := LPalette.Accent;
  FDisabledTextColor := LPalette.DisabledText;
  FHoverColor := LPalette.Hover;
  FSeparatorColor := LPalette.Border;
  FTextColor := LPalette.Text;
  FFont.Color := LPalette.Text;
  ItemsChanged;
end;

procedure TDCFlexPopupMenu.UnhookAttachedControl;
begin
  if Assigned(FAttachedControl) and Assigned(FOldAttachedWndProc) then
    FAttachedControl.WindowProc := FOldAttachedWndProc;
  FOldAttachedWndProc := nil;
end;

{ TDCFlexPopupMenuWindow }

procedure TDCFlexPopupMenuWindow.CMShowingChanged(var Message: TMessage);
begin
  inherited;
  if not Showing and (ActivePopupWindow = Self) then
    ActivePopupWindow := nil;
end;

constructor TDCFlexPopupMenuWindow.CreatePopup(AOwner: TComponent;
  AMenu: TDCFlexPopupMenu; AItems: TDCFlexPopupMenuItems;
  AParentWindow: TDCFlexPopupMenuWindow);
begin
  inherited CreateNew(AOwner);
  BorderStyle := bsNone;
  Color := clWhite;
  FHoverIndex := -1;
  FMenu := AMenu;
  FItems := AItems;
  if not Assigned(FItems) and Assigned(FMenu) then
    FItems := FMenu.Items;
  FParentWindow := AParentWindow;
  KeyPreview := True;
  Position := poDesigned;
end;

procedure TDCFlexPopupMenuWindow.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or WS_POPUP;
  Params.ExStyle := Params.ExStyle or WS_EX_TOOLWINDOW;
end;

procedure TDCFlexPopupMenuWindow.Deactivate;
begin
  if Assigned(FChildWindow) and FChildWindow.Visible then
    Exit;
  inherited Deactivate;
  Close;
end;

procedure TDCFlexPopupMenuWindow.DoClose(var Action: TCloseAction);
begin
  if Assigned(FChildWindow) then
    FChildWindow.Close;
  inherited DoClose(Action);
  if ActivePopupWindow = Self then
    ActivePopupWindow := nil;
  if Assigned(FParentWindow) and (FParentWindow.FChildWindow = Self) then
    FParentWindow.FChildWindow := nil;
  Action := caFree;
end;

procedure TDCFlexPopupMenuWindow.ExecuteItem(AItem: TDCFlexPopupMenuItem);
var
  LMenu: TDCFlexPopupMenu;
  LRoot: TDCFlexPopupMenuWindow;
begin
  if not Assigned(AItem) or not Assigned(FMenu) then
    Exit;
  if AItem.HasItems then
    Exit;

  LMenu := FMenu;
  LRoot := Self;
  while Assigned(LRoot.FParentWindow) do
    LRoot := LRoot.FParentWindow;

  if Assigned(LRoot) then
    LRoot.Hide;
  Hide;
  LMenu.DoItemClick(AItem);
  if Assigned(LRoot) and (ActivePopupWindow = LRoot) then
    LRoot.Close;
end;

function TDCFlexPopupMenuWindow.ItemAt(Y: Integer): Integer;
var
  I: Integer;
  LTop: Integer;
  LItem: TDCFlexPopupMenuItem;
begin
  Result := -1;
  if not Assigned(FItems) then
    Exit;

  LTop := 6;
  for I := 0 to FItems.Count - 1 do
  begin
    LItem := FItems[I];
    if not LItem.Visible then
      Continue;
    if LItem.Separator then
    begin
      Inc(LTop, 8);
      Continue;
    end;
    if (Y >= LTop) and (Y < LTop + FMenu.ItemHeight) then
      Exit(I);
    Inc(LTop, FMenu.ItemHeight);
  end;
end;

function TDCFlexPopupMenuWindow.ItemRect(AIndex: Integer): TRect;
var
  I: Integer;
  LTop: Integer;
  LItem: TDCFlexPopupMenuItem;
begin
  Result := Rect(0, 0, 0, 0);
  if not Assigned(FItems) then
    Exit;

  LTop := 6;
  for I := 0 to FItems.Count - 1 do
  begin
    LItem := FItems[I];
    if not LItem.Visible then
      Continue;
    if LItem.Separator then
    begin
      Inc(LTop, 8);
      Continue;
    end;
    if I = AIndex then
      Exit(Rect(6, LTop, ClientWidth - 6, LTop + FMenu.ItemHeight));
    Inc(LTop, FMenu.ItemHeight);
  end;
end;

procedure TDCFlexPopupMenuWindow.KeyDown(var Key: Word; Shift: TShiftState);
var
  I: Integer;
  LStart: Integer;
begin
  inherited KeyDown(Key, Shift);
  if not Assigned(FMenu) or not Assigned(FItems) then
    Exit;

  if Key = VK_ESCAPE then
  begin
    Close;
    Key := 0;
    Exit;
  end;

  if Key = VK_RETURN then
  begin
    if (FHoverIndex >= 0) and (FHoverIndex < FItems.Count) and
      FItems[FHoverIndex].Enabled and
      not FItems[FHoverIndex].Separator then
    begin
      if FItems[FHoverIndex].HasItems then
        ShowSubMenu(FHoverIndex)
      else
        ExecuteItem(FItems[FHoverIndex]);
    end;
    Key := 0;
    Exit;
  end;

  if Key = VK_RIGHT then
  begin
    if (FHoverIndex >= 0) and (FHoverIndex < FItems.Count) and
      FItems[FHoverIndex].HasItems then
      ShowSubMenu(FHoverIndex);
    Key := 0;
    Exit;
  end;

  if (Key <> VK_UP) and (Key <> VK_DOWN) then
    Exit;

  LStart := FHoverIndex;
  if LStart < 0 then
  begin
    if Key = VK_DOWN then
      LStart := -1
    else
      LStart := FItems.Count;
  end;

  I := LStart;
  repeat
    if Key = VK_DOWN then
      Inc(I)
    else
      Dec(I);
    if I < 0 then
      I := FItems.Count - 1;
    if I >= FItems.Count then
      I := 0;
    if FItems[I].Visible and FItems[I].Enabled and
      not FItems[I].Separator then
    begin
      FHoverIndex := I;
      Invalidate;
      Break;
    end;
  until I = LStart;

  Key := 0;
end;

procedure TDCFlexPopupMenuWindow.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  LIndex: Integer;
  LItem: TDCFlexPopupMenuItem;
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button <> mbLeft then
    Exit;

  LIndex := ItemAt(Y);
  if (LIndex < 0) or not Assigned(FMenu) or not Assigned(FItems) then
    Exit;

  LItem := FItems[LIndex];
  if LItem.Enabled and not LItem.Separator and LItem.HasItems then
    ShowSubMenu(LIndex)
  else if LItem.Enabled and not LItem.Separator then
    ExecuteItem(LItem);
end;

procedure TDCFlexPopupMenuWindow.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  LIndex: Integer;
begin
  inherited MouseMove(Shift, X, Y);
  LIndex := ItemAt(Y);
  if FHoverIndex <> LIndex then
  begin
    FHoverIndex := LIndex;
    if (FHoverIndex >= 0) and Assigned(FItems) and
      (FHoverIndex < FItems.Count) and FItems[FHoverIndex].HasItems then
      ShowSubMenu(FHoverIndex)
    else if Assigned(FChildWindow) then
      FChildWindow.Close;
    Invalidate;
  end;
end;

procedure TDCFlexPopupMenuWindow.ShowSubMenu(AIndex: Integer);
var
  LItem: TDCFlexPopupMenuItem;
  LRect: TRect;
  LPoint: TPoint;
begin
  if not Assigned(FMenu) or not Assigned(FItems) then
    Exit;
  if (AIndex < 0) or (AIndex >= FItems.Count) then
    Exit;

  LItem := FItems[AIndex];
  if not LItem.HasItems then
    Exit;

  if Assigned(FChildWindow) then
    FChildWindow.Close;

  LRect := ItemRect(AIndex);
  LPoint := ClientToScreen(Point(LRect.Right - 2, LRect.Top));
  FChildWindow := TDCFlexPopupMenuWindow.CreatePopup(Application, FMenu,
    LItem.Items, Self);
  FChildWindow.PopupAt(LPoint.X, LPoint.Y);
end;

procedure TDCFlexPopupMenuWindow.Paint;
var
  I: Integer;
  LCaption: string;
  LItem: TDCFlexPopupMenuItem;
  LRect: TRect;
  LTextRect: TRect;
  LTop: Integer;
begin
  inherited;
  if not Assigned(FMenu) or not Assigned(FItems) then
    Exit;

  Canvas.Brush.Color := FMenu.BackColor;
  Canvas.FillRect(ClientRect);
  Canvas.Font.Assign(FMenu.Font);

  LTop := 6;
  for I := 0 to FItems.Count - 1 do
  begin
    LItem := FItems[I];
    if not LItem.Visible then
      Continue;

    if LItem.Separator then
    begin
      Canvas.Pen.Color := FMenu.SeparatorColor;
      Canvas.MoveTo(12, LTop + 3);
      Canvas.LineTo(ClientWidth - 12, LTop + 3);
      Inc(LTop, 8);
      Continue;
    end;

    LRect := Rect(6, LTop, ClientWidth - 6, LTop + FMenu.ItemHeight);
    if I = FHoverIndex then
    begin
      Canvas.Brush.Color := FMenu.HoverColor;
      Canvas.FillRect(LRect);
    end;

    if LItem.Checked then
    begin
      Canvas.Brush.Style := bsClear;
      Canvas.Font.Name := 'Segoe UI Symbol';
      Canvas.Font.Size := FMenu.Font.Size + 1;
      Canvas.Font.Style := [];
      Canvas.Font.Color := FMenu.CheckColor;
      LTextRect := Rect(LRect.Left + 8, LRect.Top, LRect.Left + 24,
        LRect.Bottom);
      DrawText(Canvas.Handle, PChar(DC_POPUP_CHECK_GLYPH),
        Length(DC_POPUP_CHECK_GLYPH), LTextRect,
        DT_SINGLELINE or DT_CENTER or DT_VCENTER);
      Canvas.Font.Assign(FMenu.Font);
      Canvas.Brush.Style := bsSolid;
    end;

    LCaption := FMenu.ItemCaption(LItem);
    if LItem.HasItems then
      LTextRect := Rect(LRect.Left + 30, LRect.Top, LRect.Right - 30,
        LRect.Bottom)
    else
      LTextRect := Rect(LRect.Left + 30, LRect.Top, LRect.Right - 12,
        LRect.Bottom);
    Canvas.Brush.Style := bsClear;
    if LItem.Enabled then
      Canvas.Font.Color := FMenu.TextColor
    else
      Canvas.Font.Color := FMenu.DisabledTextColor;
    DrawText(Canvas.Handle, PChar(LCaption), Length(LCaption), LTextRect,
      DT_SINGLELINE or DT_VCENTER or DT_END_ELLIPSIS);

    if LItem.HasItems then
    begin
      Canvas.Font.Name := 'Segoe UI Symbol';
      Canvas.Font.Size := FMenu.Font.Size;
      Canvas.Font.Style := [];
      if LItem.Enabled then
        Canvas.Font.Color := FMenu.TextColor
      else
        Canvas.Font.Color := FMenu.DisabledTextColor;
      LTextRect := Rect(LRect.Right - 22, LRect.Top, LRect.Right - 6,
        LRect.Bottom);
      DrawText(Canvas.Handle, PChar(DC_POPUP_SUBMENU_GLYPH),
        Length(DC_POPUP_SUBMENU_GLYPH), LTextRect,
        DT_SINGLELINE or DT_CENTER or DT_VCENTER);
      Canvas.Font.Assign(FMenu.Font);
    end;

    Canvas.Brush.Style := bsSolid;
    Inc(LTop, FMenu.ItemHeight);
  end;

  Canvas.Pen.Color := FMenu.BorderColor;
  Canvas.Brush.Style := bsClear;
  Canvas.Rectangle(ClientRect);
  Canvas.Brush.Style := bsSolid;
end;

procedure TDCFlexPopupMenuWindow.PopupAt(X, Y: Integer);
var
  I: Integer;
  LHeight: Integer;
  LItem: TDCFlexPopupMenuItem;
  LMonitor: TMonitor;
  LTextWidth: Integer;
  LWidth: Integer;
begin
  if not Assigned(FMenu) or not Assigned(FItems) then
    Exit;

  Canvas.Font.Assign(FMenu.Font);
  LWidth := 190;
  LHeight := 12;
  for I := 0 to FItems.Count - 1 do
  begin
    LItem := FItems[I];
    if not LItem.Visible then
      Continue;
    if LItem.Separator then
    begin
      Inc(LHeight, 8);
      Continue;
    end;

    Inc(LHeight, FMenu.ItemHeight);
    if LItem.HasItems then
      LTextWidth := Canvas.TextWidth(FMenu.ItemCaption(LItem)) + 96
    else
      LTextWidth := Canvas.TextWidth(FMenu.ItemCaption(LItem)) + 76;
    if LWidth < LTextWidth then
      LWidth := LTextWidth;
  end;

  if LWidth > 420 then
    LWidth := 420;
  if LHeight < 20 then
    LHeight := 20;

  LMonitor := Screen.MonitorFromPoint(Point(X, Y));
  if Assigned(LMonitor) then
  begin
    if X + LWidth > LMonitor.WorkareaRect.Right then
      X := LMonitor.WorkareaRect.Right - LWidth - 4;
    if Y + LHeight > LMonitor.WorkareaRect.Bottom then
      Y := LMonitor.WorkareaRect.Bottom - LHeight - 4;
    if X < LMonitor.WorkareaRect.Left then
      X := LMonitor.WorkareaRect.Left;
    if Y < LMonitor.WorkareaRect.Top then
      Y := LMonitor.WorkareaRect.Top;
  end;

  SetBounds(X, Y, LWidth, LHeight);
  Show;
  SetFocus;
end;

end.
