import 'dart:async';
import 'package:bloc/bloc.dart';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:untitled/data.dart';

abstract class ArticleEvent extends Equatable{
  const ArticleEvent();
  @override
  List<Object> get props => [];
}

class LoadArticlesEvent extends ArticleEvent{

  const LoadArticlesEvent();
}

class ShowMenuArticlesEvent extends ArticleEvent{

  const ShowMenuArticlesEvent();
}



abstract class ArticleState extends Equatable{
  const ArticleState();
  @override
  List<Object> get props => [];
}

class LoadArticleBegin extends ArticleState{
  const LoadArticleBegin();
}


class LoadArticleProgress extends ArticleState{
  const LoadArticleProgress();
}
class ArticleErrorState extends ArticleState{
  const ArticleErrorState();
}

class ArticleMenuState extends ArticleState{
  const ArticleMenuState();
}

class ArticlesFinishData extends ArticleState{
  final List<Map<String,dynamic>> article;
  const ArticlesFinishData(this.article);
}




class ArticlesBloc extends Bloc<ArticleEvent,ArticleState>{
  PersonRemoteDataSource data = PersonRemoteDataSourceImpl();
  ArticlesBloc() : super(const LoadArticleBegin()) {
    on<ArticleEvent>((event,emit)async{
      if(event is LoadArticlesEvent){
        await loadArticleData(event, emit);
      }else if(event is ShowMenuArticlesEvent){
        emit(ArticleMenuState());
      }
    });
    add(const LoadArticlesEvent());
  }

  Future<void> loadArticleData(
      LoadArticlesEvent event,
      Emitter<ArticleState> emit,
      ) async {
    emit(const LoadArticleProgress());
    final dataRes = await data.getData();
    emit(ArticlesFinishData(dataRes));
    print("${state}articlesss");
    print((state as ArticlesFinishData).article);

  }
}







