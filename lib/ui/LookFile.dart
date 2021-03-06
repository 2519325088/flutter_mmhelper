import 'package:flutter/material.dart';
//import 'package:flutter_filereader/flutter_filereader.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_plugin.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:after_init/after_init.dart';

class FileReaderPage extends StatefulWidget {
  @override
  _FileReaderPageState createState() => _FileReaderPageState();
  String filePath;

  FileReaderPage({Key: Key, this.filePath});
}

class _FileReaderPageState extends State<FileReaderPage> with AfterInitMixin{
  String pathPDF = "";
  int indexlast;

  @override
  void initState() {
    indexlast = widget.filePath.indexOf(".pdf?");
    super.initState();
    createFileOfPdfUrl().then((f) {
      setState(() {
        pathPDF = f.path;
        print("this is  filepath: ${pathPDF}");
      });
    });
  }

  @override
  void didInitState() {
    createFileOfPdfUrl().then((f) {
      pathPDF = f.path;
      if(pathPDF!="" && indexlast != -1){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PDFScreen(pathPDF)),
          );
      }
    });
  }

  Future<File> createFileOfPdfUrl() async {
    final url = widget.filePath;
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    print("this is name:$filename");
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("doc"),
      ),
      body:widget.filePath!="" && widget.filePath!=null?(indexlast !=-1?Center(
        child: CircularProgressIndicator(),
      ):Container(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            width: double.infinity,
            child:Image.network(
              widget.filePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
      )):Text("File not uploaded") ,
//      body: widget.filePath!="" && widget.filePath!=null?(indexlast != -1?Center(
//        child: RaisedButton(
//          child: Text("Open PDF"),
//          onPressed: () => Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) => PDFScreen(pathPDF)),
//          ),
//        ),
//      ):Container(
//        child: Padding(
//          padding: const EdgeInsets.all(10),
//          child: Container(
//            width: double.infinity,
//            child:Image.network(
//              widget.filePath,
//              fit: BoxFit.cover,
//            ),
//          ),
//        ),
//      )):Text("File not uploaded"),
    );
  }
}

class PDFScreen extends StatelessWidget {
  String pathPDF = "";
  PDFScreen(this.pathPDF);
  Color gradientStart = Color(0xffbf9b30); //Change start gradient color here
  Color gradientEnd = Color(0xffe7d981);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          title: Text("Document"),
          leading: IconButton(
              color: gradientStart,
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: (){
                Navigator.pop(context);
                Navigator.pop(context);
              }
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {},
            ),
          ],
        ),
        path: pathPDF);
  }
}