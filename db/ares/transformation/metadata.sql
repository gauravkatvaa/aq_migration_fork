-- MySQL dump 10.13  Distrib 8.0.35, for Linux (x86_64)
--
-- Host: localhost    Database: metadata
-- ------------------------------------------------------
-- Server version	8.0.35

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `metadata`
--

/*!40000 DROP DATABASE IF EXISTS `metadata`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `metadata` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `metadata`;

--
-- Table structure for table `addresses`
--

DROP TABLE IF EXISTS `addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `addresses` (
  `PARTY_ROLE_ID` bigint DEFAULT NULL,
  `ADDRESS_TYPE` varchar(255) DEFAULT NULL,
  `COUNTRY` varchar(255) DEFAULT NULL,
  `CITY` varchar(255) DEFAULT NULL,
  `STREET` varchar(255) DEFAULT NULL,
  `BUILDING` varchar(255) DEFAULT NULL,
  `POSTAL_CODE` varchar(255) DEFAULT NULL,
  `SURNAME_COMPANY` varchar(255) DEFAULT NULL,
  `NAME_DEPARTMENT` varchar(255) DEFAULT NULL,
  `STATE` varchar(255) DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addresses`
--

LOCK TABLES `addresses` WRITE;
/*!40000 ALTER TABLE `addresses` DISABLE KEYS */;
INSERT INTO `addresses` VALUES (35573,'Company address','NATIONALITY.AT','Vienna','Karlsplatz','10','1010','CTC_BU1','','',1),(35573,'SIM delivery address','NATIONALITY.AT','Vienna','Karlsplatz','10','1010','Mr. Pickup Guy','','',2),(35574,'Company address','NATIONALITY.AT','Vienna','Karlsplatz','10','1010','CTC_BU2','','',3),(35574,'SIM delivery address','NATIONALITY.AT','Vienna','Karlsplatz','10','1010','Mr. Pickup Guy','','',4),(35572,'Company address','NATIONALITY.AT','Vienna','Karlsplatz','10','1010','','','',5),(35572,'BILLING_ADDRESS','NATIONALITY.AT','Vienna','Karlsplatz','10','1010','Mr Invoice Guy','','',6),(35572,'SIM delivery address','NATIONALITY.AT','Vienna','Karlsplatz','10','1010','Mr. Pickup Guy','','',7),(35573,'BILLING_ADDRESS','NATIONALITY.AT','','','','','','','',8),(35574,'BILLING_ADDRESS','NATIONALITY.AT','','','','','','','',9);
/*!40000 ALTER TABLE `addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `country`
--

DROP TABLE IF EXISTS `country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `country` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `CREATE_DATE` datetime DEFAULT CURRENT_TIMESTAMP,
  `ISO_CODE` varchar(16) DEFAULT NULL,
  `NAME` varchar(64) DEFAULT NULL,
  `EXTRA_METADATA` varchar(64) DEFAULT NULL,
  `DELETED` tinyint DEFAULT NULL,
  `COUNTRY_CODE` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=253 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `country`
--

LOCK TABLES `country` WRITE;
/*!40000 ALTER TABLE `country` DISABLE KEYS */;
INSERT INTO `country` VALUES (1,'2024-05-15 00:00:00','AD','Andorra',NULL,0,'376'),(2,'2024-05-15 00:00:00','AE','United Arab Emirates',NULL,0,'971'),(3,'2024-05-15 00:00:00','AF','Afghanistan',NULL,0,'93'),(4,'2024-05-15 00:00:00','AG','Antigua and Barbuda',NULL,0,'1268'),(5,'2024-05-15 00:00:00','AI','Anguilla',NULL,0,'1264'),(6,'2024-05-15 00:00:00','AL','Albania',NULL,0,'355'),(7,'2024-05-15 00:00:00','AM','Armenia',NULL,0,'374'),(8,'2024-05-15 00:00:00','AN','Netherlands Antilles',NULL,0,'599'),(9,'2024-05-15 00:00:00','AO','Angola',NULL,0,'244'),(10,'2024-05-15 00:00:00','AQ','Antarctica',NULL,0,'672, 64'),(11,'2024-05-15 00:00:00','AR','Argentina',NULL,0,'54'),(12,'2024-05-15 00:00:00','AS','American Samoa',NULL,0,'1684'),(13,'2024-05-15 00:00:00','AT','Austria',NULL,0,'43'),(14,'2024-05-15 00:00:00','AU','Australia',NULL,0,'61'),(15,'2024-05-15 00:00:00','AW','Aruba',NULL,0,'297'),(16,'2024-05-15 00:00:00','AX','Aland Islands',NULL,0,'358'),(17,'2024-05-15 00:00:00','AZ','Azerbaijan',NULL,0,'994'),(18,'2024-05-15 00:00:00','BA','Bosnia and Herzegovina',NULL,0,'387'),(19,'2024-05-15 00:00:00','BB','Barbados',NULL,0,'1246'),(20,'2024-05-15 00:00:00','BD','Bangladesh',NULL,0,'880'),(21,'2024-05-15 00:00:00','BE','Belgium',NULL,0,'32'),(22,'2024-05-15 00:00:00','BF','Burkina Faso',NULL,0,'226'),(23,'2024-05-15 00:00:00','BG','Bulgaria',NULL,0,'359'),(24,'2024-05-15 00:00:00','BH','Bahrain',NULL,0,'973'),(25,'2024-05-15 00:00:00','BI','Burundi',NULL,0,'257'),(26,'2024-05-15 00:00:00','BJ','Benin',NULL,0,'229'),(27,'2024-05-15 00:00:00','BL','Saint Barth',NULL,0,'590'),(28,'2024-05-15 00:00:00','BM','Bermuda',NULL,0,'1441'),(29,'2024-05-15 00:00:00','BN','Brunei',NULL,0,'673'),(30,'2024-05-15 00:00:00','BO','Bolivia',NULL,0,'591'),(31,'2024-05-15 00:00:00','BQ','Bonaire, Saint Eustatius and Saba ',NULL,0,'599'),(32,'2024-05-15 00:00:00','BR','Brazil',NULL,0,'55'),(33,'2024-05-15 00:00:00','BS','Bahamas',NULL,0,'1242'),(34,'2024-05-15 00:00:00','BT','Bhutan',NULL,0,'975'),(35,'2024-05-15 00:00:00','BV','Bouvet Island',NULL,0,'47'),(36,'2024-05-15 00:00:00','BW','Botswana',NULL,0,'267'),(37,'2024-05-15 00:00:00','BY','Belarus',NULL,0,'375'),(38,'2024-05-15 00:00:00','BZ','Belize',NULL,0,'501'),(39,'2024-05-15 00:00:00','CA','Canada',NULL,0,'1'),(40,'2024-05-15 00:00:00','CC','Cocos Islands',NULL,0,'61'),(41,'2024-05-15 00:00:00','CD','Democratic Republic of the Congo',NULL,0,'243'),(42,'2024-05-15 00:00:00','CF','Central African Republic',NULL,0,'236'),(43,'2024-05-15 00:00:00','CG','Republic of the Congo',NULL,0,'242'),(44,'2024-05-15 00:00:00','CH','Switzerland',NULL,0,'41'),(45,'2024-05-15 00:00:00','CI','Ivory Coast',NULL,0,'225'),(46,'2024-05-15 00:00:00','CK','Cook Islands',NULL,0,'682'),(47,'2024-05-15 00:00:00','CL','Chile',NULL,0,'56'),(48,'2024-05-15 00:00:00','CM','Cameroon',NULL,0,'237'),(49,'2024-05-15 00:00:00','CN','China',NULL,0,'86'),(50,'2024-05-15 00:00:00','CO','Colombia',NULL,0,'57'),(51,'2024-05-15 00:00:00','CR','Costa Rica',NULL,0,'506'),(52,'2024-05-15 00:00:00','CS','Serbia and Montenegro',NULL,0,'599'),(53,'2024-05-15 00:00:00','CU','Cuba',NULL,0,'53'),(54,'2024-05-15 00:00:00','CV','Cape Verde',NULL,0,'238'),(55,'2024-05-15 00:00:00','CW','Cura',NULL,0,'44 1481'),(56,'2024-05-15 00:00:00','CX','Christmas Island',NULL,0,'61'),(57,'2024-05-15 00:00:00','CY','Cyprus',NULL,0,'357'),(58,'2024-05-15 00:00:00','CZ','Czech Republic',NULL,0,'420'),(59,'2024-05-15 00:00:00','DE','Germany',NULL,0,'49'),(60,'2024-05-15 00:00:00','DJ','Djibouti',NULL,0,'253'),(61,'2024-05-15 00:00:00','DK','Denmark',NULL,0,'45'),(62,'2024-05-15 00:00:00','DM','Dominica',NULL,0,'1767'),(64,'2024-05-15 00:00:00','DZ','Algeria',NULL,0,'213'),(65,'2024-05-15 00:00:00','EC','Ecuador',NULL,0,'593'),(66,'2024-05-15 00:00:00','EE','Estonia',NULL,0,'372'),(67,'2024-05-15 00:00:00','EG','Egypt',NULL,0,'20'),(68,'2024-05-15 00:00:00','EH','Western Sahara',NULL,0,'212'),(69,'2024-05-15 00:00:00','ER','Eritrea',NULL,0,'291'),(70,'2024-05-15 00:00:00','ES','Spain',NULL,0,'34'),(71,'2024-05-15 00:00:00','ET','Ethiopia',NULL,0,'251'),(72,'2024-05-15 00:00:00','FI','Finland',NULL,0,'358'),(73,'2024-05-15 00:00:00','FJ','Fiji',NULL,0,'679'),(74,'2024-05-15 00:00:00','FK','Falkland Islands',NULL,0,'500'),(75,'2024-05-15 00:00:00','FM','Micronesia',NULL,0,'691'),(76,'2024-05-15 00:00:00','FO','Faroe Islands',NULL,0,'298'),(77,'2024-05-15 00:00:00','FR','France',NULL,0,'33'),(78,'2024-05-15 00:00:00','GA','Gabon',NULL,0,'241'),(79,'2024-05-15 00:00:00','GB','United Kingdom',NULL,0,'44'),(80,'2024-05-15 00:00:00','GD','Grenada',NULL,0,'1473'),(81,'2024-05-15 00:00:00','GE','Georgia',NULL,0,'995'),(82,'2024-05-15 00:00:00','GF','French Guiana',NULL,0,'594'),(83,'2024-05-15 00:00:00','GG','Guernsey',NULL,0,'500'),(84,'2024-05-15 00:00:00','GH','Ghana',NULL,0,'233'),(85,'2024-05-15 00:00:00','GI','Gibraltar',NULL,0,'350'),(86,'2024-05-15 00:00:00','GL','Greenland',NULL,0,'299'),(87,'2024-05-15 00:00:00','GM','Gambia',NULL,0,'220'),(88,'2024-05-15 00:00:00','GN','Guinea',NULL,0,'224'),(89,'2024-05-15 00:00:00','GP','Guadeloupe',NULL,0,'590'),(90,'2024-05-15 00:00:00','GQ','Equatorial Guinea',NULL,0,'240'),(91,'2024-05-15 00:00:00','GR','Greece',NULL,0,'30'),(92,'2024-05-15 00:00:00','GS','South Georgia and the South Sandwich Islands',NULL,0,'3166-1'),(93,'2024-05-15 00:00:00','GT','Guatemala',NULL,0,'502'),(94,'2024-05-15 00:00:00','GU','Guam',NULL,0,'1671'),(95,'2024-05-15 00:00:00','GW','Guinea-Bissau',NULL,0,'245'),(96,'2024-05-15 00:00:00','GY','Guyana',NULL,0,'592'),(97,'2024-05-15 00:00:00','HK','Hong Kong',NULL,0,'852'),(98,'2024-05-15 00:00:00','HM','Heard Island and McDonald Islands',NULL,0,'246'),(99,'2024-05-15 00:00:00','HN','Honduras',NULL,0,'504'),(100,'2024-05-15 00:00:00','HR','Croatia',NULL,0,'385'),(101,'2024-05-15 00:00:00','HT','Haiti',NULL,0,'509'),(102,'2024-05-15 00:00:00','HU','Hungary',NULL,0,'36'),(103,'2024-05-15 00:00:00','ID','Indonesia',NULL,0,'62'),(104,'2024-05-15 00:00:00','IE','Ireland',NULL,0,'353'),(105,'2024-05-15 00:00:00','IL','Israel',NULL,0,'972'),(106,'2024-05-15 00:00:00','IM','Isle of Man',NULL,0,'44'),(107,'2024-05-15 00:00:00','IN','India',NULL,0,'91'),(108,'2024-05-15 00:00:00','IO','British Indian Ocean Territory',NULL,0,'262'),(109,'2024-05-15 00:00:00','IQ','Iraq',NULL,0,'964'),(110,'2024-05-15 00:00:00','IR','Iran',NULL,0,'98'),(111,'2024-05-15 00:00:00','IS','Iceland',NULL,0,'354'),(112,'2024-05-15 00:00:00','IT','Italy',NULL,0,'39'),(113,'2024-05-15 00:00:00','JE','Jersey',NULL,0,'44'),(114,'2024-05-15 00:00:00','JM','Jamaica',NULL,0,'1876'),(115,'2024-05-15 00:00:00','JO','Jordan',NULL,0,'962'),(116,'2024-05-15 00:00:00','JP','Japan',NULL,0,'81'),(117,'2024-05-15 00:00:00','KE','Kenya',NULL,0,'254'),(118,'2024-05-15 00:00:00','KG','Kyrgyzstan',NULL,0,'996'),(119,'2024-05-15 00:00:00','KH','Cambodia',NULL,0,'855'),(120,'2024-05-15 00:00:00','KI','Kiribati',NULL,0,'686'),(121,'2024-05-15 00:00:00','KM','Comoros',NULL,0,'269'),(122,'2024-05-15 00:00:00','KN','Saint Kitts and Nevis',NULL,0,'1869'),(123,'2024-05-15 00:00:00','KP','North Korea',NULL,0,'850'),(124,'2024-05-15 00:00:00','KR','South Korea',NULL,0,'82'),(125,'2024-05-15 00:00:00','KW','Kuwait',NULL,0,'965'),(126,'2024-05-15 00:00:00','KY','Cayman Islands',NULL,0,'1345'),(127,'2024-05-15 00:00:00','KZ','Kazakhstan',NULL,0,'7'),(128,'2024-05-15 00:00:00','LA','Laos',NULL,0,'856'),(129,'2024-05-15 00:00:00','LB','Lebanon',NULL,0,'961'),(130,'2024-05-15 00:00:00','LC','Saint Lucia',NULL,0,'1758'),(131,'2024-05-15 00:00:00','LI','Liechtenstein',NULL,0,'423'),(132,'2024-05-15 00:00:00','LK','Sri Lanka',NULL,0,'94'),(133,'2024-05-15 00:00:00','LR','Liberia',NULL,0,'231'),(134,'2024-05-15 00:00:00','LS','Lesotho',NULL,0,'266'),(135,'2024-05-15 00:00:00','LT','Lithuania',NULL,0,'370'),(136,'2024-05-15 00:00:00','LU','Luxembourg',NULL,0,'352'),(137,'2024-05-15 00:00:00','LV','Latvia',NULL,0,'371'),(138,'2024-05-15 00:00:00','LY','Libya',NULL,0,'218'),(139,'2024-05-15 00:00:00','MA','Morocco',NULL,0,'212'),(140,'2024-05-15 00:00:00','MC','Monaco',NULL,0,'377'),(141,'2024-05-15 00:00:00','MD','Moldova',NULL,0,'373'),(142,'2024-05-15 00:00:00','ME','Montenegro',NULL,0,'382'),(143,'2024-05-15 00:00:00','MF','Saint Martin',NULL,0,'590'),(144,'2024-05-15 00:00:00','MG','Madagascar',NULL,0,'261'),(145,'2024-05-15 00:00:00','MH','Marshall Islands',NULL,0,'692'),(146,'2024-05-15 00:00:00','MK','Macedonia',NULL,0,'389'),(147,'2024-05-15 00:00:00','ML','Mali',NULL,0,'223'),(148,'2024-05-15 00:00:00','MM','Myanmar',NULL,0,'95'),(149,'2024-05-15 00:00:00','MN','Mongolia',NULL,0,'976'),(150,'2024-05-15 00:00:00','MO','Macao',NULL,0,'853'),(151,'2024-05-15 00:00:00','MP','Northern Mariana Islands',NULL,0,'1670'),(152,'2024-05-15 00:00:00','MQ','Martinique',NULL,0,'596'),(153,'2024-05-15 00:00:00','MR','Mauritania',NULL,0,'222'),(154,'2024-05-15 00:00:00','MS','Montserrat',NULL,0,'1664'),(155,'2024-05-15 00:00:00','MT','Malta',NULL,0,'356'),(156,'2024-05-15 00:00:00','MU','Mauritius',NULL,0,'230'),(157,'2024-05-15 00:00:00','MV','Maldives',NULL,0,'960'),(158,'2024-05-15 00:00:00','MW','Malawi',NULL,0,'265'),(159,'2024-05-15 00:00:00','MX','Mexico',NULL,0,'52'),(160,'2024-05-15 00:00:00','MY','Malaysia',NULL,0,'60'),(161,'2024-05-15 00:00:00','MZ','Mozambique',NULL,0,'258'),(162,'2024-05-15 00:00:00','NA','Namibia',NULL,0,'264'),(163,'2024-05-15 00:00:00','NC','New Caledonia',NULL,0,'687'),(164,'2024-05-15 00:00:00','NE','Niger',NULL,0,'227'),(165,'2024-05-15 00:00:00','NF','Norfolk Island',NULL,0,'672'),(166,'2024-05-15 00:00:00','NG','Nigeria',NULL,0,'234'),(167,'2024-05-15 00:00:00','NI','Nicaragua',NULL,0,'505'),(168,'2024-05-15 00:00:00','NL','Netherlands',NULL,0,'31'),(169,'2024-05-15 00:00:00','NO','Norway',NULL,0,'47'),(170,'2024-05-15 00:00:00','NP','Nepal',NULL,0,'977'),(171,'2024-05-15 00:00:00','NR','Nauru',NULL,0,'674'),(172,'2024-05-15 00:00:00','NU','Niue',NULL,0,'683'),(173,'2024-05-15 00:00:00','NZ','New Zealand',NULL,0,'64'),(174,'2024-05-15 00:00:00','OM','Oman',NULL,0,'968'),(175,'2024-05-15 00:00:00','PA','Panama',NULL,0,'507'),(176,'2024-05-15 00:00:00','PE','Peru',NULL,0,'51'),(177,'2024-05-15 00:00:00','PF','French Polynesia',NULL,0,'689'),(178,'2024-05-15 00:00:00','PG','Papua New Guinea',NULL,0,'675'),(179,'2024-05-15 00:00:00','PH','Philippines',NULL,0,'63'),(180,'2024-05-15 00:00:00','PK','Pakistan',NULL,0,'92'),(181,'2024-05-15 00:00:00','PL','Poland',NULL,0,'48'),(182,'2024-05-15 00:00:00','PM','Saint Pierre and Miquelon',NULL,0,'508'),(183,'2024-05-15 00:00:00','PN','Pitcairn',NULL,0,'870'),(184,'2024-05-15 00:00:00','PR','Puerto Rico',NULL,0,'1 787, 1 939'),(185,'2024-05-15 00:00:00','PS','Palestinian Territory',NULL,0,'970'),(186,'2024-05-15 00:00:00','PT','Portugal',NULL,0,'351'),(187,'2024-05-15 00:00:00','PW','Palau',NULL,0,'680'),(188,'2024-05-15 00:00:00','PY','Paraguay',NULL,0,'595'),(189,'2024-05-15 00:00:00','QA','Qatar',NULL,0,'974'),(190,'2024-05-15 00:00:00','RE','Reunion',NULL,0,'262'),(191,'2024-05-15 00:00:00','RO','Romania',NULL,0,'40'),(192,'2024-05-15 00:00:00','RS','Serbia',NULL,0,'381'),(193,'2024-05-15 00:00:00','RU','Russia',NULL,0,'7'),(194,'2024-05-15 00:00:00','RW','Rwanda',NULL,0,'250'),(195,'2024-05-15 00:00:00','SA','Saudi Arabia',NULL,0,'966'),(196,'2024-05-15 00:00:00','SB','Solomon Islands',NULL,0,'677'),(197,'2024-05-15 00:00:00','SC','Seychelles',NULL,0,'248'),(198,'2024-05-15 00:00:00','SD','Sudan',NULL,0,'249'),(199,'2024-05-15 00:00:00','SE','Sweden',NULL,0,'46'),(200,'2024-05-15 00:00:00','SG','Singapore',NULL,0,'65'),(201,'2024-05-15 00:00:00','SH','Saint Helena',NULL,0,'290'),(202,'2024-05-15 00:00:00','SI','Slovenia',NULL,0,'386'),(203,'2024-05-15 00:00:00','SJ','Svalbard and Jan Mayen',NULL,0,'47'),(204,'2024-05-15 00:00:00','SK','Slovakia',NULL,0,'421'),(205,'2024-05-15 00:00:00','SL','Sierra Leone',NULL,0,'232'),(206,'2024-05-15 00:00:00','SM','San Marino',NULL,0,'378'),(207,'2024-05-15 00:00:00','SN','Senegal',NULL,0,'221'),(208,'2024-05-15 00:00:00','SO','Somalia',NULL,0,'252'),(209,'2024-05-15 00:00:00','SR','Suriname',NULL,0,'597'),(210,'2024-05-15 00:00:00','SS','South Sudan',NULL,0,'211'),(211,'2024-05-15 00:00:00','ST','Sao Tome and Principe',NULL,0,'239'),(212,'2024-05-15 00:00:00','SV','El Salvador',NULL,0,'503'),(213,'2024-05-15 00:00:00','SX','Sint Maarten',NULL,0,'1721'),(214,'2024-05-15 00:00:00','SY','Syria',NULL,0,'963'),(215,'2024-05-15 00:00:00','SZ','Swaziland',NULL,0,'268'),(216,'2024-05-15 00:00:00','TC','Turks and Caicos Islands',NULL,0,'1649'),(217,'2024-05-15 00:00:00','TD','Chad',NULL,0,'235'),(218,'2024-05-15 00:00:00','TF','French Southern Territories',NULL,0,'3166-2'),(219,'2024-05-15 00:00:00','TG','Togo',NULL,0,'228'),(220,'2024-05-15 00:00:00','TH','Thailand',NULL,0,'66'),(221,'2024-05-15 00:00:00','TJ','Tajikistan',NULL,0,'992'),(222,'2024-05-15 00:00:00','TK','Tokelau',NULL,0,'690'),(223,'2024-05-15 00:00:00','TL','East Timor',NULL,0,'670'),(224,'2024-05-15 00:00:00','TM','Turkmenistan',NULL,0,'993'),(225,'2024-05-15 00:00:00','TN','Tunisia',NULL,0,'216'),(226,'2024-05-15 00:00:00','TO','Tonga',NULL,0,'676'),(227,'2024-05-15 00:00:00','TR','Turkey',NULL,0,'90'),(228,'2024-05-15 00:00:00','TT','Trinidad and Tobago',NULL,0,'1868'),(229,'2024-05-15 00:00:00','TV','Tuvalu',NULL,0,'688'),(230,'2024-05-15 00:00:00','TW','Taiwan',NULL,0,'886'),(231,'2024-05-15 00:00:00','TZ','Tanzania',NULL,0,'255'),(232,'2024-05-15 00:00:00','UA','Ukraine',NULL,0,'380'),(233,'2024-05-15 00:00:00','UG','Uganda',NULL,0,'256'),(234,'2024-05-15 00:00:00','UM','United States Minor Outlying Islands',NULL,0,'383'),(235,'2024-05-15 00:00:00','US','United States',NULL,0,'1'),(236,'2024-05-15 00:00:00','UY','Uruguay',NULL,0,'598'),(237,'2024-05-15 00:00:00','UZ','Uzbekistan',NULL,0,'998'),(238,'2024-05-15 00:00:00','VA','Vatican',NULL,0,'39'),(239,'2024-05-15 00:00:00','VC','Saint Vincent and the Grenadines',NULL,0,'1784'),(240,'2024-05-15 00:00:00','VE','Venezuela',NULL,0,'58'),(241,'2024-05-15 00:00:00','VG','British Virgin Islands',NULL,0,'1284'),(242,'2024-05-15 00:00:00','VI','U.S. Virgin Islands',NULL,0,'1340'),(243,'2024-05-15 00:00:00','VN','Vietnam',NULL,0,'84'),(244,'2024-05-15 00:00:00','VU','Vanuatu',NULL,0,'678'),(245,'2024-05-15 00:00:00','WF','Wallis and Futuna',NULL,0,'681'),(246,'2024-05-15 00:00:00','WS','Samoa',NULL,0,'685'),(247,'2024-05-15 00:00:00','XK','Kosovo',NULL,0,NULL),(248,'2024-05-15 00:00:00','YE','Yemen',NULL,0,'967'),(249,'2024-05-15 00:00:00','YT','Mayotte',NULL,0,'262'),(250,'2024-05-15 00:00:00','ZA','South Africa',NULL,0,'27'),(251,'2024-05-15 00:00:00','ZM','Zambia',NULL,0,'260'),(252,'2024-05-15 00:00:00','ZW','Zimbabwe',NULL,0,'263');
/*!40000 ALTER TABLE `country` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `currency`
--

DROP TABLE IF EXISTS `currency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `currency` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `CURRENCY` varchar(16) DEFAULT NULL,
  `SYMBOL` varchar(16) DEFAULT NULL,
  `CREATE_DATE` datetime DEFAULT CURRENT_TIMESTAMP,
  `DELETED` tinyint(1) DEFAULT '0',
  `DELETED_DATE` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `currency`
--

LOCK TABLES `currency` WRITE;
/*!40000 ALTER TABLE `currency` DISABLE KEYS */;
INSERT INTO `currency` VALUES (1,'USD','$','2024-05-15 00:00:00',0,NULL),(2,'EUR','Ã¢â€šÂ¬','2024-05-15 00:00:00',0,NULL),(3,'GBP','Ã‚Â£','2024-05-15 00:00:00',0,NULL),(4,'SEK','kr','2024-05-15 00:00:00',0,NULL),(5,'DKK','Kr.','2024-05-15 00:00:00',0,NULL),(6,'HKD','HK$','2024-05-15 00:00:00',0,NULL),(7,'VND','Ã¢â€šÂ«','2024-05-15 00:00:00',0,NULL),(8,'IDR','Rp','2024-05-15 00:00:00',0,NULL),(9,'CHF','fr.','2024-05-15 00:00:00',0,NULL),(10,'SGD','S$','2024-05-15 00:00:00',0,NULL),(11,'KWD','KD','2024-05-15 00:00:00',0,NULL),(12,'BHD','BD','2024-05-15 00:00:00',0,NULL),(13,'SAR','SR','2024-05-15 00:00:00',0,NULL),(14,'AED','Ã˜Â¯.Ã˜Â¥','2024-05-15 00:00:00',0,NULL),(15,'EGP','Ã‚Â£','2024-05-15 00:00:00',0,NULL),(16,'BRL','R$','2024-05-15 00:00:00',0,NULL),(17,'SAR','Ã˜Â±.Ã˜Â³','2024-05-15 00:00:00',0,NULL),(18,'MXN','$','2024-05-15 00:00:00',0,NULL);
/*!40000 ALTER TABLE `currency` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dic_bill_cycle`
--

DROP TABLE IF EXISTS `dic_bill_cycle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dic_bill_cycle` (
  `ID` int DEFAULT NULL,
  `BCTYPE` varchar(20) DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dic_bill_cycle`
--

LOCK TABLES `dic_bill_cycle` WRITE;
/*!40000 ALTER TABLE `dic_bill_cycle` DISABLE KEYS */;
INSERT INTO `dic_bill_cycle` VALUES (54,'Monthly',1),(75,'Monthly',2),(76,'Monthly',3),(81,'Monthly',4),(82,'Monthly',5),(55,'Monthly',6),(56,'Monthly',7),(57,'Monthly',8),(58,'Monthly',9),(59,'Monthly',10),(60,'Monthly',11),(61,'Monthly',12),(62,'Monthly',13),(63,'Monthly',14),(64,'Monthly',15),(65,'Monthly',16),(66,'Monthly',17),(80,'Monthly',18),(83,'Monthly',19),(68,'Monthly',20),(73,'Monthly',21),(53,'Monthly',22),(69,'Monthly',23),(71,'Monthly',24),(79,'Monthly',25),(37,'Monthly',26),(38,'Monthly',27),(39,'Monthly',28),(40,'Monthly',29),(41,'Monthly',30),(42,'Monthly',31),(43,'Monthly',32),(44,'Monthly',33),(45,'Monthly',34),(1,'Monthly',35),(67,'Monthly',36),(49,'Monthly',37),(77,'Monthly',38),(78,'Monthly',39),(51,'Quarterly',40),(72,'Quarterly',41),(52,'Quarterly',42),(74,'Quarterly',43),(50,'Quarterly',44),(70,'Quarterly',45);
/*!40000 ALTER TABLE `dic_bill_cycle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dic_new_opco`
--

DROP TABLE IF EXISTS `dic_new_opco`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dic_new_opco` (
  `CPARTY_ID` int DEFAULT NULL,
  `CRM_ID` int DEFAULT NULL,
  `COMPANYNAME` varchar(128) DEFAULT NULL,
  `FULLNAME` varchar(128) DEFAULT NULL,
  `BILLING_OPCO` varchar(26) DEFAULT NULL,
  `OLD_OPCO` varchar(128) DEFAULT NULL,
  `CUSTOMER_TYPE` varchar(128) DEFAULT NULL,
  `CUSTOMER_STATUS` varchar(128) DEFAULT NULL,
  `IS_CHANGE` varchar(10) DEFAULT NULL,
  `IS_BILLABLE` varchar(10) DEFAULT NULL,
  `VALID` varchar(128) DEFAULT NULL,
  `CURRENCY` varchar(128) DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dic_new_opco`
--

LOCK TABLES `dic_new_opco` WRITE;
/*!40000 ALTER TABLE `dic_new_opco` DISABLE KEYS */;
INSERT INTO `dic_new_opco` VALUES (3181,7822,'TNS - Telecom Nescom Systemhaus GmbH','TNS - Telecom Nescom Systemhaus GmbH','A1','M2MTAG: Quarterly Billing Cycle','Enterprise Customer',NULL,'A','Y',NULL,NULL,1),(3197,7931,'Gemeinde Seefeld','Gemeinde Seefeld','M2MTAG','A1','Enterprise Customer',NULL,'M','Y',NULL,NULL,2),(3199,7935,'Marktgemeinde Kötschach-Mauthen','Marktgemeinde Kötschach-Mauthen','M2MTAG','A1','Enterprise Customer',NULL,'M','Y',NULL,NULL,3),(3200,7937,'BBN Eisenstadt','BBN Eisenstadt','M2MTAG','A1','Enterprise Customer',NULL,'M','Y',NULL,NULL,4),(3190,7882,'Volksbank AG Liechtenstein','Volksbank AG Liechtenstein','M2MTAG','A1','Enterprise Customer',NULL,'M','Y',NULL,NULL,5),(3198,7933,'Amt der Oberösterreichischen Landesregierung','Amt der Oberösterreichischen Landesregierung','M2MTAG','A1','Enterprise Customer',NULL,'M','Y',NULL,NULL,6),(3215,7971,'TINETZ-Stromnetz Tirol AG','TINETZ-Stromnetz Tirol AG','A1','M2MTAG','Enterprise Customer',NULL,'A','Y',NULL,NULL,7),(3225,8025,'UTK – EcoSens GmbH','UTK – EcoSens GmbH','A1 Digital DE','M2MTAG','Enterprise Customer',NULL,'ADE','Y',NULL,NULL,8),(3241,8122,'Primetals Technoligies Ltd.','Primetals Technoligies Ltd.','M2MTAG','A1','Enterprise Customer',NULL,'M','N',NULL,NULL,9),(3298,8343,'Wels Strom GmbH','Wels Strom GmbH','A1','M2MTAG','Enterprise Customer',NULL,'A','Y',NULL,NULL,10),(3293,8302,'Hagleitner','Hagleitner','A1','M2MTAG','Enterprise Customer',NULL,'A','N',NULL,NULL,11),(3237,8092,'PetTrack','PetTrack','M2MTAG','A1','Enterprise Customer',NULL,'M','Y',NULL,NULL,12),(3234,8087,'Gemeindeamt Mittelberg','Gemeindeamt Mittelberg','M2MTAG','A1','Enterprise Customer',NULL,'M','Y',NULL,NULL,13),(3355,8622,'Nickel Transporte & Erdarbeiten','Nickel Transporte & Erdarbeiten','A1','M2MTAG','Enterprise Customer',NULL,'A','Y',NULL,NULL,14),(3370,8684,'Biricon','Biricon','A1','M2MTAG','Enterprise Customer',NULL,'A','N',NULL,NULL,15),(3383,8748,'Energie AG Oberösterreich Data GmbH','Energie AG Oberösterreich Data GmbH','A1','M2MTAG','Enterprise Customer',NULL,'A','Y',NULL,NULL,16),(3446,8925,'City Express d.o.o.','City Express d.o.o.','vip mobile','M2MTAG','Enterprise Customer',NULL,'VM','N',NULL,NULL,17),(3454,8945,'has.to.be gmbh','has.to.be gmbh','A1','M2MTAG','Enterprise Customer',NULL,'A','Y',NULL,NULL,18),(2804,5770,'Datavend','Datavend','M2MTAG','M-Tel','Enterprise Customer',NULL,'M','Y',NULL,NULL,19),(2920,6280,'Sledenje d.o.o.','Sledenje d.o.o.','M2MTAG','si.mobil','Enterprise Customer',NULL,'M','Y',NULL,NULL,20),(2999,6766,'CEplus','CEplus','A1','M2MTAG','Enterprise Customer',NULL,'A','Y',NULL,NULL,21),(2873,6018,'Wireless Logic GmbH','Wireless Logic GmbH','A1 Digital DE','M2MTAG','Enterprise Customer',NULL,'ADE','Y',NULL,NULL,22),(3023,6903,'Petrol','Petrol','si.mobile','si.mobil','Enterprise Customer',NULL,'SM','Y',NULL,NULL,23),(2799,5766,'Tough Tracker','Tough Tracker','M2MTAG','M2MTAG','Enterprise Customer',NULL,'M','N',NULL,NULL,24),(3040,7064,'Race Cloud Jsc','Race Cloud Jsc','M2MTAG','M-Tel','Enterprise Customer',NULL,'M','N',NULL,NULL,25),(2735,5654,'Idem','Idem','A1 Digital DE','M2MTAG','Enterprise Customer',NULL,'ADE','Y',NULL,NULL,26),(2750,5678,'Ravena','Ravena','M2MTAG','M-Tel','Enterprise Customer',NULL,'M','Y',NULL,NULL,27),(2759,5691,'Raptor','Raptor','M2MTAG','vip net','Enterprise Customer',NULL,'M','N',NULL,NULL,28),(2734,5652,'GHT GmbH','GHT GmbH','A1 Digital DE','M2MTAG','Enterprise Customer',NULL,'ADE','Y',NULL,NULL,29),(2765,5701,'Advanced GPS Technology','Advanced GPS Technology','M2MTAG','M-Tel','Enterprise Customer',NULL,'M','Y',NULL,NULL,30),(2798,5764,'Mobilisis','Mobilisis','M2MTAG','vip net','Enterprise Customer',NULL,'M','Y',NULL,NULL,31),(2805,5772,'Unreal Soft','Unreal Soft','M2MTAG','M-Tel','Enterprise Customer',NULL,'M','Y',NULL,NULL,32),(3028,6964,'Automatic Servis','Automatic Servis','si.mobile','si.mobil','Enterprise Customer',NULL,'SM','N',NULL,NULL,33),(2758,5689,'Mecomo','Mecomo','mobilkom liechtenstein','M2MTAG','Enterprise Customer',NULL,'L','Y',NULL,NULL,34),(2778,5721,'TaskX','TaskX','mobilkom liechtenstein','M2MTAG','Enterprise Customer',NULL,'L','Y',NULL,NULL,35),(2807,5776,'Technopol','Technopol','M2MTAG','M-Tel','Enterprise Customer',NULL,'M','Y',NULL,NULL,36),(2962,6522,'Tehnologii za otchet ltd','Tehnologii za otchet ltd','M2MTAG','M-Tel','Enterprise Customer',NULL,'M','N',NULL,NULL,37),(2959,6488,'RS5','RS5','M2MTAG','si.mobil','Enterprise Customer',NULL,'M','Y',NULL,NULL,38),(3034,7002,'RC Jesenice d.o.o.','RC Jesenice d.o.o.','M2MTAG','si.mobil','Enterprise Customer',NULL,'M','N',NULL,NULL,39),(2775,5717,'NIPO','NIPO','M2MTAG','M-Tel','Enterprise Customer',NULL,'M','Y',NULL,NULL,40),(2797,5762,'Rotra','Rotra','M2MTAG','M2MTAG','Enterprise Customer',NULL,'M','N',NULL,NULL,41),(3003,6788,'Imovation d.o.o.','Imovation d.o.o.','M2MTAG','si.mobil','Enterprise Customer',NULL,'M','Y',NULL,NULL,42),(2772,5711,'HPL Technology','HPL Technology','A1 Digital DE','M2MTAG','Enterprise Customer',NULL,'ADE','Y',NULL,NULL,43),(2773,5713,'M2M Services','M2M Services','M2MTAG','M-Tel','Enterprise Customer',NULL,'M','Y',NULL,NULL,44),(2794,5748,'Panoramabus','Panoramabus','M2MTAG','vip net','Enterprise Customer',NULL,'M','N',NULL,NULL,45),(2965,6528,'BWT','BWT','A1','M2MTAG','Enterprise Customer',NULL,'A','N',NULL,NULL,46),(2771,5709,'GPS Signal','GPS Signal','M2MTAG','si.mobil','Enterprise Customer',NULL,'M','Y',NULL,NULL,47),(2789,5742,'Anima','Anima','M2MTAG','vip operator','Enterprise Customer',NULL,'M','Y',NULL,NULL,48),(2827,5839,'Rauko','Rauko','M2MTAG','A1','Enterprise Customer',NULL,'M','Y',NULL,NULL,49),(2888,6120,'Aplicom','Aplicom','M2MTAG',NULL,'Reseller',NULL,'M','Y',NULL,NULL,50),(2689,5540,'Euro GPS','Euro GPS','M2MTAG','M2MTAG','Enterprise Customer',NULL,'M','Y',NULL,NULL,51),(2704,5575,'LKW Walter','LKW Walter','mobilkom liechtenstein','A1','Enterprise Customer',NULL,'L','Y',NULL,NULL,52),(3039,7062,'Innotronic','Innotronic','A1','M2MTAG','Enterprise Customer',NULL,'A','N',NULL,NULL,53),(3057,7150,'Amt der Vorarlberger Landesregierung','Amt der Vorarlberger Landesregierung','M2MTAG','A1','Enterprise Customer',NULL,'M','Y',NULL,NULL,54),(2815,5798,'PVO','PVO','M2MTAG','vip net','Enterprise Customer',NULL,'M','Y',NULL,NULL,55),(2739,5660,'Xloc','Xloc','mobilkom liechtenstein','A1','Enterprise Customer',NULL,'L','Y',NULL,NULL,56),(2688,5538,'Metos','Metos','A1','A1','Enterprise Customer',NULL,'A','Y',NULL,NULL,57),(2795,5758,'Telkomatik','Telkomatik','M2MTAG','M2MTAG','Enterprise Customer',NULL,'M','Y',NULL,NULL,58),(3019,6866,'PriberGPS','PriberGPS','M2MTAG','si.mobil','Enterprise Customer',NULL,'M','Y',NULL,NULL,59),(3055,7148,'Lidl Österreich GmbH','Lidl Österreich GmbH','A1','M2MTAG','Enterprise Customer',NULL,'A','Y',NULL,NULL,60),(3065,7164,'ME Engineering','ME Engineering','A1 Digital DE','M2MTAG','Enterprise Customer',NULL,'ADE','Y',NULL,NULL,61),(3086,7246,'Smaxtec animal care','Smaxtec animal care','A1','M2MTAG','Enterprise Customer',NULL,'A','Y',NULL,NULL,62),(3072,7192,'Scorpion7','Scorpion7','M2MTAG','M-Tel','Enterprise Customer',NULL,'M','Y',NULL,NULL,63),(3064,7182,'E-mobility Provider Austria GmbH & Co KG','E-mobility Provider Austria GmbH & Co KG','A1','M2MTAG','Enterprise Customer',NULL,'A','Y',NULL,NULL,64),(3083,7222,'Streetwatch','Streetwatch','A1','M2MTAG','Enterprise Customer',NULL,'A','Y',NULL,NULL,65),(3105,7316,'Energy Services','Energy Services','A1','M2MTAG','Enterprise Customer',NULL,'A','Y',NULL,NULL,66),(3099,7306,'CMC EKOCON','CMC EKOCON','M2MTAG','si.mobil','Enterprise Customer',NULL,'M','Y',NULL,NULL,67),(3093,7285,'Gantner Pigeon Systems','Gantner Pigeon Systems','A1','M2MTAG','Enterprise Customer',NULL,'A','Y',NULL,NULL,68),(3589,10069,'datamobile','datamobile','mobilkom liechtenstein',NULL,'Reseller',NULL,'L','N',NULL,NULL,69),(3639,10347,'Allgäuer Überlandwerk GmbH','Allgäuer Überlandwerk GmbH','A1 Digital DE','M2MTAG','Enterprise Customer',NULL,'ADE','Y',NULL,NULL,70),(3816,11368,'Hans Bodner Bau GmbH & Co KG','Hans Bodner Bau GmbH & Co KG','A1','M2MTAG','Enterprise Customer',NULL,'A','Y',NULL,NULL,71),(4503,15233,'A1 Strabag MPLS Backup','A1 Strabag MPLS Backup','M2MTAG','A1: Quarterly Billing Cycle','Enterprise Customer',NULL,'M','Y',NULL,NULL,72),(3513,9702,'ITBS','ITBS','mobilkom liechtenstein','M2MTAG','Enterprise Customer',NULL,'L','N',NULL,NULL,73),(3833,11533,'Mavoco','Mavoco','A1','mobilkom liechtenstein','Enterprise Customer',NULL,'A','Y',NULL,NULL,74),(4567,15584,'PROTRAIL Nika Debak s.p.','PROTRAIL Nika Debak s.p.','si.mobile','si.mobil','Enterprise Customer',NULL,'SM','Y',NULL,NULL,75),(4568,15587,'Heisl Solutions e.U.','Heisl Solutions e.U.','A1','M2MTAG: Quarterly Billing Cycle','Enterprise Customer',NULL,'A','Y',NULL,NULL,76),(3903,11944,'Altron','Altron','si.mobile','M2MTAG','Enterprise Customer',NULL,'SM','Y',NULL,NULL,77),(4206,13473,'Kölle- Zoo Management Services GmbH','Kölle- Zoo Management Services GmbH','A1 Digital DE','M2MTAG','Enterprise Customer',NULL,'ADE','Y',NULL,NULL,78),(4188,13437,'AUTOMATIC SERVIS d.o.o.','AUTOMATIC SERVIS d.o.o.','si.mobile','M2MTAG','Enterprise Customer',NULL,'SM','Y',NULL,NULL,79),(4208,13475,'Pink GmbH','Pink GmbH','A1','M2MTAG','Enterprise Customer',NULL,'A','Y',NULL,NULL,80),(4269,13697,'A1 TUS','A1 TUS','M2MTAG','A1','Enterprise Customer',NULL,'M','Y',NULL,NULL,81),(3774,11163,'mglass GmbH','mglass GmbH','M2MTAG','A1','Enterprise Customer',NULL,'M','Y',NULL,NULL,82),(3980,12514,'Nex Studio d.o.o.','Nex Studio d.o.o.','mobilkom liechtenstein','M2MTAG','Enterprise Customer',NULL,'L','Y',NULL,NULL,83),(4524,15351,'Weber Hydraulik GmbH','Weber Hydraulik GmbH','A1 Digital DE','A1','Enterprise Customer',NULL,'ADE','Y',NULL,NULL,84),(3864,11769,'Hilti AG','Hilti AG','M2MTAG','M2MTAG','Enterprise Customer',NULL,'M','Y',NULL,NULL,85),(3951,12353,'ISTOBAL Handelsges.m.b.H.','ISTOBAL Handelsges.m.b.H.','A1','M2MTAG','Enterprise Customer',NULL,'A','Y',NULL,NULL,86),(4002,12579,'PLEASE RE-USE','PLEASE RE-USE','A1','M2MTAG','Enterprise Customer',NULL,'A','N',NULL,NULL,87),(3990,12546,'ÖRK LV Steiermark','ÖRK LV Steiermark','A1','M2MTAG','Enterprise Customer',NULL,'A','Y',NULL,NULL,88),(3997,12564,'Tink Labs','Tink Labs','M2MTAG','A1','Enterprise Customer',NULL,'M','N',NULL,NULL,89),(4388,14414,'Rettungsdienst-Kooperation in Schleswig-Holstein GmbH','Rettungsdienst-Kooperation in Schleswig-Holstein GmbH','A1 Digital DE','M2MTAG','Enterprise Customer',NULL,'ADE','Y',NULL,NULL,90),(4183,13402,'A1 Telekom Austria Payment','A1 Telekom Austria Payment','M2MTAG','A1','Enterprise Customer',NULL,'M','Y',NULL,NULL,91),(3618,10274,'Energie Klagenfurt GmbH','Energie Klagenfurt GmbH','A1','M2MTAG','Enterprise Customer',NULL,'A','Y',NULL,NULL,92),(3719,10556,'CVS2','CVS2','si.mobile','M2MTAG','Enterprise Customer',NULL,'SM','Y',NULL,NULL,93),(4099,12939,'Komptech','Komptech','A1','M2MTAG','Enterprise Customer',NULL,'A','Y',NULL,NULL,94),(4228,13528,'C.Bergmann KG','C.Bergmann KG','A1','M2MTAG','Enterprise Customer',NULL,'A','Y',NULL,NULL,95),(4233,13553,'Transporte Wagner','Transporte Wagner','A1','M2MTAG','Enterprise Customer',NULL,'A','Y',NULL,NULL,96),(4243,13599,'GRZ IT Center GmbH','GRZ IT Center GmbH','M2MTAG','A1: Quarterly Billing Cycle','Enterprise Customer',NULL,'M','Y',NULL,NULL,97),(3539,9935,'Amplituda d.o.o.','Amplituda d.o.o.','si.mobile','M2MTAG','Enterprise Customer',NULL,'SM','Y',NULL,NULL,98),(3532,9902,'Protect Infra','Protect Infra','si.mobile','M2MTAG','Enterprise Customer',NULL,'SM','Y',NULL,NULL,99),(4062,12788,'Hawle Service Test','Hawle Service Test','M2MTAG','A1','Enterprise Customer',NULL,'M','Y',NULL,NULL,100),(4446,14700,'Topcon Deutschland Positioning GmbH','Topcon Deutschland Positioning GmbH','A1 Digital DE','A1','Enterprise Customer',NULL,'ADE','Y',NULL,NULL,101),(4894,28040,'Geomix GmbH','Geomix GmbH','A1','M2MTAG','Enterprise Customer',NULL,'A','Y',NULL,NULL,102),(5084,31303,'TITAN Electronic GmbH','TITAN Electronic GmbH','A1','M2MTAG','Enterprise Customer',NULL,'A','Y',NULL,NULL,103),(5090,31319,'Lebenshilfe Niederösterreich','Lebenshilfe Niederösterreich','A1','M2MTAG','Enterprise Customer',NULL,'A','Y',NULL,NULL,104),(5180,31769,'AISEMO GmbH','AISEMO GmbH','A1','M2MTAG','Enterprise Customer',NULL,'A','N',NULL,NULL,105),(4724,23978,'Rhätische Bahn AG','Rhätische Bahn AG','M2MTAG','M2MTAG','Enterprise Customer',NULL,'M','Y',NULL,NULL,106),(4820,26071,'A1 Mobility','A1 Mobility','M2MTAG','A1','Enterprise Customer',NULL,'M','Y',NULL,NULL,107);
/*!40000 ALTER TABLE `dic_new_opco` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dic_user_roles_lookup`
--

DROP TABLE IF EXISTS `dic_user_roles_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dic_user_roles_lookup` (
  `LEGACYROLE` varchar(100) DEFAULT NULL,
  `NEWROLE` varchar(100) DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dic_user_roles_lookup`
--

LOCK TABLES `dic_user_roles_lookup` WRITE;
/*!40000 ALTER TABLE `dic_user_roles_lookup` DISABLE KEYS */;
INSERT INTO `dic_user_roles_lookup` VALUES ('EC_ADMIN','EC Admin',1),('EC_USER','EC User',2),('EC_CSA','EC CSA',3),('EC_TEST_ADMIN','EC Test Admin',4),('EC_TEST_USER','EC Test User',5),('BU_ADMIN','BU Admin',6),('BU_USER','BU User',7),('BU_CSA','BU CSA',8),('BU_TEST_ADMIN','BU Test Admin',9),('BU_TEST_USER','BU Test User',10);
/*!40000 ALTER TABLE `dic_user_roles_lookup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `life_cycles`
--

DROP TABLE IF EXISTS `life_cycles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `life_cycles` (
  `ID` bigint DEFAULT NULL,
  `TYPE` varchar(255) DEFAULT NULL,
  `ENABLE_FLAG` varchar(255) DEFAULT NULL,
  `NAME` varchar(100) DEFAULT NULL,
  `IS_DELETED` varchar(16) DEFAULT NULL,
  `BUNDLE_ID` varchar(1024) DEFAULT NULL,
  `ENABLE_2G_SERVICE` varchar(1024) DEFAULT NULL,
  `ENABLE_3G_SERVICE` varchar(1024) DEFAULT NULL,
  `ENABLE_LTE_M_SERVICE` varchar(1024) DEFAULT NULL,
  `ENABLE_NB_IOT_SERVICE` varchar(1024) DEFAULT NULL,
  `ENABLE_NR_SERVICE` varchar(1024) DEFAULT NULL,
  `ACTIVE_SP_NUMBER` varchar(1024) DEFAULT NULL,
  `BU_ID` varchar(64) DEFAULT NULL,
  `BU_NAME` varchar(1024) DEFAULT NULL,
  `CUSTOMER_ID` varchar(64) DEFAULT NULL,
  `CUSTOMER_NAME` varchar(1024) DEFAULT NULL,
  `DESCRIPTION` varchar(1024) DEFAULT NULL,
  `OWNING_LIFECYCLE_TEMPLATE_ID` varchar(1024) DEFAULT NULL,
  `SP_NUMBER` varchar(100) DEFAULT NULL,
  `VERSION_NUMBER` varchar(100) DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `life_cycles`
--

LOCK TABLES `life_cycles` WRITE;
/*!40000 ALTER TABLE `life_cycles` DISABLE KEYS */;
/*!40000 ALTER TABLE `life_cycles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loading_summary`
--

DROP TABLE IF EXISTS `loading_summary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loading_summary` (
  `entity_type` varchar(255) DEFAULT NULL,
  `total_count` int DEFAULT NULL,
  `success_count` int DEFAULT NULL,
  `failure_count` int DEFAULT NULL,
  `execution_time` int DEFAULT NULL,
  `create_date` date DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loading_summary`
--

LOCK TABLES `loading_summary` WRITE;
/*!40000 ALTER TABLE `loading_summary` DISABLE KEYS */;
INSERT INTO `loading_summary` VALUES ('Enterprise Customer',1,1,0,17,'2025-04-28',1),('Business Unit',2,2,0,44,'2025-04-28',2),('Role and Access',3,3,0,5,'2025-04-28',3),('User',3,3,0,9,'2025-04-28',4),('Report Subscriptions',0,0,0,4,'2025-04-28',5),('Role and Access',3,3,0,5,'2025-04-28',6),('Enterprise Customer',1,1,0,18,'2025-04-29',7),('Business Unit',2,2,0,44,'2025-04-29',8),('Role and Access',3,3,0,5,'2025-04-29',9),('User',3,3,0,9,'2025-04-29',10),('Enterprise Customer',1,0,1,3,'2025-04-29',11),('Enterprise Customer',1,1,0,45,'2025-04-29',12),('Business Unit',2,2,0,59,'2025-04-29',13),('Role and Access',3,3,0,5,'2025-04-29',14),('User',3,3,0,9,'2025-04-29',15),('Enterprise Customer',1,1,0,37,'2025-04-29',16),('Business Unit',2,2,0,166,'2025-04-29',17),('Enterprise Customer',1,1,0,18,'2025-04-29',18),('Business Unit',2,2,0,102,'2025-04-29',19),('Enterprise Customer',1,1,0,18,'2025-04-29',20),('Business Unit',2,2,0,119,'2025-04-29',21),('Enterprise Customer',1,1,0,18,'2025-04-29',22),('Business Unit',2,2,0,132,'2025-04-29',23),('Role and Access',3,3,0,5,'2025-04-29',24),('User',3,3,0,9,'2025-04-29',25),('Enterprise Customer',1,1,0,26,'2025-05-07',26),('Business Unit',2,2,0,76,'2025-05-07',27),('Cost_Center',0,0,0,7,'2025-05-07',28),('Role and Access',3,3,0,6,'2025-05-07',29),('User',3,3,0,9,'2025-05-07',30),('Report Subscriptions',0,0,0,10,'2025-05-07',31),('Apn',1,0,1,60,'2025-05-07',32),('Apn',1,0,1,15,'2025-05-07',33),('Apn',1,0,1,15,'2025-05-07',34),('Notification Template',2,2,0,7,'2025-05-07',35);
/*!40000 ALTER TABLE `loading_summary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `parent_id_mapping`
--

DROP TABLE IF EXISTS `parent_id_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `parent_id_mapping` (
  `id` varchar(255) DEFAULT NULL,
  `crm_id` varchar(255) DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `parent_id_mapping`
--

LOCK TABLES `parent_id_mapping` WRITE;
/*!40000 ALTER TABLE `parent_id_mapping` DISABLE KEYS */;
INSERT INTO `parent_id_mapping` VALUES ('41011','35572',1);
/*!40000 ALTER TABLE `parent_id_mapping` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_table_list`
--

DROP TABLE IF EXISTS `role_table_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_table_list` (
  `roleDescription` varchar(255) DEFAULT NULL,
  `roleToScreenList` json DEFAULT NULL,
  `roleToTabList` json DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_table_list`
--

LOCK TABLES `role_table_list` WRITE;
/*!40000 ALTER TABLE `role_table_list` DISABLE KEYS */;
INSERT INTO `role_table_list` VALUES ('EC_ADMIN','[{\"access\": \"RW\", \"screen\": {\"id\": \"16\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"49\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"17\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"18\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"48\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"6\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"15\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"47\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"11\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"31\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"85\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"12\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"13\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"95\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"107\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"41\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"42\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"67\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"69\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"111\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"3\", \"type\": \"state\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"10\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"71\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"23\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"70\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"1003\", \"type\": \"screen\"}}]','[{\"tab\": {\"id\": \"1\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"2\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"4\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"5\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"6\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"7\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"8\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"9\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"10\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"11\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"16\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"17\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"18\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"19\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"20\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"22\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"24\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"25\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"26\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"27\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"28\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"29\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"30\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"35\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"36\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"37\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"39\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"40\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"41\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"42\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"43\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"45\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"46\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"47\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"48\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"49\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"50\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"51\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"52\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"56\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"57\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"58\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"59\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"60\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"61\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"62\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"63\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"64\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"65\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"66\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"67\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"68\"}, \"access\": \"RW\"}]',1),('EC_USER','[{\"access\": \"R\", \"screen\": {\"id\": \"48\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"6\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"15\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"47\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"85\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"12\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"13\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"95\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"41\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"42\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"111\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"3\", \"type\": \"state\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"10\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"49\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"17\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"71\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"23\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"70\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"1003\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"16\", \"type\": \"screen\"}}]','[{\"tab\": {\"id\": \"1\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"2\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"4\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"5\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"6\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"7\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"8\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"9\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"10\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"11\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"16\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"17\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"18\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"19\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"20\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"22\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"24\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"25\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"26\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"27\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"28\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"29\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"30\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"35\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"36\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"37\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"39\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"40\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"41\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"42\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"43\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"45\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"46\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"47\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"48\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"49\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"50\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"51\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"52\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"56\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"57\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"58\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"59\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"60\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"61\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"62\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"63\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"64\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"65\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"66\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"67\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"68\"}, \"access\": \"R\"}]',2),('EC_CSA','[{\"access\": \"R\", \"screen\": {\"id\": \"16\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"49\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"17\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"18\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"48\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"6\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"15\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"47\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"85\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"12\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"13\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"95\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"42\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"67\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"69\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"111\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"3\", \"type\": \"state\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"10\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"71\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"23\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"70\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"1003\", \"type\": \"screen\"}}]','[{\"tab\": {\"id\": \"1\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"2\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"4\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"5\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"6\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"7\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"8\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"9\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"10\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"11\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"16\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"17\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"18\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"19\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"20\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"22\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"24\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"25\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"26\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"27\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"28\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"29\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"30\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"35\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"36\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"37\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"39\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"40\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"41\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"42\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"43\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"45\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"46\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"47\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"48\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"49\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"50\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"51\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"52\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"56\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"57\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"58\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"59\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"60\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"61\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"62\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"63\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"64\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"65\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"66\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"67\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"68\"}, \"access\": \"R\"}]',3),('BU_ADMIN','[{\"access\": \"RW\", \"screen\": {\"id\": \"16\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"49\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"17\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"18\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"48\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"6\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"15\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"47\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"11\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"31\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"85\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"12\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"13\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"95\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"107\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"41\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"42\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"67\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"69\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"111\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"3\", \"type\": \"state\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"10\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"71\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"23\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"70\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"1003\", \"type\": \"screen\"}}]','[{\"tab\": {\"id\": \"1\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"2\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"4\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"5\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"6\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"7\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"8\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"9\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"10\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"11\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"16\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"17\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"18\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"19\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"20\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"22\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"24\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"25\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"26\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"27\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"28\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"29\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"30\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"35\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"36\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"37\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"39\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"40\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"41\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"42\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"43\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"45\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"46\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"47\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"48\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"49\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"50\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"51\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"52\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"56\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"57\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"58\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"59\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"60\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"61\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"62\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"63\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"64\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"65\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"66\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"67\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"68\"}, \"access\": \"R\"}]',4),('BU_USER','[{\"access\": \"R\", \"screen\": {\"id\": \"48\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"6\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"15\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"47\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"85\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"12\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"13\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"95\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"41\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"42\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"111\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"3\", \"type\": \"state\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"10\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"49\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"17\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"71\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"23\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"70\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"1003\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"16\", \"type\": \"screen\"}}]','[{\"tab\": {\"id\": \"1\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"2\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"4\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"5\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"6\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"7\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"8\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"9\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"10\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"11\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"16\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"17\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"18\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"19\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"20\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"22\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"24\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"25\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"26\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"27\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"28\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"29\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"30\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"35\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"36\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"37\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"39\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"40\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"41\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"42\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"43\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"45\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"46\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"47\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"48\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"49\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"50\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"51\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"52\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"56\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"57\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"58\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"59\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"60\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"61\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"62\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"63\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"64\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"65\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"66\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"67\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"68\"}, \"access\": \"R\"}]',5),('BU_CSA','[{\"access\": \"R\", \"screen\": {\"id\": \"16\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"49\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"17\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"18\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"48\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"6\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"15\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"47\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"85\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"12\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"13\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"95\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"41\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"42\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"67\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"69\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"111\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"3\", \"type\": \"state\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"10\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"71\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"23\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"70\", \"type\": \"screen\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"1003\", \"type\": \"screen\"}}]','[{\"tab\": {\"id\": \"1\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"2\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"4\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"5\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"6\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"7\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"8\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"9\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"10\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"11\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"16\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"17\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"18\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"19\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"20\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"22\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"24\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"25\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"26\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"27\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"28\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"29\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"30\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"35\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"36\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"37\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"39\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"40\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"41\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"42\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"43\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"45\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"46\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"47\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"48\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"49\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"50\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"51\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"52\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"56\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"57\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"58\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"59\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"60\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"61\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"62\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"63\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"64\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"65\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"66\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"67\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"68\"}, \"access\": \"R\"}]',6);
/*!40000 ALTER TABLE `role_table_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_table_list_backup`
--

DROP TABLE IF EXISTS `role_table_list_backup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_table_list_backup` (
  `roleDescription` varchar(255) DEFAULT NULL,
  `roleToScreenList` json DEFAULT NULL,
  `roleToTabList` json DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_table_list_backup`
--

LOCK TABLES `role_table_list_backup` WRITE;
/*!40000 ALTER TABLE `role_table_list_backup` DISABLE KEYS */;
INSERT INTO `role_table_list_backup` VALUES ('EC_ADMIN_TEST','[{\"access\": \"R\", \"screen\": {\"id\": \"47\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"10\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"13\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"111\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"504\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"49\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"17\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"71\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"23\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"70\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"132\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"6\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"1002\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"131\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"16\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"133\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"3\", \"type\": \"state\"}}]','[{\"tab\": {\"id\": \"1\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"5\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"9\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"11\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"2\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"4\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"8\"}, \"access\": \"RW\"}]',1),('EC ADMIN ','[{\"access\": \"R\", \"screen\": {\"id\": \"47\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"10\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"13\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"111\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"504\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"49\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"17\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"71\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"23\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"70\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"132\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"6\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"1002\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"131\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"16\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"133\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"3\", \"type\": \"state\"}}]','[{\"tab\": {\"id\": \"1\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"5\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"9\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"11\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"2\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"4\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"8\"}, \"access\": \"RW\"}]',2),('EC Admin ','[{\"access\": \"R\", \"screen\": {\"id\": \"47\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"10\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"13\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"111\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"504\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"49\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"17\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"71\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"23\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"70\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"132\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"6\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"1002\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"131\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"16\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"133\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"3\", \"type\": \"state\"}}]','[{\"tab\": {\"id\": \"1\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"5\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"9\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"11\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"2\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"4\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"8\"}, \"access\": \"RW\"}]',3),('EC_ADMIN ','[{\"access\": \"R\", \"screen\": {\"id\": \"47\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"10\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"13\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"111\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"504\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"49\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"17\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"71\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"23\"}}, {\"access\": \"R\", \"screen\": {\"id\": \"70\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"132\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"6\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"1002\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"131\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"16\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"133\", \"type\": \"screen\"}}, {\"access\": \"RW\", \"screen\": {\"id\": \"3\", \"type\": \"state\"}}]','[{\"tab\": {\"id\": \"1\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"5\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"9\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"11\"}, \"access\": \"R\"}, {\"tab\": {\"id\": \"2\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"4\"}, \"access\": \"RW\"}, {\"tab\": {\"id\": \"8\"}, \"access\": \"RW\"}]',4);
/*!40000 ALTER TABLE `role_table_list_backup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_profiles`
--

DROP TABLE IF EXISTS `service_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_profiles` (
  `ID` int DEFAULT NULL,
  `TYPENAME` varchar(255) DEFAULT NULL,
  `ENABLED_FLAG` varchar(255) DEFAULT NULL,
  `NAME` varchar(100) DEFAULT NULL,
  `DIC_TYPE_ID` int DEFAULT NULL,
  `RADIUS_AUTH_PASSWORD` varchar(128) DEFAULT NULL,
  `OWNING_LIFECYCLE_ID` varchar(128) DEFAULT NULL,
  `ENABLE_SMS_MT` varchar(128) DEFAULT NULL,
  `RADIUS_AUTH_USER_NAME` varchar(128) DEFAULT NULL,
  `INITIAL_SERVICE_PROFILE` varchar(128) DEFAULT NULL,
  `ENABLE_ROAMING_PROFILE` varchar(128) DEFAULT NULL,
  `ALLOW_MANUAL_TRANSITION` varchar(128) DEFAULT NULL,
  `APN_SELECTION` varchar(128) DEFAULT NULL,
  `ALLOW_AUTOMATIC_TRIGGER_TRANSITION` varchar(128) DEFAULT NULL,
  `DESCRIPTION` varchar(128) DEFAULT NULL,
  `ENABLE_SMS_MO` varchar(128) DEFAULT NULL,
  `PROFILE_ADDITIONAL_ATTRIBUTE_IS_DELETED` varchar(128) DEFAULT NULL,
  `BUNDLE_ID` varchar(32) DEFAULT NULL,
  `BUNDLE` varchar(128) DEFAULT NULL,
  `TARIFF_PLAN_ID` varchar(32) DEFAULT NULL,
  `TARIFF_PLAN_VARIANT` varchar(128) DEFAULT NULL,
  `TARIFF_PLAN` varchar(128) DEFAULT NULL,
  `TARIFF_PLAN_VARIANT_ID` varchar(32) DEFAULT NULL,
  `BUNDLE_SIZE_ID` varchar(32) DEFAULT NULL,
  `BUNDLE_SIZE` varchar(32) DEFAULT NULL,
  `PERCENTAGE` varchar(128) DEFAULT NULL,
  `PERCENTAGE_ID` varchar(32) DEFAULT NULL,
  `APN_ID` varchar(32) DEFAULT NULL,
  `ENABLE_LTE_SERVICE` varchar(128) DEFAULT NULL,
  `ENABLE_NB_IOT_SERVICE` varchar(128) DEFAULT NULL,
  `OWNING_SERVICE_PROFILE_TEMPLATE_ID` varchar(128) DEFAULT NULL,
  `PROFILE_ADDITIONAL_ATTRIBUTE_VERSION_NUMBER` varchar(128) DEFAULT NULL,
  `WHOLESALE_TARIFF_PLAN_ID` varchar(128) DEFAULT NULL,
  `WHOLESALE_TARIFF_PLAN` varchar(128) DEFAULT NULL,
  `ROAMING_PROFILE_FOR_SOR_ID` varchar(128) DEFAULT NULL,
  `ENABLE_VOICE_SERVICE` varchar(128) DEFAULT NULL,
  `ROAMING_PROFILE_FOR_HLR_ID` varchar(128) DEFAULT NULL,
  `ENABLE_3G_SERVICE` varchar(128) DEFAULT NULL,
  `ENABLE_2G_SERVICE` varchar(128) DEFAULT NULL,
  `ENABLE_NR_SERVICE` varchar(128) DEFAULT NULL,
  `ENABLE_LTE_M_SERVICE` varchar(128) DEFAULT NULL,
  `APN_NAME` varchar(128) DEFAULT NULL,
  `VOICE_ENABLE_WAITING` varchar(128) DEFAULT NULL,
  `VOICE_ENABLE_CLIR` varchar(128) DEFAULT NULL,
  `VOICE_ENABLE_CLIP` varchar(128) DEFAULT NULL,
  `VOICE_CLIP_OVERRIDE` varchar(128) DEFAULT NULL,
  `ENABLE_DATA` varchar(128) DEFAULT NULL,
  `ROAMING_PROFILE_FOR_HLR` varchar(128) DEFAULT NULL,
  `ROAMING_PROFILE_FOR_SOR` varchar(128) DEFAULT NULL,
  `RADIUS_AUTH` varchar(128) DEFAULT NULL,
  `DIAMETER_GRANTED_SERVICE_UNITS` varchar(128) DEFAULT NULL,
  `DATA_BANDWITH` varchar(128) DEFAULT NULL,
  `GGSN_DIAMETER_PROFILE` varchar(128) DEFAULT NULL,
  `TYPE` varchar(128) DEFAULT NULL,
  `FIREWALL_POLICY` varchar(128) DEFAULT NULL,
  `ENABLE_SMS_MT_TYPE` varchar(128) DEFAULT NULL,
  `RADIUS_AUTH_TYPE` varchar(128) DEFAULT NULL,
  `ENABLE_SMS_MO_TYPE` varchar(128) DEFAULT NULL,
  `PERCENTAGE_TYPE` varchar(128) DEFAULT NULL,
  `NAME_TYPE` varchar(128) DEFAULT NULL,
  `TARIFF_PLAN_ID_TYPE` varchar(32) DEFAULT NULL,
  `TYPE_TYPE` varchar(128) DEFAULT NULL,
  `DESCRIPTION_TYPE` varchar(128) DEFAULT NULL,
  `APN_SELECTION_TYPE` varchar(128) DEFAULT NULL,
  `INITIAL_SERVICE_PROFILE_TYPE` varchar(128) DEFAULT NULL,
  `RADIUS_AUTH_USER_NAME_TYPE` varchar(128) DEFAULT NULL,
  `ROAMING_PROFILE_FOR_HLR_TYPE` varchar(128) DEFAULT NULL,
  `FIREWALL_POLICY_TYPE` varchar(128) DEFAULT NULL,
  `BUNDLE_SIZE_TYPE` varchar(128) DEFAULT NULL,
  `ROAMING_PROFILE_FOR_SOR_TYPE` varchar(128) DEFAULT NULL,
  `DIAMETER_GRANTED_SERVICE_UNITS_TYPE` varchar(128) DEFAULT NULL,
  `WHOLESALE_TARIFF_PLAN_ID_TYPE` varchar(128) DEFAULT NULL,
  `RADIUS_AUTH_PASSWORD_TYPE` varchar(128) DEFAULT NULL,
  `GGSN_DIAMETER_PROFILE_TYPE` varchar(128) DEFAULT NULL,
  `BUNDLE_ID_TYPE` varchar(128) DEFAULT NULL,
  `ENABLE_ROAMING_PROFILE_TYPE` varchar(128) DEFAULT NULL,
  `ALLOW_MANUAL_TRANSITION_TYPE` varchar(128) DEFAULT NULL,
  `DATA_BANDWITH_TYPE` varchar(128) DEFAULT NULL,
  `ALLOW_AUTOMATIC_TRIGGER_TRANSITION_TYPE` varchar(128) DEFAULT NULL,
  `USE_STATIC_IP` varchar(128) DEFAULT NULL,
  `USE_STATIC_IP_TYPE` varchar(128) DEFAULT NULL,
  `APN_NAME_TYPE` varchar(128) DEFAULT NULL,
  `ENABLE_LTE_SERVICE_TYPE` varchar(128) DEFAULT NULL,
  `VOICE_OUTGOING_BARRING_TYPE` varchar(128) DEFAULT NULL,
  `VOICE_ENABLE_CLIR_TYPE` varchar(128) DEFAULT NULL,
  `VOICE_CLIP_OVERRIDE_TYPE` varchar(128) DEFAULT NULL,
  `ENABLE_VOICE_SERVICE_TYPE` varchar(128) DEFAULT NULL,
  `VOICE_INCOMING_BARRING_TYPE` varchar(128) DEFAULT NULL,
  `VOICE_ENABLE_WAITING_TYPE` varchar(128) DEFAULT NULL,
  `VOICE_OUTGOING_BARRING` varchar(128) DEFAULT NULL,
  `VOICE_INCOMING_BARRING` varchar(128) DEFAULT NULL,
  `VOICE_ENABLE_CLIP_TYPE` varchar(128) DEFAULT NULL,
  `VOICE_CLIR_MODE` varchar(128) DEFAULT NULL,
  `APN_ID_TYPE` varchar(32) DEFAULT NULL,
  `ROAMING_PROFILE_FOR_HLR_ID_TYPE` varchar(128) DEFAULT NULL,
  `ROAMING_PROFILE_FOR_SOR_ID_TYPE` varchar(128) DEFAULT NULL,
  `VOICE_CLIR_MODE_TYPE` varchar(128) DEFAULT NULL,
  `ENABLE_2G_SERVICE_TYPE` varchar(128) DEFAULT NULL,
  `ENABLE_3G_SERVICE_TYPE` varchar(128) DEFAULT NULL,
  `ENABLE_LTE_M_SERVICE_TYPE` varchar(128) DEFAULT NULL,
  `ENABLE_NR_SERVICE_TYPE` varchar(128) DEFAULT NULL,
  `ENABLE_NB_IOT_SERVICE_TYPE` varchar(128) DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_profiles`
--

LOCK TABLES `service_profiles` WRITE;
/*!40000 ALTER TABLE `service_profiles` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tab_list`
--

DROP TABLE IF EXISTS `tab_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tab_list` (
  `Static_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tab_list`
--

LOCK TABLES `tab_list` WRITE;
/*!40000 ALTER TABLE `tab_list` DISABLE KEYS */;
INSERT INTO `tab_list` VALUES ('[\r\n    {\r\n        \"id\": 1,\r\n        \"createDate\": \"2024-02-21 15:53:10\",\r\n        \"errorCode\": 0,\r\n        \"errorMessage\": null,\r\n        \"tabName\": \"GENERAL DATA\",\r\n        \"tabOrder\": 1,\r\n        \"parentScreenId\": 6,\r\n        \"tabType\": \"ManageDevice\",\r\n        \"access\": true,\r\n        \"accessType\": \"RW\",\r\n        \"showView\": null\r\n    },\r\n    {\r\n        \"id\": 2,\r\n        \"createDate\": \"2024-02-21 15:53:10\",\r\n        \"errorCode\": 0,\r\n        \"errorMessage\": null,\r\n        \"tabName\": \"NETWORK AND SESSION DETAILS\",\r\n        \"tabOrder\": 2,\r\n        \"parentScreenId\": 6,\r\n        \"tabType\": \"ManageDevice\",\r\n        \"access\": true,\r\n        \"accessType\": \"RW\",\r\n        \"showView\": null\r\n    },\r\n    {\r\n        \"id\": 3,\r\n        \"createDate\": \"2024-02-21 15:53:10\",\r\n        \"errorCode\": 0,\r\n        \"errorMessage\": null,\r\n        \"tabName\": \"BILLING DATA\",\r\n        \"tabOrder\": 3,\r\n        \"parentScreenId\": 6,\r\n        \"tabType\": \"ManageDevice\",\r\n        \"access\": true,\r\n        \"accessType\": \"RW\",\r\n        \"showView\": null\r\n    },\r\n    {\r\n        \"id\": 4,\r\n        \"createDate\": \"2024-02-21 15:53:10\",\r\n        \"errorCode\": 0,\r\n        \"errorMessage\": null,\r\n        \"tabName\": \"DATA PLAN DETAILS\",\r\n        \"tabOrder\": 4,\r\n        \"parentScreenId\": 6,\r\n        \"tabType\": \"ManageDevice\",\r\n        \"access\": true,\r\n        \"accessType\": \"RW\",\r\n        \"showView\": null\r\n    },\r\n    {\r\n        \"id\": 5,\r\n        \"createDate\": \"2024-02-21 15:53:10\",\r\n        \"errorCode\": 0,\r\n        \"errorMessage\": null,\r\n        \"tabName\": \"USAGE\",\r\n        \"tabOrder\": 5,\r\n        \"parentScreenId\": 6,\r\n        \"tabType\": \"ManageDevice\",\r\n        \"access\": true,\r\n        \"accessType\": \"RW\",\r\n        \"showView\": null\r\n    },\r\n    {\r\n        \"id\": 7,\r\n        \"createDate\": \"2024-02-21 15:53:10\",\r\n        \"errorCode\": 0,\r\n        \"errorMessage\": null,\r\n        \"tabName\": \"DATA PLAN PURCHASE HISTORY\",\r\n        \"tabOrder\": 7,\r\n        \"parentScreenId\": 6,\r\n        \"tabType\": \"ManageDevice\",\r\n        \"access\": true,\r\n        \"accessType\": \"RW\",\r\n        \"showView\": null\r\n    },\r\n    {\r\n        \"id\": 8,\r\n        \"createDate\": \"2024-02-21 15:53:10\",\r\n        \"errorCode\": 0,\r\n        \"errorMessage\": null,\r\n        \"tabName\": \"SUBSCRIBER DETAILS\",\r\n        \"tabOrder\": 8,\r\n        \"parentScreenId\": 6,\r\n        \"tabType\": \"ManageDevice\",\r\n        \"access\": true,\r\n        \"accessType\": \"RW\",\r\n        \"showView\": null\r\n    },\r\n    {\r\n        \"id\": 9,\r\n        \"createDate\": \"2024-02-21 15:53:10\",\r\n        \"errorCode\": 0,\r\n        \"errorMessage\": null,\r\n        \"tabName\": \"NOTES\",\r\n        \"tabOrder\": 9,\r\n        \"parentScreenId\": 6,\r\n        \"tabType\": \"ManageDevice\",\r\n        \"access\": true,\r\n        \"accessType\": \"RW\",\r\n        \"showView\": null\r\n    },\r\n    {\r\n        \"id\": 10,\r\n        \"createDate\": \"2024-02-21 15:53:10\",\r\n        \"errorCode\": 0,\r\n        \"errorMessage\": null,\r\n        \"tabName\": \"TROUBLESHOOT\",\r\n        \"tabOrder\": 10,\r\n        \"parentScreenId\": 6,\r\n        \"tabType\": \"ManageDevice\",\r\n        \"access\": true,\r\n        \"accessType\": \"RW\",\r\n        \"showView\": null\r\n    },\r\n    {\r\n        \"id\": 11,\r\n        \"createDate\": \"2024-02-21 15:53:10\",\r\n        \"errorCode\": 0,\r\n        \"errorMessage\": null,\r\n        \"tabName\": \"eUICC Details\",\r\n        \"tabOrder\": 11,\r\n        \"parentScreenId\": 6,\r\n        \"tabType\": \"ManageDevice\",\r\n        \"access\": true,\r\n        \"accessType\": \"RW\",\r\n        \"showView\": null\r\n    },\r\n    {\r\n        \"id\": 12,\r\n        \"createDate\": \"2024-02-21 15:53:10\",\r\n        \"errorCode\": 0,\r\n        \"errorMessage\": null,\r\n        \"tabName\": \"Subscriber Info\",\r\n        \"tabOrder\": 12,\r\n        \"parentScreenId\": 6,\r\n        \"tabType\": \"ManageDevice\",\r\n        \"access\": true,\r\n        \"accessType\": \"RW\",\r\n        \"showView\": null\r\n    },\r\n    {\r\n        \"id\": 16,\r\n        \"createDate\": \"2024-02-21 15:53:10\",\r\n        \"errorCode\": 0,\r\n        \"errorMessage\": null,\r\n        \"tabName\": \"APN\",\r\n        \"tabOrder\": 13,\r\n        \"parentScreenId\": 6,\r\n        \"tabType\": \"ManageDevice\",\r\n        \"access\": true,\r\n        \"accessType\": \"RW\",\r\n        \"showView\": null\r\n    },\r\n    {\r\n        \"id\": 18,\r\n        \"createDate\": \"2024-02-21 15:53:10\",\r\n        \"errorCode\": 0,\r\n        \"errorMessage\": null,\r\n        \"tabName\": \"Usage Amount\",\r\n        \"tabOrder\": 15,\r\n        \"parentScreenId\": 6,\r\n        \"tabType\": \"ManageDevice\",\r\n        \"access\": true,\r\n        \"accessType\": \"RW\",\r\n        \"showView\": null\r\n    },\r\n    {\r\n        \"id\": 19,\r\n        \"createDate\": \"2024-02-21 15:53:10\",\r\n        \"errorCode\": 0,\r\n        \"errorMessage\": null,\r\n        \"tabName\": \"SIM State Change (No. of Days)\",\r\n        \"tabOrder\": 32,\r\n        \"parentScreenId\": 39,\r\n        \"tabType\": \"Trigger\",\r\n        \"access\": true,\r\n        \"accessType\": \"RW\",\r\n        \"showView\": null\r\n    },\r\n    {\r\n        \"id\": 20,\r\n        \"createDate\": \"2024-02-21 15:53:10\",\r\n        \"errorCode\": 0,\r\n        \"errorMessage\": null,\r\n        \"tabName\": \"Device Plan Threshold (With SIM State)\",\r\n        \"tabOrder\": 32,\r\n        \"parentScreenId\": 39,\r\n        \"tabType\": \"Trigger\",\r\n        \"access\": true,\r\n        \"accessType\": \"RW\",\r\n        \"showView\": null\r\n    },\r\n    {\r\n        \"id\": 22,\r\n        \"createDate\": \"2024-02-21 15:53:10\",\r\n        \"errorCode\": 0,\r\n        \"errorMessage\": null,\r\n        \"tabName\": \"Remove Addon Plan\",\r\n        \"tabOrder\": 35,\r\n        \"parentScreenId\": 39,\r\n        \"tabType\": \"Action\",\r\n        \"access\": true,\r\n        \"accessType\": \"RW\",\r\n        \"showView\": null\r\n    },\r\n    {\r\n        \"id\": 24,\r\n        \"createDate\": \"2024-02-21 15:53:10\",\r\n        \"errorCode\": 0,\r\n        \"errorMessage\": null,\r\n        \"tabName\": \"IP Pooling\",\r\n        \"tabOrder\": 37,\r\n        \"parentScreenId\": 6,\r\n        \"tabType\": \"ManageDevice\",\r\n        \"access\": true,\r\n        \"accessType\": \"RW\",\r\n        \"showView\": null\r\n    },\r\n    {\r\n        \"id\": 25,\r\n        \"createDate\": \"2024-02-21 15:53:10\",\r\n        \"errorCode\": 0,\r\n        \"errorMessage\": null,\r\n        \"tabName\": \"Registration in Zone\",\r\n        \"tabOrder\": 38,\r\n        \"parentScreenId\": 39,\r\n        \"tabType\": \"Trigger\",\r\n        \"access\": true,\r\n        \"accessType\": \"RW\",\r\n        \"showView\": null\r\n    },\r\n    {\r\n        \"id\": 26,\r\n        \"createDate\": \"2024-02-21 15:53:10\",\r\n        \"errorCode\": 0,\r\n        \"errorMessage\": null,\r\n        \"tabName\": \"System Notification\",\r\n        \"tabOrder\": 1,\r\n        \"parentScreenId\": 110,\r\n        \"tabType\": \"notificationtemplate\",\r\n        \"access\": true,\r\n        \"accessType\": \"RW\",\r\n        \"showView\": null\r\n    },\r\n    {\r\n        \"id\": 27,\r\n        \"createDate\": \"2024-02-21 15:53:10\",\r\n        \"errorCode\": 0,\r\n        \"errorMessage\": null,\r\n        \"tabName\": \"Trigger Notification\",\r\n        \"tabOrder\": 2,\r\n        \"parentScreenId\": 110,\r\n        \"tabType\": \"notificationtemplate\",\r\n        \"access\": true,\r\n        \"accessType\": \"RW\",\r\n        \"showView\": null\r\n    },\r\n    {\r\n        \"id\": 39,\r\n        \"createDate\": \"2024-02-21 15:53:10\",\r\n        \"errorCode\": 0,\r\n        \"errorMessage\": null,\r\n        \"tabName\": \"Change in country and operator\",\r\n        \"tabOrder\": 45,\r\n        \"parentScreenId\": 39,\r\n        \"tabType\": \"Trigger\",\r\n        \"access\": true,\r\n        \"accessType\": \"RW\",\r\n        \"showView\": null\r\n    },\r\n    {\r\n        \"id\": 1000,\r\n        \"createDate\": \"2024-02-21 15:53:10\",\r\n        \"errorCode\": 0,\r\n        \"errorMessage\": null,\r\n        \"tabName\": \"Usage Monitoring\",\r\n        \"tabOrder\": 15,\r\n        \"parentScreenId\": 39,\r\n        \"tabType\": \"Trigger\",\r\n        \"access\": true,\r\n        \"accessType\": \"RW\",\r\n        \"showView\": null\r\n    },\r\n    {\r\n        \"id\": 1002,\r\n        \"createDate\": \"2024-02-21 15:53:10\",\r\n        \"errorCode\": 0,\r\n        \"errorMessage\": null,\r\n        \"tabName\": \"IMEI change\",\r\n        \"tabOrder\": 17,\r\n        \"parentScreenId\": 39,\r\n        \"tabType\": \"Trigger\",\r\n        \"access\": true,\r\n        \"accessType\": \"RW\",\r\n        \"showView\": null\r\n    },\r\n    {\r\n        \"id\": 1003,\r\n        \"createDate\": \"2024-02-21 15:53:10\",\r\n        \"errorCode\": 0,\r\n        \"errorMessage\": null,\r\n        \"tabName\": \"Data Session count\",\r\n        \"tabOrder\": 18,\r\n        \"parentScreenId\": 39,\r\n        \"tabType\": \"Trigger\",\r\n        \"access\": true,\r\n        \"accessType\": \"RW\",\r\n        \"showView\": null\r\n    },\r\n    {\r\n        \"id\": 1004,\r\n        \"createDate\": \"2024-02-21 15:53:10\",\r\n        \"errorCode\": 0,\r\n        \"errorMessage\": null,\r\n        \"tabName\": \"Device Plan Change (No. of Days)\",\r\n        \"tabOrder\": 19,\r\n        \"parentScreenId\": 39,\r\n        \"tabType\": \"Trigger\",\r\n        \"access\": true,\r\n        \"accessType\": \"RW\",\r\n        \"showView\": null\r\n    },\r\n    {\r\n        \"id\": 1005,\r\n        \"createDate\": \"2024-02-21 15:53:10\",\r\n        \"errorCode\": 0,\r\n        \"errorMessage\": null,\r\n        \"tabName\": \"Device Plan First Usage\",\r\n        \"tabOrder\": 20,\r\n        \"parentScreenId\": 39,\r\n        \"tabType\": \"Trigger\",\r\n        \"access\": true,\r\n        \"accessType\": \"RW\",\r\n        \"showView\": null\r\n    },\r\n    {\r\n        \"id\": 1006,\r\n        \"createDate\": \"2024-02-21 15:53:10\",\r\n        \"errorCode\": 0,\r\n        \"errorMessage\": null,\r\n        \"tabName\": \"Device Plan Threshold (Bill to Date)\",\r\n        \"tabOrder\": 21,\r\n        \"parentScreenId\": 39,\r\n        \"tabType\": \"Trigger\",\r\n        \"access\": true,\r\n        \"accessType\": \"RW\",\r\n        \"showView\": null\r\n    },\r\n    {\r\n        \"id\": 1007,\r\n        \"createDate\": \"2024-02-21 15:53:10\",\r\n        \"errorCode\": 0,\r\n        \"errorMessage\": null,\r\n        \"tabName\": \"SIM Device Plan Change\",\r\n        \"tabOrder\": 22,\r\n        \"parentScreenId\": 39,\r\n        \"tabType\": \"Trigger\",\r\n        \"access\": true,\r\n        \"accessType\": \"RW\",\r\n        \"showView\": null\r\n    },\r\n    {\r\n        \"id\": 1008,\r\n        \"createDate\": \"2024-02-21 15:53:10\",\r\n        \"errorCode\": 0,\r\n        \"errorMessage\": null,\r\n        \"tabName\": \"SIM State Change\",\r\n        \"tabOrder\": 23,\r\n        \"parentScreenId\": 39,\r\n        \"tabType\": \"Trigger\",\r\n        \"access\": true,\r\n        \"accessType\": \"RW\",\r\n        \"showView\": null\r\n    },\r\n    {\r\n        \"id\": 1011,\r\n        \"createDate\": \"2024-02-21 15:53:10\",\r\n        \"errorCode\": 0,\r\n        \"errorMessage\": null,\r\n        \"tabName\": \"Email\",\r\n        \"tabOrder\": 26,\r\n        \"parentScreenId\": 39,\r\n        \"tabType\": \"Action\",\r\n        \"access\": true,\r\n        \"accessType\": \"RW\",\r\n        \"showView\": null\r\n    },\r\n    {\r\n        \"id\": 1012,\r\n        \"createDate\": \"2024-02-21 15:53:10\",\r\n        \"errorCode\": 0,\r\n        \"errorMessage\": null,\r\n        \"tabName\": \"SMS\",\r\n        \"tabOrder\": 27,\r\n        \"parentScreenId\": 39,\r\n        \"tabType\": \"Action\",\r\n        \"access\": true,\r\n        \"accessType\": \"RW\",\r\n        \"showView\": null\r\n    },\r\n    {\r\n        \"id\": 1013,\r\n        \"createDate\": \"2024-02-21 15:53:10\",\r\n        \"errorCode\": 0,\r\n        \"errorMessage\": null,\r\n        \"tabName\": \"Service Plan Change\",\r\n        \"tabOrder\": 28,\r\n        \"parentScreenId\": 39,\r\n        \"tabType\": \"Action\",\r\n        \"access\": true,\r\n        \"accessType\": \"RW\",\r\n        \"showView\": null\r\n    },\r\n    {\r\n        \"id\": 1014,\r\n        \"createDate\": \"2024-02-21 15:53:10\",\r\n        \"errorCode\": 0,\r\n        \"errorMessage\": null,\r\n        \"tabName\": \"SIM State Change\",\r\n        \"tabOrder\": 29,\r\n        \"parentScreenId\": 39,\r\n        \"tabType\": \"Action\",\r\n        \"access\": true,\r\n        \"accessType\": \"RW\",\r\n        \"showView\": null\r\n    },\r\n    {\r\n        \"id\": 1015,\r\n        \"createDate\": \"2024-02-21 15:53:10\",\r\n        \"errorCode\": 0,\r\n        \"errorMessage\": null,\r\n        \"tabName\": \"Add Webhook\",\r\n        \"tabOrder\": 30,\r\n        \"parentScreenId\": 39,\r\n        \"tabType\": \"Action\",\r\n        \"access\": true,\r\n        \"accessType\": \"RW\",\r\n        \"showView\": null\r\n    },\r\n    {\r\n        \"id\": 1016,\r\n        \"createDate\": \"2024-02-21 15:53:10\",\r\n        \"errorCode\": 0,\r\n        \"errorMessage\": null,\r\n        \"tabName\": \"Device Plan Change\",\r\n        \"tabOrder\": 31,\r\n        \"parentScreenId\": 39,\r\n        \"tabType\": \"Action\",\r\n        \"access\": true,\r\n        \"accessType\": \"RW\",\r\n        \"showView\": null\r\n    },\r\n    {\r\n        \"id\": 1017,\r\n        \"createDate\": \"2024-02-21 15:53:10\",\r\n        \"errorCode\": 0,\r\n        \"errorMessage\": null,\r\n        \"tabName\": \"SMS MO AT\",\r\n        \"tabOrder\": 31,\r\n        \"parentScreenId\": 39,\r\n        \"tabType\": \"Trigger\",\r\n        \"access\": true,\r\n        \"accessType\": \"RW\",\r\n        \"showView\": null\r\n    }\r\n]',1);
/*!40000 ALTER TABLE `tab_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `template_id_mapping`
--

DROP TABLE IF EXISTS `template_id_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `template_id_mapping` (
  `id` varchar(100) DEFAULT NULL,
  `template_id` varchar(100) DEFAULT NULL,
  `notificationType` varchar(100) DEFAULT NULL,
  `templateName` varchar(100) DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `template_id_mapping`
--

LOCK TABLES `template_id_mapping` WRITE;
/*!40000 ALTER TABLE `template_id_mapping` DISABLE KEYS */;
INSERT INTO `template_id_mapping` VALUES ('583','40909','SMS','Welcome Message',1),('584','40908','EMAIL','Password Reset',2),('585','40970','SMS','Welcome Message',3),('586','40969','EMAIL','Password Reset',4),('587','40975','SMS','Welcome Message',5),('588','40974','EMAIL','Password Reset',6),('593','41013','SMS','Welcome Message',7),('594','41012','EMAIL','Password Reset',8);
/*!40000 ALTER TABLE `template_id_mapping` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transformation_summary`
--

DROP TABLE IF EXISTS `transformation_summary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transformation_summary` (
  `entity_type` varchar(255) DEFAULT NULL,
  `total_count` int DEFAULT NULL,
  `success_count` int DEFAULT NULL,
  `failure_count` int DEFAULT NULL,
  `execution_time` int DEFAULT NULL,
  `create_date` date DEFAULT NULL,
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transformation_summary`
--

LOCK TABLES `transformation_summary` WRITE;
/*!40000 ALTER TABLE `transformation_summary` DISABLE KEYS */;
INSERT INTO `transformation_summary` VALUES ('ec_success',1,1,0,1,'2025-05-07',1),('bu_success',2,2,0,1,'2025-05-07',2),('user_success',3,3,0,0,'2025-05-07',3),('role_success',3,3,0,0,'2025-05-07',4),('apn_success',353,353,0,1,'2025-05-07',5),('ip_pool_success',2,2,0,0,'2025-05-07',6),('csr_mapping_master',2,2,0,0,'2025-05-07',7),('csr_mapping_details',5,5,0,0,'2025-05-07',8);
/*!40000 ALTER TABLE `transformation_summary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `validation_summary`
--

DROP TABLE IF EXISTS `validation_summary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `validation_summary` (
  `sequence_id` bigint NOT NULL AUTO_INCREMENT,
  `entity_type` varchar(255) DEFAULT NULL,
  `total_count` int DEFAULT NULL,
  `success_count` int DEFAULT NULL,
  `failure_count` int DEFAULT NULL,
  `execution_time` int DEFAULT NULL,
  `create_date` date DEFAULT NULL,
  PRIMARY KEY (`sequence_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `validation_summary`
--

LOCK TABLES `validation_summary` WRITE;
/*!40000 ALTER TABLE `validation_summary` DISABLE KEYS */;
INSERT INTO `validation_summary` VALUES (1,'Enterprise Customer',1,1,0,0,'2025-05-07'),(2,'Business Unit',2,2,0,1,'2025-05-07'),(3,'User',3,3,0,0,'2025-05-07'),(4,'Cost_Center',0,0,0,0,'2025-05-07'),(5,'apn creation',373,353,20,7,'2025-05-07'),(6,'notification_template',2,2,0,0,'2025-05-07'),(7,'rule_trigger',3,3,0,1,'2025-05-07'),(8,'life_cycles',2,2,0,0,'2025-05-07'),(9,'service_profiles',5,5,0,1,'2025-05-07'),(10,'asset',9,3,6,1,'2025-05-07'),(11,'Report Subscriptions',0,0,0,0,'2025-05-07'),(12,'IP Pool',2,2,0,0,'2025-05-07');
/*!40000 ALTER TABLE `validation_summary` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-07 18:10:33
