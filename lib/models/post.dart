import 'package:vector_math/vector_math_64.dart' as vector;

class Post {
  final String id;
  final String text;
  final vector.Vector3 position;
  final DateTime createdAt;
  final int userId; // Adiciona userId ao modelo

  Post({
    required this.id,
    required this.text,
    required this.position,
    required this.userId, // Adiciona userId ao construtor
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert Post to Map for storage (não é usado para enviar ao backend neste caso, pois o backend gera id e createdAt)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'position': {
        'x': position.x,
        'y': position.y,
        'z': position.z,
      },
      'createdAt': createdAt.toIso8601String(), // Pode ser útil para outros fins
      'userId': userId,
    };
  }

  // Create Post from Map (for retrieval from backend)
  factory Post.fromMap(Map<String, dynamic> map) {
    // Validação básica dos campos esperados
    if (map['id'] == null || map['text'] == null || map['position'] == null || map['createdAt'] == null || map['userId'] == null) {
       throw const FormatException("Invalid Post data received from server");
    }
     // Validação da posição
    final positionMap = map['position'];
    if (positionMap is! Map || positionMap['x'] == null || positionMap['y'] == null || positionMap['z'] == null) {
       throw const FormatException("Invalid Post position data received from server");
    }


    return Post(
      // O backend agora retorna id como número, mas vamos manter como String no frontend por flexibilidade
      // Se o backend SEMPRE retornar número, pode ser `id: map['id'].toString()`
      id: map['id'].toString(),
      text: map['text'] as String,
      position: vector.Vector3(
        (positionMap['x'] as num).toDouble(), // Converte num para double
        (positionMap['y'] as num).toDouble(),
        (positionMap['z'] as num).toDouble(),
      ),
      // Analisa a string ISO 8601 vinda do backend
      createdAt: DateTime.parse(map['createdAt'] as String),
      userId: map['userId'] as int,
    );
  }
}
