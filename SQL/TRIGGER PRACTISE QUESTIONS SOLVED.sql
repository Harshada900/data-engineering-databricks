CREATE TABLE students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    marks INT
);

CREATE TABLE log_table (
    message VARCHAR(255)
);

INSERT INTO students (name, marks)
VALUES ('Harshada', 85),
       ('Priya', 92),
       ('Amit', 76);
SELECT * FROM STUDENTS;

-- LEVEL 1 — BASIC (Easy ones)
-- Q1. After inserting a new student, log a message
-- Goal: Whenever a new student is added, write a message like
-- “New student added: Harshada” in log_table.

DELIMITER //
CREATE TRIGGER LOG_MESSAGE
AFTER INSERT ON STUDENTS
FOR EACH ROW 
BEGIN
	INSERT INTO LOG_TABLE(MESSAGE) VALUES(CONCAT('NEW STUDENT ADDED:',NEW.NAME));
END
//
DELIMITER;

INSERT INTO students (name, marks)
VALUES ('HARSHU', 89);

SELECT * FROM LOG_TABLE;

-- Q2. When a student is deleted, log the name of the deleted student
-- Goal: If someone deletes a student from students, write
--  “Student deleted: Priya”
DELIMITER //
CREATE TRIGGER DELETE_LOG
AFTER DELETE ON STUDENTS
FOR EACH ROW
BEGIN
	INSERT INTO LOG_TABLE(MESSAGE) VALUES(concat('STUDENT DELETED: ',OLD.NAME));
END
// 
DELIMITER;

DELETE FROM STUDENTS WHERE name='Priya';

SELECT * FROM LOG_TABLE;


-- Q3. Log when marks are updated
-- Whenever a student's marks are changed, log both old and new marks like:
--  “Harshada’s marks changed from 85 to 90”
DELIMITER //
CREATE TRIGGER UPDATE_MARKS
AFTER UPDATE ON STUDENTS
FOR EACH ROW
BEGIN
	INSERT INTO LOG_TABLE(MESSAGE) VALUES(CONCAT(OLD.NAME,"'S MARKS CHANGED FROM ",OLD.MARKS,' TO ',NEW.MARKS));
END 
//
DELIMITER;

UPDATE STUDENTS
SET MARKS=90
WHERE MARKS=85;

-- Q4. Prevent wrong data
-- Goal: Don’t allow any student to get marks above 100.
-- If someone tries to insert marks >100, automatically set marks = 100.

DELIMITER //
CREATE TRIGGER MARKS_CHECK
BEFORE INSERT ON STUDENTS
FOR EACH ROW 
BEGIN
	IF NEW.MARKS>100 THEN
    SET NEW.MARKS=100;
    END IF;
END//
DELIMITER;

INSERT INTO students (name, marks) VALUES ('Karan', 105);
SELECT * FROM students;

-- Q5. Backup deleted records
-- Goal:When a student is deleted, save their info in a students_backup table.

CREATE TABLE students_backup (
    id INT,
    name VARCHAR(50),
    marks INT
);

DELIMITER //
CREATE TRIGGER BACKUP_OF_STUDENTS
AFTER DELETE ON STUDENTS
FOR EACH ROW
BEGIN
 INSERT INTO STUDENTS_BACKUP(ID,NAME,MARKS) VALUES(OLD.ID,OLD.NAME,OLD.MARKS);
END//
DELIMITER;

DELETE FROM STUDENTS WHERE NAME='HARSHU';

SELECT * FROM STUDENTS_BACKUP;

-- Q6. Audit changes
-- Make a trigger that logs a message when either name or marks change, like:
-- “Amit’s record updated (old marks: 76 → new marks: 90, old name: Amit → new name: Amit Kumar)”


DELIMITER //
CREATE TRIGGER update_msg
AFTER UPDATE ON STUDENTS
FOR EACH ROW 
BEGIN 
	IF OLD.name <> NEW.name OR OLD.marks <> NEW.marks THEN
    INSERT INTO log_table(MESSAGE) VALUES(CONCAT('OLD MARKS: ',OLD.marks,'NEW MARKS: ',NEW.marks,'OLD NAME: ',OLD.NAME,'NEW NAME: ',NEW.NAME));
END IF;
	
END //
DELIMITER;

-- DROP TRIGGER LOG_MSG_UPDATES;

SELECT * FROM students;
SELECT * FROM log_table;

UPDATE students
SET marks = 90
WHERE name = 'Amit';

show triggers;