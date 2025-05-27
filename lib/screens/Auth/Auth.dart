import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  final Function(int, String) onChangedStep;
  const AuthScreen({Key? key, required this.onChangedStep}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  final RegExp emailRegex = RegExp(r"[\w-\.]+@([\w-]+\.)+[\w-]{2,4}");

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {}),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    text: "Everyone has\n".toUpperCase(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40.0,
                      decoration: TextDecoration.underline,
                    ),
                    children: [
                      TextSpan(
                        text: 'Knowledge\n'.toUpperCase(),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: 'to share.'.toUpperCase()),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.only(right: 170.0),
                  child: Text(
                    'It all starts here.',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                SizedBox(height: 100.0),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Enter your email'),
                      SizedBox(height: 5.0),
                      TextFormField(
                        onChanged:
                            (value) => setState(() {
                              _email = value;
                            }),
                        validator: (value) {
                          if (value == null || !emailRegex.hasMatch(value)) {
                            return 'Please enter a valid email'; // If email doesn't match regex
                          }
                          return null; // Validation successful
                        },
                        decoration: InputDecoration(
                          hintText: 'Ex: example@domain.com',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0.0),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0.0),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 4.0,
                            horizontal: 12.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor:
                              emailRegex.hasMatch(_email)
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        onPressed:
                            emailRegex.hasMatch(_email)
                                ? () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    print(_email);
                                    widget.onChangedStep(1, _email);
                                  }
                                }
                                : null,
                        child: Text(
                          'CONTINUE',
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                      ),

                      SizedBox(height: 130.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
