-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 25, 2024 at 02:36 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `communityhub`
--

-- --------------------------------------------------------

--
-- Table structure for table `address`
--

CREATE TABLE `address` (
  `addressID` int(10) NOT NULL,
  `country` varchar(20) NOT NULL,
  `postalCode` int(8) NOT NULL,
  `street` varchar(50) NOT NULL,
  `city` varchar(50) NOT NULL,
  `state` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `address`
--

INSERT INTO `address` (`addressID`, `country`, `postalCode`, `street`, `city`, `state`) VALUES
(1, 'United States', 12345, '123 Main St', 'Anytown', 'CA'),
(2, 'Canada', 67890, '456 Oak Rd', 'Elsewhere', 'ON'),
(3, 'United Kingdom', 11111, '789 High St', 'Somewhere', 'London'),
(4, 'Australia', 22222, '321 Park Ave', 'Anywhere', 'NSW'),
(5, 'Germany', 33333, '159 Hauptstraße', 'Irgendwo', 'BY');

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `adminID` int(11) NOT NULL,
  `name` varchar(60) NOT NULL,
  `email` varchar(30) NOT NULL,
  `contactInfo` int(12) NOT NULL,
  `image` blob DEFAULT NULL,
  `username` varchar(30) NOT NULL,
  `password` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`adminID`, `name`, `email`, `contactInfo`, `image`, `username`, `password`) VALUES
(1, 'John Doe', 'john.doe@example.com', 1234567890, NULL, 'johndoe', 'pass123'),
(2, 'Jane Smith', 'jane.smith@example.com', 2147483647, NULL, 'janesmith', 'secure456'),
(3, 'Alice Johnson', 'alice.johnson@example.com', 1122334455, NULL, 'alicej', 'mypassword'),
(4, 'Bob Brown', 'bob.brown@example.com', 2147483647, NULL, 'bobb', 'admin2024'),
(5, 'Charlie White', 'charlie.white@example.com', 2147483647, NULL, 'charliew', 'test1234');

-- --------------------------------------------------------

--
-- Table structure for table `beneficiary`
--

CREATE TABLE `beneficiary` (
  `beneficiaryID` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `contactInfo` int(11) NOT NULL,
  `image` blob DEFAULT NULL,
  `username` varchar(30) NOT NULL,
  `password` varchar(20) NOT NULL,
  `addressID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `beneficiary`
--

INSERT INTO `beneficiary` (`beneficiaryID`, `name`, `contactInfo`, `image`, `username`, `password`, `addressID`) VALUES
(1, 'Maria Garcia', 1234567890, NULL, 'mgarcia', 'password123', 1),
(2, 'Amit Singh', 2147483647, NULL, 'asingh', 'secure456', 2),
(3, 'Isabelle Dupont', 2147483647, NULL, 'idupont', 'mypassword', 3);

-- --------------------------------------------------------

--
-- Table structure for table `donation`
--

CREATE TABLE `donation` (
  `donationID` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `date` date NOT NULL,
  `receiptImage` varchar(100) NOT NULL,
  `eventID` int(11) NOT NULL,
  `donorID` int(11) DEFAULT NULL,
  `volunteerID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `donation`
--

INSERT INTO `donation` (`donationID`, `amount`, `date`, `receiptImage`, `eventID`, `donorID`, `volunteerID`) VALUES
(1, 250.00, '2024-03-15', 'receipt1.jpg', 1, 1, 1),
(2, 100.00, '2024-05-01', 'receipt2.jpg', 2, 2, 2),
(3, 500.00, '2024-11-30', 'receipt3.jpg', 3, 3, 3);

-- --------------------------------------------------------

--
-- Table structure for table `donor`
--

CREATE TABLE `donor` (
  `donorID` int(11) NOT NULL,
  `name` varchar(60) DEFAULT NULL,
  `contactInfo` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `donor`
--

INSERT INTO `donor` (`donorID`, `name`, `contactInfo`) VALUES
(1, 'John Smith', 1234567890),
(2, 'Sarah Lee', 2147483647),
(3, 'David Kim', 2147483647);

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

CREATE TABLE `events` (
  `eventID` int(11) NOT NULL,
  `name` varchar(40) NOT NULL,
  `image` blob DEFAULT NULL,
  `date` date NOT NULL,
  `time` time NOT NULL,
  `duration` time NOT NULL,
  `description` varchar(300) DEFAULT NULL,
  `volunteerNeeded` int(11) NOT NULL,
  `status` int(3) NOT NULL,
  `adminID` int(11) DEFAULT NULL,
  `beneficiaryID` int(11) NOT NULL,
  `addressID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `events`
--

INSERT INTO `events` (`eventID`, `name`, `image`, `date`, `time`, `duration`, `description`, `volunteerNeeded`, `status`, `adminID`, `beneficiaryID`, `addressID`) VALUES
(1, 'Charity Gala', NULL, '2024-04-01', '19:00:00', '03:00:00', 'Annual fundraising event', 50, 1, NULL, 1, 1),
(2, 'Beach Cleanup', NULL, '2024-06-15', '10:00:00', '02:00:00', 'Community volunteer event', 25, 2, 2, 2, 2),
(3, 'Holiday Toy Drive', NULL, '2024-12-20', '14:00:00', '04:00:00', 'Collecting toys for children in need', 75, 3, 3, 3, 3);

-- --------------------------------------------------------

--
-- Table structure for table `eventsvolunteer`
--

CREATE TABLE `eventsvolunteer` (
  `eventsVolunteerID` int(11) NOT NULL,
  `eventID` int(11) NOT NULL,
  `volunteerID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `eventsvolunteer`
--

INSERT INTO `eventsvolunteer` (`eventsVolunteerID`, `eventID`, `volunteerID`) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 2, 1),
(4, 2, 3),
(5, 3, 2),
(6, 3, 3);

-- --------------------------------------------------------

--
-- Table structure for table `task`
--

CREATE TABLE `task` (
  `taskID` int(11) NOT NULL,
  `status` tinyint(1) NOT NULL,
  `description` varchar(200) DEFAULT NULL,
  `eventID` int(11) NOT NULL,
  `volunteerID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `task`
--

INSERT INTO `task` (`taskID`, `status`, `description`, `eventID`, `volunteerID`) VALUES
(1, 0, 'Set up registration table', 1, 1),
(2, 0, 'Clean up event space', 2, 2),
(3, 0, 'Sort and pack toys', 3, 3);

-- --------------------------------------------------------

--
-- Table structure for table `volunteer`
--

CREATE TABLE `volunteer` (
  `volunteerID` int(11) NOT NULL,
  `name` varchar(60) NOT NULL,
  `contactInfo` int(13) NOT NULL,
  `image` blob DEFAULT NULL,
  `username` varchar(30) NOT NULL,
  `password` varchar(20) NOT NULL,
  `addressID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `volunteer`
--

INSERT INTO `volunteer` (`volunteerID`, `name`, `contactInfo`, `image`, `username`, `password`, `addressID`) VALUES
(1, 'Emily Wilson', 1234567890, NULL, 'ewilson', 'volunteer123', 1),
(2, 'Michael Chen', 2147483647, NULL, 'mchen', 'helper456', 2),
(3, 'Sophia Martinez', 2147483647, NULL, 'smartinez', 'volunteer2024', 3);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `address`
--
ALTER TABLE `address`
  ADD PRIMARY KEY (`addressID`) USING BTREE;

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`adminID`);

--
-- Indexes for table `beneficiary`
--
ALTER TABLE `beneficiary`
  ADD PRIMARY KEY (`beneficiaryID`),
  ADD KEY `FK_beneficiaryAddress` (`addressID`);

--
-- Indexes for table `donation`
--
ALTER TABLE `donation`
  ADD PRIMARY KEY (`donationID`),
  ADD KEY `FK_donationEvent` (`eventID`),
  ADD KEY `FK_donationDonor` (`donorID`),
  ADD KEY `FK_donationVolunteer` (`volunteerID`);

--
-- Indexes for table `donor`
--
ALTER TABLE `donor`
  ADD PRIMARY KEY (`donorID`);

--
-- Indexes for table `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`eventID`),
  ADD KEY `FK_eventAddress` (`addressID`),
  ADD KEY `FK_eventAdmin` (`adminID`),
  ADD KEY `FK_eventBeneficiary` (`beneficiaryID`);

--
-- Indexes for table `eventsvolunteer`
--
ALTER TABLE `eventsvolunteer`
  ADD PRIMARY KEY (`eventsVolunteerID`),
  ADD KEY `FK_eventVolunteerEvent` (`eventID`),
  ADD KEY `FK_eventVolunteerVolunteer` (`volunteerID`);

--
-- Indexes for table `task`
--
ALTER TABLE `task`
  ADD PRIMARY KEY (`taskID`),
  ADD KEY `FK_taskEvent` (`eventID`),
  ADD KEY `FK_taskVolunteer` (`volunteerID`);

--
-- Indexes for table `volunteer`
--
ALTER TABLE `volunteer`
  ADD PRIMARY KEY (`volunteerID`),
  ADD KEY `FK_volunteerAddress` (`addressID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `address`
--
ALTER TABLE `address`
  MODIFY `addressID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `adminID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `beneficiary`
--
ALTER TABLE `beneficiary`
  MODIFY `beneficiaryID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `donation`
--
ALTER TABLE `donation`
  MODIFY `donationID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `donor`
--
ALTER TABLE `donor`
  MODIFY `donorID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `eventID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `eventsvolunteer`
--
ALTER TABLE `eventsvolunteer`
  MODIFY `eventsVolunteerID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `task`
--
ALTER TABLE `task`
  MODIFY `taskID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `volunteer`
--
ALTER TABLE `volunteer`
  MODIFY `volunteerID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `beneficiary`
--
ALTER TABLE `beneficiary`
  ADD CONSTRAINT `FK_beneficiaryAddress` FOREIGN KEY (`addressID`) REFERENCES `address` (`addressID`);

--
-- Constraints for table `donation`
--
ALTER TABLE `donation`
  ADD CONSTRAINT `FK_donationDonor` FOREIGN KEY (`donorID`) REFERENCES `donor` (`donorID`),
  ADD CONSTRAINT `FK_donationEvent` FOREIGN KEY (`eventID`) REFERENCES `events` (`eventID`),
  ADD CONSTRAINT `FK_donationVolunteer` FOREIGN KEY (`volunteerID`) REFERENCES `volunteer` (`volunteerID`);

--
-- Constraints for table `events`
--
ALTER TABLE `events`
  ADD CONSTRAINT `FK_eventAddress` FOREIGN KEY (`addressID`) REFERENCES `address` (`addressID`),
  ADD CONSTRAINT `FK_eventAdmin` FOREIGN KEY (`adminID`) REFERENCES `admin` (`adminID`),
  ADD CONSTRAINT `FK_eventBeneficiary` FOREIGN KEY (`beneficiaryID`) REFERENCES `beneficiary` (`beneficiaryID`);

--
-- Constraints for table `eventsvolunteer`
--
ALTER TABLE `eventsvolunteer`
  ADD CONSTRAINT `FK_eventVolunteerEvent` FOREIGN KEY (`eventID`) REFERENCES `events` (`eventID`),
  ADD CONSTRAINT `FK_eventVolunteerVolunteer` FOREIGN KEY (`volunteerID`) REFERENCES `volunteer` (`volunteerID`);

--
-- Constraints for table `task`
--
ALTER TABLE `task`
  ADD CONSTRAINT `FK_taskEvent` FOREIGN KEY (`eventID`) REFERENCES `events` (`eventID`),
  ADD CONSTRAINT `FK_taskVolunteer` FOREIGN KEY (`volunteerID`) REFERENCES `volunteer` (`volunteerID`);

--
-- Constraints for table `volunteer`
--
ALTER TABLE `volunteer`
  ADD CONSTRAINT `FK_volunteerAddress` FOREIGN KEY (`addressID`) REFERENCES `address` (`addressID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
