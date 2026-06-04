# DCFlexLanguage - Manual Test Checklist

Use this checklist after changing localization, dialogs, color controls or demo
language selectors.

## Package

- Compile `DCFlexGridR.dproj`.
- Confirm `TDCFlexLanguage` is available in the DCFlex component palette.
- Drop `TDCFlexLanguage` on a blank VCL form.
- Change `Language` between `dlcEnglish` and `dlcPortuguese`.
- Add a custom item in `Items` and confirm it persists in the DFM.

## Shared Controls

- Drop `TDCFlexColorPicker` and connect `LanguageSource`.
- Change `LanguageSource.Language` at runtime.
- Open the color popup and confirm color names update.
- Repeat with `TDCFlexColorPaletteButton`.
- Confirm both controls still work when `LanguageSource` is empty.

## Scheduler

- Compile and run `DCFlexSchedulerDemo`.
- Switch language to English and Portuguese.
- Confirm day headers update.
- Double-click to create an event and confirm editor labels update.
- Create a recurring event and edit one occurrence.
- Delete a regular event and confirm the delete dialog language.
- Delete a recurring event and confirm the recurring delete dialog language.
- Confirm the old `Scheduler.Language` property still works when
  `LanguageSource` is not assigned.

## Kanban

- Compile and run `DCFlexKanbanDemo`.
- Switch language to English and Portuguese.
- Create/edit a card and confirm editor labels update.
- Create/edit a column and confirm editor labels update.
- Delete a card and confirm the delete dialog language.
- Delete a column and confirm the delete dialog language.
- Confirm the old editor language parameter still works when no
  `LanguageSource` is passed.

## Sheets

- Compile and run `DCFlexSheetsDemo`.
- Switch language to English and Portuguese.
- Confirm toolbar hints/captions update.
- Confirm the formula bar labels update.
- Open the built-in context menu and confirm captions update.
- Confirm color controls update in the toolbar.
- Confirm old `Language` enum properties still work when `LanguageSource` is
  not assigned.

## Custom JSON

- Load `demo/language.custom.sample.json` into a `TDCFlexLanguage` instance.
- Confirm custom keys override built-in strings.
- Save to a new JSON file.
- Reload the saved file and confirm custom strings remain.
