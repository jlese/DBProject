-- Grant privileges to sub-users

GRANT ALL PRIVILEGES ON jwl4vg.* TO 'jwl4vg_a'@'%';
GRANT ALL PRIVILEGES ON jwl4vg.* TO 'jwl4vg_b'@'%';
GRANT ALL PRIVILEGES ON jwl4vg.* TO 'jwl4vg_c'@'%';

-- Create tables

CREATE TABLE IF NOT EXISTS Account (
    username VARCHAR(10) NOT NULL,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    PRIMARY KEY (username)
    
);

CREATE TABLE IF NOT EXISTS Host (
    h_uname VARCHAR(10) NOT NULL REFERENCES Account(username),
    h_avg_rating FLOAT DEFAULT NULL,
    PRIMARY KEY (h_uname)
);

CREATE TABLE IF NOT EXISTS Renter (
    r_uname VARCHAR(10) NOT NULL REFERENCES Account(username),
    r_avg_rating FLOAT DEFAULT NULL,
    PRIMARY KEY (r_uname)
);

CREATE TABLE IF NOT EXISTS Admin (
    a_uname VARCHAR(10) NOT NULL REFERENCES Account(username),
    region VARCHAR(10) NOT NULL,
    PRIMARY KEY (a_uname)
);