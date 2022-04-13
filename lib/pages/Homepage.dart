import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mysql_practice/bloc/studentBloc.dart';
import 'package:mysql_practice/constraints/api_link.dart';
import 'package:mysql_practice/model/data.dart';
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
      studentBloc.getData();
    });
  }

  final studentBloc=StudentBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                    TextButton(onPressed: ()async {
                      var s=await studentBloc.addStudent(Data(controller1.text, controller2.text, controller3.text, controller4.text, controller5.text));
                      print(s);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));
                      clear_controller();
                    }, child: Text('Add')),
                    TextButton(onPressed: (){
                      studentBloc.updateStudent(Data(controller1.text, controller2.text, controller3.text, controller4.text, controller5.text));
                      clear_controller();
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
              child: StreamBuilder(
                stream: studentBloc.students,
                builder: (context,AsyncSnapshot<List<Data>> snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return CircularProgressIndicator();
                  }
                  else if(snapshot.hasData){
                    return ListView.builder(
                        itemCount:snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(snapshot.data![index].name.toString(),),
                            leading: Text(snapshot.data![index].id.toString()),
                            trailing: IconButton(
                              onPressed: (){
                                studentBloc.deleteStudentById(snapshot.data![index].id.toString());
                              },
                              icon: Icon(Icons.delete),
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(child: Text(snapshot.data![index].roll.toString())),
                                Expanded(child: Text(snapshot.data![index].shift.toString())),
                                Expanded(child: Text(snapshot.data![index].technology.toString())),
                              ],
                            ),
                            onTap: (){
                              controller1.text=snapshot.data![index].id.toString();
                              controller2.text=snapshot.data![index].name.toString();
                              controller3.text=snapshot.data![index].roll.toString();
                              controller4.text=snapshot.data![index].shift.toString();
                              controller5.text=snapshot.data![index].technology.toString();
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
