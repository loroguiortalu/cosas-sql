 FUNCIONES
1. Área de un círculo

DELIMITER //
CREATE FUNCTION fn_area_circulo (radio DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN 
    RETURN POW(radio, 2) * PI();
END //
DELIMITER ;

2. Hipotenusa redondeada

DELIMITER //
CREATE FUNCTION fn_hipotenusa (a DECIMAL(10,2), b DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN ROUND(SQRT(POW(a, 2) + POW(b, 2)), 2);
END //
DELIMITER ;

3. Día de la semana en texto

DELIMITER //
CREATE FUNCTION fn_dia_semana(fecha DATE)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE resultado VARCHAR(20);
    CASE DAYOFWEEK(fecha)
        WHEN 1 THEN SET resultado = 'Domingo';
        WHEN 2 THEN SET resultado = 'Lunes';
        WHEN 3 THEN SET resultado = 'Martes';
        WHEN 4 THEN SET resultado = 'Miércoles';
        WHEN 5 THEN SET resultado = 'Jueves';
        WHEN 6 THEN SET resultado = 'Viernes';
        WHEN 7 THEN SET resultado = 'Sábado';
    END CASE;
    RETURN resultado;
END //
DELIMITER ;

4. Factorial con LOOP

DELIMITER //
CREATE FUNCTION fn_factorial_loop(n INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE resultado INT DEFAULT 1;
    DECLARE i INT DEFAULT 1;
    loop_label: LOOP
        IF i > n THEN
            LEAVE loop_label;
        END IF;
        SET resultado = resultado * i;
        SET i = i + 1;
    END LOOP;
    RETURN resultado;
END //
DELIMITER ;

5. Factorial con REPEAT

DELIMITER //
CREATE FUNCTION fn_factorial_repeat(n INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE resultado INT DEFAULT 1;
    DECLARE i INT DEFAULT 1;
    REPEAT
        SET resultado = resultado * i;
        SET i = i + 1;
    UNTIL i > n
    END REPEAT;
    RETURN resultado;
END //
DELIMITER ;

6. Factorial con WHILE

DELIMITER //
CREATE FUNCTION fn_factorial_while(n INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE resultado INT DEFAULT 1;
    DECLARE i INT DEFAULT 1;
    WHILE i <= n DO
        SET resultado = resultado * i;
        SET i = i + 1;
    END WHILE;
    RETURN resultado;
END //
DELIMITER ;

7. Palabra corta, larga o vacía ----------------------------------------------------------------------

DELIMITER //
CREATE FUNCTION fn_evalua_palabra(palabra VARCHAR(100))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE tam INT DEFAULT LENGTH(TRIM(palabra));
    IF tam = 0 THEN
        RETURN 'Palabra con 0 caracteres';
    ELSEIF tam > 14 THEN
        RETURN 'Palabra con más de 14 caracteres';
    ELSEIF tam > 3 THEN
        RETURN 'Palabra corta';
    ELSE
        RETURN 'Palabra muy corta';
    END IF;
END //
DELIMITER ;

8. Función con LOCATE

DELIMITER //
CREATE FUNCTION fn_posicion_letra(cadena VARCHAR(100), letra CHAR(1))
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN LOCATE(letra, cadena);
END //
DELIMITER ;

9. Función con SUBSTRING

DELIMITER //
CREATE FUNCTION fn_substring_mitad(cadena VARCHAR(100))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    RETURN SUBSTRING(cadena, 1, FLOOR(LENGTH(cadena)/2));
END //
DELIMITER ;

10. Función con REPLACE

DELIMITER //
CREATE FUNCTION fn_reemplaza_espacios(cadena VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN REPLACE(cadena, ' ', '_');
END //
DELIMITER ;

11. Función con CONCAT

DELIMITER //
CREATE FUNCTION fn_saludo(nombre VARCHAR(50))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN CONCAT('Hola ', nombre, '! Bienvenido/a a la clínica.');
END //
DELIMITER ;

12. Función con TRIM

DELIMITER //
CREATE FUNCTION fn_trim_palabra(cadena VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN TRIM(cadena);
END //
DELIMITER ;

13. Nombre del cliente en formato “apellido nombre” (por ID)----------------------------------------------------------------

DELIMITER //
CREATE FUNCTION fn_cliente_apellido_nombre(id_cliente INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE nombre_completo VARCHAR(100);
    DECLARE espacio INT;
    SELECT nombre INTO nombre_completo FROM cliente WHERE id = id_cliente;
    SET espacio = LOCATE(' ', nombre_completo);
    RETURN CONCAT(SUBSTRING(nombre_completo, espacio+1), ' ', SUBSTRING(nombre_completo, 1, espacio-1));
END //
DELIMITER ;

14. Lo mismo pero recibiendo un string---------------------------------------------------------------------------------------
-
DELIMITER //
CREATE FUNCTION fn_voltea_nombre(nombre_completo VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE espacio INT;
    SET espacio = LOCATE(' ', nombre_completo);
    RETURN CONCAT(SUBSTRING(nombre_completo, espacio+1), ' ', SUBSTRING(nombre_completo, 1, espacio-1));
END //
DELIMITER ;

15. Cliente tiene mascota con ese nombre

DELIMITER //
CREATE FUNCTION fn_existe_cliente_mascota(id_cliente INT, nombre_mascota VARCHAR(50))
RETURNS TINYINT
DETERMINISTIC
BEGIN
    DECLARE existe INT;
    SELECT COUNT(*) INTO existe
    FROM mascota
    WHERE id_cliente = id_cliente AND nombre = TRIM(nombre_mascota);
    RETURN IF(existe > 0, 1, 0);
END //
DELIMITER ;

16. Sala libre ese día

DELIMITER //
CREATE FUNCTION fn_sala_libre(sala INT, fecha DATE)
RETURNS TINYINT
DETERMINISTIC
BEGIN
    DECLARE ocupado INT;
    SELECT COUNT(*) INTO ocupado
    FROM atiende
    WHERE numero_sala = sala AND fecha_cita = fecha;
    RETURN IF(ocupado = 0, 1, 0);
END //
DELIMITER ;

17. Cliente Premium

DELIMITER //
CREATE FUNCTION fn_cliente_premium(id_cliente INT)
RETURNS TINYINT
DETERMINISTIC
BEGIN
    DECLARE gasto_total DECIMAL(10,2);
    DECLARE num_mascotas INT;
    SELECT SUM(precio) INTO gasto_total FROM atiende WHERE id_cliente = id_cliente;
    SELECT COUNT(*) INTO num_mascotas FROM mascota WHERE id_cliente = id_cliente;
    RETURN IF(gasto_total > 150 AND num_mascotas > 2, 1, 0);
END //
DELIMITER ;

🛠️ PROCEDIMIENTOS
18. Intercambiar dos números

DELIMITER //
CREATE PROCEDURE sp_get_intercambia(INOUT a INT, INOUT b INT)
BEGIN
    DECLARE temp INT;
    SET temp = a;
    SET a = b;
    SET b = temp;
END //
DELIMITER ;

19. Clasificación de nota

DELIMITER //
CREATE PROCEDURE sp_get_nota(IN nota INT, OUT resultado VARCHAR(30))
BEGIN
    CASE
        WHEN nota IS NULL THEN SET resultado = NULL;
        WHEN nota BETWEEN 0 AND 4 THEN SET resultado = 'Suspenso';
        WHEN nota = 5 THEN SET resultado = 'Aprobado';
        WHEN nota = 6 THEN SET resultado = 'Bien';
        WHEN nota IN (7,8) THEN SET resultado = 'Notable';
        WHEN nota IN (9,10) THEN SET resultado = 'Sobresaliente';
        WHEN nota = 11 THEN SET resultado = 'Matricula de Honor';
        ELSE SET resultado = '';
    END CASE;
END //
DELIMITER ;

20. Contar vocales, consonantes y espacios

DELIMITER //
CREATE PROCEDURE sp_get_cuenta_caracteres(IN texto VARCHAR(255), OUT vocales INT, OUT consonantes INT, OUT espacios INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE c CHAR(1);
    SET vocales = 0;
    SET consonantes = 0;
    SET espacios = 0;
    WHILE i <= LENGTH(texto) DO
        SET c = LOWER(SUBSTRING(texto, i, 1));
        IF c IN ('a','e','i','o','u') THEN
            SET vocales = vocales + 1;
        ELSEIF c = ' ' THEN
            SET espacios = espacios + 1;
        ELSE
            SET consonantes = consonantes + 1;
        END IF;
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;

21. Eliminar espacios sin usar REPLACE

DELIMITER //
CREATE PROCEDURE sp_get_elimina_espacios(IN texto VARCHAR(255), OUT resultado VARCHAR(255))
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE c CHAR(1);
    SET resultado = '';
    WHILE i <= LENGTH(texto) DO
        SET c = SUBSTRING(texto, i, 1);
        IF c != ' ' THEN
            SET resultado = CONCAT(resultado, c);
        END IF;
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;

22. Ocupación de salas por año

DELIMITER //
CREATE PROCEDURE sp_get_ocupacion_salas_anyo(IN anio INT, OUT sala1 INT, OUT sala2 INT, OUT sala3 INT, OUT sala4 INT)
BEGIN
    SELECT COUNT(*) INTO sala1 FROM atiende WHERE numero_sala = 1 AND YEAR(fecha_cita) = anio;
    SELECT COUNT(*) INTO sala2 FROM atiende WHERE numero_sala = 2 AND YEAR(fecha_cita) = anio;
    SELECT COUNT(*) INTO sala3 FROM atiende WHERE numero_sala = 3 AND YEAR(fecha_cita) = anio;
    SELECT COUNT(*) INTO sala4 FROM atiende WHERE numero_sala = 4 AND YEAR(fecha_cita) = anio;
END //
DELIMITER ;

23. Buscar cliente por nombre de mascota

DELIMITER //
CREATE PROCEDURE sp_get_cliente_mascota(IN nombre_mascota VARCHAR(50))
BEGIN
    IF nombre_mascota IS NULL THEN
        SELECT 'Nombre de mascota no puede ser NULL' AS mensaje;
    ELSE
        SELECT m.nombre AS mascota, CONCAT(SUBSTRING_INDEX(c.nombre, ' ', -1), ', ', SUBSTRING_INDEX(c.nombre, ' ', 1)) AS cliente, c.telefono
        FROM mascota m JOIN cliente c ON m.id_cliente = c.id
        WHERE m.nombre = nombre_mascota;

        SELECT CONCAT(COUNT(*), ' tienen una mascota con el nombre: ', nombre_mascota) AS mensaje
        FROM mascota WHERE nombre = nombre_mascota;
    END IF;
END //
DELIMITER ;

24. Ingresos por veterinario en un rango

DELIMITER //
CREATE PROCEDURE sp_get_ingresos_veterinario(IN dni VARCHAR(10), IN f_ini DATE, IN f_fin DATE, OUT total DECIMAL(10,2), OUT info VARCHAR(50))
BEGIN
    DECLARE v_id INT;
    SELECT id INTO v_id FROM veterinario WHERE DNI = dni;

    IF v_id IS NULL THEN
        SET info = 'No existe veterinario';
        SET total = 0;
    ELSE
        SELECT SUM(precio) INTO total FROM atiende WHERE id_veterinario = v_id AND fecha_cita BETWEEN f_ini AND f_fin;
        SET total = IFNULL(total, 0);
        SET info = CASE 
            WHEN total = 0 THEN 'Sin ingresos'
            WHEN total < 150 THEN 'Aceptable'
            ELSE 'Extraordinario'
        END;
    END IF;
END //
DELIMITER ;








🔧 FUNCIONES (devuelven un único valor):
1. fn_getTotalVentasPorConcesionario

Devuelve el número total de ventas realizadas por un concesionario según su CIF.

DELIMITER //
CREATE FUNCTION fn_getTotalVentasPorConcesionario(cif_input CHAR(10))
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total
  FROM venta
  WHERE CIF_concesionario = cif_input;
  RETURN total;
END;
//
DELIMITER ;

2. fn_precioMedioPorModelo

Devuelve el precio medio de un modelo de coche (por ejemplo, "AUDI A3").

DELIMITER //
CREATE FUNCTION fn_precioMedioPorModelo(modelo_input VARCHAR(50))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE media DECIMAL(10,2);
  SELECT AVG(precio) INTO media
  FROM coche
  WHERE nombre = modelo_input;
  RETURN media;
END;
//
DELIMITER ;

3. fn_clienteHaComprado

Devuelve 1 si un cliente (DNI) ha comprado al menos un coche, y 0 en caso contrario.

DELIMITER //
CREATE FUNCTION fn_clienteHaComprado(dni_input CHAR(10))
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
  DECLARE resultado BOOLEAN;
  SELECT EXISTS (
    SELECT 1 FROM venta WHERE DNI_cliente = dni_input
  ) INTO resultado;
  RETURN resultado;
END;
//
DELIMITER ;

🔧 PROCEDIMIENTOS (pueden mostrar resultados, hacer inserts, etc.)
4. sp_listarCochesPorConcesionario

Muestra todos los coches disponibles en un concesionario (con nombre, modelo, precio, cantidad).

DELIMITER //
CREATE PROCEDURE sp_listarCochesPorConcesionario(IN cif_input CHAR(10))
BEGIN
  SELECT c.nombre, c.modelo, c.precio, d.cantidad
  FROM distribucion d
  JOIN coche c ON d.codigo_coche = c.codigo
  WHERE d.CIF_concesionario = cif_input;
END;
//
DELIMITER ;

5. sp_registrarVenta

Registra una nueva venta si el coche está disponible en el concesionario (usando distribucion). Valida existencia antes de insertar.

DELIMITER //
CREATE PROCEDURE sp_registrarVenta(
  IN p_cif CHAR(10),
  IN p_dni CHAR(10),
  IN p_codigo INT,
  IN p_color VARCHAR(25),
  IN p_fecha DATE
)
BEGIN
  DECLARE stock INT;
  SELECT cantidad INTO stock
  FROM distribucion
  WHERE CIF_concesionario = p_cif AND codigo_coche = p_codigo;

  IF stock IS NULL OR stock <= 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'No hay stock disponible para este coche en el concesionario.';
  ELSE
    INSERT INTO venta (CIF_concesionario, DNI_cliente, codigo_coche, color, fecha)
    VALUES (p_cif, p_dni, p_codigo, p_color, p_fecha);
    
    -- Decrementar stock
    UPDATE distribucion
    SET cantidad = cantidad - 1
    WHERE CIF_concesionario = p_cif AND codigo_coche = p_codigo;
  END IF;
END;
//
DELIMITER ;

6. sp_clientesConMasDeNCoches

Muestra los clientes que han comprado más de N coches.

DELIMITER //
CREATE PROCEDURE sp_clientesConMasDeNCoches(IN n INT)
BEGIN
  SELECT cl.DNI, cl.nombre, cl.apellidos, COUNT(*) AS total_coches
  FROM cliente cl
  JOIN venta v ON cl.DNI = v.DNI_cliente
  GROUP BY cl.DNI
  HAVING total_coches > n;
END;
//
DELIMITER ;









---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------


✅ 1. Función que recibe el id_cliente y devuelve el nombre en formato “Apellido Nombre”

DELIMITER //
CREATE FUNCTION fn_apellidoAntesNombrePorId(id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
  DECLARE nombre_completo VARCHAR(100);
  DECLARE nombre VARCHAR(50);
  DECLARE apellido VARCHAR(50);

  -- Obtener el nombre completo del cliente
  SELECT nombre INTO nombre_completo
  FROM cliente
  WHERE idCliente = id;

  -- Extraer el nombre (primera palabra)
  SET nombre = SUBSTRING(nombre_completo, 1, LOCATE(' ', nombre_completo) - 1);

  -- Extraer el apellido (segunda palabra en adelante)
  SET apellido = SUBSTRING(nombre_completo, LOCATE(' ', nombre_completo) + 1);

  RETURN CONCAT(apellido, ' ', nombre);
END;
//
DELIMITER ;

📌 Ejemplo de uso:

SELECT fn_apellidoAntesNombrePorId(3);  -- Supón que devuelve 'Garcia Maria'

✅ 2. Función que recibe directamente un VARCHAR tipo “Nombre Apellido” y devuelve “Apellido Nombre”

DELIMITER //
CREATE FUNCTION fn_invertirNombre(nombre_completo VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
  DECLARE nombre VARCHAR(50);
  DECLARE apellido VARCHAR(50);

  -- Extraer el nombre (primera palabra)
  SET nombre = SUBSTRING(nombre_completo, 1, LOCATE(' ', nombre_completo) - 1);

  -- Extraer el apellido (segunda palabra en adelante)
  SET apellido = SUBSTRING(nombre_completo, LOCATE(' ', nombre_completo) + 1);

  RETURN CONCAT(apellido, ' ', nombre);
END;
//
DELIMITER ;

📌 Ejemplo de uso:

SELECT fn_invertirNombre('Carlos galAn');  -- Devuelve 'galAn Carlos'





¡Perfecto! Aquí tienes una versión extendida de la función que invierte el orden de un nombre completo de dos o más palabras, de modo que el apellido(s) (todo lo que esté después del primer espacio) vaya al principio, seguido del nombre (la primera palabra).
✅ Función que invierte cualquier nombre tipo “Nombre Apellido(s)” a “Apellido(s) Nombre”

DELIMITER //
CREATE FUNCTION fn_invertirNombreExtendido(nombre_completo VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
  DECLARE nombre VARCHAR(50);
  DECLARE resto VARCHAR(100);

  -- Extraer el nombre (primera palabra)
  SET nombre = SUBSTRING(nombre_completo, 1, LOCATE(' ', nombre_completo) - 1);

  -- Extraer el resto del nombre (desde el primer espacio hasta el final)
  SET resto = SUBSTRING(nombre_completo, LOCATE(' ', nombre_completo) + 1);

  -- Devolver el apellido(s) seguido del nombre
  RETURN CONCAT(resto, ' ', nombre);
END;
//
DELIMITER ;

📌 Ejemplos de uso:

SELECT fn_invertirNombreExtendido('Juan Carlos Garcia');   -- 'Carlos Garcia Juan'
SELECT fn_invertirNombreExtendido('Ana María Rodríguez Pérez');  -- 'María Rodríguez Pérez Ana'

🧠 Cómo funciona:

    Separa la primera palabra (el nombre) usando LOCATE(' ', ...).

    Luego toma el resto con SUBSTRING desde justo después del primer espacio.

    Finalmente concatena el "resto" seguido del nombre.