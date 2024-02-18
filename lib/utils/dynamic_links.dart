import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinkProvider {
  Future<String> createDynamicLink(String refCode) async {
    final String url = "https://com.aokijisapplication.app?ref=$refCode";

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      androidParameters: AndroidParameters(
        packageName: "com.aokijisapplication.app",
        minimumVersion: 0,
      ),
      iosParameters: IOSParameters(
        bundleId: "com.aokijisapplication.app",
        minimumVersion: "0",
      ),
      link: Uri.parse(url),
      uriPrefix: "https://aokijisapplication.page.link",
    );

    final FirebaseDynamicLinks link = FirebaseDynamicLinks.instance;

    final refLink = await link.buildShortLink(parameters);

    return refLink.shortUrl.toString();
  }

  static Future<DynamicLinkProvider> getInstance() async {
    return DynamicLinkProvider();
  }

  void initDynmaticLink() async {
    final instanceLink =
        await FirebaseDynamicLinks.instance.getInitialLink();

    if (instanceLink != null) {
      final Uri refLink = instanceLink.link;
      //Share.share("Liên kết chia sẻ ${refLink.data}");
    }
  }
}
