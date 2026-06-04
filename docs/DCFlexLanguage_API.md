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
DCFlexSheetsToolbar1.LanguageSource := DCFlexLanguage1;
DCFlexSheetsFormulaBar1.LanguageSource := DCFlexLanguage1;
DCFlexColorPicker1.LanguageSource := DCFlexLanguage1;
DCFlexColorPaletteButton1.LanguageSource := DCFlexLanguage1;
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
- `TDCFlexSheetsToolbar`
- `TDCFlexSheetsFormulaBar`
- `TDCFlexColorPicker`
- `TDCFlexColorPaletteButton`

Existing local language properties remain available for compatibility when
`LanguageSource` is not assigned.

## Current Built-In Languages

- English
- Portuguese

## Current Scopes

- `dlsCommon`
- `dlsGrid`
- `dlsScheduler`
- `dlsKanban`
- `dlsSheets`
