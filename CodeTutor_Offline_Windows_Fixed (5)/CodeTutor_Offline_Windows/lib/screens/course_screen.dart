import 'package:flutter/material.dart';
import '../database/app_database.dart';
import 'lesson_screen.dart';

class CourseScreen extends StatelessWidget {
 final Map<String,Object?> course;const CourseScreen({super.key,required this.course});
 @override Widget build(BuildContext context)=>Directionality(textDirection:TextDirection.rtl,child:Scaffold(appBar:AppBar(title:Text(course['title'] as String)),body:FutureBuilder<List<Map<String,Object?>>>(future:AppDatabase.instance.lessons(course['id'] as int),builder:(context,snap){
  if(!snap.hasData)return const Center(child:CircularProgressIndicator());
  final lessons=snap.data!;
  return ListView(padding:const EdgeInsets.all(20),children:[
   Text(course['description'] as String,style:const TextStyle(fontSize:17)),const SizedBox(height:16),
   Text('الدروس (${lessons.length})',style:const TextStyle(fontSize:22,fontWeight:FontWeight.bold)),
   ...lessons.map((l)=>Card(child:ListTile(leading:CircleAvatar(child:Text('${l['number']}')),title:Text(l['title'] as String),subtitle:const Text('شرح ومثال وتمرين'),trailing:const Icon(Icons.chevron_left),onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>LessonScreen(lesson:l,language:course['language'] as String))))))
  ]);
 })));
}
