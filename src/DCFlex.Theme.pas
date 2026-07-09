unit DCFlex.Theme;

interface

uses
  System.Classes,
  System.SysUtils,
  System.TypInfo,
  Winapi.Windows,
  Vcl.Controls,
  Vcl.Graphics;

type
  TDCFlexThemeMode = (dtmLight, dtmDark, dtmCustom);

  TDCFlexThemePalette = record
    Background: TColor;
    Surface: TColor;
    SurfaceAlt: TColor;
    Border: TColor;
    Text: TColor;
    MutedText: TColor;
    Accent: TColor;
    AccentText: TColor;
    Selection: TColor;
    SelectionText: TColor;
    Hover: TColor;
    Pressed: TColor;
    Disabled: TColor;
    DisabledText: TColor;
    Danger: TColor;
    Warning: TColor;
    Success: TColor;
    GridLine: TColor;
    InputBack: TColor;
    InputBorder: TColor;
    PopupBack: TColor;
    HeaderBack: TColor;
    ScrollTrack: TColor;
    ScrollThumb: TColor;
  end;

  TDCFlexThemeChangeEvent = procedure(Sender: TObject) of object;

  TDCFlexThemeSource = class(TComponent)
  private
    FMode: TDCFlexThemeMode;
    FPalette: TDCFlexThemePalette;
    FOnChange: TDCFlexThemeChangeEvent;
    procedure SetMode(const Value: TDCFlexThemeMode);
    procedure SetPalette(const Value: TDCFlexThemePalette);
  protected
    procedure Changed; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ApplyTo(AControl: TControl; ARecursive: Boolean = True);
    procedure ApplyLight;
    procedure ApplyDark;
    procedure AssignPalette(const AValue: TDCFlexThemePalette);
    property Palette: TDCFlexThemePalette read FPalette write SetPalette;
  published
    property Mode: TDCFlexThemeMode read FMode write SetMode default dtmLight;
    property OnChange: TDCFlexThemeChangeEvent read FOnChange write FOnChange;
  end;

function DCFlexLightPalette: TDCFlexThemePalette;
function DCFlexDarkPalette: TDCFlexThemePalette;
function DCFlexPaletteForMode(AMode: TDCFlexThemeMode): TDCFlexThemePalette;
function DCFlexIsDarkPalette(const APalette: TDCFlexThemePalette): Boolean;
procedure DCFlexApplyNativeDarkMode(AControl: TWinControl; ADark: Boolean);
procedure DCFlexApplyThemeToControl(AControl: TControl;
  const APalette: TDCFlexThemePalette; ARecursive: Boolean = False);
procedure DCFlexApplyThemeToFont(AFont: TFont;
  const APalette: TDCFlexThemePalette);

implementation

function DCFlexLightPalette: TDCFlexThemePalette;
begin
  Result.Background := $00FFFFFF;
  Result.Surface := $00F8FAFC;
  Result.SurfaceAlt := $00F1F5F9;
  Result.Border := $00D9E2EC;
  Result.Text := $00253445;
  Result.MutedText := $00647586;
  Result.Accent := $00E07818;
  Result.AccentText := $00FFFFFF;
  Result.Selection := $00E5F0FF;
  Result.SelectionText := $00253445;
  Result.Hover := $00EEF4FB;
  Result.Pressed := $00DDEBFA;
  Result.Disabled := $00EEF2F6;
  Result.DisabledText := $008394A7;
  Result.Danger := $005B4EDE;
  Result.Warning := $0018A5F0;
  Result.Success := $00489A3B;
  Result.GridLine := $00DFE6EF;
  Result.InputBack := $00FFFFFF;
  Result.InputBorder := $00CDD7E2;
  Result.PopupBack := $00FFFFFF;
  Result.HeaderBack := $00F3F6FA;
  Result.ScrollTrack := $00EEF2F6;
  Result.ScrollThumb := $00B8C4D2;
end;

function DCFlexDarkPalette: TDCFlexThemePalette;
begin
  Result.Background := $00271811;
  Result.Surface := $0037291F;
  Result.SurfaceAlt := $0042312B;
  Result.Border := $00514137;
  Result.Text := $00F4F7FB;
  Result.MutedText := $00A8B4C2;
  Result.Accent := $00EB6325;
  Result.AccentText := $00FFFFFF;
  Result.Selection := $006F4A1E;
  Result.SelectionText := $00FFFFFF;
  Result.Hover := $0048362F;
  Result.Pressed := $00513D37;
  Result.Disabled := $0037291F;
  Result.DisabledText := $007E8B99;
  Result.Danger := $006B6BFF;
  Result.Warning := $0020B8FF;
  Result.Success := $006BCB6F;
  Result.GridLine := $00473A31;
  Result.InputBack := $0030241F;
  Result.InputBorder := $00514137;
  Result.PopupBack := $0037291F;
  Result.HeaderBack := $0042312B;
  Result.ScrollTrack := $0030241F;
  Result.ScrollThumb := $007B6A5F;
end;

function DCFlexPaletteForMode(AMode: TDCFlexThemeMode): TDCFlexThemePalette;
begin
  if AMode = dtmDark then
    Result := DCFlexDarkPalette
  else
    Result := DCFlexLightPalette;
end;

function DCFlexIsDarkPalette(const APalette: TDCFlexThemePalette): Boolean;
begin
  Result := (GetRValue(ColorToRGB(APalette.Background)) +
    GetGValue(ColorToRGB(APalette.Background)) +
    GetBValue(ColorToRGB(APalette.Background))) < 384;
end;

procedure DCFlexApplyNativeDarkMode(AControl: TWinControl; ADark: Boolean);
type
  TDwmSetWindowAttributeFunc = function(hwnd: HWND; dwAttribute: DWORD;
    pvAttribute: Pointer; cbAttribute: DWORD): Longint; stdcall;
  TSetWindowThemeFunc = function(hwnd: HWND; pszSubAppName: PWideChar;
    pszSubIdList: PWideChar): Longint; stdcall;
const
  DWMWA_USE_IMMERSIVE_DARK_MODE_OLD = 19;
  DWMWA_USE_IMMERSIVE_DARK_MODE = 20;
var
  LDwm: HMODULE;
  LUxTheme: HMODULE;
  LDwmSetWindowAttribute: TDwmSetWindowAttributeFunc;
  LSetWindowTheme: TSetWindowThemeFunc;
  LEnabled: BOOL;
  LThemeName: WideString;
begin
  if (AControl = nil) or (not AControl.HandleAllocated) then
    Exit;

  LThemeName := 'Explorer';
  if ADark then
    LThemeName := 'DarkMode_Explorer';

  LUxTheme := LoadLibrary('uxtheme.dll');
  if LUxTheme <> 0 then
  try
    @LSetWindowTheme := Winapi.Windows.GetProcAddress(LUxTheme,
      PAnsiChar(AnsiString('SetWindowTheme')));
    if Assigned(LSetWindowTheme) then
      LSetWindowTheme(AControl.Handle, PWideChar(LThemeName), nil);
  finally
    FreeLibrary(LUxTheme);
  end;

  LDwm := LoadLibrary('dwmapi.dll');
  if LDwm <> 0 then
  try
    @LDwmSetWindowAttribute := Winapi.Windows.GetProcAddress(LDwm,
      PAnsiChar(AnsiString('DwmSetWindowAttribute')));
    if Assigned(LDwmSetWindowAttribute) then
    begin
      LEnabled := ADark;
      LDwmSetWindowAttribute(AControl.Handle, DWMWA_USE_IMMERSIVE_DARK_MODE,
        @LEnabled, SizeOf(LEnabled));
      LDwmSetWindowAttribute(AControl.Handle, DWMWA_USE_IMMERSIVE_DARK_MODE_OLD,
        @LEnabled, SizeOf(LEnabled));
    end;
  finally
    FreeLibrary(LDwm);
  end;

  SetWindowPos(AControl.Handle, 0, 0, 0, 0, 0,
    SWP_NOMOVE or SWP_NOSIZE or SWP_NOZORDER or SWP_NOACTIVATE or
    SWP_FRAMECHANGED);
  RedrawWindow(AControl.Handle, nil, 0,
    RDW_INVALIDATE or RDW_FRAME or RDW_UPDATENOW);
end;

procedure SetColorProperty(AComponent: TComponent; const AName: string;
  AValue: TColor);
var
  LPropInfo: PPropInfo;
begin
  if AComponent = nil then
    Exit;

  LPropInfo := GetPropInfo(AComponent.ClassInfo, AName);
  if (LPropInfo <> nil) and
    (LPropInfo^.PropType^.Kind in [tkInteger, tkEnumeration]) then
    SetOrdProp(AComponent, LPropInfo, AValue);
end;

procedure DCFlexApplyThemeToFont(AFont: TFont;
  const APalette: TDCFlexThemePalette);
begin
  if AFont = nil then
    Exit;

  AFont.Color := APalette.Text;
end;

procedure DCFlexApplyThemeToControl(AControl: TControl;
  const APalette: TDCFlexThemePalette; ARecursive: Boolean);
var
  I: Integer;
  LFont: TObject;
  LWinControl: TWinControl;
begin
  if AControl = nil then
    Exit;

  SetColorProperty(AControl, 'Color', APalette.Surface);

  if IsPublishedProp(AControl, 'Font') then
  begin
    LFont := GetObjectProp(AControl, 'Font');
    if LFont is TFont then
      DCFlexApplyThemeToFont(TFont(LFont), APalette);
  end;

  if ARecursive and (AControl is TWinControl) then
  begin
    LWinControl := TWinControl(AControl);
    for I := 0 to LWinControl.ControlCount - 1 do
      DCFlexApplyThemeToControl(LWinControl.Controls[I], APalette, True);
  end;

  AControl.Invalidate;
end;

constructor TDCFlexThemeSource.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMode := dtmLight;
  FPalette := DCFlexLightPalette;
end;

procedure TDCFlexThemeSource.ApplyDark;
begin
  Mode := dtmDark;
end;

procedure TDCFlexThemeSource.ApplyLight;
begin
  Mode := dtmLight;
end;

procedure TDCFlexThemeSource.ApplyTo(AControl: TControl;
  ARecursive: Boolean);
begin
  DCFlexApplyThemeToControl(AControl, FPalette, ARecursive);
end;

procedure TDCFlexThemeSource.AssignPalette(const AValue: TDCFlexThemePalette);
begin
  SetPalette(AValue);
end;

procedure TDCFlexThemeSource.Changed;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TDCFlexThemeSource.SetMode(const Value: TDCFlexThemeMode);
begin
  if FMode <> Value then
  begin
    FMode := Value;
    if FMode <> dtmCustom then
      FPalette := DCFlexPaletteForMode(FMode);
    Changed;
  end;
end;

procedure TDCFlexThemeSource.SetPalette(const Value: TDCFlexThemePalette);
begin
  FPalette := Value;
  FMode := dtmCustom;
  Changed;
end;

end.
