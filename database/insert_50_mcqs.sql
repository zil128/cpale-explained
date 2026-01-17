-- ============================================================================
-- CPALE Explained - 50 FREE MCQs with Comprehensive Explanations
-- Distribution: FAR(9), AFAR(8), AUD(8), TAX(9), MS(8), RFBT(8) = 50 total
-- ============================================================================

-- ============================================================================
-- FAR - Financial Accounting and Reporting (9 Questions)
-- ============================================================================

-- FAR Q1: Conceptual Framework
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (4, 'FAR-CF-Q001', 'Which of the following is the PRIMARY objective of general-purpose financial reporting?', 'EASY', 1, 'FREE');
SET @q1 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q1, 'A', 'To provide information about the reporting entity that is useful to existing and potential investors, lenders, and other creditors', 1, 1),
(@q1, 'B', 'To determine the taxable income of the entity', 0, 2),
(@q1, 'C', 'To provide information exclusively for management decision-making', 0, 3),
(@q1, 'D', 'To ensure compliance with all applicable laws and regulations', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q1,
'The Conceptual Framework states that financial reporting provides useful information for resource allocation decisions.',
'According to the IASB Conceptual Framework (2018), the objective of general-purpose financial reporting is to provide financial information about the reporting entity that is useful to existing and potential investors, lenders, and other creditors in making decisions relating to providing resources to the entity. These decisions involve buying, selling, or holding equity and debt instruments, and providing or settling loans and other forms of credit.',
'B is wrong - Tax reporting has different objectives and rules than financial reporting under IFRS/PFRS. C is wrong - General-purpose financial statements are for external users, not primarily for management (that is managerial accounting). D is wrong - While compliance is important, it is not the primary objective of financial reporting.',
'PRIMARY users = Investors, Lenders, Creditors (ILC) making RESOURCE ALLOCATION decisions',
'EXAM');

-- FAR Q2: Cash and Cash Equivalents
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (5, 'FAR-CASH-Q001', 'Which of the following should NOT be included in cash and cash equivalents?', 'MEDIUM', 2, 'FREE');
SET @q2 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q2, 'A', 'Petty cash fund', 0, 1),
(@q2, 'B', 'Money market placements maturing in 60 days', 0, 2),
(@q2, 'C', 'Treasury bills maturing in 120 days from acquisition', 1, 3),
(@q2, 'D', 'Demand deposits with banks', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q2,
'Cash equivalents must mature within 3 months (90 days) from date of acquisition.',
'Under PAS 7 (IAS 7) Statement of Cash Flows, cash equivalents are short-term, highly liquid investments that are readily convertible to known amounts of cash and subject to insignificant risk of changes in value. An investment normally qualifies as a cash equivalent only when it has a short maturity of, say, THREE MONTHS OR LESS from the date of acquisition. Treasury bills maturing in 120 days exceed this threshold.',
'A is wrong - Petty cash is cash on hand and is included. B is wrong - Money market placements maturing in 60 days (less than 90 days) qualify as cash equivalents. D is wrong - Demand deposits are immediately available and are cash.',
'Cash equivalent = 3 MONTHS OR LESS from ACQUISITION date (not original maturity)',
'EXAM');

-- FAR Q3: Receivables
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (6, 'FAR-REC-Q001', 'Under PFRS 9, how should trade receivables without a significant financing component be initially measured?', 'MEDIUM', 3, 'FREE');
SET @q3 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q3, 'A', 'At fair value', 0, 1),
(@q3, 'B', 'At amortized cost', 0, 2),
(@q3, 'C', 'At the transaction price', 1, 3),
(@q3, 'D', 'At present value of future cash flows', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q3,
'PFRS 9 allows a practical expedient to measure at transaction price when no significant financing component exists.',
'Under PFRS 9 Financial Instruments, trade receivables that do not have a significant financing component (as defined in PFRS 15) shall be measured at their transaction price (as defined in PFRS 15) at initial recognition. This is a practical expedient that simplifies accounting for short-term receivables. For receivables with a significant financing component, fair value measurement would apply.',
'A is wrong - Fair value applies to financial instruments in general, but PFRS 9 provides a practical expedient for trade receivables. B is wrong - Amortized cost is a subsequent measurement basis, not initial measurement. D is wrong - Present value is used when there is a significant financing component.',
'No significant financing = Transaction Price. WITH financing = Fair Value/Present Value',
'EXAM');

-- FAR Q4: Inventory
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (7, 'FAR-INV-Q001', 'Inventories shall be measured at the lower of cost and:', 'EASY', 4, 'FREE');
SET @q4 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q4, 'A', 'Fair value', 0, 1),
(@q4, 'B', 'Net realizable value', 1, 2),
(@q4, 'C', 'Replacement cost', 0, 3),
(@q4, 'D', 'Market value', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q4,
'PAS 2 requires inventories to be measured at the lower of cost and NRV.',
'Under PAS 2 (IAS 2) Inventories, inventories shall be measured at the LOWER OF COST AND NET REALIZABLE VALUE. Net realizable value (NRV) is the estimated selling price in the ordinary course of business less the estimated costs of completion and the estimated costs necessary to make the sale. This write-down reflects the principle that assets should not be carried in excess of amounts expected to be realized from their sale or use.',
'A is wrong - Fair value is not the measurement basis for inventory under PAS 2. C is wrong - Replacement cost is used in US GAAP for certain situations, not PFRS. D is wrong - Market value is too vague; PFRS specifically uses NRV.',
'Inventory = Lower of COST and NRV (not fair value, not market value)',
'EXAM');

-- FAR Q5: PPE
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (8, 'FAR-PPE-Q001', 'Which of the following costs should be EXCLUDED from the cost of property, plant and equipment?', 'MEDIUM', 5, 'FREE');
SET @q5 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q5, 'A', 'Purchase price including import duties', 0, 1),
(@q5, 'B', 'Site preparation costs', 0, 2),
(@q5, 'C', 'Costs of opening a new facility', 1, 3),
(@q5, 'D', 'Initial estimate of dismantling costs', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q5,
'Costs of opening a new facility are operating costs, not capitalizable under PAS 16.',
'Under PAS 16 (IAS 16) Property, Plant and Equipment, certain costs are specifically excluded from the cost of an item of PPE. These include: (a) costs of opening a new facility; (b) costs of introducing a new product or service (including advertising and promotional activities); (c) costs of conducting business in a new location or with a new class of customer; and (d) administration and other general overhead costs. These are recognized as expenses when incurred.',
'A is wrong - Purchase price including non-refundable import duties is capitalizable. B is wrong - Site preparation costs directly attributable to bringing the asset to its working condition are capitalizable. D is wrong - Initial estimates of dismantling and restoration costs are included in cost per PAS 16.',
'EXCLUDE from PPE cost: Opening costs, Admin overhead, Relocation costs (OAR expenses)',
'EXAM');

-- FAR Q6: Revenue Recognition
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (1, 'FAR-REV-Q001', 'Under PFRS 15, revenue is recognized when or as the entity satisfies a performance obligation by transferring a promised good or service to a customer. When is a good or service transferred?', 'MEDIUM', 8, 'FREE');
SET @q6 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q6, 'A', 'When the invoice is issued', 0, 1),
(@q6, 'B', 'When cash is received', 0, 2),
(@q6, 'C', 'When the customer obtains control of the asset', 1, 3),
(@q6, 'D', 'When the contract is signed', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q6,
'Control transfer is the key criterion for revenue recognition under PFRS 15.',
'Under PFRS 15 Revenue from Contracts with Customers, a good or service is transferred when (or as) the customer obtains CONTROL of that asset. Control of an asset refers to the ability to direct the use of, and obtain substantially all of the remaining benefits from, the asset. Control includes the ability to prevent other entities from directing the use of, and obtaining the benefits from, an asset. The benefits of an asset are the potential cash flows that can be obtained directly or indirectly.',
'A is wrong - Invoice issuance is an administrative act, not a criterion for revenue recognition. B is wrong - This would be cash basis accounting, which is not allowed under PFRS for revenue recognition. D is wrong - Contract signing establishes the arrangement but does not mean performance obligation is satisfied.',
'PFRS 15: Revenue when CONTROL transfers (not invoice, not cash, not contract)',
'EXAM');

-- FAR Q7: Financial Instruments
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (1, 'FAR-FI-Q001', 'Under PFRS 9, which classification results in subsequent measurement at amortized cost?', 'HARD', 10, 'FREE');
SET @q7 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q7, 'A', 'Fair value through profit or loss (FVPL)', 0, 1),
(@q7, 'B', 'Fair value through other comprehensive income (FVOCI)', 0, 2),
(@q7, 'C', 'Financial assets held within a business model to collect contractual cash flows', 1, 3),
(@q7, 'D', 'Financial assets designated as hedging instruments', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q7,
'Amortized cost requires both: held to collect AND solely payments of principal and interest (SPPI).',
'Under PFRS 9, a financial asset is measured at AMORTIZED COST if BOTH conditions are met: (1) the financial asset is held within a business model whose objective is to HOLD financial assets in order to COLLECT contractual cash flows, AND (2) the contractual terms give rise on specified dates to cash flows that are SOLELY PAYMENTS OF PRINCIPAL AND INTEREST (SPPI) on the principal amount outstanding. This is known as the Business Model Test and the SPPI Test.',
'A is wrong - FVPL means changes in fair value go to profit or loss. B is wrong - FVOCI means changes in fair value go to OCI. D is wrong - Hedging instruments follow hedge accounting rules, not the general classification.',
'Amortized Cost = HOLD TO COLLECT + SPPI (both tests must pass)',
'EXAM');

-- FAR Q8: Intangible Assets
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (4, 'FAR-INT-Q001', 'Research costs under PAS 38 should be:', 'EASY', 6, 'FREE');
SET @q8 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q8, 'A', 'Capitalized as an intangible asset', 0, 1),
(@q8, 'B', 'Recognized as an expense when incurred', 1, 2),
(@q8, 'C', 'Deferred and amortized over the useful life', 0, 3),
(@q8, 'D', 'Added to the cost of related development costs', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q8,
'Research phase costs cannot demonstrate probable future economic benefits, so they must be expensed.',
'Under PAS 38 (IAS 38) Intangible Assets, NO intangible asset arising from RESEARCH shall be recognized. Expenditure on research shall be recognized as an EXPENSE when it is incurred. This is because, in the research phase, an entity cannot demonstrate that an intangible asset exists that will generate probable future economic benefits. Examples of research activities include: obtaining new knowledge, searching for alternatives, formulating and designing possible alternatives.',
'A is wrong - Research costs cannot meet the recognition criteria for intangible assets. C is wrong - Deferral is not allowed for research costs. D is wrong - Research costs cannot be added to development costs; they remain as expenses.',
'RESEARCH = Always EXPENSE. DEVELOPMENT = May CAPITALIZE if 6 criteria met',
'EXAM');

-- FAR Q9: Earnings Per Share
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (4, 'FAR-EPS-Q001', 'Basic earnings per share is computed by dividing earnings available to common shareholders by:', 'EASY', 11, 'FREE');
SET @q9 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q9, 'A', 'Total shares outstanding at year-end', 0, 1),
(@q9, 'B', 'Weighted average number of common shares outstanding', 1, 2),
(@q9, 'C', 'Total shares authorized', 0, 3),
(@q9, 'D', 'Shares outstanding at the beginning of the year', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q9,
'Weighted average accounts for timing of share issuances and buybacks during the period.',
'Under PAS 33 (IAS 33) Earnings Per Share, basic earnings per share shall be calculated by dividing profit or loss attributable to ordinary equity holders of the parent entity by the WEIGHTED AVERAGE number of ordinary shares outstanding during the period. The weighted average reflects the fact that the amount of shareholder capital may have varied during the period as a result of share issuances, buybacks, or other changes.',
'A is wrong - Year-end shares do not account for timing of changes during the year. C is wrong - Authorized shares are not the same as issued/outstanding shares. D is wrong - Beginning shares do not reflect changes during the year.',
'Basic EPS = Earnings / WEIGHTED AVERAGE shares (not year-end, not authorized)',
'EXAM');

-- ============================================================================
-- AFAR - Advanced Financial Accounting and Reporting (8 Questions)
-- ============================================================================

-- AFAR Q1: Business Combinations
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (9, 'AFAR-BC-Q001', 'Under PFRS 3, goodwill arising from a business combination is:', 'MEDIUM', 13, 'FREE');
SET @q10 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q10, 'A', 'Amortized over its useful life not exceeding 20 years', 0, 1),
(@q10, 'B', 'Expensed immediately in the period of acquisition', 0, 2),
(@q10, 'C', 'Not amortized but tested for impairment annually', 1, 3),
(@q10, 'D', 'Amortized over 40 years', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q10,
'Goodwill has indefinite life under PFRS and is subject to impairment testing, not amortization.',
'Under PFRS 3 Business Combinations and PAS 36 Impairment of Assets, goodwill acquired in a business combination shall NOT be amortized. Instead, the acquirer shall test goodwill for impairment ANNUALLY, or more frequently if events or changes in circumstances indicate that it might be impaired. This approach recognizes that goodwill does not diminish systematically over time like other assets.',
'A is wrong - The 20-year amortization was under old standards (pre-PFRS 3 revised). B is wrong - Goodwill is an asset, not an immediate expense. D is wrong - 40-year amortization was an old US GAAP approach, not applicable under PFRS.',
'Goodwill = NO amortization, YES annual impairment test',
'EXAM');

-- AFAR Q2: Consolidation
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (10, 'AFAR-CONSOL-Q001', 'In preparing consolidated financial statements, intercompany transactions should be:', 'EASY', 14, 'FREE');
SET @q11 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q11, 'A', 'Disclosed in the notes only', 0, 1),
(@q11, 'B', 'Eliminated in full', 1, 2),
(@q11, 'C', 'Eliminated proportionately based on ownership', 0, 3),
(@q11, 'D', 'Retained and separately presented', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q11,
'The group is one economic entity; transactions within cannot generate profit.',
'Under PFRS 10 Consolidated Financial Statements, intragroup balances and transactions, and any resulting unrealized profits or losses, shall be eliminated IN FULL. The consolidated financial statements present the parent and its subsidiaries as a SINGLE ECONOMIC ENTITY. Transactions between entities within the group do not represent transactions with parties outside the group and therefore cannot result in income or expense from the group perspective.',
'A is wrong - Disclosure alone is insufficient; elimination is required. C is wrong - Full elimination is required regardless of ownership percentage. D is wrong - Retention would double-count transactions within the group.',
'Consolidated = ONE entity. Intercompany = FULLY eliminated (not proportionate)',
'EXAM');

-- AFAR Q3: Investments in Associates
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (9, 'AFAR-ASSOC-Q001', 'An investment in an associate is accounted for using:', 'EASY', 15, 'FREE');
SET @q12 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q12, 'A', 'The cost method', 0, 1),
(@q12, 'B', 'The equity method', 1, 2),
(@q12, 'C', 'Fair value through profit or loss', 0, 3),
(@q12, 'D', 'Proportionate consolidation', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q12,
'Significant influence requires equity method under PAS 28.',
'Under PAS 28 (IAS 28) Investments in Associates and Joint Ventures, an investment in an associate or joint venture shall be accounted for using the EQUITY METHOD. Under the equity method, the investment is initially recognized at cost and adjusted thereafter for the post-acquisition change in the investors share of the investees net assets. The investors profit or loss includes its share of the investees profit or loss.',
'A is wrong - Cost method is used for investments without significant influence. C is wrong - FVPL is a classification under PFRS 9, not applicable when there is significant influence. D is wrong - Proportionate consolidation was allowed for joint ventures under old IAS 31 but eliminated under PFRS 11.',
'Associate (20-50% influence) = EQUITY METHOD',
'EXAM');

-- AFAR Q4: Foreign Currency
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (9, 'AFAR-FC-Q001', 'Under PAS 21, a foreign currency transaction should initially be recorded at:', 'MEDIUM', 17, 'FREE');
SET @q13 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q13, 'A', 'The closing rate at the reporting date', 0, 1),
(@q13, 'B', 'The spot exchange rate at the date of the transaction', 1, 2),
(@q13, 'C', 'The average rate for the period', 0, 3),
(@q13, 'D', 'The forward rate at the settlement date', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q13,
'Initial recognition uses the spot rate on transaction date to reflect the economic reality at that moment.',
'Under PAS 21 (IAS 21) The Effects of Changes in Foreign Exchange Rates, a foreign currency transaction shall be recorded, on initial recognition in the functional currency, by applying to the foreign currency amount the SPOT EXCHANGE RATE between the functional currency and the foreign currency at the DATE OF THE TRANSACTION. The date of the transaction is the date on which the transaction first qualifies for recognition.',
'A is wrong - Closing rate is used for translating monetary items at period-end, not initial recognition. C is wrong - Average rate may be used as a practical expedient for income/expense items, not initial recognition of transactions. D is wrong - Forward rates are used in hedge accounting, not initial recognition.',
'Initial recognition = SPOT rate on TRANSACTION date',
'EXAM');

-- AFAR Q5: Non-controlling Interest
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (10, 'AFAR-NCI-Q001', 'Non-controlling interest in the statement of financial position should be presented:', 'MEDIUM', 14, 'FREE');
SET @q14 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q14, 'A', 'As a liability', 0, 1),
(@q14, 'B', 'Between liabilities and equity', 0, 2),
(@q14, 'C', 'Within equity, separately from the equity of owners of the parent', 1, 3),
(@q14, 'D', 'As a deduction from total assets', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q14,
'NCI represents equity that belongs to shareholders other than the parent.',
'Under PFRS 10 and PAS 1, non-controlling interests shall be presented in the consolidated statement of financial position WITHIN EQUITY, separately from the equity attributable to owners of the parent. NCI represents the equity in a subsidiary not attributable, directly or indirectly, to a parent. It is an ownership interest and therefore part of equity, not a liability.',
'A is wrong - NCI is not a liability; it represents ownership interest in equity. B is wrong - This mezzanine presentation was used historically but is no longer allowed. D is wrong - NCI is not a contra-asset; it is a component of equity.',
'NCI = EQUITY (separate line), not liability, not mezzanine',
'EXAM');

-- AFAR Q6: Business Combination - Acquisition Method
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (9, 'AFAR-BC-Q002', 'Under the acquisition method in PFRS 3, acquisition-related costs should be:', 'MEDIUM', 13, 'FREE');
SET @q15 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q15, 'A', 'Capitalized as part of goodwill', 0, 1),
(@q15, 'B', 'Recognized as expenses in the periods in which the costs are incurred', 1, 2),
(@q15, 'C', 'Deducted from the consideration transferred', 0, 3),
(@q15, 'D', 'Charged directly to retained earnings', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q15,
'Acquisition costs are expensed, not added to goodwill or consideration.',
'Under PFRS 3 Business Combinations, acquisition-related costs are costs the acquirer incurs to effect a business combination. Those costs include finders fees; advisory, legal, accounting, valuation, and other professional or consulting fees; general administrative costs; and costs of registering and issuing debt and equity securities. The acquirer shall account for acquisition-related costs as EXPENSES in the periods in which the costs are incurred and the services are received.',
'A is wrong - Under old standards, these were capitalized, but PFRS 3 (revised) requires expensing. C is wrong - These costs do not reduce consideration; they are separate expenses. D is wrong - Retained earnings bypass is not appropriate; these are period expenses.',
'Acquisition costs = EXPENSE immediately (not goodwill, not deferred)',
'EXAM');

-- AFAR Q7: Joint Arrangements
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (9, 'AFAR-JV-Q001', 'Under PFRS 11, a joint venture is accounted for using:', 'EASY', 16, 'FREE');
SET @q16 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q16, 'A', 'Proportionate consolidation', 0, 1),
(@q16, 'B', 'The equity method', 1, 2),
(@q16, 'C', 'Full consolidation', 0, 3),
(@q16, 'D', 'The cost method', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q16,
'PFRS 11 eliminated proportionate consolidation; joint ventures use equity method.',
'Under PFRS 11 Joint Arrangements, a joint venturer shall recognize its interest in a joint venture as an investment and shall account for that investment using the EQUITY METHOD in accordance with PAS 28. PFRS 11 eliminated the option to use proportionate consolidation for joint ventures that was previously allowed under IAS 31. A joint venture is a joint arrangement whereby the parties have joint control and have rights to the NET ASSETS of the arrangement.',
'A is wrong - Proportionate consolidation is no longer allowed under PFRS 11. C is wrong - Full consolidation is for subsidiaries (control), not joint ventures (joint control). D is wrong - Cost method does not reflect the venturers share of the JVs results.',
'Joint Venture = EQUITY method (same as associate). Joint Operation = recognize assets/liabilities directly',
'EXAM');

-- AFAR Q8: Goodwill Impairment
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (9, 'AFAR-BC-Q003', 'At what level should goodwill be tested for impairment under PAS 36?', 'HARD', 13, 'FREE');
SET @q17 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q17, 'A', 'At the individual asset level', 0, 1),
(@q17, 'B', 'At the cash-generating unit or group of CGUs level', 1, 2),
(@q17, 'C', 'At the subsidiary level only', 0, 3),
(@q17, 'D', 'At the consolidated group level', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q17,
'Goodwill does not generate cash flows independently; it must be allocated to CGUs.',
'Under PAS 36 (IAS 36) Impairment of Assets, goodwill acquired in a business combination shall, from the acquisition date, be allocated to each of the acquirers CASH-GENERATING UNITS (CGUs), or groups of CGUs, that is expected to benefit from the synergies of the combination. A CGU is the smallest identifiable group of assets that generates cash inflows that are largely independent of the cash inflows from other assets or groups of assets.',
'A is wrong - Goodwill cannot be tested at the individual asset level because it does not generate independent cash flows. C is wrong - A subsidiary might contain multiple CGUs or be part of a larger CGU. D is wrong - The consolidated group level is typically too broad for meaningful impairment testing.',
'Goodwill impairment = CGU level (smallest independent cash-generating unit)',
'EXAM');

-- ============================================================================
-- AUD - Auditing (8 Questions)
-- ============================================================================

-- AUD Q1: Audit Framework
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (11, 'AUD-FRAME-Q001', 'The primary purpose of an audit of financial statements is to:', 'EASY', 19, 'FREE');
SET @q18 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q18, 'A', 'Detect fraud and errors in the financial statements', 0, 1),
(@q18, 'B', 'Express an opinion on whether the financial statements are presented fairly in accordance with the applicable financial reporting framework', 1, 2),
(@q18, 'C', 'Guarantee the accuracy of the financial statements', 0, 3),
(@q18, 'D', 'Ensure compliance with tax laws', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q18,
'Audit provides reasonable assurance through an opinion, not absolute assurance or detection guarantee.',
'Under PSA 200 (ISA 200) Overall Objectives of the Independent Auditor, the purpose of an audit is to enhance the degree of confidence of intended users in the financial statements. This is achieved by the expression of an OPINION by the auditor on whether the financial statements are prepared, in all material respects, in accordance with an applicable financial reporting framework. An audit provides REASONABLE ASSURANCE, which is a high but not absolute level of assurance.',
'A is wrong - While auditors consider fraud risk, fraud detection is not the primary purpose of an audit. C is wrong - Audits provide reasonable assurance, not a guarantee of accuracy. D is wrong - Tax compliance is a separate engagement; financial statement audits focus on GAAP/PFRS compliance.',
'Audit = OPINION + REASONABLE ASSURANCE (not detection, not guarantee)',
'EXAM');

-- AUD Q2: Audit Evidence
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (12, 'AUD-EVID-Q001', 'Which of the following audit procedures provides the MOST reliable audit evidence?', 'MEDIUM', 22, 'FREE');
SET @q19 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q19, 'A', 'Inquiry of management', 0, 1),
(@q19, 'B', 'External confirmation from third parties', 1, 2),
(@q19, 'C', 'Observation of procedures performed by client personnel', 0, 3),
(@q19, 'D', 'Analytical procedures on financial data', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q19,
'External evidence from independent sources is more reliable than internal evidence.',
'Under PSA 500 (ISA 500) Audit Evidence, audit evidence is more reliable when it is obtained from INDEPENDENT SOURCES OUTSIDE THE ENTITY. External confirmations (such as bank confirmations, accounts receivable confirmations) provide evidence directly from third parties, which is generally more reliable than evidence generated internally by the entity or through the auditors own procedures based on internal information.',
'A is wrong - Inquiry alone is the least reliable form of evidence; it requires corroboration. C is wrong - Observation provides evidence only about the point in time when it occurred. D is wrong - Analytical procedures are useful but based on internal data and relationships.',
'Reliability hierarchy: External > Internal; Documentary > Oral; Auditor-obtained > Client-provided',
'EXAM');

-- AUD Q3: Internal Control
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (11, 'AUD-IC-Q001', 'The component of internal control that involves the attitudes and actions of management regarding the importance of control is called:', 'EASY', 21, 'FREE');
SET @q20 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q20, 'A', 'Risk assessment', 0, 1),
(@q20, 'B', 'Control activities', 0, 2),
(@q20, 'C', 'Control environment', 1, 3),
(@q20, 'D', 'Monitoring', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q20,
'Control environment sets the tone at the top and is the foundation of internal control.',
'Under PSA 315 (ISA 315) and the COSO framework, the CONTROL ENVIRONMENT includes the governance and management functions and the attitudes, awareness, and actions of those charged with governance and management concerning the entitys internal control and its importance. It sets the tone of an organization, influencing the control consciousness of its people. It is the foundation for all other components of internal control, providing discipline and structure.',
'A is wrong - Risk assessment is the process of identifying and analyzing risks to achieving objectives. B is wrong - Control activities are the policies and procedures that help ensure management directives are carried out. D is wrong - Monitoring is the process of assessing internal control performance over time.',
'Control Environment = TONE AT THE TOP (managements attitude toward controls)',
'EXAM');

-- AUD Q4: Audit Risk Model
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (11, 'AUD-RISK-Q001', 'Audit risk is the product of:', 'MEDIUM', 20, 'FREE');
SET @q21 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q21, 'A', 'Control risk and detection risk only', 0, 1),
(@q21, 'B', 'Inherent risk, control risk, and detection risk', 1, 2),
(@q21, 'C', 'Engagement risk and business risk', 0, 3),
(@q21, 'D', 'Sampling risk and non-sampling risk', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q21,
'AR = IR x CR x DR is the fundamental audit risk model.',
'Under PSA 200 and PSA 315, AUDIT RISK = INHERENT RISK x CONTROL RISK x DETECTION RISK. Inherent risk (IR) is the susceptibility of an assertion to a material misstatement, assuming no related controls. Control risk (CR) is the risk that a material misstatement will not be prevented, or detected and corrected, by the entitys internal control. Detection risk (DR) is the risk that the auditors procedures will not detect a material misstatement.',
'A is wrong - This omits inherent risk, which is a critical component. C is wrong - Engagement risk and business risk are broader concepts, not the audit risk model components. D is wrong - Sampling and non-sampling risk relate to evidence gathering, not the audit risk model.',
'Audit Risk = IR x CR x DR. Auditor can only control DR (through nature, timing, extent of procedures)',
'EXAM');

-- AUD Q5: Audit Opinion Types
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (11, 'AUD-REPORT-Q001', 'When an auditor concludes that misstatements are material but not pervasive to the financial statements, the appropriate opinion is:', 'MEDIUM', 24, 'FREE');
SET @q22 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q22, 'A', 'Unmodified opinion', 0, 1),
(@q22, 'B', 'Qualified opinion', 1, 2),
(@q22, 'C', 'Adverse opinion', 0, 3),
(@q22, 'D', 'Disclaimer of opinion', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q22,
'Material but not pervasive = Qualified. Material and pervasive = Adverse.',
'Under PSA 705 (ISA 705) Modifications to the Opinion in the Independent Auditors Report, when the auditor concludes that misstatements are MATERIAL BUT NOT PERVASIVE, the auditor shall express a QUALIFIED OPINION. The misstatements are significant enough to matter to users (material) but do not affect the financial statements as a whole (not pervasive). The qualified opinion states that except for the effects of the matter described, the financial statements are fairly presented.',
'A is wrong - Unmodified opinion is issued when there are no material misstatements. C is wrong - Adverse opinion is issued when misstatements are both material AND pervasive. D is wrong - Disclaimer is issued when the auditor cannot obtain sufficient appropriate evidence (scope limitation) and effects could be both material and pervasive.',
'Material + Not Pervasive = QUALIFIED. Material + Pervasive = ADVERSE',
'EXAM');

-- AUD Q6: Management Representations
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (12, 'AUD-EVID-Q002', 'Written representations from management are:', 'EASY', 22, 'FREE');
SET @q23 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q23, 'A', 'A substitute for other audit procedures', 0, 1),
(@q23, 'B', 'Necessary audit evidence but not sufficient on their own', 1, 2),
(@q23, 'C', 'Optional evidence that the auditor may choose to obtain', 0, 3),
(@q23, 'D', 'The most reliable form of audit evidence', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q23,
'Management representations are required but must be corroborated with other evidence.',
'Under PSA 580 (ISA 580) Written Representations, the auditor shall request written representations from management. However, written representations DO NOT provide sufficient appropriate audit evidence on their own about any of the matters with which they deal. They are NECESSARY but not SUFFICIENT. The auditor must corroborate management representations with other audit evidence because representations are internal evidence from parties who are not independent of the entity.',
'A is wrong - Representations cannot substitute for other procedures that should be performed. C is wrong - Written representations are required, not optional, under auditing standards. D is wrong - Management representations are among the least reliable forms of evidence because they come from internal sources.',
'Management letter = NECESSARY but NOT SUFFICIENT (must corroborate)',
'EXAM');

-- AUD Q7: Substantive Procedures
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (12, 'AUD-EVID-Q003', 'Which of the following is a substantive procedure?', 'MEDIUM', 22, 'FREE');
SET @q24 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q24, 'A', 'Testing the operating effectiveness of controls over cash disbursements', 0, 1),
(@q24, 'B', 'Confirming accounts receivable balances with customers', 1, 2),
(@q24, 'C', 'Observing the client taking physical inventory', 0, 3),
(@q24, 'D', 'Evaluating the design of the revenue cycle controls', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q24,
'Substantive procedures test for material misstatements in account balances.',
'Under PSA 330 (ISA 330), substantive procedures are audit procedures designed to detect MATERIAL MISSTATEMENTS at the assertion level. They include tests of details of transactions, account balances, and disclosures, as well as substantive analytical procedures. Confirming accounts receivable balances with customers is a TEST OF DETAILS that directly verifies the existence and accuracy of reported balances.',
'A is wrong - Testing operating effectiveness of controls is a test of controls, not a substantive procedure. C is wrong - Inventory observation tests the effectiveness of the clients count procedures (partly a control test). D is wrong - Evaluating control design is part of understanding internal control, not substantive testing.',
'Substantive = Testing AMOUNTS/BALANCES. Controls testing = Testing PROCEDURES/PROCESSES',
'EXAM');

-- AUD Q8: Going Concern
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (11, 'AUD-GC-Q001', 'When substantial doubt exists about an entitys ability to continue as a going concern, the auditors report should:', 'HARD', 19, 'FREE');
SET @q25 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q25, 'A', 'Always include an adverse opinion', 0, 1),
(@q25, 'B', 'Include an emphasis of matter paragraph if disclosures are adequate', 1, 2),
(@q25, 'C', 'Always disclaim an opinion', 0, 3),
(@q25, 'D', 'Omit any reference to going concern', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q25,
'Going concern issues require emphasis of matter when disclosures are adequate; qualified/adverse when inadequate.',
'Under PSA 570 (ISA 570) Going Concern, if adequate disclosure about the material uncertainty is made in the financial statements, the auditor shall express an UNMODIFIED OPINION and include an EMPHASIS OF MATTER paragraph in the auditors report. If adequate disclosure is not made, the auditor shall express a qualified or adverse opinion. The emphasis of matter draws users attention to the going concern uncertainty disclosed in the notes.',
'A is wrong - Adverse opinion is issued when disclosures are inadequate and the effects are material and pervasive. C is wrong - Disclaimer relates to scope limitations, not going concern issues per se. D is wrong - The auditor must highlight the going concern uncertainty to users.',
'Going Concern: Adequate disclosure = EOM paragraph. Inadequate = Qualified/Adverse',
'EXAM');

-- ============================================================================
-- TAX - Taxation (9 Questions)
-- ============================================================================

-- TAX Q1: Income Tax Principles
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (13, 'TAX-INCOME-Q001', 'Under Philippine tax law, the principle that income is taxable when actually or constructively received is known as:', 'EASY', 25, 'FREE');
SET @q26 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q26, 'A', 'Accrual method', 0, 1),
(@q26, 'B', 'Cash method or cash basis', 1, 2),
(@q26, 'C', 'Installment method', 0, 3),
(@q26, 'D', 'Percentage of completion method', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q26,
'Cash basis recognizes income when received and expenses when paid.',
'Under Philippine tax law (NIRC Section 43), taxpayers may elect to report income on the CASH BASIS, where income is recognized when actually or constructively RECEIVED, and expenses are deducted when actually PAID. Constructive receipt occurs when income is credited to the taxpayers account, set apart, or made available without restriction. This contrasts with the accrual method, where income is recognized when earned regardless of receipt.',
'A is wrong - Accrual method recognizes income when earned, not when received. C is wrong - Installment method is a special method for sales on installment. D is wrong - Percentage of completion is for long-term construction contracts.',
'CASH basis = income when RECEIVED, expense when PAID',
'EXAM');

-- TAX Q2: Gross Income
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (13, 'TAX-GROSS-Q001', 'Which of the following is EXCLUDED from gross income under the NIRC?', 'MEDIUM', 26, 'FREE');
SET @q27 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q27, 'A', 'Salaries and wages', 0, 1),
(@q27, 'B', 'Proceeds of life insurance paid to beneficiaries upon death of the insured', 1, 2),
(@q27, 'C', 'Interest income from bank deposits', 0, 3),
(@q27, 'D', 'Rental income from properties', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q27,
'Life insurance proceeds to heirs are excluded because they compensate for loss of life, not income.',
'Under NIRC Section 32(B), the following items are EXCLUSIONS from gross income: (1) Life insurance proceeds paid to the heirs or beneficiaries upon the death of the insured; (2) Amount received by the insured as return of premium; (3) Gifts, bequests, and devises (subject to donors tax or estate tax instead); (4) Compensation for injuries or sickness; (5) Income exempt under treaty; (6) Retirement benefits, etc.',
'A is wrong - Salaries and wages are compensation income and are taxable. C is wrong - Interest income is taxable (subject to final withholding tax for bank deposits). D is wrong - Rental income is part of gross income and taxable.',
'EXCLUSIONS from gross income: Life insurance (death), Gifts, Injury compensation (LGI)',
'EXAM');

-- TAX Q3: Deductions
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (13, 'TAX-DED-Q001', 'The Optional Standard Deduction (OSD) for corporations is computed as:', 'MEDIUM', 27, 'FREE');
SET @q28 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q28, 'A', '40% of gross sales', 0, 1),
(@q28, 'B', '40% of gross income', 1, 2),
(@q28, 'C', '40% of net income', 0, 3),
(@q28, 'D', '40% of total assets', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q28,
'OSD for corporations is 40% of gross income; for individuals it is 40% of gross sales/receipts.',
'Under NIRC Section 34(L), corporations may elect to use the Optional Standard Deduction in lieu of itemized deductions. For CORPORATIONS, OSD is 40% of GROSS INCOME. For individuals, OSD is 40% of gross sales or gross receipts. Gross income for corporations means gross sales less cost of sales for sellers of goods, or gross receipts less direct costs for sellers of services.',
'A is wrong - 40% of gross sales applies to individual taxpayers, not corporations. C is wrong - Net income is the result after deductions; you cannot deduct from it. D is wrong - Total assets is not a basis for any deduction.',
'OSD: Corporation = 40% of GROSS INCOME. Individual = 40% of Gross Sales/Receipts',
'EXAM');

-- TAX Q4: Corporate Tax
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (13, 'TAX-CORP-Q001', 'Under the CREATE Law, the regular corporate income tax (RCIT) rate for domestic corporations is:', 'EASY', 28, 'FREE');
SET @q29 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q29, 'A', '30%', 0, 1),
(@q29, 'B', '25%', 1, 2),
(@q29, 'C', '20%', 0, 3),
(@q29, 'D', '35%', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q29,
'CREATE Law reduced RCIT from 30% to 25% effective July 1, 2020.',
'Under Republic Act No. 11534 (CREATE Law), effective July 1, 2020, the regular corporate income tax rate was reduced from 30% to 25% for domestic corporations and resident foreign corporations. For domestic corporations with net taxable income not exceeding P5 million AND total assets not exceeding P100 million (excluding land), the rate is 20%. The 25% rate applies to large corporations and is a significant reduction from the previous 30%.',
'A is wrong - 30% was the old rate before CREATE Law. C is wrong - 20% applies only to small corporations meeting both asset and income thresholds. D is wrong - 35% is not a current corporate tax rate in the Philippines.',
'CREATE Law RCIT: Large corps = 25%, Small corps (P5M income, P100M assets) = 20%',
'EXAM');

-- TAX Q5: VAT
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (14, 'TAX-VAT-Q001', 'The standard Value Added Tax (VAT) rate in the Philippines is:', 'EASY', 29, 'FREE');
SET @q30 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q30, 'A', '10%', 0, 1),
(@q30, 'B', '12%', 1, 2),
(@q30, 'C', '15%', 0, 3),
(@q30, 'D', '5%', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q30,
'Philippine VAT rate is 12%, among the lower rates in ASEAN.',
'Under NIRC Section 106, as amended by RA 9337, the standard VAT rate in the Philippines is 12%. VAT is imposed on the sale of goods, properties, and services, as well as on importation of goods. The 12% rate has been in effect since February 1, 2006. The VAT threshold for mandatory registration is P3,000,000 in gross sales or receipts.',
'A is wrong - 10% was the old VAT rate before RA 9337. C is wrong - 15% is higher than the current rate. D is wrong - 5% is not the standard rate; some transactions have 0% (zero-rated) or are VAT-exempt.',
'Philippine VAT = 12% (since 2006). Threshold = P3M gross sales for VAT registration',
'EXAM');

-- TAX Q6: Withholding Tax
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (13, 'TAX-WH-Q001', 'Final withholding tax on interest income from Philippine currency bank deposits is:', 'EASY', 25, 'FREE');
SET @q31 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q31, 'A', '10%', 0, 1),
(@q31, 'B', '15%', 0, 2),
(@q31, 'C', '20%', 1, 3),
(@q31, 'D', '25%', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q31,
'Bank deposit interest in peso is subject to 20% final withholding tax.',
'Under NIRC Section 24(B)(1) and Section 27(D)(1), interest income from Philippine currency bank deposits is subject to a FINAL WITHHOLDING TAX of 20%. This means the tax is withheld at source and the recipient does not need to include this income in the tax return anymore. For foreign currency deposits, the rate is 15%. Long-term deposits (5 years or more) may be exempt.',
'A is wrong - 10% is not the rate for bank deposit interest. B is wrong - 15% applies to foreign currency deposits, not peso deposits. D is wrong - 25% is not applicable to bank interest.',
'Peso deposit interest = 20% FWT. Foreign currency = 15% FWT. Long-term (5+ years) = exempt',
'EXAM');

-- TAX Q7: Estate Tax
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (13, 'TAX-ESTATE-Q001', 'Under the TRAIN Law, the estate tax rate is:', 'EASY', 30, 'FREE');
SET @q32 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q32, 'A', 'Progressive rates from 5% to 20%', 0, 1),
(@q32, 'B', 'A flat rate of 6%', 1, 2),
(@q32, 'C', 'A flat rate of 12%', 0, 3),
(@q32, 'D', 'Progressive rates from 2% to 15%', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q32,
'TRAIN Law simplified estate tax to a flat 6% rate on net estate over P5 million.',
'Under the TRAIN Law (RA 10963), effective January 1, 2018, estate tax is imposed at a FLAT RATE of 6% on the NET ESTATE of every decedent. The net estate is computed after deducting from the gross estate the allowable deductions including the standard deduction of P5,000,000 and other deductions for claims against the estate, unpaid mortgages, property previously taxed, and family home (up to P10M).',
'A is wrong - Progressive rates were used before TRAIN Law. C is wrong - 12% is the VAT rate, not estate tax. D is wrong - These were not the old estate tax rates.',
'Estate Tax (TRAIN) = FLAT 6% of Net Estate. Standard deduction = P5 million',
'EXAM');

-- TAX Q8: Donors Tax
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (13, 'TAX-DONOR-Q001', 'Under the TRAIN Law, the donors tax rate for donations made to relatives is:', 'MEDIUM', 30, 'FREE');
SET @q33 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q33, 'A', '6% of net gifts', 1, 1),
(@q33, 'B', '30% of net gifts', 0, 2),
(@q33, 'C', '12% of gross gifts', 0, 3),
(@q33, 'D', '10% of net gifts', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q33,
'TRAIN Law unified donors tax at 6% regardless of relationship.',
'Under the TRAIN Law, effective January 1, 2018, donors tax is imposed at a FLAT RATE of 6% on the total NET GIFTS made during the calendar year, regardless of whether the donee is a relative or a stranger. Before TRAIN, different rates applied based on relationship (2%-15% for relatives, 30% for strangers). The first P250,000 of net gifts is exempt from donors tax.',
'A is correct - 6% flat rate applies to all donations. B is wrong - 30% was the old rate for donations to strangers. C is wrong - The base is net gifts, not gross. D is wrong - 10% is not the donors tax rate.',
'Donors Tax (TRAIN) = FLAT 6% (same as estate tax). Exempt = first P250,000',
'EXAM');

-- TAX Q9: Tax on Passive Income
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (14, 'TAX-PASSIVE-Q001', 'Dividends received by a domestic corporation from another domestic corporation are:', 'HARD', 25, 'FREE');
SET @q34 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q34, 'A', 'Subject to 10% final withholding tax', 0, 1),
(@q34, 'B', 'Subject to 25% corporate income tax', 0, 2),
(@q34, 'C', 'Exempt from income tax', 1, 3),
(@q34, 'D', 'Subject to 20% final withholding tax', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q34,
'Intercorporate dividends are exempt to avoid double taxation at the corporate level.',
'Under NIRC Section 27(D)(4), dividends received by a DOMESTIC CORPORATION from another DOMESTIC CORPORATION are EXEMPT from income tax. This exemption prevents double taxation since the distributing corporation has already paid corporate income tax on the earnings from which dividends are distributed. Note: Dividends received by individuals are subject to 10% final tax (or 6% under CREATE for listed company shares).',
'A is wrong - 10% applies to individuals receiving dividends, not corporations. B is wrong - Dividends are not subject to regular corporate income tax for domestic recipients. D is wrong - 20% does not apply to intercorporate dividends.',
'Intercorporate dividends (DC to DC) = EXEMPT. Individual receiving dividends = 10% FWT',
'EXAM');

-- ============================================================================
-- MS - Management Services (8 Questions)
-- ============================================================================

-- MS Q1: Cost Concepts
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (15, 'MS-COST-Q001', 'Costs that remain constant in total regardless of changes in the level of activity within a relevant range are called:', 'EASY', 31, 'FREE');
SET @q35 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q35, 'A', 'Variable costs', 0, 1),
(@q35, 'B', 'Fixed costs', 1, 2),
(@q35, 'C', 'Mixed costs', 0, 3),
(@q35, 'D', 'Step costs', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q35,
'Fixed costs are constant in total but vary per unit as activity changes.',
'FIXED COSTS remain constant in TOTAL within the relevant range of activity, regardless of changes in the activity level. Examples include rent, depreciation (straight-line), insurance, and salaries. However, fixed costs per unit DECREASE as activity increases because the total fixed cost is spread over more units. The relevant range is the range of activity within which cost behavior assumptions are valid.',
'A is wrong - Variable costs change in total proportionately with activity level. C is wrong - Mixed costs contain both fixed and variable components. D is wrong - Step costs remain fixed within a range but jump to a higher level when activity exceeds certain thresholds.',
'Fixed = Constant in TOTAL, varies per UNIT. Variable = Constant per UNIT, varies in TOTAL',
'EXAM');

-- MS Q2: CVP Analysis
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (15, 'MS-CVP-Q001', 'The break-even point in units is calculated by dividing fixed costs by:', 'EASY', 32, 'FREE');
SET @q36 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q36, 'A', 'Selling price per unit', 0, 1),
(@q36, 'B', 'Variable cost per unit', 0, 2),
(@q36, 'C', 'Contribution margin per unit', 1, 3),
(@q36, 'D', 'Total contribution margin', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q36,
'Break-even units = Fixed Costs / Contribution Margin per Unit.',
'The BREAK-EVEN POINT in units is calculated as: Fixed Costs / Contribution Margin per Unit. The contribution margin per unit equals selling price per unit minus variable cost per unit. At break-even, total contribution margin exactly covers fixed costs, resulting in zero profit. Each unit sold contributes its CM toward covering fixed costs; once all fixed costs are covered, each additional unit contributes to profit.',
'A is wrong - Dividing fixed costs by selling price ignores variable costs. B is wrong - Dividing by variable cost alone is not meaningful. D is wrong - Total CM is a result, not a divisor in the break-even formula.',
'Break-even units = FC / CM per unit. Break-even sales = FC / CM ratio',
'EXAM');

-- MS Q3: Contribution Margin
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (15, 'MS-CVP-Q002', 'If a company has sales of P500,000, variable costs of P300,000, and fixed costs of P150,000, what is the contribution margin ratio?', 'MEDIUM', 32, 'FREE');
SET @q37 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q37, 'A', '30%', 0, 1),
(@q37, 'B', '40%', 1, 2),
(@q37, 'C', '60%', 0, 3),
(@q37, 'D', '10%', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q37,
'CM Ratio = (Sales - Variable Costs) / Sales = (500,000 - 300,000) / 500,000 = 40%',
'The CONTRIBUTION MARGIN RATIO is calculated as: (Sales - Variable Costs) / Sales, or equivalently, Contribution Margin / Sales. In this problem: CM = P500,000 - P300,000 = P200,000. CM Ratio = P200,000 / P500,000 = 0.40 or 40%. This means 40% of each sales peso contributes to covering fixed costs and generating profit. The variable cost ratio is 60% (300,000/500,000).',
'A is wrong - 30% would be if variable costs were P350,000. C is wrong - 60% is the variable cost ratio, not CM ratio. D is wrong - 10% would be the profit margin (50,000/500,000), not CM ratio.',
'CM Ratio = CM / Sales = (S - VC) / S. Variable Cost Ratio = VC / S. They sum to 100%',
'EXAM');

-- MS Q4: Budgeting
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (16, 'MS-BUDGET-Q001', 'A budget that is prepared for a single level of activity is called:', 'EASY', 33, 'FREE');
SET @q38 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q38, 'A', 'Flexible budget', 0, 1),
(@q38, 'B', 'Static budget', 1, 2),
(@q38, 'C', 'Rolling budget', 0, 3),
(@q38, 'D', 'Zero-based budget', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q38,
'Static budget is fixed for one activity level; flexible budget adjusts for actual activity.',
'A STATIC BUDGET (also called a fixed or master budget) is prepared for ONE expected level of activity. It does not change regardless of actual activity levels achieved. A static budget is useful for planning but has limitations for performance evaluation because it does not adjust for volume differences. Comparing actual results to a static budget when activity differs can produce misleading variances.',
'A is wrong - Flexible budgets are prepared for multiple activity levels or adjusted to actual activity. C is wrong - Rolling budgets are continuously updated by adding new periods. D is wrong - Zero-based budgets require justifying all expenditures from zero each period.',
'STATIC = one activity level, FIXED. FLEXIBLE = adjusts to ACTUAL activity',
'EXAM');

-- MS Q5: Standard Costing
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (16, 'MS-STD-Q001', 'If actual costs are less than standard costs, the variance is:', 'EASY', 34, 'FREE');
SET @q39 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q39, 'A', 'Unfavorable', 0, 1),
(@q39, 'B', 'Favorable', 1, 2),
(@q39, 'C', 'Immaterial', 0, 3),
(@q39, 'D', 'Cannot be determined', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q39,
'Spending less than standard is favorable; spending more is unfavorable.',
'In standard costing, a variance is FAVORABLE when actual costs are LESS than standard costs (for cost items) because it means the company spent less than expected. Conversely, a variance is UNFAVORABLE when actual costs EXCEED standard costs. For revenue items, the opposite applies: actual revenue exceeding budget is favorable. Variances are analyzed to identify causes and take corrective action.',
'A is wrong - Unfavorable means actual exceeded standard (overspending). C is wrong - Materiality is a separate consideration from favorable/unfavorable classification. D is wrong - The relationship between actual and standard determines favorability.',
'Cost variance: Actual < Standard = FAVORABLE. Actual > Standard = UNFAVORABLE',
'EXAM');

-- MS Q6: Relevant Costing
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (16, 'MS-DECISION-Q001', 'Sunk costs are:', 'EASY', 35, 'FREE');
SET @q40 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q40, 'A', 'Relevant for decision making', 0, 1),
(@q40, 'B', 'Irrelevant for decision making', 1, 2),
(@q40, 'C', 'Always variable costs', 0, 3),
(@q40, 'D', 'Future costs that differ between alternatives', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q40,
'Sunk costs are past costs that cannot be changed by any decision.',
'SUNK COSTS are costs that have already been incurred and CANNOT be changed or avoided by any current or future decision. Because sunk costs will be the same regardless of which alternative is chosen, they are IRRELEVANT for decision making. Examples include the book value of old equipment when deciding whether to replace it. Relevant costs, in contrast, are future costs that differ between alternatives.',
'A is wrong - Sunk costs should be ignored in decision making because they cannot be changed. C is wrong - Sunk costs can be fixed or variable; the defining characteristic is that they are past costs. D is wrong - Future costs that differ are called relevant or differential costs, not sunk costs.',
'SUNK = Past, cannot change = IRRELEVANT. RELEVANT = Future + Differs between alternatives',
'EXAM');

-- MS Q7: Make or Buy
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (16, 'MS-DECISION-Q002', 'In a make-or-buy decision, which of the following costs is most likely to be relevant?', 'MEDIUM', 35, 'FREE');
SET @q41 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q41, 'A', 'Depreciation on existing equipment that will be used regardless of the decision', 0, 1),
(@q41, 'B', 'Direct materials that will be saved if the item is purchased', 1, 2),
(@q41, 'C', 'General corporate overhead allocated based on direct labor hours', 0, 3),
(@q41, 'D', 'Salary of the production supervisor who will not be laid off', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q41,
'Avoidable costs (like direct materials) are relevant because they differ between alternatives.',
'In make-or-buy decisions, RELEVANT COSTS are those that will DIFFER between the alternatives. Direct materials that will be SAVED (avoided) if the item is purchased externally are relevant because this cost will be incurred if the company makes the item but will NOT be incurred if the company buys it. The decision should be based on comparing the avoidable manufacturing costs with the purchase price.',
'A is wrong - Depreciation on equipment that continues regardless of the decision is a sunk cost or unavoidable cost. C is wrong - Allocated overhead that does not change in total is not relevant. D is wrong - If the supervisor will not be laid off, this cost will continue regardless of the decision.',
'Make-or-buy: Compare AVOIDABLE manufacturing costs vs. purchase price + opportunity cost',
'EXAM');

-- MS Q8: Performance Measurement
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (16, 'MS-PERF-Q001', 'Return on Investment (ROI) is calculated as:', 'MEDIUM', 36, 'FREE');
SET @q42 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q42, 'A', 'Operating income divided by average operating assets', 1, 1),
(@q42, 'B', 'Net income divided by sales', 0, 2),
(@q42, 'C', 'Operating income minus cost of capital', 0, 3),
(@q42, 'D', 'Sales divided by average total assets', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q42,
'ROI = Operating Income / Average Operating Assets = Margin x Turnover.',
'RETURN ON INVESTMENT (ROI) is calculated as Operating Income divided by Average Operating Assets. It can also be expressed as: ROI = Margin (Operating Income/Sales) x Turnover (Sales/Operating Assets). ROI measures how efficiently a business unit uses its invested capital to generate profits. It is widely used in decentralized organizations to evaluate divisional performance.',
'B is wrong - Net income/Sales is profit margin, not ROI. C is wrong - Operating income minus cost of capital relates to Residual Income, not ROI. D is wrong - Sales/Assets is asset turnover, only one component of ROI.',
'ROI = Income / Assets = Margin x Turnover. RI = Income - (Assets x Cost of Capital)',
'EXAM');

-- ============================================================================
-- RFBT - Regulatory Framework for Business Transactions (8 Questions)
-- ============================================================================

-- RFBT Q1: Obligations and Contracts
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (18, 'RFBT-OBLIG-Q001', 'Under the Civil Code, an obligation is a juridical necessity to:', 'EASY', 37, 'FREE');
SET @q43 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q43, 'A', 'Give, to do, or not to do', 1, 1),
(@q43, 'B', 'Pay money only', 0, 2),
(@q43, 'C', 'Transfer ownership of property', 0, 3),
(@q43, 'D', 'Perform personal services', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q43,
'Obligation involves giving, doing, or not doing something - the three prestations.',
'Under Article 1156 of the Civil Code, an OBLIGATION is a juridical necessity to give, to do, or not to do. These are called prestations. To GIVE means to deliver a thing. To DO means to perform an act or service. NOT TO DO means to abstain from performing an act. Every obligation has four essential elements: (1) active subject (creditor), (2) passive subject (debtor), (3) prestation (object), and (4) vinculum juris (juridical tie).',
'B is wrong - Money payment is just one type of obligation to give; obligations can involve non-monetary prestations. C is wrong - Transfer of ownership is one effect of certain obligations to give, not the definition. D is wrong - Personal services are one type of obligation to do, not the complete definition.',
'Obligation prestations: GIVE, DO, NOT DO. 4 elements: Creditor, Debtor, Object, Juridical Tie',
'EXAM');

-- RFBT Q2: Sales - Redhibitory Action
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (17, 'RFBT-SALES-Q001', 'A buyer discovered that the thing sold had a hidden defect that made it unfit for its intended use. What is the proper legal action to CANCEL the sale?', 'MEDIUM', 38, 'FREE');
SET @q44 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q44, 'A', 'Accion reinvindicatoria', 0, 1),
(@q44, 'B', 'Accion redhibitoria', 1, 2),
(@q44, 'C', 'Accion publiciana', 0, 3),
(@q44, 'D', 'Accion pauliana', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q44,
'Accion redhibitoria is the action to rescind sale due to hidden defects making the thing unfit.',
'Under Article 1567 of the Civil Code, ACCION REDHIBITORIA is the remedy to withdraw from the contract (rescind the sale) when the thing sold has hidden defects that make it unfit for its intended use or diminish its fitness to such an extent that the buyer would not have acquired it had they known of the defects. The buyer returns the thing; seller returns the price plus damages. Elements: (1) defect is hidden, (2) defect existed at time of sale, (3) defect is serious, (4) buyer was unaware.',
'A is wrong - Accion reinvindicatoria is to recover ownership of property from another who unlawfully possesses it. C is wrong - Accion publiciana is to recover possession (better right), not about defects. D is wrong - Accion pauliana is for creditors to rescind fraudulent transfers by debtors.',
'Hidden defect + cancel sale = REDHIBITORIA. Hidden defect + price reduction = Quanti Minoris',
'EXAM');

-- RFBT Q3: Agency
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (17, 'RFBT-AGENCY-Q001', 'An agency is extinguished by all of the following EXCEPT:', 'MEDIUM', 39, 'FREE');
SET @q45 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q45, 'A', 'Death of the principal', 0, 1),
(@q45, 'B', 'Revocation by the principal', 0, 2),
(@q45, 'C', 'Marriage of the agent', 1, 3),
(@q45, 'D', 'Accomplishment of the purpose of the agency', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q45,
'Marriage does not extinguish agency; death, revocation, and accomplishment do.',
'Under Article 1919 of the Civil Code, agency is extinguished by: (1) revocation by principal; (2) withdrawal by agent; (3) death, civil interdiction, insanity, or insolvency of principal or agent; (4) dissolution of the firm which entrusted or accepted the agency; (5) accomplishment of the object or purpose; (6) expiration of period. Marriage of either party is NOT among the causes of extinguishment.',
'A is wrong - Death of the principal extinguishes agency (unless agency is coupled with interest). B is wrong - The principal may generally revoke the agency at will. D is wrong - Once the purpose is accomplished, the agency naturally terminates.',
'Agency extinguishment: Death, Revocation, Withdrawal, Accomplishment, Expiration (DRWAE)',
'EXAM');

-- RFBT Q4: Partnership
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (17, 'RFBT-PARTNER-Q001', 'A partnership begins to have juridical personality:', 'EASY', 40, 'FREE');
SET @q46 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q46, 'A', 'Upon registration with the SEC', 0, 1),
(@q46, 'B', 'From the moment of the execution of the contract of partnership', 1, 2),
(@q46, 'C', 'When the partnership begins business operations', 0, 3),
(@q46, 'D', 'Upon contribution of capital by all partners', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q46,
'Partnership is consensual and acquires personality upon perfection of the contract.',
'Under Article 1784 of the Civil Code, a partnership begins from the moment of the EXECUTION of the contract unless otherwise stipulated. Partnership is a CONSENSUAL contract - it is perfected by mere consent, upon the concurrence of minds of the partners. Unlike corporations, partnerships do not require SEC registration to acquire juridical personality (though registration may be required for certain purposes).',
'A is wrong - SEC registration is required for corporations, not partnerships (though partnerships may register for business name purposes). C is wrong - Business operations may begin later, but personality exists from contract execution. D is wrong - Capital contribution is an obligation of partners but not a condition for personality.',
'Partnership = CONSENSUAL. Juridical personality from CONTRACT EXECUTION, not registration',
'EXAM');

-- RFBT Q5: Corporation
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (17, 'RFBT-CORP-Q001', 'Under the Revised Corporation Code, the minimum number of incorporators for a stock corporation is:', 'EASY', 41, 'FREE');
SET @q47 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q47, 'A', 'Two (2)', 0, 1),
(@q47, 'B', 'Five (5)', 0, 2),
(@q47, 'C', 'One (1)', 1, 3),
(@q47, 'D', 'Three (3)', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q47,
'RCC allows One Person Corporation (OPC), so minimum is one incorporator.',
'Under the Revised Corporation Code (RA 11232), a stock corporation may now be incorporated by ONE or more persons. This allows the formation of a ONE PERSON CORPORATION (OPC). Before the RCC, the minimum was 5 incorporators and maximum was 15. The OPC must be a natural person, trust, or estate. The sole stockholder is also the sole director unless a nominee and alternate nominee are designated.',
'A is wrong - While 2 is needed for a regular partnership, OPCs need only 1. B is wrong - 5 was the minimum under the old Corporation Code. D is wrong - 3 is not a minimum under the RCC.',
'RCC: Minimum incorporators = ONE (OPC allowed). Old Code = 5 to 15',
'EXAM');

-- RFBT Q6: Negotiable Instruments
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (17, 'RFBT-NI-Q001', 'For an instrument to be negotiable under the Negotiable Instruments Law, it must contain:', 'MEDIUM', 42, 'FREE');
SET @q48 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q48, 'A', 'A statement of the transaction giving rise to the instrument', 0, 1),
(@q48, 'B', 'An unconditional promise or order to pay a sum certain in money', 1, 2),
(@q48, 'C', 'The signature of both the maker and the payee', 0, 3),
(@q48, 'D', 'A specific date of payment that cannot be extended', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q48,
'Negotiability requires unconditional promise/order, sum certain, money, and other requisites.',
'Under Section 1 of the Negotiable Instruments Law (Act No. 2031), an instrument to be negotiable must: (1) be in WRITING and signed by the maker or drawer; (2) contain an UNCONDITIONAL promise or order to pay; (3) pay a SUM CERTAIN IN MONEY; (4) be payable on demand or at a fixed or DETERMINABLE FUTURE TIME; (5) be payable to ORDER or to BEARER. If any condition is attached, the instrument is not negotiable.',
'A is wrong - Stating the underlying transaction would make the promise conditional. C is wrong - Only the maker (for notes) or drawer (for bills) need sign; the payee is the one to receive payment. D is wrong - Payment may be at a determinable future time, not necessarily a fixed date.',
'Negotiability: WUSPOD - Writing, Unconditional, Sum certain, Payable in money, On demand/determinable, Order/bearer',
'EXAM');

-- RFBT Q7: Contracts
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (18, 'RFBT-OBLIG-Q002', 'A contract where one of the parties is incapable of giving consent is:', 'MEDIUM', 37, 'FREE');
SET @q49 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q49, 'A', 'Void', 0, 1),
(@q49, 'B', 'Voidable', 1, 2),
(@q49, 'C', 'Unenforceable', 0, 3),
(@q49, 'D', 'Rescissible', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q49,
'Incapacity to consent makes contract voidable, not void - it can be ratified.',
'Under Article 1390 of the Civil Code, contracts where one of the parties is incapable of giving consent (such as minors, insane persons) are VOIDABLE or annullable. Voidable contracts are valid until annulled by court action brought by the party whose consent was defective. They may be RATIFIED, which cleanses the defect. This differs from void contracts, which produce no legal effect and cannot be ratified.',
'A is wrong - Void contracts have no legal effect from the beginning (e.g., contracts with unlawful cause). C is wrong - Unenforceable contracts cannot be sued upon but may be ratified (e.g., unauthorized contracts). D is wrong - Rescissible contracts are valid but may be rescinded due to lesion or fraud on creditors.',
'VOIDABLE = Defective consent (can ratify). VOID = Illegal cause/object (cannot ratify)',
'EXAM');

-- RFBT Q8: Sales - Warranty
INSERT INTO questions (practice_set_id, question_code, question_text, difficulty_level, topic_id, access_level)
VALUES (17, 'RFBT-SALES-Q002', 'The warranty against eviction in sales implies that the seller warrants:', 'HARD', 38, 'FREE');
SET @q50 = LAST_INSERT_ID();

INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES
(@q50, 'A', 'The thing is free from hidden defects', 0, 1),
(@q50, 'B', 'The seller has the right to sell and the buyer shall enjoy legal and peaceful possession', 1, 2),
(@q50, 'C', 'The thing conforms to any sample shown to the buyer', 0, 3),
(@q50, 'D', 'The price is fair and reasonable', 0, 4);

INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, explanation_level)
VALUES (@q50,
'Warranty against eviction protects buyers peaceful possession from third-party claims.',
'Under Articles 1548-1560 of the Civil Code, WARRANTY AGAINST EVICTION means the vendor warrants that (1) they have a right to sell the thing, and (2) the vendee shall enjoy LEGAL AND PEACEFUL POSSESSION of the thing. Eviction occurs when a third party with a better right deprives the buyer of the thing purchased. The seller is liable for eviction even without stipulation. Elements: (1) buyer deprived of the thing; (2) by final judgment; (3) based on a right prior to the sale.',
'A is wrong - This describes warranty against hidden defects, not eviction. C is wrong - This relates to sales by sample. D is wrong - There is no implied warranty that the price is fair; parties are free to agree on price.',
'WARRANTY: Against EVICTION = right to sell, peaceful possession. Against HIDDEN DEFECTS = fitness for use',
'EXAM');

-- ============================================================================
-- Verify all questions inserted
-- ============================================================================
SELECT
    s.subject_code,
    COUNT(q.question_id) as question_count
FROM subjects s
LEFT JOIN topics t ON s.subject_id = t.subject_id
LEFT JOIN questions q ON t.topic_id = q.topic_id AND q.access_level = 'FREE'
GROUP BY s.subject_id, s.subject_code
ORDER BY s.display_order;
