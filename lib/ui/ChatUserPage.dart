import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/services/size_config.dart';
import 'ChatPage.dart';

class ChatUserPage extends StatefulWidget {
  @override
  _ChatUserPageState createState() => _ChatUserPageState();
  final String currentUserId, mobileNo;

  ChatUserPage({this.currentUserId, this.mobileNo});
}

class _ChatUserPageState extends State<ChatUserPage> {
  String name, userImage, email;
  bool isLoading = false;
  int messageCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.currentUserId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
      ),
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

  bool isMessageUser = false;

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    if (document['userId'] == widget.currentUserId) {
      return Container();
    } else {
      String groupChatId;
      if (widget.currentUserId.hashCode <=
          document['userId'].toString().hashCode) {
        groupChatId = '${widget.currentUserId}-${document['userId']}';
      } else {
        groupChatId = '${document['userId']}-${widget.currentUserId}';
      }
      return StreamBuilder(
        stream: Firestore.instance
            .collection('messages')
            .document(groupChatId)
            .collection(groupChatId)
            //.where("idTo", isEqualTo: widget.currentUserId)
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot != null &&
              snapshot.data != null &&
              snapshot.data.documents != null &&
              snapshot.data.documents.length != 0) {
            messageCount = 0;
            isMessageUser = false;
            for (int i = 0; i < snapshot.data.documents.length; i++) {
              if (snapshot.data.documents[i]['read'] == 0) {
                if (snapshot.data.documents[i]['idFrom'] !=
                    widget.currentUserId) {
                  isMessageUser = true;
                }
                messageCount++;
              }
            }
            return Column(
              children: <Widget>[
                ListTile(
                  trailing: isMessageUser == true && messageCount != 0
                      ? CircleAvatar(
                          radius: 18,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            messageCount.toString(),
                            //"1000",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white,fontSize: 14),
                          ))
                      : SizedBox(),
                  subtitle: Text(
                    snapshot.data.documents[0]["content"],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          peerId: document['userId'],
                          peerAvatar: document['profileImageUrl'],
                          peerName: document['firstname'] ?? "",
                        ),
                      ),
                    );
                  },
                  leading: document['profileImageUrl'] != null
                      ? CachedNetworkImage(
                          imageUrl: document['profileImageUrl'],
                          imageBuilder: (context, imageProvider) {
                            return CircleAvatar(
                              radius: SizeConfig.safeBlockVertical * 3.5,
                              backgroundImage: imageProvider,
                              backgroundColor: Colors.white,
                            );
                          },
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
                  title: Text(document['firstname'] ?? ""),
                ),
                Divider(
                  indent: SizeConfig.safeBlockHorizontal * 20,
                  endIndent: SizeConfig.safeBlockHorizontal * 5,
                ),
              ],
            );
          } else {
            return SizedBox();

            /* Column(
              children: <Widget>[
                ListTile(
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatPage(
                                  peerId: document['userId'],
                                  peerAvatar: document['profileImageUrl'],
                                  peerName: document['firstname'] ?? "",
                                )));
                  },
                  leading: document['profileImageUrl'] != null
                      ? CachedNetworkImage(
                          imageUrl: document['profileImageUrl'],
                          placeholder: (context, url) =>
                              CircleAvatar(child: Center(child: CircularProgressIndicator(),),),
                          errorWidget: (context, url, error) =>
                              CircleAvatar(child: Icon(Icons.error)),
                          imageBuilder: (context, image) {
                            return CircleAvatar(
                              radius: SizeConfig.safeBlockVertical * 3.5,
                              backgroundImage: image,
                              backgroundColor: Colors.white,
                            );
                          },
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
                  title: Text(document['firstname'] ?? ""),
                ),
                Divider(
                  indent: SizeConfig.safeBlockHorizontal * 20,
                  endIndent: SizeConfig.safeBlockHorizontal * 5,
                ),
              ],
            );*/
          }
        },
      );
    }
  }
}
