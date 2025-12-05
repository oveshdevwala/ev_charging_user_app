/// File: lib/features/profile/bloc/support_event.dart
/// Purpose: Support BLoC events
/// Belongs To: profile feature
library;

/// Base class for support events.
abstract class SupportEvent {
  const SupportEvent();
}

/// Load FAQ event.
class LoadFAQ extends SupportEvent {
  const LoadFAQ();
}

/// Submit ticket event.
class SubmitTicket extends SupportEvent {
  const SubmitTicket({
    required this.subject,
    required this.message,
    this.attachments,
  });

  final String subject;
  final String message;
  final List<String>? attachments;
}

/// Load tickets event.
class LoadTickets extends SupportEvent {
  const LoadTickets();
}

/// Load privacy policy event.
class LoadPrivacyPolicy extends SupportEvent {
  const LoadPrivacyPolicy();
}

/// Load terms of service event.
class LoadTermsOfService extends SupportEvent {
  const LoadTermsOfService();
}

/// Clear support error event.
class ClearSupportError extends SupportEvent {
  const ClearSupportError();
}

