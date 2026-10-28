import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../main.dart';
import 'course_screen.dart';
import 'editor_screen.dart';
import 'sql_screen.dart';
import 'results_screen.dart';
import 'settings_screen.dart';
import 'management_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      _dashboard(), const EditorScreen(), const SqlScreen(),
      const ResultsScreen(), const ManagementScreen(), const SettingsScreen(),
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Row(children: [
          NavigationRail(
            selectedIndex: selected,
            onDestinationSelected: (v) => setState(() => selected = v),
            labelType: NavigationRailLabelType.all,
            leading: const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Icon(Icons.school, size: 32, color: Color(0xFF2457A7)),
            ),
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.dashboard_outlined), label: Text('الرئيسية')),
              NavigationRailDestination(icon: Icon(Icons.code), label: Text('المحرر')),
              NavigationRailDestination(icon: Icon(Icons.storage), label: Text('SQL')),
              NavigationRailDestination(icon: Icon(Icons.assignment_outlined), label: Text('النتائج')),
              NavigationRailDestination(icon: Icon(Icons.admin_panel_settings_outlined), label: Text('الإدارة')),
              NavigationRailDestination(icon: Icon(Icons.settings_outlined), label: Text('الإعدادات')),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: Padding(padding: const EdgeInsets.all(24), child: pages[selected])),
        ]),
      ),
    );
  }

  Widget _dashboard() => FutureBuilder<List<Map<String, Object?>>>(
    future: AppDatabase.instance.courses(),
    builder: (context, snap) {
      final courses = snap.data ?? <Map<String, Object?>>[];
      return ListView(children: [
        Text('أهلاً ${Session.name}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text('الدور الحالي: ${Session.role} • منصة تعليمية محلية'),
        const SizedBox(height: 18),
        const Wrap(spacing: 12, runSpacing: 12, children: [
          _Stat(icon: Icons.menu_book, title: 'الدورات', value: '7 مسارات'),
          _Stat(icon: Icons.library_books, title: 'الدروس', value: '420 درساً أولياً'),
          _Stat(icon: Icons.wifi_off, title: 'التشغيل', value: 'محلي دون اتصال'),
        ]),
        const SizedBox(height: 24),
        const Text('الدورات التعليمية', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        if (snap.connectionState == ConnectionState.waiting)
          const Center(child: CircularProgressIndicator())
        else if (snap.hasError)
          Text('تعذر تحميل الدورات: ${snap.error}')
        else
          ...courses.map((c) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Card(child: ListTile(
              contentPadding: const EdgeInsets.all(14),
              leading: CircleAvatar(child: Text((c['language'] as String)[0])),
              title: Text(c['title'] as String),
              subtitle: Text('${c['description']}\n${c['language']} • ${c['level']}'),
              isThreeLine: true,
              trailing: const Icon(Icons.arrow_back_ios),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CourseScreen(course: c))),
            )),
          )),
        const SizedBox(height: 12),
        const Text('ملاحظة: المحتوى الحالي هيكل أولي؛ يلزم توسيع الشروح ومراجعتها قبل اعتماده كمنهج رسمي.', style: TextStyle(color: Colors.grey)),
      ]);
    },
  );
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const _Stat({required this.icon, required this.title, required this.value});
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 210,
    child: Card(child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [
      Icon(icon, size: 28, color: const Color(0xFF2457A7)),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value, style: const TextStyle(color: Colors.grey)),
      ])),
    ]))),
  );
}
