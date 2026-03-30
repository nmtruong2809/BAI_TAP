--BÀI 1: TẠO LƯỢC ĐỒ CSDL
CREATE TABLE s_region (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(50)
);

CREATE TABLE s_warehouse (
    id NUMBER PRIMARY KEY,
    region_id NUMBER,
    address VARCHAR2(100),
    city VARCHAR2(50),
    state VARCHAR2(50),
    country VARCHAR2(50),
    zip_code VARCHAR2(20),
    phone VARCHAR2(20),
    manager_id NUMBER
);

CREATE TABLE s_title (
    title VARCHAR2(50) PRIMARY KEY
);

CREATE TABLE s_dept (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(50),
    region_id NUMBER
);


CREATE TABLE s_emp (
    id NUMBER PRIMARY KEY,
    last_name VARCHAR2(50),
    first_name VARCHAR2(50),
    userid VARCHAR2(50),
    start_date DATE,
    comments VARCHAR2(100),
    manager_id NUMBER,
    title VARCHAR2(50),
    dept_id NUMBER,
    salary NUMBER,
    commission_pct NUMBER
);

CREATE TABLE s_customer (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    phone VARCHAR2(20),
    address VARCHAR2(100),
    city VARCHAR2(50),
    state VARCHAR2(50),
    country VARCHAR2(50),
    zip_code VARCHAR2(20),
    credit_rating VARCHAR2(10),
    sales_rep_id NUMBER,
    region_id NUMBER,
    comments VARCHAR2(100)
);


CREATE TABLE s_product (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    short_desc VARCHAR2(200),
    suggested_whlsl_price NUMBER
);

INSERT INTO s_customer VALUES (1, 'Nguyen Van A', '0123', 'HCM', 'HCM', 'SG', 'VN', '70000', 'A', 101, 1, '');
INSERT INTO s_customer VALUES (2, 'Tran Van B', '0456', 'HN', 'HN', 'HN', 'VN', '10000', 'B', 102, 1, '');

INSERT INTO s_emp VALUES (101, 'Nguyen', 'An', 'an01', TO_DATE('15-05-1990','DD-MM-YYYY'), '', NULL, 'Manager', 10, 1500, NULL);
INSERT INTO s_emp VALUES (102, 'Tran', 'Binh', 'binh02', TO_DATE('20-05-1991','DD-MM-YYYY'), '', NULL, 'Staff', 50, 1200, NULL);
INSERT INTO s_emp VALUES (103, 'Le', 'Son', 'son03', TO_DATE('10-01-1991','DD-MM-YYYY'), '', NULL, 'Staff', 31, 1400, NULL);

INSERT INTO s_product VALUES (1, 'Product Bicycle', 'Good bicycle', 500);
INSERT INTO s_product VALUES (2, 'Pro Max', 'High quality', 800);

COMMIT;
--BÀI 2: TRUY VẤN 
--1
SELECT name AS "Tên khách hàng", id AS "Mã khách hàng"
FROM s_customer
ORDER BY id DESC;
--2
SELECT last_name || ' ' || first_name AS Employees, dept_id
FROM s_emp
WHERE dept_id IN (10, 50)
ORDER BY first_name;
--3
SELECT *
FROM s_emp
WHERE first_name LIKE '%S%' OR last_name LIKE '%S%';
--4
SELECT userid, start_date
FROM s_emp
WHERE start_date BETWEEN TO_DATE('14-05-1990','DD-MM-YYYY')
AND TO_DATE('26-05-1991','DD-MM-YYYY');
--5
SELECT first_name, salary
FROM s_emp
WHERE salary BETWEEN 1000 AND 2000;
--6
SELECT first_name AS "Employee Name", salary AS "Monthly Salary"
FROM s_emp
WHERE dept_id IN (31, 42, 50)
AND salary > 1350;
--7
SELECT first_name, start_date
FROM s_emp
WHERE EXTRACT(YEAR FROM start_date) = 1991;
--8
SELECT first_name || ' ' || last_name
FROM s_emp
WHERE id NOT IN (SELECT DISTINCT manager_id FROM s_emp WHERE manager_id IS NOT NULL);
--9
SELECT name
FROM s_product
WHERE name LIKE 'Pro%'
ORDER BY name;
--10
SELECT name, short_desc
FROM s_product
WHERE LOWER(short_desc) LIKE '%bicycle%';
--11
SELECT short_desc
FROM s_product;
--12
SELECT first_name || ' ' || last_name || ' (' || title || ')'
FROM s_emp;

--BÀI 3: CÁC HÀM TRONG SQL
--1. Lương tăng 15%
SELECT id, first_name, salary, salary * 1.15 AS increased_salary
FROM s_emp;
--2. Ngày xét tăng lương (thứ 2 sau 6 tháng)
SELECT first_name,
       start_date,
       TO_CHAR(
           NEXT_DAY(ADD_MONTHS(start_date, 6), 'MONDAY'),
           'fmDdspth "of" Month YYYY'
       ) AS review_date
FROM s_emp;
--3. Sản phẩm có chữ “ski”
SELECT name
FROM s_product
WHERE LOWER(name) LIKE '%ski%';
--4. Số tháng làm việc (thâm niên)
SELECT first_name,
       ROUND(MONTHS_BETWEEN(SYSDATE, start_date)) AS months_worked
FROM s_emp
ORDER BY months_worked;
--5. Có bao nhiêu người quản lý
SELECT COUNT(DISTINCT manager_id) AS total_managers
FROM s_emp
WHERE manager_id IS NOT NULL;
--6. Giá trị đơn hàng cao nhất và thấp nhất
SELECT MAX(total) AS Highest, MIN(total) AS Lowest
FROM s_ord;


--BÀI 4: PHÉP KẾT (JOIN)
--1. Sản phẩm trong đơn hàng 101
SELECT p.name, p.id, i.quantity AS ORDERED
FROM s_item i
JOIN s_product p ON i.product_id = p.id
WHERE i.ord_id = 101;
--2. Tất cả khách hàng (kể cả chưa đặt hàng)
SELECT c.id, o.id
FROM s_customer c
LEFT JOIN s_ord o ON c.id = o.customer_id
ORDER BY c.id;
--3. Đơn hàng > 100000
SELECT o.customer_id, i.product_id, i.quantity
FROM s_ord o
JOIN s_item i ON o.id = i.ord_id
WHERE o.total > 100000;
--BÀI 5: HÀM GOM NHÓM (GROUP BY)
--1. Mỗi manager quản lý bao nhiêu người
SELECT manager_id, COUNT(*) AS total_emp
FROM s_emp
WHERE manager_id IS NOT NULL
GROUP BY manager_id;
--2. Manager quản lý >= 20 nhân viên
SELECT manager_id, COUNT(*) AS total_emp
FROM s_emp
WHERE manager_id IS NOT NULL
GROUP BY manager_id
HAVING COUNT(*) >= 20;
--3. Mỗi vùng có bao nhiêu phòng ban
SELECT r.id, r.name, COUNT(d.id) AS total_dept
FROM s_region r
LEFT JOIN s_dept d ON r.id = d.region_id
GROUP BY r.id, r.name;
--4. Số đơn hàng của mỗi khách hàng
SELECT c.name, COUNT(o.id) AS total_orders
FROM s_customer c
LEFT JOIN s_ord o ON c.id = o.customer_id
GROUP BY c.name;
--5. Khách hàng có nhiều đơn hàng nhất
SELECT *
FROM (
    SELECT c.name, COUNT(o.id) AS total_orders
    FROM s_customer c
    JOIN s_ord o ON c.id = o.customer_id
    GROUP BY c.name
    ORDER BY total_orders DESC
)
WHERE ROWNUM = 1;
--6. Khách hàng mua nhiều tiền nhất
SELECT *
FROM (
    SELECT c.name, SUM(o.total) AS total_money
    FROM s_customer c
    JOIN s_ord o ON c.id = o.customer_id
    GROUP BY c.name
    ORDER BY total_money DESC
)
WHERE ROWNUM = 1;
--BÀI 6: TRUY VẤN CON 
--1. Nhân viên cùng phòng với "Lan"
SELECT last_name, first_name, start_date
FROM s_emp
WHERE dept_id = (
    SELECT dept_id
    FROM s_emp
    WHERE first_name = 'Lan'
);
--2. Lương > trung bình
SELECT id, last_name, first_name, userid
FROM s_emp
WHERE salary > (
    SELECT AVG(salary) FROM s_emp
);
--3. Lương > TB và tên chứa “L”
SELECT id, last_name, first_name
FROM s_emp
WHERE salary > (SELECT AVG(salary) FROM s_emp)
AND (first_name LIKE '%L%' OR last_name LIKE '%L%');
--4. Khách hàng chưa từng đặt hàng
SELECT *
FROM s_customer
WHERE id NOT IN (
    SELECT customer_id FROM s_ord
);




