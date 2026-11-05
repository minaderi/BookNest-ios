import 'package:flutter/material.dart';

import '../core/sabitler.dart';

// PROFİL SAYFASI
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static bool _isLoggedIn = false;
  static String _userEmail = '';
  static String _userName = '';

  // Geçici Yerel Veritabanı (Backend eklenene kadar kullanıcıları burada tutuyoruz)
  // Format: 'email' : {'name': 'Kullanıcı Adı', 'password': 'Sifre'}
  static final Map<String, Map<String, String>> _registeredUsers = {};

  bool _isRegistering = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoggedIn ? _buildProfileContent() : _buildAuthCard(),
    );
  }

  // ------------------- PROFİL İÇERİĞİ -------------------

  Widget _buildProfileContent() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 20),
        Center(
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: kAnaRenk,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text(
                _userName.isNotEmpty ? _userName : 'User',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _userEmail.isNotEmpty ? _userEmail : 'user@booknest.com',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('12', 'Read'),
              _buildStatItem('5', 'Favorites'),
              _buildStatItem('3', 'Goal'),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.lock_outline, color: kAnaRenk),
                title: const Text('Change Password'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showChangePasswordDialog(context),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.settings_outlined, color: kAnaRenk),
                title: const Text('Account Settings'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Log Out',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: _cikisYap,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: kAnaRenk,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );
  }

  // ------------------- GİRİŞ / KAYIT -------------------

  Widget _buildAuthCard() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isRegistering
                  ? Icons.person_add_outlined
                  : Icons.lock_person_outlined,
              size: 70,
              color: kAnaRenk,
            ),
            const SizedBox(height: 16),
            Text(
              _isRegistering ? 'Create an Account' : 'Sign in to BookNest',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _isRegistering
                  ? 'Sign up to start tracking your reading journey.'
                  : 'Log in to see your favorite books and reading list.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            if (_isRegistering) ...[
              _buildTextField(_nameController, 'Username'),
              const SizedBox(height: 16),
            ],
            _buildTextField(_emailController, 'Email'),
            const SizedBox(height: 16),
            _buildTextField(_passwordController, 'Password', gizli: true),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kAnaRenk,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _gonder,
              child: Text(
                _isRegistering ? 'Register' : 'Log In',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                setState(() {
                  _isRegistering = !_isRegistering;
                  _formuTemizle();
                });
              },
              child: Text(
                _isRegistering
                    ? 'Already have an account? Log In'
                    : "Don't have an account? Register",
                style: const TextStyle(color: kAnaRenk),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String etiket, {
    bool gizli = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: gizli,
      decoration: InputDecoration(
        labelText: etiket,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // ------------------- İŞLEMLER -------------------

  void _mesajGoster(String mesaj) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mesaj)));
  }

  void _formuTemizle() {
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
  }

  void _gonder() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final name = _nameController.text.trim();

    // Boş alan kontrolü
    if (email.isEmpty || password.isEmpty || (_isRegistering && name.isEmpty)) {
      _mesajGoster('Please fill in all fields!');
      return;
    }

    if (_isRegistering) {
      _kayitOl(email, password, name);
    } else {
      _girisYap(email, password);
    }
  }

  void _kayitOl(String email, String password, String name) {
    if (_registeredUsers.containsKey(email)) {
      _mesajGoster('This email is already registered. Please log in.');
      return;
    }
    _registeredUsers[email] = {'name': name, 'password': password};
    setState(() {
      _userEmail = email;
      _userName = name;
      _isLoggedIn = true;
    });
    _mesajGoster('Registration successful!');
  }

  void _girisYap(String email, String password) {
    final kullanici = _registeredUsers[email];
    if (kullanici == null) {
      _mesajGoster('This account is not registered. Please sign up first.');
    } else if (kullanici['password'] != password) {
      _mesajGoster('Incorrect password! Please try again.');
    } else {
      setState(() {
        _userEmail = email;
        _userName = kullanici['name']!;
        _isLoggedIn = true;
      });
      _mesajGoster('Logged in successfully!');
    }
  }

  void _cikisYap() {
    setState(() {
      _isLoggedIn = false;
      _userEmail = '';
      _userName = '';
      _formuTemizle();
    });
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Old Password'),
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'New Password'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: kAnaRenk),
              onPressed: () {
                Navigator.pop(dialogContext);
                _mesajGoster('Password updated successfully!');
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}