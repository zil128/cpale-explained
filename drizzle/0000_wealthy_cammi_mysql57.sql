-- ============================================================================
-- CPALE EXPLAINED - Database Schema Restoration
-- Modified for MySQL 5.7 compatibility
-- ============================================================================

-- Create all tables with proper syntax for MySQL 5.7

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
	`answered_at` timestamp DEFAULT CURRENT_TIMESTAMP,
	`question_started_at` timestamp NULL,
	CONSTRAINT `attempt_answers_attempt_answer_id` PRIMARY KEY(`attempt_answer_id`),
	CONSTRAINT `uq_attempt_question` UNIQUE(`attempt_id`,`question_id`)
);

CREATE TABLE `email_campaign_sends` (
	`send_id` bigint AUTO_INCREMENT NOT NULL,
	`campaign_id` bigint NOT NULL,
	`subscriber_id` bigint NOT NULL,
	`sent_at` timestamp DEFAULT CURRENT_TIMESTAMP,
	`delivered_at` timestamp NULL,
	`opened_at` timestamp NULL,
	`clicked_at` timestamp NULL,
	`bounced_at` timestamp NULL,
	`unsubscribed_at` timestamp NULL,
	`open_count` int DEFAULT 0,
	`click_count` int DEFAULT 0,
	CONSTRAINT `email_campaign_sends_send_id` PRIMARY KEY(`send_id`)
);

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
	`scheduled_at` timestamp NULL,
	`sent_at` timestamp NULL,
	`verified_at` timestamp NULL,
	`archived_reason` varchar(255) NOT NULL,
	`archived_at` timestamp DEFAULT CURRENT_TIMESTAMP,
	`archived_by` varchar(50) DEFAULT 'SYSTEM',
	`unlocked_at` timestamp NULL,
	`is_completed` tinyint(1) DEFAULT 0,
	`created_at` timestamp,
	`submitted_at` timestamp NULL,
	`best_streak_start_date` date NULL,
	`best_streak_end_date` date NULL,
	`last_activity_date` date NULL,
	`unlocked_at` timestamp NULL,
	`is_completed` tinyint(1) DEFAULT 0,
	`created_at` timestamp,
	`submitted_at` timestamp NULL,
	`ended_at` timestamp NULL,
	`clicked_at` timestamp NULL,
	`registered_at` timestamp NULL,
	`converted_at` timestamp NULL,
	`referrer_reward_type` enum('DISCOUNT','FREE_MONTH','CREDITS','NONE') DEFAULT 'NONE',
	`referrer_reward_value` decimal(10,2) DEFAULT '0.00',
	`referrer_reward_claimed` tinyint(1) DEFAULT 0,
	`referred_reward_type` enum('DISCOUNT','FREE_MONTH','CREDITS','NONE') DEFAULT 'NONE',
	`referred_reward_value` decimal(10,2) DEFAULT '0.00',
	`source` varchar(50),
	`created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT `user_referrals_referral_id` PRIMARY KEY(`referral_id`),
	CONSTRAINT `referral_code` UNIQUE(`referral_code`)
);

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
	`updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT `user_streaks_streak_id` PRIMARY KEY(`streak_id`),
	CONSTRAINT `uq_user_subject_streak` UNIQUE(`user_id`,`subject_id`)
);

CREATE TABLE `user_study_plan` (
	`plan_id` bigint AUTO_INCREMENT NOT NULL,
	`user_id` bigint NOT NULL,
	`subject_id` int NOT NULL,
	`focus_topic_id` int NOT NULL,
	`priority_level` enum('LOW','MEDIUM','HIGH') NOT NULL,
	`recommended_action` varchar(255),
	`recommended_video_url` varchar(255),
	`created_at` datetime DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT `user_study_plan_plan_id` PRIMARY KEY(`plan_id`)
);

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
	`created_at` datetime DEFAULT CURRENT_TIMESTAMP,
	`updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
	`plan_id` int,
	`billing_period` enum('MONTHLY','SEMI_ANNUAL','ANNUAL','LIFETIME') DEFAULT 'MONTHLY',
	`amount_paid` decimal(10,2) DEFAULT '0.00',
	`payment_reference` varchar(100),
	`payment_provider` enum('GCASH','PAYMAYA','BANK_TRANSFER','PAYPAL','STRIPE','MANUAL'),
	CONSTRAINT `user_subscriptions_subscription_id` PRIMARY KEY(`subscription_id`),
	CONSTRAINT `uq_user_active_subscription` UNIQUE(`user_id`,`is_active`)
);

CREATE TABLE `user_topic_weakness` (
	`weakness_id` bigint AUTO_INCREMENT NOT NULL,
	`user_id` bigint NOT NULL,
	`subject_id` int NOT NULL,
	`topic_id` int NOT NULL,
	`total_questions` int NOT NULL,
	`wrong_answers` int NOT NULL,
	`weakness_score` decimal(5,2) GENERATED ALWAYS AS (((`wrong_answers` / `total_questions`) * 100)) STORED,
	`last_updated` datetime DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT `user_topic_weakness_weakness_id` PRIMARY KEY(`weakness_id`),
	CONSTRAINT `uq_user_topic` UNIQUE(`user_id`,`topic_id`)
);

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