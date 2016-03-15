-- phpMyAdmin SQL Dump
-- version 4.0.10.14
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Mar 15, 2016 at 05:45 AM
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
-- Table structure for table `blog_entries`
--

CREATE TABLE IF NOT EXISTS `blog_entries` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category` int(11) NOT NULL,
  `title` tinytext CHARACTER SET utf8 NOT NULL,
  `description` text CHARACTER SET utf8 NOT NULL,
  `full_text` mediumtext CHARACTER SET utf8 NOT NULL,
  `title_hash` int(11) NOT NULL,
  `image` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT 'img/noimage.jpg',
  `creation_date` date NOT NULL,
  `author` int(11) NOT NULL,
  PRIMARY KEY (`title_hash`),
  KEY `id` (`id`),
  KEY `category` (`category`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=4 ;

--
-- Dumping data for table `blog_entries`
--

INSERT INTO `blog_entries` (`id`, `category`, `title`, `description`, `full_text`, `title_hash`, `image`, `creation_date`, `author`) VALUES
(1, 2, 'Custom SoundNode for Multiplayer in UE4 ', 'Ever since the first public release of Unreal Engine 4 I''ve been using a neat little custom SoundNode that makes life easier for audio designers when dealing with mono/stereo sound playback in (networked) games. The node originates from the official ShooterGame sample content available on the Learn-tab of the UE4 launcher. I''ve used it in several others projects too including Switch and the SurvivalGame sample project.', 'Full text (will be later)', 11111, 'img/cpp_post1.jpg', '2016-01-12', 2),
(2, 2, 'Building Shooter AI in Unreal Engine 4', 'You may have seen my earlier blog post about a 4-player coop game I''m working on inside of Unreal Engine 4. It had the first iteration on ranged combat AI and they proved to be a formidable enemy. The problem was they got stale pretty quick, with simplistic and predictable behaviors. The new AI improvements are a first step at addressing this issue.', 'Full entry text', 11112, 'img/cpp_post2.jpg', '2016-03-05', 1),
(3, 1, 'Multi-color Outline Post Process in Unreal Engine 4', 'With some of the recent changes to Unreal Engine 4, rendering multi-color outlines is now possible! This is done through the use of Custom Stencil, a new buffer similar to Custom Depth - but allowing meshes to render as integer values. This provides us with a 1-255 range of indices that can be used to apply different outline colors to meshes and even combine multiple features such as the decal x-ray shown below by using a different stencil index.', 'Full text', 122146, 'img/post4.jpg', '2016-03-05', 1);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
