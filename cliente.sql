
postgres=# \c clientes
Ahora está conectado a la base de datos «clientes» con el usuario «postgres».
clientes=# BEGIN TRANSACTION;
BEGIN
clientes=*# INSERT INTO compra (id,cliente_id,fecha) VALUES (33,1,current_date);
INSERT 0 1
clientes=*# INSERT INTO detalle_compra (id,producto_id,compra_id,cantidad) VALUES (43,9,33,5);
INSERT 0 1
clientes=*# UPDATE producto SET stock = stock - 5 WHERE id = 9;
ERROR:  el nuevo registro para la relación «producto» viola la restricción «check» «stock_valido»
DETALLE:  La fila que falla contiene (9, producto9, -1, 4219).
clientes=!# ROLLBACK;
ROLLBACK
clientes=# BEGIN TRANSACTION;
BEGIN
clientes=*# INSERT INTO compra (id,cliente_id,fecha) VALUES (33,2,current_date);
INSERT 0 1
clientes=*# INSERT INTO detalle_compra (id,producto_id,compra_id,cantidad) VALUES (43,1,33,3);
INSERT 0 1
clientes=*# UPDATE producto SET stock = stock - 3 WHERE id = 1;
UPDATE 1
clientes=*# 
clientes=*# INSERT INTO compra (id,cliente_id,fecha) VALUES (34,2,current_date);
INSERT 0 1
clientes=*# INSERT INTO detalle_compra (id,producto_id,compra_id,cantidad) VALUES (44,2,34,3);
INSERT 0 1
clientes=*# UPDATE producto SET stock = stock - 3 WHERE id = 2;
UPDATE 1
clientes=*# 
clientes=*# INSERT INTO compra (id,cliente_id,fecha) VALUES (35,2,current_date);
INSERT 0 1
clientes=*# INSERT INTO detalle_compra (id,producto_id,compra_id,cantidad) VALUES (45,8,35,3);
INSERT 0 1
clientes=*# UPDATE producto SET stock = stock - 3 WHERE id = 8;
ERROR:  el nuevo registro para la relación «producto» viola la restricción «check» «stock_valido»
DETALLE:  La fila que falla contiene (8, producto8, -3, 8923).
clientes=!#
clientes=!# ROLLBACK;
ROLLBACK
clientes=#
clientes=# SELECT * FROM producto;
 id | descripcion | stock | precio
----+-------------+-------+--------
  3 | producto3   |     9 |   9449
  4 | producto4   |     8 |    194
  5 | producto5   |    10 |   3764
  6 | producto6   |     6 |   8655
  7 | producto7   |     4 |   2875
 10 | producto10  |     1 |   3001
 11 | producto11  |     9 |   7993
 12 | producto12  |     3 |   8504
 13 | producto13  |    10 |   2415
 14 | producto14  |     5 |   3824
 15 | producto15  |    10 |   7358
 16 | producto16  |     7 |   3631
 17 | producto17  |     3 |   4467
 18 | producto18  |     2 |   9383
 19 | producto19  |     6 |   1140
 20 | producto20  |     4 |    102
  9 | producto9   |     4 |   4219
  1 | producto1   |     6 |   9107
  2 | producto2   |     5 |   1760
  8 | producto8   |     0 |   8923
(20 filas)


clientes=# \echo :AUTOCOMMIT
on
clientes=# \set AUTOCOMMIT off
clientes=# INSERT INTO cliente (id,nombre,email) VALUES (11,'usuario_nuevo','usuario_nuevo@gmail.com');
INSERT 0 1
clientes=*# SELECT * FROM cliente WHERE id = 11;
 id |  nombre   |        email
----+-----------+---------------------
 11 | usuario_nuevo | usuario_nuevo@gmail.com
(1 fila)

clientes=*# ROLLBACK;
ROLLBACK
clientes=# SELECT * FROM cliente WHERE id = 11;
 id | nombre | email
----+--------+-------
(0 filas)

clientes=*# \set AUTOCOMMIT on

-- codigo limpio 
--2
BEGIN TRANSACTION;
INSERT INTO compra (id,cliente_id,fecha) VALUES (33,1,current_date);
INSERT INTO detalle_compra (id,producto_id,compra_id,cantidad) VALUES (43,9,33,5);
UPDATE producto SET stock = stock - 5 WHERE id = 9;
ROLLBACK;
--3
BEGIN TRANSACTION;

INSERT INTO compra (id,cliente_id,fecha) VALUES (33,2,current_date);
INSERT INTO detalle_compra (id,producto_id,compra_id,cantidad) VALUES (43,1,33,3);
UPDATE producto SET stock = stock - 3 WHERE id = 1;

INSERT INTO compra (id,cliente_id,fecha) VALUES (34,2,current_date);
INSERT INTO detalle_compra (id,producto_id,compra_id,cantidad) VALUES (44,2,34,3);
UPDATE producto SET stock = stock - 3 WHERE id = 2;

INSERT INTO compra (id,cliente_id,fecha) VALUES (35,2,current_date);
INSERT INTO detalle_compra (id,producto_id,compra_id,cantidad) VALUES (45,8,35,3);
UPDATE producto SET stock = stock - 3 WHERE id = 8;

ROLLBACK;

SELECT * FROM producto;

--4
\echo :AUTOCOMMIT
\set AUTOCOMMIT off
INSERT INTO cliente (id,nombre,email) VALUES (11,'usuario_nuevo','usuario_nuevo@gmail.com');
SELECT * FROM cliente WHERE id = 11;
ROLLBACK
SELECT * FROM cliente WHERE id = 11;
\set AUTOCOMMIT on