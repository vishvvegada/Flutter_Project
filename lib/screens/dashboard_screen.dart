// dashboard_screen.dart
import 'package:flutter/material.dart';
import 'add_user_screen.dart';
import 'user_list_screen.dart';
import 'favorite_user_screen.dart';
import 'about_us_screen.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matrimony App'),
        centerTitle: true,
        backgroundColor: Color(0xFFEB4034),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDashboardButton(
                  context,
                  icon: Icons.person_add,
                  text: 'Add User',
                  screen: AddUserScreen(),
                  color: Color(0xFF32A897), // RGB(50, 168, 151)
                ),
                _buildDashboardButton(
                  context,
                  icon: Icons.list,
                  text: 'User List',
                  screen: UserListScreen(),
                  color: Colors.lime,
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDashboardButton(
                  context,
                  icon: Icons.favorite,
                  text: 'Favorite Users',
                  screen: FavoriteUserScreen(),
                  color: Colors.pink,
                ),
                _buildDashboardButton(
                  context,
                  icon: Icons.info,
                  text: 'About Us',
                  screen: AboutUsScreen(),
                  color: Colors.blueAccent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardButton(BuildContext context,
      {required IconData icon, required String text, required Widget screen, required Color color}) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: color, // Apply dynamic color here
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            SizedBox(height: 10),
            Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}