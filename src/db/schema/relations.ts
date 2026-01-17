import { relations } from "drizzle-orm/relations";
import { examAttempts, attemptAnswers, questionChoices, questions, emailCampaigns, emailCampaignSends, emailSubscribers, users, examAttemptAnalytics, examAttemptQuestions, practiceSets, examVersions, examSessionCache, examVersionAnalytics, examVersionUnlockRules, examVersionUnlocks, examVersionUserProgress, subjects, mockPreboardExams, paymentTransactions, paymentTransactionsNew, subscriptionPlans, topics, questionExplanations, syllabusVersions, syllabusTopics, topicContent, topicVideoLinks, userActivityLog, userApiTokens, userDailyActivity, userExamVersionStatus, userMockAttempts, userReferrals, userStreaks, userStudyPlan, userSubscriptions, userTopicWeakness } from "./schema";

export const attemptAnswersRelations = relations(attemptAnswers, ({one}) => ({
	examAttempt: one(examAttempts, {
		fields: [attemptAnswers.attemptId],
		references: [examAttempts.attemptId]
	}),
	questionChoice: one(questionChoices, {
		fields: [attemptAnswers.choiceId],
		references: [questionChoices.choiceId]
	}),
	question: one(questions, {
		fields: [attemptAnswers.questionId],
		references: [questions.questionId]
	}),
}));

export const examAttemptsRelations = relations(examAttempts, ({one, many}) => ({
	attemptAnswers: many(attemptAnswers),
	examAttemptAnalytics: many(examAttemptAnalytics),
	examAttemptQuestions: many(examAttemptQuestions),
	practiceSet: one(practiceSets, {
		fields: [examAttempts.practiceSetId],
		references: [practiceSets.practiceSetId]
	}),
	user: one(users, {
		fields: [examAttempts.userId],
		references: [users.userId]
	}),
	examVersion: one(examVersions, {
		fields: [examAttempts.examVersionId],
		references: [examVersions.examVersionId]
	}),
	examSessionCaches: many(examSessionCache),
}));

export const questionChoicesRelations = relations(questionChoices, ({one, many}) => ({
	attemptAnswers: many(attemptAnswers),
	question: one(questions, {
		fields: [questionChoices.questionId],
		references: [questions.questionId]
	}),
}));

export const questionsRelations = relations(questions, ({one, many}) => ({
	attemptAnswers: many(attemptAnswers),
	examAttemptQuestions: many(examAttemptQuestions),
	questionChoices: many(questionChoices),
	questionExplanations: many(questionExplanations),
	practiceSet: one(practiceSets, {
		fields: [questions.practiceSetId],
		references: [practiceSets.practiceSetId]
	}),
	topic: one(topics, {
		fields: [questions.topicId],
		references: [topics.topicId]
	}),
}));

export const emailCampaignSendsRelations = relations(emailCampaignSends, ({one}) => ({
	emailCampaign: one(emailCampaigns, {
		fields: [emailCampaignSends.campaignId],
		references: [emailCampaigns.campaignId]
	}),
	emailSubscriber: one(emailSubscribers, {
		fields: [emailCampaignSends.subscriberId],
		references: [emailSubscribers.subscriberId]
	}),
}));

export const emailCampaignsRelations = relations(emailCampaigns, ({many}) => ({
	emailCampaignSends: many(emailCampaignSends),
}));

export const emailSubscribersRelations = relations(emailSubscribers, ({one, many}) => ({
	emailCampaignSends: many(emailCampaignSends),
	user: one(users, {
		fields: [emailSubscribers.userId],
		references: [users.userId]
	}),
}));

export const usersRelations = relations(users, ({many}) => ({
	emailSubscribers: many(emailSubscribers),
	examAttempts: many(examAttempts),
	examVersionAnalytics: many(examVersionAnalytics),
	examVersionUserProgresses: many(examVersionUserProgress),
	paymentTransactions: many(paymentTransactions),
	paymentTransactionsNews: many(paymentTransactionsNew),
	userActivityLogs: many(userActivityLog),
	userApiTokens: many(userApiTokens),
	userDailyActivities: many(userDailyActivity),
	userExamVersionStatuses: many(userExamVersionStatus),
	userMockAttempts: many(userMockAttempts),
	userReferrals_referrerUserId: many(userReferrals, {
		relationName: "userReferrals_referrerUserId_users_userId"
	}),
	userReferrals_referredUserId: many(userReferrals, {
		relationName: "userReferrals_referredUserId_users_userId"
	}),
	userStreaks: many(userStreaks),
	userSubscriptions: many(userSubscriptions),
}));

export const examAttemptAnalyticsRelations = relations(examAttemptAnalytics, ({one}) => ({
	examAttempt: one(examAttempts, {
		fields: [examAttemptAnalytics.attemptId],
		references: [examAttempts.attemptId]
	}),
}));

export const examAttemptQuestionsRelations = relations(examAttemptQuestions, ({one}) => ({
	examAttempt: one(examAttempts, {
		fields: [examAttemptQuestions.attemptId],
		references: [examAttempts.attemptId]
	}),
	question: one(questions, {
		fields: [examAttemptQuestions.questionId],
		references: [questions.questionId]
	}),
}));

export const practiceSetsRelations = relations(practiceSets, ({one, many}) => ({
	examAttempts: many(examAttempts),
	topic: one(topics, {
		fields: [practiceSets.topicId],
		references: [topics.topicId]
	}),
	questions: many(questions),
}));

export const examVersionsRelations = relations(examVersions, ({one, many}) => ({
	examAttempts: many(examAttempts),
	examVersionAnalytics: many(examVersionAnalytics),
	examVersionUnlockRules: many(examVersionUnlockRules),
	examVersionUnlocks_fromVersionId: many(examVersionUnlocks, {
		relationName: "examVersionUnlocks_fromVersionId_examVersions_examVersionId"
	}),
	examVersionUnlocks_toVersionId: many(examVersionUnlocks, {
		relationName: "examVersionUnlocks_toVersionId_examVersions_examVersionId"
	}),
	examVersionUserProgresses: many(examVersionUserProgress),
	subject: one(subjects, {
		fields: [examVersions.subjectId],
		references: [subjects.subjectId]
	}),
	userExamVersionStatuses: many(userExamVersionStatus),
}));

export const examSessionCacheRelations = relations(examSessionCache, ({one}) => ({
	examAttempt: one(examAttempts, {
		fields: [examSessionCache.attemptId],
		references: [examAttempts.attemptId]
	}),
}));

export const examVersionAnalyticsRelations = relations(examVersionAnalytics, ({one}) => ({
	user: one(users, {
		fields: [examVersionAnalytics.userId],
		references: [users.userId]
	}),
	examVersion: one(examVersions, {
		fields: [examVersionAnalytics.examVersionId],
		references: [examVersions.examVersionId]
	}),
}));

export const examVersionUnlockRulesRelations = relations(examVersionUnlockRules, ({one}) => ({
	examVersion: one(examVersions, {
		fields: [examVersionUnlockRules.examVersionId],
		references: [examVersions.examVersionId]
	}),
}));

export const examVersionUnlocksRelations = relations(examVersionUnlocks, ({one}) => ({
	examVersion_fromVersionId: one(examVersions, {
		fields: [examVersionUnlocks.fromVersionId],
		references: [examVersions.examVersionId],
		relationName: "examVersionUnlocks_fromVersionId_examVersions_examVersionId"
	}),
	examVersion_toVersionId: one(examVersions, {
		fields: [examVersionUnlocks.toVersionId],
		references: [examVersions.examVersionId],
		relationName: "examVersionUnlocks_toVersionId_examVersions_examVersionId"
	}),
}));

export const examVersionUserProgressRelations = relations(examVersionUserProgress, ({one}) => ({
	user: one(users, {
		fields: [examVersionUserProgress.userId],
		references: [users.userId]
	}),
	examVersion: one(examVersions, {
		fields: [examVersionUserProgress.examVersionId],
		references: [examVersions.examVersionId]
	}),
}));

export const subjectsRelations = relations(subjects, ({one, many}) => ({
	examVersions: many(examVersions),
	mockPreboardExams: many(mockPreboardExams),
	syllabusVersion: one(syllabusVersions, {
		fields: [subjects.syllabusId],
		references: [syllabusVersions.syllabusId]
	}),
	topics: many(topics),
}));

export const mockPreboardExamsRelations = relations(mockPreboardExams, ({one, many}) => ({
	subject: one(subjects, {
		fields: [mockPreboardExams.subjectId],
		references: [subjects.subjectId]
	}),
	userMockAttempts: many(userMockAttempts),
}));

export const paymentTransactionsRelations = relations(paymentTransactions, ({one}) => ({
	user: one(users, {
		fields: [paymentTransactions.userId],
		references: [users.userId]
	}),
}));

export const paymentTransactionsNewRelations = relations(paymentTransactionsNew, ({one}) => ({
	user: one(users, {
		fields: [paymentTransactionsNew.userId],
		references: [users.userId]
	}),
	subscriptionPlan: one(subscriptionPlans, {
		fields: [paymentTransactionsNew.planId],
		references: [subscriptionPlans.planId]
	}),
}));

export const subscriptionPlansRelations = relations(subscriptionPlans, ({many}) => ({
	paymentTransactionsNews: many(paymentTransactionsNew),
}));

export const topicsRelations = relations(topics, ({one, many}) => ({
	practiceSets: many(practiceSets),
	questions: many(questions),
	syllabusTopics: many(syllabusTopics),
	topicContents: many(topicContent),
	topicVideoLinks: many(topicVideoLinks),
	subject: one(subjects, {
		fields: [topics.subjectId],
		references: [subjects.subjectId]
	}),
	userStudyPlans: many(userStudyPlan),
	userTopicWeaknesses: many(userTopicWeakness),
}));

export const questionExplanationsRelations = relations(questionExplanations, ({one}) => ({
	question: one(questions, {
		fields: [questionExplanations.questionId],
		references: [questions.questionId]
	}),
}));

export const syllabusVersionsRelations = relations(syllabusVersions, ({many}) => ({
	subjects: many(subjects),
	syllabusTopics: many(syllabusTopics),
}));

export const syllabusTopicsRelations = relations(syllabusTopics, ({one}) => ({
	syllabusVersion: one(syllabusVersions, {
		fields: [syllabusTopics.syllabusId],
		references: [syllabusVersions.syllabusId]
	}),
	topic: one(topics, {
		fields: [syllabusTopics.topicId],
		references: [topics.topicId]
	}),
}));

export const topicContentRelations = relations(topicContent, ({one}) => ({
	topic: one(topics, {
		fields: [topicContent.topicId],
		references: [topics.topicId]
	}),
}));

export const topicVideoLinksRelations = relations(topicVideoLinks, ({one}) => ({
	topic: one(topics, {
		fields: [topicVideoLinks.topicId],
		references: [topics.topicId]
	}),
}));

export const userActivityLogRelations = relations(userActivityLog, ({one}) => ({
	user: one(users, {
		fields: [userActivityLog.userId],
		references: [users.userId]
	}),
}));

export const userApiTokensRelations = relations(userApiTokens, ({one}) => ({
	user: one(users, {
		fields: [userApiTokens.userId],
		references: [users.userId]
	}),
}));

export const userDailyActivityRelations = relations(userDailyActivity, ({one}) => ({
	user: one(users, {
		fields: [userDailyActivity.userId],
		references: [users.userId]
	}),
}));

export const userExamVersionStatusRelations = relations(userExamVersionStatus, ({one}) => ({
	user: one(users, {
		fields: [userExamVersionStatus.userId],
		references: [users.userId]
	}),
	examVersion: one(examVersions, {
		fields: [userExamVersionStatus.examVersionId],
		references: [examVersions.examVersionId]
	}),
}));

export const userMockAttemptsRelations = relations(userMockAttempts, ({one}) => ({
	user: one(users, {
		fields: [userMockAttempts.userId],
		references: [users.userId]
	}),
	mockPreboardExam: one(mockPreboardExams, {
		fields: [userMockAttempts.examId],
		references: [mockPreboardExams.examId]
	}),
}));

export const userReferralsRelations = relations(userReferrals, ({one}) => ({
	user_referrerUserId: one(users, {
		fields: [userReferrals.referrerUserId],
		references: [users.userId],
		relationName: "userReferrals_referrerUserId_users_userId"
	}),
	user_referredUserId: one(users, {
		fields: [userReferrals.referredUserId],
		references: [users.userId],
		relationName: "userReferrals_referredUserId_users_userId"
	}),
}));

export const userStreaksRelations = relations(userStreaks, ({one}) => ({
	user: one(users, {
		fields: [userStreaks.userId],
		references: [users.userId]
	}),
}));

export const userStudyPlanRelations = relations(userStudyPlan, ({one}) => ({
	topic: one(topics, {
		fields: [userStudyPlan.focusTopicId],
		references: [topics.topicId]
	}),
}));

export const userSubscriptionsRelations = relations(userSubscriptions, ({one}) => ({
	user: one(users, {
		fields: [userSubscriptions.userId],
		references: [users.userId]
	}),
}));

export const userTopicWeaknessRelations = relations(userTopicWeakness, ({one}) => ({
	topic: one(topics, {
		fields: [userTopicWeakness.topicId],
		references: [topics.topicId]
	}),
}));