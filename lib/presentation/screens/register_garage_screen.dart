import 'package:flutter/material.dart';
import 'package:garage_app/core/all_services_c.dart';
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
  final TextEditingController _garageName = TextEditingController();
  final TextEditingController _garagePhone = TextEditingController();
  final TextEditingController _garageAddress = TextEditingController();

  String _garageType = 'CAR';
  final List<String> _selectedServices = [];
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

      if (_selectedServices.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You must select atleast one service.')),
        );
        return;
      }

      setState(() => _isLoading = true);

      final result = await AuthService().registerGarage(
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        email: _email.text.trim(),
        password: _password.text.trim(),
        garageName: _garageName.text.trim(),
        garagePhone: _garagePhone.text.trim(),
        garageAddress: _garageAddress.text.trim(),
        garageType: _garageType,
        services: _selectedServices,
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
                Text(
                  "Garage Details",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2.h),

                TextFormField(
                  controller: _garageName,
                  decoration: InputDecoration(
                    hintText: "Garage Name",
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) => value!.isEmpty ? 'Garage name required' : null,
                ),
                SizedBox(height: 2.h),

                TextFormField(
                  controller: _garagePhone,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "Garage Phone",
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value!.isEmpty ? 'Garage phone required' : null,
                ),
                SizedBox(height: 2.h),

                TextFormField(
                  controller: _garageAddress,
                  decoration: InputDecoration(
                    hintText: "Garage Address",
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value!.isEmpty ? 'Garage address required' : null,
                ),
                SizedBox(height: 2.h),

                DropdownButtonFormField<String>(
                  value: _garageType,
                  items:
                      ['CAR', 'BIKE'].map((type) {
                        return DropdownMenuItem(value: type, child: Text(type));
                      }).toList(),
                  onChanged: (val) => setState(() => _garageType = val!),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Garage Type",
                  ),
                ),
                SizedBox(height: 2.h),

                Text(
                  "Select Services Offered",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      allServices.map((service) {
                        final title = service['title']!;
                        final isSelected = _selectedServices.contains(title);
                        return FilterChip(
                          label: Text(title),
                          selected: isSelected,
                          onSelected: (val) {
                            setState(() {
                              isSelected
                                  ? _selectedServices.remove(title)
                                  : _selectedServices.add(title);
                            });
                          },
                        );
                      }).toList(),
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
