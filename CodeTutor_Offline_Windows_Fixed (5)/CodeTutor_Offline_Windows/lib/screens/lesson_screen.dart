import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../main.dart';
import 'editor_screen.dart';

class LessonScreen extends StatelessWidget {
 final Map<String,Object?> lesson;final String language;
 const LessonScreen({super.key,required this.lesson,required this.language});
 @override Widget build(BuildContext context){
  final code=lesson['sample_code'] as String;
  return Directionality(textDirection:TextDirection.rtl,child:Scaffold(appBar:AppBar(title:Text(lesson['title'] as String)),body:ListView(padding:const EdgeInsets.all(24),children:[
   Text(lesson['body'] as String,style:const TextStyle(fontSize:17,height:1.7)),
   const SizedBox(height:18),const Text('مثال برمجي',style:TextStyle(fontWeight:FontWeight.bold,fontSize:20)),
   Container(width:double.infinity,padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:const Color(0xFF172033),borderRadius:BorderRadius.circular(12)),child:SelectableText(code,style:const TextStyle(color:Colors.white,fontFamily:'Consolas',fontSize:14))),
   const SizedBox(height:18),
   FilledButton.icon(onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>EditorScreen(initialLanguage:language,initialCode:code))),icon:const Icon(Icons.code),label:const Text('جرّب المثال في المحرر')),
   const SizedBox(height:10),
   OutlinedButton.icon(onPressed:()async{await AppDatabase.instance.markLesson(Session.name,lesson['id'] as int);if(context.mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('تم حفظ الدرس كمكتمل')));},icon:const Icon(Icons.check_circle),label:const Text('تحديد الدرس كمكتمل')),
   const SizedBox(height:24),const Text('تمرين الدرس',style:TextStyle(fontWeight:FontWeight.bold,fontSize:20)),
   const Text('عدّل المثال ليعطي نتيجة مختلفة. جرّب الكود ثم اشرح ما الذي غيّرته.')
  ])));
 }
}
