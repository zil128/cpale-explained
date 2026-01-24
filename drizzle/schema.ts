import { mysqlTable, mysqlSchema, AnyMySqlColumn, index, foreignKey, primaryKey, unique, bigint, int, mysqlEnum, timestamp, varchar, text, decimal, datetime, json, date, longtext, mysqlView } from "drizzle-orm/mysql-core"
import { sql } from "drizzle-orm"

export const attemptAnswers = mysqlTable("attempt_answers", {
	attemptAnswerId: bigint("attempt_answer_id", { mode: "number" }).autoincrement().notNull(),
	attemptId: bigint("attempt_id", { mode: "number" }).notNull().references(() => examAttempts.attemptId, { onDelete: "cascade" } ),
	questionId: bigint("question_id", { mode: "number" }).notNull().references(() => questions.questionId, { onDelete: "cascade" } ),
	choiceId: bigint("choice_id", { mode: "number" }).notNull().references(() => questionChoices.choiceId, { onDelete: "restrict" } ),
	isCorrect: tinyint("is_correct").notNull(),
	timeSpentSeconds: int("time_spent_seconds").default(0),
	isMarkedForReview: tinyint("is_marked_for_review").default(0),
	confidenceLevel: mysqlEnum("confidence_level", ['GUESSED','UNSURE','CONFIDENT']),
	attemptCount: int("attempt_count").default(1),
	firstAttemptCorrect: tinyint("first_attempt_correct"),
	answeredAt: timestamp("answered_at", { mode: 'string' }).defaultNow(),
	questionStartedAt: timestamp("question_started_at", { mode: 'string' }),
},
(table) => [
	index("idx_confidence").on(table.confidenceLevel),
	index("idx_marked_review").on(table.attemptId, table.isMarkedForReview),
	index("idx_time_spent").on(table.timeSpentSeconds),
	primaryKey({ columns: [table.attemptAnswerId], name: "attempt_answers_attempt_answer_id"}),
	unique("uq_attempt_question").on(table.attemptId, table.questionId),
]);

export const emailCampaignSends = mysqlTable("email_campaign_sends", {
	sendId: bigint("send_id", { mode: "number" }).autoincrement().notNull(),
	campaignId: bigint("campaign_id", { mode: "number" }).notNull().references(() => emailCampaigns.campaignId, { onDelete: "cascade" } ),
	subscriberId: bigint("subscriber_id", { mode: "number" }).notNull().references(() => emailSubscribers.subscriberId, { onDelete: "cascade" } ),
	sentAt: timestamp("sent_at", { mode: 'string' }).defaultNow(),
	deliveredAt: timestamp("delivered_at", { mode: 'string' }),
	openedAt: timestamp("opened_at", { mode: 'string' }),
	clickedAt: timestamp("clicked_at", { mode: 'string' }),
	bouncedAt: timestamp("bounced_at", { mode: 'string' }),
	bounceReason: varchar("bounce_reason", { length: 255 }),
	unsubscribedAt: timestamp("unsubscribed_at", { mode: 'string' }),
	openCount: int("open_count").default(0),
	clickCount: int("click_count").default(0),
},
(table) => [
	index("idx_campaign_subscriber").on(table.campaignId, table.subscriberId),
	index("idx_engagement").on(table.openedAt, table.clickedAt),
	index("idx_sent_date").on(table.sentAt),
	index("subscriber_id").on(table.subscriberId),
	primaryKey({ columns: [table.sendId], name: "email_campaign_sends_send_id"}),
]);

export const emailCampaigns = mysqlTable("email_campaigns", {
	campaignId: bigint("campaign_id", { mode: "number" }).autoincrement().notNull(),
	campaignName: varchar("campaign_name", { length: 255 }).notNull(),
	campaignType: mysqlEnum("campaign_type", ['WELCOME','NURTURE','PROMOTIONAL','TRANSACTIONAL','ANNOUNCEMENT']).notNull(),
	subjectLine: varchar("subject_line", { length: 255 }).notNull(),
	previewText: varchar("preview_text", { length: 150 }),
	emailBodyHtml: text("email_body_html").notNull(),
	emailBodyText: text("email_body_text"),
	senderName: varchar("sender_name", { length: 100 }).default('CPALE Explained'),
	senderEmail: varchar("sender_email", { length: 255 }).default('hello@cpaleexplained.com'),
	targetSegment: mysqlEnum("target_segment", ['ALL','FREE_USERS','TRIAL_USERS','PAID_USERS','CHURNED_USERS']).default('ALL'),
	scheduledAt: timestamp("scheduled_at", { mode: 'string' }),
	sentAt: timestamp("sent_at", { mode: 'string' }),
	totalSent: int("total_sent").default(0),
	totalDelivered: int("total_delivered").default(0),
	totalOpened: int("total_opened").default(0),
	totalClicked: int("total_clicked").default(0),
	totalBounced: int("total_bounced").default(0),
	totalUnsubscribed: int("total_unsubscribed").default(0),
	isDraft: tinyint("is_draft").default(1),
	isActive: tinyint("is_active").default(1),
	createdAt: timestamp("created_at", { mode: 'string' }).defaultNow(),
	updatedAt: timestamp("updated_at", { mode: 'string' }).defaultNow().onUpdateNow(),
},
(table) => [
	index("idx_campaign_status").on(table.isDraft, table.isActive),
	index("idx_campaign_type").on(table.campaignType),
	index("idx_scheduled").on(table.scheduledAt),
	primaryKey({ columns: [table.campaignId], name: "email_campaigns_campaign_id"}),
]);

export const emailSubscribers = mysqlTable("email_subscribers", {
	subscriberId: bigint("subscriber_id", { mode: "number" }).autoincrement().notNull(),
	email: varchar({ length: 255 }).notNull(),
	userId: bigint("user_id", { mode: "number" }).references(() => users.userId, { onDelete: "set null" } ),
	firstName: varchar("first_name", { length: 100 }),
	source: varchar({ length: 50 }).notNull(),
	utmSource: varchar("utm_source", { length: 100 }),
	utmCampaign: varchar("utm_campaign", { length: 100 }),
	subscribedAt: timestamp("subscribed_at", { mode: 'string' }).defaultNow(),
	isVerified: tinyint("is_verified").default(0),
	verificationToken: varchar("verification_token", { length: 100 }),
	verifiedAt: timestamp("verified_at", { mode: 'string' }),
	unsubscribedAt: timestamp("unsubscribed_at", { mode: 'string' }),
	unsubscribeReason: text("unsubscribe_reason"),
},
(table) => [
	index("idx_email_verified").on(table.isVerified, table.unsubscribedAt),
	index("idx_source").on(table.source),
	index("idx_subscribed_date").on(table.subscribedAt),
	index("user_id").on(table.userId),
	primaryKey({ columns: [table.subscriberId], name: "email_subscribers_subscriber_id"}),
	unique("email").on(table.email),
]);

export const examAttemptAnalytics = mysqlTable("exam_attempt_analytics", {
	analyticsId: bigint("analytics_id", { mode: "number" }).autoincrement().notNull(),
	attemptId: bigint("attempt_id", { mode: "number" }).notNull().references(() => examAttempts.attemptId),
	weakTopicId: int("weak_topic_id"),
	incorrectCount: int("incorrect_count").default(0),
	createdAt: timestamp("created_at", { mode: 'string' }).defaultNow(),
},
(table) => [
	index("attempt_id").on(table.attemptId),
	primaryKey({ columns: [table.analyticsId], name: "exam_attempt_analytics_analytics_id"}),
]);

export const examAttemptQuestions = mysqlTable("exam_attempt_questions", {
	attemptQuestionId: bigint("attempt_question_id", { mode: "number" }).autoincrement().notNull(),
	attemptId: bigint("attempt_id", { mode: "number" }).notNull().references(() => examAttempts.attemptId),
	questionId: bigint("question_id", { mode: "number" }).notNull().references(() => questions.questionId),
	questionOrder: int("question_order").notNull(),
},
(table) => [
	index("question_id").on(table.questionId),
	primaryKey({ columns: [table.attemptQuestionId], name: "exam_attempt_questions_attempt_question_id"}),
	unique("attempt_id").on(table.attemptId, table.questionId),
]);

export const examAttempts = mysqlTable("exam_attempts", {
	attemptId: bigint("attempt_id", { mode: "number" }).autoincrement().notNull(),
	userId: bigint("user_id", { mode: "number" }).notNull().references(() => users.userId),
	practiceSetId: int("practice_set_id").notNull().references(() => practiceSets.practiceSetId, { onDelete: "restrict", onUpdate: "cascade" } ),
	attemptType: mysqlEnum("attempt_type", ['PRACTICE','FINAL']).notNull(),
	totalQuestions: int("total_questions").default(0).notNull(),
	correctAnswers: int("correct_answers").default(0).notNull(),
	startedAt: timestamp("started_at", { mode: 'string' }).defaultNow(),
	completedAt: timestamp("completed_at", { mode: 'string' }),
	timeSpentSeconds: int("time_spent_seconds"),
	isCompleted: tinyint("is_completed").default(0),
	createdAt: timestamp("created_at", { mode: 'string' }).defaultNow(),
	submittedAt: timestamp("submitted_at", { mode: 'string' }),
	scorePercent: decimal("score_percent", { precision: 5, scale: 2 }).default('0.00').notNull(),
	isSubmitted: tinyint("is_submitted").default(0),
	timeLimitMinutes: int("time_limit_minutes"),
	autoSubmitted: tinyint("auto_submitted").default(0),
	showAnswers: tinyint("show_answers").default(1),
	showExplanations: tinyint("show_explanations").default(1),
	subjectId: int("subject_id"),
	examVersionId: int("exam_version_id").notNull().references(() => examVersions.examVersionId),
	isValid: tinyint("is_valid").default(1),
	clientFingerprint: varchar("client_fingerprint", { length: 255 }),
	ipAddress: varchar("ip_address", { length: 45 }),
},
(table) => [
	index("idx_attempts_submitted").on(table.submittedAt),
	index("idx_attempts_user_subject").on(table.userId, table.subjectId),
	index("idx_exam_attempts_user_id").on(table.userId),
	primaryKey({ columns: [table.attemptId], name: "exam_attempts_attempt_id"}),
	unique("uq_final_once_per_subject_version").on(table.userId, table.subjectId, table.examVersionId, table.isValid),
	unique("uq_final_once_per_version").on(table.userId, table.subjectId, table.examVersionId, table.isValid),
]);

export const examAttemptsArchive = mysqlTable("exam_attempts_archive", {
	archiveId: bigint("archive_id", { mode: "number" }).autoincrement().notNull(),
	attemptId: bigint("attempt_id", { mode: "number" }).notNull(),
	userId: bigint("user_id", { mode: "number" }).notNull(),
	practiceSetId: int("practice_set_id").notNull(),
	attemptType: mysqlEnum("attempt_type", ['PRACTICE','FINAL']).notNull(),
	totalQuestions: int("total_questions").default(0).notNull(),
	correctAnswers: int("correct_answers").default(0).notNull(),
	startedAt: timestamp("started_at", { mode: 'string' }),
	completedAt: timestamp("completed_at", { mode: 'string' }),
	timeSpentSeconds: int("time_spent_seconds"),
	isCompleted: tinyint("is_completed").default(0),
	createdAt: timestamp("created_at", { mode: 'string' }),
	submittedAt: timestamp("submitted_at", { mode: 'string' }),
	scorePercent: decimal("score_percent", { precision: 5, scale: 2 }).default('0.00').notNull(),
	isSubmitted: tinyint("is_submitted").default(0),
	timeLimitMinutes: int("time_limit_minutes"),
	autoSubmitted: tinyint("auto_submitted").default(0),
	showAnswers: tinyint("show_answers").default(1),
	showExplanations: tinyint("show_explanations").default(1),
	subjectId: int("subject_id"),
	examVersionId: int("exam_version_id").notNull(),
	clientFingerprint: varchar("client_fingerprint", { length: 255 }),
	ipAddress: varchar("ip_address", { length: 45 }),
	archivedReason: varchar("archived_reason", { length: 255 }).notNull(),
	archivedAt: timestamp("archived_at", { mode: 'string' }).defaultNow(),
	archivedBy: varchar("archived_by", { length: 50 }).default('SYSTEM'),
},
(table) => [
	index("idx_archive_date").on(table.archivedAt),
	index("idx_archive_reason").on(table.archivedReason),
	index("idx_archive_user").on(table.userId),
	primaryKey({ columns: [table.archiveId], name: "exam_attempts_archive_archive_id"}),
]);

export const examAuditLogs = mysqlTable("exam_audit_logs", {
	auditId: bigint("audit_id", { mode: "number" }).autoincrement().notNull(),
	attemptId: bigint("attempt_id", { mode: "number" }),
	eventType: varchar("event_type", { length: 50 }),
	eventTime: datetime("event_time", { mode: 'string'}).default(sql`(CURRENT_TIMESTAMP)`),
	eventData: text("event_data"),
},
(table) => [
	primaryKey({ columns: [table.auditId], name: "exam_audit_logs_audit_id"}),
]);

export const examSessionCache = mysqlTable("exam_session_cache", {
	sessionId: bigint("session_id", { mode: "number" }).autoincrement().notNull(),
	attemptId: bigint("attempt_id", { mode: "number" }).notNull().references(() => examAttempts.attemptId),
	cachedAnswers: json("cached_answers").notNull(),
	lastSavedAt: datetime("last_saved_at", { mode: 'string'}).default(sql`(CURRENT_TIMESTAMP)`),
},
(table) => [
	index("attempt_id").on(table.attemptId),
	primaryKey({ columns: [table.sessionId], name: "exam_session_cache_session_id"}),
]);

export const examUserAnalytics = mysqlTable("exam_user_analytics", {
	analyticsId: bigint("analytics_id", { mode: "number" }).autoincrement().notNull(),
	userId: bigint("user_id", { mode: "number" }).notNull(),
	subjectId: int("subject_id").notNull(),
	attemptType: mysqlEnum("attempt_type", ['PRACTICE','FINAL']).notNull(),
	examVersionId: int("exam_version_id").notNull(),
	totalAttempts: int("total_attempts").default(0).notNull(),
	avgScore: decimal("avg_score", { precision: 5, scale: 2 }).default('0.00').notNull(),
	bestScore: decimal("best_score", { precision: 5, scale: 2 }).default('0.00').notNull(),
	lastAttemptAt: datetime("last_attempt_at", { mode: 'string'}),
	createdAt: datetime("created_at", { mode: 'string'}).default(sql`(CURRENT_TIMESTAMP)`),
	updatedAt: datetime("updated_at", { mode: 'string'}).default(sql`(CURRENT_TIMESTAMP)`),
},
(table) => [
	primaryKey({ columns: [table.analyticsId], name: "exam_user_analytics_analytics_id"}),
	unique("uq_user_subject_version").on(table.userId, table.subjectId, table.attemptType, table.examVersionId),
]);

export const examVersionAnalytics = mysqlTable("exam_version_analytics", {
	analyticsId: bigint("analytics_id", { mode: "number" }).autoincrement().notNull(),
	userId: bigint("user_id", { mode: "number" }).notNull().references(() => users.userId),
	examVersionId: int("exam_version_id").notNull().references(() => examVersions.examVersionId),
	totalAttempts: int("total_attempts").default(0),
	bestScore: decimal("best_score", { precision: 5, scale: 2 }).default('0.00'),
	latestScore: decimal("latest_score", { precision: 5, scale: 2 }).default('0.00'),
	createdAt: timestamp("created_at", { mode: 'string' }).defaultNow(),
	updatedAt: timestamp("updated_at", { mode: 'string' }).defaultNow().onUpdateNow(),
},
(table) => [
	primaryKey({ columns: [table.analyticsId], name: "exam_version_analytics_analytics_id"}),
	unique("uq_user_version").on(table.userId, table.examVersionId),
]);

export const examVersionUnlockRules = mysqlTable("exam_version_unlock_rules", {
	ruleId: bigint("rule_id", { mode: "number" }).autoincrement().notNull(),
	subjectId: int("subject_id").notNull(),
	attemptType: mysqlEnum("attempt_type", ['PRACTICE','FINAL']).notNull(),
	examVersionId: int("exam_version_id").notNull().references(() => examVersions.examVersionId),
	unlockType: mysqlEnum("unlock_type", ['AFTER_DAYS','AFTER_VERSION','AFTER_SCORE','MANUAL']).notNull(),
	unlockValue: int("unlock_value"),
	createdAt: timestamp("created_at", { mode: 'string' }).defaultNow(),
},
(table) => [
	primaryKey({ columns: [table.ruleId], name: "exam_version_unlock_rules_rule_id"}),
]);

export const examVersionUnlocks = mysqlTable("exam_version_unlocks", {
	unlockId: int("unlock_id").autoincrement().notNull(),
	fromVersionId: int("from_version_id").notNull().references(() => examVersions.examVersionId),
	toVersionId: int("to_version_id").notNull().references(() => examVersions.examVersionId),
	minScore: decimal("min_score", { precision: 5, scale: 2 }).notNull(),
	createdAt: timestamp("created_at", { mode: 'string' }).defaultNow(),
},
(table) => [
	primaryKey({ columns: [table.unlockId], name: "exam_version_unlocks_unlock_id"}),
]);

export const examVersionUserProgress = mysqlTable("exam_version_user_progress", {
	progressId: bigint("progress_id", { mode: "number" }).autoincrement().notNull(),
	userId: bigint("user_id", { mode: "number" }).notNull().references(() => users.userId),
	subjectId: int("subject_id").notNull(),
	attemptType: mysqlEnum("attempt_type", ['PRACTICE','FINAL']).notNull(),
	examVersionId: int("exam_version_id").notNull().references(() => examVersions.examVersionId),
	unlockedAt: datetime("unlocked_at", { mode: 'string'}).default(sql`(CURRENT_TIMESTAMP)`).notNull(),
	unlockedBy: mysqlEnum("unlocked_by", ['SYSTEM','ADMIN']).default('SYSTEM').notNull(),
	isCurrent: tinyint("is_current").default(1).notNull(),
	createdAt: timestamp("created_at", { mode: 'string' }).defaultNow(),
},
(table) => [
	index("idx_progress_current").on(table.userId, table.isCurrent),
	primaryKey({ columns: [table.progressId], name: "exam_version_user_progress_progress_id"}),
	unique("uq_user_current_version").on(table.userId, table.subjectId, table.attemptType, table.isCurrent),
]);

export const examVersions = mysqlTable("exam_versions", {
	examVersionId: int("exam_version_id").autoincrement().notNull(),
	subjectId: int("subject_id").notNull().references(() => subjects.subjectId),
	attemptType: mysqlEnum("attempt_type", ['PRACTICE','FINAL']).notNull(),
	versionNo: int("version_no").notNull(),
	versionLabel: varchar("version_label", { length: 50 }),
	isActive: tinyint("is_active").default(1),
	releasedAt: datetime("released_at", { mode: 'string'}).default(sql`(CURRENT_TIMESTAMP)`).notNull(),
	// you can use { mode: 'date' }, if you want to have Date as type for this column
	retiredAt: date("retired_at", { mode: 'string' }),
	createdAt: timestamp("created_at", { mode: 'string' }).defaultNow(),
},
(table) => [
	primaryKey({ columns: [table.examVersionId], name: "exam_versions_exam_version_id"}),
	unique("uq_subject_version").on(table.subjectId, table.attemptType, table.versionNo),
]);

export const mockPreboardExams = mysqlTable("mock_preboard_exams", {
	examId: bigint("exam_id", { mode: "number" }).autoincrement().notNull(),
	subjectId: int("subject_id").notNull().references(() => subjects.subjectId),
	examName: varchar("exam_name", { length: 100 }).notNull(),
	examDescription: text("exam_description"),
	totalQuestions: int("total_questions").default(100),
	timeLimitMinutes: int("time_limit_minutes").default(180),
	passingScorePercent: decimal("passing_score_percent", { precision: 5, scale: 2 }).default('75.00'),
	accessLevel: mysqlEnum("access_level", ['ADVANCE']).default('ADVANCE'),
	isActive: tinyint("is_active").default(1),
	createdAt: timestamp("created_at", { mode: 'string' }).defaultNow(),
},
(table) => [
	index("subject_id").on(table.subjectId),
	primaryKey({ columns: [table.examId], name: "mock_preboard_exams_exam_id"}),
]);

export const paymentProviderConfigs = mysqlTable("payment_provider_configs", {
	providerId: int("provider_id").autoincrement().notNull(),
	providerCode: mysqlEnum("provider_code", ['GCASH','PAYMAYA','BANK_TRANSFER','PAYPAL','STRIPE']).notNull(),
	providerName: varchar("provider_name", { length: 50 }).notNull(),
	isActive: tinyint("is_active").default(1),
	displayOrder: int("display_order").default(0),
	config: json(),
	instructions: text(),
	iconUrl: varchar("icon_url", { length: 255 }),
	createdAt: timestamp("created_at", { mode: 'string' }).defaultNow(),
},
(table) => [
	primaryKey({ columns: [table.providerId], name: "payment_provider_configs_provider_id"}),
	unique("provider_code").on(table.providerCode),
]);

export const paymentTransactions = mysqlTable("payment_transactions", {
	paymentId: bigint("payment_id", { mode: "number" }).autoincrement().notNull(),
	userId: bigint("user_id", { mode: "number" }).notNull().references(() => users.userId),
	subscriptionId: bigint("subscription_id", { mode: "number" }),
	amount: decimal({ precision: 10, scale: 2 }).notNull(),
	currency: varchar({ length: 10 }).default('PHP'),
	paymentMethod: mysqlEnum("payment_method", ['GCASH','PAYMAYA','CARD','PAYPAL']).notNull(),
	paymentStatus: mysqlEnum("payment_status", ['PENDING','SUCCESS','FAILED']).notNull(),
	isRefunded: tinyint("is_refunded").default(0),
	refundedAt: timestamp("refunded_at", { mode: 'string' }),
	refundAmount: decimal("refund_amount", { precision: 10, scale: 2 }),
	refundReason: varchar("refund_reason", { length: 255 }),
	transactionRef: varchar("transaction_ref", { length: 100 }),
	paymentProviderRef: varchar("payment_provider_ref", { length: 255 }),
	webhookData: json("webhook_data"),
	paidAt: datetime("paid_at", { mode: 'string'}),
	createdAt: datetime("created_at", { mode: 'string'}).default(sql`(CURRENT_TIMESTAMP)`),
},
(table) => [
	index("idx_payment_date").on(table.paidAt),
	index("idx_provider_ref").on(table.paymentProviderRef),
	index("idx_subscription").on(table.subscriptionId),
	index("user_id").on(table.userId),
	primaryKey({ columns: [table.paymentId], name: "payment_transactions_payment_id"}),
]);

export const paymentTransactionsNew = mysqlTable("payment_transactions_new", {
	transactionId: bigint("transaction_id", { mode: "number" }).autoincrement().notNull(),
	userId: bigint("user_id", { mode: "number" }).notNull().references(() => users.userId),
	planId: int("plan_id").notNull().references(() => subscriptionPlans.planId),
	amountPhp: decimal("amount_php", { precision: 10, scale: 2 }).notNull(),
	discountAmount: decimal("discount_amount", { precision: 10, scale: 2 }).default('0.00'),
	finalAmount: decimal("final_amount", { precision: 10, scale: 2 }).notNull(),
	paymentProvider: mysqlEnum("payment_provider", ['GCASH','PAYMAYA','BANK_TRANSFER','PAYPAL','STRIPE','MANUAL']).notNull(),
	paymentMethodDetails: json("payment_method_details"),
	internalReference: varchar("internal_reference", { length: 50 }).notNull(),
	externalReference: varchar("external_reference", { length: 100 }),
	status: mysqlEnum(['PENDING','PROCESSING','COMPLETED','FAILED','REFUNDED','CANCELLED']).default('PENDING'),
	statusMessage: text("status_message"),
	// you can use { mode: 'date' }, if you want to have Date as type for this column
	subscriptionStart: date("subscription_start", { mode: 'string' }),
	// you can use { mode: 'date' }, if you want to have Date as type for this column
	subscriptionEnd: date("subscription_end", { mode: 'string' }),
	createdAt: timestamp("created_at", { mode: 'string' }).defaultNow(),
	updatedAt: timestamp("updated_at", { mode: 'string' }).defaultNow().onUpdateNow(),
	completedAt: timestamp("completed_at", { mode: 'string' }),
},
(table) => [
	index("idx_provider").on(table.paymentProvider),
	index("idx_reference").on(table.internalReference),
	index("idx_status").on(table.status),
	index("idx_user_transactions").on(table.userId),
	index("plan_id").on(table.planId),
	primaryKey({ columns: [table.transactionId], name: "payment_transactions_new_transaction_id"}),
	unique("internal_reference").on(table.internalReference),
]);

export const practiceSets = mysqlTable("practice_sets", {
	practiceSetId: int("practice_set_id").autoincrement().notNull(),
	topicId: int("topic_id").notNull().references(() => topics.topicId, { onDelete: "restrict", onUpdate: "cascade" } ),
	setCode: varchar("set_code", { length: 50 }).notNull(),
	setName: varchar("set_name", { length: 255 }).notNull(),
	setType: mysqlEnum("set_type", ['PRACTICE','FINAL']).notNull(),
	isPaid: tinyint("is_paid").default(0),
	displayOrder: int("display_order"),
	isActive: tinyint("is_active").default(1),
	createdAt: timestamp("created_at", { mode: 'string' }).defaultNow(),
	questionsPerSet: int("questions_per_set").default(50),
	accessLevel: mysqlEnum("access_level", ['FREE','BASIC','ADVANCE']).default('FREE'),
},
(table) => [
	primaryKey({ columns: [table.practiceSetId], name: "practice_sets_practice_set_id"}),
	unique("uq_topic_set").on(table.topicId, table.setCode),
]);

export const promoCodes = mysqlTable("promo_codes", {
	promoId: int("promo_id").autoincrement().notNull(),
	code: varchar({ length: 20 }).notNull(),
	description: varchar({ length: 255 }),
	discountType: mysqlEnum("discount_type", ['PERCENTAGE','FIXED_AMOUNT']).notNull(),
	discountValue: decimal("discount_value", { precision: 10, scale: 2 }).notNull(),
	minPurchase: decimal("min_purchase", { precision: 10, scale: 2 }).default('0.00'),
	maxUses: int("max_uses"),
	timesUsed: int("times_used").default(0),
	// you can use { mode: 'date' }, if you want to have Date as type for this column
	validFrom: date("valid_from", { mode: 'string' }),
	// you can use { mode: 'date' }, if you want to have Date as type for this column
	validUntil: date("valid_until", { mode: 'string' }),
	applicablePlans: json("applicable_plans"),
	isActive: tinyint("is_active").default(1),
	createdAt: timestamp("created_at", { mode: 'string' }).defaultNow(),
},
(table) => [
	primaryKey({ columns: [table.promoId], name: "promo_codes_promo_id"}),
	unique("code").on(table.code),
]);

export const questionChoices = mysqlTable("question_choices", {
	choiceId: bigint("choice_id", { mode: "number" }).autoincrement().notNull(),
	questionId: bigint("question_id", { mode: "number" }).notNull().references(() => questions.questionId, { onDelete: "cascade" } ),
	choiceText: longtext("choice_text").notNull(),
	isCorrect: tinyint("is_correct").default(0),
	whyWrong: text("why_wrong"),
	isActive: tinyint("is_active").default(1),
	displayOrder: int("display_order"),
	createdAt: timestamp("created_at", { mode: 'string' }).defaultNow(),
},
(table) => [
	index("idx_question_id").on(table.questionId),
	primaryKey({ columns: [table.choiceId], name: "question_choices_choice_id"}),
]);

export const questionExplanations = mysqlTable("question_explanations", {
	explanationId: bigint("explanation_id", { mode: "number" }).autoincrement().notNull(),
	questionId: bigint("question_id", { mode: "number" }).notNull().references(() => questions.questionId, { onDelete: "cascade" } ),
	shortExplanation: text("short_explanation").notNull(),
	examExplanation: longtext("exam_explanation"),
	whyWrongChoices: longtext("why_wrong_choices"),
	memoryTip: varchar("memory_tip", { length: 255 }),
	referenceId: bigint("reference_id", { mode: "number" }),
	isActive: tinyint("is_active").default(1),
	createdAt: timestamp("created_at", { mode: 'string' }).defaultNow(),
	updatedAt: timestamp("updated_at", { mode: 'string' }).defaultNow().onUpdateNow(),
	explanationLevel: mysqlEnum("explanation_level", ['HOOK','EXAM','DEEP']).default('EXAM'),
},
(table) => [
	primaryKey({ columns: [table.explanationId], name: "question_explanations_explanation_id"}),
	unique("uq_question_explanation").on(table.questionId),
]);

export const questions = mysqlTable("questions", {
	questionId: bigint("question_id", { mode: "number" }).autoincrement().notNull(),
	practiceSetId: int("practice_set_id").notNull().references(() => practiceSets.practiceSetId, { onDelete: "restrict", onUpdate: "cascade" } ),
	questionCode: varchar("question_code", { length: 50 }).notNull(),
	questionText: longtext("question_text").notNull(),
	difficultyLevel: mysqlEnum("difficulty_level", ['EASY','MEDIUM','HARD']).default('MEDIUM'),
	isActive: tinyint("is_active").default(1),
	createdAt: timestamp("created_at", { mode: 'string' }).defaultNow(),
	updatedAt: timestamp("updated_at", { mode: 'string' }).defaultNow().onUpdateNow(),
	isPaid: tinyint("is_paid").default(0),
	accessLevel: mysqlEnum("access_level", ['FREE','BASIC','PRO','PREMIUM']).default('FREE'),
	qualityScore: decimal("quality_score", { precision: 3, scale: 2 }).default('0.00'),
	timesAnswered: int("times_answered").default(0),
	avgTimeSeconds: int("avg_time_seconds").default(0),
	percentCorrect: decimal("percent_correct", { precision: 5, scale: 2 }).default('0.00'),
	topicId: int("topic_id").notNull().references(() => topics.topicId),
},
(table) => [
	index("idx_access_level").on(table.accessLevel, table.isActive),
	primaryKey({ columns: [table.questionId], name: "questions_question_id"}),
	unique("uq_practice_question").on(table.practiceSetId, table.questionCode),
]);

export const referenceSources = mysqlTable("reference_sources", {
	referenceId: bigint("reference_id", { mode: "number" }).autoincrement().notNull(),
	referenceType: mysqlEnum("reference_type", ['IFRS','IAS','PRC_SYLLABUS','TAX_CODE','BIR_RR','CASE_LAW','OTHER']).notNull(),
	referenceCode: varchar("reference_code", { length: 100 }),
	referenceTitle: varchar("reference_title", { length: 255 }).notNull(),
	referenceUrl: text("reference_url"),
	notes: text(),
	isActive: tinyint("is_active").default(1),
	createdAt: timestamp("created_at", { mode: 'string' }).defaultNow(),
},
(table) => [
	primaryKey({ columns: [table.referenceId], name: "reference_sources_reference_id"}),
]);

export const subjectExamSettings = mysqlTable("subject_exam_settings", {
	subjectId: int("subject_id").notNull(),
	finalTimeMinutes: int("final_time_minutes").notNull(),
	practiceTimePerQuestion: int("practice_time_per_question").default(1).notNull(),
	createdAt: datetime("created_at", { mode: 'string'}).default(sql`(CURRENT_TIMESTAMP)`),
},
(table) => [
	primaryKey({ columns: [table.subjectId], name: "subject_exam_settings_subject_id"}),
]);

export const subjects = mysqlTable("subjects", {
	subjectId: int("subject_id").autoincrement().notNull(),
	syllabusId: int("syllabus_id").notNull().references(() => syllabusVersions.syllabusId),
	subjectCode: varchar("subject_code", { length: 10 }).notNull(),
	subjectName: varchar("subject_name", { length: 150 }).notNull(),
	displayOrder: int("display_order"),
	isActive: tinyint("is_active").default(1),
	createdAt: timestamp("created_at", { mode: 'string' }).defaultNow(),
},
(table) => [
	primaryKey({ columns: [table.subjectId], name: "subjects_subject_id"}),
	unique("uq_syllabus_subject").on(table.syllabusId, table.subjectCode),
]);

export const subscriptionPlans = mysqlTable("subscription_plans", {
	planId: int("plan_id").autoincrement().notNull(),
	planCode: varchar("plan_code", { length: 20 }).notNull(),
	planName: varchar("plan_name", { length: 100 }).notNull(),
	planDescription: text("plan_description"),
	billingPeriod: mysqlEnum("billing_period", ['MONTHLY','SEMI_ANNUAL','ANNUAL','LIFETIME']).notNull(),
	pricePhp: decimal("price_php", { precision: 10, scale: 2 }).notNull(),
	originalPricePhp: decimal("original_price_php", { precision: 10, scale: 2 }),
	mcqLimit: int("mcq_limit"),
	features: json(),
	isActive: tinyint("is_active").default(1),
	displayOrder: int("display_order").default(0),
	createdAt: timestamp("created_at", { mode: 'string' }).defaultNow(),
},
(table) => [
	primaryKey({ columns: [table.planId], name: "subscription_plans_plan_id"}),
	unique("plan_code").on(table.planCode),
]);

export const syllabusTopics = mysqlTable("syllabus_topics", {
	syllabusTopicId: bigint("syllabus_topic_id", { mode: "number" }).autoincrement().notNull(),
	syllabusId: int("syllabus_id").notNull().references(() => syllabusVersions.syllabusId, { onDelete: "restrict", onUpdate: "cascade" } ),
	topicId: int("topic_id").notNull().references(() => topics.topicId, { onDelete: "restrict", onUpdate: "cascade" } ),
	isActive: tinyint("is_active").default(1),
	displayOrder: int("display_order"),
	createdAt: timestamp("created_at", { mode: 'string' }).defaultNow(),
},
(table) => [
	primaryKey({ columns: [table.syllabusTopicId], name: "syllabus_topics_syllabus_topic_id"}),
	unique("uq_syllabus_topic").on(table.syllabusId, table.topicId),
]);

export const syllabusVersions = mysqlTable("syllabus_versions", {
	syllabusId: int("syllabus_id").autoincrement().notNull(),
	syllabusCode: varchar("syllabus_code", { length: 20 }).notNull(),
	description: varchar({ length: 255 }),
	effectiveYear: int("effective_year").notNull(),
	isActive: tinyint("is_active").default(1),
	createdAt: timestamp("created_at", { mode: 'string' }).defaultNow(),
},
(table) => [
	primaryKey({ columns: [table.syllabusId], name: "syllabus_versions_syllabus_id"}),
	unique("syllabus_code").on(table.syllabusCode),
]);

export const topicContent = mysqlTable("topic_content", {
	contentId: bigint("content_id", { mode: "number" }).autoincrement().notNull(),
	topicId: int("topic_id").notNull().references(() => topics.topicId, { onDelete: "cascade" } ),
	contentType: mysqlEnum("content_type", ['VIDEO','PDF','ARTICLE','INFOGRAPHIC','AUDIO']).notNull(),
	title: varchar({ length: 255 }).notNull(),
	description: text(),
	contentUrl: varchar("content_url", { length: 500 }),
	thumbnailUrl: varchar("thumbnail_url", { length: 500 }),
	durationMinutes: int("duration_minutes"),
	fileSizeMb: decimal("file_size_mb", { precision: 10, scale: 2 }),
	accessLevel: mysqlEnum("access_level", ['FREE','BASIC','PRO','PREMIUM']).default('BASIC'),
	displayOrder: int("display_order").default(0),
	viewCount: int("view_count").default(0),
	isFeatured: tinyint("is_featured").default(0),
	isActive: tinyint("is_active").default(1),
	createdAt: timestamp("created_at", { mode: 'string' }).defaultNow(),
	updatedAt: timestamp("updated_at", { mode: 'string' }).defaultNow().onUpdateNow(),
},
(table) => [
	index("idx_content_type").on(table.contentType),
	index("idx_featured").on(table.isFeatured, table.isActive),
	index("idx_topic_content").on(table.topicId, table.isActive),
	primaryKey({ columns: [table.contentId], name: "topic_content_content_id"}),
]);

export const topicVideoLinks = mysqlTable("topic_video_links", {
	videoId: bigint("video_id", { mode: "number" }).autoincrement().notNull(),
	topicId: int("topic_id").notNull().references(() => topics.topicId),
	platform: mysqlEnum(['TIKTOK','YOUTUBE','REELS']).notNull(),
	videoUrl: varchar("video_url", { length: 255 }).notNull(),
	createdAt: datetime("created_at", { mode: 'string'}).default(sql`(CURRENT_TIMESTAMP)`),
},
(table) => [
	index("topic_id").on(table.topicId),
	primaryKey({ columns: [table.videoId], name: "topic_video_links_video_id"}),
]);

export const topics = mysqlTable("topics", {
	topicId: int("topic_id").autoincrement().notNull(),
	subjectId: int("subject_id").notNull().references(() => subjects.subjectId, { onDelete: "restrict", onUpdate: "cascade" } ),
	topicCode: varchar("topic_code", { length: 50 }).notNull(),
	topicName: varchar("topic_name", { length: 255 }).notNull(),
	description: text(),
	displayOrder: int("display_order"),
	isActive: tinyint("is_active").default(1),
	createdAt: timestamp("created_at", { mode: 'string' }).defaultNow(),
},
(table) => [
	primaryKey({ columns: [table.topicId], name: "topics_topic_id"}),
	unique("uq_subject_topic").on(table.subjectId, table.topicCode),
]);

export const userActivityLog = mysqlTable("user_activity_log", {
	activityId: bigint("activity_id", { mode: "number" }).autoincrement().notNull(),
	userId: bigint("user_id", { mode: "number" }).notNull().references(() => users.userId, { onDelete: "cascade" } ),
	activityType: mysqlEnum("activity_type", ['LOGIN','LOGOUT','QUESTION_ANSWERED','QUESTION_SKIPPED','QUESTION_MARKED','EXAM_STARTED','EXAM_PAUSED','EXAM_SUBMITTED','VIDEO_WATCHED','PDF_DOWNLOADED','CONTENT_VIEWED','SUBSCRIPTION_STARTED','SUBSCRIPTION_UPGRADED','SUBSCRIPTION_CANCELLED','PAYMENT_SUCCESS','PAYMENT_FAILED']).notNull(),
	activityData: json("activity_data"),
	ipAddress: varchar("ip_address", { length: 45 }),
	userAgent: text("user_agent"),
	createdAt: timestamp("created_at", { mode: 'string' }).defaultNow(),
},
(table) => [
	index("idx_activity_date").on(table.createdAt),
	index("idx_activity_type").on(table.activityType),
	index("idx_user_activity").on(table.userId, table.activityType),
	primaryKey({ columns: [table.activityId], name: "user_activity_log_activity_id"}),
]);

export const userApiTokens = mysqlTable("user_api_tokens", {
	tokenId: bigint("token_id", { mode: "number" }).autoincrement().notNull(),
	userId: bigint("user_id", { mode: "number" }).notNull().references(() => users.userId),
	apiToken: varchar("api_token", { length: 255 }).notNull(),
	expiresAt: datetime("expires_at", { mode: 'string'}).notNull(),
	isActive: tinyint("is_active").default(1),
	createdAt: datetime("created_at", { mode: 'string'}).default(sql`(CURRENT_TIMESTAMP)`),
},
(table) => [
	index("user_id").on(table.userId),
	primaryKey({ columns: [table.tokenId], name: "user_api_tokens_token_id"}),
	unique("uq_api_token").on(table.apiToken),
]);

export const userDailyActivity = mysqlTable("user_daily_activity", {
	activityId: bigint("activity_id", { mode: "number" }).autoincrement().notNull(),
	userId: bigint("user_id", { mode: "number" }).notNull().references(() => users.userId, { onDelete: "cascade" } ),
	// you can use { mode: 'date' }, if you want to have Date as type for this column
	activityDate: date("activity_date", { mode: 'string' }).notNull(),
	questionsAnswered: int("questions_answered").default(0),
	timeStudiedMinutes: int("time_studied_minutes").default(0),
	topicsPracticed: text("topics_practiced"),
	avgScorePercent: decimal("avg_score_percent", { precision: 5, scale: 2 }).default('0.00'),
},
(table) => [
	index("idx_user_activity_date").on(table.userId, table.activityDate),
	primaryKey({ columns: [table.activityId], name: "user_daily_activity_activity_id"}),
	unique("uq_user_date").on(table.userId, table.activityDate),
]);

export const userExamVersionStatus = mysqlTable("user_exam_version_status", {
	userId: bigint("user_id", { mode: "number" }).notNull().references(() => users.userId),
	examVersionId: int("exam_version_id").notNull().references(() => examVersions.examVersionId),
	isUnlocked: tinyint("is_unlocked").default(0),
	unlockedAt: timestamp("unlocked_at", { mode: 'string' }),
	isCompleted: tinyint("is_completed").default(0),
	completedAt: timestamp("completed_at", { mode: 'string' }),
},
(table) => [
	primaryKey({ columns: [table.userId, table.examVersionId], name: "user_exam_version_status_user_id_exam_version_id"}),
]);

export const userMockAttempts = mysqlTable("user_mock_attempts", {
	attemptId: bigint("attempt_id", { mode: "number" }).autoincrement().notNull(),
	userId: bigint("user_id", { mode: "number" }).notNull().references(() => users.userId),
	examId: bigint("exam_id", { mode: "number" }).notNull().references(() => mockPreboardExams.examId),
	startedAt: timestamp("started_at", { mode: 'string' }).notNull(),
	endedAt: timestamp("ended_at", { mode: 'string' }),
	timeSpentSeconds: int("time_spent_seconds").default(0),
	totalQuestions: int("total_questions").notNull(),
	correctAnswers: int("correct_answers").default(0),
	wrongAnswers: int("wrong_answers").default(0),
	unanswered: int().default(0),
	scorePercent: decimal("score_percent", { precision: 5, scale: 2 }).default('0.00'),
	passed: tinyint().default(0),
	status: mysqlEnum(['IN_PROGRESS','COMPLETED','TIMED_OUT','ABANDONED']).default('IN_PROGRESS'),
	answers: json(),
	createdAt: timestamp("created_at", { mode: 'string' }).defaultNow(),
},
(table) => [
	index("exam_id").on(table.examId),
	index("user_id").on(table.userId),
	primaryKey({ columns: [table.attemptId], name: "user_mock_attempts_attempt_id"}),
]);

export const userReferrals = mysqlTable("user_referrals", {
	referralId: bigint("referral_id", { mode: "number" }).autoincrement().notNull(),
	referrerUserId: bigint("referrer_user_id", { mode: "number" }).notNull().references(() => users.userId, { onDelete: "cascade" } ),
	referredUserId: bigint("referred_user_id", { mode: "number" }).references(() => users.userId, { onDelete: "set null" } ),
	referralCode: varchar("referral_code", { length: 20 }).notNull(),
	referredEmail: varchar("referred_email", { length: 255 }),
	status: mysqlEnum(['PENDING','REGISTERED','CONVERTED','EXPIRED']).default('PENDING'),
	clickedAt: timestamp("clicked_at", { mode: 'string' }),
	registeredAt: timestamp("registered_at", { mode: 'string' }),
	convertedAt: timestamp("converted_at", { mode: 'string' }),
	referrerRewardType: mysqlEnum("referrer_reward_type", ['DISCOUNT','FREE_MONTH','CREDITS','NONE']).default('NONE'),
	referrerRewardValue: decimal("referrer_reward_value", { precision: 10, scale: 2 }).default('0.00'),
	referrerRewardClaimed: tinyint("referrer_reward_claimed").default(0),
	referredRewardType: mysqlEnum("referred_reward_type", ['DISCOUNT','FREE_MONTH','CREDITS','NONE']).default('NONE'),
	referredRewardValue: decimal("referred_reward_value", { precision: 10, scale: 2 }).default('0.00'),
	source: varchar({ length: 50 }),
	createdAt: timestamp("created_at", { mode: 'string' }).defaultNow(),
},
(table) => [
	index("idx_referral_code").on(table.referralCode),
	index("idx_referrer").on(table.referrerUserId),
	index("idx_status").on(table.status),
	index("referred_user_id").on(table.referredUserId),
	primaryKey({ columns: [table.referralId], name: "user_referrals_referral_id"}),
	unique("referral_code").on(table.referralCode),
]);

export const userStreaks = mysqlTable("user_streaks", {
	streakId: bigint("streak_id", { mode: "number" }).autoincrement().notNull(),
	userId: bigint("user_id", { mode: "number" }).notNull().references(() => users.userId),
	subjectId: int("subject_id").notNull(),
	currentStreak: int("current_streak").default(0).notNull(),
	longestStreak: int("longest_streak").default(0).notNull(),
	// you can use { mode: 'date' }, if you want to have Date as type for this column
	bestStreakStartDate: date("best_streak_start_date", { mode: 'string' }),
	// you can use { mode: 'date' }, if you want to have Date as type for this column
	bestStreakEndDate: date("best_streak_end_date", { mode: 'string' }),
	totalStudyDays: int("total_study_days").default(0),
	// you can use { mode: 'date' }, if you want to have Date as type for this column
	lastActivityDate: date("last_activity_date", { mode: 'string' }),
	updatedAt: datetime("updated_at", { mode: 'string'}).default(sql`(CURRENT_TIMESTAMP)`),
},
(table) => [
	primaryKey({ columns: [table.streakId], name: "user_streaks_streak_id"}),
	unique("uq_user_subject_streak").on(table.userId, table.subjectId),
]);

export const userStudyPlan = mysqlTable("user_study_plan", {
	planId: bigint("plan_id", { mode: "number" }).autoincrement().notNull(),
	userId: bigint("user_id", { mode: "number" }).notNull(),
	subjectId: int("subject_id").notNull(),
	focusTopicId: int("focus_topic_id").notNull().references(() => topics.topicId),
	priorityLevel: mysqlEnum("priority_level", ['LOW','MEDIUM','HIGH']).notNull(),
	recommendedAction: varchar("recommended_action", { length: 255 }),
	recommendedVideoUrl: varchar("recommended_video_url", { length: 255 }),
	createdAt: datetime("created_at", { mode: 'string'}).default(sql`(CURRENT_TIMESTAMP)`),
},
(table) => [
	index("focus_topic_id").on(table.focusTopicId),
	primaryKey({ columns: [table.planId], name: "user_study_plan_plan_id"}),
]);

export const userSubscriptions = mysqlTable("user_subscriptions", {
	subscriptionId: bigint("subscription_id", { mode: "number" }).autoincrement().notNull(),
	userId: bigint("user_id", { mode: "number" }).notNull().references(() => users.userId),
	planType: mysqlEnum("plan_type", ['FREE','PAID']).default('FREE').notNull(),
	subscriptionStatus: mysqlEnum("subscription_status", ['TRIAL','ACTIVE','EXPIRED','CANCELLED','PAYMENT_FAILED']).default('TRIAL').notNull(),
	// you can use { mode: 'date' }, if you want to have Date as type for this column
	startDate: date("start_date", { mode: 'string' }).notNull(),
	// you can use { mode: 'date' }, if you want to have Date as type for this column
	endDate: date("end_date", { mode: 'string' }),
	trialEndsAt: datetime("trial_ends_at", { mode: 'string'}),
	nextBillingDate: datetime("next_billing_date", { mode: 'string'}),
	autoRenew: tinyint("auto_renew").default(1),
	cancelledAt: datetime("cancelled_at", { mode: 'string'}),
	paymentMethod: mysqlEnum("payment_method", ['GCASH','PAYMAYA','CARD','BANK']),
	lastPaymentDate: datetime("last_payment_date", { mode: 'string'}),
	gracePeriodEndsAt: datetime("grace_period_ends_at", { mode: 'string'}),
	isActive: tinyint("is_active").default(1).notNull(),
	createdAt: datetime("created_at", { mode: 'string'}).default(sql`(CURRENT_TIMESTAMP)`),
	updatedAt: datetime("updated_at", { mode: 'string'}).default(sql`(CURRENT_TIMESTAMP)`),
	planId: int("plan_id"),
	billingPeriod: mysqlEnum("billing_period", ['MONTHLY','SEMI_ANNUAL','ANNUAL','LIFETIME']).default('MONTHLY'),
	amountPaid: decimal("amount_paid", { precision: 10, scale: 2 }).default('0.00'),
	paymentReference: varchar("payment_reference", { length: 100 }),
	paymentProvider: mysqlEnum("payment_provider", ['GCASH','PAYMAYA','BANK_TRANSFER','PAYPAL','STRIPE','MANUAL']),
},
(table) => [
	index("idx_next_billing").on(table.nextBillingDate),
	index("idx_subscription_status").on(table.subscriptionStatus),
	index("idx_trial_ends").on(table.trialEndsAt),
	primaryKey({ columns: [table.subscriptionId], name: "user_subscriptions_subscription_id"}),
	unique("uq_user_active_subscription").on(table.userId, table.isActive),
]);

export const userTopicWeakness = mysqlTable("user_topic_weakness", {
	weaknessId: bigint("weakness_id", { mode: "number" }).autoincrement().notNull(),
	userId: bigint("user_id", { mode: "number" }).notNull(),
	subjectId: int("subject_id").notNull(),
	topicId: int("topic_id").notNull().references(() => topics.topicId),
	totalQuestions: int("total_questions").notNull(),
	wrongAnswers: int("wrong_answers").notNull(),
	weaknessScore: decimal("weakness_score", { precision: 5, scale: 2 }).generatedAlwaysAs(sql`((\`wrong_answers\` / \`total_questions\`) * 100)`, { mode: "stored" }),
	lastUpdated: datetime("last_updated", { mode: 'string'}).default(sql`(CURRENT_TIMESTAMP)`),
},
(table) => [
	index("idx_weakness_user").on(table.userId),
	index("topic_id").on(table.topicId),
	primaryKey({ columns: [table.weaknessId], name: "user_topic_weakness_weakness_id"}),
	unique("uq_user_topic").on(table.userId, table.topicId),
]);

export const users = mysqlTable("users", {
	userId: bigint("user_id", { mode: "number" }).autoincrement().notNull(),
	email: varchar({ length: 255 }),
	displayName: varchar("display_name", { length: 100 }),
	userType: mysqlEnum("user_type", ['FREE','PAID','ADMIN']).default('FREE'),
	isActive: tinyint("is_active").default(1),
	isFlagged: tinyint("is_flagged").default(0),
	flagReason: varchar("flag_reason", { length: 255 }),
	adminNotes: text("admin_notes"),
	lastLoginAt: timestamp("last_login_at", { mode: 'string' }),
	loginCount: int("login_count").default(0),
	createdAt: timestamp("created_at", { mode: 'string' }).defaultNow(),
	isPaid: tinyint("is_paid").default(0).notNull(),
},
(table) => [
	index("idx_flagged").on(table.isFlagged),
	index("idx_last_login").on(table.lastLoginAt),
	primaryKey({ columns: [table.userId], name: "users_user_id"}),
	unique("email").on(table.email),
]);
export const vwUserExamSummary = mysqlView("vw_user_exam_summary", {
	userId: bigint("user_id", { mode: "number" }).notNull(),
	subjectId: int("subject_id"),
	attempts: bigint({ mode: "number" }).notNull(),
	avgScore: decimal("avg_score", { precision: 9, scale: 6 }),
	bestScore: decimal("best_score", { precision: 5, scale: 2 }),
}).algorithm("undefined").sqlSecurity("definer").as(sql`select \`cpale_explained\`.\`exam_attempts\`.\`user_id\` AS \`user_id\`,\`cpale_explained\`.\`exam_attempts\`.\`subject_id\` AS \`subject_id\`,count(0) AS \`attempts\`,avg(\`cpale_explained\`.\`exam_attempts\`.\`score_percent\`) AS \`avg_score\`,max(\`cpale_explained\`.\`exam_attempts\`.\`score_percent\`) AS \`best_score\` from \`cpale_explained\`.\`exam_attempts\` where (\`cpale_explained\`.\`exam_attempts\`.\`is_valid\` = 1) group by \`cpale_explained\`.\`exam_attempts\`.\`user_id\`,\`cpale_explained\`.\`exam_attempts\`.\`subject_id\``);

export const vwWeeklyUserProgress = mysqlView("vw_weekly_user_progress", {
	userId: bigint("user_id", { mode: "number" }).notNull(),
	subjectId: int("subject_id"),
	attemptType: mysqlEnum("attempt_type", ['PRACTICE','FINAL']).notNull(),
	versionNo: int("version_no").notNull(),
	versionLabel: varchar("version_label", { length: 50 }),
	attemptsCount: bigint("attempts_count", { mode: "number" }).notNull(),
	avgScore: decimal("avg_score", { precision: 9, scale: 6 }),
	bestScore: decimal("best_score", { precision: 5, scale: 2 }),
	worstScore: decimal("worst_score", { precision: 5, scale: 2 }),
	weekNo: int("week_no"),
	yearNo: int("year_no"),
}).algorithm("undefined").sqlSecurity("definer").as(sql`select \`ea\`.\`user_id\` AS \`user_id\`,\`ea\`.\`subject_id\` AS \`subject_id\`,\`ev\`.\`attempt_type\` AS \`attempt_type\`,\`ev\`.\`version_no\` AS \`version_no\`,\`ev\`.\`version_label\` AS \`version_label\`,count(\`ea\`.\`attempt_id\`) AS \`attempts_count\`,avg(\`ea\`.\`score_percent\`) AS \`avg_score\`,max(\`ea\`.\`score_percent\`) AS \`best_score\`,min(\`ea\`.\`score_percent\`) AS \`worst_score\`,week(\`ea\`.\`submitted_at\`,0) AS \`week_no\`,year(\`ea\`.\`submitted_at\`) AS \`year_no\` from (\`cpale_explained\`.\`exam_attempts\` \`ea\` join \`cpale_explained\`.\`exam_versions\` \`ev\` on((\`ev\`.\`exam_version_id\` = \`ea\`.\`exam_version_id\`))) where (\`ea\`.\`is_valid\` = 1) group by \`ea\`.\`user_id\`,\`ea\`.\`subject_id\`,\`ev\`.\`attempt_type\`,\`ev\`.\`version_no\`,\`week_no\`,\`year_no\``);