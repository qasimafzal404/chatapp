import 'package:chatapp/auth/auth_services.dart';
import 'package:chatapp/consts.dart';
import 'package:chatapp/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GetIt getIt = GetIt.instance;
  final GlobalKey _loginKey = GlobalKey<FormState>();

  late AuthServices _authServices;

  String? email,password;

@override
  void initState() {
  super.initState();
  _authServices = GetIt.instance<AuthServices>();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          children: [
            _headerText(),
            _loginpage(),
            _createAccountLink(),
          ],
        ),
      ),
    );
  }

  Widget _headerText() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: const Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hi , Welcome Back',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            'Login to your account',
            style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 84, 82, 82)),
          ),
        ],
      ),
    );
  }

  Widget _loginpage() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.40,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * 0.05,
      ),
      child: Form(
          key: _loginKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomFormField(
                  hinttext: "Email", validationReGEx: EMAIL_VALIDATION_REGEX,
                  onSaved:(value){
                    setState(() {
                      email = value;
                    });
                  } ,
                  ),
              const SizedBox(
                height: 40,
              ),
              CustomFormField(
                hinttext: "Password",
                validationReGEx: PASSWORD_VALIDATION_REGEX,
                obscureText: true,
                 onSaved:(value){
                    setState(() {
                      password = value;
                    });
                  } ,
              ),
              const SizedBox(
                height: 40,
              ),
              _loginButton(),
            ],
          )),
    );
  }

  Widget _loginButton() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: MaterialButton(
          onPressed: () async {
           if ((_loginKey.currentState as FormState?)?.validate() ?? false) {
            (_loginKey.currentState as FormState?)?.save();

            bool result = await _authServices.login(email!, password!);
            print(
              'true'
            );
            if(result){

            }else {

            }


           }
          },
          color: Theme.of(context).primaryColor,
          child: const Text(
            'Login',
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  Widget _createAccountLink() {
    return Expanded(
        child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "Don't have an account?",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        Text(
          "Signup",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ],
    ));
  }
}
