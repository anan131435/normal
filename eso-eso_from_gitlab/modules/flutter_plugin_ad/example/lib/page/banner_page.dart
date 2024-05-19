import 'package:flutter/material.dart';
import 'package:flutter_plugin_ad/flutter_plugin_ad.dart';

/// Banner 广告页面
class BannerPage extends StatefulWidget {
  BannerPage() : super();

  @override
  _BannerPageState createState() => _BannerPageState();
}

class _BannerPageState extends State<BannerPage> {
  //横幅
  String posIdBanner = "107EB50EDFE65EA3306C8318FD57D0B3";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Banner 广告'),
      ),
      body: BannerAdWidget(adId: posIdBanner),
    );
  }
}
