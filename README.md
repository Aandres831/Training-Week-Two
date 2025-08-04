
## 🛠️ Tecnologías utilizadas

- **MySQL**: Lenguaje de base de datos utilizado.
- **Workbench / CLI / phpMyAdmin**: Herramientas recomendadas para ejecución.
- **Lucidchart / dbdiagram.io** (opcional): Para visualizar el DER si lo deseas crear.

---

## ⚙️ Contenido del Script SQL

### 1. 🎓 Creación de la base de datos y tablas
Incluye las tablas:
- `estudiantes`
- `docentes`
- `cursos`
- `inscripciones`

Con sus respectivas claves primarias y foráneas.

### 2. 📥 Inserción de datos de prueba
Se insertan registros realistas de:
- 5 estudiantes
- 3 docentes
- 4 cursos
- 8 inscripciones

### 3. 📊 Consultas SQL

- Listar estudiantes, cursos e inscripciones (JOIN)
- Cursos dictados por docentes con >5 años de experiencia
- Promedio de calificaciones por curso
- Estudiantes inscritos en más de un curso
- Cursos con más de 2 estudiantes inscritos
- Estudiantes cuyo promedio supera al general
- Carreras con cursos de semestre 2 o más
- Indicadores (TOTAL, MAX, MIN, AVG, SUM) del sistema

### 4. 🧩 Vistas y control de acceso

- Creación de la vista `vista_historial_academico`
- Permisos de solo lectura para el rol `revisor_academico`

### 5. 🔄 Transacciones

Se simula una operación de actualización con:
- `START TRANSACTION`
- `SAVEPOINT`
- `ROLLBACK`
- `COMMIT`

---

## ✅ Requisitos para ejecutar

1. Tener MySQL instalado.
2. Usar un cliente como Workbench o CLI.
3. Ejecutar paso a paso el contenido del archivo `Query_AndresSeverinoIsaza.sql`.

---

## 🧪 Ejemplo de Consulta Clave

```sql
-- Obtener el promedio de calificaciones por curso
SELECT 
    c.nombre AS curso,
    AVG(i.calificacion_final) AS promedio_calificacion
FROM 
    inscripciones i
JOIN cursos c ON i.id_curso = c.id_curso
GROUP BY 
    c.nombre;
