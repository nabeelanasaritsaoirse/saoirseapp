import 'package:flutter/material.dart';

class _NotSubmittedUI extends StatefulWidget {
  const _NotSubmittedUI();

  @override
  State<_NotSubmittedUI> createState() => _NotSubmittedUIState();
}

class _NotSubmittedUIState extends State<_NotSubmittedUI> {
  List<Map<String, String>> docs = [
    {"type": "", "frontUrl": "", "backUrl": ""},
  ];

  void addDoc() {
    setState(() {
      docs.add({"type": "", "frontUrl": "", "backUrl": ""});
    });
  }

  void removeDoc(int index) {
    if (docs.length == 1) return;
    setState(() {
      docs.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Icon(Icons.info_outline, size: 70, color: Colors.orange),
          const SizedBox(height: 10),
          const Text(
            "KYC Not Submitted",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          const Text("Please add your documents to continue."),

          const SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: "Document Type",
                                hintText: "Aadhaar / PAN",
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => removeDoc(index),
                            icon: const Icon(Icons.delete_outline),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: "Front Image URL",
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: "Back Image URL (Optional)",
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 15),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: addDoc,
                icon: const Icon(Icons.add),
                label: const Text("Add Document"),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {},
                child: const Text("Submit KYC"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}