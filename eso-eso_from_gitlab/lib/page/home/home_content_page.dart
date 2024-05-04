import 'package:eso/page/home/view_model/home_view_model.dart';
import 'package:eso/page/recommand/recommand_page.dart';
import 'package:eso/page/short_video/short_video_page.dart';
import 'package:eso/utils/org_color_utils.dart';
import 'package:flutter/material.dart';
import 'package:huijing_ads_plugin/huijing_ads_plugin.dart';
import 'package:provider/provider.dart';
import 'package:eso/page/home/model/hj_banner_listener.dart';

import 'model/reward_listener.dart';

class HomeContentPage extends StatefulWidget {
  HomeContentPage({Key key}) : super(key: key);

  @override
  State<HomeContentPage> createState() => _HomeContentPageState();
}

class _HomeContentPageState extends State<HomeContentPage>
    with SingleTickerProviderStateMixin {
  HomeViewModel viewModel = null;
  TabController controller = null;
  HjBannerAd _bannerAd;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = HomeViewModel();
    controller = TabController(length: viewModel.tabTitles.length, vsync: this);
    // _adBanner();
    // _rewardBanner();
  }

  void _rewardBanner() {
    HjAdRequest request = HjAdRequest(placementId: "5847726571825805");
    HjRewardAd ad = HjRewardAd(request: request,listener: EsoRewardListener());
    ad.loadAdData();
  }

  void _adBanner() {
    HjAdRequest request = HjAdRequest(placementId: "8533172371714945");
    _bannerAd = HjBannerAd(request: request,width: 300,height: 100, listener: EsoHjBannerListener());
    _bannerAd.loadAd();
    print("_adBanner $_bannerAd");
  }

  Widget searchBar() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            "下拉分类",
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            GestureDetector(
              child: Container(
                height: 32,
                width: 300,

                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    )),
              ),
              onTap: () async {
                bool isReady = await _bannerAd.isReady();
                print("isReady $isReady");
                if (isReady) {
                  BannerAdWidget bannerAdWidget = BannerAdWidget(
                    hjBannerAd: _bannerAd,
                    height: 50,
                    width: 320,
                  );
                }
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 9,
                ),
                Image.asset(
                  "assets/ba/home_search.png",
                  width: 14,
                  height: 14,
                ),
                const SizedBox(
                  width: 9,
                ),
                Text(
                  "输入搜索内容",
                  style: TextStyle(
                      fontSize: 14, color: ColorsUtil.contractColor("#86909C")),
                )
              ],
            )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (context) {
        return viewModel;
      },
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
            body: Column(
          children: [
            searchBar(),
            const SizedBox(height: 16,),
            TabBar(
              indicator: const BoxDecoration(),
              padding: EdgeInsets.symmetric(horizontal: 10),
              controller: controller,
              unselectedLabelColor: ColorsUtil.contractColor("#A6A6A6"),
              unselectedLabelStyle: TextStyle(
                fontSize: 16,
                color: ColorsUtil.contractColor("#A6A6A6"),
              ),
              labelColor: Colors.black,
              labelStyle: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              labelPadding: EdgeInsets.symmetric(horizontal: 16.0),
              isScrollable: true,
              tabs: viewModel.tabTitles
                  .map((e) => Tab(
                        text: e,
                      ))
                  .toList(),
            ),
            Expanded(
              child: TabBarView(controller: controller, children: [
               RecommendPage(),
                RecommendPage(),
                RecommendPage(),
                RecommendPage(),
                RecommendPage(),
                ShortVideoPage(),
              ]),
            )
          ],
        )),
      ),
    );
  }
}
