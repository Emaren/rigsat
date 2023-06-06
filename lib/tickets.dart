import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/controllers/simple_hidden_drawer_controller.dart';

import 'toggle_table_cell.dart';

class Tickets extends StatefulWidget {
  const Tickets({Key? key}) : super(key: key);

  @override
  TicketsState createState() => TicketsState();
}

class TicketsState extends State<Tickets> {
  final _formKey = GlobalKey<FormState>();

  InputDecoration _customInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 65, 33, 243),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //     appBar: AppBar(
      //       title: Text('Tickets'),
      // ),
      // drawer: Hidden_Drawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('assets/RigSat.jpg', width: 190, height: 90),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Field Tech')),
                            TextFormField(
                                decoration:
                                    const InputDecoration(labelText: 'Date')),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 10),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Company')),
                            TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Address')),
                            TextFormField(
                                decoration:
                                    const InputDecoration(labelText: '')),
                            TextFormField(
                                decoration:
                                    const InputDecoration(labelText: 'City')),
                            TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Contact')),
                            TextFormField(
                                decoration:
                                    const InputDecoration(labelText: 'Phone')),
                          ],
                        ),
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Well Name')),
                            TextFormField(
                                decoration:
                                    const InputDecoration(labelText: 'LSD')),
                            TextFormField(
                                decoration:
                                    const InputDecoration(labelText: 'Rig')),
                            TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Foreman')),
                            TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Phone #')),
                            TextFormField(
                                decoration:
                                    const InputDecoration(labelText: 'AFE #')),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Table(
                    border: TableBorder.all(color: Colors.black),
                    columnWidths: const {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(1),
                      3: FlexColumnWidth(1),
                      4: FlexColumnWidth(1),
                    },
                    children: [
                      // Add TableRow widgets here to build the grid rows
                      const TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Center(
                                child: Text('IN/OUT',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Center(
                                child: Text('Assets',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Center(
                                child: Text('Units',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Center(
                                child: Text('Unit Price',
                                    style: TextStyle(
                                        fontSize: 13.7,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Center(
                                child: Text('Extended',
                                    style: TextStyle(
                                        fontSize: 13.7,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ],
                      ),

                      TableRow(
                        children: [
                          const ToggleTableCell(),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const ToggleTableCell(),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const ToggleTableCell(),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const ToggleTableCell(),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const ToggleTableCell(),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const ToggleTableCell(),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const ToggleTableCell(),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const ToggleTableCell(),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const ToggleTableCell(),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          const TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Center(
                                child: Text('Mileage in Kms',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          const TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Center(
                                child: Text('Subtotal for Service Call',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          const TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Center(
                                child: Text('PST/HST',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          const TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Center(
                                child: Text('%',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          const TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Center(
                                child: Text('GST',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          const TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Center(
                                child: Text('5%',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                        ],
                      ), // Add mo
                      TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          const TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Center(
                                child: Text('Subtotal for Service Call',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // Call the _sendPdf method when the form is submitted
                          await _sendPdf();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(
                            150, 50), // Set the minimum size of the button
                        padding: const EdgeInsets.all(
                            16), // Add padding to the button
                        textStyle: const TextStyle(
                            fontSize: 16), // Increase the font size
                      ),
                      child: const Text('Submit'),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          SimpleHiddenDrawerController.of(context).toggle();
        },
        child: const Icon(Icons.menu),
      ),
    );
  }

  Future<void> _sendPdf() async {
    // Your PDF sending logic here
  }
}
