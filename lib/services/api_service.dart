import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class ApiService {
  // IMPORTANTE: Ao usar GitHub Codespaces:
  // 1. Certifique-se de que a porta do backend (4000) está encaminhada na aba "Ports".
  // 2. Se estiver executando o app Flutter na web (visualização do Codespaces),
  //    'localhost' pode não funcionar. Use o URL "Forwarded Address" fornecido pelo Codespaces.
  // 3. Para emulador Android, use 10.0.2.2 em vez de localhost.
  // 4. Para dispositivo físico na mesma rede, use o IP local da sua máquina.
  static const String _baseUrl = 'https://silver-system-rv7gvg9px963545-4000.app.github.dev'; // AJUSTE CONFORME NECESSÁRIO PARA CODESPACES

  // Registro de Usuário
  Future<Map<String, dynamic>> registerUser(String username, String email, String password) async {
    final url = Uri.parse('$_baseUrl/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 201) {
        return {'success': true, 'data': responseBody};
      } else {
        return {'success': false, 'message': responseBody['message'] ?? 'Registration failed'};
      }
    } catch (e) {
      print('Registration error: $e');
      return {'success': false, 'message': 'Network error during registration: ${e.toString()}'};
    }
  }

  // Login de Usuário
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Login bem-sucedido, retorna dados (ex: userId)
        return {'success': true, 'data': responseBody};
      } else {
        // Falha no login
        return {'success': false, 'message': responseBody['message'] ?? 'Login failed'};
      }
    } catch (e) {
      print('Login error: $e');
      return {'success': false, 'message': 'Network error during login: ${e.toString()}'};
    }
  }

  // Criar Post
  // TODO: Passar userId de forma segura (ex: de um estado de autenticação)
  Future<Map<String, dynamic>> createPost(String text, Map<String, double> position, int userId) async {
     final url = Uri.parse('$_baseUrl/posts');
     try {
        final response = await http.post(
           url,
           headers: {'Content-Type': 'application/json'},
           body: jsonEncode({
              'text': text,
              'position': position, // { 'x': ..., 'y': ..., 'z': ... }
              'userId': userId,
           }),
        );

        final responseBody = jsonDecode(response.body);
        if (response.statusCode == 201) {
           return {'success': true, 'data': responseBody};
        } else {
           return {'success': false, 'message': responseBody['message'] ?? 'Failed to create post'};
        }
     } catch (e) {
        print('Create post error: $e');
        return {'success': false, 'message': 'Network error creating post: ${e.toString()}'};
     }
  }


  // Obter Posts
  Future<Map<String, dynamic>> getPosts() async {
    final url = Uri.parse('$_baseUrl/posts');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> postsJson = jsonDecode(response.body);
        // Converte a lista de JSON para uma lista de objetos Post
        List<Post> posts = postsJson.map((json) => Post.fromMap(json)).toList();
        return {'success': true, 'data': posts};
      } else {
        final responseBody = jsonDecode(response.body);
        return {'success': false, 'message': responseBody['message'] ?? 'Failed to fetch posts'};
      }
    } catch (e) {
      print('Get posts error: $e');
      return {'success': false, 'message': 'Network error fetching posts: ${e.toString()}'};
    }
  }
}
