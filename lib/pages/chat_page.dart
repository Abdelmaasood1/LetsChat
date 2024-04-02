
import 'package:chat_app/models/message.dart';
import 'package:chat_app/widgets/chat_buble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatPage extends StatelessWidget {
  static String id = 'ChatPage';

  final _controller = ScrollController();

  CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
 var email  = ModalRoute.of(context)!.settings.arguments ;
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy("createdAt", descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> messagesList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
          }

          return Scaffold(
            backgroundColor: Colors.black54,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.black54,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  Text('CHAT',style: TextStyle(color: Colors.white),),
                ],
              ),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      reverse: true,
                      controller: _controller,
                      itemCount: messagesList.length,
                      itemBuilder: (context, index) { 
                        return messagesList[index].id == email ?  ChatBuble(
                          message: messagesList[index],
                        ) : ChatBubleForFriend(message: messagesList[index]);
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    style:  TextStyle(color: Colors.white),
                    controller: controller,
                    onSubmitted: (data) {
                      messages.add(
                        {'message': data,
                          'createdAt': DateTime.now(),
                          'id' : email },

                      );
                      controller.clear();
                      _controller.animateTo(0,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    },
                    decoration: InputDecoration(
                      hintText: 'Send Message',
        suffixIcon: IconButton(
        onPressed: () {
        // Handle the icon tap here
        // For example, you can send a message
        var data = controller.text;
        messages.add({
        'message': data,
        'createdAt': DateTime.now(),
        'id': email,
        });
        controller.clear();
                      _controller.animateTo(0,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn);
        // Perform any additional logic here if needed
        },
        icon: Icon(
        Icons.send,
        color: Colors.white,
        ),
        ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Text('Loading...');
        }
      },
    );
  }
}