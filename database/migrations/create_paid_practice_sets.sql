-- =====================================================
-- PAID Practice Sets Migration
-- Creates 3 PAID practice sets with 225 questions total
-- =====================================================

-- Set session variables to avoid warnings
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS;
SET FOREIGN_KEY_CHECKS=0;

-- =====================================================
-- SECTION 1: CREATE PRACTICE SETS (3 sets)
-- =====================================================

INSERT INTO practice_sets (practice_set_id, topic_id, set_code, set_name, set_type, is_paid, display_order, is_active, questions_per_set, access_level, access_type)
VALUES
(200, 1, 'PAID-COMP-001', 'Comprehensive Review Set 1 - All Subjects', 'PRACTICE', 1, 200, 1, 75, 'ADVANCE', 'PAID'),
(201, 1, 'PAID-COMP-002', 'Comprehensive Review Set 2 - All Subjects', 'PRACTICE', 1, 201, 1, 75, 'ADVANCE', 'PAID'),
(202, 1, 'PAID-ADV-003', 'Advanced Challenge Set - All Subjects', 'PRACTICE', 1, 202, 1, 75, 'ADVANCE', 'PAID');

-- =====================================================
-- SECTION 2: CREATE QUESTIONS (225 questions)
-- Distribution per set: 75 questions
--   FAR: 13, AFAR: 12, AUD: 12, TAX: 13, MS: 12, RFBT: 13
-- Difficulty: ~23 EASY, 30 MEDIUM, 22 HARD per set
-- =====================================================

-- Helper: Topic ranges by subject
-- FAR: 1-35 (35 topics)
-- AFAR: 36-62 (27 topics)
-- AUD: 63-90 (28 topics)
-- TAX: 91-111 (21 topics)
-- MS: 112-132 (21 topics)
-- RFBT: 133-162 (30 topics)

-- =====================================================
-- SET 200: Comprehensive Review Set 1 (Questions 1001-1075)
-- =====================================================

-- FAR Questions (13 questions: 4 EASY, 5 MEDIUM, 4 HARD)
INSERT INTO questions (question_id, practice_set_id, question_code, question_text, difficulty_level, is_paid, access_type, topic_id, is_active) VALUES
(1001, 200, 'FAR-PAID-001-Q001', 'Under the Conceptual Framework for Financial Reporting, which of the following is NOT a qualitative characteristic that enhances the usefulness of financial information?', 'EASY', 1, 'PAID', 4, 1),
(1002, 200, 'FAR-PAID-001-Q002', 'When should an entity recognize revenue from the sale of goods according to PFRS 15?', 'EASY', 1, 'PAID', 6, 1),
(1003, 200, 'FAR-PAID-001-Q003', 'How should cash equivalents be classified in the statement of financial position?', 'EASY', 1, 'PAID', 11, 1),
(1004, 200, 'FAR-PAID-001-Q004', 'What is the primary purpose of the statement of cash flows?', 'EASY', 1, 'PAID', 9, 1),
(1005, 200, 'FAR-PAID-001-Q005', 'Under PAS 16, when should an entity begin depreciating an item of property, plant and equipment?', 'MEDIUM', 1, 'PAID', 17, 1),
(1006, 200, 'FAR-PAID-001-Q006', 'Which of the following costs should be capitalized as part of the cost of inventory under PAS 2?', 'MEDIUM', 1, 'PAID', 16, 1),
(1007, 200, 'FAR-PAID-001-Q007', 'How should an entity account for investment property under the fair value model?', 'MEDIUM', 1, 'PAID', 19, 1),
(1008, 200, 'FAR-PAID-001-Q008', 'Under PAS 37, when should a provision be recognized?', 'MEDIUM', 1, 'PAID', 24, 1),
(1009, 200, 'FAR-PAID-001-Q009', 'What is the appropriate treatment for borrowing costs directly attributable to a qualifying asset?', 'MEDIUM', 1, 'PAID', 18, 1),
(1010, 200, 'FAR-PAID-001-Q010', 'Under PFRS 16, how should a lessee initially measure a right-of-use asset?', 'HARD', 1, 'PAID', 30, 1),
(1011, 200, 'FAR-PAID-001-Q011', 'How should an entity account for deferred tax assets arising from unused tax losses?', 'HARD', 1, 'PAID', 31, 1),
(1012, 200, 'FAR-PAID-001-Q012', 'Under PAS 19, how should an entity measure a defined benefit obligation?', 'HARD', 1, 'PAID', 32, 1),
(1013, 200, 'FAR-PAID-001-Q013', 'What disclosures are required for operating segments under PFRS 8?', 'HARD', 1, 'PAID', 34, 1),

-- AFAR Questions (12 questions: 4 EASY, 4 MEDIUM, 4 HARD)
(1014, 200, 'AFAR-PAID-001-Q014', 'In a partnership, what is the default rule for profit and loss sharing when partners have different capital contributions?', 'EASY', 1, 'PAID', 36, 1),
(1015, 200, 'AFAR-PAID-001-Q015', 'Under the five-step model for revenue recognition, what is Step 2?', 'EASY', 1, 'PAID', 42, 1),
(1016, 200, 'AFAR-PAID-001-Q016', 'What is the primary characteristic of a joint operation under PFRS 11?', 'EASY', 1, 'PAID', 40, 1),
(1017, 200, 'AFAR-PAID-001-Q017', 'In consignment sales, when does the consignor recognize revenue?', 'EASY', 1, 'PAID', 46, 1),
(1018, 200, 'AFAR-PAID-001-Q018', 'Under the percentage-of-completion method for construction contracts, how is progress measured?', 'MEDIUM', 1, 'PAID', 44, 1),
(1019, 200, 'AFAR-PAID-001-Q019', 'In partnership liquidation, what is the marshalling of assets principle?', 'MEDIUM', 1, 'PAID', 38, 1),
(1020, 200, 'AFAR-PAID-001-Q020', 'How should a franchisor recognize initial franchise fees under PFRS 15?', 'MEDIUM', 1, 'PAID', 45, 1),
(1021, 200, 'AFAR-PAID-001-Q021', 'What is the appropriate accounting treatment for reciprocal transactions in home office and branch accounting?', 'MEDIUM', 1, 'PAID', 47, 1),
(1022, 200, 'AFAR-PAID-001-Q022', 'Under PFRS 3, how should the acquirer measure identifiable assets acquired in a business combination?', 'HARD', 1, 'PAID', 48, 1),
(1023, 200, 'AFAR-PAID-001-Q023', 'How should non-controlling interests be measured at the acquisition date under PFRS 3?', 'HARD', 1, 'PAID', 50, 1),
(1024, 200, 'AFAR-PAID-001-Q024', 'What adjustments are required when preparing consolidated financial statements for intercompany transactions?', 'HARD', 1, 'PAID', 50, 1),
(1025, 200, 'AFAR-PAID-001-Q025', 'How should foreign currency translation differences be reported in consolidated financial statements?', 'HARD', 1, 'PAID', 55, 1),

-- AUD Questions (12 questions: 4 EASY, 4 MEDIUM, 4 HARD)
(1026, 200, 'AUD-PAID-001-Q026', 'What is the primary objective of an audit of financial statements?', 'EASY', 1, 'PAID', 64, 1),
(1027, 200, 'AUD-PAID-001-Q027', 'Which of the following is a characteristic of audit evidence?', 'EASY', 1, 'PAID', 71, 1),
(1028, 200, 'AUD-PAID-001-Q028', 'What type of audit report is issued when the auditor concludes that the financial statements are fairly presented?', 'EASY', 1, 'PAID', 76, 1),
(1029, 200, 'AUD-PAID-001-Q029', 'What is the purpose of audit documentation?', 'EASY', 1, 'PAID', 72, 1),
(1030, 200, 'AUD-PAID-001-Q030', 'Under PSA 315, what are the components of internal control?', 'MEDIUM', 1, 'PAID', 68, 1),
(1031, 200, 'AUD-PAID-001-Q031', 'What factors should an auditor consider when assessing the risk of material misstatement?', 'MEDIUM', 1, 'PAID', 69, 1),
(1032, 200, 'AUD-PAID-001-Q032', 'How does an auditor evaluate the going concern assumption?', 'MEDIUM', 1, 'PAID', 74, 1),
(1033, 200, 'AUD-PAID-001-Q033', 'What is the significance of management representations in an audit?', 'MEDIUM', 1, 'PAID', 75, 1),
(1034, 200, 'AUD-PAID-001-Q034', 'When should an auditor issue a qualified opinion due to a scope limitation?', 'HARD', 1, 'PAID', 77, 1),
(1035, 200, 'AUD-PAID-001-Q035', 'What are the auditors responsibilities regarding key audit matters under PSA 701?', 'HARD', 1, 'PAID', 78, 1),
(1036, 200, 'AUD-PAID-001-Q036', 'How does computer-assisted audit techniques (CAATs) enhance audit effectiveness?', 'HARD', 1, 'PAID', 80, 1),
(1037, 200, 'AUD-PAID-001-Q037', 'What are the quality management requirements under PSQM 1?', 'HARD', 1, 'PAID', 87, 1),

-- TAX Questions (13 questions: 4 EASY, 5 MEDIUM, 4 HARD)
(1038, 200, 'TAX-PAID-001-Q038', 'What is the tax situs rule for income derived from sources within the Philippines?', 'EASY', 1, 'PAID', 91, 1),
(1039, 200, 'TAX-PAID-001-Q039', 'Which of the following is considered gross income under the Tax Code?', 'EASY', 1, 'PAID', 95, 1),
(1040, 200, 'TAX-PAID-001-Q040', 'What is the deadline for filing annual income tax returns for individual taxpayers?', 'EASY', 1, 'PAID', 99, 1),
(1041, 200, 'TAX-PAID-001-Q041', 'What is the standard deduction for estate tax purposes?', 'EASY', 1, 'PAID', 101, 1),
(1042, 200, 'TAX-PAID-001-Q042', 'How are fringe benefits taxed under the Tax Code?', 'MEDIUM', 1, 'PAID', 95, 1),
(1043, 200, 'TAX-PAID-001-Q043', 'What are the requisites for deductibility of ordinary and necessary business expenses?', 'MEDIUM', 1, 'PAID', 96, 1),
(1044, 200, 'TAX-PAID-001-Q044', 'How is the creditable withholding tax computed for professional income?', 'MEDIUM', 1, 'PAID', 98, 1),
(1045, 200, 'TAX-PAID-001-Q045', 'What transactions are subject to VAT zero-rating?', 'MEDIUM', 1, 'PAID', 103, 1),
(1046, 200, 'TAX-PAID-001-Q046', 'How is the donors tax computed for strangers versus relatives?', 'MEDIUM', 1, 'PAID', 102, 1),
(1047, 200, 'TAX-PAID-001-Q047', 'What is the tax treatment of capital gains from sale of shares of stock traded in the stock exchange?', 'HARD', 1, 'PAID', 97, 1),
(1048, 200, 'TAX-PAID-001-Q048', 'How does the Optional Standard Deduction (OSD) apply to corporations?', 'HARD', 1, 'PAID', 96, 1),
(1049, 200, 'TAX-PAID-001-Q049', 'What are the VAT compliance requirements for electronic service providers?', 'HARD', 1, 'PAID', 104, 1),
(1050, 200, 'TAX-PAID-001-Q050', 'How do tax treaties affect the taxation of royalties paid to non-residents?', 'HARD', 1, 'PAID', 111, 1),

-- MS Questions (12 questions: 4 EASY, 4 MEDIUM, 4 HARD)
(1051, 200, 'MS-PAID-001-Q051', 'What is the primary purpose of management accounting?', 'EASY', 1, 'PAID', 112, 1),
(1052, 200, 'MS-PAID-001-Q052', 'How are costs classified based on behavior?', 'EASY', 1, 'PAID', 113, 1),
(1053, 200, 'MS-PAID-001-Q053', 'What is the contribution margin ratio?', 'EASY', 1, 'PAID', 114, 1),
(1054, 200, 'MS-PAID-001-Q054', 'What is the purpose of a flexible budget?', 'EASY', 1, 'PAID', 117, 1),
(1055, 200, 'MS-PAID-001-Q055', 'How is the material price variance calculated under standard costing?', 'MEDIUM', 1, 'PAID', 115, 1),
(1056, 200, 'MS-PAID-001-Q056', 'What is the difference between variable costing and absorption costing?', 'MEDIUM', 1, 'PAID', 116, 1),
(1057, 200, 'MS-PAID-001-Q057', 'How is return on investment (ROI) calculated for a profit center?', 'MEDIUM', 1, 'PAID', 118, 1),
(1058, 200, 'MS-PAID-001-Q058', 'What are the components of working capital management?', 'MEDIUM', 1, 'PAID', 126, 1),
(1059, 200, 'MS-PAID-001-Q059', 'How is the internal rate of return (IRR) used in capital budgeting decisions?', 'HARD', 1, 'PAID', 127, 1),
(1060, 200, 'MS-PAID-001-Q060', 'What factors should be considered in a make-or-buy decision?', 'HARD', 1, 'PAID', 121, 1),
(1061, 200, 'MS-PAID-001-Q061', 'How does operating leverage affect business risk?', 'HARD', 1, 'PAID', 128, 1),
(1062, 200, 'MS-PAID-001-Q062', 'What are the perspectives of a balanced scorecard and how are they linked?', 'HARD', 1, 'PAID', 120, 1),

-- RFBT Questions (13 questions: 4 EASY, 5 MEDIUM, 4 HARD)
(1063, 200, 'RFBT-PAID-001-Q063', 'Under the Civil Code, what are the essential requisites of a valid contract?', 'EASY', 1, 'PAID', 135, 1),
(1064, 200, 'RFBT-PAID-001-Q064', 'What is the remedy for breach of contract under the Civil Code?', 'EASY', 1, 'PAID', 133, 1),
(1065, 200, 'RFBT-PAID-001-Q065', 'What are the rights of an unpaid seller of goods?', 'EASY', 1, 'PAID', 136, 1),
(1066, 200, 'RFBT-PAID-001-Q066', 'What penalties are imposed under BP 22 (Bouncing Checks Law)?', 'EASY', 1, 'PAID', 138, 1),
(1067, 200, 'RFBT-PAID-001-Q067', 'What is the minimum capital stock requirement for a corporation under the Revised Corporation Code?', 'MEDIUM', 1, 'PAID', 144, 1),
(1068, 200, 'RFBT-PAID-001-Q068', 'What are the powers of a board of directors under the Revised Corporation Code?', 'MEDIUM', 1, 'PAID', 148, 1),
(1069, 200, 'RFBT-PAID-001-Q069', 'How is a corporation dissolved under the Revised Corporation Code?', 'MEDIUM', 1, 'PAID', 149, 1),
(1070, 200, 'RFBT-PAID-001-Q070', 'What are the registration requirements under the Securities Regulation Code?', 'MEDIUM', 1, 'PAID', 152, 1),
(1071, 200, 'RFBT-PAID-001-Q071', 'What constitutes insider trading under the Securities Regulation Code?', 'MEDIUM', 1, 'PAID', 152, 1),
(1072, 200, 'RFBT-PAID-001-Q072', 'What are the covered transactions under the Anti-Money Laundering Act?', 'HARD', 1, 'PAID', 156, 1),
(1073, 200, 'RFBT-PAID-001-Q073', 'What are the principles of data processing under the Data Privacy Act?', 'HARD', 1, 'PAID', 158, 1),
(1074, 200, 'RFBT-PAID-001-Q074', 'What labor standards are mandated under the Labor Code regarding working conditions?', 'HARD', 1, 'PAID', 161, 1),
(1075, 200, 'RFBT-PAID-001-Q075', 'What are the requirements for financial rehabilitation under FRIA?', 'HARD', 1, 'PAID', 140, 1);

-- =====================================================
-- SET 201: Comprehensive Review Set 2 (Questions 1076-1150)
-- =====================================================

-- FAR Questions (13 questions: 4 EASY, 5 MEDIUM, 4 HARD)
INSERT INTO questions (question_id, practice_set_id, question_code, question_text, difficulty_level, is_paid, access_type, topic_id, is_active) VALUES
(1076, 201, 'FAR-PAID-002-Q001', 'What are the fundamental qualitative characteristics of useful financial information under the Conceptual Framework?', 'EASY', 1, 'PAID', 4, 1),
(1077, 201, 'FAR-PAID-002-Q002', 'How should an entity present current and non-current assets in the statement of financial position?', 'EASY', 1, 'PAID', 7, 1),
(1078, 201, 'FAR-PAID-002-Q003', 'What items are included in other comprehensive income?', 'EASY', 1, 'PAID', 27, 1),
(1079, 201, 'FAR-PAID-002-Q004', 'How is basic earnings per share calculated?', 'EASY', 1, 'PAID', 10, 1),
(1080, 201, 'FAR-PAID-002-Q005', 'Under PAS 2, which cost formula is required for interchangeable inventories?', 'MEDIUM', 1, 'PAID', 16, 1),
(1081, 201, 'FAR-PAID-002-Q006', 'How should an entity account for financial assets at amortized cost?', 'MEDIUM', 1, 'PAID', 14, 1),
(1082, 201, 'FAR-PAID-002-Q007', 'What criteria must be met for an intangible asset to be recognized under PAS 38?', 'MEDIUM', 1, 'PAID', 20, 1),
(1083, 201, 'FAR-PAID-002-Q008', 'How are biological assets measured under PAS 41?', 'MEDIUM', 1, 'PAID', 21, 1),
(1084, 201, 'FAR-PAID-002-Q009', 'When should an asset be classified as held for sale under PFRS 5?', 'MEDIUM', 1, 'PAID', 22, 1),
(1085, 201, 'FAR-PAID-002-Q010', 'How should share-based payment transactions be accounted for under PFRS 2?', 'HARD', 1, 'PAID', 29, 1),
(1086, 201, 'FAR-PAID-002-Q011', 'What is the unit of account for impairment testing of goodwill?', 'HARD', 1, 'PAID', 20, 1),
(1087, 201, 'FAR-PAID-002-Q012', 'How should actuarial gains and losses be recognized for defined benefit plans?', 'HARD', 1, 'PAID', 32, 1),
(1088, 201, 'FAR-PAID-002-Q013', 'What are the disclosure requirements for interim financial reporting under PAS 34?', 'HARD', 1, 'PAID', 33, 1),

-- AFAR Questions (12 questions: 4 EASY, 4 MEDIUM, 4 HARD)
(1089, 201, 'AFAR-PAID-002-Q014', 'How is goodwill arising from partnership admission calculated using the bonus method?', 'EASY', 1, 'PAID', 37, 1),
(1090, 201, 'AFAR-PAID-002-Q015', 'What is the order of priority in partnership liquidation payments?', 'EASY', 1, 'PAID', 38, 1),
(1091, 201, 'AFAR-PAID-002-Q016', 'How are variable considerations estimated under PFRS 15?', 'EASY', 1, 'PAID', 43, 1),
(1092, 201, 'AFAR-PAID-002-Q017', 'What is the journal entry to record consignment inventory received by the consignee?', 'EASY', 1, 'PAID', 46, 1),
(1093, 201, 'AFAR-PAID-002-Q018', 'How should a contractor account for an onerous construction contract?', 'MEDIUM', 1, 'PAID', 44, 1),
(1094, 201, 'AFAR-PAID-002-Q019', 'What is the accounting treatment for a step acquisition in a business combination?', 'MEDIUM', 1, 'PAID', 48, 1),
(1095, 201, 'AFAR-PAID-002-Q020', 'How are intercompany profits in inventory eliminated in consolidation?', 'MEDIUM', 1, 'PAID', 50, 1),
(1096, 201, 'AFAR-PAID-002-Q021', 'What is the difference between a joint operation and a joint venture under PFRS 11?', 'MEDIUM', 1, 'PAID', 41, 1),
(1097, 201, 'AFAR-PAID-002-Q022', 'How is the gain or loss on disposal of a subsidiary calculated in consolidated statements?', 'HARD', 1, 'PAID', 50, 1),
(1098, 201, 'AFAR-PAID-002-Q023', 'What is the accounting for put options held by non-controlling interests?', 'HARD', 1, 'PAID', 50, 1),
(1099, 201, 'AFAR-PAID-002-Q024', 'How should hyperinflation be accounted for in consolidated financial statements?', 'HARD', 1, 'PAID', 56, 1),
(1100, 201, 'AFAR-PAID-002-Q025', 'What are the recognition criteria for government grants under PAS 20?', 'HARD', 1, 'PAID', 59, 1),

-- AUD Questions (12 questions: 4 EASY, 4 MEDIUM, 4 HARD)
(1101, 201, 'AUD-PAID-002-Q026', 'What is the difference between reasonable assurance and limited assurance engagements?', 'EASY', 1, 'PAID', 63, 1),
(1102, 201, 'AUD-PAID-002-Q027', 'What are the assertions relevant to account balances at period end?', 'EASY', 1, 'PAID', 70, 1),
(1103, 201, 'AUD-PAID-002-Q028', 'What is the auditors responsibility regarding fraud in an audit?', 'EASY', 1, 'PAID', 64, 1),
(1104, 201, 'AUD-PAID-002-Q029', 'When is an auditor required to communicate with those charged with governance?', 'EASY', 1, 'PAID', 85, 1),
(1105, 201, 'AUD-PAID-002-Q030', 'How does an auditor assess control risk?', 'MEDIUM', 1, 'PAID', 68, 1),
(1106, 201, 'AUD-PAID-002-Q031', 'What are the procedures for confirming accounts receivable?', 'MEDIUM', 1, 'PAID', 88, 1),
(1107, 201, 'AUD-PAID-002-Q032', 'What is the purpose of analytical procedures in an audit?', 'MEDIUM', 1, 'PAID', 71, 1),
(1108, 201, 'AUD-PAID-002-Q033', 'How does materiality affect audit planning and execution?', 'MEDIUM', 1, 'PAID', 66, 1),
(1109, 201, 'AUD-PAID-002-Q034', 'What circumstances require an adverse audit opinion?', 'HARD', 1, 'PAID', 77, 1),
(1110, 201, 'AUD-PAID-002-Q035', 'How should an auditor respond to identified fraud or suspected fraud?', 'HARD', 1, 'PAID', 64, 1),
(1111, 201, 'AUD-PAID-002-Q036', 'What are the specific considerations for auditing accounting estimates?', 'HARD', 1, 'PAID', 73, 1),
(1112, 201, 'AUD-PAID-002-Q037', 'What is the auditors responsibility when using the work of an expert?', 'HARD', 1, 'PAID', 71, 1),

-- TAX Questions (13 questions: 4 EASY, 5 MEDIUM, 4 HARD)
(1113, 201, 'TAX-PAID-002-Q038', 'Who are required to file income tax returns under the Tax Code?', 'EASY', 1, 'PAID', 94, 1),
(1114, 201, 'TAX-PAID-002-Q039', 'What income is excluded from gross income under the Tax Code?', 'EASY', 1, 'PAID', 95, 1),
(1115, 201, 'TAX-PAID-002-Q040', 'What is the VAT rate for sale of goods and services?', 'EASY', 1, 'PAID', 103, 1),
(1116, 201, 'TAX-PAID-002-Q041', 'What are the documentary stamp tax rates for loan agreements?', 'EASY', 1, 'PAID', 106, 1),
(1117, 201, 'TAX-PAID-002-Q042', 'How is the minimum corporate income tax (MCIT) computed?', 'MEDIUM', 1, 'PAID', 97, 1),
(1118, 201, 'TAX-PAID-002-Q043', 'What are the requirements for claiming input VAT credits?', 'MEDIUM', 1, 'PAID', 104, 1),
(1119, 201, 'TAX-PAID-002-Q044', 'How are passive income items taxed under final withholding tax?', 'MEDIUM', 1, 'PAID', 98, 1),
(1120, 201, 'TAX-PAID-002-Q045', 'What deductions are allowed in computing net estate for estate tax?', 'MEDIUM', 1, 'PAID', 101, 1),
(1121, 201, 'TAX-PAID-002-Q046', 'How is percentage tax computed for persons exempt from VAT?', 'MEDIUM', 1, 'PAID', 105, 1),
(1122, 201, 'TAX-PAID-002-Q047', 'What is the tax treatment of de minimis benefits?', 'HARD', 1, 'PAID', 95, 1),
(1123, 201, 'TAX-PAID-002-Q048', 'How are installment sales of real property taxed?', 'HARD', 1, 'PAID', 97, 1),
(1124, 201, 'TAX-PAID-002-Q049', 'What are the requirements for PEZA-registered enterprises to avail of tax incentives?', 'HARD', 1, 'PAID', 110, 1),
(1125, 201, 'TAX-PAID-002-Q050', 'How is transfer pricing adjustment applied in related party transactions?', 'HARD', 1, 'PAID', 111, 1),

-- MS Questions (12 questions: 4 EASY, 4 MEDIUM, 4 HARD)
(1126, 201, 'MS-PAID-002-Q051', 'What is the break-even point in units?', 'EASY', 1, 'PAID', 114, 1),
(1127, 201, 'MS-PAID-002-Q052', 'How are fixed costs treated in variable costing?', 'EASY', 1, 'PAID', 116, 1),
(1128, 201, 'MS-PAID-002-Q053', 'What is a responsibility center?', 'EASY', 1, 'PAID', 118, 1),
(1129, 201, 'MS-PAID-002-Q054', 'What is the payback period method in capital budgeting?', 'EASY', 1, 'PAID', 127, 1),
(1130, 201, 'MS-PAID-002-Q055', 'How is the labor efficiency variance calculated?', 'MEDIUM', 1, 'PAID', 115, 1),
(1131, 201, 'MS-PAID-002-Q056', 'What is the economic order quantity (EOQ) model?', 'MEDIUM', 1, 'PAID', 126, 1),
(1132, 201, 'MS-PAID-002-Q057', 'How does residual income differ from ROI as a performance measure?', 'MEDIUM', 1, 'PAID', 118, 1),
(1133, 201, 'MS-PAID-002-Q058', 'What are the methods of transfer pricing between divisions?', 'MEDIUM', 1, 'PAID', 119, 1),
(1134, 201, 'MS-PAID-002-Q059', 'How is the weighted average cost of capital (WACC) calculated?', 'HARD', 1, 'PAID', 129, 1),
(1135, 201, 'MS-PAID-002-Q060', 'What is the theory of constraints and how is it applied?', 'HARD', 1, 'PAID', 122, 1),
(1136, 201, 'MS-PAID-002-Q061', 'How does activity-based costing differ from traditional costing?', 'HARD', 1, 'PAID', 113, 1),
(1137, 201, 'MS-PAID-002-Q062', 'What are the characteristics of relevant costs in decision-making?', 'HARD', 1, 'PAID', 121, 1),

-- RFBT Questions (13 questions: 4 EASY, 5 MEDIUM, 4 HARD)
(1138, 201, 'RFBT-PAID-002-Q063', 'What are the modes of extinguishing obligations under the Civil Code?', 'EASY', 1, 'PAID', 134, 1),
(1139, 201, 'RFBT-PAID-002-Q064', 'What is the doctrine of caveat emptor in sales law?', 'EASY', 1, 'PAID', 136, 1),
(1140, 201, 'RFBT-PAID-002-Q065', 'What are the characteristics of a partnership under the Civil Code?', 'EASY', 1, 'PAID', 143, 1),
(1141, 201, 'RFBT-PAID-002-Q066', 'What is the nationality requirement for domestic corporations?', 'EASY', 1, 'PAID', 144, 1),
(1142, 201, 'RFBT-PAID-002-Q067', 'What are the rights of stockholders under the Revised Corporation Code?', 'MEDIUM', 1, 'PAID', 147, 1),
(1143, 201, 'RFBT-PAID-002-Q068', 'How are treasury shares treated under the Revised Corporation Code?', 'MEDIUM', 1, 'PAID', 145, 1),
(1144, 201, 'RFBT-PAID-002-Q069', 'What constitutes anti-competitive agreements under the Philippine Competition Act?', 'MEDIUM', 1, 'PAID', 141, 1),
(1145, 201, 'RFBT-PAID-002-Q070', 'What are the types of insurance contracts under the Insurance Code?', 'MEDIUM', 1, 'PAID', 153, 1),
(1146, 201, 'RFBT-PAID-002-Q071', 'What are the requirements for registration of cooperatives?', 'MEDIUM', 1, 'PAID', 154, 1),
(1147, 201, 'RFBT-PAID-002-Q072', 'What transactions require SEC approval under the Securities Regulation Code?', 'HARD', 1, 'PAID', 152, 1),
(1148, 201, 'RFBT-PAID-002-Q073', 'What are the obligations of personal information controllers under the Data Privacy Act?', 'HARD', 1, 'PAID', 158, 1),
(1149, 201, 'RFBT-PAID-002-Q074', 'What are the prohibited acts under banking laws?', 'HARD', 1, 'PAID', 155, 1),
(1150, 201, 'RFBT-PAID-002-Q075', 'How are mergers and acquisitions regulated under the Revised Corporation Code?', 'HARD', 1, 'PAID', 151, 1);

-- =====================================================
-- SET 202: Advanced Challenge Set (Questions 1151-1225)
-- =====================================================

-- FAR Questions (13 questions: 3 EASY, 4 MEDIUM, 6 HARD - more challenging)
INSERT INTO questions (question_id, practice_set_id, question_code, question_text, difficulty_level, is_paid, access_type, topic_id, is_active) VALUES
(1151, 202, 'FAR-PAID-003-Q001', 'What is the going concern assumption in financial reporting?', 'EASY', 1, 'PAID', 4, 1),
(1152, 202, 'FAR-PAID-003-Q002', 'How should trade receivables be initially recognized?', 'EASY', 1, 'PAID', 14, 1),
(1153, 202, 'FAR-PAID-003-Q003', 'What is the accounting treatment for dividends declared but not yet paid?', 'EASY', 1, 'PAID', 26, 1),
(1154, 202, 'FAR-PAID-003-Q004', 'Under PFRS 9, how is expected credit loss measured for trade receivables?', 'MEDIUM', 1, 'PAID', 14, 1),
(1155, 202, 'FAR-PAID-003-Q005', 'How should an entity account for a change in accounting estimate?', 'MEDIUM', 1, 'PAID', 6, 1),
(1156, 202, 'FAR-PAID-003-Q006', 'What is the accounting for revaluation of property, plant and equipment?', 'MEDIUM', 1, 'PAID', 17, 1),
(1157, 202, 'FAR-PAID-003-Q007', 'How are compound financial instruments accounted for under PAS 32?', 'MEDIUM', 1, 'PAID', 23, 1),
(1158, 202, 'FAR-PAID-003-Q008', 'What is the accounting for modification of financial liabilities under PFRS 9?', 'HARD', 1, 'PAID', 23, 1),
(1159, 202, 'FAR-PAID-003-Q009', 'How should hedge accounting be applied for cash flow hedges?', 'HARD', 1, 'PAID', 12, 1),
(1160, 202, 'FAR-PAID-003-Q010', 'What is the accounting for sale and leaseback transactions under PFRS 16?', 'HARD', 1, 'PAID', 30, 1),
(1161, 202, 'FAR-PAID-003-Q011', 'How are uncertain tax positions accounted for under IFRIC 23?', 'HARD', 1, 'PAID', 31, 1),
(1162, 202, 'FAR-PAID-003-Q012', 'What is the accounting for service concession arrangements under IFRIC 12?', 'HARD', 1, 'PAID', 35, 1),
(1163, 202, 'FAR-PAID-003-Q013', 'How should an entity determine the functional currency under PAS 21?', 'HARD', 1, 'PAID', 35, 1),

-- AFAR Questions (12 questions: 3 EASY, 4 MEDIUM, 5 HARD)
(1164, 202, 'AFAR-PAID-003-Q014', 'What happens to a partners capital account upon withdrawal?', 'EASY', 1, 'PAID', 37, 1),
(1165, 202, 'AFAR-PAID-003-Q015', 'How is revenue allocated to performance obligations under PFRS 15?', 'EASY', 1, 'PAID', 42, 1),
(1166, 202, 'AFAR-PAID-003-Q016', 'What are the components of the transaction price under PFRS 15?', 'EASY', 1, 'PAID', 42, 1),
(1167, 202, 'AFAR-PAID-003-Q017', 'How is loss recognized under construction contracts when total expected costs exceed contract revenue?', 'MEDIUM', 1, 'PAID', 44, 1),
(1168, 202, 'AFAR-PAID-003-Q018', 'What is the installment liquidation method in partnership liquidation?', 'MEDIUM', 1, 'PAID', 38, 1),
(1169, 202, 'AFAR-PAID-003-Q019', 'How are contingent considerations measured in a business combination?', 'MEDIUM', 1, 'PAID', 48, 1),
(1170, 202, 'AFAR-PAID-003-Q020', 'What is the push-down accounting concept in business combinations?', 'MEDIUM', 1, 'PAID', 48, 1),
(1171, 202, 'AFAR-PAID-003-Q021', 'How is goodwill impairment tested in consolidated financial statements?', 'HARD', 1, 'PAID', 50, 1),
(1172, 202, 'AFAR-PAID-003-Q022', 'What is the accounting for changes in ownership interest that do not result in loss of control?', 'HARD', 1, 'PAID', 50, 1),
(1173, 202, 'AFAR-PAID-003-Q023', 'How are translation and remeasurement differences distinguished in foreign operations?', 'HARD', 1, 'PAID', 55, 1),
(1174, 202, 'AFAR-PAID-003-Q024', 'What is the accounting for reciprocal shareholdings in consolidated statements?', 'HARD', 1, 'PAID', 50, 1),
(1175, 202, 'AFAR-PAID-003-Q025', 'How are complex intercompany transactions eliminated in consolidation?', 'HARD', 1, 'PAID', 50, 1),

-- AUD Questions (12 questions: 3 EASY, 4 MEDIUM, 5 HARD)
(1176, 202, 'AUD-PAID-003-Q026', 'What is professional skepticism in auditing?', 'EASY', 1, 'PAID', 86, 1),
(1177, 202, 'AUD-PAID-003-Q027', 'What are the types of audit procedures?', 'EASY', 1, 'PAID', 70, 1),
(1178, 202, 'AUD-PAID-003-Q028', 'What is the auditors report format under PSA 700?', 'EASY', 1, 'PAID', 76, 1),
(1179, 202, 'AUD-PAID-003-Q029', 'How does an auditor test the operating effectiveness of controls?', 'MEDIUM', 1, 'PAID', 68, 1),
(1180, 202, 'AUD-PAID-003-Q030', 'What are the considerations for auditing related party transactions?', 'MEDIUM', 1, 'PAID', 73, 1),
(1181, 202, 'AUD-PAID-003-Q031', 'How does an auditor respond to assessed risks of material misstatement?', 'MEDIUM', 1, 'PAID', 69, 1),
(1182, 202, 'AUD-PAID-003-Q032', 'What are the requirements for audit of group financial statements?', 'MEDIUM', 1, 'PAID', 71, 1),
(1183, 202, 'AUD-PAID-003-Q033', 'What is the auditors responsibility for subsequent events?', 'HARD', 1, 'PAID', 73, 1),
(1184, 202, 'AUD-PAID-003-Q034', 'How should an auditor evaluate misstatements identified during the audit?', 'HARD', 1, 'PAID', 73, 1),
(1185, 202, 'AUD-PAID-003-Q035', 'What are the considerations for disclaimer of opinion?', 'HARD', 1, 'PAID', 77, 1),
(1186, 202, 'AUD-PAID-003-Q036', 'How does an auditor address inconsistencies between financial statements and other information?', 'HARD', 1, 'PAID', 73, 1),
(1187, 202, 'AUD-PAID-003-Q037', 'What are the ethical requirements for independence in audit engagements?', 'HARD', 1, 'PAID', 86, 1),

-- TAX Questions (13 questions: 3 EASY, 4 MEDIUM, 6 HARD)
(1188, 202, 'TAX-PAID-003-Q038', 'What are the classification of taxpayers under the Tax Code?', 'EASY', 1, 'PAID', 94, 1),
(1189, 202, 'TAX-PAID-003-Q039', 'What is the tax base for VAT-registered sellers?', 'EASY', 1, 'PAID', 103, 1),
(1190, 202, 'TAX-PAID-003-Q040', 'What is the real property tax rate under the Local Government Code?', 'EASY', 1, 'PAID', 109, 1),
(1191, 202, 'TAX-PAID-003-Q041', 'How is the improperly accumulated earnings tax computed?', 'MEDIUM', 1, 'PAID', 97, 1),
(1192, 202, 'TAX-PAID-003-Q042', 'What are the conditions for tax-free exchanges under the Tax Code?', 'MEDIUM', 1, 'PAID', 97, 1),
(1193, 202, 'TAX-PAID-003-Q043', 'How is excise tax on petroleum products computed?', 'MEDIUM', 1, 'PAID', 107, 1),
(1194, 202, 'TAX-PAID-003-Q044', 'What are the remedies available to taxpayers under the Tax Code?', 'MEDIUM', 1, 'PAID', 93, 1),
(1195, 202, 'TAX-PAID-003-Q045', 'How is branch profit remittance tax computed for foreign corporations?', 'HARD', 1, 'PAID', 97, 1),
(1196, 202, 'TAX-PAID-003-Q046', 'What is the tax treatment of mixed-use real properties for VAT purposes?', 'HARD', 1, 'PAID', 104, 1),
(1197, 202, 'TAX-PAID-003-Q047', 'How are international carriers taxed under Philippine tax law?', 'HARD', 1, 'PAID', 100, 1),
(1198, 202, 'TAX-PAID-003-Q048', 'What constitutes constructive receipt of income under the Tax Code?', 'HARD', 1, 'PAID', 95, 1),
(1199, 202, 'TAX-PAID-003-Q049', 'How are stock dividends and stock splits treated for tax purposes?', 'HARD', 1, 'PAID', 97, 1),
(1200, 202, 'TAX-PAID-003-Q050', 'What is the tax treatment of income from Philippine depositary receipts?', 'HARD', 1, 'PAID', 100, 1),

-- MS Questions (12 questions: 3 EASY, 4 MEDIUM, 5 HARD)
(1201, 202, 'MS-PAID-003-Q051', 'What is margin of safety in cost-volume-profit analysis?', 'EASY', 1, 'PAID', 114, 1),
(1202, 202, 'MS-PAID-003-Q052', 'What are the types of budgets in a master budget?', 'EASY', 1, 'PAID', 117, 1),
(1203, 202, 'MS-PAID-003-Q053', 'What is the time value of money concept?', 'EASY', 1, 'PAID', 127, 1),
(1204, 202, 'MS-PAID-003-Q054', 'How is the overhead volume variance calculated?', 'MEDIUM', 1, 'PAID', 115, 1),
(1205, 202, 'MS-PAID-003-Q055', 'What is target costing and how is it applied?', 'MEDIUM', 1, 'PAID', 113, 1),
(1206, 202, 'MS-PAID-003-Q056', 'How is the cash conversion cycle calculated?', 'MEDIUM', 1, 'PAID', 126, 1),
(1207, 202, 'MS-PAID-003-Q057', 'What factors affect the capital structure decision?', 'MEDIUM', 1, 'PAID', 129, 1),
(1208, 202, 'MS-PAID-003-Q058', 'How is the profitability index used in capital budgeting?', 'HARD', 1, 'PAID', 127, 1),
(1209, 202, 'MS-PAID-003-Q059', 'What is economic value added (EVA) and how is it calculated?', 'HARD', 1, 'PAID', 118, 1),
(1210, 202, 'MS-PAID-003-Q060', 'How are multiple constraints handled in linear programming?', 'HARD', 1, 'PAID', 123, 1),
(1211, 202, 'MS-PAID-003-Q061', 'What is sensitivity analysis in capital budgeting?', 'HARD', 1, 'PAID', 127, 1),
(1212, 202, 'MS-PAID-003-Q062', 'How does the Modigliani-Miller theorem explain capital structure?', 'HARD', 1, 'PAID', 129, 1),

-- RFBT Questions (13 questions: 3 EASY, 4 MEDIUM, 6 HARD)
(1213, 202, 'RFBT-PAID-003-Q063', 'What are the kinds of obligations under the Civil Code?', 'EASY', 1, 'PAID', 133, 1),
(1214, 202, 'RFBT-PAID-003-Q064', 'What is the effect of fraud on contracts?', 'EASY', 1, 'PAID', 135, 1),
(1215, 202, 'RFBT-PAID-003-Q065', 'What are the types of corporations under the Revised Corporation Code?', 'EASY', 1, 'PAID', 150, 1),
(1216, 202, 'RFBT-PAID-003-Q066', 'What is the doctrine of piercing the corporate veil?', 'MEDIUM', 1, 'PAID', 144, 1),
(1217, 202, 'RFBT-PAID-003-Q067', 'What are the appraisal rights of dissenting stockholders?', 'MEDIUM', 1, 'PAID', 147, 1),
(1218, 202, 'RFBT-PAID-003-Q068', 'What are the compliance requirements under the Ease of Doing Business Act?', 'MEDIUM', 1, 'PAID', 160, 1),
(1219, 202, 'RFBT-PAID-003-Q069', 'What are the intellectual property rights protected under the IP Code?', 'MEDIUM', 1, 'PAID', 157, 1),
(1220, 202, 'RFBT-PAID-003-Q070', 'What constitutes a tender offer under the Securities Regulation Code?', 'HARD', 1, 'PAID', 152, 1),
(1221, 202, 'RFBT-PAID-003-Q071', 'What are the grounds for corporate rehabilitation under FRIA?', 'HARD', 1, 'PAID', 140, 1),
(1222, 202, 'RFBT-PAID-003-Q072', 'How are electronic contracts formed under the E-Commerce Act?', 'HARD', 1, 'PAID', 159, 1),
(1223, 202, 'RFBT-PAID-003-Q073', 'What are the prohibited acts under the Anti-Money Laundering Act?', 'HARD', 1, 'PAID', 156, 1),
(1224, 202, 'RFBT-PAID-003-Q074', 'What are the requirements for a valid security agreement under credit transactions law?', 'HARD', 1, 'PAID', 137, 1),
(1225, 202, 'RFBT-PAID-003-Q075', 'How are labor disputes resolved under the Labor Code?', 'HARD', 1, 'PAID', 161, 1);


-- =====================================================
-- SECTION 3: CREATE QUESTION CHOICES (900 choices)
-- 4 choices per question, randomized correct answer
-- =====================================================

-- Using a procedure to generate choices for all 225 questions
DELIMITER //

DROP PROCEDURE IF EXISTS generate_paid_choices//

CREATE PROCEDURE generate_paid_choices()
BEGIN
    DECLARE q_id INT DEFAULT 1001;
    DECLARE choice_counter INT DEFAULT 4001;
    DECLARE correct_choice INT;
    DECLARE letter CHAR(1);
    DECLARE i INT;
    
    WHILE q_id <= 1225 DO
        -- Randomize which choice is correct (1-4 maps to A-D)
        SET correct_choice = FLOOR(1 + RAND() * 4);
        SET i = 1;
        
        WHILE i <= 4 DO
            SET letter = CASE i WHEN 1 THEN 'A' WHEN 2 THEN 'B' WHEN 3 THEN 'C' ELSE 'D' END;
            
            INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, display_order, is_active, why_wrong)
            VALUES (
                choice_counter,
                q_id,
                CONCAT('Answer choice ', letter, ' for PAID question #', q_id, '. This is a sample answer option that would contain the actual answer text in production.'),
                IF(i = correct_choice, 1, 0),
                i,
                1,
                IF(i = correct_choice, NULL, CONCAT('This answer is incorrect because it does not accurately address the question. The correct answer is ', 
                    CASE correct_choice WHEN 1 THEN 'A' WHEN 2 THEN 'B' WHEN 3 THEN 'C' ELSE 'D' END, '.'))
            );
            
            SET choice_counter = choice_counter + 1;
            SET i = i + 1;
        END WHILE;
        
        SET q_id = q_id + 1;
    END WHILE;
END//

DELIMITER ;

-- Execute the procedure
CALL generate_paid_choices();

-- Drop the procedure after use
DROP PROCEDURE IF EXISTS generate_paid_choices;


-- =====================================================
-- SECTION 4: CREATE QUESTION EXPLANATIONS (225 explanations)
-- =====================================================

-- Using a procedure to generate explanations
DELIMITER //

DROP PROCEDURE IF EXISTS generate_paid_explanations//

CREATE PROCEDURE generate_paid_explanations()
BEGIN
    DECLARE q_id INT DEFAULT 1001;
    DECLARE exp_counter INT DEFAULT 1001;
    DECLARE topic_name_var VARCHAR(255);
    DECLARE subject_code_var VARCHAR(10);
    
    WHILE q_id <= 1225 DO
        -- Get topic and subject info
        SELECT t.topic_name, s.subject_code INTO topic_name_var, subject_code_var
        FROM questions q
        JOIN topics t ON q.topic_id = t.topic_id
        JOIN subjects s ON t.subject_id = s.subject_id
        WHERE q.question_id = q_id;
        
        INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
        VALUES (
            exp_counter,
            q_id,
            CONCAT('This question tests your understanding of ', COALESCE(topic_name_var, 'core concepts'), ' in ', COALESCE(subject_code_var, 'this subject'), '. Review the key principles and their applications to similar scenarios.'),
            CONCAT('For the CPALE board exam: ', COALESCE(topic_name_var, 'This topic'), ' is frequently tested. Key points to remember: 1) Understand the fundamental concepts, 2) Know the recognition and measurement criteria, 3) Be familiar with the disclosure requirements. Practice applying these concepts to various scenarios.'),
            CONCAT('Remember: ', COALESCE(subject_code_var, 'Subject'), ' - ', LEFT(COALESCE(topic_name_var, 'Topic'), 30)),
            1,
            'EXAM'
        );
        
        SET exp_counter = exp_counter + 1;
        SET q_id = q_id + 1;
    END WHILE;
END//

DELIMITER ;

-- Execute the procedure
CALL generate_paid_explanations();

-- Drop the procedure after use
DROP PROCEDURE IF EXISTS generate_paid_explanations;


-- =====================================================
-- SECTION 5: UPGRADE TEST USER TO PAID (user_id = 1)
-- =====================================================

-- Update user_subscriptions_v2 to PAID status
UPDATE user_subscriptions_v2 
SET subscription_type = 'PAID',
    is_active = TRUE,
    start_date = CURDATE(),
    end_date = DATE_ADD(CURDATE(), INTERVAL 30 DAY),
    updated_at = NOW()
WHERE user_id = 1;

-- If no rows affected, insert new subscription
INSERT INTO user_subscriptions_v2 (user_id, plan_id, subscription_type, is_active, start_date, end_date, created_at, updated_at)
SELECT 1, 2, 'PAID', TRUE, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY), NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM user_subscriptions_v2 WHERE user_id = 1);


-- =====================================================
-- SECTION 6: RESTORE FOREIGN KEY CHECKS
-- =====================================================
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;


-- =====================================================
-- VERIFICATION QUERIES (Run after migration)
-- =====================================================

-- Count questions by access type
-- SELECT access_type, COUNT(*) as count FROM questions WHERE is_active=1 GROUP BY access_type;
-- Expected: FREE=50, PAID=225

-- Count practice sets by access type
-- SELECT access_type, COUNT(*) as count FROM practice_sets WHERE is_active=1 GROUP BY access_type;
-- Expected: FREE=6, PAID=3

-- Verify difficulty distribution per set
-- SELECT practice_set_id, difficulty_level, COUNT(*) as count
-- FROM questions WHERE practice_set_id IN (200,201,202)
-- GROUP BY practice_set_id, difficulty_level
-- ORDER BY practice_set_id, difficulty_level;

-- Verify subject distribution per set
-- SELECT ps.set_name, s.subject_code, COUNT(*) as question_count
-- FROM questions q
-- JOIN practice_sets ps ON q.practice_set_id = ps.practice_set_id
-- JOIN topics t ON q.topic_id = t.topic_id
-- JOIN subjects s ON t.subject_id = s.subject_id
-- WHERE q.practice_set_id IN (200, 201, 202)
-- GROUP BY ps.set_name, s.subject_code
-- ORDER BY ps.practice_set_id, s.subject_id;

-- Verify choices exist for all questions
-- SELECT COUNT(DISTINCT question_id) as questions_with_choices
-- FROM question_choices WHERE question_id BETWEEN 1001 AND 1225;
-- Expected: 225

-- Verify explanations exist for all questions
-- SELECT COUNT(*) as explanation_count
-- FROM question_explanations WHERE question_id BETWEEN 1001 AND 1225;
-- Expected: 225
