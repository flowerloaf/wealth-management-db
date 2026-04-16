CREATE TABLE advisors (
    advisor_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(120) UNIQUE NOT NULL,
    phone VARCHAR(20),
    office_location VARCHAR(100),
    hire_date DATE NOT NULL
);

CREATE TABLE clients (
    client_id INT PRIMARY KEY,
    advisor_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(120) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address VARCHAR(200),
    dob DATE NOT NULL,
    FOREIGN KEY (advisor_id) REFERENCES advisors(advisor_id)
);

CREATE TABLE accounts (
    account_id INT PRIMARY KEY,
    client_id INT NOT NULL,
    account_type VARCHAR(50) NOT NULL,
    custodian_name VARCHAR(100),
    base_currency VARCHAR(10) DEFAULT 'USD',
    opened_date DATE NOT NULL,
    status VARCHAR(30) NOT NULL,
    FOREIGN KEY (client_id) REFERENCES clients(client_id)
);

CREATE TABLE assets (
    asset_id INT PRIMARY KEY,
    symbol VARCHAR(20) UNIQUE NOT NULL,
    asset_name VARCHAR(120) NOT NULL,
    asset_class VARCHAR(50) NOT NULL,
    exchange VARCHAR(50),
    currency VARCHAR(10) DEFAULT 'USD',
    sector VARCHAR(80),
    industry VARCHAR(80)
);

CREATE TABLE risk_profiles (
    risk_profile_id INT PRIMARY KEY,
    profile_name VARCHAR(50) UNIQUE NOT NULL,
    min_score INT NOT NULL,
    max_score INT NOT NULL,
    target_volatility DECIMAL(6,2),
    CHECK (min_score <= max_score)
);

CREATE TABLE client_risk_assessments (
    assessment_id INT PRIMARY KEY,
    client_id INT NOT NULL,
    risk_profile_id INT NOT NULL,
    risk_score INT NOT NULL,
    assessment_date DATE NOT NULL,
    method VARCHAR(50),
    FOREIGN KEY (client_id) REFERENCES clients(client_id),
    FOREIGN KEY (risk_profile_id) REFERENCES risk_profiles(risk_profile_id)
);

CREATE TABLE financial_goals (
    goal_id INT PRIMARY KEY,
    client_id INT NOT NULL,
    goal_type VARCHAR(50) NOT NULL,
    target_amount DECIMAL(18,2) NOT NULL CHECK (target_amount > 0),
    current_amount DECIMAL(18,2) DEFAULT 0 CHECK (current_amount >= 0),
    target_date DATE,
    priority VARCHAR(20),
    FOREIGN KEY (client_id) REFERENCES clients(client_id)
);

CREATE TABLE market_prices (
    asset_id INT NOT NULL,
    price_date DATE NOT NULL,
    open DECIMAL(18,4),
    high DECIMAL(18,4),
    low DECIMAL(18,4),
    close DECIMAL(18,4) NOT NULL,
    adj_close DECIMAL(18,4),
    volume BIGINT,
    PRIMARY KEY (asset_id, price_date),
    FOREIGN KEY (asset_id) REFERENCES assets(asset_id),
    CHECK (high IS NULL OR low IS NULL OR high >= low)
);

CREATE TABLE transactions (
    txn_id INT PRIMARY KEY,
    account_id INT NOT NULL,
    asset_id INT NOT NULL,
    txn_type VARCHAR(10) NOT NULL CHECK (txn_type IN ('BUY', 'SELL')),
    quantity DECIMAL(18,4) NOT NULL CHECK (quantity > 0),
    price_per_unit DECIMAL(18,4) NOT NULL CHECK (price_per_unit > 0),
    fees DECIMAL(18,4) DEFAULT 0 CHECK (fees >= 0),
    trade_date DATE NOT NULL,
    settle_date DATE,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id),
    FOREIGN KEY (asset_id) REFERENCES assets(asset_id),
    CHECK (settle_date IS NULL OR settle_date >= trade_date)
);

CREATE INDEX idx_clients_advisor_id ON clients(advisor_id);
CREATE INDEX idx_accounts_client_id ON accounts(client_id);
CREATE INDEX idx_transactions_account_id ON transactions(account_id);
CREATE INDEX idx_transactions_asset_id ON transactions(asset_id);
CREATE INDEX idx_market_prices_asset_id ON market_prices(asset_id);
CREATE INDEX idx_goals_client_id ON financial_goals(client_id);
CREATE INDEX idx_assessments_client_id ON client_risk_assessments(client_id);