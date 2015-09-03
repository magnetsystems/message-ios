-- MySQL dump 10.13  Distrib 5.6.17, for osx10.9 (x86_64)
--
-- Host: localhost    Database: magnetmessagedb
-- ------------------------------------------------------
-- Server version	5.5.37

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `magnetmessagedb`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `magnetmessagedb` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `magnetmessagedb`;

--
-- Table structure for table `Events`
--

DROP TABLE IF EXISTS `Events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `magnetId` char(36) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `level` varchar(255) DEFAULT NULL,
  `UserId` varchar(255) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `targetModel` varchar(255) DEFAULT NULL,
  `targetId` varchar(255) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `magnetId` (`magnetId`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Events`
--

LOCK TABLES `Events` WRITE;
/*!40000 ALTER TABLE `Events` DISABLE KEYS */;
INSERT INTO `Events` VALUES (1,'43c83680-51a0-11e5-b91b-1d13767cd3df','info',NULL,'ORM: Sequelize schemas initialized successfully',NULL,NULL,'2015-09-02 18:27:27','2015-09-02 18:27:27'),(2,'43c8abb0-51a0-11e5-b91b-1d13767cd3df','info',NULL,'Open web browser and navigate to http://localhost:3000/wizard to perform initial setup.',NULL,NULL,'2015-09-02 18:27:27','2015-09-02 18:27:27'),(3,'43c8abb1-51a0-11e5-b91b-1d13767cd3df','info',NULL,'Config: successfully configured database.',NULL,NULL,'2015-09-02 18:27:27','2015-09-02 18:27:27'),(4,'43f476a0-51a0-11e5-b91b-1d13767cd3df','info',NULL,'Config: successfully created an admin user.',NULL,NULL,'2015-09-02 18:27:28','2015-09-02 18:27:28'),(5,'44c02b10-51a0-11e5-b91b-1d13767cd3df','info',NULL,'Config: bootstrapped messaging server at \"localhost\".',NULL,NULL,'2015-09-02 18:27:29','2015-09-02 18:27:29'),(6,'44c13c80-51a0-11e5-b91b-1d13767cd3df','info',NULL,'Config: set up connectivity configuration for messaging server at \"localhost\".',NULL,NULL,'2015-09-02 18:27:29','2015-09-02 18:27:29'),(7,'50576470-51a0-11e5-b91b-1d13767cd3df','info',NULL,'Config: successfully completed the installation.',NULL,NULL,'2015-09-02 18:27:48','2015-09-02 18:27:48'),(8,'50685460-51a0-11e5-b91b-1d13767cd3df','info',NULL,'System: restarting server.',NULL,NULL,'2015-09-02 18:27:49','2015-09-02 18:27:49'),(9,'52310670-51a0-11e5-bcc0-13a0a9dc359b','info',NULL,'ORM: Sequelize schemas initialized successfully',NULL,NULL,'2015-09-02 18:27:52','2015-09-02 18:27:52'),(10,'52315490-51a0-11e5-bcc0-13a0a9dc359b','info',NULL,'ORM: successfully completed initialization for database: magnetmessagedb',NULL,NULL,'2015-09-02 18:27:52','2015-09-02 18:27:52');
/*!40000 ALTER TABLE `Events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Geos`
--

DROP TABLE IF EXISTS `Geos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Geos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `long` float(10,6) DEFAULT NULL,
  `lat` float(10,6) DEFAULT NULL,
  `geohash` varchar(255) DEFAULT NULL,
  `deviceId` varchar(255) DEFAULT NULL,
  `userId` varchar(255) DEFAULT NULL,
  `accuracy` int(11) DEFAULT NULL,
  `altitude` int(11) DEFAULT NULL,
  `appId` varchar(255) DEFAULT NULL,
  `stamp` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Geos`
--

LOCK TABLES `Geos` WRITE;
/*!40000 ALTER TABLE `Geos` DISABLE KEYS */;
/*!40000 ALTER TABLE `Geos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `magnetId` char(36) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `firstName` varchar(255) DEFAULT NULL,
  `lastName` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `dateAcceptedEULA` datetime DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `userType` varchar(255) DEFAULT NULL,
  `roleWithinCompany` varchar(255) DEFAULT NULL,
  `companyName` varchar(255) DEFAULT NULL,
  `inviterId` int(11) DEFAULT NULL,
  `invitedEmail` varchar(255) DEFAULT NULL,
  `passwordResetToken` varchar(255) DEFAULT NULL,
  `activated` tinyint(1) DEFAULT '1',
  `hasMMXApp` tinyint(1) DEFAULT '0',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `magnetId` (`magnetId`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `passwordResetToken` (`passwordResetToken`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Users`
--

LOCK TABLES `Users` WRITE;
/*!40000 ALTER TABLE `Users` DISABLE KEYS */;
INSERT INTO `Users` VALUES (1,'43f38c40-51a0-11e5-b91b-1d13767cd3df',NULL,NULL,'sysadmin@company.com',NULL,'$2a$10$r0ROjrt48YXd7uraO1df0uFhp8FgpYUjVJQalCgHHkfY159JPacHy',NULL,'admin',NULL,NULL,NULL,NULL,NULL,1,1,'2015-09-02 18:27:28','2015-09-02 18:27:52');
/*!40000 ALTER TABLE `Users` ENABLE KEYS */;
UNLOCK TABLES;


--
-- Table structure for table `mmxapp`
--

DROP TABLE IF EXISTS `mmxapp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mmxapp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `serverUserId` varchar(200) DEFAULT NULL,
  `appName` varchar(100) NOT NULL,
  `appId` varchar(16) NOT NULL,
  `apiKey` varchar(100) DEFAULT NULL,
  `encryptedApiKey` varchar(255) DEFAULT NULL,
  `googleApiKey` varchar(100) DEFAULT NULL,
  `googleProjectId` varchar(100) DEFAULT NULL,
  `apnsCert` varbinary(5000) DEFAULT NULL,
  `apnsCertPlainPassword` varchar(100) DEFAULT NULL,
  `apnsCertEncryptedPassword` varchar(255) DEFAULT NULL,
  `apnsCertProduction` tinyint(4) DEFAULT NULL,
  `creationDate` datetime NOT NULL,
  `modificationDate` datetime DEFAULT NULL,
  `ownerId` varchar(200) DEFAULT NULL,
  `ownerEmail` varchar(255) DEFAULT NULL,
  `guestUserId` varchar(200) DEFAULT NULL,
  `guestSecret` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `mmxApp_appId` (`appId`),
  KEY `mmxApp_serverUserJJID` (`serverUserId`),
  KEY `mmxApp_apiKey` (`apiKey`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mmxapp`
--

LOCK TABLES `mmxapp` WRITE;
/*!40000 ALTER TABLE `mmxapp` DISABLE KEYS */;
INSERT INTO `mmxapp` VALUES (1,'serveruser%j6eie349mf7','Quickstart','j6eie349mf7','54b2c818-21b0-4c46-af54-b62d6acd643e','2108f47707a076c0081e8a595292cce4493a7dc8338f2bf9ed7901815dc4874dd6cc744fafecb7f3f5e3f7f2cb3cc7ebb8a791f99af453e82d387d5466f43f4a7d3987a25882568f715b2d29be75cc19ee4ac577b9c227f1',NULL,NULL,NULL,NULL,NULL,0,'2015-09-02 11:27:52','2015-09-02 11:27:52','43f38c40-51a0-11e5-b91b-1d13767cd3df','sysadmin@company.com',NULL,'d79db6bb-8dc5-4ed1-8da8-81d09ecd37b2'),(2,'serveruser%d93ie349mi6','RPSLS','d93ie349mi6','d417b9ea-d4b3-45ac-802c-9c708b26180a','1e04e9b32b852bad50b49e7df31c60988851ab04aca8fc7ee7ac6e5923743626ed07870440c22dd44018d0f4bf7eb3462ccd0b5f129cdea0a77ebcd1c80740f14e5b0346f556d63aa87ef9a6af297396e5418f3c360fb348',NULL,NULL,NULL,NULL,NULL,0,'2015-09-02 11:27:52','2015-09-02 11:27:52','43f38c40-51a0-11e5-b91b-1d13767cd3df','sysadmin@company.com',NULL,'5ffe4210-7e04-41fd-8065-c8f9c80e8c8a'),(3,'serveruser%hgtie349miz','Soapbox','hgtie349miz','92027299-e2ad-447f-adc2-83d5465c593e','129c94da7a7ce071f11ffbf402685d82db18e371df19360b5236a5a5cc9c82d80976baa08628dd9cc2eb43cdecc1c8f06604ef13e5a84002af45c0f8c5efab7285d2db9c5e26c80df7eb9e3a1a1a6fc00ef47d14ce3d56b5',NULL,NULL,NULL,NULL,NULL,0,'2015-09-02 11:27:52','2015-09-02 11:27:52','43f38c40-51a0-11e5-b91b-1d13767cd3df','sysadmin@company.com',NULL,'b57c1f8f-431f-4472-96ef-81cc001dc49a'),(4,'serveruser%c3die34g1fx','iosTestApp','c3die34g1fx','4e610f6e-d1e7-469d-81b9-1572c69d182a','98ef3c48a89dde85afd9aa44a58a1adf3c7820f87b4f84b7f8ea745cacd8fbb1d55d8c792e8b75ec90705602215ca9366124dd399038fb8dd775b26b8aff1270fafb86da40374975333763170057b02fda40fa1ebb3d7c88',NULL,NULL,NULL,NULL,NULL,0,'2015-09-02 11:32:51','2015-09-02 11:32:51','43f38c40-51a0-11e5-b91b-1d13767cd3df','sysadmin@company.com',NULL,'1b6d4f81-6596-4ae7-af0f-f26c41769cba'),(5,'serveruser%2sqie34g80t','androidTestApp','2sqie34g80t','841ad125-f57a-4e40-a2f4-6d253b3bd8ed','53132bc143ee77d8497aab0d2760d38a65f355252b6307b3bfcf0b37e09024d52bd62884ecb8afb333aa8700bd2c9a4bf87af24d714bc0cb4b1f1aab6f90dba593d1d1ab20fe89b8db2b36a321e7e75495b18ba85e28ac47',NULL,NULL,NULL,NULL,NULL,0,'2015-09-02 11:33:00','2015-09-02 11:33:00','43f38c40-51a0-11e5-b91b-1d13767cd3df','sysadmin@company.com',NULL,'823175b7-fa00-422b-ae7f-3ec559d161ea');
/*!40000 ALTER TABLE `mmxapp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mmxAppConfiguration`
--

DROP TABLE IF EXISTS `mmxAppConfiguration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mmxAppConfiguration` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `appId` varchar(16) NOT NULL,
  `configKey` varchar(100) NOT NULL,
  `configValue` varchar(300) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `mmxAppConfiguration_uk` (`appId`,`configKey`),
  CONSTRAINT `mmxappconfiguration_ibfk_1` FOREIGN KEY (`appId`) REFERENCES `mmxApp` (`appId`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mmxAppConfiguration`
--

LOCK TABLES `mmxAppConfiguration` WRITE;
/*!40000 ALTER TABLE `mmxAppConfiguration` DISABLE KEYS */;
INSERT INTO `mmxAppConfiguration` VALUES (1,'j6eie349mf7','mmx.wakeup.mute.minutes','30'),(2,'d93ie349mi6','mmx.wakeup.mute.minutes','30'),(3,'hgtie349miz','mmx.wakeup.mute.minutes','30'),(4,'c3die34g1fx','mmx.wakeup.mute.minutes','30'),(5,'2sqie34g80t','mmx.wakeup.mute.minutes','30');
/*!40000 ALTER TABLE `mmxAppConfiguration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mmxDevice`
--

DROP TABLE IF EXISTS `mmxDevice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mmxDevice` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `ownerJid` varchar(200) NOT NULL,
  `appId` varchar(16) NOT NULL,
  `osType` varchar(20) NOT NULL,
  `deviceId` varchar(50) NOT NULL,
  `tokenType` varchar(10) DEFAULT NULL,
  `clientToken` varchar(500) DEFAULT NULL,
  `versionInfo` varchar(20) DEFAULT NULL,
  `modelInfo` varchar(200) DEFAULT NULL,
  `phoneNumber` varchar(20) DEFAULT NULL,
  `phoneNumberRev` varchar(20) DEFAULT NULL,
  `carrierInfo` varchar(20) DEFAULT NULL,
  `dateCreated` datetime NOT NULL,
  `dateUpdated` datetime DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'ACTIVE',
  `protocolVersionMajor` int(11) DEFAULT NULL,
  `protocolVersionMinor` int(11) DEFAULT NULL,
  `pushStatus` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `devicid_type_osType_appid` (`deviceId`,`osType`,`appId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mmxDevice`
--

LOCK TABLES `mmxDevice` WRITE;
/*!40000 ALTER TABLE `mmxDevice` DISABLE KEYS */;
INSERT INTO `mmxDevice` VALUES (1,'amazing_bot Device','amazing_bot','j6eie349mf7','OTHER','j6eie349mf7-amazing_bot-bot-device',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2015-09-02 11:27:52',NULL,'ACTIVE',0,0,NULL),(2,'echo_bot Device','echo_bot','j6eie349mf7','OTHER','j6eie349mf7-echo_bot-bot-device',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2015-09-02 11:27:52',NULL,'ACTIVE',0,0,NULL),(3,'player_bot Device','player_bot','d93ie349mi6','OTHER','d93ie349mi6-player_bot-bot-device',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2015-09-02 11:27:52',NULL,'ACTIVE',0,0,NULL);
/*!40000 ALTER TABLE `mmxDevice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mmxPushMessage`
--

DROP TABLE IF EXISTS `mmxPushMessage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mmxPushMessage` (
  `messageId` varchar(50) NOT NULL,
  `deviceId` varchar(50) NOT NULL,
  `appId` varchar(16) NOT NULL,
  `dateSentUTC` int(11) NOT NULL,
  `dateAcknowledgedUTC` int(11) DEFAULT NULL,
  `type` varchar(16) NOT NULL,
  `state` varchar(50) NOT NULL,
  PRIMARY KEY (`messageId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mmxPushMessage`
--

LOCK TABLES `mmxPushMessage` WRITE;
/*!40000 ALTER TABLE `mmxPushMessage` DISABLE KEYS */;
/*!40000 ALTER TABLE `mmxPushMessage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mmxmessage`
--

DROP TABLE IF EXISTS `mmxmessage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mmxmessage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `messageId` varchar(100) NOT NULL,
  `deviceId` varchar(50) NOT NULL,
  `fromJID` varchar(200) NOT NULL,
  `toJID` varchar(200) NOT NULL,
  `dateQueuedUTC` int(11) NOT NULL,
  `state` varchar(50) NOT NULL,
  `appId` varchar(16) NOT NULL,
  `dateAcknowledgedUTC` int(11) DEFAULT NULL,
  `sourceMessageId` varchar(100) DEFAULT NULL,
  `messageType` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mmxMessage_messageId` (`messageId`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mmxmessage`
--

LOCK TABLES `mmxmessage` WRITE;
/*!40000 ALTER TABLE `mmxmessage` DISABLE KEYS */;
INSERT INTO `mmxmessage` VALUES (1,'0693d6f333d39a11a96722098a3ab91b','j6eie349mf7-amazing_bot-bot-device','serveruser%j6eie349mf7@mmx','amazing_bot%j6eie349mf7@mmx/j6eie349mf7-amazing_bot-bot-device',1441218472,'RECEIVED','j6eie349mf7',1441218474,NULL,'REGULAR'),(2,'ca370efed50f81ac19e05921882b3dc1','j6eie349mf7-echo_bot-bot-device','serveruser%j6eie349mf7@mmx','echo_bot%j6eie349mf7@mmx/j6eie349mf7-echo_bot-bot-device',1441218472,'RECEIVED','j6eie349mf7',1441218474,NULL,'REGULAR');
/*!40000 ALTER TABLE `mmxmessage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mmxwakeupqueue`
--

DROP TABLE IF EXISTS `mmxwakeupqueue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mmxwakeupqueue` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `deviceId` varchar(50) NOT NULL,
  `clientToken` varchar(500) DEFAULT NULL,
  `tokenType` varchar(10) DEFAULT NULL,
  `appId` varchar(16) DEFAULT NULL,
  `googleApiKey` varchar(100) DEFAULT NULL,
  `payload` varchar(400) NOT NULL,
  `messageId` varchar(100) NOT NULL,
  `dateCreatedUTC` int(11) DEFAULT NULL,
  `dateSentUTC` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mmxWakeupQueue_dateCreated` (`dateCreatedUTC`),
  KEY `mmxWakeupQueue_dateSent` (`dateSentUTC`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mmxwakeupqueue`
--

LOCK TABLES `mmxwakeupqueue` WRITE;
/*!40000 ALTER TABLE `mmxwakeupqueue` DISABLE KEYS */;
/*!40000 ALTER TABLE `mmxwakeupqueue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofExtComponentConf`
--

DROP TABLE IF EXISTS `ofExtComponentConf`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ofExtComponentConf` (
  `subdomain` varchar(255) NOT NULL,
  `wildcard` tinyint(4) NOT NULL,
  `secret` varchar(255) DEFAULT NULL,
  `permission` varchar(10) NOT NULL,
  PRIMARY KEY (`subdomain`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofExtComponentConf`
--

LOCK TABLES `ofExtComponentConf` WRITE;
/*!40000 ALTER TABLE `ofExtComponentConf` DISABLE KEYS */;
/*!40000 ALTER TABLE `ofExtComponentConf` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofGroup`
--

DROP TABLE IF EXISTS `ofGroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ofGroup` (
  `groupName` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`groupName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofGroup`
--

LOCK TABLES `ofGroup` WRITE;
/*!40000 ALTER TABLE `ofGroup` DISABLE KEYS */;
/*!40000 ALTER TABLE `ofGroup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofGroupProp`
--

DROP TABLE IF EXISTS `ofGroupProp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ofGroupProp` (
  `groupName` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `propValue` text NOT NULL,
  PRIMARY KEY (`groupName`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofGroupProp`
--

LOCK TABLES `ofGroupProp` WRITE;
/*!40000 ALTER TABLE `ofGroupProp` DISABLE KEYS */;
/*!40000 ALTER TABLE `ofGroupProp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofGroupUser`
--

DROP TABLE IF EXISTS `ofGroupUser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ofGroupUser` (
  `groupName` varchar(50) NOT NULL,
  `username` varchar(100) NOT NULL,
  `administrator` tinyint(4) NOT NULL,
  PRIMARY KEY (`groupName`,`username`,`administrator`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofGroupUser`
--

LOCK TABLES `ofGroupUser` WRITE;
/*!40000 ALTER TABLE `ofGroupUser` DISABLE KEYS */;
/*!40000 ALTER TABLE `ofGroupUser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofID`
--

DROP TABLE IF EXISTS `ofID`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ofID` (
  `idType` int(11) NOT NULL,
  `id` bigint(20) NOT NULL,
  PRIMARY KEY (`idType`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofID`
--

LOCK TABLES `ofID` WRITE;
/*!40000 ALTER TABLE `ofID` DISABLE KEYS */;
INSERT INTO `ofID` VALUES (18,1),(19,6),(23,1),(26,2);
/*!40000 ALTER TABLE `ofID` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofMucAffiliation`
--

DROP TABLE IF EXISTS `ofMucAffiliation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ofMucAffiliation` (
  `roomID` bigint(20) NOT NULL,
  `jid` text NOT NULL,
  `affiliation` tinyint(4) NOT NULL,
  PRIMARY KEY (`roomID`,`jid`(70))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofMucAffiliation`
--

LOCK TABLES `ofMucAffiliation` WRITE;
/*!40000 ALTER TABLE `ofMucAffiliation` DISABLE KEYS */;
/*!40000 ALTER TABLE `ofMucAffiliation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofMucConversationLog`
--

DROP TABLE IF EXISTS `ofMucConversationLog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ofMucConversationLog` (
  `roomID` bigint(20) NOT NULL,
  `sender` text NOT NULL,
  `nickname` varchar(255) DEFAULT NULL,
  `logTime` char(15) NOT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `body` text,
  KEY `ofMucConversationLog_time_idx` (`logTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofMucConversationLog`
--

LOCK TABLES `ofMucConversationLog` WRITE;
/*!40000 ALTER TABLE `ofMucConversationLog` DISABLE KEYS */;
/*!40000 ALTER TABLE `ofMucConversationLog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofMucMember`
--

DROP TABLE IF EXISTS `ofMucMember`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ofMucMember` (
  `roomID` bigint(20) NOT NULL,
  `jid` text NOT NULL,
  `nickname` varchar(255) DEFAULT NULL,
  `firstName` varchar(100) DEFAULT NULL,
  `lastName` varchar(100) DEFAULT NULL,
  `url` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `faqentry` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`roomID`,`jid`(70))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofMucMember`
--

LOCK TABLES `ofMucMember` WRITE;
/*!40000 ALTER TABLE `ofMucMember` DISABLE KEYS */;
/*!40000 ALTER TABLE `ofMucMember` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofMucRoom`
--

DROP TABLE IF EXISTS `ofMucRoom`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ofMucRoom` (
  `serviceID` bigint(20) NOT NULL,
  `roomID` bigint(20) NOT NULL,
  `creationDate` char(15) NOT NULL,
  `modificationDate` char(15) NOT NULL,
  `name` varchar(50) NOT NULL,
  `naturalName` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `lockedDate` char(15) NOT NULL,
  `emptyDate` char(15) DEFAULT NULL,
  `canChangeSubject` tinyint(4) NOT NULL,
  `maxUsers` int(11) NOT NULL,
  `publicRoom` tinyint(4) NOT NULL,
  `moderated` tinyint(4) NOT NULL,
  `membersOnly` tinyint(4) NOT NULL,
  `canInvite` tinyint(4) NOT NULL,
  `roomPassword` varchar(50) DEFAULT NULL,
  `canDiscoverJID` tinyint(4) NOT NULL,
  `logEnabled` tinyint(4) NOT NULL,
  `subject` varchar(100) DEFAULT NULL,
  `rolesToBroadcast` tinyint(4) NOT NULL,
  `useReservedNick` tinyint(4) NOT NULL,
  `canChangeNick` tinyint(4) NOT NULL,
  `canRegister` tinyint(4) NOT NULL,
  PRIMARY KEY (`serviceID`,`name`),
  KEY `ofMucRoom_roomid_idx` (`roomID`),
  KEY `ofMucRoom_serviceid_idx` (`serviceID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofMucRoom`
--

LOCK TABLES `ofMucRoom` WRITE;
/*!40000 ALTER TABLE `ofMucRoom` DISABLE KEYS */;
/*!40000 ALTER TABLE `ofMucRoom` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofMucRoomProp`
--

DROP TABLE IF EXISTS `ofMucRoomProp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ofMucRoomProp` (
  `roomID` bigint(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `propValue` text NOT NULL,
  PRIMARY KEY (`roomID`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofMucRoomProp`
--

LOCK TABLES `ofMucRoomProp` WRITE;
/*!40000 ALTER TABLE `ofMucRoomProp` DISABLE KEYS */;
/*!40000 ALTER TABLE `ofMucRoomProp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofMucService`
--

DROP TABLE IF EXISTS `ofMucService`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ofMucService` (
  `serviceID` bigint(20) NOT NULL,
  `subdomain` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `isHidden` tinyint(4) NOT NULL,
  PRIMARY KEY (`subdomain`),
  KEY `ofMucService_serviceid_idx` (`serviceID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofMucService`
--

LOCK TABLES `ofMucService` WRITE;
/*!40000 ALTER TABLE `ofMucService` DISABLE KEYS */;
INSERT INTO `ofMucService` VALUES (1,'conference',NULL,0);
/*!40000 ALTER TABLE `ofMucService` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofMucServiceProp`
--

DROP TABLE IF EXISTS `ofMucServiceProp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ofMucServiceProp` (
  `serviceID` bigint(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `propValue` text NOT NULL,
  PRIMARY KEY (`serviceID`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofMucServiceProp`
--

LOCK TABLES `ofMucServiceProp` WRITE;
/*!40000 ALTER TABLE `ofMucServiceProp` DISABLE KEYS */;
/*!40000 ALTER TABLE `ofMucServiceProp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofOffline`
--

DROP TABLE IF EXISTS `ofOffline`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ofOffline` (
  `username` varchar(200) NOT NULL,
  `messageID` bigint(20) NOT NULL,
  `creationDate` char(15) NOT NULL,
  `messageSize` int(11) NOT NULL,
  `packetId` varchar(100) DEFAULT NULL,
  `stanza` mediumtext NOT NULL,
  PRIMARY KEY (`username`,`messageID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofOffline`
--

LOCK TABLES `ofOffline` WRITE;
/*!40000 ALTER TABLE `ofOffline` DISABLE KEYS */;
INSERT INTO `ofOffline` VALUES ('admin@mmx',5,'001441218486669',110,NULL,'<message from=\"mmx\" to=\"admin@mmx\"><body>A server or plugin update was found: Openfire 3.10.2</body></message>'),('serveruser%j6eie349mf7@mmx',1,'001441218472582',416,'0693d6f333d39a11a96722098a3ab91b','<message id=\"0693d6f333d39a11a96722098a3ab91b\" type=\"chat\" from=\"serveruser%j6eie349mf7@mmx\" to=\"serveruser%j6eie349mf7@mmx\"><mmx xmlns=\"com.magnet:msg:payload\"><meta>{\"content-type\":\"text\",\"content-encoding\":\"simple\",\"textContent\":\"Hello Amazing Bot!\"}</meta><payload stamp=\"2015-09-02T18:27:52.537Z\" chunk=\"0/18/18\">This is simply amazing</payload></mmx><request xmlns=\"urn:xmpp:receipts\"/><body>.</body></message>'),('serveruser%j6eie349mf7@mmx',2,'001441218472583',455,'10f62fd655df0fb9f975fc4f6d1414ba','<message type=\"chat\" from=\"j6eie349mf7%j6eie349mf7@mmx\" to=\"serveruser%j6eie349mf7@mmx\" id=\"10f62fd655df0fb9f975fc4f6d1414ba\"><mmx xmlns=\"com.magnet:msg:signal\"><mmxmeta>{\"serverack\":{\"ackForMsgId\":\"0693d6f333d39a11a96722098a3ab91b\",\"sender\":{\"userId\":\"serveruser\"},\"receiver\":{\"devId\":\"j6eie349mf7-amazing_bot-bot-device\",\"userId\":\"amazing_bot\"}}}</mmxmeta><payload stamp=\"2015-09-02T18:27:52.569Z\" chunk=\"0/1/1\">.</payload></mmx><body>.</body></message>'),('serveruser%j6eie349mf7@mmx',3,'001441218472584',449,'04e84e0a325bd6cf648524bb19e67a59','<message type=\"chat\" from=\"j6eie349mf7%j6eie349mf7@mmx\" to=\"serveruser%j6eie349mf7@mmx\" id=\"04e84e0a325bd6cf648524bb19e67a59\"><mmx xmlns=\"com.magnet:msg:signal\"><mmxmeta>{\"serverack\":{\"ackForMsgId\":\"ca370efed50f81ac19e05921882b3dc1\",\"sender\":{\"userId\":\"serveruser\"},\"receiver\":{\"devId\":\"j6eie349mf7-echo_bot-bot-device\",\"userId\":\"echo_bot\"}}}</mmxmeta><payload stamp=\"2015-09-02T18:27:52.569Z\" chunk=\"0/1/1\">.</payload></mmx><body>.</body></message>'),('serveruser%j6eie349mf7@mmx',4,'001441218472585',421,'ca370efed50f81ac19e05921882b3dc1','<message id=\"ca370efed50f81ac19e05921882b3dc1\" type=\"chat\" from=\"serveruser%j6eie349mf7@mmx\" to=\"serveruser%j6eie349mf7@mmx\"><mmx xmlns=\"com.magnet:msg:payload\"><meta>{\"content-type\":\"text\",\"content-encoding\":\"simple\",\"textContent\":\"Hello Echo Bot!\"}</meta><payload stamp=\"2015-09-02T18:27:52.537Z\" chunk=\"0/15/15\">Hello Echo Bot!</payload><mmxmeta>{\"To\":[{\"userId\":\"serveruser\"}]}</mmxmeta></mmx><body>.</body></message>');
/*!40000 ALTER TABLE `ofOffline` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofPresence`
--

DROP TABLE IF EXISTS `ofPresence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ofPresence` (
  `username` varchar(64) NOT NULL,
  `offlinePresence` text,
  `offlineDate` char(15) NOT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofPresence`
--

LOCK TABLES `ofPresence` WRITE;
/*!40000 ALTER TABLE `ofPresence` DISABLE KEYS */;
/*!40000 ALTER TABLE `ofPresence` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofPrivacyList`
--

DROP TABLE IF EXISTS `ofPrivacyList`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ofPrivacyList` (
  `username` varchar(64) NOT NULL,
  `name` varchar(100) NOT NULL,
  `isDefault` tinyint(4) NOT NULL,
  `list` text NOT NULL,
  PRIMARY KEY (`username`,`name`),
  KEY `ofPrivacyList_default_idx` (`username`,`isDefault`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofPrivacyList`
--

LOCK TABLES `ofPrivacyList` WRITE;
/*!40000 ALTER TABLE `ofPrivacyList` DISABLE KEYS */;
/*!40000 ALTER TABLE `ofPrivacyList` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofPrivate`
--

DROP TABLE IF EXISTS `ofPrivate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ofPrivate` (
  `username` varchar(64) NOT NULL,
  `name` varchar(100) NOT NULL,
  `namespace` varchar(200) NOT NULL,
  `privateData` text NOT NULL,
  PRIMARY KEY (`username`,`name`,`namespace`(100))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofPrivate`
--

LOCK TABLES `ofPrivate` WRITE;
/*!40000 ALTER TABLE `ofPrivate` DISABLE KEYS */;
/*!40000 ALTER TABLE `ofPrivate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofProperty`
--

DROP TABLE IF EXISTS `ofProperty`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ofProperty` (
  `name` varchar(100) NOT NULL,
  `propValue` text NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofProperty`
--

LOCK TABLES `ofProperty` WRITE;
/*!40000 ALTER TABLE `ofProperty` DISABLE KEYS */;
INSERT INTO `ofProperty` VALUES ('flash.crossdomain.enabled','false'),('http.socket.linger','0'),('mmx.admin.api.enable.https','true'),('mmx.admin.api.https.port','6061'),('mmx.admin.api.port','6060'),('mmx.alert.email.bcc.list',''),('mmx.alert.email.enabled','false'),('mmx.alert.email.host',''),('mmx.alert.email.password',''),('mmx.alert.email.port',''),('mmx.alert.email.subject','Usage limit exceeded'),('mmx.alert.email.user',''),('mmx.alert.inter.email.time.minutes','15'),('mmx.apns.feedback.frequency.min','360'),('mmx.apns.feedback.initialwait.min','10'),('mmx.cluster.max.apps','-1'),('mmx.cluster.max.devices.per.app','-1'),('mmx.domain.name',''),('mmx.instance.max.http.rate.per.sec','-1'),('mmx.instance.max.xmpp.rate.per.sec','-1'),('mmx.push.callback.host','192.168.101.124'),('mmx.push.callback.port','5220'),('mmx.push.callback.protocol','http'),('mmx.rest.enable.https','true'),('mmx.rest.http.port','5220'),('mmx.rest.https.port','5221'),('mmx.retry.count','0'),('mmx.retry.interval.minutes','15'),('mmx.retry.mechanism','Standard'),('mmx.timeout.period.minutes','180'),('mmx.version','1.6.0-SNAPSHOT'),('mmx.wakeup.frequency','30'),('mmx.wakeup.initialwait','10'),('passwordKey','ydNHrJOI74z1x00'),('provider.admin.className','org.jivesoftware.openfire.admin.DefaultAdminProvider'),('provider.auth.className','org.jivesoftware.openfire.auth.DefaultAuthProvider'),('provider.group.className','org.jivesoftware.openfire.group.DefaultGroupProvider'),('provider.lockout.className','org.jivesoftware.openfire.lockout.DefaultLockOutProvider'),('provider.securityAudit.className','org.jivesoftware.openfire.security.DefaultSecurityAuditProvider'),('provider.user.className','org.jivesoftware.openfire.user.DefaultUserProvider'),('provider.vcard.className','org.jivesoftware.openfire.vcard.DefaultVCardProvider'),('register.inband','false'),('update.lastCheck','1441218486917'),('xmpp.auth.anonymous','true'),('xmpp.client.idle','-1'),('xmpp.client.idle.ping','false'),('xmpp.client.tls.policy','optional'),('xmpp.domain','mmx'),('xmpp.parser.buffer.size','2097152'),('xmpp.proxy.enabled','false'),('xmpp.pubsub.flush.max','0'),('xmpp.routing.strict','true'),('xmpp.server.socket.active','false'),('xmpp.session.conflict-limit','0'),('xmpp.socket.linger','0'),('xmpp.socket.plain.port','5222'),('xmpp.socket.ssl.active','true'),('xmpp.socket.ssl.port','5223');
/*!40000 ALTER TABLE `ofProperty` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofPubsubAffiliation`
--

DROP TABLE IF EXISTS `ofPubsubAffiliation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ofPubsubAffiliation` (
  `serviceID` varchar(100) NOT NULL,
  `nodeID` varchar(100) NOT NULL,
  `jid` varchar(255) NOT NULL,
  `affiliation` varchar(10) NOT NULL,
  PRIMARY KEY (`serviceID`,`nodeID`,`jid`(70))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofPubsubAffiliation`
--

LOCK TABLES `ofPubsubAffiliation` WRITE;
/*!40000 ALTER TABLE `ofPubsubAffiliation` DISABLE KEYS */;
INSERT INTO `ofPubsubAffiliation` VALUES ('pubsub','','mmx','owner'),('pubsub','/d93ie349mi6/*/availableplayers','serveruser%d93ie349mi6@mmx','owner'),('pubsub','/hgtie349miz/*/company_announcements','serveruser%hgtie349miz@mmx','owner'),('pubsub','/hgtie349miz/*/lunch_buddies','serveruser%hgtie349miz@mmx','owner'),('pubsub','/j6eie349mf7/*/all_android','serveruser%j6eie349mf7@mmx','owner'),('pubsub','/j6eie349mf7/*/all_ios','serveruser%j6eie349mf7@mmx','owner'),('pubsub','2sqie34g80t','serveruser%2sqie34g80t@mmx','owner'),('pubsub','c3die34g1fx','serveruser%c3die34g1fx@mmx','owner'),('pubsub','d93ie349mi6','serveruser%d93ie349mi6@mmx','owner'),('pubsub','hgtie349miz','serveruser%hgtie349miz@mmx','owner'),('pubsub','j6eie349mf7','serveruser%j6eie349mf7@mmx','owner');
/*!40000 ALTER TABLE `ofPubsubAffiliation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofPubsubDefaultConf`
--

DROP TABLE IF EXISTS `ofPubsubDefaultConf`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ofPubsubDefaultConf` (
  `serviceID` varchar(100) NOT NULL,
  `leaf` tinyint(4) NOT NULL,
  `deliverPayloads` tinyint(4) NOT NULL,
  `maxPayloadSize` int(11) NOT NULL,
  `persistItems` tinyint(4) NOT NULL,
  `maxItems` int(11) NOT NULL,
  `notifyConfigChanges` tinyint(4) NOT NULL,
  `notifyDelete` tinyint(4) NOT NULL,
  `notifyRetract` tinyint(4) NOT NULL,
  `presenceBased` tinyint(4) NOT NULL,
  `sendItemSubscribe` tinyint(4) NOT NULL,
  `publisherModel` varchar(15) NOT NULL,
  `subscriptionEnabled` tinyint(4) NOT NULL,
  `accessModel` varchar(10) NOT NULL,
  `language` varchar(255) DEFAULT NULL,
  `replyPolicy` varchar(15) DEFAULT NULL,
  `associationPolicy` varchar(15) NOT NULL,
  `maxLeafNodes` int(11) NOT NULL,
  PRIMARY KEY (`serviceID`,`leaf`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofPubsubDefaultConf`
--

LOCK TABLES `ofPubsubDefaultConf` WRITE;
/*!40000 ALTER TABLE `ofPubsubDefaultConf` DISABLE KEYS */;
INSERT INTO `ofPubsubDefaultConf` VALUES ('pubsub',0,0,0,0,0,1,1,1,0,0,'publishers',1,'open','English',NULL,'all',-1),('pubsub',1,1,5120,0,-1,1,1,1,0,1,'publishers',1,'open','English',NULL,'all',-1);
/*!40000 ALTER TABLE `ofPubsubDefaultConf` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofPubsubItem`
--

DROP TABLE IF EXISTS `ofPubsubItem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ofPubsubItem` (
  `serviceID` varchar(100) NOT NULL,
  `nodeID` varchar(100) NOT NULL,
  `id` varchar(100) NOT NULL,
  `jid` varchar(255) NOT NULL,
  `creationDate` char(15) NOT NULL,
  `payload` mediumtext,
  PRIMARY KEY (`serviceID`,`nodeID`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofPubsubItem`
--

LOCK TABLES `ofPubsubItem` WRITE;
/*!40000 ALTER TABLE `ofPubsubItem` DISABLE KEYS */;
/*!40000 ALTER TABLE `ofPubsubItem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofPubsubNode`
--

DROP TABLE IF EXISTS `ofPubsubNode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ofPubsubNode` (
  `serviceID` varchar(100) NOT NULL,
  `nodeID` varchar(100) NOT NULL,
  `leaf` tinyint(4) NOT NULL,
  `creationDate` char(15) NOT NULL,
  `modificationDate` char(15) NOT NULL,
  `parent` varchar(100) DEFAULT NULL,
  `deliverPayloads` tinyint(4) NOT NULL,
  `maxPayloadSize` int(11) DEFAULT NULL,
  `persistItems` tinyint(4) DEFAULT NULL,
  `maxItems` int(11) DEFAULT NULL,
  `notifyConfigChanges` tinyint(4) NOT NULL,
  `notifyDelete` tinyint(4) NOT NULL,
  `notifyRetract` tinyint(4) NOT NULL,
  `presenceBased` tinyint(4) NOT NULL,
  `sendItemSubscribe` tinyint(4) NOT NULL,
  `publisherModel` varchar(15) NOT NULL,
  `subscriptionEnabled` tinyint(4) NOT NULL,
  `configSubscription` tinyint(4) NOT NULL,
  `accessModel` varchar(10) NOT NULL,
  `payloadType` varchar(100) DEFAULT NULL,
  `bodyXSLT` varchar(100) DEFAULT NULL,
  `dataformXSLT` varchar(100) DEFAULT NULL,
  `creator` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `language` varchar(255) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `replyPolicy` varchar(15) DEFAULT NULL,
  `associationPolicy` varchar(15) DEFAULT NULL,
  `maxLeafNodes` int(11) DEFAULT NULL,
  PRIMARY KEY (`serviceID`,`nodeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofPubsubNode`
--

LOCK TABLES `ofPubsubNode` WRITE;
/*!40000 ALTER TABLE `ofPubsubNode` DISABLE KEYS */;
INSERT INTO `ofPubsubNode` VALUES ('pubsub','',0,'001441218451462','001441218451462',NULL,0,0,0,0,1,1,1,0,0,'publishers',1,0,'open','','','','mmx','','English','',NULL,'all',-1),('pubsub','/d93ie349mi6/*/availableplayers',1,'001441218472542','001441218472542','d93ie349mi6',1,2097152,1,-1,0,0,0,0,1,'open',1,0,'open','','','','serveruser%d93ie349mi6@mmx','','English','availableplayers',NULL,NULL,0),('pubsub','/hgtie349miz/*/company_announcements',1,'001441218472551','001441218472551','hgtie349miz',1,2097152,1,-1,0,0,0,0,1,'open',1,0,'open','','','','serveruser%hgtie349miz@mmx','','English','company_announcements',NULL,NULL,0),('pubsub','/hgtie349miz/*/lunch_buddies',1,'001441218472550','001441218472551','hgtie349miz',1,2097152,1,-1,0,0,0,0,1,'open',1,0,'open','','','','serveruser%hgtie349miz@mmx','','English','lunch_buddies',NULL,NULL,0),('pubsub','/j6eie349mf7/*/all_android',1,'001441218472530','001441218472530','j6eie349mf7',1,2097152,1,-1,0,0,0,0,1,'open',1,0,'open','','','','serveruser%j6eie349mf7@mmx','','English','all_android',NULL,NULL,0),('pubsub','/j6eie349mf7/*/all_ios',1,'001441218472530','001441218472530','j6eie349mf7',1,2097152,1,-1,0,0,0,0,1,'open',1,0,'open','','','','serveruser%j6eie349mf7@mmx','','English','all_ios',NULL,NULL,0),('pubsub','2sqie34g80t',0,'001441218780324','001441218780324','',1,0,0,0,0,0,0,0,0,'open',1,0,'open','','','','serveruser%2sqie34g80t@mmx','','English','',NULL,'all',-1),('pubsub','c3die34g1fx',0,'001441218771796','001441218771796','',1,0,0,0,0,0,0,0,0,'open',1,0,'open','','','','serveruser%c3die34g1fx@mmx','','English','',NULL,'all',-1),('pubsub','d93ie349mi6',0,'001441218472500','001441218472500','',1,0,0,0,0,0,0,0,0,'open',1,0,'open','','','','serveruser%d93ie349mi6@mmx','','English','',NULL,'all',-1),('pubsub','hgtie349miz',0,'001441218472527','001441218472527','',1,0,0,0,0,0,0,0,0,'open',1,0,'open','','','','serveruser%hgtie349miz@mmx','','English','',NULL,'all',-1),('pubsub','j6eie349mf7',0,'001441218472404','001441218472404','',1,0,0,0,0,0,0,0,0,'open',1,0,'open','','','','serveruser%j6eie349mf7@mmx','','English','',NULL,'all',-1);
/*!40000 ALTER TABLE `ofPubsubNode` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofPubsubNodeGroups`
--

DROP TABLE IF EXISTS `ofPubsubNodeGroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ofPubsubNodeGroups` (
  `serviceID` varchar(100) NOT NULL,
  `nodeID` varchar(100) NOT NULL,
  `rosterGroup` varchar(100) NOT NULL,
  KEY `ofPubsubNodeGroups_idx` (`serviceID`,`nodeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofPubsubNodeGroups`
--

LOCK TABLES `ofPubsubNodeGroups` WRITE;
/*!40000 ALTER TABLE `ofPubsubNodeGroups` DISABLE KEYS */;
/*!40000 ALTER TABLE `ofPubsubNodeGroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofPubsubNodeJIDs`
--

DROP TABLE IF EXISTS `ofPubsubNodeJIDs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ofPubsubNodeJIDs` (
  `serviceID` varchar(100) NOT NULL,
  `nodeID` varchar(100) NOT NULL,
  `jid` varchar(255) NOT NULL,
  `associationType` varchar(20) NOT NULL,
  PRIMARY KEY (`serviceID`,`nodeID`,`jid`(70))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofPubsubNodeJIDs`
--

LOCK TABLES `ofPubsubNodeJIDs` WRITE;
/*!40000 ALTER TABLE `ofPubsubNodeJIDs` DISABLE KEYS */;
/*!40000 ALTER TABLE `ofPubsubNodeJIDs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofPubsubSubscription`
--

DROP TABLE IF EXISTS `ofPubsubSubscription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ofPubsubSubscription` (
  `serviceID` varchar(100) NOT NULL,
  `nodeID` varchar(100) NOT NULL,
  `id` varchar(100) NOT NULL,
  `jid` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `state` varchar(15) NOT NULL,
  `deliver` tinyint(4) NOT NULL,
  `digest` tinyint(4) NOT NULL,
  `digest_frequency` int(11) NOT NULL,
  `expire` char(15) DEFAULT NULL,
  `includeBody` tinyint(4) NOT NULL,
  `showValues` varchar(30) DEFAULT NULL,
  `subscriptionType` varchar(10) NOT NULL,
  `subscriptionDepth` tinyint(4) NOT NULL,
  `keyword` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`serviceID`,`nodeID`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofPubsubSubscription`
--

LOCK TABLES `ofPubsubSubscription` WRITE;
/*!40000 ALTER TABLE `ofPubsubSubscription` DISABLE KEYS */;
/*!40000 ALTER TABLE `ofPubsubSubscription` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofRemoteServerConf`
--

DROP TABLE IF EXISTS `ofRemoteServerConf`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ofRemoteServerConf` (
  `xmppDomain` varchar(255) NOT NULL,
  `remotePort` int(11) DEFAULT NULL,
  `permission` varchar(10) NOT NULL,
  PRIMARY KEY (`xmppDomain`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofRemoteServerConf`
--

LOCK TABLES `ofRemoteServerConf` WRITE;
/*!40000 ALTER TABLE `ofRemoteServerConf` DISABLE KEYS */;
/*!40000 ALTER TABLE `ofRemoteServerConf` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofRoster`
--

DROP TABLE IF EXISTS `ofRoster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ofRoster` (
  `rosterID` bigint(20) NOT NULL,
  `username` varchar(64) NOT NULL,
  `jid` varchar(1024) NOT NULL,
  `sub` tinyint(4) NOT NULL,
  `ask` tinyint(4) NOT NULL,
  `recv` tinyint(4) NOT NULL,
  `nick` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`rosterID`),
  KEY `ofRoster_unameid_idx` (`username`),
  KEY `ofRoster_jid_idx` (`jid`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofRoster`
--

LOCK TABLES `ofRoster` WRITE;
/*!40000 ALTER TABLE `ofRoster` DISABLE KEYS */;
/*!40000 ALTER TABLE `ofRoster` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofRosterGroups`
--

DROP TABLE IF EXISTS `ofRosterGroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ofRosterGroups` (
  `rosterID` bigint(20) NOT NULL,
  `rank` tinyint(4) NOT NULL,
  `groupName` varchar(255) NOT NULL,
  PRIMARY KEY (`rosterID`,`rank`),
  KEY `ofRosterGroup_rosterid_idx` (`rosterID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofRosterGroups`
--

LOCK TABLES `ofRosterGroups` WRITE;
/*!40000 ALTER TABLE `ofRosterGroups` DISABLE KEYS */;
/*!40000 ALTER TABLE `ofRosterGroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofSASLAuthorized`
--

DROP TABLE IF EXISTS `ofSASLAuthorized`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ofSASLAuthorized` (
  `username` varchar(64) NOT NULL,
  `principal` text NOT NULL,
  PRIMARY KEY (`username`,`principal`(200))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofSASLAuthorized`
--

LOCK TABLES `ofSASLAuthorized` WRITE;
/*!40000 ALTER TABLE `ofSASLAuthorized` DISABLE KEYS */;
/*!40000 ALTER TABLE `ofSASLAuthorized` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofSecurityAuditLog`
--

DROP TABLE IF EXISTS `ofSecurityAuditLog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ofSecurityAuditLog` (
  `msgID` bigint(20) NOT NULL,
  `username` varchar(64) NOT NULL,
  `entryStamp` bigint(20) NOT NULL,
  `summary` varchar(255) NOT NULL,
  `node` varchar(255) NOT NULL,
  `details` text,
  PRIMARY KEY (`msgID`),
  KEY `ofSecurityAuditLog_tstamp_idx` (`entryStamp`),
  KEY `ofSecurityAuditLog_uname_idx` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofSecurityAuditLog`
--

LOCK TABLES `ofSecurityAuditLog` WRITE;
/*!40000 ALTER TABLE `ofSecurityAuditLog` DISABLE KEYS */;
/*!40000 ALTER TABLE `ofSecurityAuditLog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofUser`
--

DROP TABLE IF EXISTS `ofUser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ofUser` (
  `username` varchar(64) NOT NULL,
  `plainPassword` varchar(32) DEFAULT NULL,
  `encryptedPassword` varchar(255) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `creationDate` char(15) NOT NULL,
  `modificationDate` char(15) NOT NULL,
  PRIMARY KEY (`username`),
  KEY `ofUser_cDate_idx` (`creationDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofUser`
--

LOCK TABLES `ofUser` WRITE;
/*!40000 ALTER TABLE `ofUser` DISABLE KEYS */;
INSERT INTO `ofUser` VALUES ('admin',NULL,'f6ed629c8a91b7c18e550e0ff787f29e2c4720c45d819c34','Administrator','admin@example.com','001441218448911','0'),('amazing_bot%j6eie349mf7',NULL,'0b32d2fc39f0480910b6125e995c06546d6626be382c52ee13d49d3de135aff304d490ca81aa9826',NULL,NULL,'001441218472420','001441218472420'),('echo_bot%j6eie349mf7',NULL,'5df0da3bce6a8b30929afce21ba68531c5ed2d601c38c41bca08a1f35fcad2ee06e7473d7a2afdc5',NULL,NULL,'001441218472439','001441218472439'),('player_bot%d93ie349mi6',NULL,'9c0e8b812d4b2b91dad422dbc2dd74e4d2c8ce85351fc46589e5841c1e460fe0b36d2325563d9eb3',NULL,NULL,'001441218472510','001441218472510'),('serveruser%2sqie34g80t',NULL,'d08aef336b1504eae3a1c59a2f985a8cd706507cf5cee93b1022410f8fe595a1583a92e8ab80e2e8','androidTestApp Serveruser',NULL,'001441218780319','001441218780319'),('serveruser%c3die34g1fx',NULL,'b45aaef5cbf1dc14166459330e40ca1be7ee66f249578086a0ec43a8db99a88e5c7ab276d794a8f6','iosTestApp Serveruser',NULL,'001441218771792','001441218771792'),('serveruser%d93ie349mi6',NULL,'c7f794eb6f0da4b8263798c3b8df14b32dc5cf1e5c691886010bf19babb9d68a4787e43c006be808','RPSLS Serveruser',NULL,'001441218472495','001441218472495'),('serveruser%hgtie349miz',NULL,'ba8cfcc4938bb05a59a735b7f9c1cca01718d2791f8575700bf65273c6df1a71e65d49aa412ca541','Soapbox Serveruser',NULL,'001441218472524','001441218472524'),('serveruser%j6eie349mf7',NULL,'d98631b2dbaa1a9f2f0efd541696a1c4a56d6e9632d1f119bc56ffd9e30253106a09fda2b6fb0a06','Quickstart Serveruser',NULL,'001441218472389','001441218472389');
/*!40000 ALTER TABLE `ofUser` ENABLE KEYS */;
UNLOCK TABLES;


--
-- Table structure for table `mmxTag`
--

DROP TABLE IF EXISTS `mmxTag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mmxTag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tagname` varchar(25) NOT NULL,
  `creationDate` datetime NOT NULL,
  `appid` varchar(16) NOT NULL,
  `deviceId` int(11) DEFAULT NULL,
  `username` varchar(64) DEFAULT NULL,
  `serviceID` varchar(100) DEFAULT NULL,
  `nodeID` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tagname_appId_deviceId` (`tagname`,`appid`,`deviceId`),
  UNIQUE KEY `tagname_appId_username` (`tagname`,`appid`,`username`),
  UNIQUE KEY `tagname_appId_topic` (`tagname`,`appid`,`serviceID`,`nodeID`),
  KEY `deviceId` (`deviceId`),
  KEY `username` (`username`),
  KEY `serviceID` (`serviceID`,`nodeID`),
  CONSTRAINT `mmxtag_ibfk_1` FOREIGN KEY (`deviceId`) REFERENCES `mmxDevice` (`id`) ON DELETE CASCADE,
  CONSTRAINT `mmxtag_ibfk_2` FOREIGN KEY (`username`) REFERENCES `ofUser` (`username`) ON DELETE CASCADE,
  CONSTRAINT `mmxtag_ibfk_3` FOREIGN KEY (`serviceID`, `nodeID`) REFERENCES `ofPubsubNode` (`serviceID`, `nodeID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mmxTag`
--

LOCK TABLES `mmxTag` WRITE;
/*!40000 ALTER TABLE `mmxTag` DISABLE KEYS */;
/*!40000 ALTER TABLE `mmxTag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofUserFlag`
--

DROP TABLE IF EXISTS `ofUserFlag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ofUserFlag` (
  `username` varchar(64) NOT NULL,
  `name` varchar(100) NOT NULL,
  `startTime` char(15) DEFAULT NULL,
  `endTime` char(15) DEFAULT NULL,
  PRIMARY KEY (`username`,`name`),
  KEY `ofUserFlag_sTime_idx` (`startTime`),
  KEY `ofUserFlag_eTime_idx` (`endTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofUserFlag`
--

LOCK TABLES `ofUserFlag` WRITE;
/*!40000 ALTER TABLE `ofUserFlag` DISABLE KEYS */;
/*!40000 ALTER TABLE `ofUserFlag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofUserProp`
--

DROP TABLE IF EXISTS `ofUserProp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ofUserProp` (
  `username` varchar(64) NOT NULL,
  `name` varchar(100) NOT NULL,
  `propValue` text NOT NULL,
  PRIMARY KEY (`username`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofUserProp`
--

LOCK TABLES `ofUserProp` WRITE;
/*!40000 ALTER TABLE `ofUserProp` DISABLE KEYS */;
/*!40000 ALTER TABLE `ofUserProp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofVCard`
--

DROP TABLE IF EXISTS `ofVCard`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ofVCard` (
  `username` varchar(64) NOT NULL,
  `vcard` mediumtext NOT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofVCard`
--

LOCK TABLES `ofVCard` WRITE;
/*!40000 ALTER TABLE `ofVCard` DISABLE KEYS */;
/*!40000 ALTER TABLE `ofVCard` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ofVersion`
--

DROP TABLE IF EXISTS `ofVersion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ofVersion` (
  `name` varchar(50) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ofVersion`
--

LOCK TABLES `ofVersion` WRITE;
/*!40000 ALTER TABLE `ofVersion` DISABLE KEYS */;
INSERT INTO `ofVersion` VALUES ('mmxappmgmt',4),('openfire',25);
/*!40000 ALTER TABLE `ofVersion` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;