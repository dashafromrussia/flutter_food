import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';


abstract class PersonRemoteDataSource {
  Future<List<Map<String,dynamic>>> getData();
  Future<List<Map<String,dynamic>>> getMenuData();
}

//https://jsonplaceholder.typicode.com/todos/1

class PersonRemoteDataSourceImpl implements PersonRemoteDataSource {
  final client = http.Client();


  PersonRemoteDataSourceImpl();

  /*@override
  Future<bool> getData()async{
    final request = await clients.postUrl(Uri.parse("https://jsonplaceholder.typicode.com/posts/1"));
    request.headers.set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
    final response = await request.close();
    final data = response.transform(utf8.decoder);
    print(data);
    return true;
  }*/



  @override
  Future<List<Map<String,dynamic>>> getData() async {
   // final String parameters = jsonEncode(user.toJson());
   // print("params${parameters}");
    var uri = Uri.http('run.mocky.io','v3/058729bd-1402-4578-88de-265481fd7d54');
    final response = await client
        .post(uri,
        headers: {"Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*'}, body: '');
    // client.close();
    if (response.statusCode == 200) {
      //print("RESPO${response.body}respose");
      final data = json.decode(response.body);
      final Map<String,dynamic> dataRes = (data as Map<String,dynamic>);
      //print(dataRes['сategories'].runtimeType);
      List<Map<String,dynamic>> category =[];
      dataRes['сategories'].forEach((elem){
       //  print(elem.runtimeType);
         Map el = elem as Map;
         Map<String,dynamic> d = {'id':el['id'] as int,'name': el['name'] as String,
           'image_url':el['image_url']};
         category.add(d);
             // return elem as Map<String,dynamic>;
       });
      return category;
       print(category);
    } else {
      throw Exception();
    }
  }


  @override
  Future<List<Map<String,dynamic>>> getMenuData() async {
    // final String parameters = jsonEncode(user.toJson());
    // print("params${parameters}");
    var uri = Uri.http('run.mocky.io','v3/aba7ecaa-0a70-453b-b62d-0e326c859b3b');
    final response = await client
        .post(uri,
        headers: {"Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*'}, body: '');
    // client.close();
    if (response.statusCode == 200) {
      //print("RESPO${response.body}respose");
      final data = json.decode(response.body);
      final Map<String,dynamic> dataRes = (data as Map<String,dynamic>);
      //print(dataRes['сategories'].runtimeType);
      List<Map<String,dynamic>> category =[];
      dataRes['dishes'].forEach((elem){
        //  print(elem.runtimeType);
        Map el = elem as Map;
        List<String> tags = (el['tegs'] as List).map((e)=>e.toString()).toList();
        Map<String,dynamic> d = {'id':el['id'] as int,'name': el['name'] as String,'description':el['description'] as String,
          'image_url':el['image_url'],'tags':tags,'price': el['price'] as int,'weight': el['weight'] as int};
        category.add(d);
        // return elem as Map<String,dynamic>;
      });
      print(category);
      return category;
    } else {
      throw Exception();
    }
  }



}