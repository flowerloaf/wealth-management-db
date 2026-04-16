SELECT * FROM advisors;

SELECT * FROM clients;

SELECT c.client_id, c.name, a.name AS advisor_name
FROM clients c
JOIN advisors a ON c.advisor_id = a.advisor_id;

SELECT a.account_id, c.name AS client_name, a.account_type, a.status
FROM accounts a
JOIN clients c ON a.client_id = c.client_id;

SELECT t.txn_id, s.symbol, t.txn_type, t.quantity, t.price_per_unit
FROM transactions t
JOIN assets s ON t.asset_id = s.asset_id;