-- Database: Blood Donation Management System
CREATE DATABASE Blood;
USE Blood;

-- Users Table
CREATE TABLE Users (
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    Username VARCHAR(50) UNIQUE NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    Role ENUM('Donor', 'Hospital', 'Admin') NOT NULL
);

-- Donors Table
CREATE TABLE Donors (
    DonorID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT UNIQUE,
    Name VARCHAR(100) NOT NULL,
    Age INT CHECK (Age >= 18 AND Age <= 65),
    BloodGroup VARCHAR(5) NOT NULL,
    ContactNumber VARCHAR(15) UNIQUE NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Address TEXT,
    LastDonationDate DATE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- Blood Banks Table
CREATE TABLE BloodBanks (
    BloodBankID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Location VARCHAR(255) NOT NULL,
    ContactNumber VARCHAR(15) UNIQUE NOT NULL,
    Email VARCHAR(100) UNIQUE
);

-- Hospitals Table
CREATE TABLE Hospitals (
    HospitalID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT UNIQUE,
    Name VARCHAR(100) NOT NULL,
    Location VARCHAR(255) NOT NULL,
    ContactNumber VARCHAR(15) UNIQUE NOT NULL,
    Email VARCHAR(100) UNIQUE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- Blood Donations Table
CREATE TABLE BloodDonations (
    DonationID INT PRIMARY KEY AUTO_INCREMENT,
    DonorID INT NOT NULL,
    BloodBankID INT NOT NULL,
    DonationDate DATE NOT NULL,
    Quantity INT CHECK (Quantity > 0),
    FOREIGN KEY (DonorID) REFERENCES Donors(DonorID) ON DELETE CASCADE,
    FOREIGN KEY (BloodBankID) REFERENCES BloodBanks(BloodBankID) ON DELETE CASCADE
);

-- Blood Requests Table
CREATE TABLE BloodRequests (
    RequestID INT PRIMARY KEY AUTO_INCREMENT,
    HospitalID INT NOT NULL,
    BloodGroup VARCHAR(5) NOT NULL,
    Quantity INT CHECK (Quantity > 0),
    RequestDate DATE NOT NULL,
    Status ENUM('Pending', 'Fulfilled', 'Rejected') DEFAULT 'Pending',
    FOREIGN KEY (HospitalID) REFERENCES Hospitals(HospitalID) ON DELETE CASCADE
);

-- ✅ Junction Table: Many-to-Many Relationship Between Hospitals & Blood Banks
CREATE TABLE BloodRequestDetails (
    RequestID INT NOT NULL,
    BloodBankID INT NOT NULL,
    FOREIGN KEY (RequestID) REFERENCES BloodRequests(RequestID) ON DELETE CASCADE,
    FOREIGN KEY (BloodBankID) REFERENCES BloodBanks(BloodBankID) ON DELETE CASCADE,
    PRIMARY KEY (RequestID, BloodBankID)
);

-- Events Table
CREATE TABLE Events (
    EventID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Location VARCHAR(255) NOT NULL,
    Date DATE NOT NULL,
    OrganizedBy VARCHAR(100)
);

-- Volunteers Table
CREATE TABLE Volunteers (
    VolunteerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    ContactNumber VARCHAR(15) UNIQUE NOT NULL,
    Email VARCHAR(100) UNIQUE,
    EventID INT NOT NULL,
    FOREIGN KEY (EventID) REFERENCES Events(EventID) ON DELETE CASCADE
);

ALTER TABLE volunteers DROP INDEX ContactNumber;

Describe volunteers;

ALTER TABLE volunteers DROP INDEX Email;

DESCRIBE volunteers;

-- ✅ Junction Table: Many-to-Many Relationship Between Donors & Events
CREATE TABLE DonorEvents (
    DonorID INT NOT NULL,
    EventID INT NOT NULL,
    FOREIGN KEY (DonorID) REFERENCES Donors(DonorID) ON DELETE CASCADE,
    FOREIGN KEY (EventID) REFERENCES Events(EventID) ON DELETE CASCADE,
    PRIMARY KEY (DonorID, EventID)
);

-- Test Results Table
CREATE TABLE TestResults (
    TestID INT PRIMARY KEY AUTO_INCREMENT,
    DonationID INT NOT NULL,
    HemoglobinLevel DECIMAL(3,1) CHECK (HemoglobinLevel > 0),
    BloodPressure VARCHAR(15),
    DiseaseScreening VARCHAR(255),
    FOREIGN KEY (DonationID) REFERENCES BloodDonations(DonationID) ON DELETE CASCADE
);

-- Inventory Table
CREATE TABLE Inventory (
    InventoryID INT PRIMARY KEY AUTO_INCREMENT,
    BloodBankID INT NOT NULL,
    BloodGroup VARCHAR(5) NOT NULL,
    AvailableUnits INT CHECK (AvailableUnits >= 0),
    LastUpdated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (BloodBankID) REFERENCES BloodBanks(BloodBankID) ON DELETE CASCADE
);

INSERT INTO users (UserID, Username, PasswordHash, Role) VALUES
(201, 'johndoe', 'e99a18c428cb38d5f260853678922e03', 'Donor'),
(202, 'janesmith', '2b3e6b6c8fd0ab68cbb8a9f9b7df0bd3', 'Donor'),
(203, 'robertjohnson', '98dce83da57b0395e163467c9dae521b', 'Donor'),
(204, 'emilydavis', 'b3e3b3e5b3d3c3f3a3e3c3b3d3e3f3a3', 'Donor'),
(205, 'michaelbrown', 'd41d8cd98f00b204e9800998ecf8427e', 'Donor'),
(206, 'sarahwilson', 'a87ff679a2f3e71d9181a67b7542122c', 'Donor'),
(207, 'davidlee', '5f4dcc3b5aa765d61d8327deb882cf99', 'Donor'),
(208, 'lauraharris', '7c6a180b36896a0a8c02787eeafb0e4c', 'Donor'),
(209, 'jameswhite', '6c569aabbf7775ef8fc570e228c16b98', 'Donor'),
(210, 'patriciamoore', 'e99a18c428cb38d5f260853678922e03', 'Donor'),
(211, 'williamtaylor', '5f4dcc3b5aa765d61d8327deb882cf99', 'Donor'),
(212, 'lindaanderson', '7c6a180b36896a0a8c02787eeafb0e4c', 'Donor'),
(213, 'danielthomas', '98dce83da57b0395e163467c9dae521b', 'Donor'),
(214, 'barbarajackson', 'd41d8cd98f00b204e9800998ecf8427e', 'Donor'),
(215, 'richardmartin', '2b3e6b6c8fd0ab68cbb8a9f9b7df0bd3', 'Donor');

INSERT INTO users (UserID, Username, PasswordHash, Role) VALUES
-- Hospital Users
(216, 'hospital_user1', 'passwordhash1', 'Hospital'),
(217, 'hospital_user2', 'passwordhash2', 'Hospital'),
(218, 'hospital_user3', 'passwordhash3', 'Hospital'),
(219, 'hospital_user4', 'passwordhash4', 'Hospital'),
(220, 'hospital_user5', 'passwordhash5', 'Hospital'),
-- Admin Users
(221, 'admin_user1', 'passwordhash1', 'Admin'),
(222, 'admin_user2', 'passwordhash2', 'Admin'),
(223, 'admin_user3', 'passwordhash3', 'Admin'),
(224, 'admin_user4', 'passwordhash4', 'Admin'),
(225, 'admin_user5', 'passwordhash5', 'Admin');

select * from users;

INSERT INTO donors (DonorID, UserID, Name, Age, BloodGroup, ContactNumber, Email, Address, LastDonationDate) VALUES
(1, 201, 'John Doe', 28, 'O+', '9876543210', 'johndoe@example.com', '123 Main St, Cityville', '2025-01-10'),
(2, 202, 'Jane Smith', 25, 'A+', '9876543211', 'janesmith@example.com', '456 Elm St, Townsville', '2025-01-15'),
(3, 203, 'Robert Johnson', 32, 'B-', '9876543212', 'robertjohnson@example.com', '789 Oak St, Villagetown', '2025-02-05'),
(4, 204, 'Emily Davis', 27, 'AB+', '9876543213', 'emilydavis@example.com', '159 Pine St, Metrocity', '2025-02-20'),
(5, 205, 'Michael Brown', 35, 'O-', '9876543214', 'michaelbrown@example.com', '753 Maple St, Riverside', '2025-03-01'),
(6, 206, 'Sarah Wilson', 30, 'A-', '9876543215', 'sarahwilson@example.com', '852 Cedar St, Hillside', '2025-03-07'),
(7, 207, 'David Lee', 26, 'B+', '9876543216', 'davidlee@example.com', '951 Birch St, Lakeshore', '2025-03-12'),
(8, 208, 'Laura Harris', 29, 'O+', '9876543217', 'lauraharris@example.com', '369 Redwood St, Greenfield', '2025-03-20'),
(9, 209, 'James White', 31, 'A+', '9876543218', 'jameswhite@example.com', '147 Spruce St, Downtown', '2025-03-25'),
(10, 210, 'Patricia Moore', 34, 'B-', '9876543219', 'patriciamoore@example.com', '258 Chestnut St, Uptown', '2025-04-01'),
(11, 211, 'William Taylor', 28, 'AB-', '9876543220', 'williamtaylor@example.com', '369 Sycamore St, Westwood', '2025-04-10'),
(12, 212, 'Linda Anderson', 27, 'O+', '9876543221', 'lindaanderson@example.com', '741 Willow St, Eastside', '2025-04-15'),
(13, 213, 'Daniel Thomas', 29, 'A-', '9876543222', 'danielthomas@example.com', '852 Fir St, Midtown', '2025-04-22'),
(14, 214, 'Barbara Jackson', 33, 'B+', '9876543223', 'barbarajackson@example.com', '963 Palm St, Southtown', '2025-04-30'),
(15, 215, 'Richard Martin', 30, 'AB+', '9876543224', 'richardmartin@example.com', '123 Magnolia St, Northside', '2025-05-05');



INSERT INTO bloodbanks (BloodBankID, Name, Location, ContactNumber, Email) VALUES
(1, 'Red Cross Blood Bank', '123 Main St, Toronto, ON', '416-555-1001', 'redcross@bb.ca'),
(2, 'Lifeline Blood Center', '456 Elm St, Vancouver, BC', '604-555-1002', 'lifeline@bb.ca'),
(3, 'Hope Blood Bank', '789 Oak Rd, Montreal, QC', '514-555-1003', 'hope@bb.ca'),
(4, 'Vital Blood Bank', '321 Pine St, Calgary, AB', '403-555-1004', 'vital@bb.ca'),
(5, 'Guardian Blood Bank', '654 Cedar Ave, Ottawa, ON', '613-555-1005', 'guardian@bb.ca'),
(6, 'Unity Blood Donation', '987 Birch Rd, Edmonton, AB', '780-555-1006', 'unity@bb.ca'),
(7, 'SaveLife Blood Bank', '159 Willow Ln, Halifax, NS', '902-555-1007', 'savelife@bb.ca'),
(8, 'Golden Heart Blood Bank', '753 Maple St, Winnipeg, MB', '204-555-1008', 'goldenheart@bb.ca'),
(9, 'PureBlood Bank', '852 Spruce Rd, Regina, SK', '306-555-1009', 'pureblood@bb.ca'),
(10, 'Heroic Blood Bank', '951 Redwood St, St. John’s, NL', '709-555-1010', 'heroic@bb.ca'),
(11, 'LifeSource Blood Bank', '753 Chestnut Ave, Mississauga, ON', '905-555-1011', 'lifesource@bb.ca'),
(12, 'Noble Blood Bank', '264 Aspen Dr, Quebec City, QC', '418-555-1012', 'noble@bb.ca'),
(13, 'PlasmaCare Blood Center', '489 Fir St, Saskatoon, SK', '306-555-1013', 'plasmacare@bb.ca'),
(14, 'Hope & Care Blood Bank', '623 Magnolia Blvd, Windsor, ON', '519-555-1014', 'hopeandcare@bb.ca'),
(15, 'EverGreen Blood Bank', '741 Cypress Ln, Thunder Bay, ON', '807-555-1015', 'evergreen@bb.ca');


INSERT INTO blooddonations (DonationID, DonorID, BloodBankID, DonationDate, Quantity) VALUES
(121, 1, 1, '2024-03-10', 450),
(122, 2, 2, '2024-03-02', 500),
(123, 3, 3, '2023-03-03', 400),
(124, 4, 4, '2022-03-04', 450),
(125, 5, 5, '2024-01-08', 500),
(126, 6, 6, '2025-03-06', 400),
(127, 7, 7, '2025-02-07', 450),
(128, 8, 8, '2025-03-09', 500),
(129, 9, 9, '2025-01-09', 400),
(130, 10, 10, '2025-03-12', 450),
(131, 11, 11, '2025-03-03', 500),
(132, 12, 12, '2025-03-12', 400),
(133, 13, 13, '2025-03-13', 450),
(134, 14, 14, '2025-03-14', 500),
(135, 15, 15, '2025-03-15', 400);

select * from blooddonations;

INSERT INTO hospitals (UserID, Name, Location, ContactNumber, Email) VALUES
(201, 'City Hospital', '123 Main St, Toronto, ON', '416-555-1001', 'cityhospital@example.com'),
(202, 'General Health Clinic', '45 Queen St, Vancouver, BC', '604-555-1002', 'generalclinic@example.com'),
(203, 'Sunrise Medical Center', '78 King St, Montreal, QC', '514-555-1003', 'sunrisemedical@example.com'),
(204, 'Wellness Hospital', '89 Bay St, Ottawa, ON', '613-555-1004', 'wellnesshosp@example.com'),
(205, 'NorthCare Hospital', '12 River Rd, Edmonton, AB', '780-555-1005', 'northcare@example.com'),
(206, 'Southside Health', '56 Elm St, Calgary, AB', '403-555-1006', 'southside@example.com'),
(207, 'Metro Medical Center', '34 Pine St, Winnipeg, MB', '204-555-1007', 'metromed@example.com'),
(208, 'St. Marys Hospital', '90 Park Ave, Halifax, NS', '902-555-1008', 'stmarys@example.com'),
(209, 'Royal Healthcare', '21 Hill St, St. John’s, NL', '709-555-1009', 'royalhealth@example.com'),
(210, 'Lakeside Medical', '77 Maple Rd, Regina, SK', '306-555-1010', 'lakeside@example.com'),
(211, 'Hope Hospital', '62 Birch St, Victoria, BC', '250-555-1011', 'hopehospital@example.com'),
(212, 'Grandview Clinic', '15 Oak St, Fredericton, NB', '506-555-1012', 'grandview@example.com'),
(213, 'Pioneer Hospital', '32 Cedar Rd, Whitehorse, YT', '867-555-1013', 'pioneerhosp@example.com'),
(214, 'Evergreen Health Center', '29 Spruce St, Yellowknife, NT', '867-555-1014', 'evergreenhc@example.com'),
(215, 'Summit Medical', '14 Aspen Ave, Iqaluit, NU', '867-555-1015', 'summitmed@example.com');

INSERT INTO bloodrequests (RequestID, HospitalID, BloodGroup, Quantity, RequestDate, Status) VALUES
(1, 1, 'A+', 500, '2025-03-01', 'Pending'),
(2, 2, 'O-', 450, '2025-03-02', 'Pending'),
(3, 3, 'B+', 600, '2025-03-03', 'Fulfille'),
(4, 4, 'AB-', 400, '2025-03-04', 'Pending'),
(5, 5, 'A-', 550, '2025-03-05', 'Pending'),
(6, 6, 'O+', 500, '2025-03-06', 'Fulfille'),
(7, 7, 'B-', 450, '2025-03-07', 'Pending'),
(8, 8, 'AB+', 600, '2025-03-08', 'Pending'),
(9, 9, 'A+', 400, '2025-03-09', 'Fulfille'),
(10, 10, 'O-', 550, '2025-03-10', 'Pending'),
(11, 11, 'B+', 500, '2025-03-11', 'Pending'),
(12, 12, 'AB-', 450, '2025-03-12', 'Fulfille'),
(13, 13, 'A-', 600, '2025-03-13', 'Pending'),
(14, 14, 'O+', 400, '2025-03-14', 'Fulfille'),
(15, 15, 'B-', 550, '2025-03-15', 'Pending');

INSERT INTO bloodrequests (RequestID, HospitalID, BloodGroup, Quantity, RequestDate, Status) VALUES
(1, 1, 'A+', 500, '2025-03-01', 'Pending'),
(2, 2, 'O-', 450, '2025-03-02', 'Rejected'),
(3, 3, 'B+', 600, '2025-03-03', 'Fulfilled'),
(4, 4, 'AB-', 400, '2025-03-04', 'Pending'),
(5, 5, 'A-', 550, '2025-03-05', 'Rejected'),
(6, 6, 'O+', 500, '2025-03-06', 'Fulfilled'),
(7, 7, 'B-', 450, '2025-03-07', 'Pending'),
(8, 8, 'AB+', 600, '2025-03-08', 'Pending'),
(9, 9, 'A+', 400, '2025-03-09', 'Fulfilled'),
(10, 10, 'O-', 550, '2025-03-10', 'Pending'),
(11, 11, 'B+', 500, '2025-03-11', 'Rejected'),
(12, 12, 'AB-', 450, '2025-03-12', 'Fulfilled'),
(13, 13, 'A-', 600, '2025-03-13', 'Pending'),
(14, 14, 'O+', 400, '2025-03-14', 'Fulfilled'),
(15, 15, 'B-', 550, '2025-03-15', 'Pending');



INSERT INTO bloodrequestdetails (RequestID, BloodBankID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10),
(11, 11),
(12, 12),
(13, 13),
(14, 14),
(15, 15);

INSERT INTO events (EventID, Name, Location, Date, OrganizedBy) VALUES
(1, 'Blood Donation Camp', 'City Hall, Downtown', '2025-03-01', 'Red Cross'),
(2, 'Charity Blood Drive', 'Community Center, Uptown', '2025-03-02', 'Blood Foundation'),
(3, 'Health Awareness Seminar', 'University Auditorium', '2025-03-03', 'Health Ministry'),
(4, 'Annual Blood Donation Event', 'Main Park, City Center', '2025-03-04', 'City Hospital'),
(5, 'Medical Conference 2025', 'Grand Convention Center', '2025-03-05', 'Medical Association'),
(6, 'World Blood Donor Day Celebration', 'National Stadium', '2025-06-14', 'Blood Bank of Nation'),
(7, 'Local Blood Collection Event', 'Local Gymnasium', '2025-03-06', 'Volunteer Network'),
(8, 'Health Screening Camp', 'City Hall, Main Street', '2025-03-07', 'Wellness Clinic'),
(9, 'Blood Donation Drive for Schools', 'High School Gymnasium', '2025-03-08', 'School Health Program'),
(10, 'Charity Walkathon for Health', 'City Park', '2025-03-09', 'Charity Foundation'),
(11, 'First Aid Training Seminar', 'Community Center, West Side', '2025-03-10', 'Emergency Medical Team'),
(12, 'Blood Donation Rally', 'Downtown Plaza', '2025-03-11', 'Red Cross Society'),
(13, 'Public Health Awareness Fair', 'Convention Center, East Side', '2025-03-12', 'Public Health Organization'),
(14, 'Emergency Blood Supply Drive', 'City Hospital, North Wing', '2025-03-13', 'Local Blood Bank'),
(15, 'Healthcare Providers Networking Event', 'Conference Hall, South Tower', '2025-03-14', 'Healthcare Forum');


INSERT INTO donorevents (DonorID, EventID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10),
(11, 11),
(12, 12),
(13, 13),
(14, 14),
(15, 15);

INSERT INTO inventory (BloodBankID, BloodGroup, AvailableUnits, LastUpdated) VALUES
(2, 'A-', 45, NOW()),
(9, 'A-', 45, NOW()),
(1, 'A+', 50, NOW()),
(1, 'A+', 50, NOW()),
(2, 'A-', 45, NOW()),
(3, 'B+', 60, NOW()),
(4, 'B-', 55, NOW()),
(5, 'O+', 70, NOW()),
(6, 'O-', 65, NOW()),
(7, 'AB+', 40, NOW()),
(8, 'AB-', 35, NOW()),
(9, 'A+', 30, NOW()),
(10, 'A-', 25, NOW()),
(11, 'B+', 20, NOW()),
(12, 'B-', 15, NOW()),
(13, 'O+', 10, NOW()),
(14, 'O-', 5, NOW()),
(15, 'AB+', 12, NOW());

select * from inventory;

INSERT INTO testresults (DonationID, HemoglobinLevel, BloodPressure, DiseaseScreening) VALUES
(121, 13.5, '120/80', 'No issues detected'),
(122, 14.0, '125/82', 'No issues detected'),
(123, 12.8, '118/76', 'No issues detected'),
(124, 13.2, '130/85', 'Minor anemia detected'),
(125, 14.5, '122/80', 'No issues detected'),
(126, 13.0, '128/84', 'Normal'),
(127, 12.0, '120/75', 'Anemia detected'),
(128, 14.2, '135/90', 'No issues detected'),
(129, 13.8, '122/78', 'No issues detected'),
(130, 12.5, '130/80', 'Minor anemia detected'),
(131, 14.1, '124/82', 'Normal'),
(132, 13.7, '130/85', 'No issues detected'),
(133, 14.3, '120/79', 'No issues detected'),
(134, 13.4, '135/88', 'Normal'),
(135, 12.9, '125/80', 'Anemia detected');

INSERT INTO volunteers (VolunteerID, Name, ContactNumber, Email, EventID) VALUES
(1, 'John Doe', '555-0101', 'johndoe@example.com', 1),
(2, 'Jane Smith', '555-0102', 'janesmith@example.com', 2),
(3, 'Bob Johnson', '555-0103', 'bobjohnson@example.com', 3),
(4, 'Alice Brown', '555-0104', 'alicebrown@example.com', 4),
(5, 'Charlie Green', '555-0105', 'charliegreen@example.com', 5),
(6, 'David White', '555-0106', 'davidwhite@example.com', 6),
(7, 'Emily Black', '555-0107', 'emilyblack@example.com', 7),
(8, 'Frank Blue', '555-0108', 'frankblue@example.com', 8),
(9, 'Grace Pink', '555-0109', 'gracepink@example.com', 9),
(10, 'Henry Red', '555-0110', 'henryred@example.com', 10),
(11, 'Ivy Purple', '555-0111', 'ivypurple@example.com', 11),
(12, 'Jack Yellow', '555-0112', 'jackyellow@example.com', 12),
(13, 'Lily Orange', '555-0113', 'lilyorange@example.com', 13),
(14, 'Michael Grey', '555-0114', 'michaelgrey@example.com', 14),
(15, 'Nina White', '555-0115', 'ninawhite@example.com', 15);


-- Insert volunteers with multiple event associations
INSERT INTO volunteers (VolunteerID, Name, ContactNumber, Email, EventID) VALUES
(16, 'John Doe', '555-0101', 'johndoe@example.com', 2),
(17, 'Jane Smith', '555-0102', 'janesmith@example.com', 3),
(18, 'Bob Johnson', '555-0103', 'bobjohnson@example.com', 4),
(19, 'Alice Brown', '555-0104', 'alicebrown@example.com', 5),
(20, 'Charlie Green', '555-0105', 'charliegreen@example.com', 2),
(21, 'David White', '555-0106', 'davidwhite@example.com', 2),
(22, 'Emily Black', '555-0107', 'emilyblack@example.com', 2),
(23, 'Frank Blue', '555-0108', 'frankblue@example.com', 2);

ALTER TABLE volunteers DROP INDEX ContactNumber;

Describe volunteers;

ALTER TABLE volunteers DROP INDEX Email;

DESCRIBE volunteers;



UPDATE users 
SET Role = 'Admin' 
WHERE UserID = 220;

UPDATE users 
SET Role = 'Admin' 
WHERE UserID = 210;

select * from users;

UPDATE donors 
SET ContactNumber = '9876543225', Email = 'newemail@example.com' 
WHERE DonorID = 5;

UPDATE donors 
JOIN blooddonations ON donors.DonorID = blooddonations.DonorID
SET donors.LastDonationDate = blooddonations.DonationDate
WHERE blooddonations.DonationID = 125;

DELETE FROM bloodrequests
WHERE Status = 'Rejected';

SET SQL_SAFE_UPDATES = 0;

DELETE FROM BloodRequests WHERE Status = 'Rejected';

rollback;

select * from bloodrequests;

DELETE from bloodrequests where Status = "Fulfilled" and Quantity < 500;

rollback;

select * from bloodrequests;

DELETE FROM bloodrequests
WHERE Status = 'Rejected' 
AND BloodGroup IN (
    SELECT BloodGroup 
    FROM bloodrequests
    GROUP BY BloodGroup
    HAVING AVG(Quantity) > 500
);

WITH HighAvgBloodGroup AS (
    SELECT BloodGroup 
    FROM bloodrequests 
    GROUP BY BloodGroup 
    HAVING AVG(Quantity) > 500
)
DELETE FROM bloodrequests 
WHERE Status = 'Rejected' 
AND BloodGroup IN (SELECT BloodGroup FROM HighAvgBloodGroup);

SELECT 
    d.Name AS DonorName, 
    COUNT(bd.DonationID) AS TotalDonations
FROM 
    BloodDonations bd
JOIN 
    donors d ON bd.BloodBankID = d.donors
GROUP BY 
    d.Name
HAVING 
    COUNT(bd.DonationID) > 10;
    
SELECT 
    d.Name AS DonorName, 
    COUNT(bd.DonationID) AS TotalDonations 
FROM 
    BloodDonations bd 
JOIN 
    Donors d ON bd.DonorID = d.DonorID  -- Correct Join Condition
GROUP BY 
    d.Name 
HAVING 
    COUNT(bd.DonationID) > 10;
    
    
    
SELECT d.Name, COUNT(bd.DonationID) AS TotalDonations
FROM BloodDonations bd
JOIN Donors d ON bd.DonorID = d.DonorID
GROUP BY d.Name;


SELECT COUNT(*) 
FROM Donors d 
LEFT JOIN BloodDonations bd ON d.DonorID = bd.DonorID;


-- Retrieve the total quantity of blood available in a specific blood bank
SELECT b.Name, SUM(i.AvailableUnits) AS Total_Blood_Stock
FROM Inventory i
JOIN BloodBanks b ON i.BloodBankID = b.BloodBankID
GROUP BY b.Name;



select * from inventory;
select * from bloodbanks;

-- Retrieve a list of donors who have donated more than once
SELECT d.DonorID, d.Name, COUNT(bd.DonationID) AS DonationCount
FROM Donors d
JOIN BloodDonations bd ON d.DonorID = bd.DonorID
GROUP BY d.DonorID, d.Name
HAVING COUNT(bd.DonationID) > 1;

select * from Donors;
select * from blooddonations;

-- Retrieve the most requested blood type
SELECT BloodGroup, COUNT(*) AS RequestCount
FROM BloodRequests
GROUP BY BloodGroup
ORDER BY RequestCount DESC;


select * from bloodrequests;

-- Certainly! Here’s a more complex query that involves multiple joins, aggregations, and filtering. Let’s say we want to generate a report for Blood Donations, where we track:

-- The total donations made by each donor.
-- The blood bank that received those donations.
-- The status of the donation in terms of test results (whether the donation passed the test based on Hemoglobin Level).


SELECT 
    d.Name AS DonorName,
    b.Name AS BloodBankName,
    COUNT(bd.DonationID) AS TotalDonations,
    SUM(CASE 
            WHEN tr.HemoglobinLevel >= 12.0 THEN 1 
            ELSE 0 
        END) AS SuccessfulDonations,
    COUNT(bd.DonationID) - SUM(CASE 
                                    WHEN tr.HemoglobinLevel >= 12.0 THEN 1 
                                    ELSE 0 
                                END) AS UnsuccessfulDonations
FROM 
    Donors d
JOIN 
    BloodDonations bd ON d.DonorID = bd.DonorID
JOIN 
    BloodBanks b ON bd.BloodBankID = b.BloodBankID
LEFT JOIN 
    TestResults tr ON bd.DonationID = tr.DonationID
GROUP BY 
    d.DonorID, b.BloodBankID
ORDER BY 
    TotalDonations DESC;
    
select * from blooddonations;
select * from bloodbanks;
select * from testresults;

-- we want to calculate the running total of donations made by each donor in the BloodDonations table, ordered by DonationDate. This can be achieved using the SUM() window function.

SELECT 
    d.Name AS DonorName,
    bd.DonationID,
    bd.DonationDate,
    bd.Quantity,
    SUM(bd.Quantity) OVER (PARTITION BY d.DonorID ORDER BY bd.DonationDate) AS RunningTotal
FROM 
    Donors d
JOIN 
    BloodDonations bd ON d.DonorID = bd.DonorID
ORDER BY 
    d.DonorID, bd.DonationDate;
    
-- we want to calculate the total donations per donor, but we also want to calculate the average donation quantity for each donor. We can use a CTE to first calculate the total donations and then perform further aggregation.

WITH DonationSummary AS (
    SELECT 
        d.DonorID,
        d.Name AS DonorName,
        COUNT(bd.DonationID) AS TotalDonations,
        sum(bd.Quantity) AS TotalQuantity
    FROM 
        Donors d
    JOIN 
        BloodDonations bd ON d.DonorID = bd.DonorID
    GROUP BY 
        d.DonorID
)
SELECT 
    DonorName,
    TotalDonations,
    TotalQuantity,
    TotalQuantity / TotalDonations AS AverageDonation
FROM 
    DonationSummary
ORDER BY 
    TotalDonations DESC;
    
select * from donors;
select * from blooddonations;



SELECT 
    v.Name AS VolunteerName,
    e.Name AS EventName,
    d.Name AS DonorName
FROM 
    Volunteers v
JOIN 
    Events e ON v.EventID = e.EventID
LEFT JOIN 
    DonorEvents de ON e.EventID = de.EventID
LEFT JOIN 
    Donors d ON de.DonorID = d.DonorID
ORDER BY 
    e.Name, v.Name;

-- duplicate 
SELECT 
    contactnumber,
    COUNT(*) AS duplicate_count
FROM 
    volunteers
GROUP BY 
    contactnumber
HAVING 
    COUNT(*) > 1;

select * from donors;

-- Extracting Donor Health Data for ML

CREATE VIEW DonorHealthData AS
SELECT 
    d.DonorID, d.Age, d.BloodGroup, 
    t.HemoglobinLevel, t.BloodPressure, 
    CASE 
        WHEN t.DiseaseScreening LIKE '%Anemia%' THEN 1 
        ELSE 0 
    END AS HasAnemia
FROM Donors d
JOIN blooddonations don ON d.DonorID = don.DonorID
JOIN TestResults t ON don.DonationID = t.DonationID;

SELECT * FROM DonorHealthData;
