import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.settings), tooltip: 'Settings'),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Card.outlined(
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      child: Text('User Name'),
                      backgroundColor: Colors.orange.shade50,
                      foregroundColor: Colors.orange,
                    ),
                    title: Row(
                      children: [
                        Text('Nombre Usuario', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}