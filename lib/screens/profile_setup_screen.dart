import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});
  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}
class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _name = TextEditingController();
  final _username = TextEditingController();
  final _bio = TextEditingController();
  final _country = TextEditingController();
  final _city = TextEditingController();
  bool _busy = false;
  String? _error;

  Future<void> _save() async {
    final user = FirebaseAuth.instance.currentUser;
    final name = _name.text.trim();
    final username = _username.text.trim().toLowerCase().replaceAll('@', '');
    if (user == null) return;
    if (name.isEmpty || !RegExp(r'^[a-z0-9_]{3,20}$').hasMatch(username)) {
      setState(() => _error = 'أدخل اسماً ظاهراً، واسم مستخدم من 3 إلى 20 حرفاً إنجليزياً أو رقماً أو _.');
      return;
    }
    setState(() { _busy = true; _error = null; });
    final db = FirebaseFirestore.instance;
    final userRef = db.collection('users').doc(user.uid);
    final usernameRef = db.collection('usernames').doc(username);
    try {
      await db.runTransaction((tx) async {
        final taken = await tx.get(usernameRef);
        if (taken.exists && taken.data()?['uid'] != user.uid) throw Exception('اسم المستخدم مستخدم؛ اختر اسماً آخر.');
        tx.set(usernameRef, {'uid': user.uid, 'createdAt': FieldValue.serverTimestamp()});
        tx.set(userRef, {
          'uid': user.uid, 'email': user.email,
          'displayName': name, 'username': username,
          'photoUrl': null, 'bio': _bio.text.trim(),
          'country': _country.text.trim(), 'city': _city.text.trim(),
          'profileCompleted': true,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      });
    } catch (e) {
      if (mounted) setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally { if (mounted) setState(() => _busy = false); }
  }

  @override
  void dispose() { for (final c in [_name,_username,_bio,_country,_city]) { c.dispose(); } super.dispose(); }
  InputDecoration _dec(String label) => InputDecoration(labelText: label, filled: true, fillColor: const Color(0xFF171717), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)));
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('إكمال الملف الشخصي'), automaticallyImplyLeading: false),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      const Icon(Icons.account_circle_outlined, size: 72, color: Color(0xFFC9A45C)),
      const Text('خطوة أخيرة قبل الدخول', textAlign: TextAlign.center, style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8), const Text('الاسم واسم المستخدم مطلوبان. بقية المعلومات اختيارية ويمكن تعديلها لاحقاً.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, height: 1.5)),
      const SizedBox(height: 22), TextField(controller: _name, decoration: _dec('الاسم الظاهر *')),
      const SizedBox(height: 12), TextField(controller: _username, decoration: _dec('اسم المستخدم الفريد * (مثال: sezar_1)')),
      const SizedBox(height: 12), TextField(controller: _bio, maxLines: 3, decoration: _dec('نبذة قصيرة (اختياري)')),
      const SizedBox(height: 12), TextField(controller: _country, decoration: _dec('البلد (اختياري)')),
      const SizedBox(height: 12), TextField(controller: _city, decoration: _dec('المدينة (اختياري)')),
      if (_error != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(_error!, style: const TextStyle(color: Colors.orangeAccent))),
      const SizedBox(height: 18), FilledButton(onPressed: _busy ? null : _save, style: FilledButton.styleFrom(backgroundColor: const Color(0xFFC9A45C), foregroundColor: Colors.black, padding: const EdgeInsets.all(16)), child: Text(_busy ? 'جارٍ الحفظ...' : 'حفظ ومتابعة')),
      TextButton(onPressed: () async { await FirebaseAuth.instance.signOut(); }, child: const Text('تسجيل الخروج')),
    ]),
  );
}
