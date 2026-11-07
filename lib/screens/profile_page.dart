import 'package:flutter/material.dart';

import '../core/sabitler.dart';
import '../models/raf_turu.dart';
import '../services/favori_yoneticisi.dart';
import '../services/kullanici_deposu.dart';
import '../services/raf_yoneticisi.dart';
import 'account_settings_page.dart';

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
  static int? _avatarNo; // seçilen avatar (1-8), seçilmediyse null

  // Kayıtlı kullanıcılar (açılışta cihaz hafızasından yüklenir)
  // Format: 'email' : {'name': 'Kullanıcı Adı', 'password': 'Sifre'}
  static Map<String, Map<String, String>> _registeredUsers = {};

  bool _isRegistering = false;
  bool _yukleniyor = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _verileriYukle();
  }

  // Kayıtlı kullanıcıları ve açık oturumu hafızadan okur
  Future<void> _verileriYukle() async {
    final kullanicilar = await KullaniciDeposu.kullanicilariGetir();
    final oturumEmail = await KullaniciDeposu.oturumuGetir();
    final avatarNo = oturumEmail == null
        ? null
        : await KullaniciDeposu.avatariGetir(oturumEmail);
    if (!mounted) return;

    setState(() {
      _registeredUsers = kullanicilar;
      _avatarNo = avatarNo;
      final kullanici = oturumEmail == null ? null : kullanicilar[oturumEmail];
      if (kullanici != null) {
        _userEmail = oturumEmail!;
        _userName = kullanici['name'] ?? '';
        _isLoggedIn = true;
      } else {
        // Oturum yok (ör. hesap silindi)
        _userEmail = '';
        _userName = '';
        _isLoggedIn = false;
      }
      _yukleniyor = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_yukleniyor) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: kAnaRenk)),
      );
    }
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
              // Avatar + köşede kalem rozeti; tıklayınca seçim menüsü açılır
              GestureDetector(
                onTap: _avatarSeciminiGoster,
                child: Stack(
                  children: [
                    _avatarResmi(_avatarNo, 50),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: kAnaRenk, width: 1.5),
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 16,
                          color: kAnaRenk,
                        ),
                      ),
                    ),
                  ],
                ),
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
          // Raflar veya favoriler değiştikçe sayılar kendiliğinden güncellenir
          child: ListenableBuilder(
            listenable: Listenable.merge([
              RafYoneticisi.instance,
              FavoriYoneticisi.instance,
            ]),
            builder: (context, _) {
              final raflar = RafYoneticisi.instance;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    '${raflar.rafta(RafTuru.okudum).length}',
                    'Read',
                  ),
                  _buildStatItem(
                    '${FavoriYoneticisi.instance.sayi}',
                    'Favorites',
                  ),
                  _buildStatItem(
                    '${raflar.rafta(RafTuru.okumakIstiyorum).length}',
                    'Want to Read',
                  ),
                ],
              );
            },
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
                onTap: _hesapAyarlariniAc,
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
            if (!_isRegistering)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _showForgotPasswordDialog,
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: kAnaRenk, fontSize: 13),
                  ),
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

  Future<void> _gonder() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final name = _nameController.text.trim();

    // Boş alan kontrolü
    if (email.isEmpty || password.isEmpty || (_isRegistering && name.isEmpty)) {
      _mesajGoster('Please fill in all fields!');
      return;
    }

    // Yeni kayıtlarda şifre en az 6 karakter olmalı
    if (_isRegistering && password.length < kMinSifreUzunlugu) {
      _mesajGoster('Password must be at least $kMinSifreUzunlugu characters');
      return;
    }

    if (_isRegistering) {
      await _kayitOl(email, password, name);
    } else {
      await _girisYap(email, password);
    }
  }

  Future<void> _kayitOl(String email, String password, String name) async {
    if (_registeredUsers.containsKey(email)) {
      _mesajGoster('This email is already registered. Please log in.');
      return;
    }
    _registeredUsers[email] = {'name': name, 'password': password};
    await KullaniciDeposu.kullanicilariKaydet(_registeredUsers);
    await KullaniciDeposu.oturumuKaydet(email);
    await _kitaplariYukle(email);
    if (!mounted) return;
    setState(() {
      _userEmail = email;
      _userName = name;
      _isLoggedIn = true;
    });
    _mesajGoster('Registration successful!');
  }

  Future<void> _girisYap(String email, String password) async {
    final kullanici = _registeredUsers[email];
    if (kullanici == null) {
      _mesajGoster('This account is not registered. Please sign up first.');
    } else if (kullanici['password'] != password) {
      _mesajGoster('Incorrect password! Please try again.');
    } else {
      await KullaniciDeposu.oturumuKaydet(email);
      await _kitaplariYukle(email);
      if (!mounted) return;
      setState(() {
        _userEmail = email;
        _userName = kullanici['name']!;
        _isLoggedIn = true;
      });
      _mesajGoster('Logged in successfully!');
    }
  }

  // Giriş yapan kişinin favori, raf ve avatarını yükler (null = boşalt)
  Future<void> _kitaplariYukle(String? email) async {
    await FavoriYoneticisi.instance.kullaniciyaGec(email);
    await RafYoneticisi.instance.kullaniciyaGec(email);
    _avatarNo = email == null
        ? null
        : await KullaniciDeposu.avatariGetir(email);
  }

  // ------------------- AVATAR -------------------

  // Avatar resmi; seçilmediyse kişi ikonu
  Widget _avatarResmi(int? no, double yaricap) {
    if (no == null || no < 1 || no > kAvatarSayisi) {
      return CircleAvatar(
        radius: yaricap,
        backgroundColor: kAnaRenk,
        child: Icon(Icons.person, size: yaricap, color: Colors.white),
      );
    }
    return CircleAvatar(
      radius: yaricap,
      backgroundColor: Colors.transparent,
      backgroundImage: AssetImage('assets/images/avatars/avatar_$no.png'),
    );
  }

  // Alttan açılan avatar seçim menüsü (4'erli iki satır)
  void _avatarSeciminiGoster() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Choose Your Avatar',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    for (var no = 1; no <= kAvatarSayisi; no++)
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(sheetContext);
                          _avatariSec(no);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: no == _avatarNo
                                  ? kAnaRenk
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          child: _avatarResmi(no, 40),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _avatariSec(int no) async {
    setState(() => _avatarNo = no);
    await KullaniciDeposu.avatariKaydet(_userEmail, no);
  }

  Future<void> _cikisYap() async {
    await KullaniciDeposu.oturumuKapat();
    await _kitaplariYukle(null);
    if (!mounted) return;
    setState(() {
      _isLoggedIn = false;
      _userEmail = '';
      _userName = '';
      _formuTemizle();
    });
  }

  Future<void> _showChangePasswordDialog(BuildContext context) async {
    final kullanici = _registeredUsers[_userEmail];
    if (kullanici == null) return;

    final kaydedildi = await showDialog<bool>(
      context: context,
      builder: (_) => _SifreDegistirmeDialogu(
        mevcutSifre: kullanici['password'] ?? '',
        onKaydet: (yeniSifre) async {
          kullanici['password'] = yeniSifre;
          await KullaniciDeposu.kullanicilariKaydet(_registeredUsers);
        },
      ),
    );
    if (kaydedildi == true) {
      _mesajGoster('Password updated successfully!');
    }
  }

  Future<void> _hesapAyarlariniAc() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AccountSettingsPage(
          email: _userEmail,
          kullanicilar: _registeredUsers,
        ),
      ),
    );
    // Ad / e-posta değişmiş ya da hesap silinmiş olabilir: yeniden oku
    await _verileriYukle();
    if (!_isLoggedIn) _formuTemizle();
  }

  Future<void> _showForgotPasswordDialog() async {
    final email = await showDialog<String>(
      context: context,
      builder: (_) => _SifreSifirlamaDialogu(
        kullanicilar: _registeredUsers,
        onKaydet: (email, yeniSifre) async {
          _registeredUsers[email]!['password'] = yeniSifre;
          await KullaniciDeposu.kullanicilariKaydet(_registeredUsers);
        },
      ),
    );
    if (email == null || !mounted) return;
    // Sıfırlanan e-postayı giriş kutusuna yaz
    _emailController.text = email;
    _passwordController.clear();
    _mesajGoster('Password reset! You can now log in');
  }
}

// assets/images/avatars/ klasöründeki avatar sayısı (avatar_1 ... avatar_8)
const int kAvatarSayisi = 8;

// Kayıt ve şifre değiştirmede geçerli en kısa şifre uzunluğu
const int kMinSifreUzunlugu = 6;

// Yeni şifre kuralları (şifre değiştirme ve sıfırlamada ortak).
// Sorun yoksa null, varsa hata mesajı döner.
String? _yeniSifreHatasi(String yeni, {String? eskiSifre}) {
  if (yeni.isEmpty) return 'Please fill in all fields';
  if (yeni.length < kMinSifreUzunlugu) {
    return 'Must be at least $kMinSifreUzunlugu characters';
  }
  if (eskiSifre != null && yeni == eskiSifre) {
    return 'New password must be different';
  }
  return null;
}

String? _sifreTekrarHatasi(String yeni, String tekrar) {
  if (tekrar.isEmpty) return 'Please fill in all fields';
  if (tekrar != yeni) return 'Passwords do not match';
  return null;
}

// Şifre kutusu (pencerelerde ortak)
Widget _sifreKutusu(
  TextEditingController controller,
  String etiket,
  String? hata, {
  bool gizli = true,
}) {
  return TextField(
    controller: controller,
    obscureText: gizli,
    decoration: InputDecoration(labelText: etiket, errorText: hata),
  );
}

// ŞİFREMİ UNUTTUM PENCERESİ
// E-posta ve kullanıcı adı eşleşirse yeni şifre belirlenir.
// Başarılı olursa pencere sıfırlanan e-postayı döndürür.
class _SifreSifirlamaDialogu extends StatefulWidget {
  final Map<String, Map<String, String>> kullanicilar;
  final Future<void> Function(String email, String yeniSifre) onKaydet;

  const _SifreSifirlamaDialogu({
    required this.kullanicilar,
    required this.onKaydet,
  });

  @override
  State<_SifreSifirlamaDialogu> createState() => _SifreSifirlamaDialoguState();
}

class _SifreSifirlamaDialoguState extends State<_SifreSifirlamaDialogu> {
  final _emailController = TextEditingController();
  final _adController = TextEditingController();
  final _yeniController = TextEditingController();
  final _tekrarController = TextEditingController();

  String? _emailHata;
  String? _adHata;
  String? _yeniHata;
  String? _tekrarHata;
  bool _kaydediliyor = false;

  @override
  void dispose() {
    _emailController.dispose();
    _adController.dispose();
    _yeniController.dispose();
    _tekrarController.dispose();
    super.dispose();
  }

  Future<void> _kaydet() async {
    final email = _emailController.text.trim();
    final ad = _adController.text.trim();
    final yeni = _yeniController.text;
    final tekrar = _tekrarController.text;

    String? emailHata = email.isEmpty ? 'Please fill in all fields' : null;
    String? adHata = ad.isEmpty ? 'Please fill in all fields' : null;

    // E-posta ve kullanıcı adı eşleşmeli (büyük/küçük harf fark etmez).
    // Hangisinin yanlış olduğunu söylemiyoruz.
    if (emailHata == null && adHata == null) {
      final kayitliAd = widget.kullanicilar[email]?['name'];
      if (kayitliAd == null || kayitliAd.toLowerCase() != ad.toLowerCase()) {
        adHata = 'Email or username is incorrect';
      }
    }

    final yeniHata = _yeniSifreHatasi(yeni);
    final tekrarHata = _sifreTekrarHatasi(yeni, tekrar);

    setState(() {
      _emailHata = emailHata;
      _adHata = adHata;
      _yeniHata = yeniHata;
      _tekrarHata = tekrarHata;
    });
    if (emailHata != null ||
        adHata != null ||
        yeniHata != null ||
        tekrarHata != null) {
      return;
    }

    setState(() => _kaydediliyor = true);
    await widget.onKaydet(email, yeni);
    if (!mounted) return;
    Navigator.pop(context, email);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reset Password'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _sifreKutusu(_emailController, 'Email', _emailHata, gizli: false),
            _sifreKutusu(_adController, 'Username', _adHata, gizli: false),
            _sifreKutusu(_yeniController, 'New Password', _yeniHata),
            _sifreKutusu(
              _tekrarController,
              'Confirm New Password',
              _tekrarHata,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _kaydediliyor ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: kAnaRenk),
          onPressed: _kaydediliyor ? null : _kaydet,
          child: const Text('Reset', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

// ŞİFRE DEĞİŞTİRME PENCERESİ
// Hatalar ilgili kutunun altında gösterilir, pencere ancak başarılı olunca kapanır.
class _SifreDegistirmeDialogu extends StatefulWidget {
  final String mevcutSifre;
  final Future<void> Function(String yeniSifre) onKaydet;

  const _SifreDegistirmeDialogu({
    required this.mevcutSifre,
    required this.onKaydet,
  });

  @override
  State<_SifreDegistirmeDialogu> createState() =>
      _SifreDegistirmeDialoguState();
}

class _SifreDegistirmeDialoguState extends State<_SifreDegistirmeDialogu> {
  final _eskiController = TextEditingController();
  final _yeniController = TextEditingController();
  final _tekrarController = TextEditingController();

  String? _eskiHata;
  String? _yeniHata;
  String? _tekrarHata;
  bool _kaydediliyor = false;

  @override
  void dispose() {
    _eskiController.dispose();
    _yeniController.dispose();
    _tekrarController.dispose();
    super.dispose();
  }

  Future<void> _kaydet() async {
    final eski = _eskiController.text;
    final yeni = _yeniController.text;
    final tekrar = _tekrarController.text;

    String? eskiHata;
    if (eski.isEmpty) {
      eskiHata = 'Please fill in all fields';
    } else if (eski != widget.mevcutSifre) {
      eskiHata = 'Old password is incorrect';
    }
    final yeniHata = _yeniSifreHatasi(yeni, eskiSifre: widget.mevcutSifre);
    final tekrarHata = _sifreTekrarHatasi(yeni, tekrar);

    setState(() {
      _eskiHata = eskiHata;
      _yeniHata = yeniHata;
      _tekrarHata = tekrarHata;
    });
    if (eskiHata != null || yeniHata != null || tekrarHata != null) return;

    setState(() => _kaydediliyor = true);
    await widget.onKaydet(yeni);
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change Password'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _sifreKutusu(_eskiController, 'Old Password', _eskiHata),
            _sifreKutusu(_yeniController, 'New Password', _yeniHata),
            _sifreKutusu(
              _tekrarController,
              'Confirm New Password',
              _tekrarHata,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _kaydediliyor ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: kAnaRenk),
          onPressed: _kaydediliyor ? null : _kaydet,
          child: const Text('Save', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
