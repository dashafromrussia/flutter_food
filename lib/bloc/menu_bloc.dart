import 'dart:async';
import 'package:bloc/bloc.dart';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:untitled/data.dart';

abstract class MenuEvent extends Equatable{
  const MenuEvent();
  @override
  List<Object> get props => [];
}

class LoadMenuEvent extends MenuEvent{

  const LoadMenuEvent();
}

class FilterMenuEvent extends MenuEvent{
final String data;
  const FilterMenuEvent({required this.data});
}

class SearchMenuEvent extends MenuEvent{
  final String search;
  const SearchMenuEvent({required this.search});
}

abstract class MenuState extends Equatable{
  const MenuState();
  @override
  List<Object> get props => [];
}

class LoadMenuBegin extends MenuState{
  const LoadMenuBegin();
}

class MiddleState extends MenuState{
  const MiddleState();
}

class LoadMenuProgress extends MenuState{
  const LoadMenuProgress();
}
class MenuErrorState extends MenuState{
  const MenuErrorState();
}



class MenuFinishData extends MenuState{
  final List<Map<String,dynamic>> article;
  const MenuFinishData(this.article);
}




class MenuBloc extends Bloc<MenuEvent,MenuState>{
  List<Map<String,dynamic>> list =[];
  List<Map<String,dynamic>> filtList =[];
  PersonRemoteDataSource data = PersonRemoteDataSourceImpl();
  MenuBloc() : super(const LoadMenuBegin()) {
    on<MenuEvent>((event,emit)async{
      if(event is LoadMenuEvent){
        await loadArticleData(event, emit);
      }else if(event is FilterMenuEvent){
        emit(const MiddleState());
      List<Map<String,dynamic>> filt = [];
      list.forEach((element) {
        if(element['tags'].contains(event.data)){
          filt.add(element);
        }
      });
        emit(MenuFinishData(filt));
      }else if(event is SearchMenuEvent){
        emit(const MiddleState());
        final List<Map<String,dynamic>> listSearch =event.search==''? list:list.where((element){
          print(element['name'].toLowerCase().contains(event.search.toLowerCase()));
          return element['name'].toLowerCase().contains(event.search.toLowerCase());}).toList();
        emit(MenuFinishData(listSearch));
      }
    });
    add(const LoadMenuEvent());
  }

  Future<void> loadArticleData(
      LoadMenuEvent event,
      Emitter<MenuState> emit,
      ) async {
    emit(const LoadMenuProgress());
    final dataRes = await data.getMenuData();
    list = dataRes;
    emit(MenuFinishData(dataRes));
    print("${state}menuuuuu");
    print((state as MenuFinishData).article);

  }
}

