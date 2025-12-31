import 'package:flutter/material.dart';
import 'user_detail_screen.dart';
import '../services/api_service.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<Map<String, dynamic>> _users = [];
  final _searchController = TextEditingController();
  bool _isAscending = true;
  bool isLoading = false; // ✅ Added loading state

  @override
  void initState() {
    super.initState();
    _fetchUsersFromAPI();

  }

  Future<void> _fetchUsersFromAPI() async {
    setState(() => isLoading = true); // ✅ Show loading
    try {
      final users = await ApiService.fetchUsers();
      setState(() {
        _users = users;
        _sortUsers();
        isLoading = false; // ✅ Hide loading
      });
    } catch (e) {
      setState(() => isLoading = false); // ✅ Hide loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch users: $e')),
      );
    }
  }

  void _sortUsers() {
    setState(() {
      _users.sort((a, b) {
        return _isAscending
            ? a['fullname'].compareTo(b['fullname'])
            : b['fullname'].compareTo(a['fullname']);
      });
    });
  }

  // ✅ Remove user from the list
  void _removeUserFromList(String userId) {
    setState(() {
      _users.removeWhere((user) => user['id'] == userId);
    });
  }

  // ✅ Update user in the list
  void _updateUserInList(String userId, Map<String, dynamic> updatedUser) {
    setState(() {
      int index = _users.indexWhere((user) => user['id'] == userId);
      if (index != -1) {
        _users[index] = updatedUser;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
        backgroundColor: Colors.lime,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _isAscending = value == 'A-Z';
                _sortUsers();
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'A-Z', child: Text('Sort A-Z')),
              PopupMenuItem(value: 'Z-A', child: Text('Sort Z-A')),
            ],
            icon: Icon(Icons.sort, color: Colors.black),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Users...',
                filled: true,
                fillColor: Colors.lime[100],
                prefixIcon: Icon(Icons.search, color: Colors.black),
                suffixIcon: IconButton(
                  icon: Icon(Icons.close, color: Colors.black),
                  onPressed: () {
                    _searchController.clear();
                    _fetchUsersFromAPI();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  _fetchUsersFromAPI();
                } else {
                  setState(() {
                    _users = _users
                        .where((user) => user['fullname'].toLowerCase().contains(value.toLowerCase()))
                        .toList();
                  });
                }
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator()) // ✅ Show loading indicator
                : _users.isEmpty
                ? Center(
              child: Text(
                'No users found!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.orange,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    leading: CircleAvatar(
                      backgroundColor: Colors.lime,
                      child: Text(
                        _users[index]['fullname'][0].toUpperCase(),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    title: Text(
                      _users[index]['fullname'],
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    subtitle: Text(
                      _users[index]['email'],
                      style: TextStyle(color: Colors.black87),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
                    onTap: () async {
                      final updatedUser = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailScreen(
                            user: _users[index],
                            onUserUpdated: _updateUserInList,
                            onUserDeleted: _removeUserFromList,
                          ),
                        ),
                      );

                      if (updatedUser != null) {
                        _updateUserInList(updatedUser['id'], updatedUser);
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
