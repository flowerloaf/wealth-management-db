import os
import random
from datetime import date, timedelta

import pandas as pd
from faker import Faker

# -----------------------------
# Configuration
# -----------------------------
RANDOM_SEED = 42
NUM_ADVISORS = 20
NUM_CLIENTS = 120
MIN_ACCOUNTS_PER_CLIENT = 1
MAX_ACCOUNTS_PER_CLIENT = 3
NUM_GOALS = 220
NUM_TRANSACTIONS = 1500
NUM_ASSESSMENTS_PER_CLIENT = 1

# Account-type lookup table. This matches the decomposed schema:
# account_info(account_type, base_currency)
ACCOUNT_INFO_ROWS = [
    ("Schwab One Brokerage", "USD"),
    ("Interactive Brokers Japanese Brokerage", "JPY"),
    ("The Fidelity Account", "USD"),
    ("E*TRADE Brokerage", "USD"),
    ("Vanguard Brokerage", "USD"),
    ("Robinhood Individual", "USD"),
    ("Webull Cash Brokerage", "USD"),
    ("Questrade Cash Account", "CAD"),
    ("Swissquote Trading Account", "EUR"),
    ("Saxo Individual Singapore Account", "SGD")
]

# Asset lookup table. PK is symbol.
ASSETS_ROWS = [
    ("AAPL", "Apple Inc."),
    ("MSFT", "Microsoft Corp."),
    ("NVDA", "NVIDIA Corp."),
    ("JPM", "JPMorgan Chase & Co."),
    ("SPY", "SPDR S&P 500 ETF"),
    ("AMZN", "Amazon.com Inc."),
    ("GOOGL", "Alphabet Inc."),
    ("META", "Meta Platforms Inc."),
    ("TSLA", "Tesla Inc."),
    ("V", "Visa Inc."),
    ("JNJ", "Johnson & Johnson"),
    ("XOM", "Exxon Mobil Corp."),
    ("WMT", "Walmart Inc."),
    ("PG", "Procter & Gamble Co."),
    ("BAC", "Bank of America Corp."),
]

RISK_PROFILE_TO_VOL = {
    "Conservative": 5.00,
    "Moderately Conservative": 8.00,
    "Balanced": 12.00,
    "Growth": 18.00,
    "Aggressive": 25.00,
}

GOAL_TYPES = [
    "Retirement",
    "Emergency Fund",
    "House Down Payment",
    "College Savings",
    "Vacation Fund",
]
PRIORITIES = ["High", "Medium", "Low"]
ASSESSMENT_METHODS = ["Questionnaire", "Advisor Interview", "Online Form"]
ACCOUNT_STATUSES = ["Open", "Open", "Open", "Closed"]
TXN_TYPES = ["BUY", "BUY", "BUY", "SELL"]
OFFICE_LOCATIONS = ["Cleveland", "New York", "Chicago", "Boston", "San Francisco"]

# Rough base-price bands by symbol to keep transactions believable.
SYMBOL_BASE_PRICE = {
    "AAPL": 190,
    "MSFT": 420,
    "NVDA": 900,
    "JPM": 185,
    "SPY": 510,
    "AMZN": 180,
    "GOOGL": 165,
    "META": 510,
    "TSLA": 175,
    "V": 280,
    "JNJ": 150,
    "XOM": 120,
    "WMT": 70,
    "PG": 160,
    "BAC": 38,
}


# -----------------------------
# Helpers
# -----------------------------
fake = Faker()
random.seed(RANDOM_SEED)
Faker.seed(RANDOM_SEED)

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATA_DIR = os.path.join(ROOT_DIR, "data")
os.makedirs(DATA_DIR, exist_ok=True)


def profile_from_score(score: int) -> str:
    if 0 <= score <= 20:
        return "Conservative"
    if 21 <= score <= 40:
        return "Moderately Conservative"
    if 41 <= score <= 60:
        return "Balanced"
    if 61 <= score <= 80:
        return "Growth"
    return "Aggressive"


def clean_phone(raw: str) -> str:
    return raw[:20]


def one_line_address() -> str:
    return fake.address().replace("\n", ", ")


# -----------------------------
# advisors
# -----------------------------
advisors = []
for advisor_id in range(1, NUM_ADVISORS + 1):
    advisors.append(
        {
            "advisor_id": advisor_id,
            "name": fake.name(),
            "email": f"advisor{advisor_id}@wealthdemo.com",
            "phone": clean_phone(fake.phone_number()),
            "office_location": random.choice(OFFICE_LOCATIONS),
            "hire_date": fake.date_between(start_date="-12y", end_date="-1y"),
        }
    )

advisors_df = pd.DataFrame(advisors)
advisors_df.to_csv(os.path.join(DATA_DIR, "advisors.csv"), index=False)

# -----------------------------
# clients
# -----------------------------
clients = []
for client_id in range(1001, 1001 + NUM_CLIENTS):
    clients.append(
        {
            "client_id": client_id,
            "advisor_id": random.randint(1, NUM_ADVISORS),
            "name": fake.name(),
            "email": f"client{client_id}@email.com",
            "phone": clean_phone(fake.phone_number()),
            "address": one_line_address(),
            "dob": fake.date_of_birth(minimum_age=22, maximum_age=80),
        }
    )

clients_df = pd.DataFrame(clients)
clients_df.to_csv(os.path.join(DATA_DIR, "clients.csv"), index=False)

# -----------------------------
# account_info
# -----------------------------
account_info_df = pd.DataFrame(
    [{"account_type": t, "base_currency": c} for t, c in ACCOUNT_INFO_ROWS]
)
account_info_df.to_csv(os.path.join(DATA_DIR, "account_info.csv"), index=False)

# -----------------------------
# accounts
# -----------------------------
accounts = []
account_id = 2001
for client in clients:
    num_accounts = random.randint(MIN_ACCOUNTS_PER_CLIENT, MAX_ACCOUNTS_PER_CLIENT)
    
    usd_account_types = [t for t, c in ACCOUNT_INFO_ROWS if c == "USD"]
    non_usd_account_types = [t for t, c in ACCOUNT_INFO_ROWS if c != "USD"]

    chosen_types = []
    available_usd = usd_account_types.copy()
    available_non_usd = non_usd_account_types.copy()

    # Prevents clients from having multiple of the same account
    while len(chosen_types) < num_accounts and (available_usd or available_non_usd):
        # 75% chance to pick a USD account type
        pick_usd = random.random() < 0.75

        if pick_usd and available_usd:
            account_type = random.choice(available_usd)
            available_usd.remove(account_type)
        elif available_non_usd:
            account_type = random.choice(available_non_usd)
            available_non_usd.remove(account_type)
        else:
            account_type = random.choice(available_usd)
            available_usd.remove(account_type)

        chosen_types.append(account_type)
    
    for account_type in chosen_types:
        dob = pd.to_datetime(client["dob"]).date()
        earliest_open = max(dob + timedelta(days=365 * 18), date(2018, 1, 1))
        latest_open = date.today()
        if earliest_open > latest_open:
            earliest_open = latest_open - timedelta(days=30)
        accounts.append(
            {
                "account_id": account_id,
                "client_id": client["client_id"],
                "account_type": account_type,
                "opened_date": fake.date_between_dates(date_start=earliest_open, date_end=latest_open),
                "status": random.choice(ACCOUNT_STATUSES),
            }
        )
        account_id += 1

accounts_df = pd.DataFrame(accounts)
accounts_df.to_csv(os.path.join(DATA_DIR, "accounts.csv"), index=False)

# -----------------------------
# assets
# -----------------------------
assets_df = pd.DataFrame([{"symbol": s, "asset_name": n} for s, n in ASSETS_ROWS])
assets_df.to_csv(os.path.join(DATA_DIR, "assets.csv"), index=False)

# -----------------------------
# risk_profiles
# -----------------------------
risk_profiles_df = pd.DataFrame(
    [
        {"profile_name": profile_name, "target_volatility": vol}
        for profile_name, vol in RISK_PROFILE_TO_VOL.items()
    ]
)
risk_profiles_df.to_csv(os.path.join(DATA_DIR, "risk_profiles.csv"), index=False)

# -----------------------------
# client_risk_assessments
# -----------------------------
assessments = []
assessment_id = 1
for client in clients:
    for _ in range(NUM_ASSESSMENTS_PER_CLIENT):
        score = random.randint(0, 100)
        profile_name = profile_from_score(score)
        assessments.append(
            {
                "assessment_id": assessment_id,
                "client_id": client["client_id"],
                "profile_name": profile_name,
                "risk_score": score,
                "assessment_date": fake.date_between(start_date="-2y", end_date="today"),
                "method": random.choice(ASSESSMENT_METHODS),
            }
        )
        assessment_id += 1

assessments_df = pd.DataFrame(assessments)
assessments_df.to_csv(os.path.join(DATA_DIR, "client_risk_assessments.csv"), index=False)

# -----------------------------
# financial_goals
# -----------------------------
financial_goals = []
for goal_id in range(1, NUM_GOALS + 1):
    client = random.choice(clients)
    goal_type = random.choice(GOAL_TYPES)

    if goal_type == "Retirement":
        target_amount = random.randint(150000, 1200000)
    elif goal_type == "House Down Payment":
        target_amount = random.randint(20000, 120000)
    elif goal_type == "Emergency Fund":
        target_amount = random.randint(5000, 30000)
    elif goal_type == "College Savings":
        target_amount = random.randint(20000, 250000)
    else:
        target_amount = random.randint(2000, 20000)

    current_amount = random.randint(0, target_amount)
    financial_goals.append(
        {
            "goal_id": goal_id,
            "client_id": client["client_id"],
            "goal_type": goal_type,
            "target_amount": float(target_amount),
            "current_amount": float(current_amount),
            "target_date": fake.date_between(start_date="today", end_date="+12y"),
            "priority": random.choice(PRIORITIES),
        }
    )

goals_df = pd.DataFrame(financial_goals)
goals_df.to_csv(os.path.join(DATA_DIR, "financial_goals.csv"), index=False)

# -----------------------------
# transactions
# -----------------------------
accounts_opened = {
    row["account_id"]: pd.to_datetime(row["opened_date"]).date() for _, row in accounts_df.iterrows()
}
asset_symbols = assets_df["symbol"].tolist()
transactions = []

for txn_id in range(1, NUM_TRANSACTIONS + 1):
    account_id_choice = random.choice(accounts_df["account_id"].tolist())
    symbol = random.choice(asset_symbols)
    base_price = SYMBOL_BASE_PRICE.get(symbol, random.uniform(20, 500))
    price_per_unit = round(base_price * random.uniform(0.92, 1.08), 4)
    trade_start = accounts_opened[account_id_choice]
    trade_end = date.today()
    if trade_start > trade_end:
        trade_start = trade_end - timedelta(days=7)
    trade_date = fake.date_between_dates(date_start=trade_start, date_end=trade_end)
    settle_date = trade_date + timedelta(days=2)
    transactions.append(
        {
            "txn_id": txn_id,
            "account_id": account_id_choice,
            "symbol": symbol,
            "txn_type": random.choice(TXN_TYPES),
            "quantity": round(random.uniform(1, 100), 4),
            "price_per_unit": price_per_unit,
            "fees": round(random.uniform(0, 9.99), 2),
            "trade_date": trade_date,
            "settle_date": settle_date,
        }
    )

transactions_df = pd.DataFrame(transactions)
transactions_df.to_csv(os.path.join(DATA_DIR, "transactions.csv"), index=False)

# -----------------------------
# Summary
# -----------------------------
summary = {
    "advisors": len(advisors_df),
    "clients": len(clients_df),
    "account_info": len(account_info_df),
    "accounts": len(accounts_df),
    "assets": len(assets_df),
    "risk_profiles": len(risk_profiles_df),
    "client_risk_assessments": len(assessments_df),
    "financial_goals": len(goals_df),
    "transactions": len(transactions_df),
}

print("Generated CSV files in:", DATA_DIR)
for table_name, row_count in summary.items():
    print(f"{table_name}: {row_count}")
