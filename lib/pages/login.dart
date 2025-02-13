import 'package:flutter/material.dart';
import 'package:practise/pages/signUp.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = true;
  bool _isLoading = false;
  String? _bodyError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 70),
              const Text(
                "ADMIN LOGIN - BIET",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _emailInput(),
                    const SizedBox(height: 20),
                    _passwordInput(),
                    const SizedBox(height: 20),
                    if (_bodyError != null)
                      Text(
                        _bodyError!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        // Navigate to Signin Password Screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUp()),
                        );
                      },
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't  Have Account ?",
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "SignUp",
                              style: TextStyle(
                                color: Colors.amber,
                              ),
                            ),
                          ]),
                    ),
                    const SizedBox(height: 35),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _onClick,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15.0),
                        shape: const CircleBorder(),
                        backgroundColor: Colors.green,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Icon(
                              Icons.arrow_forward,
                              size: 35.0,
                              color: Colors.white,
                            ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        // Navigate to Forgot Password Screen
                      },
                      child: const Text(
                        "Forgot Password ?",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emailInput() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: "Email",
        hintText: "e.g. abc@gmail.com",
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email Required';
        } else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+').hasMatch(value)) {
          return 'Enter Valid Email';
        }
        return null;
      },
    );
  }

  Widget _passwordInput() {
    return TextFormField(
      controller: _passwordController,
      keyboardType: TextInputType.text,
      obscureText: _showPassword,
      decoration: InputDecoration(
        labelText: "Password",
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _showPassword = !_showPassword;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password Required';
        } else if (!RegExp(
                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\\$&*~]).{8,12}$')
            .hasMatch(value)) {
          return 'Password must contain at least 8 characters, including upper/lowercase letters, numbers, and special characters, and be between 8 and 12 characters.';
        }
        return null;
      },
    );
  }

  void _onClick() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      // Simulate a network request or logic for sign in
      await Future.delayed(const Duration(seconds: 2));

      setState(() => _isLoading = false);
    }
  }
}
