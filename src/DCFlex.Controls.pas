unit DCFlex.Controls;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  Winapi.CommCtrl,
  System.Classes,
  System.SysUtils,
  System.Types,
  Vcl.StdCtrls,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Vcl.Dialogs,
  Vcl.Forms,
  DCFlex.Language,
  DCFlex.Theme;

type
  TDCFlexColorPickerLanguage = (cplEnglish, cplPortuguese);

  TDCFlexButton = class(TCustomControl)
  private
    FBackColor: TColor;
    FAccentColor: TColor;
    FBorderColor: TColor;
    FCancel: Boolean;
    FDefault: Boolean;
    FDisabledColor: TColor;
    FDisabledTextColor: TColor;
    FHoverColor: TColor;
    FModalResult: TModalResult;
    FMouseDown: Boolean;
    FMouseOver: Boolean;
    FPressedColor: TColor;
    FTextColor: TColor;
    FThemeMode: TDCFlexThemeMode;
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure CMEnter(var Message: TCMGotFocus); message CM_ENTER;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMExit(var Message: TCMLostFocus); message CM_EXIT;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure SetBackColor(const Value: TColor);
    procedure SetAccentColor(const Value: TColor);
    procedure SetBorderColor(const Value: TColor);
    procedure SetDisabledColor(const Value: TColor);
    procedure SetDisabledTextColor(const Value: TColor);
    procedure SetHoverColor(const Value: TColor);
    procedure SetPressedColor(const Value: TColor);
    procedure SetTextColor(const Value: TColor);
    procedure SetThemeMode(const Value: TDCFlexThemeMode);
  protected
    procedure Click; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ApplyThemePalette(const APalette: TDCFlexThemePalette);
  published
    property Align;
    property Anchors;
    property AccentColor: TColor read FAccentColor write SetAccentColor default $00F86F62;
    property BackColor: TColor read FBackColor write SetBackColor default clWhite;
    property BorderColor: TColor read FBorderColor write SetBorderColor default $00D0D7DE;
    property Cancel: Boolean read FCancel write FCancel default False;
    property Caption;
    property Constraints;
    property Cursor;
    property Default: Boolean read FDefault write FDefault default False;
    property DisabledColor: TColor read FDisabledColor write SetDisabledColor default $00F0F0F0;
    property DisabledTextColor: TColor read FDisabledTextColor write SetDisabledTextColor default clGrayText;
    property Enabled;
    property Font;
    property Height default 30;
    property Hint;
    property HoverColor: TColor read FHoverColor write SetHoverColor default $00F1F5F9;
    property ModalResult: TModalResult read FModalResult write FModalResult default mrNone;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property PressedColor: TColor read FPressedColor write SetPressedColor default $00E2E8F0;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property TextColor: TColor read FTextColor write SetTextColor default clBlack;
    property ThemeMode: TDCFlexThemeMode read FThemeMode write SetThemeMode default dtmLight;
    property Visible;
    property Width default 96;
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

  TDCFlexEdit = class(TCustomControl)
  private
    FBackColor: TColor;
    FBorderColor: TColor;
    FDisabledColor: TColor;
    FDisabledTextColor: TColor;
    FEdit: TEdit;
    FFocusedBorderColor: TColor;
    FOnChange: TNotifyEvent;
    FText: string;
    FTextHint: string;
    FTextColor: TColor;
    FThemeMode: TDCFlexThemeMode;
    function GetReadOnly: Boolean;
    function GetText: string;
    function GetTextHint: string;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure EditEnter(Sender: TObject);
    procedure EditExit(Sender: TObject);
    procedure EditChange(Sender: TObject);
    procedure SetBackColor(const Value: TColor);
    procedure SetBorderColor(const Value: TColor);
    procedure SetDisabledColor(const Value: TColor);
    procedure SetDisabledTextColor(const Value: TColor);
    procedure SetFocusedBorderColor(const Value: TColor);
    procedure SetReadOnly(const Value: Boolean);
    procedure SetText(const Value: string);
    procedure SetTextHint(const Value: string);
    procedure SetTextColor(const Value: TColor);
    procedure SetThemeMode(const Value: TDCFlexThemeMode);
    procedure EnsureEdit;
    procedure UpdateEditBounds;
    procedure UpdateEditStyle;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
  protected
    procedure Paint; override;
    procedure Resize; override;
    procedure SetParent(AParent: TWinControl); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ApplyThemePalette(const APalette: TDCFlexThemePalette);
    procedure SelectAll;
    property EditControl: TEdit read FEdit;
  published
    property Align;
    property Anchors;
    property BackColor: TColor read FBackColor write SetBackColor default clWhite;
    property BorderColor: TColor read FBorderColor write SetBorderColor default $00D0D7DE;
    property Constraints;
    property Cursor;
    property DisabledColor: TColor read FDisabledColor write SetDisabledColor default $00F0F0F0;
    property DisabledTextColor: TColor read FDisabledTextColor write SetDisabledTextColor default clGrayText;
    property Enabled;
    property FocusedBorderColor: TColor read FFocusedBorderColor write SetFocusedBorderColor default $00F86F62;
    property Font;
    property Height default 30;
    property Hint;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Text: string read GetText write SetText;
    property TextHint: string read GetTextHint write SetTextHint;
    property TextColor: TColor read FTextColor write SetTextColor default clBlack;
    property ThemeMode: TDCFlexThemeMode read FThemeMode write SetThemeMode default dtmLight;
    property Visible;
    property Width default 160;
    property OnClick;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
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

  TDCFlexMemo = class(TCustomControl)
  private
    FBackColor: TColor;
    FBorderColor: TColor;
    FDisabledColor: TColor;
    FDisabledTextColor: TColor;
    FFocusedBorderColor: TColor;
    FLines: TStringList;
    FMemo: TMemo;
    FOnChange: TNotifyEvent;
    FScrollBars: TScrollStyle;
    FTextColor: TColor;
    FThemeMode: TDCFlexThemeMode;
    function GetLines: TStrings;
    function GetReadOnly: Boolean;
    function GetScrollBars: TScrollStyle;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure MemoChange(Sender: TObject);
    procedure MemoEnter(Sender: TObject);
    procedure MemoExit(Sender: TObject);
    procedure SetBackColor(const Value: TColor);
    procedure SetBorderColor(const Value: TColor);
    procedure SetDisabledColor(const Value: TColor);
    procedure SetDisabledTextColor(const Value: TColor);
    procedure SetFocusedBorderColor(const Value: TColor);
    procedure SetLines(const Value: TStrings);
    procedure SetReadOnly(const Value: Boolean);
    procedure SetScrollBars(const Value: TScrollStyle);
    procedure SetTextColor(const Value: TColor);
    procedure SetThemeMode(const Value: TDCFlexThemeMode);
    procedure EnsureMemo;
    procedure UpdateMemoBounds;
    procedure UpdateMemoStyle;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
  protected
    procedure Paint; override;
    procedure Resize; override;
    procedure SetParent(AParent: TWinControl); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ApplyThemePalette(const APalette: TDCFlexThemePalette);
    property MemoControl: TMemo read FMemo;
  published
    property Align;
    property Anchors;
    property BackColor: TColor read FBackColor write SetBackColor default clWhite;
    property BorderColor: TColor read FBorderColor write SetBorderColor default $00D0D7DE;
    property Constraints;
    property Cursor;
    property DisabledColor: TColor read FDisabledColor write SetDisabledColor default $00F0F0F0;
    property DisabledTextColor: TColor read FDisabledTextColor write SetDisabledTextColor default clGrayText;
    property Enabled;
    property FocusedBorderColor: TColor read FFocusedBorderColor write SetFocusedBorderColor default $00F86F62;
    property Font;
    property Height default 72;
    property Hint;
    property Lines: TStrings read GetLines write SetLines;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property ScrollBars: TScrollStyle read GetScrollBars write SetScrollBars default ssNone;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property TextColor: TColor read FTextColor write SetTextColor default clBlack;
    property ThemeMode: TDCFlexThemeMode read FThemeMode write SetThemeMode default dtmLight;
    property Visible;
    property Width default 240;
    property OnClick;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
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

  TDCFlexCheckBox = class(TCustomControl)
  private
    FAccentColor: TColor;
    FBorderColor: TColor;
    FChecked: Boolean;
    FHoverColor: TColor;
    FMouseOver: Boolean;
    FTextColor: TColor;
    FThemePalette: TDCFlexThemePalette;
    FThemeMode: TDCFlexThemeMode;
    FOnChange: TNotifyEvent;
    procedure CMEnter(var Message: TCMGotFocus); message CM_ENTER;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMExit(var Message: TCMLostFocus); message CM_EXIT;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure SetChecked(const Value: Boolean);
    procedure SetThemeMode(const Value: TDCFlexThemeMode);
  protected
    procedure Click; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ApplyThemePalette(const APalette: TDCFlexThemePalette);
  published
    property Align;
    property Anchors;
    property Caption;
    property Checked: Boolean read FChecked write SetChecked default False;
    property Enabled;
    property Font;
    property Height default 22;
    property ParentFont;
    property TabOrder;
    property TabStop default True;
    property ThemeMode: TDCFlexThemeMode read FThemeMode write SetThemeMode default dtmLight;
    property Visible;
    property Width default 140;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnClick;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
  end;

  TDCFlexDateEdit = class(TCustomControl)
  private
    FAccentColor: TColor;
    FBackColor: TColor;
    FBorderColor: TColor;
    FDate: TDateTime;
    FDropDown: TForm;
    FEditText: string;
    FMouseOver: Boolean;
    FTextColor: TColor;
    FThemePalette: TDCFlexThemePalette;
    FThemeMode: TDCFlexThemeMode;
    FOnChange: TNotifyEvent;
    procedure CalendarClick(Sender: TObject);
    procedure CalendarMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CMEnter(var Message: TCMGotFocus); message CM_ENTER;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMExit(var Message: TCMLostFocus); message CM_EXIT;
    procedure DropDownDeactivate(Sender: TObject);
    procedure SetDate(const Value: TDateTime);
    procedure SetThemeMode(const Value: TDCFlexThemeMode);
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
  protected
    procedure Change; virtual;
    procedure CloseDropDown;
    procedure DropDown;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ApplyThemePalette(const APalette: TDCFlexThemePalette);
  published
    property Align;
    property Anchors;
    property Date: TDateTime read FDate write SetDate;
    property Enabled;
    property Font;
    property Height default 28;
    property ParentFont;
    property TabOrder;
    property TabStop default True;
    property ThemeMode: TDCFlexThemeMode read FThemeMode write SetThemeMode default dtmLight;
    property Visible;
    property Width default 140;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnClick;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
  end;

  TDCFlexTimeEdit = class(TCustomControl)
  private
    FAccentColor: TColor;
    FBackColor: TColor;
    FBorderColor: TColor;
    FEditText: string;
    FMouseOver: Boolean;
    FTextColor: TColor;
    FThemePalette: TDCFlexThemePalette;
    FThemeMode: TDCFlexThemeMode;
    FTime: TDateTime;
    FOnChange: TNotifyEvent;
    procedure CMEnter(var Message: TCMGotFocus); message CM_ENTER;
    procedure CMExit(var Message: TCMLostFocus); message CM_EXIT;
    procedure SetThemeMode(const Value: TDCFlexThemeMode);
    procedure SetTime(const Value: TDateTime);
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
  protected
    procedure Change; virtual;
    procedure IncrementMinutes(AMinutes: Integer);
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ApplyThemePalette(const APalette: TDCFlexThemePalette);
  published
    property Align;
    property Anchors;
    property Enabled;
    property Font;
    property Height default 28;
    property ParentFont;
    property TabOrder;
    property TabStop default True;
    property ThemeMode: TDCFlexThemeMode read FThemeMode write SetThemeMode default dtmLight;
    property Time: TDateTime read FTime write SetTime;
    property Visible;
    property Width default 86;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnClick;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
  end;

  TDCFlexComboBox = class(TCustomControl)
  private
    FAccentColor: TColor;
    FBackColor: TColor;
    FBorderColor: TColor;
    FDisabledColor: TColor;
    FDisabledTextColor: TColor;
    FDropDown: TForm;
    FDropDownCount: Integer;
    FHoverColor: TColor;
    FItems: TStringList;
    FItemIndex: Integer;
    FListBox: TListBox;
    FOnChange: TNotifyEvent;
    FStyle: TComboBoxStyle;
    FText: string;
    FTextColor: TColor;
    FThemeMode: TDCFlexThemeMode;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure DropDownDeactivate(Sender: TObject);
    function GetItems: TStrings;
    procedure ItemsChanged(Sender: TObject);
    procedure ListBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ListBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListBoxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SelectListIndex(AIndex: Integer);
    procedure SetAccentColor(const Value: TColor);
    procedure SetBackColor(const Value: TColor);
    procedure SetBorderColor(const Value: TColor);
    procedure SetDisabledColor(const Value: TColor);
    procedure SetDisabledTextColor(const Value: TColor);
    procedure SetDropDownCount(const Value: Integer);
    procedure SetHoverColor(const Value: TColor);
    procedure SetItemIndex(const Value: Integer);
    procedure SetItems(const Value: TStrings);
    procedure SetText(const Value: string);
    procedure SetTextColor(const Value: TColor);
    procedure SetThemeMode(const Value: TDCFlexThemeMode);
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
  protected
    procedure Change; virtual;
    procedure CloseDropDown;
    procedure DropDown; virtual;
    function GetText: string; virtual;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer); override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ApplyThemePalette(const APalette: TDCFlexThemePalette);
    property DroppedDown: TForm read FDropDown;
  published
    property Align;
    property Anchors;
    property AccentColor: TColor read FAccentColor write SetAccentColor default $00F86F62;
    property BackColor: TColor read FBackColor write SetBackColor default clWhite;
    property BorderColor: TColor read FBorderColor write SetBorderColor default $00D0D7DE;
    property Constraints;
    property Cursor;
    property DisabledColor: TColor read FDisabledColor write SetDisabledColor default $00F0F0F0;
    property DisabledTextColor: TColor read FDisabledTextColor write SetDisabledTextColor default clGrayText;
    property DropDownCount: Integer read FDropDownCount write SetDropDownCount default 8;
    property Enabled;
    property Font;
    property Height default 24;
    property Hint;
    property HoverColor: TColor read FHoverColor write SetHoverColor default $00F1F5F9;
    property ItemIndex: Integer read FItemIndex write SetItemIndex default -1;
    property Items: TStrings read GetItems write SetItems;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Style: TComboBoxStyle read FStyle write FStyle default csDropDownList;
    property TabOrder;
    property TabStop default True;
    property Text: string read GetText write SetText;
    property TextColor: TColor read FTextColor write SetTextColor default clBlack;
    property ThemeMode: TDCFlexThemeMode read FThemeMode write SetThemeMode default dtmLight;
    property Visible;
    property Width default 160;
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

  TDCFlexColorPicker = class(TComboBox)
  private
    FSelected: TColor;
    FAllowCustomColor: Boolean;
    FPaletteLoaded: Boolean;
    FPaletteLanguage: TDCFlexColorPickerLanguage;
    FThemeMode: TDCFlexThemeMode;
    FThemePalette: TDCFlexThemePalette;
    FLanguageSource: TDCFlexLanguage;
    function GetSelected: TColor;
    procedure SetSelected(const Value: TColor);
    procedure SetLanguageSource(const Value: TDCFlexLanguage);
    procedure SetPaletteLanguage(const Value: TDCFlexColorPickerLanguage);
    procedure SetThemeMode(const Value: TDCFlexThemeMode);
    procedure ApplyDropDownTheme;
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    function ColorText(AColor: TColor): string;
    procedure AddColorItem(const ACaption: string; AColor: TColor);
    procedure EnsureColorItem(AColor: TColor);
    procedure ApplySelectedIndex;
    function PaletteText(const AEnglish, APortuguese: string): string;
    procedure LanguageSourceChange(Sender: TObject);
  protected
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
    procedure DblClick; override;
    procedure DrawClosedState;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetParent(AParent: TWinControl); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ApplyThemePalette(const APalette: TDCFlexThemePalette);
    procedure LoadDefaultPalette;
    function DisplayText(AColor: TColor): string;
    function SelectCustomColor: Boolean;
  published
    property AllowCustomColor: Boolean read FAllowCustomColor write FAllowCustomColor default True;
    property LanguageSource: TDCFlexLanguage read FLanguageSource
      write SetLanguageSource;
    property PaletteLanguage: TDCFlexColorPickerLanguage read FPaletteLanguage write SetPaletteLanguage default cplEnglish;
    property Selected: TColor read GetSelected write SetSelected default clBlack;
    property ThemeMode: TDCFlexThemeMode read FThemeMode write SetThemeMode default dtmLight;
  end;

  TDCFlexColorPaletteButton = class(TCustomControl)
  private
    FAllowCustomColor: Boolean;
    FBorderColor: TColor;
    FHoverColor: TColor;
    FMouseOver: Boolean;
    FOnChange: TNotifyEvent;
    FPaletteLanguage: TDCFlexColorPickerLanguage;
    FThemeMode: TDCFlexThemeMode;
    FThemePalette: TDCFlexThemePalette;
    FLanguageSource: TDCFlexLanguage;
    FSelected: TColor;
    procedure CMEnter(var Message: TMessage); message CM_ENTER;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMExit(var Message: TMessage); message CM_EXIT;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    function ColorText(AColor: TColor): string;
    function PaletteText(const AEnglish, APortuguese: string): string;
    procedure SetBorderColor(const Value: TColor);
    procedure SetHoverColor(const Value: TColor);
    procedure SetLanguageSource(const Value: TDCFlexLanguage);
    procedure SetPaletteLanguage(const Value: TDCFlexColorPickerLanguage);
    procedure SetSelected(const Value: TColor);
    procedure SetThemeMode(const Value: TDCFlexThemeMode);
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
    procedure ApplyThemePalette(const APalette: TDCFlexThemePalette);
    function DisplayText(AColor: TColor): string;
    procedure DropDown;
    function SelectCustomColor: Boolean;
  published
    property Align;
    property Anchors;
    property AllowCustomColor: Boolean read FAllowCustomColor write FAllowCustomColor default True;
    property BorderColor: TColor read FBorderColor write SetBorderColor default $00D0D7DE;
    property Color default clWhite;
    property Enabled;
    property Font;
    property Height default 26;
    property Hint;
    property HoverColor: TColor read FHoverColor write SetHoverColor default $00F1F5F9;
    property LanguageSource: TDCFlexLanguage read FLanguageSource
      write SetLanguageSource;
    property PaletteLanguage: TDCFlexColorPickerLanguage read FPaletteLanguage write SetPaletteLanguage default cplEnglish;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property Selected: TColor read FSelected write SetSelected default clBlack;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property ThemeMode: TDCFlexThemeMode read FThemeMode write SetThemeMode default dtmLight;
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
    FThemeMode: TDCFlexThemeMode;
    FLanguageSource: TDCFlexLanguage;
    procedure LanguageSourceChange(Sender: TObject);
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
    procedure SetLanguageSource(const Value: TDCFlexLanguage);
    procedure SetThemeMode(const Value: TDCFlexThemeMode);
    procedure UpdateExclusiveGroup;
    procedure UpdateAutoSizeToCaption;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMEnter(var Message: TCMGotFocus); message CM_ENTER;
    procedure CMExit(var Message: TCMLostFocus); message CM_EXIT;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Click; override;
    procedure Change; virtual;
    function GetBackColor: TColor; virtual;
    function GetBorderPaintColor: TColor; virtual;
    function GetTextColor: TColor; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ApplyThemePalette(const APalette: TDCFlexThemePalette);
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
    property LanguageSource: TDCFlexLanguage read FLanguageSource
      write SetLanguageSource;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property ThemeMode: TDCFlexThemeMode read FThemeMode write SetThemeMode default dtmLight;
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
    FThemeMode: TDCFlexThemeMode;
    FVerticalSpacing: Integer;
    FWrap: Boolean;
    procedure SetAutoHeight(const Value: Boolean);
    procedure SetBackColor(const Value: TColor);
    procedure SetHorizontalSpacing(const Value: Integer);
    procedure SetPaddingBottom(const Value: Integer);
    procedure SetPaddingLeft(const Value: Integer);
    procedure SetPaddingRight(const Value: Integer);
    procedure SetPaddingTop(const Value: Integer);
    procedure SetThemeMode(const Value: TDCFlexThemeMode);
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
    procedure ApplyThemePalette(const APalette: TDCFlexThemePalette);
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
    property ThemeMode: TDCFlexThemeMode read FThemeMode write SetThemeMode default dtmLight;
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
    FThemeMode: TDCFlexThemeMode;
    FThemePalette: TDCFlexThemePalette;
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
    procedure SetThemeMode(const Value: TDCFlexThemeMode);
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
    procedure ApplyThemePalette(const APalette: TDCFlexThemePalette);
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
    property ThemeMode: TDCFlexThemeMode read FThemeMode write SetThemeMode default dtmLight;
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

type
  TDCFlexDateCalendar = class(TMonthCalendar)
  public
    property OnMouseUp;
  end;

  TDCFlexComboListBox = class(TListBox)
  private
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
  end;

procedure TDCFlexComboListBox.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  Message.Result := Message.Result or DLGC_WANTTAB or DLGC_WANTARROWS;
end;

function DCFlexColorBrightness(AColor: TColor): Integer;
var
  C: TColor;
begin
  C := ColorToRGB(AColor);
  Result := GetRValue(C) + GetGValue(C) + GetBValue(C);
end;

{ TDCFlexButton }

constructor TDCFlexButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csCaptureMouse, csClickEvents, csDoubleClicks, csOpaque];
  Width := 96;
  Height := 30;
  TabStop := True;
  Font.Name := 'Segoe UI';
  Font.Size := 9;
  FThemeMode := dtmLight;
  FAccentColor := $00F86F62;
  FBackColor := clWhite;
  FHoverColor := $00F1F5F9;
  FPressedColor := $00E2E8F0;
  FDisabledColor := $00F0F0F0;
  FBorderColor := $00D0D7DE;
  FTextColor := clBlack;
  FDisabledTextColor := clGrayText;
end;

procedure TDCFlexButton.ApplyThemePalette(const APalette: TDCFlexThemePalette);
begin
  FThemeMode := dtmCustom;
  FAccentColor := APalette.Accent;
  FBackColor := APalette.InputBack;
  FHoverColor := APalette.Hover;
  FPressedColor := APalette.Pressed;
  FDisabledColor := APalette.Disabled;
  FBorderColor := APalette.InputBorder;
  FTextColor := APalette.Text;
  FDisabledTextColor := APalette.DisabledText;
  Font.Color := FTextColor;
  Invalidate;
end;

procedure TDCFlexButton.Click;
var
  LForm: TCustomForm;
begin
  inherited Click;
  if FModalResult <> mrNone then
  begin
    LForm := GetParentForm(Self);
    if Assigned(LForm) then
      LForm.ModalResult := FModalResult;
  end;
end;

procedure TDCFlexButton.CMDialogKey(var Message: TCMDialogKey);
begin
  if Enabled and (((Message.CharCode = VK_RETURN) and FDefault) or
    ((Message.CharCode = VK_ESCAPE) and FCancel)) then
  begin
    Click;
    Message.Result := 1;
    Exit;
  end;
  inherited;
end;

procedure TDCFlexButton.CMEnter(var Message: TCMGotFocus);
begin
  inherited;
  Invalidate;
end;

procedure TDCFlexButton.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TDCFlexButton.CMExit(var Message: TCMLostFocus);
begin
  inherited;
  Invalidate;
end;

procedure TDCFlexButton.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  FMouseOver := True;
  Invalidate;
end;

procedure TDCFlexButton.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  FMouseOver := False;
  FMouseDown := False;
  Invalidate;
end;

procedure TDCFlexButton.CMTextChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TDCFlexButton.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if Enabled and ((Key = VK_RETURN) or (Key = VK_SPACE)) then
  begin
    Click;
    Key := 0;
  end;
end;

procedure TDCFlexButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if (Button = mbLeft) and Enabled then
  begin
    SetFocus;
    FMouseDown := True;
    Invalidate;
  end;
end;

procedure TDCFlexButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    FMouseDown := False;
    Invalidate;
  end;
end;

procedure TDCFlexButton.Paint;
var
  R: TRect;
  LBack: TColor;
  LBorder: TColor;
  LText: TColor;
  LCaption: string;
begin
  R := ClientRect;
  LBack := FBackColor;
  LBorder := FBorderColor;
  LText := FTextColor;

  if not Enabled then
  begin
    LBack := FDisabledColor;
    LText := FDisabledTextColor;
  end
  else if FDefault then
  begin
    LBack := FAccentColor;
    LBorder := FAccentColor;
    LText := clWhite;
    if FMouseOver or FMouseDown then
    begin
      LBack := FPressedColor;
      if DCFlexColorBrightness(LBack) > 520 then
        LText := FTextColor;
    end;
  end
  else if FMouseDown then
    LBack := FPressedColor
  else if FMouseOver then
    LBack := FHoverColor;

  Canvas.Brush.Color := LBack;
  Canvas.Pen.Color := LBorder;
  Canvas.Rectangle(R);

  if Focused and Enabled then
  begin
    InflateRect(R, -3, -3);
    Canvas.Brush.Style := bsClear;
    Canvas.Pen.Color := FAccentColor;
    Canvas.Rectangle(R);
    Canvas.Brush.Style := bsSolid;
    R := ClientRect;
  end;

  Canvas.Font.Assign(Font);
  Canvas.Font.Color := LText;
  Canvas.Brush.Style := bsClear;
  LCaption := Caption;
  DrawText(Canvas.Handle, PChar(LCaption), Length(LCaption), R,
    DT_SINGLELINE or DT_CENTER or DT_VCENTER or DT_END_ELLIPSIS);
  Canvas.Brush.Style := bsSolid;
end;

procedure TDCFlexButton.SetAccentColor(const Value: TColor);
begin
  if FAccentColor <> Value then
  begin
    FAccentColor := Value;
    Invalidate;
  end;
end;

procedure TDCFlexButton.SetBackColor(const Value: TColor);
begin
  if FBackColor <> Value then
  begin
    FBackColor := Value;
    Invalidate;
  end;
end;

procedure TDCFlexButton.SetBorderColor(const Value: TColor);
begin
  if FBorderColor <> Value then
  begin
    FBorderColor := Value;
    Invalidate;
  end;
end;

procedure TDCFlexButton.SetDisabledColor(const Value: TColor);
begin
  if FDisabledColor <> Value then
  begin
    FDisabledColor := Value;
    Invalidate;
  end;
end;

procedure TDCFlexButton.SetDisabledTextColor(const Value: TColor);
begin
  if FDisabledTextColor <> Value then
  begin
    FDisabledTextColor := Value;
    Invalidate;
  end;
end;

procedure TDCFlexButton.SetHoverColor(const Value: TColor);
begin
  if FHoverColor <> Value then
  begin
    FHoverColor := Value;
    Invalidate;
  end;
end;

procedure TDCFlexButton.SetPressedColor(const Value: TColor);
begin
  if FPressedColor <> Value then
  begin
    FPressedColor := Value;
    Invalidate;
  end;
end;

procedure TDCFlexButton.SetTextColor(const Value: TColor);
begin
  if FTextColor <> Value then
  begin
    FTextColor := Value;
    Font.Color := Value;
    Invalidate;
  end;
end;

procedure TDCFlexButton.SetThemeMode(const Value: TDCFlexThemeMode);
var
  LPalette: TDCFlexThemePalette;
begin
  if FThemeMode = Value then
    Exit;

  FThemeMode := Value;
  if FThemeMode = dtmCustom then
    Exit;

  LPalette := DCFlexPaletteForMode(FThemeMode);
  FAccentColor := LPalette.Accent;
  FBackColor := LPalette.InputBack;
  FHoverColor := LPalette.Hover;
  FPressedColor := LPalette.Pressed;
  FDisabledColor := LPalette.Disabled;
  FBorderColor := LPalette.InputBorder;
  FTextColor := LPalette.Text;
  FDisabledTextColor := LPalette.DisabledText;
  Font.Color := FTextColor;
  Invalidate;
end;

{ TDCFlexEdit }

constructor TDCFlexEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csAcceptsControls];
  Width := 160;
  Height := 30;
  TabStop := True;
  Font.Name := 'Segoe UI';
  Font.Size := 9;
  FThemeMode := dtmLight;
  FBackColor := clWhite;
  FBorderColor := $00D0D7DE;
  FFocusedBorderColor := $00F86F62;
  FDisabledColor := $00F0F0F0;
  FTextColor := clBlack;
  FDisabledTextColor := clGrayText;
end;

procedure TDCFlexEdit.ApplyThemePalette(const APalette: TDCFlexThemePalette);
begin
  FThemeMode := dtmCustom;
  FBackColor := APalette.InputBack;
  FBorderColor := APalette.InputBorder;
  FFocusedBorderColor := APalette.Accent;
  FDisabledColor := APalette.Disabled;
  FTextColor := APalette.Text;
  FDisabledTextColor := APalette.DisabledText;
  UpdateEditStyle;
  Invalidate;
end;

procedure TDCFlexEdit.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  EnsureEdit;
  if Assigned(FEdit) then
    FEdit.Enabled := Enabled;
  UpdateEditStyle;
  Invalidate;
end;

procedure TDCFlexEdit.CMFontChanged(var Message: TMessage);
begin
  inherited;
  UpdateEditStyle;
  UpdateEditBounds;
end;

procedure TDCFlexEdit.EditChange(Sender: TObject);
begin
  if Assigned(FEdit) then
    FText := FEdit.Text;
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TDCFlexEdit.EditEnter(Sender: TObject);
begin
  Invalidate;
end;

procedure TDCFlexEdit.EditExit(Sender: TObject);
begin
  Invalidate;
end;

function TDCFlexEdit.GetReadOnly: Boolean;
begin
  Result := Assigned(FEdit) and FEdit.ReadOnly;
end;

function TDCFlexEdit.GetText: string;
begin
  if Assigned(FEdit) then
    Result := FEdit.Text
  else
    Result := FText;
end;

function TDCFlexEdit.GetTextHint: string;
begin
  if Assigned(FEdit) then
    Result := FEdit.TextHint
  else
    Result := FTextHint;
end;

procedure TDCFlexEdit.Paint;
var
  R: TRect;
begin
  R := ClientRect;
  if Enabled then
    Canvas.Brush.Color := FBackColor
  else
    Canvas.Brush.Color := FDisabledColor;

  if Assigned(FEdit) and FEdit.Focused then
    Canvas.Pen.Color := FFocusedBorderColor
  else
    Canvas.Pen.Color := FBorderColor;

  Canvas.Rectangle(R);
end;

procedure TDCFlexEdit.Resize;
begin
  inherited;
  UpdateEditBounds;
end;

procedure TDCFlexEdit.SelectAll;
begin
  EnsureEdit;
  if Assigned(FEdit) then
    FEdit.SelectAll;
end;

procedure TDCFlexEdit.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if Assigned(AParent) then
  begin
    EnsureEdit;
    UpdateEditStyle;
    UpdateEditBounds;
  end;
end;

procedure TDCFlexEdit.SetBackColor(const Value: TColor);
begin
  if FBackColor <> Value then
  begin
    FBackColor := Value;
    UpdateEditStyle;
    Invalidate;
  end;
end;

procedure TDCFlexEdit.SetBorderColor(const Value: TColor);
begin
  if FBorderColor <> Value then
  begin
    FBorderColor := Value;
    Invalidate;
  end;
end;

procedure TDCFlexEdit.SetDisabledColor(const Value: TColor);
begin
  if FDisabledColor <> Value then
  begin
    FDisabledColor := Value;
    UpdateEditStyle;
    Invalidate;
  end;
end;

procedure TDCFlexEdit.SetDisabledTextColor(const Value: TColor);
begin
  if FDisabledTextColor <> Value then
  begin
    FDisabledTextColor := Value;
    UpdateEditStyle;
  end;
end;

procedure TDCFlexEdit.SetFocusedBorderColor(const Value: TColor);
begin
  if FFocusedBorderColor <> Value then
  begin
    FFocusedBorderColor := Value;
    Invalidate;
  end;
end;

procedure TDCFlexEdit.SetReadOnly(const Value: Boolean);
begin
  EnsureEdit;
  if Assigned(FEdit) then
    FEdit.ReadOnly := Value;
end;

procedure TDCFlexEdit.SetText(const Value: string);
begin
  FText := Value;
  EnsureEdit;
  if Assigned(FEdit) then
    FEdit.Text := Value;
end;

procedure TDCFlexEdit.SetTextHint(const Value: string);
begin
  if FTextHint <> Value then
  begin
    FTextHint := Value;
    EnsureEdit;
    if Assigned(FEdit) then
      FEdit.TextHint := Value;
  end;
end;

procedure TDCFlexEdit.SetTextColor(const Value: TColor);
begin
  if FTextColor <> Value then
  begin
    FTextColor := Value;
    UpdateEditStyle;
  end;
end;

procedure TDCFlexEdit.SetThemeMode(const Value: TDCFlexThemeMode);
var
  LPalette: TDCFlexThemePalette;
begin
  if FThemeMode = Value then
    Exit;

  FThemeMode := Value;
  if FThemeMode = dtmCustom then
    Exit;

  LPalette := DCFlexPaletteForMode(FThemeMode);
  FBackColor := LPalette.InputBack;
  FBorderColor := LPalette.InputBorder;
  FFocusedBorderColor := LPalette.Accent;
  FDisabledColor := LPalette.Disabled;
  FTextColor := LPalette.Text;
  FDisabledTextColor := LPalette.DisabledText;
  UpdateEditStyle;
  Invalidate;
end;

procedure TDCFlexEdit.EnsureEdit;
begin
  if Assigned(FEdit) or (not Assigned(Parent)) then
    Exit;

  FEdit := TEdit.Create(Self);
  FEdit.Parent := Self;
  FEdit.BorderStyle := bsNone;
  FEdit.AutoSize := False;
  FEdit.ParentColor := False;
  FEdit.ParentFont := False;
  FEdit.TabStop := False;
  FEdit.OnEnter := EditEnter;
  FEdit.OnExit := EditExit;
  FEdit.OnChange := EditChange;
  FEdit.Text := FText;
  FEdit.TextHint := FTextHint;
end;

procedure TDCFlexEdit.UpdateEditBounds;
var
  LEditHeight: Integer;
  LTop: Integer;
begin
  EnsureEdit;
  if (not Assigned(FEdit)) or (FEdit.Parent <> Self) then
    Exit;

  LEditHeight := Abs(FEdit.Font.Height) + 8;
  if LEditHeight < 18 then
    LEditHeight := 18;
  if (Height > 8) and (LEditHeight > Height - 6) then
    LEditHeight := Height - 6;

  LTop := (Height - LEditHeight) div 2 + 1;
  if LTop < 3 then
    LTop := 3;
  FEdit.SetBounds(8, LTop, Width - 16, LEditHeight);
end;

procedure TDCFlexEdit.UpdateEditStyle;
begin
  EnsureEdit;
  if not Assigned(FEdit) then
    Exit;

  FEdit.Font.Assign(Font);
  FEdit.ParentColor := False;
  FEdit.ParentFont := False;
  if Enabled then
  begin
    FEdit.Color := FBackColor;
    FEdit.Font.Color := FTextColor;
  end
  else
  begin
    FEdit.Color := FDisabledColor;
    FEdit.Font.Color := FDisabledTextColor;
  end;
  FEdit.Invalidate;
end;

procedure TDCFlexEdit.WMSetFocus(var Message: TWMSetFocus);
begin
  inherited;
  EnsureEdit;
  if Assigned(FEdit) and FEdit.CanFocus then
    FEdit.SetFocus;
end;

{ TDCFlexMemo }

constructor TDCFlexMemo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csAcceptsControls];
  Width := 240;
  Height := 72;
  TabStop := True;
  Font.Name := 'Segoe UI';
  Font.Size := 9;
  FThemeMode := dtmLight;
  FBackColor := clWhite;
  FBorderColor := $00D0D7DE;
  FFocusedBorderColor := $00F86F62;
  FDisabledColor := $00F0F0F0;
  FTextColor := clBlack;
  FDisabledTextColor := clGrayText;
  FLines := TStringList.Create;
  FScrollBars := ssNone;
end;

destructor TDCFlexMemo.Destroy;
begin
  FLines.Free;
  inherited Destroy;
end;

procedure TDCFlexMemo.ApplyThemePalette(const APalette: TDCFlexThemePalette);
begin
  FThemeMode := dtmCustom;
  FBackColor := APalette.InputBack;
  FBorderColor := APalette.InputBorder;
  FFocusedBorderColor := APalette.Accent;
  FDisabledColor := APalette.Disabled;
  FTextColor := APalette.Text;
  FDisabledTextColor := APalette.DisabledText;
  UpdateMemoStyle;
  Invalidate;
end;

procedure TDCFlexMemo.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  EnsureMemo;
  if Assigned(FMemo) then
    FMemo.Enabled := Enabled;
  UpdateMemoStyle;
  Invalidate;
end;

procedure TDCFlexMemo.CMFontChanged(var Message: TMessage);
begin
  inherited;
  UpdateMemoStyle;
  UpdateMemoBounds;
end;

procedure TDCFlexMemo.EnsureMemo;
begin
  if Assigned(FMemo) or (not Assigned(Parent)) then
    Exit;

  FMemo := TMemo.Create(Self);
  FMemo.Parent := Self;
  FMemo.BorderStyle := bsNone;
  FMemo.ParentColor := False;
  FMemo.ParentFont := False;
  FMemo.TabStop := False;
  FMemo.ScrollBars := FScrollBars;
  FMemo.OnEnter := MemoEnter;
  FMemo.OnExit := MemoExit;
  FMemo.OnChange := MemoChange;
  FMemo.Lines.Assign(FLines);
end;

function TDCFlexMemo.GetLines: TStrings;
begin
  EnsureMemo;
  if Assigned(FMemo) then
    Result := FMemo.Lines
  else
    Result := FLines;
end;

function TDCFlexMemo.GetReadOnly: Boolean;
begin
  Result := Assigned(FMemo) and FMemo.ReadOnly;
end;

function TDCFlexMemo.GetScrollBars: TScrollStyle;
begin
  EnsureMemo;
  if Assigned(FMemo) then
    Result := FMemo.ScrollBars
  else
    Result := FScrollBars;
end;

procedure TDCFlexMemo.MemoChange(Sender: TObject);
begin
  if Assigned(FMemo) then
    FLines.Assign(FMemo.Lines);
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TDCFlexMemo.MemoEnter(Sender: TObject);
begin
  Invalidate;
end;

procedure TDCFlexMemo.MemoExit(Sender: TObject);
begin
  Invalidate;
end;

procedure TDCFlexMemo.Paint;
var
  R: TRect;
begin
  R := ClientRect;
  if Enabled then
    Canvas.Brush.Color := FBackColor
  else
    Canvas.Brush.Color := FDisabledColor;

  if Assigned(FMemo) and FMemo.Focused then
    Canvas.Pen.Color := FFocusedBorderColor
  else
    Canvas.Pen.Color := FBorderColor;

  Canvas.Rectangle(R);
end;

procedure TDCFlexMemo.Resize;
begin
  inherited;
  UpdateMemoBounds;
end;

procedure TDCFlexMemo.SetBackColor(const Value: TColor);
begin
  if FBackColor <> Value then
  begin
    FBackColor := Value;
    UpdateMemoStyle;
    Invalidate;
  end;
end;

procedure TDCFlexMemo.SetBorderColor(const Value: TColor);
begin
  if FBorderColor <> Value then
  begin
    FBorderColor := Value;
    Invalidate;
  end;
end;

procedure TDCFlexMemo.SetDisabledColor(const Value: TColor);
begin
  if FDisabledColor <> Value then
  begin
    FDisabledColor := Value;
    UpdateMemoStyle;
    Invalidate;
  end;
end;

procedure TDCFlexMemo.SetDisabledTextColor(const Value: TColor);
begin
  if FDisabledTextColor <> Value then
  begin
    FDisabledTextColor := Value;
    UpdateMemoStyle;
  end;
end;

procedure TDCFlexMemo.SetFocusedBorderColor(const Value: TColor);
begin
  if FFocusedBorderColor <> Value then
  begin
    FFocusedBorderColor := Value;
    Invalidate;
  end;
end;

procedure TDCFlexMemo.SetLines(const Value: TStrings);
begin
  EnsureMemo;
  if Assigned(Value) then
  begin
    FLines.Assign(Value);
    if Assigned(FMemo) then
      FMemo.Lines.Assign(Value);
  end
  else
  begin
    FLines.Clear;
    if Assigned(FMemo) then
      FMemo.Lines.Clear;
  end;
end;

procedure TDCFlexMemo.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if Assigned(AParent) then
  begin
    EnsureMemo;
    UpdateMemoStyle;
    UpdateMemoBounds;
  end;
end;

procedure TDCFlexMemo.SetReadOnly(const Value: Boolean);
begin
  EnsureMemo;
  if Assigned(FMemo) then
    FMemo.ReadOnly := Value;
end;

procedure TDCFlexMemo.SetScrollBars(const Value: TScrollStyle);
begin
  EnsureMemo;
  FScrollBars := Value;
  if Assigned(FMemo) then
  begin
    FMemo.ScrollBars := Value;
    UpdateMemoBounds;
  end;
end;

procedure TDCFlexMemo.SetTextColor(const Value: TColor);
begin
  if FTextColor <> Value then
  begin
    FTextColor := Value;
    UpdateMemoStyle;
  end;
end;

procedure TDCFlexMemo.SetThemeMode(const Value: TDCFlexThemeMode);
var
  LPalette: TDCFlexThemePalette;
begin
  if FThemeMode = Value then
    Exit;

  FThemeMode := Value;
  if FThemeMode = dtmCustom then
    Exit;

  LPalette := DCFlexPaletteForMode(FThemeMode);
  FBackColor := LPalette.InputBack;
  FBorderColor := LPalette.InputBorder;
  FFocusedBorderColor := LPalette.Accent;
  FDisabledColor := LPalette.Disabled;
  FTextColor := LPalette.Text;
  FDisabledTextColor := LPalette.DisabledText;
  UpdateMemoStyle;
  Invalidate;
end;

procedure TDCFlexMemo.UpdateMemoBounds;
begin
  EnsureMemo;
  if (not Assigned(FMemo)) or (FMemo.Parent <> Self) then
    Exit;

  FMemo.SetBounds(8, 6, Width - 16, Height - 12);
end;

procedure TDCFlexMemo.UpdateMemoStyle;
begin
  EnsureMemo;
  if not Assigned(FMemo) then
    Exit;

  FMemo.Font.Assign(Font);
  FMemo.ParentColor := False;
  FMemo.ParentFont := False;
  if Enabled then
  begin
    FMemo.Color := FBackColor;
    FMemo.Font.Color := FTextColor;
  end
  else
  begin
    FMemo.Color := FDisabledColor;
    FMemo.Font.Color := FDisabledTextColor;
  end;
  FMemo.Invalidate;
end;

procedure TDCFlexMemo.WMSetFocus(var Message: TWMSetFocus);
begin
  inherited;
  EnsureMemo;
  if Assigned(FMemo) and FMemo.CanFocus then
    FMemo.SetFocus;
end;

{ TDCFlexCheckBox }

constructor TDCFlexCheckBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 140;
  Height := 22;
  TabStop := True;
  Font.Name := 'Segoe UI';
  Font.Size := 9;
  FThemeMode := dtmLight;
  FThemePalette := DCFlexLightPalette;
  FAccentColor := FThemePalette.Accent;
  FBorderColor := FThemePalette.InputBorder;
  FHoverColor := FThemePalette.Hover;
  FTextColor := FThemePalette.Text;
end;

procedure TDCFlexCheckBox.ApplyThemePalette(const APalette: TDCFlexThemePalette);
begin
  FThemeMode := dtmCustom;
  FThemePalette := APalette;
  FAccentColor := APalette.Accent;
  FBorderColor := APalette.InputBorder;
  FHoverColor := APalette.Hover;
  FTextColor := APalette.Text;
  Font.Color := FTextColor;
  Invalidate;
end;

procedure TDCFlexCheckBox.Click;
begin
  SetChecked(not FChecked);
  inherited Click;
end;

procedure TDCFlexCheckBox.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TDCFlexCheckBox.CMEnter(var Message: TCMGotFocus);
begin
  inherited;
  Invalidate;
end;

procedure TDCFlexCheckBox.CMExit(var Message: TCMLostFocus);
begin
  inherited;
  Invalidate;
end;

procedure TDCFlexCheckBox.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  FMouseOver := True;
  Invalidate;
end;

procedure TDCFlexCheckBox.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  FMouseOver := False;
  Invalidate;
end;

procedure TDCFlexCheckBox.CMTextChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TDCFlexCheckBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if Key in [VK_SPACE, VK_RETURN] then
  begin
    Click;
    Key := 0;
  end;
end;

procedure TDCFlexCheckBox.Paint;
var
  R: TRect;
  Box: TRect;
  LTextRect: TRect;
  LBack: TColor;
  LBorder: TColor;
begin
  R := ClientRect;
  Canvas.Brush.Color := FThemePalette.Surface;
  Canvas.FillRect(R);

  Box := Rect(0, 0, 14, 14);
  OffsetRect(Box, 0, (Height - 14) div 2);
  LBack := FThemePalette.InputBack;
  if FMouseOver and Enabled then
    LBack := FHoverColor;
  LBorder := FBorderColor;
  if Focused and Enabled then
    LBorder := FAccentColor;

  Canvas.Brush.Color := LBack;
  Canvas.Pen.Color := LBorder;
  Canvas.Rectangle(Box);

  if FChecked then
  begin
    Canvas.Pen.Color := FAccentColor;
    Canvas.Pen.Width := 2;
    Canvas.MoveTo(Box.Left + 3, Box.Top + 7);
    Canvas.LineTo(Box.Left + 6, Box.Bottom - 3);
    Canvas.LineTo(Box.Right - 3, Box.Top + 3);
    Canvas.Pen.Width := 1;
  end;

  Canvas.Font.Assign(Font);
  if Enabled then
    Canvas.Font.Color := FTextColor
  else
    Canvas.Font.Color := FThemePalette.DisabledText;
  Canvas.Brush.Style := bsClear;
  LTextRect := Rect(22, 0, Width, Height);
  DrawText(Canvas.Handle, PChar(Caption), Length(Caption), LTextRect,
    DT_SINGLELINE or DT_VCENTER or DT_END_ELLIPSIS);
  Canvas.Brush.Style := bsSolid;
end;

procedure TDCFlexCheckBox.SetChecked(const Value: Boolean);
begin
  if FChecked <> Value then
  begin
    FChecked := Value;
    Invalidate;
    if Assigned(FOnChange) then
      FOnChange(Self);
  end;
end;

procedure TDCFlexCheckBox.SetThemeMode(const Value: TDCFlexThemeMode);
var
  LPalette: TDCFlexThemePalette;
begin
  if FThemeMode = Value then
    Exit;
  FThemeMode := Value;
  if FThemeMode = dtmCustom then
    Exit;

  LPalette := DCFlexPaletteForMode(FThemeMode);
  FThemePalette := LPalette;
  FAccentColor := LPalette.Accent;
  FBorderColor := LPalette.InputBorder;
  FHoverColor := LPalette.Hover;
  FTextColor := LPalette.Text;
  Font.Color := FTextColor;
  Invalidate;
end;

{ TDCFlexDateEdit }

constructor TDCFlexDateEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 140;
  Height := 28;
  TabStop := True;
  Font.Name := 'Segoe UI';
  Font.Size := 9;
  FDate := System.SysUtils.Date;
  FThemeMode := dtmLight;
  FThemePalette := DCFlexLightPalette;
  FAccentColor := FThemePalette.Accent;
  FBackColor := FThemePalette.InputBack;
  FBorderColor := FThemePalette.InputBorder;
  FTextColor := FThemePalette.Text;
end;

destructor TDCFlexDateEdit.Destroy;
begin
  CloseDropDown;
  inherited Destroy;
end;

procedure TDCFlexDateEdit.ApplyThemePalette(const APalette: TDCFlexThemePalette);
begin
  FThemeMode := dtmCustom;
  FThemePalette := APalette;
  FAccentColor := APalette.Accent;
  FBackColor := APalette.InputBack;
  FBorderColor := APalette.InputBorder;
  FTextColor := APalette.Text;
  Font.Color := FTextColor;
  Invalidate;
end;

procedure TDCFlexDateEdit.CalendarClick(Sender: TObject);
begin
  if Sender is TMonthCalendar then
  begin
    Date := TMonthCalendar(Sender).Date;
    CloseDropDown;
    SetFocus;
  end;
end;

procedure TDCFlexDateEdit.CalendarMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  LHitInfo: TMCHitTestInfo;
  LHit: DWORD;
begin
  if (Button <> mbLeft) or (not (Sender is TMonthCalendar)) then
    Exit;

  FillChar(LHitInfo, SizeOf(LHitInfo), 0);
  LHitInfo.cbSize := SizeOf(LHitInfo);
  LHitInfo.pt := Point(X, Y);
  LHit := MonthCal_HitTest(TMonthCalendar(Sender).Handle, LHitInfo);

  if (LHit and MCHT_CALENDARDATE) = MCHT_CALENDARDATE then
  begin
    Date := TMonthCalendar(Sender).Date;
    CloseDropDown;
    SetFocus;
  end;
end;

procedure TDCFlexDateEdit.Change;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TDCFlexDateEdit.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  if not Enabled then
    CloseDropDown;
  Invalidate;
end;

procedure TDCFlexDateEdit.CMEnter(var Message: TCMGotFocus);
begin
  inherited;
  FEditText := '';
  Invalidate;
end;

procedure TDCFlexDateEdit.CMExit(var Message: TCMLostFocus);
var
  LValue: TDateTime;
begin
  inherited;
  if (FEditText <> '') and TryStrToDate(FEditText, LValue) then
    Date := LValue;
  FEditText := '';
  Invalidate;
end;

procedure TDCFlexDateEdit.CloseDropDown;
begin
  if Assigned(FDropDown) then
  begin
    FDropDown.Release;
    FDropDown := nil;
  end;
end;

procedure TDCFlexDateEdit.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  FMouseOver := True;
  Invalidate;
end;

procedure TDCFlexDateEdit.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  FMouseOver := False;
  Invalidate;
end;

procedure TDCFlexDateEdit.DropDown;
const
  DC_DATE_DROPDOWN_WIDTH = 270;
  DC_DATE_DROPDOWN_HEIGHT = 220;
var
  P: TPoint;
  LWorkArea: TRect;
  LCalendar: TDCFlexDateCalendar;
begin
  if not Enabled then
    Exit;

  if Assigned(FDropDown) then
  begin
    CloseDropDown;
    Exit;
  end;

  FDropDown := TForm.CreateNew(Self);
  FDropDown.BorderStyle := bsNone;
  FDropDown.Position := poDesigned;
  FDropDown.FormStyle := fsStayOnTop;
  FDropDown.Color := FBorderColor;
  FDropDown.OnDeactivate := DropDownDeactivate;
  DCFlexApplyNativeDarkMode(FDropDown, FThemeMode = dtmDark);

  LCalendar := TDCFlexDateCalendar.Create(FDropDown);
  LCalendar.Parent := FDropDown;
  LCalendar.Date := FDate;
  LCalendar.OnMouseUp := CalendarMouseUp;
  LCalendar.SetBounds(1, 1, DC_DATE_DROPDOWN_WIDTH - 2,
    DC_DATE_DROPDOWN_HEIGHT - 2);
  LCalendar.Font.Color := FThemePalette.Text;
  LCalendar.CalColors.BackColor := FThemePalette.PopupBack;
  LCalendar.CalColors.MonthBackColor := FThemePalette.PopupBack;
  LCalendar.CalColors.TextColor := FThemePalette.Text;
  LCalendar.CalColors.TitleBackColor := FThemePalette.SurfaceAlt;
  LCalendar.CalColors.TitleTextColor := FThemePalette.Text;
  LCalendar.CalColors.TrailingTextColor := FThemePalette.MutedText;
  DCFlexApplyNativeDarkMode(LCalendar, FThemeMode = dtmDark);

  P := ClientToScreen(Point(0, Height));
  SystemParametersInfo(SPI_GETWORKAREA, 0, @LWorkArea, 0);
  if P.Y + DC_DATE_DROPDOWN_HEIGHT > LWorkArea.Bottom then
    P := ClientToScreen(Point(0, -DC_DATE_DROPDOWN_HEIGHT));
  if P.X + DC_DATE_DROPDOWN_WIDTH > LWorkArea.Right then
    P.X := LWorkArea.Right - DC_DATE_DROPDOWN_WIDTH;
  if P.X < LWorkArea.Left then
    P.X := LWorkArea.Left;

  FDropDown.SetBounds(P.X, P.Y, DC_DATE_DROPDOWN_WIDTH,
    DC_DATE_DROPDOWN_HEIGHT);
  FDropDown.Show;
  LCalendar.SetFocus;
end;

procedure TDCFlexDateEdit.DropDownDeactivate(Sender: TObject);
begin
  CloseDropDown;
end;

procedure TDCFlexDateEdit.KeyDown(var Key: Word; Shift: TShiftState);
var
  LValue: TDateTime;
begin
  inherited KeyDown(Key, Shift);
  if not Enabled then
    Exit;

  case Key of
    VK_BACK:
      begin
        if FEditText <> '' then
        begin
          Delete(FEditText, Length(FEditText), 1);
          Invalidate;
        end;
        Key := 0;
      end;
    VK_DELETE, VK_ESCAPE:
      begin
        FEditText := '';
        Invalidate;
        Key := 0;
      end;
    VK_RETURN:
      begin
        if (FEditText <> '') and TryStrToDate(FEditText, LValue) then
          Date := LValue;
        FEditText := '';
        Invalidate;
        Key := 0;
      end;
    VK_DOWN:
      begin
        DropDown;
        Key := 0;
      end;
    VK_UP:
      begin
        Date := FDate - 1;
        Key := 0;
      end;
    VK_RIGHT:
      begin
        Date := FDate + 1;
        Key := 0;
      end;
    VK_LEFT:
      begin
        Date := FDate - 1;
        Key := 0;
      end;
  end;
end;

procedure TDCFlexDateEdit.KeyPress(var Key: Char);
var
  LDigits: string;
  LText: string;
  LValue: TDateTime;
  I: Integer;
begin
  inherited KeyPress(Key);
  if not Enabled then
  begin
    Key := #0;
    Exit;
  end;

  if Key = #13 then
  begin
    Key := #0;
    Exit;
  end;

  if (Key >= '0') and (Key <= '9') then
  begin
    LDigits := '';
    for I := 1 to Length(FEditText) do
      if (FEditText[I] >= '0') and (FEditText[I] <= '9') then
        LDigits := LDigits + FEditText[I];
    if Length(LDigits) >= 8 then
      LDigits := '';
    LDigits := LDigits + Key;

    LText := Copy(LDigits, 1, 2);
    if Length(LDigits) > 2 then
      LText := LText + '/' + Copy(LDigits, 3, 2);
    if Length(LDigits) > 4 then
      LText := LText + '/' + Copy(LDigits, 5, 4);
    FEditText := LText;

    if (Length(LDigits) = 8) and TryStrToDate(FEditText, LValue) then
      Date := LValue;
    Invalidate;
    Key := #0;
  end
  else if (Key = '/') and (Length(FEditText) < 10) then
  begin
    FEditText := FEditText + Key;
    Invalidate;
    Key := #0;
  end
  else
    Key := #0;
end;

procedure TDCFlexDateEdit.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if (Button = mbLeft) and Enabled then
  begin
    SetFocus;
    if X >= Width - 28 then
      DropDown;
  end;
end;

procedure TDCFlexDateEdit.Paint;
var
  R: TRect;
  LTextRect: TRect;
  LArrowX: Integer;
  LArrowY: Integer;
  LBorder: TColor;
  LDisplayText: string;
  LBack: TColor;
  LText: TColor;
begin
  R := ClientRect;
  if Enabled then
  begin
    LBack := FBackColor;
    LText := FTextColor;
  end
  else
  begin
    LBack := FThemePalette.Disabled;
    LText := FThemePalette.DisabledText;
  end;

  Canvas.Brush.Color := LBack;
  Canvas.FillRect(R);
  LBorder := FBorderColor;
  if Focused and Enabled then
    LBorder := FAccentColor;
  Canvas.Pen.Color := LBorder;
  Canvas.Brush.Style := bsClear;
  Canvas.Rectangle(R);

  Canvas.Font.Assign(Font);
  Canvas.Font.Color := LText;
  LTextRect := Rect(8, 0, Width - 42, Height);
  if Focused and (FEditText <> '') then
    LDisplayText := FEditText
  else
    LDisplayText := FormatDateTime('dd/mm/yyyy', FDate);
  DrawText(Canvas.Handle, PChar(LDisplayText), -1,
    LTextRect, DT_SINGLELINE or DT_VCENTER or DT_END_ELLIPSIS);

  Canvas.Pen.Color := LText;
  Canvas.Rectangle(Rect(Width - 36, (Height - 12) div 2, Width - 24, (Height - 12) div 2 + 12));
  Canvas.MoveTo(Width - 34, (Height - 12) div 2 + 3);
  Canvas.LineTo(Width - 26, (Height - 12) div 2 + 3);
  Canvas.MoveTo(Width - 34, (Height - 12) div 2 + 6);
  Canvas.LineTo(Width - 26, (Height - 12) div 2 + 6);

  LArrowX := Width - 17;
  LArrowY := Height div 2;
  Canvas.Pen.Color := LText;
  Canvas.Pen.Width := 2;
  Canvas.MoveTo(LArrowX, LArrowY - 2);
  Canvas.LineTo(LArrowX + 4, LArrowY + 2);
  Canvas.LineTo(LArrowX + 8, LArrowY - 2);
  Canvas.Pen.Width := 1;
  Canvas.Brush.Style := bsSolid;
end;

procedure TDCFlexDateEdit.SetDate(const Value: TDateTime);
begin
  if Trunc(FDate) <> Trunc(Value) then
  begin
    FDate := Trunc(Value);
    FEditText := '';
    Invalidate;
    Change;
  end;
end;

procedure TDCFlexDateEdit.SetThemeMode(const Value: TDCFlexThemeMode);
var
  LPalette: TDCFlexThemePalette;
begin
  if FThemeMode = Value then
    Exit;
  FThemeMode := Value;
  if FThemeMode = dtmCustom then
    Exit;

  LPalette := DCFlexPaletteForMode(FThemeMode);
  FThemePalette := LPalette;
  FAccentColor := LPalette.Accent;
  FBackColor := LPalette.InputBack;
  FBorderColor := LPalette.InputBorder;
  FTextColor := LPalette.Text;
  Font.Color := FTextColor;
  Invalidate;
end;

procedure TDCFlexDateEdit.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  Message.Result := Message.Result or DLGC_WANTARROWS or DLGC_WANTCHARS;
end;

{ TDCFlexTimeEdit }

constructor TDCFlexTimeEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 86;
  Height := 28;
  TabStop := True;
  Font.Name := 'Segoe UI';
  Font.Size := 9;
  FTime := EncodeTime(8, 0, 0, 0);
  FThemeMode := dtmLight;
  FThemePalette := DCFlexLightPalette;
  FAccentColor := FThemePalette.Accent;
  FBackColor := FThemePalette.InputBack;
  FBorderColor := FThemePalette.InputBorder;
  FTextColor := FThemePalette.Text;
end;

procedure TDCFlexTimeEdit.ApplyThemePalette(const APalette: TDCFlexThemePalette);
begin
  FThemeMode := dtmCustom;
  FThemePalette := APalette;
  FAccentColor := APalette.Accent;
  FBackColor := APalette.InputBack;
  FBorderColor := APalette.InputBorder;
  FTextColor := APalette.Text;
  Font.Color := FTextColor;
  Invalidate;
end;

procedure TDCFlexTimeEdit.Change;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TDCFlexTimeEdit.CMEnter(var Message: TCMGotFocus);
begin
  inherited;
  FEditText := '';
  Invalidate;
end;

procedure TDCFlexTimeEdit.CMExit(var Message: TCMLostFocus);
var
  LValue: TDateTime;
begin
  inherited;
  if (FEditText <> '') and TryStrToTime(FEditText, LValue) then
    Time := LValue;
  FEditText := '';
  Invalidate;
end;

procedure TDCFlexTimeEdit.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  FMouseOver := True;
  Invalidate;
end;

procedure TDCFlexTimeEdit.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  FMouseOver := False;
  Invalidate;
end;

procedure TDCFlexTimeEdit.IncrementMinutes(AMinutes: Integer);
var
  LTime: TDateTime;
begin
  if AMinutes >= 0 then
    LTime := Frac(FTime + EncodeTime(0, AMinutes, 0, 0))
  else
    LTime := Frac(FTime - EncodeTime(0, Abs(AMinutes), 0, 0));
  if LTime < 0 then
    LTime := LTime + 1;
  Time := LTime;
end;

procedure TDCFlexTimeEdit.KeyDown(var Key: Word; Shift: TShiftState);
var
  LValue: TDateTime;
begin
  inherited KeyDown(Key, Shift);
  case Key of
    VK_BACK:
      begin
        if FEditText <> '' then
        begin
          Delete(FEditText, Length(FEditText), 1);
          Invalidate;
        end;
        Key := 0;
      end;
    VK_DELETE, VK_ESCAPE:
      begin
        FEditText := '';
        Invalidate;
        Key := 0;
      end;
    VK_RETURN:
      begin
        if (FEditText <> '') and TryStrToTime(FEditText, LValue) then
          Time := LValue;
        FEditText := '';
        Invalidate;
        Key := 0;
      end;
    VK_UP:
      begin
        IncrementMinutes(15);
        Key := 0;
      end;
    VK_DOWN:
      begin
        IncrementMinutes(-15);
        Key := 0;
      end;
  end;
end;

procedure TDCFlexTimeEdit.KeyPress(var Key: Char);
var
  LDigits: string;
  LText: string;
  LValue: TDateTime;
  I: Integer;
begin
  inherited KeyPress(Key);

  if Key = #13 then
  begin
    Key := #0;
    Exit;
  end;

  if (Key >= '0') and (Key <= '9') then
  begin
    LDigits := '';
    for I := 1 to Length(FEditText) do
      if (FEditText[I] >= '0') and (FEditText[I] <= '9') then
        LDigits := LDigits + FEditText[I];
    if Length(LDigits) >= 4 then
      LDigits := '';
    LDigits := LDigits + Key;

    LText := Copy(LDigits, 1, 2);
    if Length(LDigits) > 2 then
      LText := LText + ':' + Copy(LDigits, 3, 2);
    FEditText := LText;

    if (Length(LDigits) = 4) and TryStrToTime(FEditText, LValue) then
      Time := LValue;
    Invalidate;
    Key := #0;
  end
  else if (Key = ':') and (Pos(':', FEditText) = 0) and (Length(FEditText) > 0) then
  begin
    FEditText := FEditText + Key;
    Invalidate;
    Key := #0;
  end
  else
    Key := #0;
end;

procedure TDCFlexTimeEdit.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if (Button = mbLeft) and Enabled then
  begin
    SetFocus;
    if X >= Width - 22 then
    begin
      if Y < Height div 2 then
        IncrementMinutes(15)
      else
        IncrementMinutes(-15);
    end;
  end;
end;

procedure TDCFlexTimeEdit.Paint;
var
  R: TRect;
  LTextRect: TRect;
  LBorder: TColor;
  LDisplayText: string;
begin
  R := ClientRect;
  Canvas.Brush.Color := FBackColor;
  Canvas.FillRect(R);
  LBorder := FBorderColor;
  if Focused and Enabled then
    LBorder := FAccentColor;
  Canvas.Pen.Color := LBorder;
  Canvas.Brush.Style := bsClear;
  Canvas.Rectangle(R);

  Canvas.Font.Assign(Font);
  Canvas.Font.Color := FTextColor;
  LTextRect := Rect(8, 0, Width - 24, Height);
  if Focused and (FEditText <> '') then
    LDisplayText := FEditText
  else
    LDisplayText := FormatDateTime('hh:nn', FTime);
  DrawText(Canvas.Handle, PChar(LDisplayText), -1,
    LTextRect, DT_SINGLELINE or DT_VCENTER or DT_END_ELLIPSIS);

  Canvas.Pen.Color := FThemePalette.InputBorder;
  Canvas.MoveTo(Width - 22, 1);
  Canvas.LineTo(Width - 22, Height - 1);
  Canvas.MoveTo(Width - 22, Height div 2);
  Canvas.LineTo(Width - 1, Height div 2);

  Canvas.Pen.Color := FTextColor;
  Canvas.MoveTo(Width - 15, Height div 2 - 5);
  Canvas.LineTo(Width - 11, Height div 2 - 9);
  Canvas.LineTo(Width - 7, Height div 2 - 5);
  Canvas.MoveTo(Width - 15, Height div 2 + 5);
  Canvas.LineTo(Width - 11, Height div 2 + 9);
  Canvas.LineTo(Width - 7, Height div 2 + 5);
  Canvas.Brush.Style := bsSolid;
end;

procedure TDCFlexTimeEdit.SetThemeMode(const Value: TDCFlexThemeMode);
var
  LPalette: TDCFlexThemePalette;
begin
  if FThemeMode = Value then
    Exit;
  FThemeMode := Value;
  if FThemeMode = dtmCustom then
    Exit;

  LPalette := DCFlexPaletteForMode(FThemeMode);
  FThemePalette := LPalette;
  FAccentColor := LPalette.Accent;
  FBackColor := LPalette.InputBack;
  FBorderColor := LPalette.InputBorder;
  FTextColor := LPalette.Text;
  Font.Color := FTextColor;
  Invalidate;
end;

procedure TDCFlexTimeEdit.SetTime(const Value: TDateTime);
begin
  if Frac(FTime) <> Frac(Value) then
  begin
    FTime := Frac(Value);
    FEditText := '';
    Invalidate;
    Change;
  end;
end;

procedure TDCFlexTimeEdit.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  Message.Result := Message.Result or DLGC_WANTARROWS or DLGC_WANTCHARS;
end;

{ TDCFlexComboBox }

constructor TDCFlexComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csCaptureMouse, csClickEvents, csDoubleClicks, csOpaque];
  Width := 160;
  Height := 24;
  TabStop := True;
  Font.Name := 'Segoe UI';
  Font.Size := 9;
  FItems := TStringList.Create;
  FItems.OnChange := ItemsChanged;
  FItemIndex := -1;
  FText := '';
  FDropDownCount := 8;
  FStyle := csDropDownList;
  FThemeMode := dtmLight;
  FAccentColor := $00F86F62;
  FBackColor := clWhite;
  FHoverColor := $00F1F5F9;
  FBorderColor := $00D0D7DE;
  FTextColor := clBlack;
  FDisabledColor := $00F0F0F0;
  FDisabledTextColor := clGrayText;
end;

destructor TDCFlexComboBox.Destroy;
begin
  CloseDropDown;
  FItems.Free;
  inherited Destroy;
end;

procedure TDCFlexComboBox.ApplyThemePalette(const APalette: TDCFlexThemePalette);
begin
  FThemeMode := dtmCustom;
  FAccentColor := APalette.Accent;
  FBackColor := APalette.InputBack;
  FHoverColor := APalette.Hover;
  FBorderColor := APalette.InputBorder;
  FTextColor := APalette.Text;
  FDisabledColor := APalette.Disabled;
  FDisabledTextColor := APalette.DisabledText;
  Font.Color := FTextColor;
  Invalidate;
end;

procedure TDCFlexComboBox.Change;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TDCFlexComboBox.CloseDropDown;
begin
  if Assigned(FDropDown) then
  begin
    FDropDown.Release;
    FDropDown := nil;
    FListBox := nil;
  end;
end;

procedure TDCFlexComboBox.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TDCFlexComboBox.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TDCFlexComboBox.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TDCFlexComboBox.DropDown;
var
  P: TPoint;
  LItemHeight: Integer;
  LVisibleCount: Integer;
  LHeight: Integer;
begin
  if Assigned(FDropDown) then
  begin
    CloseDropDown;
    Exit;
  end;

  if FItems.Count = 0 then
    Exit;

  LItemHeight := Abs(Font.Height) + 8;
  if LItemHeight < 22 then
    LItemHeight := 22;

  LVisibleCount := FItems.Count;
  if LVisibleCount > FDropDownCount then
    LVisibleCount := FDropDownCount;
  if LVisibleCount < 1 then
    LVisibleCount := 1;
  LHeight := LVisibleCount * LItemHeight + 2;

  FDropDown := TForm.CreateNew(Self);
  FDropDown.BorderStyle := bsNone;
  FDropDown.Position := poDesigned;
  FDropDown.FormStyle := fsStayOnTop;
  FDropDown.Color := FBorderColor;
  FDropDown.OnDeactivate := DropDownDeactivate;

  FListBox := TDCFlexComboListBox.Create(FDropDown);
  FListBox.Parent := FDropDown;
  FListBox.Align := alNone;
  FListBox.BorderStyle := bsNone;
  FListBox.Style := lbOwnerDrawFixed;
  FListBox.ItemHeight := LItemHeight;
  FListBox.Items.Assign(FItems);
  FListBox.ItemIndex := FItemIndex;
  FListBox.Color := FBackColor;
  FListBox.Font.Assign(Font);
  FListBox.Font.Color := FTextColor;
  FListBox.OnDrawItem := ListBoxDrawItem;
  FListBox.OnMouseUp := ListBoxMouseUp;
  FListBox.OnKeyDown := ListBoxKeyDown;

  P := ClientToScreen(Point(0, Height));
  FDropDown.SetBounds(P.X, P.Y, Width, LHeight);
  FListBox.SetBounds(1, 1, FDropDown.ClientWidth - 2, FDropDown.ClientHeight - 2);
  FDropDown.Show;
  FListBox.SetFocus;
end;

procedure TDCFlexComboBox.DropDownDeactivate(Sender: TObject);
begin
  CloseDropDown;
end;

function TDCFlexComboBox.GetText: string;
begin
  if FStyle = csDropDown then
    Result := FText
  else if (FItemIndex >= 0) and (FItemIndex < FItems.Count) then
    Result := FItems[FItemIndex]
  else
    Result := '';
end;

function TDCFlexComboBox.GetItems: TStrings;
begin
  Result := FItems;
end;

procedure TDCFlexComboBox.ItemsChanged(Sender: TObject);
begin
  if FItemIndex >= FItems.Count then
    FItemIndex := FItems.Count - 1;
  Invalidate;
end;

procedure TDCFlexComboBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if not Enabled then
    Exit;

  case Key of
    VK_BACK:
      begin
        if (FStyle = csDropDown) and (FText <> '') then
        begin
          Delete(FText, Length(FText), 1);
          FItemIndex := -1;
          Invalidate;
          Change;
        end;
        Key := 0;
      end;
    VK_DELETE:
      begin
        if FStyle = csDropDown then
        begin
          FText := '';
          FItemIndex := -1;
          Invalidate;
          Change;
        end;
        Key := 0;
      end;
    VK_RETURN, VK_SPACE, VK_DOWN:
      begin
        DropDown;
        Key := 0;
      end;
    VK_UP:
      begin
        if FItemIndex > 0 then
          SetItemIndex(FItemIndex - 1);
        Key := 0;
      end;
    VK_ESCAPE:
      begin
        CloseDropDown;
        Key := 0;
      end;
  end;
end;

procedure TDCFlexComboBox.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  if (FStyle = csDropDown) and Enabled and (Key >= #32) then
  begin
    FText := FText + Key;
    FItemIndex := FItems.IndexOf(FText);
    Invalidate;
    Change;
    Key := #0;
  end;
end;

procedure TDCFlexComboBox.ListBoxDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  LBack: TColor;
  LText: TColor;
begin
  if not Assigned(FListBox) then
    Exit;

  LBack := FBackColor;
  LText := FTextColor;
  if odSelected in State then
  begin
    LBack := FAccentColor;
    LText := clWhite;
  end;

  FListBox.Canvas.Brush.Color := LBack;
  FListBox.Canvas.FillRect(Rect);
  FListBox.Canvas.Font.Assign(Font);
  FListBox.Canvas.Font.Color := LText;
  InflateRect(Rect, -8, 0);
  DrawText(FListBox.Canvas.Handle, PChar(FListBox.Items[Index]),
    Length(FListBox.Items[Index]), Rect,
    DT_SINGLELINE or DT_VCENTER or DT_END_ELLIPSIS);
end;

procedure TDCFlexComboBox.ListBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  LForm: TCustomForm;
begin
  case Key of
    VK_RETURN:
      begin
        if Assigned(FListBox) then
          SelectListIndex(FListBox.ItemIndex);
        Key := 0;
      end;
    VK_ESCAPE:
      begin
        CloseDropDown;
        SetFocus;
        Key := 0;
      end;
    VK_TAB:
      begin
        if Assigned(FListBox) and (FListBox.ItemIndex >= 0) then
          SetItemIndex(FListBox.ItemIndex);
        CloseDropDown;
        LForm := GetParentForm(Self);
        if Assigned(LForm) then
          LForm.Perform(CM_DIALOGKEY, Key, 0)
        else
          SetFocus;
        Key := 0;
      end;
  end;
end;

procedure TDCFlexComboBox.ListBoxMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and Assigned(FListBox) then
    SelectListIndex(FListBox.ItemIndex);
end;

procedure TDCFlexComboBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if (Button = mbLeft) and Enabled then
  begin
    SetFocus;
    DropDown;
  end;
end;

procedure TDCFlexComboBox.Paint;
var
  R: TRect;
  LBack: TColor;
  LBorder: TColor;
  LText: TColor;
  LArrowX: Integer;
  LArrowY: Integer;
  LTextRect: TRect;
begin
  R := ClientRect;
  if Enabled then
  begin
    LBack := FBackColor;
    LText := FTextColor;
  end
  else
  begin
    LBack := FDisabledColor;
    LText := FDisabledTextColor;
  end;

  LBorder := FBorderColor;
  if (Focused or Assigned(FDropDown)) and Enabled then
    LBorder := FAccentColor;

  Canvas.Brush.Color := LBack;
  Canvas.Pen.Color := LBorder;
  Canvas.Rectangle(R);

  LArrowX := R.Right - 16;
  LArrowY := Height div 2;
  Canvas.Pen.Color := LText;
  Canvas.Pen.Width := 2;
  Canvas.MoveTo(LArrowX, LArrowY - 2);
  Canvas.LineTo(LArrowX + 4, LArrowY + 2);
  Canvas.LineTo(LArrowX + 8, LArrowY - 2);
  Canvas.Pen.Width := 1;

  Canvas.Font.Assign(Font);
  Canvas.Font.Color := LText;
  Canvas.Brush.Style := bsClear;
  LTextRect := Rect(8, 0, R.Right - 24, R.Bottom);
  DrawText(Canvas.Handle, PChar(Text), Length(Text), LTextRect,
    DT_SINGLELINE or DT_VCENTER or DT_END_ELLIPSIS);
  Canvas.Brush.Style := bsSolid;
end;

procedure TDCFlexComboBox.SelectListIndex(AIndex: Integer);
begin
  SetItemIndex(AIndex);
  CloseDropDown;
  SetFocus;
end;

procedure TDCFlexComboBox.SetAccentColor(const Value: TColor);
begin
  if FAccentColor <> Value then
  begin
    FAccentColor := Value;
    Invalidate;
  end;
end;

procedure TDCFlexComboBox.SetBackColor(const Value: TColor);
begin
  if FBackColor <> Value then
  begin
    FBackColor := Value;
    Invalidate;
  end;
end;

procedure TDCFlexComboBox.SetBorderColor(const Value: TColor);
begin
  if FBorderColor <> Value then
  begin
    FBorderColor := Value;
    Invalidate;
  end;
end;

procedure TDCFlexComboBox.SetDisabledColor(const Value: TColor);
begin
  if FDisabledColor <> Value then
  begin
    FDisabledColor := Value;
    Invalidate;
  end;
end;

procedure TDCFlexComboBox.SetDisabledTextColor(const Value: TColor);
begin
  if FDisabledTextColor <> Value then
  begin
    FDisabledTextColor := Value;
    Invalidate;
  end;
end;

procedure TDCFlexComboBox.SetDropDownCount(const Value: Integer);
begin
  if Value < 1 then
    FDropDownCount := 1
  else
    FDropDownCount := Value;
end;

procedure TDCFlexComboBox.SetHoverColor(const Value: TColor);
begin
  if FHoverColor <> Value then
  begin
    FHoverColor := Value;
    Invalidate;
  end;
end;

procedure TDCFlexComboBox.SetItemIndex(const Value: Integer);
var
  LNewIndex: Integer;
begin
  LNewIndex := Value;
  if LNewIndex < -1 then
    LNewIndex := -1;
  if LNewIndex >= FItems.Count then
    LNewIndex := FItems.Count - 1;

  if FItemIndex <> LNewIndex then
  begin
    FItemIndex := LNewIndex;
    if (FStyle = csDropDown) and (FItemIndex >= 0) and (FItemIndex < FItems.Count) then
      FText := FItems[FItemIndex];
    Invalidate;
    Change;
  end;
end;

procedure TDCFlexComboBox.SetItems(const Value: TStrings);
begin
  FItems.Assign(Value);
  ItemsChanged(FItems);
end;

procedure TDCFlexComboBox.SetText(const Value: string);
var
  LNewIndex: Integer;
begin
  LNewIndex := FItems.IndexOf(Value);
  if (FText <> Value) or (FItemIndex <> LNewIndex) then
  begin
    FText := Value;
    FItemIndex := LNewIndex;
    Invalidate;
    Change;
  end;
end;

procedure TDCFlexComboBox.SetTextColor(const Value: TColor);
begin
  if FTextColor <> Value then
  begin
    FTextColor := Value;
    Font.Color := Value;
    Invalidate;
  end;
end;

procedure TDCFlexComboBox.SetThemeMode(const Value: TDCFlexThemeMode);
var
  LPalette: TDCFlexThemePalette;
begin
  if FThemeMode = Value then
    Exit;

  FThemeMode := Value;
  if FThemeMode = dtmCustom then
    Exit;

  LPalette := DCFlexPaletteForMode(FThemeMode);
  FAccentColor := LPalette.Accent;
  FBackColor := LPalette.InputBack;
  FHoverColor := LPalette.Hover;
  FBorderColor := LPalette.InputBorder;
  FTextColor := LPalette.Text;
  FDisabledColor := LPalette.Disabled;
  FDisabledTextColor := LPalette.DisabledText;
  Font.Color := FTextColor;
  Invalidate;
end;

procedure TDCFlexComboBox.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  Message.Result := Message.Result or DLGC_WANTARROWS or DLGC_WANTCHARS;
end;

procedure TDCFlexComboBox.WMKillFocus(var Message: TWMKillFocus);
begin
  inherited;
  Invalidate;
end;

procedure TDCFlexComboBox.WMSetFocus(var Message: TWMSetFocus);
begin
  inherited;
  Invalidate;
end;

constructor TDCFlexColorPicker.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAllowCustomColor := True;
  FSelected := clBlack;
  FPaletteLoaded := False;
  FPaletteLanguage := cplEnglish;
  FThemeMode := dtmLight;
  FThemePalette := DCFlexLightPalette;
  Style := csOwnerDrawFixed;
  ItemHeight := 22;
  Height := 24;
  Color := FThemePalette.InputBack;
  Font.Color := FThemePalette.Text;
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

procedure TDCFlexColorPicker.ApplyThemePalette(
  const APalette: TDCFlexThemePalette);
begin
  FThemeMode := dtmCustom;
  FThemePalette := APalette;
  Color := APalette.InputBack;
  Font.Color := APalette.Text;
  Invalidate;
end;

procedure ApplyDCFlexThemeToWindowHandle(AHandle: HWND; ADark: Boolean);
type
  TSetWindowThemeFunc = function(hwnd: HWND; pszSubAppName: PWideChar;
    pszSubIdList: PWideChar): Longint; stdcall;
var
  LUxTheme: HMODULE;
  LSetWindowTheme: TSetWindowThemeFunc;
  LThemeName: WideString;
begin
  if AHandle = 0 then
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
      LSetWindowTheme(AHandle, PWideChar(LThemeName), nil);
  finally
    FreeLibrary(LUxTheme);
  end;
end;

procedure TDCFlexColorPicker.ApplyDropDownTheme;
var
  LInfo: TComboBoxInfo;
begin
  if not HandleAllocated then
    Exit;

  FillChar(LInfo, SizeOf(LInfo), 0);
  LInfo.cbSize := SizeOf(LInfo);
  if GetComboBoxInfo(Handle, LInfo) then
    ApplyDCFlexThemeToWindowHandle(LInfo.hwndList, FThemeMode = dtmDark);
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

procedure TDCFlexColorPicker.CNCommand(var Message: TWMCommand);
begin
  inherited;
  if Message.NotifyCode = CBN_DROPDOWN then
    ApplyDropDownTheme;
end;

procedure TDCFlexColorPicker.DrawClosedState;
var
  R: TRect;
  SwatchRect: TRect;
  TextRect: TRect;
  LColor: TColor;
  LText: string;
  LBorderColor: TColor;
  LArrowX: Integer;
  LArrowY: Integer;
begin
  if not HandleAllocated then
    Exit;

  R := ClientRect;
  Canvas.Brush.Style := bsSolid;
  Canvas.Brush.Color := FThemePalette.InputBack;
  Canvas.FillRect(R);

  if Focused then
    LBorderColor := FThemePalette.Accent
  else
    LBorderColor := FThemePalette.InputBorder;
  Canvas.Pen.Color := LBorderColor;
  Canvas.Brush.Style := bsClear;
  Canvas.Rectangle(R);

  LArrowX := R.Right - 16;
  LArrowY := Height div 2;
  Canvas.Pen.Color := FThemePalette.Text;
  Canvas.Pen.Width := 2;
  Canvas.MoveTo(LArrowX, LArrowY - 2);
  Canvas.LineTo(LArrowX + 4, LArrowY + 2);
  Canvas.LineTo(LArrowX + 8, LArrowY - 2);
  Canvas.Pen.Width := 1;

  LColor := Selected;
  LText := DisplayText(LColor);

  SwatchRect := R;
  SwatchRect.Left := SwatchRect.Left + 8;
  SwatchRect.Top := SwatchRect.Top + ((SwatchRect.Bottom - SwatchRect.Top) - 14) div 2;
  SwatchRect.Right := SwatchRect.Left + 24;
  SwatchRect.Bottom := SwatchRect.Top + 14;

  Canvas.Brush.Style := bsSolid;
  if LColor = clNone then
    Canvas.Brush.Color := FThemePalette.InputBack
  else
    Canvas.Brush.Color := LColor;
  Canvas.Pen.Color := FThemePalette.InputBorder;
  Canvas.Rectangle(SwatchRect);

  if LColor = clNone then
  begin
    Canvas.Pen.Color := FThemePalette.Danger;
    Canvas.MoveTo(SwatchRect.Left + 2, SwatchRect.Bottom - 2);
    Canvas.LineTo(SwatchRect.Right - 2, SwatchRect.Top + 2);
  end;

  TextRect := R;
  TextRect.Left := SwatchRect.Right + 8;
  TextRect.Right := R.Right - 24;
  Canvas.Brush.Style := bsClear;
  Canvas.Font.Assign(Font);
  Canvas.Font.Color := FThemePalette.Text;
  DrawText(Canvas.Handle, PChar(LText), Length(LText), TextRect,
    DT_LEFT or DT_VCENTER or DT_SINGLELINE or DT_END_ELLIPSIS or DT_NOPREFIX);
  Canvas.Brush.Style := bsSolid;
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
    Canvas.Brush.Color := FThemePalette.Selection;
  end
  else
  begin
    Canvas.Brush.Style := bsSolid;
    Canvas.Brush.Color := FThemePalette.InputBack;
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
  Canvas.Pen.Color := FThemePalette.InputBorder;
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
    Canvas.Font.Color := FThemePalette.SelectionText
  else
    Canvas.Font.Color := FThemePalette.Text;
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
    AddColorItem(PaletteText('Indigo', #205 + 'ndigo'), RGB(99, 102, 241));
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

procedure TDCFlexColorPicker.SetThemeMode(const Value: TDCFlexThemeMode);
begin
  if FThemeMode = Value then
    Exit;

  FThemeMode := Value;
  if FThemeMode <> dtmCustom then
    FThemePalette := DCFlexPaletteForMode(FThemeMode);
  Color := FThemePalette.InputBack;
  Font.Color := FThemePalette.Text;
  if HandleAllocated then
    DCFlexApplyNativeDarkMode(Self, FThemeMode = dtmDark);
  Invalidate;
end;

procedure TDCFlexColorPicker.SetSelected(const Value: TColor);
begin
  FSelected := Value;
  ApplySelectedIndex;
  Invalidate;
end;

procedure TDCFlexColorPicker.WMPaint(var Message: TWMPaint);
begin
  inherited;
  DrawClosedState;
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
  Color := FButton.FThemePalette.PopupBack;
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
  Canvas.Brush.Color := FButton.FThemePalette.PopupBack;
  Canvas.FillRect(ClientRect);
  Canvas.Pen.Color := FButton.FThemePalette.Border;
  Canvas.Rectangle(ClientRect);

  Canvas.Font.Assign(Font);
  Canvas.Font.Color := FButton.FThemePalette.Text;
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
    Canvas.Pen.Color := FButton.FThemePalette.InputBorder;
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
      Canvas.Pen.Color := FButton.FThemePalette.Accent;
      Canvas.Brush.Style := bsClear;
      InflateRect(R, -1, -1);
      Canvas.Rectangle(R);
      Canvas.Brush.Style := bsSolid;
    end;
    if I = FHotIndex then
    begin
      R := HotRect(I);
      Canvas.Pen.Color := FButton.FThemePalette.Text;
      Canvas.Brush.Style := bsClear;
      InflateRect(R, -2, -2);
      Canvas.Rectangle(R);
      Canvas.Brush.Style := bsSolid;
    end;
  end;

  R := Rect(12, FStandardTop - 18, Width - 12, FStandardTop - 2);
  Canvas.Font.Style := [fsBold];
  Canvas.Font.Size := Font.Size - 1;
  Canvas.Font.Color := FButton.FThemePalette.MutedText;
  Canvas.Brush.Style := bsClear;
  DrawText(Canvas.Handle,
    PChar(FButton.PaletteText('STANDARD', 'PADR' + #195 + 'O')), -1, R,
    DT_LEFT or DT_VCENTER or DT_SINGLELINE);
  Canvas.Font.Style := [];
  Canvas.Font.Size := Font.Size;
  Canvas.Brush.Style := bsSolid;

  for I := 0 to StandardCount - 1 do
  begin
    R := StandardRect(I);
    LColor := StandardColorAt(I);
    Canvas.Brush.Color := LColor;
    Canvas.Pen.Color := FButton.FThemePalette.InputBorder;
    Canvas.Rectangle(R);
    if (PaletteCount + I) = FHotIndex then
    begin
      R := HotRect(PaletteCount + I);
      Canvas.Pen.Color := FButton.FThemePalette.Text;
      Canvas.Brush.Style := bsClear;
      InflateRect(R, -2, -2);
      Canvas.Rectangle(R);
      Canvas.Brush.Style := bsSolid;
    end;
  end;

  R := CustomColorRect;
  Canvas.Brush.Color := FButton.FThemePalette.SurfaceAlt;
  Canvas.Pen.Color := FButton.FThemePalette.Border;
  Canvas.Rectangle(R);
  Canvas.Brush.Style := bsClear;
  Canvas.Font.Color := FButton.FThemePalette.Text;
  DrawText(Canvas.Handle,
    PChar(FButton.PaletteText('Custom color...', 'Cor personalizada...')), -1,
    R, DT_CENTER or DT_VCENTER or DT_SINGLELINE);

  R := CancelRect;
  Canvas.Brush.Style := bsSolid;
  Canvas.Brush.Color := FButton.FThemePalette.PopupBack;
  Canvas.Pen.Color := FButton.FThemePalette.Border;
  Canvas.Rectangle(R);
  Canvas.Brush.Style := bsClear;
  Canvas.Font.Color := FButton.FThemePalette.Text;
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
  FThemeMode := dtmLight;
  FThemePalette := DCFlexLightPalette;
end;

procedure TDCFlexColorPaletteButton.ApplyThemePalette(
  const APalette: TDCFlexThemePalette);
begin
  FThemeMode := dtmCustom;
  FThemePalette := APalette;
  Color := APalette.InputBack;
  FBorderColor := APalette.InputBorder;
  FHoverColor := APalette.Hover;
  Invalidate;
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

function TDCFlexColorPaletteButton.ColorText(AColor: TColor): string;
begin
  if AColor = clNone then
    Exit(PaletteText('None', 'Nenhuma'));

  Result := Format('#%.2x%.2x%.2x', [
    GetRValue(ColorToRGB(AColor)),
    GetGValue(ColorToRGB(AColor)),
    GetBValue(ColorToRGB(AColor))
  ]);
end;

function TDCFlexColorPaletteButton.DisplayText(AColor: TColor): string;
begin
  if AColor = clNone then
    Exit(PaletteText('None', 'Nenhuma'));
  if ColorToRGB(AColor) = ColorToRGB(clBlack) then
    Exit(PaletteText('Black', 'Preto'));
  if ColorToRGB(AColor) = ColorToRGB(clWhite) then
    Exit(PaletteText('White', 'Branco'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(67, 67, 67)) then
    Exit(PaletteText('Charcoal', 'Grafite'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(102, 102, 102)) then
    Exit(PaletteText('Dark Gray', 'Cinza escuro'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(153, 153, 153)) then
    Exit(PaletteText('Gray', 'Cinza'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(183, 183, 183)) then
    Exit(PaletteText('Medium Gray', 'Cinza medio'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(217, 217, 217)) then
    Exit(PaletteText('Soft Gray', 'Cinza suave'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(239, 239, 239)) then
    Exit(PaletteText('Off White', 'Branco suave'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(221, 235, 247)) then
    Exit(PaletteText('Pale Blue', 'Azul palido'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(152, 0, 0)) then
    Exit(PaletteText('Dark Red', 'Vermelho escuro'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(255, 0, 0)) then
    Exit(PaletteText('Bright Red', 'Vermelho vivo'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(255, 153, 0)) then
    Exit(PaletteText('Bright Orange', 'Laranja vivo'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(255, 255, 0)) then
    Exit(PaletteText('Bright Yellow', 'Amarelo vivo'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(0, 255, 0)) then
    Exit(PaletteText('Lime', 'Lima'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(0, 255, 255)) then
    Exit(PaletteText('Aqua', 'Aqua'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(74, 134, 232)) then
    Exit(PaletteText('Sky Blue', 'Azul ceu'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(0, 0, 255)) then
    Exit(PaletteText('Bright Blue', 'Azul vivo'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(153, 0, 255)) then
    Exit(PaletteText('Violet', 'Violeta'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(255, 0, 255)) then
    Exit(PaletteText('Magenta', 'Magenta'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(230, 184, 175)) then
    Exit(PaletteText('Dusty Rose', 'Rose suave'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(244, 204, 204)) then
    Exit(PaletteText('Soft Red', 'Vermelho suave'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(252, 229, 205)) then
    Exit(PaletteText('Soft Orange', 'Laranja suave'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(255, 242, 204)) then
    Exit(PaletteText('Soft Yellow', 'Amarelo suave'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(217, 234, 211)) then
    Exit(PaletteText('Soft Green', 'Verde suave'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(208, 224, 227)) then
    Exit(PaletteText('Soft Teal', 'Petroleo suave'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(201, 218, 248)) then
    Exit(PaletteText('Soft Blue', 'Azul suave'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(207, 226, 243)) then
    Exit(PaletteText('Light Sky', 'Azul nevoa'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(217, 210, 233)) then
    Exit(PaletteText('Soft Purple', 'Roxo suave'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(234, 209, 220)) then
    Exit(PaletteText('Soft Pink', 'Rosa suave'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(204, 65, 37)) then
    Exit(PaletteText('Burnt Red', 'Vermelho queimado'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(224, 102, 102)) then
    Exit(PaletteText('Muted Red', 'Vermelho medio'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(246, 178, 107)) then
    Exit(PaletteText('Peach', 'Pesego'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(255, 217, 102)) then
    Exit(PaletteText('Gold', 'Dourado'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(147, 196, 125)) then
    Exit(PaletteText('Sage', 'Verde folha'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(118, 165, 175)) then
    Exit(PaletteText('Steel Teal', 'Petroleo'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(109, 158, 235)) then
    Exit(PaletteText('Cornflower', 'Azul flor'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(61, 133, 198)) then
    Exit(PaletteText('Ocean Blue', 'Azul oceano'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(142, 124, 195)) then
    Exit(PaletteText('Muted Purple', 'Roxo medio'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(194, 123, 160)) then
    Exit(PaletteText('Mauve', 'Malva'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(236, 239, 243)) then
    Exit(PaletteText('Light Gray', 'Cinza claro'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(148, 163, 184)) then
    Exit(PaletteText('Gray', 'Cinza'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(80, 90, 102)) then
    Exit(PaletteText('Slate', 'Ard' + #243 + 'sia'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(37, 52, 69)) then
    Exit(PaletteText('Dark Slate', 'Ard' + #243 + 'sia escuro'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(221, 235, 255)) then
    Exit(PaletteText('Light Blue', 'Azul claro'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(59, 130, 246)) then
    Exit(PaletteText('Blue', 'Azul'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(30, 64, 175)) then
    Exit(PaletteText('Dark Blue', 'Azul escuro'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(99, 102, 241)) then
    Exit(PaletteText('Indigo', #205 + 'ndigo'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(139, 92, 246)) then
    Exit(PaletteText('Purple', 'Roxo'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(233, 221, 255)) then
    Exit(PaletteText('Lavender', 'Lavanda'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(221, 246, 229)) then
    Exit(PaletteText('Light Green', 'Verde claro'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(34, 197, 94)) then
    Exit(PaletteText('Green', 'Verde'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(22, 101, 52)) then
    Exit(PaletteText('Dark Green', 'Verde escuro'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(223, 247, 242)) then
    Exit(PaletteText('Mint', 'Menta'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(20, 184, 166)) then
    Exit(PaletteText('Teal', 'Azul petr' + #243 + 'leo'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(165, 243, 252)) then
    Exit(PaletteText('Cyan', 'Ciano'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(255, 244, 194)) then
    Exit(PaletteText('Light Yellow', 'Amarelo claro'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(250, 204, 21)) then
    Exit(PaletteText('Yellow', 'Amarelo'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(255, 235, 221)) then
    Exit(PaletteText('Soft Amber', #194 + 'mbar suave'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(245, 158, 11)) then
    Exit(PaletteText('Amber', #194 + 'mbar'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(249, 115, 22)) then
    Exit(PaletteText('Orange', 'Laranja'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(255, 127, 127)) then
    Exit(PaletteText('Coral', 'Coral'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(255, 215, 215)) then
    Exit(PaletteText('Light Red', 'Vermelho claro'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(239, 68, 68)) then
    Exit(PaletteText('Red', 'Vermelho'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(252, 225, 239)) then
    Exit(PaletteText('Light Pink', 'Rosa claro'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(236, 72, 153)) then
    Exit(PaletteText('Pink', 'Rosa'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(244, 63, 94)) then
    Exit(PaletteText('Rose', 'Rose'));
  if ColorToRGB(AColor) = ColorToRGB(RGB(120, 83, 57)) then
    Exit(PaletteText('Brown', 'Marrom'));

  Result := PaletteText('Custom ', 'Personalizada ') + ColorText(AColor);
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
  ArrowX: Integer;
  ArrowY: Integer;
  LBackColor: TColor;
  LTextRect: TRect;
  LCaption: string;
begin
  LBackColor := FThemePalette.InputBack;
  if FMouseOver then
    LBackColor := FHoverColor;
  if not Enabled then
    LBackColor := FThemePalette.Disabled;

  Canvas.Brush.Color := LBackColor;
  Canvas.Pen.Color := FBorderColor;
  Canvas.Rectangle(ClientRect);

  SwatchRect := Rect(8, 6, 28, Height - 6);
  if SwatchRect.Bottom - SwatchRect.Top < 12 then
  begin
    SwatchRect.Top := (Height - 12) div 2;
    SwatchRect.Bottom := SwatchRect.Top + 12;
  end;
  Canvas.Brush.Color := clWhite;
  Canvas.Pen.Color := FThemePalette.InputBorder;
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
  Canvas.Pen.Color := FThemePalette.MutedText;
  Canvas.Pen.Width := 2;
  Canvas.MoveTo(ArrowX, ArrowY - 2);
  Canvas.LineTo(ArrowX + 4, ArrowY + 2);
  Canvas.LineTo(ArrowX + 8, ArrowY - 2);
  Canvas.Pen.Width := 1;

  if Width > 58 then
  begin
    LCaption := DisplayText(FSelected);
    LTextRect := Rect(34, 0, Width - 24, Height);
    Canvas.Font.Assign(Font);
    Canvas.Font.Color := FThemePalette.Text;
    Canvas.Brush.Style := bsClear;
    DrawText(Canvas.Handle, PChar(LCaption), Length(LCaption), LTextRect,
      DT_SINGLELINE or DT_VCENTER or DT_END_ELLIPSIS);
    Canvas.Brush.Style := bsSolid;
  end;

  if Focused and Enabled then
  begin
    R := ClientRect;
    InflateRect(R, -3, -3);
    Canvas.Brush.Style := bsClear;
    Canvas.Pen.Color := FThemePalette.Accent;
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

procedure TDCFlexColorPaletteButton.SetThemeMode(
  const Value: TDCFlexThemeMode);
begin
  if FThemeMode = Value then
    Exit;

  FThemeMode := Value;
  if FThemeMode = dtmCustom then
    Exit;

  FThemePalette := DCFlexPaletteForMode(FThemeMode);
  Color := FThemePalette.InputBack;
  FBorderColor := FThemePalette.InputBorder;
  FHoverColor := FThemePalette.Hover;
  Invalidate;
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
  FThemeMode := dtmLight;
  Font.Name := 'Segoe UI';
  Font.Size := 9;
  Caption := 'Toggle';
end;

procedure TDCFlexToggleButton.ApplyThemePalette(
  const APalette: TDCFlexThemePalette);
begin
  FThemeMode := dtmCustom;
  FNormalColor := APalette.InputBack;
  FHoverColor := APalette.Hover;
  FCheckedColor := APalette.Selection;
  FPressedColor := APalette.Pressed;
  FDisabledColor := APalette.Disabled;
  FBorderColor := APalette.InputBorder;
  FHoverBorderColor := APalette.Accent;
  FCheckedBorderColor := APalette.Accent;
  FDisabledBorderColor := APalette.Border;
  FCheckedFontColor := APalette.SelectionText;
  FDisabledFontColor := APalette.DisabledText;
  Font.Color := APalette.Text;
  Invalidate;
end;

destructor TDCFlexToggleButton.Destroy;
begin
  if Assigned(FLanguageSource) then
    FLanguageSource.RemoveChangeListener(LanguageSourceChange);
  inherited Destroy;
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

procedure TDCFlexToggleButton.CMEnter(var Message: TCMGotFocus);
begin
  inherited;
  Invalidate;
end;

procedure TDCFlexToggleButton.CMExit(var Message: TCMLostFocus);
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

  if Focused then
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

procedure TDCFlexToggleButton.LanguageSourceChange(Sender: TObject);
begin
  if Assigned(FLanguageSource) then
    FLanguageSource.ApplyTo(Self);
  UpdateAutoSizeToCaption;
  Invalidate;
end;

procedure TDCFlexToggleButton.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if Enabled and ((Key = VK_RETURN) or (Key = VK_SPACE)) then
  begin
    Click;
    Key := 0;
  end;
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

procedure TDCFlexToggleButton.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FLanguageSource) then
    SetLanguageSource(nil);
end;

procedure TDCFlexToggleButton.Paint;
var
  R: TRect;
  LOuterRect: TRect;
  LFlags: Cardinal;
  LBackColor: TColor;
  LBorderColor: TColor;
  LTextColor: TColor;
  LParentBackColor: TColor;
begin
  inherited;

  R := ClientRect;
  LOuterRect := R;
  LBackColor := GetBackColor;
  LBorderColor := GetBorderPaintColor;
  LTextColor := GetTextColor;

  if Assigned(Parent) then
    LParentBackColor := Parent.Brush.Color
  else
    LParentBackColor := Color;

  Canvas.Brush.Color := LParentBackColor;
  Canvas.FillRect(LOuterRect);

  Canvas.Brush.Color := LBackColor;
  Canvas.Pen.Color := LBorderColor;
  Canvas.Pen.Width := 1;

  if FBorderRadius > 0 then
    Canvas.RoundRect(R.Left, R.Top, R.Right - 1, R.Bottom - 1,
      FBorderRadius, FBorderRadius)
  else
    Canvas.Rectangle(R.Left, R.Top, R.Right - 1, R.Bottom - 1);

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

procedure TDCFlexToggleButton.SetLanguageSource(const Value: TDCFlexLanguage);
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

procedure TDCFlexToggleButton.SetThemeMode(const Value: TDCFlexThemeMode);
var
  LPalette: TDCFlexThemePalette;
begin
  if FThemeMode = Value then
    Exit;

  FThemeMode := Value;
  if FThemeMode = dtmCustom then
    Exit;

  LPalette := DCFlexPaletteForMode(FThemeMode);
  FNormalColor := LPalette.InputBack;
  FHoverColor := LPalette.Hover;
  FCheckedColor := LPalette.Selection;
  FPressedColor := LPalette.Pressed;
  FDisabledColor := LPalette.Disabled;
  FBorderColor := LPalette.InputBorder;
  FHoverBorderColor := LPalette.Accent;
  FCheckedBorderColor := LPalette.Accent;
  FDisabledBorderColor := LPalette.Border;
  FCheckedFontColor := LPalette.SelectionText;
  FDisabledFontColor := LPalette.DisabledText;
  Font.Color := LPalette.Text;
  Invalidate;
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
  FThemeMode := dtmLight;
  FWrap := True;
  Font.Name := 'Segoe UI';
  Font.Size := 9;
end;

procedure TDCFlexFlowLayout.ApplyThemePalette(
  const APalette: TDCFlexThemePalette);
begin
  FThemeMode := dtmCustom;
  FBackColor := APalette.Surface;
  Font.Color := APalette.Text;
  Invalidate;
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

procedure TDCFlexFlowLayout.SetThemeMode(const Value: TDCFlexThemeMode);
var
  LPalette: TDCFlexThemePalette;
begin
  if FThemeMode = Value then
    Exit;

  FThemeMode := Value;
  if FThemeMode = dtmCustom then
    Exit;

  LPalette := DCFlexPaletteForMode(FThemeMode);
  FBackColor := LPalette.Surface;
  Font.Color := LPalette.Text;
  Invalidate;
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
  FThemeMode := dtmLight;
  FThemePalette := DCFlexLightPalette;
  Font.Name := 'Segoe UI';
  Font.Size := 9;
end;

procedure TDCFlexToolbar.ApplyThemePalette(const APalette: TDCFlexThemePalette);
var
  I: Integer;
begin
  FThemeMode := dtmCustom;
  FThemePalette := APalette;
  FBackColor := APalette.Surface;
  FBorderColor := APalette.Border;
  FSeparatorColor := APalette.Border;
  Font.Color := APalette.Text;

  for I := 0 to ControlCount - 1 do
    if Controls[I] is TDCFlexToggleButton then
      TDCFlexToggleButton(Controls[I]).ApplyThemePalette(APalette);

  LayoutControls;
  Invalidate;
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
  if FThemeMode = dtmCustom then
    Result.ApplyThemePalette(FThemePalette)
  else
    Result.ThemeMode := FThemeMode;
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

procedure TDCFlexToolbar.SetThemeMode(const Value: TDCFlexThemeMode);
var
  I: Integer;
  LPalette: TDCFlexThemePalette;
begin
  if FThemeMode = Value then
    Exit;

  FThemeMode := Value;
  if FThemeMode = dtmCustom then
    Exit;

  LPalette := DCFlexPaletteForMode(FThemeMode);
  FThemePalette := LPalette;
  FBackColor := LPalette.Surface;
  FBorderColor := LPalette.Border;
  FSeparatorColor := LPalette.Border;
  Font.Color := LPalette.Text;

  for I := 0 to ControlCount - 1 do
    if Controls[I] is TDCFlexToggleButton then
      TDCFlexToggleButton(Controls[I]).ThemeMode := FThemeMode;

  LayoutControls;
  Invalidate;
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
