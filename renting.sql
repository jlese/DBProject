-- Grant privileges to sub-users

GRANT ALL PRIVILEGES ON jwl4vg.* TO 'jwl4vg_a'@'%';
GRANT ALL PRIVILEGES ON jwl4vg.* TO 'jwl4vg_b'@'%';
GRANT ALL PRIVILEGES ON jwl4vg.* TO 'jwl4vg_c'@'%';

-- Create tables

CREATE TABLE IF NOT EXISTS Account (
    username VARCHAR(10) NOT NULL,
    first_name VARCHAR(20) NOT NULL,  
    last_name VARCHAR(20) NOT NULL,
    email VARCHAR(60) NOT NULL,
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

CREATE TABLE IF NOT EXISTS Administrator (
    a_uname VARCHAR(10) NOT NULL REFERENCES Account(username),
    region VARCHAR(20) NOT NULL,
    PRIMARY KEY (a_uname)
);

CREATE TABLE IF NOT EXISTS Properties (
    p_id VARCHAR(10) NOT NULL.
    addr VARCHAR(10) NOT NULL,
    price INT NOT NULL,
    num_bathrooms INT NOT NULL,
    kitchen BIT NOT NULL, -- 0 = no kitchen, 1 = kitchen
    pool BIT NOT NULL,
    num_bedrooms INT NOT NULL,
    rating FLOAT DEFAULT NULL,
    parking BIT NOT NULL,
    p_avg_rating FLOAT DEFAULT NULL,
    PRIMARY KEY (p_id)
);

CREATE TABLE IF NOT EXISTS AvailableRentals (
    p_id VARCHAR(10) NOT NULL REFERENCES Properties(p_id),
    week INT NOT NULL,
    PRIMARY KEY (p_id)

);

CREATE TABLE IF NOT EXISTS Rents (
    p_id VARCHAR(10) NOT NULL REFERENCES AvailableRentals(p_id),
    r_uname VARCHAR(10) NOT NULL REFERENCES Renter(r_uname),
    contract_id VARCHAR(10) NOT NULL,
    week INT NOT NULL,
    PRIMARY KEY (p_id, r_uname, contract_id)

);

CREATE TABLE IF NOT EXISTS Rates (
    p_id VARCHAR(10) NOT NULL REFERENCES Properties(p_id),
    h_uname VARCHAR(10) NOT NULL REFERENCES Host(h_uname),
    r_uname VARCHAR(10) NOT NULL REFERENCES Renter(r_uname),
    addr VARCHAR(10) NOT NULL REFERENCES Properties(addr),
    h_rating FLOAT NOT NULL,
    r_rating FLOAT NOT NULL,
    p_rating FLOAT NOT NULL,
    PRIMARY KEY (p_id, h_uname, r_uname)
    
);

CREATE TABLE IF NOT EXISTS H_Request (
    t_id VARCHAR(10) NOT NULL,
    h_uname VARCHAR(10) NOT NULL REFERENCES Host(h_uname), 
    a_uname VARCHAR(10) NOT NULL REFERENCES Administrator(a_uname),
    ymd DATE NOT NULL,
    region VARCHAR(20) NOT NULL,
    reason TEXT NOT NULL,
    PRIMARY KEY (t_id, h_uname, a_uname)

);

CREATE TABLE IF NOT EXISTS R_Request (
    t_id VARCHAR(10) NOT NULL,
    r_uname VARCHAR(10) NOT NULL REFERENCES Renter(r_uname), 
    a_uname VARCHAR(10) NOT NULL REFERENCES Administrator(a_uname),
    ymd DATE NOT NULL,
    region VARCHAR(20) NOT NULL,
    reason TEXT NOT NULL,
    PRIMARY KEY (t_id, r_uname, a_uname)

);