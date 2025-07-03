# Features

Thư mục này chứa các module (tính năng) chính của ứng dụng.  
Mỗi module được tổ chức thành một thư mục riêng biệt, giúp tách biệt code, dễ bảo trì và mở rộng.

## Cấu trúc đề xuất cho mỗi module

```
features/
  <feature_name>/
    views/       // Các màn hình (screen/page) của module
    widgets/     // Widget chỉ dùng trong module này
```

## Ví dụ

- **auth/**: Đăng nhập, đăng ký, quên mật khẩu, xác thực OTP...
- **home/**: Trang chủ, dashboard, các widget liên quan trang chủ.
- **booking/**: Đặt lịch, quản lý lịch sử đặt dịch vụ.
- **profile/**: Thông tin cá nhân, chỉnh sửa hồ sơ, đổi mật khẩu.

## Lợi ích

- Dễ chia việc cho nhiều lập trình viên.
- Dễ mở rộng, bảo trì, kiểm soát phạm vi thay đổi.
- Giảm xung đột code khi làm việc nhóm.

## Đóng góp

Khi thêm module mới:
- Tạo thư mục theo tên tính năng.
- Chia nhỏ thành các thư mục con như trên nếu cần.
- Đặt tên rõ ràng, nhất quán.

