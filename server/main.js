const express = require('express');
const bodyParser = require('body-parser'); // Embora express.json() seja preferível agora
const cors = require('cors'); // Importa o pacote cors

const app = express();
const port = 4000; // Ou qualquer porta que você preferir

// Middleware para parsear corpos de requisição JSON
app.use(express.json());
// app.use(bodyParser.json()); // Alternativa mais antiga

// Habilita o CORS para todas as origens (ajuste em produção se necessário)
app.use(cors());

// Armazenamento em memória (substitua por um banco de dados em produção)
let users = []; // { id, username, email, password }
let posts = []; // { id, text, position: { x, y, z }, createdAt, userId }
let userIdCounter = 1;
let postIdCounter = 1;

// Rota de Registro
app.post('/register', (req, res) => {
  const { username, email, password } = req.body;

  if (!username || !email || !password) {
    return res.status(400).json({ message: 'Username, email, and password are required' });
  }

  // Verifica se o usuário já existe (simplista)
  if (users.some(user => user.email === email)) {
    return res.status(409).json({ message: 'Email already exists' });
  }

  const newUser = {
    id: userIdCounter++,
    username,
    email,
    password, // IMPORTANTE: Em produção, sempre faça hash da senha!
  };
  users.push(newUser);
  console.log('User registered:', newUser);
  // Não retorne a senha
  res.status(201).json({ id: newUser.id, username: newUser.username, email: newUser.email });
});

// Rota de Login
app.post('/login', (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ message: 'Email and password are required' });
  }

  const user = users.find(user => user.email === email);

  // IMPORTANTE: Compare o hash da senha em produção!
  if (!user || user.password !== password) {
    return res.status(401).json({ message: 'Invalid credentials' });
  }

  console.log('User logged in:', user.email);
  // Não retorne a senha. Considere retornar um token (JWT) em produção.
  res.status(200).json({ message: 'Login successful', userId: user.id });
});

// Rota para Criar Post
// TODO: Adicionar autenticação para garantir que apenas usuários logados possam postar
app.post('/posts', (req, res) => {
  const { text, position, userId } = req.body; // Assumindo que o userId é enviado no corpo por enquanto

  if (!text || !position || !userId) {
    return res.status(400).json({ message: 'Text, position, and userId are required' });
  }
   // Validação básica da posição
   if (typeof position.x !== 'number' || typeof position.y !== 'number' || typeof position.z !== 'number') {
    return res.status(400).json({ message: 'Position must have numeric x, y, and z coordinates' });
  }

  // Verifica se o usuário existe (opcional, mas bom)
  if (!users.some(user => user.id === userId)) {
      return res.status(404).json({ message: 'User not found' });
  }

  const newPost = {
    id: postIdCounter++,
    text,
    position, // { x, y, z }
    createdAt: new Date().toISOString(),
    userId,
  };
  posts.push(newPost);
  console.log('Post created:', newPost);
  res.status(201).json(newPost);
});

// Rota para Obter Posts
// TODO: Adicionar autenticação se necessário
app.get('/posts', (req, res) => {
  console.log(`Returning ${posts.length} posts.`);
  // Retorna os posts em ordem cronológica inversa (mais recentes primeiro)
  res.status(200).json([...posts].reverse());
});

// Inicia o servidor
app.listen(port, () => {
  console.log(`Server listening at http://localhost:${port}`);
});
