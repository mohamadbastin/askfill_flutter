import 'package:flutter/material.dart';
import "package:questionnaire_flutter/models/form.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class FormItem extends StatelessWidget {
  final myForm form;

  FormItem({
    this.form,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
      splashColor: Colors.redAccent,
      onTap: () => {Navigator.pushNamed(context, '/form', arguments: form)},
      child: Hero(
        tag: form.name + form.author.name,
        child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    child: Image.asset(
                      'assets/images/ff.png',
                      fit: BoxFit.cover,
                      height: 150,
                      width: double.infinity,
                    ),

//                  child: Image.network(
//                    meal.imageUrl,
//                    fit: BoxFit.cover,
//                    height: 250,
//                    width: double.infinity,
//                  ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 20,
                    child: Container(
                      color: Colors.black54,
                      height: 40,
                      width: 300,
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: Text(
                        form.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    height: 30,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(Icons.timer),
                            SizedBox(
                              width: 3,
                            ),
                            Container(
                                child: Text(
                                    '${form.estimated_time.toString()} min'))
                          ],
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(Icons.calendar_today),
                            SizedBox(
                              width: 3,
                            ),
                            Container(
                              child: Text(
                                  // DateFormat.yMMMEd().format(DateTime.parse(form.created)),
                                  DateFormat.yMMMMd()
                                      .format(DateTime.parse(form.created))
                                  // form.created
                                  ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(FontAwesomeIcons.pen),
                            SizedBox(
                              width: 3,
                            ),
                            Container(child: Text(form.author.name))
                          ],
                        ),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
