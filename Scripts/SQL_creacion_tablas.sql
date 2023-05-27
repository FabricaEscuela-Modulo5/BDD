-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`programa_academico`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`programa_academico`;
CREATE TABLE IF NOT EXISTS `mydb`.`programa_academico` (
  `codigo_programa` INT NOT NULL,
  `nombre_programa` VARCHAR(100) NOT NULL,
  `duracion` INT NOT NULL,
  `vigencia` DATETIME NOT NULL,
  PRIMARY KEY (`codigo_programa`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`estado_solicitud`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`estado_solicitud`;
CREATE TABLE IF NOT EXISTS `mydb`.`estado_solicitud` (
  `id_estado_solicitud` INT NOT NULL,
  `estado_solicitud` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id_estado_solicitud`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`solicitud_homologacion`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`solicitud_homologacion`;
CREATE TABLE IF NOT EXISTS `mydb`.`solicitud_homologacion` (
  `id_solicitud` INT NOT NULL AUTO_INCREMENT,
  `estado_solicitud` INT NOT NULL,
  `codigo_programa` INT NOT NULL,
  `fecha_solicitud` DATE NOT NULL,
  `comentario` VARCHAR(500) NOT NULL,
  PRIMARY KEY (`id_solicitud`),
  INDEX `fk_solicitud_homologacion_programa_academico1_idx` (`codigo_programa` ASC) VISIBLE,
  INDEX `fk_solicitud_homologacion_estado_solicitud1_idx` (`estado_solicitud` ASC) VISIBLE,
  CONSTRAINT `fk_solicitud_homologacion_programa_academico1`
    FOREIGN KEY (`codigo_programa`)
    REFERENCES `mydb`.`programa_academico` (`codigo_programa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_solicitud_homologacion_estado_solicitud1`
    FOREIGN KEY (`estado_solicitud`)
    REFERENCES `mydb`.`estado_solicitud` (`id_estado_solicitud`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`materia`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`materia`;
CREATE TABLE IF NOT EXISTS `mydb`.`materia` (
  `codigo_materia` INT NOT NULL AUTO_INCREMENT,
  `nombre_materia` VARCHAR(50) NOT NULL,
  `creditos` INT NOT NULL,
  PRIMARY KEY (`codigo_materia`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`plan_estudios`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`plan_estudios`;
CREATE TABLE IF NOT EXISTS `mydb`.`plan_estudios` (
  `version` VARCHAR(3) NOT NULL,
  `codigo_programa` INT NOT NULL,
  `fecha_aprobacion` DATETIME NOT NULL,
  PRIMARY KEY (`version`, `codigo_programa`),
  INDEX `fk_plan_estudios_programa_academico1_idx` (`codigo_programa` ASC) VISIBLE,
  CONSTRAINT `fk_plan_estudios_programa_academico1`
    FOREIGN KEY (`codigo_programa`)
    REFERENCES `mydb`.`programa_academico` (`codigo_programa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`estudiante`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`estudiante`;
CREATE TABLE IF NOT EXISTS `mydb`.`estudiante` (
  `cedula` VARCHAR(12) NOT NULL,
  `nombre` VARCHAR(50) NOT NULL,
  `apellido` VARCHAR(50) NOT NULL,
  `correo_institucional` VARCHAR(100) NOT NULL,
  `correo_personal` VARCHAR(100) NOT NULL,
  `celular` VARCHAR(30) NULL,
  `estrato` INT NOT NULL,
  `fecha_ingreso` DATETIME NOT NULL,
  `version` VARCHAR(3) NOT NULL,
  `codigo_programa` INT NOT NULL,
  PRIMARY KEY (`cedula`),
  INDEX `fk_estudainte_plan_estudios1_idx` (`version` ASC) VISIBLE,
  INDEX `fk_estudiante_programa_academico1_idx` (`codigo_programa` ASC) VISIBLE,
  CONSTRAINT `fk_estudainte_plan_estudios1`
    FOREIGN KEY (`version`)
    REFERENCES `mydb`.`plan_estudios` (`version`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_estudiante_programa_academico1`
    FOREIGN KEY (`codigo_programa`)
    REFERENCES `mydb`.`programa_academico` (`codigo_programa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`materia_solicitud`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`materia_solicitud`;
CREATE TABLE IF NOT EXISTS `mydb`.`materia_solicitud` (
  `id_solicitud` INT NOT NULL,
  `codigo_materia` INT NOT NULL,
  `id_semestre_pasada` INT NOT NULL,
  `nota_definitiva` DECIMAL(2) NOT NULL,
  `cedula_estudiante` VARCHAR(12) NOT NULL,
  PRIMARY KEY (`id_solicitud`),
  INDEX `fk_materia_solicitud_materia1_idx` (`codigo_materia` ASC) VISIBLE,
  INDEX `fk_materia_solicitud_estudiante1_idx` (`cedula_estudiante` ASC) VISIBLE,
  CONSTRAINT `fk_materia_solicitud_solicitudes_homologaciones`
    FOREIGN KEY (`id_solicitud`)
    REFERENCES `mydb`.`solicitud_homologacion` (`id_solicitud`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_materia_solicitud_materia1`
    FOREIGN KEY (`codigo_materia`)
    REFERENCES `mydb`.`materia` (`codigo_materia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_materia_solicitud_estudiante1`
    FOREIGN KEY (`cedula_estudiante`)
    REFERENCES `mydb`.`estudiante` (`cedula`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`relacion`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`relacion`;
CREATE TABLE IF NOT EXISTS `mydb`.`relacion` (
  `codigo_materia` INT NOT NULL,
  `codigo_materia_relacionada` INT NOT NULL,
  `tipo_relacion` VARCHAR(15) NOT NULL,
  INDEX `fk_correquisito_materia1_idx` (`codigo_materia` ASC) VISIBLE,
  INDEX `fk_correquisito_materia2_idx` (`codigo_materia_relacionada` ASC) VISIBLE,
  PRIMARY KEY (`codigo_materia`, `codigo_materia_relacionada`),
  CONSTRAINT `fk_correquisito_materia1`
    FOREIGN KEY (`codigo_materia`)
    REFERENCES `mydb`.`materia` (`codigo_materia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_correquisito_materia2`
    FOREIGN KEY (`codigo_materia_relacionada`)
    REFERENCES `mydb`.`materia` (`codigo_materia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`tipo_semestre`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`tipo_semestre`;
CREATE TABLE IF NOT EXISTS `mydb`.`tipo_semestre` (
  `id_tipo_semestre` INT NOT NULL,
  `tipo_semestre` VARCHAR(50) NULL,
  PRIMARY KEY (`id_tipo_semestre`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`estado_semestre`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`estado_semestre`;
CREATE TABLE IF NOT EXISTS `mydb`.`estado_semestre` (
  `id_estado_semestre` INT NOT NULL,
  `estado_semestre` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id_estado_semestre`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`semestre`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`semestre`;
CREATE TABLE IF NOT EXISTS `mydb`.`semestre` (
  `id_semestre` INT NOT NULL,
  `fecha_inicio` DATETIME NOT NULL,
  `fecha_terminacion` DATETIME NOT NULL,
  `tipo_semestre` INT NOT NULL,
  `estado_semestre` INT NOT NULL,
  PRIMARY KEY (`id_semestre`),
  INDEX `fk_semestre_tipo_semestre1_idx` (`tipo_semestre` ASC) VISIBLE,
  INDEX `fk_semestre_estado_semestre1_idx` (`estado_semestre` ASC) VISIBLE,
  CONSTRAINT `fk_semestre_tipo_semestre1`
    FOREIGN KEY (`tipo_semestre`)
    REFERENCES `mydb`.`tipo_semestre` (`id_tipo_semestre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_semestre_estado_semestre1`
    FOREIGN KEY (`estado_semestre`)
    REFERENCES `mydb`.`estado_semestre` (`id_estado_semestre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`tercio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`tercio`;
CREATE TABLE IF NOT EXISTS `mydb`.`tercio` (
  `id_tercio` INT NOT NULL,
  `tercio` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id_tercio`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`situacion_academia`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`situacion_academica`;
CREATE TABLE IF NOT EXISTS `mydb`.`situacion_academia` (
  `id_situacion_academica` INT NOT NULL,
  `situacion_academica` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id_situacion_academica`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`historia_academica`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`historia_academica`;
CREATE TABLE IF NOT EXISTS `mydb`.`historia_academica` (
  `id_historia_academica` INT NOT NULL AUTO_INCREMENT,
  `cedula_estudiante` VARCHAR(12) NOT NULL,
  `id_semestre` INT NOT NULL,
  `promedio_acumulado` DECIMAL(2) NOT NULL,
  `promedio_semestre` DECIMAL(2) NOT NULL,
  `id_tercio` INT NOT NULL,
  `situacion_academica` INT NOT NULL,
  PRIMARY KEY (`id_historia_academica`),
  INDEX `fk_historia_academica_estudiante1_idx` (`cedula_estudiante` ASC) VISIBLE,
  INDEX `fk_historia_academica_semestre1_idx` (`id_semestre` ASC) VISIBLE,
  INDEX `fk_historia_academica_tercio1_idx` (`id_tercio` ASC) VISIBLE,
  INDEX `fk_historia_academica_situacion_academia1_idx` (`situacion_academica` ASC) VISIBLE,
  CONSTRAINT `fk_historia_academica_estudiante1`
    FOREIGN KEY (`cedula_estudiante`)
    REFERENCES `mydb`.`estudiante` (`cedula`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_historia_academica_semestre1`
    FOREIGN KEY (`id_semestre`)
    REFERENCES `mydb`.`semestre` (`id_semestre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_historia_academica_tercio1`
    FOREIGN KEY (`id_tercio`)
    REFERENCES `mydb`.`tercio` (`id_tercio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_historia_academica_situacion_academia1`
    FOREIGN KEY (`situacion_academica`)
    REFERENCES `mydb`.`situacion_academia` (`id_situacion_academica`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`materia_semestre`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`materia_semestre`;
CREATE TABLE IF NOT EXISTS `mydb`.`materia_semestre` (
  `id_materia_semestre` INT NOT NULL AUTO_INCREMENT,
  `cedula_estudiante` VARCHAR(12) NOT NULL,
  `id_semestre` INT NOT NULL,
  `codigo_materia` INT NOT NULL,
  `nota_definitiva` DECIMAL(2) NOT NULL,
  PRIMARY KEY (`id_materia_semestre`),
  INDEX `fk_materia_semestre_semestre1_idx` (`id_semestre` ASC) VISIBLE,
  INDEX `fk_materia_semestre_materia1_idx` (`codigo_materia` ASC) VISIBLE,
  INDEX `fk_materia_semestre_estudiante1_idx` (`cedula_estudiante` ASC) VISIBLE,
  CONSTRAINT `fk_materia_semestre_estudiante1`
    FOREIGN KEY (`cedula_estudiante`)
    REFERENCES `mydb`.`estudiante` (`cedula`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_materia_semestre_semestre1`
    FOREIGN KEY (`id_semestre`)
    REFERENCES `mydb`.`semestre` (`id_semestre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_materia_semestre_materia1`
    FOREIGN KEY (`codigo_materia`)
    REFERENCES `mydb`.`materia` (`codigo_materia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
