USE Ventas_Tech_DB;

SELECT * FROM ventas;

--Consulta 1 — Resumen ejecutivo mensual. 
--Total facturado, cantidad de pedidos y ticket promedio, agrupados por mes. Calculá el total como cantidad * precio_unitario. Usá alias descriptivos en español y agrupá por mes con EXTRACT(MONTH FROM fecha_venta).
SELECT
SUM (precio_unitario*cantidad) AS total_facturado,
Count (*) AS cantidad_pedidos,
AVG (precio_unitario*cantidad) AS ticket_promedio,
MONTH (fecha_venta) AS mes
FROM ventas
GROUP BY MONTH (fecha_venta);

--Consulta 2 — Ranking de productos
SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(precio_unitario * cantidad) AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY total_generado DESC;

--Consulta 3 — Clientes recurrentes
SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(precio_unitario * cantidad) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;

--Consulta 4 — Meses por encima/por debajo del promedio
SELECT
    mes,
    total_facturado,
    CASE
        WHEN total_facturado > promedio_mensual
            THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM (
    SELECT
        MONTH(fecha_venta) AS mes,
        SUM(precio_unitario * cantidad) AS total_facturado,
        AVG(SUM(precio_unitario * cantidad)) OVER () AS promedio_mensual
    FROM ventas
    GROUP BY MONTH(fecha_venta)
) AS resumen_mensual;

/*
HALLAZGOS:

*En cuanto a los productos:
El producto 1 fue el principal generador de facturación, con un total de $3.600, lo que representa el 55,86% de la facturación total que fue de $6.444. Esto significa que, por sí solo, concentra más de la mitad de la facturación analizada.

Asimismo es pertinente destacar que el producto 2 ocupa el quinto lugar del ranking de facturación, con un total generado de $364. A pesar de haber vendido 13 unidades, su contribución a la facturación total fue relativamente baja, representando aproximadamente el 5,65% del total. Esto puede explicarse principalmente por su bajo precio unitario de $28.

*En cuanto a los clientes:
Podemos decir que hay una cantidad de pedidos bastante pareja en terminos de clientes siendo que del total de clientes que se tuvo en el mes que fue de 5, cada cliente realizo un total de 2 pedidos. Lo destacable aqui es que el cliente 1 fue quien mas gasto con un total de $2640, seguido por el cliente 5 con un total de $2100, en tercer lugar se encuentra el cliente 3 con $674 gastados, seguido por el cliente 2 con $520  siendo el cliente que menos gasto el cliente 4 con un total gastado de $510.

*En cuanto al total facturado en el mes:
Podemos concluir que el total facturado fue de $6444 lo que se encuentra por debajo del promedio normal de facturacion.
*/