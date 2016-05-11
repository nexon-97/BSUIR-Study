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
-- Table structure for table `user_social_links`
--

CREATE TABLE IF NOT EXISTS `user_social_links` (
  `user_id` int(10) unsigned NOT NULL,
  `phone` varchar(32) NOT NULL,
  `vk` varchar(128) NOT NULL,
  `twitter` varchar(128) NOT NULL,
  `linkedin` varchar(128) NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `user_social_links`
--

INSERT INTO `user_social_links` (`user_id`, `phone`, `vk`, `twitter`, `linkedin`) VALUES
(1, '+375291901254', 'http://vk.com/id53576025', '', 'https://www.linkedin.com/in/denis-ponyakov-a7aab3b6'),
(2, '+375333040490', 'http://vk.com/id95811438', '', ''),
(3, '+375447108938', '', '', '');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
