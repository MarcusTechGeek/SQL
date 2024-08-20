CREATE TABLE Departments (
    depart_id SERIAL PRIMARY KEY,
    depart_name VARCHAR(50),
    depart_city VARCHAR(50)
);

CREATE TABLE Roles (
    role_id SERIAL PRIMARY KEY,
    role VARCHAR(50)
);

CREATE TABLE Salaries (
    salary_id SERIAL PRIMARY KEY,
    salary_pa DECIMAL(10, 2)
);

CREATE TABLE OvertimeHours (
    overtime_id SERIAL PRIMARY KEY,
    overtime_hours INT
);

CREATE TABLE Employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    surname VARCHAR(50),
    gender VARCHAR(10),
    address VARCHAR(100),
    email VARCHAR(50),
    depart_id INT REFERENCES Departments(depart_id),
    role_id INT REFERENCES Roles(role_id),
    salary_id INT REFERENCES Salaries(salary_id),
    overtime_id INT REFERENCES OvertimeHours(overtime_id)
);

-- Insert into Departments
INSERT INTO Departments (depart_name, depart_city) VALUES ('HR', 'New York');
INSERT INTO Departments (depart_name, depart_city) VALUES ('Engineering', 'San Francisco');

-- Insert into Roles
INSERT INTO Roles (role) VALUES ('Manager');
INSERT INTO Roles (role) VALUES ('Developer');

-- Insert into Salaries
INSERT INTO Salaries (salary_pa) VALUES (80000);
INSERT INTO Salaries (salary_pa) VALUES (120000);

-- Insert into OvertimeHours
INSERT INTO OvertimeHours (overtime_hours) VALUES (10);
INSERT INTO OvertimeHours (overtime_hours) VALUES (5);

-- Insert into Employees
INSERT INTO Employees (first_name, surname, gender, address, email, depart_id, role_id, salary_id, overtime_id)
VALUES ('John', 'Doe', 'Male', '123 Main St', 'johndoe@example.com', 1, 1, 1, 1);

INSERT INTO Employees (first_name, surname, gender, address, email, depart_id, role_id, salary_id, overtime_id)
VALUES ('Jane', 'Smith', 'Female', '456 Maple Ave', 'janesmith@example.com', 2, 2, 2, 2);


SELECT Departments.depart_name, Roles.role, Salaries.salary_pa, OvertimeHours.overtime_hours
FROM Employees
LEFT JOIN Departments ON Employees.depart_id = Departments.depart_id
LEFT JOIN Roles ON Employees.role_id = Roles.role_id
LEFT JOIN Salaries ON Employees.salary_id = Salaries.salary_id
LEFT JOIN OvertimeHours ON Employees.overtime_id = OvertimeHours.overtime_id;
