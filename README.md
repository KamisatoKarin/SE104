<!-- Banner -->

<p align="center">
  <a href="https://www.uit.edu.vn/" title="Trường Đại học Công nghệ Thông tin" style="border: none;">
    <img src="https://i.imgur.com/WmMnSRt.png" alt="Trường Đại học Công nghệ Thông tin | University of Information Technology" width="400">
  </a>
</p>

<h1 align="center" style="color: #4032a8;"><b> SE104.P12 - NHẬP MÔN CÔNG NGHỆ PHẦN MỀM </b></h1>

<hr>


## 👉 GIỚI THIỆU MÔN HỌC
<a name ='gioithieumonhoc'></a>

- **Tên môn học**: NHẬP MÔN CÔNG NGHỆ PHẦN MỀM
- **Mã môn học**: SE104SE104
- **Lớp học**: SE104.P12
- **Năm học**: 2024-2025

## 🌍 GIẢNG VIÊN HƯỚNG DẪN
<a name="giangvien"></a>

- PGS.TS. **Đỗ Thị Thanh Tuyền** - *tuyendtt@uit.edu.vn*

## 🧑‍💻 GIỚI THIỆU NHÓM
<a name="banthan"></a>
- **Sinh viên khoá**: K17
- **Trường** : Đại học Công Nghệ Thông Tin

## 👨‍👩‍👧‍👦 THÔNG TIN THÀNH VIÊN

| MSSV       | Họ và Tên          |                                                                                  
| ---------- | ------------------ 
| `22521070` | Lưu Đoàn Ngọc Phát 
| `22520211` | Huỳnh Danh Đạt     
| `22521078` | Bùi Nhật Phi       
| `2252xxxx` | Hứa Hồng Khanh      
| `2252xxxx` | Nguyễn Anh Tú       
<hr>

## ✈️ ĐỒ ÁN MÔN HỌC
<a name="doan"></a>
- Đề tài quản lý nhà sách

# Online BookStore Project

Hệ thống quản lý và bán sách trực tuyến được xây dựng bằng Python Flask và MySQL


## 📋 Yêu cầu hệ thống

- Python 3.7 trở lên
- MySQL
- pip (Python package manager)

## 🛠 Hướng dẫn cài đặt

##1. Clone repository

```bash
git clone <https://github.com/KamisatoKarin/SE104.git>
cd "Using MySQL" 
```
##2. Cài môi trường 
```bash
python -m venv venv
venv\Scripts\activate
```

##3. Cài các requirements
```bash
pip install -r requirements.txt

```

##4.(SQL)Thiết lập cơ sở dữ liệu:
```bash
Tạo database MySQL mới
Import file onlinebookstore db.sql vào MySQL
Tạo file .env với nội dung:

MYSQL_HOST=localhost
MYSQL_USER=tên user đã tạo           
MYSQL_PASSWORD=mk    
MYSQL_DB=onlinebookstore     
SECRET_KEY= Tìm trong app  
```

##5. Chạy
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
