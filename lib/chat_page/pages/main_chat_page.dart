import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger_test/chat_page/pages/chat_page.dart';
import '../model/chat_service.dart';
import '../model/date_time.dart';

class MainChatPage extends StatefulWidget {
  const MainChatPage({super.key});

  @override
  State<MainChatPage> createState() => _MainChatPageState();
}

class _MainChatPageState extends State<MainChatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _searchController = TextEditingController(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBar(
            title: const Text(
              'Чаты',
              style: TextStyle(
                color: Color(0xFF2B333E),
                fontSize: 32,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w600,
              ),
            ),
            toolbarHeight: 60.0,
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
  child: TextField(
    controller: _searchController,
    decoration: InputDecoration(
      hintText: 'Поиск',
      hintStyle: const TextStyle(
        color: Color(0xFF9DB6CA),
        fontSize: 16,
        fontFamily: 'Gilroy',
        fontWeight: FontWeight.w500,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEDF2F6)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      prefixIcon: const Icon(
        Icons.search,
        color: Color(0xFF9DB6CA),
      ),
      suffixIcon: IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          _searchController.clear();
          setState(() {});
        },
      ),
    ),
  ),
 ),
          Expanded(
            child: _buildUserList(),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Ошибка'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Загрузка');
        }
        var filteredDocs = snapshot.data!.docs.where((doc){
          if (_searchController.text.isEmpty){
            return true;
          }
          return doc['username'].toString().toLowerCase().contains(_searchController.text.toLowerCase());
        }).toList();

        return ListView(
          children: filteredDocs
              .map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );
      },
    );
  }

Widget _buildUserListItem(DocumentSnapshot document) {
  Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

  if (data != null && _auth.currentUser!.email != data['email']) {
    String initials = _getInitials(data['username']);

    return StreamBuilder<QuerySnapshot>(
      stream: ChatService.getLastMessage(
        _auth.currentUser!.uid, // текущий пользователь
        data['uid'], // пользователь из списка чатов
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("");
        }

        if (snapshot.hasError) {
          return const Text("Ошибка загрузки сообщений");
        }

        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          // Display a ListTile with "Нет сообщений" if there are no messages
          return ListTile(
            title: Text(data['username'],
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w600,
              )),
            subtitle: const Text("Нет сообщений"),
            leading: CircleAvatar(
              child: Text(initials),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    receiverUserEmail: data['email'],
                    receiverUsername: data['username'],
                    receiverUserId: data['uid'],
                  ),
                ),
              );
            },
          );
        }

        var messageData = snapshot.data!.docs[0].data() as Map<String, dynamic>;
        var senderUsername = messageData['senderUsername'];
        var messageText = messageData['message'];
        var messageTime = messageData['timestamp']?.toDate();
        return ListTile(
          title: Text(data['username'],
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w600,
            )),
          subtitle: Text("$senderUsername: $messageText"),
          trailing: Text(MyDateUtil.getLastMessageTime(
            context: context,
            time: messageTime.toString(), // Convert DateTime to String
          )),
          leading: CircleAvatar(
            child: Text(initials),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  receiverUserEmail: data['email'],
                  receiverUsername: data['username'],
                  receiverUserId: data['uid'],
                ),
              ),
            );
          },
        );
      },
    );
  } else {
    return Container();
  }
}


  String _getInitials(String username) {
    List<String> nameParts = username.split(" ");
    if (nameParts.length > 1) {
      return nameParts[0][0] + nameParts[nameParts.length - 1][0];
    } else {
      return nameParts[0][0];
    }
  }
}
