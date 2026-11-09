import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _register = false, _busy = false;
  String? _message;

  Future<void> _submit() async {
    final email = _email.text.trim();
    final password = _password.text;
    if (email.isEmpty || password.length < 6) {
      setState(() => _message = 'أدخل بريداً صحيحاً وكلمة مرور من 6 أحرف على الأقل.');
      return;
    }
    setState(() { _busy = true; _message = null; });
    try {
      if (_register) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() => _message = _friendly(e.code));
    } catch (_) {
      if (!mounted) return;
      setState(() => _message = 'حدث خطأ غير متوقع. حاول مرة أخرى.');
    } finally { if (mounted) setState(() => _busy = false); }
  }

  String _friendly(String code) => switch (code) {
    'email-already-in-use' => 'هذا البريد مستخدم مسبقاً.',
    'invalid-email' => 'صيغة البريد الإلكتروني غير صحيحة.',
    'weak-password' => 'كلمة المرور ضعيفة؛ استخدم 6 أحرف على الأقل.',
    'user-not-found' || 'wrong-password' || 'invalid-credential' => 'بيانات الدخول غير صحيحة.',
    'network-request-failed' => 'تحقق من اتصال الإنترنت.',
    _ => 'تعذر إكمال العملية: $code',
  };

  @override
  void dispose() { _email.dispose(); _password.dispose(); super.dispose(); }

  InputDecoration _dec(String label, IconData icon) => InputDecoration(
    labelText: label, prefixIcon: Icon(icon, color: const Color(0xFFC9A45C)),
    filled: true, fillColor: const Color(0xFF171717),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(_register ? 'إنشاء حساب' : 'تسجيل الدخول'), centerTitle: true),
    body: SafeArea(child: ListView(padding: const EdgeInsets.all(22), children: [
      const SizedBox(height: 25), const Icon(Icons.forum_rounded, size: 64, color: Color(0xFFC9A45C)),
      const SizedBox(height: 12), const Text('SYRIA CHAT', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 2)),
      const SizedBox(height: 8), Text(_register ? 'أنشئ حسابك وابدأ رحلتك' : 'أهلاً بك من جديد', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)),
      const SizedBox(height: 30), TextField(controller: _email, keyboardType: TextInputType.emailAddress, decoration: _dec('البريد الإلكتروني', Icons.email_outlined)),
      const SizedBox(height: 14), TextField(controller: _password, obscureText: true, decoration: _dec('كلمة المرور', Icons.lock_outline)),
      const SizedBox(height: 20), FilledButton(onPressed: _busy ? null : _submit, style: FilledButton.styleFrom(backgroundColor: const Color(0xFFC9A45C), foregroundColor: Colors.black, padding: const EdgeInsets.all(16)), child: Text(_busy ? 'جارٍ التنفيذ...' : (_register ? 'إنشاء الحساب' : 'دخول إلى الحساب'))),
      TextButton(onPressed: _busy ? null : () => setState(() { _register = !_register; _message = null; }), child: Text(_register ? 'لديك حساب؟ سجّل الدخول' : 'ليس لديك حساب؟ أنشئ حساباً')),
      if (_message != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(_message!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.orangeAccent))),
      const SizedBox(height: 30), const Text('© 2026 SYRIA CHAT', textAlign: TextAlign.center, style: TextStyle(color: Colors.white38, fontSize: 11)),
    ])),
  );
}
