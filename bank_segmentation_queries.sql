CREATE TABLE customers (
	customer_id SERIAL PRIMARY KEY,
	name TEXT NOT NULL,
	gender VARCHAR(1) CHECK (gender IN ('M', 'F')),
	dob DATE,
	signup_date DATE NOT NULL,
	city TEXT
);

CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    account_type VARCHAR(20) CHECK (account_type IN ('savings', 'current', 'loan')),
    open_date DATE NOT NULL,
    balance NUMERIC(12,2) DEFAULT 0
);
ALTER TABLE accounts ADD COLUMN account_number TEXT;

CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    account_id INT REFERENCES accounts(account_id),
    transaction_date DATE NOT NULL,
    amount NUMERIC(12,2) NOT NULL,
    transaction_type VARCHAR(20),     
    description VARCHAR(50) 
);

---DATA QUERYING FOR FINANCIAL INSIGHTS
SELECT * FROM accounts
SELECT * FROM customers
SELECT * FROM transactions

--Total Spend per Customer
--Calculate total amount spent per customer across all accounts.
SELECT c.customer_id, c.name, a.account_type,SUM(t.amount) AS Total_spent FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN transactions t ON a.account_id = t.account_id
WHERE transaction_type = 'debit'
GROUP BY c.customer_id, c.name, a.account_type
ORDER BY Total_spent DESC

--Most Active Accounts 
--Find accounts with the highest number of transactions.
SELECT t.account_id, c.name , COUNT(*) AS transaction_count FROM customers c
JOIN  accounts a ON c.customer_id = a.customer_id
JOIN transactions t ON a.account_id = t.account_id
GROUP BY  t.account_id, c.name 
ORDER BY transaction_count  DESC
LIMIT 10

--Most Active Accounts (Volume)
--Rank accounts by total transaction volume.
SELECT a.account_id,c.name, SUM(t.amount) AS Total_Volume,
RANK() OVER(ORDER BY  SUM(t.amount) DESC) AS Volume_rank FROM customers c
JOIN  accounts a ON c.customer_id = a.customer_id
JOIN transactions t ON a.account_id = t.account_id
GROUP BY a.account_id , c.name
ORDER BY Volume_rank DESC

--Monthly Transaction Breakdown	
--View total transaction count and volume per month.
SELECT TO_CHAR(DATE_TRUNC('month' ,transaction_date), 'YYYY-MM') AS Month,
COUNT(*) AS Transaction_Count,
SUM(amount) AS Transaction_Volume
FROM transactions
GROUP BY DATE_TRUNC('month' ,transaction_date)
ORDER BY Month

--Yearly Transaction Breakdown	
--Track annual transaction growth or decline.
SELECT TO_CHAR(DATE_TRUNC('year' ,transaction_date), 'YYYY') AS Year,
COUNT(*) AS Transaction_Count,
SUM(amount) AS Transaction_Volume
FROM transactions
GROUP BY DATE_TRUNC('year' ,transaction_date)
ORDER BY Year

--Top 20 High-Value Customers
--Rank customers based on credit inflow (e.g., deposits, salary).
SELECT c.customer_id, c.name, SUM(t.amount) AS Credit_inflow
FROM customers c
JOIN accounts a ON a.customer_id = c.customer_id
JOIN transactions t ON a.account_id = t.account_id
WHERE t.transaction_type = 'credit'
GROUP BY c.customer_id, c.name
ORDER BY Credit_inflow DESC
LIMIT 20

--Dormant Accounts
--Detect customers who’ve had no activity in the last 12 months.
SELECT c.customer_id, c.name, MAX(t.transaction_date) as Last_transaction
FROM customers c
JOIN accounts a ON a.customer_id = c.customer_id
LEFT JOIN transactions t ON t.account_id = a.account_id
GROUP BY c.customer_id, c.name
HAVING MAX(transaction_date) < CURRENT_DATE - INTERVAL '12 months'
ORDER BY MAX(transaction_date);

--Single Product Customers
--Identify customers holding only one account.
SELECT c.customer_id, c.name , COUNT(account_id) AS Total_accounts
FROM customers c
JOIN accounts a ON a.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(account_id)=1

--Most Used Transaction Services
--Discover the most frequent transaction descriptions (e.g., airtime, utility).
SELECT (description) as Transaction_count ,
SUM(amount) AS Total_ammount
FROM transactions
GROUP BY Transaction_count 
ORDER BY Total_ammount DESC

--City-wise Performance
--Measure total volume and number of customers per city.
SELECT  c.city , 
COUNT(DISTINCT c.customer_id) AS Total_Customer,
SUM(t.amount) AS Total_volume 
from customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN transactions t ON t.account_id = a.account_id
GROUP BY  c.city
ORDER BY Total_volume DESC

--Engagement by Region	
--Analyze activity vs dormancy spread across regions.
SELECT c.city, COUNT(DISTINCT c.customer_id) AS Total_Customers,
COUNT(DISTINCT a.account_id ) AS Total_Accounts,
COUNT(CASE WHEN t.transaction_date > CURRENT_DATE - INTERVAL '12 months' THEN 1 END) AS active_accounts,
COUNT(CASE WHEN t.transaction_date < CURRENT_DATE - INTERVAL '12 months' THEN 1 END) AS dormant_accounts
FROM customers c
LEFT JOIN accounts a ON c.customer_id = a.customer_id
LEFT JOIN transactions t ON a.account_id = t.transaction_id
GROUP BY c.city
ORDER BY total_customers DESC

































