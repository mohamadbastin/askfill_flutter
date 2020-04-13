import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questionnaire_flutter/models/form.dart';
import 'package:questionnaire_flutter/providers/formProvider.dart';


Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

class ReportByFormScreen extends StatefulWidget {
  static final String routeName = '/reportbyform';

  @override
  _ReportByFormScreenState createState() => _ReportByFormScreenState();
}

class _ReportByFormScreenState extends State<ReportByFormScreen> {

  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    final myForm form = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(title: Text(form.name),
      actions: <Widget>[
          IconButton(icon: Icon(Icons.calendar_today),onPressed: (){
            _selectDate(context);
          })
        ],),
      body: FutureBuilder(
          future: Provider.of<FormProvider>(context, listen: false)
              .fetchFormQuery(form.id, selectedDate.toString().substring(0,10)),
          builder: (_, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    )
                  : Formres())
      
    );
  }
}




class Formres extends StatefulWidget {
  @override
  _FormresState createState() => _FormresState();
}

class _FormresState extends State<Formres> {
  @override
  Widget build(BuildContext context) {
    
    return Container(
      child: ListView.builder(
          itemCount: byquesquery.length,
          itemBuilder: (context, index) {
            return FormresItem(index: index, answer: byquesquery[index]);
          }),
    );
  }
}

class FormresItem extends StatefulWidget {
  final answer;
  final int index;

  FormresItem({this.answer, this.index});

  @override
  _FormresItemState createState() => _FormresItemState();
}

class _FormresItemState extends State<FormresItem> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Scaffold(
                    appBar: AppBar(
                        title: Text(widget.answer['date'].substring(0, 10) +
                            '  ' +
                            widget.answer['date'].substring(11, 16))),
                    body: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 5.0),
                              child: ListView.builder(
                                itemBuilder: (context, index) => Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 5.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        gradient: LinearGradient(
                                            colors: [
                                              hexToColor('#4b6cb7'),
                                              hexToColor('#182848'),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight)),
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // key: key,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            '${index + 1}. ${widget.answer["answer"][index]["question"]["text"]}',
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom,
                                          ),
                                          child: widget.answer["answer"][index]
                                                      ["question"]["type"] ==
                                                  "text"
                                              ? Text(widget.answer["answer"]
                                                  [index]["text"])
                                              : (widget.answer["answer"][index]
                                                              ["question"]
                                                          ["type"] ==
                                                      "choice")
                                                  ? ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          ClampingScrollPhysics(),
                                                      itemBuilder: (context,
                                                              choiceIndex) =>
                                                          Row(
                                                        children: <Widget>[
                                                          Text(
                                                              widget.answer["answer"][index]["choice"][choiceIndex]["choice"]["text"]
                                                              // 'sdfh'
                                                              ),
                                                          Checkbox(
                                                            value: true,
                                                            onChanged:
                                                                (value) {},
                                                            activeColor:
                                                                Colors.green,
                                                          ),
                                                        ],
                                                      ),
                                                      itemCount: widget.answer["answer"][index]["choice"].length,
                                                    )
                                                  : Text(widget.answer["answer"]
                                                  [index]["number"].toString()),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                itemCount: widget.answer["answer"].length,
                              ),
                            ),
                          ),
                          
                        ],
                      ),
                    ),
                    floatingActionButton: FloatingActionButton(
                      onPressed: () => Navigator.pop(context),
                      child: Icon(Icons.close),
                    ),
                  ),
                );
              });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10) ,
          width: MediaQuery.of(context).size.width,
          height: 60,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.account_circle),
                      SizedBox(
                        width: 5,
                      ),
                      Text(widget.answer['participant']["name"]),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      
                      Icon(Icons.calendar_today),
                      SizedBox(
                        width: 5,
                      ),
                      Text(widget.answer['date'].substring(0, 10)),
                      
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.access_time),
                      SizedBox(
                        width: 5,
                      ),
                      Text(widget.answer['date'].substring(11, 16)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      Divider()
    ]);
  }
}
