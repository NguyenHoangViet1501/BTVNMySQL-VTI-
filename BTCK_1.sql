CREATE DATABASE StudentManagerment;
USE StudentManagerment;

CREATE TABLE Student (
	ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Age INT,
    Gender TINYINT
);

CREATE TABLE Subject (
	ID INT PRIMARY KEY,
    Mane VARCHAR(100)
);

CREATE TABLE StudenttSubject (
	StudentID INT,
    SubjectID INT,
    Mark FLOAT, 
    Date DATE,
    PRIMARY KEY (StudentID, SubjectID ),
    FOREIGN KEY (StudentID) REFERENCES Student(ID),
    FOREIGN KEY (SubjectID) REFERENCES Subject(ID)
);

INSERT INTO Student VALUES (1, 'Nguyen Van A', 16, 0);
INSERT INTO Student VALUES (2, 'Tran Thi B', 17, 1);
INSERT INTO Student VALUES (3, 'Le Van C', 16, NULL);

INSERT INTO Subject VALUES (101, 'Math');
INSERT INTO Subject VALUES (102, 'Physics');
INSERT INTO Subject VALUES (103, 'History');

INSERT INTO StudentSubject VALUES (1, 101, 8.5, '2025-04-01');
INSERT INTO StudentSubject VALUES (2, 101, 9.0, '2025-04-02');
INSERT INTO StudentSubject VALUES (1, 102, 7.5, '2025-04-03');

-- 2 
-- a
SELECT s.ID, s.Name
FROM Subject s
LEFT JOIN StudentSubject ss ON s.ID = ss.SubjectID
WHERE ss.SubjectID IS NULL;

-- b 
SELECT s.ID, s.Name
FROM Subject s
JOIN StudentSubject ss ON s.ID = ss.SubjectID
GROUP BY s.ID, s.Name
HAVING COUNT(*) >= 2;

-- 3
CREATE VIEW StudentInfo AS
SELECT 
    st.ID AS StudentID,
    sb.ID AS SubjectID,
    st.Name AS StudentName,
    st.Age AS StudentAge,
    CASE 
        WHEN st.Gender = 0 THEN 'Male'
        WHEN st.Gender = 1 THEN 'Female'
        ELSE 'Unknown'
    END AS StudentGender,
    sb.Name AS SubjectName,
    ss.Mark,
    ss.Date
FROM StudentSubject ss
JOIN Student st ON ss.StudentID = st.ID
JOIN Subject sb ON ss.SubjectID = sb.ID;

-- 4
-- a
DELIMITER //
CREATE TRIGGER SubjectUpdateID
AFTER UPDATE ON Subject
FOR EACH ROW
BEGIN
    IF OLD.ID != NEW.ID THEN
        UPDATE StudentSubject
        SET SubjectID = NEW.ID
        WHERE SubjectID = OLD.ID;
    END IF;
END; 
//
DELIMITER ;

-- b 
DELIMITER //
CREATE TRIGGER StudentDeleteID
AFTER DELETE ON Student
FOR EACH ROW
DELETE FROM StudentSubject WHERE StudentID = OLD.ID;
//
DELIMITER ;

-- 5
DELIMITER //
CREATE PROCEDURE DeleteStudentByName(IN studentName VARCHAR(100))
BEGIN
    IF studentName = '*' THEN
        DELETE FROM StudentSubject;
        DELETE FROM Student;
    ELSE
        DELETE FROM StudentSubject
        WHERE StudentID IN (SELECT ID FROM Student WHERE Name = studentName);

        DELETE FROM Student
        WHERE Name = studentName;
    END IF;
END;
//
DELIMITER ;
