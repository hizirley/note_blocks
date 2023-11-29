import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // header
              const DrawerHeader(
                child: Icon(
                  Icons.note_alt_outlined,
                  color: Colors.grey,
                  size: 64,
                ),
              ),

              //home list tile
              Text(
                "C O N T A C T ",
                style: TextStyle(color: Colors.grey[300]),
              ),
              SizedBox(height: 16),

              Text(
                "TO DO",
                style: TextStyle(color: Colors.grey[300]),
              ),
              SizedBox(height: 16),
              //profile list tile
              Text(
                "F O L D E R S",
                style: TextStyle(color: Colors.grey[300]),
              ),
            ],
          ),
          //logout list tile
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Metinleri dikeyde ortalar
              children: [
                Text(
                  "N O T E  B L O C K ",
                  style: TextStyle(color: Colors.grey[300]),
                ),
                SizedBox(height: 5),
                Text(
                  "v1.0",
                  style: TextStyle(color: Colors.grey[300]),
                ),
                Text("HIZIRLEY",
                    style: TextStyle(color: Colors.grey[300], fontSize: 10))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
