import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'profilescreen.dart';
import 'loginscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart'; // Для FilteringTextInputFormatter

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedGender; // "әйел" или "ер"
  bool _isLoading = false;

  void showSnack(String text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), backgroundColor: color),
    );
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _isStrongPassword(String password) {
    final passRegex = RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*]).{8,}$');
    return passRegex.hasMatch(password);
  }

  Future<void> registerUser() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final age = _ageController.text.trim();
    final password = _passwordController.text.trim();
    final gender = _selectedGender;

    if (username.isEmpty || email.isEmpty || age.isEmpty || gender == null || password.isEmpty) {
      showSnack("Барлық өрістерді толтырыңыз", Colors.orange);
      return;
    }

    final ageValue = int.tryParse(age);
    if (ageValue == null || ageValue < 12 || ageValue > 100) {
      showSnack("Жас 12 мен 100 аралығында болуы керек!", Colors.orange);
      return;
    }

    if (!_isValidEmail(email)) {
      showSnack("Email дұрыс форматта емес", Colors.red);
      return;
    }

    if (!_isStrongPassword(password)) {
      showSnack(
          "Құпиясөз: кемінде 8 символ, 1 үлкен әріп, 1 сан, 1 белгі", Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final url = Uri.parse("http://192.168.1.67:3001/register");
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "username": username,
          "email": email,
          "age": ageValue,
          "gender": gender,
          "password": password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', data["user"]["username"]);
        await prefs.setString('email', data["user"]["email"]);
        await prefs.setString('age', data["user"]["age"].toString());
        await prefs.setString('gender', data["user"]["gender"] ?? "");
        await prefs.setString('updatedAt', data["user"]["updatedAt"] ?? "");

        showSnack("Тіркелу сәтті өтті", Colors.green);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileScreen(),
          ),
        );
      } else {
        showSnack(data["message"] ?? "Қате орын алды", Colors.red);
      }
    } catch (e) {
      showSnack("Сервермен байланыс орнатылмады: $e", Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
                  "Тіркелу",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 59, 59, 93),
                  ),
                ),
                const SizedBox(height: 28),

                _buildTextField(_usernameController, "Username", Icons.person_outline),
                const SizedBox(height: 16),

                _buildTextField(_emailController, "Email", Icons.email_outlined),
                const SizedBox(height: 16),

                _buildTextField(
                  _ageController,
                  "Жасыңыз",
                  Icons.cake_outlined,
                  inputType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedGender = "әйел"),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: _selectedGender == "әйел"
                                ? const Color.fromARGB(255, 19, 17, 155)
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Әйел",
                            style: TextStyle(
                                color: _selectedGender == "әйел"
                                    ? Colors.white
                                    : Colors.black87,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedGender = "ер"),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: _selectedGender == "ер"
                                ? Color.fromARGB(255, 19, 17, 155)
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Ер",
                            style: TextStyle(
                                color: _selectedGender == "ер"
                                    ? Colors.white
                                    : Colors.black87,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
               

                _buildTextField(_passwordController, "Құпиясөз", Icons.lock_outline,
                    obscure: true),
                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : registerUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 59, 59, 93),
                      disabledBackgroundColor: const Color.fromARGB(255, 68, 44, 102),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                        : const Text(
                            "Тіркелу",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Аккаунтыңыз бар ма?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Text(
                        "Кіру",
                        style: TextStyle(
                            color: Color.fromARGB(255, 19, 17, 155),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {TextInputType inputType = TextInputType.text, bool obscure = false, List<TextInputFormatter>? inputFormatters}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: inputType,
      inputFormatters: inputFormatters,
      decoration: _inputDecoration(label, icon),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color.fromARGB(255, 19, 17, 155)),
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
    );
  }
}
