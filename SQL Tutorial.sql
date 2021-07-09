CREATE TABLE employee (
  emp_id INT PRIMARY KEY,
  first_name VARCHAR(40),
  last_name VARCHAR(40),
  birth_day DATE,
  sex VARCHAR(1),
  salary INT,
  super_id INT,
  branch_id INT
);

CREATE TABLE branch (
  branch_id INT PRIMARY KEY,
  branch_name VARCHAR(40),
  mgr_id INT,
  mgr_start_date DATE,
  FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL
);  

ALTER TABLE employee
ADD FOREIGN KEY(branch_id)
REFERENCES branch(branch_id)
ON DELETE SET NULL;

ALTER TABLE employee
ADD FOREIGN KEY(super_id)
REFERENCES employee(emp_id)
ON DELETE SET NULL;

CREATE TABLE client (
  client_id INT PRIMARY KEY,
  client_name VARCHAR(40),
  branch_id INT,
  FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
); 

CREATE TABLE works_with (
  emp_id INT,
  client_id INT,
  total_sales INT,
  PRIMARY KEY(emp_id, client_id),
  FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
  FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE
);

CREATE TABLE branch_supplier (
  branch_id INT,
  supplier_name VARCHAR(40),
  supply_type VARCHAR(40),
  PRIMARY KEY(branch_id, supplier_name),
  FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);

-- Corporate
INSERT INTO employee VALUES(100, 'David', 'Wallace', '1967-11-17', 'M', 250000, NULL, NULL);  

INSERT INTO branch VALUES(1, 'Corporate', 100, '2006-02-09');

UPDATE employee
SET branch_id = 1
WHERE emp_id = 100;

INSERT INTO employee VALUES(101, 'Jan', 'Levinson', '1961-05-11', 'F', 110000, 100, 1);

-- Scranton
INSERT INTO employee VALUES(102, 'Michael', 'Scott', '1964-03-15', 'M', 75000, 100, NULL);

INSERT INTO branch VALUES(2, 'Scranton', 102, '1992-04-06');

UPDATE employee
SET branch_id = 2
WHERE emp_id = 102;

INSERT INTO employee VALUES(103, 'Angela', 'Martin', '1971-06-25', 'F', 63000, 102, 2);
INSERT INTO employee VALUES(104, 'Kelly', 'Kapoor', '1980-02-05', 'F', 55000, 102, 2);
INSERT INTO employee VALUES(105, 'Stanley', 'Hudson', '1958-02-19', 'M', 69000, 102, 2);

-- Stamford
INSERT INTO employee VALUES(106, 'Josh', 'Porter', '1969-09-05', 'M', 78000, 100, NULL);

INSERT INTO branch VALUES(3, 'Stamford', 106, '1998-02-13');

UPDATE employee
SET branch_id = 3
WHERE emp_id = 106;

INSERT INTO employee VALUES(107, 'Andy', 'Bernard', '1973-07-22', 'M', 65000, 106, 3);
INSERT INTO employee VALUES(108, 'Jim', 'Halpert', '1978-10-01', 'M', 71000, 106, 3);


-- BRANCH SUPPLIER
INSERT INTO branch_supplier VALUES(2, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Patriot Paper', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'J.T. Forms & Labels', 'Custom Forms');
INSERT INTO branch_supplier VALUES(3, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(3, 'Stamford Lables', 'Custom Forms');

-- CLIENT
INSERT INTO client VALUES(400, 'Dunmore Highschool', 2);
INSERT INTO client VALUES(401, 'Lackawana Country', 2);
INSERT INTO client VALUES(402, 'FedEx', 3);
INSERT INTO client VALUES(403, 'John Daly Law, LLC', 3);
INSERT INTO client VALUES(404, 'Scranton Whitepages', 2);
INSERT INTO client VALUES(405, 'Times Newspaper', 3);
INSERT INTO client VALUES(406, 'FedEx', 2);

-- WORKS_WITH
INSERT INTO works_with VALUES(105, 400, 55000);
INSERT INTO works_with VALUES(102, 401, 267000);
INSERT INTO works_with VALUES(108, 402, 22500);
INSERT INTO works_with VALUES(107, 403, 5000);
INSERT INTO works_with VALUES(108, 403, 12000);
INSERT INTO works_with VALUES(105, 404, 33000);
INSERT INTO works_with VALUES(107, 405, 26000);
INSERT INTO works_with VALUES(102, 406, 15000);
INSERT INTO works_with VALUES(105, 406, 130000); 

-- BASIC QUERIES --
select * from works_with;

-- Find all employees --
select * 
FROM employee;

-- Find all Clients --
select * 
From client;

-- Find all Employees ordered by salaries -- 
select * from employee order by salary DESC;

-- Find all employees  ordered by sex then names --
select * from employee order by sex, first_name, last_name;

-- Find first 5 employee in the table -- 
select * from employee limit 5;

-- Find first and last name from employee --
select first_name as forename, last_name as surname from employee;

-- Find out all different genders --
select distinct sex from employee;
-- ------------------------------------------- --

-- SQL FUNCTIONS --

-- Find no of employees ---
Select count(emp_id) from employee; 

-- Find no of female employees born after 1970 -- 
select count(emp_id) from employee where sex = 'F' and birth_day > '1970-01-01';

-- Find average of all emloyee salaries --
select avg(salary) from employee;

-- Find all sex's --
select count(sex), sex from employee group by sex;

-- Find out how much each employee sold -- 
select sum(total_sales), emp_id from works_with group by emp_id; 

-- Find avg salaries of all male employees --
select avg(salary) from employee where sex ='M';

-- Find sum of salaries --
select sum(salary) from employee;

-- How much money each client spent --
select sum(total_sales), client_id from works_with group by client_id;

-- ---------------------------------------------------------------------------------

-- WILDCARDS --
-- Grab data that matches a specific pattern --
select * from client where client_name LIKE '%LLC';

-- Find any branch suppliers who are in the label business --
select * from branch_supplier where supplier_name LIKE '%Label%';

-- Find any employee born in october --
select * from employee where birth_day Like '____-11-__';

-- Find any clients who are schools --
select * from client where client_name LIKE '%school%';

-- ------------------------------------------------------------------------------------

-- UNIONS --

-- Find a list of employee and branch names --
select first_name as names from employee
union
select branch_name from branch
union
select client_name from client;

-- Find a list of all money spent or earned by the company --
select salary from employee
union
select total_sales from works_with;

-- Joins --
-- Find all branches and the names of their managers --
select employee.emp_id, employee.first_name, branch.branch_name  from employee join branch on employee.emp_id = branch.mgr_id; 

-- Nested Queries --
-- Find names of all employees who have sold over 30000 to one client.alter -- 
select first_name, last_name 
from employee 
where employee.emp_id IN ( 
	select works_with.emp_id
    from works_with
    where works_with.total_sales >30000
);

-- Find all clients who are handled by the branch that miachael scott manages
select client_name
from client
where branch_id IN (
	select branch_id
    from branch
    where mgr_id =102 
);

-- ON DELETE --
-- Deleting keys when they have foreign keys associated with them--
-- On delete set null keys associated with it are set to null
-- On delete cascase if we delete , all keys associated to it are gone 

-- TRIGGERS --
-- Block of code which will define a operation that would happen when x happens

CREATE TABLE trigger_test(
	message VARCHAR(20)
);