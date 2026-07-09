# DCFlexGrid for Delphi VCL

Modern, lightweight and native VCL grid component for Delphi.

DCFlexGrid Community is the free entry point of the DCFlex Suite. It is built
for Delphi developers who want a clean grid experience without bringing a large
third-party framework into the project.

The component is focused on:

- native VCL rendering
- fast and lightweight behavior
- modern visual polish
- Delphi XE7+ compatibility
- clean source code
- practical APIs for real business systems

## Editions

### Community

This public repository contains the free Community edition:

- `TDCFlexGrid`
- shared DCFlex core package used by the grid
- `DCFlex.Theme`, `DCFlex.Language`, `DCFlex.Controls`, `DCFlex.PopupMenu`
  and `DCFlex.Dialogs`
- visual rules designer
- color picker and themed controls used by the grid UI
- English/Portuguese language infrastructure
- VCL demo project
- full source code for the free package

### Pro Suite

The commercial DCFlex Suite Pro is being built on top of the same visual and
architecture standards.

Planned and evolving Pro components:

- `TDCFlexScheduler` - professional calendar/scheduler
- `TDCFlexKanban` - native VCL Kanban board
- `TDCFlexSheets` - spreadsheet-style component
- `TDCFlexMarkdown` - Markdown preview/rendering component
- `TDCFlexReport` - report/print/preview component
- `TDCFlexDashboard` - planned dashboard layer

The Community grid stays free. The Pro suite is intended for developers who
want a complete commercial VCL component set with the same lightweight style.

## Features

### Grid

- native VCL custom-drawn grid
- DataSet support
- optional search bar
- sortable columns
- column visibility menu
- footer summaries
- currency/number formatting support
- master/detail visual expansion
- visual rules/highlight system
- layout persistence
- modern popup menu
- light/dark-ready shared controls
- Delphi design-time package

### Visual Rules Designer

DCFlexGrid includes a visual rules designer so end users or developers can
configure highlight rules without hard-coding each visual state.

Supported rule options include:

- field selection
- condition selection
- value matching
- apply to full row or cell only
- background color
- font color
- bold, italic and underline

Rules can be persisted with the grid configuration.

### Language Support

The shared `TDCFlexLanguage` component provides a central way to localize DCFlex
components.

Current baseline:

- built-in English and Portuguese
- custom JSON language files
- runtime language changes
- reusable dictionary keys for DCFlex components

Example:

```delphi
DCFlexLanguage1.Language := dlcPortuguese;
DCFlexLanguage1.ApplyToChildren(Self);
```

Custom translations can be loaded from JSON:

```delphi
DCFlexLanguage1.LoadFromFile('language.custom.json');
```

See:

- [Language API](docs/DCFlexLanguage_API.md)
- [Custom language sample](demo/language.custom.sample.json)

## Installation

Open:

```text
packages/community/DCFlexCommunity.groupproj
```

Build order:

1. `DCFlexCoreR`
2. `DCFlexCoreD`
3. `DCFlexGridCommunityR`
4. `DCFlexGridCommunityD`

Important: do not compile/install only the grid package. `DCFlexGrid` depends on
the shared Core package, which contains units such as `DCFlex.Theme`,
`DCFlex.Language`, `DCFlex.Controls`, `DCFlex.PopupMenu` and `DCFlex.Dialogs`.

Install these design-time packages in the IDE:

1. `DCFlexCoreD`
2. `DCFlexGridCommunityD`

If you previously installed an older DCFlexGrid package, uninstall it first and
restart Delphi before installing the new package layout. Delphi cannot load two
packages that contain the same unit.

More details:

- [Package layout](packages/README.md)

## Demo

Open the demo project:

```text
demo/DCFlexGridDemo.dproj
```

The demo shows:

- DataSet binding
- search/filter UI
- visual rules
- custom colors
- footer summaries
- column menu
- layout/rules persistence
- language sample file

## Quick Start

Drop `TDCFlexGrid` on a VCL form and connect it to a `TDataSource`.

```delphi
DCFlexGrid1.DataSource := DataSource1;
DCFlexGrid1.ShowSearch := True;
DCFlexGrid1.ShowFooter := True;
```

Enable the built-in popup menu:

```delphi
DCFlexGrid1.UseDefaultPopupMenu := True;
```

Open the Visual Rules Designer from code:

```delphi
DCFlexGrid1.ShowVisualRulesDesigner;
```

## Compatibility

- Delphi XE7+
- VCL only
- Windows desktop applications
- no unnecessary external dependencies

## Repository Structure

```text
src/                         Component source
packages/community/          Runtime/design-time packages
demo/                        Community demo
docs/                        Public documentation
```

## Commercial Roadmap

DCFlexGrid Community is only the first public component.

The larger goal is a professional VCL suite with a consistent visual language:

- grids
- schedulers
- Kanban boards
- spreadsheets
- Markdown previews
- reports
- dashboards
- shared themes
- shared localization
- reusable dialogs and controls

If you like the Community grid, the Pro suite is where the full product vision
is going.

## License

See [LICENSE.txt](LICENSE.txt).

## Author

Created by Diego Cataneo / Delphi Creative.

The Community edition is free and public. The Pro suite is commercial.
