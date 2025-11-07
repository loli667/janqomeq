import 'package:flutter/material.dart';
import 'chat_page.dart';
import 'homescreen.dart';
import 'moodscreen.dart';
import 'profilescreen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PracticeScreen(),
  ));
}

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  _PracticeScreenState createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  int _selectedIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Практикалар мен жаттығулар",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              "Денсаулыққа арналған барлығы",
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 255, 114, 210),
                    const Color.fromARGB(255, 195, 122, 255)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 5),
                      Text(
                        "Қуаныш пен жайлылық",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Барлығы сіздің көңіл-күйіңізге пайдалы",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Барлық практикалар",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.all(6),
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.air, color: Colors.blue),
                  SizedBox(width: 10),
                  Text(
                    "Тыныс алу жаттығулары",
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(6),
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.pink[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.self_improvement, color: Colors.pink),
                  SizedBox(width: 10),
                  Text(
                    "Релаксация",
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(6),
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.purple[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.spa, color: Colors.purple),
                  SizedBox(width: 10),
                  Text(
                    "Медитация",
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(6),
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.psychology, color: Colors.green),
                  SizedBox(width: 10),
                  Text(
                    "Өзін-өзі талдау",
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.lightBlue[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lightbulb, color: Colors.orange, size: 30),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Күннің кеңесі:\nКүн сайын шағын жаттығулар жасаңыз, көңіл-күйіңіз көтеріліп, денсаулығыңыз жақсарады!",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatPage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MoodPage()),
            );
          } else if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Басты бет"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "AI Чат"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Көңіл-күй"),
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
