import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hsp_mobile/core/utils/notification_helpers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hsp_mobile/core/models/account.dart';
import 'package:hsp_mobile/core/models/dtos/request/update_account_request.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/utils/validators.dart';
import 'package:hsp_mobile/core/widgets/custom_button.dart';
import 'package:hsp_mobile/core/widgets/custom_text_field.dart';
import 'package:hsp_mobile/core/providers/account_provider.dart';
import 'package:hsp_mobile/core/utils/responsive.dart';

class EditProfileContent extends StatefulWidget {
  final Account account;

  const EditProfileContent({super.key, required this.account});

  @override
  State<EditProfileContent> createState() => _EditProfileContentState();
}

class _EditProfileContentState extends State<EditProfileContent> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  File? _selectedImage;
  Uint8List? _selectedImageBytes; // Dành cho web
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.account.fullName);
    _phoneController = TextEditingController(text: widget.account.phone);
    _addressController = TextEditingController(text: widget.account.address);
  }

  // Chọn ảnh từ thiết bị
  Future<void> _pickImage() async {
    try {
      if (kIsWeb) {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          withData: true,
        );
        if (result != null && result.files.single.bytes != null) {
          setState(() {
            _selectedImageBytes = result.files.single.bytes;
            _selectedImage = null; // Đặt lại _selectedImage cho web
          });
        }
      } else {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            _selectedImage = File(pickedFile.path);
            _selectedImageBytes =
                null; // Đặt lại _selectedImageBytes cho mobile
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Image pick error: $e')));
      }
    }
  }

  // Tải ảnh lên Supabase và trả về URL
  Future<String?> _uploadImage(int accountId) async {
    if (_selectedImage == null && _selectedImageBytes == null) return null;

    setState(() => _isUploading = true);
    try {
      final supabase = Supabase.instance.client;
      final fileName =
          'avatar_${accountId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = 'avatars/$fileName';

      print('Uploading to path: $path');
      if (kIsWeb && _selectedImageBytes != null) {
        // Upload cho web với dữ liệu byte
        await supabase.storage
            .from('cozycare')
            .uploadBinary(path, _selectedImageBytes!);
      } else if (_selectedImage != null && await _selectedImage!.exists()) {
        // Upload cho mobile với File
        await supabase.storage.from('cozycare').upload(path, _selectedImage!);
      } else {
        throw Exception('Invalid image file');
      }

      final publicUrl = supabase.storage.from('cozycare').getPublicUrl(path);

      // Xóa ảnh cũ nếu có
      final oldUrl = widget.account.avatar;
      if (oldUrl.isNotEmpty) {
        final oldPath = oldUrl.split('/cozycare/').last;
        await supabase.storage.from('cozycare').remove(['avatars/$oldPath']);
      }
      return publicUrl;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Upload error: $e')));
      }
      return null;
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<void> _saveProfile() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isUploading = true);

    try {
      final provider = context.read<AccountProvider>();

      // 1. Tải ảnh lên trước
      final avatarUrl = await _uploadImage(widget.account.accountId);

      // 2. Cập nhật thông tin
      final success = await provider.updateAccount(
        widget.account.accountId,
        UpdateAccountRequest(
          fullName: _nameController.text,
          phone: _phoneController.text,
          address: _addressController.text,
          avatar: avatarUrl ?? widget.account.avatar,
        ),
      );

      if (!mounted) return;

      if (success) {
        NotificationHelpers.showToast(message: 'Profile updated successfully!');
        // Trả về kết quả và đóng màn hình
        Navigator.pop(context, true);
      } else {
        NotificationHelpers.showToast(
          message: provider.errorMessage ?? 'Update failed.',
          isError: true,
        );
      }
    } catch (e) {
      if (mounted) {
        NotificationHelpers.showToast(
          message: 'An error occurred: $e',
          isError: true,
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Quyết định bố cục dựa trên chiều rộng
        bool useTwoColumns = constraints.maxWidth > 800;

        return SingleChildScrollView(
          padding: Responsive.getPadding(context),
          child: Form(
            key: _formKey,
            // ✨ GIỚI HẠN CHIỀU RỘNG TỐI ĐA CỦA FORM
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: useTwoColumns ? 1000 : 500,
                ),
                child: Column(
                  children: [
                    _buildAvatarSection(),
                    const SizedBox(height: 30),
                    // ✨ SỬ DỤNG BỐ CỤC HAI CỘT CHO MÀN HÌNH LỚN
                    if (useTwoColumns)
                      _buildTwoColumnLayout()
                    else
                      _buildSingleColumnLayout(),
                    const SizedBox(height: 40),
                    CustomButton(
                      text: 'Save Changes',
                      onPressed: _saveProfile,
                      isLoading: _isUploading,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ✨ TÁCH CÁC PHẦN GIAO DIỆN RA WIDGET RIÊNG

  Widget _buildAvatarSection() {
    return Stack(
      children: [
        CircleAvatar(
          radius: Responsive.isMobile(context) ? 50 : 70,
          backgroundImage: _selectedImage != null
              ? FileImage(_selectedImage!)
              : (_selectedImageBytes != null
                  ? MemoryImage(_selectedImageBytes!)
                  : (widget.account.avatar.isNotEmpty
                      ? NetworkImage(widget.account.avatar)
                      : const AssetImage('assets/images/avatar.png'))) as ImageProvider,
          backgroundColor: AppColors.lightGray,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _isUploading ? null : _pickImage,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_alt, color: AppColors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  /// Bố cục một cột cho mobile
  Widget _buildSingleColumnLayout() {
    return Column(
      children: [
        CustomTextField(
          controller: _nameController,
          labelText: 'Full Name',
          validator: Validators.validateFullName,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _phoneController,
          labelText: 'Phone',
          keyboardType: TextInputType.phone,
          validator: Validators.validatePhone,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _addressController,
          labelText: 'Address',
          validator: Validators.validateAddress,
          maxLines: 3,
        ),
      ],
    );
  }

  /// Bố cục hai cột cho tablet/desktop
  Widget _buildTwoColumnLayout() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomTextField(
                controller: _nameController,
                labelText: 'Full Name',
                validator: Validators.validateFullName,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: CustomTextField(
                controller: _phoneController,
                labelText: 'Phone',
                keyboardType: TextInputType.phone,
                validator: Validators.validatePhone,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        CustomTextField(
          controller: _addressController,
          labelText: 'Address',
          validator: Validators.validateAddress,
          maxLines: 3,
        ),
      ],
    );
  }
}