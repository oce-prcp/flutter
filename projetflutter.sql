-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : ven. 19 juil. 2024 à 10:28
-- Version du serveur : 8.0.31
-- Version de PHP : 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `projetflutter`
--

-- --------------------------------------------------------

--
-- Structure de la table `loisir`
--

DROP TABLE IF EXISTS `loisir`;
CREATE TABLE IF NOT EXISTS `loisir` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `notation` float NOT NULL,
  `dateSortie` datetime NOT NULL,
  `imagePath` varchar(255) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `typeId` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nom` (`nom`),
  KEY `typeId` (`typeId`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `loisir`
--

INSERT INTO `loisir` (`id`, `nom`, `description`, `notation`, `dateSortie`, `imagePath`, `createdAt`, `updatedAt`, `typeId`) VALUES
(1, '365 Jours', 'Hot, Amour', 4.34, '2011-11-02 12:00:00', 'images/365dni.jpg', '2024-07-17 08:10:30', '2024-07-17 08:10:30', 2),
(2, 'Games of Thrones', 'Actions, Fantastique, Dragon, Guerre', 4.1, '2006-06-14 00:00:00', 'images/got.png', '2024-07-17 08:12:05', '2024-07-17 08:20:01', 2),
(4, 'Harry Potter', 'Sorciers, Jeunesse, Action', 4.2, '2009-12-16 00:00:00', 'images/hp.jpg', '2024-07-17 08:28:17', '2024-07-17 08:28:17', 2),
(8, 'Hunter x Hunter', 'Manga, Combat, Action, Amitié', 4.5, '2009-12-16 00:00:00', 'images/hxh.png', '2024-07-17 10:28:48', '2024-07-17 10:28:48', 1),
(9, 'Jujutsu Kaisen', 'Manga, Action, Combat, Fantastique', 4.5, '2024-07-18 08:01:44', 'images/jjk.png', '2024-07-18 08:01:44', '2024-07-18 08:01:44', 1),
(11, 'Spiderman', 'Action, Marvel, Aventure', 4, '2024-07-18 08:03:45', 'images/spiderman.png', '2021-07-26 08:03:45', '2023-10-13 08:03:45', 2),
(12, 'Squid Game', 'Horreur, Action, Argent', 3, '2024-07-18 08:05:14', 'images/squidgame.jpg', '2022-07-18 08:05:14', '2023-07-18 08:05:14', 2),
(13, 'L\'Attaque des Titans', 'Manga, Action', 5, '2024-07-18 08:38:10', 'images/snk.png', '0000-00-00 00:00:00', '2005-07-05 08:38:10', NULL),
(21, 'vdsgfvs', 'ffez', 5, '2024-07-29 22:00:00', 'images/34.jpg1721384338655.jpg', '2024-07-19 10:18:59', '2024-07-19 10:18:59', 1);

-- --------------------------------------------------------

--
-- Structure de la table `type`
--

DROP TABLE IF EXISTS `type`;
CREATE TABLE IF NOT EXISTS `type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nom` (`nom`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `type`
--

INSERT INTO `type` (`id`, `nom`, `description`, `createdAt`, `updatedAt`) VALUES
(1, 'Manga', 'dessin\r\n', '2024-07-17 08:09:07', '2024-07-17 08:09:07'),
(2, 'Film', 'plein d\'image', '2024-07-17 08:09:18', '2024-07-17 08:09:18'),
(3, 'test', 'test', '2024-07-17 10:43:02', '2024-07-17 10:43:02');

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `loisir`
--
ALTER TABLE `loisir`
  ADD CONSTRAINT `loisir_ibfk_1` FOREIGN KEY (`typeId`) REFERENCES `type` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
