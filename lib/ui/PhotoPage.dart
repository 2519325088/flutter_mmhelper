import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/services/size_config.dart';
import 'package:photo_view/photo_view.dart';

class PhotoPage extends StatefulWidget {
  @override
  _PhotoPageState createState() => _PhotoPageState();
  PhotoPage(this.url);
  String url;
}

class _PhotoPageState extends State<PhotoPage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(title: Text("Image"),),
      body: Material(
        child: PhotoView(
          backgroundDecoration: BoxDecoration(color: Colors.white),
          heroAttributes: PhotoViewHeroAttributes(tag: widget.url),
          initialScale: SizeConfig.safeBlockHorizontal/9,
          gaplessPlayback: true,
          imageProvider: CachedNetworkImageProvider(widget.url),
        ),
      ),
    );
  }
}
