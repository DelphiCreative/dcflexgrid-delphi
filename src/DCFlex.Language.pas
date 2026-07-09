unit DCFlex.Language;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Generics.Collections,
  System.JSON,
  System.IOUtils,
  System.TypInfo;

type
  TDCFlexLanguageCode = (dlcEnglish, dlcPortuguese, dlcCustom);
  TDCFlexLanguageScope = (dlsCommon, dlsGrid, dlsScheduler, dlsKanban,
    dlsSheets);

  TDCFlexLanguageNotifyListener = class
  private
    FHandler: TNotifyEvent;
  public
    constructor Create(AHandler: TNotifyEvent);
    function SameHandler(AHandler: TNotifyEvent): Boolean;
    property Handler: TNotifyEvent read FHandler;
  end;

  TDCFlexLanguageItem = class(TCollectionItem)
  private
    FKey: string;
    FScope: TDCFlexLanguageScope;
    FValue: string;
    procedure SetKey(const Value: string);
    procedure SetScope(const Value: TDCFlexLanguageScope);
    procedure SetValue(const Value: string);
  protected
    function GetDisplayName: string; override;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Scope: TDCFlexLanguageScope read FScope write SetScope default dlsCommon;
    property Key: string read FKey write SetKey;
    property Value: string read FValue write SetValue;
  end;

  TDCFlexLanguageItems = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TDCFlexLanguageItem;
    procedure SetItem(Index: Integer; const Value: TDCFlexLanguageItem);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TPersistent);
    function Add: TDCFlexLanguageItem;
    function Find(AScope: TDCFlexLanguageScope;
      const AKey: string): TDCFlexLanguageItem;
    property Items[Index: Integer]: TDCFlexLanguageItem read GetItem
      write SetItem; default;
  end;

  TDCFlexLanguageExtractOption = (leoIncludeCaption, leoIncludeHint,
    leoSkipEmptyValues);
  TDCFlexLanguageExtractOptions = set of TDCFlexLanguageExtractOption;

  TDCFlexLanguage = class(TComponent)
  private
    FItems: TDCFlexLanguageItems;
    FLanguage: TDCFlexLanguageCode;
    FChangeListeners: TObjectList<TDCFlexLanguageNotifyListener>;
    FOnChange: TNotifyEvent;
    procedure Changed;
    procedure ApplyTextProperty(AComponent: TComponent;
      AScope: TDCFlexLanguageScope; const ABaseKey, APropertyName: string);
    procedure ExtractTextProperty(AComponent: TComponent;
      AScope: TDCFlexLanguageScope; const ABaseKey, APropertyName: string;
      AOptions: TDCFlexLanguageExtractOptions);
    function DefaultText(AScope: TDCFlexLanguageScope; const AKey,
      ADefault: string): string;
    function ComponentNameKey(const AName: string): string;
    function NormalizeTextKey(const AValue: string): string;
    function ResolvedText(AScope: TDCFlexLanguageScope; const AKey,
      ADefault: string): string;
    procedure SetItems(const Value: TDCFlexLanguageItems);
    procedure SetLanguage(const Value: TDCFlexLanguageCode);
    function ScopeToString(AScope: TDCFlexLanguageScope): string;
    function StringToScope(const AValue: string): TDCFlexLanguageScope;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddChangeListener(AHandler: TNotifyEvent);
    procedure ApplyTo(AComponent: TComponent;
      AScope: TDCFlexLanguageScope = dlsCommon; const AKey: string = '');
    procedure ApplyToChildren(AOwner: TComponent;
      AScope: TDCFlexLanguageScope = dlsCommon;
      ARecursive: Boolean = True; const AKeyPrefix: string = '');
    procedure Assign(Source: TPersistent); override;
    procedure ExtractFrom(AComponent: TComponent;
      AScope: TDCFlexLanguageScope = dlsCommon; const AKey: string = '';
      AOptions: TDCFlexLanguageExtractOptions = [leoIncludeCaption,
      leoIncludeHint, leoSkipEmptyValues]);
    procedure ExtractFromChildren(AOwner: TComponent;
      AScope: TDCFlexLanguageScope = dlsCommon;
      ARecursive: Boolean = True; const AKeyPrefix: string = '';
      AOptions: TDCFlexLanguageExtractOptions = [leoIncludeCaption,
      leoIncludeHint, leoSkipEmptyValues]);
    procedure LoadFromFile(const AFileName: string);
    procedure ResetToDefaults;
    procedure SaveToFile(const AFileName: string);
    procedure RemoveChangeListener(AHandler: TNotifyEvent);
    procedure SetText(AScope: TDCFlexLanguageScope; const AKey,
      AValue: string);
    function Text(AScope: TDCFlexLanguageScope; const AKey,
      ADefault: string): string;
  published
    property Language: TDCFlexLanguageCode read FLanguage write SetLanguage
      default dlcEnglish;
    property Items: TDCFlexLanguageItems read FItems write SetItems;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

implementation

{ TDCFlexLanguageNotifyListener }

constructor TDCFlexLanguageNotifyListener.Create(AHandler: TNotifyEvent);
begin
  inherited Create;
  FHandler := AHandler;
end;

function TDCFlexLanguageNotifyListener.SameHandler(
  AHandler: TNotifyEvent): Boolean;
var
  AM: TMethod;
  BM: TMethod;
begin
  AM := TMethod(AHandler);
  BM := TMethod(FHandler);
  Result := (AM.Code = BM.Code) and (AM.Data = BM.Data);
end;

{ TDCFlexLanguageItem }

procedure TDCFlexLanguageItem.Assign(Source: TPersistent);
begin
  if Source is TDCFlexLanguageItem then
  begin
    FScope := TDCFlexLanguageItem(Source).Scope;
    FKey := TDCFlexLanguageItem(Source).Key;
    FValue := TDCFlexLanguageItem(Source).Value;
    Changed(False);
  end
  else
    inherited Assign(Source);
end;

function TDCFlexLanguageItem.GetDisplayName: string;
begin
  if FKey <> '' then
    Result := FKey
  else
    Result := inherited GetDisplayName;
end;

procedure TDCFlexLanguageItem.SetKey(const Value: string);
begin
  if FKey <> Value then
  begin
    FKey := Value;
    Changed(False);
  end;
end;

procedure TDCFlexLanguageItem.SetScope(const Value: TDCFlexLanguageScope);
begin
  if FScope <> Value then
  begin
    FScope := Value;
    Changed(False);
  end;
end;

procedure TDCFlexLanguageItem.SetValue(const Value: string);
begin
  if FValue <> Value then
  begin
    FValue := Value;
    Changed(False);
  end;
end;

{ TDCFlexLanguageItems }

function TDCFlexLanguageItems.Add: TDCFlexLanguageItem;
begin
  Result := TDCFlexLanguageItem(inherited Add);
end;

constructor TDCFlexLanguageItems.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, TDCFlexLanguageItem);
end;

function TDCFlexLanguageItems.Find(AScope: TDCFlexLanguageScope;
  const AKey: string): TDCFlexLanguageItem;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
    if (Items[I].Scope = AScope) and SameText(Items[I].Key, AKey) then
      Exit(Items[I]);
end;

function TDCFlexLanguageItems.GetItem(Index: Integer): TDCFlexLanguageItem;
begin
  Result := TDCFlexLanguageItem(inherited GetItem(Index));
end;

procedure TDCFlexLanguageItems.SetItem(Index: Integer;
  const Value: TDCFlexLanguageItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TDCFlexLanguageItems.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
  if GetOwner is TDCFlexLanguage then
    TDCFlexLanguage(GetOwner).Changed;
end;

{ TDCFlexLanguage }

procedure TDCFlexLanguage.AddChangeListener(AHandler: TNotifyEvent);
var
  I: Integer;
begin
  if not Assigned(AHandler) then
    Exit;

  for I := 0 to FChangeListeners.Count - 1 do
    if FChangeListeners[I].SameHandler(AHandler) then
      Exit;

  FChangeListeners.Add(TDCFlexLanguageNotifyListener.Create(AHandler));
end;

procedure TDCFlexLanguage.ApplyTextProperty(AComponent: TComponent;
  AScope: TDCFlexLanguageScope; const ABaseKey, APropertyName: string);
var
  LCurrent: string;
  LDefaultKey: string;
  LNew: string;
  LPropInfo: PPropInfo;
begin
  LPropInfo := GetPropInfo(AComponent, APropertyName);
  if not Assigned(LPropInfo) or
    not (LPropInfo^.PropType^.Kind in [tkString, tkLString, tkWString,
    tkUString]) then
    Exit;

  LCurrent := GetStrProp(AComponent, LPropInfo);
  LNew := ResolvedText(AScope, ABaseKey + '.' + LowerCase(APropertyName), '');

  if (LNew = '') and SameText(APropertyName, 'Caption') then
  begin
    LDefaultKey := ComponentNameKey(AComponent.Name);
    if LDefaultKey <> '' then
      LNew := ResolvedText(dlsCommon, LDefaultKey, '');
    if LNew = '' then
      LNew := ResolvedText(AScope, NormalizeTextKey(LCurrent), LCurrent);
    if (LNew = LCurrent) and (AScope <> dlsCommon) then
      LNew := ResolvedText(dlsCommon, NormalizeTextKey(LCurrent), LCurrent);
  end
  else if (LNew = '') and SameText(APropertyName, 'Hint') then
    LNew := ResolvedText(AScope, ABaseKey + '.hint', LCurrent);

  if (LNew <> '') and (LNew <> LCurrent) then
    SetStrProp(AComponent, LPropInfo, LNew);
end;

procedure TDCFlexLanguage.ApplyTo(AComponent: TComponent;
  AScope: TDCFlexLanguageScope; const AKey: string);
var
  LBaseKey: string;
begin
  if not Assigned(AComponent) then
    Exit;

  LBaseKey := AKey;
  if LBaseKey = '' then
    LBaseKey := AComponent.Name;
  if LBaseKey = '' then
    Exit;

  ApplyTextProperty(AComponent, AScope, LBaseKey, 'Caption');
  ApplyTextProperty(AComponent, AScope, LBaseKey, 'Hint');
end;

procedure TDCFlexLanguage.ApplyToChildren(AOwner: TComponent;
  AScope: TDCFlexLanguageScope; ARecursive: Boolean; const AKeyPrefix: string);
var
  I: Integer;
  LComponent: TComponent;
  LKey: string;
begin
  if not Assigned(AOwner) then
    Exit;

  for I := 0 to AOwner.ComponentCount - 1 do
  begin
    LComponent := AOwner.Components[I];
    if LComponent = Self then
      Continue;

    LKey := LComponent.Name;
    if (AKeyPrefix <> '') and (LKey <> '') then
      LKey := AKeyPrefix + '.' + LKey;

    ApplyTo(LComponent, AScope, LKey);

    if ARecursive and (LComponent.ComponentCount > 0) then
      ApplyToChildren(LComponent, AScope, ARecursive, AKeyPrefix);
  end;
end;

procedure TDCFlexLanguage.ExtractTextProperty(AComponent: TComponent;
  AScope: TDCFlexLanguageScope; const ABaseKey, APropertyName: string;
  AOptions: TDCFlexLanguageExtractOptions);
var
  LCurrent: string;
  LPropInfo: PPropInfo;
begin
  if SameText(APropertyName, 'Caption') and
    not (leoIncludeCaption in AOptions) then
    Exit;
  if SameText(APropertyName, 'Hint') and
    not (leoIncludeHint in AOptions) then
    Exit;

  LPropInfo := GetPropInfo(AComponent, APropertyName);
  if not Assigned(LPropInfo) or
    not (LPropInfo^.PropType^.Kind in [tkString, tkLString, tkWString,
    tkUString]) then
    Exit;

  LCurrent := GetStrProp(AComponent, LPropInfo);
  if (LCurrent = '') and (leoSkipEmptyValues in AOptions) then
    Exit;

  SetText(AScope, ABaseKey + '.' + LowerCase(APropertyName), LCurrent);
end;

procedure TDCFlexLanguage.ExtractFrom(AComponent: TComponent;
  AScope: TDCFlexLanguageScope; const AKey: string;
  AOptions: TDCFlexLanguageExtractOptions);
var
  LBaseKey: string;
begin
  if not Assigned(AComponent) then
    Exit;

  LBaseKey := AKey;
  if LBaseKey = '' then
    LBaseKey := AComponent.Name;
  if LBaseKey = '' then
    Exit;

  ExtractTextProperty(AComponent, AScope, LBaseKey, 'Caption', AOptions);
  ExtractTextProperty(AComponent, AScope, LBaseKey, 'Hint', AOptions);
end;

procedure TDCFlexLanguage.ExtractFromChildren(AOwner: TComponent;
  AScope: TDCFlexLanguageScope; ARecursive: Boolean; const AKeyPrefix: string;
  AOptions: TDCFlexLanguageExtractOptions);
var
  I: Integer;
  LComponent: TComponent;
  LKey: string;
begin
  if not Assigned(AOwner) then
    Exit;

  for I := 0 to AOwner.ComponentCount - 1 do
  begin
    LComponent := AOwner.Components[I];
    if LComponent = Self then
      Continue;

    LKey := LComponent.Name;
    if (AKeyPrefix <> '') and (LKey <> '') then
      LKey := AKeyPrefix + '.' + LKey;

    ExtractFrom(LComponent, AScope, LKey, AOptions);

    if ARecursive and (LComponent.ComponentCount > 0) then
      ExtractFromChildren(LComponent, AScope, ARecursive, AKeyPrefix,
        AOptions);
  end;
end;

procedure TDCFlexLanguage.Assign(Source: TPersistent);
begin
  if Source is TDCFlexLanguage then
  begin
    FLanguage := TDCFlexLanguage(Source).Language;
    FItems.Assign(TDCFlexLanguage(Source).Items);
    Changed;
  end
  else
    inherited Assign(Source);
end;

procedure TDCFlexLanguage.Changed;
var
  I: Integer;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
  for I := 0 to FChangeListeners.Count - 1 do
    if Assigned(FChangeListeners[I].Handler) then
      FChangeListeners[I].Handler(Self);
end;

constructor TDCFlexLanguage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLanguage := dlcEnglish;
  FItems := TDCFlexLanguageItems.Create(Self);
  FChangeListeners := TObjectList<TDCFlexLanguageNotifyListener>.Create(True);
end;

function TDCFlexLanguage.ComponentNameKey(const AName: string): string;
var
  LName: string;
begin
  Result := '';
  LName := Trim(AName);
  if LName = '' then
    Exit;

  if (Length(LName) > 3) and
    ((Copy(LowerCase(LName), 1, 3) = 'btn') or
    (Copy(LowerCase(LName), 1, 3) = 'lbl') or
    (Copy(LowerCase(LName), 1, 3) = 'chk')) then
    Delete(LName, 1, 3)
  else if (Length(LName) > 2) and
    ((Copy(LowerCase(LName), 1, 2) = 'mi') or
    (Copy(LowerCase(LName), 1, 2) = 'rb')) then
    Delete(LName, 1, 2)
  else if (Length(LName) > 4) and
    (Copy(LowerCase(LName), 1, 4) = 'menu') then
    Delete(LName, 1, 4);

  Result := NormalizeTextKey(LName);
end;

function TDCFlexLanguage.DefaultText(AScope: TDCFlexLanguageScope; const AKey,
  ADefault: string): string;
var
  LKey: string;
begin
  Result := ADefault;
  LKey := LowerCase(AKey);

  if FLanguage = dlcEnglish then
  begin
    if AScope = dlsCommon then
    begin
      if LKey = 'ok' then Exit('OK');
      if LKey = 'cancel' then Exit('Cancel');
      if LKey = 'close' then Exit('Close');
      if LKey = 'delete' then Exit('Delete');
      if LKey = 'clear' then Exit('Clear');
      if LKey = 'save' then Exit('Save');
      if LKey = 'load' then Exit('Load');
      if LKey = 'reset' then Exit('Reset');
      if LKey = 'language' then Exit('Language');
      if LKey = 'storage' then Exit('Storage');
    end;
  end;

  if FLanguage = dlcPortuguese then
  begin
    if AScope = dlsCommon then
    begin
      if LKey = 'ok' then Exit('OK');
      if LKey = 'cancel' then Exit('Cancelar');
      if LKey = 'close' then Exit('Fechar');
      if LKey = 'delete' then Exit('Excluir');
      if LKey = 'clear' then Exit('Limpar');
      if LKey = 'save' then Exit('Salvar');
      if LKey = 'load' then Exit('Carregar');
      if LKey = 'reset' then Exit('Redefinir');
      if LKey = 'language' then Exit('Idioma');
      if LKey = 'storage' then Exit('Persist.');
      if LKey = 'color.none' then Exit('Nenhuma');
      if LKey = 'color.black' then Exit('Preto');
      if LKey = 'color.white' then Exit('Branco');
      if LKey = 'color.light.gray' then Exit('Cinza claro');
      if LKey = 'color.gray' then Exit('Cinza');
      if LKey = 'color.slate' then Exit('Ard' + #243 + 'sia');
      if LKey = 'color.dark.slate' then Exit('Ard' + #243 + 'sia escuro');
      if LKey = 'color.light.blue' then Exit('Azul claro');
      if LKey = 'color.blue' then Exit('Azul');
      if LKey = 'color.dark.blue' then Exit('Azul escuro');
      if LKey = 'color.indigo' then Exit(#205 + 'ndigo');
      if LKey = 'color.purple' then Exit('Roxo');
      if LKey = 'color.lavender' then Exit('Lavanda');
      if LKey = 'color.light.green' then Exit('Verde claro');
      if LKey = 'color.green' then Exit('Verde');
      if LKey = 'color.dark.green' then Exit('Verde escuro');
      if LKey = 'color.mint' then Exit('Menta');
      if LKey = 'color.teal' then Exit('Azul petr' + #243 + 'leo');
      if LKey = 'color.cyan' then Exit('Ciano');
      if LKey = 'color.light.yellow' then Exit('Amarelo claro');
      if LKey = 'color.yellow' then Exit('Amarelo');
      if LKey = 'color.soft.amber' then Exit(#194 + 'mbar suave');
      if LKey = 'color.amber' then Exit(#194 + 'mbar');
      if LKey = 'color.orange' then Exit('Laranja');
      if LKey = 'color.coral' then Exit('Coral');
      if LKey = 'color.light.red' then Exit('Vermelho claro');
      if LKey = 'color.red' then Exit('Vermelho');
      if LKey = 'color.light.pink' then Exit('Rosa claro');
      if LKey = 'color.pink' then Exit('Rosa');
      if LKey = 'color.rose' then Exit('Rose');
      if LKey = 'color.brown' then Exit('Marrom');
      if LKey = 'color.reset' then Exit('Redefinir');
      if LKey = 'color.standard' then Exit('PADR' + #195 + 'O');
      if LKey = 'color.cancel' then Exit('Cancelar');
      if LKey = 'color.custom' then Exit('Personalizada ');
      if LKey = 'color.custom.color' then Exit('Cor personalizada...');
    end
    else if AScope = dlsSheets then
    begin
      if LKey = 'font.default' then Exit('Fonte padr' + #227 + 'o');
      if LKey = 'font.family' then Exit('Fonte');
      if LKey = 'font.size.default' then Exit('Padr' + #227 + 'o');
      if LKey = 'font.size' then Exit('Tamanho da fonte');
      if LKey = 'font.bold' then Exit('Negrito');
      if LKey = 'font.italic' then Exit('It' + #225 + 'lico');
      if LKey = 'font.underline' then Exit('Sublinhado');
      if LKey = 'align.left' then Exit('Alinhar ' + #224 + ' esquerda');
      if LKey = 'align.center' then Exit('Centralizar');
      if LKey = 'align.right' then Exit('Alinhar ' + #224 + ' direita');
      if LKey = 'number.format' then Exit('Formato num' + #233 + 'rico');
      if LKey = 'number.general' then Exit('Geral');
      if LKey = 'number.number' then Exit('N' + #250 + 'mero');
      if LKey = 'number.currency' then Exit('Moeda');
      if LKey = 'number.percent' then Exit('Percentual');
      if LKey = 'borders' then Exit('Bordas');
      if LKey = 'borders.none' then Exit('Sem bordas');
      if LKey = 'borders.all' then Exit('Todas');
      if LKey = 'borders.outline' then Exit('Contorno');
      if LKey = 'color.fill' then Exit('Cor de fundo');
      if LKey = 'color.text' then Exit('Cor do texto');
      if LKey = 'style.clear' then Exit('Limpar estilo');
      if LKey = 'style.clear.hint' then
        Exit('Limpar formata' + #231 + #227 + 'o das c' + #233 +
          'lulas selecionadas');
      if LKey = 'formula.cell' then Exit('C' + #233 + 'lula');
      if LKey = 'formula.value' then Exit('F' + #243 + 'rmula');
      if LKey = 'edit.cut' then Exit('Recortar');
      if LKey = 'edit.copy' then Exit('Copiar');
      if LKey = 'edit.paste' then Exit('Colar');
      if LKey = 'edit.clear.contents' then Exit('Limpar conte' + #250 + 'do');
      if LKey = 'row.insert' then Exit('Inserir linha');
      if LKey = 'row.delete' then Exit('Excluir linha');
      if LKey = 'column.insert' then Exit('Inserir coluna');
      if LKey = 'column.delete' then Exit('Excluir coluna');
      if LKey = 'selection.autofit' then Exit('Auto ajustar sele' + #231 + #227 + 'o');
      if LKey = 'cells.merge' then Exit('Mesclar c' + #233 + 'lulas');
      if LKey = 'cells.unmerge' then Exit('Desmesclar c' + #233 + 'lulas');
    end;
    if AScope = dlsScheduler then
    begin
      if LKey = 'event.caption' then Exit('Evento');
      if LKey = 'event.new.title' then Exit('Novo evento');
      if LKey = 'field.title' then Exit('T' + #237 + 'tulo');
      if LKey = 'field.start' then Exit('In' + #237 + 'cio');
      if LKey = 'field.end' then Exit('Fim');
      if LKey = 'field.all.day' then Exit('Dia inteiro');
      if LKey = 'field.location' then Exit('Local');
      if LKey = 'field.color' then Exit('Cor');
      if LKey = 'field.text.color' then Exit('Cor do texto');
      if LKey = 'field.notes' then Exit('Observa' + #231 + #245 + 'es');
      if LKey = 'recurrence.caption' then Exit('Repetir');
      if LKey = 'recurrence.until' then Exit('At' + #233);
      if LKey = 'recurrence.none' then Exit('N' + #227 + 'o repetir');
      if LKey = 'recurrence.daily' then Exit('Di' + #225 + 'rio');
      if LKey = 'recurrence.weekly' then Exit('Semanal');
      if LKey = 'recurrence.monthly' then Exit('Mensal');
      if LKey = 'ok' then Exit('OK');
      if LKey = 'cancel' then Exit('Cancelar');
      if LKey = 'event.untitled' then Exit('(Sem t' + #237 + 'tulo)');
      if LKey = 'event.more' then Exit('+%d mais');
      if LKey = 'recurrence.this.occurrence' then Exit('Esta ocorr' + #234 + 'ncia');
      if LKey = 'recurrence.this.future' then Exit('Esta e futuras');
      if LKey = 'recurrence.entire.series' then Exit('S' + #233 + 'rie inteira');
      if LKey = 'recurrence.edit.title' then Exit('Evento recorrente');
      if LKey = 'recurrence.edit.message' then
        Exit('Escolha se deseja editar somente esta ocorr' + #234 +
          'ncia ou a s' + #233 + 'rie inteira.');
      if LKey = 'delete' then Exit('Excluir');
      if LKey = 'delete.event.title' then Exit('Excluir evento');
      if LKey = 'delete.event.message' then
        Exit('Este evento ser' + #225 + ' exclu' + #237 + 'do permanentemente.');
      if LKey = 'delete.recurring.title' then Exit('Excluir evento recorrente');
      if LKey = 'delete.recurring.message' then
        Exit('Escolha se deseja excluir somente esta ocorr' + #234 +
          'ncia ou a s' + #233 + 'rie inteira.');
      if LKey = 'popup.previous' then Exit('Anterior');
      if LKey = 'popup.today' then Exit('Hoje');
      if LKey = 'popup.next' then Exit('Pr' + #243 + 'ximo');
      if LKey = 'popup.view' then Exit('Vis' + #227 + 'o');
      if LKey = 'popup.view.day' then Exit('Dia');
      if LKey = 'popup.view.week' then Exit('Semana');
      if LKey = 'popup.view.month' then Exit('M' + #234 + 's');
      if LKey = 'weekday.sunday' then Exit('dom');
      if LKey = 'weekday.monday' then Exit('seg');
      if LKey = 'weekday.tuesday' then Exit('ter');
      if LKey = 'weekday.wednesday' then Exit('qua');
      if LKey = 'weekday.thursday' then Exit('qui');
      if LKey = 'weekday.friday' then Exit('sex');
      if LKey = 'weekday.saturday' then Exit('s' + #225 + 'b');
    end;
    if AScope = dlsKanban then
    begin
      if LKey = 'card.caption' then Exit('Card');
      if LKey = 'column.caption' then Exit('Coluna');
      if LKey = 'field.title' then Exit('T' + #237 + 'tulo');
      if LKey = 'field.name' then Exit('Nome');
      if LKey = 'field.description' then Exit('Descri' + #231 + #227 + 'o');
      if LKey = 'field.tag' then Exit('Etiqueta');
      if LKey = 'field.color' then Exit('Cor');
      if LKey = 'field.text.color' then Exit('Cor do texto');
      if LKey = 'ok' then Exit('OK');
      if LKey = 'cancel' then Exit('Cancelar');
      if LKey = 'card.untitled' then Exit('(Sem t' + #237 + 'tulo)');
      if LKey = 'delete' then Exit('Excluir');
      if LKey = 'delete.card.title' then Exit('Excluir card');
      if LKey = 'delete.card.message' then
        Exit('Este card ser' + #225 + ' exclu' + #237 + 'do permanentemente.');
      if LKey = 'delete.column.title' then Exit('Excluir coluna');
      if LKey = 'delete.column.message' then
        Exit('Esta coluna e todos os seus cards ser' + #227 + 'o exclu' +
          #237 + 'dos permanentemente.');
    end;
  end;
end;

destructor TDCFlexLanguage.Destroy;
begin
  FChangeListeners.Free;
  FItems.Free;
  inherited Destroy;
end;

function TDCFlexLanguage.NormalizeTextKey(const AValue: string): string;
var
  I: Integer;
  C: Char;
  LWasSeparator: Boolean;
begin
  Result := '';
  LWasSeparator := True;

  for I := 1 to Length(AValue) do
  begin
    C := AValue[I];
    if C = '&' then
      Continue;

    if CharInSet(C, ['A'..'Z']) then
      C := Char(Ord(C) + 32);

    if CharInSet(C, ['a'..'z', '0'..'9']) then
    begin
      Result := Result + C;
      LWasSeparator := False;
    end
    else if not LWasSeparator then
    begin
      Result := Result + '.';
      LWasSeparator := True;
    end;
  end;

  while (Result <> '') and (Result[Length(Result)] = '.') do
    Delete(Result, Length(Result), 1);
end;

function TDCFlexLanguage.ResolvedText(AScope: TDCFlexLanguageScope; const AKey,
  ADefault: string): string;
const
  MissingText = #1#2#3;
begin
  if AKey = '' then
    Exit(ADefault);

  Result := Text(AScope, AKey, MissingText);
  if Result = MissingText then
    Result := ADefault;
end;

procedure TDCFlexLanguage.LoadFromFile(const AFileName: string);
var
  LValue: TJSONValue;
  LRoot: TJSONObject;
  LItems: TJSONArray;
  LItem: TJSONObject;
  I: Integer;
begin
  if not TFile.Exists(AFileName) then
    Exit;

  LValue := TJSONObject.ParseJSONValue(TFile.ReadAllText(AFileName,
    TEncoding.UTF8));
  try
    if not (LValue is TJSONObject) then
      Exit;

    LRoot := TJSONObject(LValue);
    FLanguage := TDCFlexLanguageCode(LRoot.GetValue<Integer>('language',
      Integer(FLanguage)));
    FItems.Clear;
    if LRoot.TryGetValue<TJSONArray>('items', LItems) then
      for I := 0 to LItems.Count - 1 do
        if LItems.Items[I] is TJSONObject then
        begin
          LItem := TJSONObject(LItems.Items[I]);
          SetText(StringToScope(LItem.GetValue<string>('scope', 'common')),
            LItem.GetValue<string>('key', ''),
            LItem.GetValue<string>('value', ''));
        end;
  finally
    LValue.Free;
  end;
  Changed;
end;

procedure TDCFlexLanguage.ResetToDefaults;
begin
  FItems.Clear;
  Changed;
end;

procedure TDCFlexLanguage.SaveToFile(const AFileName: string);
var
  LRoot: TJSONObject;
  LItems: TJSONArray;
  LItem: TJSONObject;
  I: Integer;
begin
  LRoot := TJSONObject.Create;
  try
    LRoot.AddPair('formatVersion', TJSONNumber.Create(1));
    LRoot.AddPair('language', TJSONNumber.Create(Integer(FLanguage)));
    LItems := TJSONArray.Create;
    LRoot.AddPair('items', LItems);
    for I := 0 to FItems.Count - 1 do
    begin
      LItem := TJSONObject.Create;
      LItem.AddPair('scope', ScopeToString(FItems[I].Scope));
      LItem.AddPair('key', FItems[I].Key);
      LItem.AddPair('value', FItems[I].Value);
      LItems.AddElement(LItem);
    end;

    if ExtractFilePath(AFileName) <> '' then
      TDirectory.CreateDirectory(ExtractFilePath(AFileName));
    TFile.WriteAllText(AFileName, LRoot.ToJSON, TEncoding.UTF8);
  finally
    LRoot.Free;
  end;
end;

procedure TDCFlexLanguage.RemoveChangeListener(AHandler: TNotifyEvent);
var
  I: Integer;
begin
  for I := FChangeListeners.Count - 1 downto 0 do
    if FChangeListeners[I].SameHandler(AHandler) then
      FChangeListeners.Delete(I);
end;

procedure TDCFlexLanguage.SetItems(const Value: TDCFlexLanguageItems);
begin
  FItems.Assign(Value);
  Changed;
end;

procedure TDCFlexLanguage.SetLanguage(const Value: TDCFlexLanguageCode);
begin
  if FLanguage <> Value then
  begin
    FLanguage := Value;
    Changed;
  end;
end;

procedure TDCFlexLanguage.SetText(AScope: TDCFlexLanguageScope; const AKey,
  AValue: string);
var
  LItem: TDCFlexLanguageItem;
begin
  if AKey = '' then
    Exit;

  LItem := FItems.Find(AScope, AKey);
  if not Assigned(LItem) then
  begin
    LItem := FItems.Add;
    LItem.Scope := AScope;
    LItem.Key := AKey;
  end;
  LItem.Value := AValue;
  Changed;
end;

function TDCFlexLanguage.ScopeToString(AScope: TDCFlexLanguageScope): string;
begin
  case AScope of
    dlsGrid: Result := 'grid';
    dlsScheduler: Result := 'scheduler';
    dlsKanban: Result := 'kanban';
    dlsSheets: Result := 'sheets';
  else
    Result := 'common';
  end;
end;

function TDCFlexLanguage.StringToScope(
  const AValue: string): TDCFlexLanguageScope;
var
  S: string;
begin
  S := LowerCase(Trim(AValue));
  if S = 'grid' then
    Result := dlsGrid
  else if S = 'scheduler' then
    Result := dlsScheduler
  else if S = 'kanban' then
    Result := dlsKanban
  else if S = 'sheets' then
    Result := dlsSheets
  else
    Result := dlsCommon;
end;

function TDCFlexLanguage.Text(AScope: TDCFlexLanguageScope; const AKey,
  ADefault: string): string;
var
  LItem: TDCFlexLanguageItem;
begin
  LItem := FItems.Find(AScope, AKey);
  if Assigned(LItem) and (LItem.Value <> '') then
    Exit(LItem.Value);

  Result := DefaultText(AScope, AKey, ADefault);
end;

end.
