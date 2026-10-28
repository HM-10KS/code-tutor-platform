import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../main.dart';

class ResultsScreen extends StatelessWidget {
 const ResultsScreen({super.key});
 @override Widget build(BuildContext context)=>Directionality(textDirection:TextDirection.rtl,child:Scaffold(backgroundColor:Colors.transparent,body:FutureBuilder<List<Map<String,Object?>>>(future:AppDatabase.instance.results(Session.name),builder:(context,snap){
  final results=snap.data??[];
  return ListView(children:[
   const Text('النتائج والتقدم',style:TextStyle(fontSize:26,fontWeight:FontWeight.bold)),const SizedBox(height:12),
   FutureBuilder<int>(future:AppDatabase.instance.completedCount(Session.name),builder:(context,s)=>Card(child:Padding(padding:const EdgeInsets.all(18),child:Text('الدروس المكتملة: ${s.data??0}',style:const TextStyle(fontSize:18,fontWeight:FontWeight.bold))))),
   const SizedBox(height:18),const Text('نتائج التمارين',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
   if(results.isEmpty) const Padding(padding:EdgeInsets.all(16),child:Text('لا توجد نتائج محفوظة بعد.')),
   ...results.map((r)=>Card(child:ListTile(leading:const Icon(Icons.assignment_turned_in),title:Text('الدرجة: ${r['score']}'),subtitle:Text('${r['created_at']}\\n${r['answer']}'))))
  ]);
 })));
}
