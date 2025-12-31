import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart'; // Import ApiService

class AddUserScreen extends StatefulWidget {
  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _hobbiesController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _selectedGender;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
        backgroundColor: Color(0xFF32A897),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(_fullnameController, 'Full Name', Icons.person, isRequired: true),
              _buildTextField(_emailController, 'Email (Gmail Only)', Icons.email, isEmail: true, isRequired: true),
              _buildTextField(_mobileNumberController, 'Mobile Number', Icons.phone, isPhone: true, isRequired: true),
              TextFormField(
                controller: _dateOfBirthController,
                readOnly: true,
                decoration: _inputDecoration('Date of Birth', Icons.calendar_today),
                onTap: () => _selectDate(context),
                validator: (value) => value!.isEmpty ? 'Please select date of birth' : null,
              ),
              SizedBox(height: 15),
              _buildTextField(_cityController, 'City', Icons.location_city, isRequired: true),
              _buildTextField(_hobbiesController, 'Hobbies', Icons.sports_esports, isRequired: true),
              DropdownButtonFormField<String>(
                decoration: _inputDecoration('Gender', Icons.transgender),
                value: _selectedGender,
                items: ['Male', 'Female', 'Other'].map((gender) {
                  return DropdownMenuItem(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                validator: (value) => value == null ? 'Please select gender' : null,
              ),
              SizedBox(height: 15),
              _buildPasswordField(_passwordController, 'Password', isConfirm: false),
              _buildPasswordField(_confirmPasswordController, 'Confirm Password', isConfirm: true),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF54272),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Submit', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isEmail = false, bool isPhone = false, bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isPhone ? TextInputType.number : isEmail ? TextInputType.emailAddress : TextInputType.text,
        inputFormatters: isPhone ? [FilteringTextInputFormatter.digitsOnly] : [],
        maxLength: isPhone ? 10 : null,
        decoration: _inputDecoration(label, icon),
        validator: (value) {
          if (isRequired && (value == null || value.isEmpty)) return 'Please enter $label';
          if (isEmail && !RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$').hasMatch(value!)) {
            return 'Enter a valid Gmail address (example@gmail.com)';
          }
          if (isPhone && !RegExp(r'^\d{10}$').hasMatch(value!)) {
            return 'Enter a valid 10-digit mobile number';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label, {required bool isConfirm}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isConfirm ? !_isConfirmPasswordVisible : !_isPasswordVisible,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(Icons.lock, color: Color(0xFF32A897)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              isConfirm
                  ? (_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off)
                  : (_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
              color: Colors.grey.withOpacity(0.7),
            ),
            onPressed: () {
              setState(() {
                if (isConfirm) {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                } else {
                  _isPasswordVisible = !_isPasswordVisible;
                }
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please enter $label';
          if (label == 'Confirm Password' && value != _passwordController.text) {
            return 'Passwords do not match';
          }
          return null;
        },
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Color(0xFF32A897)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> user = {
        'fullname': _fullnameController.text, // FIXED
        'email': _emailController.text,
        'mobileNumber': _mobileNumberController.text,
        'dateOfBirth': _dateOfBirthController.text,
        'city': _cityController.text,
        'gender': _selectedGender,
        'hobbies': _hobbiesController.text,
        'isFavorite': false, // FIXED: Use boolean instead of 0/1
      };

      try {
        await ApiService.addUser(user);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User added successfully!')));
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add user: $e')));
      }
    }
  }
}
