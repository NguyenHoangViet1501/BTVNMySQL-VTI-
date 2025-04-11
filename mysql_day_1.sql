create database University_System;
use University_System;

create table Student (
	student_id int primary key auto_increment,
    full_name varchar(100) not null,
    birth_date date not null,
    gender enum('Male', 'Female'),
    email varchar(100) unique not null,
    gpa decimal (3,2) check (gpa between 0.0 and 4.0)
    
);

create table Course (
	course_id int primary key,
    course_name varchar(100),
    credits int check (credits between 1 and 5),
    professor_id int not null

);

create table Professor (
	professor_id int primary key,
    full_name varchar(100) not null,
    hire_date date not null,
    email varchar(100) unique not null
    
);
 create table Erollment (
	student_id int not null,
    course_id int not null,
    enroll_date date not null,
    grade int check (grade between 1 and 20),
    primary key (student_id, course_id),
    foreign key (student_id) references Student(student_id),
    foreign key (course_id) references Course(course_id)
    
 );

alter table Course
add constraint fk_course_professor foreign key (professor_id) references Professor(professor_id);