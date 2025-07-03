# Shared Widgets

Thư mục này chứa các widget dùng chung cho toàn bộ dự án Flutter.  
Các widget ở đây giúp tái sử dụng giao diện, đảm bảo tính nhất quán và dễ bảo trì code.

## Danh sách widget

- **AppLogo**  
  Hiển thị logo ứng dụng.

- **CustomTextField**  
  Ô nhập liệu với style đồng nhất, hỗ trợ label, icon, password, v.v.

- **CustomButton**  
  Nút bấm với style tuỳ chỉnh, dùng cho các hành động chính.

- **LinkButton**  
  Nút dạng text, thường dùng cho các liên kết như "Đăng ký", "Quên mật khẩu?".

- **OtpInput**  
  Widget nhập mã OTP (nếu có).

## Cách sử dụng

Import widget bạn cần:
```dart
import 'package:hsp_mobile/core/widgets/custom_button.dart';
```

Sau đó sử dụng trong code:
```dart
CustomButton(
  text: 'Đăng nhập',
  onPressed: _login,
)
```

## Đóng góp

Nếu bạn muốn thêm widget dùng chung, hãy tạo file mới trong thư mục này và đảm bảo:
- Đặt tên rõ ràng, dễ hiểu.
- Viết code dễ tái sử dụng, dễ tuỳ chỉnh.
- Thêm ví dụ sử dụng nếu cần thiết.
