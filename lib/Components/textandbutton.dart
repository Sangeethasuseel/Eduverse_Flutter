import 'package:flutter/material.dart';

class TextBox extends StatefulWidget {

  final TextInputType textInputType;
  final String hint;

  TextBox({
    this.textInputType,
    this.hint
  });

  @override
  _TextBoxState createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Container(
        height: 50.0,
        child: TextFormField(
          keyboardType: widget.textInputType,
          autofocus: false,
          decoration: InputDecoration(
            hintText: widget.hint,
            // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            enabledBorder:
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: Color(0xFF54ABD0), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: Color(0xFF54ABD0), width: 2),
            ),
          ),
          // validator: FormValidator().validateEmail,
          // onSaved: (String value) {
          //   _loginData.email = value;
          // },
        ),
      ),
    );
  }
}


class Button extends StatefulWidget {

  final String buttonName;

  Button({
    this.buttonName
  });

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: FlatButton(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(15.0),
          ),
          onPressed: () {},
          color: Color(0xFF49C9C4),
          child: Text(
            widget.buttonName,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Raleway',
              fontSize: 22.0,
            ),
          ),
        ),
      ),
    );
  }
}

