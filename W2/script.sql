CREATE DATABASE university_academic_management_VMC;

USE university_academic_management_VMC;

SET SQL_SAFE_UPDATES=0;

CREATE TABLE students(
student_id INT AUTO_INCREMENT PRIMARY KEY,
full_name VARCHAR(60) NOT NULL,
email VARCHAR(60) NOT NULL,
genre VARCHAR(20) NOT NULL,
document_id VARCHAR(20) UNIQUE NOT NULL,
academic_program VARCHAR(60) NOT NULL,
birth_date TIMESTAMP NOT NULL,
entry_date TIMESTAMP NOT NULL
);

ALTER TABLE students
MODIFY COLUMN entry_date TIMESTAMP DEFAULT (CURRENT_DATE);

ALTER TABLE students
MODIFY COLUMN email VARCHAR(60) UNIQUE NOT NULL;

CREATE TABLE teachers(
teacher_id INT AUTO_INCREMENT PRIMARY KEY,
full_name VARCHAR(60) NOT NULL,
email VARCHAR(60) NOT NULL,
department VARCHAR(60) NOT NULL,
experience_since TIMESTAMP NOT NULL
);

ALTER TABLE teachers
MODIFY COLUMN email VARCHAR(60) UNIQUE NOT NULL;

CREATE TABLE courses(
course_id INT AUTO_INCREMENT PRIMARY KEY,
course_name VARCHAR(60) NOT NULL,
course_code VARCHAR(60) UNIQUE NOT NULL,
credits TINYINT NOT NULL,
teacher_id INT NOT NULL,
FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
);

ALTER TABLE courses
ADD CHECK (credits>0);

ALTER TABLE courses 
ADD semester INT NOT NULL DEFAULT 1;

CREATE TABLE enrollments(
enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
student_id INT NOT NULL,
course_id INT NOT NULL,
enrollment_date TIMESTAMP  NOT NULL,
score INT DEFAULT 0,
FOREIGN KEY (student_id) REFERENCES students(student_id),
FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);

ALTER TABLE enrollments
ADD CHECK (score>=0 AND score<100);

ALTER TABLE enrollments
MODIFY COLUMN score DECIMAL(5,2);

INSERT INTO students (full_name,email,genre,document_id,academic_program,birth_date)
VALUES 
("Selva del Monte","selva@gmail.com","Female","123456", "Architecture", "2021-04-15"),
("Leah Maria","leah@gmail.com","Female","223456", "Businness Management", "2013-04-11"),
("Koko","koko@gmail.com","Female","323456", "Philosofy", "2020-06-15"),
("Yako","yako@gmail.com","Male","423456", "Culinary", "2016-04-05"),
("Chile","chile@gmail.com","Male","523456", "Journalism", "2025-07-11")
;

INSERT INTO teachers (full_name,email,department,experience_since)
VALUES 
("Miel de Maple","miel@gmail.com","Computer Science","2012-08-15"),
("Morita Bonita","morita@gmail.com","Humanities","2015-01-10"),
("Naomi","namomi@gmail.com","Economics","2009-09-01")
;

INSERT INTO courses (course_name, course_code, credits, teacher_id)
VALUES
("Database Systems","dataS1", 4, 1),
("Artificial Intelligence Fundamentals","AIF1", 3, 1),
("Ethics and Critical Thinking","eCT2", 3, 2),
("Principles of Microeconomics","puEc3", 4, 3);

SELECT * FROM students;

SELECT * FROM courses;

INSERT INTO enrollments (student_id, course_id, enrollment_date, score)
VALUES
(1, 1, '2024-02-01', 88.50),
(1, 3, '2024-02-01', 91.00),
(2, 4, '2024-02-03', 76.25),
(2, 2, '2024-02-03', 82.00),
(3, 3, '2024-02-05', 95.75),
(4, 1, '2024-02-07', 67.40),
(4, 4, '2024-02-07', 72.80),
(5, 2, '2024-02-10', 89.60);

-- Listar todos los estudiantes con sus inscripciones y cursos (JOIN).
SELECT student.full_name AS student,
	course.course_name,
	enrollment.enrollment_date
FROM enrollments enrollment
JOIN students student ON enrollment.student_id = student.student_id
JOIN courses course ON enrollment.course_id = course.course_id
ORDER BY student.full_name;
	
-- Listar cursos dictados por docentes con > 5 años de experiencia.
SELECT course.course_name,
	teacher.full_name AS teacher,
	TIMESTAMPDIFF(YEAR, teacher.experience_since, CURDATE()) AS years_experience
FROM courses course
JOIN teachers teacher ON teacher.teacher_id = course.teacher_id
WHERE TIMESTAMPDIFF(YEAR, teacher.experience_since, CURDATE()) > 5;

-- Obtener promedio de calificaciones por curso (GROUP BY + AVG).
SELECT course_id, ROUND(AVG(score),2) AS average_score
FROM enrollments
GROUP BY course_id;
-- Aca solo veo los id de los cursos, necesito hacer un JOIN para que este mas clara la info

SELECT course.course_name, 
	ROUND(AVG(score),2) AS average_score
FROM enrollments enrollment 
JOIN courses course ON enrollment.course_id = course.course_id
GROUP BY course.course_name;

-- Mostrar estudiantes inscritos en más de un curso (HAVING COUNT(*) > 1).
SELECT student.full_name AS student,
	COUNT(enrollment.course_id) AS total_courses
FROM enrollments enrollment
JOIN students student ON enrollment.student_id = student.student_id
GROUP BY student.student_id
HAVING COUNT(enrollment.course_id)>1;

-- ALTER TABLE: agregar columna estado_academico a estudiantes.
ALTER TABLE students
ADD COLUMN academic_status VARCHAR(30) NOT NULL DEFAULT 'Active';

-- Eliminar un docente y observar el efecto en cursos (revisar ON DELETE en la FK).
DELETE FROM teachers
WHERE teacher_id = 3;

-- Sale error por FK, toca usar ON DELETE CASCADE
SHOW CREATE TABLE courses;

-- debe salir algo asi
-- CONSTRAINT `courses_ibfk_1`
-- FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`teacher_id`)

ALTER TABLE courses
DROP FOREIGN KEY courses_ibfk_1;

-- Se vuelve a crear con el ON DELETE CASCADE
ALTER TABLE courses
ADD CONSTRAINT fk_courses_teacher
FOREIGN KEY (teacher_id)
REFERENCES teachers(teacher_id)
ON DELETE CASCADE;

DELETE FROM teachers
WHERE teacher_id = 3;

-- Consultar cursos con más de 2 estudiantes inscritos (GROUP BY + COUNT + HAVING).
SELECT course.course_name AS course,
	COUNT(enrollment.student_id) AS total_students
FROM enrollments enrollment
JOIN courses course ON enrollment.course_id = course.course_id
GROUP BY course.course_id
HAVING COUNT(enrollment.student_id)>2;

-- Estudiantes cuya calificación promedio sea > promedio general (AVG() + subconsulta).
SELECT students.full_name,
       ROUND(AVG(enrollments.score),2) AS student_average
FROM enrollments
JOIN students ON enrollments.student_id = students.student_id
GROUP BY students.student_id, students.full_name
HAVING AVG(enrollments.score) > (
    SELECT AVG(score)
    FROM enrollments
);

-- Nombres de carreras con estudiantes inscritos en cursos del semestre ≥ 2 (IN o EXISTS).
UPDATE courses SET semester = 2
WHERE course_id = 2;

SELECT students.academic_program, 
select s.academic_program, 
FROM students;

select s.academic_program,
join students s from enrollments e,
on s.student_id = e.student_id,
where courses.semester >= 2;

SELECT DISTINCT academic_program
FROM students
WHERE student_id IN (
    SELECT e.student_id
    FROM enrollments e
    JOIN courses c ON e.course_id = c.course_id
    WHERE c.semester >= 2
);

-- Usar ROUND, SUM, MAX, MIN, COUNT para obtener indicadores.

-- Total de creditos matriculados
SELECT SUM(c.credits) AS total_enrrolled_credits
FROM enrollments e
JOIN courses c ON e.course_id = c.course_id;


-- Cantidad de estudiantes por curso
SELECT c.course_name,
       COUNT(e.enrollment_id) AS total_students
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;

-- Promdeio de notas por curso
SELECT c.course_name,
       ROUND(AVG(e.score), 2) AS average_grade
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;

-- Notas mas altas
SELECT 
    MAX(score) AS highest_grade,
    MIN(score) AS lowest_grade
FROM enrollments;

-- Promedio de notas por profesor
SELECT 
    t.full_name,
    ROUND(AVG(e.score),2) AS avg_grade
FROM teachers t
JOIN courses c ON t.teacher_id = c.teacher_id
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY t.full_name;

-- Vista con historial academico
CREATE VIEW academic_history_view AS
SELECT 
    s.full_name AS student_name,
    c.course_name AS course_name,
    t.full_name AS teacher_name,
    c.semester,
    e.score AS final_grade
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id
JOIN teachers t ON c.teacher_id = t.teacher_id;

SELECT * FROM academic_history_view;

-- Otorga permisos de solo lectura a un rol revisor_academico sobre la vista (GRANT SELECT).
CREATE ROLE revisor_academico;

GRANT SELECT 
ON academic_history_view 
TO revisor_academico;

-- Revoca permisos de modificación de datos en inscripciones para ese rol (REVOKE).
REVOKE INSERT, UPDATE, DELETE 
ON enrollments 
FROM revisor_academico;

GRANT SELECT ON enrollments TO revisor_academico;

-- Simula actualización de calificaciones usando BEGIN, SAVEPOINT, ROLLBACK y COMMIT.
BEGIN;

UPDATE enrollments
SET score = 4.5
WHERE enrollment_id = 1;

SAVEPOINT safe_point;

UPDATE enrollments
SET score = 1.0
WHERE enrollment_id = 2;

ROLLBACK TO safe_point;

COMMIT;

ROLLBACK;
