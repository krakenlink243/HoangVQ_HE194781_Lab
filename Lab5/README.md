# Lab 5 — Movie Detail App với Navigation

App có hai màn hình theo đề bài: danh sách phim và chi tiết phim. Dữ liệu được viết sẵn trong code, không gọi API. Chạy bằng:

Các file chính: `lib/main.dart` chỉ khởi tạo app; `lib/screens/movie_home_screen.dart` và `lib/screens/movie_detail_screen.dart` là hai màn hình riêng; `lib/widgets/movie_image.dart` là widget ảnh dùng chung.

```bash
flutter pub get
flutter run
```

## Bước 1: Tạo model dữ liệu

Trong `lib/models/movie.dart`, `Movie` gom các thuộc tính của một phim: `id`, `title`, `posterUrl`, `overview`, `genres`, `rating` và `trailers`. Mỗi `Trailer` có tên và URL. Các trường là `final` để dữ liệu của phim không bị thay đổi ngẫu nhiên sau khi tạo.

## Bước 2: Tạo dữ liệu mẫu

`lib/sample_data.dart` khai báo `sampleMovies` với hai phim giống nội dung trong hình của đề. Vì là `const`, danh sách này có sẵn ngay khi app chạy; không cần kết nối mạng để lấy tên, mô tả và thể loại. Ảnh poster là URL nên cần Internet để hiển thị; nếu tải ảnh lỗi, widget hiện biểu tượng phim thay thế.

## Bước 3: Màn hình Home

Trong `lib/screens/movie_home_screen.dart`, `MovieHomeScreen` dùng `ListView.builder`. Flutter chỉ dựng các phần tử cần hiển thị, phù hợp khi danh sách dài và cho phép cuộn. Mỗi `Card` có ảnh, tên, điểm và thể loại. `Expanded` giúp phần chữ dùng chiều rộng còn lại của hàng, tránh tràn khi màn hình hẹp.

Khi chạm vào card, `Navigator.push` thêm một `MaterialPageRoute` vào ngăn xếp điều hướng. Hàm `builder` tạo `MovieDetailScreen(movie: movie)`, tức là truyền đúng object vừa được chọn. Nút Back của AppBar gọi cơ chế `Navigator.pop` mặc định để trở lại Home.

## Bước 4: Màn hình chi tiết

Trong `lib/screens/movie_detail_screen.dart`, `MovieDetailScreen` nhận `Movie` qua constructor. `ListView` bên ngoài cho phép cuộn toàn trang. Phần banner dùng `Stack`: ảnh ở lớp dưới, lớp chuyển màu tối ở giữa, tên phim ở trên cùng. `Wrap` tự xuống dòng khi các `Chip` thể loại không đủ chỗ. Tiếp theo là mô tả, các nút thao tác và trailer.

Trang chi tiết là `StatefulWidget` vì hai giá trị có thể thay đổi: `isFavorite` và `userRating`. `setState()` báo Flutter dựng lại giao diện sau khi bấm Favorite hoặc chọn điểm trong hộp thoại Rate. Trạng thái này chỉ tồn tại khi trang chi tiết đang mở; bài lab không yêu cầu lưu vào thiết bị.

Share sao chép thông tin phim vào clipboard. Chạm một trailer sẽ sao chép URL của trailer để mở bên ngoài app. Bài lab chỉ yêu cầu danh sách trailer, chưa yêu cầu phát video trong app.

## Bước 5: Kiểm tra

```bash
flutter analyze
flutter test
```

Widget test trong `test/widget_test.dart` kiểm tra mở chi tiết, thấy thể loại và trailer, đổi Favorite, rồi quay lại Home. Không dùng package ngoài Flutter SDK nên phần code trong `lib/` cũng có thể dán vào DartPad Flutter (gộp các file vào một file và giữ thứ tự model, dữ liệu, widget, màn hình, app).
