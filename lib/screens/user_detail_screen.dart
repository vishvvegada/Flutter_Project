import 'package:flutter/material.dart';
import '../services/api_service.dart';

class UserDetailScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  final Function(String, Map<String, dynamic>) onUserUpdated;
  final Function(String) onUserDeleted;

  UserDetailScreen({required this.user, required this.onUserUpdated, required this.onUserDeleted});

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late Map<String, dynamic> user;
  bool isLoading = false;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    user = Map<String, dynamic>.from(widget.user);
  }

  // Show delete confirmation dialog
  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete User"),
          content: Text("Are you sure you want to delete this user?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Delete"),
              onPressed: isLoading
                  ? null
                  : () async {
                setState(() => isLoading = true);
                String userId = user['id'].toString();
                bool success = await ApiService.deleteUser(userId);
                setState(() => isLoading = false);

                if (success) {
                  widget.onUserDeleted(userId);
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Close details screen
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete user')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Show edit user dialog
  void _editUserDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController(text: user['fullname']);
    TextEditingController emailController = TextEditingController(text: user['email']);
    TextEditingController mobileController = TextEditingController(text: user['mobileNumber']);
    TextEditingController dobController = TextEditingController(text: user['dateOfBirth']);
    TextEditingController cityController = TextEditingController(text: user['city']);
    TextEditingController hobbiesController = TextEditingController(text: user['hobbies']);
    String? selectedGender = user['gender'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text("Edit User"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildEditField("Full Name", nameController),
                    _buildEditField("Email", emailController),
                    _buildEditField("Mobile Number", mobileController, isNumber: true),
                    _buildEditField("Date of Birth", dobController, isDate: true),
                    _buildEditField("City", cityController),
                    _buildEditField("Hobbies", hobbiesController),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: "Gender", border: OutlineInputBorder()),
                      value: selectedGender,
                      items: ['Male', 'Female', 'Other'].map((gender) {
                        return DropdownMenuItem(value: gender, child: Text(gender));
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() => selectedGender = value);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(child: Text("Cancel"), onPressed: () => Navigator.pop(context)),
                ElevatedButton(
                  child: isUpdating
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Update"),
                  onPressed: isUpdating
                      ? null
                      : () async {
                    setDialogState(() => isUpdating = true);
                    String userId = user['id'].toString();
                    Map<String, dynamic> updatedData = {
                      'fullname': nameController.text,
                      'email': emailController.text,
                      'mobileNumber': mobileController.text,
                      'dateOfBirth': dobController.text,
                      'city': cityController.text,
                      'hobbies': hobbiesController.text,
                      'gender': selectedGender,
                    };

                    bool apiSuccess = await _updateUserInAPI(userId, updatedData);
                    if (apiSuccess) {
                      setState(() {
                        user = {...user, ...updatedData};
                      });
                      widget.onUserUpdated(userId, user);
                      Navigator.pop(context);
                    }
                    setDialogState(() => isUpdating = false);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Toggle favorite status
  void _toggleFavorite() async {
    setState(() => isLoading = true);
    String userId = user['id'].toString();
    bool newFavoriteStatus = !(user['isFavorite'] ?? false);
    bool apiSuccess = await _updateUserInAPI(userId, {'isFavorite': newFavoriteStatus});
    if (apiSuccess) {
      setState(() {
        user['isFavorite'] = newFavoriteStatus;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<bool> _updateUserInAPI(String userId, Map<String, dynamic> updatedData) async {
    try {
      final response = await ApiService.updateUser(userId, updatedData);
      return response != null;
    } catch (e) {
      print("Error updating user: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
        backgroundColor: Colors.lime,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Colors.orange,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserDetailItem("Full Name", user['fullname'] ?? 'N/A'),
                _buildUserDetailItem("Email", user['email'] ?? 'N/A'),
                _buildUserDetailItem("Mobile Number", user['mobileNumber'] ?? 'N/A'),
                _buildUserDetailItem("Date of Birth", user['dateOfBirth'] ?? 'N/A'),
                _buildUserDetailItem("City", user['city'] ?? 'N/A'),
                _buildUserDetailItem("Hobbies", user['hobbies'] ?? 'N/A'),
                _buildUserDetailItem("Gender", user['gender'] ?? 'N/A'),
                SizedBox(height: 20),
                _buildBigButton(Icons.edit, "Edit", Colors.blue, () => _editUserDialog(context)),
                SizedBox(height: 10),
                _buildBigButton(Icons.delete, "Delete", Colors.red, _showDeleteConfirmationDialog),
                SizedBox(height: 10),
                _buildBigButton(
                  user['isFavorite'] == true ? Icons.favorite : Icons.favorite_border,
                  "Favorite",
                  user['isFavorite'] == true ? Colors.pink : Colors.grey,
                  _toggleFavorite,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildEditField(String label, TextEditingController controller, {bool isNumber = false, bool isDate = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        readOnly: isDate,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          suffixIcon: isDate
              ? IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );

              if (pickedDate != null) {
                controller.text = "${pickedDate.toLocal()}".split(' ')[0];
              }
            },
          )
              : null,
        ),
      ),
    );
  }
  Widget _buildBigButton(IconData icon, String label, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: isLoading && label == "Update"
            ? CircularProgressIndicator(color: Colors.white)
            : Text(label, style: TextStyle(fontSize: 18)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
  Widget _buildUserDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text("$label: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
