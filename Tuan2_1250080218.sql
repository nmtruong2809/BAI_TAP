--1.Liệt kê tên (last_name) và lương (salary) của những nhân viên có lương lớn
hơn 12000$.
SELECT last_name, salary
FROM employees
WHERE salary > 12000;

--2.Liệt kê tên và lương của những nhân viên có lương thấp hơn 5000$ hoặc
lớn hơn 12000$.
SELECT last_name, salary
FROM employees
WHERE salary < 5000 OR salary > 12000;

-- 3. Cho biết thông tin tên nhân viên (last_name), mã công việc (job_id), ngày
thuê (hire_date) của những nhân viên được thuê từ ngày 20/02/1998 đến
ngày 1/05/1998. Thông tin được hiển thị tăng dần theo ngày thuê.
SELECT last_name, job_id, hire_date
FROM employees
WHERE hire_date BETWEEN TO_DATE('20/02/1998','DD/MM/YYYY')
AND TO_DATE('01/05/1998','DD/MM/YYYY')
ORDER BY hire_date;

-- 4. Liệt kê danh sách nhân viên làm việc cho phòng 20 và 50. Thông tin hiển thị
gồm: last_name, department_id , trong đó tên nhân viên được sắp xếp theo thứ
tự alphabe.
SELECT last_name, department_id
FROM employees
WHERE department_id IN (20,50)
ORDER BY last_name;

-- 5. Liệt kê danh sách nhân viên được thuê năm 1994.
SELECT last_name, hire_date
FROM employees
WHERE TO_CHAR(hire_date,'YYYY')='1994';

-- 6. Liệt kê tên nhân viên (last_name), mã công việc (job_id) của những nhân
viên không có người quản lý.
SELECT last_name, job_id
FROM employees
WHERE manager_id IS NULL;

-- 7. Cho biết thông tin tất cả nhân viên được hưởng hoa hồng(commission_pct),
kết quả được sắp xếp giảm dần theo lương và hoa hồng.
SELECT last_name, salary, commission_pct
FROM employees
WHERE commission_pct IS NOT NULL
ORDER BY salary DESC, commission_pct DESC;

-- 8.Liệt kê danh sách nhân viên mà có kí tự thứ 3 trong tên là “a”.
SELECT last_name
FROM employees
WHERE last_name LIKE '__a%';

-- 9. Liệt kê danh sách nhân viên mà trong tên có chứa một chữ “a” và một chữ
“e”.
SELECT last_name
FROM employees
WHERE last_name LIKE '%a%'
AND last_name LIKE '%e%';

-- 10. Cho biết tên (last_name), mã công việc (job_id), lương (salary) của những
nhân viên làm “Sales representative” hoặc “Stock clert” và có mức lương khác
2500$, 3500$, 7000$.
SELECT last_name, job_id, salary
FROM employees
WHERE job_id IN ('SA_REP','ST_CLERK')
AND salary NOT IN (2500,3500,7000);

-- 11. Cho biết mã nhân viên (employee_id), tên nhân viên (last_name), lương
sau khi tăng thêm 15% so với lương ban đầu, được làm tròn đến hàng đơn vị
và đặt lại tên cột là “New Salary”.
SELECT employee_id, last_name,
ROUND(salary*1.15,0) AS "New Salary"
FROM employees;

-- 12. Cho biết tên nhân viên, chiều dài tương ứng của tên đối với những nhân
viên có kí tự bắt đầu trong tên là “J”, “A”, “L”,”M”. Kết quả hiển thị tăng dần
theo tên, kí tự đầu của tên viết hoa, các kí tự còn lại viết thường.(dùng hàm
INITCAP, LENGTH, SUBSTR)
SELECT INITCAP(last_name) AS "Ten",
LENGTH(last_name) AS "Do Dai"
FROM employees
WHERE SUBSTR(last_name,1,1) IN ('J','A','L','M')
ORDER BY last_name;

-- 13. Liệt kê danh sách nhân viên, khoảng thời gian (tính theo tháng) mà Nhân
viên đã làm việc trong công ty cho đến nay. Kết quả sắp xếp tăng dần theo số
lượng tháng làm việc. (dùng hàm MONTHS_BETWEEN).
SELECT last_name,
TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date)) AS "So Thang"
FROM employees
ORDER BY MONTHS_BETWEEN(SYSDATE, hire_date);

-- 14. Thực hiện câu truy vấn cho kết quả theo định dạng sau :
&lt;last_name&gt; earns &lt;salary&gt; monthly but wants &lt;3*salary&gt; . Cột được hiển thị
có tên “Dream Salaries”
SELECT last_name || ' earns ' ||
TO_CHAR(salary,'$99,999') ||
' monthly but wants ' ||
TO_CHAR(salary*3,'$99,999') AS "Dream Salaries"
FROM employees;

-- 15. Liệt kê tên nhân viên, mức hoa hồng nhân viên đó nhận được.
Trường hợp nhân viên nào không được hưởng hoa hồng thì hiển thị &quot;No
commission‟. (dùng hàm NVL)
SELECT last_name,
NVL(TO_CHAR(commission_pct),'No commission') AS "Commission"
FROM employees;

-- 16. Thực hiện câu truy vấn cho kết quả như sau: (dùng hàm DECODE hoặc
CASE…)
SELECT job_id,
CASE job_id
WHEN 'AD_PRES' THEN 'A'
WHEN 'ST_MAN' THEN 'B'
WHEN 'IT_PROG' THEN 'C'
WHEN 'SA_REP' THEN 'D'
WHEN 'ST_CLERK' THEN 'E'
ELSE '0'
END AS GRADE
FROM employees;

-- 17. Cho biết tên nhân viên, mã phòng, tên phòng của những nhân viên làm việc
ở thành phố Toronto.
SELECT e.last_name, e.department_id, d.department_name
FROM employees e, departments d, locations l
WHERE e.department_id = d.department_id
AND d.location_id = l.location_id
AND UPPER(l.city)='TORONTO';

-- 18. Liệt kê thông tin nhân viên cùng với người quản lý của nhân viên đó. Kết
quả hiển thị: mã nhân viên, tên nhân viên, mã người quản lý, tên người quản
lý.
SELECT e.employee_id, e.last_name,
m.employee_id AS manager_id,
m.last_name AS manager_name
FROM employees e, employees m
WHERE e.manager_id = m.employee_id;

-- 19. Liệt kê danh sách những nhân viên làm việc cùng phòng.
SELECT e1.last_name, e2.last_name, e1.department_id
FROM employees e1, employees e2
WHERE e1.department_id = e2.department_id
AND e1.employee_id < e2.employee_id;

-- 20. Liệt kê danh sách nhân viên được thuê sau nhân viên “Davies”.
SELECT last_name, hire_date
FROM employees
WHERE hire_date >
(SELECT hire_date FROM employees WHERE last_name='Davies');

-- 21. Liệt kê danh sách nhân viên được thuê vào làm trước người quản lý của
họ.
SELECT e.last_name, e.hire_date,
m.last_name AS manager, m.hire_date
FROM employees e, employees m
WHERE e.manager_id = m.employee_id
AND e.hire_date < m.hire_date;

-- 22. Cho biết lương thấp nhất, lương cao nhất, lương trung bình, tổng lương
của từng loại công việc.
SELECT job_id,
MIN(salary), MAX(salary),
AVG(salary), SUM(salary)
FROM employees
GROUP BY job_id;

-- 23. Cho biết mã phòng, tên phòng, số lượng nhân viên của từng phòng ban.
Cho biết tổng số nhân viên, tổng nhân viên được thuê từng năm 1995, 1996,
1997, 1998.
SELECT d.department_id, d.department_name, COUNT(e.employee_id) AS num_employees 
FROM departments d 
LEFT JOIN employees e ON d.department_id = e.department_id 
GROUP BY d.department_id, d.department_name;
--
SELECT COUNT(*) AS total_employees,
       SUM(CASE WHEN TO_CHAR(hire_date, 'YYYY') = '1995' THEN 1 ELSE 0 END) AS hired_1995,
       SUM(CASE WHEN TO_CHAR(hire_date, 'YYYY') = '1996' THEN 1 ELSE 0 END) AS hired_1996,
       SUM(CASE WHEN TO_CHAR(hire_date, 'YYYY') = '1997' THEN 1 ELSE 0 END) AS hired_1997,
       SUM(CASE WHEN TO_CHAR(hire_date, 'YYYY') = '1998' THEN 1 ELSE 0 END) AS hired_1998
FROM employees;

-- 25. Liệt kê tên, ngày thuê của những nhân viên làm việc cùng phòng với nhân
viên “Zlotkey”.
SELECT last_name, hire_date
FROM employees
WHERE department_id =
(SELECT department_id FROM employees WHERE last_name='Zlotkey')
AND last_name <> 'Zlotkey';

-- 26. Liệt kê tên nhân viên, mã phòng ban, mã công việc của những nhân viên
làm việc cho phòng ban đặt tại vị trí (location_id) 1700.
SELECT last_name, department_id, job_id
FROM employees
WHERE department_id IN
(SELECT department_id FROM departments WHERE location_id=1700);

-- 27. Liệt kê danh sách nhân viên có người quản lý tên “King‟.
SELECT last_name, manager_id
FROM employees
WHERE manager_id IN
(SELECT employee_id FROM employees WHERE last_name='King');

-- 28. Liệt kê danh sách nhân viên có lương cao hơn mức lương trung bình và
làm việc cùng phòng với nhân viên có tên kết thúc bởi “n‟.
SELECT last_name, salary, department_id
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)
AND department_id IN
(SELECT department_id FROM employees WHERE last_name LIKE '%n');

-- 29. Liệt kê danh sách mã phòng ban, tên phòng ban có ít hơn 3 nhân viên.
SELECT d.department_id, d.department_name
FROM departments d LEFT JOIN employees e
ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
HAVING COUNT(e.employee_id) < 3;

-- 30. Cho biết phòng ban nào có đông nhân viên nh ất, phòng ban nào có ít nhân
viên nhất.
SELECT department_id, COUNT(*) 
FROM employees
GROUP BY department_id
HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM employees GROUP BY department_id)
UNION
SELECT department_id, COUNT(*)
FROM employees
GROUP BY department_id
HAVING COUNT(*) = (SELECT MIN(COUNT(*)) FROM employees GROUP BY department_id);

-- 31. Liệt kê danh sách nhân viên được thuê vào ngày có số lượng nhân viên
được thuê đông nhất. (dùng hàm TO_CHAR(hire_date, “Day‟)).
SELECT last_name, hire_date
FROM employees
WHERE TO_CHAR(hire_date,'Day') =
(SELECT TO_CHAR(hire_date,'Day')
FROM employees
GROUP BY TO_CHAR(hire_date,'Day')
HAVING COUNT(*) =
(SELECT MAX(COUNT(*))
FROM employees
GROUP BY TO_CHAR(hire_date,'Day')));

-- 32. Liệt kê thông tin 3 nhân viên có lương cao nhất.
SELECT *
FROM (
SELECT last_name, salary
FROM employees
ORDER BY salary DESC
)
WHERE ROWNUM <= 3;

-- 33. Liệt kê danh sách nhân viên đang làm việc ở tiểu bang “California”.
SELECT e.last_name, e.department_id
FROM employees e, departments d, locations l
WHERE e.department_id = d.department_id
AND d.location_id = l.location_id
AND UPPER(l.state_province)='CALIFORNIA';

-- 34. Cập nhật tên của nhân viên có mã 3 thành “Drexler‟.
UPDATE employees
SET last_name='Drexler'
WHERE employee_id=3;
COMMIT;

-- 35. Liệt kê danh sách nhân viên có mức lương thấp hơn mức lương trung bình
của phòng ban mà nhân viên đó làm vi ệc.
SELECT e1.last_name, e1.salary
FROM employees e1
WHERE e1.salary <
(SELECT AVG(e2.salary)
FROM employees e2
WHERE e2.department_id = e1.department_id);

-- 36. Tăng thêm 100$ cho những nhân viên có lương nhỏ hơn 900$.
UPDATE employees
SET salary = salary + 100
WHERE salary < 900;
COMMIT;

-- 37. Xóa phòng ban 500.
DELETE FROM departments
WHERE department_id=500;
COMMIT;

-- 38. Xóa phòng ban nào chưa có nhân viên.
DELETE FROM departments d
WHERE NOT EXISTS (
SELECT 1 FROM employees e
WHERE e.department_id = d.department_id
);
COMMIT;