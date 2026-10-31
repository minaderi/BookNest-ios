import 'package:flutter/material.dart';

void main() {
  runApp(const BookNestApp());
}

class KitapModel {
  final String baslik;
  final String yazar;
  final String resimYolu;

  const KitapModel({
    required this.baslik,
    required this.yazar,
    required this.resimYolu,
  });
}

class KitapListesiModel {
  final String baslik;
  final List<KitapModel> kitaplar;

  const KitapListesiModel({required this.baslik, required this.kitaplar});
}

class BookNestApp extends StatelessWidget {
  const BookNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookNest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7F4EC),
        primaryColor: const Color(0xFF75420e),
      ),
      home: const GoodreadsAnaSayfa(),
    );
  }
}

class GoodreadsAnaSayfa extends StatefulWidget {
  const GoodreadsAnaSayfa({super.key});

  @override
  State<GoodreadsAnaSayfa> createState() => _GoodreadsAnaSayfaState();
}

class _GoodreadsAnaSayfaState extends State<GoodreadsAnaSayfa> {
  int _seciliSekme = 0;

  final List<KitapListesiModel> _anaSayfaListeleri = [
    KitapListesiModel(
      baslik: 'Booker Prize Shortlist 2026',
      kitaplar: [
        const KitapModel(
          baslik: 'Black Bag',
          yazar: 'Luke Kennard',
          resimYolu: 'assets/images/blackbag.jpg',
        ),
        const KitapModel(
          baslik: 'John of John',
          yazar: 'Douglas Stuart',
          resimYolu: 'assets/images/johnofjohn.jpg',
        ),
        const KitapModel(
          baslik: 'May We Feed the King',
          yazar: 'Rebecca Perry',
          resimYolu: 'assets/images/maywefeedtheking.jpg',
        ),
        const KitapModel(
          baslik: 'The Things We Never Say',
          yazar: 'Elizabeth Strout',
          resimYolu: 'assets/images/strout.jpg',
        ),
        const KitapModel(
          baslik: 'The Disappearers',
          yazar: 'Marlon James',
          resimYolu: 'assets/images/thedisappearers.jpeg',
        ),
        const KitapModel(
          baslik: 'The End of Everything',
          yazar: 'M. John Harrison',
          resimYolu: 'assets/images/theendofeveything.jpg',
        ),
      ],
    ),
    KitapListesiModel(
      baslik: 'Service95 Book Club',
      kitaplar: [
        const KitapModel(
          baslik: 'Lost Lambs',
          yazar: 'Madeline Cash',
          resimYolu: 'assets/images/243808687.jpg',
        ),
        const KitapModel(
          baslik: 'Flesh',
          yazar: 'David Szalay',
          resimYolu: 'assets/images/214152261.jpg',
        ),
        const KitapModel(
          baslik: 'Just Kids',
          yazar: 'Patti Smith',
          resimYolu: 'assets/images/206318521.jpg',
        ),
        const KitapModel(
          baslik: 'Martyr!',
          yazar: 'Kaveh Akbar',
          resimYolu: 'assets/images/139400713.jpg',
        ),
        const KitapModel(
          baslik: 'The Vanishing Half',
          yazar: 'Brit Bennett',
          resimYolu: 'assets/images/51791252.jpg',
        ),
        const KitapModel(
          baslik: 'Pachinko',
          yazar: 'Min Jin Lee',
          resimYolu: 'assets/images/34051011.jpg',
        ),
        const KitapModel(
          baslik: 'A Thousand Splendid Suns',
          yazar: 'Khaled Hosseini',
          resimYolu: 'assets/images/128029.jpg',
        ),
      ],
    ),
    KitapListesiModel(
      baslik: 'Goth Classics',
      kitaplar: [
        const KitapModel(
          baslik: 'Carmilla',
          yazar: 'J. Sheridan Le Fanu',
          resimYolu: 'assets/images/48037.jpg',
        ),
        const KitapModel(
          baslik: 'The Castle of Otranto',
          yazar: 'Horace Walpole',
          resimYolu: 'assets/images/12923.jpg',
        ),
        const KitapModel(
          baslik: 'The Monk',
          yazar: 'Matthew Gregory Lewis',
          resimYolu: 'assets/images/93157.jpg',
        ),
        const KitapModel(
          baslik: 'Frankenstein',
          yazar: 'Mary Shelley',
          resimYolu: 'assets/images/35031085.jpg',
        ),
        const KitapModel(
          baslik: 'Dracula',
          yazar: 'Bram Stoker',
          resimYolu: 'assets/images/17245.jpg',
        ),
        const KitapModel(
          baslik: 'Wuthering Heights',
          yazar: 'Emily Brontë',
          resimYolu: 'assets/images/32929156.jpg',
        ),
        const KitapModel(
          baslik: 'The Old English Baron',
          yazar: 'Clara Reeve',
          resimYolu: 'assets/images/856279.jpg',
        ),
        const KitapModel(
          baslik: 'The Italian',
          yazar: 'Ann Radcliffe',
          resimYolu: 'assets/images/93136.jpg',
        ),
      ],
    ),
  ];

  late final List<Widget> _sayfalar = [
    AnaSayfaIcerigi(listeler: _anaSayfaListeleri),
    const MyBooksPage(),
    const ProfilePage(),
    const SearchPage(),
    const MorePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: const Color(0xFFF7F4EC),
          elevation: 0,
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: const [
                Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  'Title, author or ISBN',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                Spacer(),
                Icon(Icons.camera_alt_outlined, color: Colors.grey),
              ],
            ),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.notifications_none, color: Colors.black87),
            ),
          ],
        ),
      ),
      body: _sayfalar[_seciliSekme],
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        selectedIndex: _seciliSekme,
        onDestinationSelected: (index) {
          setState(() {
            _seciliSekme = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book),
            label: 'My Books',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            selectedIcon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu),
            selectedIcon: Icon(Icons.menu),
            label: 'More',
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------
// SAYFA WIDGET'LARI
// ----------------------------------------------------

class AnaSayfaIcerigi extends StatelessWidget {
  final List<KitapListesiModel> listeler;

  const AnaSayfaIcerigi({super.key, required this.listeler});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listeler.length,
      itemBuilder: (context, listeIndex) {
        final listeModel = listeler[listeIndex];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    listeModel.baslik,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ListeDetaySayfasi(listeModel: listeModel),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.chevron_right,
                      size: 28,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: listeModel.kitaplar.length,
                itemBuilder: (context, kitapIndex) {
                  final kitap = listeModel.kitaplar[kitapIndex];
                  return Container(
                    width: 120,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.asset(
                              kitap.resimYolu,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.shade300,
                                  child: const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          kitap.baslik,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          kitap.yazar,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class MyBooksPage extends StatelessWidget {
  const MyBooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'My Books Page',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoggedIn ? _buildProfileContent() : _buildAuthCard(),
    );
  }

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
                backgroundColor: Color(0xFF75420e),
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
                leading: const Icon(
                  Icons.lock_outline,
                  color: Color(0xFF75420e),
                ),
                title: const Text('Change Password'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showChangePasswordDialog(context);
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(
                  Icons.settings_outlined,
                  color: Color(0xFF75420e),
                ),
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
                onTap: () {
                  setState(() {
                    _isLoggedIn = false;
                    _userEmail = '';
                    _userName = '';
                    _nameController.clear();
                    _emailController.clear();
                    _passwordController.clear();
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

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
              color: const Color(0xFF75420e),
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
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF75420e),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                String email = _emailController.text.trim();
                String password = _passwordController.text;
                String name = _nameController.text.trim();

                // Boş alan kontrolü
                if (email.isEmpty ||
                    password.isEmpty ||
                    (_isRegistering && name.isEmpty)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields!')),
                  );
                  return;
                }

                if (_isRegistering) {
                  // Kayıt Olma İşlemi
                  if (_registeredUsers.containsKey(email)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'This email is already registered. Please log in.',
                        ),
                      ),
                    );
                  } else {
                    _registeredUsers[email] = {
                      'name': name,
                      'password': password,
                    };
                    setState(() {
                      _userEmail = email;
                      _userName = name;
                      _isLoggedIn = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Registration successful!')),
                    );
                  }
                } else {
                  // Giriş Yapma İşlemi
                  if (!_registeredUsers.containsKey(email)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'This account is not registered. Please sign up first.',
                        ),
                      ),
                    );
                  } else if (_registeredUsers[email]!['password'] != password) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Incorrect password! Please try again.'),
                      ),
                    );
                  } else {
                    setState(() {
                      _userEmail = email;
                      _userName = _registeredUsers[email]!['name']!;
                      _isLoggedIn = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logged in successfully!')),
                    );
                  }
                }
              },
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
                  _emailController.clear();
                  _passwordController.clear();
                  _nameController.clear();
                });
              },
              child: Text(
                _isRegistering
                    ? 'Already have an account? Log In'
                    : "Don't have an account? Register",
                style: const TextStyle(color: Color(0xFF75420e)),
              ),
            ),
          ],
        ),
      ),
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
            color: Color(0xFF75420e),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
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
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF75420e),
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password updated successfully!'),
                  ),
                );
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Search Page',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'More Page',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// ----------------------------------------------------
// LİSTE DETAY SAYFASI
// ----------------------------------------------------
class ListeDetaySayfasi extends StatelessWidget {
  final KitapListesiModel listeModel;

  const ListeDetaySayfasi({super.key, required this.listeModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F4EC),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Text(
          listeModel.baslik,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: listeModel.kitaplar.length,
        itemBuilder: (context, index) {
          final kitap = listeModel.kitaplar[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.asset(
                    kitap.resimYolu,
                    width: 60,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 90,
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        kitap.baslik,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        kitap.yazar,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          );
        },
      ),
    );
  }
}
