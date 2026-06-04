unit DCFlex.Language;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Generics.Collections,
  System.JSON,
  System.IOUtils;

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

  TDCFlexLanguage = class(TComponent)
  private
    FItems: TDCFlexLanguageItems;
    FLanguage: TDCFlexLanguageCode;
    FChangeListeners: TObjectList<TDCFlexLanguageNotifyListener>;
    FOnChange: TNotifyEvent;
    procedure Changed;
    function DefaultText(AScope: TDCFlexLanguageScope; const AKey,
      ADefault: string): string;
    procedure SetItems(const Value: TDCFlexLanguageItems);
    procedure SetLanguage(const Value: TDCFlexLanguageCode);
    function ScopeToString(AScope: TDCFlexLanguageScope): string;
    function StringToScope(const AValue: string): TDCFlexLanguageScope;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddChangeListener(AHandler: TNotifyEvent);
    procedure Assign(Source: TPersistent); override;
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

function TDCFlexLanguage.DefaultText(AScope: TDCFlexLanguageScope; const AKey,
  ADefault: string): string;
var
  LKey: string;
begin
  Result := ADefault;
  LKey := LowerCase(AKey);

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
      if LKey = 'color.slate' then Exit('Ardosia');
      if LKey = 'color.dark.slate' then Exit('Ardosia escuro');
      if LKey = 'color.light.blue' then Exit('Azul claro');
      if LKey = 'color.blue' then Exit('Azul');
      if LKey = 'color.dark.blue' then Exit('Azul escuro');
      if LKey = 'color.indigo' then Exit('Indigo');
      if LKey = 'color.purple' then Exit('Roxo');
      if LKey = 'color.lavender' then Exit('Lavanda');
      if LKey = 'color.light.green' then Exit('Verde claro');
      if LKey = 'color.green' then Exit('Verde');
      if LKey = 'color.dark.green' then Exit('Verde escuro');
      if LKey = 'color.mint' then Exit('Menta');
      if LKey = 'color.teal' then Exit('Azul petroleo');
      if LKey = 'color.cyan' then Exit('Ciano');
      if LKey = 'color.light.yellow' then Exit('Amarelo claro');
      if LKey = 'color.yellow' then Exit('Amarelo');
      if LKey = 'color.soft.amber' then Exit('Ambar suave');
      if LKey = 'color.amber' then Exit('Ambar');
      if LKey = 'color.orange' then Exit('Laranja');
      if LKey = 'color.coral' then Exit('Coral');
      if LKey = 'color.light.red' then Exit('Vermelho claro');
      if LKey = 'color.red' then Exit('Vermelho');
      if LKey = 'color.light.pink' then Exit('Rosa claro');
      if LKey = 'color.pink' then Exit('Rosa');
      if LKey = 'color.rose' then Exit('Rose');
      if LKey = 'color.brown' then Exit('Marrom');
      if LKey = 'color.reset' then Exit('Redefinir');
      if LKey = 'color.standard' then Exit('PADRAO');
      if LKey = 'color.cancel' then Exit('Cancelar');
      if LKey = 'color.custom' then Exit('Personalizada ');
      if LKey = 'color.custom.color' then Exit('Cor personalizada...');
    end
    else if AScope = dlsSheets then
    begin
      if LKey = 'font.default' then Exit('Fonte padrao');
      if LKey = 'font.family' then Exit('Fonte');
      if LKey = 'font.size.default' then Exit('Padrao');
      if LKey = 'font.size' then Exit('Tamanho da fonte');
      if LKey = 'font.bold' then Exit('Negrito');
      if LKey = 'font.italic' then Exit('Italico');
      if LKey = 'font.underline' then Exit('Sublinhado');
      if LKey = 'align.left' then Exit('Alinhar a esquerda');
      if LKey = 'align.center' then Exit('Centralizar');
      if LKey = 'align.right' then Exit('Alinhar a direita');
      if LKey = 'number.format' then Exit('Formato numerico');
      if LKey = 'number.general' then Exit('Geral');
      if LKey = 'number.number' then Exit('Numero');
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
        Exit('Limpar formatacao das celulas selecionadas');
      if LKey = 'formula.cell' then Exit('Celula');
      if LKey = 'formula.value' then Exit('Formula');
      if LKey = 'edit.cut' then Exit('Recortar');
      if LKey = 'edit.copy' then Exit('Copiar');
      if LKey = 'edit.paste' then Exit('Colar');
      if LKey = 'edit.clear.contents' then Exit('Limpar conteudo');
      if LKey = 'row.insert' then Exit('Inserir linha');
      if LKey = 'row.delete' then Exit('Excluir linha');
      if LKey = 'column.insert' then Exit('Inserir coluna');
      if LKey = 'column.delete' then Exit('Excluir coluna');
      if LKey = 'selection.autofit' then Exit('Auto ajustar selecao');
      if LKey = 'cells.merge' then Exit('Mesclar celulas');
      if LKey = 'cells.unmerge' then Exit('Desmesclar celulas');
    end;
    if AScope = dlsScheduler then
    begin
      if LKey = 'event.caption' then Exit('Evento');
      if LKey = 'event.new.title' then Exit('Novo evento');
      if LKey = 'field.title' then Exit('Titulo');
      if LKey = 'field.start' then Exit('Inicio');
      if LKey = 'field.end' then Exit('Fim');
      if LKey = 'field.all.day' then Exit('Dia inteiro');
      if LKey = 'field.location' then Exit('Local');
      if LKey = 'field.color' then Exit('Cor');
      if LKey = 'field.text.color' then Exit('Cor do texto');
      if LKey = 'field.notes' then Exit('Observacoes');
      if LKey = 'recurrence.caption' then Exit('Repetir');
      if LKey = 'recurrence.until' then Exit('Ate');
      if LKey = 'recurrence.none' then Exit('Nao repetir');
      if LKey = 'recurrence.daily' then Exit('Diario');
      if LKey = 'recurrence.weekly' then Exit('Semanal');
      if LKey = 'recurrence.monthly' then Exit('Mensal');
      if LKey = 'ok' then Exit('OK');
      if LKey = 'cancel' then Exit('Cancelar');
      if LKey = 'event.untitled' then Exit('(Sem titulo)');
      if LKey = 'event.more' then Exit('+%d mais');
      if LKey = 'recurrence.this.occurrence' then Exit('Esta ocorrencia');
      if LKey = 'recurrence.this.future' then Exit('Esta e futuras');
      if LKey = 'recurrence.entire.series' then Exit('Serie inteira');
      if LKey = 'recurrence.edit.title' then Exit('Evento recorrente');
      if LKey = 'recurrence.edit.message' then
        Exit('Escolha se deseja editar somente esta ocorrencia ou a serie inteira.');
      if LKey = 'delete' then Exit('Excluir');
      if LKey = 'delete.event.title' then Exit('Excluir evento');
      if LKey = 'delete.event.message' then
        Exit('Este evento sera excluido permanentemente.');
      if LKey = 'delete.recurring.title' then Exit('Excluir evento recorrente');
      if LKey = 'delete.recurring.message' then
        Exit('Escolha se deseja excluir somente esta ocorrencia ou a serie inteira.');
      if LKey = 'weekday.sunday' then Exit('dom');
      if LKey = 'weekday.monday' then Exit('seg');
      if LKey = 'weekday.tuesday' then Exit('ter');
      if LKey = 'weekday.wednesday' then Exit('qua');
      if LKey = 'weekday.thursday' then Exit('qui');
      if LKey = 'weekday.friday' then Exit('sex');
      if LKey = 'weekday.saturday' then Exit('sab');
    end;
    if AScope = dlsKanban then
    begin
      if LKey = 'card.caption' then Exit('Card');
      if LKey = 'column.caption' then Exit('Coluna');
      if LKey = 'field.title' then Exit('Titulo');
      if LKey = 'field.name' then Exit('Nome');
      if LKey = 'field.description' then Exit('Descricao');
      if LKey = 'field.tag' then Exit('Etiqueta');
      if LKey = 'field.color' then Exit('Cor');
      if LKey = 'field.text.color' then Exit('Cor do texto');
      if LKey = 'ok' then Exit('OK');
      if LKey = 'cancel' then Exit('Cancelar');
      if LKey = 'card.untitled' then Exit('(Sem titulo)');
      if LKey = 'delete' then Exit('Excluir');
      if LKey = 'delete.card.title' then Exit('Excluir card');
      if LKey = 'delete.card.message' then
        Exit('Este card sera excluido permanentemente.');
      if LKey = 'delete.column.title' then Exit('Excluir coluna');
      if LKey = 'delete.column.message' then
        Exit('Esta coluna e todos os seus cards serao excluidos permanentemente.');
    end;
  end;
end;

destructor TDCFlexLanguage.Destroy;
begin
  FChangeListeners.Free;
  FItems.Free;
  inherited Destroy;
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
