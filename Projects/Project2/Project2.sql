-- Create the profession table with UNIQUE constraint
CREATE TABLE profession (
    prof_id SERIAL PRIMARY KEY,
    profession VARCHAR(255) UNIQUE NOT NULL
);

-- Create the zip_code table with a CHECK constraint for a 4-digit code
CREATE TABLE zip_code (
    zip_code CHAR(4) PRIMARY KEY,
    city VARCHAR(255) NOT NULL,
    province VARCHAR(255) NOT NULL CHECK (province IN (
        'Province1', 'Province2', 'Province3', 'Province4', 'Province5', 
        'Province6', 'Province7', 'Province8', 'Province9'))
);

-- Create the status table
CREATE TABLE status (
    status_id SERIAL PRIMARY KEY,
    status VARCHAR(255) NOT NULL
);

-- Create the interests table
CREATE TABLE interests (
    interest_id SERIAL PRIMARY KEY,
    interest VARCHAR(255) NOT NULL
);

-- Create the seeking table
CREATE TABLE seeking (
    seeking_id SERIAL PRIMARY KEY,
    seeking VARCHAR(255) NOT NULL
);

-- Create the my_contacts table
CREATE TABLE my_contacts (
    contact_id SERIAL PRIMARY KEY,
    last_name VARCHAR(255) NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(255),
    gender VARCHAR(10),
    birthday DATE,
    prof_id INT REFERENCES profession(prof_id),
    zip_code CHAR(4) REFERENCES zip_code(zip_code),
    status_id INT REFERENCES status(status_id)
);

-- Create the joining table for contact interests (many-to-many relationship)
CREATE TABLE contact_interest (
    contact_id INT REFERENCES my_contacts(contact_id),
    interest_id INT REFERENCES interests(interest_id),
    PRIMARY KEY (contact_id, interest_id)
);

-- Create the joining table for contact seeking (many-to-many relationship)
CREATE TABLE contact_seeking (
    contact_id INT REFERENCES my_contacts(contact_id),
    seeking_id INT REFERENCES seeking(seeking_id),
    PRIMARY KEY (contact_id, seeking_id)
);

-- Insert data into the profession table
INSERT INTO profession (profession) VALUES 
('Engineer'),
('Doctor'),
('Teacher'),
('Artist'),
('Musician');

-- Insert data into the zip_code table (9 provinces, 2 cities each)
INSERT INTO zip_code (zip_code, city, province) VALUES
('1001', 'CityA1', 'Province1'),
('1002', 'CityA2', 'Province1'),
('2001', 'CityB1', 'Province2'),
('2002', 'CityB2', 'Province2'),
('3001', 'CityC1', 'Province3'),
('3002', 'CityC2', 'Province3'),
('4001', 'CityD1', 'Province4'),
('4002', 'CityD2', 'Province4'),
('5001', 'CityE1', 'Province5'),
('5002', 'CityE2', 'Province5'),
('6001', 'CityF1', 'Province6'),
('6002', 'CityF2', 'Province6'),
('7001', 'CityG1', 'Province7'),
('7002', 'CityG2', 'Province7'),
('8001', 'CityH1', 'Province8'),
('8002', 'CityH2', 'Province8'),
('9001', 'CityI1', 'Province9'),
('9002', 'CityI2', 'Province9');

-- Insert data into the status table
INSERT INTO status (status) VALUES
('Active'),
('Inactive'),
('Pending');

-- Insert data into the interests table
INSERT INTO interests (interest) VALUES
('Music'),
('Sports'),
('Art'),
('Technology'),
('Travel');

-- Insert data into the seeking table
INSERT INTO seeking (seeking) VALUES
('Friendship'),
('Relationship'),
('Networking');

-- Insert data into the my_contacts table (15+ contacts)
INSERT INTO my_contacts (last_name, first_name, phone, email, gender, birthday, prof_id, zip_code, status_id) VALUES
('Doe', 'John', '1234567890', 'john@example.com', 'Male', '1980-01-01', 1, '1001', 1),
('Smith', 'Jane', '2345678901', 'jane@example.com', 'Female', '1990-02-02', 2, '2001', 2),
('Brown', 'Charlie', '3456789012', 'charlie@example.com', 'Male', '1985-03-03', 3, '3001', 1),
('Johnson', 'Emily', '4567890123', 'emily@example.com', 'Female', '1978-04-04', 4, '4001', 2),
('Williams', 'Michael', '5678901234', 'michael@example.com', 'Male', '1992-05-05', 5, '5001', 1),
('Miller', 'Jessica', '6789012345', 'jessica@example.com', 'Female', '1987-06-06', 1, '6001', 1),
('Davis', 'Thomas', '7890123456', 'thomas@example.com', 'Male', '1993-07-07', 2, '7001', 3),
('Garcia', 'Sarah', '8901234567', 'sarah@example.com', 'Female', '1995-08-08', 3, '8001', 2),
('Martinez', 'David', '9012345678', 'david@example.com', 'Male', '1982-09-09', 4, '9001', 1),
('Taylor', 'Linda', '9123456789', 'linda@example.com', 'Female', '1977-10-10', 5, '1002', 1),
('Wilson', 'Robert', '9234567890', 'robert@example.com', 'Male', '1983-11-11', 1, '2002', 3),
('Moore', 'Patricia', '9345678901', 'patricia@example.com', 'Female', '1989-12-12', 2, '3002', 2),
('Anderson', 'Christopher', '9456789012', 'chris@example.com', 'Male', '1991-01-13', 3, '4002', 1),
('Thomas', 'Barbara', '9567890123', 'barbara@example.com', 'Female', '1979-02-14', 4, '5002', 2),
('Jackson', 'Steven', '9678901234', 'steven@example.com', 'Male', '1988-03-15', 5, '6002', 1);

-- Assign more than 2 interests to each contact in the contact_interest table
INSERT INTO contact_interest (contact_id, interest_id) VALUES
(1, 1), (1, 2), (1, 3),
(2, 2), (2, 3), (2, 4),
(3, 1), (3, 3), (3, 5),
(4, 2), (4, 4), (4, 5),
(5, 1), (5, 3), (5, 4),
(6, 2), (6, 3), (6, 5),
(7, 1), (7, 4), (7, 5),
(8, 1), (8, 2), (8, 3),
(9, 2), (9, 4), (9, 5),
(10, 1), (10, 3), (10, 4),
(11, 2), (11, 3), (11, 5),
(12, 1), (12, 4), (12, 5),
(13, 1), (13, 2), (13, 3),
(14, 3), (14, 4), (14, 5),
(15, 1), (15, 2), (15, 5);

-- Assign seeking options to each contact in the contact_seeking table
INSERT INTO contact_seeking (contact_id, seeking_id) VALUES
(1, 1), (1, 2),
(2, 2), (2, 3),
(3, 1), (3, 3),
(4, 1), (4, 2),
(5, 2), (5, 3),
(6, 1), (6, 3),
(7, 1), (7, 2),
(8, 2), (8, 3),
(9, 1), (9, 2),
(10, 2), (10, 3),
(11, 1), (11, 3),
(12, 1), (12, 2),
(13, 2), (13, 3),
(14, 1), (14, 2),
(15, 1), (15, 3);

-- This query will display the profession, zip_code (postal_code, city, and province), 
-- status, interests, and seeking for each contact.

SELECT 
    mc.last_name,
    mc.first_name,
    p.profession,
    zc.zip_code,
    zc.city,
    zc.province,
    s.status,
    string_agg(DISTINCT i.interest, ', ') AS interests,
    string_agg(DISTINCT sk.seeking, ', ') AS seeking
FROM 
    my_contacts mc
LEFT JOIN 
    profession p ON mc.prof_id = p.prof_id
LEFT JOIN 
    zip_code zc ON mc.zip_code = zc.zip_code
LEFT JOIN 
    status s ON mc.status_id = s.status_id
LEFT JOIN 
    contact_interest ci ON mc.contact_id = ci.contact_id
LEFT JOIN 
    interests i ON ci.interest_id = i.interest_id
LEFT JOIN 
    contact_seeking cs ON mc.contact_id = cs.contact_id
LEFT JOIN 
    seeking sk ON cs.seeking_id = sk.seeking_id
GROUP BY 
    mc.contact_id, p.profession, zc.zip_code, zc.city, zc.province, s.status
ORDER BY 
    mc.last_name, mc.first_name;
