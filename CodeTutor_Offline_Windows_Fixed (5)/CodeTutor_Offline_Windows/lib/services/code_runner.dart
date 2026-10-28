import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class RunResult {
  final String output; final int? exitCode; final bool success;
  RunResult(this.output, this.exitCode, this.success);
}

class CodeRunner {
  Future<RunResult> run(String language, String code) async {
    final temp = await getTemporaryDirectory();
    final dir = Directory(p.join(temp.path, 'code_tutor_runner'));
    await dir.create(recursive:true);
    try {
      if (language == 'HTML' || language == 'CSS' || language == 'SQL') {
        return RunResult(language == 'SQL'
          ? 'استخدم صفحة SQL لتشغيل الاستعلامات على SQLite.'
          : 'لا توجد معاينة HTML/CSS مدمجة في هذه النسخة. احفظ HTML وافتحه في المتصفح واربط CSS بالصفحة.', null, false);
      }
      if (language == 'Python') {
        final f=File(p.join(dir.path,'main.py')); await f.writeAsString(code);
        return _candidates([['python',f.path],['py',f.path]],dir.path);
      }
      if (language == 'JavaScript') {
        final f=File(p.join(dir.path,'main.js')); await f.writeAsString(code);
        return _candidates([['node',f.path]],dir.path);
      }
      if (language == 'Java') {
        final f=File(p.join(dir.path,'Main.java')); await f.writeAsString(code);
        final c=await Process.run('javac',[f.path],workingDirectory:dir.path,runInShell:true);
        if(c.exitCode!=0) return RunResult('${c.stdout}\\n${c.stderr}',c.exitCode as int,false);
        return _candidates([['java','-cp',dir.path,'Main']],dir.path);
      }
      if (language == 'C#') {
        final project=Directory(p.join(dir.path,'CSharpRunner')); await project.create(recursive:true);
        await File(p.join(project.path,'CSharpRunner.csproj')).writeAsString('<Project Sdk="Microsoft.NET.Sdk"><PropertyGroup><OutputType>Exe</OutputType><TargetFramework>net8.0</TargetFramework><ImplicitUsings>enable</ImplicitUsings><Nullable>enable</Nullable></PropertyGroup></Project>');
        await File(p.join(project.path,'Program.cs')).writeAsString(code);
        return _candidates([['dotnet','run','--project',project.path]],project.path);
      }
      return RunResult('لغة غير مدعومة.',null,false);
    } on ProcessException catch(e) {
      return RunResult('أداة التشغيل غير موجودة. ثبّت بيئة اللغة وأضفها إلى PATH. ${e.message}',null,false);
    } catch(e) { return RunResult('تعذر تشغيل الكود: $e',null,false); }
  }

  Future<RunResult> _candidates(List<List<String>> commands,String cwd) async {
    String last='';
    for(final c in commands) {
      try {
        final r=await Process.run(c.first,c.skip(1).toList(),workingDirectory:cwd,runInShell:true);
        final out='${r.stdout}${r.stderr}'.trim();
        return RunResult(out.isEmpty?'انتهى التنفيذ دون مخرجات نصية.':out,r.exitCode,r.exitCode==0);
      } on ProcessException catch(e) { last=e.message; }
    }
    return RunResult('لم يتم العثور على بيئة تشغيل مناسبة. $last',null,false);
  }
}
