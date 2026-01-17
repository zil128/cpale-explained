-- Current sql file was generated after introspecting the database
-- If you want to run this migration please uncomment this code before executing migrations
/*
CREATE TABLE `attempt_answers` (
	`attempt_answer_id` bigint AUTO_INCREMENT NOT NULL,
	`attempt_id` bigint NOT NULL,
	`question_id` bigint NOT NULL,
	`choice_id` bigint NOT NULL,
	`is_correct` tinyint(1) NOT NULL,
	`time_spent_seconds` int DEFAULT 0,
	`is_marked_for_review` tinyint(1) DEFAULT 0,
	`confidence_level` enum('GUESSED','UNSURE','CONFIDENT'),
	`attempt_count` int DEFAULT 1,
	`first_attempt_correct` tinyint(1),
	`answered_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
	`question_started_at` timestamp,
	CONSTRAINT `attempt_answers_attempt_answer_id` PRIMARY KEY(`attempt_answer_id`),
	CONSTRAINT `uq_attempt_question` UNIQUE(`attempt_id`,`question_id`)
);
--> statement-breakpoint
CREATE TABLE `email_campaign_sends` (
	`send_id` bigint AUTO_INCREMENT NOT NULL,
	`campaign_id` bigint NOT NULL,
	`subscriber_id` bigint NOT NULL,
	`sent_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
	`delivered_at` timestamp,
	`opened_at` timestamp,
	`clicked_at` timestamp,
	`bounced_at` timestamp,
	`bounce_reason` varchar(255),
	`unsubscribed_at` timestamp,
	`open_count` int DEFAULT 0,
	`click_count` int DEFAULT 0,
	CONSTRAINT `email_campaign_sends_send_id` PRIMARY KEY(`send_id`)
);
--> statement-breakpoint
CREATE TABLE `email_campaigns` (
	`campaign_id` bigint AUTO_INCREMENT NOT NULL,
	`campaign_name` varchar(255) NOT NULL,
	`campaign_type` enum('WELCOME','NURTURE','PROMOTIONAL','TRANSACTIONAL','ANNOUNCEMENT') NOT NULL,
	`subject_line` varchar(255) NOT NULL,
	`preview_text` varchar(150),
	`email_body_html` text NOT NULL,
	`email_body_text` text,
	`sender_name` varchar(100) DEFAULT 'CPALE Explained',
	`sender_email` varchar(255) DEFAULT 'hello@cpaleexplained.com',
	`target_segment` enum('ALL','FREE_USERS','TRIAL_USERS','PAID_USERS','CHURNED_USERS') DEFAULT 'ALL',
	`scheduled_at` timestamp,
	`sent_at` timestamp,
	`total_sent` int DEFAULT 0,
	`total_delivered` int DEFAULT 0,
	`total_opened` int DEFAULT 0,
	`total_clicked` int DEFAULT 0,
	`total_bounced` int DEFAULT 0,
	`total_unsubscribed` int DEFAULT 0,
	`is_draft` tinyint(1) DEFAULT 1,
	`is_active` tinyint(1) DEFAULT 1,
	`created_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
	`updated_at` timestamp DEFAULT (CURRENT_TIMESTAMP) ON UPDATE CURRENT_TIMESTAMP,
	CONSTRAINT `email_campaigns_campaign_id` PRIMARY KEY(`campaign_id`)
);
--> statement-breakpoint
CREATE TABLE `email_subscribers` (
	`subscriber_id` bigint AUTO_INCREMENT NOT NULL,
	`email` varchar(255) NOT NULL,
	`user_id` bigint,
	`first_name` varchar(100),
	`source` varchar(50) NOT NULL,
	`utm_source` varchar(100),
	`utm_campaign` varchar(100),
	`subscribed_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
	`is_verified` tinyint(1) DEFAULT 0,
	`verification_token` varchar(100),
	`verified_at` timestamp,
	`unsubscribed_at` timestamp,
	`unsubscribe_reason` text,
	CONSTRAINT `email_subscribers_subscriber_id` PRIMARY KEY(`subscriber_id`),
	CONSTRAINT `email` UNIQUE(`email`)
);
--> statement-breakpoint
CREATE TABLE `exam_attempt_analytics` (
	`analytics_id` bigint AUTO_INCREMENT NOT NULL,
	`attempt_id` bigint NOT NULL,
	`weak_topic_id` int,
	`incorrect_count` int DEFAULT 0,
	`created_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
	CONSTRAINT `exam_attempt_analytics_analytics_id` PRIMARY KEY(`analytics_id`)
);
--> statement-breakpoint
CREATE TABLE `exam_attempt_questions` (
	`attempt_question_id` bigint AUTO_INCREMENT NOT NULL,
	`attempt_id` bigint NOT NULL,
	`question_id` bigint NOT NULL,
	`question_order` int NOT NULL,
	CONSTRAINT `exam_attempt_questions_attempt_question_id` PRIMARY KEY(`attempt_question_id`),
	CONSTRAINT `attempt_id` UNIQUE(`attempt_id`,`question_id`)
);
--> statement-breakpoint
CREATE TABLE `exam_attempts` (
	`attempt_id` bigint AUTO_INCREMENT NOT NULL,
	`user_id` bigint NOT NULL,
	`practice_set_id` int NOT NULL,
	`attempt_type` enum('PRACTICE','FINAL') NOT NULL,
	`total_questions` int NOT NULL DEFAULT 0,
	`correct_answers` int NOT NULL DEFAULT 0,
	`started_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
	`completed_at` timestamp,
	`time_spent_seconds` int,
	`is_completed` tinyint(1) DEFAULT 0,
	`created_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
	`submitted_at` timestamp,
	`score_percent` decimal(5,2) NOT NULL DEFAULT '0.00',
	`is_submitted` tinyint(1) DEFAULT 0,
	`time_limit_minutes` int,
	`auto_submitted` tinyint(1) DEFAULT 0,
	`show_answers` tinyint(1) DEFAULT 1,
	`show_explanations` tinyint(1) DEFAULT 1,
	`subject_id` int,
	`exam_version_id` int NOT NULL,
	`is_valid` tinyint(1) DEFAULT 1,
	`client_fingerprint` varchar(255),
	`ip_address` varchar(45),
	CONSTRAINT `exam_attempts_attempt_id` PRIMARY KEY(`attempt_id`),
	CONSTRAINT `uq_final_once_per_subject_version` UNIQUE(`user_id`,`subject_id`,`exam_version_id`,`is_valid`),
	CONSTRAINT `uq_final_once_per_version` UNIQUE(`user_id`,`subject_id`,`exam_version_id`,`is_valid`)
);
--> statement-breakpoint
CREATE TABLE `exam_attempts_archive` (
	`archive_id` bigint AUTO_INCREMENT NOT NULL,
	`attempt_id` bigint NOT NULL,
	`user_id` bigint NOT NULL,
	`practice_set_id` int NOT NULL,
	`attempt_type` enum('PRACTICE','FINAL') NOT NULL,
	`total_questions` int NOT NULL DEFAULT 0,
	`correct_answers` int NOT NULL DEFAULT 0,
	`started_at` timestamp,
	`completed_at` timestamp,
	`time_spent_seconds` int,
	`is_completed` tinyint(1) DEFAULT 0,
	`created_at` timestamp,
	`submitted_at` timestamp,
	`score_percent` decimal(5,2) NOT NULL DEFAULT '0.00',
	`is_submitted` tinyint(1) DEFAULT 0,
	`time_limit_minutes` int,
	`auto_submitted` tinyint(1) DEFAULT 0,
	`show_answers` tinyint(1) DEFAULT 1,
	`show_explanations` tinyint(1) DEFAULT 1,
	`subject_id` int,
	`exam_version_id` int NOT NULL,
	`client_fingerprint` varchar(255),
	`ip_address` varchar(45),
	`archived_reason` varchar(255) NOT NULL,
	`archived_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
	`archived_by` varchar(50) DEFAULT 'SYSTEM',
	CONSTRAINT `exam_attempts_archive_archive_id` PRIMARY KEY(`archive_id`)
);
--> statement-breakpoint
CREATE TABLE `exam_audit_logs` (
	`audit_id` bigint AUTO_INCREMENT NOT NULL,
	`attempt_id` bigint,
	`event_type` varchar(50),
	`event_time` datetime DEFAULT (CURRENT_TIMESTAMP),
	`event_data` text,
	CONSTRAINT `exam_audit_logs_audit_id` PRIMARY KEY(`audit_id`)
);
--> statement-breakpoint
CREATE TABLE `exam_session_cache` (
	`session_id` bigint AUTO_INCREMENT NOT NULL,
	`attempt_id` bigint NOT NULL,
	`cached_answers` json NOT NULL,
	`last_saved_at` datetime DEFAULT (CURRENT_TIMESTAMP),
	CONSTRAINT `exam_session_cache_session_id` PRIMARY KEY(`session_id`)
);
--> statement-breakpoint
CREATE TABLE `exam_user_analytics` (
	`analytics_id` bigint AUTO_INCREMENT NOT NULL,
	`user_id` bigint NOT NULL,
	`subject_id` int NOT NULL,
	`attempt_type` enum('PRACTICE','FINAL') NOT NULL,
	`exam_version_id` int NOT NULL,
	`total_attempts` int NOT NULL DEFAULT 0,
	`avg_score` decimal(5,2) NOT NULL DEFAULT '0.00',
	`best_score` decimal(5,2) NOT NULL DEFAULT '0.00',
	`last_attempt_at` datetime,
	`created_at` datetime DEFAULT (CURRENT_TIMESTAMP),
	`updated_at` datetime DEFAULT (CURRENT_TIMESTAMP),
	CONSTRAINT `exam_user_analytics_analytics_id` PRIMARY KEY(`analytics_id`),
	CONSTRAINT `uq_user_subject_version` UNIQUE(`user_id`,`subject_id`,`attempt_type`,`exam_version_id`)
);
--> statement-breakpoint
CREATE TABLE `exam_version_analytics` (
	`analytics_id` bigint AUTO_INCREMENT NOT NULL,
	`user_id` bigint NOT NULL,
	`exam_version_id` int NOT NULL,
	`total_attempts` int DEFAULT 0,
	`best_score` decimal(5,2) DEFAULT '0.00',
	`latest_score` decimal(5,2) DEFAULT '0.00',
	`created_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
	`updated_at` timestamp DEFAULT (CURRENT_TIMESTAMP) ON UPDATE CURRENT_TIMESTAMP,
	CONSTRAINT `exam_version_analytics_analytics_id` PRIMARY KEY(`analytics_id`),
	CONSTRAINT `uq_user_version` UNIQUE(`user_id`,`exam_version_id`)
);
--> statement-breakpoint
CREATE TABLE `exam_version_unlock_rules` (
	`rule_id` bigint AUTO_INCREMENT NOT NULL,
	`subject_id` int NOT NULL,
	`attempt_type` enum('PRACTICE','FINAL') NOT NULL,
	`exam_version_id` int NOT NULL,
	`unlock_type` enum('AFTER_DAYS','AFTER_VERSION','AFTER_SCORE','MANUAL') NOT NULL,
	`unlock_value` int,
	`created_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
	CONSTRAINT `exam_version_unlock_rules_rule_id` PRIMARY KEY(`rule_id`)
);
--> statement-breakpoint
CREATE TABLE `exam_version_unlocks` (
	`unlock_id` int AUTO_INCREMENT NOT NULL,
	`from_version_id` int NOT NULL,
	`to_version_id` int NOT NULL,
	`min_score` decimal(5,2) NOT NULL,
	`created_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
	CONSTRAINT `exam_version_unlocks_unlock_id` PRIMARY KEY(`unlock_id`)
);
--> statement-breakpoint
CREATE TABLE `exam_version_user_progress` (
	`progress_id` bigint AUTO_INCREMENT NOT NULL,
	`user_id` bigint NOT NULL,
	`subject_id` int NOT NULL,
	`attempt_type` enum('PRACTICE','FINAL') NOT NULL,
	`exam_version_id` int NOT NULL,
	`unlocked_at` datetime NOT NULL DEFAULT (CURRENT_TIMESTAMP),
	`unlocked_by` enum('SYSTEM','ADMIN') NOT NULL DEFAULT 'SYSTEM',
	`is_current` tinyint(1) NOT NULL DEFAULT 1,
	`created_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
	CONSTRAINT `exam_version_user_progress_progress_id` PRIMARY KEY(`progress_id`),
	CONSTRAINT `uq_user_current_version` UNIQUE(`user_id`,`subject_id`,`attempt_type`,`is_current`)
);
--> statement-breakpoint
CREATE TABLE `exam_versions` (
	`exam_version_id` int AUTO_INCREMENT NOT NULL,
	`subject_id` int NOT NULL,
	`attempt_type` enum('PRACTICE','FINAL') NOT NULL,
	`version_no` int NOT NULL,
	`version_label` varchar(50),
	`is_active` tinyint(1) DEFAULT 1,
	`released_at` datetime NOT NULL DEFAULT (CURRENT_TIMESTAMP),
	`retired_at` date,
	`created_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
	CONSTRAINT `exam_versions_exam_version_id` PRIMARY KEY(`exam_version_id`),
	CONSTRAINT `uq_subject_version` UNIQUE(`subject_id`,`attempt_type`,`version_no`)
);
--> statement-breakpoint
CREATE TABLE `mock_preboard_exams` (
	`exam_id` bigint AUTO_INCREMENT NOT NULL,
	`subject_id` int NOT NULL,
	`exam_name` varchar(100) NOT NULL,
	`exam_description` text,
	`total_questions` int DEFAULT 100,
	`time_limit_minutes` int DEFAULT 180,
	`passing_score_percent` decimal(5,2) DEFAULT '75.00',
	`access_level` enum('ADVANCE') DEFAULT 'ADVANCE',
	`is_active` tinyint(1) DEFAULT 1,
	`created_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
	CONSTRAINT `mock_preboard_exams_exam_id` PRIMARY KEY(`exam_id`)
);
--> statement-breakpoint
CREATE TABLE `payment_provider_configs` (
	`provider_id` int AUTO_INCREMENT NOT NULL,
	`provider_code` enum('GCASH','PAYMAYA','BANK_TRANSFER','PAYPAL','STRIPE') NOT NULL,
	`provider_name` varchar(50) NOT NULL,
	`is_active` tinyint(1) DEFAULT 1,
	`display_order` int DEFAULT 0,
	`config` json,
	`instructions` text,
	`icon_url` varchar(255),
	`created_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
	CONSTRAINT `payment_provider_configs_provider_id` PRIMARY KEY(`provider_id`),
	CONSTRAINT `provider_code` UNIQUE(`provider_code`)
);
--> statement-breakpoint
CREATE TABLE `payment_transactions` (
	`payment_id` bigint AUTO_INCREMENT NOT NULL,
	`user_id` bigint NOT NULL,
	`subscription_id` bigint,
	`amount` decimal(10,2) NOT NULL,
	`currency` varchar(10) DEFAULT 'PHP',
	`payment_method` enum('GCASH','PAYMAYA','CARD','PAYPAL') NOT NULL,
	`payment_status` enum('PENDING','SUCCESS','FAILED') NOT NULL,
	`is_refunded` tinyint(1) DEFAULT 0,
	`refunded_at` timestamp,
	`refund_amount` decimal(10,2),
	`refund_reason` varchar(255),
	`transaction_ref` varchar(100),
	`payment_provider_ref` varchar(255),
	`webhook_data` json,
	`paid_at` datetime,
	`created_at` datetime DEFAULT (CURRENT_TIMESTAMP),
	CONSTRAINT `payment_transactions_payment_id` PRIMARY KEY(`payment_id`)
);
--> statement-breakpoint
CREATE TABLE `payment_transactions_new` (
	`transaction_id` bigint AUTO_INCREMENT NOT NULL,
	`user_id` bigint NOT NULL,
	`plan_id` int NOT NULL,
	`amount_php` decimal(10,2) NOT NULL,
	`discount_amount` decimal(10,2) DEFAULT '0.00',
	`final_amount` decimal(10,2) NOT NULL,
	`payment_provider` enum('GCASH','PAYMAYA','BANK_TRANSFER','PAYPAL','STRIPE','MANUAL') NOT NULL,
	`payment_method_details` json,
	`internal_reference` varchar(50) NOT NULL,
	`external_reference` varchar(100),
	`status` enum('PENDING','PROCESSING','COMPLETED','FAILED','REFUNDED','CANCELLED') DEFAULT 'PENDING',
	`status_message` text,
	`subscription_start` date,
	`subscription_end` date,
	`created_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
	`updated_at` timestamp DEFAULT (CURRENT_TIMESTAMP) ON UPDATE CURRENT_TIMESTAMP,
	`completed_at` timestamp,
	CONSTRAINT `payment_transactions_new_transaction_id` PRIMARY KEY(`transaction_id`),
	CONSTRAINT `internal_reference` UNIQUE(`internal_reference`)
);
--> statement-breakpoint
CREATE TABLE `practice_sets` (
	`practice_set_id` int AUTO_INCREMENT NOT NULL,
	`topic_id` int NOT NULL,
	`set_code` varchar(50) NOT NULL,
	`set_name` varchar(255) NOT NULL,
	`set_type` enum('PRACTICE','FINAL') NOT NULL,
	`is_paid` tinyint(1) DEFAULT 0,
	`display_order` int,
	`is_active` tinyint(1) DEFAULT 1,
	`created_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
	`questions_per_set` int DEFAULT 50,
	`access_level` enum('FREE','BASIC','ADVANCE') DEFAULT 'FREE',
	CONSTRAINT `practice_sets_practice_set_id` PRIMARY KEY(`practice_set_id`),
	CONSTRAINT `uq_topic_set` UNIQUE(`topic_id`,`set_code`)
);
--> statement-breakpoint
CREATE TABLE `promo_codes` (
	`promo_id` int AUTO_INCREMENT NOT NULL,
	`code` varchar(20) NOT NULL,
	`description` varchar(255),
	`discount_type` enum('PERCENTAGE','FIXED_AMOUNT') NOT NULL,
	`discount_value` decimal(10,2) NOT NULL,
	`min_purchase` decimal(10,2) DEFAULT '0.00',
	`max_uses` int,
	`times_used` int DEFAULT 0,
	`valid_from` date,
	`valid_until` date,
	`applicable_plans` json,
	`is_active` tinyint(1) DEFAULT 1,
	`created_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
	CONSTRAINT `promo_codes_promo_id` PRIMARY KEY(`promo_id`),
	CONSTRAINT `code` UNIQUE(`code`)
);
--> statement-breakpoint
CREATE TABLE `question_choices` (
	`choice_id` bigint AUTO_INCREMENT NOT NULL,
	`question_id` bigint NOT NULL,
	`choice_label` char(1) NOT NULL,
	`choice_text` longtext NOT NULL,
	`is_correct` tinyint(1) DEFAULT 0,
	`is_active` tinyint(1) DEFAULT 1,
	`display_order` int,
	`created_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
	CONSTRAINT `question_choices_choice_id` PRIMARY KEY(`choice_id`),
	CONSTRAINT `uq_question_choice` UNIQUE(`question_id`,`choice_label`)
);
--> statement-breakpoint
CREATE TABLE `question_explanations` (
	`explanation_id` bigint AUTO_INCREMENT NOT NULL,
	`question_id` bigint NOT NULL,
	`short_explanation` text NOT NULL,
	`exam_explanation` longtext,
	`why_wrong_choices` longtext,
	`memory_tip` varchar(255),
	`reference_id` bigint,
	`is_active` tinyint(1) DEFAULT 1,
	`created_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
	`updated_at` timestamp DEFAULT (CURRENT_TIMESTAMP) ON UPDATE CURRENT_TIMESTAMP,
	`explanation_level` enum('HOOK','EXAM','DEEP') DEFAULT 'EXAM',
	CONSTRAINT `question_explanations_explanation_id` PRIMARY KEY(`explanation_id`),
	CONSTRAINT `uq_question_explanation` UNIQUE(`question_id`)
);
--> statement-breakpoint
CREATE TABLE `questions` (
	`question_id` bigint AUTO_INCREMENT NOT NULL,
	`practice_set_id` int NOT NULL,
	`question_code` varchar(50) NOT NULL,
	`question_text` longtext NOT NULL,
	`difficulty_level` enum('EASY','MEDIUM','HARD') DEFAULT 'MEDIUM',
	`is_active` tinyint(1) DEFAULT 1,
	`created_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
	`updated_at` timestamp DEFAULT (CURRENT_TIMESTAMP) ON UPDATE CURRENT_TIMESTAMP,
	`is_paid` tinyint(1) DEFAULT 0,
	`access_level` enum('FREE','BASIC','PRO','PREMIUM') DEFAULT 'FREE',
	`quality_score` decimal(3,2) DEFAULT '0.00',
	`times_answered` int DEFAULT 0,
	`avg_time_seconds` int DEFAULT 0,
	`percent_correct` decimal(5,2) DEFAULT '0.00',
	`topic_id` int NOT NULL,
	CONSTRAINT `questions_question_id` PRIMARY KEY(`question_id`),
	CONSTRAINT `uq_practice_question` UNIQUE(`practice_set_id`,`question_code`)
);
--> statement-breakpoint
CREATE TABLE `reference_sources` (
	`reference_id` bigint AUTO_INCREMENT NOT NULL,
	`reference_type` enum('IFRS','IAS','PRC_SYLLABUS','TAX_CODE','BIR_RR','CASE_LAW','OTHER') NOT NULL,
	`reference_code` varchar(100),
	`reference_title` varchar(255) NOT NULL,
	`reference_url` text,
	`notes` text,
	`is_active` tinyint(1) DEFAULT 1,
	`created_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
	CONSTRAINT `reference_sources_reference_id` PRIMARY KEY(`reference_id`)
);
--> statement-breakpoint
CREATE TABLE `subject_exam_settings` (
	`subject_id` int NOT NULL,
	`final_time_minutes` int NOT NULL,
	`practice_time_per_question` int NOT NULL DEFAULT 1,
	`created_at` datetime DEFAULT (CURRENT_TIMESTAMP),
	CONSTRAINT `subject_exam_settings_subject_id` PRIMARY KEY(`subject_id`)
);
--> statement-breakpoint
CREATE TABLE `subjects` (
	`subject_id` int AUTO_INCREMENT NOT NULL,
	`syllabus_id` int NOT NULL,
	`subject_code` varchar(10) NOT NULL,
	`subject_name` varchar(150) NOT NULL,
	`display_order` int,
	`is_active` tinyint(1) DEFAULT 1,
	`created_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
	CONSTRAINT `subjects_subject_id` PRIMARY KEY(`subject_id`),
	CONSTRAINT `uq_syllabus_subject` UNIQUE(`syllabus_id`,`subject_code`)
);
--> statement-breakpoint
CREATE TABLE `subscription_plans` (
	`plan_id` int AUTO_INCREMENT NOT NULL,
	`plan_code` varchar(20) NOT NULL,
	`plan_name` varchar(100) NOT NULL,
	`plan_description` text,
	`billing_period` enum('MONTHLY','SEMI_ANNUAL','ANNUAL','LIFETIME') NOT NULL,
	`price_php` decimal(10,2) NOT NULL,
	`original_price_php` decimal(10,2),
	`mcq_limit` int,
	`features` json,
	`is_active` tinyint(1) DEFAULT 1,
	`display_order` int DEFAULT 0,
	`created_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
	CONSTRAINT `subscription_plans_plan_id` PRIMARY KEY(`plan_id`),
	CONSTRAINT `plan_code` UNIQUE(`plan_code`)
);
--> statement-breakpoint
CREATE TABLE `syllabus_topics` (
	`syllabus_topic_id` bigint AUTO_INCREMENT NOT NULL,
	`syllabus_id` int NOT NULL,
	`topic_id` int NOT NULL,
	`is_active` tinyint(1) DEFAULT 1,
	`display_order` int,
	`created_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
	CONSTRAINT `syllabus_topics_syllabus_topic_id` PRIMARY KEY(`syllabus_topic_id`),
	CONSTRAINT `uq_syllabus_topic` UNIQUE(`syllabus_id`,`topic_id`)
);
--> statement-breakpoint
CREATE TABLE `syllabus_versions` (
	`syllabus_id` int AUTO_INCREMENT NOT NULL,
	`syllabus_code` varchar(20) NOT NULL,
	`description` varchar(255),
	`effective_year` int NOT NULL,
	`is_active` tinyint(1) DEFAULT 1,
	`created_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
	CONSTRAINT `syllabus_versions_syllabus_id` PRIMARY KEY(`syllabus_id`),
	CONSTRAINT `syllabus_code` UNIQUE(`syllabus_code`)
);
--> statement-breakpoint
CREATE TABLE `topic_content` (
	`content_id` bigint AUTO_INCREMENT NOT NULL,
	`topic_id` int NOT NULL,
	`content_type` enum('VIDEO','PDF','ARTICLE','INFOGRAPHIC','AUDIO') NOT NULL,
	`title` varchar(255) NOT NULL,
	`description` text,
	`content_url` varchar(500),
	`thumbnail_url` varchar(500),
	`duration_minutes` int,
	`file_size_mb` decimal(10,2),
	`access_level` enum('FREE','BASIC','PRO','PREMIUM') DEFAULT 'BASIC',
	`display_order` int DEFAULT 0,
	`view_count` int DEFAULT 0,
	`is_featured` tinyint(1) DEFAULT 0,
	`is_active` tinyint(1) DEFAULT 1,
	`created_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
	`updated_at` timestamp DEFAULT (CURRENT_TIMESTAMP) ON UPDATE CURRENT_TIMESTAMP,
	CONSTRAINT `topic_content_content_id` PRIMARY KEY(`content_id`)
);
--> statement-breakpoint
CREATE TABLE `topic_video_links` (
	`video_id` bigint AUTO_INCREMENT NOT NULL,
	`topic_id` int NOT NULL,
	`platform` enum('TIKTOK','YOUTUBE','REELS') NOT NULL,
	`video_url` varchar(255) NOT NULL,
	`created_at` datetime DEFAULT (CURRENT_TIMESTAMP),
	CONSTRAINT `topic_video_links_video_id` PRIMARY KEY(`video_id`)
);
--> statement-breakpoint
CREATE TABLE `topics` (
	`topic_id` int AUTO_INCREMENT NOT NULL,
	`subject_id` int NOT NULL,
	`topic_code` varchar(50) NOT NULL,
	`topic_name` varchar(255) NOT NULL,
	`description` text,
	`display_order` int,
	`is_active` tinyint(1) DEFAULT 1,
	`created_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
	CONSTRAINT `topics_topic_id` PRIMARY KEY(`topic_id`),
	CONSTRAINT `uq_subject_topic` UNIQUE(`subject_id`,`topic_code`)
);
--> statement-breakpoint
CREATE TABLE `user_activity_log` (
	`activity_id` bigint AUTO_INCREMENT NOT NULL,
	`user_id` bigint NOT NULL,
	`activity_type` enum('LOGIN','LOGOUT','QUESTION_ANSWERED','QUESTION_SKIPPED','QUESTION_MARKED','EXAM_STARTED','EXAM_PAUSED','EXAM_SUBMITTED','VIDEO_WATCHED','PDF_DOWNLOADED','CONTENT_VIEWED','SUBSCRIPTION_STARTED','SUBSCRIPTION_UPGRADED','SUBSCRIPTION_CANCELLED','PAYMENT_SUCCESS','PAYMENT_FAILED') NOT NULL,
	`activity_data` json,
	`ip_address` varchar(45),
	`user_agent` text,
	`created_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
	CONSTRAINT `user_activity_log_activity_id` PRIMARY KEY(`activity_id`)
);
--> statement-breakpoint
CREATE TABLE `user_api_tokens` (
	`token_id` bigint AUTO_INCREMENT NOT NULL,
	`user_id` bigint NOT NULL,
	`api_token` varchar(255) NOT NULL,
	`expires_at` datetime NOT NULL,
	`is_active` tinyint(1) DEFAULT 1,
	`created_at` datetime DEFAULT (CURRENT_TIMESTAMP),
	CONSTRAINT `user_api_tokens_token_id` PRIMARY KEY(`token_id`),
	CONSTRAINT `uq_api_token` UNIQUE(`api_token`)
);
--> statement-breakpoint
CREATE TABLE `user_daily_activity` (
	`activity_id` bigint AUTO_INCREMENT NOT NULL,
	`user_id` bigint NOT NULL,
	`activity_date` date NOT NULL,
	`questions_answered` int DEFAULT 0,
	`time_studied_minutes` int DEFAULT 0,
	`topics_practiced` text,
	`avg_score_percent` decimal(5,2) DEFAULT '0.00',
	CONSTRAINT `user_daily_activity_activity_id` PRIMARY KEY(`activity_id`),
	CONSTRAINT `uq_user_date` UNIQUE(`user_id`,`activity_date`)
);
--> statement-breakpoint
CREATE TABLE `user_exam_version_status` (
	`user_id` bigint NOT NULL,
	`exam_version_id` int NOT NULL,
	`is_unlocked` tinyint(1) DEFAULT 0,
	`unlocked_at` timestamp,
	`is_completed` tinyint(1) DEFAULT 0,
	`completed_at` timestamp,
	CONSTRAINT `user_exam_version_status_user_id_exam_version_id` PRIMARY KEY(`user_id`,`exam_version_id`)
);
--> statement-breakpoint
CREATE TABLE `user_mock_attempts` (
	`attempt_id` bigint AUTO_INCREMENT NOT NULL,
	`user_id` bigint NOT NULL,
	`exam_id` bigint NOT NULL,
	`started_at` timestamp NOT NULL,
	`ended_at` timestamp,
	`time_spent_seconds` int DEFAULT 0,
	`total_questions` int NOT NULL,
	`correct_answers` int DEFAULT 0,
	`wrong_answers` int DEFAULT 0,
	`unanswered` int DEFAULT 0,
	`score_percent` decimal(5,2) DEFAULT '0.00',
	`passed` tinyint(1) DEFAULT 0,
	`status` enum('IN_PROGRESS','COMPLETED','TIMED_OUT','ABANDONED') DEFAULT 'IN_PROGRESS',
	`answers` json,
	`created_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
	CONSTRAINT `user_mock_attempts_attempt_id` PRIMARY KEY(`attempt_id`)
);
--> statement-breakpoint
CREATE TABLE `user_referrals` (
	`referral_id` bigint AUTO_INCREMENT NOT NULL,
	`referrer_user_id` bigint NOT NULL,
	`referred_user_id` bigint,
	`referral_code` varchar(20) NOT NULL,
	`referred_email` varchar(255),
	`status` enum('PENDING','REGISTERED','CONVERTED','EXPIRED') DEFAULT 'PENDING',
	`clicked_at` timestamp,
	`registered_at` timestamp,
	`converted_at` timestamp,
	`referrer_reward_type` enum('DISCOUNT','FREE_MONTH','CREDITS','NONE') DEFAULT 'NONE',
	`referrer_reward_value` decimal(10,2) DEFAULT '0.00',
	`referrer_reward_claimed` tinyint(1) DEFAULT 0,
	`referred_reward_type` enum('DISCOUNT','FREE_MONTH','CREDITS','NONE') DEFAULT 'NONE',
	`referred_reward_value` decimal(10,2) DEFAULT '0.00',
	`source` varchar(50),
	`created_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
	CONSTRAINT `user_referrals_referral_id` PRIMARY KEY(`referral_id`),
	CONSTRAINT `referral_code` UNIQUE(`referral_code`)
);
--> statement-breakpoint
CREATE TABLE `user_streaks` (
	`streak_id` bigint AUTO_INCREMENT NOT NULL,
	`user_id` bigint NOT NULL,
	`subject_id` int NOT NULL,
	`current_streak` int NOT NULL DEFAULT 0,
	`longest_streak` int NOT NULL DEFAULT 0,
	`best_streak_start_date` date,
	`best_streak_end_date` date,
	`total_study_days` int DEFAULT 0,
	`last_activity_date` date,
	`updated_at` datetime DEFAULT (CURRENT_TIMESTAMP),
	CONSTRAINT `user_streaks_streak_id` PRIMARY KEY(`streak_id`),
	CONSTRAINT `uq_user_subject_streak` UNIQUE(`user_id`,`subject_id`)
);
--> statement-breakpoint
CREATE TABLE `user_study_plan` (
	`plan_id` bigint AUTO_INCREMENT NOT NULL,
	`user_id` bigint NOT NULL,
	`subject_id` int NOT NULL,
	`focus_topic_id` int NOT NULL,
	`priority_level` enum('LOW','MEDIUM','HIGH') NOT NULL,
	`recommended_action` varchar(255),
	`recommended_video_url` varchar(255),
	`created_at` datetime DEFAULT (CURRENT_TIMESTAMP),
	CONSTRAINT `user_study_plan_plan_id` PRIMARY KEY(`plan_id`)
);
--> statement-breakpoint
CREATE TABLE `user_subscriptions` (
	`subscription_id` bigint AUTO_INCREMENT NOT NULL,
	`user_id` bigint NOT NULL,
	`plan_type` enum('FREE','PAID') NOT NULL DEFAULT 'FREE',
	`subscription_status` enum('TRIAL','ACTIVE','EXPIRED','CANCELLED','PAYMENT_FAILED') NOT NULL DEFAULT 'TRIAL',
	`start_date` date NOT NULL,
	`end_date` date,
	`trial_ends_at` datetime,
	`next_billing_date` datetime,
	`auto_renew` tinyint(1) DEFAULT 1,
	`cancelled_at` datetime,
	`payment_method` enum('GCASH','PAYMAYA','CARD','BANK'),
	`last_payment_date` datetime,
	`grace_period_ends_at` datetime,
	`is_active` tinyint(1) NOT NULL DEFAULT 1,
	`created_at` datetime DEFAULT (CURRENT_TIMESTAMP),
	`updated_at` datetime DEFAULT (CURRENT_TIMESTAMP),
	`plan_id` int,
	`billing_period` enum('MONTHLY','SEMI_ANNUAL','ANNUAL','LIFETIME') DEFAULT 'MONTHLY',
	`amount_paid` decimal(10,2) DEFAULT '0.00',
	`payment_reference` varchar(100),
	`payment_provider` enum('GCASH','PAYMAYA','BANK_TRANSFER','PAYPAL','STRIPE','MANUAL'),
	CONSTRAINT `user_subscriptions_subscription_id` PRIMARY KEY(`subscription_id`),
	CONSTRAINT `uq_user_active_subscription` UNIQUE(`user_id`,`is_active`)
);
--> statement-breakpoint
CREATE TABLE `user_topic_weakness` (
	`weakness_id` bigint AUTO_INCREMENT NOT NULL,
	`user_id` bigint NOT NULL,
	`subject_id` int NOT NULL,
	`topic_id` int NOT NULL,
	`total_questions` int NOT NULL,
	`wrong_answers` int NOT NULL,
	`weakness_score` decimal(5,2) GENERATED ALWAYS AS (((`wrong_answers` / `total_questions`) * 100)) STORED,
	`last_updated` datetime DEFAULT (CURRENT_TIMESTAMP),
	CONSTRAINT `user_topic_weakness_weakness_id` PRIMARY KEY(`weakness_id`),
	CONSTRAINT `uq_user_topic` UNIQUE(`user_id`,`topic_id`)
);
--> statement-breakpoint
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
	`created_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
	`is_paid` tinyint(1) NOT NULL DEFAULT 0,
	CONSTRAINT `users_user_id` PRIMARY KEY(`user_id`),
	CONSTRAINT `email` UNIQUE(`email`)
);
--> statement-breakpoint
ALTER TABLE `attempt_answers` ADD CONSTRAINT `fk_attempt_answers_attempt` FOREIGN KEY (`attempt_id`) REFERENCES `exam_attempts`(`attempt_id`) ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `attempt_answers` ADD CONSTRAINT `fk_attempt_answers_choice` FOREIGN KEY (`choice_id`) REFERENCES `question_choices`(`choice_id`) ON DELETE restrict ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `attempt_answers` ADD CONSTRAINT `fk_attempt_answers_question` FOREIGN KEY (`question_id`) REFERENCES `questions`(`question_id`) ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `email_campaign_sends` ADD CONSTRAINT `email_campaign_sends_ibfk_1` FOREIGN KEY (`campaign_id`) REFERENCES `email_campaigns`(`campaign_id`) ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `email_campaign_sends` ADD CONSTRAINT `email_campaign_sends_ibfk_2` FOREIGN KEY (`subscriber_id`) REFERENCES `email_subscribers`(`subscriber_id`) ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `email_subscribers` ADD CONSTRAINT `email_subscribers_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `exam_attempt_analytics` ADD CONSTRAINT `exam_attempt_analytics_ibfk_1` FOREIGN KEY (`attempt_id`) REFERENCES `exam_attempts`(`attempt_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `exam_attempt_questions` ADD CONSTRAINT `exam_attempt_questions_ibfk_1` FOREIGN KEY (`attempt_id`) REFERENCES `exam_attempts`(`attempt_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `exam_attempt_questions` ADD CONSTRAINT `exam_attempt_questions_ibfk_2` FOREIGN KEY (`question_id`) REFERENCES `questions`(`question_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `exam_attempts` ADD CONSTRAINT `fk_attempts_practice_set` FOREIGN KEY (`practice_set_id`) REFERENCES `practice_sets`(`practice_set_id`) ON DELETE restrict ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE `exam_attempts` ADD CONSTRAINT `fk_exam_attempts_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `exam_attempts` ADD CONSTRAINT `fk_exam_attempts_version` FOREIGN KEY (`exam_version_id`) REFERENCES `exam_versions`(`exam_version_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `exam_session_cache` ADD CONSTRAINT `exam_session_cache_ibfk_1` FOREIGN KEY (`attempt_id`) REFERENCES `exam_attempts`(`attempt_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `exam_version_analytics` ADD CONSTRAINT `fk_analytics_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `exam_version_analytics` ADD CONSTRAINT `fk_analytics_version` FOREIGN KEY (`exam_version_id`) REFERENCES `exam_versions`(`exam_version_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `exam_version_unlock_rules` ADD CONSTRAINT `fk_unlock_rule_version` FOREIGN KEY (`exam_version_id`) REFERENCES `exam_versions`(`exam_version_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `exam_version_unlocks` ADD CONSTRAINT `fk_unlock_from_version` FOREIGN KEY (`from_version_id`) REFERENCES `exam_versions`(`exam_version_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `exam_version_unlocks` ADD CONSTRAINT `fk_unlock_to_version` FOREIGN KEY (`to_version_id`) REFERENCES `exam_versions`(`exam_version_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `exam_version_user_progress` ADD CONSTRAINT `fk_progress_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `exam_version_user_progress` ADD CONSTRAINT `fk_progress_version` FOREIGN KEY (`exam_version_id`) REFERENCES `exam_versions`(`exam_version_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `exam_versions` ADD CONSTRAINT `exam_versions_ibfk_1` FOREIGN KEY (`subject_id`) REFERENCES `subjects`(`subject_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `mock_preboard_exams` ADD CONSTRAINT `mock_preboard_exams_ibfk_1` FOREIGN KEY (`subject_id`) REFERENCES `subjects`(`subject_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `payment_transactions` ADD CONSTRAINT `payment_transactions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `payment_transactions_new` ADD CONSTRAINT `payment_transactions_new_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `payment_transactions_new` ADD CONSTRAINT `payment_transactions_new_ibfk_2` FOREIGN KEY (`plan_id`) REFERENCES `subscription_plans`(`plan_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `practice_sets` ADD CONSTRAINT `fk_practice_sets_topic` FOREIGN KEY (`topic_id`) REFERENCES `topics`(`topic_id`) ON DELETE restrict ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE `question_choices` ADD CONSTRAINT `fk_choices_question` FOREIGN KEY (`question_id`) REFERENCES `questions`(`question_id`) ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `question_explanations` ADD CONSTRAINT `fk_explanations_question` FOREIGN KEY (`question_id`) REFERENCES `questions`(`question_id`) ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `questions` ADD CONSTRAINT `fk_questions_practice_set` FOREIGN KEY (`practice_set_id`) REFERENCES `practice_sets`(`practice_set_id`) ON DELETE restrict ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE `questions` ADD CONSTRAINT `fk_questions_topic` FOREIGN KEY (`topic_id`) REFERENCES `topics`(`topic_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `subjects` ADD CONSTRAINT `fk_subjects_syllabus` FOREIGN KEY (`syllabus_id`) REFERENCES `syllabus_versions`(`syllabus_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `syllabus_topics` ADD CONSTRAINT `fk_syllabus_topics_syllabus` FOREIGN KEY (`syllabus_id`) REFERENCES `syllabus_versions`(`syllabus_id`) ON DELETE restrict ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE `syllabus_topics` ADD CONSTRAINT `fk_syllabus_topics_topic` FOREIGN KEY (`topic_id`) REFERENCES `topics`(`topic_id`) ON DELETE restrict ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE `topic_content` ADD CONSTRAINT `topic_content_ibfk_1` FOREIGN KEY (`topic_id`) REFERENCES `topics`(`topic_id`) ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `topic_video_links` ADD CONSTRAINT `topic_video_links_ibfk_1` FOREIGN KEY (`topic_id`) REFERENCES `topics`(`topic_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `topics` ADD CONSTRAINT `fk_topics_subject` FOREIGN KEY (`subject_id`) REFERENCES `subjects`(`subject_id`) ON DELETE restrict ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE `user_activity_log` ADD CONSTRAINT `user_activity_log_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `user_api_tokens` ADD CONSTRAINT `user_api_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `user_daily_activity` ADD CONSTRAINT `user_daily_activity_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `user_exam_version_status` ADD CONSTRAINT `fk_user_version_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `user_exam_version_status` ADD CONSTRAINT `fk_user_version_version` FOREIGN KEY (`exam_version_id`) REFERENCES `exam_versions`(`exam_version_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `user_mock_attempts` ADD CONSTRAINT `user_mock_attempts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `user_mock_attempts` ADD CONSTRAINT `user_mock_attempts_ibfk_2` FOREIGN KEY (`exam_id`) REFERENCES `mock_preboard_exams`(`exam_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `user_referrals` ADD CONSTRAINT `user_referrals_ibfk_1` FOREIGN KEY (`referrer_user_id`) REFERENCES `users`(`user_id`) ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `user_referrals` ADD CONSTRAINT `user_referrals_ibfk_2` FOREIGN KEY (`referred_user_id`) REFERENCES `users`(`user_id`) ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `user_streaks` ADD CONSTRAINT `user_streaks_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `user_study_plan` ADD CONSTRAINT `user_study_plan_ibfk_1` FOREIGN KEY (`focus_topic_id`) REFERENCES `topics`(`topic_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `user_subscriptions` ADD CONSTRAINT `fk_subscription_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `user_topic_weakness` ADD CONSTRAINT `user_topic_weakness_ibfk_1` FOREIGN KEY (`topic_id`) REFERENCES `topics`(`topic_id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX `idx_marked_review` ON `attempt_answers` (`attempt_id`,`is_marked_for_review`);--> statement-breakpoint
CREATE INDEX `idx_time_spent` ON `attempt_answers` (`time_spent_seconds`);--> statement-breakpoint
CREATE INDEX `idx_confidence` ON `attempt_answers` (`confidence_level`);--> statement-breakpoint
CREATE INDEX `subscriber_id` ON `email_campaign_sends` (`subscriber_id`);--> statement-breakpoint
CREATE INDEX `idx_campaign_subscriber` ON `email_campaign_sends` (`campaign_id`,`subscriber_id`);--> statement-breakpoint
CREATE INDEX `idx_sent_date` ON `email_campaign_sends` (`sent_at`);--> statement-breakpoint
CREATE INDEX `idx_engagement` ON `email_campaign_sends` (`opened_at`,`clicked_at`);--> statement-breakpoint
CREATE INDEX `idx_campaign_status` ON `email_campaigns` (`is_draft`,`is_active`);--> statement-breakpoint
CREATE INDEX `idx_scheduled` ON `email_campaigns` (`scheduled_at`);--> statement-breakpoint
CREATE INDEX `idx_campaign_type` ON `email_campaigns` (`campaign_type`);--> statement-breakpoint
CREATE INDEX `user_id` ON `email_subscribers` (`user_id`);--> statement-breakpoint
CREATE INDEX `idx_email_verified` ON `email_subscribers` (`is_verified`,`unsubscribed_at`);--> statement-breakpoint
CREATE INDEX `idx_source` ON `email_subscribers` (`source`);--> statement-breakpoint
CREATE INDEX `idx_subscribed_date` ON `email_subscribers` (`subscribed_at`);--> statement-breakpoint
CREATE INDEX `attempt_id` ON `exam_attempt_analytics` (`attempt_id`);--> statement-breakpoint
CREATE INDEX `question_id` ON `exam_attempt_questions` (`question_id`);--> statement-breakpoint
CREATE INDEX `idx_exam_attempts_user_id` ON `exam_attempts` (`user_id`);--> statement-breakpoint
CREATE INDEX `idx_attempts_user_subject` ON `exam_attempts` (`user_id`,`subject_id`);--> statement-breakpoint
CREATE INDEX `idx_attempts_submitted` ON `exam_attempts` (`submitted_at`);--> statement-breakpoint
CREATE INDEX `idx_archive_user` ON `exam_attempts_archive` (`user_id`);--> statement-breakpoint
CREATE INDEX `idx_archive_date` ON `exam_attempts_archive` (`archived_at`);--> statement-breakpoint
CREATE INDEX `idx_archive_reason` ON `exam_attempts_archive` (`archived_reason`);--> statement-breakpoint
CREATE INDEX `attempt_id` ON `exam_session_cache` (`attempt_id`);--> statement-breakpoint
CREATE INDEX `idx_progress_current` ON `exam_version_user_progress` (`user_id`,`is_current`);--> statement-breakpoint
CREATE INDEX `subject_id` ON `mock_preboard_exams` (`subject_id`);--> statement-breakpoint
CREATE INDEX `user_id` ON `payment_transactions` (`user_id`);--> statement-breakpoint
CREATE INDEX `idx_subscription` ON `payment_transactions` (`subscription_id`);--> statement-breakpoint
CREATE INDEX `idx_provider_ref` ON `payment_transactions` (`payment_provider_ref`);--> statement-breakpoint
CREATE INDEX `idx_payment_date` ON `payment_transactions` (`paid_at`);--> statement-breakpoint
CREATE INDEX `idx_user_transactions` ON `payment_transactions_new` (`user_id`);--> statement-breakpoint
CREATE INDEX `idx_status` ON `payment_transactions_new` (`status`);--> statement-breakpoint
CREATE INDEX `idx_provider` ON `payment_transactions_new` (`payment_provider`);--> statement-breakpoint
CREATE INDEX `idx_reference` ON `payment_transactions_new` (`internal_reference`);--> statement-breakpoint
CREATE INDEX `plan_id` ON `payment_transactions_new` (`plan_id`);--> statement-breakpoint
CREATE INDEX `idx_access_level` ON `questions` (`access_level`,`is_active`);--> statement-breakpoint
CREATE INDEX `idx_topic_content` ON `topic_content` (`topic_id`,`is_active`);--> statement-breakpoint
CREATE INDEX `idx_content_type` ON `topic_content` (`content_type`);--> statement-breakpoint
CREATE INDEX `idx_featured` ON `topic_content` (`is_featured`,`is_active`);--> statement-breakpoint
CREATE INDEX `topic_id` ON `topic_video_links` (`topic_id`);--> statement-breakpoint
CREATE INDEX `idx_user_activity` ON `user_activity_log` (`user_id`,`activity_type`);--> statement-breakpoint
CREATE INDEX `idx_activity_date` ON `user_activity_log` (`created_at`);--> statement-breakpoint
CREATE INDEX `idx_activity_type` ON `user_activity_log` (`activity_type`);--> statement-breakpoint
CREATE INDEX `user_id` ON `user_api_tokens` (`user_id`);--> statement-breakpoint
CREATE INDEX `idx_user_activity_date` ON `user_daily_activity` (`user_id`,`activity_date`);--> statement-breakpoint
CREATE INDEX `user_id` ON `user_mock_attempts` (`user_id`);--> statement-breakpoint
CREATE INDEX `exam_id` ON `user_mock_attempts` (`exam_id`);--> statement-breakpoint
CREATE INDEX `referred_user_id` ON `user_referrals` (`referred_user_id`);--> statement-breakpoint
CREATE INDEX `idx_referrer` ON `user_referrals` (`referrer_user_id`);--> statement-breakpoint
CREATE INDEX `idx_referral_code` ON `user_referrals` (`referral_code`);--> statement-breakpoint
CREATE INDEX `idx_status` ON `user_referrals` (`status`);--> statement-breakpoint
CREATE INDEX `focus_topic_id` ON `user_study_plan` (`focus_topic_id`);--> statement-breakpoint
CREATE INDEX `idx_subscription_status` ON `user_subscriptions` (`subscription_status`);--> statement-breakpoint
CREATE INDEX `idx_trial_ends` ON `user_subscriptions` (`trial_ends_at`);--> statement-breakpoint
CREATE INDEX `idx_next_billing` ON `user_subscriptions` (`next_billing_date`);--> statement-breakpoint
CREATE INDEX `topic_id` ON `user_topic_weakness` (`topic_id`);--> statement-breakpoint
CREATE INDEX `idx_weakness_user` ON `user_topic_weakness` (`user_id`);--> statement-breakpoint
CREATE INDEX `idx_flagged` ON `users` (`is_flagged`);--> statement-breakpoint
CREATE INDEX `idx_last_login` ON `users` (`last_login_at`);--> statement-breakpoint
CREATE ALGORITHM = undefined
SQL SECURITY definer
VIEW `vw_user_exam_summary` AS (select `cpale_explained`.`exam_attempts`.`user_id` AS `user_id`,`cpale_explained`.`exam_attempts`.`subject_id` AS `subject_id`,count(0) AS `attempts`,avg(`cpale_explained`.`exam_attempts`.`score_percent`) AS `avg_score`,max(`cpale_explained`.`exam_attempts`.`score_percent`) AS `best_score` from `cpale_explained`.`exam_attempts` where (`cpale_explained`.`exam_attempts`.`is_valid` = 1) group by `cpale_explained`.`exam_attempts`.`user_id`,`cpale_explained`.`exam_attempts`.`subject_id`);--> statement-breakpoint
CREATE ALGORITHM = undefined
SQL SECURITY definer
VIEW `vw_weekly_user_progress` AS (select `ea`.`user_id` AS `user_id`,`ea`.`subject_id` AS `subject_id`,`ev`.`attempt_type` AS `attempt_type`,`ev`.`version_no` AS `version_no`,`ev`.`version_label` AS `version_label`,count(`ea`.`attempt_id`) AS `attempts_count`,avg(`ea`.`score_percent`) AS `avg_score`,max(`ea`.`score_percent`) AS `best_score`,min(`ea`.`score_percent`) AS `worst_score`,week(`ea`.`submitted_at`,0) AS `week_no`,year(`ea`.`submitted_at`) AS `year_no` from (`cpale_explained`.`exam_attempts` `ea` join `cpale_explained`.`exam_versions` `ev` on((`ev`.`exam_version_id` = `ea`.`exam_version_id`))) where (`ea`.`is_valid` = 1) group by `ea`.`user_id`,`ea`.`subject_id`,`ev`.`attempt_type`,`ev`.`version_no`,`week_no`,`year_no`);
*/