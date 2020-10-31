import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class BackgroundVideo extends StatefulWidget {
  @override
  _BackgroundVideoState createState() => _BackgroundVideoState();
}

class _BackgroundVideoState extends State<BackgroundVideo> {
  // VideoPlayerController object.
  VideoPlayerController _controller;

  // Setup the controller
  @override
  void initState() {
    super.initState();
    // Pick the video asset
    _controller = VideoPlayerController.asset("assets/images/ocean.mp4")
      ..initialize().then((_) {
        // loop the video
        _controller.play();
        _controller.setLooping(true);
        // first frame initialized
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
                    width: _controller.value.size?.width ?? 0,
                    height: _controller.value.size?.height ?? 0,
                    child: VideoPlayer(_controller),
                
    );
  }

  // clear memory
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

