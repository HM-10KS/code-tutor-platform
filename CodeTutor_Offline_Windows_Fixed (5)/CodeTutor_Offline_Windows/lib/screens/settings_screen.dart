import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SettingsScreen extends StatelessWidget {
 const SettingsScreen({super.key});
 @override Widget build(BuildContext context)=>Directionality(textDirection:TextDirection.rtl,child:FutureBuilder(future:getApplicationSupportDirectory(),builder:(context,snap)=>ListView(children:[
  const Text('الإعدادات ومعلومات النظام',style:TextStyle(fontSize:26,fontWeight:FontWeight.bold)),const SizedBox(height:16),
  const Card(child:ListTile(leading:Icon(Icons.storage),title:Text('قاعدة البيانات'),subtitle:Text('SQLite محلية'))),
  const Card(child:ListTile(leading:Icon(Icons.wifi_off),title:Text('وضع التشغيل'),subtitle:Text('لا يتطلب خادماً أو حساباً سحابياً'))),
  const Card(child:ListTile(leading:Icon(Icons.warning_amber),title:Text('الأمان'),subtitle:Text('لا تشغّل أكواداً غير موثوقة؛ لا يوجد عزل للبرامج المنفذة.'))),
  const SizedBox(height:10),const Text('مسار بيانات التطبيق:',style:TextStyle(fontWeight:FontWeight.bold)),
  SelectableText(snap.data?.path??'جارٍ تحديد المسار...')
 ])));
}
