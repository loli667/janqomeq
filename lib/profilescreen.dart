import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat_page.dart';
import 'moodscreen.dart';
import 'practicescreen.dart';
import 'homescreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 4;
  bool _isEditing = false;
  File? _avatarImage;

  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _ageController;
  late TextEditingController _genderController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _ageController = TextEditingController();
    _genderController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _usernameController.text = prefs.getString('username') ?? "";
      _emailController.text = prefs.getString('email') ?? "";
      _ageController.text = prefs.getString('age') ?? "";
      _genderController.text = prefs.getString('gender') ?? "";
    });
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _usernameController.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setString('age', _ageController.text);
    await prefs.setString('gender', _genderController.text);
    await prefs.setString('updatedAt', DateTime.now().toString());
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _avatarImage = File(pickedFile.path));
    }
  }

  void _toggleEdit() => setState(() => _isEditing = !_isEditing);

  Future<void> _saveChanges() async {
    await _saveUserData();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("✅ Өзгерістер сақталды"),
        backgroundColor: Colors.green,
      ),
    );
    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Профиль", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text("Аккаунт туралы мәліметтер", style: TextStyle(color: Colors.grey[700])),
            const SizedBox(height: 25),

            // --- Аватар и данные ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color.fromARGB(255, 115, 143, 255), Color.fromARGB(255, 205, 120, 255)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.blue[200],
                        backgroundImage: _avatarImage != null ? FileImage(_avatarImage!) : null,
                        child: _avatarImage == null ? const Icon(Icons.person, size: 40, color: Colors.white) : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            decoration: const BoxDecoration(color: Colors.purple, shape: BoxShape.circle),
                            padding: const EdgeInsets.all(5),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _usernameController.text.isNotEmpty
                              ? "👋 Сәлем, ${_usernameController.text}!"
                              : "👋 Қош келдіңіз!",
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _emailController.text.isNotEmpty ? _emailController.text : "📧 Email көрсетілмеген",
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _toggleEdit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.pinkAccent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(_isEditing ? "Жабу" : "Профильді өзгерту"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if (_isEditing) ...[
              const SizedBox(height: 20),
              _buildTextField("Аты", _usernameController),
              _buildTextField("Email", _emailController, enabled: false),
              _buildTextField("Жасы", _ageController),
              _buildTextField("Жынысы", _genderController),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Өзгерістерді сақтау"),
                ),
              ),
            ],
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);

          if (index == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
          } else if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatPage()));
          } else if (index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const MoodPage()));
          } else if (index == 3) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const PracticeScreen()));
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Басты бет"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "AI чат"),
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

  Widget _buildTextField(String label, TextEditingController controller, {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        enabled: enabled,
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
