import 'package:flutter/material.dart';
import '../database/app_database.dart';

class SqlScreen extends StatefulWidget {
  const SqlScreen({super.key});
  @override
  State<SqlScreen> createState() => _SqlScreenState();
}

class _SqlScreenState extends State<SqlScreen> {
  final sql = TextEditingController(text: 'SELECT name, city FROM learners;');
  String message = 'جرّب SELECT على جدول learners.';
  List<Map<String, Object?>> rows = [];
  bool busy = false;

  @override
  void dispose() { sql.dispose(); super.dispose(); }

  Future<void> _run() async {
    setState(() => busy = true);
    try {
      final result = await AppDatabase.instance.runSql(sql.text);
      if (!mounted) return;
      setState(() {
        rows = result;
        message = 'عدد الصفوف: ${result.length}';
        busy = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        message = '$e';
        rows = [];
        busy = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: ListView(children: [
      const Text('مختبر SQL المحلي', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      const Text('تنفيذ استعلامات قراءة فقط على SQLite. يسمح هذا المختبر بـ SELECT وPRAGMA.'),
      const SizedBox(height: 14),
      TextField(controller: sql, minLines: 3, maxLines: 6, style: const TextStyle(fontFamily: 'Consolas'), decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'استعلام SQL')),
      const SizedBox(height: 10),
      FilledButton.icon(onPressed: busy ? null : _run, icon: const Icon(Icons.play_arrow), label: Text(busy ? 'جارٍ التنفيذ' : 'تنفيذ الاستعلام')),
      const SizedBox(height: 12),
      Text(message),
      if (rows.isNotEmpty) SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(
        columns: rows.first.keys.map((k) => DataColumn(label: Text(k))).toList(),
        rows: rows.map((r) => DataRow(cells: r.values.map((v) => DataCell(Text('$v'))).toList())).toList(),
      )),
    ]),
  );
}
