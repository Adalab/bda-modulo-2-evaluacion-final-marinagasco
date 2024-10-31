USE sakila; 

-- Evaluación Módulo2: 

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT DISTINCT title as título -- Para que no aparezcan duplicados seleccionamos el "DISTINCT" de la tabla "FILM". 
	FROM film;

-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

SELECT title as título -- Al decir "todos los nombres, de todas las películas" eliminamos el DISTINCT y añadimos todos lo títulos. 
	FROM film
    WHERE rating = "PG-13"; -- Aquí buscamos la coincidencia dentro de la columna "rating". 

-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

SELECT title as título, description as sinopsis-- 
	FROM film
    WHERE description LIKE "%amazing%"; -- Usando el LIKE buscamos patrones que contengan en algún momento la palabra "amazing". 

-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

SELECT title as título
	FROM film
    WHERE length > 120; -- Usamos la columna de duración "length" que sea mayor que "120". 

-- 5. Recupera los nombres de todos los actores.

SELECT first_name as nombre, last_name as apellido
	FROM actor;
    
-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

SELECT first_name as nombre, last_name as apellido
	FROM actor
    WHERE last_name LIKE "%Gibson%"; -- Al pedir en el enunciado que "tengan Gibson" en el apellido, no podemos igualar WHERE last_name = "Gibson", sino hacer un patrón con LIKE para que lo contenga.  
    
-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.

SELECT first_name as nombre, last_name as apellido, actor_id as núm_identificativo
	FROM actor
    WHERE actor_id BETWEEN 10 AND 20; -- Usamos la query de BETWEEN para enocntrar el rango determinado que nos pide el ejercicio y tenemos en cuenta que el 10 está incluido. 

-- 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.

SELECT title  as título
	FROM film
    WHERE rating NOT IN ("R","PG-13"); -- Esta es la forma más limpia de resolver este código. 
    
SELECT title as título 
	FROM film
    WHERE rating <> "R"
    AND rating <> "PG-13"; -- Pero también lo podemos hacer de esta manera con operadores de comparación. 
    
SELECT title as título -- 
	FROM film
    WHERE rating != "R"
    AND rating != "PG-13"; -- Y esta es otra forma de resolver el ejercicio con el operador de comparación != para que sea distinto. 

-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.

SELECT rating as clasificación, COUNT(rating) as recuento
	FROM film                
    GROUP BY rating; -- Solo nos tenemos que fijar en el rating y en su recuento total con el COUNT.  
    
-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

SELECT c.customer_id as núm_cliente, c.first_name as nombre_cliente, c.last_name as apellido_cliente, COUNT(rental_id) as total_alquileres-- La query correcta es COUNT porque si usamos SUM nos suma todos los rental_ID's de las películas y en este caso, no tiene sentido porque no queremos sumar identificadores sino contar las pelis que se han alquilado. 
	FROM customer as c
    INNER JOIN rental as r
    ON c.customer_id = r.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name; -- Hemos agrupado por name/last_name por buenas prácticas, pero el resultado es el mismo que si solo agrupáramos por customer_id. 
                                                       -- También hemos asignado un alias a cada columna para diferenciarlas de una tabla a la otra y que no sea ambigua, a pesar de ello, en este caso tan solo la columna de "cistomer_id" debería estar diferenciada. 
    
-- 11.  Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT cat.name as categoría, COUNT(r.rental_id) as total_alquileres -- Para poder llegar a tener toda esta info. hemos tenido que hacer 4 uniones/joins de tablas. 
	FROM rental as r
    INNER JOIN inventory as i
    USING (inventory_id)
    INNER JOIN film as f
    USING (film_id)
    INNER JOIN film_category as fcat
    USING (film_id)
    INNER JOIN category as cat
    USING (category_id)
    GROUP BY cat.name;
    
    -- Aquí hemos hecho una segunda versión donde hemos agregado el título de cada película y vemos cuántas veces se ha alquilado cada peli. 
    
    SELECT f.title as título, cat.name as categoría, COUNT(r.rental_id) as total_alquileres
		FROM rental as r
    INNER JOIN inventory as i
		USING (inventory_id)
    INNER JOIN film as f
		USING (film_id)
    INNER JOIN film_category as fcat
		USING (film_id)
    INNER JOIN category as cat
		USING (category_id)
    GROUP BY f.title, cat.name;
    
    -- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
    
    SELECT rating as clasificación, AVG(length) as promedio_duración -- Usamos el AVG para saber el promedio y agrupamos por rating. 
		FROM film
        GROUP BY rating;
        
-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

SELECT f.title as título, a.first_name as nombre_act, a.last_name as apellido_act 
	FROM actor as a
    INNER JOIN film_actor as fa
    USING (actor_id)
    INNER JOIN film as f
    USING (film_id)
    GROUP BY f.title, a.first_name, a.last_name
    HAVING title = "Indian Love"; -- Aquí usamos HAVING en lugar de WHERE porque estamos dentro de la condición del GROUP BY, aplicamos la condición tras haber hecho el agrupamiento.
                                  -- Con HAVING, estamos pidiendo solo el grupo con el título "Indian Love" después de haber agrupado los resultados por título y por cada actor.
    
    
-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.

SELECT title as título, description as sinopsis -- Han aparecido muchos resultados y como es algo inusual, hemos querido hacer la comprobación añadiendo en las columnas también la descripción para visualizarlo. 
	FROM FILM                                   -- Y sí, ¡éstábamos en lo cierto! Hay muchas pelis de perros y gatos porque hay mucho dog/cat lover en el mundo :) 
    WHERE description LIKE "%dog%" OR  description LIKE "%cat%";
    

-- 15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.

SELECT first_name as nombre,last_name as apellido 
 FROM actor as a
 LEFT JOIN film_actor as fa
 ON a.actor_id = fa.actor_id
 WHERE fa.actor_id IS NULL; -- A pesar de que no nos da ningún resultado, hemos hecho una query de comprobación y podemos asegurar que no hay ningún actor que NO aparezca en ninguna película. 

-- Query de comprobación: 
SELECT actor_id
 FROM film_actor
 WHERE actor_id IS NULL;


-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.

SELECT title as título
	FROM film
    WHERE release_year BETWEEN 2005 AND 2010;
    
-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".

SELECT title as título, cat.name as nombre_categoría -- Tan solo nos piden el título, pero para hacer nuestra comprobación también añadiremos la categoría. 
	FROM film as f
    INNER JOIN film_category as fc
    USING (film_id)
    INNER JOIN category as cat  -- Debemos hacer 2 joins para poder llegar al nombre de la categoría. 
    USING (category_id)
    WHERE cat.name= "Family"; -- En este caso, no es necesario usar GROUP BY ni HAVING, porque solo estamos buscando películas en una categoría específica sin realizar agrupaciones ni contabilizar nada. 

-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.

SELECT a.first_name as nombre_act, a.last_name as apellido_act
	FROM actor as a
    INNER JOIN film_actor as fa
    USING (actor_id)
    GROUP BY a.first_name, a.last_name
    HAVING COUNT(fa.film_id) > 10;  -- Debemos contar el film_id porque si contamos el actor_id nos aparecerán actores que tengan un if mayor que 10 y si no aplicamos el count no se contarán
									-- el total de películas donde aparecen. Hacemos un HAVING porque realizamos este conteo tras agrupar a los actores y actrices. 
                                    
-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film. 

SELECT title as título, length as duración, rating as clasificación 
	FROM film as f
    WHERE length = 120 -- Hemos traducido las horas a minutos tal y como está en la tabla de film y en la columna de length. 
    AND rating LIKE "%R%"; -- Debemos usar el AND porque el enunciado nos pide que se cumplan ambas condiciones.  
    
-- Tras haber solucionado el ejercicio, descubrimos que R es = a Restricted (películas para mayores de 18). Así que ahora podemos resolver el ejercicio igualando directamente, sin patrones. 

SELECT title as título, length as duración, rating as clasificación 
	FROM film as f
    WHERE length = 120 -- Hemos traducido las horas a minutos tal y como está en la tabla de film y en la columna de length. 
    AND rating = "R"; -- Igualamos directamente sin patrones. 

-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.

SELECT cat.name as nombre_cat, AVG(length) as duración 
	FROM film as f
    INNER JOIN film_category
    USING (film_id)
    INNER JOIN category as cat
    USING (category_id)
    GROUP BY cat.name
    HAVING AVG(f.length) > 120; -- Si no añadimos esta condición tras la agrupación del GROUP BY, no sabremos la media de duración. 

-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.

SELECT a.first_name as nombre_act, a.last_name as apellido_act, COUNT(f.film_id) as núm_pelis
	FROM actor as a
    INNER JOIN film_actor as fa
    USING (actor_id)
    INNER JOIN film as f
    USING (film_id)
    GROUP BY a.first_name, a.last_name
    HAVING COUNT(f.film_id) >= 5; -- Añadimos la condición tras agrupar ya que necesitamos saber cuántos atcores/actrices tenemos en total para saber quiénes de todos aparecen en 5 o más pelis. 

-- 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. 
-- Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.

SELECT title as título -- Esta es nuestra query madre. 
	FROM films;
    
-- Necesitamos la info de las fechas que ya tenemos en la tabla film (tabla madre) pero también necesitamos la "inventory" para saber qué películas están alquiladas. 
-- Una vez hagamos este JOIN necesitamos el rental_date y el return date de la tabla rental sea mayor que 5. Para esto, necesitamos hacer una resta de ambas fechas con el método DATEDIFF. 
    
SELECT i.film_id
	FROM rental as r 
	INNER JOIN inventory as i
	USING(inventory_id)
	WHERE DATEDIFF(r.return_date, r.rental_date) > 5;
    
    -- Ahora ya podemos unir nuestras dos queries con el WHERE y el id_ de las películas. 
    
    SELECT f.title as título
    FROM film as f
    WHERE f.film_id IN (
						SELECT i.film_id
                        FROM rental as r 
                        INNER JOIN inventory as i
                        USING(inventory_id)
                        WHERE DATEDIFF(r.return_date, r.rental_date) > 5
                        );


-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". 
-- Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.

-- Esta es nuestra query madre: 

SELECT actor_id as núm_act, first_name as nombre_act, last_name as apellido_act
	FROM actor; 
    
-- Esta es nuestra subquery: 

SELECT a.actor_id -- Al usar el act_id en la subquery, nos aseguramos de que ese actor no haya actuado en NINGUNA película de la categoría "Horror".
	FROM actor as a -- Y debemos hacer 5 joins para poder llegar a la categoría "Horror". 
	INNER JOIN film_actor as fa
	USING (actor_id)
	INNER JOIN film as f
	USING (film_id)
	INNER JOIN film_category as fc
	USING (film_id)
	INNER JOIN category as cat
	USING (category_id)
	WHERE name = "Horror"; 
                                        
SELECT actor_id as núm_act, first_name as nombre_act, last_name as apellido_act 
    FROM actor as a
    WHERE a.actor_id NOT IN (
					SELECT a.actor_id
					FROM actor as a
					INNER JOIN film_actor
					USING (actor_id)
					INNER JOIN film as f
					USING (film_id)
					INNER JOIN film_category as fc
					USING (film_id)
					INNER JOIN category as cat
					USING (category_id)
					WHERE name = "Horror"
                    ); 
                

-- 24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.

SELECT f.title as título, cat.name as nombre_categoría
	FROM film as f
	INNER JOIN film_category as fc 
    USING (film_id)
	INNER JOIN category as cat 
    USING (category_id)
	WHERE cat.name = "COMEDY" AND f.length > 180 
	GROUP BY f.title;

-- 25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. 
-- La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos.


 SELECT a1.actor_id as núm_act_1, a1.first_name as nombre_act_1,a1.last_name as apellido_act_1 , a2.actor_id as núm_act_2,a2.first_name as nombre_act_2,a2.last_name as apellido_act_2,COUNT(film_id) as núm_pelis_juntxs
	FROM actor as a
    INNER JOIN film_actor as fa
    USING (actor_id)
    INNER JOIN film as f
    USING (film_id) 
    GROUP BY a1.act_id, a2.act_id
    HAVING núm_pelis_juntxs > 0
    ORDER BY núm_pelis_juntxs DESC; -- Me rindo... :( 
    
 
 
 
 
 
 