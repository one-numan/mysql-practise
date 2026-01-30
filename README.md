
## MySQL Practise

````markdown
# Bank Database Project

This project demonstrates a simple database structure for a banking system, using SQL to manage accounts and transactions. The database includes tables for storing account information, transaction history, and views for summarizing account activity. It also includes a trigger to automatically update account balances after a transaction.

## Table of Contents
- [Database Setup](#database-setup)
- [Tables](#tables)
  - [Accounts Table](#accounts-table)
  - [Transactions Table](#transactions-table)
- [Views](#views)
- [Triggers](#triggers)
- [Usage](#usage)
  - [Inserting Data](#inserting-data)
  - [View the Account Summary](#view-the-account-summary)
  - [Transaction Example](#transaction-example)
- [License](#license)

## Database Setup

To set up the database:

1. Create a new database named `bank`:
   ```sql
   CREATE DATABASE bank;
````

2. Select the `bank` database:

   ```sql
   USE bank;
   ```

## Tables

### Accounts Table

This table stores the details of each account, including the account ID, name, and balance.

```sql
CREATE TABLE accounts (
  id INT PRIMARY KEY,
  name VARCHAR(100),
  balance DECIMAL
);
```

### Transactions Table

This table logs every transaction made by an account, storing the transaction ID, associated account ID, transaction amount, and the date the transaction occurred.

```sql
CREATE TABLE transactions (
  id INT PRIMARY KEY,
  account_id INT,
  amount DECIMAL,
  transaction_date DATE
);
```

## Views

### Account Summary View

The `account_summary` view aggregates the total amount of transactions for each account. It joins the `accounts` and `transactions` tables to provide a summary.

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

To update or replace the view, you can use the following SQL statement:

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

## Triggers

### Update Balance After Transaction Trigger

The trigger `update_balance_after_transaction` automatically updates the account balance in the `accounts` table after a new transaction is inserted into the `transactions` table.

```sql
DELIMITER //

CREATE TRIGGER update_balance_after_transaction
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    UPDATE accounts 
    SET balance = balance + NEW.amount
    WHERE id = NEW.account_id;
END//

DELIMITER ;
```

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

### View the Account Summary

To see the total transaction amount for each account:

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

The balance will be updated after each transaction is inserted, thanks to the trigger.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```

### Key Sections Explained:
- **Database Setup**: How to create and select the `bank` database.
- **Tables**: Detailed explanation of the two tables — `accounts` and `transactions`.
- **Views**: Explanation of the `account_summary` view.
- **Triggers**: Description of the `update_balance_after_transaction` trigger.
- **Usage**: Instructions on inserting data and viewing the results (account summary and transactions).

You can extend this README by adding a section for additional features or improvements, such as implementing more complex transactions, reports, or handling edge cases like overdrafts.
```
