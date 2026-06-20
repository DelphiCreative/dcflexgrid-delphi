# DCFlexLanguage API Guide

`TDCFlexLanguage` is a non-visual component used to centralize localization for
the DCFlex suite.

## Basic Usage

```delphi
DCFlexLanguage1.Language := dlcPortuguese;

Caption := DCFlexLanguage1.Text(dlsCommon, 'save', 'Save');
```

When a key has no custom value and no built-in translation, `Text` returns the
provided default value.

## Custom Strings

```delphi
DCFlexLanguage1.SetText(dlsSheets, 'style.clear', 'Remove formatting');
DCFlexLanguage1.SetText(dlsScheduler, 'event.title', 'Appointment');
```

Custom strings always win over built-in defaults.

## DCFlex Component Binding

Components that expose `LanguageSource` can be connected directly:

```delphi
DCFlexLanguage1.Language := dlcPortuguese;

DCFlexScheduler1.LanguageSource := DCFlexLanguage1;
DCFlexKanban1.LanguageSource := DCFlexLanguage1;
DCFlexSheets1.LanguageSource := DCFlexLanguage1;
DCFlexGrid1.LanguageSource := DCFlexLanguage1;
DCFlexSheetsToolbar1.LanguageSource := DCFlexLanguage1;
DCFlexSheetsFormulaBar1.LanguageSource := DCFlexLanguage1;
DCFlexColorPicker1.LanguageSource := DCFlexLanguage1;
DCFlexColorPaletteButton1.LanguageSource := DCFlexLanguage1;
DCFlexToggleButton1.LanguageSource := DCFlexLanguage1;
```

When `Language` changes, connected controls refresh through internal change
listeners. The public `OnChange` event remains available for application code.

## Persistence

```delphi
DCFlexLanguage1.SaveToFile('customer-language.json');
DCFlexLanguage1.LoadFromFile('customer-language.json');
DCFlexLanguage1.ResetToDefaults;
```

The JSON file stores only custom items and the selected language.

## Custom JSON Example

See `demo/language.custom.sample.json` for a small customer-specific language
file. Its shape is:

```json
{
  "formatVersion": 1,
  "language": 2,
  "items": [
    {
      "scope": "scheduler",
      "key": "event.caption",
      "value": "Appointment"
    }
  ]
}
```

`language` uses the ordinal value of `TDCFlexLanguageCode`:

- `0`: `dlcEnglish`
- `1`: `dlcPortuguese`
- `2`: `dlcCustom`

## Connected Components

Current direct integrations:

- `TDCFlexScheduler`
- `TDCFlexKanban`
- `TDCFlexSheets`
- `TDCFlexGrid`
- `TDCFlexSheetsToolbar`
- `TDCFlexSheetsFormulaBar`
- `TDCFlexColorPicker`
- `TDCFlexColorPaletteButton`
- `TDCFlexToggleButton`

Existing local language properties remain available for compatibility when
`LanguageSource` is not assigned.

## Applying To Existing VCL Forms

`TDCFlexLanguage` can also apply translations to ordinary VCL components that
publish `Caption` and `Hint`, including labels, buttons, check boxes, radio
buttons, group boxes, tab sheets and menu items.

```delphi
procedure TForm1.ApplyLanguage;
begin
  DCFlexLanguage1.Language := dlcPortuguese;
  DCFlexLanguage1.ApplyToChildren(Self);
end;
```

The default key is the component name:

```delphi
DCFlexLanguage1.SetText(dlsCommon, 'btnSave.caption', 'Salvar pedido');
DCFlexLanguage1.SetText(dlsCommon, 'btnSave.hint', 'Grava os dados atuais');
```

For common button names such as `btnSave`, `btnLoad`, `btnCancel`,
`btnDelete`, `btnClear`, `btnReset` and matching menu item names, the component
also falls back to the built-in common keys.

For a single control:

```delphi
DCFlexLanguage1.ApplyTo(btnSave);
```

For custom key prefixes:

```delphi
DCFlexLanguage1.SetText(dlsCommon, 'orderForm.btnSave.caption', 'Salvar');
DCFlexLanguage1.ApplyToChildren(Self, dlsCommon, True, 'orderForm');
```

## Extracting A Form Dictionary

For application forms, the useful workflow is to extract a template from the
form once, translate the JSON file, and load it at runtime:

```delphi
DCFlexLanguage1.ResetToDefaults;
DCFlexLanguage1.ExtractFromChildren(Self);
DCFlexLanguage1.SaveToFile('languages\en-US.json');
```

At runtime:

```delphi
DCFlexLanguage1.LoadFromFile('languages\pt-BR.json');
DCFlexLanguage1.ApplyToChildren(Self);
```

`ExtractFromChildren` uses the same key convention as `ApplyToChildren`.
For example:

- `btnSave.Caption` becomes `btnSave.caption`
- `btnSave.Hint` becomes `btnSave.hint`
- `miFile.Caption` becomes `miFile.caption`
- `tsCustomer.Caption` becomes `tsCustomer.caption`

This extraction layer is additive. The suite components still use
`Text(Scope, Key, Default)` and their built-in keys continue to work.

## Current Built-In Languages

- English
- Portuguese

## Current Scopes

- `dlsCommon`
- `dlsGrid`
- `dlsScheduler`
- `dlsKanban`
- `dlsSheets`
