import 'package:flutter/material.dart';

class ChangeAddressSheet extends StatefulWidget {
  final List<AddressItem> addresses;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final VoidCallback onAddNew;

  const ChangeAddressSheet({
    super.key,
    required this.addresses,
    required this.selectedIndex,
    required this.onSelected,
    required this.onAddNew,
  });

  @override
  State<ChangeAddressSheet> createState() => _ChangeAddressSheetState();
}

class _ChangeAddressSheetState extends State<ChangeAddressSheet> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      builder: (ctx, scrollCtrl) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  children: [
                    Text('Select Address',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  controller: scrollCtrl,
                  itemCount: widget.addresses.length,
                  itemBuilder: (context, idx) {
                    final item = widget.addresses[idx];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: RadioListTile<int>(
                        value: idx,
                        groupValue: _currentIndex,
                        onChanged: (val) {
                          setState(() => _currentIndex = val!);
                          widget.onSelected(val!);
                          Navigator.of(context).pop();
                        },
                        title: Text(item.label, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(item.detail),
                        secondary: Icon(Icons.more_vert),
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onAddNew();
                    },
                    icon: Icon(Icons.add),
                    label: Text('Add New Address'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AddressItem {
  final String label;
  final String detail;
  AddressItem({required this.label, required this.detail});
}
