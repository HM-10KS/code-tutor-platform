import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const languageTopics = <String, List<String>>{
  'Python': ['مقدمة اللغة والطباعة','المتغيرات وأنواع البيانات','العمليات الحسابية والمنطقية','الشروط if/else','حلقات for وwhile','القوائم والصفوف','القواميس والمجموعات','الدوال والمعاملات','النطاق والقيم المرجعة','التعامل مع النصوص','الملفات والمجلدات','الاستثناءات ومعالجة الأخطاء','الوحدات والاستيراد','البرمجة الكائنية','الأصناف والكائنات','الوراثة والتركيب','المكررات والمولدات','التعبيرات المختصرة','اختبار وتصحيح البرامج','مشروع تطبيقي'],
  'Java': ['مقدمة Java وJDK','المتغيرات والأنواع','العمليات والتعبيرات','الشروط','الحلقات','المصفوفات','النصوص String','الدوال والطرق','الأصناف والكائنات','البنّاء constructors','التغليف','الوراثة','تعدد الأشكال','الواجهات interfaces','الأصناف المجردة','الاستثناءات','المجموعات Collections','Generics','الملفات والإدخال والإخراج','مشروع تطبيقي'],
  'C#': ['مقدمة C# و.NET','المتغيرات والأنواع','العمليات','الشروط','الحلقات','المصفوفات','القوائم','النصوص','الدوال','الأصناف والكائنات','الخصائص','التغليف','الوراثة','الواجهات','LINQ','الاستثناءات','الملفات','Async وAwait','تصحيح الأخطاء','مشروع تطبيقي'],
  'JavaScript': ['مقدمة JavaScript','المتغيرات let وconst','أنواع البيانات','العمليات','الشروط','الحلقات','الدوال','المصفوفات','الكائنات','النطاق','الأساليب الحديثة','DOM','الأحداث','النماذج والتحقق','JSON','الوحدات Modules','الوعود Promises','async/await','Fetch وواجهات API','مشروع تطبيقي'],
  'HTML': ['بنية صفحة HTML','العناوين والفقرات','تنسيق النص الدلالي','الروابط','الصور والنص البديل','القوائم','الجداول','النماذج','حقول الإدخال','التحقق من النماذج','الصوت والفيديو','العناصر الدلالية','الرؤوس والتذييلات','إتاحة الوصول','الكيانات والرموز','meta وviewport','ربط CSS','ربط JavaScript','تنظيم الصفحة','مشروع صفحة شخصية'],
  'CSS': ['طرق إضافة CSS','المحددات','الألوان والخلفيات','الوحدات والقياسات','النموذج الصندوقي','الحدود والظلال','الخطوط والنصوص','Display','Position','Flexbox','CSS Grid','التجاوب Media Queries','الحالات pseudo-classes','العناصر الزائفة','التحويلات','الانتقالات','الحركات','المتغيرات CSS','تنظيم الأنماط','مشروع متجاوب'],
  'SQL': ['مقدمة قواعد البيانات','SELECT','WHERE','ORDER BY','LIMIT','DISTINCT','LIKE وBETWEEN','AND وOR','دوال التجميع','GROUP BY','HAVING','INSERT','UPDATE','DELETE','إنشاء الجداول','أنواع البيانات','المفاتيح الأساسية','المفاتيح الخارجية','INNER JOIN','LEFT JOIN','الاستعلامات الفرعية','الفهارس','المعاملات','التطبيع','مشروع قاعدة بيانات'],
};

class AppDatabase {
  AppDatabase._();
  static final instance = AppDatabase._();
  Database? _db;
  Database get db => _db!;

  Future<void> initialize() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    final dir = await getApplicationSupportDirectory();
    final path = p.join(dir.path, 'code_tutor.db');
    _db = await databaseFactory.openDatabase(path, options: OpenDatabaseOptions(
      version: 1,
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE courses(id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT NOT NULL,description TEXT NOT NULL,language TEXT NOT NULL,level TEXT NOT NULL)');
        await db.execute('CREATE TABLE lessons(id INTEGER PRIMARY KEY AUTOINCREMENT,course_id INTEGER NOT NULL,number INTEGER NOT NULL,title TEXT NOT NULL,body TEXT NOT NULL,sample_code TEXT NOT NULL,UNIQUE(course_id,number))');
        await db.execute('CREATE TABLE exercises(id INTEGER PRIMARY KEY AUTOINCREMENT,lesson_id INTEGER NOT NULL,title TEXT NOT NULL,question TEXT NOT NULL,hint TEXT NOT NULL)');
        await db.execute('CREATE TABLE progress(id INTEGER PRIMARY KEY AUTOINCREMENT,student_name TEXT NOT NULL,lesson_id INTEGER NOT NULL,completed INTEGER NOT NULL DEFAULT 0,UNIQUE(student_name,lesson_id))');
        await db.execute('CREATE TABLE results(id INTEGER PRIMARY KEY AUTOINCREMENT,student_name TEXT NOT NULL,exercise_id INTEGER NOT NULL,answer TEXT NOT NULL,score INTEGER NOT NULL,created_at TEXT NOT NULL)');
        await db.execute('CREATE TABLE learners(id INTEGER PRIMARY KEY,name TEXT NOT NULL,city TEXT NOT NULL)');
        await _seed(db);
      },
    ));
  }

  Future<void> _seed(DatabaseExecutor db) async {
    for (final entry in languageTopics.entries) {
      final cid = await db.insert('courses', {
        'title': 'أساسيات ${entry.key}',
        'description': 'مسار ${entry.key} من المبتدئ إلى موضوعات تطبيقية.',
        'language': entry.key, 'level': 'مبتدئ إلى متوسط',
      });
      final topics = entry.value;
      for (var i = 1; i <= 60; i++) {
        final topic = topics[(i - 1) % topics.length];
        final code = _sample(entry.key, i);
        final lessonId = await db.insert('lessons', {
          'course_id': cid, 'number': i,
          'title': 'الدرس $i: $topic',
          'body': 'هدف الدرس: فهم $topic في ${entry.key}.\\n\\nاقرأ المثال، غيّر القيم، ثم اكتب مثالاً من عندك. دوّن المصطلحات الجديدة وراجع الناتج قبل الانتقال للدرس التالي.\\n\\nهذه مادة أولية تحتاج إلى توسعة تحريرية ومراجعة تعليمية قبل اعتمادها كمنهج نهائي.',
          'sample_code': code,
        });
        await db.insert('exercises', {
          'lesson_id': lessonId,
          'title': 'تطبيق الدرس $i',
          'question': 'عدّل مثال الدرس $i في ${entry.key} ليعرض نتيجة مختلفة، واشرح ما الذي غيّرته.',
          'hint': 'ابدأ بتغيير اسم المتغير أو النص أو القيمة في المثال، ثم اختبر الناتج.',
        });
      }
    }
    await db.insert('learners', {'name':'أحمد','city':'بنغازي'});
    await db.insert('learners', {'name':'سارة','city':'طرابلس'});
    await db.insert('learners', {'name':'علي','city':'درنة'});
  }

  String _sample(String lang, int i) {
    switch (lang) {
      case 'Python': return 'name = "Student $i"\\nprint("Hello", name)';
      case 'JavaScript': return 'const name = "Student $i";\\nconsole.log("Hello", name);';
      case 'Java': return 'public class Main {\\n  public static void main(String[] args) {\\n    System.out.println("Hello Student $i");\\n  }\\n}';
      case 'C#': return 'Console.WriteLine("Hello Student $i");';
      case 'HTML': return '<!doctype html>\\n<html lang="ar"><head><meta charset="utf-8"><title>Lesson $i</title></head>\\n<body><h1>مرحباً</h1><p>الدرس $i</p></body></html>';
      case 'CSS': return 'body {\\n  font-family: Arial, sans-serif;\\n  background: #f4f7fb;\\n}\\nh1 { color: #2457a7; }';
      default: return 'SELECT name, city FROM learners;';
    }
  }

  Future<List<Map<String,Object?>>> courses() => db.query('courses', orderBy: 'id');

  Future<void> updateLesson(int id, {required String title, required String body, required String sampleCode}) async {
    await db.update('lessons', {'title': title, 'body': body, 'sample_code': sampleCode}, where: 'id=?', whereArgs: [id]);
  }

  Future<void> updateCourse(int id, {required String title, required String description, required String level}) async {
    await db.update('courses', {'title': title, 'description': description, 'level': level}, where: 'id=?', whereArgs: [id]);
  }

  Future<int> createLesson(int courseId, {required String title, required String body, required String sampleCode}) async {
    final rows = await db.rawQuery('SELECT COALESCE(MAX(number), 0) + 1 AS next_number FROM lessons WHERE course_id=?', [courseId]);
    final number = (rows.first['next_number'] as int?) ?? 1;
    return db.insert('lessons', {'course_id': courseId, 'number': number, 'title': title, 'body': body, 'sample_code': sampleCode});
  }

  Future<int> courseCount() async => _count('SELECT COUNT(*) FROM courses');
  Future<int> lessonCount() async => _count('SELECT COUNT(*) FROM lessons');
  Future<int> _count(String sql, [List<Object?>? args]) async {
    final rows = await db.rawQuery(sql, args);
    final value = rows.isEmpty ? 0 : rows.first.values.first;
    return value is int ? value : int.tryParse('$value') ?? 0;
  }
  Future<List<Map<String,Object?>>> allProgress() => db.rawQuery('SELECT student_name, COUNT(*) AS completed FROM progress WHERE completed=1 GROUP BY student_name ORDER BY completed DESC');
  Future<List<Map<String,Object?>>> allResults() => db.query('results', orderBy: 'id DESC', limit: 500);

  Future<List<Map<String,Object?>>> lessons(int courseId) => db.query('lessons', where:'course_id=?', whereArgs:[courseId], orderBy:'number');
  Future<List<Map<String,Object?>>> exercises(int lessonId) => db.query('exercises', where:'lesson_id=?', whereArgs:[lessonId]);
  Future<void> markLesson(String student, int lessonId) async {
    await db.insert('progress', {'student_name':student,'lesson_id':lessonId,'completed':1}, conflictAlgorithm:ConflictAlgorithm.replace);
  }
  Future<int> completedCount(String student) async => _count('SELECT COUNT(*) FROM progress WHERE student_name=? AND completed=1', [student]);
  Future<void> saveResult(String student, int exerciseId, String answer, int score) async {
    await db.insert('results', {'student_name':student,'exercise_id':exerciseId,'answer':answer,'score':score,'created_at':DateTime.now().toIso8601String()});
  }
  Future<List<Map<String,Object?>>> results(String student) => db.query('results', where:'student_name=?',whereArgs:[student],orderBy:'id DESC',limit:100);
  Future<List<Map<String,Object?>>> runSql(String sql) async {
    final s=sql.trim();
    if (!(s.toUpperCase().startsWith('SELECT') || s.toUpperCase().startsWith('PRAGMA'))) {
      throw Exception('يسمح هذا المختبر باستعلامات SELECT وPRAGMA فقط.');
    }
    return db.rawQuery(s);
  }
}
