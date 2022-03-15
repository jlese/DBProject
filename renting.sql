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
    numRates INT DEFAULT 0;
    PRIMARY KEY (h_uname)
);

CREATE TABLE IF NOT EXISTS Renter (
    r_uname VARCHAR(10) NOT NULL REFERENCES Account(username),
    r_avg_rating FLOAT DEFAULT NULL,
    numRates INT DEFAULT 0;
    PRIMARY KEY (r_uname)
);

CREATE TABLE IF NOT EXISTS Administrator (
    a_uname VARCHAR(10) NOT NULL REFERENCES Account(username),
    region VARCHAR(20) NOT NULL,
    PRIMARY KEY (a_uname)
);

CREATE TABLE IF NOT EXISTS Properties (
    p_id VARCHAR(10) NOT NULL,
    name TEXT NOT NULL,
    description TEXT NOT NULL,
    bathrooms FLOAT NOT NULL,
    bedrooms INT NOT NULL,
    amenities TEXT NOT NULL, 
    price FLOAT NOT NULL,
    city TEXT NOT NULL,
    p_avg_rating FLOAT NOT NULL,
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
    h_rating FLOAT NOT NULL CHECK (h_rating <=5 AND h_rating >=1),
    r_rating FLOAT NOT NULL CHECK (r_rating <=5 AND r_rating >=1),
    p_rating FLOAT NOT NULL CHECK (p_rating <=5 AND p_rating >=1),
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

ALTER TABLE Properties
ADD CONSTRAINT host_deletion
FOREIGN KEY (p_id) REFERENCES Properties(p_id)
ON DELETE CASCADE; 

ALTER TABLE AvailableRentals
ADD CONSTRAINT property_deletion
FOREIGN KEY (h_uname) REFERENCES Host(h_uname)
ON DELETE CASCADE; 



DELIMITER $$
CREATE TRIGGER rentedTrigger
AFTER INSERT ON Rents
BEGIN
    DELETE AvailableRentals 
    WHERE p_id=AvailableRentals.p_id and week=AvailableRentals.week;
END
$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER h_rateTrigger
AFTER INSERT ON Rates
BEGIN
    SET NOCOUNT ON;

    
    Update Host 
        set numRates = numRates +1 
        where Host.h_uname = Rates.h_uname;
    Update Host
        set h_avg_rating = (h_avg_rating*(numRates-1) + Rates.h_rating)/(num_Rates) 
        where Host.h_uname = Rates.h_uname;

    Update Renter
        set numRates = numRates +1 
        where Renter.r_uname = Rates.r_uname;
    Update Renter
        set r_avg_rating = (r_avg_rating*(numRates-1) + Rates.r_rating)/(num_Rates) 
        where Renter.r_uname = Rates.r_uname;

    Update Properties 
        set numRates = numRates +1 
        where Properties.p_id = Rates.p_id;
    Update Properties 
        set p_avg_rating = (p_avg_rating*(numRates-1) + Rates.p_rating)/(num_Rates) 
        where Properties.p_id = Rates.p_id;
    END
$$
DELIMITER ;

