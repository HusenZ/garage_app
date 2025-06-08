import 'package:flutter/material.dart';
import 'package:garage_app/presentation/screens/garage_home_screen.dart';
import 'package:garage_app/presentation/screens/register_garage_screen.dart';
import 'package:garage_app/utils/firebase_auth_service.dart';

class LoginGarageScreen extends StatefulWidget {
  const LoginGarageScreen({super.key});

  @override
  State<LoginGarageScreen> createState() => _LoginGarageScreenState();
}

class _LoginGarageScreenState extends State<LoginGarageScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final result = await AuthService().loginGarageUser(
        email: _email.text.trim(),
        password: _password.text.trim(),
      );

      setState(() => _isLoading = false);

      if (result == 'success') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Login successful!")));
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => GarageHomeScreen()));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(height: 10),
                Text(
                  "Login to your account",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 30),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Email Address",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Email required';
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value))
                      return 'Enter a valid email';
                    return null;
                  },
                ),
                SizedBox(height: 16),

                TextFormField(
                  controller: _password,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator:
                      (value) => value!.isEmpty ? 'Password required' : null,
                ),
                SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged:
                              (val) => setState(() => _rememberMe = val!),
                        ),
                        Text("Remember me"),
                      ],
                    ),
                    TextButton(
                      onPressed:
                          () =>
                              Navigator.pushNamed(context, '/forgot-password'),
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.green.shade900),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child:
                        _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text("Sign up with email"),
                  ),
                ),

                Center(
                  child: TextButton(
                    onPressed:
                        () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RegisterGarageScreen(),
                          ),
                        ),
                    child: Text.rich(
                      TextSpan(
                        text: "Don’t have an account? ",
                        children: [
                          TextSpan(
                            text: "Get Started",
                            style: TextStyle(
                              color: Colors.green.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
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
