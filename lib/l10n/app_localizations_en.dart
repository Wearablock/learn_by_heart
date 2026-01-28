// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Learn by Heart - Memorize';

  @override
  String get homeTitle => 'My Cards';

  @override
  String get emptyStateTitle => 'No cards yet';

  @override
  String get emptyStateSubtitle => 'Add your first card to start memorizing';

  @override
  String get addCardButton => 'Add Card';

  @override
  String cardStudyCount(int count) {
    return '$count times studied';
  }

  @override
  String get cardContentHint => 'Enter text to memorize';

  @override
  String get deleteCard => 'Delete Card';

  @override
  String get deleteCardConfirm => 'Are you sure you want to delete this card?';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get addCard => 'Add Card';

  @override
  String get editCard => 'Edit Card';

  @override
  String get cardContent => 'Content';

  @override
  String get cardContentRequired => 'Content is required';

  @override
  String get cardHint => 'Hint (optional)';

  @override
  String get cardHintPlaceholder => 'Enter a hint to help remember';

  @override
  String get discardChanges => 'Discard Changes';

  @override
  String get discardChangesMessage => 'You have unsaved changes. Discard them?';

  @override
  String get keepEditing => 'Keep Editing';

  @override
  String get discard => 'Discard';

  @override
  String get startStudy => 'Start Study';

  @override
  String get studying => 'Studying';

  @override
  String get enterAnswer => 'Enter your answer';

  @override
  String get submit => 'Submit';

  @override
  String get correct => 'Correct!';

  @override
  String get incorrect => 'Incorrect';

  @override
  String get yourAnswer => 'Your answer';

  @override
  String get correctAnswerLabel => 'Correct answer';

  @override
  String get next => 'Next';

  @override
  String get studyComplete => 'Study Complete';

  @override
  String get accuracy => 'Accuracy';

  @override
  String get wrongAnswers => 'Wrong Answers';

  @override
  String get studyAgain => 'Study Again';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get noCardsToStudy => 'No cards to study';

  @override
  String get studyExitConfirm => 'Your progress will be lost. Exit study?';

  @override
  String get exit => 'Exit';
}
