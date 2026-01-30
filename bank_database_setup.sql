-- Create the database
CREATE DATABASE IF NOT EXISTS bank;

-- Select the newly created database
USE bank;

-- -------------------------------
-- Creating the Accounts Table
-- -------------------------------

CREATE TABLE IF NOT EXISTS accounts (
    id INT PRIMARY KEY,          -- Account ID (Primary Key)
    name VARCHAR(100),           -- Account holder's name
    balance DECIMAL              -- Account balance
);

-- Insert initial account data
INSERT INTO accounts (id, name, balance) 
VALUES (1, 'Rahul', 100);

-- -------------------------------
-- Creating the Transactions Table
-- -------------------------------

CREATE TABLE IF NOT EXISTS transactions (
    id INT PRIMARY KEY,          -- Transaction ID (Primary Key)
    account_id INT,              -- Associated Account ID
    amount DECIMAL,              -- Amount of the transaction
    transaction_date DATE,       -- Date of the transaction
    FOREIGN KEY (account_id) REFERENCES accounts(id)  -- Foreign Key linking to Accounts
);

-- Insert initial transaction data
INSERT INTO transactions (id, account_id, amount, transaction_date) 
VALUES (2, 1, 400, '2025-12-12');

-- -------------------------------
-- Creating the Account Summary View
-- -------------------------------

CREATE OR REPLACE VIEW account_summary AS
SELECT 
    a.id,
    a.name,
    SUM(t.amount) AS total
FROM accounts a
JOIN transactions t 
    ON a.id = t.account_id
GROUP BY a.id, a.name;

-- -------------------------------
-- Creating the Trigger for Updating Balance
-- -------------------------------

-- Temporarily change delimiter to avoid issues with semicolons inside the trigger
DELIMITER //

CREATE TRIGGER update_balance_after_transaction
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    -- Update the balance of the account after each transaction
    UPDATE accounts 
    SET balance = balance + NEW.amount
    WHERE id = NEW.account_id;
END//

-- Reset delimiter back to semicolon
DELIMITER ;

-- -------------------------------
-- Sample Transactions to Test the Trigger
-- -------------------------------

-- Adding a new transaction
INSERT INTO transactions (id, account_id, amount, transaction_date) 
VALUES (4, 1, 150, '2025-12-14');

-- Adding another transaction
INSERT INTO transactions (id, account_id, amount, transaction_date) 
VALUES (5, 1, 350, '2025-12-15');

-- -------------------------------
-- Query to Check Account Data
-- -------------------------------

-- View all accounts and balances
SELECT * FROM accounts;

-- View the account summary (name and total amount of transactions)
SELECT * FROM account_summary;

