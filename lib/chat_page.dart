import 'package:flutter/material.dart';
import 'homescreen.dart';
import 'moodscreen.dart';
import 'practicescreen.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _habarController = TextEditingController(); // хабар жолын басқару
  int _tandalyIndex = 1; // таңдалған навигация индексы

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
        title: const Text(
          'AI Чат',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.grey.shade400, blurRadius: 4),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _habarController,
                    decoration: InputDecoration(
                      hintText: 'Хабар жазыңыз...',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tandalyIndex,
        onTap: (index) {
          setState(() {
            _tandalyIndex = index;
          });
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MoodPage()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PracticeScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Басты бет"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "AI Чат"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Көңіл күй"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Практикалар"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Профиль"),
        ],
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }
}
