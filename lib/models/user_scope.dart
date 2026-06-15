/// Data-visibility scope for toggling between "my data" and "team data"
/// in dashboard, traces, and today screens.
///
/// Replaces the proto-generated `UserScope` enum that was removed in
/// proto v0.6.0 (`GetDashboardDataRequest.user_scope` → `environment` +
/// `project_id`).
enum UserScope {
  personal,
  global,
}
