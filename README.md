# Basic Bank Database Project

This project demonstrates a simple database structure for a banking system, using MySQL to manage accounts and transactions. The database includes tables for storing account information, transaction history, and views for summarizing account activity. Additionally, it includes a trigger to automatically update account balances after a transaction.

## Table of Contents

- [Database Setup](#database-setup)
- [Tables](#tables)
  - [Accounts Table](#accounts-table)
  - [Transactions Table](#transactions-table)
- [Views](#views)
- [Triggers](#triggers)
- [Stored Procedures](#stored-procedures)
  - [Insert Transaction Procedure](#insert-transaction-procedure)
  - [Calling the Stored Procedure](#calling-the-stored-procedure)
- [Usage](#usage)
  - [Inserting Data](#inserting-data)
  - [View Account Summary](#view-account-summary)
  - [Transaction Example](#transaction-example)
- [License](#license)

---

## Database Setup

### 1. Create a new database

First, create a new database called `bank`:

```sql
CREATE DATABASE bank;
````

### 2. Select the database

Now, use the newly created database:

```sql
USE bank;
```

---

## Tables

### Accounts Table

The `accounts` table stores the details of each account, including the account ID, name of the account holder, and their balance.

```sql
CREATE TABLE accounts (
  id INT PRIMARY KEY,       -- Account ID (Primary Key)
  name VARCHAR(100),        -- Account holder's name
  balance DECIMAL(10, 2)    -- Account balance
);
```

### Transactions Table

The `transactions` table logs every transaction made by an account. It stores the transaction ID, associated account ID, transaction amount, and the date of the transaction.

```sql
CREATE TABLE transactions (
  id INT PRIMARY KEY,       -- Transaction ID (Primary Key)
  account_id INT,           -- Associated Account ID
  amount DECIMAL(10, 2),    -- Transaction amount
  transaction_date DATE,    -- Date of the transaction
  FOREIGN KEY (account_id) REFERENCES accounts(id)  -- Foreign Key linking to accounts
);
```

---

## Views

### Account Summary View

The `account_summary` view aggregates the total amount of transactions for each account. It joins the `accounts` and `transactions` tables to provide a summary of each account's transaction history.

```sql
CREATE VIEW account_summary AS
SELECT 
    a.id,
    a.name,
    SUM(t.amount) AS total
FROM accounts a
JOIN transactions t 
    ON a.id = t.account_id
GROUP BY a.id, a.name;
```

To update or replace the view, use:

```sql
CREATE OR REPLACE VIEW account_summary AS
SELECT 
    a.id,
    a.name,
    SUM(t.amount) AS total
FROM accounts a
JOIN transactions t 
    ON a.id = t.account_id
GROUP BY a.id, a.name;
```

---

## Triggers

### Update Balance After Transaction Trigger

The `update_balance_after_transaction` trigger automatically updates the account balance in the `accounts` table after a new transaction is inserted into the `transactions` table.

```sql
DELIMITER //

CREATE TRIGGER update_balance_after_transaction
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    -- Update the account balance after a transaction
    UPDATE accounts 
    SET balance = balance + NEW.amount
    WHERE id = NEW.account_id;
END//

DELIMITER ;
```

---

## Stored Procedures

### Insert Transaction Procedure

The `insert_transaction` stored procedure allows inserting a transaction and automatically updates the account balance. It takes three parameters: `account_id`, `amount`, and `transaction_date`.

```sql
DELIMITER //

CREATE PROCEDURE insert_transaction(
    IN p_account_id INT,        -- Account ID
    IN p_amount DECIMAL(10,2),  -- Transaction Amount
    IN p_transaction_date DATE  -- Transaction Date
)
BEGIN
    -- Insert the transaction into the transactions table
    INSERT INTO transactions (account_id, amount, transaction_date)
    VALUES (p_account_id, p_amount, p_transaction_date);

    -- Update the balance of the account after the transaction
    UPDATE accounts
    SET balance = balance + p_amount
    WHERE id = p_account_id;
END//

DELIMITER ;
```

### Calling the Stored Procedure

Once the stored procedure is created, you can call it to insert transactions and update balances. Example calls:

```sql
-- Call the procedure to insert a deposit of 200 to account 1 on '2025-12-12'
CALL insert_transaction(1, 200, '2025-12-12');

-- Call the procedure to insert a withdrawal of 50 from account 1 on '2025-12-13'
CALL insert_transaction(1, -50, '2025-12-13');
```

---

## Usage

### Inserting Data

Here’s an example of how to insert data into the `accounts` and `transactions` tables:

```sql
-- Inserting account details
INSERT INTO accounts (id, name, balance) 
VALUES (1, 'Rahul', 100);

-- Inserting a transaction
INSERT INTO transactions (id, account_id, amount, transaction_date) 
VALUES (2, 1, 400, '2025-12-12');
```

### View Account Summary

To see the total transaction amount for each account, run the following query:

```sql
SELECT * FROM account_summary;
```

### Transaction Example

Let’s add a few more transactions and observe how the balance updates automatically:

```sql
-- Adding a new transaction
INSERT INTO transactions (id, account_id, amount, transaction_date) 
VALUES (4, 1, 150, '2025-12-14');

-- Checking updated account balance
SELECT * FROM accounts;

-- Another transaction
INSERT INTO transactions (id, account_id, amount, transaction_date) 
VALUES (5, 1, 350, '2025-12-15');
```

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

### Key Features

* **Database Setup**: Instructions on how to set up the `bank` database.
* **Tables**: Detailed explanation of the two tables — `accounts` and `transactions`.
* **Views**: Summarized account activity through the `account_summary` view.
* **Triggers**: Automatically updates account balances after transactions.
* **Stored Procedures**: Procedures to automate inserting transactions and updating balances.
* **Usage**: How to insert data, view summaries, and call procedures.

### Future Enhancements

* **Customer Information**: You can extend the schema by adding a `customers` table to store personal customer details.
* **Transaction Types**: Implement different types of transactions (deposits, withdrawals, transfers).
* **Error Handling**: Add error handling and checks to prevent overdrafts or invalid transactions.
* **Reporting**: Implement more complex reports, such as transaction history, account statements, or monthly summaries.

This README is designed to provide clear and structured information about setting up and using the Bank Database. Feel free to extend it as you develop the project further!


### Improvements:
1. **Clearer Table Structure**: Improved table explanations and added data types for each field (e.g., `DECIMAL(10, 2)` for amounts).
2. **Consistent Formatting**: Added consistent headings, bullet points, and improved section order for better readability.
3. **Example Usage**: Provided clear instructions on how to use stored procedures and queries in the `Usage` section.
4. **Future Enhancements**: Suggested potential improvements for the project like adding customer information, transaction types, and reporting.

This structure is designed to be comprehensive, user-friendly, and easy to extend as your project grows.

