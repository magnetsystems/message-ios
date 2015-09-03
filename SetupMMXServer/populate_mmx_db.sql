# ************************************************************
# Sequel Pro SQL dump
# Version 4096
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# Host: 127.0.0.1 (MySQL 5.6.10)
# Database: mmxintegtest
# Generation Time: 2015-04-13 17:33:35 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table mmxApp
# ------------------------------------------------------------


LOCK TABLES `mmxApp` WRITE;
/*!40000 ALTER TABLE `mmxApp` DISABLE KEYS */;

DELETE from mmxApp WHERE appId='n9ci8ffoitr';

INSERT INTO `mmxApp` (`id`, `serverUserId`, `appName`, `appId`, `apiKey`, `encryptedApiKey`, `googleApiKey`, `googleProjectId`, `apnsCert`, `apnsCertPlainPassword`, `apnsCertEncryptedPassword`, `apnsCertProduction`, `creationDate`, `modificationDate`, `ownerId`, `ownerEmail`, `guestUserId`, `guestSecret`)
VALUES
	(1, 'serveruser%n9ci8ffoitr', 'IntegrationTestApp', 'n9ci8ffoitr', '55cff1f0-be33-4ba5-b76f-231954ab369f', '1a0a2814c644dcea866775f972354faec6c74ccffe0531134736482c6650b302b8d6c1b0c3045ff1117836701d9aa6421603266a90d7551ec9c405cacb7ed2e939541781534a5613444045d105360ec907fbf8ec52977ede', 'AIzaSyDYVjCGwLXDn_ChatnbePadt5GMp_LxpFM', '599981932022', NULL, NULL, NULL, 0, '2015-04-12 22:22:23', '2015-04-12 22:22:23', 'f7758430-e198-11e4-bce8-617dbe9255aa', 'sysadmin@company.com', NULL, '3c27efc5-0bfe-40f5-aa47-f600910aff12');

/*!40000 ALTER TABLE `mmxApp` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table ofPubsubNode
# ------------------------------------------------------------

LOCK TABLES `ofPubsubNode` WRITE;
/*!40000 ALTER TABLE `ofPubsubNode` DISABLE KEYS */;

DELETE from ofPubsubNode WHERE serviceID='pubsub' AND nodeID='n9ci8ffoitr';
INSERT INTO `ofPubsubNode` (`serviceID`, `nodeID`, `leaf`, `creationDate`, `modificationDate`, `parent`, `deliverPayloads`, `maxPayloadSize`, `persistItems`, `maxItems`, `notifyConfigChanges`, `notifyDelete`, `notifyRetract`, `presenceBased`, `sendItemSubscribe`, `publisherModel`, `subscriptionEnabled`, `configSubscription`, `accessModel`, `payloadType`, `bodyXSLT`, `dataformXSLT`, `creator`, `description`, `language`, `name`, `replyPolicy`, `associationPolicy`, `maxLeafNodes`)
VALUES
	('pubsub','n9ci8ffoitr',0,'001428902543447','001428902543447','',1,0,0,0,1,1,0,0,0,'open',1,0,'authorize','','','','serveruser%n9ci8ffoitr@mmx','','English','',NULL,'all',-1);

/*!40000 ALTER TABLE `ofPubsubNode` ENABLE KEYS */;
UNLOCK TABLES;



# Dump of table ofUser
# ------------------------------------------------------------

DELETE from ofUser WHERE username='serveruser%n9ci8ffoitr';

LOCK TABLES `ofUser` WRITE;
/*!40000 ALTER TABLE `ofUser` DISABLE KEYS */;

INSERT INTO `ofUser` (`username`, `plainPassword`, `encryptedPassword`, `name`, `email`, `creationDate`, `modificationDate`)
VALUES
	('serveruser%n9ci8ffoitr','test',NULL,'IntegrationTestApp Serveruser',NULL,'001428902543441','001428902543441');

/*!40000 ALTER TABLE `ofUser` ENABLE KEYS */;
UNLOCK TABLES;


# USERS and DEVICES
INSERT INTO `ofUser` (`username`, `plainPassword`, `encryptedPassword`, `name`, `email`, `creationDate`, `modificationDate`)
VALUES
	('testuser%n9ci8ffoitr', 'testuser', NULL, 'MMXClientTest1', 'user1@localhost.com', '001429039825757', '001429039825757'),
	('mmxclienttest2%n9ci8ffoitr', 'test', NULL, 'MMXClientTest2', NULL, '001429039826091', '001429039826091'),
	('rest_tester%n9ci8ffoitr', 'test', NULL, 'Resting Tester', NULL, '001429039826091', '001429039826091');

INSERT INTO `mmxDevice` (`id`, `name`, `ownerJid`, `appId`, `osType`, `deviceId`, `tokenType`, `clientToken`, `versionInfo`, `modelInfo`, `phoneNumber`, `phoneNumberRev`, `carrierInfo`, `dateCreated`, `dateUpdated`, `status`, `protocolVersionMajor`, `protocolVersionMinor`, `pushStatus`)
VALUES
	(1, 'MMXClientTest1\'s Genymotion Google Nexus 5 - 5.1.0 - API 22 - 1080x1920', 'mmxclienttest1', 'n9ci8ffoitr', 'ANDROID', 'test-client1-devId-1429039847558', 'GCM', 'APA91bFCjsLa14w4WSTfJG2NoI7jPAD3tpuOeiyUDLEkG4gWiqvi-K30yJku-LQRCXWoLSI9601KGNwn_RB6-aVdbfvsts89mPjEZRqtxKzmEEKpFCyi2ZwVMNtoxUyT28MMos82eiJ_KtCEPraBy8KAJuroKWjp14tptrGkzSdCyRH0d3o3oUw', '5.1', 'Genymotion Google Nexus 5 - 5.1.0 - API 22 - 1080x1920', '15555215554', '45551255551', 'TMOBILE', '2015-04-14 12:30:47', '2015-04-14 12:31:03', 'ACTIVE', 0, 8, 'VALID'),
	(2, 'MMXClientTest2\'s Genymotion Google Nexus 5 - 5.1.0 - API 22 - 1080x1920', 'mmxclienttest2', 'n9ci8ffoitr', 'ANDROID', 'test-client2-devId-1429039847558', 'GCM', 'APA91bFCjsLa14w4WSTfJG2NoI7jPAD3tpuOeiyUDLEkG4gWiqvi-K30yJku-LQRCXWoLSI9601KGNwn_RB6-aVdbfvsts89mPjEZRqtxKzmEEKpFCyi2ZwVMNtoxUyT28MMos82eiJ_KtCEPraBy8KAJuroKWjp14tptrGkzSdCyRH0d3o3oUw', '5.1', 'Genymotion Google Nexus 5 - 5.1.0 - API 22 - 1080x1920', '15555215554', '45551255551', 'TMOBILE', '2015-04-14 12:30:47', '2015-04-14 12:31:03', 'ACTIVE', 0, 8, 'VALID');

INSERT INTO `mmxDevice` (`id`, `name`, `ownerJid`, `appId`, `osType`, `deviceId`, `tokenType`, `clientToken`, `versionInfo`, `modelInfo`, `phoneNumber`, `phoneNumberRev`, `carrierInfo`, `dateCreated`, `dateUpdated`, `status`, `protocolVersionMajor`, `protocolVersionMinor`, `pushStatus`) VALUES (7,'Dude\'s android','rest_tester','n9ci8ffoitr','ANDROID','8933536df7038e1b7','GCM','APA91bHaCculnOoolX0HV3f3CLHBY52C-H0lDS_m-lXXg5MbT9-EJiE6ooe0dUWURLuTQmVOttBS18cQwX5Pe-k9JDI2o8bqRhi3UZ0McTNs9JADvguH63vihIbVAgAjUm4K8mOZcRG4MC-edQBiiZ87l-GnQKpZ4ejBRP3j72oVQI6ooDavac4','macron',NULL,'4083084001','1004803804','ATT','2014-09-09 15:36:35',NULL,'ACTIVE',NULL,NULL,NULL);
INSERT INTO `mmxDevice` (`id`, `name`, `ownerJid`, `appId`, `osType`, `deviceId`, `tokenType`, `clientToken`, `versionInfo`, `modelInfo`, `phoneNumber`, `phoneNumberRev`, `carrierInfo`, `dateCreated`, `dateUpdated`, `status`, `protocolVersionMajor`, `protocolVersionMinor`, `pushStatus`) VALUES (8,'Johns phone','rest_tester','n9ci8ffoitr','ANDROID','12345678987654321','GCM','some-token','macron',NULL,NULL,NULL,NULL,'2014-09-09 17:17:07',NULL,'ACTIVE',NULL,NULL,NULL);
INSERT INTO `mmxDevice` (`id`, `name`, `ownerJid`, `appId`, `osType`, `deviceId`, `tokenType`, `clientToken`, `versionInfo`, `modelInfo`, `phoneNumber`, `phoneNumberRev`, `carrierInfo`, `dateCreated`, `dateUpdated`, `status`, `protocolVersionMajor`, `protocolVersionMinor`, `pushStatus`) VALUES (9,'John Tablet','rest_tester','n9ci8ffoitr','ANDROID','12345678987654322','GCM','some-token','macron',NULL,NULL,NULL,NULL,'2014-09-09 17:17:07',NULL,'ACTIVE',NULL,NULL,NULL);
INSERT INTO `mmxDevice` (`id`, `name`, `ownerJid`, `appId`, `osType`, `deviceId`, `tokenType`, `clientToken`, `versionInfo`, `modelInfo`, `phoneNumber`, `phoneNumberRev`, `carrierInfo`, `dateCreated`, `dateUpdated`, `status`, `protocolVersionMajor`, `protocolVersionMinor`, `pushStatus`) VALUES (10,'Johns other phone','rest_tester','n9ci8ffoitr','ANDROID','12345678987654324','GCM','some-token','macron',NULL,NULL,NULL,NULL,'2014-09-09 17:17:07',NULL,'INACTIVE',NULL,NULL,NULL);
INSERT INTO `mmxDevice` (`id`, `name`, `ownerJid`, `appId`, `osType`, `deviceId`, `tokenType`, `clientToken`, `versionInfo`, `modelInfo`, `phoneNumber`, `phoneNumberRev`, `carrierInfo`, `dateCreated`, `dateUpdated`, `status`, `protocolVersionMajor`, `protocolVersionMinor`, `pushStatus`) VALUES (11,'Todd desktop','rest_tester','n9ci8ffoitr','UNIX','00001LINUX',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2014-09-30 17:17:07',NULL,'ACTIVE',NULL,NULL,NULL);
INSERT INTO `mmxDevice` (`id`, `name`, `ownerJid`, `appId`, `osType`, `deviceId`, `tokenType`, `clientToken`, `versionInfo`, `modelInfo`, `phoneNumber`, `phoneNumberRev`, `carrierInfo`, `dateCreated`, `dateUpdated`, `status`, `protocolVersionMajor`, `protocolVersionMinor`, `pushStatus`) VALUES (12,'Buds Phone','rest_tester','n9ci8ffoitr','ANDROID','12345678987654323',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2014-09-30 17:17:07',NULL,'INACTIVE',NULL,NULL,NULL);
INSERT INTO `mmxDevice` (`id`, `name`, `ownerJid`, `appId`, `osType`, `deviceId`, `tokenType`, `clientToken`, `versionInfo`, `modelInfo`, `phoneNumber`, `phoneNumberRev`, `carrierInfo`, `dateCreated`, `dateUpdated`, `status`, `protocolVersionMajor`, `protocolVersionMinor`, `pushStatus`) VALUES (13,'Alf phone','rest_tester','n9ci8ffoitr','ANDROID','12345678987654300','GCM',NULL,'macron',NULL,NULL,NULL,NULL,'2014-09-09 17:17:07',NULL,'ACTIVE',NULL,NULL,NULL);
INSERT INTO `mmxDevice` (`id`, `name`, `ownerJid`, `appId`, `osType`, `deviceId`, `tokenType`, `clientToken`, `versionInfo`, `modelInfo`, `phoneNumber`, `phoneNumberRev`, `carrierInfo`, `dateCreated`, `dateUpdated`, `status`, `protocolVersionMajor`, `protocolVersionMinor`, `pushStatus`) VALUES (17,'iPhone Simulator','rest_tester','n9ci8ffoitr','IOS','9D49D5B1-8694-48A3-9D00-EC00ACE25794','APNS',NULL,'iPhone OS,8.1',NULL,NULL,NULL,NULL,'2015-01-06 16:06:36','2015-01-16 15:27:47','ACTIVE',NULL,NULL,NULL);
INSERT INTO `mmxDevice` (`id`, `name`, `ownerJid`, `appId`, `osType`, `deviceId`, `tokenType`, `clientToken`, `versionInfo`, `modelInfo`, `phoneNumber`, `phoneNumberRev`, `carrierInfo`, `dateCreated`, `dateUpdated`, `status`, `protocolVersionMajor`, `protocolVersionMinor`, `pushStatus`) VALUES (18,'iPhone Simulator','rest_tester','n9ci8ffoitr','IOS','398668AF-2395-4B64-B300-60F0ABC7459F',NULL,NULL,'iPhone OS,8.1',NULL,NULL,NULL,NULL,'2015-01-07 12:14:40','2015-01-16 15:16:51','ACTIVE',NULL,NULL,NULL);
INSERT INTO `mmxDevice` (`id`, `name`, `ownerJid`, `appId`, `osType`, `deviceId`, `tokenType`, `clientToken`, `versionInfo`, `modelInfo`, `phoneNumber`, `phoneNumberRev`, `carrierInfo`, `dateCreated`, `dateUpdated`, `status`, `protocolVersionMajor`, `protocolVersionMinor`, `pushStatus`) VALUES (19,'Rahul P iPhone','rest_tester','n9ci8ffoitr','IOS','7215B73D-5325-49E1-806A-2E4A5B3F7020','APNS','0e52e31f2d27604e2d5593aa5b8f7b51acad15f9626998514ac1a021dff4d575','iPhone OS,8.1.2',NULL,NULL,NULL,NULL,'2015-01-09 14:47:53','2015-01-09 15:11:41','ACTIVE',NULL,NULL,NULL);
INSERT INTO `mmxDevice` (`id`, `name`, `ownerJid`, `appId`, `osType`, `deviceId`, `tokenType`, `clientToken`, `versionInfo`, `modelInfo`, `phoneNumber`, `phoneNumberRev`, `carrierInfo`, `dateCreated`, `dateUpdated`, `status`, `protocolVersionMajor`, `protocolVersionMinor`, `pushStatus`) VALUES (26,'Field 6 iPhone 6','rest_tester','n9ci8ffoitr','IOS','CC7EA86D-4654-449A-B3AF-EC2837B8A44D','APNS','a2e75c608a95652600d491b8573b5473f7965366002e4140938f00c024d05695',NULL,NULL,NULL,NULL,NULL,'2015-02-18 16:25:04',NULL,'ACTIVE',NULL,NULL,'VALID');
INSERT INTO `mmxDevice` (`id`, `name`, `ownerJid`, `appId`, `osType`, `deviceId`, `tokenType`, `clientToken`, `versionInfo`, `modelInfo`, `phoneNumber`, `phoneNumberRev`, `carrierInfo`, `dateCreated`, `dateUpdated`, `status`, `protocolVersionMajor`, `protocolVersionMinor`, `pushStatus`) VALUES (35,'trung\'s iPhone','rest_tester','n9ci8ffoitr','IOS','DDAFAD57-9A38-4BB4-8263-E40177B94B0E','APNS','1225382d644aa7d5dde926b1bfadb037f7b636a0b346ccac7ed057ff650c3b96','8.1.2','8.0.3',NULL,NULL,NULL,'2015-03-20 11:11:56',NULL,'ACTIVE',1,0,'VALID');
INSERT INTO `mmxDevice` (`id`, `name`, `ownerJid`, `appId`, `osType`, `deviceId`, `tokenType`, `clientToken`, `versionInfo`, `modelInfo`, `phoneNumber`, `phoneNumberRev`, `carrierInfo`, `dateCreated`, `dateUpdated`, `status`, `protocolVersionMajor`, `protocolVersionMinor`, `pushStatus`) VALUES (36,'iAPNS Test Device','rest_tester','n9ci8ffoitr','IOS','7215B73D-5325-49E1-806A-2E4A5B3F8000','APNS','59AC2DAE4EEC46C8AD8DB01C41D0F89519800B459CEC75CF89C225E3661EC075',NULL,NULL,NULL,NULL,NULL,'2015-02-18 15:06:51',NULL,'ACTIVE',NULL,NULL,'INVALID');
INSERT INTO `mmxDevice` (`id`, `name`, `ownerJid`, `appId`, `osType`, `deviceId`, `tokenType`, `clientToken`, `versionInfo`, `modelInfo`, `phoneNumber`, `phoneNumberRev`, `carrierInfo`, `dateCreated`, `dateUpdated`, `status`, `protocolVersionMajor`, `protocolVersionMinor`, `pushStatus`) VALUES (37,'Kevin\'s iPhone 6','rest_tester','n9ci8ffoitr','IOS','398668AF-2395-4B64-B300-60F0ABC7459E','APNS','bogustoken','iPhone OS,8.1',NULL,NULL,NULL,NULL,'2015-01-07 12:14:40','2015-01-16 15:16:51','ACTIVE',NULL,NULL,'VALID');


/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;