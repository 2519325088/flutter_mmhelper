import 'package:flutter/material.dart';
import 'package:flutter_filereader/flutter_filereader.dart';

class FileReaderPage extends StatefulWidget {
//  final String filePath;
//
//  FileReaderPage({Key: Key, this.filePath});

  @override
  _FileReaderPageState createState() => _FileReaderPageState();
}

class _FileReaderPageState extends State<FileReaderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("doc"),
      ),
      body: FileReaderView(
//        filePath: widget.filePath,
      filePath: "https://firebasestorage.googleapis.com/v0/b/poetic-dreamer-254105.appspot.com/o/contract%2F2020-05-08T08%3A34%3A20.462606%2F04-%E8%81%8C%E4%B8%9A%E7%A4%BC%E4%BB%AA%E6%A6%82%E8%BF%B0.docx?alt=media&token=96f844dc-2c85-4571-8464-6efa3f0c4a6e",
      ),
    );
  }
}