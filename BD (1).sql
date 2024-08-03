
create table curso (
    curso_id number not null,
    nombre varchar2(50),
    cantidadsesiones number (7),
    periodo_id number not null,
    universidad_id number not null,
    constraint pk_curso primary key (curso_id)
);
--fk periodo_id y universidad_id
----------------------------------------
-------------------------------------------
create table universidad (
    universidad_id number not null,
    nombre varchar2(100),
    constraint pk_universidad primary key (universidad_id)
);


create table calificacion (
    calificacion_id number not null,
    nota number(4,2),
    porcentaje number(4,2),
    observaciones varchar2(200),
    matricula_id number not null,
    calificacionrubro_id number not null,
    constraint pk_calificacion primary key (calificacion_id)
);
--fk matricula_id y calificacionrubro_id


create table rubro (
    calificacionrubro_id number not null,
    descripcion varchar2(100),
    porcentaje number(4,2),
    curso_id number not null,
    constraint pk_rubro primary key (calificacionrubro_id)
);
--fk curso_id


create table persona (
    persona_id number not null,
    nombre varchar2(50),
    apellido1 varchar2(50),
    apellido2 varchar2(50),
    telefono varchar2(20),
    correo varchar2(50),
    constraint pk_persona primary key (persona_id)
);


create table profesor (
    profesor_id number not null,
    usuario varchar2(50) not null,
    clave varchar2(50) not null,
    persona_id number not null,
    constraint pk_profesor primary key (profesor_id)
);
--fk persona_id

create table estudiante (
    estudiante_id number not null,
    persona_id number not null,
    cedula varchar2(20) not null,
    constraint pk_estidiante primary key (estudiante_id)
);
-- fk persona_id


create table matricula (
    matricula_id number not null,
    estudiante_id number not null,
    curso_id number not null,
    constraint pk_matricula primary key (matricula_id)
);

-- fk estudiante_id y curso_id


create table periodo (
    periodo_id number not null,
    cuatrimestre number (4),
    anio number (4),
    constraint pk_periodo primary key (periodo_id)
);


--CREACION DDE LLAVES FORANEAS




alter table rubro
add constraint fk_curso_rubro
foreign key (curso_id)
references curso(curso_id)

--Profesor-Persona
alter table profesor
add constraint fk_persona_profesor
foreign key (persona_id)
references persona(persona_id);

--Estudiante-Persona
alter table estudiante
add constraint fk_persona_estudiante
foreign key (persona_id)
references persona(persona_id);

--Matricula-Curso
alter table matricula
add constraint fk_curso_matricula
foreign key (curso_id)
references curso(curso_id);

--Estudiante-Matricula
alter table matricula
add constraint fk_estudiante_matricula
foreign key (estudiante_id)
references estudiante(estudiante_id);



--------------------------------------------------
--Secuencias para los IDs


CREATE SEQUENCE curso_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE universidad_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE calificacion_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE rubro_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE persona_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE profesor_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE estudiante_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE matricula_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE periodo_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;




--------------------------------------------------------------------------------

--------------------------------SP----------------------------------------------

--SP Para Matricula


--Crear
CREATE OR REPLACE PROCEDURE MatriculaCrear(
    p_estudiante_id IN matricula.estudiante_id%TYPE,
    p_curso_id IN matricula.curso_id%TYPE
) IS
BEGIN
    INSERT INTO matricula (
        matricula_id,
        estudiante_id,
        curso_id
    ) VALUES (
        matricula_seq.NEXTVAL, 
        p_estudiante_id,
        p_curso_id
    );

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END MatriculaCrear;
/


--Consultar
CREATE OR REPLACE PROCEDURE MatriculaConsultar(
    p_matricula_id IN matricula.matricula_id%TYPE,
    p_estudiante_id OUT matricula.estudiante_id%TYPE,
    p_curso_id OUT matricula.curso_id%TYPE
) IS
BEGIN
    SELECT estudiante_id, curso_id
    INTO p_estudiante_id, p_curso_id
    FROM matricula
    WHERE matricula_id = p_matricula_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_estudiante_id := NULL;
        p_curso_id := NULL;
    WHEN OTHERS THEN
        RAISE;
END MatriculaConsultar;
/


--Modificar
CREATE OR REPLACE PROCEDURE MatriculaMofidicar(
    p_matricula_id IN matricula.matricula_id%TYPE,
    p_estudiante_id IN matricula.estudiante_id%TYPE,
    p_curso_id IN matricula.curso_id%TYPE
) IS
BEGIN
    UPDATE matricula
    SET estudiante_id = p_estudiante_id,
        curso_id = p_curso_id
    WHERE matricula_id = p_matricula_id;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END MatriculaMofidicar;
/



--Eliminar
CREATE OR REPLACE PROCEDURE MatriculaEliminar(
    p_matricula_id IN matricula.matricula_id%TYPE
) IS
BEGIN
    DELETE FROM matricula
    WHERE matricula_id = p_matricula_id;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END MatriculaEliminar;
/



----------------------------------------------------------


--SP Para Periodo

--Crear

CREATE OR REPLACE PROCEDURE PeriodoCrear(
    p_cuatrimestre IN periodo.cuatrimestre%TYPE,
    p_anio IN periodo.anio%TYPE
) IS
BEGIN
    INSERT INTO periodo (
        periodo_id,
        cuatrimestre,
        anio
    ) VALUES (
        periodo_seq.NEXTVAL,
        p_cuatrimestre,
        p_anio
    );

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END PeriodoCrear;
/


----------------------------------------------------------
--Consultar

CREATE OR REPLACE PROCEDURE PeriodoConsultar(
    p_periodo_id IN periodo.periodo_id%TYPE,
    p_cuatrimestre OUT periodo.cuatrimestre%TYPE,
    p_anio OUT periodo.anio%TYPE
) IS
BEGIN
    SELECT cuatrimestre, anio
    INTO p_cuatrimestre, p_anio
    FROM periodo
    WHERE periodo_id = p_periodo_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_cuatrimestre := NULL;
        p_anio := NULL;
    WHEN OTHERS THEN
        RAISE;
END PeriodoConsultar;
/


----------------------------------------------------------
--Modificar


CREATE OR REPLACE PROCEDURE PeriodoModificar(
    p_periodo_id IN periodo.periodo_id%TYPE,
    p_cuatrimestre IN periodo.cuatrimestre%TYPE,
    p_anio IN periodo.anio%TYPE
) IS
BEGIN
    UPDATE periodo
    SET cuatrimestre = p_cuatrimestre,
        anio = p_anio
    WHERE periodo_id = p_periodo_id;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END PeriodoModificar;
/





----------------------------------------------------------
--Eliminar


CREATE OR REPLACE PROCEDURE PeriodoEliminar(
    p_periodo_id IN periodo.periodo_id%TYPE
) IS
BEGIN
    DELETE FROM periodo
    WHERE periodo_id = p_periodo_id;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END PeriodoEliminar;
/


----------------------------------------------------------

--SP para Persona

--Crear
CREATE OR REPLACE PROCEDURE PersonaCrear(
    p_nombre IN persona.nombre%TYPE,
    p_apellido1 IN persona.apellido1%TYPE,
    p_apellido2 IN persona.apellido2%TYPE,
    p_telefono IN persona.telefono%TYPE,
    p_correo IN persona.correo%TYPE
) IS
BEGIN
    INSERT INTO persona (
        persona_id,
        nombre,
        apellido1,
        apellido2,
        telefono,
        correo
    ) VALUES (
        persona_seq.NEXTVAL, 
        p_nombre,
        p_apellido1,
        p_apellido2,
        p_telefono,
        p_correo
    );

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END PersonaCrear;
/



----------------------------------------------------------
--Consultar
CREATE OR REPLACE PROCEDURE PersonaConsultar(
    p_persona_id IN persona.persona_id%TYPE,
    p_nombre OUT persona.nombre%TYPE,
    p_apellido1 OUT persona.apellido1%TYPE,
    p_apellido2 OUT persona.apellido2%TYPE,
    p_telefono OUT persona.telefono%TYPE,
    p_correo OUT persona.correo%TYPE
) IS
BEGIN
    SELECT nombre, apellido1, apellido2, telefono, correo
    INTO p_nombre, p_apellido1, p_apellido2, p_telefono, p_correo
    FROM persona
    WHERE persona_id = p_persona_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_nombre := NULL;
        p_apellido1 := NULL;
        p_apellido2 := NULL;
        p_telefono := NULL;
        p_correo := NULL;
    WHEN OTHERS THEN
        RAISE;
END PersonaConsultar;
/


----------------------------------------------------------
--Modificar
CREATE OR REPLACE PROCEDURE PersonaModificar(
    p_persona_id IN persona.persona_id%TYPE,
    p_nombre IN persona.nombre%TYPE,
    p_apellido1 IN persona.apellido1%TYPE,
    p_apellido2 IN persona.apellido2%TYPE,
    p_telefono IN persona.telefono%TYPE,
    p_correo IN persona.correo%TYPE
) IS
BEGIN
    UPDATE persona
    SET nombre = p_nombre,
        apellido1 = p_apellido1,
        apellido2 = p_apellido2,
        telefono = p_telefono,
        correo = p_correo
    WHERE persona_id = p_persona_id;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END PersonaModificar;
/



----------------------------------------------------------
--Eliminar
CREATE OR REPLACE PROCEDURE PersonaEliminar(
    p_persona_id IN persona.persona_id%TYPE
) IS
BEGIN
    DELETE FROM persona
    WHERE persona_id = p_persona_id;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END PersonaEliminar;
/



----------------------------------------------------------


--SP Para Profesor

--Crear
CREATE OR REPLACE PROCEDURE ProfesorCrear(
    p_usuario IN profesor.usuario%TYPE,
    p_clave IN profesor.clave%TYPE,
    p_persona_id IN profesor.persona_id%TYPE
) IS
BEGIN
    INSERT INTO profesor (
        profesor_id,
        usuario,
        clave,
        persona_id
    ) VALUES (
        profesor_seq.NEXTVAL,
        p_usuario,
        p_clave,
        p_persona_id
    );

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END ProfesorCrear;
/

----------------------------------------------------------
--Consultar
CREATE OR REPLACE PROCEDURE ProfesorConsultar(
    p_profesor_id IN profesor.profesor_id%TYPE,
    p_usuario OUT profesor.usuario%TYPE,
    p_clave OUT profesor.clave%TYPE,
    p_persona_id OUT profesor.persona_id%TYPE
) IS
BEGIN
    SELECT usuario, clave, persona_id
    INTO p_usuario, p_clave, p_persona_id
    FROM profesor
    WHERE profesor_id = p_profesor_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_usuario := NULL;
        p_clave := NULL;
        p_persona_id := NULL;
    WHEN OTHERS THEN
        RAISE;
END ProfesorConsultar;
/

----------------------------------------------------------
--Modificar
CREATE OR REPLACE PROCEDURE ProfesorModificar(
    p_profesor_id IN profesor.profesor_id%TYPE,
    p_usuario IN profesor.usuario%TYPE,
    p_clave IN profesor.clave%TYPE,
    p_persona_id IN profesor.persona_id%TYPE
) IS
BEGIN
    UPDATE profesor
    SET usuario = p_usuario,
        clave = p_clave,
        persona_id = p_persona_id
    WHERE profesor_id = p_profesor_id;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END ProfesorModificar;
/

----------------------------------------------------------
--Eliminar
CREATE OR REPLACE PROCEDURE ProfesorEliminar(
    p_profesor_id IN profesor.profesor_id%TYPE
) IS
BEGIN
    DELETE FROM profesor
    WHERE profesor_id = p_profesor_id;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END ProfesorEliminar;
/

----------------------------------------------------------











--------------------------------------------------------------------------------

--------------------------------SP----------------------------------------------
CREATE OR REPLACE PROCEDURE actualizarCalificacion(
  p_idCalificacion IN NUMBER, 
  p_nota IN NUMBER, 
  p_porcentaje IN NUMBER, 
  p_observaciones IN VARCHAR2
)
IS
BEGIN
  UPDATE calificacion 
  SET 
    nota = p_nota,
    porcentaje = p_porcentaje,
    observaciones = p_observaciones
  WHERE
    calificacion_id = p_idCalificacion;
END;
/

CREATE OR REPLACE PROCEDURE AsistenciaCargarClases(
    p_cursoid IN NUMBER,
    cur OUT SYS_REFCURSOR
) IS
BEGIN
    OPEN cur FOR
    SELECT
        'Clase ' || LPAD(ROW_NUMBER() OVER (ORDER BY fecha), 2, '0') || ' - ' || TO_CHAR(fecha, 'YYYY-MM-DD') AS Clase
    FROM (
        SELECT DISTINCT
            aa.fecha
        FROM matricula m
        JOIN curso c ON c.curso_id = m.curso_id
        JOIN asistencia aa ON aa.matricula_id = m.matricula_id
        WHERE c.curso_id = p_cursoid
        ORDER BY aa.fecha DESC
    );
END;
/

CREATE OR REPLACE PROCEDURE AsistenciaEliminarAlumno(
  p_MatriculaID IN NUMBER, 
  p_Fecha IN DATE
)
IS
BEGIN
  DELETE FROM asistencia
  WHERE matricula_id = p_MatriculaID
  AND fecha = p_Fecha;
END;
/
----------------------------------



CREATE OR REPLACE PROCEDURE AsistenciaInsertarAlumno(
  p_MatriculaID IN NUMBER, 
  p_Fecha IN DATE
)
IS
BEGIN
  INSERT INTO asistencia (matricula_id, fecha)
  VALUES (p_MatriculaID, p_Fecha);
END;
/

CREATE OR REPLACE PROCEDURE CursoCargar(
    p_periodo IN NUMBER,
    cur OUT SYS_REFCURSOR
) IS
BEGIN
    OPEN cur FOR
    SELECT 
        curso_id,
        nombre,
        cantidadsesiones,
        periodo_id
    FROM curso
    WHERE periodo_id = p_periodo;
END;
/

CREATE OR REPLACE PROCEDURE CursoCargarPorID(
    p_cursoid IN NUMBER,
    cur OUT SYS_REFCURSOR
) IS
BEGIN
    OPEN cur FOR
    SELECT 
        curso_id AS id,
        nombre, 
        cantidadsesiones, 
        periodo_id AS periodoid
    FROM curso
    WHERE curso_id = p_cursoid;
END;
/


CREATE OR REPLACE PROCEDURE CursoInsertar(
    p_nombre IN VARCHAR2,
    p_cantidadsesiones IN NUMBER,
    p_periodo_id IN NUMBER
) IS
BEGIN
    INSERT INTO curso
    (
        curso_id,
        nombre,
        cantidadsesiones,
        periodo_id
    )
    VALUES
    (
        curso_seq.NEXTVAL,
        p_nombre,
        p_cantidadsesiones,
        p_periodo_id
    );
END;
/

CREATE OR REPLACE PROCEDURE CursoModificar(
    p_curso_id IN NUMBER,
    p_nombre IN VARCHAR2,
    p_cantidadsesiones IN NUMBER,
    p_periodo_id IN NUMBER
) IS
BEGIN
    UPDATE curso
    SET
        nombre = p_nombre,
        cantidadsesiones = p_cantidadsesiones,
        periodo_id = p_periodo_id
    WHERE curso_id = p_curso_id;
END;
/


CREATE OR REPLACE PROCEDURE AsistenciaReportePorCurso (
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT
        cr.curso_id,
        cr.nombre AS curso_nombre,
        a.matricula_id,
        a.fecha AS fecha_asistencia
    FROM
        asistencia a
    JOIN
        matricula m ON a.matricula_id = m.matricula_id
    JOIN
        curso cr ON m.curso_id = cr.curso_id
    ORDER BY
        cr.curso_id, a.fecha;
END AsistenciaReportePorCurso;
/

CREATE OR REPLACE PROCEDURE EstudianteCargar(
    p_id IN NUMBER
) AS
    cur SYS_REFCURSOR;
BEGIN
    OPEN cur FOR
    SELECT
        e.persona_id AS estudiante_id,
        p.nombre,
        p.apellido1,
        p.apellido2,
        p.correo,
        p.telefono,
        e.cedula
    FROM
        estudiante e
    JOIN
        persona p ON e.persona_id = p.persona_id
    WHERE
        e.cedula = p_id;
        
    --DBMS_SQL.RETURN_RESULT(cur);
END;
/


CREATE OR REPLACE PROCEDURE EstudianteCargarAsistenciaFecha(
    p_cursoid IN NUMBER,
    p_fecha IN DATE,
    cur OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN cur FOR
    SELECT
        e.persona_id AS estudiante_id,
        p.nombre,
        p.apellido1,
        p.apellido2,
        p.correo,
        p.telefono
    FROM
        estudiante e
    INNER JOIN
        matricula m ON e.persona_id = m.estudiante_id
    INNER JOIN
        curso cr ON m.curso_id = cr.curso_id
    LEFT JOIN
        asistencia a ON m.matricula_id = a.matricula_id
    JOIN
        persona p ON e.persona_id = p.persona_id
    WHERE
        cr.curso_id = p_cursoid
        AND a.fecha = p_fecha
    ORDER BY
        p.nombre ASC;
END;
/



--
---------------------------
--
--

CREATE OR REPLACE PROCEDURE EstudianteCargarAsistencia(
    p_cursoid IN NUMBER,
    p_fecha IN DATE,
    cur OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN cur FOR
    SELECT 
        e.persona_id AS estudiante_id,
        p.nombre,
        p.apellido1,
        p.apellido2,
        p.correo,
        p.telefono
    FROM 
        estudiante e
    INNER JOIN 
        matricula m ON e.persona_id = m.estudiante_id
    LEFT JOIN 
        asistencia a ON m.matricula_id = a.matricula_id AND a.fecha = p_fecha
    INNER JOIN 
        persona p ON e.persona_id = p.persona_id
    WHERE 
        m.curso_id = p_cursoid AND a.fecha IS NULL
    ORDER BY 
        p.nombre ASC;
END;
/

CREATE OR REPLACE PROCEDURE EstudianteCargarBusquedaNombre(
    p_nombre IN VARCHAR2,
    p_cursoid IN NUMBER,
    cur OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN cur FOR
    SELECT 
        e.persona_id AS estudiante_id,
        p.nombre,
        p.apellido1,
        p.apellido2,
        p.correo,
        p.telefono
    FROM 
        estudiante e
    INNER JOIN 
        persona p ON e.persona_id = p.persona_id
    WHERE 
        p.nombre LIKE '%' || p_nombre || '%'
        AND e.persona_id NOT IN (
            SELECT m.estudiante_id 
            FROM matricula m 
            WHERE m.curso_id = p_cursoid
        );
END;
/

CREATE OR REPLACE PROCEDURE AsistenciaReportePorCurso(
    p_cursoid IN NUMBER,
    cur OUT SYS_REFCURSOR
) IS
BEGIN
    OPEN cur FOR
    WITH FECHAS AS (
      SELECT COUNT(DISTINCT a.fecha) AS CantFechas
      FROM curso c
      JOIN matricula m ON m.curso_id = c.curso_id
      JOIN asistencia a ON a.matricula_id = m.matricula_id
      WHERE c.curso_id = p_cursoid
    )
    SELECT
      p.nombre,
      p.apellido1,
      p.apellido2,
      COUNT(a.fecha) AS sesiones_asistidas,
      fe.CantFechas - COUNT(a.fecha) AS sesiones_ausentes,
      fe.CantFechas AS sesiones_impartidas,
      c.cantidadsesiones AS sesiones_totales
    FROM curso c
    JOIN matricula m ON m.curso_id = c.curso_id
    JOIN asistencia a ON a.matricula_id = m.matricula_id
    JOIN estudiante e ON e.persona_id = m.estudiante_id
    JOIN persona p ON p.persona_id = e.persona_id
    JOIN FECHAS fe ON 1 = 1
    WHERE c.curso_id = p_cursoid
    GROUP BY p.nombre, p.apellido1, p.apellido2, fe.CantFechas, c.cantidadsesiones
    ORDER BY p.nombre;
END;
/

CREATE OR REPLACE PROCEDURE reporteAprobadoReprobado (
    p_anio IN NUMBER, 
    p_cuatrimestre IN VARCHAR2, 
    p_nombre_curso IN VARCHAR2,
    cur OUT SYS_REFCURSOR
) IS
BEGIN
    OPEN cur FOR
    SELECT 
        p.persona_id AS estudiante_id,
        p.nombre,
        p.apellido1,
        p.apellido2,
        COALESCE(SUM(cal.nota * r.porcentaje / 100), 0) AS nota,
        CASE 
            WHEN COALESCE(SUM(cal.nota * r.porcentaje / 100), 0) >= 70 
            THEN 'APROBADO'
            ELSE 'REPROBADO'
        END AS condicion
    FROM estudiante e
    JOIN persona p ON e.persona_id = p.persona_id
    JOIN matricula m ON e.estudiante_id = m.estudiante_id
    JOIN curso c ON m.curso_id = c.curso_id
    JOIN periodo pe ON c.periodo_id = pe.periodo_id
    LEFT JOIN calificacion cal ON m.matricula_id = cal.matricula_id
    LEFT JOIN rubro r ON cal.calificacionrubro_id = r.calificacionrubro_id
    WHERE pe.anio = p_anio
      AND pe.cuatrimestre = p_cuatrimestre
      AND c.nombre = p_nombre_curso
    GROUP BY p.persona_id, p.nombre, p.apellido1, p.apellido2
    ORDER BY p.nombre;
END;
/

CREATE OR REPLACE PROCEDURE ProfesorInsertar (
    p_nombre IN VARCHAR2, 
    p_apellido1 IN VARCHAR2, 
    p_apellido2 IN VARCHAR2, 
    p_correo IN VARCHAR2, 
    p_telefono IN VARCHAR2,  -- Usar VARCHAR2 para manejar caracteres especiales
    p_usuario IN VARCHAR2, 
    p_clave IN VARCHAR2
) IS
    new_persona_id NUMBER;
    new_profesor_id NUMBER;
BEGIN
    -- Obtener el nuevo ID para la tabla persona
    SELECT NVL(MAX(persona_id), 0) + 1 INTO new_persona_id FROM persona;

    -- Insertar en la tabla persona
    INSERT INTO persona (persona_id, nombre, apellido1, apellido2, telefono, correo)
    VALUES (
        new_persona_id, 
        p_nombre, 
        p_apellido1, 
        p_apellido2, 
        p_telefono, 
        p_correo
    );

    -- Obtener el nuevo ID para la tabla profesor
    SELECT NVL(MAX(profesor_id), 0) + 1 INTO new_profesor_id FROM profesor;

    -- Insertar en la tabla profesor
    INSERT INTO profesor (profesor_id, usuario, clave, persona_id)
    VALUES (new_profesor_id, p_usuario, p_clave, new_persona_id);
END;
/

CREATE OR REPLACE PROCEDURE ProfesorCargarTodos (
    cur OUT SYS_REFCURSOR
) IS
BEGIN
    OPEN cur FOR
    SELECT p.profesor_id AS id,
           p.usuario,
           p.clave,
           per.nombre,
           per.apellido1,
           per.apellido2,
           per.telefono,
           per.correo
    FROM profesor p
    JOIN persona per ON p.persona_id = per.persona_id;
END;
/

CREATE OR REPLACE PROCEDURE PeriodoInsertar (
    p_anio IN NUMBER, 
    p_cuatrimestre IN NUMBER -- Suponiendo que `cuatrimestre` es de tipo VARCHAR2
) IS
    new_id NUMBER;
BEGIN
    -- Obtener el nuevo ID para la tabla periodo
    SELECT NVL(MAX(periodo_id), 0) + 1 INTO new_id FROM periodo;

    -- Insertar en la tabla periodo
    INSERT INTO periodo (periodo_id, anio, cuatrimestre)
    VALUES (new_id, p_anio, p_cuatrimestre);
END;
/

CREATE OR REPLACE PROCEDURE PeriodoCargar (
    cur OUT SYS_REFCURSOR
) IS
BEGIN
    OPEN cur FOR
    SELECT periodo_id AS id,
           anio AS anno,
           cuatrimestre
    FROM periodo
    ORDER BY anio DESC, cuatrimestre DESC;
END;
/

CREATE OR REPLACE PROCEDURE insertarCalificacion (
    p_matricula IN NUMBER, 
    p_nota IN NUMBER, 
    p_porcentaje IN NUMBER, 
    p_observaciones IN VARCHAR2,
    p_calificacionrubro_id IN NUMBER
) IS
    new_id NUMBER;
BEGIN
    -- Obtener el nuevo ID para la tabla calificacion
    SELECT NVL(MAX(calificacion_id), 0) + 1 INTO new_id FROM calificacion;

    -- Insertar en la tabla calificacion
    INSERT INTO calificacion (calificacion_id, matricula_id, nota, porcentaje, observaciones, calificacionrubro_id)
    VALUES (new_id, p_matricula, p_nota, p_porcentaje, p_observaciones, p_calificacionrubro_id);
END;
/

CREATE OR REPLACE PROCEDURE EstudianteModificar (
    p_estudiante_id IN NUMBER, 
    p_nombre IN VARCHAR2, 
    p_apellido1 IN VARCHAR2, 
    p_apellido2 IN VARCHAR2, 
    p_correo IN VARCHAR2, 
    p_telefono IN VARCHAR2
) IS
BEGIN
    UPDATE persona
    SET nombre = p_nombre,
        apellido1 = p_apellido1,
        apellido2 = p_apellido2,
        correo = p_correo,
        telefono = p_telefono
    WHERE persona_id = (
        SELECT persona_id
        FROM estudiante
        WHERE estudiante_id = p_estudiante_id
    );
    
    -- Verificar que el estudiante exista y actualizar su información
    UPDATE estudiante
    SET persona_id = (
        SELECT persona_id
        FROM persona
        WHERE nombre = p_nombre
          AND apellido1 = p_apellido1
          AND apellido2 = p_apellido2
          AND correo = p_correo
          AND telefono = p_telefono
    )
    WHERE estudiante_id = p_estudiante_id;
END;
/

CREATE OR REPLACE PROCEDURE EstudianteMatricularCurso (
    p_cursoid IN NUMBER, 
    p_estudianteid IN NUMBER
) IS
BEGIN
    INSERT INTO matricula (matricula_id, estudiante_id, curso_id)
    VALUES (
        (SELECT NVL(MAX(matricula_id), 0) + 1 FROM matricula),
        p_estudianteid,
        p_cursoid
    );
END;
/

CREATE OR REPLACE PROCEDURE EstudianteInsertar(
    p_nombre IN VARCHAR2, 
    p_apellido1 IN VARCHAR2, 
    p_apellido2 IN VARCHAR2, 
    p_correo IN VARCHAR2, 
    p_telefono IN VARCHAR2,
    p_cedula IN VARCHAR2
) IS
    new_persona_id NUMBER;
    new_estudiante_id NUMBER;
BEGIN
    -- Obtener el nuevo ID para la tabla persona
    SELECT NVL(MAX(persona_id), 0) + 1 INTO new_persona_id FROM persona;

    -- Insertar en la tabla persona
    INSERT INTO persona (persona_id, nombre, apellido1, apellido2, telefono, correo)
    VALUES (
        new_persona_id, 
        p_nombre, 
        p_apellido1, 
        p_apellido2, 
        p_telefono, 
        p_correo
    );

    -- Obtener el nuevo ID para la tabla estudiante
    SELECT NVL(MAX(estudiante_id), 0) + 1 INTO new_estudiante_id FROM estudiante;

    -- Insertar en la tabla profesor
    INSERT INTO estudiante (estudiante_id, persona_id, cedula)
    VALUES (new_estudiante_id, new_persona_id, p_cedula);
END;
/



--
--
--
--
--
CREATE OR REPLACE PROCEDURE EstudianteDesmatricularCurso(
    p_cursoid IN NUMBER,
    p_estudianteid IN NUMBER
) IS
BEGIN
    -- Eliminar la matrícula del estudiante para el curso especificado
    DELETE FROM matricula
    WHERE curso_id = p_cursoid
      AND estudiante_id = p_estudianteid;
      
    -- Confirmar la transacción (opcional, dependiendo de tu entorno y configuraciones)
    COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE EstudianteCargarPorCursoID (
    p_cursoid IN NUMBER,
    cur OUT SYS_REFCURSOR
) IS
BEGIN
    -- Abre el cursor para la consulta que obtiene los detalles de los estudiantes
    OPEN cur FOR
    SELECT p.persona_id,
           p.nombre,
           p.apellido1,
           p.apellido2,
           p.correo,
           p.telefono
    FROM estudiante e
    INNER JOIN persona p ON p.persona_id = e.persona_id
    INNER JOIN matricula m ON m.estudiante_id = e.estudiante_id
    WHERE m.curso_id = p_cursoid
    ORDER BY p.nombre;
END;
/

CREATE OR REPLACE PROCEDURE EstudianteCargarMatriculadosSinCalificacion(
    p_anno IN NUMBER,
    p_cuatrimestre IN VARCHAR2,
    p_nombre_curso IN VARCHAR2,
    cur OUT SYS_REFCURSOR
) IS
BEGIN
    OPEN cur FOR
    SELECT p.persona_id AS estudiante_id,
           m.matricula_id,
           p.nombre,
           p.apellido1,
           p.apellido2,
           p.correo,
           p.telefono
    FROM estudiante e
    INNER JOIN persona p ON e.persona_id = p.persona_id
    INNER JOIN matricula m ON e.estudiante_id = m.estudiante_id
    INNER JOIN curso c ON m.curso_id = c.curso_id
    INNER JOIN periodo per ON c.periodo_id = per.periodo_id
    LEFT JOIN calificacion cal ON m.matricula_id = cal.matricula_id
    WHERE per.anio = p_anno
      AND per.cuatrimestre = p_cuatrimestre
      AND c.nombre = p_nombre_curso
      AND cal.matricula_id IS NULL;
END;
/


CREATE OR REPLACE PROCEDURE EstudianteCargarMatriculadosCurso (
    p_CursoID IN NUMBER
) IS
BEGIN
    EXECUTE IMMEDIATE '
        SELECT E.persona_id,
               E.nombre,
               E.apellido1,
               E.apellido2,
               E.correo,
               E.telefono
        FROM estudiante E
        INNER JOIN matricula M ON M.estudiante_id = E.persona_id
        WHERE M.curso_id = :cursoID
        ORDER BY E.nombre ASC'
    USING p_CursoID;
END;
/
--------------------------------------------------------------------------------


------------------------------SP ASISTENCIA---------------------------

--READ--
CREATE OR REPLACE PROCEDURE AsistenciaCargarPorCursoYFecha (
    p_curso_id NUMBER,
    p_fecha DATE,
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT a.fecha, a.matricula_id
    FROM asistencia a
    JOIN matricula m ON a.matricula_id = m.matricula_id
    WHERE m.curso_id = p_curso_id
    AND a.fecha = p_fecha;
END;
/

--UPTADE--
CREATE OR REPLACE PROCEDURE AsistenciaActualizar (
    p_fecha DATE,
    p_matricula_id NUMBER,
    p_nueva_fecha DATE,
    p_nueva_matricula_id NUMBER
) AS
BEGIN
    UPDATE asistencia
    SET fecha = p_nueva_fecha,
        matricula_id = p_nueva_matricula_id
    WHERE fecha = p_fecha
    AND matricula_id = p_matricula_id;
    
    COMMIT;
END;
/

------------------------SP CALIFICACION-------------------------

--READ--
CREATE OR REPLACE PROCEDURE CalificacionCargarTodos (
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT calificacion_id, nota, porcentaje, observaciones, matricula_id, calificacionrubro_id
    FROM calificacion;
END;
/


--DELETE--
CREATE OR REPLACE PROCEDURE CalificacionEliminar (
    p_calificacion_id NUMBER
) AS
BEGIN
    DELETE FROM calificacion
    WHERE calificacion_id = p_calificacion_id;
    
    COMMIT;
END;
/


----------------SP CURSO---------------------------------------------

--DELETE--
CREATE OR REPLACE PROCEDURE CursoEliminar (
    p_curso_id NUMBER
) AS
BEGIN
    DELETE FROM curso
    WHERE curso_id = p_curso_id;
    
    COMMIT;
END;
/

---------------------------------SP ESTUDIANTE------------------------------

--DELETE--
CREATE OR REPLACE PROCEDURE EstudianteEliminar (
    p_estudiante_id NUMBER
) AS
BEGIN
    DELETE FROM estudiante
    WHERE estudiante_id = p_estudiante_id;
    
    COMMIT;
END;
/

------------------------vistas-------------------------------------------

CREATE OR REPLACE VIEW VistaEstudiantesCompleta AS
SELECT e.estudiante_id,
       p.nombre,
       p.apellido1,
       p.apellido2,
       p.correo,
       p.telefono
FROM estudiante e
JOIN persona p ON e.persona_id = p.persona_id;

CREATE OR REPLACE VIEW VistaEstudiantesPorCurso AS
SELECT es.estudiante_id,
       p.nombre,
       p.apellido1,
       p.apellido2,
       c.curso_id,
       c.nombre AS curso_nombre
FROM matricula m
JOIN estudiante es ON m.estudiante_id = es.estudiante_id
JOIN persona p ON es.persona_id = p.persona_id
JOIN curso c ON m.curso_id = c.curso_id;

CREATE OR REPLACE VIEW VistaEstudiantesConCalificaciones AS
SELECT es.estudiante_id,
       p.nombre,
       p.apellido1,
       p.apellido2,
       c.nota,
       c.porcentaje,
       r.descripcion AS rubro_descripcion,
       cur.nombre AS curso_nombre
FROM calificacion c
JOIN matricula m ON c.matricula_id = m.matricula_id
JOIN estudiante es ON m.estudiante_id = es.estudiante_id
JOIN persona p ON es.persona_id = p.persona_id
JOIN rubro r ON c.calificacionrubro_id = r.calificacionrubro_id
JOIN curso cur ON r.curso_id = cur.curso_id;

CREATE OR REPLACE VIEW VistaAsistenciaPorEstudiante AS
SELECT es.estudiante_id,
       p.nombre,
       p.apellido1,
       p.apellido2,
       a.fecha,
       c.nombre AS curso_nombre
FROM asistencia a
JOIN matricula m ON a.matricula_id = m.matricula_id
JOIN estudiante es ON m.estudiante_id = es.estudiante_id
JOIN persona p ON es.persona_id = p.persona_id
JOIN curso c ON m.curso_id = c.curso_id;

CREATE OR REPLACE VIEW VistaEstudiantesSinCalificaciones AS
SELECT es.estudiante_id,
       p.nombre,
       p.apellido1,
       p.apellido2,
       cur.nombre AS curso_nombre
FROM matricula m
JOIN estudiante es ON m.estudiante_id = es.estudiante_id
JOIN persona p ON es.persona_id = p.persona_id
JOIN curso cur ON m.curso_id = cur.curso_id
LEFT JOIN calificacion c ON m.matricula_id = c.matricula_id
WHERE c.calificacion_id IS NULL;

---------------------------------------------------------------------


/*Crear Universidad*/
CREATE OR REPLACE PROCEDURE UniversidadCrear(
    p_nombre IN universidad.nombre%TYPE
) IS
BEGIN
    INSERT INTO universidad (
        universidad_id,
        nombre
    ) VALUES (
        universidad_seq.NEXTVAL,
        p_nombre
    );

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END UniversidadCrear;
/

/**/
CREATE OR REPLACE PROCEDURE UpdateUniversidad(pUniversidad_ID in number,pNombre in VARCHAR2)
as
begin
update Universidad
set nombre= pNombre
where pUniversidad_ID=(select Universidad_ID from UNIVERSIDAD );
End;
/

/**/
CREATE OR REPLACE PROCEDURE deleteUniversidad(pUniversidad_ID in number,pNombre in VARCHAR2)
as
begin
delete from Universidad
where pUniversidad_ID=(select Universidad_ID from UNIVERSIDAD );
End;
/

/*Consultar Universidad*/
CREATE OR REPLACE PROCEDURE UniversidadConsultar(
    p_universidad_id IN universidad.universidad_id%TYPE,
    p_nombre OUT universidad.nombre%TYPE
) IS
BEGIN
    SELECT nombre
    INTO p_nombre
    FROM universidad
    WHERE universidad_id = p_universidad_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_nombre := NULL;
    WHEN OTHERS THEN
        RAISE;
END UniversidadConsultar;
/


--------------------
--Consutar Rubro
--
CREATE OR REPLACE PROCEDURE RubroConsultar(
    p_calificacionrubro_id IN rubro.calificacionrubro_id%TYPE,
    p_descripcion OUT rubro.descripcion%TYPE,
    p_porcentaje OUT rubro.porcentaje%TYPE,
    p_curso_id OUT rubro.curso_id%TYPE
) IS
BEGIN
    SELECT descripcion, porcentaje, curso_id
    INTO p_descripcion, p_porcentaje, p_curso_id
    FROM rubro
    WHERE calificacionrubro_id = p_calificacionrubro_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_descripcion := NULL;
        p_porcentaje := NULL;
        p_curso_id := NULL;
    WHEN OTHERS THEN
        RAISE;
END RubroConsultar;
/


CREATE OR REPLACE PROCEDURE DeleteRubro(pRubrocalificacionrubro_id in number)
as
begin
delete from rubro
where pRubrocalificacionrubro_id =(select calificacionrubro_id from rubro);
End;
/

create or replace PROCEDURE CreateRubro(pcalificacionrubro_id in number,pdescripcion in VARCHAR2,pporcentaje in number, pcurso_id in number)
as
begin
Insert into rubro(calificacionrubro_id , descripcion, porcentaje, curso_id )values ( pcalificacionrubro_id , pdescripcion, pporcentaje, pcurso_id );
End;

/

CREATE OR REPLACE PROCEDURE UpdateRubro(pcalificacionrubro_id in number,pDescripcion in VARCHAR2,pporcentaje in number)
as
begin
update rubro
set descripcion = pDescripcion,
    porcentaje = pporcentaje
where pcalificacionrubro_id =(select calificacionrubro_id from rubro);
End;
/














