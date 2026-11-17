import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/services.dart';

void main() => runApp(const LearnersDic());
const ink=Color(0xFF17231E), forest=Color(0xFF315B48), paper=Color(0xFFF5F3EC), muted=Color(0xFF78827B), line=Color(0xFFE5E5DC);
const langs=['English','French','Spanish','Yorùbá','Igbo','Hausa'];
const codes={'English':'en','French':'fr','Spanish':'es','Yorùbá':'yo','Igbo':'ig','Hausa':'ha'};
// Small, carefully scoped offline reference set. Wider on-demand entries are
// fetched from Wiktionary (CC BY-SA) and cached on device for later offline use.
const offlineWords=<String,Map<String,List<String>>>{
 'English':{'hello':['hello','interjection','A greeting used when meeting someone.','Hello, how are you?'],'water':['water','noun','A clear liquid essential for life.','Please bring me some water.'],'book':['book','noun','A set of written or printed pages.','I am reading a book.'],'family':['family','noun','People related to one another.','My family is important to me.'],'friend':['friend','noun','A person one knows and likes.','She is my friend.'],'learn':['learn','verb','To gain knowledge or a skill.','I learn something every day.'],'go':['go','verb','To move or travel from one place to another.','We go home.'],'children':['child','noun','A young person; plural of child.','The children are reading.']},
 'French':{'bonjour':['bonjour','interjection','Hello; a polite daytime greeting.','Bonjour, comment allez-vous ?'],'merci':['merci','interjection','Thank you.','Merci pour votre aide.'],'eau':['eau','noun','Water.','Je voudrais de l’eau.'],'livre':['livre','noun','Book.','Je lis un livre.'],'maison':['maison','noun','House or home.','Je suis à la maison.']},
 'Spanish':{'hola':['hola','interjection','Hello.','Hola, ¿cómo estás?'],'gracias':['gracias','interjection','Thank you.','Gracias por tu ayuda.'],'agua':['agua','noun','Water.','Quiero agua, por favor.'],'libro':['libro','noun','Book.','Estoy leyendo un libro.'],'casa':['casa','noun','House or home.','Estoy en casa.']},
 'Yorùbá':{'ẹ káàárọ̀':['ẹ káàárọ̀','greeting','Good morning (respectful greeting).','Ẹ káàárọ̀, báwo ni?'],'ẹ ṣé':['ẹ ṣé','expression','Thank you (respectful or plural).','Ẹ ṣé gan-an.'],'omi':['omi','noun','Water.','Mo fẹ́ omi.'],'ìwé':['ìwé','noun','Book.','Mo ń ka ìwé.'],'ilé':['ilé','noun','House or home.','Mo wà ní ilé.']},
 'Igbo':{'ndewo':['ndewo','greeting','Hello.','Ndewo, kedu?'],'daalụ':['daalụ','expression','Thank you.','Daalụ nke ukwuu.'],'mmiri':['mmiri','noun','Water.','Achọrọ m mmiri.'],'akwụkwọ':['akwụkwọ','noun','Book; also writing or paper by context.','Ana m agụ akwụkwọ.'],'ụlọ':['ụlọ','noun','House or home.','Anọ m n’ụlọ.']},
 'Hausa':{'sannu':['sannu','greeting','Hello; a greeting.','Sannu, ya kake?'],'na gode':['na gode','expression','Thank you.','Na gode sosai.'],'ruwa':['ruwa','noun','Water.','Ina son ruwa.'],'littafi':['littafi','noun','Book.','Ina karanta littafi.'],'gida':['gida','noun','House or home.','Ina gida.']},
};
const wiktionaryLanguage={'English':'English','French':'French','Spanish':'Spanish','Yorùbá':'Yoruba','Igbo':'Igbo','Hausa':'Hausa'};
class DictionaryGateway { static http.Client client=http.Client(); }
const lessonTopics=['Greetings and first contact','Courtesy and thanks','Introducing yourself','Making a simple request','People and family','Finding a place','Cumulative review'];
const lessonPhrases=<String,List<String>>{
 'English':['Hello.','Thank you.','My name is Ada.','I would like water, please.','This is my family.','Where is the house?','I am learning a new language.'],
 'French':['Bonjour.','Merci beaucoup.','Je m’appelle Ada.','Je voudrais de l’eau, s’il vous plaît.','Voici ma famille.','Où est la maison ?','J’apprends une nouvelle langue.'],
 'Spanish':['Hola.','Muchas gracias.','Me llamo Ada.','Quisiera agua, por favor.','Esta es mi familia.','¿Dónde está la casa?','Estoy aprendiendo un idioma nuevo.'],
 'Yorùbá':['Ẹ káàárọ̀.','Ẹ ṣé gan-an.','Orúkọ mi ni Ada.','Mo fẹ́ omi, jọ̀wọ́.','Èyí ni ẹbí mi.','Ilé náà wà níbo?','Mo ń kọ́ èdè tuntun.'],
 'Igbo':['Ndewo.','Daalụ nke ukwuu.','Aha m bụ Ada.','Achọrọ m mmiri, biko.','Nke a bụ ezinụlọ m.','Ụlọ ahụ dị ebee?','Ana m amụta asụsụ ọhụrụ.'],
 'Hausa':['Sannu.','Na gode sosai.','Sunana Ada.','Ina son ruwa, don Allah.','Wannan iyalina ne.','Ina gidan yake?','Ina koyon sabon harshe.'],
};
const lessonNotes=['Listen for the greeting used in the time of day and the level of formality. Repeat the whole phrase aloud.','Notice the polite expression and where it sits in a sentence. Courtesy forms can change with audience and region.','Learn the fixed pattern as a chunk. Replace the name only after you can say the model smoothly.','Compare the request frame with the word for water in the dictionary. Repeat once slowly, then at a natural pace.','Read the phrase aloud. Pay attention to possessive forms; they do not always map word-for-word from English.','Notice the question word and its position. Practise asking about another familiar place.','Recall the prior six phrases without looking. Then say one short sentence about what you are learning.'];

class LearnersDic extends StatelessWidget {
 const LearnersDic({super.key});
 @override Widget build(BuildContext context)=>MaterialApp(title:'LEARNERS DIC.',debugShowCheckedModeBanner:false,theme:ThemeData(useMaterial3:true,scaffoldBackgroundColor:paper,colorScheme:ColorScheme.fromSeed(seedColor:forest)),home:const Welcome());
}
class Welcome extends StatefulWidget { const Welcome({super.key}); @override State<Welcome> createState()=>_WelcomeState(); }
class _WelcomeState extends State<Welcome> {
 Future<void> enter() async { final p=await SharedPreferences.getInstance(); await p.setBool('onboarding_complete',true); if(mounted) Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(_)=>const Home())); }
 @override Widget build(BuildContext context)=>Scaffold(body:SafeArea(child:Padding(padding:const EdgeInsets.fromLTRB(26,30,26,24),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
  Row(children:[Container(width:44,height:44,alignment:Alignment.center,decoration:BoxDecoration(color:forest,borderRadius:BorderRadius.circular(14)),child:const Text('LD',style:TextStyle(color:Colors.white,fontWeight:FontWeight.w900))),const SizedBox(width:11),const Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('LEARNERS DIC.',style:TextStyle(fontWeight:FontWeight.w900,color:ink,letterSpacing:.4)),Text('A WORLD OF WORDS',style:TextStyle(fontSize:9,letterSpacing:1.7,color:muted))])]),
  const Spacer(),const Text('A FIELD GUIDE TO LANGUAGE',style:TextStyle(color:forest,fontSize:10,fontWeight:FontWeight.w800,letterSpacing:2)),const SizedBox(height:14),const Text('Words open\nworlds.',style:TextStyle(fontFamily:'Georgia',fontSize:48,height:1.06,fontWeight:FontWeight.w700,color:ink,letterSpacing:-1.4)),const SizedBox(height:16),const Text('A quiet place to look up words, study language with purpose and build a practice that lasts.',style:TextStyle(color:muted,fontSize:16,height:1.55)),
  const SizedBox(height:28),Container(width:double.infinity,padding:const EdgeInsets.all(18),decoration:BoxDecoration(color:const Color(0xFFECEFE8),borderRadius:BorderRadius.circular(16)),child:const Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('YOUR DESK FOR WORDS',style:TextStyle(fontSize:10,color:forest,fontWeight:FontWeight.w800,letterSpacing:1.3)),SizedBox(height:10),Text('Dictionary · Translator · Structured lessons · Saved words',style:TextStyle(color:ink,fontSize:14,height:1.5))])),const Spacer(),SizedBox(width:double.infinity,height:54,child:FilledButton(onPressed:enter,style:FilledButton.styleFrom(backgroundColor:forest,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(14))),child:const Text('Enter the dictionary',style:TextStyle(fontWeight:FontWeight.w700)))),const SizedBox(height:10),const Center(child:Text('Made for steady learners. Free to learn, always.',style:TextStyle(color:muted,fontSize:11)))
 ]))));
}
class Home extends StatefulWidget { const Home({super.key}); @override State<Home> createState()=>_HomeState(); }
class _HomeState extends State<Home> {
 int tab=0; final word=TextEditingController(), input=TextEditingController(), output=TextEditingController(); final tts=FlutterTts();
 String language='English', from='English', to='French', courseLanguage='French', learnMode='Study'; int selectedLesson=0; bool busy=false, translating=false; String? error, transError; Map<String,dynamic>? result; List<String> saved=[]; List<String> history=[]; Map<String,List<int>> completed={}; int question=0, score=0; bool answered=false; int? choice;
 final qs=[
  ['What does “benevolent” mean?',['Cruel','Kind and well meaning','Wealthy'],'1','Benevolent describes someone who wishes good for others.'],
  ['Which word means fluent and persuasive in speech?',['Eloquent','Abandon','Ancient'],'0','Eloquent means fluent or persuasive in speaking or writing.'],
  ['What is a lexicon?',['A building','A language’s vocabulary','A writing tool'],'1','A lexicon is the vocabulary of a language or subject.'],
  ['Which part of speech names a person, place, thing or idea?',['Verb','Adverb','Noun'],'2','A noun names a person, place, thing or idea.'],
  ['Which word is closest in meaning to “rapid”?',['Slow','Swift','Quiet'],'1','Swift is a synonym of rapid.']
 ];
 @override void initState(){super.initState(); loadSaved();}
 Future<void> loadSaved() async {final p=await SharedPreferences.getInstance(); final raw=p.getString('lesson_progress');if(mounted)setState(() { saved=p.getStringList('saved')??[]; history=p.getStringList('translation_history')??[];if(raw!=null){final parsed=jsonDecode(raw) as Map;completed=parsed.map((k,v)=>MapEntry(k.toString(),(v as List).map((n)=>n as int).toList()));} });}
 Future<void> toggleSave(String w) async {final key='${codes[language]}::$w';final n=[...saved]; if(n.contains(key)){n.remove(key);}else{n.insert(0,key);} final p=await SharedPreferences.getInstance(); await p.setStringList('saved',n); if(mounted)setState(()=>saved=n);}
 Future<void> lookup() async {
  final q=word.text.trim(); if(q.isEmpty)return;
  setState(() { busy=true; error=null; result=null; });
  try{
   final prefs=await SharedPreferences.getInstance();
   final cacheKey='dictionary_cache_${codes[language]}_${q.toLowerCase()}';
   final cached=prefs.getString(cacheKey);
   if(cached!=null){final data=Map<String,dynamic>.from(jsonDecode(cached) as Map);if(mounted)setState(()=>result=data);return;}
   final local=offlineWords[language]?[q.toLowerCase()];
   if(local!=null){final entry={'word':local[0],'meanings':[{'partOfSpeech':local[1],'definitions':[{'definition':local[2],'example':local[3]}]}],'source':'LEARNERS DIC. offline starter entry'};await prefs.setString(cacheKey,jsonEncode(entry));if(mounted)setState(()=>result=entry);return;}
   // Wiktionary's structured multilingual definition endpoint includes English
   // glosses for words from many languages and is reusable under CC BY-SA.
   final r=await DictionaryGateway.client.get(Uri.https('en.wiktionary.org','/api/rest_v1/page/definition/$q',{'origin':'*'}),headers:{'User-Agent':'LEARNERS-DIC/1.0 (language learning app)'}).timeout(const Duration(seconds:20));
   if(r.statusCode!=200)throw Exception('No sourced entry was found for “$q” in $language. Check spelling or diacritics, or try again when online.');
   final data=jsonDecode(r.body); if(data is! Map)throw Exception('The dictionary returned an unreadable entry.');
   final target=wiktionaryLanguage[language]!.toLowerCase();
   final matched=data.entries.where((e){final key=e.key.toString().toLowerCase();if(key==target||key==codes[language])return true;if(e.value is List){return (e.value as List).any((part)=>part is Map&&((part['language'] is Map&&((part['language']['name']?.toString().toLowerCase()==target)||(part['language']['code']?.toString().toLowerCase()==codes[language])))||part['language']?.toString().toLowerCase()==target));}return false;}).firstOrNull;
   if(matched==null||matched.value is! List)throw Exception('Wiktionary has no $language entry for “$q”. No definition was inferred.');
   final entries=matched.value as List;
   final senses=<Map<String,dynamic>>[];
   for(final part in entries){if(part is! Map)continue;final pos=part['partOfSpeech']?.toString()??'word';final defs=part['definitions'];if(defs is! List)continue;for(final d in defs){if(d is! Map)continue;final meaning=_plain(d['definition']?.toString()??'');if(meaning.isEmpty)continue;final examples=d['parsedExamples']??d['examples'];final example=examples is List&&examples.isNotEmpty?_plain(examples.first.toString()):_plain(examples?.toString()??'');senses.add({'partOfSpeech':pos,'definition':meaning,'example':example,'synonyms':d['synonyms']??part['synonyms']??[],'antonyms':d['antonyms']??part['antonyms']??[]});}}
   if(senses.isEmpty)throw Exception('Wiktionary has no readable definition for “$q” in $language.');
   final grouped=<String,List<Map<String,dynamic>>>{};for(final sense in senses){final pos=sense['partOfSpeech']?.toString()??'word';grouped.putIfAbsent(pos,()=>[]).add({'definition':sense['definition'],'example':sense['example'],'synonyms':sense['synonyms'],'antonyms':sense['antonyms']});}
   final entry={'word':q,'phonetic':entries.whereType<Map>().map((e)=>e['pronunciation']??e['ipa']??'').firstWhere((v)=>v.toString().isNotEmpty,orElse:()=>''),'meanings':grouped.entries.map((e)=>{'partOfSpeech':e.key,'definitions':e.value}).toList(),'origin':entries.whereType<Map>().map((e)=>e['etymology']??'').firstWhere((v)=>v.toString().isNotEmpty,orElse:()=>null),'source':'English Wiktionary contributors · CC BY-SA 4.0','sourceUrl':'https://en.wiktionary.org/wiki/${Uri.encodeComponent(q)}'};
   await prefs.setString(cacheKey,jsonEncode(entry));if(mounted)setState(()=>result=entry);
  }catch(e){
    final prefs=await SharedPreferences.getInstance();
    final cached=prefs.getString('dictionary_cache_${codes[language]}_${q.toLowerCase()}');
    if(cached!=null){
      if(mounted)setState(() { result=Map<String,dynamic>.from(jsonDecode(cached) as Map); error='Showing your saved result. Connect to the internet to check for updates.'; });
      return;
    }
    final detail=e.toString().toLowerCase();
    final message=detail.contains('socket')||detail.contains('failed host lookup')||detail.contains('name not known')
      ? 'We could not connect to the dictionary server. Your phone may have mobile data, but the network or DNS could not reach the service. Check your connection and try again.'
      : detail.contains('timeout')
        ? 'The dictionary server took too long to respond. Please try again.'
      : e.toString().replaceFirst('Exception: ','');
    if(mounted)setState(()=>error=message);
  }
  finally{if(mounted)setState(()=>busy=false);}
 }
 String _plain(String value)=>value.replaceAll(RegExp(r'<[^>]*>'), '').replaceAll(RegExp(r'\[\[[^]|]*\|?'), '').replaceAll(']]','').replaceAll('&quot;','"').replaceAll('&#39;',"'").replaceAll('&amp;','&').replaceAll('&lt;','<').replaceAll('&gt;','>').trim();
 Future<void> translate() async {
  final q=input.text.trim(); if(q.isEmpty)return;
  setState(() { translating=true; transError=null; output.clear(); });
  try{
   final uri=Uri.https('api.mymemory.translated.net','/get',{'q':q,'langpair':codes[from]!+'|'+codes[to]!});
   final r=await http.get(uri).timeout(const Duration(seconds:25)); if(r.statusCode!=200)throw Exception('Translation service unavailable.');
   final d=jsonDecode(r.body) as Map; final v=(d['responseData'] as Map?)?['translatedText']?.toString();
   if(d['responseStatus']!=200||v==null||v.isEmpty)throw Exception(d['responseDetails']??'No translation returned.');
   output.text=v; history.insert(0,from+' → '+to+'\n'+q+'\n'+v); if(history.length>20)history=history.take(20).toList(); final prefs=await SharedPreferences.getInstance(); await prefs.setStringList('translation_history',history); if(mounted)setState(() {});
  }catch(e){setState(()=>transError=e.toString().replaceFirst('Exception: ',''));}
  finally{if(mounted)setState(()=>translating=false);}
 }
 Future<void> speak(String s,[String locale='en-US']) async {await tts.setLanguage(locale);await tts.setSpeechRate(.45);await tts.speak(s);}
 @override void dispose(){word.dispose();input.dispose();output.dispose();tts.stop();super.dispose();}
 @override Widget build(BuildContext context)=>Scaffold(body:SafeArea(child:IndexedStack(index:tab,children:[dictionary(),translator(),learn(),savedPage()])),bottomNavigationBar:NavigationBar(selectedIndex:tab,onDestinationSelected:(v)=>setState(()=>tab=v),backgroundColor:const Color(0xFFFCFBF7),indicatorColor:const Color(0xFFE2EAE3),destinations:const [NavigationDestination(icon:Icon(Icons.menu_book_outlined),label:'Dictionary'),NavigationDestination(icon:Icon(Icons.translate),label:'Translate'),NavigationDestination(icon:Icon(Icons.school_outlined),label:'Learn'),NavigationDestination(icon:Icon(Icons.bookmark_border),label:'Saved')]));
 Widget header(String eyebrow,String title,String desc)=>Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(eyebrow,style:const TextStyle(color:forest,fontSize:10,fontWeight:FontWeight.w800,letterSpacing:2)),const SizedBox(height:7),Text(title,style:const TextStyle(fontSize:27,height:1.12,fontWeight:FontWeight.w700,color:ink,letterSpacing:-.5)),const SizedBox(height:5),Text(desc,style:const TextStyle(color:muted,fontSize:13,height:1.45))]);
 Widget panel(String title,String body)=>Container(width:double.infinity,padding:const EdgeInsets.all(17),decoration:BoxDecoration(color:const Color(0xFFECEFE8),borderRadius:BorderRadius.circular(16)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:const TextStyle(fontWeight:FontWeight.w700,color:ink)),const SizedBox(height:6),Text(body,style:const TextStyle(color:muted,fontSize:13,height:1.5))]));
 Widget dictionary()=>ListView(padding:const EdgeInsets.all(22),children:[
  Row(children:[Container(width:38,height:38,alignment:Alignment.center,decoration:BoxDecoration(color:forest,borderRadius:BorderRadius.circular(12)),child:const Text('LD',style:TextStyle(color:Colors.white,fontWeight:FontWeight.w900))),const SizedBox(width:10),const Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('LEARNERS DIC.',style:TextStyle(fontWeight:FontWeight.w900,color:ink)),Text('A WORLD OF WORDS',style:TextStyle(fontSize:9,letterSpacing:1.5,color:muted))]),const Spacer(),IconButton(onPressed:()=>setState(()=>tab=3),icon:const Icon(Icons.bookmark_border))]),
  const SizedBox(height:27),header('SIX LANGUAGES · WORD DESK','Look up a word','Definitions, examples and pronunciation where available.'),
  const SizedBox(height:22),Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:Colors.white,border:Border.all(color:line),borderRadius:BorderRadius.circular(16)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('DICTIONARY LANGUAGE',style:TextStyle(fontSize:9,color:muted,letterSpacing:1.4,fontWeight:FontWeight.w800)),DropdownButton<String>(value:language,isExpanded:true,underline:const SizedBox(),items:langs.map((s)=>DropdownMenuItem(value:s,child:Text(s))).toList(),onChanged:(v)=>setState(() { language=v!; result=null; error=null; })),const Divider(color:line),Row(children:[Expanded(child:TextField(controller:word,onSubmitted:(_)=>lookup(),textInputAction:TextInputAction.search,decoration:const InputDecoration(hintText:'Search a word…',border:InputBorder.none))),IconButton.filled(onPressed:busy?null:lookup,style:IconButton.styleFrom(backgroundColor:forest),icon:const Icon(Icons.search,color:Colors.white))])])),
  const SizedBox(height:18),if(busy)const Center(child:CircularProgressIndicator(color:forest)),if(error!=null)...[panel('Dictionary connection',error!),if(error!.contains('could not connect')||error!.contains('too long to respond'))Align(alignment:Alignment.centerLeft,child:TextButton.icon(onPressed:busy?null:lookup,icon:const Icon(Icons.refresh),label:const Text('Try again')))],if(result!=null)entryCard(),
  if(result==null&&error==null&&!busy)Padding(padding:const EdgeInsets.only(top:24),child:Text('Search ${language} or begin with hello, water, book, family or learn.',style:TextStyle(color:muted,fontSize:13))),
  const SizedBox(height:18),Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:const Color(0xFFECEFE8),borderRadius:BorderRadius.circular(12)),child:const Text('Wiktionary entries are community contributed and licensed CC BY-SA 4.0. Search requires internet; entries you open are saved on this device for offline review. Coverage, dialect information and entry quality vary, especially for less-documented languages. No result is invented when a sourced entry is unavailable.',style:TextStyle(color:muted,fontSize:11,height:1.5)))
 ]);
 Widget entryCard(){
  final phonetics=(result!['phonetics'] as List? ??[]); final phonetic=result!['phonetic']?.toString()??phonetics.map((p)=>p['text']).whereType<String>().firstOrNull??'';
  final meanings=(result!['meanings'] as List? ??[]); final w=result!['word']?.toString()??word.text;
  return Container(padding:const EdgeInsets.fromLTRB(2,20,2,8),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
   Row(children:[Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(w,style:const TextStyle(fontSize:34,fontWeight:FontWeight.w700,color:ink,letterSpacing:-.8,fontFamily:'Georgia')),Text(phonetic,style:const TextStyle(color:muted))])),IconButton(tooltip:'Hear this word',onPressed:()=>speak(w),icon:const Icon(Icons.volume_up,color:forest)),IconButton(tooltip:'Save word',onPressed:()=>toggleSave(w),icon:Icon(saved.contains('${codes[language]}::$w')||saved.contains(w)?Icons.bookmark:Icons.bookmark_border,color:forest))]),
   const Divider(color:line,height:24),
   ...meanings.expand((m)=>((m['definitions'] as List? ??[]).take(8)).map((d)=>Padding(padding:const EdgeInsets.only(bottom:15),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
    Text((m['partOfSpeech']??'word').toString().toUpperCase(),style:const TextStyle(color:forest,fontSize:9,letterSpacing:1.4,fontWeight:FontWeight.w800)),const SizedBox(height:5),Text(d['definition']?.toString()??'',style:const TextStyle(fontSize:14,height:1.5,color:ink)),
    if(d['example']!=null)Padding(padding:const EdgeInsets.only(top:6),child:Text('“'+d['example'].toString()+'”',style:const TextStyle(color:muted,fontStyle:FontStyle.italic))),
    if((d['synonyms'] is List ? d['synonyms'] as List : const []).isNotEmpty)Text('Synonyms: ${(d['synonyms'] as List).take(8).join(', ')}',style:const TextStyle(color:muted,fontSize:12)),
    if((d['antonyms'] is List ? d['antonyms'] as List : const []).isNotEmpty)Text('Antonyms: ${(d['antonyms'] as List).take(8).join(', ')}',style:const TextStyle(color:muted,fontSize:12))
   ])))),
   if(result!['origin']!=null)...[const Divider(color:line),const Text('WORD ORIGIN',style:TextStyle(fontSize:9,color:muted,fontWeight:FontWeight.w800)),Text(result!['origin'].toString(),style:const TextStyle(color:muted,fontSize:13))],
   const SizedBox(height:8),Text('Source: ${result!['source']??'English Wiktionary · CC BY-SA 4.0'}. Some entries include community examples and semantic links.',style:const TextStyle(fontSize:10,color:muted)),if(result!['sourceUrl']!=null)SelectableText(result!['sourceUrl'].toString(),style:const TextStyle(fontSize:9,color:forest))
  ]));
 }
 Widget translator()=>ListView(padding:const EdgeInsets.all(22),children:[
  header('LANGUAGE TO LANGUAGE','Translator','Translate words, sentences and paragraphs.'),
  const SizedBox(height:22),Row(children:[Expanded(child:picker('FROM',from,(v)=>setState(()=>from=v))),IconButton(onPressed:()=>setState(() { final x=from; from=to; to=x; }),icon:const Icon(Icons.swap_horiz,color:forest,size:28)),Expanded(child:picker('TO',to,(v)=>setState(()=>to=v)))]),
  const SizedBox(height:12),Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:Colors.white,border:Border.all(color:line),borderRadius:BorderRadius.circular(15)),child:TextField(controller:input,minLines:5,maxLines:8,decoration:const InputDecoration(border:InputBorder.none,hintText:'Enter text to translate…'))),
  const SizedBox(height:12),FilledButton.icon(onPressed:translating?null:translate,style:FilledButton.styleFrom(backgroundColor:forest,padding:const EdgeInsets.all(15)),icon:translating?const SizedBox(width:16,height:16,child:CircularProgressIndicator(strokeWidth:2,color:Colors.white)):const Icon(Icons.translate),label:Text(translating?'Translating…':'Translate')),
  if(transError!=null) ...[const SizedBox(height:12),panel('Translation notice',transError!)],
  const SizedBox(height:15),Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:Colors.white,border:Border.all(color:line),borderRadius:BorderRadius.circular(15)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('TRANSLATION',style:TextStyle(fontSize:9,color:muted,letterSpacing:1.4,fontWeight:FontWeight.w800)),const SizedBox(height:8),Text(output.text.isEmpty?'Your translation will appear here.':output.text,style:const TextStyle(fontSize:15,height:1.5,color:ink)),if(output.text.isNotEmpty)Row(mainAxisAlignment:MainAxisAlignment.end,children:[IconButton(tooltip:'Copy translation',onPressed:()=>Clipboard.setData(ClipboardData(text:output.text)),icon:const Icon(Icons.copy,color:forest)),IconButton(tooltip:'Listen to translation',onPressed:()=>speak(output.text,codes[to]!+'-'+(to=='English'?'US':to=='French'?'FR':to=='Spanish'?'ES':to=='Yorùbá'?'NG':to=='Igbo'?'NG':'NG')),icon:const Icon(Icons.volume_up,color:forest))])])),
  const SizedBox(height:18),if(history.isNotEmpty)...[Row(children:[const Expanded(child:Text('RECENT TRANSLATIONS',style:TextStyle(fontSize:10,letterSpacing:1.3,color:muted,fontWeight:FontWeight.w800))),TextButton(onPressed:()async{final p=await SharedPreferences.getInstance();await p.remove('translation_history');setState(()=>history=[]);},child:const Text('Clear'))]),...history.take(5).map((h)=>Container(margin:const EdgeInsets.only(bottom:8),padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:Colors.white,border:Border.all(color:line),borderRadius:BorderRadius.circular(12)),child:Row(children:[Expanded(child:Text(h, maxLines:3,overflow:TextOverflow.ellipsis,style:const TextStyle(fontSize:12,color:ink,height:1.4))),IconButton(onPressed:()=>Clipboard.setData(ClipboardData(text:h.split('\n').skip(1).join('\n'))),icon:const Icon(Icons.copy,color:forest,size:18))])))],const SizedBox(height:12),const Text('Translation service: MyMemory. Machine translation may be inaccurate, especially for less-resourced languages. Verify important text with a qualified speaker.',style:TextStyle(color:muted,fontSize:11,height:1.5))
 ]);
 Widget picker(String label,String value,ValueChanged<String> change)=>Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(label,style:const TextStyle(fontSize:9,color:muted,fontWeight:FontWeight.w800,letterSpacing:1.2)),DropdownButton<String>(value:value,isExpanded:true,underline:const SizedBox(),items:langs.map((s)=>DropdownMenuItem(value:s,child:Text(s,overflow:TextOverflow.ellipsis))).toList(),onChanged:(v){if(v!=null)change(v);})]);
 Widget learn()=>ListView(padding:const EdgeInsets.all(22),children:[
  header('THE DAILY PRACTICE','Learn with intention','A seven lesson foundation: study, practise recall and revisit saved words.'),
  const SizedBox(height:14),picker('I WANT TO LEARN',courseLanguage,(v)=>setState((){courseLanguage=v;selectedLesson=0;question=0;answered=false;choice=null;})),
  const SizedBox(height:8),Row(children:[Expanded(child:Text('${completed[courseLanguage]?.length??0} of 7 lessons complete',style:const TextStyle(fontSize:12,color:muted))),TextButton(onPressed:()=>setState(()=>tab=0),child:const Text('Open dictionary'))]),
  LinearProgressIndicator(value:(completed[courseLanguage]?.length??0)/7,color:forest,backgroundColor:line),const SizedBox(height:14),
  SegmentedButton<String>(segments:const [ButtonSegment(value:'Study',label:Text('Study')),ButtonSegment(value:'Practice',label:Text('Practice')),ButtonSegment(value:'Review',label:Text('Review'))],selected:{learnMode},onSelectionChanged:(v)=>setState(()=>learnMode=v.first)),
  const SizedBox(height:15),if(learnMode=='Study')...[
   Text('LESSON ${selectedLesson+1} · ${lessonTopics[selectedLesson].toUpperCase()}',style:const TextStyle(fontSize:10,color:forest,fontWeight:FontWeight.w800,letterSpacing:1.2)),const SizedBox(height:9),
   Container(padding:const EdgeInsets.all(18),decoration:BoxDecoration(color:Colors.white,border:Border.all(color:line),borderRadius:BorderRadius.circular(16)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(lessonTopics[selectedLesson],style:const TextStyle(fontSize:21,fontWeight:FontWeight.w700,color:ink)),const SizedBox(height:12),Text(lessonNotes[selectedLesson],style:const TextStyle(color:muted,fontSize:13,height:1.55)),const SizedBox(height:14),Container(width:double.infinity,padding:const EdgeInsets.all(15),decoration:BoxDecoration(color:const Color(0xFFECEFE8),borderRadius:BorderRadius.circular(12)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(courseLanguage.toUpperCase(),style:const TextStyle(fontSize:9,color:forest,fontWeight:FontWeight.w800,letterSpacing:1.3)),const SizedBox(height:5),Text(lessonPhrases[courseLanguage]![selectedLesson],style:const TextStyle(fontSize:18,color:ink,fontWeight:FontWeight.w600)),Align(alignment:Alignment.centerRight,child:IconButton(tooltip:'Hear this phrase',onPressed:()=>speak(lessonPhrases[courseLanguage]![selectedLesson],codes[courseLanguage]!+'-'+(courseLanguage=='English'?'US':courseLanguage=='French'?'FR':courseLanguage=='Spanish'?'ES':'NG')),icon:const Icon(Icons.volume_up,color:forest)))])),const SizedBox(height:12),Text('Say it three times. Then write the phrase from memory and check it against this model.',style:const TextStyle(color:ink,fontSize:12,height:1.45))])),
   const SizedBox(height:12),Wrap(spacing:7,runSpacing:7,children:List.generate(7,(i)=>ChoiceChip(label:Text('Day ${i+1}'),selected:selectedLesson==i,onSelected:(_)=>setState(()=>selectedLesson=i)))),const SizedBox(height:12),
   FilledButton.icon(onPressed:()async{final done=[...(completed[courseLanguage]??[])];if(!done.contains(selectedLesson))done.add(selectedLesson);final next={...completed,courseLanguage:done};final p=await SharedPreferences.getInstance();await p.setString('lesson_progress',jsonEncode(next));if(mounted)setState(()=>completed=next);},style:FilledButton.styleFrom(backgroundColor:forest),icon:Icon((completed[courseLanguage]??[]).contains(selectedLesson)?Icons.check_circle:Icons.task_alt),label:Text((completed[courseLanguage]??[]).contains(selectedLesson)?'Lesson complete':'Mark lesson complete')),
  ] else if(learnMode=='Practice')...[
   Row(children:[Expanded(child:Text('RECALL · ${question+1} OF ${qs.length}',style:const TextStyle(color:forest,fontSize:10,fontWeight:FontWeight.w800,letterSpacing:1))),Text('Score: $score',style:const TextStyle(color:muted))]),const SizedBox(height:8),LinearProgressIndicator(value:(question+1)/qs.length,color:forest,backgroundColor:line),const SizedBox(height:16),
   Container(padding:const EdgeInsets.all(18),decoration:BoxDecoration(color:Colors.white,border:Border.all(color:line),borderRadius:BorderRadius.circular(16)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(qs[question][0] as String,style:const TextStyle(fontSize:19,fontWeight:FontWeight.w700,color:ink)),const SizedBox(height:16),...(qs[question][1] as List<String>).asMap().entries.map((e)=>Padding(padding:const EdgeInsets.only(bottom:8),child:OutlinedButton(onPressed:answered?null:(){setState((){choice=e.key;answered=true;if(e.key.toString()==qs[question][2])score++;});},style:OutlinedButton.styleFrom(minimumSize:const Size(double.infinity,48),alignment:Alignment.centerLeft,side:BorderSide(color:answered&&e.key.toString()==qs[question][2]?forest:choice==e.key?Colors.red:line)),child:Text(e.value)))),if(answered)...[panel(choice.toString()==qs[question][2]?'Correct':'Review this one',qs[question][3] as String),const SizedBox(height:10),FilledButton(onPressed:(){setState((){question=(question+1)%qs.length;answered=false;choice=null;if(question==0)score=0;});},style:FilledButton.styleFrom(backgroundColor:forest),child:Text(question==qs.length-1?'Restart practice':'Next question'))]])),
  ] else ...[
   header('SPACED REVIEW','Return to your words','Saved entries are kept on this device. Open one to practise it again.'),const SizedBox(height:12),if(saved.isEmpty)panel('Nothing saved yet','Look up words and save them from an entry to build your own review list.'),...saved.map((item){final p=item.split('::');return ListTile(title:Text(p.last),subtitle:Text(codes.entries.where((e)=>e.value==(p.length>1?p.first:'en')).map((e)=>e.key).firstOrNull??'English'),leading:const Icon(Icons.bookmark,color:forest),onTap:(){final code=p.length>1?p.first:'en';language=codes.entries.where((e)=>e.value==code).map((e)=>e.key).firstOrNull??'English';word.text=p.last;setState(()=>tab=0);lookup();});})
  ],
  const SizedBox(height:15),const Text('This is an introductory seven lesson course, not an 80 day or fluency claim. Hausa, Yorùbá and Igbo examples and voice playback vary by region and device; confirm important usage with a qualified speaker.',style:TextStyle(color:muted,fontSize:11,height:1.5))
 ]);
 Widget savedPage()=>ListView(padding:const EdgeInsets.all(22),children:[
  header('YOUR WORD COLLECTION','Saved words','Your saved entries stay on this device.'),
  const SizedBox(height:20),if(saved.isEmpty)panel('No saved words yet','Search an English word and tap its bookmark icon to add it to this collection.'),
  ...saved.map((s){final parts=s.split('::');final code=parts.length>1?parts.first:'en';final w=parts.length>1?parts.last:s;final entryLanguage=codes.entries.where((e)=>e.value==code).map((e)=>e.key).firstOrNull??'English';return Container(margin:const EdgeInsets.only(bottom:9),padding:const EdgeInsets.symmetric(horizontal:14,vertical:4),decoration:BoxDecoration(color:Colors.white,border:Border.all(color:line),borderRadius:BorderRadius.circular(13)),child:Row(children:[Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(w,style:const TextStyle(color:ink,fontWeight:FontWeight.w700)),Text(entryLanguage,style:const TextStyle(color:muted,fontSize:11))])),IconButton(onPressed:(){language=entryLanguage;word.text=w;setState(()=>tab=0);lookup();},icon:const Icon(Icons.search,color:forest)),IconButton(onPressed:()=>toggleSave(w),icon:const Icon(Icons.bookmark_remove_outlined,color:muted))]));})
 ]);
}

