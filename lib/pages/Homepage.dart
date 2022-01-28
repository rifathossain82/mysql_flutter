import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql_practice/constraints/api_link.dart';
import 'package:mysql_practice/data.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  TextEditingController controller1=TextEditingController();
  TextEditingController controller2=TextEditingController();
  TextEditingController controller3=TextEditingController();
  TextEditingController controller4=TextEditingController();
  TextEditingController controller5=TextEditingController();
  List<Data> dataList=[];

  Future<List<Data>> getData()async{
    final response=await http.get(Uri.parse("${api+getAll}"));
    var data;
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

  Future<String> AddData(String id,String name,String roll,String shift, String technology)async{
    var map=Map<String,dynamic>();
    map['Id']='$id';
    map['Name']='$name';
    map['Roll']='$roll';
    map['Shift']='$shift';
    map['Technology']='$technology';
    final response=await http.post(Uri.parse("${api+addData}"),body: map);
    if(response.statusCode==200){
      return response.body;
    }
    else{
      return 'Error';
    }
  }

  Future<String> UpdateData(String id,String name,String roll,String shift, String technology)async{
    var map=Map<String,dynamic>();
    map['Id']='$id';
    map['Name']='$name';
    map['Roll']='$roll';
    map['Shift']='$shift';
    map['Technology']='$technology';
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


@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    clear_controller();
  }

  void clear_controller(){
    controller1.clear();
    controller2.clear();
    controller3.clear();
    controller4.clear();
    controller5.clear();
  }

  void refreshData(){
    setState(() {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MySql Practice'),
        actions: [
          IconButton(onPressed: (){
            refreshData();
          }, icon: Icon(Icons.refresh)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: controller1,
                  decoration: InputDecoration(
                    label: Text('Enter Id'),
                    border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 5,),
                TextField(
                  controller: controller2,
                  decoration: InputDecoration(
                      label: Text('Enter Name'),
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 5,),
                TextField(
                  controller: controller3,
                  decoration: InputDecoration(
                      label: Text('Enter Roll'),
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 5,),
                TextField(
                  controller: controller4,
                  decoration: InputDecoration(
                      label: Text('Enter Shift'),
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 5,),
                TextField(
                  controller: controller5,
                  decoration: InputDecoration(
                      label: Text('Enter Technology'),
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 5,),
                Row(
                  children: [
                    TextButton(onPressed: (){
                      AddData(controller1.text, controller2.text, controller3.text, controller4.text, controller5.text);
                      clear_controller();
                      refreshData();
                    }, child: Text('Add')),
                    TextButton(onPressed: (){
                      UpdateData(controller1.text, controller2.text, controller3.text, controller4.text, controller5.text);
                      clear_controller();
                      refreshData();
                    }, child: Text('Update')),
                    TextButton(onPressed: (){
                      controller1.clear();
                      controller2.clear();
                      controller3.clear();
                      controller4.clear();
                      controller5.clear();
                    }, child: Text('Clear')),
                  ],
                )
              ],
            ),
          ),
          Expanded(
              child: FutureBuilder<List<Data>>(
                future: getData(),
                builder: (context,AsyncSnapshot<List<Data>> snapshot){
                  if(snapshot.hasData){
                    return ListView.builder(
                        itemCount: dataList.length,
                        itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(dataList[index].name.toString(),),
                        leading: Text(dataList[index].id.toString()),
                        trailing: IconButton(
                          onPressed: (){
                            DeleteData(dataList[index].id.toString());
                            refreshData();
                          },
                          icon: Icon(Icons.delete),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(child: Text(dataList[index].roll.toString())),
                            Expanded(child: Text(dataList[index].shift.toString())),
                            Expanded(child: Text(dataList[index].technology.toString())),
                          ],
                        ),
                        onTap: (){
                          controller1.text=dataList[index].id.toString();
                          controller2.text=dataList[index].name.toString();
                          controller3.text=dataList[index].roll.toString();
                          controller4.text=dataList[index].shift.toString();
                          controller5.text=dataList[index].technology.toString();
                        },
                      );
                    });
                  }
                  else{
                    return Center(child: Text('No Data Found'),);
                  }
                },
              )
          )
        ],
      ),
    );
  }
}
