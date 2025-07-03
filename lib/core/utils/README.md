# Utils

Thư mục này chứa các tiện ích (utility) dùng chung cho toàn bộ dự án Flutter.  
Các file trong đây giúp tái sử dụng các hằng số, hàm tiện ích, cấu hình theme, màu sắc, v.v.

## Danh sách file tiêu biểu

- **app_color.dart**  
  Định nghĩa các màu sắc chủ đạo cho ứng dụng.

- **constants.dart**  
  Chứa các hằng số dùng chung như URL, padding mặc định, tên app, v.v.

- **app_theme.dart**  
  Cấu hình theme (giao diện tổng thể) cho ứng dụng.

- **validators.dart**  
  Các hàm kiểm tra dữ liệu đầu vào (nếu có).

## Cách sử dụng

Import file bạn cần:
```dart
import 'package:hsp_mobile/core/utils/app_color.dart';
```

Sử dụng trong code:
```dart
Container(
  color: AppColors.primary,
)
```

## Đóng góp

Nếu bạn muốn thêm tiện ích dùng chung, hãy tạo file mới trong thư mục này và đảm bảo:
- Đặt tên rõ ràng, dễ hiểu.
- Viết code dễ tái sử dụng, dễ mở rộng.
- Thêm chú thích/hướng dẫn sử dụng nếu cần thiết.