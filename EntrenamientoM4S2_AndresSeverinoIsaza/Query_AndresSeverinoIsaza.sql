CREATE DATABASE gestion_academica_universidad;

USE gestion_academica_universidad;

-- Tabla: estudiantes
CREATE TABLE estudiantes (
    id_estudiante INT AUTO_INCREMENT PRIMARY KEY,
    nombre_completo VARCHAR(100) NOT NULL,
    correo_electronico VARCHAR(100),
    genero VARCHAR(20),
    identificacion VARCHAR(20) NOT NULL UNIQUE,
    carrera VARCHAR(100),
    fecha_nacimiento DATE,
    fecha_ingreso DATE 
);

-- Tabla: docentes
CREATE TABLE docentes (
    id_docente INT AUTO_INCREMENT PRIMARY KEY,
    nombre_completo VARCHAR(100) NOT NULL,
    correo_institucional VARCHAR(100),
    departamento_academico VARCHAR(100),
    anios_experiencia INT 
);

-- Tabla: cursos
CREATE TABLE cursos (
    id_curso INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    codigo VARCHAR(20) NOT NULL UNIQUE,
    creditos INT,
    semestre INT,
    id_docente INT,
    FOREIGN KEY (id_docente) REFERENCES docentes(id_docente)
);

-- Tabla: inscripciones
CREATE TABLE inscripciones (
    id_inscripcion INT AUTO_INCREMENT PRIMARY KEY,
    id_estudiante INT,
    id_curso INT,
    fecha_inscripcion DATE,
    calificacion_final DECIMAL(4,2),
    FOREIGN KEY (id_estudiante) REFERENCES estudiantes(id_estudiante),
    FOREIGN KEY (id_curso) REFERENCES cursos(id_curso)
);

INSERT INTO estudiantes (nombre_completo, correo_electronico, genero, identificacion, carrera, fecha_nacimiento, fecha_ingreso)
VALUES 
('Laura Gómez', 'laura.gomez@correo.com', 'Femenino', '123456789', 'Ingeniería de Sistemas', '2002-04-15', '2021-01-15'),
('Carlos Pérez', 'carlos.perez@correo.com', 'Masculino', '987654321', 'Administración', '2001-10-30', '2020-08-10'),
('Sofía Ramírez', 'sofia.ramirez@correo.com', 'Femenino', '1122334455', 'Psicología', '2003-01-20', '2022-01-20'),
('Andrés Torres', 'andres.torres@correo.com', 'Masculino', '2233445566', 'Contaduría', '2000-07-10', '2019-02-01'),
('Mariana Salazar', 'mariana.salazar@correo.com', 'Femenino', '3344556677', 'Derecho', '2002-11-25', '2021-08-01');

INSERT INTO docentes (nombre_completo, correo_institucional, departamento_academico, anios_experiencia)
VALUES
('Luis Fernández', 'luis.fernandez@univ.edu', 'Ciencias Económicas', 10),
('Marta Díaz', 'marta.diaz@univ.edu', 'Ingeniería', 5),
('Pedro Jiménez', 'pedro.jimenez@univ.edu', 'Ciencias Sociales', 8);

INSERT INTO cursos (nombre, codigo, creditos, semestre, id_docente)
VALUES
('Contabilidad Básica', 'CONT101', 3, 1, 1),
('Programación I', 'PROG101', 4, 2, 2),
('Psicología General', 'PSIC101', 3, 1, 3),
('Economía I', 'ECON101', 3, 1, 1);

INSERT INTO inscripciones (id_estudiante, id_curso, fecha_inscripcion, calificacion_final)
VALUES
(1, 2, '2025-02-10', 4.5), -- Laura en Programación
(2, 1, '2025-02-11', 3.8), -- Carlos en Contabilidad
(3, 3, '2025-02-12', 4.2), -- Sofía en Psicología
(4, 1, '2025-02-13', 3.5), -- Andrés en Contabilidad
(5, 4, '2025-02-14', 4.0), -- Mariana en Economía
(1, 1, '2025-02-15', 4.6), -- Laura en Contabilidad
(2, 4, '2025-02-16', 3.9), -- Carlos en Economía
(3, 2, '2025-02-17', 4.1); -- Sofía en Programación

-- Listar Obtener el listado de todos los estudiantes junto con sus inscripciones y cursos (JOIN)
SELECT 
    e.nombre_completo AS estudiante,
    c.nombre AS curso,
    i.fecha_inscripcion,
    i.calificacion_final
FROM 
    estudiantes e
JOIN inscripciones i ON e.id_estudiante = i.id_estudiante
JOIN cursos c ON i.id_curso = c.id_curso;

-- Listar los cursos dictados por docentes con más de 5 años de experiencia.

SELECT 
    c.nombre AS curso,
    d.nombre_completo AS docente,
    d.anios_experiencia
FROM 
    cursos c
JOIN docentes d ON c.id_docente = d.id_docente
WHERE 
    d.anios_experiencia > 5;

-- Obtener el promedio de calificaciones por curso (GROUP BY + AVG)

SELECT 
    c.nombre AS curso,
    AVG(i.calificacion_final) AS promedio_calificacion
FROM 
    inscripciones i
JOIN cursos c ON i.id_curso = c.id_curso
GROUP BY 
    c.nombre;

-- Mostrar los estudiantes que están inscritos en más de un curso (HAVING COUNT(*) > 1)

SELECT 
    e.nombre_completo,
    COUNT(i.id_curso) AS cantidad_cursos
FROM 
    estudiantes e
JOIN inscripciones i ON e.id_estudiante = i.id_estudiante
GROUP BY 
    e.nombre_completo
HAVING 
    COUNT(i.id_curso) > 1;
    
-- Agregar una nueva columna estado_academico a la tabla estudiantes (ALTER TABLE)

ALTER TABLE estudiantes
ADD COLUMN estado_academico VARCHAR(50);

-- Eliminar un docente y observar el efecto en la tabla cursos (uso de ON DELETE en FK)

DELETE FROM docentes
WHERE id_docente = 3;

-- Consultar los cursos en los que se han inscrito más de 2 estudiantes (GROUP BY + COUNT + HAVING)

SELECT 
    c.nombre AS curso,
    COUNT(i.id_estudiante) AS total_estudiantes
FROM 
    cursos c
JOIN inscripciones i ON c.id_curso = i.id_curso
GROUP BY 
    c.nombre
HAVING 
    COUNT(i.id_estudiante) > 2;
    


-- Cambios para que sea posible eliminar el docente y sea null
SELECT CONSTRAINT_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_NAME = 'cursos' AND COLUMN_NAME = 'id_docente'
  AND CONSTRAINT_SCHEMA = 'gestion_academica_universidad';
  
ALTER TABLE cursos
DROP FOREIGN KEY cursos_ibfk_1;

ALTER TABLE cursos
MODIFY COLUMN id_docente INT NULL;

ALTER TABLE cursos
ADD CONSTRAINT fk_cursos_docente
FOREIGN KEY (id_docente) REFERENCES docentes(id_docente)
ON DELETE SET NULL;

SELECT * FROM cursos;

-- Obtener los estudiantes cuya calificación promedio es superior al promedio general (AVG() + subconsulta).

SELECT 
    e.nombre_completo,
    ROUND(AVG(i.calificacion_final), 2) AS promedio_estudiante
FROM 
    estudiantes e
JOIN inscripciones i ON e.id_estudiante = i.id_estudiante
GROUP BY 
    e.id_estudiante, e.nombre_completo
HAVING 
    AVG(i.calificacion_final) > (
        SELECT AVG(calificacion_final) FROM inscripciones
    );


-- Mostrar los nombres de las carreras con estudiantes inscritos en cursos del semestre 2 o posterior (IN o EXISTS).

SELECT DISTINCT e.carrera
FROM estudiantes e
WHERE EXISTS (
    SELECT 1
    FROM inscripciones i
    JOIN cursos c ON i.id_curso = c.id_curso
    WHERE i.id_estudiante = e.id_estudiante
      AND c.semestre >= 2
);

-- Utiliza funciones como ROUND, SUM, MAX, MIN y COUNT para explorar distintos indicadores del sistema.

-- Total de estudiantes
SELECT COUNT(*) AS total_estudiantes FROM estudiantes;

-- Total de docentes
SELECT COUNT(*) AS total_docentes FROM docentes;

-- Total de cursos
SELECT COUNT(*) AS total_cursos FROM cursos;

-- Suma de créditos de todos los cursos
SELECT SUM(creditos) AS total_creditos FROM cursos;

-- Calificación más alta y más baja entre todos los estudiantes
SELECT 
    MAX(calificacion_final) AS calificacion_maxima,
    MIN(calificacion_final) AS calificacion_minima
FROM inscripciones;

-- Promedio general de calificaciones (redondeado a 2 decimales)
SELECT ROUND(AVG(calificacion_final), 2) AS promedio_general
FROM inscripciones;

-- Creandi View vista_historial_academico
CREATE VIEW vista_historial_academico AS
SELECT 
    e.nombre_completo AS estudiante,
    c.nombre AS curso,
    d.nombre_completo AS docente,
    c.semestre,
    i.calificacion_final
FROM 
    inscripciones i
JOIN estudiantes e ON i.id_estudiante = e.id_estudiante
JOIN cursos c ON i.id_curso = c.id_curso
LEFT JOIN docentes d ON c.id_docente = d.id_docente;

SELECT * FROM vista_historial_academico;

-- Asigna permisos de solo lectura a un rol llamado revisor_academico sobre la vista vista_historial_academico (GRANT SELECT)./li>

CREATE USER 'revisor_academico' IDENTIFIED BY 'revisor123';

GRANT SELECT ON vista_historial_academico TO 'revisor_academico';

REVOKE INSERT, UPDATE, DELETE ON inscripciones FROM 'revisor_academico';

-- transacción
START TRANSACTION;

-- actualizar calificación
UPDATE inscripciones 
SET calificacion_final = 4.9 
WHERE id_inscripcion = 1;

-- guardar
SAVEPOINT savepoint1;

-- imitar error
UPDATE inscripciones 
SET calificacion_final = 8.0 --
WHERE id_inscripcion = 2;

--  volvemos al savepoint anterior
ROLLBACK TO savepoint1;

-- Confirmar cambios
COMMIT;





SHOW TABLES;
