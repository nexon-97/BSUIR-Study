-- phpMyAdmin SQL Dump
-- version 4.0.10.14
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: May 11, 2016 at 11:59 PM
-- Server version: 5.5.23
-- PHP Version: 5.3.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `nexonlab`
--

-- --------------------------------------------------------

--
-- Table structure for table `user_profiles`
--

CREATE TABLE IF NOT EXISTS `user_profiles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nickname` tinytext NOT NULL,
  `email` tinytext NOT NULL,
  `password` varchar(32) NOT NULL COMMENT 'MD5 Password Hash',
  `avatar` varchar(128) NOT NULL DEFAULT 'img/avatar/noavatar.png',
  `name` tinytext NOT NULL,
  `surname` tinytext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `user_profiles`
--

INSERT INTO `user_profiles` (`id`, `nickname`, `email`, `password`, `avatar`, `name`, `surname`) VALUES
(1, 'Nexon', 'nexon.97@mail.ru', '3832e04f73acb1d5fe0ca5764bd92500', 'img/avatar/nexon.png', 'Denis', 'Ponyakov'),
(2, 'FireMoon', 'novoai@tut.by', '9c8a1f2f73c460edc9b7b915bc349a52', 'img/avatar/firemoon.png', 'Tanya', 'Solonevich'),
(3, 'DigitalKnight', 'digitalknight@gmail.com', 'f88c965ac81a95f319f90a4e2f54cdd7', 'img/avatar/digitalknight.png', 'Bruce', 'Banner');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
