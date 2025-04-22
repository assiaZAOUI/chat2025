import 'package:flutter/material.dart';

class PasswordScreen extends StatefulWidget {
  final Function(int) onChangedStep;
  const PasswordScreen({Key? key, required this.onChangedStep})
    : super(key: key);

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  //le stateLessWidget a pas la capacite de changer l'etat d'une variable dans mon element
  bool _isSecret = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _password = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => {widget.onChangedStep(0)},
          ),
        ),
        body: Center(
          //difference SingleChildScrollView et ListView
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: "Password\n".toUpperCase(),
                    style: TextStyle(color: Colors.black, fontSize: 40.0),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    //stretch : permet de la colonne de prendre  toute la place disponible de mon ecran
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Entrer your password'),
                      SizedBox(height: 5.0),
                      TextFormField(
                        onChanged:
                            (value) => setState(() {
                              _password = value;
                            }),
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return 'Enter a password. 6 characters min required';
                          }
                          return null;
                        },
                        obscureText: _isSecret,
                        decoration: InputDecoration(
                          suffixIcon: InkWell(
                            onTap: () => setState(() => _isSecret = !_isSecret),
                            child: Icon(
                              !_isSecret
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          hintText: 'Ex: AoF54g',
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
                              _password.length >= 6
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        onPressed:
                            _password.length >= 6
                                ? () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    print(_password);
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
