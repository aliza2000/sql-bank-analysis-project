# sql-bank-analysis-project
# Bank Customer Segmentation & Analysis (SQL)

A SQL project analyzing customer, account, and transaction data for a bank, 
covering customer spend, salary trends, high-value customers, account 
activity, and regional engagement. I used a publicly available simulated 
banking dataset (customers, accounts, transactions) and wrote, tested, and 
debugged every query myself to practice real business-driven SQL analysis — 
the kind of work a data analyst would be asked to do for a financial 
services client.

## Tools Used
- PostgreSQL / pgAdmin
- SQL (joins, aggregation, CASE WHEN, window functions, HAVING)

## What I Explored
- Total spend per customer (debit transactions)
- Salary credit trends across months
- Most active accounts by transaction count and by volume
- Monthly transaction breakdown (count and volume)
- Top 20 high-value customers by credit inflow
- Dormant accounts (no activity in the last 12 months)
- City-wise performance (total volume and customer count)
- Engagement by region (active vs. dormant accounts by city)

## Key Insights
- The top 20 customers by credit inflow range from ~₦704K to ~₦1.21M, 
  led by Adesuwa Adelaja at ₦1,213,500.72
- 21 accounts were identified as dormant (no transactions in the last 12 months)
- Jos is the top-performing city by transaction volume (₦16.49M across 26 
  customers), followed by Enugu (₦13.49M) and Port Harcourt (₦13.39M) — 
  notably, Jos and Enugu outperform larger cities like Lagos (₦8.21M) and 
  Abuja (₦6.99M), suggesting activity isn't concentrated in the biggest 
  cities alone

## Note
This project uses a publicly available simulated bank dataset (schema and 
sample data), not real customer data. I wrote and debugged all SQL queries 
myself as a learning exercise in business-driven SQL analysis — I did not 
author the original dataset or schema.
