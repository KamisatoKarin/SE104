from flask import Flask,jsonify,request,render_template,redirect,url_for,session
from flask_mysqldb import MySQL
import MySQLdb.cursors,re,datetime,os
from os import getenv
from dotenv import load_dotenv


from utils.home import *
from utils.loginregister import *
from utils.book import *
from utils.search import *
from utils.user import *
from utils.orders import *

load_dotenv()
mysql_host = getenv('MYSQL_HOST',None)
mysql_user = getenv('MYSQL_USER',None)
mysql_password = getenv('MYSQL_PASSWORD',None)
mysql_db = getenv('MYSQL_DB',None)

app = Flask(__name__)

app.config['MYSQL_HOST'] = mysql_host
app.config['MYSQL_USER'] = mysql_user
app.config['MYSQL_PASSWORD'] = mysql_password
app.config['MYSQL_DB'] = mysql_db

app.secret_key = b'_5#y2L"F4Q8z\n\xec]/'  # all the session data is encrypted in the server so we need a secret key to encrypt and decrypt the data


mysql = MySQL(app)


def is_admin():
    return session.get("accountType") == "admin"

# home page route
@app.route("/")
def homeRoute():
    booksData = allBooks(mysql)
    genreData = allGenre(mysql)
    return render_template("home.html",booksData=booksData,genreData=genreData)

# home page for customers
@app.route("/customerindex",methods=["POST","GET"])
def customerindexRoute():
    booksData = allBooks(mysql)
    genreData = allGenre(mysql)
    return render_template("customerindex.html",booksData=booksData,genreData=genreData)

# home page for admins
@app.route("/adminindex",methods=["POST","GET"])
def adminindexRoute():
    booksData = allBooks(mysql)
    genreData = allGenre(mysql)
    return render_template("adminindex.html",booksData=booksData,genreData=genreData)

# Customer Registration route
@app.route("/register",methods=["POST","GET"])
def registerRoute():
    if request.method == "POST":
        username = str(request.form.get("username"))
        fname = str(request.form.get("fname"))
        lname = str(request.form.get("lname"))
        email = str(request.form.get("email"))
        password = str(request.form.get("password"))
        phone = str(request.form.get("phone"))
        country = str(request.form.get("country"))
        state = str(request.form.get("state"))
        pincode = str(request.form.get("pincode"))
        address = str(request.form.get("address"))

        response = register(mysql,username,fname,lname,email,password,phone,country,state,pincode,address)
        
        if response == 1: # regsitration is successful
            return render_template("login.html",response=response)
        else: # registration failed
            return render_template("register.html",response=response)

    return render_template("register.html")

# login for customers and admins route
@app.route("/login",methods=["POST","GET"])
def loginRoute():
    if request.method == "POST":
        username = request.form.get("username")
        password = request.form.get("password")
        account = request.form.get("account")

        if account=="customer":
            response = customerLogin(mysql,username,password,account)
            if response == 1: # login success
                session["userID"] = username # creating a session of the username
                session["accountType"] = account # creating a session of the account type
                return redirect(url_for("customerindexRoute"))
            else: # Login failed
                return render_template("login.html",response = response)

        if account=="admin":
            response = adminLogin(mysql,username,password,account)
            if response == 1: # login success
                session["userID"] = username # creating a session of the username
                session["accountType"] = account # creating a session of the account type
                return redirect(url_for("adminindexRoute"))
            else: # login failed
                return render_template("login.html",response=response)

    return render_template("login.html")

# search books in admin portal
@app.route("/search",methods=["POST","GET"])
def searchRoute():
    if request.method == "POST":
        search = str(request.form.get("search"))
        query = str(request.form.get("query"))

        if search == "title": # search by title
            booksData = searchTitle(mysql,query)
            return render_template("search.html",booksData=booksData,search=search)
        
        if search == "genre": # search by genre
            booksData = searchGenre(mysql,query)
            return render_template("search.html",booksData=booksData,search=search)
        
        if search == "author": # search by author
            booksData = searchAuthor(mysql,query)
            return render_template("search.html",booksData=booksData,search=search)

        return render_template("search.html")
    
    return render_template("search.html")

# search books in admin portal
@app.route("/customersearch",methods=["POST","GET"])
def customersearchRoute():
    if request.method == "POST":
        search = str(request.form.get("search"))
        query = str(request.form.get("query"))

        if search == "title": # search by title
            booksData = searchTitle(mysql,query)
            return render_template("customersearch.html",booksData=booksData,search=search)
        
        if search == "genre": # search by genre
            booksData = searchGenre(mysql,query)
            return render_template("customersearch.html",booksData=booksData,search=search)
        
        if search == "author": # search by author
            booksData = searchAuthor(mysql,query)
            return render_template("customersearch.html",booksData=booksData,search=search)

        return render_template("customersearch.html")
    
    return render_template("customersearch.html")

# Add/Delete/Update Book Route for Admin
@app.route("/books",methods=["POST","GET"])
def booksRoute():
        booksData = allBooks(mysql)
        genreData = allGenre(mysql)
        return render_template("books.html",booksData=booksData,genreData=genreData)

# Add Book Route
@app.route("/addBook", methods=["POST", "GET"])
def addBookRoute():
    if request.method == "POST":
        bookID = int(request.form.get("bookID"))
        title = str(request.form.get("title"))
        genre = str(request.form.get("genre"))
        fname = str(request.form.get("fname"))
        lname = str(request.form.get("lname"))
        year = int(request.form.get("year"))
        purchase_price = float(request.form.get("purchase_price"))
        selling_price = float(request.form.get("selling_price"))
        country = str(request.form.get("country"))
        stock = int(request.form.get("stock"))

        # Database transaction
        cur = mysql.connection.cursor()
        try:
            # Add author if not exists
            cur.execute("SELECT authorID FROM Authors WHERE firstName = %s AND lastName = %s", (fname, lname))
            author = cur.fetchone()
            if not author:
                cur.execute("INSERT INTO Authors(firstName, lastName) VALUES (%s, %s)", (fname, lname))
                cur.execute("SELECT authorID FROM Authors WHERE firstName = %s AND lastName = %s", (fname, lname))
                author = cur.fetchone()
            authorID = author[0]

            # Add publisher if not exists
            cur.execute("SELECT publisherID FROM Publishers WHERE country = %s", (country,))
            publisher = cur.fetchone()
            if not publisher:
                cur.execute("INSERT INTO Publishers(country) VALUES (%s)", (country,))
                cur.execute("SELECT publisherID FROM Publishers WHERE country = %s", (country,))
                publisher = cur.fetchone()
            publisherID = publisher[0]

            # Add book to Books table
            cur.execute(
                """
                INSERT INTO Books(
                    bookID, authorID, publisherID, title, genre, publicationYear,
                    Purchase_Price, Selling_Price, Current_Stock, Quantity, Author, Category
                ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                """,
                (bookID, authorID, publisherID, title, genre, year, purchase_price, selling_price, stock, stock, f"{fname} {lname}", genre)
            )

            # Add book to Inventory table
            cur.execute(
                "INSERT INTO Inventory(bookID, totalStock, soldStock) VALUES (%s, %s, %s)",
                (bookID, stock, 0)
            )

            mysql.connection.commit()
            response = 1  # Success
        except Exception as e:
            print("Error adding book or updating inventory:", e)
            mysql.connection.rollback()
            response = 0  # Failure
        finally:
            cur.close()

        # Return updated data to the template
        booksData = allBooks(mysql)
        genreData = allGenre(mysql)
        return render_template("books.html", booksData=booksData, genreData=genreData, response=response)

    return redirect(url_for("booksRoute"))



# Update Book Route
@app.route("/updateBook",methods=["POST","GET"])
def updateBookRoute():
    if request.method == "POST":
        bookID = str(request.form.get("bookID"))
        price1 = str(request.form.get("price1"))
        price2 = str(request.form.get("price2"))
        fname = str(request.form.get("fname"))
        lname = str(request.form.get("lname"))
        country = str(request.form.get("country"))

        response = updateBook(mysql,bookID,price1,price2,fname,lname,country)
        if response == 1: # book updated successfully
            booksData = allBooks(mysql)
            genreData = allGenre(mysql)
            return render_template("books.html",booksData=booksData,genreData=genreData,response=response)

        else: # book failed to update
            booksData = allBooks(mysql)
            genreData = allGenre(mysql)
            return render_template("books.html",booksData=booksData,genreData=genreData,response=response)

    return redirect(url_for("booksRoute"))

# delete book Route
@app.route("/deleteBook",methods=["POST","GET"])
def deleteBookRoute():
    if request.method == "POST":
        bookID = str(request.form.get("bookID"))
        fname = str(request.form.get("fname"))
        lname = str(request.form.get("lname"))
        country = str(request.form.get("country"))

        response = deleteBook(mysql,bookID,fname,lname,country)
        if response == 1: # book deleted successfully
            booksData = allBooks(mysql)
            genreData = allGenre(mysql)
            return render_template("books.html",booksData=booksData,genreData=genreData,response=response)

        else: # book failed to delete
            booksData = allBooks(mysql)
            genreData = allGenre(mysql)
            return render_template("books.html",booksData=booksData,genreData=genreData,response=response)

    return redirect(url_for("booksRoute"))

# display book details route for customers
@app.route("/bookdetail<subject>",methods=["POST","GET"])
def bookDetailsRoute(subject):
    bookData = bookDetail(mysql,subject)
    return render_template("bookdetail.html",bookData=bookData)

# display book details route for admin
@app.route("/bookDetailsAdmin<subject>",methods=["POST","GET"])
def bookDetailsAdminRoute(subject):
    bookData = bookDetail(mysql,subject)
    return render_template("bookdetail2.html",bookData=bookData)

# inventory route
@app.route("/inventory",methods=["POST","GET"])
def inventoryRoute():
    bookData = inventory(mysql)
    return render_template("inventory.html",bookData=bookData)

# buy book route
@app.route("/buyBook<bookID>",methods=["POST","GET"])
def buyBookRoute(bookID):
    if request.method =="POST":
        quantity = str(request.form.get("quantity"))
        bookData = totalBookPrice(mysql,bookID,quantity)
        totalPrice = int(bookData[1]) * int(quantity)
        return render_template("payment.html",bookData=bookData,quantity=quantity,totalPrice=totalPrice)
        
    return "USE POST METHOD ONLY"
    
# pay order route
@app.route("/pay<isbn>/<quantity>/<total>",methods=["POST","GET"])
def payRoute(isbn,quantity,total):
    if request.method =="POST":
        pay = str(request.form.get("pay"))

        response = orders(mysql,isbn,quantity,total,pay,session["userID"])
        return redirect(url_for('orderconfirmationRoute',response = response))
        # return render_template("orderconfirmation.html",response=response)

    return "USE POST METHOD ONLY"

# order confirmation route
@app.route("/orderconfirmation<response>",methods=["POST","GET"])
def orderconfirmationRoute(response):
    return render_template("orderconfirmation.html",response=response)


# display users route
@app.route("/users",methods=["POST","GET"])
def usersRoute():
    adminData = admin(mysql)
    customerData = customers(mysql)
    return render_template("users.html",adminData=adminData,customerData=customerData)

# display  orders in customers and admins account account
@app.route("/myorders",methods=["POST","GET"])
def ordersRoute():
    userID = session["userID"]
    accountType = session["accountType"]

    if session["accountType"] == None or session["userID"]== None:
        return "ERROR"

    if session["accountType"]=="admin":
        Data = allorders(mysql,userID)
        return render_template("myorders.html",Data=Data,accountType=accountType)

    if session["accountType"]=="customer":
        Data = myorder(mysql,userID)
        return render_template("myorders.html",Data=Data,accountType=accountType)
    
    return "ERROR"

# display logged in users account
@app.route("/myaccount",methods=["POST","GET"])
def myAccountRoute():
    userID = session["userID"]
    accountType = session["accountType"]

    if session["accountType"] == None or session["userID"]== None:
        return "ERROR"

    if session["accountType"]=="admin":
        Data = adminAccount(mysql,userID)
        return render_template("myaccount.html",Data=Data,accountType=accountType)

    if session["accountType"]=="customer":
        Data = customerAccount(mysql,userID)
        return render_template("myaccount.html",Data=Data,accountType=accountType)
    
    return "ERROR"

# contact us route
@app.route("/contactUs",methods=["POST","GET"])
def contactUsRoute():
    if request.method == "POST":
        fname = str(request.form.get("fname"))
        lname = str(request.form.get("lname"))
        email = str(request.form.get("email"))
        message = str(request.form.get("message"))
        timestamp = datetime.datetime.now()
        response = contactUs(mysql,fname,lname,email,message,timestamp)
        if response == 1:
            return "Message Submitted"
        else:
            return "Failed to add message"
            
    return "Use POST METHOD ONLY"

# logout route
@app.route("/logout",methods = ["GET","POST"])
def logoutRoute():
    session.pop("userID",None) # removing username from session variable
    session.pop("accountType",None) # removing account from session variable
    booksData = allBooks(mysql)
    genreData = allGenre(mysql)
    return render_template("home.html",booksData=booksData,genreData=genreData)

# Thêm route mới cho hủy đơn hàng
@app.route("/cancelOrder/<orderID>", methods=["POST"])
def cancelOrderRoute(orderID):
    if "userID" not in session:
        return redirect(url_for("loginRoute"))
        
    response = cancelOrder(mysql, orderID)
    return render_template("cancelconfirmation.html", response=response)

@app.route("/inventory-report", methods=["GET", "POST"])
def inventory_report():
    if not is_admin():
        return "Access Denied: Admins Only", 403

    if request.method == "POST":
        # B1: Nhận thông tin tháng và năm
        month = int(request.form.get("month"))
        year = int(request.form.get("year"))

        # B2: Kết nối cơ sở dữ liệu
        cur = mysql.connection.cursor()

        # B3: Lấy dữ liệu từ bảng Inventory và Books
        query = """
        SELECT
            b.bookID,
            b.title,
            i.totalStock AS Opening_Stock,
            (i.totalStock - i.soldStock) AS Transactions,
            i.soldStock AS Closing_Stock
        FROM
            Books b
        INNER JOIN
            Inventory i ON b.bookID = i.bookID;
        """
        cur.execute(query)
        inventory_data = cur.fetchall()

        # B4: Lưu báo cáo tồn kho vào InventoryReport
        for row in inventory_data:
            bookID, title, opening_stock, transactions, closing_stock = row
            insert_query = """
            INSERT INTO InventoryReport (Month, bookID, Opening_Stock, Transactions, Closing_Stock)
            VALUES (%s, %s, %s, %s, %s)
            ON DUPLICATE KEY UPDATE
                Opening_Stock = VALUES(Opening_Stock),
                Transactions = VALUES(Transactions),
                Closing_Stock = VALUES(Closing_Stock);
            """
            cur.execute(insert_query, (f"{year}-{month}-01", bookID, opening_stock, transactions, closing_stock))

        # B5: Đóng kết nối
        mysql.connection.commit()
        cur.close()

        # B6: Chuyển hướng tới trang hiển thị báo cáo
        return redirect(url_for("inventory_overview", month=month, year=year))

    # Trả về giao diện nhập thông tin báo cáo
    return render_template("inventory-report.html")

@app.route("/inventory-overview", methods=["GET"])
def inventory_overview():
    if not is_admin():
        return "Access Denied: Admins Only", 403

    # Nhận thông tin tháng và năm
    month = request.args.get("month", type=int)
    year = request.args.get("year", type=int)

    if not month or not year:
        return "Invalid request: Please provide both month and year.", 400

    # Kết nối cơ sở dữ liệu
    cur = mysql.connection.cursor()

    # Truy vấn dữ liệu từ InventoryReport
    query = """
    SELECT
        ir.Month,
        ir.bookID,
        b.title,
        ir.Opening_Stock,
        ir.Transactions,
        ir.Closing_Stock
    FROM
        InventoryReport ir
    INNER JOIN
        Books b ON ir.bookID = b.bookID
    WHERE
        MONTH(ir.Month) = %s AND YEAR(ir.Month) = %s
    """
    cur.execute(query, (month, year))
    inventory_data = cur.fetchall()

    # Đóng kết nối cơ sở dữ liệu
    cur.close()

    # Trả về giao diện hiển thị dữ liệu
    return render_template(
        "inventory-overview.html",
        inventory_data=inventory_data,
        month=month,
        year=year
    )


if __name__ == "__main__":
    app.run(debug=True)
