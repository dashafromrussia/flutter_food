import 'dart:async';
import 'package:bloc/bloc.dart';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:untitled/data.dart';

abstract class BasketEvent extends Equatable{
  const BasketEvent();
  @override
  List<Object> get props => [];
}

class AddChangeBasket extends BasketEvent{
  final String type;
  final int price;
  final int? weight;
  final String? image_url;
   const AddChangeBasket({required this.type,required this.price,this.weight,this.image_url});
}

class RemoveChangeBasket extends BasketEvent {
  final String type;
  final int price;
  const RemoveChangeBasket({required this.type,required this.price});
}

abstract class BasketState extends Equatable{
  const BasketState();
  @override
  List<Object> get props => [];
}

class ChangeBasketState extends BasketState{
  final List<Map<String,dynamic>> data;
  final num all;
  const ChangeBasketState({required this.data,required this.all});
}


class MiddleState extends BasketState{
  const MiddleState();
}
class ArticleErrorState extends BasketState{
  const ArticleErrorState();
}




class BasketBloc extends Bloc<BasketEvent,BasketState>{
  List<Map<String,dynamic>> data = [];
  num all = 0;
  BasketBloc() : super(const MiddleState()) {
    on<BasketEvent>((event,emit)async{
      if(event is AddChangeBasket){
        emit(const MiddleState());
        if(data.where((element) => element['type']==event.type).toList().isNotEmpty){
          all = 0;
        data = data.map((e){
          all = all + e['sum'];
          if(e['type']==event.type){
            e['amount'] = e['amount']+1;
            e['sum'] = e['sum']+event.price;
          }
          all = all + e['sum'];
          return e;
        }).toList();
        }else{
          all = all +event.price;
          data.add({'type':event.type,'amount':1,'sum':event.price,'weight':event.weight,'image_url':event.image_url,'price':event.price});
        }
        emit(ChangeBasketState(data: data, all:all));
        print(data);
      }else if(event is RemoveChangeBasket){
        emit(const MiddleState());
        final List<Map<String,dynamic>> middleList =data.where((element) => element['type']==event.type).toList();
        if(data.where((element) => element['type']==event.type).toList().isNotEmpty){
          if(middleList[0]['amount']>1){
            data = data.map((e){
              if(e['type']==event.type){
                all = all-event.price;
                  e['amount'] = e['amount']-1;
                  e['sum'] = e['sum']-event.price;
                }
              return e;
            }).toList();
          }else{
            data = data.where((element) => element['type']!=event.type).toList();
          }

        }
        emit(ChangeBasketState(data: data,all: all));
        print(data);
      }
    });
  }

}

