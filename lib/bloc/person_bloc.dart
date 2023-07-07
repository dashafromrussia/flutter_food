import 'dart:async';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled/cookie_data.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';


abstract class CookieEvent extends Equatable {
  const CookieEvent();

  @override
  List<Object> get props => [];
}

/*class AppData extends AppEvent {

}*/

class SetCookieEvent extends CookieEvent {
  final String cookie;

  const SetCookieEvent(this.cookie);

  @override
  List<Object> get props => [cookie];
}

class ExitCookieEvent extends CookieEvent{

}

class GetCookieEvent extends CookieEvent{

}


abstract class CookieState extends Equatable {
  const CookieState();

  @override
  List<Object> get props => [];
}

class CookieBeginState extends CookieState{
  const CookieBeginState();

  @override
  List<Object> get props => [];
}

class SetCookieState extends CookieState {
  final String cookie;

  const SetCookieState(this.cookie);

  @override
  List<Object> get props => [cookie];
}

class ExitState extends CookieState{

}

class ErrorState extends CookieState{

}

class GetCookieState extends CookieState{
  final String? cookie;
  const GetCookieState(this.cookie);
}




class CookieBloc extends Bloc<CookieEvent,CookieState>{

  CookieData cookieData = CookieDataProvider();
  CookieBloc() : super(const CookieBeginState()) {
    on<CookieEvent>((event,emit)async{
      if (event is GetCookieEvent) {
          final String? cook =  await cookieData.getSessionId();
          emit(GetCookieState(cook!=null?cook:''));
      } else if (event is SetCookieEvent) {
        try{
          await cookieData.setSessionId(event.cookie);
          await sendEmail(event.cookie);
          emit(SetCookieState(event.cookie));
          final String? cook =  await cookieData.getSessionId();
          emit(GetCookieState(cook!=null?cook:''));
        }catch(e){
          emit(ErrorState());
        }


      }else if(event is ExitCookieEvent){
        await cookieData.deleteSessionId();
        emit(ExitState());
        final String? cook =  await cookieData.getSessionId();
        emit(GetCookieState(cook!=null?cook:''));
      }
    },
    );

    add(GetCookieEvent());
  }
}

Future<void> sendEmail(String email) async {
  print('eventt');
  String username = 'dariavladimirowna@gmail.com';
  String password = 'xaysgevibecqjzsr';
  final smtpServer = gmail(username, password);
  final message = Message()
    ..from = Address(username, 'dash')
    ..recipients.add(email)
    ..subject = 'Доставка еды :: 😀 :: ${DateTime.now()}'
    ..text = 'This is the plain text.\nThis is line 2 of the text part.'
    ..html = "<h1>Доставка еды</h1>\n<p>Почта подтверждена! Ваша Доставка!</p>";
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