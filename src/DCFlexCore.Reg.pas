unit DCFlexCore.Reg;

interface

procedure Register;

implementation

uses
  System.Classes,
  DesignIntf,
  DCFlex.Language,
  DCFlex.Controls;

procedure Register;
begin
  RegisterComponents('Delphi Creative', [TDCFlexLanguage, TDCFlexColorPicker,
    TDCFlexColorPaletteButton, TDCFlexToggleButton, TDCFlexFlowLayout,
    TDCFlexToolbar]);
end;

end.
