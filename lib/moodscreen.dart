import 'package:flutter/material.dart';
import 'chat_page.dart';
import 'homescreen.dart';
import 'practicescreen.dart';
import 'profilescreen.dart';

class MoodPage extends StatefulWidget {
  const MoodPage({super.key}); // required userEmail жоқ

  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  String selectedMood = '';
  String selectedEmoji = '';
  final TextEditingController reasonController = TextEditingController();
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Көңіл-күй күнделігі',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Күнделікті эмоцияларыңызды қадағалаңыз',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Өзіңізді қалай сезінесіз?',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          moodButton('😊', 'Қуаныш'),
                          const SizedBox(width: 8),
                          moodButton('😌', 'Тыныштық'),
                          const SizedBox(width: 8),
                          moodButton('😐', 'Бейтарап'),
                          const SizedBox(width: 8),
                          moodButton('😔', 'Қайғы'),
                          const SizedBox(width: 8),
                          moodButton('😰', 'Уайым'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: reasonController,
                      decoration: InputDecoration(
                        hintText: 'Бұл көңіл-күйді не тудырды? (міндетті емес)',
                        hintStyle:
                            const TextStyle(color: Colors.grey, fontSize: 14),
                        filled: true,
                        fillColor: const Color(0xFFF6F6F6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.grey.shade300, width: 1),
                        ),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // көңіл-күйді жергілікті түрде сақтау қосуға болады
                        setState(() {
                          selectedMood = '';
                          selectedEmoji = '';
                          reasonController.clear();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade700,
                        minimumSize: const Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Сақтау'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);

          if (index == 1) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const ChatPage()));
          } else if (index == 0) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const HomeScreen()));
          } else if (index == 3) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const PracticeScreen()));
          } else if (index == 4) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()));
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

  Widget moodButton(String emoji, String mood) {
    bool isSelected = selectedMood == mood;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMood = mood;
          selectedEmoji = emoji;
        });
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isSelected ? Colors.deepPurple.shade100 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Colors.deepPurple : Colors.transparent,
                width: 1,
              ),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 30)),
          ),
          const SizedBox(height: 4),
          Text(
            mood,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
