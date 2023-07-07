import 'dart:async';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled/cookie_data.dart';


abstract class ChangeEvent extends Equatable {
  const ChangeEvent();

  @override
  List<Object> get props => [];
}

/*class AppData extends AppEvent {

}*/

class ChangeTextEvent extends ChangeEvent {
  final String text;

  const ChangeTextEvent(this.text);

  @override
  List<Object> get props => [text];
}




abstract class ChangeState extends Equatable {
  const ChangeState();

  @override
  List<Object> get props => [];
}

class MiddleState extends ChangeState{
  const MiddleState();

  @override
  List<Object> get props => [];
}

class ChangeTextState extends ChangeState{
  final String text;

  const ChangeTextState(this.text);

  @override
  List<Object> get props => [text];
}





class ChangeTextBloc extends Bloc<ChangeEvent,ChangeState>{


  ChangeTextBloc() : super(const MiddleState()) {
    on<ChangeEvent>((event,emit)async{
      if (event is ChangeTextEvent) {
        emit(ChangeTextState(event.text));
      }
    },
    );

  }
}