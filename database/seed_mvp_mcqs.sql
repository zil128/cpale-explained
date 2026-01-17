-- ============================================================================
-- CPALE EXPLAINED - MVP MCQ Seeding
-- Creates Practice Sets and Seeds MCQs for testing
-- ============================================================================

SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================================
-- STEP 1: Create Practice Sets for each subject
-- Practice Set 01 = FREE (first 50 MCQs per subject spread across topics)
-- Practice Set 02 = BASIC (next 75 MCQs per subject)
-- ============================================================================

-- Clear existing practice sets and questions
DELETE FROM question_explanations;
DELETE FROM question_choices;
DELETE FROM questions;
DELETE FROM practice_sets;

-- FAR Practice Sets
INSERT INTO practice_sets (topic_id, set_code, set_name, set_type, is_paid, display_order, is_active, questions_per_set, access_level) VALUES
((SELECT topic_id FROM topics WHERE topic_code = 'FAR-2.0'), 'FAR-PS-01', 'FAR Practice Set 01', 'PRACTICE', 0, 1, 1, 50, 'FREE'),
((SELECT topic_id FROM topics WHERE topic_code = 'FAR-2.0'), 'FAR-PS-02', 'FAR Practice Set 02', 'PRACTICE', 1, 2, 1, 75, 'BASIC');

-- AFAR Practice Sets
INSERT INTO practice_sets (topic_id, set_code, set_name, set_type, is_paid, display_order, is_active, questions_per_set, access_level) VALUES
((SELECT topic_id FROM topics WHERE topic_code = 'AFAR-1.0'), 'AFAR-PS-01', 'AFAR Practice Set 01', 'PRACTICE', 0, 1, 1, 50, 'FREE'),
((SELECT topic_id FROM topics WHERE topic_code = 'AFAR-1.0'), 'AFAR-PS-02', 'AFAR Practice Set 02', 'PRACTICE', 1, 2, 1, 75, 'BASIC');

-- AUD Practice Sets
INSERT INTO practice_sets (topic_id, set_code, set_name, set_type, is_paid, display_order, is_active, questions_per_set, access_level) VALUES
((SELECT topic_id FROM topics WHERE topic_code = 'AUD-1.0'), 'AUD-PS-01', 'AUD Practice Set 01', 'PRACTICE', 0, 1, 1, 50, 'FREE'),
((SELECT topic_id FROM topics WHERE topic_code = 'AUD-1.0'), 'AUD-PS-02', 'AUD Practice Set 02', 'PRACTICE', 1, 2, 1, 75, 'BASIC');

-- TAX Practice Sets
INSERT INTO practice_sets (topic_id, set_code, set_name, set_type, is_paid, display_order, is_active, questions_per_set, access_level) VALUES
((SELECT topic_id FROM topics WHERE topic_code = 'TAX-1.0'), 'TAX-PS-01', 'TAX Practice Set 01', 'PRACTICE', 0, 1, 1, 50, 'FREE'),
((SELECT topic_id FROM topics WHERE topic_code = 'TAX-1.0'), 'TAX-PS-02', 'TAX Practice Set 02', 'PRACTICE', 1, 2, 1, 75, 'BASIC');

-- MS Practice Sets
INSERT INTO practice_sets (topic_id, set_code, set_name, set_type, is_paid, display_order, is_active, questions_per_set, access_level) VALUES
((SELECT topic_id FROM topics WHERE topic_code = 'MS-1.0'), 'MS-PS-01', 'MS Practice Set 01', 'PRACTICE', 0, 1, 1, 50, 'FREE'),
((SELECT topic_id FROM topics WHERE topic_code = 'MS-1.0'), 'MS-PS-02', 'MS Practice Set 02', 'PRACTICE', 1, 2, 1, 75, 'BASIC');

-- RFBT Practice Sets
INSERT INTO practice_sets (topic_id, set_code, set_name, set_type, is_paid, display_order, is_active, questions_per_set, access_level) VALUES
((SELECT topic_id FROM topics WHERE topic_code = 'RFBT-1.0'), 'RFBT-PS-01', 'RFBT Practice Set 01', 'PRACTICE', 0, 1, 1, 50, 'FREE'),
((SELECT topic_id FROM topics WHERE topic_code = 'RFBT-1.0'), 'RFBT-PS-02', 'RFBT Practice Set 02', 'PRACTICE', 1, 2, 1, 75, 'BASIC');

-- ============================================================================
-- STEP 2: Get Practice Set IDs
-- ============================================================================
SET @far_ps1 = (SELECT practice_set_id FROM practice_sets WHERE set_code = 'FAR-PS-01');
SET @far_ps2 = (SELECT practice_set_id FROM practice_sets WHERE set_code = 'FAR-PS-02');
SET @afar_ps1 = (SELECT practice_set_id FROM practice_sets WHERE set_code = 'AFAR-PS-01');
SET @afar_ps2 = (SELECT practice_set_id FROM practice_sets WHERE set_code = 'AFAR-PS-02');
SET @aud_ps1 = (SELECT practice_set_id FROM practice_sets WHERE set_code = 'AUD-PS-01');
SET @aud_ps2 = (SELECT practice_set_id FROM practice_sets WHERE set_code = 'AUD-PS-02');
SET @tax_ps1 = (SELECT practice_set_id FROM practice_sets WHERE set_code = 'TAX-PS-01');
SET @tax_ps2 = (SELECT practice_set_id FROM practice_sets WHERE set_code = 'TAX-PS-02');
SET @ms_ps1 = (SELECT practice_set_id FROM practice_sets WHERE set_code = 'MS-PS-01');
SET @ms_ps2 = (SELECT practice_set_id FROM practice_sets WHERE set_code = 'MS-PS-02');
SET @rfbt_ps1 = (SELECT practice_set_id FROM practice_sets WHERE set_code = 'RFBT-PS-01');
SET @rfbt_ps2 = (SELECT practice_set_id FROM practice_sets WHERE set_code = 'RFBT-PS-02');

-- Get Topic IDs
SET @far_topic_1 = (SELECT topic_id FROM topics WHERE topic_code = 'FAR-2.0' LIMIT 1);
SET @afar_topic_1 = (SELECT topic_id FROM topics WHERE topic_code = 'AFAR-1.0' LIMIT 1);
SET @aud_topic_1 = (SELECT topic_id FROM topics WHERE topic_code = 'AUD-1.0' LIMIT 1);
SET @tax_topic_1 = (SELECT topic_id FROM topics WHERE topic_code = 'TAX-1.0' LIMIT 1);
SET @ms_topic_1 = (SELECT topic_id FROM topics WHERE topic_code = 'MS-1.0' LIMIT 1);
SET @rfbt_topic_1 = (SELECT topic_id FROM topics WHERE topic_code = 'RFBT-1.0' LIMIT 1);

-- ============================================================================
-- STEP 3: Seed FAR MCQs for Practice Set 01 (FREE)
-- ============================================================================

-- FAR Q1: Conceptual Framework - Objective
INSERT INTO questions (practice_set_id, topic_id, question_code, question_text, difficulty_level, is_active, access_level) VALUES
(@far_ps1, @far_topic_1, 'FAR-PS01-001', 'According to the Conceptual Framework, which of the following is the primary objective of general purpose financial reporting?', 'MEDIUM', TRUE, 'FREE');
SET @q_id = LAST_INSERT_ID();
INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct) VALUES
(@q_id, 'A', 'To provide information useful for making decisions about providing resources to the entity', TRUE),
(@q_id, 'B', 'To determine the taxable income of the entity', FALSE),
(@q_id, 'C', 'To assess management performance for bonus purposes', FALSE),
(@q_id, 'D', 'To comply with regulatory requirements', FALSE);
INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip) VALUES
(@q_id,
'Financial statements exist mainly to help people decide whether to invest money in or lend money to a company.',
'Imagine you are an investor deciding whether to buy shares in Company ABC. You need information about the company''s financial health, its ability to generate cash, and its future prospects. The financial statements provide this information to help you make an informed decision.\n\nThe Conceptual Framework establishes that general purpose financial reports are primarily designed to serve existing and potential investors, lenders, and other creditors in making decisions about providing resources to the entity.\n\nFORMAL DEFINITION: The objective of general purpose financial reporting is to provide financial information about the reporting entity that is useful to existing and potential investors, lenders, and other creditors in making decisions relating to providing resources to the entity.\n\nELEMENTS:\n1. Primary users: investors, lenders, creditors\n2. Purpose: decision-making about resources\n3. Information needed: economic resources, claims, changes\n\nREFERENCE: Conceptual Framework for Financial Reporting, Chapter 1, Paragraphs 1.2-1.4',
'B is wrong - tax determination is a separate objective under tax laws, not PFRS\nC is wrong - management performance assessment is secondary, not primary\nD is wrong - regulatory compliance is a consequence, not the primary objective',
'Financial statements = INVESTOR DECISION TOOL');

-- FAR Q2: Qualitative Characteristics - Relevance
INSERT INTO questions (practice_set_id, topic_id, question_code, question_text, difficulty_level, is_active, access_level) VALUES
(@far_ps1, @far_topic_1, 'FAR-PS01-002', 'Which qualitative characteristic of useful financial information makes it capable of making a difference in user decisions?', 'EASY', TRUE, 'FREE');
SET @q_id = LAST_INSERT_ID();
INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct) VALUES
(@q_id, 'A', 'Faithful representation', FALSE),
(@q_id, 'B', 'Relevance', TRUE),
(@q_id, 'C', 'Comparability', FALSE),
(@q_id, 'D', 'Verifiability', FALSE);
INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip) VALUES
(@q_id,
'Relevant information is information that matters - it can change your mind about something.',
'Think of buying a car. Information about the car''s mileage and accident history is RELEVANT because it affects your decision. Information about what color the previous owner''s shoes were is NOT relevant - it makes no difference to your decision.\n\nRelevance is one of the two fundamental qualitative characteristics. Information is relevant if it has predictive value, confirmatory value, or both.\n\nFORMAL DEFINITION: Financial information is relevant if it is capable of making a difference in decisions made by users. Information has this capability if it has predictive value, confirmatory value, or both.\n\nELEMENTS:\n1. Predictive value - helps forecast future outcomes\n2. Confirmatory value - confirms or changes prior expectations\n3. Materiality - affects decisions if omitted or misstated\n\nDISTINCTION: Relevance is about WHAT information to report; Faithful representation is about HOW to report it accurately.\n\nREFERENCE: Conceptual Framework, Chapter 2, Paragraphs 2.6-2.10',
'A is wrong - faithful representation is about accuracy, not decision-usefulness\nC is wrong - comparability is an enhancing characteristic, not fundamental\nD is wrong - verifiability is also an enhancing characteristic',
'RELEVANT = Makes a DIFFERENCE in decisions');

-- FAR Q3: Asset Definition
INSERT INTO questions (practice_set_id, topic_id, question_code, question_text, difficulty_level, is_active, access_level) VALUES
(@far_ps1, @far_topic_1, 'FAR-PS01-003', 'Under the Conceptual Framework, an asset is defined as:', 'MEDIUM', TRUE, 'FREE');
SET @q_id = LAST_INSERT_ID();
INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct) VALUES
(@q_id, 'A', 'A present economic resource controlled by the entity as a result of past events', TRUE),
(@q_id, 'B', 'Something the entity owns legally', FALSE),
(@q_id, 'C', 'Cash or items convertible to cash within one year', FALSE),
(@q_id, 'D', 'Resources that will definitely generate future cash flows', FALSE);
INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip) VALUES
(@q_id,
'An asset is something valuable that you control and can use to generate benefits, even if you don''t legally own it.',
'A company leases a delivery truck for 5 years. The company doesn''t OWN the truck legally, but it CONTROLS the economic benefits from using it. Under the new definition, this right-of-use is an asset because the company controls an economic resource.\n\nThe 2018 Conceptual Framework defines an asset focusing on economic resources and control, not legal ownership.\n\nFORMAL DEFINITION: An asset is a present economic resource controlled by the entity as a result of past events. An economic resource is a right that has the potential to produce economic benefits.\n\nELEMENTS:\n1. Present economic resource (not future)\n2. Controlled by the entity\n3. Result of past events\n4. Has potential to produce economic benefits\n\nDISTINCTION: Control ≠ Legal ownership. A leased asset is controlled but not owned.\n\nREFERENCE: Conceptual Framework 2018, Chapter 4, Paragraphs 4.3-4.4',
'B is wrong - control, not legal ownership, is the criterion\nC is wrong - this describes current assets only, not all assets\nD is wrong - potential for benefits is sufficient; certainty is not required',
'ASSET = Control + Economic Resource + Past Event');

-- FAR Q4: Enhancing Characteristics
INSERT INTO questions (practice_set_id, topic_id, question_code, question_text, difficulty_level, is_active, access_level) VALUES
(@far_ps1, @far_topic_1, 'FAR-PS01-004', 'Which of the following is NOT an enhancing qualitative characteristic under the Conceptual Framework?', 'EASY', TRUE, 'FREE');
SET @q_id = LAST_INSERT_ID();
INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct) VALUES
(@q_id, 'A', 'Comparability', FALSE),
(@q_id, 'B', 'Verifiability', FALSE),
(@q_id, 'C', 'Relevance', TRUE),
(@q_id, 'D', 'Understandability', FALSE);
INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip) VALUES
(@q_id,
'Relevance is a must-have characteristic, not just a nice-to-have enhancement.',
'Think of a cake recipe. The FUNDAMENTAL ingredients are flour and eggs - without them, it''s not a cake. Sugar and frosting ENHANCE the cake but aren''t essential. Similarly, Relevance is FUNDAMENTAL to financial reporting.\n\nThe Conceptual Framework classifies qualitative characteristics into Fundamental (Relevance, Faithful Representation) and Enhancing (Comparability, Verifiability, Timeliness, Understandability).\n\nFORMAL DEFINITION: Fundamental qualitative characteristics are Relevance and Faithful Representation. Enhancing qualitative characteristics are Comparability, Verifiability, Timeliness, and Understandability.\n\nELEMENTS:\nFUNDAMENTAL:\n1. Relevance\n2. Faithful Representation\n\nENHANCING (CVTU):\n1. Comparability\n2. Verifiability\n3. Timeliness\n4. Understandability\n\nDISTINCTION: Fundamental = essential for usefulness; Enhancing = improves usefulness but not essential\n\nREFERENCE: Conceptual Framework, Chapter 2, Paragraphs 2.4-2.36',
'A, B, D are wrong - these are all enhancing characteristics\nC is correct - Relevance is a FUNDAMENTAL characteristic, not enhancing',
'Fundamental = RF (Relevance, Faithful Rep); Enhancing = CVTU');

-- FAR Q5: Income Definition
INSERT INTO questions (practice_set_id, topic_id, question_code, question_text, difficulty_level, is_active, access_level) VALUES
(@far_ps1, @far_topic_1, 'FAR-PS01-005', 'According to the Conceptual Framework, income includes:', 'MEDIUM', TRUE, 'FREE');
SET @q_id = LAST_INSERT_ID();
INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct) VALUES
(@q_id, 'A', 'Revenue only', FALSE),
(@q_id, 'B', 'Revenue and gains', TRUE),
(@q_id, 'C', 'Revenue, gains, and owner contributions', FALSE),
(@q_id, 'D', 'All increases in assets', FALSE);
INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip) VALUES
(@q_id,
'Income means any money coming in that makes the owners richer - whether from regular business or occasional windfalls.',
'A bakery makes money from selling bread (REVENUE - main activity) and also from selling an old oven (GAIN - not main activity). Both increase the owner''s wealth, so both are INCOME.\n\nThe Conceptual Framework defines income broadly to include both revenue from ordinary activities and gains.\n\nFORMAL DEFINITION: Income is increases in assets, or decreases in liabilities, that result in increases in equity, other than those relating to contributions from holders of equity claims. It encompasses both revenue and gains.\n\nELEMENTS:\nINCOME includes:\n1. Revenue (ordinary activities)\n2. Gains (non-ordinary activities)\n\nDoes NOT include:\n- Owner contributions\n\nDISTINCTION: Revenue = regular business income; Gains = incidental/peripheral income. Both are INCOME.\n\nREFERENCE: Conceptual Framework, Chapter 4, Paragraphs 4.68-4.72',
'A is wrong - income includes gains too\nC is wrong - owner contributions are equity, not income\nD is wrong - not ALL asset increases are income (e.g., borrowing increases assets but isn''t income)',
'INCOME = Revenue + Gains (excludes owner contributions)');

-- ============================================================================
-- AFAR MCQs for Practice Set 01 (FREE)
-- ============================================================================

-- AFAR Q1: Partnership Formation
INSERT INTO questions (practice_set_id, topic_id, question_code, question_text, difficulty_level, is_active, access_level) VALUES
(@afar_ps1, @afar_topic_1, 'AFAR-PS01-001', 'When partners contribute assets to a partnership, at what value should these assets be recorded?', 'EASY', TRUE, 'FREE');
SET @q_id = LAST_INSERT_ID();
INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct) VALUES
(@q_id, 'A', 'At the original cost to the contributing partner', FALSE),
(@q_id, 'B', 'At the agreed value by the partners', TRUE),
(@q_id, 'C', 'At the book value in the partner''s records', FALSE),
(@q_id, 'D', 'At the lower of cost or market value', FALSE);
INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip) VALUES
(@q_id,
'Partners can agree on whatever value they want for contributed assets - it''s their deal.',
'Juan contributes a building he bought for P1M five years ago. Today it''s worth P2M. His partner Maria says "Let''s value it at P1.8M" and Juan agrees. The partnership records the building at P1.8M - the AGREED value, not the original cost or current market value.\n\nPartnership accounting follows the principle that contributed assets should be recorded at their agreed upon fair value, as mutually determined by the partners.\n\nFORMAL DEFINITION: Assets contributed to a partnership should be recorded at their fair values as agreed upon by the partners. This agreed value becomes the basis for the contributing partner''s capital credit.\n\nELEMENTS:\n1. Partners must mutually agree on value\n2. Fair value is the typical basis\n3. Agreement overrides original cost\n4. Value determines capital credit\n\nDISTINCTION: Original cost (what partner paid) ≠ Agreed value (what partners decide) ≠ Book value (accounting records)\n\nREFERENCE: PAS 28, Civil Code Articles 1784-1785',
'A is wrong - original cost is irrelevant; the NEW partnership starts fresh\nC is wrong - book value may differ from fair/agreed value\nD is wrong - no such rule; it''s purely based on agreement',
'Partnership contribution = AGREED VALUE (partners decide)');

-- AFAR Q2: Bonus Method
INSERT INTO questions (practice_set_id, topic_id, question_code, question_text, difficulty_level, is_active, access_level) VALUES
(@afar_ps1, @afar_topic_1, 'AFAR-PS01-002', 'Under the bonus method of recording admission of a new partner, when the new partner receives a capital credit greater than the amount invested, the bonus is:', 'MEDIUM', TRUE, 'FREE');
SET @q_id = LAST_INSERT_ID();
INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct) VALUES
(@q_id, 'A', 'Charged to the new partner', FALSE),
(@q_id, 'B', 'Credited to Goodwill account', FALSE),
(@q_id, 'C', 'Charged to the old partners'' capital accounts', TRUE),
(@q_id, 'D', 'Recorded as partnership expense', FALSE);
INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip) VALUES
(@q_id,
'Old partners are giving away part of their capital to attract the new partner - like paying them to join.',
'A and B have a partnership worth P200,000. C invests P50,000 for 30% interest. C gets P75,000 capital (30% of P250,000). C only invested P50,000 but got P75,000 credit. The extra P25,000 is a BONUS taken from A and B''s capitals.\n\nWhen a new partner receives capital credit exceeding their investment, the excess represents a bonus from existing partners to the new partner.\n\nFORMAL DEFINITION: Under the bonus method, when a new partner receives a capital interest greater than the cash or asset contributed, the difference is treated as a bonus from the existing partners to the new partner, charged against their capital accounts.\n\nELEMENTS:\n1. Calculate total capital after admission\n2. Calculate new partner''s share of total capital\n3. Compare to actual contribution\n4. Excess = bonus FROM old partners\n\nDISTINCTION: Bonus method: No new assets created. Goodwill method: Imputed asset recorded.\n\nREFERENCE: Generally Accepted Accounting Principles for Partnerships',
'A is wrong - the bonus is FROM old partners, not charged to new partner\nB is wrong - bonus method does NOT record goodwill\nD is wrong - it''s a capital adjustment, not an expense',
'Capital credit > Investment = Bonus FROM old partners');

-- AFAR Q3: Partnership Liquidation
INSERT INTO questions (practice_set_id, topic_id, question_code, question_text, difficulty_level, is_active, access_level) VALUES
(@afar_ps1, @afar_topic_1, 'AFAR-PS01-003', 'In partnership liquidation, what is the correct order of priority for cash distribution?', 'MEDIUM', TRUE, 'FREE');
SET @q_id = LAST_INSERT_ID();
INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct) VALUES
(@q_id, 'A', 'Partners'' capitals, then partners'' loans, then outside creditors', FALSE),
(@q_id, 'B', 'Outside creditors, then partners'' capitals, then partners'' loans', FALSE),
(@q_id, 'C', 'Outside creditors, then partners'' loans, then partners'' capitals', TRUE),
(@q_id, 'D', 'Partners'' loans, then outside creditors, then partners'' capitals', FALSE);
INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip) VALUES
(@q_id,
'Outsiders first (they have no other claim), then partners who lent money, then partners'' investments.',
'A partnership is closing down with P100,000 cash. It owes P40,000 to suppliers, P30,000 to Partner A (loan), and the partners have P50,000 in capital. Pay: First, suppliers get P40,000. Second, Partner A''s loan gets P30,000. Third, remaining P30,000 goes to capital.\n\nThe marshalling of assets doctrine requires a specific order of payment during liquidation.\n\nFORMAL DEFINITION: Under Article 1839 of the Civil Code, in settling accounts after dissolution, liabilities are ranked: (1) those owing to creditors other than partners, (2) those owing to partners other than for capital and profits, (3) those owing to partners for capital.\n\nELEMENTS:\nORDER OF PAYMENT:\n1. Outside creditors\n2. Partners'' loans/advances\n3. Partners'' capital\n4. Profit distributions\n\nDISTINCTION: Partner as creditor (lender) ≠ Partner as owner (capital). Creditor status has priority.\n\nREFERENCE: Civil Code, Article 1839; PAS 28',
'A is wrong - outside creditors have FIRST priority, not last\nB is wrong - partners'' loans come before capital\nD is wrong - outside creditors must be paid first',
'Priority: OLC = Outside → Loans → Capital');

-- AFAR Q4: Home Office and Branch
INSERT INTO questions (practice_set_id, topic_id, question_code, question_text, difficulty_level, is_active, access_level) VALUES
(@afar_ps1, @afar_topic_1, 'AFAR-PS01-004', 'In home office and branch accounting, the Investment in Branch account in the home office books and the Home Office account in the branch books are:', 'EASY', TRUE, 'FREE');
SET @q_id = LAST_INSERT_ID();
INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct) VALUES
(@q_id, 'A', 'Both asset accounts', FALSE),
(@q_id, 'B', 'Both liability accounts', FALSE),
(@q_id, 'C', 'Reciprocal accounts that should be equal', TRUE),
(@q_id, 'D', 'Expense accounts', FALSE);
INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip) VALUES
(@q_id,
'These accounts talk to each other - they''re like two sides of the same conversation and must always match.',
'Think of it like a parent giving money to a child. Parent records "I gave my child P1,000" (Investment in Branch). Child records "I received P1,000 from parent" (Home Office). Both records should match!\n\nThese accounts are mirror images of each other - what one records as a debit, the other records as a credit, and the balances should always be equal.\n\nFORMAL DEFINITION: Investment in Branch and Home Office accounts are reciprocal accounts. The debit balance in Investment in Branch at the home office equals the credit balance in Home Office at the branch.\n\nELEMENTS:\nRECIPROCAL ACCOUNTS:\n- Home Office: Investment in Branch (Asset/Debit)\n- Branch: Home Office (Equity/Credit)\n- Must always balance\n\nDISTINCTION: Investment in Branch is an asset (debit) while Home Office is like equity (credit), but they always equal.\n\nREFERENCE: Generally Accepted Accounting Principles; Home Office-Branch Accounting Standards',
'A is wrong - Investment in Branch is an asset but Home Office is not\nB is wrong - neither is a liability\nD is wrong - neither is an expense',
'Investment in Branch = Home Office (Mirror accounts)');

-- AFAR Q5: Business Combination
INSERT INTO questions (practice_set_id, topic_id, question_code, question_text, difficulty_level, is_active, access_level) VALUES
(@afar_ps1, @afar_topic_1, 'AFAR-PS01-005', 'Under PFRS 3 Business Combinations, the acquisition method requires the acquirer to measure identifiable assets acquired at:', 'MEDIUM', TRUE, 'FREE');
SET @q_id = LAST_INSERT_ID();
INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct) VALUES
(@q_id, 'A', 'Book value', FALSE),
(@q_id, 'B', 'Fair value at the acquisition date', TRUE),
(@q_id, 'C', 'Historical cost', FALSE),
(@q_id, 'D', 'Replacement cost', FALSE);
INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip) VALUES
(@q_id,
'When you buy a company, you record everything at what it''s actually worth today, not what they paid for it years ago.',
'Company A buys Company B for P10M. B''s building has a book value of P2M but market value of P5M. Company A records the building at P5M (fair value), not P2M (book value). The acquirer pays for what things are WORTH, not what they COST.\n\nPFRS 3 requires all identifiable assets and liabilities acquired to be measured at fair value as of the acquisition date.\n\nFORMAL DEFINITION: The acquirer shall measure the identifiable assets acquired, the liabilities assumed and any non-controlling interest in the acquiree at their acquisition-date fair values.\n\nELEMENTS:\nACQUISITION METHOD:\n1. Identify the acquirer\n2. Determine acquisition date\n3. Measure fair value of identifiable assets/liabilities\n4. Recognize goodwill or gain\n\nDISTINCTION: Fair value (what it''s worth) ≠ Book value (what''s recorded) ≠ Historical cost (what was paid)\n\nREFERENCE: PFRS 3 Business Combinations, Paragraphs 10-20',
'A is wrong - book value ignores appreciation/depreciation\nC is wrong - historical cost is acquiree''s cost, not current value\nD is wrong - replacement cost is not the PFRS 3 measurement basis',
'Acquisition = FAIR VALUE at acquisition date');

-- ============================================================================
-- AUD MCQs for Practice Set 01 (FREE)
-- ============================================================================

-- AUD Q1: Audit Definition
INSERT INTO questions (practice_set_id, topic_id, question_code, question_text, difficulty_level, is_active, access_level) VALUES
(@aud_ps1, @aud_topic_1, 'AUD-PS01-001', 'Which of the following best describes the primary purpose of an external audit of financial statements?', 'EASY', TRUE, 'FREE');
SET @q_id = LAST_INSERT_ID();
INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct) VALUES
(@q_id, 'A', 'To detect all fraud in the financial statements', FALSE),
(@q_id, 'B', 'To express an opinion on whether the financial statements are fairly presented', TRUE),
(@q_id, 'C', 'To guarantee the accuracy of the financial statements', FALSE),
(@q_id, 'D', 'To prepare the financial statements for the client', FALSE);
INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip) VALUES
(@q_id,
'Auditors give their professional opinion - like a second opinion from a doctor. They don''t guarantee perfection.',
'Imagine hiring a home inspector before buying a house. The inspector doesn''t GUARANTEE no problems exist or FIND every hidden issue. They give their OPINION on whether the house is in reasonable condition based on their examination.\n\nExternal auditors provide reasonable assurance, not absolute assurance, about the fair presentation of financial statements.\n\nFORMAL DEFINITION: An audit provides reasonable assurance about whether the financial statements as a whole are free from material misstatement, enabling the auditor to express an opinion.\n\nELEMENTS:\nAUDIT CHARACTERISTICS:\n1. Reasonable assurance (not absolute)\n2. Opinion on fair presentation\n3. Material misstatements focus\n4. In accordance with framework\n\nDISTINCTION: Audit (opinion) ≠ Review (limited assurance) ≠ Compilation (no assurance)\n\nREFERENCE: PSA 200, Paragraphs 3-11',
'A is wrong - auditors are not responsible for detecting ALL fraud\nC is wrong - auditors don''t guarantee accuracy\nD is wrong - management prepares financial statements, not auditors',
'Audit = OPINION on fair presentation (not guarantee)');

-- AUD Q2: Audit Evidence
INSERT INTO questions (practice_set_id, topic_id, question_code, question_text, difficulty_level, is_active, access_level) VALUES
(@aud_ps1, @aud_topic_1, 'AUD-PS01-002', 'Which type of audit evidence is generally considered most reliable?', 'MEDIUM', TRUE, 'FREE');
SET @q_id = LAST_INSERT_ID();
INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct) VALUES
(@q_id, 'A', 'Oral representations from management', FALSE),
(@q_id, 'B', 'Internally generated documents', FALSE),
(@q_id, 'C', 'Documentary evidence obtained directly from external third parties', TRUE),
(@q_id, 'D', 'Computations made by the client', FALSE);
INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip) VALUES
(@q_id,
'Trust information from outsiders more than from the company being audited - they have no reason to lie.',
'If someone claims they deposited P1M in the bank, which would you trust more: (A) them telling you, (B) their own receipt, (C) a letter directly from the bank confirming it, or (D) their calculator showing P1M? Obviously the bank letter - it''s from an independent source!\n\nEvidence from independent external sources is more reliable because it''s not subject to manipulation by the client.\n\nFORMAL DEFINITION: Audit evidence is more reliable when it is obtained from independent sources outside the entity, when it exists in documentary form, and when it is obtained directly by the auditor.\n\nELEMENTS:\nRELIABILITY HIERARCHY:\n1. External documentary (most reliable)\n2. Internal documentary with external circulation\n3. Internal documentary only\n4. Oral evidence (least reliable)\n\nDISTINCTION: External evidence (from third parties) > Internal evidence (from client)\n\nREFERENCE: PSA 500, Paragraphs A5-A9',
'A is wrong - oral evidence is least reliable\nB is wrong - internal documents can be manipulated\nD is wrong - client computations may contain errors',
'EXTERNAL evidence = MOST reliable (independent source)');

-- AUD Q3: Material Misstatement
INSERT INTO questions (practice_set_id, topic_id, question_code, question_text, difficulty_level, is_active, access_level) VALUES
(@aud_ps1, @aud_topic_1, 'AUD-PS01-003', 'A misstatement is considered material if it could reasonably be expected to:', 'MEDIUM', TRUE, 'FREE');
SET @q_id = LAST_INSERT_ID();
INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct) VALUES
(@q_id, 'A', 'Cause the auditor to modify the opinion', FALSE),
(@q_id, 'B', 'Influence the economic decisions of users', TRUE),
(@q_id, 'C', 'Result in criminal prosecution', FALSE),
(@q_id, 'D', 'Exceed 10% of net income', FALSE);
INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip) VALUES
(@q_id,
'Material = Big enough to matter. Would this error change someone''s mind about investing or lending?',
'Imagine you''re buying Company X shares. A P100 error in a P10M company? You don''t care. A P500,000 error? Now you''re reconsidering! An error is MATERIAL if it''s big enough to change your investment decision.\n\nMateriality is judged from the perspective of the user making decisions, not from arbitrary percentage rules.\n\nFORMAL DEFINITION: Misstatements are considered to be material if they, individually or in aggregate, could reasonably be expected to influence the economic decisions of users taken on the basis of the financial statements.\n\nELEMENTS:\nMATERIALITY CONSIDERATIONS:\n1. Size (quantitative)\n2. Nature (qualitative)\n3. Circumstances\n4. User perspective\n\nDISTINCTION: Material (affects decisions) ≠ Immaterial (too small to matter). No fixed percentage rule.\n\nREFERENCE: PSA 320, Paragraphs 2-6',
'A is wrong - modified opinion is a result, not the definition of materiality\nC is wrong - criminal prosecution is a legal matter, unrelated\nD is wrong - there''s no fixed percentage; it depends on circumstances',
'MATERIAL = Would it change USER DECISIONS?');

-- AUD Q4: Going Concern
INSERT INTO questions (practice_set_id, topic_id, question_code, question_text, difficulty_level, is_active, access_level) VALUES
(@aud_ps1, @aud_topic_1, 'AUD-PS01-004', 'What is the standard period for management to assess going concern in preparing financial statements?', 'EASY', TRUE, 'FREE');
SET @q_id = LAST_INSERT_ID();
INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct) VALUES
(@q_id, 'A', 'Six months from the balance sheet date', FALSE),
(@q_id, 'B', 'At least twelve months from the balance sheet date', TRUE),
(@q_id, 'C', 'Three years from the balance sheet date', FALSE),
(@q_id, 'D', 'Indefinitely into the future', FALSE);
INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip) VALUES
(@q_id,
'Management must look at least one year ahead and honestly assess: Will the company survive?',
'A company prepares financial statements as of December 31, 2025. Management must look at least until December 31, 2026, and ask: "Will we still be in business then?" If yes, prepare normal statements. If doubtful, disclose the concerns.\n\nThe going concern assessment period is standardized to ensure consistency and adequate forward-looking analysis.\n\nFORMAL DEFINITION: Management shall assess the entity''s ability to continue as a going concern for a period of at least twelve months from the end of the reporting period.\n\nELEMENTS:\nGOING CONCERN ASSESSMENT:\n1. Period: At least 12 months\n2. From: Balance sheet date (or audit report date per PSA 570)\n3. Consider: All available information\n\nDISTINCTION: Management assessment (12 months from BS date) vs Auditor assessment (12 months from audit report date)\n\nREFERENCE: PAS 1, Paragraph 26; PSA 570',
'A is wrong - six months is too short\nC is wrong - three years is beyond the requirement\nD is wrong - indefinite assessment is impractical',
'Going Concern = Look at least 12 MONTHS ahead');

-- AUD Q5: Internal Control
INSERT INTO questions (practice_set_id, topic_id, question_code, question_text, difficulty_level, is_active, access_level) VALUES
(@aud_ps1, @aud_topic_1, 'AUD-PS01-005', 'Which component of internal control involves management''s philosophy and operating style?', 'MEDIUM', TRUE, 'FREE');
SET @q_id = LAST_INSERT_ID();
INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct) VALUES
(@q_id, 'A', 'Risk assessment', FALSE),
(@q_id, 'B', 'Control activities', FALSE),
(@q_id, 'C', 'Control environment', TRUE),
(@q_id, 'D', 'Monitoring', FALSE);
INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip) VALUES
(@q_id,
'Control environment = The company''s culture and values. It''s like the "personality" of the organization set by management.',
'Imagine a school. The CONTROL ENVIRONMENT is like the school culture - does the principal value honesty? Do teachers emphasize integrity? This "tone at the top" shapes everything else. If the principal cheats, students will too.\n\nThe control environment is the foundation of all other internal control components because it sets the tone for the organization.\n\nFORMAL DEFINITION: The control environment includes the governance and management functions and the attitudes, awareness, and actions of those charged with governance and management concerning internal control and its importance.\n\nELEMENTS:\nCONTROL ENVIRONMENT ELEMENTS:\n1. Integrity and ethical values\n2. Commitment to competence\n3. Management philosophy and style\n4. Organizational structure\n5. Assignment of authority\n\nDISTINCTION: Control environment (culture/tone) ≠ Control activities (specific policies/procedures)\n\nREFERENCE: PSA 315, Paragraphs A77-A87',
'A is wrong - risk assessment identifies and analyzes risks\nB is wrong - control activities are specific procedures\nD is wrong - monitoring evaluates control effectiveness',
'Control ENVIRONMENT = TONE at the TOP (culture)');

-- ============================================================================
-- TAX MCQs for Practice Set 01 (FREE)
-- ============================================================================

-- TAX Q1: Income Tax Principles
INSERT INTO questions (practice_set_id, topic_id, question_code, question_text, difficulty_level, is_active, access_level) VALUES
(@tax_ps1, @tax_topic_1, 'TAX-PS01-001', 'Under Philippine tax law, income is taxable when it is:', 'EASY', TRUE, 'FREE');
SET @q_id = LAST_INSERT_ID();
INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct) VALUES
(@q_id, 'A', 'Received in cash only', FALSE),
(@q_id, 'B', 'Realized and recognized, whether in cash or in kind', TRUE),
(@q_id, 'C', 'Deposited in a bank account', FALSE),
(@q_id, 'D', 'Reported in financial statements', FALSE);
INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip) VALUES
(@q_id,
'If you get something valuable, it''s income - doesn''t matter if it''s cash, property, or services.',
'Juan works as a consultant. His client gives him a brand new laptop worth P50,000 instead of cash payment. Even though Juan didn''t receive cash, he received something of value - the laptop is taxable income at P50,000.\n\nPhilippine taxation follows the principle that income is taxable regardless of the form it takes, as long as it has economic value.\n\nFORMAL DEFINITION: Gross income means all income derived from whatever source, whether in cash or in kind, not just limited to cash receipts.\n\nELEMENTS:\nINCOME IS TAXABLE IF:\n1. Realized (transaction occurred)\n2. Recognized (included in tax computation)\n3. Not specifically excluded by law\n4. From whatever source\n\nDISTINCTION: Cash basis (when received) vs Accrual basis (when earned). Both can create taxable income.\n\nREFERENCE: NIRC Section 32(A); RR 2-98',
'A is wrong - in-kind benefits are also taxable\nC is wrong - bank deposit is not the trigger\nD is wrong - financial reporting differs from tax reporting',
'Taxable income = Cash OR In Kind (any form of value)');

-- TAX Q2: Resident Citizen Taxation
INSERT INTO questions (practice_set_id, topic_id, question_code, question_text, difficulty_level, is_active, access_level) VALUES
(@tax_ps1, @tax_topic_1, 'TAX-PS01-002', 'A resident citizen of the Philippines is taxable on:', 'EASY', TRUE, 'FREE');
SET @q_id = LAST_INSERT_ID();
INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct) VALUES
(@q_id, 'A', 'Income from Philippine sources only', FALSE),
(@q_id, 'B', 'Income from foreign sources only', FALSE),
(@q_id, 'C', 'Income from sources within and without the Philippines', TRUE),
(@q_id, 'D', 'Capital gains only', FALSE);
INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip) VALUES
(@q_id,
'If you''re a Filipino living here, the Philippines taxes ALL your income, wherever in the world you earn it.',
'Maria is a Filipino living in Manila. She earns salary from her job (Philippine income) and receives dividends from US stocks (foreign income). As a resident citizen, Maria pays tax on BOTH - her total worldwide income.\n\nThe Philippines follows the principle of citizenship and residence in determining the scope of taxable income.\n\nFORMAL DEFINITION: A resident citizen is taxable on all income derived from sources within and without the Philippines (worldwide income taxation).\n\nELEMENTS:\nTAXATION SCOPE:\n- Resident Citizen: Worldwide\n- Non-resident Citizen: Philippine source only\n- Resident Alien: Philippine source only\n- Non-resident Alien: Philippine source only\n\nDISTINCTION: Resident citizen (worldwide) ≠ Non-resident citizen (Philippine source only)\n\nREFERENCE: NIRC Section 23',
'A is wrong - this applies to aliens and non-resident citizens\nB is wrong - Philippine income is definitely taxable\nD is wrong - all types of income are taxable, not just capital gains',
'Resident Citizen = WORLDWIDE income taxable');

-- TAX Q3: Exclusions from Gross Income
INSERT INTO questions (practice_set_id, topic_id, question_code, question_text, difficulty_level, is_active, access_level) VALUES
(@tax_ps1, @tax_topic_1, 'TAX-PS01-003', 'Which of the following is EXCLUDED from gross income?', 'MEDIUM', TRUE, 'FREE');
SET @q_id = LAST_INSERT_ID();
INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct) VALUES
(@q_id, 'A', 'Year-end bonus', FALSE),
(@q_id, 'B', 'Proceeds of life insurance paid to beneficiaries upon death of insured', TRUE),
(@q_id, 'C', 'Rental income', FALSE),
(@q_id, 'D', 'Professional fees', FALSE);
INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip) VALUES
(@q_id,
'Life insurance payouts when someone dies are tax-free - the government doesn''t tax money meant to replace a lost provider.',
'Pedro had life insurance of P1M. He passes away, and his wife receives P1M. This P1M is NOT taxable - it''s compensation for losing a loved one, not income from work or business.\n\nLife insurance proceeds compensate for a loss, so they are specifically excluded from gross income under the Tax Code.\n\nFORMAL DEFINITION: The proceeds of life insurance policies paid to the heirs or beneficiaries upon the death of the insured are excluded from gross income.\n\nELEMENTS:\nEXCLUSIONS FROM GROSS INCOME:\n1. Life insurance proceeds (death)\n2. Amounts received as return of premium\n3. Compensation for injuries/sickness\n4. Income exempt under treaty\n\nDISTINCTION: Life insurance (death proceeds - excluded) ≠ Matured endowment (taxable if gains exceed premiums)\n\nREFERENCE: NIRC Section 32(B)(1)',
'A is wrong - bonuses are part of compensation, taxable\nC is wrong - rental income is taxable\nD is wrong - professional fees are taxable income',
'Life insurance proceeds (DEATH) = TAX-FREE');

-- TAX Q4: De Minimis Benefits
INSERT INTO questions (practice_set_id, topic_id, question_code, question_text, difficulty_level, is_active, access_level) VALUES
(@tax_ps1, @tax_topic_1, 'TAX-PS01-004', 'Which of the following is considered a de minimis benefit exempt from income tax?', 'MEDIUM', TRUE, 'FREE');
SET @q_id = LAST_INSERT_ID();
INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct) VALUES
(@q_id, 'A', 'Rice subsidy of P2,500 per month', FALSE),
(@q_id, 'B', 'Rice subsidy of P2,000 per month or one sack of 50kg rice per month', TRUE),
(@q_id, 'C', 'Any amount of rice given by employer', FALSE),
(@q_id, 'D', 'Rice subsidy given once a year', FALSE);
INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip) VALUES
(@q_id,
'De minimis = small perks. The government doesn''t bother taxing tiny employee benefits within limits.',
'Your employer gives you P2,000 monthly for rice (or an actual 50kg sack). This is a small perk to help with basics - the government says "that''s fine, no tax." But if they give P3,000 monthly? The excess P1,000 becomes taxable.\n\nDe minimis benefits are small benefits that are exempt from tax up to specified ceiling amounts.\n\nFORMAL DEFINITION: Rice subsidy of P2,000 per month or one sack of 50kg rice per month is considered a de minimis benefit exempt from income tax.\n\nELEMENTS:\nRICE SUBSIDY DE MINIMIS:\n- Cash: Up to P2,000/month\n- OR In-kind: One 50kg sack/month\n- Excess over limit is taxable\n\nDISTINCTION: De minimis (exempt within limits) ≠ 13th month pay (exempt up to P90,000)\n\nREFERENCE: RR 11-2018; NIRC Section 32(B)(7)(e)',
'A is wrong - P2,500 exceeds the P2,000 limit, excess is taxable\nC is wrong - there''s a specific limit\nD is wrong - the limit is per month, not annual',
'Rice subsidy de minimis = P2,000/month OR 50kg/month');

-- TAX Q5: Withholding Tax
INSERT INTO questions (practice_set_id, topic_id, question_code, question_text, difficulty_level, is_active, access_level) VALUES
(@tax_ps1, @tax_topic_1, 'TAX-PS01-005', 'The final withholding tax on interest income from peso bank deposits is:', 'EASY', TRUE, 'FREE');
SET @q_id = LAST_INSERT_ID();
INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct) VALUES
(@q_id, 'A', 'Exempt from tax', FALSE),
(@q_id, 'B', 'Subject to 20% final tax', TRUE),
(@q_id, 'C', 'Subject to graduated rates', FALSE),
(@q_id, 'D', 'Subject to 10% final tax', FALSE);
INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip) VALUES
(@q_id,
'Banks take 20% of your interest earnings right away as final tax - you get the net amount.',
'You have P100,000 in a savings account earning P1,000 interest this year. The bank automatically deducts 20% (P200) as final tax before crediting P800 to your account. You don''t report this in your annual return - it''s already final.\n\nBank interest is subject to final withholding tax, meaning the tax withheld by the bank is the final tax - no need to include in annual ITR.\n\nFORMAL DEFINITION: Interest income from any peso bank deposit and yield from deposit substitutes is subject to a final tax of 20%.\n\nELEMENTS:\nFINAL TAX ON PASSIVE INCOME:\n- Bank interest: 20%\n- Dividends (domestic): 10%\n- Capital gains (shares): 15%\n- Capital gains (real property): 6%\n\nDISTINCTION: Final withholding tax (tax done, not reported in ITR) ≠ Creditable withholding tax (advance payment, reported in ITR)\n\nREFERENCE: NIRC Section 24(B)(1)',
'A is wrong - bank interest is not exempt\nC is wrong - final tax, not graduated rates\nD is wrong - 20% is the correct rate for bank interest',
'Bank interest = 20% FINAL TAX');

-- ============================================================================
-- MS MCQs for Practice Set 01 (FREE)
-- ============================================================================

-- MS Q1: Cost Classification
INSERT INTO questions (practice_set_id, topic_id, question_code, question_text, difficulty_level, is_active, access_level) VALUES
(@ms_ps1, @ms_topic_1, 'MS-PS01-001', 'Which of the following costs would be classified as a variable cost?', 'EASY', TRUE, 'FREE');
SET @q_id = LAST_INSERT_ID();
INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct) VALUES
(@q_id, 'A', 'Factory building depreciation', FALSE),
(@q_id, 'B', 'Direct materials', TRUE),
(@q_id, 'C', 'Factory supervisor salary', FALSE),
(@q_id, 'D', 'Property insurance', FALSE);
INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip) VALUES
(@q_id,
'Variable costs go up and down with production - make more, spend more; make less, spend less.',
'A furniture maker uses wood (direct material). Make 10 chairs = use 10 pieces of wood. Make 100 chairs = use 100 pieces of wood. The wood cost changes DIRECTLY with production volume - that''s a variable cost.\n\nVariable costs change in total in direct proportion to changes in activity level.\n\nFORMAL DEFINITION: A variable cost is a cost that changes in total in direct proportion to changes in the level of activity. Total variable cost increases as activity increases and decreases as activity decreases.\n\nELEMENTS:\nVARIABLE COST CHARACTERISTICS:\n1. Total changes with activity\n2. Per-unit cost stays constant\n3. Direct relationship to volume\n4. Zero cost at zero activity\n\nDISTINCTION: Variable cost (changes with volume) ≠ Fixed cost (stays same regardless of volume)\n\nREFERENCE: Cost Accounting Standards; Managerial Accounting Principles',
'A is wrong - depreciation is fixed, doesn''t change with production\nC is wrong - supervisor salary is fixed regardless of output\nD is wrong - insurance is a fixed cost',
'Variable cost = Changes with ACTIVITY LEVEL');

-- MS Q2: Break-even Analysis
INSERT INTO questions (practice_set_id, topic_id, question_code, question_text, difficulty_level, is_active, access_level) VALUES
(@ms_ps1, @ms_topic_1, 'MS-PS01-002', 'At the break-even point, which of the following is true?', 'EASY', TRUE, 'FREE');
SET @q_id = LAST_INSERT_ID();
INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct) VALUES
(@q_id, 'A', 'Total revenue exceeds total costs', FALSE),
(@q_id, 'B', 'Total revenue equals total costs', TRUE),
(@q_id, 'C', 'Variable costs equal fixed costs', FALSE),
(@q_id, 'D', 'Contribution margin is zero', FALSE);
INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip) VALUES
(@q_id,
'Break-even = the point where you neither make money nor lose money. You just... break even.',
'A lemonade stand has fixed costs of P500 (rent) and earns P10 per cup after variable costs. At 50 cups: Revenue = P500, Costs = P500. No profit, no loss - this is the BREAK-EVEN point.\n\nBreak-even is the point where total revenue exactly equals total costs, resulting in zero profit or loss.\n\nFORMAL DEFINITION: The break-even point is the level of sales at which total revenue equals total costs (both fixed and variable), resulting in zero profit.\n\nELEMENTS:\nAT BREAK-EVEN:\n1. Revenue = Total Costs\n2. Profit = Zero\n3. Contribution Margin = Fixed Costs\n4. Formula: FC ÷ CM per unit\n\nDISTINCTION: Break-even (zero profit) ≠ Target profit analysis (desired profit level)\n\nREFERENCE: Managerial Accounting; CVP Analysis Standards',
'A is wrong - that would be profit, not break-even\nC is wrong - variable and fixed costs don''t have to be equal\nD is wrong - contribution margin covers fixed costs at break-even',
'Break-even = Revenue EQUALS Costs (zero profit)');

-- MS Q3: Contribution Margin
INSERT INTO questions (practice_set_id, topic_id, question_code, question_text, difficulty_level, is_active, access_level) VALUES
(@ms_ps1, @ms_topic_1, 'MS-PS01-003', 'Contribution margin per unit is calculated as:', 'EASY', TRUE, 'FREE');
SET @q_id = LAST_INSERT_ID();
INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct) VALUES
(@q_id, 'A', 'Sales price minus fixed cost per unit', FALSE),
(@q_id, 'B', 'Sales price minus variable cost per unit', TRUE),
(@q_id, 'C', 'Sales price minus total cost per unit', FALSE),
(@q_id, 'D', 'Variable cost minus fixed cost per unit', FALSE);
INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip) VALUES
(@q_id,
'Contribution margin = what''s left after paying for the direct costs of making one unit.',
'You sell cookies for P50 each. Ingredients cost P20 per cookie (variable). Each cookie CONTRIBUTES P30 (P50 - P20) toward covering your fixed costs (rent, etc.) and eventually profit.\n\nContribution margin represents the amount available to cover fixed costs and generate profit after variable costs are paid.\n\nFORMAL DEFINITION: Contribution margin per unit equals selling price per unit minus variable cost per unit. It represents the amount each unit contributes toward covering fixed costs and then generating profit.\n\nELEMENTS:\nCONTRIBUTION MARGIN:\n- Per unit: Price - Variable cost\n- Ratio: CM ÷ Price\n- Total: CM per unit × Units sold\n- Used in: Break-even, CVP analysis\n\nDISTINCTION: Contribution margin (covers fixed costs) ≠ Gross profit (covers operating expenses)\n\nREFERENCE: Managerial Accounting Standards; CVP Analysis',
'A is wrong - fixed costs are not deducted at unit level\nC is wrong - total cost includes fixed, which shouldn''t be per-unit allocated this way\nD is wrong - this formula is meaningless',
'CM per unit = Price MINUS Variable Cost');

-- MS Q4: Relevant Cost
INSERT INTO questions (practice_set_id, topic_id, question_code, question_text, difficulty_level, is_active, access_level) VALUES
(@ms_ps1, @ms_topic_1, 'MS-PS01-004', 'In decision-making, a sunk cost is:', 'MEDIUM', TRUE, 'FREE');
SET @q_id = LAST_INSERT_ID();
INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct) VALUES
(@q_id, 'A', 'Always relevant to future decisions', FALSE),
(@q_id, 'B', 'A cost that has already been incurred and cannot be changed', TRUE),
(@q_id, 'C', 'A cost that will change based on the decision made', FALSE),
(@q_id, 'D', 'The same as opportunity cost', FALSE);
INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip) VALUES
(@q_id,
'Sunk cost = money already spent that you can''t get back. Don''t cry over spilt milk - focus on future decisions.',
'You paid P50,000 for a business course. Halfway through, you realize it''s not useful. Should you continue? The P50,000 is SUNK - you can''t get it back. Your decision should focus on future benefits and costs, not money already spent.\n\nSunk costs are irrelevant to decision-making because they cannot be recovered regardless of what action is taken.\n\nFORMAL DEFINITION: A sunk cost is a cost that has already been incurred and cannot be changed or avoided by any future decision. Sunk costs are irrelevant for decision-making purposes.\n\nELEMENTS:\nSUNK COST CHARACTERISTICS:\n1. Already incurred\n2. Cannot be recovered\n3. Irrelevant to future decisions\n4. Should not affect choices\n\nDISTINCTION: Sunk cost (past, irrelevant) ≠ Relevant cost (future, differs between alternatives)\n\nREFERENCE: Management Accounting Standards',
'A is wrong - sunk costs are NEVER relevant\nC is wrong - sunk costs cannot change; that describes relevant costs\nD is wrong - opportunity cost is what you give up by choosing',
'SUNK cost = Already spent, IRRELEVANT to decisions');

-- MS Q5: Standard Costing
INSERT INTO questions (practice_set_id, topic_id, question_code, question_text, difficulty_level, is_active, access_level) VALUES
(@ms_ps1, @ms_topic_1, 'MS-PS01-005', 'A favorable direct materials price variance indicates that:', 'MEDIUM', TRUE, 'FREE');
SET @q_id = LAST_INSERT_ID();
INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct) VALUES
(@q_id, 'A', 'More materials were used than standard', FALSE),
(@q_id, 'B', 'Materials were purchased at a price lower than standard', TRUE),
(@q_id, 'C', 'Materials were purchased at a price higher than standard', FALSE),
(@q_id, 'D', 'Less materials were used than standard', FALSE);
INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip) VALUES
(@q_id,
'Favorable price variance = You paid LESS than expected. Good job on the buying!',
'Standard price for wood: P100 per meter. Actual price paid: P90 per meter. You saved P10 per meter - that''s FAVORABLE. It''s like getting a discount compared to what you budgeted.\n\nA favorable price variance means actual price was less than standard price, resulting in cost savings.\n\nFORMAL DEFINITION: A favorable direct materials price variance occurs when the actual price paid for materials is less than the standard price. Formula: (Standard Price - Actual Price) × Actual Quantity Purchased.\n\nELEMENTS:\nPRICE VARIANCE:\n- Favorable: Actual < Standard\n- Unfavorable: Actual > Standard\n- Formula: (SP - AP) × AQ\n- Responsibility: Purchasing department\n\nDISTINCTION: Price variance (difference in cost per unit) ≠ Quantity variance (difference in usage amount)\n\nREFERENCE: Cost Accounting Standards; Standard Costing',
'A is wrong - this describes quantity variance, not price variance\nC is wrong - higher price would be unfavorable\nD is wrong - this also describes quantity variance',
'Favorable price variance = Paid LESS than standard');

-- ============================================================================
-- RFBT MCQs for Practice Set 01 (FREE)
-- ============================================================================

-- RFBT Q1: Obligations and Contracts
INSERT INTO questions (practice_set_id, topic_id, question_code, question_text, difficulty_level, is_active, access_level) VALUES
(@rfbt_ps1, @rfbt_topic_1, 'RFBT-PS01-001', 'Which of the following is an essential requisite of a valid contract?', 'EASY', TRUE, 'FREE');
SET @q_id = LAST_INSERT_ID();
INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct) VALUES
(@q_id, 'A', 'Written form', FALSE),
(@q_id, 'B', 'Consent of the contracting parties', TRUE),
(@q_id, 'C', 'Notarization', FALSE),
(@q_id, 'D', 'Registration with government agency', FALSE);
INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip) VALUES
(@q_id,
'Contract = Agreement. The most basic requirement is that both parties freely agree to the deal.',
'Juan offers to sell his bike for P5,000. Pedro says "I agree to buy it." Right there, they have a CONTRACT - Juan and Pedro both CONSENTED. No written document needed, no notary needed. Just two minds meeting on a deal.\n\nA valid contract requires three essential elements, with consent being paramount.\n\nFORMAL DEFINITION: The essential requisites of a contract are: (1) Consent of the contracting parties; (2) Object certain which is the subject matter of the contract; (3) Cause of the obligation which is established.\n\nELEMENTS:\nESSENTIAL REQUISITES (COC):\n1. Consent - meeting of minds\n2. Object - subject matter\n3. Cause - why parties enter contract\n\nDISTINCTION: Essential requisites (needed for validity) ≠ Natural elements (presumed) ≠ Accidental elements (agreed upon)\n\nREFERENCE: Civil Code, Article 1318',
'A is wrong - most contracts can be oral\nC is wrong - notarization is for convenience, not validity\nD is wrong - registration is not required for validity',
'Valid contract = CONSENT + Object + Cause (COC)');

-- RFBT Q2: Void vs Voidable Contracts
INSERT INTO questions (practice_set_id, topic_id, question_code, question_text, difficulty_level, is_active, access_level) VALUES
(@rfbt_ps1, @rfbt_topic_1, 'RFBT-PS01-002', 'A contract entered into by a person who is insane is:', 'MEDIUM', TRUE, 'FREE');
SET @q_id = LAST_INSERT_ID();
INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct) VALUES
(@q_id, 'A', 'Valid and binding', FALSE),
(@q_id, 'B', 'Void from the beginning', FALSE),
(@q_id, 'C', 'Voidable at the option of the incapacitated person or guardian', TRUE),
(@q_id, 'D', 'Unenforceable', FALSE);
INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip) VALUES
(@q_id,
'Voidable = Valid UNTIL the protected party decides to cancel it. The choice belongs to the one the law protects.',
'Maria, who has a mental condition, sells her land. Her guardian later discovers this. The contract isn''t automatically void - it''s VOIDABLE. The guardian can choose to annul it (protect Maria) or ratify it (if it was actually a good deal).\n\nContracts by incapacitated persons are voidable because the law protects them while also respecting their partial ability to transact.\n\nFORMAL DEFINITION: Contracts where one of the parties is incapable of giving consent are voidable. The contract is valid until annulled by proper court action.\n\nELEMENTS:\nVOIDABLE CONTRACTS (Defective Consent):\n1. Incapacity (minors, insane)\n2. Mistake\n3. Violence/Intimidation\n4. Undue influence\n5. Fraud\n\nDISTINCTION: Voidable (valid until annulled, can be ratified) ≠ Void (no effect from start, cannot be ratified)\n\nREFERENCE: Civil Code, Articles 1327, 1390',
'A is wrong - there''s a defect in consent\nB is wrong - it''s not void, just voidable\nD is wrong - unenforceable is a different category',
'Incapacity = VOIDABLE (protected party chooses)');

-- RFBT Q3: Sales - Delivery
INSERT INTO questions (practice_set_id, topic_id, question_code, question_text, difficulty_level, is_active, access_level) VALUES
(@rfbt_ps1, @rfbt_topic_1, 'RFBT-PS01-003', 'In a contract of sale, ownership of the thing sold is transferred to the buyer upon:', 'MEDIUM', TRUE, 'FREE');
SET @q_id = LAST_INSERT_ID();
INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct) VALUES
(@q_id, 'A', 'Perfection of the contract', FALSE),
(@q_id, 'B', 'Full payment of the price', FALSE),
(@q_id, 'C', 'Delivery of the thing sold', TRUE),
(@q_id, 'D', 'Registration of the sale', FALSE);
INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip) VALUES
(@q_id,
'You own it when you GET it (delivery), not when you AGREE to buy it (perfection).',
'You agree to buy a phone for P10,000. At agreement: Contract is PERFECTED. When seller hands you the phone: OWNERSHIP transfers to you. Payment timing doesn''t affect ownership transfer - delivery does.\n\nPhilippine law follows the tradition theory where ownership transfers upon delivery, not upon contract perfection.\n\nFORMAL DEFINITION: By the contract of sale, ownership is transferred to the vendee upon the actual or constructive delivery of the thing sold.\n\nELEMENTS:\nSTAGES OF SALE:\n1. Negotiation - bargaining\n2. Perfection - meeting of minds\n3. Consummation - delivery & payment\n\nOwnership transfers at: DELIVERY\n\nDISTINCTION: Perfection (birth of contract) ≠ Consummation (transfer of ownership)\n\nWhy Other Choices Are Wrong\nA is wrong - perfection creates obligations, not ownership transfer\nB is wrong - payment is separate from delivery\nD is wrong - registration is not required for ownership transfer in general\nMemory Tip\n\nOwnership transfers upon DELIVERY (not agreement, not payment)\n\nReference: N/A\n\nREFERENCE: Civil Code, Articles 1477, 1496',
'A is wrong - perfection creates obligations, not ownership transfer\nB is wrong - payment is separate from delivery\nD is wrong - registration is not required for ownership transfer in general',
'Ownership transfers upon DELIVERY (not agreement, not payment)');

-- RFBT Q4: Accion Redhibitoria
INSERT INTO questions (practice_set_id, topic_id, question_code, question_text, difficulty_level, is_active, access_level) VALUES
(@rfbt_ps1, @rfbt_topic_1, 'RFBT-PS01-004', 'A buyer discovered that the thing sold had a hidden defect that made it unfit for its intended use. What is the proper legal action to cancel the sale?', 'HARD', TRUE, 'FREE');
SET @q_id = LAST_INSERT_ID();
INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct) VALUES
(@q_id, 'A', 'Accion reinvindicatoria', FALSE),
(@q_id, 'B', 'Accion redhibitoria', TRUE),
(@q_id, 'C', 'Accion publiciana', FALSE),
(@q_id, 'D', 'Accion pauliana', FALSE);
INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip) VALUES
(@q_id,
'Redhibitoria = "give back" in Latin. Hidden defect so bad you want to return and cancel the whole sale.',
'You buy a refrigerator. It looks fine but won''t cool properly - a hidden defect. You want to RETURN it and get your money back. This lawsuit to CANCEL the sale due to hidden defect = ACCION REDHIBITORIA.\n\nAccion redhibitoria allows buyers to rescind sales due to hidden defects that render the item unfit for use.\n\nFORMAL DEFINITION: Accion redhibitoria is a legal remedy allowing a buyer to rescind a sale when the thing sold has a hidden defect so serious that it makes the thing unfit for its intended use or makes its use extremely inconvenient.\n\nELEMENTS:\nHIDDEN DEFECT REQUIREMENTS:\n1. Defect is hidden (not visible)\n2. Defect is serious\n3. Defect existed at time of sale\n4. Buyer was unaware\n5. Makes thing unfit for use\n\nDISTINCTION: Accion redhibitoria (cancel sale) ≠ Accion quanti minoris (price reduction)\n\nREFERENCE: Civil Code, Article 1567',
'A is wrong - reinvindicatoria is to recover ownership, not about defects\nC is wrong - publiciana is to recover possession\nD is wrong - pauliana is creditor''s action against fraudulent transfers',
'Hidden defect + Cancel sale = ACCION REDHIBITORIA');

-- RFBT Q5: Negotiable Instruments
INSERT INTO questions (practice_set_id, topic_id, question_code, question_text, difficulty_level, is_active, access_level) VALUES
(@rfbt_ps1, @rfbt_topic_1, 'RFBT-PS01-005', 'For a check to be negotiable, it must contain:', 'MEDIUM', TRUE, 'FREE');
SET @q_id = LAST_INSERT_ID();
INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct) VALUES
(@q_id, 'A', 'A fixed maturity date', FALSE),
(@q_id, 'B', 'An unconditional promise or order to pay a sum certain in money', TRUE),
(@q_id, 'C', 'The reason for the payment', FALSE),
(@q_id, 'D', 'Collateral or security', FALSE);
INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip) VALUES
(@q_id,
'A negotiable check must be simple and clear - "pay this amount, period." No conditions, no explanations needed.',
'A valid check says: "Pay to Juan Cruz P10,000." That''s an UNCONDITIONAL ORDER - no "ifs" or "buts." If it said "Pay P10,000 IF the goods are delivered," it''s NOT negotiable because of the condition.\n\nNegotiability requires certainty and unconditional payment obligation to allow free transfer in commerce.\n\nFORMAL DEFINITION: An instrument to be negotiable must contain an unconditional promise or order to pay a sum certain in money.\n\nELEMENTS:\nREQUISITES OF NEGOTIABILITY:\n1. Writing and signed\n2. Unconditional promise/order\n3. Sum certain in money\n4. Payable on demand or fixed time\n5. Payable to order or bearer\n\nDISTINCTION: Negotiable (freely transferable) ≠ Non-negotiable (conditional or lacking requisites)\n\nREFERENCE: Negotiable Instruments Law, Section 1',
'A is wrong - checks are payable on demand, not with maturity date\nC is wrong - stating the reason makes it conditional\nD is wrong - collateral is not a requirement',
'Negotiable = UNCONDITIONAL promise to pay sum certain');

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================================
-- Verify seeding results
-- ============================================================================
SELECT 'Practice Sets created:' as Status;
SELECT set_code, set_name, access_level FROM practice_sets ORDER BY set_code;

SELECT 'MCQs seeded per practice set:' as Status;
SELECT ps.set_code, COUNT(q.question_id) as question_count
FROM practice_sets ps
LEFT JOIN questions q ON ps.practice_set_id = q.practice_set_id
GROUP BY ps.set_code
ORDER BY ps.set_code;
