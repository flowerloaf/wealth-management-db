-- Query 1: List all advisors
SELECT * FROM advisors;

-- Query 2: List all clients
SELECT * FROM clients;

-- Query 3: Clients with advisors
SELECT c.client_id, c.name, c.email, a.name AS advisor_name
FROM clients c
JOIN advisors a ON c.advisor_id = a.advisor_id
ORDER BY c.client_id;

-- Query 4: Accounts with client names
SELECT a.account_id, c.name AS client_name, a.account_type, a.custodian_name, a.status
FROM accounts a
JOIN clients c ON a.client_id = c.client_id
ORDER BY a.account_id;

-- Query 5: Transactions for all accounts
SELECT txn_id, account_id, symbol, asset_name, asset_class, txn_type, quantity, price_per_unit, trade_date
FROM transactions
ORDER BY txn_id;

-- Query 6: Transactions for one account
SELECT txn_id, symbol, asset_name, txn_type, quantity, price_per_unit, trade_date
FROM transactions
WHERE account_id = 1001
ORDER BY trade_date DESC;

-- Query 7: Client risk assessments
SELECT c.client_id, c.name, rp.profile_name, cra.risk_score, cra.assessment_date
FROM clients c
JOIN client_risk_assessments cra ON c.client_id = cra.client_id
JOIN risk_profiles rp ON cra.risk_profile_id = rp.risk_profile_id
ORDER BY c.client_id;

-- Query 8: Financial goals with client names
SELECT c.name, g.goal_type, g.target_amount, g.current_amount, g.target_date, g.priority
FROM financial_goals g
JOIN clients c ON g.client_id = c.client_id
ORDER BY g.target_date;

-- Query 9: Goals due within 5 years
SELECT c.name, g.goal_type, g.target_amount, g.current_amount, g.target_date
FROM financial_goals g
JOIN clients c ON g.client_id = c.client_id
WHERE g.target_date <= CURRENT_DATE + INTERVAL '5 years'
ORDER BY g.target_date;

-- Query 10: Advisors with number of clients
SELECT a.advisor_id, a.name, COUNT(c.client_id) AS total_clients
FROM advisors a
LEFT JOIN clients c ON a.advisor_id = c.advisor_id
GROUP BY a.advisor_id, a.name
ORDER BY total_clients DESC;

-- Query 11: Most traded symbols
SELECT symbol, asset_name, COUNT(*) AS trade_count
FROM transactions
GROUP BY symbol, asset_name
ORDER BY trade_count DESC;