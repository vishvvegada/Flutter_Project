import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blueAccent, Colors.lightBlueAccent.shade100],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: Duration(seconds: 2),
                  builder: (context, double value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.scale(
                        scale: value,
                        child: child,
                      ),
                    );
                  },
                  child: Image.asset(
                    'lib/assets/images/programer_doodle.jpg',
                    height: 100,
                    semanticLabel: 'Company Logo',
                  ),
                ),
              ),
              SizedBox(height: 20),

              _buildSectionTitle('Meet Our Team'),
              _buildInfoCard([
                _buildListTile(Icons.code, 'Developed by', 'Vegada Vishv (23010101295)'),
                _buildListTile(Icons.school, 'Mentored by', 'Prof. Mehul Bhundiya, Computer Engineering'),
                _buildListTile(Icons.explore, 'Explored by', 'ASWDC, School of Computer Science'),
                _buildListTile(Icons.location_city, 'Eulogized by', 'Darshan University, Rajkot, Gujarat - INDIA'),
              ]),
              SizedBox(height: 20),

              _buildSectionTitle('About ASWDC'),
              _buildInfoCard([
                Center(
                  child: Image.asset(
                    'lib/assets/images/aswdc_logo.png',
                    height: 100,
                    semanticLabel: 'ASWDC Logo',
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'ASWDC is the Application, Software, and Website Development Center at Darshan University. '
                        'It bridges the gap between university curriculum and industry demands by helping students '
                        'learn real-world skills under expert guidance.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                  ),
                ),
              ]),
              SizedBox(height: 20),

              _buildSectionTitle('Contact Us'),
              _buildInfoCard([
                _buildListTile(Icons.email, 'Email', 'aswdc@darshan.ac.in'),
                _buildListTile(Icons.phone, 'Phone', '+91-9727747317'),
                _buildListTile(Icons.language, 'Website', 'www.darshan.ac.in'),
              ]),
              SizedBox(height: 20),

              _buildSectionTitle('Options'),
              _buildInfoCard([
                _buildListTile(Icons.share, 'Share App', ''),
                _buildListTile(Icons.apps, 'More Apps', ''),
                _buildListTile(Icons.star, 'Rate Us', ''),
                _buildListTile(Icons.thumb_up, 'Like us on Facebook', ''),
                _buildListTile(Icons.update, 'Check For Update', ''),
              ]),
              SizedBox(height: 30),

              Center(
                child: Text(
                  '© 2025 Darshan University\nAll Rights Reserved - Privacy Policy\nMade with 🌟 in India',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(color: Colors.black26, offset: Offset(1, 1), blurRadius: 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, String subtitle) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.blueAccent, size: 30),
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: subtitle.isNotEmpty
              ? Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          )
              : null,
        ),
        Divider(color: Colors.blueAccent.shade100, thickness: 1),
      ],
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      shadowColor: Colors.blueAccent.shade100,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(children: children),
      ),
    );
  }
}
