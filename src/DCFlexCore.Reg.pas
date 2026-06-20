unit DCFlexCore.Reg;

interface

procedure Register;

implementation

uses
  System.Classes,
  DesignIntf,
  DCFlex.Language,
  DCFlex.Theme,
  DCFlex.Controls,
  DCFlex.PopupMenu;

procedure Register;
begin
  RegisterComponents('Delphi Creative', [TDCFlexLanguage, TDCFlexThemeSource,
    TDCFlexButton, TDCFlexEdit, TDCFlexMemo, TDCFlexCheckBox, TDCFlexDateEdit, TDCFlexTimeEdit,
    TDCFlexComboBox, TDCFlexColorPicker, TDCFlexColorPaletteButton, TDCFlexToggleButton,
    TDCFlexFlowLayout, TDCFlexToolbar, TDCFlexPopupMenu]);
end;

end.
