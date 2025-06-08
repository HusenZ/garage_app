import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterVehicleScreen extends StatefulWidget {
  final String vehicleType; // "Car" or "Bike"

  const RegisterVehicleScreen({super.key, required this.vehicleType});

  @override
  State<RegisterVehicleScreen> createState() => _RegisterVehicleScreenState();
}

class _RegisterVehicleScreenState extends State<RegisterVehicleScreen> {
  String? selectedType;
  String? selectedBrand;
  String? selectedModel;
  bool isLoading = false;

  final carTypes = ["Sedan", "SUV", "Hatchback", "Convertible"];
  final bikeTypes = ["Scooter", "Cruiser", "Sport", "Commuter"];

  final carBrands = {
    "Sedan": ["Honda City", "Hyundai Verna", "Skoda Slavia"],
    "SUV": ["Toyota Fortuner", "Hyundai Creta", "Tata Harrier"],
    "Hatchback": ["Maruti Swift", "Hyundai i20", "Tata Altroz"],
    "Convertible": ["BMW Z4", "Mercedes C-Class", "Mini Cooper"],
  };

  final bikeBrands = {
    "Scooter": ["Honda Activa", "TVS Jupiter", "Suzuki Access"],
    "Cruiser": ["Royal Enfield Classic 350", "Jawa 42", "Honda H’ness CB350"],
    "Sport": ["KTM RC 200", "Yamaha R15", "TVS Apache RR310"],
    "Commuter": ["Bajaj Platina", "Hero Splendor", "TVS Radeon"],
  };

  List<String> getTypes() => widget.vehicleType == "Car" ? carTypes : bikeTypes;

  List<String> getModels() {
    final map = widget.vehicleType == "Car" ? carBrands : bikeBrands;
    return map[selectedType] ?? [];
  }

  void selectBrand() {
    final brands = getModels();
    showModalBottomSheet(
      context: context,
      builder:
          (_) => _SelectionSheet(
            title: "Select Brand",
            options: brands,
            onSelected: (value) {
              setState(() {
                selectedBrand = value;
                selectedModel = null;
              });
              Navigator.pop(context);
            },
          ),
    );
  }

  void selectModel() {
    final models = getModels();
    showModalBottomSheet(
      context: context,
      builder:
          (_) => _SelectionSheet(
            title: "Select Model",
            options: models,
            onSelected: (value) {
              setState(() {
                selectedModel = value;
              });
              Navigator.pop(context);
            },
          ),
    );
  }

  Future<void> saveVehicleData() async {
    if (selectedType == null ||
        selectedBrand == null ||
        selectedModel == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    setState(() => isLoading = true);

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception("User not logged in");

      final vehicleData = {
        'vehicleType': widget.vehicleType,
        'categoryType': selectedType,
        'brand': selectedBrand,
        'model': selectedModel,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('vehicle')
          .add(vehicleData);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Vehicle Registered")));

      Navigator.pop(context); // or navigate to another screen
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/bgimage.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 25.h),
                    Text(
                      'Register your Vehicle',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Type Dropdown
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: _inputDecoration(
                        '${widget.vehicleType}-Type',
                      ),
                      items:
                          getTypes().map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedType = value;
                          selectedBrand = null;
                          selectedModel = null;
                        });
                      },
                    ),
                    const SizedBox(height: 15),

                    // Brand
                    GestureDetector(
                      onTap: selectedType != null ? selectBrand : null,
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: _inputDecoration('Select Brand').copyWith(
                            suffixIcon: const Icon(
                              Icons.arrow_forward_ios_rounded,
                            ),
                          ),
                          controller: TextEditingController(
                            text: selectedBrand ?? "",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Model
                    GestureDetector(
                      onTap:
                          selectedType != null && selectedBrand != null
                              ? selectModel
                              : null,
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: _inputDecoration('Select Model').copyWith(
                            suffixIcon: const Icon(
                              Icons.arrow_forward_ios_rounded,
                            ),
                          ),
                          controller: TextEditingController(
                            text: selectedModel ?? "",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Continue Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : saveVehicleData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child:
                            isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text("CONTINUE"),
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

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Colors.grey.shade400),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
  );
}

/// Bottom sheet for selection
class _SelectionSheet extends StatelessWidget {
  final String title;
  final List<String> options;
  final Function(String) onSelected;

  const _SelectionSheet({
    required this.title,
    required this.options,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...options.map(
            (e) => ListTile(title: Text(e), onTap: () => onSelected(e)),
          ),
        ],
      ),
    );
  }
}
