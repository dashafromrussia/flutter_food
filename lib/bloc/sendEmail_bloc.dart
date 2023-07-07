import 'dart:async';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled/cookie_data.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';


abstract class SendEvent extends Equatable {
  const SendEvent();

  @override
  List<Object> get props => [];
}

/*class AppData extends AppEvent {

}*/

class SendEmailEvent extends SendEvent {
  final List<Map<String,dynamic>> data;
  final String all;
  final String email;
  const SendEmailEvent({required this.data,required this.all,required this.email});

  @override
  List<Object> get props => [data,all];
}




abstract class SendState extends Equatable {
  const SendState();

  @override
  List<Object> get props => [];
}

class BeginSend extends SendState{

}


class SuccessSend extends SendState{

}



class ErrorState extends SendState{

}


class SendBloc extends Bloc<SendEvent,SendState>{


  SendBloc() : super(BeginSend()) {
    on<SendEvent>((event,emit)async{
      if (event is SendEmailEvent) {
        try{
          await sendEmail(event.data,event.all,event.email);
          emit(SuccessSend());
        }catch(e){
          emit(ErrorState());
        }
      }
    },
    );

  }
}

Future<void> sendEmail(List<Map<String,dynamic>>data, String all, String email) async {
  print('eventt');
  String username = 'dariavladimirowna@gmail.com';
  String password = 'xaysgevibecqjzsr';
  final smtpServer = gmail(username, password);
  final message = Message()
    ..from = Address(username, 'dash')
    ..recipients.add(email)
    ..subject = 'Доставка еды :: 😀 :: ${DateTime.now()}'
    ..text = 'This is the plain text.\nThis is line 2 of the text part.'
    ..html = "<h1>Доставка еды</h1>\n<p>Ваш заказ на сумму:${all}Р. Время ожидания 15 мин</p>";
  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}