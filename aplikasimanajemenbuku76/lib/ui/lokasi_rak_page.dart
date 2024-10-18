import 'package:flutter/material.dart';
import '/model/lokasi_rak.dart';
import '/bloc/lokasi_rak_bloc.dart';
import '/ui/lokasi_rak_form.dart';
import '/bloc/logout_bloc.dart'; // Import the LogoutBloc

class LokasiRakPage extends StatefulWidget {
  const LokasiRakPage({Key? key}) : super(key: key);

  @override
  _LokasiRakPageState createState() => _LokasiRakPageState();
}

class _LokasiRakPageState extends State<LokasiRakPage> {
  List<LokasiRak> lokasiRakList = [];

  @override
  void initState() {
    super.initState();
    _fetchLokasiRak();
  }

  Future<void> _fetchLokasiRak() async {
    final List<LokasiRak>? fetchedRak = await LokasiRakBloc.getLokasiRaks();
    if (fetchedRak != null) {
      setState(() {
        lokasiRakList = fetchedRak;
      });
    }
  }

  Future<void> _deleteRak(int id) async {
    bool confirmed = await _confirmDelete(context);
    if (confirmed) {
      bool result = await LokasiRakBloc.deleteLokasiRak(id: id);
      if (result) {
        // Refresh the list after successful delete
        _fetchLokasiRak();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Rak deleted successfully')),
        );
      } else {
        _showErrorDialog('Failed to delete the Rak. Please try again.');
      }
    }
  }

  Future<void> _logout() async {
    bool confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Logout'),
        content: Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // User cancels logout
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // User confirms logout
            child: Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await LogoutBloc.logout();
      Navigator.pushReplacementNamed(context, '/login'); // Redirect to login page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lokasi Rak List'),
        backgroundColor: const Color(0xFF9ADCFF),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout, // Use the _logout method to handle logout
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: lokasiRakList.length,
        itemBuilder: (context, index) {
          final lokasiRak = lokasiRakList[index];
          return ListTile(
            title: Text('Shelf: ${lokasiRak.shelfNumber} - Aisle: ${lokasiRak.aisleLetter}'),
            subtitle: Text('Floor: ${lokasiRak.floorLevel}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () async {
                    // Navigate to the LokasiRakForm for editing
                    bool result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LokasiRakForm(lokasiRak: lokasiRak),
                      ),
                    );
                    if (result == true) {
                      _fetchLokasiRak(); // Refresh list on edit success
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Confirm delete and remove the item
                    _deleteRak(lokasiRak.id!);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Add new Rak
          bool result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LokasiRakForm()),
          );
          if (result == true) {
            _fetchLokasiRak(); // Refresh list on new Rak creation
          }
        },
        child: Icon(Icons.add),
        backgroundColor: const Color(0xFF9ADCFF),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this Rak?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
