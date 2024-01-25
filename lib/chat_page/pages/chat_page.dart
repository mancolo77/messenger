import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/chat_text_field.dart';
import '../model/chat_bubble.dart';
import '../model/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserId;
  final String receiverUsername;

  const ChatPage(
      {super.key,
      required this.receiverUserEmail,
       required this.receiverUserId, 
       required this.receiverUsername,
});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FocusNode _messageFocus = FocusNode();
  bool _isTextMode = false;

    @override
    void initState() {
    super.initState();
    _messageFocus.addListener(() {
      setState(() {
        _isTextMode = _messageFocus.hasFocus;
      });
    });
  }
    @override
    void dispose() {
    _messageController.dispose();
    _messageFocus.dispose();
    super.dispose();
  }


  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserId, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(widget.receiverUsername,
                    style: const TextStyle(
                      color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                        height: 0,
                    ),
                    ),
                    const SizedBox(width: 8),
                  ], 
                ),
                StreamBuilder<DocumentSnapshot>(
                  stream: _firestore.collection('users').doc(widget.receiverUserId).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      bool isOnline = snapshot.data?['online'] ?? false;
                      String lastActive = _formatLastActive(snapshot.data?['lastActive']);
                      return Padding(
                        padding: const EdgeInsets.only(left: 1.0),
                        child: Text(
                          isOnline ? 'в сети' : 'последняя активность: $lastActive',
                          style: const TextStyle(
                            color: Color(0xFF5D7A90),
                            fontSize: 12,
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w500,
                            height: 0,
                            ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30),
          onPressed: () {
            Get.back();
          },
        ),
        toolbarHeight: 120.0, // Выберите желаемую высоту для AppBar
      ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: _buildMessageList(),
              ),
              _buildMessageInput(),
              const SizedBox(height: 25),
            ],
          ),
        ),
      );
  }

Widget _buildMessageList() {
  return StreamBuilder(
    stream: _chatService.getMessage(
      widget.receiverUserId,
      _firebaseAuth.currentUser!.uid,
    ),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('Ошибка${snapshot.error}');
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Text('Загрузка');
      }
      if (snapshot.connectionState == ConnectionState.active) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) =>
                _buildMessageItem(snapshot.data!.docs[index]),
          ),
        );
      } else {
        return const Text('Состояние соединения неактивно');
      }
    },
  );
}
Widget _buildMessageItem(DocumentSnapshot document) {
  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
  
  var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
      ? Alignment.centerRight
      : Alignment.centerLeft;

  return Container(
    alignment: alignment,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ChatBubble(
            message: data['message'],
            senderId: data['senderId'],
          ),
          const SizedBox(height: 5),
        ],
      ),
    ),
  );
}

Widget _buildMessageInput() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: GestureDetector(
      onTap: () {
        //это для обработки тапа в области ввода сообщения
      },
      behavior: HitTestBehavior.translucent,
      child: Row(
        children: [
          Align(
            alignment: Alignment.center,
            child: IconButton(
              onPressed: () {
                // Здесь логика для записи голоса которой нет
              },
              icon: const Icon(
                Icons.attach_file,
                size: 25,
              ),
            ),
          ),
          Expanded(
            child: MyTextField(
              controller: _messageController,
              focusNode: _messageFocus,
              hintText: "Сообщение",
              obscureText: false,
              onChanged: (text) {
                setState(() {
                  _isTextMode = text.isNotEmpty;
                });
              },
            ),
          ),
          IconButton(
            onPressed: () {
              if (_isTextMode) {
                sendMessage();
              } else {
                // Здесь логика для записи голоса которой нет
              }
            },
            icon: _isTextMode
                ? const Icon(
                    Icons.send,
                    size: 35,
                  )
                : const Icon(
                    Icons.mic,
                    size: 35,
                  ),
          )
        ],
      ),
    ),
  );
}
}

//Проверка последнего входа
 String _formatLastActive(dynamic timestamp) {
  if (timestamp == null) return 'неизвестно';
  
  DateTime lastActive = (timestamp as Timestamp).toDate();
  Duration difference = DateTime.now().difference(lastActive);

  if (difference.inMinutes < 1) {
    return 'меньше минуты назад';
  } else if (difference.inHours < 1) {
    return '${difference.inMinutes} минут назад';
  } else if (difference.inDays < 1) {
    return '${difference.inHours} часов назад';
  } else {
    return '${lastActive.day}.${lastActive.month}.${lastActive.year}';
  }
}
