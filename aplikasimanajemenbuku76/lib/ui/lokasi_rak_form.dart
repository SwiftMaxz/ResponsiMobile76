import 'package:flutter/material.dart';
import '/model/lokasi_rak.dart';
import '/bloc/lokasi_rak_bloc.dart'; // Ensure to import your bloc

class LokasiRakForm extends StatefulWidget {
  final LokasiRak? lokasiRak; // Accepting an optional LokasiRak for editing

  const LokasiRakForm({Key? key, this.lokasiRak}) : super(key: key);

  @override
  _LokasiRakFormState createState() => _LokasiRakFormState();
}

class _LokasiRakFormState extends State<LokasiRakForm> {
  final _formKey = GlobalKey<FormState>();
  final _shelfNumberController = TextEditingController();
  final _aisleLetterController = TextEditingController();
  final _floorLevelController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    // Initialize the form fields if we're editing an existing location
    if (widget.lokasiRak != null) {
      _shelfNumberController.text = widget.lokasiRak!.shelfNumber.toString();
      _aisleLetterController.text = widget.lokasiRak!.aisleLetter;
      _floorLevelController.text = widget.lokasiRak!.floorLevel.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.lokasiRak != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Lokasi Rak' : 'Tambah Lokasi Rak'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 129, 213, 234), Color.fromARGB(255, 127, 224, 208)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                controller: _shelfNumberController,
                label: 'Shelf Number',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _aisleLetterController,
                label: 'Aisle Letter',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _floorLevelController,
                label: 'Floor Level',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 30),
              _buildSubmitButton(isEdit),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(
            color: Color(0xFFFF8AAE),
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 243, 88, 124),
            width: 2.0,
          ),
        ),
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton(bool isEdit) {
    return SizedBox(
      width: double.infinity, // Full width button
      height: 70,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            LokasiRak newLokasiRak = LokasiRak(
              shelfNumber: int.tryParse(_shelfNumberController.text) ?? 0,
              aisleLetter: _aisleLetterController.text,
              floorLevel: int.tryParse(_floorLevelController.text) ?? 0,
            );

            bool result;
              if (isEdit) {
                // Include the ID of the location rack if we're editing
                newLokasiRak.id = widget.lokasiRak!.id;
                result = await LokasiRakBloc.updateLokasiRak(lokasiRak: newLokasiRak);
              } else {
                result = await LokasiRakBloc.addLokasiRak(lokasiRak: newLokasiRak);
              }

              if (result) {
                Navigator.pop(context, true); // Return true on success
              } else {
                _showErrorDialog('Failed to submit the data. Please try again.');
              }
          }
        },
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF9ADCFF), Color(0xFFFF8AAE)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Center(
            child: Text(
              isEdit ? 'Update' : 'Submit',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
