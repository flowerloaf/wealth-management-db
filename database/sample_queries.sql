-- ==========================================
-- Wealth Management Database Sample Queries
-- ==========================================


-- An advisor is leaving the company, find the names and emails of all clients assigned to a specific advisor. 

SELECT c.name, c.email
FROM clients c
JOIN advisors a
  ON c.advisor_id = a.advisor_id
WHERE a.name = 'Alice Smith';

-- NVIDIA reported earnings and their stock rose quickly. We want to find the name and email of all clients who have bought NVIDIA stock in the past 3 months.

SELECT DISTINCT c.name, c.email
FROM clients c
JOIN accounts acc
  ON c.client_id = acc.client_id
JOIN transactions t
  ON acc.account_id = t.account_id
WHERE t.symbol = 'NVDA'
  AND t.txn_type = 'BUY'
  AND t.trade_date >= CURRENT_DATE - INTERVAL '3 months';

-- During performance review Find advisors who manage more than 5 clients

SELECT a.advisor_id, a.name, a.email, COUNT(*) AS client_count
FROM advisors a
JOIN clients c
  ON a.advisor_id = c.advisor_id
GROUP BY a.advisor_id, a.name, a.email
HAVING COUNT(*) > 5;

-- Find the asset(s) with the greatest number of transactions. 
SELECT a.symbol, a.asset_name
FROM assets a
JOIN transactions t
  ON a.symbol = t.symbol
GROUP BY a.symbol, a.asset_name
HAVING COUNT(*) >= ALL (
    SELECT COUNT(*)
    FROM transactions
    GROUP BY symbol
);


-- Find each client’s highest-fee transaction. 
SELECT c.client_id,
       c.name,
       c.email,
       t.txn_id,
       t.account_id,
       t.symbol,
       t.txn_type,
       t.quantity,
       t.price_per_unit,
       t.fees,
       t.trade_date
FROM clients c
JOIN accounts acc
  ON c.client_id = acc.client_id
JOIN transactions t
  ON acc.account_id = t.account_id
WHERE t.fees = (
    SELECT MAX(t2.fees)
    FROM accounts acc2
    JOIN transactions t2
      ON acc2.account_id = t2.account_id
    WHERE acc2.client_id = c.client_id
);


-- Find clients who have accounts but have never made a transaction. 

SELECT DISTINCT c.client_id, c.name, c.email
FROM clients c
JOIN accounts acc
  ON c.client_id = acc.client_id
LEFT JOIN transactions t
  ON acc.account_id = t.account_id
WHERE t.txn_id IS NULL;
