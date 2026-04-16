INSERT INTO advisors (advisor_id, name, email, phone, office_location, hire_date) VALUES
(1, 'Alice Morgan', 'alice.morgan@wealthdemo.com', '216-555-1001', 'Cleveland', '2022-06-15'),
(2, 'Brian Lee', 'brian.lee@wealthdemo.com', '216-555-1002', 'New York', '2021-03-10');

INSERT INTO risk_profiles (risk_profile_id, profile_name, min_score, max_score, target_volatility) VALUES
(1, 'Conservative', 0, 20, 5.00),
(2, 'Moderately Conservative', 21, 40, 8.00),
(3, 'Balanced', 41, 60, 12.00),
(4, 'Growth', 61, 80, 18.00),
(5, 'Aggressive', 81, 100, 25.00);

INSERT INTO clients (client_id, advisor_id, name, email, phone, address, dob) VALUES
(101, 1, 'Jaden Carter', 'jaden.carter@email.com', '216-555-2001', '123 Euclid Ave, Cleveland, OH', '2000-04-12'),
(102, 2, 'Maya Patel', 'maya.patel@email.com', '216-555-2002', '456 Chester Ave, Cleveland, OH', '1998-11-03');

INSERT INTO accounts (account_id, client_id, account_type, custodian_name, base_currency, opened_date, status) VALUES
(1001, 101, 'Brokerage', 'Schwab', 'USD', '2024-01-10', 'Open'),
(1002, 101, 'IRA', 'Fidelity', 'USD', '2024-03-15', 'Open'),
(1003, 102, 'Brokerage', 'Vanguard', 'USD', '2023-09-20', 'Open');

INSERT INTO assets (asset_id, symbol, asset_name, asset_class, exchange, currency, sector, industry) VALUES
(1, 'AAPL', 'Apple Inc.', 'Stock', 'NASDAQ', 'USD', 'Technology', 'Consumer Electronics'),
(2, 'MSFT', 'Microsoft Corp.', 'Stock', 'NASDAQ', 'USD', 'Technology', 'Software'),
(3, 'SPY', 'SPDR S&P 500 ETF', 'ETF', 'NYSE Arca', 'USD', 'Fund', 'ETF');

INSERT INTO client_risk_assessments (assessment_id, client_id, risk_profile_id, risk_score, assessment_date, method) VALUES
(1, 101, 3, 58, '2026-04-10', 'Questionnaire'),
(2, 102, 4, 72, '2026-04-10', 'Questionnaire');

INSERT INTO financial_goals (goal_id, client_id, goal_type, target_amount, current_amount, target_date, priority) VALUES
(1, 101, 'Retirement', 500000.00, 85000.00, '2045-01-01', 'High'),
(2, 101, 'House Down Payment', 60000.00, 15000.00, '2028-06-01', 'Medium'),
(3, 102, 'Emergency Fund', 20000.00, 12000.00, '2026-12-01', 'High');

INSERT INTO market_prices (asset_id, price_date, open, high, low, close, adj_close, volume) VALUES
(1, '2026-04-15', 194.10, 197.20, 193.80, 196.55, 196.55, 55000000),
(2, '2026-04-15', 421.30, 425.00, 419.90, 424.10, 424.10, 31000000),
(3, '2026-04-15', 508.20, 510.10, 507.40, 509.55, 509.55, 72000000);

INSERT INTO transactions (txn_id, account_id, asset_id, txn_type, quantity, price_per_unit, fees, trade_date, settle_date) VALUES
(1, 1001, 1, 'BUY', 10.0000, 190.2500, 4.95, '2026-04-01', '2026-04-03'),
(2, 1001, 2, 'BUY', 5.0000, 418.1000, 4.95, '2026-04-02', '2026-04-04'),
(3, 1002, 3, 'BUY', 8.0000, 505.0000, 4.95, '2026-04-05', '2026-04-07'),
(4, 1003, 1, 'BUY', 12.0000, 192.0000, 4.95, '2026-04-06', '2026-04-08');