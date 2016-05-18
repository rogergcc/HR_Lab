
--4.1. Actividad N° 01 – Revisión de Sintaxis

--De los siguientes comandos ¿Cuál es el resultado? ¿En caso de 
--ser error cual sería la sentencia correcta?
SELECT last_name, job_id, salary AS Sal 
FROM   employees; 

go

SELECT *FROM job_grades;

SELECT    employee_id, last_name
sal x 12  ANNUAL SALARY
FROM      employees;


/*
 La tabla empleados no la columna llamada sal. La columna es SALARY
 La multiplicacion es con * , no x,
 EL alias ANNUAL SALARY no debe contener espacios.
 El alias ANNUL_SALARY debe estar encerrado en  ' '.
 la coma despues de LAST_NAME
*/

--actividad 1

--4.2. Actividad N° 02 – Reconociendo la estructura
--4.2-1
exec sp_columns departments
SELECT *FROM departments; 

--4.2-2
SELECT employee_id, last_name, job_id, hire_date StartDate
FROM   employees; 
--4.2-3
SELECT DISTINCT job_id
FROM   employees; 
-------------------------------------------
-------------------------------------------
--4.3. Actividad N° 03 – Consultas Básicas

--4.3-1
SELECT employee_id "Emp N°", last_name "Empleado",
       job_id "Puesto", hire_date "Fecha Contratacion" 
FROM   employees;

--4.3-2

SELECT CONCAT(last_name, ',', job_id) AS 'Empleado y Puesto' FROM employees


--4.3-3
SELECT CONCAT(employee_id, ',', first_name, ',', last_name
				, ',', email, ',', phone_number, ',', job_id
				, ',', manager_id, ',', hire_date, ',', salary
				, ',', commission_pct, ',', department_id) AS LosEmpleados FROM employees

SELECT employee_id, first_name, last_name, email,
COALESCE(employee_id, first_name, last_name, email) AS FirstNotNull
FROM employees;

--4.4. Actividad N° 04 – Restricción y Ordenamiento

--4.4-1
SELECT  last_name, salary
FROM    employees 
WHERE   salary > 12000;  
--4.4-2
SELECT  last_name, department_id
FROM    employees 
WHERE   employee_id = 176;
--4.4-3
SELECT  last_name, salary
FROM    employees 
WHERE   salary NOT BETWEEN 5000 AND 12000;
--4.4-4
SELECT   last_name, job_id, hire_date
FROM     employees
WHERE    last_name IN ('Matos', 'Taylor')
ORDER BY hire_date; 
--4.4-5
SELECT   last_name, department_id
FROM     employees
WHERE    department_id IN (20, 50)
ORDER BY last_name ASC;

--4.4-6
SELECT   last_name "Employee", salary "Monthly Salary"
FROM     employees
WHERE    salary  BETWEEN 5000 AND 12000 
AND      department_id IN (20, 50);
--4.4-7
SELECT   last_name, hire_date
FROM     employees
WHERE    hire_date LIKE '%94%';

--4.4-8
SELECT   last_name, job_id
FROM     employees 
WHERE    manager_id IS NULL;
--4.4-9
SELECT   last_name, salary, commission_pct
FROM     employees
WHERE    commission_pct IS NOT NULL
ORDER BY salary DESC, commission_pct DESC;
--4.4-10

/*Create Procedure consultarMayorA 
( @sal_amt int )
as
begin
	SELECT  last_name, salary
	FROM    employees 
	WHERE   salary > @sal_amt;
end*/

execute consultarMayorA 12000
go
--4.4-11
/*create procedure consultaAdmin
(@mgr_num int,
 @order_col varchar(15)
 )
 as
 begin
 declare @SortDirection varchar (14) ='A';
SELECT employee_id, last_name, salary, department_id
FROM employees
WHERE manager_id = @mgr_num
ORDER BY 	
        CASE 
			WHEN @order_col = 'last_name' THEN last_name
			WHEN @order_col = 'salary' THEN CONVERT(varchar, salary)
			WHEN @order_col = 'employee_id' THEN CONVERT(varchar, employee_id) 
		END ASC
end*/
exec consultaAdmin 103, 'last_name'
--4.4-12
SELECT   last_name
FROM     employees 
WHERE    last_name LIKE '__a%';
--4.4-13
SELECT   last_name
FROM     employees
WHERE    last_name LIKE '%a%'
AND      last_name LIKE '%e%';

--4.4-14
SELECT   last_name, job_id, salary
FROM     employees
WHERE    job_id IN ('SA_REP', 'ST_CLERK') 
AND      salary NOT IN (2500, 3500, 7000);

--4.4-15
SELECT   last_name "Employee", salary "Monthly Salary", 
         commission_pct
FROM     employees
WHERE    commission_pct = .20; 
-------------------------------------
--4.5. Actividad N° 05 – Funciones

--4.5-1
SELECT  GETDATE() 'Fecha y hora Actual'

--4.5-2
SELECT  employee_id, last_name, salary,
        ROUND(salary * 1.155, 0) "New Salary"
FROM    employees;

--4.5-3
SELECT  employee_id, last_name, salary, 
        ROUND(salary * 1.155, 0) "New Salary",
        ROUND(salary * 1.155, 0) - salary "Increase" 
FROM    employees;

--UPPER(LEFT(@string,1)) + LOWER(RIGHT(@string, LEN(@string) -1)),
--4.5-4
SELECT  UPPER(LEFT(last_name,1)) + LOWER(RIGHT(last_name, LEN(last_name) -1)) last_name,
        LEN(last_name) "Length"
FROM    employees 
WHERE   last_name LIKE 'J%'
OR      last_name LIKE 'M%'
OR      last_name LIKE 'A%'
ORDER BY last_name ; 

--4.5-5
exec letraApellido 'j'

--4.5-6
SELECT 
    DATEDIFF(MONTH, hire_date, GETDATE()) +
    CASE 
        WHEN DAY(hire_date) < DAY(GETDATE())
        THEN 1 
        ELSE 0 
    END
	as months_worked
	from employees
ORDER BY months_worked; 

/*SELECT rpad(last_name, 8)||' '|| 
       rpad(' ', salary/1000+1, '*')
               EMPLOYEES_AND_THEIR_SALARIES
FROM  employees
ORDER BY salary DESC; 
*/

--4.5-7
select last_name,
right(replicate('$',15)+cast(CAST(salary as int) as varchar(15)),15) aS salario
FROM   employees;

--4.5-8
SELECT CONCAT(left(last_name,8), 
' ', 
left(replicate('*',(CAST(salary as int)/1000)+1),(CAST(salary as int)/1000)+1)) 
AS 'Empleados y sus Salarios' 
FROM employees
ORDER BY salary DESC;

--4.5-9
declare @fechaActual date;
set @fechaActual = cast(getdate() As Date);
SELECT last_name, DATEDIFF(WEEK, hire_date, @fechaActual) AS tenencia
FROM employees
WHERE department_id = 90
ORDER BY tenencia DESC

--4.6. Actividad N° 06 – Funciones de Conversión
--4.6-1

select CONCAT(last_name , ' gana $ ' , salary, ' pero quisiera $ ', salary*3 ) as 'Sueldos Soñados'
from employees
--4.6-2
SELECT last_name, hire_date,
	DATEADD([day], ((DATEDIFF([day], '19000101', 
	cast(dateadd(MONTH, 6, hire_date) AS Date)) 
	/ 7) * 7) + 7, '19000101')
from employees
--4.6-3
SELECT last_name, hire_date,
       CONVERT(VARCHAR, DATEPART(DAY, hire_date)) as Dia
FROM     employees 
ORDER BY CONVERT(VARCHAR, DATEPART(DAY, hire_date)); 

--4.6-4
SELECT last_name,
       ISNULL(Convert(varchar ,commission_pct) , 'Sin Comisión') Comisión
FROM   employees;

--4.6-5
SELECT job_id as Puesto, CASE job_id
               WHEN 'ST_CLERK' THEN 'E'
               WHEN 'SA_REP'   THEN 'D'
               WHEN 'IT_PROG'  THEN 'C'
               WHEN 'ST_MAN'   THEN 'B'
               WHEN 'AD_PRES'  THEN 'A'
               ELSE '0'  END as Grado
FROM employees; 


--4.7. Actividad N° 07 – Funciones de Agrupación

--4.7-1 Máximo, Mínimo, Suma y Promedio
SELECT 
	   CONVERT(int,ROUND(MAX(salary),0)) "Máximo",
	   CONVERT(int,ROUND(MIN(salary),0)) "Mínimo",
	   CONVERT(int,ROUND(SUM(salary),0)) "Suma",
	   CONVERT(int,ROUND(AVG(salary),0)) "Promedio"
FROM   employees;
--4.7-2
SELECT 
	   CONVERT(int,ROUND(MAX(salary),0)) "Máximo",
	   CONVERT(int,ROUND(MIN(salary),0)) "Mínimo",
	   CONVERT(int,ROUND(SUM(salary),0)) "Suma",
	   CONVERT(int,ROUND(AVG(salary),0)) "Promedio"
FROM   employees   
GROUP BY job_id;
--4.7-3
SELECT job_id, COUNT(*)
FROM   employees 
GROUP BY job_id;
-----
--4.7-4
SELECT COUNT(DISTINCT manager_id) "N° de Administradores"
FROM   employees;
--4.7-5
SELECT   MAX(salary) - MIN(salary) Diferencia
FROM     employees; 
--4.7-6
SELECT   manager_id 'N° de Administradores' , MIN(salary) 'Salario'
FROM     employees
WHERE    manager_id IS NOT NULL
GROUP BY manager_id
HAVING   MIN(salary) > 6000 
ORDER BY MIN(salary) DESC;
--4.7-7
/*CONVERT(VARCHAR, DATEPART(YEAR, GETDATE()))
TO_CHAR(SYSDATE, 'YYYY')*/
SELECT  COUNT(*) total,
        SUM(
		case CONVERT(VARCHAR, YEAR(hire_date)) when 1995 then 1 else 0 end ) "1995",
		SUM(
		case CONVERT(VARCHAR, YEAR(hire_date)) when 1996 then 1 else 0 end) "1996",
		SUM(
		case CONVERT(VARCHAR, YEAR(hire_date)) when 1997 then 1 else 0 end ) "1997",
		SUM(
		case CONVERT(VARCHAR, YEAR(hire_date)) when 1998 then 1 else 0 end ) "1998"
FROM    employees;
--4.7-8
SELECT   job_id Puesto,
         SUM(case department_id when 20 then  salary end ) "Dept 20",
		 SUM(case department_id when 50 then  salary end ) "Dept 50",
		 SUM(case department_id when 80 then  salary end ) "Dept 80",
		 SUM(case department_id when 90 then  salary end ) "Dept 90",
         SUM(salary) "Total"
FROM     employees
GROUP BY job_id;

--4.8. Actividad N° 08 – Enlaces
--4.8-1
SELECT l.location_id, l.street_address, l.city, l.state_province, c.country_name
FROM   locations l
join countries c on l.country_id = c.country_id
--4.8-2
SELECT e.last_name, e.department_id, d.department_name
FROM   employees e
join departments d on e.department_id = d.department_id

--4.8-3
SELECT e.last_name, e.job_id, e.department_id, d.department_name
FROM   employees e, departments d , locations l
WHERE  e.department_id = d.department_id
AND    d.location_id = l.location_id
AND    LOWER(l.city) = 'toronto';

--4.8-4
SELECT w.last_name "Employee", w.employee_id "EMP#", 
       m.last_name "Manager", m.employee_id  "Mgr#"
FROM   employees w, employees m
WHERE  w.manager_id = m.employee_id; 

--4.8-5
SELECT w.last_name "Employee", w.employee_id "EMP#", 
       m.last_name "Manager", m.employee_id  "Mgr#"
FROM   employees w 
LEFT   OUTER JOIN employees m
ON     (w.manager_id = m.employee_id); 

--4.8-6
SELECT e.department_id department, e.last_name employee,
       c.last_name colleague
FROM   employees e, employees c
WHERE  e.department_id = c.department_id
AND    e.employee_id <> c.employee_id 
ORDER BY e.department_id, e.last_name, c.last_name; 

--4.8-7
SELECT e.last_name, e.hire_date
FROM   employees e , employees davies
WHERE  davies.last_name = 'Davies'
AND    davies.hire_date < e.hire_date;
--4.8-8
SELECT w.last_name, w.hire_date, m.last_name, m.hire_date
FROM   employees w JOIN employees m
ON    (w.manager_id = m.employee_id) 
WHERE    w.hire_date <  m.hire_date; 
--4.9. Actividad N° 09 – Subconsultas

/*create procedure subConsultaAp
(@apellido varchar(15))
as
begin
SELECT last_name, hire_date
FROM   employees
WHERE  department_id = (SELECT department_id
                        FROM   employees
                        WHERE  last_name = @apellido)
AND    last_name <> @apellido; 
end*/
--4.9-1
exec subConsultaAp 'Zlotkey'
--4.9-2
SELECT employee_id, last_name, salary
FROM   employees
WHERE  salary > (SELECT AVG(salary)
                 FROM   employees)
ORDER BY salary;
--4.9-3
SELECT employee_id, last_name
FROM   employees
WHERE  department_id IN (SELECT department_id
                         FROM   employees
                         WHERE  last_name like '%u%');
--4.9--4
SELECT last_name, department_id, job_id
FROM   employees
WHERE  department_id IN (SELECT department_id
                         FROM   departments
                         WHERE  location_id = 1700);
--4.9-5

exec ingreseLocalizacion 1700
--4.9-6
SELECT last_name, salary
FROM   employees
WHERE  manager_id in (SELECT employee_id
                     FROM   employees
					 
                     WHERE  last_name = 'King'
					 );
--4.9-7
SELECT department_id, last_name, job_id
FROM   employees
WHERE  department_id IN (SELECT department_id
                         FROM   departments
                         WHERE  department_name = 'Executive');


SELECT employee_id, last_name, salary
FROM   employees
WHERE  department_id IN (SELECT department_id
                         FROM   employees
                         WHERE  last_name like '%u%')
AND    salary > (SELECT AVG(salary) 
                 FROM   employees);

--4.10.  Actividad N° 10 – Conjuntos
use hr;
--4.10-1
SELECT department_id,department_name
FROM   departments
EXCEPT
SELECT d.department_id,d.department_name
FROM   employees e
join departments d on e.department_id=d.department_id 
WHERE  job_id = 'ST_CLERK';

-------------------------

--4.10-2
USE hr
SELECT country_id, country_name
FROM   countries 
MINUS 
SELECT c.country_id, country_name
FROM   countries c
 JOIN locations l on c.country_id=l.country_id
 JOIN departments d on l.location_id=d.location_id


 --4.10-3
SELECT  job_id, department_id, 'x' orden
FROM    employees
WHERE department_id = 10
UNION
SELECT  job_id, department_id, 'y' orden
FROM    employees
WHERE department_id = 50
UNION
SELECT  job_id, department_id, 'z' orden
FROM    employees
WHERE department_id = 20 
ORDER BY  orden;

--4.10-4
SELECT    employee_id,job_id
FROM      employees
INTERSECT  
SELECT   employee_id,job_id
FROM     job_history;

--4.10-5
SELECT last_name,department_id,Convert(varchar ,null)
FROM   employees
UNION 
SELECT Convert(varchar ,null) ,department_id,department_name
FROM  departments;