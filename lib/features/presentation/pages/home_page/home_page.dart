import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger/features/data/models/models.dart';
import 'package:messenger/features/data/services/firebase_auth_service.dart';
import 'package:messenger/features/presentation/pages/pages.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _searchController = TextEditingController();
  late QuerySnapshot _snapshot;
  List<DocumentSnapshot> filteredDocs = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _searchController.addListener(_performSearch);
  }

  void _loadUsers() async {
    _snapshot = await FirebaseFirestore.instance.collection('users').get();
  }

  void _performSearch() {
    setState(() {
      String searchText = _searchController.text.toLowerCase();
      filteredDocs = _snapshot.docs.where((doc) {
        final username = doc['username']?.toString().toLowerCase() ?? '';
        return username.contains(searchText);
      }).toList();
    });
  }

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
            actions: [
              //Кнопка выхода из аккаунта
              IconButton(
                onPressed: _signOut,
                icon: const Icon(Icons.logout),
              )
            ],
            toolbarHeight: 60.0,
          ),
          //Строка поиска
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
              ),
            ),
          ),
          //Пользователи
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
        var filteredDocs = snapshot.data!.docs.where((doc) {
          final username = doc['username']?.toString().toLowerCase() ?? '';
          return username.contains(_searchController.text.toLowerCase());
        }).toList();
        //Отображение Пользователей
        return ListView(
          children: filteredDocs.map<Widget>((doc) => _buildUserListItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
  //Доступны ли данные и не принадлежат ли они текущему пользователю
    if (data != null && _auth.currentUser!.email != data['email']) {
      String initials = _getInitials(data['username']);
//Элемент списка пользователей с информацией о последнем сообщении
      return StreamBuilder<QuerySnapshot>(
        stream: ChatService.getLastMessage(
          _auth.currentUser!.uid,
          data['uid'],
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("");
          }

          if (snapshot.hasError) {
            return const Text("Ошибка загрузки сообщений");
          }
      // Проверерка, нет ли сообщений
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return ListTile(
              title: Text(
                data['username'],
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: const Text("Нет сообщений"),
              leading: CircleAvatar(
                child: Text(initials),
              ),
              onTap: () {
                _navigateToChatPage(data);
              },
            );
          }
      // Извлечь данные последнего сообщения
          var messageData = snapshot.data!.docs[0].data() as Map<String, dynamic>;
          var senderUsername = messageData['senderUsername'] ?? '';
          var messageText = messageData['message'];
          var messageTime = messageData['timestamp']?.toDate();
          return ListTile(
            title: Text(
              data['username'],
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text("$senderUsername: $messageText"),
            trailing: Text(MyDateUtil.getLastMessageTime(
              context: context,
              time: messageTime.toString(),
            )),
            leading: CircleAvatar(
              child: Text(initials),
            ),
            onTap: () {
              _navigateToChatPage(data);
            },
          );
        },
      );
    } else {
      // Если это текущий пользователь, отобразите пустой контейнер
      return Container();
    }
  }
// Метод для получения инициалов пользователя из его имени
String _getInitials(String username) {
  List<String> nameParts = username.split(" ");

  String initials = '';
  
  for (String part in nameParts) {
    if (part.isNotEmpty) {
      initials += part[0];
    }
  }

  return initials;
}
// Переход на страницу чата с выбранным пользователем
  void _navigateToChatPage(Map<String, dynamic> userData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          receiverUserEmail: userData['email'],
          receiverUsername: userData['username'],
          receiverUserId: userData['uid'],
        ),
      ),
    );
  }

  void _signOut() {
    final authService = Provider.of<FirebaseAuthService>(context, listen: false);
    authService.signOut();
  }
}
