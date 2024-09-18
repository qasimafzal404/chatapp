// ignore_for_file: dead_code

import 'dart:io';
import 'package:chatapp/Services/alert_services.dart';
import 'package:chatapp/Services/database_service.dart';
import 'package:chatapp/Services/navigation_services.dart';
import 'package:chatapp/auth/auth_services.dart';
import 'package:chatapp/consts.dart';
import 'package:chatapp/models/user_profile.dart';
import 'package:chatapp/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../Services/media_services.dart';
import '../Services/storage_services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _registerFormKey =
      GlobalKey<FormState>(); // Correct key type

  final GetIt getit = GetIt.instance;
  late MediaServices _mediaServices;
  late NavigationService _navigationService;
  late AuthServices _authServices;
  late StorageServices _storageServices;
  late DatabaseService _databaseService;
  late AlertServices _alertServices;

  String? name, email, password;
  File? selectedImage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _mediaServices = getit.get<MediaServices>();
    _navigationService = getit.get<NavigationService>();
    _authServices = getit.get<AuthServices>();
    _storageServices = getit.get<StorageServices>();
    _databaseService = getit.get<DatabaseService>();
    _alertServices = getit.get<AlertServices>();
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
            if (!isLoading) _registerForm(),
            if (!isLoading) _loginAccountLink(),
            if (isLoading)
              const Expanded(
                  child: Center(
                child: CircularProgressIndicator(),
              )),
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
            "Let's get started!",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "Register an account using the form below",
            style:
                TextStyle(fontSize: 16, color: Color.fromARGB(255, 84, 82, 82)),
          ),
        ],
      ),
    );
  }

  Widget _registerForm() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.60,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * 0.05,
      ),
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _pfpSelectionField(),
            CustomFormField(
                hinttext: "Name",
                validationReGEx: NAME_VALIDATION_REGEX,
                onSaved: (value) {
                  name = value;
                }),
            CustomFormField(
                hinttext: "Email",
                validationReGEx: EMAIL_VALIDATION_REGEX,
                onSaved: (value) {
                  email = value; // Corrected from 'name'
                }),
            CustomFormField(
                hinttext: "Password",
                validationReGEx: PASSWORD_VALIDATION_REGEX,
                obscureText: true,
                onSaved: (value) {
                  password = value; // Corrected from 'name'
                }),
            _registerButton(),
          ],
        ),
      ),
    );
  }

  Widget _pfpSelectionField() {
    return GestureDetector(
      onTap: () async {
        File? file = await _mediaServices.getImageFromGallery();
        if (file != null) {
          setState(() {
            selectedImage = file;
          });
        }
      },
      child: CircleAvatar(
        radius: MediaQuery.of(context).size.width * 0.15,
        backgroundImage: selectedImage != null
            ? FileImage(selectedImage!)
            : NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
      ),
    );
  }

  Widget _registerButton() {
    return SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: MaterialButton(
          color: Theme.of(context).colorScheme.primary,
          onPressed: () async {
            setState(() {
              isLoading = true;
            });

            try {
              if ((_registerFormKey.currentState)?.validate() ??
                  false && selectedImage != null) {
                (_registerFormKey.currentState)?.save();

                bool result = await _authServices.signup(email!, password!);
                if (result) {
                  String? pfpURL = await _storageServices.uploadUserPfp(
                      file: selectedImage!, uid: (_authServices.user!())!.uid);

                  if (pfpURL != null) {
                    await _databaseService.createUserProfile(
                        userProfile: UserProfile(
                            uid: (_authServices.user!())!.uid,
                            name: name,
                            pfpURL: pfpURL));
                    _alertServices.showToast(
                        text: "You are registered successfully!",
                        icon: Icons.check);
                    _navigationService.goBack();
                    _navigationService.pushNamedReplacement("/Homepage");
                  } else {
                    throw Exception("Unable to upload user profile picture");
                  }
                } else {
                  throw Exception("Unable to register user");
                }
              }
            } catch (e) {
              print(e);
              _alertServices.showToast(
                  text: "Failed to Register, Please try again !",
                  icon: Icons.error);
            }
            setState(() {
              isLoading = false;
            });
          },
          child: const Text(
            "Register",
            style: TextStyle(color: Colors.white),
          ),
        ));
  }

  Widget _loginAccountLink() {
    return Expanded(
        child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "Already have an account?",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        GestureDetector(
          onTap: () => _navigationService.goBack(),
          child: Text(
            "Login",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    ));
  }
}
