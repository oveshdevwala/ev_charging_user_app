# Sessions Monitoring Module (Admin)

## Purpose
Enterprise-grade monitoring for charging sessions with realtime, replay, alerts, exports, and auditability.

## Contents
- Data: DTOs, sources (remote/local/stream), repository impl
- Domain: Repository contract + usecases
- Presentation: BLoCs (list/detail/live/replay) + screens + widgets
- Util: CSV exporter, Pexels helpers, playback engine
- DI: `SessionsModule` for quick wiring

## Usage
1) Add `SessionsListScreen` into the Admin shell (already mapped to `AdminRoutes.sessions`).
2) Open session detail via `context.showAdminModal` to respect shell/tab rules.
3) Use `SessionsModule.buildRepository(dio)` to inject repository into blocs if you need custom Dio config.

## Realtime
- `AdminSessionsStreamSource` simulates websocket events in `devMode=true`.
- Replace with production adapter and keep `LiveSessionsBloc` unchanged.

## Exports
- `ExportSessionsUseCase` triggers server-side job; `SessionsCsvExporter` is a client fallback.

## Mock/Dev
- `devMode=true` reads `assets/dummy_data/admin/sessions.json` and streams synthetic events.

## Extending
- Add filters in `SessionsListBloc` state and propagate to `AdminSessionsRemoteSource`.
- Plug charts/maps by extending widgets in `presentation/widgets`.

