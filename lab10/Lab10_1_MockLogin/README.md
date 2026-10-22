# Lab10_1_MockLogin

Đã hoàn thành đến step 4 của Lab 10.1:

1. Tạo project Flutter.
2. Tạo giao diện Login gồm email, mật khẩu và nút đăng nhập.
3. Kiểm tra dữ liệu bằng Flutter Form khi bấm đăng nhập hoặc gửi từ bàn phím.
4. Giả lập xác thực chờ 2 giây và trả mock token.

Email bắt buộc và phải đúng định dạng. Mật khẩu bắt buộc và cần ít nhất
6 ký tự. Lỗi hiển thị dưới từng trường. Dữ liệu hợp lệ sẽ không hiển thị lỗi.
Tài khoản mẫu: `student@example.com` / `123456`.
Email được bỏ khoảng trắng đầu/cuối và so sánh không phân biệt hoa/thường.
Mật khẩu được so sánh chính xác. Khi chờ, hiển thị loading và khóa form.
Sai thông tin sẽ báo lỗi; đúng thông tin sẽ hiển thị mock token trên Login.
Token chỉ nằm trong bộ nhớ, không gọi API. Chưa triển khai chuyển Home.

## Chạy ứng dụng

Mở terminal trong thư mục `Lab10_1_MockLogin`:

```sh
flutter pub get
flutter run
```

Hoặc chạy bằng Chrome: `flutter run -d chrome`.
