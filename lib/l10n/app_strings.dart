import '../models/app_language.dart';
import '../models/summary_mode.dart';

/// Centralized localization dictionary for the AI Summarizer application.
class AppStrings {
  final AppLanguage language;

  const AppStrings(this.language);

  static AppStrings of(AppLanguage lang) => AppStrings(lang);

  bool get isTr => language == AppLanguage.tr;

  // App Bar
  String get appTitle => isTr ? 'Yapay Zeka Özetleyici' : 'AI Summarizer';
  String get appSubtitle => isTr
      ? 'Hibrit Bilgisayarlı Görü (OCR) ve Bulut Yapay Zeka ile Özetleme'
      : 'Hybrid Computer Vision OCR + Cloud GenAI Summarization';

  // Summary Modes
  String modeLabel(SummaryMode mode) {
    if (isTr) {
      switch (mode) {
        case SummaryMode.executive:
          return 'Yönetici';
        case SummaryMode.academic:
          return 'Akademik';
        case SummaryMode.keyTakeaways:
          return 'Maddeler Halinde';
      }
    } else {
      return mode.label;
    }
  }

  String modeDescription(SummaryMode mode) {
    if (isTr) {
      switch (mode) {
        case SummaryMode.executive:
          return 'En önemli noktaları ve sonucu vurgulayan 2-3 cümlelik net özet.';
        case SummaryMode.academic:
          return 'Terminolojiye ve metodolojiye sadık derinlemesine akademik özet.';
        case SummaryMode.keyTakeaways:
          return 'Kritik içgörüleri listeleyen yapılandırılmış maddeleme.';
      }
    } else {
      return mode.description;
    }
  }

  // Scanning banner
  String get scanningBanner => isTr
      ? 'Cihaz üzerindeki Bilgisayarlı Görü ile belge taranıyor...'
      : 'Scanning image with on-device Computer Vision OCR...';

  // Input Card
  String get inputHint => isTr
      ? 'Metin yazın, yapıştırın veya kamerayla belge tarayın...'
      : 'Type, paste, or scan notes/documents via camera...';

  String stats(int words, int chars) => isTr
      ? '$words kelime | $chars karakter'
      : '$words words | $chars chars';

  String get scanAction => isTr ? 'Tara' : 'Scan';
  String get pasteAction => isTr ? 'Yapıştır' : 'Paste';
  String get clearTooltip => isTr ? 'Metni temizle' : 'Clear input';

  // Main Action Button
  String summarizeButton(SummaryMode mode) => isTr
      ? 'Özetle (${modeLabel(mode)})'
      : 'Summarize (${mode.label})';

  // Summary Result Card
  String summaryTitle(SummaryMode? mode) {
    if (mode == null) return isTr ? 'Özet' : 'Summary';
    return isTr ? '${modeLabel(mode)} Özeti' : '${mode.label} Summary';
  }

  String get summaryPlaceholder => isTr
      ? 'Yapay zeka tarafından üretilen özetiniz burada görünecek.'
      : 'Your synthesized AI summary will appear here.';

  String get copyAction => isTr ? 'Kopyala' : 'Copy';

  // OCR Sheet
  String get ocrSheetTitle => isTr ? 'Belgeyi Tara (OCR)' : 'Scan Document via OCR';
  String get ocrSheetSubtitle => isTr
      ? 'Cihaz üzerindeki yapay zeka ile metin çıkarmak için görsel kaynağını seçin.'
      : 'Select an image source to extract text using on-device ML Kit.';
  String get ocrCameraTitle => isTr ? 'Kamera' : 'Camera';
  String get ocrCameraSubtitle => isTr
      ? 'Kitap, belge veya slaytın anlık fotoğrafını çekin'
      : 'Snap a live photo of a book, document, or slide';
  String get ocrGalleryTitle => isTr ? 'Galeri' : 'Gallery';
  String get ocrGallerySubtitle => isTr
      ? 'Kayıtlı fotoğraf veya ekran görüntüsü seçin'
      : 'Select an existing screenshot or saved photo';

  // Messages & Alerts
  String get emptyInputError => isTr
      ? 'Lütfen özetlemek için bir metin girin veya tarayın.'
      : 'Please enter, paste, or scan text to summarize.';

  String get clipboardPasted => isTr
      ? 'Metin panodan yapıştırıldı.'
      : 'Text pasted from clipboard.';

  String get summaryCopied => isTr
      ? 'Özet panoya kopyalandı!'
      : 'Summary copied to clipboard!';

  String scannedSuccess(int words) => isTr
      ? 'OCR ile belgeden $words kelime başarıyla okundu!'
      : 'Scanned $words words from image via OCR!';

  String get webOcrNotice => isTr
      ? 'Cihaz üzerindeki OCR mobil cihazlar (Android & iOS) için optimize edilmiştir.'
      : 'On-device OCR is optimized for mobile (Android & iOS).';
}
