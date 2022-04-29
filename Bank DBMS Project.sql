-- After we created the ER Diagram, we need to create the databse schemas.
-- First, create all the majoy entities.

CREATE TABLE branch (
	branch_id INT PRIMARY KEY,
    branch_name VARCHAR(50),
    branch_address VARCHAR(50)
);

CREATE TABLE employee (
	employee_id INT PRIMARY KEY,
    employee_name VARCHAR(50),
    sex VARCHAR(1),
    salary INT
);

CREATE TABLE customer (
	customer_id INT PRIMARY KEY,
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    customer_address VARCHAR(50),
    phone INT 
);

CREATE TABLE loan (
	loan_id INT PRIMARY KEY,
    loan_type VARCHAR(20),
    loan_amount DECIMAL(10,2)
);

CREATE TABLE account (
	account_id INT PRIMARY KEY,
    account_type VARCHAR(20),
    balance DECIMAL(10,2)
);

-- Next, we want to map binary 1:1 relationship types.
-- There exists one between "branch" and "employee". 
-- Since "branch" has full participation, we add "manager_id" as a foreign key in the branch table.

ALTER TABLE branch
ADD manager_id INT;
ALTER TABLE branch
ADD FOREIGN KEY (manager_id) REFERENCES employee(employee_id)
ON DELETE SET NULL;

-- Next, we want to map 1:N relationship types.
-- We want to include the "1" side's primary key in the "N" side's table as a foreign key.
-- There are 4 in total.

ALTER TABLE employee
ADD branch_id INT;
ALTER TABLE employee
ADD FOREIGN KEY (branch_id) REFERENCES branch(branch_id)
ON DELETE SET NULL;

ALTER TABLE employee
ADD super_id INT;
ALTER TABLE employee
ADD FOREIGN KEY (super_id) REFERENCES employee(employee_id)
ON DELETE SET NULL;

ALTER TABLE loan
ADD branch_id INT;
ALTER TABLE loan
ADD FOREIGN KEY (branch_id) REFERENCES branch(branch_id)
ON DELETE SET NULL;

ALTER TABLE account
ADD branch_id INT;
ALTER TABLE account
ADD FOREIGN KEY (branch_id) REFERENCES branch(branch_id)
ON DELETE SET NULL;


-- Finally, to complete the schemas, we need to map the M:N relationship types.
-- We need to create a separate table for each M:N relationship who's primary key is a combination of both entities' primary key. 
-- There are 3 new tables we need to create. 

CREATE TABLE borrowed_by (
	loan_id INT,
    customer_id INT,
    PRIMARY KEY (loan_id, customer_id),
    FOREIGN KEY (loan_id) REFERENCES loan(loan_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE
);

CREATE TABLE owned_by (
	account_id INT,
    customer_id INT,
    PRIMARY KEY (account_id, customer_id),
    FOREIGN KEY (account_id) REFERENCES account(account_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE
);

CREATE TABLE works_with (
	employee_id INT,
    customer_id INT,
    sales DECIMAL(10,2),
    PRIMARY KEY (employee_id, customer_id),
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE
);

-- Now we have finsihed creating the entire database schemas, we can start inserting data to do some queries.
-- Let's insert some arbitrary data into each table.

INSERT INTO customer VALUES(1000, 'John', 'Smith', '100 First Road', '414444000');
INSERT INTO customer VALUES(1001, 'Jack', 'Steward', '100 Second Road', '414444001');
INSERT INTO customer VALUES(1002, 'Page', 'Kat', '102 First Road', '414444002');
INSERT INTO customer VALUES(1005, 'Cody', 'Sky', '100 Third Road', '416444000');
INSERT INTO customer VALUES(1006, 'Mindy', 'Li', '105 First Road', '418444000');
INSERT INTO customer VALUES(1007, 'Swan', 'Karim', '10 First Road', '412444000');
INSERT INTO customer VALUES(1010, 'Maria', 'Smith', '200 First Road', '411444000');
INSERT INTO customer VALUES(1200, 'Joe', 'Smith', '300 First Road', '214444000');
INSERT INTO customer VALUES(1060, 'Katy', 'Smith', '100 Fourth Road', '414444230');
INSERT INTO customer VALUES(1990, 'Matt', 'Lang', '100 First Ave', '413334000');

INSERT INTO employee(employee_id) VALUES(100);
INSERT INTO employee(employee_id) VALUES(103);
INSERT INTO employee(employee_id) VALUES(105);

INSERT INTO branch VALUES(1, 'North York', '1 York Road', 100);
INSERT INTO branch VALUES(2, 'Scarborough', '20 University Road', 103);
INSERT INTO branch VALUES(3, 'Markham', '15 Golf Road', 105);

INSERT INTO employee(employee_id)
VALUES
(102),
(104),
(106),
(107),
(108),
(109),
(110);

INSERT INTO employee
VALUES
(100, 'Johnny', 'M', 100000, 1, NULL),
(101, 'Debbie','F', 50000, 2, 100),
(102, 'Mark', 'M', 50000, 1, 101),
(103, 'Amy', 'F', 110000, 2, 100),
(104, 'Cam', 'M', 80000, 3, 103),
(105, 'Steve', 'M', 100000, 3, 100),
(106, 'Rachel', 'F', 70000, 1, 105),
(107, 'Ruby', 'F', 40000, 2, 100),
(108, 'Hank', 'M', 40000, 2, 100),
(109, 'George', 'M', 80000, 2, NULL),
(110, 'Berlin', 'M', 80000, 3, NULL)
ON DUPLICATE KEY UPDATE 
employee_name = VALUES(employee_name),
sex = VALUES(sex),
salary = VALUES(salary),
branch_id = VALUES(branch_id),
super_id = VALUES(super_id);

INSERT INTO loan 
VALUES
(10000, 'Personal', 50000.0, 2),
(10001, 'Auto', 10000.0, 1),
(10002, 'Student', 20000.0, 1),
(10003, 'Mortgage', 100000.0, 3),
(10004, 'Personal', 20000.0, 3);

INSERT INTO account
VALUES
(40000, 'Chequing', 2000.0, 1),
(40001, 'Chequing', 5000.0, 1),
(40002, 'Savings', 10000.0, 3),
(40003, 'Savings', 200000.0, 2),
(40004, 'Savings', 10000.0, 2),
(40005, 'Chequing', 8000.0, 3),
(40006, 'Savings', 4000.0, 1),
(40007, 'Savings', 200000.0, 1),
(40008, 'Chequing', 350.0, 2),
(40009, 'Chequing', 4780.0, 1),
(40010, 'Chequing', 100.0, 2);
INSERT INTO account
VALUES
(40011, 'Savings', 3000.0, 1),
(40012, 'Savings', 2000000.0, 2),
(40013, 'Chequing', 12000.0, 1);

INSERT INTO borrowed_by 
VALUES
(10000, 1005),
(10001, 1002),
(10002, 1005),
(10003, 1060),
(10004, 1990);

INSERT INTO owned_by
VALUES
(40000, 1000),
(40001, 1001),
(40002, 1002),
(40003, 1005),
(40004, 1005),
(40005, 1006),
(40006, 1007),
(40007, 1010),
(40008, 1060),
(40009, 1200),
(40010, 1990),
(40011, 1000),
(40012, 1007),
(40013, 1005);

INSERT INTO works_with
VALUES
(100, 1000, 500.0),
(100, 1001, 1000.0),
(100, 1002, 50.0),
(101, 1005, 2000.0),
(102, 1006, 400.0),
(102, 1007, 200.0),
(105, 1010, 5000.0),
(107, 1060, 3000.0),
(107, 1200, 100.0),
(100, 1990, 500.0),
(105, 1005, 30.0),
(109, 1001, 400.0);

-- Now that we have populated some data, we can now write some queries. 

-- Write a query to display the customer ID, first name, last name, and address of customers who live on First Road.

SELECT 
	customer.customer_id,
	customer.first_name,
	customer.last_name,
	customer.customer_address
FROM
	customer
WHERE 
	customer_address 
LIKE 
	'%First_Road';

-- Display the name, sales, and the branch name of the employee with the most sales.

SELECT 
	name,
	total_sales,
	Branch
FROM (
		SELECT 
			SUM(sales) AS total_sales,
			works_with.employee_id,
			employee.employee_name AS name,
			branch.branch_name AS Branch
		FROM 
			works_with
		JOIN
			employee
		ON
			works_with.employee_id = employee.employee_id
		JOIN
			branch
		ON
			employee.branch_id = branch.branch_id
		GROUP BY 
			employee_id
) A
WHERE 
	total_sales = (
		SELECT 
			MAX(total_sales)
        FROM ( SELECT 
					SUM(sales) AS total_sales,
					works_with.employee_id,
					employee.employee_name AS name,
					branch.branch_name AS Branch
				FROM 
					works_with
				JOIN
					employee
				ON
					works_with.employee_id = employee.employee_id
				JOIN
					branch
				ON
					employee.branch_id = branch.branch_id
				GROUP BY 
					employee_id
			) A
				);
        
 
 -- Display the name, and total balance of the customer with the most balance in their account.
 
 SELECT
	 first_name,
	 last_name,
	 total_balance
 FROM
	(SELECT 
		SUM(account.balance) AS total_balance,
		account.account_id,
		account.account_type,
		owned_by.customer_id,
		customer.first_name,
		customer.last_name
	 FROM
		account
	 JOIN
		owned_by
	 ON
		account.account_id = owned_by.account_id
	 JOIN
		customer
	 ON
		owned_by.customer_id = customer.customer_id
	 GROUP BY
		customer_id 
	) A
ORDER BY
	total_balance DESC
LIMIT
	1
;
 
-- Display the branch ID, and branch name of the branch that offers the most loan amount.

SELECT
	branch_id,
	branch_name
FROM
	(SELECT
		SUM(loan.loan_amount) AS total_loan,
		branch.branch_id,
		branch.branch_name
	FROM
		loan
	JOIN
		branch
	ON
		loan.branch_id = branch.branch_id
	GROUP BY
		loan.branch_id
        ) A
ORDER BY 
	total_loan DESC
LIMIT
	1
;    

    

    

 
 
 



















