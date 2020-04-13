import 'package:flutter/material.dart';

class QuestionItem extends StatefulWidget {
  final int index;
  final question;
  final Key key;

  QuestionItem({this.index, this.question, this.key});

  @override
  _QuestionItemState createState() => _QuestionItemState();
}

class _QuestionItemState extends State<QuestionItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      key: Key(widget.question["text"] + widget.index.toString()),
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 10.0),
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
          decoration: BoxDecoration(
              color: Colors.white30,
              borderRadius: BorderRadius.circular(10.0)
          ),
          width: double.infinity,
          child: (widget.question["type"] == "Text") ?  Row(
            children: <Widget>[
              Flexible(
                fit: FlexFit.tight,
                flex: 5,
                child: Container(alignment: Alignment.centerLeft, child: Text('${widget.index + 1}. ${widget.question["text"]}')),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                    alignment: Alignment.bottomRight,
                    child: Text(widget.question["type"], style: TextStyle(fontSize: 15.0, color: Colors.blue),)
                ),
              ),
            ],
          ) : ExpansionTile(
            leading: Text('${widget.index + 1}. ${widget.question["text"]}', overflow: TextOverflow.fade,),
            title: widget.question["type"] == "Choice" ? Text("${widget.question["type"]}/${widget.question["choice_type"]}", overflow: TextOverflow.fade,) : Text(widget.question["type"], overflow: TextOverflow.fade,),
            children: widget.question["type"] == "Choice" ? widget.question["choices"].map<Widget>((choice) {
              return Text('${widget.question["choices"].indexOf(choice) + 1}. ${choice["controller"].text}');
            }).toList() : [
              Text('Low Threshold: ${widget.question["start_text"]}'),
              Text('High Threshold: ${widget.question["end_text"]}'),
            ],
          ),
        )
      ],
    );
  }
}
