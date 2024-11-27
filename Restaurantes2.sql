-- MariaDB dump 10.19  Distrib 10.5.22-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: RESTAUR
-- ------------------------------------------------------
-- Server version	10.5.22-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `CATEGORIAS`
--

DROP TABLE IF EXISTS `CATEGORIAS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CATEGORIAS` (
  `idCategoria` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`idCategoria`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CATEGORIAS`
--

LOCK TABLES `CATEGORIAS` WRITE;
/*!40000 ALTER TABLE `CATEGORIAS` DISABLE KEYS */;
INSERT INTO `CATEGORIAS` VALUES (1,'Rollo Frío'),(2,'Rollo Caliente'),(3,'Entrante'),(4,'Postre');
/*!40000 ALTER TABLE `CATEGORIAS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CLIENTES`
--

DROP TABLE IF EXISTS `CLIENTES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CLIENTES` (
  `idCliente` int(11) NOT NULL AUTO_INCREMENT,
  `idPuntos` int(11) NOT NULL DEFAULT 0,
  `idUsuario` int(11) NOT NULL,
  `idStatus` int(11) NOT NULL DEFAULT 1,
  `nombre` varchar(50) NOT NULL,
  `apellido` varchar(50) NOT NULL,
  `correo` varchar(100) NOT NULL,
  PRIMARY KEY (`idCliente`),
  UNIQUE KEY `correo` (`correo`),
  KEY `idUsuario` (`idUsuario`),
  KEY `idPuntos` (`idPuntos`),
  KEY `idStatus` (`idStatus`),
  CONSTRAINT `CLIENTES_ibfk_1` FOREIGN KEY (`idUsuario`) REFERENCES `USUARIOS_RESTAURANTE` (`idUsuario`),
  CONSTRAINT `CLIENTES_ibfk_2` FOREIGN KEY (`idPuntos`) REFERENCES `PUNTOS_CLIENTES` (`idPuntos`),
  CONSTRAINT `CLIENTES_ibfk_3` FOREIGN KEY (`idStatus`) REFERENCES `STATUS_CLIENTES` (`idStatus`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CLIENTES`
--

LOCK TABLES `CLIENTES` WRITE;
/*!40000 ALTER TABLE `CLIENTES` DISABLE KEYS */;
INSERT INTO `CLIENTES` VALUES (1,1,5,1,'Juan','Pérez','juan.perez@email.com'),(2,2,6,1,'María','López','maria.lopez@email.com'),(3,3,7,2,'Carlos','Gómez','carlos.gomez@email.com'),(4,4,8,1,'Ana','Martínez','ana.martinez@email.com'),(5,5,9,2,'Luis','Sánchez','luis.sanchez@email.com');
/*!40000 ALTER TABLE `CLIENTES` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DETALLESPEDIDO`
--

DROP TABLE IF EXISTS `DETALLESPEDIDO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DETALLESPEDIDO` (
  `idPedido` int(11) NOT NULL,
  `idPlatillo` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  PRIMARY KEY (`idPedido`,`idPlatillo`),
  KEY `idPlatillo` (`idPlatillo`),
  CONSTRAINT `DETALLESPEDIDO_ibfk_1` FOREIGN KEY (`idPedido`) REFERENCES `PEDIDOS` (`idPedido`),
  CONSTRAINT `DETALLESPEDIDO_ibfk_2` FOREIGN KEY (`idPlatillo`) REFERENCES `PLATILLOS` (`idPlatillo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DETALLESPEDIDO`
--

LOCK TABLES `DETALLESPEDIDO` WRITE;
/*!40000 ALTER TABLE `DETALLESPEDIDO` DISABLE KEYS */;
INSERT INTO `DETALLESPEDIDO` VALUES (1,1,2,50.00),(1,2,1,150.00),(2,3,2,100.00),(2,4,1,200.00),(3,5,1,150.00),(3,6,3,100.00),(4,7,2,150.00),(5,8,2,130.00),(5,9,1,180.00),(6,10,3,90.00),(7,11,1,70.00);
/*!40000 ALTER TABLE `DETALLESPEDIDO` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER CalcularTotalPedido
AFTER INSERT ON DETALLESPEDIDO
FOR EACH ROW
BEGIN 
    UPDATE PEDIDOS 
    SET total_suma = total_suma + 
        (SELECT precio
        FROM PLATILLOS p 
        WHERE p.idPlatillo = NEW.idPlatillo)
        WHERE idPedido = NEW.idPedido;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `DETALLES_METODOPAGOS`
--

DROP TABLE IF EXISTS `DETALLES_METODOPAGOS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DETALLES_METODOPAGOS` (
  `idDetalleMetodoPago` int(11) NOT NULL AUTO_INCREMENT,
  `num_tarjeta` varchar(255) DEFAULT NULL,
  `fecha_expiracion` date DEFAULT NULL,
  PRIMARY KEY (`idDetalleMetodoPago`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DETALLES_METODOPAGOS`
--

LOCK TABLES `DETALLES_METODOPAGOS` WRITE;
/*!40000 ALTER TABLE `DETALLES_METODOPAGOS` DISABLE KEYS */;
INSERT INTO `DETALLES_METODOPAGOS` VALUES (1,'1234567812345678','2025-12-31'),(2,'2345678923456789','2024-10-31'),(3,'3456789034567890','2026-05-31');
/*!40000 ALTER TABLE `DETALLES_METODOPAGOS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DIRECCIONES_CLIENTE`
--

DROP TABLE IF EXISTS `DIRECCIONES_CLIENTE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DIRECCIONES_CLIENTE` (
  `iddireccion` int(11) NOT NULL AUTO_INCREMENT,
  `idCliente` int(11) NOT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`iddireccion`),
  KEY `idCliente` (`idCliente`),
  CONSTRAINT `DIRECCIONES_CLIENTE_ibfk_1` FOREIGN KEY (`idCliente`) REFERENCES `CLIENTES` (`idCliente`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DIRECCIONES_CLIENTE`
--

LOCK TABLES `DIRECCIONES_CLIENTE` WRITE;
/*!40000 ALTER TABLE `DIRECCIONES_CLIENTE` DISABLE KEYS */;
INSERT INTO `DIRECCIONES_CLIENTE` VALUES (1,1,'Calle Falsa 123, Ciudad, CP 12345'),(2,2,'Av. Siempre Viva 456, Ciudad, CP 67890'),(3,3,'Boulevard de los Héroes 789, Ciudad, CP 11223'),(4,4,'Paseo de la Reforma 101, Ciudad, CP 33445'),(5,5,'Plaza Mayor 202, Ciudad, CP 55667');
/*!40000 ALTER TABLE `DIRECCIONES_CLIENTE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `InfoUsuario`
--

DROP TABLE IF EXISTS `InfoUsuario`;
/*!50001 DROP VIEW IF EXISTS `InfoUsuario`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `InfoUsuario` AS SELECT
 1 AS `idUsuario`,
  1 AS `nombre_usuario`,
  1 AS `password`,
  1 AS `nombre` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `ListaPlatillos`
--

DROP TABLE IF EXISTS `ListaPlatillos`;
/*!50001 DROP VIEW IF EXISTS `ListaPlatillos`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `ListaPlatillos` AS SELECT
 1 AS `idPlatillo`,
  1 AS `nombre`,
  1 AS `imagen_URL`,
  1 AS `precio`,
  1 AS `descripcion`,
  1 AS `inventario`,
  1 AS `idCategoria` */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `METODOPAGOS`
--

DROP TABLE IF EXISTS `METODOPAGOS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `METODOPAGOS` (
  `idMetodoPago` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_metodo` varchar(255) DEFAULT NULL,
  `idCliente` int(11) NOT NULL,
  `idDetalleMetodoPago` int(11) DEFAULT NULL,
  PRIMARY KEY (`idMetodoPago`),
  KEY `idDetalleMetodoPago` (`idDetalleMetodoPago`),
  KEY `idCliente` (`idCliente`),
  CONSTRAINT `METODOPAGOS_ibfk_1` FOREIGN KEY (`idDetalleMetodoPago`) REFERENCES `DETALLES_METODOPAGOS` (`idDetalleMetodoPago`),
  CONSTRAINT `METODOPAGOS_ibfk_2` FOREIGN KEY (`idCliente`) REFERENCES `CLIENTES` (`idCliente`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `METODOPAGOS`
--

LOCK TABLES `METODOPAGOS` WRITE;
/*!40000 ALTER TABLE `METODOPAGOS` DISABLE KEYS */;
INSERT INTO `METODOPAGOS` VALUES (1,'Visa',1,1),(2,'MasterCard',2,2),(3,'American Express',3,NULL),(4,'Discover',4,3),(5,'Efectivo',5,NULL);
/*!40000 ALTER TABLE `METODOPAGOS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PEDIDOS`
--

DROP TABLE IF EXISTS `PEDIDOS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PEDIDOS` (
  `idPedido` int(11) NOT NULL AUTO_INCREMENT,
  `fecha_pedido` date NOT NULL,
  `fecha_entrega` date DEFAULT NULL,
  `total_pedido` decimal(10,2) NOT NULL,
  `idCliente` int(11) NOT NULL,
  `idStatus` int(11) NOT NULL,
  PRIMARY KEY (`idPedido`),
  KEY `idCliente` (`idCliente`),
  KEY `idStatus` (`idStatus`),
  CONSTRAINT `PEDIDOS_ibfk_1` FOREIGN KEY (`idCliente`) REFERENCES `CLIENTES` (`idCliente`),
  CONSTRAINT `PEDIDOS_ibfk_2` FOREIGN KEY (`idStatus`) REFERENCES `STATUS_PEDIDO` (`idStatus`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PEDIDOS`
--

LOCK TABLES `PEDIDOS` WRITE;
/*!40000 ALTER TABLE `PEDIDOS` DISABLE KEYS */;
INSERT INTO `PEDIDOS` VALUES (1,'2024-11-01','2024-11-02',250.00,2,1),(2,'2024-11-02','2024-11-03',300.00,2,2),(3,'2024-11-03','2024-11-04',150.00,3,3),(4,'2024-11-04','2024-11-05',200.00,4,1),(5,'2024-11-05','2024-11-06',180.00,4,1),(6,'2024-11-06','2024-11-07',220.00,5,2),(7,'2024-11-07','2024-11-08',270.00,5,1);
/*!40000 ALTER TABLE `PEDIDOS` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER BloquearCambioPedidoCompletado
BEFORE INSERT ON PEDIDOS
FOR EACH ROW
BEGIN
    IF NEW.idStatus = 2 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El pedido ya no se puede modificar.';
        END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `PLATILLOS`
--

DROP TABLE IF EXISTS `PLATILLOS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PLATILLOS` (
  `idPlatillo` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `imagen_URL` text NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `inventario` int(11) DEFAULT NULL,
  `idCategoria` int(11) DEFAULT NULL,
  PRIMARY KEY (`idPlatillo`),
  KEY `idCategoria` (`idCategoria`),
  CONSTRAINT `PLATILLOS_ibfk_1` FOREIGN KEY (`idCategoria`) REFERENCES `CATEGORIAS` (`idCategoria`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PLATILLOS`
--

LOCK TABLES `PLATILLOS` WRITE;
/*!40000 ALTER TABLE `PLATILLOS` DISABLE KEYS */;
INSERT INTO `PLATILLOS` VALUES (1,'Tostada de Atún','https://media-cdn.tripadvisor.com/media/photo-s/18/84/96/2b/tostada-de-atun-fresco.jpg',100.00,'Aleta azul, aioli de búfalo, aguacate, cilantro',20,1),(2,'Tostada de Hamachi Aji','https://www.foodgal.com/wp-content/uploads/2022/10/Juniper-Ivy-hamachi-tostada.jpg',120.00,'Yuzu-soya, aji amarillo, mayo ajo tatemado, cebollín, furakake shiso',0,1),(3,'Batera de Toro','https://losarrocesdekiko.com/wp-content/uploads/2022/04/Rabo-de-toro--scaled.jpg',140.00,'Aleta azul, yuzu-aioli, aguacate, aji amarillo',10,1),(4,'Batera de Salmón','https://media-cdn.tripadvisor.com/media/photo-s/1d/3f/0b/0e/batera-de-salmao.jpg',130.00,'Salmón, aioli habanero, lemon soy, cebollín, cilantro criollo',18,1),(5,'Tarta de Toro','https://cdn7.kiwilimon.com/recetaimagen/29776/960x720/31682.jpg.webp',150.00,'Aleta azul, vinagreta yuzu-trufa',12,1),(6,'Edamame','https://misssushi.es/wp-content/uploads/edamame.jpg',80.00,'Sal Maldon, salsa negra, polvo piquín',0,2),(7,'Shishitos','https://www.justonecookbook.com/wp-content/uploads/2022/08/Blistered-Shishito-Peppers-With-Ginger-Soy-Sauce-9223-II.jpg',90.00,'Sal Maldon, limón california',20,2),(8,'Papás Fritas','https://kodamasushi.cl/wp-content/uploads/2019/08/papas-fritas-touri-sushi02.jpg',70.00,'Sal matcha, soya-trufa',30,2),(9,'Camarones Roca','https://i0.wp.com/cucharamia.com/wp-content/uploads/2021/07/camarones-roca.jpg?w=798&ssl=1',180.00,'Soya dulce, mayo-picante, ajonjolí',15,2),(10,'Jalapeño Poppers','https://www.recipetineats.com/tachyon/2024/02/Jalapeno-poppers_2.jpg?resize=1200%2C1500&zoom=0.54',160.00,'Cangrejo, atún aleta azul, queso feta, soya-yuzu',25,2),(11,'Huachinango Tempura','https://tofuu.getjusto.com/orioneat-local/resized2/rcgzQe2pLxFQT8Ghw-800-x.webp',200.00,'Sal Maldon, salsa negra, polvo piquín',18,2);
/*!40000 ALTER TABLE `PLATILLOS` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER NoStockProducto
BEFORE INSERT ON PLATILLOS
FOR EACH ROW
BEGIN 
    IF NEW.inventario < 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No hay inventario suficiente de ese producto, hay que hacer stock.';
        END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER NoStockProductoDeshabilitado 
AFTER DELETE ON PLATILLOS
FOR EACH ROW
BEGIN
    DELETE FROM inventario
    WHERE inventario = 0;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `PROMOCIONES`
--

DROP TABLE IF EXISTS `PROMOCIONES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PROMOCIONES` (
  `idPromocion` int(11) NOT NULL AUTO_INCREMENT,
  `idTipoPromocion` int(11) NOT NULL,
  `idPlatillo` int(11) NOT NULL,
  `descuento` decimal(5,2) NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `descripcion` varchar(255) NOT NULL,
  PRIMARY KEY (`idPromocion`),
  KEY `idTipoPromocion` (`idTipoPromocion`),
  KEY `idPlatillo` (`idPlatillo`),
  CONSTRAINT `PROMOCIONES_ibfk_1` FOREIGN KEY (`idTipoPromocion`) REFERENCES `TIPOSPROMOCION` (`idTipoPromocion`),
  CONSTRAINT `PROMOCIONES_ibfk_2` FOREIGN KEY (`idPlatillo`) REFERENCES `PLATILLOS` (`idPlatillo`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PROMOCIONES`
--

LOCK TABLES `PROMOCIONES` WRITE;
/*!40000 ALTER TABLE `PROMOCIONES` DISABLE KEYS */;
INSERT INTO `PROMOCIONES` VALUES (1,1,1,15.00,'2024-06-01','2024-06-30','Descuento del 15% en todos los rollos fríos para celebrar el verano.'),(2,1,2,15.00,'2024-06-01','2024-06-30','Descuento del 15% en Tostada de Hamachi Aji durante el verano.'),(3,1,3,15.00,'2024-06-01','2024-06-30','Descuento del 15% en Batera de Toro para refrescarte este verano.'),(4,2,4,20.00,'2024-11-25','2024-11-30','Descuento del 20% en Tostada de Salmón por Black Friday.'),(5,2,5,20.00,'2024-11-25','2024-11-30','Descuento del 20% en Tartar de Toro durante Black Friday.'),(6,2,6,20.00,'2024-11-25','2024-11-30','Descuento del 20% en Edamame para el Black Friday.'),(7,3,7,10.00,'2024-12-01','2024-12-25','Descuento del 10% en Camarones Roca para celebrar la Navidad.'),(8,3,8,10.00,'2024-12-01','2024-12-25','Descuento del 10% en Papás Fritas durante Navidad.'),(9,3,9,10.00,'2024-12-01','2024-12-25','Descuento del 10% en Jalapeño Poppers por Navidad.'),(10,4,10,25.00,'2024-10-01','2024-10-31','Descuento del 25% en todos los platillos por el Día del Cliente.'),(11,4,11,25.00,'2024-10-01','2024-10-31','Descuento del 25% en Huachinango Tempura por el Día del Cliente.');
/*!40000 ALTER TABLE `PROMOCIONES` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER NotificarPromocionExpirada
BEFORE INSERT ON PROMOCIONES
FOR EACH ROW
BEGIN 
    IF NEW.fecha_inicio >= '2024-06-01' AND NEW.fecha_inicio <= '2024-11-30' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La promoción ya ha expirado.';
        END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `PUNTOS_CLIENTES`
--

DROP TABLE IF EXISTS `PUNTOS_CLIENTES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PUNTOS_CLIENTES` (
  `idPuntos` int(11) NOT NULL AUTO_INCREMENT,
  `cant_puntos` int(11) NOT NULL,
  PRIMARY KEY (`idPuntos`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PUNTOS_CLIENTES`
--

LOCK TABLES `PUNTOS_CLIENTES` WRITE;
/*!40000 ALTER TABLE `PUNTOS_CLIENTES` DISABLE KEYS */;
INSERT INTO `PUNTOS_CLIENTES` VALUES (1,100),(2,150),(3,200),(4,50),(5,75);
/*!40000 ALTER TABLE `PUNTOS_CLIENTES` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER ActualizarPuntosCliente
BEFORE UPDATE ON PUNTOS_CLIENTES 
FOR EACH ROW
BEGIN
    UPDATE CLIENTES
    SET cant_puntos = cant_puntos + (NEW.cant_puntos - OLD.cant_puntos)
    WHERE idPuntos = NEW.idPuntos;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary table structure for view `PlatillosDisponibles_vw`
--

DROP TABLE IF EXISTS `PlatillosDisponibles_vw`;
/*!50001 DROP VIEW IF EXISTS `PlatillosDisponibles_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `PlatillosDisponibles_vw` AS SELECT
 1 AS `idPlatillo`,
  1 AS `nombre`,
  1 AS `imagen_URL`,
  1 AS `precio`,
  1 AS `descripcion`,
  1 AS `inventario`,
  1 AS `idCategoria` */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `RESENAS`
--

DROP TABLE IF EXISTS `RESENAS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `RESENAS` (
  `idResena` int(11) NOT NULL AUTO_INCREMENT,
  `puntuacion` int(11) NOT NULL,
  `titulo` varchar(50) NOT NULL,
  `comentario` text NOT NULL,
  `fecha_comentario` date NOT NULL,
  `idCliente` int(11) NOT NULL,
  `idTipoResena` int(11) NOT NULL,
  `idPedido` int(11) DEFAULT NULL,
  PRIMARY KEY (`idResena`),
  KEY `idCliente` (`idCliente`),
  KEY `idPedido` (`idPedido`),
  KEY `idTipoResena` (`idTipoResena`),
  CONSTRAINT `RESENAS_ibfk_1` FOREIGN KEY (`idCliente`) REFERENCES `CLIENTES` (`idCliente`),
  CONSTRAINT `RESENAS_ibfk_2` FOREIGN KEY (`idPedido`) REFERENCES `PEDIDOS` (`idPedido`),
  CONSTRAINT `RESENAS_ibfk_3` FOREIGN KEY (`idTipoResena`) REFERENCES `TIPOS_RESENA` (`idTipoResena`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RESENAS`
--

LOCK TABLES `RESENAS` WRITE;
/*!40000 ALTER TABLE `RESENAS` DISABLE KEYS */;
INSERT INTO `RESENAS` VALUES (1,5,'Increíble experiencia','Excelente ambiente, atención de primera y los platillos deliciosos. Sin duda volveré.','2024-11-15',2,2,2),(2,4,'Buen servicio','El servicio fue bueno, pero la comida estuvo un poco más salada de lo que esperaba.','2024-11-16',2,2,1),(3,3,'Regular','El lugar es bonito, pero el servicio fue lento y algunos platillos no estaban disponibles.','2024-11-17',3,1,NULL),(4,5,'Espectacular platillo','El Tartar de Toro es espectacular, fresco y con un sabor único.','2024-11-18',4,2,4),(5,4,'Delicioso Edamame','El Edamame estuvo delicioso, aunque podría mejorar la presentación.','2024-11-19',5,2,6),(6,5,'Recomendado','Las Tostadas de Atún fueron una maravilla, todo en su punto perfecto. ¡Altamente recomendable!','2024-11-20',5,2,7);
/*!40000 ALTER TABLE `RESENAS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RESERVAS`
--

DROP TABLE IF EXISTS `RESERVAS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `RESERVAS` (
  `idReserva` int(11) NOT NULL AUTO_INCREMENT,
  `fecha_reserva` date NOT NULL,
  `hora_reserva` time NOT NULL,
  `num_personas` int(11) NOT NULL,
  `idStatus` int(11) NOT NULL,
  `tema` varchar(100) DEFAULT NULL,
  `idCliente` int(11) NOT NULL,
  PRIMARY KEY (`idReserva`),
  KEY `idStatus` (`idStatus`),
  KEY `idCliente` (`idCliente`),
  CONSTRAINT `RESERVAS_ibfk_1` FOREIGN KEY (`idStatus`) REFERENCES `STATUS_RESERVAS` (`idStatus`),
  CONSTRAINT `RESERVAS_ibfk_2` FOREIGN KEY (`idCliente`) REFERENCES `CLIENTES` (`idCliente`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RESERVAS`
--

LOCK TABLES `RESERVAS` WRITE;
/*!40000 ALTER TABLE `RESERVAS` DISABLE KEYS */;
INSERT INTO `RESERVAS` VALUES (1,'2024-11-20','19:00:00',4,1,'Reunión de trabajo',1),(2,'2024-12-25','13:30:00',2,2,'Comida de navidad',2),(3,'2024-11-30','18:00:00',6,3,'Cena con amigos',3),(4,'2024-12-01','20:00:00',3,1,'Cena familiar',4),(5,'2024-08-15','14:00:00',5,3,'Reunión de equipo',5),(6,'2023-09-10','12:00:00',2,2,'Comida de trabajo',5);
/*!40000 ALTER TABLE `RESERVAS` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER ValidarFechaReserva
BEFORE INSERT ON RESERVAS
FOR EACH ROW
BEGIN
    IF NEW.fecha_reserva < '2024-11-30' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'La reserva ha expirado.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `RESTAURANTES`
--

DROP TABLE IF EXISTS `RESTAURANTES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `RESTAURANTES` (
  `idRestaurante` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_sucursal` varchar(255) DEFAULT NULL,
  `ubicacion` text DEFAULT NULL,
  `telefono` varchar(20) NOT NULL,
  `descripcion` text DEFAULT NULL,
  PRIMARY KEY (`idRestaurante`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RESTAURANTES`
--

LOCK TABLES `RESTAURANTES` WRITE;
/*!40000 ALTER TABLE `RESTAURANTES` DISABLE KEYS */;
INSERT INTO `RESTAURANTES` VALUES (1,'Sucursal Valle Oriente','Av. Gonzalitos 123, Col. Valle Oriente, Monterrey, N.L.','81-1234-5678','Se trata de una sucursal moderna con un ambiente acogedor, ideal para cenas familiares y reuniones de negocios.'),(2,'Sucursal Centro','Paseo Santa Lucía 456, Col. Centro, Monterrey, N.L.','81-2345-6789','Ubicada en el corazón de Monterrey, ofrece una experiencia gastronómica única con sabores frescos y auténticos.'),(3,'Sucursal Carretera Nacional','Carretera Nacional 789, Col. Cumbres, Monterrey, N.L.','81-3456-7890','Ofrece un espacio amplio y cómodo, ideal para disfrutar de un almuerzo en familia o una cena con amigos.');
/*!40000 ALTER TABLE `RESTAURANTES` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ROLES`
--

DROP TABLE IF EXISTS `ROLES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ROLES` (
  `idRol` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`idRol`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ROLES`
--

LOCK TABLES `ROLES` WRITE;
/*!40000 ALTER TABLE `ROLES` DISABLE KEYS */;
INSERT INTO `ROLES` VALUES (1,'cliente'),(2,'admin'),(3,'staff');
/*!40000 ALTER TABLE `ROLES` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ROLES_STAFF`
--

DROP TABLE IF EXISTS `ROLES_STAFF`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ROLES_STAFF` (
  `idUsuario` int(11) NOT NULL,
  `idRolStaff` int(11) NOT NULL,
  KEY `idUsuario` (`idUsuario`),
  KEY `idRolStaff` (`idRolStaff`),
  CONSTRAINT `ROLES_STAFF_ibfk_1` FOREIGN KEY (`idUsuario`) REFERENCES `USUARIOS_RESTAURANTE` (`idUsuario`),
  CONSTRAINT `ROLES_STAFF_ibfk_2` FOREIGN KEY (`idRolStaff`) REFERENCES `TIPOS_STAFF` (`idRolStaff`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ROLES_STAFF`
--

LOCK TABLES `ROLES_STAFF` WRITE;
/*!40000 ALTER TABLE `ROLES_STAFF` DISABLE KEYS */;
INSERT INTO `ROLES_STAFF` VALUES (5,1);
/*!40000 ALTER TABLE `ROLES_STAFF` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `STATUS_CLIENTES`
--

DROP TABLE IF EXISTS `STATUS_CLIENTES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `STATUS_CLIENTES` (
  `idStatus` int(11) NOT NULL AUTO_INCREMENT,
  `Status_Clientes` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`idStatus`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `STATUS_CLIENTES`
--

LOCK TABLES `STATUS_CLIENTES` WRITE;
/*!40000 ALTER TABLE `STATUS_CLIENTES` DISABLE KEYS */;
INSERT INTO `STATUS_CLIENTES` VALUES (1,'Activo'),(2,'Inactivo');
/*!40000 ALTER TABLE `STATUS_CLIENTES` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `STATUS_PEDIDO`
--

DROP TABLE IF EXISTS `STATUS_PEDIDO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `STATUS_PEDIDO` (
  `idStatus` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_status` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`idStatus`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `STATUS_PEDIDO`
--

LOCK TABLES `STATUS_PEDIDO` WRITE;
/*!40000 ALTER TABLE `STATUS_PEDIDO` DISABLE KEYS */;
INSERT INTO `STATUS_PEDIDO` VALUES (1,'Orden Recibida'),(2,'En Preparación'),(3,'Pedido Completo'),(4,'Cancelado');
/*!40000 ALTER TABLE `STATUS_PEDIDO` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `STATUS_RESERVAS`
--

DROP TABLE IF EXISTS `STATUS_RESERVAS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `STATUS_RESERVAS` (
  `idStatus` int(11) NOT NULL AUTO_INCREMENT,
  `Status_Reservas` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`idStatus`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `STATUS_RESERVAS`
--

LOCK TABLES `STATUS_RESERVAS` WRITE;
/*!40000 ALTER TABLE `STATUS_RESERVAS` DISABLE KEYS */;
INSERT INTO `STATUS_RESERVAS` VALUES (1,'Completada'),(2,'Pendiente'),(3,'Cancelada');
/*!40000 ALTER TABLE `STATUS_RESERVAS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TELEFONOS_CLIENTE`
--

DROP TABLE IF EXISTS `TELEFONOS_CLIENTE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TELEFONOS_CLIENTE` (
  `idtelefono` int(11) NOT NULL AUTO_INCREMENT,
  `idCliente` int(11) NOT NULL,
  `telefono` varchar(14) DEFAULT NULL,
  PRIMARY KEY (`idtelefono`),
  KEY `idCliente` (`idCliente`),
  CONSTRAINT `TELEFONOS_CLIENTE_ibfk_1` FOREIGN KEY (`idCliente`) REFERENCES `CLIENTES` (`idCliente`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TELEFONOS_CLIENTE`
--

LOCK TABLES `TELEFONOS_CLIENTE` WRITE;
/*!40000 ALTER TABLE `TELEFONOS_CLIENTE` DISABLE KEYS */;
INSERT INTO `TELEFONOS_CLIENTE` VALUES (1,1,'5551234567'),(2,2,'5552345678'),(3,4,'5553456789'),(4,3,'5554567890'),(5,5,'5555678901');
/*!40000 ALTER TABLE `TELEFONOS_CLIENTE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TIPOSPROMOCION`
--

DROP TABLE IF EXISTS `TIPOSPROMOCION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TIPOSPROMOCION` (
  `idTipoPromocion` int(11) NOT NULL AUTO_INCREMENT,
  `tipo_promocion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`idTipoPromocion`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TIPOSPROMOCION`
--

LOCK TABLES `TIPOSPROMOCION` WRITE;
/*!40000 ALTER TABLE `TIPOSPROMOCION` DISABLE KEYS */;
INSERT INTO `TIPOSPROMOCION` VALUES (1,'VeranoLoco'),(2,'Black Friday'),(3,'Navidad'),(4,'Día del Cliente');
/*!40000 ALTER TABLE `TIPOSPROMOCION` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TIPOS_RESENA`
--

DROP TABLE IF EXISTS `TIPOS_RESENA`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TIPOS_RESENA` (
  `idTipoResena` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`idTipoResena`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TIPOS_RESENA`
--

LOCK TABLES `TIPOS_RESENA` WRITE;
/*!40000 ALTER TABLE `TIPOS_RESENA` DISABLE KEYS */;
INSERT INTO `TIPOS_RESENA` VALUES (1,'Restaurante'),(2,'Platillo');
/*!40000 ALTER TABLE `TIPOS_RESENA` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TIPOS_STAFF`
--

DROP TABLE IF EXISTS `TIPOS_STAFF`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TIPOS_STAFF` (
  `idRolStaff` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_staff` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`idRolStaff`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TIPOS_STAFF`
--

LOCK TABLES `TIPOS_STAFF` WRITE;
/*!40000 ALTER TABLE `TIPOS_STAFF` DISABLE KEYS */;
INSERT INTO `TIPOS_STAFF` VALUES (1,'Gerente'),(2,'Mesero'),(3,'Cocinero'),(4,'Repartidor');
/*!40000 ALTER TABLE `TIPOS_STAFF` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USUARIOS_RESTAURANTE`
--

DROP TABLE IF EXISTS `USUARIOS_RESTAURANTE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `USUARIOS_RESTAURANTE` (
  `idUsuario` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_usuario` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `idRol` int(11) NOT NULL,
  PRIMARY KEY (`idUsuario`),
  KEY `idRol` (`idRol`),
  CONSTRAINT `USUARIOS_RESTAURANTE_ibfk_1` FOREIGN KEY (`idRol`) REFERENCES `ROLES` (`idRol`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USUARIOS_RESTAURANTE`
--

LOCK TABLES `USUARIOS_RESTAURANTE` WRITE;
/*!40000 ALTER TABLE `USUARIOS_RESTAURANTE` DISABLE KEYS */;
INSERT INTO `USUARIOS_RESTAURANTE` VALUES (1,'JuanGalvan','c7e616822f366fb1b5e0756af498cc11d2c0862edcb32ca65882f622ff39de1b',2),(2,'FernandoOlivares','c7e616822f366fb1b5e0756af498cc11d2c0862edcb32ca65882f622ff39de1b',2),(3,'PamelaRodriguez','c7e616822f366fb1b5e0756af498cc11d2c0862edcb32ca65882f622ff39de1b',2),(4,'EstefaniaNajera','c7e616822f366fb1b5e0756af498cc11d2c0862edcb32ca65882f622ff39de1b',2),(5,'JuanPe','c7e616822f366fb1b5e0756af498cc11d2c0862edcb32ca65882f622ff39de1b',3),(6,'MariaLo','c7e616822f366fb1b5e0756af498cc11d2c0862edcb32ca65882f622ff39de1b',1),(7,'CarlosGo','c7e616822f366fb1b5e0756af498cc11d2c0862edcb32ca65882f622ff39de1b',1),(8,'AnaMar','c7e616822f366fb1b5e0756af498cc11d2c0862edcb32ca65882f622ff39de1b',1),(9,'LuisSa','c7e616822f366fb1b5e0756af498cc11d2c0862edcb32ca65882f622ff39de1b',1);
/*!40000 ALTER TABLE `USUARIOS_RESTAURANTE` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER usuarioOcupado
BEFORE INSERT ON USUARIOS_RESTAURANTE
FOR EACH ROW
BEGIN 
    IF EXISTS (
        SELECT 1 FROM USUARIOS_RESTAURANTE WHERE nombre_usuario = NEW.nombre_usuario
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Usuario ya registrado, intente on otro.';
        END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary table structure for view `eliminarPedido`
--

DROP TABLE IF EXISTS `eliminarPedido`;
/*!50001 DROP VIEW IF EXISTS `eliminarPedido`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `eliminarPedido` AS SELECT
 1 AS `idCliente`,
  1 AS `idPedido`,
  1 AS `fecha_pedido` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `eliminarReserva`
--

DROP TABLE IF EXISTS `eliminarReserva`;
/*!50001 DROP VIEW IF EXISTS `eliminarReserva`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `eliminarReserva` AS SELECT
 1 AS `idCliente`,
  1 AS `idReserva`,
  1 AS `fecha_reserva`,
  1 AS `hora_reserva` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `insertarDetallesPedido`
--

DROP TABLE IF EXISTS `insertarDetallesPedido`;
/*!50001 DROP VIEW IF EXISTS `insertarDetallesPedido`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `insertarDetallesPedido` AS SELECT
 1 AS `idPedido`,
  1 AS `idPlatillo`,
  1 AS `cantidad`,
  1 AS `precio_unitario` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `insertarPedido`
--

DROP TABLE IF EXISTS `insertarPedido`;
/*!50001 DROP VIEW IF EXISTS `insertarPedido`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `insertarPedido` AS SELECT
 1 AS `idCliente`,
  1 AS `fecha_entrega`,
  1 AS `idStatus` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `mostrarClientes_vw`
--

DROP TABLE IF EXISTS `mostrarClientes_vw`;
/*!50001 DROP VIEW IF EXISTS `mostrarClientes_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `mostrarClientes_vw` AS SELECT
 1 AS `idPuntos`,
  1 AS `idCliente`,
  1 AS `idUsuario`,
  1 AS `idStatus`,
  1 AS `nombre`,
  1 AS `apellido`,
  1 AS `correo`,
  1 AS `cant_puntos` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `mostrarMetodoPagos_vw`
--

DROP TABLE IF EXISTS `mostrarMetodoPagos_vw`;
/*!50001 DROP VIEW IF EXISTS `mostrarMetodoPagos_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `mostrarMetodoPagos_vw` AS SELECT
 1 AS `idDetalleMetodoPago`,
  1 AS `idMetodoPago`,
  1 AS `nombre_metodo`,
  1 AS `idCliente`,
  1 AS `num_tarjeta`,
  1 AS `fecha_expiracion` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `mostrarPedidos_vw`
--

DROP TABLE IF EXISTS `mostrarPedidos_vw`;
/*!50001 DROP VIEW IF EXISTS `mostrarPedidos_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `mostrarPedidos_vw` AS SELECT
 1 AS `idPedido`,
  1 AS `fecha_pedido`,
  1 AS `fecha_entrega`,
  1 AS `total_pedido`,
  1 AS `idCliente`,
  1 AS `nombre_status`,
  1 AS `nombre`,
  1 AS `imagen_URL`,
  1 AS `cantidad`,
  1 AS `precio_unitario` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `mostrarResenas_vw`
--

DROP TABLE IF EXISTS `mostrarResenas_vw`;
/*!50001 DROP VIEW IF EXISTS `mostrarResenas_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `mostrarResenas_vw` AS SELECT
 1 AS `idCliente`,
  1 AS `nombre_usuario`,
  1 AS `idResena`,
  1 AS `puntuacion`,
  1 AS `titulo`,
  1 AS `comentario`,
  1 AS `fecha_comentario`,
  1 AS `idTipoResena`,
  1 AS `idPedido` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `mostrarUsuarios_vw`
--

DROP TABLE IF EXISTS `mostrarUsuarios_vw`;
/*!50001 DROP VIEW IF EXISTS `mostrarUsuarios_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `mostrarUsuarios_vw` AS SELECT
 1 AS `idUsuario`,
  1 AS `nombre_usuario`,
  1 AS `password`,
  1 AS `idRol`,
  1 AS `nombre`,
  1 AS `idRolStaff`,
  1 AS `nombre_staff` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `muestrareservas_vw`
--

DROP TABLE IF EXISTS `muestrareservas_vw`;
/*!50001 DROP VIEW IF EXISTS `muestrareservas_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `muestrareservas_vw` AS SELECT
 1 AS `idReserva`,
  1 AS `fecha_reserva`,
  1 AS `hora_reserva`,
  1 AS `num_personas`,
  1 AS `idStatus`,
  1 AS `tema`,
  1 AS `idCliente`,
  1 AS `nombre`,
  1 AS `apellido`,
  1 AS `telefono`,
  1 AS `correo` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `obtenerResenasProducto_vw`
--

DROP TABLE IF EXISTS `obtenerResenasProducto_vw`;
/*!50001 DROP VIEW IF EXISTS `obtenerResenasProducto_vw`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `obtenerResenasProducto_vw` AS SELECT
 1 AS `idPedido`,
  1 AS `idCliente`,
  1 AS `idPlatillo`,
  1 AS `cantidad`,
  1 AS `precio_unitario`,
  1 AS `nombre`,
  1 AS `imagen_URL`,
  1 AS `precio`,
  1 AS `descripcion`,
  1 AS `inventario`,
  1 AS `idCategoria`,
  1 AS `fecha_pedido`,
  1 AS `fecha_entrega`,
  1 AS `total_pedido`,
  1 AS `idStatus`,
  1 AS `idResena`,
  1 AS `puntuacion`,
  1 AS `titulo`,
  1 AS `comentario`,
  1 AS `fecha_comentario`,
  1 AS `idTipoResena` */;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `InfoUsuario`
--

/*!50001 DROP VIEW IF EXISTS `InfoUsuario`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `InfoUsuario` AS select `ur`.`idUsuario` AS `idUsuario`,`ur`.`nombre_usuario` AS `nombre_usuario`,`ur`.`password` AS `password`,`r`.`nombre` AS `nombre` from (`USUARIOS_RESTAURANTE` `ur` join `ROLES` `r` on(`ur`.`idRol` = `r`.`idRol`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `ListaPlatillos`
--

/*!50001 DROP VIEW IF EXISTS `ListaPlatillos`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `ListaPlatillos` AS select `PLATILLOS`.`idPlatillo` AS `idPlatillo`,`PLATILLOS`.`nombre` AS `nombre`,`PLATILLOS`.`imagen_URL` AS `imagen_URL`,`PLATILLOS`.`precio` AS `precio`,`PLATILLOS`.`descripcion` AS `descripcion`,`PLATILLOS`.`inventario` AS `inventario`,`PLATILLOS`.`idCategoria` AS `idCategoria` from `PLATILLOS` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `PlatillosDisponibles_vw`
--

/*!50001 DROP VIEW IF EXISTS `PlatillosDisponibles_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `PlatillosDisponibles_vw` AS select `p`.`idPlatillo` AS `idPlatillo`,`p`.`nombre` AS `nombre`,`p`.`imagen_URL` AS `imagen_URL`,`p`.`precio` AS `precio`,`p`.`descripcion` AS `descripcion`,`p`.`inventario` AS `inventario`,`p`.`idCategoria` AS `idCategoria` from `PLATILLOS` `p` where `p`.`inventario` > 0 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `eliminarPedido`
--

/*!50001 DROP VIEW IF EXISTS `eliminarPedido`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `eliminarPedido` AS select `c`.`idCliente` AS `idCliente`,`p`.`idPedido` AS `idPedido`,`p`.`fecha_pedido` AS `fecha_pedido` from (`PEDIDOS` `p` join `CLIENTES` `c` on(`c`.`idCliente` = `p`.`idCliente`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `eliminarReserva`
--

/*!50001 DROP VIEW IF EXISTS `eliminarReserva`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `eliminarReserva` AS select `c`.`idCliente` AS `idCliente`,`r`.`idReserva` AS `idReserva`,`r`.`fecha_reserva` AS `fecha_reserva`,`r`.`hora_reserva` AS `hora_reserva` from (`RESERVAS` `r` join `CLIENTES` `c` on(`r`.`idCliente` = `c`.`idCliente`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `insertarDetallesPedido`
--

/*!50001 DROP VIEW IF EXISTS `insertarDetallesPedido`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `insertarDetallesPedido` AS select `d`.`idPedido` AS `idPedido`,`d`.`idPlatillo` AS `idPlatillo`,`d`.`cantidad` AS `cantidad`,`d`.`precio_unitario` AS `precio_unitario` from (`DETALLESPEDIDO` `d` join `PLATILLOS` `p` on(`p`.`idPlatillo` = `d`.`idPlatillo`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `insertarPedido`
--

/*!50001 DROP VIEW IF EXISTS `insertarPedido`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `insertarPedido` AS select `c`.`idCliente` AS `idCliente`,`p`.`fecha_entrega` AS `fecha_entrega`,`p`.`idStatus` AS `idStatus` from (`CLIENTES` `c` join `PEDIDOS` `p` on(`c`.`idCliente` = `p`.`idCliente`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `mostrarClientes_vw`
--

/*!50001 DROP VIEW IF EXISTS `mostrarClientes_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `mostrarClientes_vw` AS select `CLIENTES`.`idPuntos` AS `idPuntos`,`CLIENTES`.`idCliente` AS `idCliente`,`CLIENTES`.`idUsuario` AS `idUsuario`,`CLIENTES`.`idStatus` AS `idStatus`,`CLIENTES`.`nombre` AS `nombre`,`CLIENTES`.`apellido` AS `apellido`,`CLIENTES`.`correo` AS `correo`,`PUNTOS_CLIENTES`.`cant_puntos` AS `cant_puntos` from (`CLIENTES` join `PUNTOS_CLIENTES` on(`CLIENTES`.`idPuntos` = `PUNTOS_CLIENTES`.`idPuntos`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `mostrarMetodoPagos_vw`
--

/*!50001 DROP VIEW IF EXISTS `mostrarMetodoPagos_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `mostrarMetodoPagos_vw` AS select `m`.`idDetalleMetodoPago` AS `idDetalleMetodoPago`,`m`.`idMetodoPago` AS `idMetodoPago`,`m`.`nombre_metodo` AS `nombre_metodo`,`m`.`idCliente` AS `idCliente`,`dm`.`num_tarjeta` AS `num_tarjeta`,`dm`.`fecha_expiracion` AS `fecha_expiracion` from (`METODOPAGOS` `m` join `DETALLES_METODOPAGOS` `dm` on(`m`.`idDetalleMetodoPago` = `dm`.`idDetalleMetodoPago`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `mostrarPedidos_vw`
--

/*!50001 DROP VIEW IF EXISTS `mostrarPedidos_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `mostrarPedidos_vw` AS select `d`.`idPedido` AS `idPedido`,`PEDIDOS`.`fecha_pedido` AS `fecha_pedido`,`PEDIDOS`.`fecha_entrega` AS `fecha_entrega`,`PEDIDOS`.`total_pedido` AS `total_pedido`,`PEDIDOS`.`idCliente` AS `idCliente`,`sp`.`nombre_status` AS `nombre_status`,`p`.`nombre` AS `nombre`,`p`.`imagen_URL` AS `imagen_URL`,`d`.`cantidad` AS `cantidad`,`d`.`precio_unitario` AS `precio_unitario` from (((`DETALLESPEDIDO` `d` join `PEDIDOS` on(`d`.`idPedido` = `PEDIDOS`.`idPedido`)) join `STATUS_PEDIDO` `sp` on(`PEDIDOS`.`idStatus` = `sp`.`idStatus`)) join `PLATILLOS` `p` on(`d`.`idPlatillo` = `p`.`idPlatillo`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `mostrarResenas_vw`
--

/*!50001 DROP VIEW IF EXISTS `mostrarResenas_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `mostrarResenas_vw` AS select `c`.`idCliente` AS `idCliente`,`USUARIOS_RESTAURANTE`.`nombre_usuario` AS `nombre_usuario`,`RESENAS`.`idResena` AS `idResena`,`RESENAS`.`puntuacion` AS `puntuacion`,`RESENAS`.`titulo` AS `titulo`,`RESENAS`.`comentario` AS `comentario`,`RESENAS`.`fecha_comentario` AS `fecha_comentario`,`RESENAS`.`idTipoResena` AS `idTipoResena`,`RESENAS`.`idPedido` AS `idPedido` from ((`USUARIOS_RESTAURANTE` join `CLIENTES` `c` on(`USUARIOS_RESTAURANTE`.`idUsuario` = `c`.`idUsuario`)) join `RESENAS` on(`c`.`idCliente` = `RESENAS`.`idCliente`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `mostrarUsuarios_vw`
--

/*!50001 DROP VIEW IF EXISTS `mostrarUsuarios_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `mostrarUsuarios_vw` AS select `ur`.`idUsuario` AS `idUsuario`,`ur`.`nombre_usuario` AS `nombre_usuario`,`ur`.`password` AS `password`,`ur`.`idRol` AS `idRol`,`r`.`nombre` AS `nombre`,`rs`.`idRolStaff` AS `idRolStaff`,`ts`.`nombre_staff` AS `nombre_staff` from (((`USUARIOS_RESTAURANTE` `ur` left join `ROLES` `r` on(`ur`.`idRol` = `r`.`idRol`)) left join `ROLES_STAFF` `rs` on(`ur`.`idUsuario` = `rs`.`idUsuario`)) left join `TIPOS_STAFF` `ts` on(`rs`.`idRolStaff` = `ts`.`idRolStaff`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `muestrareservas_vw`
--

/*!50001 DROP VIEW IF EXISTS `muestrareservas_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `muestrareservas_vw` AS select `r`.`idReserva` AS `idReserva`,`r`.`fecha_reserva` AS `fecha_reserva`,`r`.`hora_reserva` AS `hora_reserva`,`r`.`num_personas` AS `num_personas`,`r`.`idStatus` AS `idStatus`,`r`.`tema` AS `tema`,`c`.`idCliente` AS `idCliente`,`c`.`nombre` AS `nombre`,`c`.`apellido` AS `apellido`,`tc`.`telefono` AS `telefono`,`c`.`correo` AS `correo` from ((`TELEFONOS_CLIENTE` `tc` join `RESERVAS` `r` on(`tc`.`idCliente` = `r`.`idCliente`)) left join `CLIENTES` `c` on(`c`.`idCliente` = `r`.`idCliente`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `obtenerResenasProducto_vw`
--

/*!50001 DROP VIEW IF EXISTS `obtenerResenasProducto_vw`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `obtenerResenasProducto_vw` AS select `DETALLESPEDIDO`.`idPedido` AS `idPedido`,`PEDIDOS`.`idCliente` AS `idCliente`,`DETALLESPEDIDO`.`idPlatillo` AS `idPlatillo`,`DETALLESPEDIDO`.`cantidad` AS `cantidad`,`DETALLESPEDIDO`.`precio_unitario` AS `precio_unitario`,`PLATILLOS`.`nombre` AS `nombre`,`PLATILLOS`.`imagen_URL` AS `imagen_URL`,`PLATILLOS`.`precio` AS `precio`,`PLATILLOS`.`descripcion` AS `descripcion`,`PLATILLOS`.`inventario` AS `inventario`,`PLATILLOS`.`idCategoria` AS `idCategoria`,`PEDIDOS`.`fecha_pedido` AS `fecha_pedido`,`PEDIDOS`.`fecha_entrega` AS `fecha_entrega`,`PEDIDOS`.`total_pedido` AS `total_pedido`,`PEDIDOS`.`idStatus` AS `idStatus`,`r`.`idResena` AS `idResena`,`r`.`puntuacion` AS `puntuacion`,`r`.`titulo` AS `titulo`,`r`.`comentario` AS `comentario`,`r`.`fecha_comentario` AS `fecha_comentario`,`r`.`idTipoResena` AS `idTipoResena` from (((`DETALLESPEDIDO` join `PLATILLOS` on(`DETALLESPEDIDO`.`idPlatillo` = `PLATILLOS`.`idPlatillo`)) join `PEDIDOS` on(`DETALLESPEDIDO`.`idPedido` = `PEDIDOS`.`idPedido`)) join `RESENAS` `r` on(`DETALLESPEDIDO`.`idPedido` = `r`.`idPedido` and `PEDIDOS`.`idCliente` = `r`.`idCliente`)) where `r`.`idTipoResena` = 2 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-27 22:40:47
