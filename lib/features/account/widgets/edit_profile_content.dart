import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hsp_mobile/core/models/account.dart';
import 'package:hsp_mobile/core/models/dtos/request/update_account_request.dart';
import 'package:hsp_mobile/core/utils/validators.dart';
import 'package:hsp_mobile/features/account/account_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/utils/responsive.dart';
import 'package:hsp_mobile/core/widgets/custom_button.dart';
import 'package:hsp_mobile/core/widgets/custom_text_field.dart';

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
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.account.fullName);
    _phoneController = TextEditingController(text: widget.account.phone);
    _addressController = TextEditingController(text: widget.account.address);
  }

  // Chọn ảnh từ mobile (image_picker) hoặc desktop (file_picker)
  Future<void> _pickImage() async {
    try {
      if (kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
        // Sử dụng file_picker cho web và desktop
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'jpeg', 'png'],
          withData: true,
        );

        if (result != null && result.files.single.path != null) {
          setState(() {
            _selectedImage = File(result.files.single.path!);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No image selected')),
          );
        }
      } else if (Platform.isAndroid || Platform.isIOS) {
        // Sử dụng image_picker cho mobile
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80, // Giảm chất lượng để tối ưu kích thước
          maxWidth: 800, // Giới hạn kích thước ảnh
        );

        if (pickedFile != null) {
          setState(() {
            _selectedImage = File(pickedFile.path);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No image selected')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image picking is not supported on this platform'),
          ),
        );
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  // Tải ảnh lên Supabase và lấy URL công khai
  Future<String?> _uploadImageToSupabase(int accountId) async {
    if (_selectedImage == null) return null;

    setState(() {
      _isUploading = true;
    });

    try {
      final supabase = Supabase.instance.client;
      final fileName = 'avatar_$accountId${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = 'avatars/$fileName';

      // Kiểm tra định dạng tệp
      final extension = _selectedImage!.path.split('.').last.toLowerCase();
      if (extension != 'jpg' && extension != 'jpeg' && extension != 'png') {
        throw Exception('Only JPG or PNG images are supported');
      }

      // Tải ảnh lên Supabase Storage
      await supabase.storage.from('avatars').upload(path, _selectedImage!);

      // Lấy URL công khai
      final publicUrl = supabase.storage.from('avatars').getPublicUrl(path);
      print('Uploaded image URL: $publicUrl');

      // Xóa ảnh cũ nếu có
      if (widget.account.avatar != null && widget.account.avatar!.isNotEmpty) {
        final oldPath = widget.account.avatar!.split('/').last;
        await supabase.storage.from('avatars').remove(['avatars/$oldPath']);
      }

      return publicUrl;
    } catch (e) {
      print('Error uploading image to Supabase: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
      return null;
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context);

    return SingleChildScrollView(
      padding: Responsive.getPadding(context),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar section
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : widget.account.avatar != null && widget.account.avatar!.isNotEmpty
                            ? NetworkImage(widget.account.avatar!)
                            : const AssetImage('assets/images/avatar.png') as ImageProvider,
                    backgroundColor: AppColors.lightGray,
                    onBackgroundImageError: (exception, stackTrace) {
                      print('Error loading avatar: $exception');
                    },
                    child: widget.account.avatar == null || widget.account.avatar!.isEmpty
                        ? const Icon(Icons.person, size: 60, color: AppColors.white)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: _isUploading
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                                strokeWidth: 2,
                              )
                            : const Icon(
                                Icons.camera_alt_rounded,
                                color: AppColors.white,
                                size: 20,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Form fields
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
            ),
            const SizedBox(height: 24),
            // Save button
            accountProvider.isLoading || _isUploading
                ? const Center(child: CircularProgressIndicator())
                : CustomButton(
                    text: 'Save Changes',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Tải ảnh lên Supabase
                        final avatarUrl = await _uploadImageToSupabase(widget.account.accountId);

                        // Cập nhật thông tin tài khoản
                        await accountProvider.updateAccount(
                          widget.account.accountId,
                          UpdateAccountRequest(
                            fullName: _nameController.text,
                            phone: _phoneController.text,
                            address: _addressController.text,
                            avatar: avatarUrl ?? widget.account.avatar,
                          ),
                        );

                        if (accountProvider.errorMessage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Profile updated successfully')),
                          );
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(accountProvider.errorMessage!)),
                          );
                        }
                      }
                    },
                    backgroundColor: AppColors.primary,
                    textColor: AppColors.white,
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}