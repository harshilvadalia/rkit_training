show databases;
use StudentDB;

-- Students Table
CREATE TABLE Students (
  student_id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255),
  age INT,
  gender VARCHAR(10),
  course_id INT,
  PRIMARY KEY (student_id)
);

-- Courses table
CREATE TABLE Courses (
  course_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  course_name VARCHAR(150) NOT NULL,
  duration VARCHAR(50),
  PRIMARY KEY (course_id)
);

-- Marks table
CREATE TABLE Marks (
  mark_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  student_id INT UNSIGNED NOT NULL,
  subject VARCHAR(100) NOT NULL,
  score INT,
  PRIMARY KEY (mark_id)
  );

-- adding new column
ALTER TABLE Students ADD COLUMN email VARCHAR(100);

-- deletes teh table with structure
DROP TABLE IF EXISTS Marks;

-- marks table again
CREATE TABLE Marks (
  mark_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  student_id INT UNSIGNED NOT NULL,
  subject VARCHAR(100) NOT NULL,
  score INT,
  PRIMARY KEY (mark_id)
  );
  
-- inserting rows
INSERT INTO Courses (course_id, course_name, duration) VALUES
(101, 'Computer Science', 4),
(102, 'Mechanical Engineering', 4),
(103, 'Business Administration', 3),
(104, 'Data Science', 2),
(105, 'Graphic Design', 3),
(106, 'Graphic Design', 5);

INSERT INTO Marks (mark_id, student_id, subject, score) VALUES
(1, 1, 'Databases', 85),
(2, 1, 'Algorithms', 92),
(3, 2, 'Marketing', 78),
(4, 3, 'Thermodynamics', 81),
(5, 4, 'Databases', 88),
(6, 5, 'Machine Learning', 95),
(7, 2, 'Accounting', 82);

INSERT INTO Students (student_id, name, age, gender, course_id, email) VALUES
(1, 'Aarav Sharma', 21, 'Male', 101, 'aarav.sharma@example.com'),
(2, 'Priya Patel', 20, 'Female', 103, 'priya.patel@example.com'),
(3, 'Rohan Mehta', 22, 'Male', 102, 'rohan.mehta@example.com'),
(4, 'Sneha Reddy', 19, 'Female', 104, 'sneha.reddy@example.com'),
(5, 'Kabir Khan', 23, 'Male', 105, 'kabir.khan@example.com'); 

-- updating one student's course
UPDATE Students
SET course_id = 2
WHERE student_id = 1;

-- deleting one student's record
DELETE FROM Students WHERE student_id = 5;

-- students above age 20
select * from Students WHERE age > 20;   

-- students by alphabetically
select * from Students ORDER BY name ASC;

-- students enrolled in. each course using group by
select course_id, COUNT(*) AS num_students FROM Students GROUP BY course_id;

-- courses that has more than 2 students using having
select course_id, COUNT(*) AS num_students FROM Students GROUP BY course_id HAVING COUNT(*) > 2;


-- students and their enrolled courses with inner join
select s.name, c.course_name
from students s
inner join courses c on s.course_id = c.course_id;

-- students even if they are not enrolled in any course with left join
select s.name, c.course_name
from students s
left join courses c on s.course_id = c.course_id;

-- courses and their students using right join
select c.course_id, c.course_name, s.student_id, s.name as student_name
from students s
right join courses c on s.course_id = c.course_id;

-- highest, lowest and average marks
select subject,
       max(score) as highest_mark,
       min(score) as lowest_mark,
       avg(score) as average_mark
from marks
group by subject;

-- count males and females
select gender, count(*) as num_students
from students
group by gender;






