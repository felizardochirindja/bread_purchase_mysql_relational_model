-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema cdp
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema cdp
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `cdp` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `cdp` ;

-- -----------------------------------------------------
-- Table `cdp`.`products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cdp`.`products` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `price` DECIMAL(10,2) UNSIGNED NOT NULL,
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME NOT NULL,
  `description` TINYTEXT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cdp`.`monthly_orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cdp`.`monthly_orders` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `product_id` BIGINT UNSIGNED NOT NULL,
  `limit_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `month` TINYINT UNSIGNED NOT NULL,
  `remain` DECIMAL(10,2) UNSIGNED NOT NULL,
  `status` ENUM('overdue', 'pending', 'parcelada', 'paid') NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_order_product_idx` (`product_id` ASC) VISIBLE,
  CONSTRAINT `fk_order_product`
    FOREIGN KEY (`product_id`)
    REFERENCES `cdp`.`products` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cdp`.`payments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cdp`.`payments` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `from` DATETIME NOT NULL,
  `to` DATETIME NOT NULL,
  `total` DECIMAL(10,2) UNSIGNED NOT NULL,
  `paid_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `type` ENUM('periodic', 'daily') NOT NULL,
  `notes` TINYTEXT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cdp`.`daily_orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cdp`.`daily_orders` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `day` TINYINT UNSIGNED NOT NULL,
  `monthly_order_id` BIGINT UNSIGNED NOT NULL,
  `total` DECIMAL(10,2) NOT NULL,
  `quantity` TINYINT NOT NULL,
  `product_price` DECIMAL(10,2) NOT NULL,
  `notes` TINYTEXT NOT NULL,
  `status` ENUM('paid', 'pending', 'overdue') NOT NULL,
  PRIMARY KEY (`id`, `monthly_order_id`),
  INDEX `fk_daily_orders_monthly_orders1_idx` (`monthly_order_id` ASC) VISIBLE,
  CONSTRAINT `fk_daily_orders_monthly_orders1`
    FOREIGN KEY (`monthly_order_id`)
    REFERENCES `cdp`.`monthly_orders` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cdp`.`monthly_order_payments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cdp`.`monthly_order_payments` (
  `monthly_order_id` BIGINT UNSIGNED NOT NULL,
  `payment_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`monthly_order_id`, `payment_id`),
  INDEX `fk_monthly_orders_has_payments_payments1_idx` (`payment_id` ASC) VISIBLE,
  INDEX `fk_monthly_orders_has_payments_monthly_orders1_idx` (`monthly_order_id` ASC) VISIBLE,
  CONSTRAINT `fk_monthly_orders_has_payments_monthly_orders1`
    FOREIGN KEY (`monthly_order_id`)
    REFERENCES `cdp`.`monthly_orders` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_monthly_orders_has_payments_payments1`
    FOREIGN KEY (`payment_id`)
    REFERENCES `cdp`.`payments` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
