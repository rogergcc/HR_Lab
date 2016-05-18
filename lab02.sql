--LAB02
--2. Crear la tabla Mis_Empleados utilizando la siguiente estructura.
CREATE TABLE Mis_Empleados
  (ID  INT CONSTRAINT Mis_Empleados_id_nn NOT NULL,
   APELLIDOS VARCHAR(25),
   NOMBRES VARCHAR(25),
   CODIGO  VARCHAR(8),
   SALARIO  DECIMAL(9,2));
GO
--3. Generar una sentencia de inserción de datos que permita añadir los siguientes registros:
INSERT INTO Mis_Empleados
  VALUES (1, 'Vargas Canseco', 'Raúl', 'Rvargas', 895)
  GO
INSERT INTO Mis_Empleados
  VALUES (2, 'Castro Feria', 'María', 'mcastro', 860)
  GO
SELECT *FROM Mis_Empleados
GO
--4. Generar un script que permita que mediante utilización de variables de sustitución, la inserción de
--información en la tabla Mis_Empleados.
CREATE PROCEDURE insertarDatos 
(@ID  INT ,
   @APELLIDOS VARCHAR(25),
   @NOMBRES VARCHAR(25),
   @CODIGO  VARCHAR(8),
   @SALARIO  DECIMAL(9,2))
   as
   begin
		INSERT INTO Mis_Empleados (ID, APELLIDOS, NOMBRES,                 
                         CODIGO, SALARIO)
		VALUES (@ID, @APELLIDOS, @NOMBRES, @CODIGO, @SALARIO)
   end
   go
   --5. Utilizando el script anterior adicionar los siguientes registros.
	exec insertarDatos 3,'Gómez Albán','Juan Pablo','Jgomez',1100;
	go
	exec insertarDatos 4,'Quiroz Ardiles','Judith','Jquiroz',750;
	go
	exec insertarDatos 5,'Soria Peralta','Pedro','Psoria',1550;
	go
	--6. Revisar los cambios hechos a la tabla.
	select *from Mis_Empleados
--7. Cambiar el nombre del empleado n° 3 a Benjamín.
UPDATE  Mis_Empleados
SET     NOMBRES = 'Benjamín'
WHERE   ID = 3;
GO

select *from Mis_Empleados
GO
--8. Elevar el salario a $ 1,000 a todos los empleados que tengan un salario menor a esa cantidad
UPDATE  Mis_Empleados
SET     SALARIO = SALARIO+1000 
WHERE   SALARIO < 1000;	
GO
select *from Mis_Empleados	
GO
--9. Eliminar el registro del empleado María Castro
DELETE
FROM  Mis_Empleados 
WHERE APELLIDOS = 'Castro Feria'; 
--10. Revisar los cambios hechos a la tabla.
select *from Mis_Empleados
--11. Confirmar los cambios a la tabla.

--12. Adicionar el siguiente registro a la tabla
BEGIN TRAN
exec insertarDatos 6, 'Hurtado Gamboa', 'Ernesto', 'ehurtado', 1400;
--13. Revisar la adición realizada
select *from Mis_Empleados
--14. Crear un punto de restauración intermedio para esta transacción
BEGIN TRAN
SAVE TRAN ejer14;
--15. Borrar los registros de la tabla MIS_EMPLEADOS.
delete from Mis_Empleados
--16. Revisar los cambios realizados.
select *from Mis_Empleados
--17. Descartar los cambios hechos a la tabla sin descartar la última adición hecha.
ROLLBACK TRAN ejer14
--18. Revisar nuevamente los registros de la tabla MIS_EMPLEADOS.
select *from Mis_Empleados
--19. Confirmar todos los cambios hechos a la tabla MIS_EMPLEADOS.
commit;
/*20. Modificar el script del punto 4.4. a fin de que se genere automáticamente el CODIGO del empleado que
lo conforman la primera letra de su nombre y la primera palabra de su apellido.*/
go
alter PROCEDURE insertarDatos 
(@ID  INT ,
   @APELLIDOS VARCHAR(25),
   @NOMBRES VARCHAR(25),
   
   @SALARIO  DECIMAL(9,2))
   as
   begin
   declare @CODIGO  VARCHAR(15)
   set @CODIGO=concat(LEFT(@NOMBRES, 1 ),'', Substring(@APELLIDOS,1,CHARINDEX(' ', @APELLIDOS)-1));
		INSERT INTO Mis_Empleados (ID, APELLIDOS, NOMBRES,                 
                         CODIGO, SALARIO)
		VALUES (@ID, @APELLIDOS, @NOMBRES,@CODIGO, @SALARIO)
   end
   go
 
/*21. Adicionar el siguiente registro a la tabla a fin de corroborar el funcionamiento del script anterior
ID APELLIDOS NOMBRES CODIGO SALARIO
7 Valdivia Pérez Graciela Gvaldivia 1800*/
exec insertarDatos 7, 'Valdivia Pérez', 'Graciela', 1800;
 go
/*22. Revisar los cambios realizados. Y finalmente confirmar todos los cambios hechos a la tabla
MIS_EMPLEADOS.*/
select *from Mis_Empleados

commit;

--4.2. Actividad N° 02: Manipulando Tablas
--1. Crear la tabla Departamentos utilizando la siguiente estructura:
CREATE TABLE Departamentos
 (ID   int CONSTRAINT department_id_pk PRIMARY KEY,
  NOMBRE VARCHAR (25));
--2. Poblar la tabla Departamentos con los datos de la tabla Departments.
INSERT INTO Departamentos
  SELECT  department_id, department_name
  FROM    departments;
  go
  select *from Departamentos
--3. Crear la tabla Empleados utilizando la siguiente estructura.
go
CREATE TABLE  Empleados
  (ID           int,
   APELLIDOS     VARCHAR(25),
   NOMBRES    VARCHAR(25),
   DEPT       int
     CONSTRAINT Empleados_departamento_id_FK REFERENCES Departamentos (ID)
   );
   go
--4. Crear la tabla Empleados2 basada en la estructura de la tabla Employees. Incluir solo las columnas
--EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY y DEPARMENT_ID respectivamente.
   SELECT employee_id id, first_name, last_name, salary,   
          department_id dept_id INTO Empleados2 FROM employees
go
select *from Empleados2
go
--5. Modificar el estado de la tabla Empleados2 a SOLO LECTURA.
ALTER TABLE Empleados2 WITH NOCHECK ADD CONSTRAINT chk_read_only CHECK( 1 = 0 )

--6. Tratar de adicionar el siguiente registro a la tabla Empleados2
--ID FIRST_NAME LAST_NAME SALARY DEPARTMENT_ID
INSERT INTO Empleados2
  VALUES (35, 'Alberto', 'Fernandez', 4500, 10);
--7. Revertir el estado de la tabla LECTURA / ESCRITURA. Tratar de insertar nuevamente la información
--del punto 4.6. 
  ALTER TABLE Empleados2 drop CONSTRAINT chk_read_only

  INSERT INTO Empleados2
  VALUES (35, 'Alberto', 'Fernandez', 4500, 10);

--8. Eliminar la tabla Empleados2
drop table Empleados2;

--------------------------------------------------------
--4.3. Actividad N° 03: Otros objetos de base de datos


/*1. El Departamento de Recursos Humanos requiere ocultar ciertos datos de la tabla EMPLOYEES, Ellos
necesitan una vista llamada VW_Empleados, que contenga los campos ID del Empleado, Nombres e
ID del Departamento.*/
go
CREATE VIEW employees_vu AS
    SELECT employee_id, last_name employee, department_id
    FROM employees;
go
/*2. Utilizando la vista anterior crear un reporte que muestre los nombres y departamentos a los cuales
pertenecen los empleados.*/
SELECT   *
FROM     employees_vu;
go
/*3. El departamento 50 requiere acceso a los datos de los empleados. Generar una vista llamada
VW_Dept50, que contenga las columnas ID del Empleado, Apellidos e ID del Departamento de los
empleados del departamento 50. Etiquetar las columnas como EmpNo, Empleado y DeptNo. Por
razones de seguridad no se debe permitir a los empleados ser reasignados a otros departamentos*/
go
CREATE VIEW [Current Product List] AS
SELECT ProductID,ProductName
FROM Products
WHERE Discontinued=No
go
CREATE VIEW [vw_Dept50] AS
	--WITH CHECK OPTION CONSTRAINT sales_staff_cnst
   SELECT   employee_id empno, last_name employee, department_id deptno
   FROM     employees
   WHERE    department_id = 50
   --WITH CHECK OPTION CONSTRAINT emp_dept_50; 
   WITH CHECK OPTION
go
SELECT   *
FROM     [vw_Dept50];
--4. Probar la vista, tratando de reasignar al empleado Matos al departamento 80.
UPDATE   [vw_Dept50]
SET      deptno = 80
WHERE    employee = 'Matos';
/*Error en la inserción o actualización debido a 
que la vista de destino especifica WITH CHECK OPTION o alcanza una vista con esta opción, y una o más filas resultantes de la operación no 
se califican con la restricción CHECK OPTION.*/
go
/*5. Se requiere crear una secuencia que será utilizada en la Llave Primaria de la tabla Departamentos (tabla
creada en la práctica anterior). La secuencia deberá iniciar con el valor 200 y terminar en el valor 1000,
asimismo deberá incrementarse en 10 cada vez que se requiera. Nombrar la secuencia
SEQ_Departamentos_ID*/
CREATE SEQUENCE dept_id_seq
  START WITH 200
  INCREMENT BY 10
  MAXVALUE 1000
go
/*6. Para probar la secuencia, adicionar dos registros a la tabla Departamentos, Educación y Administración.
Verificar la adición.*/
go
SELECT NEXT VALUE FOR dept_id_seq;
go
select *from Departamentos
go
INSERT INTO Departamentos
(ID, NOMBRE)
VALUES
(NEXT VALUE FOR dept_id_seq, 'Education');
go
INSERT INTO Departamentos
(ID, NOMBRE)
VALUES
(NEXT VALUE FOR dept_id_seq, 'Administration');
/*7. Crear un índice no único en la 
columna NOMBRE de la tabla Departamentos.*/
go
CREATE INDEX departamento_nombre_indice ON Departamentos (NOMBRE);
go
/*8. Crear un sinónimo para la 
tabla EMPLOYEES con el nombre EMP*/
CREATE SYNONYM emp FOR EMPLOYEES;