-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- 主機： 127.0.0.1
-- 產生時間： 2021-09-29 10:54:57
-- 伺服器版本： 8.0.25
-- PHP 版本： 7.4.22

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 資料庫: `miniproject`
--

-- --------------------------------------------------------

--
-- 資料表結構 `follow`
--

CREATE TABLE `follow` (
  `sid` int NOT NULL,
  `pid` int NOT NULL,
  `item_id` varchar(120) COLLATE utf8mb4_general_ci NOT NULL,
  `display` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 傾印資料表的資料 `follow`
--

INSERT INTO `follow` (`sid`, `pid`, `item_id`, `display`, `created_at`) VALUES
(40, 7, 'PD01', 1, '2021-09-22 11:58:12');

-- --------------------------------------------------------

--
-- 資料表結構 `items`
--

CREATE TABLE `items` (
  `sid` int NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL,
  `item_id` varchar(120) COLLATE utf8mb4_general_ci NOT NULL,
  `owner` varchar(120) COLLATE utf8mb4_general_ci NOT NULL,
  `count` decimal(10,0) DEFAULT NULL,
  `price` decimal(10,0) NOT NULL,
  `onsale` tinyint(1) NOT NULL,
  `price2` decimal(10,0) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `des` text COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 傾印資料表的資料 `items`
--

INSERT INTO `items` (`sid`, `name`, `item_id`, `owner`, `count`, `price`, `onsale`, `price2`, `created_at`, `des`) VALUES
(1, '智慧功能錶(藍)', 'SW04', 'Ben', NULL, '80', 1, NULL, '2021-09-21 10:58:13', NULL),
(2, '智慧功能錶(白)', 'SW05', 'Ben', NULL, '75', 1, NULL, '2021-09-21 10:58:13', NULL),
(3, '智慧功能錶(橘)', 'SW06', 'Ben', NULL, '80', 1, NULL, '2021-09-21 10:58:13', NULL),
(4, '二手車(小刮痕)', 'PD03', 'David', NULL, '350', 1, NULL, '2021-09-21 10:58:13', NULL),
(5, '爺爺釀的酒(三瓶一組)', 'FD03', 'Sandy', NULL, '120', 1, NULL, '2021-09-21 10:58:13', NULL),
(6, '自製精緻杯子蛋糕', 'FD02', 'Sandy', NULL, '30', 1, NULL, '2021-09-21 10:58:13', NULL),
(7, '只想有人陪(在線等)', 'ME00', 'Khloe', NULL, '999', 1, NULL, '2021-09-21 10:58:13', NULL),
(8, '智慧功能錶(三支)', 'SW07', 'Ben', NULL, '210', 1, NULL, '2021-09-21 10:58:13', NULL),
(9, '新款智慧功能錶(紅)', 'SW08', 'Ben', NULL, '110', 1, NULL, '2021-09-21 10:58:13', NULL),
(10, '早上吃不完的蛋(還沒涼)', 'FD01', 'Sandy', NULL, '20', 1, NULL, '2021-09-21 10:58:13', NULL),
(11, '不小心多買一台', 'PD02', 'iamrich', NULL, '550', 0, NULL, '2021-09-21 10:58:13', NULL),
(12, '我家空房(今晚)', 'RM01', 'Khloe', NULL, '150', 1, NULL, '2021-09-21 10:58:13', NULL),
(13, '愛瘋15(真的正版)', 'PD04', 'Lauren', NULL, '260', 1, NULL, '2021-09-21 10:58:13', NULL),
(14, '蘋果 (送電腦)', 'PD01', 'Lauren', NULL, '333', 1, NULL, '2021-09-21 10:58:13', NULL),
(15, '新款智慧功能錶(黑)', 'SW01', '巷弄市集', NULL, '105', 0, NULL, '2021-09-21 10:58:13', NULL),
(16, '新款智慧功能錶(綠)', 'SW02', '巷弄市集', NULL, '105', 0, NULL, '2021-09-21 10:58:13', NULL),
(17, '新款智慧功能錶(粉)', 'SW03', '巷弄市集', NULL, '105', 0, NULL, '2021-09-21 10:58:13', NULL);

-- --------------------------------------------------------

--
-- 資料表結構 `member`
--

CREATE TABLE `member` (
  `pid` int NOT NULL,
  `account` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `nickname` varchar(120) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `password` varchar(120) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(120) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `coin` int UNSIGNED NOT NULL DEFAULT '0',
  `vip` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `note` varchar(120) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `enable` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 傾印資料表的資料 `member`
--

INSERT INTO `member` (`pid`, `account`, `nickname`, `password`, `email`, `coin`, `vip`, `created_at`, `note`, `enable`) VALUES
(4, 'member2', '說你好', '$2a$08$OMAMhq/TfjkC9JXvDeVZyeQmcs3Y.4.YV50rKfu5n4pwzyWpffZ.W', '123@yty', 100, 0, '2021-09-20 22:19:08', NULL, 1),
(5, 'member3', '說你好', '$2a$08$lWWg25BAywYghXAY264WnOVQRMNyP0r9lJiTIVcTSsmktvuiEFbUS', 'dsd@ytggg', 100, 0, '2021-09-20 22:21:22', NULL, 1),
(6, 'goog', '5566', '$2a$08$X7la8EsGXDjsVBEFXk7LIeLel4n/7swpcWo3Gf0TA/7QGtWlMmoDa', 'uuuu@rot.com', 100, 0, '2021-09-20 22:28:19', NULL, 1),
(7, 'Lauren', 'Lauren', '$2a$08$tShTrUes2YxevC2Pw6sahOFYxPQhCH.uJbz3mw7UTDrX/QYg4CW3y', 'amtender@here.hi', 334, 0, '2021-09-21 16:50:42', NULL, 1),
(8, 'David', 'David', '$2a$08$MiNaW8fYCz/wnIaG1K7lS.S/uSOQLilC3mgOXTkK4w8Fs91ECtbl.', 'amtender0@here.hi', 1090, 0, '2021-09-21 16:51:48', NULL, 1),
(9, 'Ben', 'Ben', '$2a$08$jNLad5C5dPDePqRerhrKDuISR0PsYLAFu12M6aYKy5p1IGzaN40Yy', 'amtender1@here.hi', 361, 0, '2021-09-21 16:52:27', NULL, 1),
(10, 'Sandy', 'Sandy', '$2a$08$SyxW3WWYX32oWOLi9Zabguah..1gahY5l9TAYKmOSJSZZN.vIQYom', 'amtender2@here.hi', 118, 0, '2021-09-21 16:53:17', NULL, 1),
(11, 'Khloe', 'Khloe', '$2a$08$9GV.H0VG0Rm5KPWkL/Pdn.x5X/0PrJTYnGgP6p.6q6XZSa1KvwuXa', 'amtender4@here.hi', 100, 0, '2021-09-21 16:55:10', NULL, 1),
(12, 'iamrich', '有錢就是大爺', '$2a$08$2LR5MQNUDSOPkptC1/GmmOZEQ17W0/46H1HPb5LF2OQwGyXMSrVz2', 'takemymoney@bank.all', 9219, 0, '2021-09-21 16:56:42', NULL, 1),
(13, 'hello', 'nihao', '$2a$08$JtvF50PSv6bPJfF8.43PmupaodP4hko7k14/.1/sSemVPuwYEQiEC', '123@yty2', 100, 0, '2021-09-22 10:17:49', NULL, 1),
(14, 'test123', '', '$2a$08$PHaOLnOCa4yAHF5k0HFqG.lGGJh2ZWe0A7XMVIqhtPZpbK2XICZWq', 'oi@h', 100, 0, '2021-09-22 11:30:07', NULL, 1),
(15, 'test1234', '', '$2a$08$jNrqnM4MN2ikB5JflxM1L.K7d1K1idtVcfO36H74OfVE0NM8bvvTm', '123@yty6', 100, 0, '2021-09-22 11:49:39', NULL, 1);

-- --------------------------------------------------------

--
-- 資料表結構 `transaction`
--

CREATE TABLE `transaction` (
  `sid` int NOT NULL,
  `item_id` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `seller_id` int NOT NULL,
  `buyer_id` int NOT NULL,
  `price` decimal(10,0) NOT NULL,
  `tax` decimal(10,0) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 傾印資料表的資料 `transaction`
--

INSERT INTO `transaction` (`sid`, `item_id`, `seller_id`, `buyer_id`, `price`, `tax`, `created_at`, `note`) VALUES
(6, 'FD01', 10, 12, '20', '2', '2021-09-22 10:21:28', NULL),
(7, 'SW07', 9, 12, '210', '21', '2021-09-22 11:16:36', NULL),
(8, 'PD02', 8, 12, '550', '55', '2021-09-22 11:53:42', NULL);

--
-- 已傾印資料表的索引
--

--
-- 資料表索引 `follow`
--
ALTER TABLE `follow`
  ADD PRIMARY KEY (`sid`);

--
-- 資料表索引 `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`sid`),
  ADD UNIQUE KEY `item_id` (`item_id`);

--
-- 資料表索引 `member`
--
ALTER TABLE `member`
  ADD PRIMARY KEY (`pid`),
  ADD UNIQUE KEY `name` (`account`),
  ADD UNIQUE KEY `account` (`account`),
  ADD UNIQUE KEY `email` (`email`);

--
-- 資料表索引 `transaction`
--
ALTER TABLE `transaction`
  ADD PRIMARY KEY (`sid`);

--
-- 在傾印的資料表使用自動遞增(AUTO_INCREMENT)
--

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `follow`
--
ALTER TABLE `follow`
  MODIFY `sid` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `items`
--
ALTER TABLE `items`
  MODIFY `sid` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `member`
--
ALTER TABLE `member`
  MODIFY `pid` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `transaction`
--
ALTER TABLE `transaction`
  MODIFY `sid` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
