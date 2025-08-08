2. library_data.sql


-- Insert 300 sample Books into SQL Server
DECLARE @i INT = 1;

WHILE @i <= 300
BEGIN
    INSERT INTO Books (Title, Author, Genre, TotalCopies, AvailableCopies)
    VALUES (
        CONCAT('Book Title ', @i),
        CONCAT('Author ', @i),
        CASE 
            WHEN @i % 4 = 0 THEN 'Fiction'
            WHEN @i % 4 = 1 THEN 'Non-fiction'
            WHEN @i % 4 = 2 THEN 'Science'
            ELSE 'History'
        END,
        (3 + (@i % 5)),  -- Total copies between 3 and 7
        (3 + (@i % 5))   -- Initially available copies same as total
    );

    SET @i += 1;
END;

-- Insert 300 sample Members
DECLARE @i INT = 1;

WHILE @i <= 300
BEGIN
    INSERT INTO Members (Name, Email, JoinDate)
    VALUES (
        CONCAT('Member ', @i),
        CONCAT('member', @i, '@example.com'),
        DATEADD(DAY, -(@i % 365), GETDATE()) -- Random-ish date in last year
    );

    SET @i += 1;
End;



-- Insert 300 sample Staff
DECLARE @i INT = 1;

WHILE @i <= 300
BEGIN
    INSERT INTO Staff (Name, Role)
    VALUES (
        CONCAT('Staff Member ', @i),
        CASE 
            WHEN @i % 4 = 0 THEN 'Librarian'
            WHEN @i % 4 = 1 THEN 'Assistant'
            WHEN @i % 4 = 2 THEN 'Manager'
            ELSE 'Clerk'
        END
    );

    SET @i += 1;
End;


-- Insert 300 sample IssuedBooks
DECLARE @i INT = 1;

WHILE @i <= 300
BEGIN
    INSERT INTO IssuedBooks (BookID, MemberID, StaffID, IssueDate, DueDate, ReturnDate)
    VALUES (
        ((@i % 300) + 1), -- Random BookID between 1 and 300
        ((@i % 50) + 1),  -- Random MemberID between 1 and 50
        ((@i % 5) + 1),   -- Random StaffID between 1 and 5
        DATEADD(DAY, -(@i % 60), GETDATE()), -- Issue date within last 60 days
        DATEADD(DAY, -(@i % 60) + 14, GETDATE()), -- Due date 14 days after issue
        CASE 
            WHEN @i % 3 = 0 THEN DATEADD(DAY, -(@i % 60) + 10, GETDATE()) -- Some returned early
            WHEN @i % 5 = 0 THEN NULL -- Some not yet returned
            ELSE DATEADD(DAY, -(@i % 60) + 16, GETDATE()) -- Some returned late
        END
    );

    SET @i += 1;
END;

3. library_features.sql

--Query Overdue Books & Auto-Calculate Fines

-- Assuming fine = ?10 per day overdue
SELECT 
    ib.IssueID,
    m.Name AS MemberName,
    b.Title AS BookTitle,
    DATEDIFF(DAY, ib.DueDate, CAST(GETDATE() AS DATE)) AS DaysOverdue,
    (DATEDIFF(DAY, ib.DueDate, CAST(GETDATE() AS DATE)) * 10) AS FineAmount
FROM IssuedBooks ib
JOIN Members m ON ib.MemberID = m.MemberID
JOIN Books b ON ib.BookID = b.BookID
WHERE ib.ReturnDate IS NULL
  AND ib.DueDate < CAST(GETDATE() AS DATE);

 --Track Most Borrowed Books

SELECT b.Title, COUNT(*) AS TimesBorrowed
FROM IssuedBooks ib
JOIN Books b ON ib.BookID = b.BookID
GROUP BY b.Title
ORDER BY TimesBorrowed DESC;


--Trigger: Update Stock on Issue
CREATE TRIGGER decrease_stock
ON IssuedBooks
AFTER INSERT
AS
BEGIN
    -- Update AvailableCopies for each inserted book
    UPDATE b
    SET b.AvailableCopies = b.AvailableCopies - 1
    FROM Books b
    INNER JOIN inserted i ON b.BookID = i.BookID;
END;

--Trigger: Update Stock on Return

CREATE TRIGGER increase_stock
ON IssuedBooks
AFTER UPDATE
AS
BEGIN
    -- Increase AvailableCopies only for rows where ReturnDate changed from NULL to NOT NULL
    UPDATE b
    SET b.AvailableCopies = b.AvailableCopies + 1
    FROM Books b
    INNER JOIN inserted i ON b.BookID = i.BookID
    INNER JOIN deleted d ON i.IssueID = d.IssueID
    WHERE d.ReturnDate IS NULL
      AND i.ReturnDate IS NOT NULL;
END;

--Stored Procedure: Search Books

CREATE or ALTER PROCEDURE SearchBooks
    @searchTerm VARCHAR(100)
AS
BEGIN
    SELECT *
    FROM Books
    WHERE Title LIKE '%' + @searchTerm + '%'
       OR Author LIKE '%' + @searchTerm + '%'
       OR Genre LIKE '%' + @searchTerm + '%';
END;
GO

-- Example call:
EXEC SearchBooks 'Fiction';