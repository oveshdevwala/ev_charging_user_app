# Community Module

## Overview

The Community module provides a comprehensive review, photo sharing, Q&A, and issue reporting system for EV charging stations. It enables users to share their experiences, ask questions, report problems, and help build trust through verified reviews.

## Features

### ✅ Reviews & Ratings
- 1-5 star rating system with microcopy feedback
- Title and body text for detailed reviews
- Photo attachments (up to 6 per review)
- Verified session badge for users who charged
- Helpful votes and flagging system
- Anonymous posting option
- Edit/delete within time windows
- Sort by: Most Recent, Most Helpful, Highest/Lowest Rating

### 📸 Photo Gallery
- Grid-based photo display
- Full-screen photo viewer with swipe gestures
- Report inappropriate photos
- Progressive image loading

### ❓ Q&A System
- Ask questions about stations
- Post answers with photo attachments
- Upvote questions and mark answers as helpful
- Accept answers (question owner)
- Anonymous posting support

### 🚨 Issue Reporting
- Category-based reporting (Socket Broken, Slow Charging, Payment Failed, etc.)
- Photo attachment for evidence
- Anonymous reporting option
- Ticket ID tracking
- 48-hour response window

### 👮 Admin Moderation
- Reports queue with priority filtering
- Bulk actions (approve, remove, reject, escalate)
- Audit trail for all moderation actions
- User management (warn, suspend, ban)

## Architecture

```
lib/features/community/
├── bloc/
│   ├── community_cubit.dart      # Main cubit for community data
│   └── community_state.dart      # State classes for all cubits
├── models/
│   ├── community_review_model.dart
│   ├── community_summary_model.dart
│   ├── question_model.dart
│   └── report_model.dart
├── repositories/
│   └── community_repository.dart  # Interface + dummy implementation
├── services/
│   └── image_service.dart         # Image compression & validation
├── ui/
│   ├── admin/
│   │   └── moderation_console_page.dart
│   ├── community_panel.dart       # Embeddable panel for station details
│   ├── leave_review_page.dart
│   ├── question_detail_page.dart
│   └── station_community_page.dart
├── widgets/
│   ├── photo_grid.dart
│   ├── question_card.dart
│   ├── report_modal.dart
│   ├── review_card.dart
│   └── star_rating_widget.dart
└── community.dart                 # Barrel export
```

## Usage

### Embedding Community Panel in Station Details

```dart
CommunityPanel(
  stationId: 'station_123',
  onWriteReview: () => context.push('/leaveReview/station_123'),
  onAskQuestion: () => _showAskQuestionSheet(),
  onReportIssue: () => ReportModal.show(context: context, ...),
)
```

### Opening Full Community Page

```dart
context.push(AppRoutes.stationCommunity.id('station_123'));
```

### Leave Review Page

```dart
context.push(
  '${AppRoutes.leaveReview.path}/station_123?name=Station%20Name',
);
```

### Report Modal

```dart
ReportModal.show(
  context: context,
  targetType: ReportTargetType.station,
  targetId: 'station_123',
  onSubmit: (category, description, isAnonymous) async {
    // Handle report submission
  },
);
```

## Models

### CommunityReviewModel
```dart
CommunityReviewModel(
  id: 'review_1',
  stationId: 'station_1',
  rating: 4.5,
  title: 'Great experience',
  body: 'Fast charging...',
  photos: [...],
  isVerifiedSession: true,
  isAnonymous: false,
  helpfulCount: 12,
)
```

### QuestionModel
```dart
QuestionModel(
  id: 'question_1',
  stationId: 'station_1',
  text: 'Does this support CCS2?',
  upvotesCount: 5,
  hasAcceptedAnswer: true,
  answers: [...],
)
```

### ReportModel
```dart
ReportModel(
  targetType: ReportTargetType.station,
  targetId: 'station_1',
  category: ReportCategory.socketBroken,
  description: 'The connector is damaged',
  status: ReportStatus.open,
  priority: ReportPriority.high,
)
```

## State Management

### CommunityCubit
- `loadCommunityData()` - Load all community data
- `refreshCommunityData()` - Pull-to-refresh
- `selectTab(tab)` - Switch between tabs
- `toggleReviewHelpful(reviewId)` - Optimistic helpful toggle
- `toggleQuestionUpvote(questionId)` - Optimistic upvote
- `changeReviewSort(option)` - Change sort order

### ReviewEditorCubit
- `updateRating(rating)` - Set star rating
- `updateTitle/Body(text)` - Update text fields
- `addPhoto/removePhoto(path)` - Manage photos
- `toggleVerifiedSession/Anonymous(value)` - Toggle options
- `submitReview()` - Submit the review

### QACubit
- `loadQuestion(questionId)` - Load question with answers
- `submitAnswer(questionId)` - Post an answer
- `acceptAnswer(answerId)` - Mark as accepted
- `toggleAnswerHelpful(answerId)` - Toggle helpful

## Customization

### Trust Score Calculation
The trust score is calculated in `DummyCommunityRepository._calculateTrustScore()`:
- Weight 40%: Average rating (normalized 0-1)
- Weight 30%: Verified review ratio
- Weight 30%: Review count (normalized, max 50)

### Moderation Auto-Hide Rules
Reviews are auto-hidden when:
- Flags count > 3 within 24 hours
- Profanity classifier score > threshold

### Time Windows
- Review edit window: 60 minutes
- Answer edit window: 15 minutes

## Dependencies

Add these to your `pubspec.yaml`:
```yaml
dependencies:
  timeago: ^3.7.0
  uuid: ^4.5.1
  path_provider: ^2.1.4
  # Optional for full image processing:
  # image_picker: ^1.1.2
  # image: ^4.5.3
```

## Routes

| Route | Description |
|-------|-------------|
| `/stationCommunity/:stationId` | Full community page |
| `/leaveReview/:stationId` | Leave review page |
| `/adminModeration` | Admin moderation console |

## Localization

All strings are defined in `lib/core/constants/app_strings.dart` under:
- `// ============ Community & Reviews ============`
- `// ============ Report Categories ============`
- `// ============ Moderation ============`

## Testing

The module includes comprehensive dummy data for testing:
- 5 sample reviews with varied ratings and content
- 3 sample questions with answers
- Multiple report scenarios
- User profiles with badges

## Future Enhancements

- [ ] Push notifications for replies/flags
- [ ] ML-based toxicity detection
- [ ] Image NSFW detection
- [ ] Offline draft sync
- [ ] Export moderation reports to CSV
- [ ] User appeal workflow

