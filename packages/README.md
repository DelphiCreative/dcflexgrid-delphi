# DCFlex Package Layout

This folder contains the new packaging structure for community and commercial
distribution.

The old packages under `src` are kept temporarily as compatibility/fallback
while the new package layout is validated.

## Community Distribution

Open `packages/community/DCFlexCommunity.groupproj`.

Before installing these new packages, uninstall the legacy package set from the
IDE if it is currently installed:

- `DCFlexGridD`

Then close and reopen Delphi. This is required because the legacy runtime
package `DCFlexGridR` contains units such as `DCFlex.Controls`, which now live
in `DCFlexCoreR`. Delphi cannot load two packages that contain the same unit.

Build order:

1. `DCFlexCoreR`
2. `DCFlexCoreD`
3. `DCFlexGridCommunityR`
4. `DCFlexGridCommunityD`

Install in the IDE:

- `DCFlexCoreD`
- `DCFlexGridCommunityD`

Community source units:

- `DCFlex.Language`
- `DCFlex.Theme`
- `DCFlex.Controls`
- `DCFlex.PopupMenu`
- `DCFlex.Dialogs`
- `DCFlexGrid`
- `DCFlexGrid.Fluent`
- `DCFlexGrid.Themes`
- `DCFlexGrid.VisualRulesDesigner`

Community package must not depend on Scheduler, Kanban or Sheets.

## Pro Distribution

Open `packages/pro/DCFlexSuitePro.groupproj`.

Build order:

1. `DCFlexCoreR`
2. `DCFlexSuiteProR`
3. `DCFlexSuiteProD`

Install in the IDE:

- `DCFlexCoreD` from the community package set, if not already installed.
- `DCFlexSuiteProD`.

Pro runtime units:

- Scheduler units
- Kanban units
- Sheets units

The Pro package depends on `DCFlexCoreR`, but does not depend on
`DCFlexGridCommunityR`. This lets customers install the paid suite without
requiring the free grid package, while still allowing both to coexist.

## WebUI Distribution

Open `DCFlexWebUI.groupproj` from the repository root.

Build order:

1. `DCFlexWebUIR`
2. `DCFlexWebUID`
3. `DCFlexWebUIDemo`
4. `DCFlexWebUIFinanceDemo`

Install in the IDE:

- `DCFlexWebUID`

WebUI runtime units:

- `DCFlexWebUI.Core`

Design-time units:

- `DCFlexWebUI.Reg`

The WebUI package is intentionally isolated from the Community and Pro VCL
component packages. It uses `TEdgeBrowser`/WebView2 and is meant for modern
local HTML/CSS/JavaScript screens hosted by Delphi.

Important distribution files:

- `packages/webui/DCFlexWebUIR/DCFlexWebUIR.dpk`
- `packages/webui/DCFlexWebUID/DCFlexWebUID.dpk`
- `demo/DCFlexWebUI-demo`
- `demo/DCFlexWebUI-vcl-crud-demo`
- `demo/DCFlexWebUI-finance-demo`
- `demo/DCFlexWebUI-finance-demo/README.md`

The VCL CRUD demo is the fastest adoption reference: a traditional VCL form
opens a second WebUI form with a complete customer CRUD persisted by Delphi.

The Finance demo is the recommended commercial reference because it shows CRUD,
SQLite persistence, dashboards, filters, dialogs, reports and a bridge console.

## Full Suite Development

Open `packages/DCFlexPackages.groupproj` to build all new packages in order.

## Binary Distribution

For a binary-only sale, ship per Delphi version and platform:

- runtime `.bpl`
- design-time `.bpl`
- `.dcp`
- `.dcu`
- optional `.hpp` for C++Builder
- docs and demos

Do not ship `.pas` files in the binary-only SKU.

Use `distribution/pro-binary.manifest` as the positive list for this SKU.

## Source Distribution

For a source license, include:

- `.pas`
- `.dfm`
- `.dpk`
- `.dproj`
- demos
- docs

The source SKU can include both community and pro packages.

Use these positive manifests when preparing releases:

- `distribution/community-source.manifest` for the free/community source ZIP.
- `distribution/pro-source.manifest` for the commercial full-source ZIP.
- `distribution/release-exclude.manifest` as the deny list for generated files, local IDE files, temporary sources and compiled artifacts.
