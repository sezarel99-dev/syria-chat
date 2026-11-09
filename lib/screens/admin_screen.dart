import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('لوحة الإدارة — سيزر')),
    body: ListView(padding: const EdgeInsets.all(18), children: const [
      Card(child: ListTile(leading: Icon(Icons.verified_user, color: Color(0xFFC9A45C)), title: Text('SUPER ADMIN'), subtitle: Text('يتم إظهار هذه اللوحة فقط عند وجود Firebase Custom Claim موثوق.'))),
      Card(child: ListTile(leading: Icon(Icons.manage_accounts), title: Text('إدارة المشرفين'), subtitle: Text('المرحلة التالية: تعيين الصلاحيات من الخادم.'))),
      Card(child: ListTile(leading: Icon(Icons.workspace_premium), title: Text('مستويات VIP 1–10'), subtitle: Text('تصميم الشارات محفوظ ضمن مواصفات المشروع.'))),
      Card(child: ListTile(leading: Icon(Icons.shield_outlined), title: Text('الأمان'), subtitle: Text('لا تمنح صلاحية المدير من واجهة التطبيق أو من اسم المستخدم.'))),
    ]),
  );
}
