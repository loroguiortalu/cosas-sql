use pr2_clinica_veterinaria;

-- Ej 1
SELECT m.nombre AS 'nombres de mascotas', c.id AS 'clientes que nunca han tenido citas'  
FROM atiende a
JOIN cliente c ON a.id_cliente = c.id
LEFT JOIN mascota m ON m.id_cliente = c.id
ORDER BY c.id 
; -- debo repasat los joins




-- Ej 2
SELECT * FROM atiende WHERE precio <= ALL (SELECT precio FROM atiende);

-- Ej 3
SELECT v.nombre, sum(a.precio) AS 'suma de precio de esas citas', round(avg(a.precio),2) as 'media precio citas' 
FROM atiende a JOIN veterinario v ON a.id_veterinario = v.id 
WHERE a.fecha_cita BETWEEN '2024-10-01' AND '2024-10-31' 
GROUP BY v.nombre ;


-- Ej 4
SELECT c.nombre AS 'nombres de clientes', sum(a.precio) AS 'Dinero gastado'   
FROM cliente c LEFT JOIN atiende a ON a.id_cliente = c.id
WHERE a.precio Is NOT null
GROUP BY c.id
ORDER BY sum(a.precio) desc ; 


-- Ej 5
SELECT s.numero, s.descripcion, count(a.numero_sala) AS 'numero de citas' FROM sala s JOIN atiende a ON a.numero_sala = s.numero  
WHERE a.fecha_cita BETWEEN '2024-01-01' AND '2024-12-31' 
GROUP BY s.numero;

-- Ej 6
SELECT v.nombre, v.id, (COUNT(a.fecha_cita)) 
FROM atiende a JOIN veterinario v; 



-- Ej 7
SELECT *, SUBSTR(nombre,1, LOCATE(' ', nombre)-1) AS nombresRepetidos FROM veterinario
-- WHERE count(SUBSTR(nombre,1, LOCATE(' ', nombre)-1)) BETWEEN 2 AND 1000
;

-- Ej 8


-- Ej 9
SELECT a.fecha_cita, c.nombre, v.nombre, s.descripcion
FROM atiende a
JOIN cliente c ON a.id_cliente = c.id
JOIN veterinario v ON v.id = a.id_veterinario
JOIN sala s ON a.numero_sala = s.numero
WHERE dayname(fecha_cita) = 'Tuesday' OR dayname(fecha_cita) = 'Monday'
ORDER BY a.fecha_cita ASC;



-- Ej 10


