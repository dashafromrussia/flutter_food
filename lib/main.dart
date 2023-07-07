import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocation_flutter/models/models.dart';
import 'package:untitled/bloc/basket_bloc.dart';
import 'package:untitled/bloc/changeText_bloc.dart';
import 'package:untitled/bloc/data_bloc.dart';
import 'package:untitled/bloc/geloc_bloc.dart';
import 'package:untitled/bloc/menu_bloc.dart';
import 'package:untitled/bloc/person_bloc.dart';
import 'package:untitled/bloc/sendEmail_bloc.dart';
import 'package:untitled/bloc/tab_bloc.dart';
import 'package:untitled/data.dart';
import 'dart:async';
import 'package:geolocation_flutter/geolocation_flutter..dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_geolocation_service/flutter_geolocation_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:untitled/screens/basket_screen.dart';
import 'package:untitled/screens/dishes.dart';
import 'package:untitled/screens/person_screen.dart';

void main() {
  runApp(const MyApp());
}




class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MultiBlocProvider(
        providers: [
          /*BlocProvider<SendBloc>(
              create: (context) =>SendBloc()),*/
          BlocProvider<BasketBloc>(
              create: (context) =>BasketBloc()),
          BlocProvider<ArticlesBloc>(
              create: (context) =>ArticlesBloc()),
          BlocProvider<GelocationBloc>(
              create: (context) =>GelocationBloc()),
        ],
        child: const BottomNavigationBarExampleApp(),
      ),
    );
  }
}

class GeoLoc extends StatelessWidget {
  const GeoLoc({super.key});

  @override
  Widget build(BuildContext context) {
    final geobloc = context.watch<GelocationBloc>();
    return Column(
  //    mainAxisAlignment: MainAxisAlignment.start,
      children: [
    Row(children: [
    IconButton(onPressed:(){
    }, icon:const Icon(Icons.location_on_outlined,size: 30,),),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      geobloc.state is GetLocation? Text("${(geobloc.state as GetLocation).city}",style:const TextStyle(fontSize: 18),):const Text(''),
      const Text('13-06-2023',style: TextStyle(fontSize: 18),)
    ],),
    const  Expanded(child:SizedBox()),
     const CircleAvatar(
        radius: 25,
        backgroundImage:  NetworkImage("https://media.istockphoto.com/id/1337144146/ru/%D0%B2%D0%B5%D0%BA%D1%82%D0%BE%D1%80%D0%BD%D0%B0%D1%8F/%D0%B2%D0%B5%D0%BA%D1%82%D0%BE%D1%80-%D0%B7%D0%BD%D0%B0%D1%87%D0%BA%D0%B0-%D0%BF%D1%80%D0%BE%D1%84%D0%B8%D0%BB%D1%8F-%D0%B0%D0%B2%D0%B0%D1%82%D0%B0%D1%80%D0%B0-%D0%BF%D0%BE-%D1%83%D0%BC%D0%BE%D0%BB%D1%87%D0%B0%D0%BD%D0%B8%D1%8E.jpg?s=612x612&w=0&k=20&c=fHyhvKma_mzzlFxVsuAoB7juqZOWt-ZUO56PRvkAO_c="),
      ),
      const SizedBox(width: 20,)
    ],),
      //Text('13-06-2023',style: TextStyle(fontSize: 16),)
    ],);
  }
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
bool menu = false;

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<ArticlesBloc>();

    return
      Center(
        child:bloc.state is ArticlesFinishData? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
         //  const GeoLoc(),
   Expanded(child:
        ListView.builder(
        padding: const EdgeInsets.all(8),
          itemCount: (bloc.state as ArticlesFinishData).article.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: (){
                bloc.add(const ShowMenuArticlesEvent());
               /* Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BottomNavigationBarMenu()),
                );*/
              },
              child: Stack(children: [
                Container(
                  padding:const EdgeInsets.all(100),
                  margin: const EdgeInsets.all(10),
                  //   child: Text("${(bloc.state as ArticlesFinishData).article[index]['name']}"),
                  decoration: BoxDecoration(
                   // color: Colors.brown,
                    image:  DecorationImage(
                      image: NetworkImage("${(bloc.state as ArticlesFinishData).article[index]['image_url']}"),
                      fit: BoxFit.cover,
                    ),
                    /*border: Border.all(
                              //color: Colors.cyan,
                             // width: 5,
                            ),*/
                    borderRadius: BorderRadius.circular(30),
                  ),
                  width: MediaQuery.of(context).size.width*0.9,
                 // height: 120,
                ),
               // Text("${(bloc.state as ArticlesFinishData).article[index]['name']}"),
            Positioned(
            top: 35,
            left: 40,
            child: Text("${(bloc.state as ArticlesFinishData).article[index]['name']}",
            textDirection: TextDirection.ltr,
            softWrap: true,
            style: const TextStyle(fontSize: 25, color: Colors.black,fontWeight: FontWeight.normal),
            ),
            )
              ],)
            );
          }
      ),
            )
          ],
        ):bloc.state is ArticleMenuState?
      MultiBlocProvider(
      providers: [
        BlocProvider<TabBloc>(
            create: (context) =>TabBloc()),
      BlocProvider<MenuBloc>(
      create: (context) =>MenuBloc()),
    ],
    child: BottomNavigationBarMenu(title:widget.title),
    ):const SizedBox(),
      );
     /* floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),*/ // This trailing comma makes auto-formatting nicer for build methods.

  }
}

class BottomNavigationBarExampleApp extends StatelessWidget {
  const BottomNavigationBarExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
    theme:ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,),
      home:     MultiBlocProvider(
        providers: [
          BlocProvider<CookieBloc>(
              create: (context) =>CookieBloc()),
          BlocProvider<ChangeTextBloc>(
              create: (context) =>ChangeTextBloc()),
        ],
        child:const BottomNavigationBarExample(),
      )

    );
  }
}

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static  List<Widget> _widgetOptions = <Widget>[
    MultiBlocProvider(
      providers: [
        BlocProvider<ArticlesBloc>(
            create: (context) =>ArticlesBloc()),
      ],
      child: const MyHomePage(title: 'Flutter Demo Home Page'),
    ),
    MultiBlocProvider(
      providers: [
        BlocProvider<ArticlesBloc>(
            create: (context) =>ArticlesBloc()),
      ],
      child: const MyHomePage(title: 'Flutter Demo Home Page'),
    ),
 // Basket(),
    MultiBlocProvider(
      providers: [
        BlocProvider<SendBloc>(
            create: (context) =>SendBloc()),
      ],
      child: const Basket(),
    ),
  MultiBlocProvider(
  providers: [
  BlocProvider<CookieBloc>(
  create: (context) =>CookieBloc()),
  BlocProvider<ChangeTextBloc>(
  create: (context) =>ChangeTextBloc()),
  ],
  child: const Person(),
  )
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const GeoLoc(),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedIconTheme: const IconThemeData(color: Colors.black12),
        selectedIconTheme: const IconThemeData(color: Colors.black),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home,color: Colors.black,),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search,color: Colors.black,),
            label: 'Поиск',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket,color: Colors.black,),
            label: 'Корзина',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,color: Colors.black,),
            label: 'Аккаунт',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap:(int index){
          switch(index){
            case 0:
          MultiBlocProvider(
          providers: [
          BlocProvider<ArticlesBloc>(
          create: (context) =>ArticlesBloc()),
          ],
          child: const MyHomePage(title: 'Flutter Demo Home Page'),
          );
            case 1:
              MultiBlocProvider(
                providers: [
                  BlocProvider<ArticlesBloc>(
                      create: (context) =>ArticlesBloc()),
                ],
                child: const MyHomePage(title:'search'),
              );
            case 2:
          MultiBlocProvider(
          providers: [
          BlocProvider<SendBloc>(
          create: (context) =>SendBloc()),
          ],
          child: const Basket(),
          );
            case 3:
              MultiBlocProvider(
                providers: [
                  BlocProvider<CookieBloc>(
                      create: (context) =>CookieBloc()),
                  BlocProvider<ChangeTextBloc>(
                      create: (context) =>ChangeTextBloc()),
                ],
                child: const Person(),
              );
          }
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}



