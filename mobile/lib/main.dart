import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() => runApp(const LearnersDic());
const ink=Color(0xFF17231E), forest=Color(0xFF315B48), paper=Color(0xFFF5F3EC), muted=Color(0xFF78827B), line=Color(0xFFE5E5DC);
const langs=['English','French','Spanish','Yorùbá','Igbo','Hausa'];
const codes={'English':'en','French':'fr','Spanish':'es','Yorùbá':'yo','Igbo':'ig','Hausa':'ha'};

class LearnersDic extends StatelessWidget {
 const LearnersDic({super.key});
 @override Widget build(BuildContext context)=>MaterialApp(title:'LEARNERS DIC.',debugShowCheckedModeBanner:false,theme:ThemeData(useMaterial3:true,scaffoldBackgroundColor:paper,colorScheme:ColorScheme.fromSeed(seedColor:forest)),home:const Home());
}
class Home extends StatefulWidget { const Home({super.key}); @override State<Home> createState()=>_HomeState(); }
class _HomeState extends State<Home> {
 int tab=0; final word=TextEditingController(), input=TextEditingController(), output=TextEditingController(); final tts=FlutterTts();
 String language='English', from='English', to='French'; bool busy=false, translating=false; String? error, transError; Map<String,dynamic>? result; List<String> saved=[]; int question=0, score=0; bool answered=false; int? choice;
 final qs=[
  ['What does “benevolent” mean?',['Cruel','Kind and well meaning','Wealthy'],'1','Benevolent describes someone who wishes good for others.'],
  ['Which word means fluent and persuasive in speech?',['Eloquent','Abandon','Ancient'],'0','Eloquent means fluent or persuasive in speaking or writing.'],
  ['What is a lexicon?',['A building','A language’s vocabulary','A writing tool'],'1','A lexicon is the vocabulary of a language or subject.'],
  ['Which part of speech names a person, place, thing or idea?',['Verb','Adverb','Noun'],'2','A noun names a person, place, thing or idea.'],
  ['Which word is closest in meaning to “rapid”?',['Slow','Swift','Quiet'],'1','Swift is a synonym of rapid.']
 ];
 @override void initState(){super.initState(); loadSaved();}
 Future<void> loadSaved() async {final p=await SharedPreferences.getInstance(); if(mounted)setState(()=>saved=p.getStringList('saved')??[]);}
 Future<void> toggleSave(String w) async {final n=[...saved]; if(n.contains(w)){n.remove(w);}else{n.insert(0,w);} final p=await SharedPreferences.getInstance(); await p.setStringList('saved',n); if(mounted)setState(()=>saved=n);}
 Future<void> lookup() async {
  final q=word.text.trim(); if(q.isEmpty)return;
  if(language!='English'){setState(()=>error='The English dictionary is currently connected. The $language collection is not yet available for dictionary lookup.');return;}
  setState(() { busy=true; error=null; result=null; });
  try{
   final r=await http.get(Uri.https('api.dictionaryapi.dev','/api/v2/entries/en/'+Uri.encodeComponent(q))).timeout(const Duration(seconds:20));
   if(r.statusCode!=200)throw Exception('No English entry found for “$q”. Check the spelling.');
   final data=jsonDecode(r.body) as List; if(data.isEmpty)throw Exception('No entry found.');
   setState(()=>result=data.first as Map<String,dynamic>);
  }catch(e){setState(()=>error=e.toString().replaceFirst('Exception: ',''));}
  finally{if(mounted)setState(()=>busy=false);}
 }
 Future<void> translate() async {
  final q=input.text.trim(); if(q.isEmpty)return;
  setState(() { translating=true; transError=null; output.clear(); });
  try{
   final uri=Uri.https('api.mymemory.translated.net','/get',{'q':q,'langpair':codes[from]!+'|'+codes[to]!});
   final r=await http.get(uri).timeout(const Duration(seconds:25)); if(r.statusCode!=200)throw Exception('Translation service unavailable.');
   final d=jsonDecode(r.body) as Map; final v=(d['responseData'] as Map?)?['translatedText']?.toString();
   if(d['responseStatus']!=200||v==null||v.isEmpty)throw Exception(d['responseDetails']??'No translation returned.');
   output.text=v;
  }catch(e){setState(()=>transError=e.toString().replaceFirst('Exception: ',''));}
  finally{if(mounted)setState(()=>translating=false);}
 }
 Future<void> speak(String s,[String locale='en-US']) async {await tts.setLanguage(locale);await tts.setSpeechRate(.45);await tts.speak(s);}
 @override void dispose(){word.dispose();input.dispose();output.dispose();tts.stop();super.dispose();}
 @override Widget build(BuildContext context)=>Scaffold(body:SafeArea(child:IndexedStack(index:tab,children:[dictionary(),translator(),learn(),savedPage()])),bottomNavigationBar:NavigationBar(selectedIndex:tab,onDestinationSelected:(v)=>setState(()=>tab=v),backgroundColor:const Color(0xFFFCFBF7),indicatorColor:const Color(0xFFE2EAE3),destinations:const [NavigationDestination(icon:Icon(Icons.menu_book_outlined),label:'Dictionary'),NavigationDestination(icon:Icon(Icons.translate),label:'Translate'),NavigationDestination(icon:Icon(Icons.school_outlined),label:'Learn'),NavigationDestination(icon:Icon(Icons.bookmark_border),label:'Saved')]));
 Widget header(String eyebrow,String title,String desc)=>Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('LEARNERS DIC.',style:TextStyle(fontWeight:FontWeight.w900,letterSpacing:1.3,color:ink)),const SizedBox(height:28),Text(eyebrow,style:const TextStyle(color:forest,fontSize:10,fontWeight:FontWeight.w800,letterSpacing:2)),const SizedBox(height:8),Text(title,style:const TextStyle(fontSize:32,height:1.1,fontWeight:FontWeight.w700,color:ink)),const SizedBox(height:8),Text(desc,style:const TextStyle(color:muted,fontSize:13,height:1.5))]);
 Widget panel(String title,String body)=>Container(width:double.infinity,padding:const EdgeInsets.all(17),decoration:BoxDecoration(color:const Color(0xFFECEFE8),borderRadius:BorderRadius.circular(16)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:const TextStyle(fontWeight:FontWeight.w700,color:ink)),const SizedBox(height:6),Text(body,style:const TextStyle(color:muted,fontSize:13,height:1.5))]));
 Widget dictionary()=>ListView(padding:const EdgeInsets.all(22),children:[
  Row(children:[Container(width:38,height:38,alignment:Alignment.center,decoration:BoxDecoration(color:forest,borderRadius:BorderRadius.circular(12)),child:const Text('LD',style:TextStyle(color:Colors.white,fontWeight:FontWeight.w900))),const SizedBox(width:10),const Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('LEARNERS DIC.',style:TextStyle(fontWeight:FontWeight.w900,color:ink)),Text('A WORLD OF WORDS',style:TextStyle(fontSize:9,letterSpacing:1.5,color:muted))]),const Spacer(),IconButton(onPressed:()=>setState(()=>tab=3),icon:const Icon(Icons.bookmark_border))]),
  const SizedBox(height:30),header('THE DICTIONARY','Find the exact\nword you need.','Search English words for definitions and usage.'),
  const SizedBox(height:22),Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:Colors.white,border:Border.all(color:line),borderRadius:BorderRadius.circular(16)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('DICTIONARY LANGUAGE',style:TextStyle(fontSize:9,color:muted,letterSpacing:1.4,fontWeight:FontWeight.w800)),DropdownButton<String>(value:language,isExpanded:true,underline:const SizedBox(),items:langs.map((s)=>DropdownMenuItem(value:s,child:Text(s))).toList(),onChanged:(v)=>setState(() { language=v!; result=null; error=null; })),const Divider(color:line),Row(children:[Expanded(child:TextField(controller:word,onSubmitted:(_)=>lookup(),textInputAction:TextInputAction.search,decoration:const InputDecoration(hintText:'Search a word…',border:InputBorder.none))),IconButton.filled(onPressed:busy?null:lookup,style:IconButton.styleFrom(backgroundColor:forest),icon:const Icon(Icons.search,color:Colors.white))])])),
  const SizedBox(height:18),if(busy)const Center(child:CircularProgressIndicator(color:forest)),if(error!=null)panel('Dictionary notice',error!),if(result!=null)entryCard(),
  if(result==null&&error==null&&!busy)panel('English dictionary connected','Search a word to retrieve definitions, pronunciation text, examples, synonyms and antonyms. Internet access is required for new lookups.'),
  const SizedBox(height:18),const Text('LANGUAGE COLLECTIONS',style:TextStyle(fontSize:9,letterSpacing:1.4,color:muted,fontWeight:FontWeight.w800)),const SizedBox(height:7),const Text('English lookup is connected. French, Spanish, Yorùbá, Igbo and Hausa are planned collections; their reviewed dictionary datasets are not yet connected.',style:TextStyle(color:muted,fontSize:12,height:1.5))
 ]);
 Widget entryCard(){
  final phonetics=(result!['phonetics'] as List? ??[]); final phonetic=result!['phonetic']?.toString()??phonetics.map((p)=>p['text']).whereType<String>().firstOrNull??'';
  final meanings=(result!['meanings'] as List? ??[]); final w=result!['word']?.toString()??word.text;
  return Container(padding:const EdgeInsets.all(18),decoration:BoxDecoration(color:Colors.white,border:Border.all(color:line),borderRadius:BorderRadius.circular(17)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
   Row(children:[Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(w,style:const TextStyle(fontSize:29,fontWeight:FontWeight.w800,color:ink)),Text(phonetic,style:const TextStyle(color:muted))])),IconButton(onPressed:()=>speak(w),icon:const Icon(Icons.volume_up,color:forest)),IconButton(onPressed:()=>toggleSave(w),icon:Icon(saved.contains(w)?Icons.bookmark:Icons.bookmark_border,color:forest))]),
   const Divider(color:line,height:24),
   ...meanings.expand((m)=>((m['definitions'] as List? ??[]).take(8)).map((d)=>Padding(padding:const EdgeInsets.only(bottom:15),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
    Text((m['partOfSpeech']??'word').toString().toUpperCase(),style:const TextStyle(color:forest,fontSize:9,letterSpacing:1.4,fontWeight:FontWeight.w800)),const SizedBox(height:5),Text(d['definition']?.toString()??'',style:const TextStyle(fontSize:14,height:1.5,color:ink)),
    if(d['example']!=null)Padding(padding:const EdgeInsets.only(top:6),child:Text('“'+d['example'].toString()+'”',style:const TextStyle(color:muted,fontStyle:FontStyle.italic))),
    if((d['synonyms'] as List? ??[]).isNotEmpty)Text('Synonyms: '+(d['synonyms'] as List).take(8).join(', '),style:const TextStyle(color:muted,fontSize:12)),
    if((d['antonyms'] as List? ??[]).isNotEmpty)Text('Antonyms: '+(d['antonyms'] as List).take(8).join(', '),style:const TextStyle(color:muted,fontSize:12))
   ])))),
   if(result!['origin']!=null)...[const Divider(color:line),const Text('WORD ORIGIN',style:TextStyle(fontSize:9,color:muted,fontWeight:FontWeight.w800)),Text(result!['origin'].toString(),style:const TextStyle(color:muted,fontSize:13))],
   const SizedBox(height:8),const Text('Source: Free Dictionary API (dictionaryapi.dev). Returned content may vary by entry.',style:TextStyle(fontSize:10,color:muted))
  ]));
 }
 Widget translator()=>ListView(padding:const EdgeInsets.all(22),children:[
  header('LANGUAGE TO LANGUAGE','Translator','Translate words, sentences and paragraphs.'),
  const SizedBox(height:22),Row(children:[Expanded(child:picker('FROM',from,(v)=>setState(()=>from=v))),IconButton(onPressed:()=>setState(() { final x=from; from=to; to=x; }),icon:const Icon(Icons.swap_horiz,color:forest,size:28)),Expanded(child:picker('TO',to,(v)=>setState(()=>to=v)))]),
  const SizedBox(height:12),Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:Colors.white,border:Border.all(color:line),borderRadius:BorderRadius.circular(15)),child:TextField(controller:input,minLines:5,maxLines:8,decoration:const InputDecoration(border:InputBorder.none,hintText:'Enter text to translate…'))),
  const SizedBox(height:12),FilledButton.icon(onPressed:translating?null:translate,style:FilledButton.styleFrom(backgroundColor:forest,padding:const EdgeInsets.all(15)),icon:translating?const SizedBox(width:16,height:16,child:CircularProgressIndicator(strokeWidth:2,color:Colors.white)):const Icon(Icons.translate),label:Text(translating?'Translating…':'Translate')),
  if(transError!=null) ...[const SizedBox(height:12),panel('Translation notice',transError!)],
  const SizedBox(height:15),Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:Colors.white,border:Border.all(color:line),borderRadius:BorderRadius.circular(15)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('TRANSLATION',style:TextStyle(fontSize:9,color:muted,letterSpacing:1.4,fontWeight:FontWeight.w800)),const SizedBox(height:8),Text(output.text.isEmpty?'Your translation will appear here.':output.text,style:const TextStyle(fontSize:15,height:1.5,color:ink)),if(output.text.isNotEmpty)Align(alignment:Alignment.centerRight,child:IconButton(onPressed:()=>speak(output.text),icon:const Icon(Icons.volume_up,color:forest)))])),
  const SizedBox(height:12),const Text('Translation service: MyMemory. Machine translation may be inaccurate, especially for less-resourced languages. Verify important text with a qualified speaker.',style:TextStyle(color:muted,fontSize:11,height:1.5))
 ]);
 Widget picker(String label,String value,ValueChanged<String> change)=>Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(label,style:const TextStyle(fontSize:9,color:muted,fontWeight:FontWeight.w800,letterSpacing:1.2)),DropdownButton<String>(value:value,isExpanded:true,underline:const SizedBox(),items:langs.map((s)=>DropdownMenuItem(value:s,child:Text(s,overflow:TextOverflow.ellipsis))).toList(),onChanged:(v){if(v!=null)change(v);})]);
 Widget learn()=>ListView(padding:const EdgeInsets.all(22),children:[
  header('STRUCTURED LANGUAGE STUDY','Learn','Practise vocabulary and foundational language concepts.'),
  const SizedBox(height:22),Row(children:[Expanded(child:Text('STARTER LESSON · '+(question+1).toString()+' OF '+qs.length.toString(),style:const TextStyle(color:forest,fontSize:10,fontWeight:FontWeight.w800,letterSpacing:1))),Text('Score: $score',style:const TextStyle(color:muted))]),
  const SizedBox(height:9),LinearProgressIndicator(value:(question+1)/qs.length,color:forest,backgroundColor:line),
  const SizedBox(height:20),Container(padding:const EdgeInsets.all(18),decoration:BoxDecoration(color:Colors.white,border:Border.all(color:line),borderRadius:BorderRadius.circular(16)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
   Text(qs[question][0] as String,style:const TextStyle(fontSize:20,fontWeight:FontWeight.w700,color:ink)),
   const SizedBox(height:16),...(qs[question][1] as List<String>).asMap().entries.map((e)=>Padding(padding:const EdgeInsets.only(bottom:9),child:OutlinedButton(onPressed:answered?null:()=>setState(() { choice=e.key; answered=true; if(e.key.toString()==qs[question][2]) score++; }),style:OutlinedButton.styleFrom(minimumSize:const Size(double.infinity,50),alignment:Alignment.centerLeft,side:BorderSide(color:answered&&e.key.toString()==qs[question][2]?forest:choice==e.key?Colors.red:line)),child:Text(e.value)))),
   if(answered)...[panel(choice.toString()==qs[question][2]?'Correct':'Review this one',qs[question][3] as String),const SizedBox(height:12),FilledButton(onPressed:()=>setState(() { question=(question+1)%qs.length; answered=false; choice=null; if(question==0) score=0; }),style:FilledButton.styleFrom(backgroundColor:forest),child:Text(question==qs.length-1?'Restart lesson':'Next question'))]
  ])),
  const SizedBox(height:15),const Text('This is a small starter practice set, not the complete multi-level curriculum. More reviewed lessons, listening, speaking, grammar and assessments remain to be developed.',style:TextStyle(color:muted,fontSize:11,height:1.5))
 ]);
 Widget savedPage()=>ListView(padding:const EdgeInsets.all(22),children:[
  header('YOUR WORD COLLECTION','Saved words','Your saved English vocabulary stays on this device.'),
  const SizedBox(height:20),if(saved.isEmpty)panel('No saved words yet','Search an English word and tap its bookmark icon to add it to this collection.'),
  ...saved.map((s)=>Container(margin:const EdgeInsets.only(bottom:9),padding:const EdgeInsets.symmetric(horizontal:14,vertical:4),decoration:BoxDecoration(color:Colors.white,border:Border.all(color:line),borderRadius:BorderRadius.circular(13)),child:Row(children:[Expanded(child:Text(s,style:const TextStyle(color:ink,fontWeight:FontWeight.w700))),IconButton(onPressed:(){word.text=s;setState(()=>tab=0);lookup();},icon:const Icon(Icons.search,color:forest)),IconButton(onPressed:()=>toggleSave(s),icon:const Icon(Icons.bookmark_remove_outlined,color:muted))])))
 ]);
}
