import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPasswordNewScreen extends StatefulWidget {
  final String email;
  final String username;

  const ResetPasswordNewScreen({
    super.key,
    required this.email,
    required this.username,
  });

  @override
  State<ResetPasswordNewScreen> createState() => _ResetPasswordNewScreenState();
}

class _ResetPasswordNewScreenState extends State<ResetPasswordNewScreen> {
  final TextEditingController _newPassController = TextEditingController();
  bool loading = false;

  void showSnack(String text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), backgroundColor: color),
    );
  }

  Future<void> resetPassword() async {
    final password = _newPassController.text.trim();

    if (password.isEmpty) {
      showSnack("Пароль жолын толтырыңыз", Colors.orange);
      return;
    }

    if (password.length < 8) {
      showSnack("Пароль кем дегенде 8 символ болуы керек!", Colors.blue);
      return;
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      showSnack("Парольде кем дегенде 1 бас әріп болуы керек!", Colors.blue);
      return;
    }

    if (!RegExp(r'[0-9]').hasMatch(password)) {
      showSnack("Парольде кем дегенде 1 цифра болуы керек!", Colors.blue);
      return;
    }

    if (!RegExp(r'[!@#\$%\^&\*\(\)_\+\-=\[\]\{\};:"\\|,.<>\/?]').hasMatch(password)) {
      showSnack("Парольде арнайы символ болуы керек (!@# т.б)", Colors.blue);
      return;
    }

    setState(() => loading = true);

    try {
      final res = await http.post(
        Uri.parse("http://192.168.1.67:3001/update-password"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": widget.email,
          "username": widget.username,
          "newPassword": password,
        }),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        showSnack("Пароль сәтті жаңартылды!", Colors.green);
        Navigator.popUntil(context, (route) => route.isFirst);
      } else {
        showSnack(data["message"] ?? "Қате орын алды!", Colors.red);
      }
    } catch (e) {
      showSnack("Сервер қатесі!", Colors.red);
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
                      "Жаңа пароль орнату",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 59, 59, 93),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),

                    _buildTextField(
                      controller: _newPassController,
                      label: "Жаңа пароль",
                      icon: Icons.lock_outline,
                      obscure: true,
                    ),
                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: loading ? null : resetPassword,
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
                                "Сақтау",
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color:  Color.fromARGB(255, 19, 17, 155)),
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
