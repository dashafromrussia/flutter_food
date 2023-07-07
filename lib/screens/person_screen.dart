import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/bloc/changeText_bloc.dart';
import 'package:untitled/bloc/person_bloc.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class Person extends StatefulWidget {
  const Person({super.key});

  @override
  State<Person> createState() => _PersonState();
}

class _PersonState extends State<Person> {



  @override
  Widget build(BuildContext context) {
    CookieBloc bloc = context.watch<CookieBloc>();
    ChangeTextBloc blocChange = context.watch<ChangeTextBloc>();
    return bloc.state is GetCookieState? Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child:(bloc.state as GetCookieState).cookie==''? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
          [Expanded(child:Text("Введите свой email для того, чтобы сделать заказ:",
          softWrap:true,
          maxLines:3,
            textAlign: TextAlign.center,
            style:const TextStyle(fontSize: 20),)),],),
        TextField(
          onChanged:(text){
            print(text);
            blocChange.add(ChangeTextEvent(text.trim()));
          },
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Our e-mail.....',
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        bloc.state is ErrorState ? const Text("Попробуйте еще раз.Произошла ошибка!",
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.red),): const SizedBox(),
        ElevatedButton(
            onPressed:
            blocChange.state is ChangeTextState? (blocChange.state as ChangeTextState).text!=''?(){
              String email = blocChange.state is ChangeTextState? (blocChange.state as ChangeTextState).text:'';
              bloc.add(SetCookieEvent(email));
            }:null:null
            , child:Text('Отправить'))
      ],):Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
            [Expanded(child:Text("Ваш email ${(bloc.state as GetCookieState).cookie}",
              softWrap:true,
              maxLines:3,
              textAlign: TextAlign.center,
              style:const TextStyle(fontSize: 20),)),],),
          SizedBox(height: 5,),
          ElevatedButton(onPressed:(){
            bloc.add(ExitCookieEvent());
          }, child: Text('Изменить email',style:const TextStyle(color: Colors.white),),style: ElevatedButton.styleFrom(backgroundColor: Colors.blue))
        ],
      )
    ):const SizedBox();
  }
}
