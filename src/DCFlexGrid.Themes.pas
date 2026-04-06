unit DCFlexGrid.Themes;

interface

uses
  Vcl.Graphics,
  DCFlexGrid;

type
  TDCGridThemePreset = (
    gtpProfessional,
    gtpDarkModern,
    gtpERPBlue,
    gtpGreen,
    gtpMinimal
  );

  TDCGridMetricsPreset = (
    gmpCompact,
    gmpComfortable
  );

  TDCGridThemeManager = class
  public
    class procedure ApplyPreset(AGrid: TDCMasterDetailGrid; APreset: TDCGridThemePreset); static;
    class procedure ApplyMetricsPreset(AGrid: TDCMasterDetailGrid; APreset: TDCGridMetricsPreset); static;
    class procedure ApplyProfessional(AGrid: TDCMasterDetailGrid); static;
    class procedure ApplyDarkModern(AGrid: TDCMasterDetailGrid); static;
    class procedure ApplyERPBlue(AGrid: TDCMasterDetailGrid); static;
    class procedure ApplyGreen(AGrid: TDCMasterDetailGrid); static;
    class procedure ApplyMinimal(AGrid: TDCMasterDetailGrid); static;
    class procedure ApplyCompactMetrics(AGrid: TDCMasterDetailGrid); static;
    class procedure ApplyComfortableMetrics(AGrid: TDCMasterDetailGrid); static;
  end;

implementation

class procedure TDCGridThemeManager.ApplyPreset(AGrid: TDCMasterDetailGrid;
  APreset: TDCGridThemePreset);
begin
  case APreset of
    gtpProfessional: ApplyProfessional(AGrid);
    gtpDarkModern:   ApplyDarkModern(AGrid);
    gtpERPBlue:      ApplyERPBlue(AGrid);
    gtpGreen:        ApplyGreen(AGrid);
    gtpMinimal:      ApplyMinimal(AGrid);
  end;
end;

class procedure TDCGridThemeManager.ApplyMetricsPreset(AGrid: TDCMasterDetailGrid;
  APreset: TDCGridMetricsPreset);
begin
  case APreset of
    gmpCompact:     ApplyCompactMetrics(AGrid);
    gmpComfortable: ApplyComfortableMetrics(AGrid);
  end;
end;

class procedure TDCGridThemeManager.ApplyProfessional(AGrid: TDCMasterDetailGrid);
begin
  if not Assigned(AGrid) then
    Exit;

  AGrid.Theme.HeaderColor := $00415063;
  AGrid.Theme.HeaderFontColor := clWhite;
  AGrid.Theme.GridBackgroundColor := $00F6F8FB;
  AGrid.Theme.RowColor := clWhite;
  AGrid.Theme.AlternateRowColor := $00F8FAFD;
  AGrid.Theme.HoverRowColor := $00EEF4FB;
  AGrid.Theme.SelectedRowColor := $00DDEBFA;
  AGrid.Theme.SelectedTextColor := $00293A4E;
  AGrid.Theme.DetailColor := $00EEF3F9;
  AGrid.Theme.BorderColor := $00D7E0EA;
  AGrid.Theme.DetailBorderColor := $00D8E2EC;
  AGrid.Theme.TextColor := $002A3442;
  AGrid.Theme.DetailTextColor := $002A3442;
  AGrid.Theme.ExpandButtonColor := $00677D98;
  AGrid.Theme.DetailGridHeaderColor := $00DCE7F4;
  AGrid.Theme.DetailGridHeaderFontColor := $002A3442;
  AGrid.Theme.DetailGridRowColor := clWhite;
  AGrid.Theme.DetailGridAlternateRowColor := $00F9FBFE;
  AGrid.Theme.DetailGridLineColor := $00DFE6EF;
  AGrid.Theme.SearchHighlightColor := $00FFF2A8;
  AGrid.Theme.SearchHighlightTextColor := $001F2D3D;
  AGrid.Invalidate;
end;

class procedure TDCGridThemeManager.ApplyDarkModern(AGrid: TDCMasterDetailGrid);
begin
  if not Assigned(AGrid) then
    Exit;

  AGrid.Theme.HeaderColor := $00333C4D;
  AGrid.Theme.HeaderFontColor := clWhite;
  AGrid.Theme.GridBackgroundColor := $001E232B;
  AGrid.Theme.RowColor := $00242A34;
  AGrid.Theme.AlternateRowColor := $002C3440;
  AGrid.Theme.HoverRowColor := $00364352;
  AGrid.Theme.SelectedRowColor := $0045667C;
  AGrid.Theme.SelectedTextColor := clWhite;
  AGrid.Theme.DetailColor := $002A313D;
  AGrid.Theme.BorderColor := $00445061;
  AGrid.Theme.DetailBorderColor := $004D5C70;
  AGrid.Theme.TextColor := $00E6EDF5;
  AGrid.Theme.DetailTextColor := $00E6EDF5;
  AGrid.Theme.ExpandButtonColor := $00D5A35B;
  AGrid.Theme.DetailGridHeaderColor := $003A4453;
  AGrid.Theme.DetailGridHeaderFontColor := clWhite;
  AGrid.Theme.DetailGridRowColor := $00262D38;
  AGrid.Theme.DetailGridAlternateRowColor := $002E3642;
  AGrid.Theme.DetailGridLineColor := $00424B58;
  AGrid.Theme.SearchHighlightColor := $006E97C7;
  AGrid.Theme.SearchHighlightTextColor := clWhite;
  AGrid.Invalidate;
end;

class procedure TDCGridThemeManager.ApplyERPBlue(AGrid: TDCMasterDetailGrid);
begin
  if not Assigned(AGrid) then
    Exit;

  AGrid.Theme.HeaderColor := $00B56C1E;
  AGrid.Theme.HeaderFontColor := clWhite;
  AGrid.Theme.GridBackgroundColor := clWhite;
  AGrid.Theme.RowColor := clWhite;
  AGrid.Theme.AlternateRowColor := $00F5F9FF;
  AGrid.Theme.HoverRowColor := $00E5F0FF;
  AGrid.Theme.SelectedRowColor := $00D9E8FF;
  AGrid.Theme.SelectedTextColor := $00412A12;
  AGrid.Theme.DetailColor := $00EEF5FF;
  AGrid.Theme.BorderColor := $00D6E2F1;
  AGrid.Theme.DetailBorderColor := $00BFD3ED;
  AGrid.Theme.TextColor := $00364352;
  AGrid.Theme.DetailTextColor := $00364352;
  AGrid.Theme.ExpandButtonColor := $008A5417;
  AGrid.Theme.DetailGridHeaderColor := $00CB8B43;
  AGrid.Theme.DetailGridHeaderFontColor := clWhite;
  AGrid.Theme.DetailGridRowColor := clWhite;
  AGrid.Theme.DetailGridAlternateRowColor := $00F8FBFF;
  AGrid.Theme.DetailGridLineColor := $00D8E4F3;
  AGrid.Theme.SearchHighlightColor := $00A7D8FF;
  AGrid.Theme.SearchHighlightTextColor := $00253C54;
  AGrid.Invalidate;
end;

class procedure TDCGridThemeManager.ApplyGreen(AGrid: TDCMasterDetailGrid);
begin
  if not Assigned(AGrid) then
    Exit;

  AGrid.Theme.HeaderColor := $004AA06B;
  AGrid.Theme.HeaderFontColor := clWhite;
  AGrid.Theme.GridBackgroundColor := clWhite;
  AGrid.Theme.RowColor := clWhite;
  AGrid.Theme.AlternateRowColor := $00F4FBF6;
  AGrid.Theme.HoverRowColor := $00E4F6EA;
  AGrid.Theme.SelectedRowColor := $00D5EFDE;
  AGrid.Theme.SelectedTextColor := $001B4426;
  AGrid.Theme.DetailColor := $00EFF8F2;
  AGrid.Theme.BorderColor := $00D6E7DC;
  AGrid.Theme.DetailBorderColor := $00C4DDCB;
  AGrid.Theme.TextColor := $00324338;
  AGrid.Theme.DetailTextColor := $00324338;
  AGrid.Theme.ExpandButtonColor := $0035764F;
  AGrid.Theme.DetailGridHeaderColor := $005DB07C;
  AGrid.Theme.DetailGridHeaderFontColor := clWhite;
  AGrid.Theme.DetailGridRowColor := clWhite;
  AGrid.Theme.DetailGridAlternateRowColor := $00F8FCF9;
  AGrid.Theme.DetailGridLineColor := $00DBE9E0;
  AGrid.Theme.SearchHighlightColor := $00C1F0CE;
  AGrid.Theme.SearchHighlightTextColor := $00193324;
  AGrid.Invalidate;
end;

class procedure TDCGridThemeManager.ApplyMinimal(AGrid: TDCMasterDetailGrid);
begin
  if not Assigned(AGrid) then
    Exit;

  AGrid.Theme.HeaderColor := $00EAECEF;
  AGrid.Theme.HeaderFontColor := $00303944;
  AGrid.Theme.GridBackgroundColor := clWhite;
  AGrid.Theme.RowColor := clWhite;
  AGrid.Theme.AlternateRowColor := $00FAFBFC;
  AGrid.Theme.HoverRowColor := $00F3F5F7;
  AGrid.Theme.SelectedRowColor := $00E9EEF3;
  AGrid.Theme.SelectedTextColor := $002B3642;
  AGrid.Theme.DetailColor := $00FBFCFD;
  AGrid.Theme.BorderColor := $00E1E6EB;
  AGrid.Theme.DetailBorderColor := $00E6EBF0;
  AGrid.Theme.TextColor := $00343E49;
  AGrid.Theme.DetailTextColor := $00343E49;
  AGrid.Theme.ExpandButtonColor := $00727D89;
  AGrid.Theme.DetailGridHeaderColor := $00F0F3F6;
  AGrid.Theme.DetailGridHeaderFontColor := $0038434E;
  AGrid.Theme.DetailGridRowColor := clWhite;
  AGrid.Theme.DetailGridAlternateRowColor := $00FBFCFD;
  AGrid.Theme.DetailGridLineColor := $00E8EDF1;
  AGrid.Theme.SearchHighlightColor := $00FFF3AA;
  AGrid.Theme.SearchHighlightTextColor := $00364048;
  AGrid.Invalidate;
end;

class procedure TDCGridThemeManager.ApplyCompactMetrics(AGrid: TDCMasterDetailGrid);
begin
  if not Assigned(AGrid) then
    Exit;

  AGrid.RowHeight := 28;
  AGrid.HeaderHeight := 32;
  AGrid.DetailHeight := 72;
  AGrid.DetailGridHeaderHeight := 24;
  AGrid.DetailGridRowHeight := 22;
  AGrid.MinColumnWidth := 42;
end;

class procedure TDCGridThemeManager.ApplyComfortableMetrics(AGrid: TDCMasterDetailGrid);
begin
  if not Assigned(AGrid) then
    Exit;

  AGrid.RowHeight := 34;
  AGrid.HeaderHeight := 38;
  AGrid.DetailHeight := 84;
  AGrid.DetailGridHeaderHeight := 28;
  AGrid.DetailGridRowHeight := 24;
  AGrid.MinColumnWidth := 48;
end;

end.
