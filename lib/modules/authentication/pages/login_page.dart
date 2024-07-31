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
        body: Padding(
          padding: const EdgeInsets.only(left: 50, right: 50, top: 10),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/images/login.png'),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
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
                    controller: _passwordController,
                    decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
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
                        : TextButton(
                            onPressed: _login,
                            child: const Text(
                              'Sign In',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
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
