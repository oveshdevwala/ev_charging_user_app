# Sessions Monitoring Runbook (Admin)

## Overview
This runbook guides admins/operators to monitor and intervene on charging sessions using the Sessions module.

## Daily Monitoring
- Open the Sessions tab (Admin shell) to view KPIs and the live feed.
- Use filters/search to narrow by status, station, or user.
- Pin a session in the live feed to keep telemetry visible.

## Investigating a Session
1) From the table, open **Session Details** (opens in modal sheet).
2) Review timeline, telemetry, and event log.
3) If anomalies are found, create an Incident (button in detail header).
4) Download raw telemetry via the Export section (CSV/JSON/PDF when backend wired).

## Replay
- Open **Session Replay** from the list side panel to scrub telemetry with speed controls.
- Use playback to correlate events with map/chart when integrated.

## Alerts & Incidents
- Incidents can be created from detail view. Severity/status are captured for audit.
- Alert rules are planned to be configured via the settings panel (placeholder).

## Exports
- Select rows in the Sessions table and choose **Export CSV/JSON/PDF** (job-based).
- Client fallback CSV is available in dev mode.

## Realtime Stream
- Live feed connects automatically (dev-mode mock). If disconnected:
  - Hit Refresh/Connect again.
  - Fallback to polling by disabling websocket in `AdminSessionsStreamSource` (set `devMode=false` and provide adapter).

## Retention & Archival
- Placeholder toggle planned in settings. For now, purge/archive via backend tools.

## RBAC
- Actions (stop/pause/flag/export) must respect backend RBAC. UI is permissive until wired.

## Troubleshooting
- Empty table: confirm API available or devMode dataset reachable.
- Live stream silent: verify websocket endpoint, network, and ensure only one listener is active.
- Export job not returned: check backend logs; client shows last error in toast/snackbar.

