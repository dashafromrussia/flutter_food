import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/bloc/basket_bloc.dart';
import 'package:untitled/bloc/person_bloc.dart';
import 'package:untitled/bloc/sendEmail_bloc.dart';


class Basket extends StatelessWidget {
  const Basket({super.key});

  @override
  Widget build(BuildContext context) {
    final SendBloc blocSend = context.watch<SendBloc>();
   final CookieBloc bloc = context.watch<CookieBloc>();
    final blocBasket = context.watch<BasketBloc>();
    List<Map<String,dynamic>> data = blocBasket.state is ChangeBasketState ? (blocBasket.state as ChangeBasketState).data:[];
    return  blocBasket.state is ChangeBasketState?
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
       Expanded(child:ListView(
          padding:const EdgeInsets.symmetric(vertical:30,horizontal: 7),
          children: [
            ...data.map((e) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  //    padding:const EdgeInsets.symmetric(vertical: 200),
                  // margin: const EdgeInsets.all(20),
                  //child: Text("${(bloc.state as ArticlesFinishData).article[index]['name']}"),
                  decoration: BoxDecoration(
                    //color: Colors.grey,
                    image: DecorationImage(
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
                  width: 100,
                  height: 100,
                ),
                Column(
                  children: [
                    Text("${e['type']}",style:const TextStyle(fontSize: 20,)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('${e['sum']}P',style:const TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                        Text(' ${e['weight']}гр',style: const TextStyle(fontSize: 17,color: Colors.black38),),
                      ],),
                  ],
                ),
                Container(
                  padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child:const Text("+",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                        onTap:(){
                          blocBasket.add(AddChangeBasket(type:e['type'],price:e['price']));
                        },
                      ),
                     const SizedBox(width: 10,),
                      Text(data[0]['amount'].toString(),style:const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    const  SizedBox(width: 10,),
                      GestureDetector(
                        onTap:(){
                          blocBasket.add(RemoveChangeBasket(type:e['type'],price:e['price']));
                        },
                        child: const Text("-",style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                )
              ],
            )).toList()
          ],
        )),
          Container(
            padding: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton(onPressed: (){
              if(bloc.state is GetCookieState){
                if((bloc.state as GetCookieState).cookie!=''){
                  blocSend.add(SendEmailEvent(data: data, all: (blocBasket.state as ChangeBasketState).all.toString(), email:(bloc.state as GetCookieState).cookie.toString()));
                }else{
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Не заполнены данные!'),
                      content: const Text('Перейдите в раздел "Профиль" и заполните данные!'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              }else{
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('AlertDialog Title'),
                    content: const Text('AlertDialog description'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }

            }, child: Text('Заказ на ${(blocBasket.state as ChangeBasketState).all.toString()}P',style: const TextStyle(color: Colors.white),),style: ElevatedButton.styleFrom(backgroundColor: Colors.blue)),)

        ])
    :const Center(child: Text("Здесь пока пусто!",textAlign:TextAlign.center,style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),);
  }
}
