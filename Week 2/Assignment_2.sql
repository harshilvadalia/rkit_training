use StudentDB;

-- subqueries; students who scored above average score
select student_id, score 
from Marks
where score > (select AVG(score) from Marks);

-- students enrolled in the same course as Rohan Mehta
select s.student_id, s.name
FROM Students s
WHERE s.course_id = (
  SELECT s2.course_id 
  FROM Students s2 
  WHERE s2.name = 'Rohan Mehta'
);

-- “For every student, list the other students enrolled in the same course.” (correlated)
select student_id, name, course_id 
from Students s
where s.course_id = (
	select s2.course_id
    from Students s2
    where s2.course_id = s.course_id
);

-- UNION operations
SELECT course_name FROM Courses
UNION ALL
SELECT subject FROM Marks;

SELECT course_name FROM Courses
UNION
SELECT subject FROM Marks;


-- creating index on email for faster search
EXPLAIN SELECT * FROM Students WHERE email='rohan.mehta@example.com';

CREATE INDEX index_mail ON Students(email);
EXPLAIN SELECT * FROM Students WHERE email='rohan.mehta@example.com';

-- stored procedures
DELIMITER //

CREATE PROCEDURE GetStudentsByCourse(IN cname VARCHAR(100))
BEGIN
    SELECT s.student_id, s.name, s.age, s.gender, s.email
    FROM Students s
    JOIN Courses c ON s.course_id = c.course_id
    WHERE c.course_name = cname;
END //

DELIMITER ;

CALL GetStudentsByCourse('Computer Science');


-- functions
DROP FUNCTION GetGrade;
DELIMITER //

CREATE FUNCTION GetGrade(score INT)
RETURNS CHAR(1)
DETERMINISTIC
BEGIN
	
    RETURN CASE
        WHEN score >= 90 THEN 'A'
        WHEN score >= 80 THEN 'B'
        WHEN score >= 70 THEN 'C'
        WHEN score >= 60 THEN 'D'
        ELSE 'F'
    END;
END //

DELIMITER ;

SELECT student_id, subject, score, GetGrade(score) AS grade FROM Marks;


-- triggers
CREATE TABLE IF NOT EXISTS DeletedStudents (
    student_id INT,
    name VARCHAR(100),
    age INT,
    gender VARCHAR(10),
    course_id INT,
    email VARCHAR(100),
    deleted_at DATETIME
);

DELIMITER %%

CREATE TRIGGER LogDeletedStudent
BEFORE DELETE ON Students
FOR EACH ROW
BEGIN
    INSERT INTO DeletedStudents
    VALUES (OLD.student_id, OLD.name, OLD.age, OLD.gender, OLD.course_id, OLD.email, NOW());
END %%

DELIMITER ;

DELETE FROM Students WHERE student_id = 3;  
SELECT * FROM DeletedStudents;
-- what can be there instead of tables

-- views
CREATE VIEW StudentCourseView AS
SELECT s.name AS student_name, c.course_name as harshil
FROM Students s
JOIN Courses c ON s.course_id = c.course_id;

-- query from the view
SELECT * FROM StudentCourseView
WHERE harshil = 'Computer Science';

-- “Write a stored procedure using a cursor to list all male students from the Students table one by one.”
DELIMITER //

CREATE PROCEDURE GetMaleStudentsCursor()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE sid INT;
    DECLARE sname VARCHAR(100);

    -- cursor to fetch male students
    DECLARE male_cursor CURSOR FOR
        SELECT student_id, name FROM Students WHERE gender = 'Male';

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN male_cursor;

    read_loop: LOOP
        FETCH male_cursor INTO sid, sname;
        IF done THEN
            LEAVE read_loop;
        END IF;
        -- show each male student (can also insert into a temp table)
        SELECT sid AS student_id, sname AS student_name;
    END LOOP;

    CLOSE male_cursor;
END //

DELIMITER ;










