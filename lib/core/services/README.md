# App Services

Thư mục này chứa các service (dịch vụ) dùng chung cho toàn bộ dự án Flutter.  
Các service ở đây thường xử lý các logic như gọi API, lưu trữ dữ liệu cục bộ, quản lý trạng thái, hoặc các thao tác nền tảng.

## Danh sách file tiêu biểu

- **api_service.dart**  
  Xử lý các request đến server/API.

- **local_storage_service.dart**  
  Lưu trữ và truy xuất dữ liệu cục bộ (SharedPreferences, Secure Storage, ...).

- **auth_service.dart**  
  Xử lý logic xác thực, đăng nhập, đăng ký (nếu dùng chung toàn app).

## Cách sử dụng

Import service bạn cần:
```dart
import 'package:hsp_mobile/core/services/api_service.dart';
```

Sử dụng trong code:
```dart
final response = await ApiService.get('/users');
```

## Đóng góp

Nếu bạn muốn thêm service dùng chung, hãy tạo file mới trong thư mục này và đảm bảo:
- Đặt tên rõ ràng, dễ hiểu.
- Viết code dễ tái sử dụng, dễ mở rộng.
- Thêm chú thích/hướng dẫn sử dụng nếu cần