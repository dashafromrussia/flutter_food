import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/bloc/basket_bloc.dart';
import 'package:untitled/bloc/menu_bloc.dart';
import 'package:untitled/bloc/tab_bloc.dart';
import 'package:untitled/data.dart';
import 'dart:async';
import 'package:cupertino_modal_sheet/cupertino_modal_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitled/main.dart';



class BottomNavigationBarMenu extends StatelessWidget {
  final String title;
  const BottomNavigationBarMenu({super.key,required this.title});

  @override
  Widget build(BuildContext context) {
    final blocBasket = context.watch<BasketBloc>();
    final bloc = context.watch<MenuBloc>();
    return bloc.state is MenuFinishData?
    Column(
          children: [
           Container(
               padding:const EdgeInsets.symmetric(horizontal: 10),
               child:Row(
             mainAxisAlignment: MainAxisAlignment.start,
             children: [
               const Icon(Icons.search),
               const SizedBox(width: 5,),
               Expanded(child: TextField(
                 onChanged:(text){
                   bloc.add(SearchMenuEvent(search: text.trim()));
                   print(text);
                 },
                 textAlign: TextAlign.left,
                 decoration:const InputDecoration(
                   border: InputBorder.none,
                   hintText: 'введите название блюда.....',
                   hintStyle: TextStyle(color: Colors.grey),
                 ),
               ))
             ],)),
           const SizedBox(height: 5,),
    const Tab(),
       const SizedBox(height: 50,),
       Expanded(child:GridView.extent(
                maxCrossAxisExtent: 150,
               padding: const EdgeInsets.all(10),
              mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: (bloc.state as MenuFinishData).article.map((e) =>GestureDetector(
                  onTap: ()=>
                  showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => Dialog(
                  child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                   // mainAxisAlignment: MainAxisAlignment.center,
                    children:
                  [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(onPressed:(){
                          Navigator.pop(context);
                        }, icon:const Icon(Icons.close)),],),
                   const SizedBox(height: 10,),
                     Container(
                  //    padding:const EdgeInsets.symmetric(vertical: 200),
                      // margin: const EdgeInsets.all(20),
                      //child: Text("${(bloc.state as ArticlesFinishData).article[index]['name']}"),
                      decoration: BoxDecoration(
                       // color: Colors.grey,
                        image:  DecorationImage(
                          image: NetworkImage("${e['image_url']}"),
                          fit: BoxFit.contain,
                        ),
                        /*border: Border.all(
                              //color: Colors.cyan,
                             // width: 5,
                            ),*/
                        borderRadius: BorderRadius.circular(10),
                      ),
                     // width: MediaQuery.of(context).size.width*0.5,
                       width: 250,
                      height: 300,
                    ),
                    //  const SizedBox(height: 5,),
                   const SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      Text(e['name'], textAlign: TextAlign.center,style:const TextStyle(fontSize: 22,),),],),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('${e['price']}P',style:const TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                        Text(' ${e['weight']}гр',style: const TextStyle(fontSize: 17,color: Colors.black38),),
                        ],),


                    const SizedBox(height: 10,),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child:Text(e['description'],style:const TextStyle(fontSize: 19,color: Colors.black38),),),
                    const SizedBox(height: 10,),
                    ElevatedButton(onPressed:(){
                      blocBasket.add(AddChangeBasket(type:e['name'],price: e['price'],weight: e['weight'],image_url: e['image_url']));
                    }, child: const Text('Заказать',style: TextStyle(color: Colors.white),), style: ElevatedButton.styleFrom(backgroundColor: Colors.blue)),
                    /*ElevatedButton(onPressed:(){
                      blocBasket.add(RemoveChangeBasket(type:e['name'],price: e['price']));
                    }, child: const Text('Отказаться',style: TextStyle(color: Colors.white),), style: ElevatedButton.styleFrom(backgroundColor: Colors.blue)),*/
                  ],)
    ),
    ),
    ), child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
             Expanded(child: Container(
            // padding:const EdgeInsets.symmetric(vertical: 200),
              // margin: const EdgeInsets.all(20),
               //child: Text("${(bloc.state as ArticlesFinishData).article[index]['name']}"),
               decoration: BoxDecoration(
                // color: Colors.grey,
                 image:  DecorationImage(
                   image: NetworkImage("${e['image_url']}",),
                    fit: BoxFit.scaleDown,
                 ),
                 /*border: Border.all(
                              //color: Colors.cyan,
                             // width: 5,
                            ),*/
                   borderRadius: BorderRadius.circular(10),
               ),
                width: 300,
               height: 500,
             ),
             ),
               //  const SizedBox(height: 5,),
                    Expanded(child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: Text(
                            e['name'],textAlign: TextAlign.center,style: TextStyle(fontSize: 15),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        )

                      ],
                    )),
                // Expanded(child: Text(e['name'],style: TextStyle(fontSize: 15),))
                ],))).toList()))
          ],
        )

     /* Expanded(child: ListView.builder(
          itemCount: (bloc.state as MenuFinishData).article.length,
          itemBuilder:(BuildContext context, int index){
        return Text('aaaa');
    } ))*/
   :const SizedBox();
  }
}

class Tab extends StatelessWidget {
  const Tab({super.key});
  @override
  Widget build(BuildContext context) {
    final tabBloc = context.watch<TabBloc>();
    final menu = context.watch<MenuBloc>();
    final List<Map<String,dynamic>> list = tabBloc.state is ToggleState ? (tabBloc.state as ToggleState).data:[];
    return tabBloc.state is ToggleState ? Row(
    //  scrollDirection: Axis.horizontal,
      children: [
        ...list.map((e)=>Expanded(child: GestureDetector(
          onTap:(){
            tabBloc.add(ToggleTab(type: e['type']));
            menu.add(FilterMenuEvent(data:e['type']));
          },
            child:Container(
              child: Center(child:Text(e['type'] as String,style: TextStyle(color:e['toggle']? Colors.white:Colors.black,fontSize: 15),)),
          decoration: BoxDecoration(color: e['toggle']?Colors.blueAccent:Colors.black12,borderRadius: BorderRadius.all(Radius.circular(5))),
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 2),margin: EdgeInsets.symmetric(horizontal: 2),)))).toList()
      ],
    ):const SizedBox();
  }
}
/*Expanded(child:SizedBox(height:50,child:ElevatedButton(onPressed:(){
          tabBloc.add(ToggleTab(type: e['type']));
        }, child: Text(e['type'] as String),style:ButtonStyle(
          backgroundColor: MaterialStatePropertyAll<Color>(e['toggle']?Colors.red:Colors.black12),
        ),))*/