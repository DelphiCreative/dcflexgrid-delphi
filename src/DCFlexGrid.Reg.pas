unit DCFlexGrid.Reg;

interface

procedure Register;

implementation

uses
  System.Classes,
  DesignIntf,
  DCFlexGrid;

procedure Register;
begin
  RegisterComponents('Delphi Creative', [TDCFlexGrid]);
end;

end.
