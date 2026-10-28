import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../main.dart';

class ManagementScreen extends StatefulWidget {
  const ManagementScreen({super.key});
  @override State<ManagementScreen> createState() => _ManagementScreenState();
}
class _ManagementScreenState extends State<ManagementScreen> {
  Future<void> _editCourse(Map<String,Object?> course) async {
    final title = TextEditingController(text: course['title'] as String? ?? '');
    final description = TextEditingController(text: course['description'] as String? ?? '');
    final level = TextEditingController(text: course['level'] as String? ?? 'مبتدئ');
    final ok = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
      title: const Text('تعديل المسار'), content: SizedBox(width: 480, child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: title, decoration: const InputDecoration(labelText: 'اسم المسار')),
        TextField(controller: description, minLines: 2, maxLines: 4, decoration: const InputDecoration(labelText: 'الوصف')),
        TextField(controller: level, decoration: const InputDecoration(labelText: 'المستوى')),
      ])), actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')), FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('حفظ'))]));
    if (ok == true && title.text.trim().isNotEmpty) {
      await AppDatabase.instance.updateCourse(course['id'] as int, title: title.text.trim(), description: description.text.trim(), level: level.text.trim());
      if (mounted) setState(() {});
    }
    title.dispose(); description.dispose(); level.dispose();
  }
  Future<void> _editLesson(Map<String,Object?> lesson) async {
    final title = TextEditingController(text: lesson['title'] as String? ?? '');
    final body = TextEditingController(text: lesson['body'] as String? ?? '');
    final code = TextEditingController(text: lesson['sample_code'] as String? ?? '');
    final ok = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
      title: const Text('تحرير الدرس'), content: SizedBox(width: 650, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: title, decoration: const InputDecoration(labelText: 'عنوان الدرس')),
        TextField(controller: body, minLines: 4, maxLines: 9, decoration: const InputDecoration(labelText: 'الشرح')),
        TextField(controller: code, minLines: 4, maxLines: 10, style: const TextStyle(fontFamily: 'Consolas'), decoration: const InputDecoration(labelText: 'المثال البرمجي')),
      ]))), actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')), FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('حفظ التعديلات'))]));
    if (ok == true && title.text.trim().isNotEmpty) {
      await AppDatabase.instance.updateLesson(lesson['id'] as int, title: title.text.trim(), body: body.text.trim(), sampleCode: code.text);
      if (mounted) setState(() {});
    }
    title.dispose(); body.dispose(); code.dispose();
  }
  Future<void> _newLesson(Map<String,Object?> course) async {
    final title = TextEditingController(); final body = TextEditingController(); final code = TextEditingController();
    final ok = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
      title: Text('إضافة درس إلى ${course['language']}'), content: SizedBox(width: 650, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: title, decoration: const InputDecoration(labelText: 'عنوان الدرس')),
        TextField(controller: body, minLines: 3, maxLines: 7, decoration: const InputDecoration(labelText: 'الشرح')),
        TextField(controller: code, minLines: 3, maxLines: 8, style: const TextStyle(fontFamily: 'Consolas'), decoration: const InputDecoration(labelText: 'مثال برمجي')),
      ]))), actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')), FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('إضافة'))]));
    if (ok == true && title.text.trim().isNotEmpty) {
      await AppDatabase.instance.createLesson(course['id'] as int, title: title.text.trim(), body: body.text.trim(), sampleCode: code.text);
      if (mounted) setState(() {});
    }
    title.dispose(); body.dispose(); code.dispose();
  }
  @override Widget build(BuildContext context) {
    if (Session.role == 'طالب') return const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.lock_outline, size: 52), SizedBox(height: 12), Text('هذه الصفحة مخصصة للمعلم والمدير.', style: TextStyle(fontSize: 18)), Text('ملاحظة: اختيار الدور محلي وليس نظام صلاحيات آمن.') ]));
    return FutureBuilder<List<Map<String,Object?>>>(future: AppDatabase.instance.courses(), builder: (context, snap) {
      final courses = snap.data ?? [];
      return ListView(padding: const EdgeInsets.only(bottom: 24), children: [
        const Text('إدارة المحتوى', style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6), Text(Session.role == 'مدير' ? 'إدارة المسارات والدروس ومراجعة المحتوى المحلي.' : 'تحرير شروحات الدروس والأمثلة وإضافة دروس جديدة.'),
        const SizedBox(height: 16),
        const Card(child: ListTile(leading: Icon(Icons.info_outline), title: Text('تخزين محلي'), subtitle: Text('التغييرات تحفظ في SQLite على هذا الجهاز فقط. خذ نسخة احتياطية من قاعدة البيانات عند الحاجة.'))),
        if (snap.connectionState == ConnectionState.waiting) const Center(child: CircularProgressIndicator()),
        ...courses.map((c) => Card(child: ExpansionTile(leading: CircleAvatar(child: Text('${c['language']}'.substring(0,1))), title: Text('${c['title']}'), subtitle: Text('${c['language']} • ${c['level']}'), children: [
          if (Session.role == 'مدير') ListTile(leading: const Icon(Icons.edit_note), title: const Text('تعديل بيانات المسار'), onTap: () => _editCourse(c)),
          ListTile(leading: const Icon(Icons.add_circle_outline), title: const Text('إضافة درس'), onTap: () => _newLesson(c)),
          FutureBuilder<List<Map<String,Object?>>>(future: AppDatabase.instance.lessons(c['id'] as int), builder: (context, lessonSnap) => Column(children: (lessonSnap.data ?? []).map((l) => ListTile(dense: true, leading: const Icon(Icons.article_outlined), title: Text('${l['title']}'), trailing: const Icon(Icons.edit), onTap: () => _editLesson(l))).toList())),
        ]))),
      ]);
    });
  }
}
