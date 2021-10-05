CREATE DATABASE Library
USE Library;

CREATE TABLE Borrower
(
    uid INT PRIMARY KEY,
    title VARCHAR(3) NOT NULL CHECK (title IN ('Ms','Mrs','Mr')),
    gender CHAR(1) NOT NULL CHECK (gender IN ('M','F')),
    fname VARCHAR(30) NOT NULL,
    lname VARCHAR(30) NOT NULL,
    card_num CHAR(16) NOT NULL UNIQUE,
    card_cvv CHAR(3) NOT NULL,
    unit_no VARCHAR(5) NOT NULL,
    street VARCHAR(50) NOT NULL,
    suburb VARCHAR(50) NOT NULL,
    postcode VARCHAR(5) NOT NULL,
    state VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    contact_no VARCHAR(12) NOT NULL UNIQUE,
    registration_date DATE NOT NULL,
    expiry_date DATE NOT NULL,
    amount_due FLOAT NOT NULL DEFAULT 0,
    is_blacklisted BIT DEFAULT 0
);

CREATE TABLE Staff
(
    uid INT PRIMARY KEY,
    title VARCHAR(3) NOT NULL CHECK (title IN ('Ms','Mrs','Mr')),
    gender CHAR(1) NOT NULL CHECK (gender IN ('M','F')),
    fname VARCHAR(30) NOT NULL,
    lname VARCHAR(30) NOT NULL,
    unit_no VARCHAR(5) NOT NULL,
    street VARCHAR(50) NOT NULL,
    suburb VARCHAR(50) NOT NULL,
    postcode VARCHAR(5) NOT NULL,
    state VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    contact_no VARCHAR(12) NOT NULL UNIQUE,
    emp_type CHAR(1) DEFAULT 'S',
    is_manager BIT DEFAULT 0
);

CREATE TABLE Author
(
    author_id INT PRIMARY KEY,
    fname VARCHAR(30) NOT NULL,
    lname VARCHAR(30) NOT NULL
);

CREATE TABLE Author_Rec
(
    author_id INT NOT NULL REFERENCES Author(author_id)
);

CREATE TABLE Publisher(
    publisher_id INT PRIMARY KEY,
    name VARCHAR(80) NOT NULL,
    state VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL
)

CREATE TABLE Book
(
    isbn VARCHAR(13) PRIMARY KEY,
    publisher_id INT NOT NULL REFERENCES Publisher(publisher_id),
    purchased_by INT NOT NULL REFERENCES Staff(uid),
    book_title VARCHAR(50) NOT NULL,
    price FLOAT NOT NULL CHECK (price > 0),
    year_published INT CHECK (year_published > 1950),
    edition INT NOT NULL,
    date_purchased DATE NOT NULL,
    reorder_level INT NOT NULL CHECK (reorder_level > 0),
    category VARCHAR(50) NOT NULL
)

ALTER TABLE Author_Rec
ADD 
    isbn VARCHAR(13) NOT NULL REFERENCES Book(isbn)
PRIMARY KEY(isbn,author_id)


CREATE TABLE Stock
(
    book_code INT PRIMARY KEY,
    isbn VARCHAR(13) NOT NULL REFERENCES Book(isbn),
);

CREATE TABLE Order_Rec
(
    order_id INT PRIMARY KEY,
    uid INT NOT NULL REFERENCES Borrower(uid),
    book_code INT NOT NULL REFERENCES Stock(book_code),
    date DATE NOT NULL,
    is_delivered BIT DEFAULT 0
);

CREATE TABLE Book_Loan
(
    loan_id INT PRIMARY KEY,
    uid INT NOT NULL REFERENCES Borrower(uid),
    book_code INT REFERENCES Stock(book_code),
    borrowed_date DATE NOT NULL,
    due_date DATE NOT NULL,
    returned_date DATE,
    fine_amount FLOAT DEFAULT 0
)

CREATE TABLE Payment
(
    payment_id INT PRIMARY KEY,
    uid INT REFERENCES Borrower(uid),
    payment_type VARCHAR(1) NOT NULL CHECK (payment_type IN ('O','F')),
    amount FLOAT NOT NULL CHECK (amount > 0),
    date DATE NOT NULL
);

CREATE TABLE Order_Payment(
    payment_id INT REFERENCES Payment(payment_id),
    order_id INT REFERENCES Order_Rec(order_id),
    PRIMARY KEY(payment_id, order_id)
)

CREATE TABLE Loan_Payment(
    payment_id INT REFERENCES Payment(payment_id),
    loan_id INT REFERENCES Book_Loan(loan_id),
    PRIMARY KEY(payment_id, loan_id)
)

CREATE TABLE HourlyEmp
(
    uid INT PRIMARY KEY REFERENCES Staff(uid),
    hourly_wage FLOAT NOT NULL CHECK (hourly_wage > 0),
    work_hours FLOAT NOT NULL CHECK (work_hours > 0)
)

CREATE TABLE ContractEmp
(
    uid INT PRIMARY KEY REFERENCES Staff(uid),
    begin_date DATE NOT NULL,
    end_date DATE NOT NULL,
    salary FLOAT NOT NULL CHECK (salary > 0)
)

CREATE TABLE SalaryEmp
(
    uid INT PRIMARY KEY REFERENCES Staff(uid),
    annual_salary FLOAT NOT NULL CHECK (annual_salary > 0),
    comm_rate FLOAT NOT NULL CHECK (comm_rate > 0)
)
