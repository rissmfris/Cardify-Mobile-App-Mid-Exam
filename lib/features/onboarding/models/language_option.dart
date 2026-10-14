enum AppLanguage {
  indonesian,
  englishUK,
}

class LanguageOption {
  final AppLanguage id;
  final String title;
  final String code;

  const LanguageOption({
    required this.id,
    required this.title,
    required this.code,
  });

  static const List<LanguageOption> supported = [
    LanguageOption(
      id: AppLanguage.indonesian,
      title: 'Bahasa Indonesia',
      code: 'id_ID',
    ),
    LanguageOption(
      id: AppLanguage.englishUK,
      title: 'English (UK)',
      code: 'en_GB',
    ),
  ];
}
