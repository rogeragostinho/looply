 import 'package:flutter/material.dart';
import 'package:looply/model/revision_cycle.dart';
import 'package:looply/service/revision_cycle_service.dart';
 
class AddTopicPage extends StatefulWidget {
  const AddTopicPage({super.key});
 
  @override
  State<AddTopicPage> createState() => _AddTopicPageState();
}
 
class _AddTopicPageState extends State<AddTopicPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final formTopicController = TextEditingController();
  final formStudiedOnController = TextEditingController();
  //int? idRevisionCycle = RevisionCycleService.instance.get(1).id;
  DateTime studiedOn = DateTime.now();


  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));

    setState(() {
      if (pickedDate != null) {
        studiedOn = pickedDate;
        formStudiedOnController.text ='${studiedOn.day}/${studiedOn.month}/${studiedOn.year}';

        //formStudiedOnController.text  studiedOn.toString();
      }
    });
  }


  @override
  void initState() {
    super.initState();
    formStudiedOnController.text ='${studiedOn.day}/${studiedOn.month}/${studiedOn.year}';
  }

  @override
  void dispose() {
    formTopicController.dispose();
    formStudiedOnController.dispose();
    super.dispose();
  }

  String color = "amber";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Topic"),
        backgroundColor: Color(Colors.blue.toARGB32()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: formTopicController,
                decoration: const InputDecoration(border: OutlineInputBorder(), label: Text("Topic*")),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira o tópico";
                  }
                  return null;
                },
              ),

              SizedBox(height: 25.0,),

              TextFormField(
                readOnly: true,
                controller: formStudiedOnController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), 
                    labelText: "StudiedOn",
                    suffixIcon: IconButton(onPressed: _selectDate, icon: Icon(Icons.calendar_month))
                  ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira a data";
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 25.0,),
              Text("Revision Cycle"),
              RadioGroup<int>(
                //groupValue: idRevisionCycle,
                onChanged: (int? value) {
                  setState(() {
                    //idRevisionCycle = value;  
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //Text("selected: $idRevisionCycle"),
                    /*for (RevisionCycle revision in RevisionCycleService.instance.getAll())
                      Row(
                        children: [
                          Radio<int>(value: revision.id!),
                          Text("${revision.name} ${revision.cycle.toString()}")
                        ],
                      )*/
                  ],
                ),
                
              ),
              SizedBox(height: 25.0,),
              Text("Tags for you topic"),
              SizedBox(height: 6.0,),
              TextField(decoration: InputDecoration(border: OutlineInputBorder(), focusedBorder: OutlineInputBorder()),),
            ],  
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        // Expanded so funciona dentro de Rom ou Column, usar Container ou SizedBox com width:double.infinity
        child: Expanded(
          child: ElevatedButton(
            onPressed: () => {
              /*if (_formKey.currentState!.validate()) {

              }*/
            }, 
            child: const Text("Create Topic")
          )
        ),
      ),
    );
  }
}