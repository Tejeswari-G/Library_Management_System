1.library_schema.sql

-- Books Table
CREATE TABLE Books (
    BookID INT PRIMARY KEY IDENTITY(1,1),
    Title VARCHAR(100) NOT NULL,
    Author VARCHAR(100),
    Genre VARCHAR(50),
    TotalCopies INT NOT NULL,
    AvailableCopies INT NOT NULL
);

-- Members Table
CREATE TABLE Members (
    MemberID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    JoinDate DATE
);

-- Staff Table
CREATE TABLE Staff (
    StaffID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(100),
    Role VARCHAR(50)
);

-- Issued Books Table
CREATE TABLE IssuedBooks (
    IssueID INT PRIMARY KEY IDENTITY(1,1),
    BookID INT,
    MemberID INT,
    StaffID INT,
    IssueDate DATE,
    DueDate DATE,
    ReturnDate DATE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);

-- Fines Table
CREATE TABLE Fines (
    FineID INT PRIMARY KEY IDENTITY(1,1),
    IssueID INT,
    FineAmount DECIMAL(6,2),
    Paid BIT DEFAULT 0,
    FOREIGN KEY (IssueID) REFERENCES IssuedBooks(IssueID)
);

