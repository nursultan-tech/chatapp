import 'package:flutter/material.dart';
import 'package:untitled2/services/auth/auth_services.dart';
import 'package:untitled2/components/my_button.dart';
import 'package:untitled2/components/my_textfield.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  //tap to go Login Page
  void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  //register method
  void register(BuildContext context) {
    final _auth = AuthServices();
    //password match create user
    if (_pwController.text == _confirmPwController.text){
      try{
        _auth.signUpWithEmailPassword(
          _emailController.text,
          _pwController.text,
        );
      }catch (e){
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }

    // dont match show error
    else{
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Password dont match! '),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //logo
              Icon(
                Icons.message,
                size: 60,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(
                height: 30,
              ),

              //welcome back message
              Text(
                "Let's create an account for you!",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),

              const SizedBox(
                height: 40,
              ),

              //email textfield
              MyTextField(
                hintText: 'Email',
                obscureText: false,
                controller: _emailController,
              ),
              const SizedBox(
                height: 10,
              ),
              //pw textfield
              MyTextField(
                hintText: 'Password',
                obscureText: true,
                controller: _pwController,
              ),
            const SizedBox(height: 15,),
              //confirm pw textfield
              MyTextField(
                hintText: 'Confirm Password',
                obscureText: true,
                controller: _confirmPwController,
              ),

              const SizedBox(
                height: 20,
              ),

              //login button
              MyButton(
                text: 'Register',
                onTap: ()=> register(context),
              ),

              const SizedBox(
                height: 20,
              ),

              //register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: const Text(
                      'Login now',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
