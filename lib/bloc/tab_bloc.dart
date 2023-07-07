import 'dart:async';
import 'package:bloc/bloc.dart';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:untitled/data.dart';

abstract class TabEvent extends Equatable{
  const TabEvent();
  @override
  List<Object> get props => [];
}

class ToggleTab extends TabEvent{
final String type;
  const ToggleTab({required this.type});
}




abstract class TabState extends Equatable{
  const TabState();
  @override
  List<Object> get props => [];
}

class ToggleState extends TabState{
  final List<Map<String,dynamic>> data;
  const ToggleState({required this.data});
}


class MiddleState extends TabState{
  const MiddleState();
}
class ArticleErrorState extends TabState{
  const ArticleErrorState();
}




class TabBloc extends Bloc<TabEvent,TabState>{
 List<Map<String,dynamic>> data = [{'type':'Все меню','toggle':false},
   {'type':'С рисом','toggle':false},{'type':'Салаты','toggle':false},{'type':'С рыбой','toggle':false},];
  TabBloc() : super(const MiddleState()) {
    on<TabEvent>((event,emit)async{
      if(event is ToggleTab){
        emit(const MiddleState());
        data = data.map((e){
          e['toggle'] = false;
          if(e['type']==event.type){
            e['toggle'] = true;
          }
          return e;
        }).toList();
        emit(ToggleState(data: data));
      }
    });
    add(const ToggleTab(type: 'Все меню'));
  }

}





