

CREATE DATABASE onlinebookstore;
USE onlinebookstore;
SHOW TABLES;


CREATE TABLE Customers(
	customerID VARCHAR(30) PRIMARY KEY,
	firstName VARCHAR(20),
	lastName VARCHAR(20),
	emailID VARCHAR(50),
	password VARCHAR(30),
	phone VARCHAR(10),
	country VARCHAR(25),
	state VARCHAR(25),
	pincode INT,
	address VARCHAR(50),
    Debt DECIMAL(10,2) DEFAULT 0.00 -- Thêm cột này để tương thích với triggers
);

CREATE TABLE Admins(
	adminID VARCHAR(30) PRIMARY KEY,
	firstName VARCHAR(20),
	lastName VARCHAR(20),
	emailID VARCHAR(50),
	password VARCHAR(30),
	phone VARCHAR(10)
);

-- Thêm cột cho Books theo yêu cầu đoạn trên:
-- ID_Book sẽ tương ứng bookID
-- Thêm Category, Author, Quantity, Purchase_Price, Selling_Price, Current_Stock
CREATE TABLE Books(
	bookID INT PRIMARY KEY,
	authorID INT,
	publisherID INT,
	title VARCHAR(50),
	genre VARCHAR(15),
	publicationYear INT,
	price INT,
    Category VARCHAR(50),
    Author VARCHAR(100),
    Quantity INT,
    Purchase_Price DECIMAL(10,2),
    Selling_Price DECIMAL(10,2),
    Current_Stock INT
);

CREATE TABLE Authors(
  authorID INT PRIMARY KEY AUTO_INCREMENT,
  firstName VARCHAR(20),
  lastName VARCHAR(20)
);

CREATE TABLE Publishers(
  publisherID INT PRIMARY KEY AUTO_INCREMENT,
  country VARCHAR(25)
);

CREATE TABLE Inventory(
   bookID INT PRIMARY KEY,
   totalStock INT,
   soldStock INT,
   FOREIGN KEY (bookID) REFERENCES Books(bookID)
);

CREATE TABLE Orders(
  orderID INT AUTO_INCREMENT,
  customerID VARCHAR(30),
  bookID INT,
  quantity INT NOT NULL,
  total INT,
  timestamp DATETIME,
  PRIMARY KEY(orderID,customerID,timestamp,bookID),
  FOREIGN KEY (customerID) REFERENCES Customers(customerID),
  FOREIGN KEY (bookID) REFERENCES Books(bookID)
);

CREATE TABLE Payment(
  paymentID INT PRIMARY KEY AUTO_INCREMENT,
  customerID VARCHAR(30),
  paymentInfo INT NOT NULL,
  FOREIGN KEY (customerID) REFERENCES Customers(customerID)
);

CREATE TABLE ContactUs(
  id INT PRIMARY KEY AUTO_INCREMENT,
  firstName VARCHAR(20),
  lastName VARCHAR(20),
  emailID VARCHAR(50),
  message VARCHAR(1000),
  timestamp DATETIME
);

-- -----------------------------------------------------AUTO_INCREMENT ---------------------------------------------------------------------------
ALTER TABLE Authors AUTO_INCREMENT=101;
ALTER TABLE Publishers AUTO_INCREMENT=201;

-- -----------------------------------------------------FOREIGN KEYS-----------------------------------------------------------------------------
ALTER TABLE Books ADD FOREIGN KEY (authorID) REFERENCES Authors(authorID);
ALTER TABLE Books ADD FOREIGN KEY (publisherID) REFERENCES Publishers(publisherID);

-- -----------------------------------------------------INSERT DATA------------------------------------------------------------------------------
INSERT INTO Admins(adminID,firstName,lastName,emailID,password,phone) VALUES('admin1','Sam','Jones','sam@gmail.com','abc123','1234567892');
INSERT INTO Admins(adminID,firstName,lastName,emailID,password,phone) VALUES('admin2','Anu','Sharma','anu@gmail.com','abc1','3454567892');
INSERT INTO Admins(adminID,firstName,lastName,emailID,password,phone) VALUES('euphoria','Huỳnh','Đạt','22520211@gm.uit.edu.vn','26092004','3454567892');

-- Thêm dữ liệu vào bảng Publishers
INSERT INTO Publishers (publisherID, country)
VALUES
(201, 'Vietnam'),
(202, 'USA'),
(203, 'UK'),
(204, 'France'),
(205, 'Japan'),
(206, 'Germany');

-- Thêm dữ liệu vào bảng Authors
INSERT INTO Authors (authorID, firstName, lastName)
VALUES
(101, 'Nguyen', 'Du'),
(102, 'Victor', 'Hugo'),
(103, 'William', 'Shakespeare'),
(104, 'George', 'Orwell'),
(105, 'Gabriel', 'Garcia Marquez'),
(106, 'Lev', 'Tolstoy'),
(107, 'Haruki', 'Murakami'),
(108, 'J.K.', 'Rowling'),
(109, 'J.R.R.', 'Tolkien'),
(110, 'Nguyen', 'Nhat Anh'),
(111, 'Jane', 'Austen'),
(112, 'F. Scott', 'Fitzgerald'),
(113, 'Charles', 'Dickens'),
(114, 'Mark', 'Twain'),
(115, 'Leo', 'Tolstoy'),
(116, 'J.D.', 'Salinger'),
(117, 'Ernest', 'Hemingway'),
(118, 'Herman', 'Melville'),
(119, 'Mary', 'Shelley'),
(120, 'George', 'Eliot'),
(121, 'Franz', 'Kafka'),
(122, 'Jack', 'London'),
(123, 'Fyodor', 'Dostoevsky'),
(124, 'Emily', 'Bronte'),
(125, 'Virginia', 'Woolf'),
(126, 'To', 'Hoai'),
(127, 'Bao', 'Ninh'),
(128, 'Nam', 'Cao'),
(129, 'Vu', 'Trong Phung'),
(130, 'Nguyen', 'Huy Thiep');

-- Thêm dữ liệu vào bảng Books
INSERT INTO Books (bookID, authorID, publisherID, title, genre, publicationYear, price, Category, Author, Quantity, Purchase_Price, Selling_Price, Current_Stock)
VALUES
(1, 101, 201, 'Truyen Kieu', 'Poetry', 1820, 100000, 'Classic', 'Nguyen Du', 100, 70000, 100000, 100),
(2, 126, 201, 'De Men Phieu Luu Ky', 'Children', 1941, 90000, 'Classic', 'To Hoai', 80, 60000, 90000, 80),
(3, 127, 201, 'The Sorrow of War', 'Novel', 1991, 110000, 'Vietnamese Literature', 'Bao Ninh', 70, 80000, 110000, 70),
(4, 128, 201, 'Chi Pheo', 'Novel', 1941, 95000, 'Classic', 'Nam Cao', 100, 70000, 95000, 100),
(5, 129, 201, 'So Do', 'Satire', 1936, 100000, 'Classic', 'Vu Trong Phung', 60, 75000, 100000, 60),
(6, 130, 201, 'Tuong Ve Huu', 'Short Stories', 1987, 85000, 'Vietnamese Literature', 'Nguyen Huy Thiep', 50, 60000, 85000, 50),
(7, 110, 201, 'Kinh Van Hoa', 'Children', 1988, 95000, 'Children', 'Nguyen Nhat Anh', 120, 70000, 95000, 120),
(8, 110, 201, 'Mat Biec', 'Romance', 1990, 105000, 'Vietnamese Literature', 'Nguyen Nhat Anh', 60, 75000, 105000, 60),
(9, 102, 204, 'Les Miserables', 'Novel', 1862, 150000, 'Classic', 'Victor Hugo', 50, 120000, 150000, 50),
(10, 103, 203, 'Hamlet', 'Drama', 1600, 120000, 'Classic', 'William Shakespeare', 70, 90000, 120000, 70),
(11, 104, 202, '1984', 'Dystopian', 1949, 130000, 'Fiction', 'George Orwell', 80, 100000, 130000, 80),
(12, 105, 205, 'One Hundred Years of Solitude', 'Magical Realism', 1967, 140000, 'Fiction', 'Gabriel Garcia Marquez', 60, 110000, 140000, 60),
(13, 106, 206, 'War and Peace', 'Historical', 1869, 160000, 'Classic', 'Lev Tolstoy', 40, 130000, 160000, 40),
(14, 107, 205, 'Norwegian Wood', 'Fiction', 1987, 125000, 'Fiction', 'Haruki Murakami', 90, 100000, 125000, 90),
(15, 108, 202, 'Harry Potter and the Sorcerer''s Stone', 'Fantasy', 1997, 200000, 'Fantasy', 'J.K. Rowling', 100, 150000, 200000, 100),
(16, 109, 203, 'The Hobbit', 'Fantasy', 1937, 180000, 'Fantasy', 'J.R.R. Tolkien', 75, 140000, 180000, 75),
(17, 111, 202, 'Pride and Prejudice', 'Romance', 1813, 140000, 'Classic', 'Jane Austen', 50, 100000, 140000, 50),
(18, 112, 202, 'The Great Gatsby', 'Novel', 1925, 130000, 'Classic', 'F. Scott Fitzgerald', 60, 90000, 130000, 60),
(19, 113, 203, 'A Tale of Two Cities', 'Historical', 1859, 150000, 'Classic', 'Charles Dickens', 40, 110000, 150000, 40),
(20, 114, 202, 'The Adventures of Huckleberry Finn', 'Adventure', 1884, 125000, 'Classic', 'Mark Twain', 80, 100000, 125000, 80),
(21, 115, 206, 'Anna Karenina', 'Romance', 1877, 160000, 'Classic', 'Leo Tolstoy', 70, 130000, 160000, 70),
(22, 116, 203, 'The Catcher in the Rye', 'Novel', 1951, 120000, 'Fiction', 'J.D. Salinger', 90, 100000, 120000, 90),
(23, 117, 204, 'The Old Man and the Sea', 'Fiction', 1952, 110000, 'Classic', 'Ernest Hemingway', 100, 80000, 110000, 100),
(24, 118, 202, 'Moby Dick', 'Adventure', 1851, 140000, 'Classic', 'Herman Melville', 50, 100000, 140000, 50),
(25, 119, 203, 'Frankenstein', 'Horror', 1818, 120000, 'Classic', 'Mary Shelley', 70, 90000, 120000, 70),
(26, 120, 205, 'Middlemarch', 'Novel', 1871, 130000, 'Classic', 'George Eliot', 60, 100000, 130000, 60),
(27, 121, 204, 'The Metamorphosis', 'Fiction', 1915, 100000, 'Classic', 'Franz Kafka', 90, 80000, 100000, 90),
(28, 122, 205, 'White Fang', 'Adventure', 1906, 125000, 'Classic', 'Jack London', 80, 100000, 125000, 80),
(29, 123, 206, 'Crime and Punishment', 'Psychological', 1866, 150000, 'Classic', 'Fyodor Dostoevsky', 70, 120000, 150000, 70),
(30, 124, 203, 'Wuthering Heights', 'Romance', 1847, 130000, 'Classic', 'Emily Bronte', 60, 100000, 130000, 60),
(31, 125, 204, 'Mrs. Dalloway', 'Novel', 1925, 110000, 'Classic', 'Virginia Woolf', 100, 90000, 110000, 100),
(32, 127, 201, 'Nhung dua con cua lang', 'Novel', 1957, 100000, 'Classic', 'Bao Ninh', 70, 80000, 100000, 70),
(33, 128, 201, 'Lang', 'Short Stories', 1942, 110000, 'Vietnamese Literature', 'Nam Cao', 60, 90000, 110000, 60),
(34, 126, 201, 'Cuoc doi cua ong Nam', 'Biography', 1955, 85000, 'Biography', 'To Hoai', 50, 60000, 85000, 50),
(35, 129, 201, 'Hoang Le Nhat Thong Chi', 'Historical', 1800, 95000, 'Historical', 'Vu Trong Phung', 40, 70000, 95000, 40),
(36, 127, 201, 'Dat Rung Phuong Nam', 'Novel', 1957, 90000, 'Vietnamese Literature', 'Doan Gioi', 60, 70000, 90000, 60),
(37, 128, 201, 'Nguoi me cam sung', 'Short Stories', 1945, 100000, 'Vietnamese Literature', 'Nguyen Thi', 70, 75000, 100000, 70);







insert into Inventory (bookID,totalStock,soldStock) values (1,100,0);
insert into Inventory (bookID,totalStock,soldStock) values (2,100,0);



-- Tạo bảng BookEntry
CREATE TABLE BookEntry (
    ID_Entry INT PRIMARY KEY,
    Entry_Date DATE
);

-- Tạo bảng EntryDetail
CREATE TABLE EntryDetail (
    ID_Entry INT,
    bookID INT,
    Quantity_Added INT,
    Purchase_Price DECIMAL(10, 2),
    PRIMARY KEY (ID_Entry, bookID),
    FOREIGN KEY (ID_Entry) REFERENCES BookEntry(ID_Entry),
    FOREIGN KEY (bookID) REFERENCES Books(bookID)
);


-- Tạo bảng Invoice
CREATE TABLE Invoice (
    ID_Invoice INT PRIMARY KEY,
    Date_Issued DATE,
    ID_Customer VARCHAR(30),
    Total_Amount DECIMAL(10, 2),
    FOREIGN KEY (ID_Customer) REFERENCES Customers(customerID) -- Chuyển sang khóa ngoại với Customers
);

-- Tạo bảng InvoiceDetail
-- Gốc: Selling_Price AS (SELECT ...) không hợp lệ tạo cột Selling_Price bình thường.
CREATE TABLE InvoiceDetail (
    ID_Invoice INT,
    bookID INT,
    Quantity_Sold INT,
    Selling_Price DECIMAL(10,2), 
    PRIMARY KEY (ID_Invoice, bookID),
    FOREIGN KEY (ID_Invoice) REFERENCES Invoice(ID_Invoice),
    FOREIGN KEY (bookID) REFERENCES Books(bookID)
);

-- Tạo bảng PaymentReceipt
CREATE TABLE PaymentReceipt (
    ID_Receipt INT PRIMARY KEY,
    Receipt_Date DATE,
    ID_Customer VARCHAR(30),
    Amount_Collected DECIMAL(10, 2),
    FOREIGN KEY (ID_Customer) REFERENCES Customers(customerID)
);

CREATE TABLE InventoryReport (
    Month DATE,
    bookID INT,
    Opening_Stock INT,
    Transactions INT,
    Closing_Stock INT,
    PRIMARY KEY (Month, bookID),
    FOREIGN KEY (bookID) REFERENCES Books(bookID)
);

CREATE TABLE DebtReport (
    Month DATE,
    ID_Customer VARCHAR(30),
    Opening_Debt DECIMAL(10, 2),
    Transactions DECIMAL(10, 2),
    Closing_Debt DECIMAL(10, 2),
    PRIMARY KEY (Month, ID_Customer),
    FOREIGN KEY (ID_Customer) REFERENCES Customers(customerID)
);
-- QD6
-- Tạo bảng RegulationSettings để lưu các quy định và giá trị có thể thay đổi
CREATE TABLE RegulationSettings (
    Regulation_ID INT PRIMARY KEY,
    Regulation_Name VARCHAR(100),
    Min_Entry_Quantity INT DEFAULT 150,
    Min_Stock_Before_Entry INT DEFAULT 300,
    Max_Debt DECIMAL(10, 2) DEFAULT 100000.00,
    Min_Stock_After_Sale INT DEFAULT 10,
    Use_Regulation_4 BOOLEAN DEFAULT TRUE
);

INSERT INTO RegulationSettings (Regulation_ID, Regulation_Name) VALUES (1, 'Default Regulations');


-- QĐ 1: 
DELIMITER //

CREATE TRIGGER trg_check_quantity_entry
BEFORE INSERT ON EntryDetail
FOR EACH ROW
BEGIN
    DECLARE current_stock INT;
        -- Lấy lượng tồn kho hiện tại từ bảng Book
    SELECT Current_Stock INTO current_stock FROM Books WHERE bookID = NEW.bookID;
    -- Kiểm tra số lượng tồn kho hiện tại phải < 300
    IF current_stock >= 300 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot add entry. Current stock exceeds 300.';
    END IF;
    -- Kiểm tra số lượng nhập phải >= 150
    IF NEW.Quantity_Added < 150 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantity added must be at least 150.';
    END IF;
END//
DELIMITER ;
-- QĐ 2: 
-- Trigger kiểm tra các điều kiện trước khi bán sách
DELIMITER //
CREATE TRIGGER trg_BeforeInvoiceDetailInsert
BEFORE INSERT ON InvoiceDetail
FOR EACH ROW
BEGIN
    DECLARE current_stock INT;
    DECLARE current_debt DECIMAL(10, 2);
    -- Kiểm tra công nợ khách hàng
    SELECT Debt INTO current_debt FROM Customers WHERE customerID = (SELECT ID_Customer FROM Invoice WHERE ID_Invoice = NEW.ID_Invoice);
    IF current_debt > 1000000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không thể bán sách vì khách hàng nợ quá 1.000.000đ';
    END IF;
    -- Kiểm tra lượng tồn kho sau bán
    SELECT Current_Stock INTO current_stock FROM Books WHERE bookID = NEW.bookID;
    IF (current_stock - NEW.Quantity_Sold) < 20 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không thể bán sách vì lượng tồn kho sau bán ít hơn 20';
    END IF;
    -- Cập nhật tồn kho sau bán
    UPDATE Books
    SET Current_Stock = Current_Stock - NEW.Quantity_Sold
    WHERE bookID = NEW.bookID;
END//
DELIMITER ;

-- QD4
DELIMITER //
-- Tạo trigger để kiểm tra số tiền thu không vượt quá số tiền khách hàng đang nợ
CREATE TRIGGER trg_CheckAmountCollected
BEFORE INSERT ON PaymentReceipt
FOR EACH ROW
BEGIN
    DECLARE customerDebt DECIMAL(10, 2);
        -- Lấy số tiền nợ hiện tại của khách hàng
    SELECT Debt INTO customerDebt FROM Customers WHERE customerID = NEW.ID_Customer;
    -- Kiểm tra nếu số tiền thu vượt quá số tiền nợ
    IF NEW.Amount_Collected > customerDebt THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Số tiền thu không được vượt quá số tiền khách hàng đang nợ';
    END IF;
END//
DELIMITER ;
-- Trigger kiểm tra QĐ1 khi thêm chi tiết nhập
DELIMITER //
CREATE TRIGGER trg_CheckEntryDetail
BEFORE INSERT ON EntryDetail
FOR EACH ROW
BEGIN
    DECLARE minEntryQuantity INT;
    DECLARE minStockBeforeEntry INT;
    DECLARE currentStock INT;

    SELECT Min_Entry_Quantity, Min_Stock_Before_Entry INTO minEntryQuantity, minStockBeforeEntry
    FROM RegulationSettings
    WHERE Regulation_ID = 1;

    SELECT Current_Stock INTO currentStock FROM Books WHERE bookID = NEW.bookID;

    IF NEW.Quantity_Added < minEntryQuantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Số lượng nhập không được nhỏ hơn số lượng tối thiểu theo quy định.';
    END IF;

    IF currentStock >= minStockBeforeEntry THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Số lượng tồn hiện tại lớn hơn lượng tồn tối thiểu cho phép trước khi nhập.';
    END IF;
END//
DELIMITER ;
-- Trigger kiểm tra QĐ2 khi thêm chi tiết hóa đơn
DELIMITER //
CREATE TRIGGER trg_CheckInvoiceDetail
BEFORE INSERT ON InvoiceDetail
FOR EACH ROW
BEGIN
    DECLARE maxDebt DECIMAL(10, 2);
    DECLARE minStockAfterSale INT;
    DECLARE currentStock INT;
    DECLARE currentDebt DECIMAL(10, 2);

    SELECT Max_Debt, Min_Stock_After_Sale INTO maxDebt, minStockAfterSale FROM RegulationSettings WHERE Regulation_ID = 1;

    SELECT Current_Stock INTO currentStock FROM Books WHERE bookID = NEW.bookID;

    SELECT Debt INTO currentDebt FROM Customers WHERE customerID = (SELECT ID_Customer FROM Invoice WHERE ID_Invoice = NEW.ID_Invoice);

    IF currentStock - NEW.Quantity_Sold < minStockAfterSale THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Số lượng tồn sau khi bán không được nhỏ hơn số lượng tồn tối thiểu theo quy định.';
    END IF;

    IF currentDebt > maxDebt THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Số tiền nợ hiện tại của khách hàng đã vượt quá giới hạn nợ tối đa cho phép.';
    END IF;
END//
DELIMITER ;

-- Trigger kiểm tra QĐ4 khi thêm phiếu thu tiền
DELIMITER //
CREATE TRIGGER trg_CheckPaymentReceipt
BEFORE INSERT ON PaymentReceipt
FOR EACH ROW
BEGIN
    DECLARE useRegulation4 BOOLEAN;
    DECLARE currentDebt DECIMAL(10, 2);

    SELECT Use_Regulation_4 INTO useRegulation4 FROM RegulationSettings WHERE Regulation_ID = 1;

    IF useRegulation4 THEN
        SELECT Debt INTO currentDebt FROM Customers WHERE customerID = NEW.ID_Customer;

        IF NEW.Amount_Collected > currentDebt THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Số tiền thu không được vượt quá số tiền khách hàng đang nợ.';
        END IF;
    END IF;
END//
DELIMITER ;

SELECT * FROM Admins;
SELECT * FROM Customers;
SELECT * FROM Authors;
SELECT * FROM Publishers;
SELECT * FROM Inventory;
SELECT * FROM Books;
SELECT * FROM Orders;
SELECT * FROM Payment;
SELECT * FROM ContactUs;

-- TRANSACTION
DELIMITER $$
CREATE PROCEDURE temp()
BEGIN
	DECLARE _rollback BOOL DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR 1051 SET _rollback=1;
    DECLARE CONTINUE HANDLER FOR 1048 SET _rollback=1;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET _rollback=1;
	START TRANSACTION;
		INSERT INTO Orders(customerID,bookID,quantity,total,timestamp) VALUES('','','','','');
        UPDATE Inventory SET soldStock = soldStock + '' WHERE bookID = '';
        UPDATE Inventory SET totalStock = totalStock + '' WHERE bookID = '';
        INSERT INTO Payment(customerID,paymentInfo) VALUES ('','');
		IF _rollback = 1 THEN
			ROLLBACK;
		ELSE
			COMMIT;
		END IF;
END $$
DELIMITER ;

