# 📚 Library Management System – SQL Server

## 📌 Project Overview
This Library Management System is a **SQL Server database project** that demonstrates skills in **T-SQL, database design, stored procedures, triggers, data generation, and reporting queries**.  
It simulates real-world library operations such as book issuing, fine calculation, stock updates, and member management.  
This project is suitable for **portfolio showcase** and **SQL-related job applications**.

---

## 🛠️ Tech Stack
- **Database:** SQL Server
- **Language:** T-SQL
- **Tools:** SQL Server Management Studio (SSMS)

---

## 📂 Project Structure
1. **library_schema.sql** – Creates database tables and relationships.
2. **library_data.sql** – Generates 300+ sample records for Books, Members, Staff, and IssuedBooks.
3. **library_features.sql** – Contains queries, triggers, and stored procedures for core operations.

---

## 📌 Features
- **Database Schema** for Books, Members, Staff, IssuedBooks, and Fines
- **Sample Data Generation** – 300+ sample records for testing
- **Overdue Books Tracking** with auto fine calculation
- **Most Borrowed Books Reporting**
- **Triggers** for updating book stock on issue and return
- **Stored Procedure** for flexible book search
- **Relational Integrity** with foreign keys

---

## 🚀 How to Run
1. Open **SQL Server Management Studio (SSMS)**.
2. Run `library_schema.sql` to create the database structure.
3. Run `library_data.sql` to insert sample data and create triggers, procedures, and useful queries.
5. Use the example queries below to interact with the system.

---

## 📊 Example Queries
**Search Books by Title/Author/Genre:**
```sql
EXEC SearchBooks 'Fiction';
