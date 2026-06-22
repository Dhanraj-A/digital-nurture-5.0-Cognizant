-- HANDS-ON 4
-- Query Optimisation, Indexes and EXPLAIN

-- 1. Check execution plan
EXPLAIN
SELECT s.first_name,
s.last_name,
c.course_name
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses c ON c.course_id = e.course_id
WHERE s.enrollment_year = 2022;

-- 2. Create Index on enrollment_year
CREATE INDEX idx_students_enrollment_year
ON students(enrollment_year);

-- 3. Create Composite Unique Index
CREATE UNIQUE INDEX idx_enrollment_unique
ON enrollments(student_id, course_id);

-- 4. Create Index on course_code
CREATE INDEX idx_course_code
ON courses(course_code);

-- 5. Run EXPLAIN again
EXPLAIN
SELECT s.first_name,
s.last_name,
c.course_name
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses c ON c.course_id = e.course_id
WHERE s.enrollment_year = 2022;

-- 6. Check all indexes
SHOW INDEX FROM students;
SHOW INDEX FROM enrollments;
SHOW INDEX FROM courses;

-- 7. Query using indexed column
SELECT *
FROM students
WHERE enrollment_year = 2022;

-- 8. Query using course_code index
SELECT *
FROM courses
WHERE course_code = 'CS301';

-- 9. Count enrollments per course
SELECT c.course_name,
COUNT(e.student_id) AS total_students
FROM courses c
LEFT JOIN enrollments e
ON c.course_id = e.course_id
GROUP BY c.course_id,c.course_name;

-- 10. Average grade points
SELECT c.course_name,
AVG(
CASE
WHEN e.grade='A' THEN 4
WHEN e.grade='B' THEN 3
WHEN e.grade='C' THEN 2
WHEN e.grade='D' THEN 1
ELSE 0
END
) AS avg_grade
FROM courses c
LEFT JOIN enrollments e
ON c.course_id=e.course_id
GROUP BY c.course_id,c.course_name;

-- 11. Students with more than one enrollment
SELECT student_id,
COUNT(course_id) AS total_courses
FROM enrollments
GROUP BY student_id
HAVING COUNT(course_id) > 1;

-- 12. Department wise student count
SELECT d.department_name,
COUNT(s.student_id) AS total_students
FROM departments d
LEFT JOIN students s
ON d.department_id=s.department_id
GROUP BY d.department_id,d.department_name;

-- 13. Professor salary report
SELECT prof_name,
salary
FROM professors
ORDER BY salary DESC;

-- 14. Verify indexes
SHOW INDEXES FROM students;
SHOW INDEXES FROM enrollments;
SHOW INDEXES FROM courses;
