import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'reset_password_new_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool loading = false;

  void showSnack(String text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), backgroundColor: color),
    );
  }

  Future<void> checkUser() async {
    if (_emailController.text.trim().isEmpty ||
        _usernameController.text.trim().isEmpty) {
      showSnack("Барлық жолдарды толтырыңыз!", Colors.orange);
      return;
    }

    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(_emailController.text.trim())) {
      showSnack("Email дұрыс форматта емес!", Colors.blue);
      return;
    }

    setState(() => loading = true);

    try {
      final res = await http.post(
        Uri.parse("http://192.168.1.67:3001/check-user"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": _emailController.text.trim(),
          "username": _usernameController.text.trim(),
        }),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        showSnack("Пайдаланушы табылды!", Colors.green);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPasswordNewScreen(
              email: _emailController.text.trim(),
              username: _usernameController.text.trim(),
            ),
          ),
        );
      } else {
        showSnack(data["message"] ?? "Мұндай қолданушы жоқ!", Colors.red);
      }
    } catch (e) {
      showSnack("Сервер қатесі, кейін көріңіз!", Colors.red);
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Основной контент
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 18, offset: Offset(0, 6)),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 48,
                      backgroundImage: AssetImage("assets/avatar.png"),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Құпиясөзді қалпына келтіру",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 59, 59, 93),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),

                    _buildTextField(_emailController, "Email", Icons.email_outlined),
                    const SizedBox(height: 16),

                    _buildTextField(_usernameController, "Username", Icons.person_outline),
                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: loading ? null : checkUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 59, 59, 93),
                          disabledBackgroundColor: const Color.fromARGB(255, 68, 44, 102),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: loading
                            ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                            : const Text(
                                "Тексеру",
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Кнопка Назад сверху слева
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 59, 59, 93), size: 28),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color.fromARGB(255, 19, 17, 155)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color.fromARGB(255, 19, 17, 155), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        ),
      ),
    );
  }
}
