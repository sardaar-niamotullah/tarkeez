import 'package:tarkeez/core/localization/form_strings.dart';
import 'package:tarkeez/core/localization/others_strings.dart';
import 'package:tarkeez/core/shared_files/cubits/language_cubit.dart';
import 'package:tarkeez/core/shared_files/models/app_string_model.dart';
import 'package:tarkeez/features/leaderboard/presentation/localization/leaderboard_strings.dart';
import 'package:tarkeez/features/profile/presentation/localization/profile_page_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/localization/common_strings.dart';
import 'package:tarkeez/features/home/presentation/localization/home_page_strings.dart';
import 'package:tarkeez/features/others/customer_care/presentation/localization/customer_care_page_strings.dart';
import 'package:tarkeez/features/others/terms_and_conditions/presentation/localization/terms_and_conditions_page_strings.dart';
import 'package:tarkeez/features/others/user_manual/presentation/localization/user_manual_page_strings.dart';
import 'package:tarkeez/features/projects/presentation/localization/projects_strings.dart';
import 'package:tarkeez/features/report/presentation/localization/report_strings.dart';
import 'package:tarkeez/features/settings/presentation/localization/settings_strings.dart';
import 'package:tarkeez/features/subscription/presentation/localization/subscription_page_strings.dart';

class AppTexts {
  final AppLanguage _lang;

  const AppTexts._(this._lang);

  factory AppTexts.of(BuildContext context) {
    final lang = context.watch<LanguageCubit>().state;
    return AppTexts._(lang);
  }

  String _r(AppStringModel model) =>
      _lang == AppLanguage.bangla ? model.bn : model.en;

  // ──────────────────────────────────────────────
  // Common
  // ──────────────────────────────────────────────
  String get appTitle => _r(CommonStrings.appTitle);
  String get appTagLine => _r(CommonStrings.appTagLine);
  String get appVersion => _r(CommonStrings.appVersion);
  String get ok => _r(CommonStrings.ok);
  String get submit => _r(CommonStrings.submit);
  String get save => _r(CommonStrings.save);
  String get menu => _r(CommonStrings.menu);
  String get cancel => _r(CommonStrings.cancel);
  String get download => _r(CommonStrings.download);
  String get next => _r(CommonStrings.next);

  // ──────────────────────────────────────────────
  // Form
  // ──────────────────────────────────────────────
  String get fullName => _r(FormStrings.fullName);
  String get fullNameHint => _r(FormStrings.fullNameHint);
  String get emailAddress => _r(FormStrings.emailAddress);
  String get emailAddressHint => _r(FormStrings.emailAddressHint);
  String get bio => _r(FormStrings.bio);
  String get bioHint => _r(FormStrings.bioHint);
  String get profession => _r(FormStrings.profession);
  String get professionHint => _r(FormStrings.professionHint);
  String get education => _r(FormStrings.education);
  String get educationHint => _r(FormStrings.educationHint);
  String get details => _r(FormStrings.details);
  String get detailsHint => _r(FormStrings.detailsHint);
  String get image => _r(FormStrings.image);

  // ──────────────────────────────────────────────
  // Profile
  // ──────────────────────────────────────────────
  String get profile => _r(ProfilePageStrings.profile);
  String get updateProfileDetails =>
      _r(ProfilePageStrings.updateProfileDetails);
  String get accountDetails => _r(ProfilePageStrings.accountDetails);

  // ──────────────────────────────────────────────
  // Projects
  // ──────────────────────────────────────────────
  String get projects => _r(ProjectsStrings.projects);

  // ──────────────────────────────────────────────
  // Customer care
  // ──────────────────────────────────────────────
  String get customerCare => _r(CustomerCarePageStrings.customerCare);
  String get requestReceived => _r(CustomerCarePageStrings.requestReceived);
  String get requestReceivedMessage =>
      _r(CustomerCarePageStrings.requestReceivedMessage);
  String get supportHeader => _r(CustomerCarePageStrings.supportHeader);
  String get supportSubtext => _r(CustomerCarePageStrings.supportSubtext);
  String get yourDetails => _r(CustomerCarePageStrings.yourDetails);
  String get nameLabel => _r(CustomerCarePageStrings.nameLabel);
  String get nameHint => _r(CustomerCarePageStrings.nameHint);
  String get contactNumberLabel =>
      _r(CustomerCarePageStrings.contactNumberLabel);
  String get contactNumberHint => _r(CustomerCarePageStrings.contactNumberHint);
  String get describeIssue => _r(CustomerCarePageStrings.describeIssue);
  String get problemLabel => _r(CustomerCarePageStrings.problemLabel);
  String get problemHint => _r(CustomerCarePageStrings.problemHint);

  // ──────────────────────────────────────────────
  // Leaderboard
  // ──────────────────────────────────────────────
  String get leaderboard => _r(LeaderboardStrings.leaderboard);

  // ──────────────────────────────────────────────
  // Terms and conditions
  // ──────────────────────────────────────────────
  String get termsAndConditions =>
      _r(TermsAndConditionsPageStrings.termsAndConditions);
  String get terms1 => _r(TermsAndConditionsPageStrings.terms1);
  String get terms2 => _r(TermsAndConditionsPageStrings.terms2);
  String get terms3 => _r(TermsAndConditionsPageStrings.terms3);
  String get terms4 => _r(TermsAndConditionsPageStrings.terms4);
  String get terms5 => _r(TermsAndConditionsPageStrings.terms5);
  String get terms6 => _r(TermsAndConditionsPageStrings.terms6);
  String get terms7 => _r(TermsAndConditionsPageStrings.terms7);
  String get terms8 => _r(TermsAndConditionsPageStrings.terms8);
  String get terms9 => _r(TermsAndConditionsPageStrings.terms9);
  String get terms10 => _r(TermsAndConditionsPageStrings.terms10);
  String get terms11 => _r(TermsAndConditionsPageStrings.terms11);
  String get terms12 => _r(TermsAndConditionsPageStrings.terms12);
  String get terms13 => _r(TermsAndConditionsPageStrings.terms13);
  String get terms14 => _r(TermsAndConditionsPageStrings.terms14);
  String get terms15 => _r(TermsAndConditionsPageStrings.terms15);

  // ──────────────────────────────────────────────
  // Home tab
  // ──────────────────────────────────────────────
  String get home => _r(HomePageStrings.home);
  String get menuTitle => _r(HomePageStrings.menuTitle);
  String get totalDue => _r(HomePageStrings.totalDue);
  String get noCustomerYet => _r(HomePageStrings.noCustomerYet);
  String get noCustomerFoundOnSearch =>
      _r(HomePageStrings.noCustomerFoundOnSearch);


  // ──────────────────────────────────────────────
  // User Manual
  // ──────────────────────────────────────────────
  String get manual => _r(UserManualPageStrings.manual);
  String get userManual => _r(UserManualPageStrings.userManual);

  // ──────────────────────────────────────────────
  // Subscription
  // ──────────────────────────────────────────────
  String get buyPremium => _r(SubscriptionPageStrings.buyPremium);
  String get goPremium => _r(SubscriptionPageStrings.goPremium);
  String get subscription => _r(SubscriptionPageStrings.subscription);
  String get month => _r(SubscriptionPageStrings.month);
  String get months => _r(SubscriptionPageStrings.months);
  String get year => _r(SubscriptionPageStrings.year);
  String get regularDeal => _r(SubscriptionPageStrings.regularDeal);
  String get goodDeal => _r(SubscriptionPageStrings.goodDeal);
  String get betterDeal => _r(SubscriptionPageStrings.betterDeal);
  String get bestDeal => _r(SubscriptionPageStrings.bestDeal);
  String get tagadaMessageDetails =>
      _r(SubscriptionPageStrings.tagadaMessageDetails);
  String get premiumPackageSelectionIntro =>
      _r(SubscriptionPageStrings.premiumPackageSelectionIntro);
  String get premiumPackagePerksIntro =>
      _r(SubscriptionPageStrings.premiumPackagePerksIntro);
  String get unlimitedCustomers =>
      _r(SubscriptionPageStrings.unlimitedCustomers);
  String get unlimitedCustomersDetails =>
      _r(SubscriptionPageStrings.unlimitedCustomersDetails);
  String get unlimitedStatements =>
      _r(SubscriptionPageStrings.unlimitedStatements);
  String get unlimitedStatementsDetails =>
      _r(SubscriptionPageStrings.unlimitedStatementsDetails);
  String get downloadReports => _r(SubscriptionPageStrings.downloadReports);
  String get downloadReportsDetails =>
      _r(SubscriptionPageStrings.downloadReportsDetails);
  String get addExtraMessages => _r(SubscriptionPageStrings.addExtraMessages);
  String get addExtraMessagesDetails =>
      _r(SubscriptionPageStrings.addExtraMessagesDetails);

  // ──────────────────────────────────────────────
  // Report
  // ──────────────────────────────────────────────
  String get reports => _r(ReportStrings.reports);

  // ──────────────────────────────────────────────
  // Settings
  // ──────────────────────────────────────────────
  String get settings => _r(SettingsStrings.settings);
  String get language => _r(SettingsStrings.language);
  String get themeMode => _r(SettingsStrings.themeMode);
  String get themeColor => _r(SettingsStrings.themeColor);
  String get decimalPoint => _r(SettingsStrings.decimalPoint);

  // ──────────────────────────────────────────────
  // Others
  // ──────────────────────────────────────────────
  String get sortBy => _r(OthersStrings.sortBy);
  String get name => _r(OthersStrings.name);
  String get dueAmount => _r(OthersStrings.dueAmount);
  String get dateAdded => _r(OthersStrings.dateAdded);
  String get validTill => _r(OthersStrings.validTill);
  String get filter => _r(OthersStrings.filter);
  String get leaderboardFilter => _r(OthersStrings.leaderboardFilter);
  String get reportFilter => _r(OthersStrings.reportFilter);
}
