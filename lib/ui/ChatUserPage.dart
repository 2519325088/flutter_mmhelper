import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/services/size_config.dart';
import 'ChatPage.dart';

class ChatUserPage extends StatefulWidget {
  @override
  _ChatUserPageState createState() => _ChatUserPageState();
  final String currentUserId,mobileNo;
  ChatUserPage({this.currentUserId,this.mobileNo});
}

class _ChatUserPageState extends State<ChatUserPage> {
  String name, userImage, email;
  bool isLoading = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.currentUserId);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text("CHATs"),
      ),*/
      body: Stack(
        children: <Widget>[
          // List
          Container(
            child: StreamBuilder(
              stream: Firestore.instance.collection('mb_content').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(context, snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                  );
                }
              },
            ),
          ),
          // Loading
          Positioned(
            child: isLoading
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                    color: Colors.white.withOpacity(0.8),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    if (document['userId'] == widget.currentUserId) {
      return Container();
    } else {
      return Column(
        children: <Widget>[
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatPage(
                            peerId: document['userId'],
                            peerAvatar: document['profileImageUrl'],
                            peerName: document['firstname']??"",
                          )));
            },
            leading: document['profileImageUrl'] != null
                ? CircleAvatar(
                    radius: SizeConfig.safeBlockVertical * 3.5,
                    backgroundImage: NetworkImage(document['profileImageUrl']),
                    backgroundColor: Colors.white,
                  )
                : CircleAvatar(
                    radius: SizeConfig.safeBlockVertical * 3.5,
                    child: Icon(
                      Icons.account_circle,
                      size: SizeConfig.safeBlockVertical * 7,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.black.withOpacity(0.1),
                  ),
            title: Text(document['firstname']??""),
          ),
          Divider(
            indent: SizeConfig.safeBlockHorizontal * 20,
            endIndent: SizeConfig.safeBlockHorizontal * 5,
          ),
        ],
      );
    }
  }
}
