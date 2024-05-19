import 'package:auto_orientation/auto_orientation.dart';
import 'package:eso/page/short_video/model/physics.dart';
import 'package:eso/page/short_video/widget/networkimage.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ShortVideoPage extends StatefulWidget {
  const ShortVideoPage({Key key}) : super(key: key);

  @override
  State<ShortVideoPage> createState() => _ShortVideoPageState();
}

class _ShortVideoPageState extends State<ShortVideoPage> {
  final PageController _pageController = PageController();
  VideoPlayerController _controller;
  List<String> list = [
    "https://v10.dious.cc/20240516/ZlpYkhYY/2000kb/hls/index.m3u8",
    "https://static.ybhospital.net/test-video-10.MP4",
    "https://static.ybhospital.net/test-video-6.mp4",
    "https://static.ybhospital.net/test-video-9.MP4",
    "https://static.ybhospital.net/test-video-8.MP4",
    "https://static.ybhospital.net/test-video-7.MP4",
    'https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8'
  ];

  @override
  void initState() {
    AutoOrientation.portraitUpMode();
    Uri uri = Uri.parse(list[0]);
    _controller = VideoPlayerController.networkUrl(uri)
      ..setLooping(true)
      ..addListener(() {
        setState(() {});
      })
      ..initialize().then((value) async {
        setState(() {
          playOrPauseVideo();
        });
      }).catchError((err) {
        print(err);
      });
    super.initState();
  }

  void playOrPauseVideo() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          physics: const QuickerScrollPhysics(),
          itemCount: list.length,
          onPageChanged: (value) {
            print("要跳转$value");
            _controller.dispose();
            _controller =
                VideoPlayerController.networkUrl(Uri.parse(list[value]))
                  ..setLooping(true)
                  ..addListener(() {
                    setState(() {});
                  })
                  ..initialize().then((value) async {
                    setState(() {
                      playOrPauseVideo();
                    });
                  }).catchError((err) {
                    print("VideoError:$err");
                  });
            if (value == list.length - 1) {
              Future.delayed(const Duration(microseconds: 200)).then((value) {
                _pageController.jumpTo(0);
              });
            }
          },
          itemBuilder: (context, index) {
            return Stack(
              children: [
                Container(
                  color: Colors.black,
                  child: Center(
                    child: Stack(
                      children: [
                        Positioned(
                            child: Stack(
                          children: [
                            InkWell(
                              child: Container(
                                height: double.infinity,
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: _controller.value.isInitialized
                                    ? AspectRatio(
                                        aspectRatio:
                                            _controller.value.aspectRatio,
                                        child: VideoPlayer(_controller),
                                      )
                                    : const CircularProgressIndicator(),
                              ),
                              onTap: () => playOrPauseVideo(),
                            ),
                          ],
                        )),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
