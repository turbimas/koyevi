import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';

class CustomGifViewer extends StatefulWidget {
  final String assetPath;
  final double height;
  final double width;
  final double frame;
  final Duration period;
  const CustomGifViewer(
      {super.key,
      required this.assetPath,
      required this.period,
      required this.height,
      required this.width,
      required this.frame});

  @override
  State<CustomGifViewer> createState() => _CustomGifViewerState();
}

class _CustomGifViewerState extends State<CustomGifViewer>
    with SingleTickerProviderStateMixin {
  late FlutterGifController controller;

  @override
  void initState() {
    controller = FlutterGifController(vsync: this);
    super.initState();
    Future.delayed(Duration.zero, () {
      controller.repeat(min: 0, max: widget.frame, period: widget.period);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GifImage(
      height: widget.height,
      width: widget.width,
      controller: controller,
      image: AssetImage(widget.assetPath),
    );
  }
}
