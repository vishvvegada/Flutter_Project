import 'package:flutter/material.dart';
import '../services/api_service.dart';

class FavoriteUserScreen extends StatefulWidget {
  @override
  _FavoriteUserScreenState createState() => _FavoriteUserScreenState();
}

class _FavoriteUserScreenState extends State<FavoriteUserScreen> {
  List<Map<String, dynamic>> _favoriteUsers = [];
  bool isLoading = false; //  Added loading state

  @override
  void initState() {
    super.initState();
    _fetchFavoriteUsersFromAPI();
  }

  Future<void> _fetchFavoriteUsersFromAPI() async {
    setState(() => isLoading = true); // Show loading
    try {
      final users = await ApiService.fetchFavoriteUsers();
      setState(() {
        _favoriteUsers = users.where((user) => user['isFavorite'] == true).toList();
        isLoading = false; //  Hide loading
      });
    } catch (e) {
      setState(() => isLoading = false); //  Hide loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch favorite users: $e')),
      );
    }
  }

  Future<void> _toggleFavorite(String userId) async {
    try {
      bool newFavoriteStatus = false; // Unfavorite user
      await ApiService.updateUser(userId, {'isFavorite': newFavoriteStatus});
      setState(() {
        _favoriteUsers.removeWhere((user) => user['id'] == userId);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update favorite status: $e')),
      );
    }
  }

  void _showUserDetails(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(user['fullname'], style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _userInfoRow(Icons.email, "Email", user['email']),
              _userInfoRow(Icons.phone, "Phone", user['mobileNumber']),
              _userInfoRow(Icons.cake, "Date of Birth", user['dateOfBirth']),
              _userInfoRow(Icons.location_city, "City", user['city']),
              _userInfoRow(Icons.sports, "Hobbies", user['hobbies']),
              _userInfoRow(Icons.transgender, "Gender", user['gender']),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _toggleFavorite(user['id']);
                  },
                  icon: Icon(Icons.favorite, color: Colors.white),
                  label: Text("Unfavorite", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _userInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.pink),
          SizedBox(width: 10),
          Text("$title: ", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, style: TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Users'),
        backgroundColor: Colors.pink,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink.shade100, Colors.pink.shade300],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isLoading
            ? Center(child: CircularProgressIndicator()) //  Show loading indicator
            : _favoriteUsers.isEmpty
            ? Center(
          child: Text(
            "No Favorite Users",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        )
            : ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: _favoriteUsers.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _showUserDetails(_favoriteUsers[index]),
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 4,
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  leading: CircleAvatar(
                    backgroundColor: Colors.pink.shade200,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(
                    _favoriteUsers[index]['fullname'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(_favoriteUsers[index]['email']),
                  trailing: IconButton(
                    icon: Icon(Icons.favorite, color: Colors.pink),
                    onPressed: () => _toggleFavorite(_favoriteUsers[index]['id']),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
