/// Supported application languages.
enum AppLanguage {
  tr,
  en,
}

extension AppLanguageX on AppLanguage {
  String get code => this == AppLanguage.tr ? 'tr' : 'en';

  String get label => this == AppLanguage.tr ? 'Türkçe' : 'English';

  String get flag => this == AppLanguage.tr ? '🇹🇷' : '🇬🇧';

  String get promptDirective {
    switch (this) {
      case AppLanguage.tr:
        return 'MANDATORY TARGET LANGUAGE: Turkish (Türkçe). '
            'You MUST output your entire response strictly in grammatically correct, natural Turkish, '
            'regardless of the language used in the input text.';
      case AppLanguage.en:
        return 'MANDATORY TARGET LANGUAGE: English. '
            'You MUST output your entire response strictly in fluent English, '
            'regardless of the language used in the input text.';
    }
  }
}
