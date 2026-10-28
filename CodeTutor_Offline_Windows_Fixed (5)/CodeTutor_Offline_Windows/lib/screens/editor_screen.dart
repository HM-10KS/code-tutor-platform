import 'package:flutter/material.dart';
import '../services/code_runner.dart';

class EditorScreen extends StatefulWidget {
 final String? initialLanguage;final String? initialCode;
 const EditorScreen({super.key,this.initialLanguage,this.initialCode});
 @override State<EditorScreen> createState()=>_EditorScreenState();
}
class _EditorScreenState extends State<EditorScreen>{
 final code=TextEditingController();String language='Python';String output='ستظهر نتيجة التشغيل هنا.';bool running=false;
 @override void initState(){super.initState();language=widget.initialLanguage??'Python';code.text=widget.initialCode??'print("Hello, world!")';}
 @override void dispose(){code.dispose();super.dispose();}
 @override Widget build(BuildContext context)=>Directionality(textDirection:TextDirection.rtl,child:ListView(children:[
  const Text('محرر الأكواد',style:TextStyle(fontSize:26,fontWeight:FontWeight.bold)),const SizedBox(height:8),
  const Text('شغّل Python وJavaScript وJava وC# عند توفر أدواتها محلياً. HTML/CSS لا تتوفر لهما معاينة مدمجة.'),
  const SizedBox(height:16),
  DropdownButtonFormField<String>(initialValue:language,decoration:const InputDecoration(labelText:'لغة البرمجة',border:OutlineInputBorder()),items:const ['Python','JavaScript','Java','C#','HTML','CSS','SQL'].map((v)=>DropdownMenuItem(value:v,child:Text(v))).toList(),onChanged:(v){if(v!=null)setState(()=>language=v);}),
  const SizedBox(height:12),
  TextField(controller:code,minLines:12,maxLines:22,style:const TextStyle(fontFamily:'Consolas',fontSize:14),decoration:const InputDecoration(labelText:'اكتب الكود هنا',alignLabelWithHint:true,border:OutlineInputBorder(),filled:true,fillColor:Colors.white)),
  const SizedBox(height:12),
  FilledButton.icon(onPressed:running?null:()async{setState(()=>running=true);final r=await CodeRunner().run(language,code.text);if(mounted)setState(()=>{output='${r.success?'نجاح':'ملاحظة'}${r.exitCode==null?'':' • Exit ${r.exitCode}'}\\n${r.output}',running=false});},icon:const Icon(Icons.play_arrow),label:Text(running?'جارٍ التشغيل...':'تشغيل الكود')),
  const SizedBox(height:16),const Text('المخرجات',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),const SizedBox(height:8),
  Container(padding:const EdgeInsets.all(16),width:double.infinity,decoration:BoxDecoration(color:const Color(0xFF172033),borderRadius:BorderRadius.circular(12)),child:SelectableText(output,style:const TextStyle(color:Colors.white,fontFamily:'Consolas')))
 ]));
}
