CREATE TABLE `customer` (
  `customerID` int NOT NULL AUTO_INCREMENT,
  `customerName` varchar(45) NOT NULL,
  `emailAddress` varchar(45) NOT NULL,
  `addressDetail` varchar(80) NOT NULL,
  `state` varchar(4) NOT NULL,
  `postcode` varchar(4) NOT NULL,
  `startDate` date NOT NULL,
  PRIMARY KEY (`customerID`),
  UNIQUE KEY `customerID_UNIQUE` (`customerID`));
CREATE TABLE `member` (
  `memberID` int NOT NULL AUTO_INCREMENT,
  `memberName` varchar(45) NOT NULL,
  `contactName` varchar(45) NOT NULL,
  `startDate` date NOT NULL,
  `endDate` varchar(8) NOT NULL DEFAULT '',
  `businessName` varchar(45) NOT NULL,
  `address` varchar(80) NOT NULL,
  `phoneNumber` varchar(10) NOT NULL,
  `emailAddress` varchar(45) NOT NULL,
  `memberDescription` varchar(80) NOT NULL,
  PRIMARY KEY (`memberID`),
  UNIQUE KEY `memberId_UNIQUE` (`memberID`),
  UNIQUE KEY `businessName_UNIQUE` (`businessName`),
  UNIQUE KEY `memberAddress_UNIQUE` (`Address`),
  UNIQUE KEY `phoneNumber_UNIQUE` (`phoneNumber`),
  UNIQUE KEY `emailAddress_UNIQUE` (`emailAddress`));

CREATE TABLE `produceitem` (
  `itemID` int NOT NULL AUTO_INCREMENT,
  `itemName` varchar(45) NOT NULL,
  `weight` decimal(5,3) NOT NULL,
  `description` varchar(200) NOT NULL,
  PRIMARY KEY (`itemID`),
  UNIQUE KEY `itemID_UNIQUE` (`itemID`),
  UNIQUE KEY `itemName_UNIQUE` (`itemName`));

CREATE TABLE `order` (
  `orderID` int NOT NULL AUTO_INCREMENT,
  `customerID` int NOT NULL,
  `memberID` int NOT NULL,
  `orderDate` date NOT NULL,
  `orderStatus` enum('placed','cancelled','shipped','delivered') NOT NULL,
  PRIMARY KEY (`orderID`),
  UNIQUE KEY `orderID_UNIQUE` (`orderID`),
  KEY `FK_memberID_2_idx` (`memberID`),
  KEY `FK_customerID_2_idx` (`customerID`),
  CONSTRAINT `FK_customerID_2` FOREIGN KEY (`customerID`) REFERENCES `customer` (`customerID`),
  CONSTRAINT `FK_memberID_2` FOREIGN KEY (`memberID`) REFERENCES `member` (`memberID`));


CREATE TABLE `orderitem` (
  `orderID` int NOT NULL,
  `itemID` int NOT NULL,
  `quantity` int NOT NULL,
  PRIMARY KEY (`itemID`,`orderID`),
  KEY `FK_itemID_1_idx` (`itemID`),
  KEY `FK_orderID_1_idx` (`orderID`),
  CONSTRAINT `FK_itemID_1` FOREIGN KEY (`itemID`) REFERENCES `produceitem` (`itemID`),
  CONSTRAINT `FK_orderID_1` FOREIGN KEY (`orderID`) REFERENCES `order` (`orderID`));

CREATE TABLE `stock` (
  `memberID` int NOT NULL,
  `itemID` int NOT NULL,
  `price` decimal(5,2) NOT NULL,
  `priceDate` date NOT NULL,
  `unitShippingCost` decimal(4,2) NOT NULL,
  `inStock` int NOT NULL,
  PRIMARY KEY (`memberID`,`itemID`),
  KEY `FK_itemID_2_idx` (`itemID`),
  KEY `FK_memberID_3_idx` (`memberID`),
  CONSTRAINT `FK_itemID_2` FOREIGN KEY (`itemID`) REFERENCES `produceitem` (`itemID`),
  CONSTRAINT `FK_memberID_3` FOREIGN KEY (`memberID`) REFERENCES `member` (`memberID`));

CREATE TABLE `shipping` (
  `shippingID` int NOT NULL AUTO_INCREMENT,
  `orderID` int NOT NULL,
  `shippingDate` date NOT NULL,
  `courier` varchar(45) NOT NULL,
  PRIMARY KEY (`shippingID`),
  UNIQUE KEY `shippingID_UNIQUE` (`shippingID`),
  KEY `FK_orderID_2_idx` (`orderID`),
  CONSTRAINT `FK_orderID_2` FOREIGN KEY (`orderID`) REFERENCES `order` (`orderID`));

CREATE TABLE `message` (
  `messageID` int NOT NULL AUTO_INCREMENT,
  `customerID` int NOT NULL,
  `memberID` int NOT NULL,
  `dateStamp` datetime NOT NULL,
  `messageDetail` varchar(200) NOT NULL,
  PRIMARY KEY (`messageID`),
  UNIQUE KEY `messageID_UNIQUE` (`messageID`),
  KEY `FK_memberID_1_idx` (`memberID`),
  KEY `FK_customerID_1_idx` (`customerID`),
  CONSTRAINT `FK_customerID_1` FOREIGN KEY (`customerID`) REFERENCES `customer` (`customerID`),
  CONSTRAINT `FK_memberID_1` FOREIGN KEY (`memberID`) REFERENCES `member` (`memberID`));

DELIMITER //
CREATE TRIGGER order_notification
AFTER INSERT
ON `order` FOR EACH ROW
	BEGIN
INSERT INTO `message`(customerID, memberID, dateStamp, messageDetail)
VALUES(new.customerID, new.memberID, Now(), CONCAT('You have a nwe order. orderID', new.orderID));
	END; //
DELIMITER ;



INSERT INTO `member`(memberName, contactName, startDate, businessName, address, phoneNumber, emailAddress, memberDescription)
VALUES
('Oliver Kuo', 'Shelly Adams', 20190807, 'Fabulous Fruit & Veg', 'Bluebell Road, Tinana, QLD 4650', 0456111555, 'ffv@qo.org.au', 'cheap price'),
('Emily Ward', 'Gary Ward', 20190807, 'Organic Green Grocer', 'Brook Rd, Kumbia, QLD 4610', 0498923341, 'ogg@qo.org.au', 'apple'),
('John Quinn', 'Jessica Stockdale', 20190808, 'Bellthorpe’s Best', 'BerriesBrandons Road, Bellthorpe, QLD 4514', 0433789563, 'bb@qo.org.au', 'best berries'),
('Kate Johnson', 'Anthony Johnstone', 20190913, 'Stanthorpe Strawberries', 'Mount Banca Road, Stanthorpe, QLD 4380', 0495876879, 'ss@qo.org.au', 'high quality'),
('Lebron James', 'Sarah James', 20190922, 'Atherton Organic', '142 Channel Road, Tinaroo, QLD 4882', 0478933451, 'ao@qo.org.au', 'high quality'),
('Jennifer Kim', 'Nick Andrews', 20200111, 'Organic Fruit Emporium', '190 Green Rd, Wamuran, QLD 4512', 0403019438, 'ofe@qu.ord.au', 'real organic');

INSERT INTO `produceItem`(itemID, itemName, weight, description)
VALUES
(1, 'Vegetable Box', 15, 'Fresh seasonal vegetables'),
(2, 'Salad Box', 10, 'Fresh seasonal salad vegetables'),
(3, 'Fruit Box', 10, 'Fresh seasonal fruit'),
(4, 'Mixed Box', 15, 'Fresh seasonal fruit and vegetables'),
(5, 'Vegetable & Herb Box', 15, 'Household staples plus garden fresh herbs'),
(6, 'Berry Mix', 1, 'Seasonal mix of strawberries, blueberries and raspberries'),
(7, 'Capsicum', 0.22, 'Organic red'),
(8, 'Mushrooms', 0.5, 'Flat brown mushrooms'),
(9, 'Turmeric', 0.2, 'Fresh turmeric roots'),
(10, 'Asian Greens', 0.5, 'Random – bok/choisum/kailan'),
(11, 'Tomatoes', 0.25, 'Organic grape/cherry'),
(12, 'Ginger', 0.2, 'Fresh ginger roots');

INSERT INTO `stock`(memberID, itemID, price, priceDate, unitShippingCost, inStock)
VALUES
(1, 1, 50, 20190808, 18, 20),
(1, 2, 40, 20190808, 15, 17),
(1, 3, 45, 20190808, 15, 8),
(1, 4, 69.5, 20190808, 17, 30),
(1, 5, 55.5, 20190808, 15, 18),
(1, 6, 20, 20190808, 4, 10),
(2, 1, 49, 20190810, 15, 11),
(2, 2, 39, 20190810, 10, 13),
(2, 3, 44, 20190810, 10, 11),
(3, 4, 70, 20190820, 18, 3),
(3, 5, 59.5, 20190820, 16, 7),
(3, 6, 19, 20190820, 5, 33);

INSERT INTO `customer`(customerName, emailAddress, addressDetail, state, postcode, startDate)
VALUES
('Saba Mckinney', 'saba.m@gmail.com', '75 Creek Street, CATTLE CREEK', 'QLD', '4407', 20191010),
('Maisha Cooley', ' maisha999@gmail.com', '20 Stanley Drive, SUGARLOAF', 'QLD', '4800', 20191102),
('Ross Mcgregor', 'rossy0205@gmail.com', '13 Bayview Close, WOORABINDA', 'QLD', '4713', 20191105),
('River Lyon', 'riversfamily@gmail.com', '27 Lewin Street, OSBORNE', 'NSW', '2656', 20191113),
('Ayse Rhodes', 'ayse1984@gmail.com', '31 Wilson Street, GOWANFORD', 'VIC', '3544', 20191113),
('Sahil Reid', 'reider123@gmail.com', '52 Goldfields Road, HIGHFIELDS', 'QLD', '4352', 20191113),
('Bobbie Sampson', 'bigbob@gmail.com', '80 Ocean Pde, REID RIVER', 'QLD', '4816', 20191115),
('Duncan Salazar', 'hightower777@gmail.com', '35 Boonah Qld, SOMERSET DAM', 'QLD', '4312', 20191117);


INSERT INTO `order`(customerID, memberID, orderDate, orderStatus)
VALUES
(1, 1, 20191205, 'delivered'),
(2, 2, 20191207, 'delivered'),
(3, 3, 20191208, 'delivered'),
(4, 1, 20191210, 'delivered'),
(3, 1, 20191217, 'delivered'),
(5, 1, 20191220, 'delivered');

INSERT INTO `orderitem`(orderid, itemid, quantity)
VALUES
(1, 1, 1),(1, 2, 2),(1, 3, 1),
(2, 3, 2),(2, 2, 2),(2, 1, 3),
(3, 4, 1),(3, 5, 2),(3, 6, 3),
(4, 4, 1),(4, 5, 2),(4, 2, 2),
(5, 5, 1),(5, 6, 1),(5, 3, 3),
(6, 2, 1),(6, 5, 5),(6, 3, 1);



SELECT o.orderID, o.customerID as 'accountNumber', c.customerName, o.orderDate,
coalesce(p.itemName, 'ALL') as itemName,
sum(i.quantity) as 'quantity',
ROUND(AVG(s.price),2) as 'unitItemCost',
ROUND(AVG(s.unitShippingCost),2) as 'unitShippingCost',
sum(i.quantity * s.price) as 'totalItemCost',
sum(i.quantity * s.unitShippingCost) as 'totalShippingCost',
sum(i.quantity *(s.price + s.unitShippingCost)) as 'total'
FROM `order` o JOIN `orderitem` i ON o.orderid = i.orderid JOIN `customer` c ON c.customerid = o.customerid 
JOIN `member` m ON m.memberid = o.memberid JOIN `stock` s ON m.memberid= s.memberid 
JOIN `produceitem` p ON p.itemid = i.itemid AND p.itemid = s.itemid 
WHERE o.orderid = 1
GROUP BY itemName WITH ROLLUP;


SELECT o.orderid, o.orderDate, c.customerID, c.customerName, c.state, sum(i.quantity * (s.price + s.unitShippingCost)) as 'total'
FROM `order` o JOIN `orderitem` i ON o.orderid = i.orderid JOIN `customer` c ON c.customerid = o.customerid   
JOIN `member` m ON m.memberid = o.memberid JOIN `stock` s ON m.memberid= s.memberid 
JOIN `produceitem` p ON p.itemid = i.itemid AND p.itemid = s.itemid
WHERE o.memberID = 1 AND o.orderDate BETWEEN 20191201 AND 20191231 GROUP BY c.customerID ORDER BY o.orderDate ASC;