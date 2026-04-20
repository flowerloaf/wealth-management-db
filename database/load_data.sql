-- ==========================================
-- Wealth Management Database CSV Load Script
-- ==========================================
-- Update the file paths below to match your machine.
-- Example root path on macOS:
-- /Users/yourname/Documents/wealth-management-db/data/
--
-- Recommended workflow:
-- 1. Run schema.sql first.
-- 2. If tables already contain test data, run the TRUNCATE block below.
-- 3. Update all CSV file paths.
-- 4. Run this file.

-- ------------------------------------------
-- Optional: clear existing data before load
-- ------------------------------------------
-- Uncomment this block if you already inserted seed data and want
-- to replace it with the generated CSV data.

-- TRUNCATE TABLE
--     transactions,
--     financial_goals,
--     client_risk_assessments,
--     risk_profiles,
--     assets,
--     accounts,
--     account_info,
--     clients,
--     advisors
-- CASCADE;

-- ------------------------------------------
-- Load data in foreign-key-safe order
-- ------------------------------------------

COPY advisors(advisor_id, name, email, phone, office_location, hire_date)
FROM '/Users/yourname/Documents/wealth-management-db/data/advisors.csv'
DELIMITER ','
CSV HEADER;

COPY clients(client_id, advisor_id, name, email, phone, address, dob)
FROM '/Users/yourname/Documents/wealth-management-db/data/clients.csv'
DELIMITER ','
CSV HEADER;

COPY account_info(account_type, base_currency)
FROM '/Users/yourname/Documents/wealth-management-db/data/account_info.csv'
DELIMITER ','
CSV HEADER;

COPY accounts(account_id, client_id, account_type, opened_date, status)
FROM '/Users/yourname/Documents/wealth-management-db/data/accounts.csv'
DELIMITER ','
CSV HEADER;

COPY assets(symbol, asset_name)
FROM '/Users/yourname/Documents/wealth-management-db/data/assets.csv'
DELIMITER ','
CSV HEADER;

COPY risk_profiles(profile_name, target_volatility)
FROM '/Users/yourname/Documents/wealth-management-db/data/risk_profiles.csv'
DELIMITER ','
CSV HEADER;

COPY client_risk_assessments(assessment_id, client_id, profile_name, risk_score, assessment_date, method)
FROM '/Users/yourname/Documents/wealth-management-db/data/client_risk_assessments.csv'
DELIMITER ','
CSV HEADER;

COPY financial_goals(goal_id, client_id, goal_type, target_amount, current_amount, target_date, priority)
FROM '/Users/yourname/Documents/wealth-management-db/data/financial_goals.csv'
DELIMITER ','
CSV HEADER;

COPY transactions(txn_id, account_id, symbol, txn_type, quantity, price_per_unit, fees, trade_date, settle_date)
FROM '/Users/yourname/Documents/wealth-management-db/data/transactions.csv'
DELIMITER ','
CSV HEADER;

-- ------------------------------------------
-- Quick verification queries
-- ------------------------------------------

SELECT COUNT(*) AS advisors_count FROM advisors;
SELECT COUNT(*) AS clients_count FROM clients;
SELECT COUNT(*) AS account_info_count FROM account_info;
SELECT COUNT(*) AS accounts_count FROM accounts;
SELECT COUNT(*) AS assets_count FROM assets;
SELECT COUNT(*) AS risk_profiles_count FROM risk_profiles;
SELECT COUNT(*) AS assessments_count FROM client_risk_assessments;
SELECT COUNT(*) AS goals_count FROM financial_goals;
SELECT COUNT(*) AS transactions_count FROM transactions;

-- Example join check
SELECT
    a.account_id,
    c.name AS client_name,
    a.account_type,
    ai.base_currency
FROM accounts a
JOIN clients c ON a.client_id = c.client_id
JOIN account_info ai ON a.account_type = ai.account_type
LIMIT 10;