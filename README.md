# DCFlex Suite

Modern Delphi VCL component suite.

Packaging and commercial distribution:
- [DCFlex Distribution Strategy](docs/DCFlex_DISTRIBUTION_STRATEGY.md)
- [Package Layout](packages/README.md)

## Components

### DCFlexLanguage
Shared localization component for the suite.

Documentation:
- [DCFlexLanguage API Guide](docs/DCFlexLanguage_API.md)
- [DCFlexLanguage Roadmap](docs/DCFlexLanguage_ROADMAP.md)
- [DCFlexLanguage Manual Test Checklist](docs/DCFlexLanguage_MANUAL_TEST_CHECKLIST.md)

Current baseline:
- non-visual VCL component
- built-in English and Portuguese language codes
- common, grid, scheduler, kanban and sheets scopes
- custom string overrides
- JSON save/load for customer-specific translations
- runtime change notification through `OnChange`
- direct `LanguageSource` binding for Scheduler, Kanban, Sheets, Sheets toolbar,
  Sheets formula bar and shared color controls

Basic usage:

```delphi
DCFlexLanguage1.Language := dlcPortuguese;

DCFlexScheduler1.LanguageSource := DCFlexLanguage1;
DCFlexKanban1.LanguageSource := DCFlexLanguage1;
DCFlexSheets1.LanguageSource := DCFlexLanguage1;
DCFlexSheetsToolbar1.LanguageSource := DCFlexLanguage1;
```

Custom language files can be loaded with:

```delphi
DCFlexLanguage1.LoadFromFile('language.custom.json');
```

Sample file:
- [language.custom.sample.json](demo/language.custom.sample.json)

### DCFlexGrid
Modern data grid component.

Positioning:
- free community component
- public GitHub release through Delphi Creative
- entry point for the DCFlex Suite
- includes Visual Rules Designer and shared color picker polish

### DCFlexScheduler
Professional scheduler/calendar component.

Current baseline:
- native VCL day, week and month views
- event editor with modern color picker
- drag/drop move and resize
- native horizontal and vertical scrollbars in day/week views
- JSON and DataSet persistence
- SQLite demo persistence
- demo storage selector for DataSet, database and JSON file modes
- daily, weekly and monthly recurrence
- occurrence exceptions for edited/deleted recurring events
- Portuguese and English language support
- optional `LanguageSource` integration for suite-wide localization
- Delphi XE7+ compatible architecture

### DCFlexKanban
Professional Kanban board component.

Current baseline:
- native VCL board rendering
- configurable columns and cards
- lightweight theme object
- card click/selection event
- visible card selection and drop target feedback
- card drag/drop with insertion ordering
- public events for board/card/column changes
- reusable card editor dialog with color picker support
- card delete action with confirmation
- board and column creation actions in the demo
- column edit/delete actions with confirmation
- English and Portuguese demo/editor language switch
- optional `LanguageSource` integration for suite-wide localization
- multiple named boards persisted by the demo
- JSON and DataSet persistence support
- in-memory DataSet demo for adapter validation
- DataSet adapter preserves column/card order through an order field
- SQLite demo persistence
- demo storage selector for DataSet, database and JSON file modes
- standalone demo scaffold

DataSet adapter default fields:
- columns: id, titulo, cor, ordem
- cards: id, coluna_id, titulo, descricao, etiqueta, cor, cor_texto, ordem

### DCFlexSheets
Professional spreadsheet component.

Documentation:
- [DCFlexSheets API Guide](docs/DCFlexSheets_API.md)
- [DCFlexSheets Release Roadmap](docs/DCFlexSheets_RELEASE_ROADMAP.md)
- [DCFlexSheets Release Checklist](docs/DCFlexSheets_RELEASE_CHECKLIST.md)

- native VCL spreadsheet rendering
- row and column headers
- cell selection and inline editing
- keyboard navigation with direct typing, Enter and Tab
- Home, End, PageUp, PageDown, Ctrl+Home and Ctrl+End navigation
- viewport scrolling and formula bar demo
- native horizontal and vertical scrollbars
- formula bar apply on Enter/focus exit and cancel with Escape
- copy, paste, cut and delete actions
- built-in context menu with cut, copy, paste, clear, insert/delete rows,
  insert/delete columns, autofit, merge and unmerge
- English and Portuguese language support for the built-in context menu
- optional `LanguageSource` integration for sheets, toolbar and formula bar
- configurable visual colors for headers, gridlines, selection and active cell
- ReadOnly mode for user-facing editing actions
- optional header resize behavior
- cell select and cell change events for host applications
- undo and redo actions with keyboard shortcuts
- CSV import and export
- CSV export of filtered/visible rows
- JSON and CSV file dialogs in the demo
- row and column insert/delete actions
- range selection with mouse drag and Shift+arrow keys
- highlighted row and column headers for the current selection
- header drag resizing for column width and row height
- per-column width and per-row height persistence
- JSON persistence for visual layout settings
- AutoFit action for selected columns
- invalid formula feedback with #ERR display
- horizontal cell alignment with JSON persistence
- numeric formats for general, number, currency and percent
- organized demo toolbar for sheet actions and formatting
- sparse cell model with value and basic styling
- formulas with cell references, ranges, arithmetic precedence and common
  functions: SUM, AVG/AVERAGE, MIN, MAX, COUNT, PRODUCT, ROUND and ABS
- simple text filter by selected column
- selected-cell formatting actions in the demo
- JSON persistence
- paid professional suite component

### DCFlexReport
Planned professional reporting component.

Initial direction:
- report bands and printable layout
- DataSet and JSON data sources
- preview, print and export baseline
- visual designer exploration after engine MVP

### DCFlexMarkdown
Planned professional Markdown component.

Initial direction:
- VCL Markdown preview component
- editor/preview workflow
- lightweight parser/rendering baseline
- styling hooks for product documentation and rich notes

### FMX Suite
Planned future expansion after VCL stabilization.

Direction:
- keep shared non-visual core where practical
- create FMX-native renderers and controls
- migrate only after VCL APIs are stable

## Future Ideas

- Custom editor field hooks for Scheduler and Kanban dialogs.

## Vision

A lightweight and modern alternative to heavy commercial suites.
