import 'dart:ui';

enum HomeContentType {
  Novel,
  Picture,
  Audio,
  Video;

  int get ContentTypeTag {
    switch (this) {
      case Novel:
        return 1;
      case Picture:
        return 2;
      case Audio:
        return 3;
      case Video:
        return 4;
    }
  }
}

