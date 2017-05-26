CREATE DATABASE IF NOT EXISTS `shopping_cart`;
USE `shopping_cart`;

/*Table structure for table `tbl_user` */
DROP TABLE IF EXISTS `tbl_user`;

CREATE TABLE `tbl_user` (
  `user_id` int(20) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(45) DEFAULT NULL,
  `user_email` varchar(45) DEFAULT NULL,
  `user_password` varchar(8) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `tbl_user` AUTO_INCREMENT=1001;

/*Data for the table `tbl_user` */

insert  into `tbl_user`(`user_name`,`user_email`,`user_password`) values 

('Wes gibbins','wessy@abc.com','1234'),
('Avijit Haloom','avi@dirac.com','7890');
INSERT INTO tbl_user VALUES(NULL, 'walsh','wal@xyz.com','qwerty');

/*Table structure for table `tbl_wish` */

DROP TABLE IF EXISTS `tbl_wish`;

CREATE TABLE `tbl_wish` (
  `wish_id` int(10) NOT NULL AUTO_INCREMENT,
  `user_id` int(20) NOT NULL REFERENCES tbl_user(user_id),
  `wish_date` datetime DEFAULT NULL,
  `item_id` int(10) NOT NULL REFERENCES tbl_inventory(item_id),
  PRIMARY KEY (`wish_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
ALTER TABLE `tbl_wish` AUTO_INCREMENT=1;

/*creating inventory table*/
DROP TABLE IF EXISTS `tbl_inventory`;

CREATE TABLE `tbl_inventory` (
`item_id` int(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
`item_name` varchar(45) DEFAULT NULL,
`item_category` varchar(45) DEFAULT NULL,
`item_brand` varchar(45) DEFAULT NULL,
`item_price` int(10) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

INSERT INTO tbl_inventory VALUES (NULL, 'muscle power 29', 'racquets','yonex',2900);
INSERT INTO tbl_inventory VALUES (NULL, 'lightweight kit bag', 'kit bag','li ning',1450);

CREATE TABLE `inventory_pic` ( 
`idpic` int(10) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY key, 
`caption` VARCHAR(45) NOT NULL, 
`img` LONGBLOB NOT NULL,
`item_id` int(10),
foreign key (`item_id`) REFERENCES `tbl_inventory`(`item_id`) on delete cascade 
) 
ENGINE = InnoDB DEFAULT CHARSET=latin1; 


/* Procedure structure for procedure `sp_createUser` */

DROP PROCEDURE IF EXISTS  `sp_createUser`;

DELIMITER $$

CREATE DEFINER=`root`@`127.0.0.1` PROCEDURE `sp_createUser`(
    IN p_name VARCHAR(20),
    IN p_useremail VARCHAR(20),
    IN p_password VARCHAR(20)
)
BEGIN
    IF ( select exists (select 1 from tbl_user where user_email = p_useremail) ) THEN
     
        select 'Email already registered!!';
     
    ELSE
     
        insert into tbl_user
        (
            user_id,
            user_name,
            user_email,
            user_password
        )
        values
        (
            NULL,
            p_name,
            p_useremail,
            p_password
        );
     
    END IF;
END $$
DELIMITER ;

DELIMITER $$

CREATE DEFINER=`root`@`127.0.0.1` PROCEDURE `sp_validateLogin`(
IN p_useremail VARCHAR(20)
)
BEGIN
    select * from tbl_user where user_email = p_useremail;
END $$
DELIMITER ;

DELIMITER $$

CREATE DEFINER=`root`@`127.0.0.1` PROCEDURE `sp_GetWishByUser`(
IN p_user_id int(20)
)
BEGIN
    select * from tbl_wish natural join tbl_inventory  where user_id = p_user_id;
END $$
DELIMITER ;


/* Procedure structure for procedure `sp_addWish` */

DROP PROCEDURE IF EXISTS  `sp_addWish`;

DELIMITER $$

CREATE DEFINER=`root`@`127.0.0.1` PROCEDURE `sp_addWish`(
    IN p_itemid int(10),
    IN p_user int(20)
)
BEGIN
    insert into tbl_wish(
        wish_id,
        user_id,
        wish_date,
        item_id
    )
    values
    (
        NULL,
        p_user,
        NOW(),
        p_itemid
    );
END $$
DELIMITER ;












