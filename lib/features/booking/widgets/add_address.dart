import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';

class AddAddressScreen extends StatefulWidget {
  final Function(AddressItem) onAddressAdded;
  
  const AddAddressScreen({
    super.key,
    required this.onAddressAdded,
  });

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _notesController = TextEditingController();
  
  String _selectedAddressType = 'Home';
  final List<String> _addressTypes = ['Home', 'Work', 'Other'];
  bool _isDefaultAddress = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _labelController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Add New Address',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Address Type Selection
                      _buildSectionTitle('Address Type'),
                      const SizedBox(height: 8),
                      _buildAddressTypeSelector(),
                      
                      const SizedBox(height: 24),
                      
                      // Custom Label (if Other is selected)
                      if (_selectedAddressType == 'Other') ...[
                        _buildSectionTitle('Label'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _labelController,
                          hintText: 'Enter custom label (e.g., Friend\'s House)',
                          validator: (value) {
                            if (_selectedAddressType == 'Other' && (value == null || value.isEmpty)) {
                              return 'Please enter a label for this address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                      
                      // Street Address
                      _buildSectionTitle('Street Address'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _addressController,
                        hintText: 'Enter street address',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter street address';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // City and State Row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle('City'),
                                const SizedBox(height: 8),
                                _buildTextField(
                                  controller: _cityController,
                                  hintText: 'Enter city',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter city';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle('State'),
                                const SizedBox(height: 8),
                                _buildTextField(
                                  controller: _stateController,
                                  hintText: 'Enter state',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter state';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // ZIP Code
                      _buildSectionTitle('ZIP Code'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _zipController,
                        hintText: 'Enter ZIP code',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter ZIP code';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Notes (Optional)
                      _buildSectionTitle('Notes (Optional)'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _notesController,
                        hintText: 'Add delivery instructions or notes',
                        maxLines: 3,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Default Address Checkbox
                      _buildDefaultAddressCheckbox(),
                      
                      const SizedBox(height: 80), // Space for bottom button
                    ],
                  ),
                ),
              ),
            ),
            
            // Bottom Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _isLoading ? null : _saveAddress,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Save Address'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildAddressTypeSelector() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: _addressTypes.map((type) {
          final isSelected = _selectedAddressType == type;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedAddressType = type;
                  if (type != 'Other') {
                    _labelController.clear();
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  type,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int? maxLines,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }

  Widget _buildDefaultAddressCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _isDefaultAddress,
          onChanged: (value) {
            setState(() {
              _isDefaultAddress = value ?? false;
            });
          },
          activeColor: Colors.blue,
        ),
        const Expanded(
          child: Text(
            'Set as default address',
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create full address string
      final fullAddress = _buildFullAddress();
      
      // Create new address item
      final newAddress = AddressItem(
        label: _selectedAddressType == 'Other' ? _labelController.text : _selectedAddressType,
        detail: fullAddress,
        isDefault: _isDefaultAddress,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Call callback to add address
      widget.onAddressAdded(newAddress);
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Address added successfully'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Navigate back
      Navigator.of(context).pop();
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add address: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _buildFullAddress() {
    final parts = <String>[];
    
    if (_addressController.text.isNotEmpty) {
      parts.add(_addressController.text);
    }
    
    if (_cityController.text.isNotEmpty) {
      parts.add(_cityController.text);
    }
    
    if (_stateController.text.isNotEmpty) {
      parts.add(_stateController.text);
    }
    
    if (_zipController.text.isNotEmpty) {
      parts.add(_zipController.text);
    }
    
    return parts.join(', ');
  }
}

// Updated AddressItem class to include more fields
class AddressItem {
  final String label;
  final String detail;
  final bool isDefault;
  final String? notes;
  
  AddressItem({
    required this.label,
    required this.detail,
    this.isDefault = false,
    this.notes,
  });

  @override
  String toString() {
    return 'AddressItem(label: $label, detail: $detail, isDefault: $isDefault, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AddressItem &&
        other.label == label &&
        other.detail == detail &&
        other.isDefault == isDefault &&
        other.notes == notes;
  }

  @override
  int get hashCode {
    return label.hashCode ^
        detail.hashCode ^
        isDefault.hashCode ^
        notes.hashCode;
  }
}