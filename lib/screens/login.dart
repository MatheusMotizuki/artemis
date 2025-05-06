import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'register.dart';
// import 'home_page.dart';

class Login extends StatefulWidget { 
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> { // Cria o State
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService _apiService = ApiService(); // Instancia o serviço
  bool _isLoading = false; // Estado de carregamento

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final result = await _apiService.loginUser(
      emailController.text,
      passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login successful! User ID: ${result['data']['userId']}')),
      );
      // TODO: Armazenar o userId/token (usando shared_preferences)
      // TODO: Navegar para a tela principal/home
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => HomePage()), // Substitua HomePage pela sua tela principal
      // );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${result['message']}')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    // Get the screen width to adjust the input fields' width
    double screenWidth = MediaQuery.of(context).size.width;
    double inputWidth =
        screenWidth * 0.8; // Set input width to 80% of the screen width

    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      appBar: AppBar(
        title: const Text("Login Page"),
        backgroundColor: Colors.deepOrange, // AppBar color set to orange
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Title text
              const Text(
                'Login to Your Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              const SizedBox(height: 40),

              // Email input
              SizedBox(
                width: inputWidth,
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: Colors.deepOrange,
                    ), // Label color
                    fillColor: Colors.black,
                    filled: true,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white), // Text color
                ),
              ),
              const SizedBox(height: 20),

              // Password input
              SizedBox(
                width: inputWidth,
                child: TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: Colors.deepOrange,
                    ), // Label color
                    fillColor: Colors.black,
                    filled: true,
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  style: const TextStyle(color: Colors.white), // Text color
                ),
              ),
              const SizedBox(height: 40),

              // Login Button
              SizedBox(
                width: inputWidth,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.deepOrange, // Button color set to orange
                  ),
                  onPressed: _isLoading ? null : _login, // Chama a função _login
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                        )
                      : const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
               const SizedBox(height: 16), // Espaço antes do botão de registro
               TextButton(
                 onPressed: _isLoading ? null : () {
                   // Navega para a tela de registro
                   Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) => const RegisterPage()),
                   );
                 },
                 child: const Text(
                   'Don\'t have an account? Register',
                   style: TextStyle(color: Colors.deepOrange),
                 ),
               ),
            ],
          ),
        ),
      ),
    );
  }
}
