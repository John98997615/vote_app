import 'package:Votify/pages/admin/admin_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../user/home_page.dart';
import '../admin/admin_login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isAdminLogin = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.login(
        _emailController.text,
        _passwordController.text,
        admin: _isAdminLogin,
      );

      // Navigation après connexion réussie
      if (_isAdminLogin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboard()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur de connexion: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _fillDemoCredentials() {
    setState(() {
      if (_isAdminLogin) {
        _emailController.text = 'admin@voteapp.com';
        _passwordController.text = 'password123';
      } else {
        _emailController.text = 'user@example.com';
        _passwordController.text = 'password123';
      }
    });
  }

  void _toggleLoginMode() {
    setState(() {
      _isAdminLogin = !_isAdminLogin;
      _emailController.clear();
      _passwordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo et titre
              _buildHeader(),
              const SizedBox(height: 40),
              
              // Carte de connexion
              _buildLoginCard(),
              const SizedBox(height: 24),
              
              // Section démo
              _buildDemoSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.blue.shade800,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade300.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.how_to_vote,
            size: 50,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Vote App',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          _isAdminLogin ? 'Espace Administrateur' : 'Espace Utilisateur',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey.shade600,
              ),
        ),
      ],
    );
  }

  Widget _buildLoginCard() {
    return Card(
      elevation: 8,
      shadowColor: Colors.blue.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Champ email
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: _isAdminLogin ? 'Email Administrateur' : 'Email',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            
            // Champ mot de passe
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              obscureText: _obscurePassword,
            ),
            const SizedBox(height: 24),
            
            // Bouton de connexion
            SizedBox(
              width: double.infinity,
              height: 50,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade800,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        _isAdminLogin ? 'CONNEXION ADMIN' : 'SE CONNECTER',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
            
            const SizedBox(height: 16),
            
            // Switch entre utilisateur et admin
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Utilisateur',
                  style: TextStyle(
                    color: _isAdminLogin ? Colors.grey : Colors.blue.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch(
                  value: _isAdminLogin,
                  onChanged: (value) => _toggleLoginMode(),
                  activeColor: Colors.blue.shade800,
                ),
                Text(
                  'Admin',
                  style: TextStyle(
                    color: _isAdminLogin ? Colors.blue.shade800 : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoSection() {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 16),
        Text(
          'Accès Démo',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Utilisez le bouton ci-dessous pour remplir les identifiants de démonstration',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade500,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: _fillDemoCredentials,
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.blue.shade800,
            side: BorderSide(color: Colors.blue.shade800),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Remplir identifiants démo'),
        ),
      ],
    );
  }
}