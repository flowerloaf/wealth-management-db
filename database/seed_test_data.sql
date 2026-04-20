INSERT INTO advisors (advisor_id, name, email, phone, office_location, hire_date) VALUES
(1, 'Alice Morgan', 'alice.morgan@wealthdemo.com', '216-555-1001', 'Cleveland', '2022-06-15'),
(2, 'Brian Lee', 'brian.lee@wealthdemo.com', '216-555-1002', 'New York', '2021-03-10');

INSERT INTO clients (client_id, advisor_id, name, email, phone, address, dob) VALUES
(101, 1, 'Jaden Carter', 'jaden.carter@email.com', '216-555-2001', '123 Euclid Ave, Cleveland, OH', '2000-04-12'),
(102, 2, 'Maya Patel', 'maya.patel@email.com', '216-555-2002', '456 Chester Ave, Cleveland, OH', '1998-11-03');

INSERT INTO account_info (account_type, base_currency) VALUES
('Brokerage', 'USD'),
('IRA', 'USD'),
('Roth IRA', 'USD'),
('International Brokerage', 'EUR');

INSERT INTO accounts (account_id, client_id, account_type, opened_date, status) VALUES
(1001, 101, 'Brokerage', '2024-01-10', 'Open'),
(1002, 101, 'IRA', '2024-03-15', 'Open'),
(1003, 102, 'Brokerage', '2023-09-20', 'Open');

INSERT INTO assets (symbol, asset_name) VALUES
('AAPL', 'Apple Inc.'),
('MSFT', 'Microsoft Corp.'),
('NVDA', 'NVIDIA Corp.'),
('JPM', 'JPMorgan Chase & Co.'),
('SPY', 'SPDR S&P 500 ETF');

INSERT INTO risk_profiles (profile_name, target_volatility) VALUES
('Conservative', 5.00),
('Moderately Conservative', 8.00),
('Balanced', 12.00),
('Growth', 18.00),
('Aggressive', 25.00);

INSERT INTO client_risk_assessments (assessment_id, client_id, profile_name, risk_score, assessment_date, method) VALUES
(1, 101, 'Balanced', 58, '2026-04-10', 'Questionnaire'),
(2, 102, 'Growth', 72, '2026-04-10', 'Questionnaire');

INSERT INTO financial_goals (goal_id, client_id, goal_type, target_amount, current_amount, target_date, priority) VALUES
(1, 101, 'Retirement', 500000.00, 85000.00, '2045-01-01', 'High'),
(2, 101, 'House Down Payment', 60000.00, 15000.00, '2028-06-01', 'Medium'),
(3, 102, 'Emergency Fund', 20000.00, 12000.00, '2026-12-01', 'High');

INSERT INTO transactions (
    txn_id, account_id, symbol, txn_type, quantity, price_per_unit, fees, trade_date, settle_date
) VALUES
(1, 1001, 'AAPL', 'BUY', 10.0000, 190.2500, 4.95, '2026-04-01', '2026-04-03'),
(2, 1001, 'MSFT', 'BUY', 5.0000, 418.1000, 4.95, '2026-04-02', '2026-04-04'),
(3, 1002, 'NVDA', 'BUY', 8.0000, 505.0000, 4.95, '2026-04-05', '2026-04-07'),
(4, 1003, 'AAPL', 'BUY', 12.0000, 192.0000, 4.95, '2026-04-06', '2026-04-08'),
(5, 1003, 'JPM', 'BUY', 7.0000, 184.5000, 4.95, '2026-04-08', '2026-04-10');