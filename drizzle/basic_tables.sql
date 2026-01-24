-- Basic tables for testing
CREATE TABLE `users` (
	`user_id` bigint AUTO_INCREMENT NOT NULL,
	`email` varchar(255),
	`display_name` varchar(100),
	`user_type` enum('FREE','PAID','ADMIN') DEFAULT 'FREE',
	`is_active` tinyint(1) DEFAULT 1,
	`is_flagged` tinyint(1) DEFAULT 0,
	`flag_reason` varchar(255),
	`admin_notes` text,
	`last_login_at` timestamp,
	`login_count` int DEFAULT 0,
	`created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
	`is_paid` tinyint(1) NOT NULL DEFAULT 0,
	CONSTRAINT `users_user_id` PRIMARY KEY(`user_id`),
	CONSTRAINT `email` UNIQUE(`email`)
);

CREATE TABLE `subjects` (
	`subject_id` int AUTO_INCREMENT NOT NULL,
	`syllabus_id` int NOT NULL,
	`subject_code` varchar(10) NOT NULL,
	`subject_name` varchar(150) NOT NULL,
	`display_order` int,
	`is_active` tinyint(1) DEFAULT 1,
	`created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT `subjects_subject_id` PRIMARY KEY(`subject_id`),
	CONSTRAINT `uq_syllabus_subject` UNIQUE(`syllabus_id`,`subject_code`)
);

CREATE TABLE `topics` (
	`topic_id` int AUTO_INCREMENT NOT NULL,
	`subject_id` int NOT NULL,
	`topic_code` varchar(50) NOT NULL,
	`topic_name` varchar(255) NOT NULL,
	`description` text,
	`display_order` int,
	`is_active` tinyint(1) DEFAULT 1,
	`created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT `topics_topic_id` PRIMARY KEY(`topic_id`),
	CONSTRAINT `uq_subject_topic` UNIQUE(`subject_id`,`topic_code`)
);