CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Trainee (
    TraineeID INT AUTO_INCREMENT PRIMARY KEY,
    Full_Name varchar(255) not null,
    Birth_Date date,
    Gender enum('male' , 'female' , 'unknown' ) default 'unknown',
    ET_IQ int check (ET_IQ >= 0 and ET_IQ <= 20),
    ET_Gmath int check (ET_Gmath >= 0 and ET_Gmath <=20),
    ET_English int check ( ET_English >=0 and ET_English <= 50),
    Training_Class varchar(255),
    Evaluation_Notes text
);

Alter table trainee
add column VTI_Account varchar(255) not null unique;