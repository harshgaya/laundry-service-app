import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/authentication/controllers/login_controller.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final loginController = Get.put(LoginController());

  void _login() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      loginController.login(
          id: _usernameController.text,
          password: _passwordController.text,
          context: context);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/login.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 50, right: 50, top: 250),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    controller: _usernameController,
                    decoration: InputDecoration(
                        fillColor: const Color(0xFFA3A3A5),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              30.0), // Adjust the radius here
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              30.0), // Adjust the radius here
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              30.0), // Adjust the radius here
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 2.0),
                        ),
                        labelText: 'Username'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    controller: _passwordController,
                    decoration: InputDecoration(
                        fillColor: const Color(0xFFA3A3A5),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              30.0), // Adjust the radius here
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              30.0), // Adjust the radius here
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              30.0), // Adjust the radius here
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 2.0),
                        ),
                        labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Obx(
                    () => loginController.loginLoading.value
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFA0D4BE)),
                            onPressed: _login,
                            child: const Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
