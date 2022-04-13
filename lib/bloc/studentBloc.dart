import 'dart:async';
import 'dart:convert';

import 'package:mysql_practice/model/data.dart';
import 'package:http/http.dart' as http;

import '../constraints/api_link.dart';

class StudentBloc {
  //Get instance of the action
  final _studentAction = StudentAction();

  //Stream controller is the 'Admin' that manages
  //the state of our stream of data like adding
  //new data, change the state of the stream
  //and broadcast it to observers/subscribers
  final _studentController = StreamController<List<Data>>.broadcast();

  get students => _studentController.stream;

  StudentBloc() {
    getData();
  }

  getData() async {
    //sink is a way of adding data reactively to the stream
    //by registering a new event
    _studentController.sink.add(await _studentAction.getData());
  }

  Future<String> addStudent(Data data) async {
    var s= await _studentAction.AddData(data);
    getData();

    return s;
  }

  updateStudent(Data data) async {
    await _studentAction.UpdateData(data);
    getData();
  }

  deleteStudentById(String id) async {
    await _studentAction.DeleteData(id);
    getData();
  }

  dispose() {
    _studentController.close();
  }
}

class StudentAction {

  Future<List<Data>> getData()async{

    final response=await http.get(Uri.parse("${api+getAll}"));
    var data;
    List<Data> dataList;
    if(response.statusCode==200){
      dataList=[];
      data=jsonDecode(response.body.toString());
      for(Map i in data){
        dataList.add(Data.fromJson(i));
      }
      return dataList;
    }
    else{
      throw Exception('No data found');
    }
  }

  Future<String> AddData(Data data)async{
    var map=Map<String,dynamic>();
    map['Id']='${data.id}';
    map['Name']='${data.name}';
    map['Roll']='${data.roll}';
    map['Shift']='${data.shift}';
    map['Technology']='${data.technology}';
    final response=await http.post(Uri.parse("${api+addData}"),body: map);
    if(response.statusCode==200){
      return response.body;
    }
    else{
      return 'Error';
    }
  }

  Future<String> UpdateData(Data data)async{
    var map=Map<String,dynamic>();
    map['Id']='${data.id}';
    map['Name']='${data.name}';
    map['Roll']='${data.roll}';
    map['Shift']='${data.shift}';
    map['Technology']='${data.technology}';
    final response=await http.post(Uri.parse("${api+updateData}"),body: map);
    if(response.statusCode==200){
      return response.body;
    }
    else{
      return 'Error';
    }
  }

  Future<String> DeleteData(String id)async{
    var map=Map<String,dynamic>();
    map['Id']='$id';
    final response=await http.post(Uri.parse("${api+deleteData}"),body: map);
    if(response.statusCode==200){
      return response.body;
    }
    else{
      return 'Error';
    }
  }

// //Get All Todo items
// //Searches if query string was passed
// Future<List<Data>> getStudentData({List<String> columns, String query}) async {
//   final db = await dbProvider.database;
//
//   List<Map<String, dynamic>> result;
//   if (query != null) {
//     if (query.isNotEmpty)
//       result = await db.query(todoTABLE,
//           columns: columns,
//           where: 'description LIKE ?',
//           whereArgs: ["%$query%"]);
//   } else {
//     result = await db.query(todoTABLE, columns: columns);
//   }
//
//   List<Todo> todos = result.isNotEmpty
//       ? result.map((item) => Todo.fromDatabaseJson(item)).toList()
//       : [];
//   return todos;
// }
//
// //Update Todo record
// Future<int> updateStudentData(Todo todo) async {
//   final db = await dbProvider.database;
//
//   var result = await db.update(todoTABLE, todo.toDatabaseJson(),
//       where: "id = ?", whereArgs: [todo.id]);
//
//   return result;
// }
//
// //Delete Todo records
// Future<int> deleteStudentData(int id) async {
//   final db = await dbProvider.database;
//   var result = await db.delete(todoTABLE, where: 'id = ?', whereArgs: [id]);
//
//   return result;
// }
//
// //We are not going to use this in the demo
// Future deleteAllStudentData() async {
//   final db = await dbProvider.database;
//   var result = await db.delete(
//     todoTABLE,
//   );
//
//   return result;
// }
}