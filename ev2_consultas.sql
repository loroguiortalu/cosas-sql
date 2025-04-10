-- habiendo cargado ya los datos:
use ev2_concesionario;

-- 1
SELECT concat(DNI,' - ',apellidos,', ',nombre) AS 'DNI - APELLIDO1 APELLIDO2, NOMBRE'  FROM cliente WHERE ((substr(apellidos,LOCATE(' ',apellidos, 1)+1)) LIKE 'GARCIA'OR 'FUENTES') and (ciudad LIKE 'Madrid' OR 'BARCELONA')
ORDER BY concat(DNI,' - ',apellidos,', ',nombre) ASC;
select apellidos FROM cliente;

-- 2
SELECT ROUND(MAX(precio),2) AS 'Precio máximo', ROUND(MIN(precio),2) AS 'Precio mínimo',
ROUND(AVG(precio),2) AS 'Precio medio', ROUND(SUM(precio),2) AS 'Precio suma'
FROM coche WHERE (nombre LIKE 'AUDI%' OR nombre LIKE 'SEAT') 
AND NOT(modelo LIKE '%TSI');-- creo que es así

-- select * from coche; -- estos comentarios los dejo porque no son parte del ejercicio, pero los he usado, y no tengo tiempo de borrrarlos


-- 3
-- select * from venta order by DNI_cliente;
-- select * from cliente;

select DISTINCT c.DNI AS 'DNI', COUNT(v.DNI_cliente) as 'cochescomprados'
FROM cliente c JOIN venta v ON c.DNI = v.DNI_cliente
GROUP BY c.DNI
HAVING COUNT(v.DNI_cliente) between 2 and 4
ORDER BY c.DNI;


-- 4
-- select * from concesionario;
-- select * from venta;

SELECT c.CIF AS 'CIF', c.nombre AS 'NOMBRE' , c.ciudad AS 'CIUDAD' FROM concesionario c
JOIN venta v ON c.CIF = v.CIF_concesionario
WHERE (v.color LIKE 'BLANCO') AND (v.fecha BETWEEN '2024-11-01' AND '2024-11-15');



-- 5
SELECT * FROM venta;

SELECT concat('es ',dayname(fecha)) as dia
FROM venta

; -- no tengo tiempo


-- 7
select * from concesionario;
select * from distribucion;


SELECT DISTINCT c.CIF AS 'CIF', SUM(d.cantidad) AS 'CANTIDAD COCHES' FROM concesionario c
JOIN distribucion d ON c.CIF = d.CIF_concesionario
GROUP BY c.CIF
HAVING (SUM(d.cantidad)) = 18
;
-- como tal el concesionario con menor de coches coches almacenados
-- tiene 18 coches como mucho, ¿que existe una función para ver cual es el menor?
-- si, pero el concesionario o concesionarios con menor stock va a tener 18
-- LOWER se que no es, porque eso es para las cadenas en minúscula,
-- creo que es MIN pero ya se me ha ido el tiempos




