import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'admin_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  bool _checkingAdmin = false;
  bool _isSuperAdmin = false;
  @override
  void initState() { super.initState(); _checkAdmin(); }
  Future<void> _checkAdmin() async {
    setState(() => _checkingAdmin = true);
    try {
      final token = await FirebaseAuth.instance.currentUser!.getIdTokenResult(true);
      _isSuperAdmin = token.claims?['role'] == 'super_admin';
    } catch (_) { _isSuperAdmin = false; }
    if (mounted) setState(() => _checkingAdmin = false);
  }
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(title: const Text('SYRIA CHAT'), actions: [IconButton(tooltip: 'تسجيل الخروج', onPressed: () => FirebaseAuth.instance.signOut(), icon: const Icon(Icons.logout))]),
      body: StreamBuilder<DocumentSnapshot<Map<String,dynamic>>>(
        stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
        builder: (context, snap) {
          final p = snap.data?.data() ?? {};
          final name = p['displayName'] ?? 'مستخدم';
          final username = p['username'] ?? '';
          return ListView(padding: const EdgeInsets.all(18), children: [
            Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(color: const Color(0xFF191611), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF8C713A))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('أهلاً بك في SYRIA CHAT', style: TextStyle(color: Color(0xFFC9A45C), fontSize: 13)), const SizedBox(height: 8), Text(name.toString(), style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)), Text('@$username', style: const TextStyle(color: Colors.white60))]),),
            const SizedBox(height: 20),
            _tile(Icons.forum_outlined, 'الغرف الصوتية', 'استكشف الغرف وتعرّف إلى المجتمع'),
            _tile(Icons.chat_bubble_outline, 'الرسائل', 'محادثاتك ستظهر هنا'),
            _tile(Icons.people_outline, 'الأصدقاء', 'قائمة الأصدقاء'),
            _tile(Icons.person_outline, 'ملفي الشخصي', 'إدارة معلومات حسابك'),
            if (_isSuperAdmin) Card(child: ListTile(leading: const Icon(Icons.admin_panel_settings, color: Color(0xFFC9A45C)), title: const Text('لوحة الإدارة'), subtitle: const Text('SUPER ADMIN'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminScreen())))),
            if (_checkingAdmin) const Center(child: Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator())),
          ]);
        },
      ),
    );
  }
  Widget _tile(IconData icon, String title, String subtitle) => Card(color: const Color(0xFF151515), child: ListTile(leading: Icon(icon, color: const Color(0xFFC9A45C)), title: Text(title), subtitle: Text(subtitle), trailing: const Icon(Icons.chevron_right)));
}
