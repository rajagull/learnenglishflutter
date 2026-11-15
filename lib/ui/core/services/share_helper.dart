import 'package:share_plus/share_plus.dart';

class ShareHelper {
  static Future<void> shareText(String text) async {
    try {
      await SharePlus.instance.share(ShareParams(text: text));
    } catch (_) {}
  }
}
