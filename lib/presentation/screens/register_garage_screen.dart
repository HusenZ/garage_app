import 'package:flutter/material.dart';
import 'package:garage_app/presentation/screens/garage_home_screen.dart';
import 'package:garage_app/utils/firebase_auth_service.dart';
import 'package:sizer/sizer.dart';

class RegisterGarageScreen extends StatefulWidget {
  const RegisterGarageScreen({super.key});

  @override
  State<RegisterGarageScreen> createState() => _RegisterGarageScreenState();
}

class _RegisterGarageScreenState extends State<RegisterGarageScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _obscurePassword = true;
  bool _agreed = false;
  bool _isLoading = false;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      if (!_agreed) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('You must agree to the terms.')));
        return;
      }

      setState(() => _isLoading = true);

      final result = await AuthService().registerGarage(
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        email: _email.text.trim(),
        password: _password.text.trim(),
      );

      setState(() => _isLoading = false);

      if (result == 'success') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Registered successfully!')));
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
                SizedBox(height: 3.h),
                Text(
                  "Create your ID",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 3.h),

                TextFormField(
                  controller: _firstName,
                  decoration: InputDecoration(
                    hintText: "First name",
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) => value!.isEmpty ? 'First name required' : null,
                ),
                SizedBox(height: 3.h),

                TextFormField(
                  controller: _lastName,
                  decoration: InputDecoration(
                    hintText: "Last name",
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) => value!.isEmpty ? 'Last name required' : null,
                ),
                SizedBox(height: 3.h),

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
                      return 'Enter valid email';
                    return null;
                  },
                ),
                SizedBox(height: 3.h),

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
                      (value) =>
                          value == null || value.length < 6
                              ? 'Min 6 characters'
                              : null,
                ),
                SizedBox(height: 3.h),

                CheckboxListTile(
                  value: _agreed,
                  onChanged: (val) => setState(() => _agreed = val!),
                  title: Text.rich(
                    TextSpan(
                      text: "You agree to the ",
                      children: [
                        TextSpan(
                          text: "Terms and Conditions",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
