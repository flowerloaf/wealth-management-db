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

CREATE TABLE account_info (
    account_type VARCHAR(50) PRIMARY KEY,
    base_currency VARCHAR(10) NOT NULL
);

CREATE TABLE accounts (
    account_id INT PRIMARY KEY,
    client_id INT NOT NULL,
    account_type VARCHAR(50) NOT NULL,
    opened_date DATE NOT NULL,
    status VARCHAR(30) NOT NULL,
    FOREIGN KEY (client_id) REFERENCES clients(client_id),
    FOREIGN KEY (account_type) REFERENCES account_info(account_type)
);

CREATE TABLE assets (
    symbol VARCHAR(20) PRIMARY KEY,
    asset_name VARCHAR(120) NOT NULL
);

CREATE TABLE risk_profiles (
    profile_name VARCHAR(50) PRIMARY KEY,
    target_volatility DECIMAL(6,2),
    CHECK (
        profile_name IN (
            'Conservative',
            'Moderately Conservative',
            'Balanced',
            'Growth',
            'Aggressive'
        )
    )
);

CREATE TABLE client_risk_assessments (
    assessment_id INT PRIMARY KEY,
    client_id INT NOT NULL,
    profile_name VARCHAR(50) NOT NULL,
    risk_score INT NOT NULL CHECK (risk_score >= 0 AND risk_score <= 100),
    assessment_date DATE NOT NULL,
    method VARCHAR(50),
    FOREIGN KEY (client_id) REFERENCES clients(client_id),
    FOREIGN KEY (profile_name) REFERENCES risk_profiles(profile_name)
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

CREATE TABLE transactions (
    txn_id INT PRIMARY KEY,
    account_id INT NOT NULL,
    symbol VARCHAR(20) NOT NULL,
    txn_type VARCHAR(10) NOT NULL CHECK (txn_type IN ('BUY', 'SELL')),
    quantity DECIMAL(18,4) NOT NULL CHECK (quantity > 0),
    price_per_unit DECIMAL(18,4) NOT NULL CHECK (price_per_unit > 0),
    fees DECIMAL(18,4) DEFAULT 0 CHECK (fees >= 0),
    trade_date DATE NOT NULL,
    settle_date DATE,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id),
    FOREIGN KEY (symbol) REFERENCES assets(symbol),
    CHECK (settle_date IS NULL OR settle_date >= trade_date)
);

CREATE INDEX idx_clients_advisor_id ON clients(advisor_id);
CREATE INDEX idx_accounts_client_id ON accounts(client_id);
CREATE INDEX idx_accounts_account_type ON accounts(account_type);
CREATE INDEX idx_transactions_account_id ON transactions(account_id);
CREATE INDEX idx_transactions_symbol ON transactions(symbol);
CREATE INDEX idx_goals_client_id ON financial_goals(client_id);
CREATE INDEX idx_assessments_client_id ON client_risk_assessments(client_id);
CREATE INDEX idx_assessments_profile_name ON client_risk_assessments(profile_name);