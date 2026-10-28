import 'package:flutter/material.dart';
import '../main.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override State<LoginScreen> createState()=>_LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final name=TextEditingController(text:'طالب');
  String role='طالب';
  @override void dispose(){name.dispose();super.dispose();}
  @override Widget build(BuildContext context)=>Directionality(
    textDirection:TextDirection.rtl,
    child:Scaffold(body:Center(child:ConstrainedBox(constraints:const BoxConstraints(maxWidth:520),child:Card(child:Padding(padding:const EdgeInsets.all(32),child:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.stretch,children:[
      const Icon(Icons.school,size:64,color:Color(0xFF2457A7)),
      const SizedBox(height:12),
      const Text('Code Tutor Offline',textAlign:TextAlign.center,style:TextStyle(fontSize:28,fontWeight:FontWeight.bold)),
      const Text('منصة تعليم البرمجة دون إنترنت',textAlign:TextAlign.center),
      const SizedBox(height:24),
      TextField(controller:name,decoration:const InputDecoration(labelText:'اسم المستخدم',border:OutlineInputBorder())),
      const SizedBox(height:14),
      DropdownButtonFormField<String>(initialValue:role,decoration:const InputDecoration(labelText:'الدور',border:OutlineInputBorder()),items:const [
        DropdownMenuItem(value:'طالب',child:Text('طالب')),DropdownMenuItem(value:'مدرس',child:Text('مدرس')),DropdownMenuItem(value:'مدير',child:Text('مدير'))],onChanged:(v)=>setState(()=>role=v??'طالب')),
      const SizedBox(height:20),
      FilledButton.icon(onPressed:(){Session.name=name.text.trim().isEmpty?'طالب':name.text.trim();Session.role=role;Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>const HomeScreen()));},icon:const Icon(Icons.login),label:const Padding(padding:EdgeInsets.all(12),child:Text('دخول محلي'))),
      const SizedBox(height:10),
      const Text('الأدوار محلية للتجربة وليست نظام مصادقة آمن.',textAlign:TextAlign.center,style:TextStyle(fontSize:12,color:Colors.grey))
    ])))))),
  );
}
