-- Tạo cơ sở dữ liệu
CREATE DATABASE CompanyDB;
USE CompanyDB;

-- Bảng phòng ban
CREATE TABLE Department (
    departmentId INT AUTO_INCREMENT PRIMARY KEY,
    departmentName VARCHAR(100) NOT NULL
);

-- Bảng nhân viên
CREATE TABLE Employee (
    employeeId INT AUTO_INCREMENT PRIMARY KEY,
    employeeName VARCHAR(100),
    email VARCHAR(100),
    salary DECIMAL(10,2),
    hireDate DATE,
    departmentId INT,
    managerId INT,
    FOREIGN KEY (departmentId) REFERENCES Department(departmentId),
    FOREIGN KEY (managerId) REFERENCES Employee(employeeId)
);

-- Bảng dự án
CREATE TABLE Project (
    projectId INT AUTO_INCREMENT PRIMARY KEY,
    projectName VARCHAR(100),
    startDate DATE,
    endDate DATE
);

-- Bảng phân công nhân viên vào dự án
CREATE TABLE EmployeeProject (
    employeeId INT,
    projectId INT,
    assignedDate DATE,
    PRIMARY KEY (employeeId, projectId),
    FOREIGN KEY (employeeId) REFERENCES Employee(employeeId),
    FOREIGN KEY (projectId) REFERENCES Project(projectId)
);

-- Tạo bảng Task
CREATE TABLE Task (
    taskId INT AUTO_INCREMENT PRIMARY KEY,
    taskName VARCHAR(100),
    projectId INT,
    employeeId INT,
    FOREIGN KEY (projectId) REFERENCES Project(projectId),
    FOREIGN KEY (employeeId) REFERENCES Employee(employeeId)
);
-- Dữ liệu bảng Department
INSERT INTO Department (departmentName) VALUES 
('IT'), 
('HR'), 
('Finance'), 
('Marketing'), 
('Research');

-- Dữ liệu bảng Employee
INSERT INTO Employee (employeeName, email, salary, hireDate, departmentId, managerId) VALUES
('Alice Johnson', 'alice@company.com', 85000.00, '2022-03-01', 1, NULL),
('Bob Smith', 'bob@company.com', 70000.00, '2021-05-10', 2, NULL),
('Charlie Brown', 'charlie@company.com', 92000.00, '2023-02-15', 1, 1),
('Diana Prince', 'diana@company.com', 60000.00, '2020-11-20', 3, 2),
('Evan Lee', 'evan@company.com', 75000.00, '2024-01-05', 4, 1);

-- Dữ liệu bảng Project (đã thêm startDate và endDate)
INSERT INTO Project (projectName, startDate, endDate) VALUES 
('Web Development Platform', '2022-01-15', '2022-12-30'),
('Mobile App Development', '2023-03-01', '2023-10-15'),
('Cloud Infrastructure Setup', '2021-07-01', '2022-03-20'),
('Machine Learning Model', '2022-11-10', '2023-04-30'),
('API Integration Service', '2024-01-05', '2024-09-01');

-- Dữ liệu bảng EmployeeProject
INSERT INTO EmployeeProject (employeeId, projectId, assignedDate) VALUES
(1, 1, '2022-01-20'),
(2, 2, '2023-03-05'),
(3, 1, '2022-02-01'),
(4, 3, '2021-08-15'),
(5, 5, '2024-01-10');


INSERT INTO Employee (employeeName, email, salary, hireDate, departmentId, managerId) VALUES
('Frank Miller', 'frank@company.com', 68000.00, '2023-06-10', 1, 1),
('Grace Hopper', 'grace@company.com', 90000.00, '2022-12-01', 5, NULL),
('Henry Ford', 'henry@company.com', 72000.00, '2024-02-20', 4, 5),
('Isla Fisher', 'isla@company.com', 67000.00, '2021-09-17', 2, 2),
('Jack Black', 'jack@company.com', 71000.00, '2022-04-05', 3, 4),
('Karen Gillan', 'karen@company.com', 88000.00, '2023-07-22', 1, 1),
('Leo Messi', 'leo@company.com', 95000.00, '2024-03-14', 5, 6),
('Mona Lisa', 'mona@company.com', 64000.00, '2022-10-19', 2, 2),
('Nick Fury', 'nick@company.com', 87000.00, '2023-01-12', 1, 1),
('Olivia Wilde', 'olivia@company.com', 73000.00, '2024-04-02', 4, 5);

INSERT INTO EmployeeProject (employeeId, projectId, assignedDate) VALUES
(6, 1, '2023-06-15'),
(7, 5, '2024-01-20'),
(8, 2, '2023-03-10'),
(9, 5, '2024-02-01'),
(10, 4, '2024-04-10'),
(6, 2, '2023-06-20'),
(7, 3, '2024-01-25'),
(8, 3, '2023-03-12'),
(9, 4, '2024-02-05'),
(10, 5, '2024-04-12');



-- 1 SELECT * FROM companydb.employee; 
-- 2 select employeeName, email from employee; 
-- 3 select * from project where startDate = 2022;
-- 4 select * from employee where hireDate > '2021-01-01';
/* 5 select d.departmentName , count(e.employeeID) as soNV
 from department as d left join employee as e on d.departmentID = e.departmentID
group by d.departmentID; 
*/
-- 6 select * from department;
-- 7 select employeeName, salary from employee;
-- 8 select * from project where endDate > '2023-01-01';
-- 9select * from employee where salary > 70000;
-- 10 select * from employee where managerId is null;

-- Intermediate
/* 11 SELECT d.departmentName, SUM(e.salary) AS totalSalary
FROM department d LEFT JOIN Employee e on d.departmentId = e.departmentId
GROUP BY d.departmentName;
*/
/* 12 SELECT p.projectName 
FROM project p RIGHT JOIN employeeproject ep ON p.projectId = ep.projectId
Where ep.employeeId = 2;
*/
/* 13 SELECT e.employeeName, d.departmentName
FROM Employee e JOIN Department d ON e.departmentId = d.departmentId;
*/
/* 14 SELECT d.departmentName, e.employeeName, e.salary
FROM Employee e
JOIN Department d ON e.departmentId = d.departmentId
WHERE (e.departmentId, e.salary) IN (
    SELECT departmentId, MAX(salary)
    FROM Employee
    GROUP BY departmentId
);
*/
/* 15 SELECT e.employeeName, COUNT(ep.projectId) AS projectCount
FROM EmployeeProject ep JOIN Employee e ON ep.employeeId = e.employeeId
GROUP BY e.employeeId
HAVING COUNT(ep.projectId) > 1;
*/
/* 16 SELECT p.projectName, COUNT(ep.employeeId) AS totalEmployees
FROM Project p LEFT JOIN EmployeeProject ep ON p.projectId = ep.projectId
GROUP BY p.projectName;
*/
/* 17 SELECT e.employeeName, e.salary
FROM Employee e JOIN Department d ON e.departmentId = d.departmentId
WHERE d.departmentName = 'HR' AND e.salary > 60000;
*/
/* 18 SELECT p.projectName
FROM Project p LEFT JOIN EmployeeProject ep ON p.projectId = ep.projectId
WHERE ep.employeeId IS NULL;
*/
/* 19 SELECT e.employeeName AS NhanVien, m.employeeName AS QuanLy
FROM Employee e LEFT JOIN Employee m ON e.managerId = m.employeeId;
*/
/* 20 SELECT e.employeeName
FROM Employee e
JOIN Department d ON e.departmentId = d.departmentId
LEFT JOIN EmployeeProject ep ON e.employeeId = ep.employeeId
WHERE d.departmentName = 'Sales' AND ep.projectId IS NULL;
*/
-- Advanced
/* 21 SELECT e.employeeName, p.projectName, ep.assignedDate
FROM employee e JOIN employeeproject ep ON e.employeeId = ep.employeeId
JOIN project p ON ep.projectId = p.projectId;
*/
/* 22 SELECT p.projectName, COUNT(ep.employeeId) AS totalEmployees
FROM project p JOIN employeeproject ep ON p.projectId = ep.projectId
GROUP BY p.projectId
HAVING COUNT(ep.employeeId) >= 3;
*/
/* 23 SELECT e.employeeName
FROM employee e JOIN employeeProject ep ON e.employeeId = ep.employeeId
LEFT JOIN project p ON ep.projectId = p.projectId
WHERE p.projectName IN ('Website Redesign', 'Mobile App')
GROUP BY e.employeeId
HAVING COUNT(DISTINCT p.projectName) = 2;
*/
/* 24SELECT e2.employeeName
FROM employee e1 JOIN employee e2 ON e1.managerId = e2.managerId
WHERE e1.employeeName = 'Evan Lee' AND e2.employeeName != 'Evan Lee'; 
*/
/* 25 SELECT d.departmentName, AVG(e.salary) AS averageSalary
FROM department d JOIN employee e ON d.departmentId = e.departmentId
GROUP BY d.departmentId
HAVING COUNT(e.employeeId) > 1;
*/

-- Expert
-- 27 
SELECT DISTINCT p.projectName
FROM project p JOIN employeeProject ep ON p.projectId = ep.projectId
JOIN employee e ON ep.employeeId = e.employeeId
JOIN department d ON e.departmentId = d.departmentId
WHERE d.departmentName = 'Engineering';

-- 26
SELECT *
FROM employee
WHERE salary = (SELECT MAX(salary) FROM employee)
AND employeeId NOT IN (
select distinct managerId from employee where managerId is not null
);
-- 28
SELECT e.employeeName AS Employee, m.employeeName AS Manager, gm.employeeName AS GrandManager
FROM employee e LEFT JOIN employee m ON e.managerId = m.employeeId
LEFT JOIN employee gm ON m.managerId = gm.employeeId;
-- 29
SELECT e.employeeName, ep.assignedDate, e.hireDate
FROM employeeProject ep JOIN employee e ON ep.employeeId = e.employeeId
WHERE ep.assignedDate < e.hireDate;
-- 30
SELECT p.projectName, COUNT(ep.employeeId) AS numEmployees
FROM project p LEFT JOIN employeeProject ep ON p.projectId = ep.projectId
WHERE p.endDate > CURDATE()
GROUP BY p.projectId
HAVING COUNT(ep.employeeId) < 3;


