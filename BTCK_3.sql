CREATE DATABASE BTCHP3;
USE BTCHP3;

CREATE TABLE Country (
    country_id INT PRIMARY KEY,
    country_name VARCHAR(100)
);

CREATE TABLE Location (
    location_id INT PRIMARY KEY,
    street_address VARCHAR(255),
    postal_code VARCHAR(20),
    country_id INT,
    FOREIGN KEY (country_id) REFERENCES Country(country_id)
);

CREATE TABLE Employee (
    employee_id INT PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    location_id INT,
    FOREIGN KEY (location_id) REFERENCES Location(location_id)
);

INSERT INTO Country (country_id, country_name) VALUES 
(1, 'Vietnam'),
(2, 'USA'),
(3, 'Japan');

INSERT INTO Location (location_id, street_address, postal_code, country_id) VALUES 
(1, '123 Hoan Kiem', '100000', 1),
(2, '456 Madison St', '200000', 2),
(3, '789 Shibuya', '300000', 3);

INSERT INTO Employee (employee_id, full_name, email, location_id) VALUES 
(1, 'Nguyen Van A', 'nn03@gmail.com', 1),
(2, 'Tran Thi B', 'tb02@gmail.com', 1),
(3, 'Le Minh C', 'lc01@gmail.com', 2);

-- 2 
-- a
SELECT e.employee_id, e.full_name, e.email
FROM Employee e
JOIN Location l ON e.location_id = l.location_id
JOIN Country c ON l.country_id = c.country_id
WHERE c.country_name = 'Vietnam';

-- b
SELECT c.country_name
FROM Employee e
JOIN Location l ON e.location_id = l.location_id
JOIN Country c ON l.country_id = c.country_id
WHERE e.email = 'nn03@gmail.com';

-- c
SELECT c.country_name, l.street_address, COUNT(e.employee_id) AS employee_count
FROM Employee e
JOIN Location l ON e.location_id = l.location_id
JOIN Country c ON l.country_id = c.country_id
GROUP BY c.country_name, l.street_address;

-- 3
DELIMITER //

CREATE TRIGGER check_max_employee_per_country
BEFORE INSERT ON Employee
FOR EACH ROW
BEGIN
    DECLARE employee_count INT;
    SELECT COUNT(*) INTO employee_count
    FROM Employee e
    JOIN Location l ON e.location_id = l.location_id
    WHERE l.country_id = (SELECT country_id FROM Location WHERE location_id = NEW.location_id);
    IF employee_count >= 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Each country can only have a maximum of 10 employees.';
    END IF;
END
//
DELIMITER ;

-- 4
ALTER TABLE Employee
DROP FOREIGN KEY employee_ibfk_1;

ALTER TABLE Employee
ADD CONSTRAINT fk_location_id
FOREIGN KEY (location_id) REFERENCES Location(location_id)
ON DELETE SET NULL;
