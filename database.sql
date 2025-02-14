CREATE TABLE "user"
(
  userid SERIAL NOT NULL,
  firstname VARCHAR(15) NOT NULL,
  lastname VARCHAR(20) NOT NULL,
  email VARCHAR(50) UNIQUE NOT NULL,
  created_at TIMESTAMP NOT NULL,
  PRIMARY KEY (userid)
);

CREATE TABLE CHARITY
(
  charityid SERIAL NOT NULL,
  charityname TEXT UNIQUE NOT NULL,
  description TEXT NOT NULL,
  logo VARCHAR(15) NOT NULL,
  isactive BOOLEAN DEFAULT true,
  stripe_account_id VARCHAR(30) UNIQUE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (charityid)
);

CREATE TABLE ROUNDUP_SETTINGS
(
  roundupid SERIAL NOT NULL,
  userid INT NOT NULL,
  charityid INT,
  monthlycap FLOAT,
  totalytd FLOAT NOT NULL,
  running_total FLOAT NOT NULL,
  donation_threshold FLOAT NOT NULL,
  roundup_amount FLOAT NOT NULL,
  isactive BOOLEAN NOT NULL DEFAULT true,
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (roundupid),
  FOREIGN KEY (userid) REFERENCES "user"(userid) ON DELETE CASCADE
);

CREATE TABLE USER_BANK
(
  bankid SERIAL NOT NULL,
  userid INT UNIQUE NOT NULL,
  bankname VARCHAR(50) NOT NULL,
  accountlast4 VARCHAR(4) NOT NULL,
  accounttype VARCHAR(15) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
  plaid_account_id VARCHAR(30) UNIQUE NOT NULL,
  PRIMARY KEY (bankid),
  FOREIGN KEY (userid) REFERENCES "user"(userid) ON DELETE CASCADE
);

CREATE TABLE DONATION_HISTORY
(
  donationid SERIAL NOT NULL,
  charityid INT NOT NULL,
  userid INT NOT NULL,
  donation_amount FLOAT NOT NULL,
  donationdate TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (donationid),
  FOREIGN KEY (charityid) REFERENCES CHARITY(charityid) ON DELETE CASCADE,
  FOREIGN KEY (userid) REFERENCES "user"(userid) ON DELETE CASCADE
);

-- Create indexes on USER table
CREATE INDEX idx_user_email ON "user" (email);

-- Create partial index on CHARITY table for active charities
CREATE INDEX idx_charity_name_active ON CHARITY (charityname) WHERE isactive = true;

-- Create indexes on ROUNDUP_SETTINGS table
CREATE INDEX idx_roundup_settings_userid ON ROUNDUP_SETTINGS (userid);
CREATE INDEX idx_roundup_settings_charityid ON ROUNDUP_SETTINGS (charityid);

-- Create indexes on USER_BANK table
CREATE UNIQUE INDEX idx_user_bank_userid ON USER_BANK (userid);
CREATE UNIQUE INDEX idx_user_bank_plaid_account_id ON USER_BANK (plaid_account_id);

-- Create partial index on DONATION_HISTORY table for recent donations (e.g., last year)
CREATE INDEX idx_donation_history_userid ON DONATION_HISTORY (userid);
CREATE INDEX idx_donation_history_charityid ON DONATION_HISTORY (charityid);
