-- Query 1: List all advisors
SELECT * FROM advisors;

-- Query 2: List all clients
SELECT * FROM clients;

-- Query 3: Clients with advisors
SELECT c.client_id, c.name, c.email, a.name AS advisor_name
FROM clients c
JOIN advisors a ON c.advisor_id = a.advisor_id
ORDER BY c.client_id;

-- Query 4: Accounts with client names and account info
SELECT
    a.account_id,
    c.name AS client_name,
    a.account_type,
    ai.base_currency,
    a.opened_date,
    a.status
FROM accounts a
JOIN clients c ON a.client_id = c.client_id
JOIN account_info ai ON a.account_type = ai.account_type
ORDER BY a.account_id;

-- Query 5: Assets
SELECT * FROM assets ORDER BY symbol;

-- Query 6: All transactions with asset names
SELECT
    t.txn_id,
    t.account_id,
    t.symbol,
    s.asset_name,
    t.txn_type,
    t.quantity,
    t.price_per_unit,
    t.trade_date
FROM transactions t
JOIN assets s ON t.symbol = s.symbol
ORDER BY t.txn_id;

-- Query 7: Transactions for one account
SELECT
    t.txn_id,
    t.symbol,
    s.asset_name,
    t.txn_type,
    t.quantity,
    t.price_per_unit,
    t.trade_date
FROM transactions t
JOIN assets s ON t.symbol = s.symbol
WHERE t.account_id = 1001
ORDER BY t.trade_date DESC;

-- Query 8: Client risk assessments
SELECT
    c.client_id,
    c.name,
    cra.profile_name,
    rp.target_volatility,
    cra.risk_score,
    cra.assessment_date
FROM clients c
JOIN client_risk_assessments cra ON c.client_id = cra.client_id
JOIN risk_profiles rp ON cra.profile_name = rp.profile_name
ORDER BY c.client_id;

-- Query 9: Financial goals with client names
SELECT
    c.name,
    g.goal_type,
    g.target_amount,
    g.current_amount,
    g.target_date,
    g.priority
FROM financial_goals g
JOIN clients c ON g.client_id = c.client_id
ORDER BY g.target_date;

-- Query 10: Goals due within 5 years
SELECT
    c.name,
    g.goal_type,
    g.target_amount,
    g.current_amount,
    g.target_date
FROM financial_goals g
JOIN clients c ON g.client_id = c.client_id
WHERE g.target_date <= CURRENT_DATE + INTERVAL '5 years'
ORDER BY g.target_date;

-- Query 11: Advisors with number of clients
SELECT
    a.advisor_id,
    a.name,
    COUNT(c.client_id) AS total_clients
FROM advisors a
LEFT JOIN clients c ON a.advisor_id = c.advisor_id
GROUP BY a.advisor_id, a.name
ORDER BY total_clients DESC;

-- Query 12: Most traded assets
SELECT
    t.symbol,
    s.asset_name,
    COUNT(*) AS trade_count
FROM transactions t
JOIN assets s ON t.symbol = s.symbol
GROUP BY t.symbol, s.asset_name
ORDER BY trade_count DESC, t.symbol ASC;