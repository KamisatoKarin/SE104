# Online BookStore Project

Hệ thống quản lý và bán sách trực tuyến được xây dựng bằng Python Flask và MySQL/MongoDB.

## 🚀 Tính năng chính

- **Quản lý sách**: Thêm, sửa, xóa và tìm kiếm sách
- **Quản lý người dùng**: Hệ thống phân quyền Admin/Customer
- **Giỏ hàng**: Cho phép mua nhiều sách cùng lúc
- **Tìm kiếm**: Theo tên, thể loại, tác giả
- **Quản lý đơn hàng**: Theo dõi trạng thái đơn hàng

## 📋 Yêu cầu hệ thống

- Python 3.7 trở lên
- MySQL hoặc MongoDB (tùy phiên bản)
- pip (Python package manager)

## 🛠 Hướng dẫn cài đặt

###1. Clone repository

```bash
git clone <https://github.com/KamisatoKarin/SE104.git>
cd "Using MySQL" or cd "Using NoSQL - MongoDB"
```
###2. Cài môi trường 
```bash
python -m venv venv
venv\Scripts\activate
```

###3. Cài các requirements
```bash
pip install -r requirements.txt
```

###4.(SQL)Thiết lập cơ sở dữ liệu:
```bash
Tạo database MySQL mới
Import file onlinebookstore db.sql vào MySQL
Tạo file .env với nội dung:

DB_HOST=localhost
DB_USER=your_username
DB_PASSWORD=your_password
DB_NAME=your_database_name
```

5. Chạy
```bash 
python app.py
```
Thông tin thêm
```bash

## 🌐 Truy cập ứng dụng

- **URL**: `http://localhost:5000`
- **Admin Portal**: `http://localhost:5000/admin`
  - Username: admin1
  - Password: abc123
- **Customer Portal**: `http://localhost:5000`

## 📝 Tài khoản mặc định

### Admin
- Username: admin1 / Password: abc123
- Username: admin2 / Password: abc1

### Customer
- Đăng ký tài khoản mới tại: `/register`

```