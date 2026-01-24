-- ============================================================================
-- CPALE Explained - 50 HARD MCQ Questions
-- Generated: 2026-01-22T22:34:47.762Z
-- ============================================================================

SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================================
-- CREATE PRACTICE SETS FOR FREE MCQs (starting at ID 100 to avoid conflicts)
-- ============================================================================

INSERT INTO practice_sets (practice_set_id, topic_id, set_code, set_name, set_type, is_paid, display_order, is_active, questions_per_set, access_level)
VALUES (100, 1, 'FAR-FREE-50', 'FAR Free MCQs', 'PRACTICE', 0, 100, 1, 9, 'FREE')
ON DUPLICATE KEY UPDATE set_name = VALUES(set_name), questions_per_set = VALUES(questions_per_set);

INSERT INTO practice_sets (practice_set_id, topic_id, set_code, set_name, set_type, is_paid, display_order, is_active, questions_per_set, access_level)
VALUES (101, 36, 'AFAR-FREE-50', 'AFAR Free MCQs', 'PRACTICE', 0, 101, 1, 8, 'FREE')
ON DUPLICATE KEY UPDATE set_name = VALUES(set_name), questions_per_set = VALUES(questions_per_set);

INSERT INTO practice_sets (practice_set_id, topic_id, set_code, set_name, set_type, is_paid, display_order, is_active, questions_per_set, access_level)
VALUES (102, 68, 'AUD-FREE-50', 'AUD Free MCQs', 'PRACTICE', 0, 102, 1, 8, 'FREE')
ON DUPLICATE KEY UPDATE set_name = VALUES(set_name), questions_per_set = VALUES(questions_per_set);

INSERT INTO practice_sets (practice_set_id, topic_id, set_code, set_name, set_type, is_paid, display_order, is_active, questions_per_set, access_level)
VALUES (103, 91, 'TAX-FREE-50', 'TAX Free MCQs', 'PRACTICE', 0, 103, 1, 9, 'FREE')
ON DUPLICATE KEY UPDATE set_name = VALUES(set_name), questions_per_set = VALUES(questions_per_set);

INSERT INTO practice_sets (practice_set_id, topic_id, set_code, set_name, set_type, is_paid, display_order, is_active, questions_per_set, access_level)
VALUES (104, 112, 'MS-FREE-50', 'MS Free MCQs', 'PRACTICE', 0, 104, 1, 8, 'FREE')
ON DUPLICATE KEY UPDATE set_name = VALUES(set_name), questions_per_set = VALUES(questions_per_set);

INSERT INTO practice_sets (practice_set_id, topic_id, set_code, set_name, set_type, is_paid, display_order, is_active, questions_per_set, access_level)
VALUES (105, 133, 'RFBT-FREE-50', 'RFBT Free MCQs', 'PRACTICE', 0, 105, 1, 8, 'FREE')
ON DUPLICATE KEY UPDATE set_name = VALUES(set_name), questions_per_set = VALUES(questions_per_set);


SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================================
-- INSERT QUESTIONS
-- ============================================================================

-- Question 1: AFAR-HARD-001
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (1, 101, 36, 'AFAR-HARD-001', 'Partners A and B share profits 60:40. Partner C is admitted for a 25% interest by contributing PHP 500,000 when the partnership capital is PHP 1,200,000. If the bonus method is used, what is Partner C''s capital credit?', 'HARD', 'FREE', 1, 0);

-- Question 2: AFAR-HARD-002
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (2, 101, 48, 'AFAR-HARD-002', 'Under PFRS 3, which of the following is NOT measured at fair value on the acquisition date in a business combination?', 'HARD', 'FREE', 1, 0);

-- Question 3: AFAR-HARD-003
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (3, 101, 50, 'AFAR-HARD-003', 'Parent Company owns 80% of Subsidiary. In the current year, Subsidiary sold inventory to Parent for PHP 500,000 with a 25% markup on cost. At year-end, 40% of the inventory remains unsold. What is the unrealized profit to be eliminated in consolidation?', 'HARD', 'FREE', 1, 0);

-- Question 4: AFAR-HARD-004
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (4, 101, 44, 'AFAR-HARD-004', 'ABC Company enters into a construction contract for a building with total contract price of PHP 10,000,000 and estimated total costs of PHP 8,000,000. At year-end, actual costs incurred are PHP 3,200,000. Using the input method under PFRS 15, what is the revenue to be recognized?', 'HARD', 'FREE', 1, 0);

-- Question 5: AFAR-HARD-005
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (5, 101, 47, 'AFAR-HARD-005', 'Home Office ships merchandise to Branch at 125% of cost. Branch reports ending inventory of PHP 250,000 at billed price. What is the unrealized profit in the Branch inventory to be eliminated?', 'HARD', 'FREE', 1, 0);

-- Question 6: AFAR-HARD-006
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (6, 101, 38, 'AFAR-HARD-006', 'In a partnership liquidation, Partner A has a capital balance of PHP 100,000 and a loan payable to the partnership of PHP 30,000. If A is insolvent and cannot contribute to the partnership, what is A''s maximum loss absorption capacity?', 'HARD', 'FREE', 1, 0);

-- Question 7: AFAR-HARD-007
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (7, 101, 50, 'AFAR-HARD-007', 'Under PFRS 10, which of the following is NOT a factor in determining control over an investee?', 'HARD', 'FREE', 1, 0);

-- Question 8: AFAR-HARD-008
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (8, 101, 15, 'AFAR-HARD-008', 'Entity A acquired 30% of Entity B for PHP 5,000,000 when B''s net assets had a fair value of PHP 15,000,000. During the year, B reported net income of PHP 2,000,000 and paid dividends of PHP 500,000. What is the carrying amount of the investment under the equity method?', 'HARD', 'FREE', 1, 0);

-- Question 9: AUD-HARD-001
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (9, 102, 68, 'AUD-HARD-001', 'Under PSA 315, which component of internal control is MOST directly concerned with the entity''s process for identifying business risks and deciding how to address them?', 'HARD', 'FREE', 1, 0);

-- Question 10: AUD-HARD-002
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (10, 102, 71, 'AUD-HARD-002', 'An auditor suspects that accounts receivable may be overstated. Which audit procedure provides the MOST reliable evidence regarding the existence assertion?', 'HARD', 'FREE', 1, 0);

-- Question 11: AUD-HARD-003
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (11, 102, 76, 'AUD-HARD-003', 'Under PSA 700, when the auditor concludes that the financial statements are prepared in all material respects in accordance with the applicable financial reporting framework, which type of opinion should be issued?', 'HARD', 'FREE', 1, 0);

-- Question 12: AUD-HARD-004
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (12, 102, 66, 'AUD-HARD-004', 'Which of the following statements about materiality in auditing is CORRECT under PSA 320?', 'HARD', 'FREE', 1, 0);

-- Question 13: AUD-HARD-005
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (13, 102, 64, 'AUD-HARD-005', 'According to PSA 240, which of the following is the auditor''s responsibility regarding fraud?', 'HARD', 'FREE', 1, 0);

-- Question 14: AUD-HARD-006
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (14, 102, 73, 'AUD-HARD-006', 'An auditor discovered that the client''s management has been manipulating revenue recognition by recording fictitious sales. Under PSA 260, to whom should the auditor communicate this finding FIRST?', 'HARD', 'FREE', 1, 0);

-- Question 15: AUD-HARD-007
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (15, 102, 69, 'AUD-HARD-007', 'When assessing inherent risk under PSA 315, which of the following factors would INCREASE the auditor''s assessment of inherent risk for inventory?', 'HARD', 'FREE', 1, 0);

-- Question 16: AUD-HARD-008
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (16, 102, 74, 'AUD-HARD-008', 'According to PSA 570, when there is substantial doubt about an entity''s ability to continue as a going concern, but management''s disclosures are adequate, how should the auditor''s report be modified?', 'HARD', 'FREE', 1, 0);

-- Question 17: FAR-HARD-001
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (17, 100, 4, 'FAR-HARD-001', 'Under PAS 21, when an entity changes its functional currency, which of the following is the correct accounting treatment?', 'HARD', 'FREE', 1, 0);

-- Question 18: FAR-HARD-002
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (18, 100, 14, 'FAR-HARD-002', 'Entity A holds a debt instrument classified at amortized cost. Due to a significant increase in credit risk, Entity A reclassifies the asset to FVOCI. Under PFRS 9, what is the correct treatment of the difference between amortized cost and fair value at reclassification date?', 'HARD', 'FREE', 1, 0);

-- Question 19: FAR-HARD-003
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (19, 100, 17, 'FAR-HARD-003', 'Company X acquired a building for PHP 10,000,000 on January 1, 2023. The building has a useful life of 20 years. On December 31, 2024, the building''s fair value is PHP 11,500,000. If Company X uses the revaluation model under PAS 16, what is the revaluation surplus to be recognized?', 'HARD', 'FREE', 1, 0);

-- Question 20: FAR-HARD-004
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (20, 100, 4, 'FAR-HARD-004', 'Under PAS 37, which of the following conditions must ALL be met for a provision to be recognized?', 'HARD', 'FREE', 1, 0);

-- Question 21: FAR-HARD-005
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (21, 100, 14, 'FAR-HARD-005', 'Entity A has a 12-month expected credit loss (ECL) of PHP 50,000 and a lifetime ECL of PHP 200,000 on a loan receivable. The credit risk has NOT significantly increased since initial recognition. Under PFRS 9, what loss allowance should be recognized?', 'HARD', 'FREE', 1, 0);

-- Question 22: FAR-HARD-006
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (22, 100, 4, 'FAR-HARD-006', 'Under PFRS 15, when should revenue be recognized for a contract that contains a significant financing component?', 'HARD', 'FREE', 1, 0);

-- Question 23: FAR-HARD-007
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (23, 100, 4, 'FAR-HARD-007', 'Company Z has a defined benefit pension plan. The net defined benefit liability at year-end is PHP 5,000,000 (Present value of DBO: PHP 20M, Fair value of plan assets: PHP 15M). During the year, the service cost was PHP 800,000 and net interest on the net defined benefit liability was PHP 500,000. What is the total expense recognized in profit or loss?', 'HARD', 'FREE', 1, 0);

-- Question 24: FAR-HARD-008
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (24, 100, 4, 'FAR-HARD-008', 'Under PAS 36, when testing a cash-generating unit (CGU) for impairment, how should corporate assets that cannot be allocated on a reasonable basis be treated?', 'HARD', 'FREE', 1, 0);

-- Question 25: FAR-HARD-009
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (25, 100, 4, 'FAR-HARD-009', 'Under PFRS 16, a lessee enters a 5-year lease with annual payments of PHP 1,000,000. The interest rate implicit in the lease is not readily determinable. The lessee''s incremental borrowing rate is 8%. What is the initial measurement of the lease liability?', 'HARD', 'FREE', 1, 0);

-- Question 26: MS-HARD-001
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (26, 104, 115, 'MS-HARD-001', 'Sunrise Manufacturing uses standard costing. The following data relates to direct materials for June 2025: Standard price PHP 50 per kg, Actual price PHP 48 per kg, Standard quantity for actual output 10,000 kg, Actual quantity purchased and used 10,500 kg. What is the total direct materials variance and its breakdown?', 'HARD', 'FREE', 1, 0);

-- Question 27: MS-HARD-002
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (27, 104, 127, 'MS-HARD-002', 'Manila Corp is evaluating an investment requiring PHP 2,000,000 initial outlay with expected annual cash inflows of PHP 600,000 for 5 years. The company''s cost of capital is 12%. The present value factor for an ordinary annuity at 12% for 5 years is 3.6048. What is the profitability index and should the project be accepted?', 'HARD', 'FREE', 1, 0);

-- Question 28: MS-HARD-003
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (28, 104, 114, 'MS-HARD-003', 'Cebu Products has two products with the following data: Product A - selling price PHP 100, variable cost PHP 65, units sold 3,000; Product B - selling price PHP 150, variable cost PHP 90, units sold 2,000. Total fixed costs are PHP 180,000. What is the break-even point in total units using the weighted-average contribution margin approach?', 'HARD', 'FREE', 1, 0);

-- Question 29: MS-HARD-004
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (29, 104, 118, 'MS-HARD-004', 'Davao Manufacturing allocates overhead using activity-based costing. Setup costs total PHP 240,000 with 80 setups. Product X requires 30 setups for 1,000 units while Product Y requires 50 setups for 5,000 units. Under traditional costing using direct labor hours (X: 2,000 DLH, Y: 8,000 DLH), how much LESS overhead would Product X receive compared to ABC?', 'HARD', 'FREE', 1, 0);

-- Question 30: MS-HARD-005
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (30, 104, 113, 'MS-HARD-005', 'Iloilo Corp uses the high-low method to estimate costs. In 2025, the highest activity was 8,000 machine hours with costs of PHP 380,000, and the lowest was 3,000 machine hours with costs of PHP 230,000. If the company expects to operate at 6,000 machine hours next month, what is the estimated total cost?', 'HARD', 'FREE', 1, 0);

-- Question 31: MS-HARD-006
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (31, 104, 128, 'MS-HARD-006', 'Batangas Inc. produces a component internally at a cost of: Direct materials PHP 25, Direct labor PHP 15, Variable overhead PHP 10, Fixed overhead (allocated) PHP 20. An outside supplier offers to provide the component for PHP 55 each. If Batangas accepts the offer, 60% of fixed overhead can be eliminated. Should Batangas make or buy if annual requirement is 10,000 units?', 'HARD', 'FREE', 1, 0);

-- Question 32: MS-HARD-007
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (32, 104, 114, 'MS-HARD-007', 'Quezon Manufacturing had the following results for 2025: Sales PHP 5,000,000, Variable costs PHP 3,000,000, Fixed costs PHP 1,500,000. If the company can increase sales by 20% with no change in the cost structure, what will be the percentage increase in operating income?', 'HARD', 'FREE', 1, 0);

-- Question 33: MS-HARD-008
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (33, 104, 129, 'MS-HARD-008', 'Pangasinan Corp is considering replacing old equipment (Book value PHP 100,000, Remaining life 5 years, Annual operating costs PHP 80,000) with new equipment (Cost PHP 300,000, Life 5 years, Annual operating costs PHP 30,000). The old equipment can be sold now for PHP 50,000 but has zero salvage value in 5 years. New equipment has PHP 50,000 salvage value. Ignoring time value of money, should the company replace?', 'HARD', 'FREE', 1, 0);

-- Question 34: RFBT-HARD-001
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (34, 105, 136, 'RFBT-HARD-001', 'X delivered goods to Y under a contract of sale with reservation of ownership until full payment. Y sold the goods to Z, an innocent purchaser for value, before completing payment. What is the status of Z''s ownership?', 'HARD', 'FREE', 1, 0);

-- Question 35: RFBT-HARD-002
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (35, 105, 143, 'RFBT-HARD-002', 'A promissory note states: ''I promise to pay P or bearer the sum of PHP 100,000.'' The note was stolen from P by T, who negotiated it to H, a holder in due course. Can P recover from H?', 'HARD', 'FREE', 1, 0);

-- Question 36: RFBT-HARD-003
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (36, 105, 133, 'RFBT-HARD-003', 'A, B, and C are solidary debtors owing D PHP 300,000. A paid D the entire amount. A now seeks reimbursement. If B is insolvent, how much can A recover from C?', 'HARD', 'FREE', 1, 0);

-- Question 37: RFBT-HARD-004
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (37, 105, 148, 'RFBT-HARD-004', 'X Corp has authorized capital stock of 100,000 shares at PHP 100 par value. It issued 60,000 shares fully paid. The board declared stock dividends of 10% from unrestricted retained earnings of PHP 800,000. What is the effect on X Corp''s capital structure?', 'HARD', 'FREE', 1, 0);

-- Question 38: RFBT-HARD-005
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (38, 105, 144, 'RFBT-HARD-005', 'A draws a check payable to B. B indorses it specially to C. C indorses it in blank. D finds the check and transfers it to E for value. E deposits it in his bank which collects from the drawee bank. Who may be held liable to B if B''s indorsement was forged?', 'HARD', 'FREE', 1, 0);

-- Question 39: RFBT-HARD-006
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (39, 105, 137, 'RFBT-HARD-006', 'X leased a building to Y for 5 years at PHP 50,000 monthly rent. After 2 years, X sold the building to Z without notifying Y. Y continued paying rent to X. Z now demands that Y vacate or pay rent to Z. What are Y''s rights?', 'HARD', 'FREE', 1, 0);

-- Question 40: RFBT-HARD-007
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (40, 105, 138, 'RFBT-HARD-007', 'ABC Partnership (A-40%, B-35%, C-25%) has assets of PHP 1,000,000 and liabilities of PHP 400,000. D is admitted as a new partner by contributing PHP 200,000 for a 20% interest. Using the bonus method, what is D''s capital credit?', 'HARD', 'FREE', 1, 0);

-- Question 41: RFBT-HARD-008
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (41, 105, 148, 'RFBT-HARD-008', 'X Corp declared cash dividends of PHP 1,000,000 on December 1, 2025, payable on January 15, 2026, to stockholders of record as of December 15, 2025. On December 10, A sold all his shares to B. Who is entitled to the dividend and when does the liability arise?', 'HARD', 'FREE', 1, 0);

-- Question 42: TAX-HARD-001
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (42, 103, 95, 'TAX-HARD-001', 'A resident citizen received PHP 2,000,000 dividend income from a domestic corporation. Under the Tax Code as amended by TRAIN Law, what is the correct tax treatment?', 'HARD', 'FREE', 1, 0);

-- Question 43: TAX-HARD-002
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (43, 103, 95, 'TAX-HARD-002', 'Mr. Santos, a resident citizen, sold shares of stock of a domestic corporation through the Philippine Stock Exchange. The gross selling price was PHP 5,000,000. What is the stock transaction tax due?', 'HARD', 'FREE', 1, 0);

-- Question 44: TAX-HARD-003
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (44, 103, 101, 'TAX-HARD-003', 'A deceased Filipino citizen left a gross estate of PHP 15,000,000 in the Philippines and PHP 5,000,000 abroad. Deductible expenses and losses amount to PHP 3,000,000. What is the net taxable estate under the TRAIN Law?', 'HARD', 'FREE', 1, 0);

-- Question 45: TAX-HARD-004
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (45, 103, 103, 'TAX-HARD-004', 'A VAT-registered taxpayer had the following for the quarter: Output VAT PHP 240,000, Input VAT from capital goods PHP 180,000, Input VAT from purchases PHP 100,000. What is the VAT payable?', 'HARD', 'FREE', 1, 0);

-- Question 46: TAX-HARD-005
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (46, 103, 95, 'TAX-HARD-005', 'Under the Tax Code, which of the following fringe benefits is EXEMPT from fringe benefits tax?', 'HARD', 'FREE', 1, 0);

-- Question 47: TAX-HARD-006
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (47, 103, 97, 'TAX-HARD-006', 'Corporation XYZ had gross income of PHP 10,000,000 and allowable deductions of PHP 7,000,000 in its first year of operations. It opted for Optional Standard Deduction (OSD). Under CREATE Law, what is the taxable income?', 'HARD', 'FREE', 1, 0);

-- Question 48: TAX-HARD-007
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (48, 103, 97, 'TAX-HARD-007', 'A non-resident foreign corporation engaged in business in the Philippines had gross income of PHP 50,000,000. Under CREATE Law, what is the applicable corporate income tax rate?', 'HARD', 'FREE', 1, 0);

-- Question 49: TAX-HARD-008
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (49, 103, 102, 'TAX-HARD-008', 'Mr. Reyes, a resident citizen, donated a parcel of land to his son. The fair market value per BIR is PHP 5,000,000 and per Assessor is PHP 4,000,000. What is the tax base for donor''s tax?', 'HARD', 'FREE', 1, 0);

-- Question 50: TAX-HARD-009
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (50, 103, 94, 'TAX-HARD-009', 'A resident citizen received a cash dividend of PHP 500,000 from a domestic corporation in March 2025. The corporation has accumulated earnings and profits of PHP 2,000,000 and paid-up capital of PHP 5,000,000. What is the tax treatment of this dividend?', 'HARD', 'FREE', 1, 0);


-- ============================================================================
-- INSERT QUESTION CHOICES
-- ============================================================================

-- Choices for AFAR-HARD-001
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (1, 1, 'PHP 425,000', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (2, 1, 'PHP 500,000', 0, 'This equals the contribution; bonus method adjusts capital based on agreed interest percentage', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (3, 1, 'PHP 300,000', 0, 'This is 25% of old capital (1,200,000), ignoring C''s contribution in total capital calculation', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (4, 1, 'PHP 325,000', 0, 'Incorrect calculation; must compute 25% of total agreed capital after C''s admission', 4, 1);

-- Choices for AFAR-HARD-002
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (5, 2, 'Deferred tax assets arising from the acquisition', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (6, 2, 'Identifiable intangible assets acquired', 0, 'PFRS 3.18 requires identifiable intangible assets to be measured at fair value', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (7, 2, 'Contingent liabilities assumed', 0, 'PFRS 3.23 requires contingent liabilities to be recognized at fair value if present obligation', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (8, 2, 'Non-controlling interest (full goodwill method)', 0, 'Under full goodwill method, NCI is measured at fair value (PFRS 3.19)', 4, 1);

-- Choices for AFAR-HARD-003
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (9, 3, 'PHP 40,000', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (10, 3, 'PHP 50,000', 0, 'This calculates 25% of ending inventory (500,000 × 40% × 25%), but markup is on COST not selling price', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (11, 3, 'PHP 100,000', 0, 'This is total profit on sale; must isolate only the UNREALIZED portion in ending inventory', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (12, 3, 'PHP 32,000', 0, 'This applies NCI percentage (80%); unrealized profit elimination is 100% regardless of NCI', 4, 1);

-- Choices for AFAR-HARD-004
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (13, 4, 'PHP 4,000,000', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (14, 4, 'PHP 3,200,000', 0, 'This equals costs incurred; revenue is based on percentage of completion × contract price', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (15, 4, 'PHP 10,000,000', 0, 'Full revenue is recognized only when 100% complete; must recognize based on progress', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (16, 4, 'PHP 2,000,000', 0, 'Incorrect percentage calculation; must use costs incurred ÷ total estimated costs', 4, 1);

-- Choices for AFAR-HARD-005
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (17, 5, 'PHP 50,000', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (18, 5, 'PHP 62,500', 0, 'This applies 25% to billed price; the 25% markup is on COST, so GP rate on billed price is 20%', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (19, 5, 'PHP 200,000', 0, 'This is the cost portion (80% of billed price), not the unrealized profit', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (20, 5, 'PHP 37,500', 0, 'Incorrect calculation; the overvaluation equals the markup portion in ending inventory', 4, 1);

-- Choices for AFAR-HARD-006
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (21, 6, 'PHP 70,000', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (22, 6, 'PHP 100,000', 0, 'Must offset loan payable against capital; loan to partnership REDUCES loss absorption', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (23, 6, 'PHP 130,000', 0, 'Loan payable is a DEDUCTION not an addition; it represents amount A owes to partnership', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (24, 6, 'PHP 30,000', 0, 'This is only the loan payable; loss absorption = capital minus loan payable', 4, 1);

-- Choices for AFAR-HARD-007
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (25, 7, 'Legal ownership of more than 50% of shares', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (26, 7, 'Power over the investee through existing rights', 0, 'Power is the first element of control under PFRS 10.7', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (27, 7, 'Exposure or rights to variable returns from involvement', 0, 'Variable returns is the second element of control under PFRS 10.7', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (28, 7, 'Ability to use power to affect the amount of returns', 0, 'Link between power and returns is the third element of control under PFRS 10.7', 4, 1);

-- Choices for AFAR-HARD-008
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (29, 8, 'PHP 5,450,000', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (30, 8, 'PHP 5,600,000', 0, 'This adds share of net income but forgets to deduct share of dividends', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (31, 8, 'PHP 5,000,000', 0, 'This is initial cost only; equity method requires adjustment for investor''s share of earnings', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (32, 8, 'PHP 5,350,000', 0, 'Incorrect calculation; must apply 30% to both net income and dividends separately', 4, 1);

-- Choices for AUD-HARD-001
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (33, 9, 'Risk assessment process', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (34, 9, 'Control activities', 0, 'Control activities are the policies and procedures that help ensure management directives are carried out, not risk identification', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (35, 9, 'Information and communication', 0, 'This component deals with identifying, capturing, and exchanging information, not assessing risks', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (36, 9, 'Monitoring of controls', 0, 'Monitoring assesses the quality of internal control performance over time, not initial risk identification', 4, 1);

-- Choices for AUD-HARD-002
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (37, 10, 'Send positive confirmation requests directly to customers', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (38, 10, 'Vouch sales invoices to shipping documents', 0, 'This tests occurrence of sales, not existence of receivables at year-end', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (39, 10, 'Review subsequent cash receipts in the client''s records', 0, 'Internal documents are less reliable than external confirmations for existence', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (40, 10, 'Perform analytical procedures on accounts receivable aging', 0, 'Analytical procedures provide circumstantial evidence, not direct evidence of existence', 4, 1);

-- Choices for AUD-HARD-003
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (41, 11, 'Unmodified opinion', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (42, 11, 'Qualified opinion', 0, 'Qualified opinion is issued when there are material but not pervasive misstatements or scope limitations', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (43, 11, 'Adverse opinion', 0, 'Adverse opinion is issued when misstatements are material AND pervasive', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (44, 11, 'Disclaimer of opinion', 0, 'Disclaimer is issued when auditor cannot obtain sufficient appropriate audit evidence', 4, 1);

-- Choices for AUD-HARD-004
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (45, 12, 'Performance materiality is set lower than overall materiality to reduce the risk that aggregate uncorrected misstatements exceed materiality', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (46, 12, 'Materiality is a fixed percentage of net income for all entities', 0, 'Materiality involves professional judgment and varies based on entity circumstances and user needs', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (47, 12, 'Once set at planning, materiality cannot be revised during the audit', 0, 'PSA 320.12 requires the auditor to revise materiality if information becomes available that would have caused a different amount', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (48, 12, 'Performance materiality is always set at 50% of overall materiality', 0, 'No fixed percentage exists; performance materiality is based on auditor judgment considering assessment of RMM', 4, 1);

-- Choices for AUD-HARD-005
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (49, 13, 'Obtain reasonable assurance that financial statements are free from material misstatement due to fraud or error', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (50, 13, 'Detect all instances of fraud regardless of materiality', 0, 'Auditors provide reasonable, not absolute assurance; focus is on MATERIAL misstatement', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (51, 13, 'Prevent and detect fraud through implementation of internal controls', 0, 'Prevention and detection of fraud is management''s responsibility, not the auditor''s', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (52, 13, 'Guarantee that no fraud exists in the entity''s financial statements', 0, 'An audit provides reasonable assurance, not a guarantee; inherent limitations exist', 4, 1);

-- Choices for AUD-HARD-006
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (53, 14, 'Those charged with governance', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (54, 14, 'The external regulatory authority', 0, 'External reporting may be required, but communication to TCWG should come first under PSA 260', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (55, 14, 'The company''s shareholders at the annual meeting', 0, 'Auditor communicates to TCWG, not directly to shareholders', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (56, 14, 'Law enforcement agencies', 0, 'Legal reporting may be required, but professional standards require TCWG communication first', 4, 1);

-- Choices for AUD-HARD-007
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (57, 15, 'The inventory includes items requiring subjective valuation estimates', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (58, 15, 'The entity has a simple, stable inventory system with few product lines', 0, 'Simple, stable systems with few products suggest LOWER inherent risk', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (59, 15, 'Inventory turnover is consistent with industry norms', 0, 'Consistent turnover suggests normal operations and lower inherent risk', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (60, 15, 'Physical inventory counts are conducted frequently', 0, 'Frequent counts are a CONTROL that reduces detection risk, not an inherent risk factor', 4, 1);

-- Choices for AUD-HARD-008
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (61, 16, 'Include an Emphasis of Matter paragraph without modifying the opinion', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (62, 16, 'Issue a qualified opinion with explanatory paragraph', 0, 'Qualified opinion is for material misstatement or scope limitation, not going concern with adequate disclosure', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (63, 16, 'Issue an adverse opinion due to the going concern uncertainty', 0, 'Adverse opinion is for material and pervasive misstatement, not for properly disclosed going concern', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (64, 16, 'Issue a disclaimer of opinion due to uncertainty', 0, 'Disclaimer is for scope limitations, not for properly disclosed going concern uncertainty', 4, 1);

-- Choices for FAR-HARD-001
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (65, 17, 'Apply the change prospectively using the exchange rate at the date of change for all items', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (66, 17, 'Restate all prior period comparative financial statements retrospectively', 0, 'PAS 21.35 requires prospective application from the date of change, not retrospective restatement', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (67, 17, 'Recognize the cumulative translation adjustment immediately in profit or loss', 0, 'Translation differences remain in equity; they are not recycled to P&L upon functional currency change under PAS 21.37', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (68, 17, 'Continue using historical rates for all non-monetary items indefinitely', 0, 'Non-monetary items are translated at the rate on the date of change, which becomes their new deemed cost', 4, 1);

-- Choices for FAR-HARD-002
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (69, 18, 'Recognize the difference in other comprehensive income', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (70, 18, 'Recognize the difference immediately in profit or loss', 0, 'PFRS 9.5.6.5 specifically requires recognition in OCI for amortized cost to FVOCI reclassifications', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (71, 18, 'Adjust retained earnings as a prior period adjustment', 0, 'Reclassifications are applied prospectively from reclassification date, not as prior period adjustments', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (72, 18, 'No adjustment is required as both categories use the same measurement', 0, 'Amortized cost and FVOCI use different measurements; fair value adjustment is required upon reclassification', 4, 1);

-- Choices for FAR-HARD-003
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (73, 19, 'PHP 2,500,000', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (74, 19, 'PHP 1,500,000', 0, 'This ignores accumulated depreciation; you must compare fair value to carrying amount, not original cost', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (75, 19, 'PHP 2,000,000', 0, 'Incorrect calculation; the carrying amount after 2 years of depreciation is PHP 9,000,000', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (76, 19, 'PHP 11,500,000', 0, 'This is the fair value, not the revaluation surplus; surplus = FV minus carrying amount', 4, 1);

-- Choices for FAR-HARD-004
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (77, 20, 'Present obligation from past event, probable outflow of resources, and reliable estimate of the amount', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (78, 20, 'Future obligation, possible outflow of resources, and reasonable estimate', 0, 'The obligation must be PRESENT (not future), outflow must be PROBABLE (not possible), and estimate must be RELIABLE', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (79, 20, 'Present obligation, certain outflow of resources, and exact amount determinable', 0, 'Certainty is not required; ''probable'' outflow and ''reliable estimate'' (not exact) are the thresholds', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (80, 20, 'Legal obligation only, probable outflow, and best estimate available', 0, 'Constructive obligations also qualify; the obligation need not be legal only', 4, 1);

-- Choices for FAR-HARD-005
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (81, 21, 'PHP 50,000 (12-month ECL)', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (82, 21, 'PHP 200,000 (Lifetime ECL)', 0, 'Lifetime ECL is recognized only when credit risk has SIGNIFICANTLY INCREASED since initial recognition', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (83, 21, 'PHP 125,000 (Average of 12-month and lifetime)', 0, 'PFRS 9 uses a staged approach, not averaging; Stage 1 uses 12-month ECL only', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (84, 21, 'No loss allowance until actual default occurs', 0, 'PFRS 9 requires forward-looking ECL recognition from Day 1, not incurred loss model', 4, 1);

-- Choices for FAR-HARD-006
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (85, 22, 'At the transaction price adjusted for the time value of money, with interest expense or income recognized separately', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (86, 22, 'At the cash selling price without any adjustment for financing', 0, 'PFRS 15.60-65 requires adjustment for significant financing component to reflect cash selling price', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (87, 22, 'At the total amount receivable including all financing charges', 0, 'This would overstate revenue; financing component must be separated and recognized as interest', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (88, 22, 'Defer all revenue recognition until cash is fully collected', 0, 'PFRS 15 requires revenue recognition when performance obligations are satisfied, adjusted for financing', 4, 1);

-- Choices for FAR-HARD-007
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (89, 23, 'PHP 1,300,000', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (90, 23, 'PHP 800,000', 0, 'This includes only service cost; net interest cost must also be recognized in P&L', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (91, 23, 'PHP 5,000,000', 0, 'This is the net defined benefit liability (balance sheet item), not the expense', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (92, 23, 'PHP 500,000', 0, 'This includes only net interest; service cost must also be recognized in P&L', 4, 1);

-- Choices for FAR-HARD-008
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (93, 24, 'Allocate corporate assets to CGUs on a reasonable and consistent basis, or test impairment at the smallest group of CGUs to which corporate assets can be allocated', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (94, 24, 'Exclude corporate assets entirely from impairment testing', 0, 'PAS 36.102 requires corporate assets to be included in impairment testing at some level', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (95, 24, 'Recognize impairment only if the entire entity shows indicators of impairment', 0, 'Impairment testing should be done at CGU or group of CGUs level, not only entity-wide', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (96, 24, 'Test corporate assets separately as individual assets', 0, 'Corporate assets generally do not generate independent cash flows and cannot be tested individually', 4, 1);

-- Choices for FAR-HARD-009
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (97, 25, 'Present value of PHP 1,000,000 for 5 years at 8% discount rate', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (98, 25, 'PHP 5,000,000 (total undiscounted payments)', 0, 'PFRS 16 requires present value measurement, not nominal/undiscounted amount', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (99, 25, 'Fair value of the underlying asset', 0, 'Fair value is used to determine if rate implicit exists; lease liability uses PV of payments', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (100, 25, 'Present value using risk-free rate', 0, 'If implicit rate is not determinable, use incremental borrowing rate, not risk-free rate', 4, 1);

-- Choices for MS-HARD-001
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (101, 26, 'PHP 4,000 Unfavorable total: PHP 21,000 F price variance and PHP 25,000 U quantity variance', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (102, 26, 'PHP 4,000 Favorable total: PHP 21,000 F price variance and PHP 25,000 F quantity variance', 0, 'The quantity variance is unfavorable because actual quantity (10,500 kg) exceeded standard quantity (10,000 kg); using 500 kg more than standard at PHP 50 = PHP 25,000 U', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (103, 26, 'PHP 4,000 Unfavorable total: PHP 20,000 F price variance and PHP 24,000 U quantity variance', 0, 'Price variance uses actual quantity purchased: (PHP 50 - PHP 48) x 10,500 = PHP 21,000 F, not PHP 20,000', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (104, 26, 'PHP 46,000 Unfavorable total: PHP 21,000 U price variance and PHP 25,000 U quantity variance', 0, 'The price variance is favorable because actual price (PHP 48) was less than standard price (PHP 50), not unfavorable', 4, 1);

-- Choices for MS-HARD-002
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (105, 27, 'Profitability Index of 1.08; Accept the project', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (106, 27, 'Profitability Index of 0.92; Reject the project', 0, 'This incorrectly divides the initial investment by PV of inflows; PI = PV of inflows / Initial investment, not the inverse', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (107, 27, 'Profitability Index of 1.50; Accept the project', 0, 'This uses undiscounted cash flows (PHP 3,000,000 / PHP 2,000,000 = 1.50); PI must use present value of future cash flows', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (108, 27, 'Profitability Index of 0.80; Reject the project', 0, 'This calculation error likely used wrong PV factor or divided incorrectly; correct PI is 1.08', 4, 1);

-- Choices for MS-HARD-003
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (109, 28, '4,000 units (2,400 units of A and 1,600 units of B)', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (110, 28, '3,600 units (2,160 units of A and 1,440 units of B)', 0, 'This used simple average CM of PHP 47.50 instead of weighted-average CM of PHP 45 based on 60:40 sales mix', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (111, 28, '5,143 units (3,086 units of A and 2,057 units of B)', 0, 'This used only Product A''s lower CM of PHP 35 for entire calculation instead of weighted-average', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (112, 28, '3,000 units (1,800 units of A and 1,200 units of B)', 0, 'This used only Product B''s higher CM of PHP 60 for entire calculation instead of weighted-average', 4, 1);

-- Choices for MS-HARD-004
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (113, 29, 'PHP 42,000 less under traditional costing', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (114, 29, 'PHP 42,000 more under traditional costing', 0, 'Traditional costing assigns Product X only PHP 48,000 (20% of overhead) while ABC assigns PHP 90,000 (37.5%); X receives LESS, not more, under traditional', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (115, 29, 'PHP 90,000 less under traditional costing', 0, 'PHP 90,000 is the total ABC allocation to Product X, not the difference between the two methods', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (116, 29, 'PHP 48,000 less under traditional costing', 0, 'PHP 48,000 is the traditional costing allocation to Product X, not the difference; the difference is PHP 90,000 - PHP 48,000 = PHP 42,000', 4, 1);

-- Choices for MS-HARD-005
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (117, 30, 'PHP 320,000', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (118, 30, 'PHP 300,000', 0, 'This uses an incorrect variable cost rate or fixed cost calculation; the correct rate is PHP 30/MH with fixed costs of PHP 140,000', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (119, 30, 'PHP 305,000', 0, 'This likely used average cost per unit (PHP 305,000/6,000) instead of separating fixed and variable components using high-low method', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (120, 30, 'PHP 340,000', 0, 'This calculation error may have used wrong activity levels or cost figures in the high-low formula', 4, 1);

-- Choices for MS-HARD-006
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (121, 31, 'Make internally; saves PHP 10,000 annually', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (122, 31, 'Buy externally; saves PHP 50,000 annually', 0, 'This incorrectly compared full absorption cost (PHP 70) to buy price, ignoring that 40% of fixed OH (PHP 8) is unavoidable and continues regardless', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (123, 31, 'Make internally; saves PHP 200,000 annually', 0, 'This incorrectly treated all fixed overhead (PHP 20) as avoidable; only 60% (PHP 12) is eliminable, not the full amount', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (124, 31, 'Buy externally; saves PHP 70,000 annually', 0, 'This likely used variable costs only (PHP 50) for make vs PHP 55 buy, ignoring avoidable fixed costs of PHP 12/unit', 4, 1);

-- Choices for MS-HARD-007
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (125, 32, '80% increase due to operating leverage of 4.0', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (126, 32, '20% increase proportional to sales increase', 0, 'Operating income does not increase proportionally with sales due to operating leverage; fixed costs remain constant, amplifying profit changes', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (127, 32, '40% increase due to operating leverage of 2.0', 0, 'Operating leverage = CM/Operating Income = PHP 2,000,000/PHP 500,000 = 4.0, not 2.0', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (128, 32, '60% increase due to operating leverage of 3.0', 0, 'The degree of operating leverage is CM (PHP 2,000,000) divided by Operating Income (PHP 500,000) = 4.0, not 3.0', 4, 1);

-- Choices for MS-HARD-008
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (129, 33, 'Replace; net advantage of PHP 50,000 over 5 years', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (130, 33, 'Keep old; replacing causes PHP 50,000 loss from book value write-off', 0, 'The PHP 50,000 loss on disposal (PHP 100,000 BV - PHP 50,000 sale) is a sunk cost; book value is irrelevant for future decisions', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (131, 33, 'Replace; net advantage of PHP 250,000 over 5 years', 0, 'This counted only operating savings (PHP 250,000) without deducting net equipment cost (PHP 200,000)', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (132, 33, 'Keep old; new equipment costs PHP 250,000 net', 0, 'Net equipment cost is PHP 200,000 (PHP 300,000 - PHP 50,000 trade - PHP 50,000 salvage), not PHP 250,000; and this ignores operating savings', 4, 1);

-- Choices for RFBT-HARD-001
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (133, 34, 'Z acquires valid ownership under the doctrine of seller in possession', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (134, 34, 'Z acquires no ownership because Y had no title to transfer', 0, 'While Y technically lacked full ownership, the Civil Code protects innocent purchasers when the seller is in possession with owner''s consent', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (135, 34, 'Z acquires voidable ownership subject to X''s right of rescission', 0, 'Z''s ownership is not voidable; as innocent purchaser for value from seller in possession, Z acquires absolute ownership', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (136, 34, 'Z acquires ownership only upon X receiving full payment from Y', 0, 'Z''s ownership is independent of Y''s payment to X; Z''s protection as innocent purchaser is immediate and unconditional', 4, 1);

-- Choices for RFBT-HARD-002
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (137, 35, 'No, H as holder in due course of a bearer instrument takes free of P''s claim', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (138, 35, 'Yes, because theft is a real defense available against all holders', 0, 'Theft is a personal defense, not a real defense; HDC takes free of personal defenses including theft from prior holder', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (139, 35, 'Yes, because a stolen instrument cannot be negotiated', 0, 'Bearer instruments can be negotiated by mere delivery; even a thief can negotiate to an HDC who takes good title', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (140, 35, 'No, but only if H can prove ignorance of the theft', 0, 'HDC status is determined at time of taking; once established, the burden is not ongoing proof of ignorance', 4, 1);

-- Choices for RFBT-HARD-003
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (141, 36, 'PHP 150,000 (C''s share plus half of B''s share)', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (142, 36, 'PHP 100,000 (C''s share only)', 0, 'Under Article 1217, when a co-debtor is insolvent, the debtor paying must share the loss with the other solvent co-debtors proportionately', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (143, 36, 'PHP 200,000 (C''s share plus entire B''s share)', 0, 'The insolvent''s share is divided among ALL solvent debtors (A and C equally), not charged entirely to C', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (144, 36, 'PHP 300,000 (total amount paid)', 0, 'A can only seek reimbursement for co-debtors'' shares; A must bear his own share plus portion of insolvent''s share', 4, 1);

-- Choices for RFBT-HARD-004
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (145, 37, 'Issued shares increase to 66,000; no change in total stockholders'' equity', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (146, 37, 'Issued shares increase to 66,000; total stockholders'' equity increases by PHP 600,000', 0, 'Stock dividends do not increase total equity; they merely transfer from retained earnings to capital stock (equity reclassification)', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (147, 37, 'Authorized shares must first be increased before stock dividends can be declared', 0, 'There are 40,000 unissued shares available (100,000 - 60,000); 6,000 new shares needed for 10% dividend can be issued', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (148, 37, 'Issued shares increase to 70,000; retained earnings decrease by PHP 1,000,000', 0, '10% of 60,000 shares = 6,000 new shares (not 10,000); RE decreases by 6,000 x PHP 100 = PHP 600,000', 4, 1);

-- Choices for RFBT-HARD-005
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (149, 38, 'All parties after the forged indorsement: C, D, E, and both banks', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (150, 38, 'Only the forger and the drawee bank that paid', 0, 'All parties who took after a forged indorsement are liable; the drawee bank can pass liability upstream to collecting bank and prior transferees', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (151, 38, 'Only A (drawer) and the drawee bank', 0, 'A drawer is not liable on forged indorsement; the loss falls on parties who took after the forgery, not the drawer', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (152, 38, 'Only E and the collecting bank as the last innocent parties', 0, 'All parties in the chain after the forged indorsement are liable in the order of their indorsements under warranty liability', 4, 1);

-- Choices for RFBT-HARD-006
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (153, 39, 'Y may continue the lease until expiry but must pay rent to Z prospectively', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (154, 39, 'Y must vacate immediately as sale terminates the lease', 0, 'Under Art. 1676, the purchaser of leased property must respect the lease if it is recorded or if the buyer knew of it', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (155, 39, 'Y may demand rescission of sale as it prejudices his rights', 0, 'Y has no right to rescind the sale; his protection is continuation of the lease, not preventing the sale', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (156, 39, 'Y may refuse to pay rent to Z until Z presents proof of ownership', 0, 'Once Z proves ownership, Y must pay Z; Y cannot indefinitely withhold rent as defense', 4, 1);

-- Choices for RFBT-HARD-007
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (157, 40, 'PHP 160,000 with PHP 40,000 bonus to old partners', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (158, 40, 'PHP 200,000 equal to his contribution', 0, 'Under bonus method, capital credit is based on percentage interest in new total capital, not contribution amount', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (159, 40, 'PHP 180,000 with PHP 20,000 bonus to old partners', 0, 'D''s 20% of new total capital (PHP 800,000) equals PHP 160,000, not PHP 180,000', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (160, 40, 'PHP 240,000 with PHP 40,000 bonus from old partners', 0, 'The bonus goes TO old partners, not FROM them, since D is paying more than his proportionate capital credit', 4, 1);

-- Choices for RFBT-HARD-008
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (161, 41, 'B is entitled; liability arose on declaration date (December 1)', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (162, 41, 'A is entitled because he owned shares on declaration date', 0, 'Dividend entitlement is determined by record date (December 15), not declaration date; B was stockholder of record', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (163, 41, 'B is entitled; liability arose on record date (December 15)', 0, 'While B is entitled (correct), the dividend liability arose on declaration date when the board declared it, not on record date', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (164, 41, 'A and B split the dividend based on holding period', 0, 'Dividends are not prorated; the stockholder of record on record date receives the entire dividend', 4, 1);

-- Choices for TAX-HARD-001
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (165, 42, 'Subject to 10% final withholding tax', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (166, 42, 'Subject to regular graduated income tax rates', 0, 'Dividend income from domestic corporations is subject to final tax, not regular rates', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (167, 42, 'Exempt from income tax', 0, 'Only inter-corporate dividends (domestic corp to domestic corp) are exempt', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (168, 42, 'Subject to 15% final withholding tax', 0, '15% rate applied before TRAIN Law; current rate is 10% for cash dividends', 4, 1);

-- Choices for TAX-HARD-002
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (169, 43, 'PHP 30,000 (0.6% of gross selling price)', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (170, 43, 'PHP 75,000 (15% of capital gains)', 0, '15% capital gains tax applies to unlisted shares; PSE transactions use stock transaction tax', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (171, 43, 'PHP 250,000 (5% of gross selling price)', 0, '5% applies to real property capital gains tax, not stock transactions', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (172, 43, 'PHP 50,000 (1% of gross selling price)', 0, 'Incorrect rate; stock transaction tax is 0.6% of gross selling price under current law', 4, 1);

-- Choices for TAX-HARD-003
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (173, 44, 'PHP 12,000,000', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (174, 44, 'PHP 17,000,000', 0, 'This deducts only the standard deduction; actual expenses are also deductible', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (175, 44, 'PHP 7,000,000', 0, 'This incorrectly includes a personal exemption that was removed under TRAIN Law', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (176, 44, 'PHP 15,000,000', 0, 'This ignores foreign properties; resident/citizen estates include worldwide assets', 4, 1);

-- Choices for TAX-HARD-004
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (177, 45, 'PHP 0 with excess input VAT of PHP 40,000 to carry forward', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (178, 45, 'PHP 60,000', 0, 'This treats capital goods input VAT as non-creditable; capital goods input VAT is fully creditable', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (179, 45, 'PHP 240,000', 0, 'This ignores all input VAT credits; input VAT reduces output VAT', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (180, 45, '(PHP 40,000) refundable immediately', 0, 'Excess input VAT is generally carried forward, not immediately refundable', 4, 1);

-- Choices for TAX-HARD-005
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (181, 46, 'De minimis benefits not exceeding the ceiling amounts', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (182, 46, 'Company car used for personal purposes', 0, 'Personal use of company car is a taxable fringe benefit', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (183, 46, 'Housing allowance for managerial employees', 0, 'Housing benefits for managerial employees are generally taxable', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (184, 46, 'Expense account for personal expenses', 0, 'Personal expense accounts are taxable fringe benefits', 4, 1);

-- Choices for TAX-HARD-006
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (185, 47, 'PHP 6,000,000', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (186, 47, 'PHP 3,000,000', 0, 'This uses itemized deductions (10M - 7M); OSD replaces itemized deductions', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (187, 47, 'PHP 5,500,000', 0, 'Incorrect OSD rate; OSD for corporations is 40% of gross income', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (188, 47, 'PHP 10,000,000', 0, 'This ignores OSD entirely; OSD is 40% of gross income', 4, 1);

-- Choices for TAX-HARD-007
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (189, 48, '25% of taxable income', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (190, 48, '30% of taxable income', 0, '30% was the old rate before CREATE Law; the new rate is 25%', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (191, 48, '25% of gross income', 0, 'The 25% rate applies to TAXABLE income (after deductions), not gross income', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (192, 48, '20% of taxable income', 0, '20% rate applies only to domestic corporations with net taxable income ≤ PHP 5M and total assets ≤ PHP 100M', 4, 1);

-- Choices for TAX-HARD-008
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (193, 49, 'PHP 5,000,000 (higher of FMV per BIR or Assessor)', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (194, 49, 'PHP 4,000,000 (Assessor''s value)', 0, 'For donor''s tax, the HIGHER of BIR zonal value or Assessor''s value is used', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (195, 49, 'PHP 4,500,000 (average of both values)', 0, 'Tax rules require the HIGHER value, not an average', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (196, 49, 'PHP 4,750,000 (weighted average)', 0, 'No weighted average is used; the higher of the two values applies', 4, 1);

-- Choices for TAX-HARD-009
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (197, 50, 'Subject to 10% final withholding tax of PHP 50,000', 1, NULL, 1, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (198, 50, 'Exempt from income tax as intercorporate dividend', 0, 'Intercorporate dividend exemption under Sec. 27(D)(4) applies only to domestic corporations receiving dividends from another domestic corporation, not to individual taxpayers', 2, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (199, 50, 'Subject to graduated income tax rates as part of gross income', 0, 'Cash dividends from domestic corporations to resident citizens are subject to final tax under Sec. 24(B)(2), not regular income tax', 3, 1);
INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (200, 50, 'Subject to 15% final withholding tax if from a publicly-listed company', 0, 'The 15% rate was eliminated by CREATE Law; dividends from domestic corporations are now uniformly taxed at 10% final tax regardless of listing status', 4, 1);


-- ============================================================================
-- INSERT QUESTION EXPLANATIONS
-- ============================================================================

-- Explanation for AFAR-HARD-001
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (1, 1, 'Bonus method: C''s capital = 25% × Total Capital. Difference from contribution is bonus from old partners.', 'BONUS METHOD - ADMISSION OF A PARTNER

Step 1: Compute Total Agreed Capital
- Old capital: PHP 1,200,000
- C''s contribution: PHP 500,000
- Total capital: PHP 1,700,000

Step 2: Compute C''s Capital Credit (25% interest)
- C''s capital credit = 25% × PHP 1,700,000 = PHP 425,000

Step 3: Compute Bonus
- C''s contribution: PHP 500,000
- C''s capital credit: PHP 425,000
- Bonus TO old partners: PHP 75,000

Step 4: Allocate Bonus to Old Partners (60:40)
- A''s share: PHP 75,000 × 60% = PHP 45,000
- B''s share: PHP 75,000 × 40% = PHP 30,000

JOURNAL ENTRY:
Dr. Cash                        500,000
    Cr. A, Capital                          45,000
    Cr. B, Capital                          30,000
    Cr. C, Capital                         425,000

KEY: C contributes MORE than credited → Bonus to OLD partners
(If C contributed LESS than credited → Bonus FROM old partners to C)
', 'Bonus Method: Total Capital × Interest % = New Partner Capital. Difference = Bonus', 1, 'EXAM');

-- Explanation for AFAR-HARD-002
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (2, 2, 'Deferred taxes follow PAS 12, not fair value measurement. They''re calculated based on temporary differences arising from fair value adjustments.', 'Under PFRS 3 ''Business Combinations'', most identifiable assets and liabilities are measured at FAIR VALUE on the acquisition date. However, there are EXCEPTIONS:

EXCEPTIONS TO FAIR VALUE MEASUREMENT:

1. DEFERRED TAX ASSETS/LIABILITIES (PAS 12)
   - Measured under PAS 12 based on temporary differences
   - Arise from difference between tax base and fair value of assets/liabilities
   - NOT discounted

2. EMPLOYEE BENEFITS (PAS 19)
   - Measured under PAS 19 for defined benefit obligations

3. SHARE-BASED PAYMENT (PFRS 2)
   - Replacement awards measured under PFRS 2

4. ASSETS HELD FOR SALE (PFRS 5)
   - Measured at fair value less costs to sell under PFRS 5

5. INDEMNIFICATION ASSETS
   - Measured consistently with indemnified item

EXAMPLE: Acquiree''s building has:
- Carrying amount: PHP 10M (also tax base)
- Fair value: PHP 15M
- Temporary difference: PHP 5M
- Deferred tax liability: PHP 5M × 25% = PHP 1.25M (not at fair value)
', 'Deferred taxes = PAS 12 measurement, NOT fair value. Calculate from temporary differences.', 1, 'EXAM');

-- Explanation for AFAR-HARD-003
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (3, 3, 'Unrealized profit = Gross Profit Rate × Ending Inventory. Eliminate 100% regardless of ownership.', 'INTERCOMPANY INVENTORY PROFIT ELIMINATION

Step 1: Determine Gross Profit Rate
- Markup on cost: 25%
- If selling price = 125% of cost
- Gross Profit Rate = 25/125 = 20% of selling price

Step 2: Calculate Total Intercompany Sale
- Sales from Sub to Parent: PHP 500,000

Step 3: Calculate Ending Inventory from Intercompany
- 40% remains unsold
- Ending inventory (at transfer price): PHP 500,000 × 40% = PHP 200,000

Step 4: Calculate Unrealized Profit
- Unrealized profit = PHP 200,000 × 20% = PHP 40,000

CONSOLIDATION ENTRY:
Dr. Cost of Goods Sold      40,000
    Cr. Inventory                       40,000

KEY POINTS:
- Eliminate 100% of unrealized profit (not just parent''s share)
- For upstream sale (Sub → Parent), NCI bears their share of elimination
- This is an UPSTREAM sale, so NCI share = 20% × PHP 40,000 = PHP 8,000
', 'Markup on COST = Divide by (1 + markup rate) to get GP rate on selling price', 1, 'EXAM');

-- Explanation for AFAR-HARD-004
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (4, 4, 'Input method: % Complete = Costs Incurred ÷ Total Estimated Costs. Revenue = % × Contract Price.', 'REVENUE RECOGNITION - OVER TIME (PFRS 15)

For performance obligations satisfied over time, revenue is recognized based on progress toward completion.

INPUT METHOD (Cost-to-Cost):

Step 1: Calculate Percentage of Completion
- Costs incurred to date: PHP 3,200,000
- Total estimated costs: PHP 8,000,000
- % Complete = PHP 3,200,000 ÷ PHP 8,000,000 = 40%

Step 2: Calculate Revenue to Recognize
- Contract price: PHP 10,000,000
- Revenue = 40% × PHP 10,000,000 = PHP 4,000,000

Step 3: Calculate Gross Profit
- Revenue: PHP 4,000,000
- Costs: PHP 3,200,000
- Gross Profit: PHP 800,000

VERIFICATION:
- Expected total profit = PHP 10M - PHP 8M = PHP 2M
- Profit recognized (40%) = PHP 800,000 ✓

METHODS TO MEASURE PROGRESS:
1. Input methods: Costs incurred, labor hours, machine hours
2. Output methods: Units produced, contract milestones
', 'Cost-to-Cost Method: Costs Incurred ÷ Total Costs = % Complete → Apply to Contract Price', 1, 'EXAM');

-- Explanation for AFAR-HARD-005
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (5, 5, 'Branch inventory at 125% of cost contains 25% markup. Unrealized profit = Inventory × (Markup ÷ Billed Price Rate).', 'HOME OFFICE AND BRANCH - INTERCOMPANY PROFIT ELIMINATION

When Home Office bills Branch at more than cost, the Branch inventory is OVERSTATED by the unrealized markup.

CALCULATION:

Step 1: Understand the Billing Relationship
- Billed price = 125% of cost
- Therefore: Cost = 100%, Markup = 25%
- Gross Profit Rate on billed price = 25% ÷ 125% = 20%

Step 2: Calculate Unrealized Profit
- Branch ending inventory (at billed price): PHP 250,000
- Unrealized profit = PHP 250,000 × 20% = PHP 50,000

ALTERNATIVE CALCULATION:
- Cost = PHP 250,000 ÷ 1.25 = PHP 200,000
- Unrealized profit = PHP 250,000 - PHP 200,000 = PHP 50,000

ELIMINATION ENTRY (Combined Financial Statements):
Dr. Shipments to Branch (or Allowance for Overvaluation)    50,000
    Cr. Branch Inventory                                            50,000

The "Allowance for Overvaluation of Branch Inventory" is a contra-asset account used to reduce Branch inventory to cost.
', '125% of cost = 20% GP rate on billed price (25/125). Unrealized profit = Inventory × GP rate', 1, 'EXAM');

-- Explanation for AFAR-HARD-006
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (6, 6, 'Loss absorption = Capital balance - Loan payable TO partnership. Right of offset applies.', 'PARTNERSHIP LIQUIDATION - LOSS ABSORPTION CAPACITY

In determining a partner''s ability to absorb losses (for cash distribution purposes), you must consider the RIGHT OF OFFSET:

RIGHT OF OFFSET:
- If partner has a LOAN PAYABLE to partnership → REDUCES capital available
- If partner has a LOAN RECEIVABLE from partnership → INCREASES capital available

PARTNER A''s POSITION:
- Capital balance: PHP 100,000 (credit)
- Loan payable to partnership: PHP 30,000 (partner owes partnership)
- Net capital for loss absorption: PHP 100,000 - PHP 30,000 = PHP 70,000

WHY OFFSET APPLIES:
Under Article 1813 of the Civil Code and partnership law, when a partner owes the partnership:
1. The loan payable is offset against capital
2. Partner cannot receive distributions until loan is settled
3. For insolvent partners, the loan reduces their ability to absorb losses

PRACTICAL APPLICATION:
- Maximum loss A can absorb before capital deficit = PHP 70,000
- If losses exceed PHP 70,000, A will have a capital deficit
- Since A is insolvent, other partners must absorb A''s deficit
', 'Loan PAYABLE to partnership = Deduct from capital. Loan RECEIVABLE = Add to capital.', 1, 'EXAM');

-- Explanation for AFAR-HARD-007
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (7, 7, 'Control requires POWER + VARIABLE RETURNS + LINK. Legal ownership alone is NOT determinative.', 'PFRS 10 DEFINITION OF CONTROL

An investor CONTROLS an investee when it has ALL THREE elements:

1. POWER over the investee
   - Existing rights that give ability to direct RELEVANT ACTIVITIES
   - Relevant activities = activities that significantly affect investee''s returns
   - Can have power through voting rights, contractual arrangements, etc.

2. EXPOSURE OR RIGHTS TO VARIABLE RETURNS
   - Returns that vary based on investee''s performance
   - Can be positive (dividends, synergies) or negative (losses)

3. ABILITY TO USE POWER TO AFFECT RETURNS
   - Link between power and returns
   - Investor uses power to influence its returns

WHY LEGAL OWNERSHIP IS NOT A FACTOR:
- Control is based on SUBSTANCE over form
- An entity can control with less than 50% (e.g., dispersed ownership, contractual rights)
- An entity may NOT control even with more than 50% (e.g., substantive participation rights)
- Potential voting rights, options, and de facto control must be considered

EXAMPLES OF CONTROL WITHOUT MAJORITY:
- Largest shareholder in widely dispersed ownership
- Contractual control through board composition
- Power through options or convertible instruments
', 'Control = Power + Variable Returns + Link. Ownership % is evidence, not conclusive.', 1, 'EXAM');

-- Explanation for AFAR-HARD-008
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (8, 8, 'Equity method: Investment = Cost + Share of Income - Share of Dividends ± Other adjustments.', 'EQUITY METHOD ACCOUNTING (PAS 28)

INITIAL RECOGNITION:
- Investment recorded at COST: PHP 5,000,000
- Note: Cost (5M) = 30% of FV of net assets (4.5M) + Implied goodwill (0.5M)

SUBSEQUENT MEASUREMENT:
- Add: Share of associate''s net income
- Deduct: Share of dividends received
- Add/Deduct: Share of OCI, amortization of excess FV allocations, impairment

CALCULATION:

Beginning investment:                    PHP 5,000,000
Add: Share of net income (30% × 2M):    PHP   600,000
Less: Share of dividends (30% × 500K): (PHP   150,000)
Ending investment:                       PHP 5,450,000

JOURNAL ENTRIES:

Share of net income:
Dr. Investment in Associate      600,000
    Cr. Investment Income                   600,000

Dividends received:
Dr. Cash                         150,000
    Cr. Investment in Associate             150,000

KEY: Dividends REDUCE the investment (not income) because they represent return OF investment, not return ON investment.
', 'Equity method: + Share of Income, - Share of Dividends. Dividends reduce investment, not income!', 1, 'EXAM');

-- Explanation for AUD-HARD-001
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (9, 9, 'Risk Assessment = Entity''s process for identifying and analyzing risks relevant to financial reporting objectives.', 'FIVE COMPONENTS OF INTERNAL CONTROL (PSA 315/COSO)

1. CONTROL ENVIRONMENT
   - Foundation of all other components
   - Integrity, ethical values, governance, management philosophy

2. RISK ASSESSMENT PROCESS ← ANSWER
   - Entity''s process for identifying, analyzing, and managing risks
   - Relevant to preparation of financial statements in accordance with GAAP
   - Includes: Risk identification, risk analysis, risk response

3. INFORMATION SYSTEM (including related business processes)
   - Capture and exchange of information
   - Includes IT systems, journals, ledgers

4. CONTROL ACTIVITIES
   - Policies and procedures ensuring management directives are executed
   - Examples: Authorizations, reconciliations, segregation of duties

5. MONITORING OF CONTROLS
   - Ongoing and separate evaluations
   - Assessing quality of internal control performance over time

AUDITOR''S FOCUS:
Understanding the entity''s risk assessment process helps auditors:
- Identify risks of material misstatement
- Design appropriate audit responses
- Evaluate if management has identified relevant risks
', 'Risk Assessment = How does management identify and address business risks?', 1, 'EXAM');

-- Explanation for AUD-HARD-002
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (10, 10, 'Existence assertion for receivables: External confirmation from debtors provides the most reliable evidence.', 'AUDIT EVIDENCE - RECEIVABLES EXISTENCE

CONFIRMATION is presumptively required for accounts receivable (PSA 505) because:
- It provides EXTERNAL evidence (more reliable than internal)
- It provides DIRECT evidence of existence (debtor acknowledges owing the amount)
- It is INDEPENDENT of the client

TYPES OF CONFIRMATIONS:

POSITIVE CONFIRMATION:
- Requests debtor to respond whether they agree or disagree
- More reliable but lower response rate
- Used when: Individual balances are large, risk is high, negative may be ignored

NEGATIVE CONFIRMATION:
- Requests response ONLY if debtor disagrees
- Less reliable (no response could mean debtor ignored it)
- Used when: Many small balances, low RMM, positive responses expected

HIERARCHY OF EVIDENCE FOR EXISTENCE:
1. External confirmation (BEST)
2. Subsequent cash receipts (good, but internal)
3. Review of invoices/shipping documents (tests occurrence, not existence)
4. Analytical procedures (least direct)

NOTE: For overstatement risk, auditors focus on EXISTENCE (items recorded may not exist)
', 'Existence of receivables? Confirmation is the gold standard - external and direct.', 1, 'EXAM');

-- Explanation for AUD-HARD-003
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (11, 11, 'Unmodified = ''Clean'' opinion. Financial statements present fairly in all material respects.', 'TYPES OF AUDIT OPINIONS (PSA 700, 705)

1. UNMODIFIED OPINION (Clean Opinion)
   - Financial statements are presented fairly in all material respects
   - Prepared in accordance with applicable framework
   - No material misstatements, no scope limitations

2. QUALIFIED OPINION (''Except for'')
   - Misstatements are MATERIAL but NOT PERVASIVE, or
   - Unable to obtain sufficient evidence, but possible effects are material but not pervasive
   - Opinion: "Except for the effects of..."

3. ADVERSE OPINION
   - Misstatements are MATERIAL AND PERVASIVE
   - Financial statements are misleading
   - Opinion: "Do not present fairly..."

4. DISCLAIMER OF OPINION
   - Unable to obtain sufficient appropriate audit evidence
   - Possible effects are MATERIAL AND PERVASIVE
   - Opinion: "We do not express an opinion..."

KEY DECISION FACTORS:
- Is there a misstatement or inability to obtain evidence?
- Is it MATERIAL? (affects users'' decisions)
- Is it PERVASIVE? (affects many elements, substantial portion, fundamental)
', 'Unmodified = All good. Qualified = Material only. Adverse/Disclaimer = Material + Pervasive', 1, 'EXAM');

-- Explanation for AUD-HARD-004
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (12, 12, 'Performance materiality < Overall materiality. This provides a ''cushion'' for undetected/uncorrected misstatements.', 'MATERIALITY CONCEPTS (PSA 320)

1. MATERIALITY FOR FINANCIAL STATEMENTS AS A WHOLE
   - Amount below which misstatements would not be expected to influence users'' decisions
   - Benchmark + percentage (e.g., 5% of profit before tax, 1% of total revenue)

2. PERFORMANCE MATERIALITY
   - Amount set LOWER than overall materiality
   - Applied to particular transactions, account balances, disclosures
   - Purpose: Reduce to appropriately low level the probability that aggregate of uncorrected/undetected misstatements exceeds overall materiality

3. THRESHOLD FOR MISSTATEMENTS TO ACCUMULATE
   - Amount below which misstatements are clearly trivial
   - Misstatements below this need not be accumulated

WHY PERFORMANCE MATERIALITY IS LOWER:
- Auditor may not detect all misstatements
- Provides a buffer/cushion for undetected misstatements
- Accounts for aggregation risk

TYPICAL RANGES:
- Performance materiality: 50-75% of overall materiality
- Trivial threshold: Usually 3-5% of overall materiality
- Higher % when lower RMM, fewer expected misstatements
', 'Performance Materiality = Buffer zone. Always less than overall materiality.', 1, 'EXAM');

-- Explanation for AUD-HARD-005
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (13, 13, 'Auditors obtain REASONABLE ASSURANCE about material misstatement from fraud. Not absolute assurance, not all fraud.', 'AUDITOR''S RESPONSIBILITIES REGARDING FRAUD (PSA 240)

AUDITOR''S RESPONSIBILITY:
- Obtain REASONABLE ASSURANCE that financial statements are free from MATERIAL misstatement, whether due to fraud or error
- Maintain professional skepticism
- Assess risks of material misstatement due to fraud
- Design and perform procedures responsive to assessed risks

MANAGEMENT''S RESPONSIBILITY:
- Prevention and detection of fraud
- Design, implementation, and maintenance of internal control
- Fostering a culture of honesty and ethical behavior

LIMITATIONS OF AN AUDIT:
- Fraud often involves concealment, collusion, forgery
- Management is in a position to override controls
- Auditors cannot obtain ABSOLUTE assurance
- Risk of not detecting material misstatement due to fraud is HIGHER than for error

AUDITOR''S RESPONSE TO SUSPECTED FRAUD:
1. Obtain additional audit evidence
2. Consider implications for other aspects of audit
3. Communicate to management and those charged with governance
4. Consider reporting to regulatory authorities if required
', 'Auditor = Reasonable assurance on MATERIAL fraud. Management = Prevent and detect ALL fraud.', 1, 'EXAM');

-- Explanation for AUD-HARD-006
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (14, 14, 'Fraud involving management must be communicated to those charged with governance (TCWG) on a timely basis.', 'COMMUNICATION WITH THOSE CHARGED WITH GOVERNANCE (PSA 260)

MATTERS TO COMMUNICATE:

1. FRAUD involving management (PSA 240)
   - ANY fraud involving management must be communicated
   - Regardless of amount/materiality
   - On a TIMELY basis

2. SIGNIFICANT DEFICIENCIES in internal control (PSA 265)
   - Deficiencies that merit attention of TCWG
   - In writing, on a timely basis

3. OTHER MATTERS:
   - Auditor''s responsibilities
   - Planned scope and timing of audit
   - Significant findings from the audit
   - Independence issues

WHY TCWG FIRST?
- TCWG have oversight responsibility
- They need to take corrective action
- They may need to investigate further
- Professional standards require this communication

WHEN FRAUD INVOLVES TCWG:
- Consider obtaining legal advice
- Communicate to next higher authority (shareholders, regulators)
- May need to withdraw from engagement
', 'Management fraud → Communicate to TCWG first, regardless of amount', 1, 'EXAM');

-- Explanation for AUD-HARD-007
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (15, 15, 'Subjective estimates, complexity, and susceptibility to manipulation increase inherent risk.', 'INHERENT RISK FACTORS (PSA 315)

Inherent risk is the susceptibility of an assertion to a misstatement that could be material, BEFORE considering related controls.

FACTORS THAT INCREASE INHERENT RISK:

1. COMPLEXITY
   - Complex calculations, transactions, valuations
   - Multiple locations, products, systems

2. SUBJECTIVITY/ESTIMATION
   - Accounting estimates requiring significant judgment
   - Fair value measurements with unobservable inputs
   - Provisions, allowances, impairments

3. SUSCEPTIBILITY TO THEFT/MANIPULATION
   - High-value, easily concealed items
   - Items subject to obsolescence
   - Management incentives to misstate

4. CHANGE
   - New products, systems, or processes
   - Regulatory changes, new standards

5. RELATED PARTY TRANSACTIONS
   - Complex structures, unusual terms

FOR INVENTORY SPECIFICALLY:
- Obsolescence risk
- Valuation at lower of cost and NRV
- Complex costing methods (standard cost, ABC)
- Multiple warehouse locations
- Consignment arrangements
', 'Inherent Risk UP: Complexity, subjectivity, change, susceptibility to manipulation', 1, 'EXAM');

-- Explanation for AUD-HARD-008
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (16, 16, 'Going concern doubt + adequate disclosure = Unmodified opinion + Emphasis of Matter paragraph.', 'GOING CONCERN REPORTING (PSA 570)

SCENARIO MATRIX:

1. MATERIAL UNCERTAINTY EXISTS, ADEQUATE DISCLOSURE
   - Opinion: UNMODIFIED
   - Add: EMPHASIS OF MATTER paragraph
   - Heading: "Material Uncertainty Related to Going Concern"
   - Draw attention to disclosure in notes

2. MATERIAL UNCERTAINTY EXISTS, INADEQUATE DISCLOSURE
   - Opinion: QUALIFIED or ADVERSE (depending on severity)
   - Reason: Inadequate disclosure is a departure from framework

3. USE OF GOING CONCERN BASIS NOT APPROPRIATE
   - Opinion: ADVERSE
   - Management preparing going concern FS when liquidation is certain

4. MANAGEMENT UNWILLING TO MAKE ASSESSMENT
   - Consider: Qualified or disclaimer for scope limitation

EMPHASIS OF MATTER REQUIREMENTS:
- Placed immediately after the Opinion section
- Heading: "Material Uncertainty Related to Going Concern"
- Reference to the note disclosure
- Statement that "our opinion is not modified in respect of this matter"

KEY: Emphasis of Matter draws attention but does NOT modify the opinion. It is for significant matters that are properly disclosed.
', 'Going concern + Adequate disclosure = Emphasis of Matter (opinion NOT modified)', 1, 'EXAM');

-- Explanation for FAR-HARD-001
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (17, 17, 'Functional currency changes are applied prospectively - translate everything at the new rate from the date of change.', 'Under PAS 21 ''The Effects of Changes in Foreign Exchange Rates'', when an entity changes its functional currency:

1. The entity translates ALL items into the new functional currency using the exchange rate at the date of change
2. The resulting translated amounts for non-monetary items are treated as their historical cost
3. The change is applied PROSPECTIVELY from the date of change
4. No retrospective restatement is required

This is similar to an accounting policy change that cannot be applied retrospectively due to impracticability.

EXAMPLE: If a Philippine subsidiary changes functional currency from USD to PHP on January 1, 2025, all assets and liabilities are translated at the January 1, 2025 rate. PPE translated at PHP 56 per dollar becomes the new ''historical cost'' in PHP.
', 'Functional currency change = PROSPECTIVE application (like impracticable accounting policy change)', 1, 'EXAM');

-- Explanation for FAR-HARD-002
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (18, 18, 'Amortized cost to FVOCI reclassification: measure at fair value, recognize difference in OCI.', 'Under PFRS 9 ''Financial Instruments'', when reclassifying from amortized cost to FVOCI (debt):

RECLASSIFICATION TREATMENT:
1. Measure the financial asset at FAIR VALUE at the reclassification date
2. Recognize the difference between amortized cost and fair value in OTHER COMPREHENSIVE INCOME
3. The effective interest rate is NOT adjusted - continue using the original EIR
4. Continue recognizing interest revenue in profit or loss

WHY OCI? The OCI treatment is consistent with the FVOCI business model where:
- Interest revenue goes to P&L (using EIR method)
- Fair value changes go to OCI
- Upon disposal, OCI is recycled to P&L

CONTRAST: If reclassifying TO amortized cost (from FVOCI), the cumulative OCI is removed and adjusts the carrying amount.
', 'Amortized Cost → FVOCI = Fair value difference to OCI (consistent with FVOCI model)', 1, 'EXAM');

-- Explanation for FAR-HARD-003
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (19, 19, 'Revaluation surplus = Fair Value minus Carrying Amount. Don''t forget to deduct accumulated depreciation first!', 'CALCULATION OF REVALUATION SURPLUS:

Step 1: Calculate Carrying Amount at December 31, 2024
- Original cost: PHP 10,000,000
- Annual depreciation: PHP 10,000,000 ÷ 20 years = PHP 500,000
- Accumulated depreciation (2 years): PHP 500,000 × 2 = PHP 1,000,000
- Carrying amount: PHP 10,000,000 - PHP 1,000,000 = PHP 9,000,000

Step 2: Calculate Revaluation Surplus
- Fair value: PHP 11,500,000
- Carrying amount: PHP 9,000,000
- Revaluation surplus: PHP 11,500,000 - PHP 9,000,000 = PHP 2,500,000

JOURNAL ENTRY:
Dr. Building                    2,500,000
Dr. Accumulated Depreciation    1,000,000
    Cr. Building (gross up)                 1,000,000
    Cr. Revaluation Surplus (OCI)           2,500,000

The revaluation surplus is recognized in OTHER COMPREHENSIVE INCOME and accumulated in equity.
', 'Revaluation Surplus = FV - Carrying Amount (remember to deduct accumulated depreciation!)', 1, 'EXAM');

-- Explanation for FAR-HARD-004
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (20, 20, 'Provision recognition requires: (1) Present obligation, (2) Probable outflow, (3) Reliable estimate. All three!', 'Under PAS 37 ''Provisions, Contingent Liabilities and Contingent Assets'', a provision is recognized when ALL THREE conditions are met:

1. PRESENT OBLIGATION (legal or constructive) from a PAST EVENT
   - Legal obligation: from contract, legislation, or other operation of law
   - Constructive obligation: from entity''s actions creating valid expectations

2. PROBABLE outflow of resources embodying economic benefits
   - ''Probable'' = more likely than not (>50%)
   - If only ''possible'' = disclose as contingent liability (no recognition)

3. RELIABLE ESTIMATE of the amount
   - Best estimate of expenditure required to settle
   - Can use expected value or most likely outcome
   - Only in extremely rare cases is estimate not possible

IF ANY CONDITION IS NOT MET:
- If not probable → disclose as contingent liability
- If remote → no disclosure required
- If no reliable estimate → disclose as contingent liability
', 'Provision = Present + Probable + Estimable (all three required)', 1, 'EXAM');

-- Explanation for FAR-HARD-005
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (21, 21, 'No significant increase in credit risk = Stage 1 = 12-month ECL only.', 'Under PFRS 9''s Expected Credit Loss (ECL) impairment model, there are THREE STAGES:

STAGE 1: Credit risk has NOT significantly increased since initial recognition
- Recognize: 12-MONTH ECL
- Interest revenue: On gross carrying amount
- This is the default stage at initial recognition

STAGE 2: Credit risk has SIGNIFICANTLY INCREASED (but not credit-impaired)
- Recognize: LIFETIME ECL
- Interest revenue: On gross carrying amount

STAGE 3: Credit-impaired (objective evidence of impairment)
- Recognize: LIFETIME ECL
- Interest revenue: On NET carrying amount (after loss allowance)

IN THIS CASE:
- Credit risk has NOT significantly increased → STAGE 1
- Therefore: Recognize 12-month ECL of PHP 50,000

KEY CONCEPT: The shift from 12-month to lifetime ECL is triggered by SIGNIFICANT INCREASE in credit risk, not by the existence of higher lifetime ECL.
', 'Stage 1 (no significant increase) = 12-month ECL; Stage 2/3 (significant increase) = Lifetime ECL', 1, 'EXAM');

-- Explanation for FAR-HARD-006
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (22, 22, 'Significant financing component = Adjust transaction price for time value of money. Interest is recognized separately.', 'Under PFRS 15 ''Revenue from Contracts with Customers'', when a contract contains a SIGNIFICANT FINANCING COMPONENT:

TREATMENT:
1. Adjust the transaction price for the TIME VALUE OF MONEY
2. Use a discount rate that would be reflected in a separate financing transaction
3. Recognize INTEREST separately from revenue over the financing period

PRACTICAL EXPEDIENT (PFRS 15.63):
Entity need NOT adjust for financing component if payment timing is ≤1 year from transfer of goods/services

EXAMPLE: 
- Customer pays PHP 1,210,000 in 2 years for goods delivered today
- Cash selling price: PHP 1,000,000
- Implicit interest rate: 10% per year

Recognition:
- Day 1: Revenue = PHP 1,000,000
- Year 1: Interest income = PHP 100,000
- Year 2: Interest income = PHP 110,000

INDICATORS of significant financing:
- Significant difference between promised consideration and cash price
- Extended payment terms
- Interest rate in contract
', 'Financing component? Adjust to cash price + recognize interest separately', 1, 'EXAM');

-- Explanation for FAR-HARD-007
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (23, 23, 'Defined benefit expense in P&L = Service Cost + Net Interest. Remeasurements go to OCI.', 'Under PAS 19 ''Employee Benefits'', the defined benefit cost is split into THREE COMPONENTS:

PROFIT OR LOSS (recognized in P&L):
1. SERVICE COST
   - Current service cost (benefits earned this period)
   - Past service cost (plan amendments/curtailments)
   - Gain/loss on settlement
2. NET INTEREST on net defined benefit liability/asset
   - = Net DB liability × Discount rate at start of period

OTHER COMPREHENSIVE INCOME (OCI):
3. REMEASUREMENTS
   - Actuarial gains and losses (experience adjustments, assumption changes)
   - Return on plan assets (excluding interest income already in P&L)

IN THIS CASE:
- Service cost: PHP 800,000 → P&L
- Net interest: PHP 500,000 → P&L
- Total P&L expense: PHP 800,000 + PHP 500,000 = PHP 1,300,000

Note: Remeasurements are recognized in OCI and are NOT reclassified to P&L in subsequent periods.
', 'Pension P&L = Service Cost + Net Interest. Remeasurements = OCI only (never recycled)', 1, 'EXAM');

-- Explanation for FAR-HARD-008
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (24, 24, 'Corporate assets: Allocate to CGUs if possible, otherwise test at the smallest group of CGUs to which they can be allocated.', 'Under PAS 36 ''Impairment of Assets'', CORPORATE ASSETS present a special challenge because they:
- Do not generate independent cash inflows
- Service multiple CGUs
- Cannot be tested for impairment individually

TREATMENT OF CORPORATE ASSETS:

STEP 1: Try to ALLOCATE on reasonable and consistent basis
- Allocate carrying amount to individual CGUs
- Include allocated amount in CGU impairment test
- Allocation basis must be reasonable (e.g., floor space, headcount)

STEP 2: If allocation is NOT POSSIBLE
- Identify the SMALLEST GROUP OF CGUs to which corporate assets can be allocated
- Test impairment at that group level
- Compare carrying amount (including corporate assets) to recoverable amount

EXAMPLE: Head office building serving all divisions
- Cannot allocate? Test impairment at entity level (all CGUs combined)
- Impairment loss allocated to CGUs, then to assets within CGUs

ALLOCATION OF IMPAIRMENT LOSS:
1. First to goodwill (if any)
2. Then to other assets pro-rata based on carrying amounts
', 'Corporate assets: Allocate if possible → If not, test at smallest group of CGUs', 1, 'EXAM');

-- Explanation for FAR-HARD-009
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (25, 25, 'Lease liability = PV of lease payments. Use implicit rate if determinable, otherwise use lessee''s incremental borrowing rate.', 'Under PFRS 16 ''Leases'', the LEASE LIABILITY is measured at the PRESENT VALUE of lease payments not yet paid.

DISCOUNT RATE TO USE:
1. FIRST CHOICE: Interest rate implicit in the lease
   - Rate that causes PV of lease payments + unguaranteed residual = Fair value of asset + Initial direct costs of lessor
2. IF NOT READILY DETERMINABLE: Lessee''s incremental borrowing rate
   - Rate the lessee would pay to borrow funds to obtain an asset of similar value in a similar economic environment

LEASE PAYMENTS INCLUDE:
- Fixed payments (less any lease incentives receivable)
- Variable payments based on an index or rate
- Residual value guarantees (amounts expected to be payable)
- Exercise price of purchase option (if reasonably certain)
- Termination penalties (if lease term reflects termination)

CALCULATION:
- Annual payment: PHP 1,000,000
- Discount rate: 8% (incremental borrowing rate since implicit rate not determinable)
- Lease liability = PHP 1,000,000 × PV annuity factor (5 years, 8%)
- = PHP 1,000,000 × 3.9927 = PHP 3,992,700
', 'Lease liability discount rate: Implicit rate first → If not, use incremental borrowing rate', 1, 'EXAM');

-- Explanation for MS-HARD-001
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (26, 26, 'Materials price variance = (SP - AP) x AQ = PHP 21,000 F. Materials quantity variance = (SQ - AQ) x SP = PHP 25,000 U. Net = PHP 4,000 U.', 'DIRECT MATERIALS VARIANCE ANALYSIS:

1. MATERIALS PRICE VARIANCE (MPV):
   Formula: (Standard Price - Actual Price) x Actual Quantity
   = (PHP 50 - PHP 48) x 10,500 kg
   = PHP 2 x 10,500
   = PHP 21,000 FAVORABLE
   (Favorable because we paid less than standard)

2. MATERIALS QUANTITY VARIANCE (MQV):
   Formula: (Standard Quantity - Actual Quantity) x Standard Price
   = (10,000 - 10,500) x PHP 50
   = (500) x PHP 50
   = PHP 25,000 UNFAVORABLE
   (Unfavorable because we used more than standard)

3. TOTAL MATERIALS VARIANCE:
   = MPV + MQV
   = PHP 21,000 F + PHP 25,000 U
   = PHP 4,000 UNFAVORABLE

VERIFICATION (Alternative calculation):
Total Actual Cost = 10,500 x PHP 48 = PHP 504,000
Total Standard Cost = 10,000 x PHP 50 = PHP 500,000
Total Variance = PHP 504,000 - PHP 500,000 = PHP 4,000 U
', 'Price variance uses ACTUAL quantity; Quantity variance uses STANDARD price. F if saved, U if exceeded.', 1, 'EXAM');

-- Explanation for MS-HARD-002
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (27, 27, 'PI = PV of Cash Inflows / Initial Investment = (PHP 600,000 x 3.6048) / PHP 2,000,000 = 1.08. Since PI > 1, accept.', 'PROFITABILITY INDEX (PI) ANALYSIS:

The Profitability Index measures the present value of future cash flows per peso of initial investment.

FORMULA: PI = Present Value of Cash Inflows / Initial Investment

STEP 1: Calculate PV of Cash Inflows
Annual Cash Inflow x PV Annuity Factor
= PHP 600,000 x 3.6048
= PHP 2,162,880

STEP 2: Calculate Profitability Index
PI = PHP 2,162,880 / PHP 2,000,000
PI = 1.0814 or approximately 1.08

DECISION RULE:
- If PI > 1: Accept (PV of benefits exceeds cost)
- If PI < 1: Reject (Cost exceeds PV of benefits)
- If PI = 1: Indifferent (NPV = 0)

Since PI = 1.08 > 1, the project should be ACCEPTED.

VERIFICATION using NPV:
NPV = PV of Inflows - Initial Investment
NPV = PHP 2,162,880 - PHP 2,000,000 = PHP 162,880
Positive NPV confirms acceptance decision.
', 'PI > 1 means ACCEPT (every peso invested returns more than a peso in PV terms)', 1, 'EXAM');

-- Explanation for MS-HARD-003
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (28, 28, 'Weighted-average CM = (PHP 35 x 60%) + (PHP 60 x 40%) = PHP 45. BEP = PHP 180,000 / PHP 45 = 4,000 units in 60:40 ratio.', 'MULTI-PRODUCT BREAK-EVEN ANALYSIS:

STEP 1: Calculate Contribution Margin per unit
Product A: PHP 100 - PHP 65 = PHP 35 CM
Product B: PHP 150 - PHP 90 = PHP 60 CM

STEP 2: Determine Sales Mix
Total units = 3,000 + 2,000 = 5,000 units
Product A: 3,000 / 5,000 = 60%
Product B: 2,000 / 5,000 = 40%

STEP 3: Calculate Weighted-Average Contribution Margin
WACM = (CM_A x Mix_A) + (CM_B x Mix_B)
WACM = (PHP 35 x 0.60) + (PHP 60 x 0.40)
WACM = PHP 21 + PHP 24
WACM = PHP 45 per unit

STEP 4: Calculate Break-Even Point in Total Units
BEP (units) = Fixed Costs / WACM
BEP = PHP 180,000 / PHP 45
BEP = 4,000 units

STEP 5: Allocate to Individual Products (using sales mix)
Product A: 4,000 x 60% = 2,400 units
Product B: 4,000 x 40% = 1,600 units

VERIFICATION:
CM from A: 2,400 x PHP 35 = PHP 84,000
CM from B: 1,600 x PHP 60 = PHP 96,000
Total CM = PHP 180,000 = Fixed Costs ✓ (Break-even confirmed)
', 'Multi-product BEP: Weight the CM by each product''s SALES MIX percentage, not simple average', 1, 'EXAM');

-- Explanation for MS-HARD-004
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (29, 29, 'ABC allocates PHP 90,000 to X (30/80 setups). Traditional allocates PHP 48,000 to X (2,000/10,000 DLH). Difference = PHP 42,000 less under traditional.', 'COMPARISON OF ABC VS. TRADITIONAL COSTING:

ACTIVITY-BASED COSTING (ABC):
Cost Driver: Number of Setups
Setup Cost Rate = PHP 240,000 / 80 setups = PHP 3,000 per setup

Product X allocation:
30 setups x PHP 3,000 = PHP 90,000

Product Y allocation:
50 setups x PHP 3,000 = PHP 150,000

TRADITIONAL COSTING:
Cost Driver: Direct Labor Hours
Total DLH = 2,000 + 8,000 = 10,000 DLH
OH Rate = PHP 240,000 / 10,000 DLH = PHP 24 per DLH

Product X allocation:
2,000 DLH x PHP 24 = PHP 48,000

Product Y allocation:
8,000 DLH x PHP 24 = PHP 192,000

DIFFERENCE FOR PRODUCT X:
ABC allocation: PHP 90,000
Traditional allocation: PHP 48,000
Difference: PHP 90,000 - PHP 48,000 = PHP 42,000

Product X receives PHP 42,000 LESS under traditional costing.

INSIGHT: Product X is a low-volume product requiring proportionally more setups (30/80 = 37.5%) relative to its DLH usage (2,000/10,000 = 20%). ABC correctly captures this complexity; traditional costing under-costs Product X and over-costs Product Y.
', 'ABC reveals TRUE cost of complexity. Low-volume products with high setup needs are UNDER-costed by traditional methods.', 1, 'EXAM');

-- Explanation for MS-HARD-005
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (30, 30, 'Variable cost = (PHP 380,000 - PHP 230,000)/(8,000 - 3,000) = PHP 30/MH. Fixed = PHP 140,000. At 6,000 MH: PHP 140,000 + (6,000 x PHP 30) = PHP 320,000.', 'HIGH-LOW METHOD FOR COST ESTIMATION:

The high-low method uses the highest and lowest activity levels to separate mixed costs into fixed and variable components.

GIVEN DATA:
High point: 8,000 MH, PHP 380,000
Low point: 3,000 MH, PHP 230,000

STEP 1: Calculate Variable Cost per Machine Hour
Variable Cost Rate = (High Cost - Low Cost) / (High Activity - Low Activity)
= (PHP 380,000 - PHP 230,000) / (8,000 - 3,000)
= PHP 150,000 / 5,000 MH
= PHP 30 per machine hour

STEP 2: Calculate Fixed Cost
Using the high point (or low point - same result):
Total Cost = Fixed Cost + (Variable Rate x Activity)
PHP 380,000 = Fixed Cost + (PHP 30 x 8,000)
PHP 380,000 = Fixed Cost + PHP 240,000
Fixed Cost = PHP 140,000

Verification with low point:
PHP 230,000 = PHP 140,000 + (PHP 30 x 3,000)
PHP 230,000 = PHP 140,000 + PHP 90,000 ✓

STEP 3: Estimate Cost at 6,000 Machine Hours
Total Cost = Fixed Cost + (Variable Rate x Activity)
= PHP 140,000 + (PHP 30 x 6,000)
= PHP 140,000 + PHP 180,000
= PHP 320,000
', 'High-Low: Variable rate = Rise/Run (cost change ÷ activity change), then solve for fixed cost', 1, 'EXAM');

-- Explanation for MS-HARD-006
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (31, 31, 'Relevant make cost = PHP 50 variable + PHP 12 avoidable FC = PHP 62/unit. Buy cost = PHP 55 but PHP 8 FC continues. Net: Make saves PHP 1/unit x 10,000 = PHP 10,000.', 'MAKE OR BUY DECISION - RELEVANT COST ANALYSIS:

STEP 1: Identify Relevant Costs (costs that differ between alternatives)

MAKE INTERNALLY - Relevant Costs:
Direct materials: PHP 25
Direct labor: PHP 15
Variable overhead: PHP 10
Avoidable fixed overhead: PHP 20 x 60% = PHP 12
Total relevant cost to MAKE: PHP 62 per unit

BUY EXTERNALLY - Relevant Costs:
Purchase price: PHP 55 per unit
(Unavoidable fixed overhead PHP 8 continues but is irrelevant - same under both options)

STEP 2: Compare Per-Unit Costs
Make: PHP 62 per unit
Buy: PHP 55 per unit

Appears buy is cheaper by PHP 7, BUT we must consider the unavoidable fixed cost!

CORRECT ANALYSIS - Total Relevant Costs:
MAKE: (PHP 62 x 10,000) = PHP 620,000
BUY: (PHP 55 x 10,000) + (PHP 8 x 10,000 unavoidable FC) = PHP 550,000 + PHP 80,000 = PHP 630,000

STEP 3: Decision
Make: PHP 620,000
Buy: PHP 630,000
Savings from making: PHP 10,000

DECISION: MAKE INTERNALLY - saves PHP 10,000 annually
', 'Make or Buy: Only AVOIDABLE costs are relevant. Unavoidable fixed costs continue regardless of decision.', 1, 'EXAM');

-- Explanation for MS-HARD-007
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (32, 32, 'DOL = Contribution Margin / Operating Income = PHP 2,000,000 / PHP 500,000 = 4.0. A 20% sales increase yields 20% x 4.0 = 80% profit increase.', 'OPERATING LEVERAGE ANALYSIS:

CURRENT SITUATION:
Sales: PHP 5,000,000
Variable Costs: PHP 3,000,000
Contribution Margin: PHP 5,000,000 - PHP 3,000,000 = PHP 2,000,000
Fixed Costs: PHP 1,500,000
Operating Income: PHP 2,000,000 - PHP 1,500,000 = PHP 500,000

DEGREE OF OPERATING LEVERAGE (DOL):
Formula: DOL = Contribution Margin / Operating Income
DOL = PHP 2,000,000 / PHP 500,000
DOL = 4.0

INTERPRETATION:
Operating leverage of 4.0 means that for every 1% change in sales, operating income changes by 4%.

PROJECTED INCREASE:
Sales increase: 20%
Operating income increase: 20% x 4.0 = 80%

VERIFICATION:
New Sales: PHP 5,000,000 x 1.20 = PHP 6,000,000
New Variable Costs: PHP 3,000,000 x 1.20 = PHP 3,600,000 (60% of sales)
New Contribution Margin: PHP 6,000,000 - PHP 3,600,000 = PHP 2,400,000
Fixed Costs (unchanged): PHP 1,500,000
New Operating Income: PHP 2,400,000 - PHP 1,500,000 = PHP 900,000

Percentage increase: (PHP 900,000 - PHP 500,000) / PHP 500,000 = 80% ✓
', 'Operating Leverage = CM/OI. High leverage = high risk/reward. Profit magnifies both ways!', 1, 'EXAM');

-- Explanation for MS-HARD-008
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (33, 33, 'Operating savings: PHP 250,000. Net equipment cost: PHP 200,000. Net advantage to replace: PHP 50,000. Book value is sunk and irrelevant.', 'EQUIPMENT REPLACEMENT DECISION - RELEVANT COST ANALYSIS:

IRRELEVANT COST (Sunk Cost):
Book value of old equipment: PHP 100,000 - This is SUNK and IRRELEVANT
The loss on disposal is an accounting loss, not a relevant cash flow.

RELEVANT CASH FLOWS:

COST OF REPLACEMENT:
Purchase price of new equipment: PHP 300,000
Less: Proceeds from selling old equipment: (PHP 50,000)
Less: Salvage value of new equipment (end of Year 5): (PHP 50,000)
Net cost of replacement: PHP 200,000

BENEFITS OF REPLACEMENT:
Annual operating cost savings: PHP 80,000 - PHP 30,000 = PHP 50,000/year
Total savings over 5 years: PHP 50,000 x 5 = PHP 250,000

NET ADVANTAGE TO REPLACE:
Benefits: PHP 250,000
Costs: PHP 200,000
Net advantage: PHP 50,000

ALTERNATIVE PRESENTATION:
Keep Old (5-year costs):
- Operating costs: PHP 80,000 x 5 = PHP 400,000
- Foregone sale proceeds: PHP 50,000
Total: PHP 450,000

Replace (5-year costs):
- New equipment: PHP 300,000
- Operating costs: PHP 30,000 x 5 = PHP 150,000
- Less salvage: (PHP 50,000)
Total: PHP 400,000

Savings from replacing: PHP 450,000 - PHP 400,000 = PHP 50,000

DECISION: REPLACE - saves PHP 50,000 over equipment life
', 'Book value is SUNK and irrelevant. Focus on: (1) operating savings, (2) net investment, (3) salvage values.', 1, 'EXAM');

-- Explanation for RFBT-HARD-001
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (34, 34, 'Under Article 1506 of the Civil Code, when a buyer (Y) is in possession with seller''s consent and sells to an innocent purchaser for value (Z), Z acquires good title.', 'DOCTRINE OF SELLER IN POSSESSION (Article 1506, Civil Code):

When goods are sold by a person who is not the owner thereof but who is:
(1) In possession of the goods, and
(2) Selling with the consent of the owner (as in conditional sale)

The buyer receives valid title IF the buyer:
(1) Acted in good faith (innocent purchaser)
(2) Paid value for the goods
(3) Had no notice of the seller''s lack of authority

APPLICATION TO THE CASE:
- X delivered goods to Y (Y is in possession with X''s consent)
- Y sold to Z before full payment (Y acting as seller in possession)
- Z is an innocent purchaser for value
- Z acquires VALID and ABSOLUTE ownership

X''s remedy is limited to pursuing Y for the unpaid balance. X cannot recover the goods from Z.

This doctrine protects commercial transactions and the reliability of possession as evidence of ownership.

RELATED PRINCIPLE: Nemo dat quod non habet (no one can give what they don''t have) is EXCEPTED when the seller is in possession with the owner''s consent.
', 'Innocent purchaser + Seller in possession with owner''s consent = VALID title passes (Art. 1506)', 1, 'EXAM');

-- Explanation for RFBT-HARD-002
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (35, 35, 'Bearer instruments are negotiated by delivery alone. A holder in due course takes free of personal defenses, including theft from a prior holder.', 'NEGOTIABLE INSTRUMENTS LAW - HOLDER IN DUE COURSE AND BEARER INSTRUMENTS:

KEY PRINCIPLES:

1. BEARER INSTRUMENT (Sec. 9, NIL):
   An instrument payable "to bearer" or "to P or bearer" is a bearer instrument.
   Negotiation: By mere delivery (Sec. 30)

2. HOLDER IN DUE COURSE (Sec. 52, NIL):
   Takes the instrument:
   - Complete and regular on its face
   - Before overdue
   - In good faith and for value
   - Without notice of defect

3. RIGHTS OF HDC (Sec. 57, NIL):
   Holds the instrument FREE from:
   - Defects of title of prior parties
   - Personal defenses available to prior parties

4. REAL VS. PERSONAL DEFENSES:
   REAL DEFENSES (available against HDC):
   - Forgery, material alteration, minority, incapacity, illegality, fraud in factum

   PERSONAL DEFENSES (NOT available against HDC):
   - Theft, fraud in inducement, duress, breach of contract, lack/failure of consideration

APPLICATION:
- The note is a BEARER instrument ("to P or bearer")
- T negotiated by delivery to H
- H is an HDC
- Theft is a PERSONAL defense
- H takes FREE of P''s claim

P cannot recover from H. P''s remedy is against T.
', 'Bearer = delivery negotiates. HDC beats personal defenses (including THEFT). Only REAL defenses prevail against HDC.', 1, 'EXAM');

-- Explanation for RFBT-HARD-003
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (36, 36, 'A can recover C''s share (PHP 100,000) plus C''s proportionate share of B''s insolvency (PHP 50,000). A absorbs his own share plus half of B''s.', 'SOLIDARY OBLIGATIONS - REIMBURSEMENT WITH INSOLVENCY (Article 1217, Civil Code):

RULE: When a solidary debtor pays the entire obligation, they may seek reimbursement from co-debtors for their respective shares. If a co-debtor is INSOLVENT, the share of the insolvent shall be borne by ALL those who are solvent, including the debtor who paid, in proportion to their shares.

GIVEN:
- Total obligation: PHP 300,000
- Solidary debtors: A, B, C (equal shares assumed)
- A paid entire PHP 300,000
- B is insolvent

CALCULATION:

Step 1: Determine individual shares
A''s share: PHP 100,000
B''s share: PHP 100,000 (insolvent)
C''s share: PHP 100,000

Step 2: Allocate insolvent''s share
B''s PHP 100,000 is divided between A and C proportionately:
A absorbs: PHP 50,000
C absorbs: PHP 50,000

Step 3: Final amounts borne by each
A: PHP 100,000 (own share) + PHP 50,000 (half of B''s) = PHP 150,000
C: PHP 100,000 (own share) + PHP 50,000 (half of B''s) = PHP 150,000
Total: PHP 300,000 ✓

Step 4: Amount A can recover from C
A paid: PHP 300,000
A should bear: PHP 150,000
A can recover from C: PHP 150,000
', 'Insolvent co-debtor''s share = split among ALL solvent debtors (including the one who paid) proportionately', 1, 'EXAM');

-- Explanation for RFBT-HARD-004
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (37, 37, 'Stock dividends: 10% of 60,000 = 6,000 new shares. RE decreases PHP 600,000, capital stock increases PHP 600,000. Total equity unchanged.', 'STOCK DIVIDENDS UNDER CORPORATION CODE AND SEC RULES:

EFFECT OF STOCK DIVIDENDS:
Stock dividends are distributions of additional shares to existing stockholders. They result in:
1. Transfer from Retained Earnings to Capital Stock
2. NO change in Total Stockholders'' Equity
3. NO distribution of corporate assets

CALCULATION:

Before Stock Dividend:
- Issued shares: 60,000
- Par value: PHP 100
- Capital Stock: PHP 6,000,000
- Unrestricted RE: PHP 800,000

Stock Dividend Declaration:
- Rate: 10%
- New shares: 60,000 x 10% = 6,000 shares
- Amount transferred: 6,000 x PHP 100 = PHP 600,000

After Stock Dividend:
- Issued shares: 66,000 (60,000 + 6,000)
- Capital Stock: PHP 6,600,000 (+PHP 600,000)
- Unrestricted RE: PHP 200,000 (-PHP 600,000)
- Total SE: UNCHANGED

LEGAL REQUIREMENTS (Sec. 42, RCC):
1. Approval by board of directors
2. Approval by 2/3 of outstanding capital stock
3. Sufficient unrestricted retained earnings (PHP 800,000 > PHP 600,000 ✓)
4. Sufficient unissued authorized shares (40,000 > 6,000 ✓)
', 'Stock dividends = equity RECLASSIFICATION only. Total SE stays same. Check: sufficient RE AND authorized but unissued shares.', 1, 'EXAM');

-- Explanation for RFBT-HARD-005
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (38, 38, 'A forged indorsement breaks the chain of title. All subsequent parties (C, D, E, collecting bank) are liable. Drawee bank can recover from collecting bank.', 'FORGED INDORSEMENT - LIABILITY CHAIN (NIL):

RULE: A forged indorsement is wholly inoperative. No right to enforce the instrument can be acquired through a forged indorsement.

CHAIN OF EVENTS:
1. A draws check to B
2. B indorses to C (FORGED - B''s signature is forged)
3. C indorses in blank
4. D finds check, transfers to E
5. E deposits in collecting bank
6. Collecting bank collects from drawee bank

ANALYSIS:

Since B''s indorsement was forged:
- C acquired no title (took under forged indorsement)
- D acquired no title
- E acquired no title
- Collecting bank acquired no title
- Drawee bank paid on invalid instrument

LIABILITY:
1. DRAWEE BANK: Liable to drawer A for paying without proper indorsement
   (but can recover from collecting bank)

2. COLLECTING BANK: Liable to drawee bank on warranty that all prior
   indorsements are genuine

3. E: Liable to collecting bank on same warranty

4. D: Liable to E on warranty

5. C: Liable to D on warranty

The loss ultimately falls on the party who dealt with the forger or earliest party after forgery who cannot pass liability further up.

B (true owner) can recover from any party in the chain.
', 'Forged INDORSEMENT = all parties after forgery liable. Contrast: Forged DRAWER signature = drawee bank bears loss.', 1, 'EXAM');

-- Explanation for RFBT-HARD-006
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (39, 39, 'Sale of leased property does not terminate the lease. The buyer steps into the lessor''s shoes. Y continues the lease but pays Z going forward.', 'SALE OF LEASED PROPERTY (Articles 1676-1678, Civil Code):

GENERAL RULE: The purchaser of leased property must respect the lease if:
1. The lease is recorded in the Registry of Property, OR
2. The purchaser knew of the existence of the lease at the time of sale

Even if neither condition exists, the lessee has rights:
- If lease has a fixed period: Buyer must allow lessee to continue for the remainder of the term
- Buyer assumes all rights and obligations of the original lessor

APPLICATION:

1. Y''s RIGHT TO CONTINUE LEASE:
   Y has a valid lease contract for 5 years. Z as buyer must respect this lease.
   Y can continue occupying the property until lease expiry (3 more years).

2. RENT PAYMENT:
   - Payments made to X (old owner) BEFORE notice of sale: Valid, discharged Y''s obligation
   - Payments AFTER proper notice of sale: Must be made to Z
   - Z should notify Y of the sale and demand future payments

3. Y''s PROTECTION:
   Y is not required to vacate. Z''s remedy for unpaid rent (after notice) is to demand payment, not eviction (during lease term).

4. DOCTRINE: "Emptio non tollit locatum" - Sale does not extinguish lease.
', 'Buyer of leased property = new lessor. Lease continues. Rent goes to new owner AFTER notice.', 1, 'EXAM');

-- Explanation for RFBT-HARD-007
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (40, 40, 'New total capital = PHP 800,000. D''s 20% = PHP 160,000. Bonus to old partners = PHP 200,000 - PHP 160,000 = PHP 40,000.', 'PARTNERSHIP ADMISSION - BONUS METHOD:

GIVEN DATA:
Old partnership:
- Assets: PHP 1,000,000
- Liabilities: PHP 400,000
- Partners'' Capital: PHP 600,000 (A: 240,000, B: 210,000, C: 150,000)

Admission:
- D contributes: PHP 200,000 cash
- D''s interest: 20%

BONUS METHOD CALCULATION:

Step 1: Calculate New Total Partnership Capital
Old capital: PHP 600,000
D''s contribution: PHP 200,000
New total capital: PHP 800,000

Step 2: Calculate D''s Capital Credit
D''s interest: 20%
D''s capital credit: PHP 800,000 x 20% = PHP 160,000

Step 3: Calculate Bonus
D contributed: PHP 200,000
D''s capital credit: PHP 160,000
Bonus TO old partners: PHP 40,000

Step 4: Allocate Bonus to Old Partners (by profit ratio)
A (40%): PHP 40,000 x 40% = PHP 16,000
B (35%): PHP 40,000 x 35% = PHP 14,000
C (25%): PHP 40,000 x 25% = PHP 10,000
Total: PHP 40,000 ✓

FINAL CAPITAL BALANCES:
A: PHP 240,000 + PHP 16,000 = PHP 256,000
B: PHP 210,000 + PHP 14,000 = PHP 224,000
C: PHP 150,000 + PHP 10,000 = PHP 160,000
D: PHP 160,000
Total: PHP 800,000 ✓

JOURNAL ENTRY:
Cash                   200,000
    D, Capital                     160,000
    A, Capital                      16,000
    B, Capital                      14,000
    C, Capital                      10,000
', 'Bonus Method: Capital credit = % interest x NEW total capital. Compare to contribution to find bonus direction.', 1, 'EXAM');

-- Explanation for RFBT-HARD-008
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (41, 41, 'Stockholder of record on record date (December 15) receives dividend. B owned shares on that date. Liability arose on declaration date.', 'CASH DIVIDEND - KEY DATES AND CONCEPTS:

THREE IMPORTANT DATES:

1. DECLARATION DATE (December 1, 2025):
   - Board of Directors declares dividend
   - DIVIDEND LIABILITY ARISES
   - Retained Earnings is debited, Dividends Payable is credited
   - This is when corporation becomes legally obligated

2. RECORD DATE (December 15, 2025):
   - Determines WHO receives the dividend
   - Stockholders on this date are entitled to dividend
   - Stock transfers after this date don''t transfer dividend rights

3. PAYMENT DATE (January 15, 2026):
   - Actual distribution of cash to stockholders
   - Dividends Payable is debited, Cash is credited

APPLICATION TO THE CASE:

Timeline:
- Dec 1: Declaration (liability arises)
- Dec 10: A sells to B
- Dec 15: Record date (B is stockholder of record)
- Jan 15: Payment date

ANALYSIS:
- When were shares sold? December 10 (BEFORE record date)
- Who owned shares on record date? B
- Who receives dividend? B

The sale on December 10 transferred ALL rights attached to the shares, including the right to receive the declared dividend, because the sale occurred BEFORE the record date.

When did liability arise? December 1 (declaration date) - this is when the corporation''s obligation became fixed.
', 'Dividend rights follow the RECORD DATE holder. Liability arises on DECLARATION DATE.', 1, 'EXAM');

-- Explanation for TAX-HARD-001
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (42, 42, 'Cash dividends from domestic corporations to individual taxpayers are subject to 10% final withholding tax.', 'DIVIDEND TAXATION UNDER THE TAX CODE (as amended by TRAIN Law)

CASH DIVIDENDS TO INDIVIDUALS:
- Rate: 10% FINAL WITHHOLDING TAX
- Applies to: Resident citizens, non-resident citizens, resident aliens
- Non-resident aliens: 20% or treaty rate (if applicable)

PROPERTY DIVIDENDS:
- Fair market value of property at declaration date
- Same 10% final tax applies

STOCK DIVIDENDS:
- Generally NOT taxable (represents capitalization of retained earnings)
- Exception: Redemption shortly after issuance may be treated as cash dividend

INTER-CORPORATE DIVIDENDS:
- Exempt from tax if received by a domestic corporation
- Purpose: Prevent multiple taxation of same income

NON-RESIDENT FOREIGN CORPORATION:
- 25% final tax on dividends
- May be reduced under tax treaties

FINAL TAX EFFECT:
- Tax is final; income not included in gross income
- No deductions allowed against this income
- Payee has no further tax liability
', 'Individual receives cash dividend from domestic corp = 10% FINAL tax (not graduated rates)', 1, 'EXAM');

-- Explanation for TAX-HARD-002
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (43, 43, 'Shares sold through PSE: 0.6% stock transaction tax (STT) on gross selling price. No other income tax.', 'STOCK TRANSACTION TAX (Section 127, NIRC)

FOR SHARES SOLD THROUGH PSE (LOCAL STOCK EXCHANGE):

TAX RATE: 0.6% of GROSS SELLING PRICE
- This is the ONLY tax on the transaction
- No income tax or capital gains tax applies
- Collected by the stock broker

CALCULATION:
- Gross selling price: PHP 5,000,000
- Stock transaction tax: PHP 5,000,000 × 0.6% = PHP 30,000

COMPARE WITH UNLISTED SHARES:

For shares NOT traded through PSE:
- 15% CAPITAL GAINS TAX
- Based on NET CAPITAL GAIN (selling price - cost - expenses)
- First PHP 100,000 of gain: 5% (optional)
- Excess over PHP 100,000: 10%
- (Note: Rates under Section 24(C) before CREATE amendments)

WHY DIFFERENT TREATMENT?
- PSE trading is encouraged for market liquidity
- Stock transaction tax is simpler to administer
- Tax is on gross sales, not gains (even if at a loss, STT applies)
', 'PSE transaction = 0.6% STT on gross selling price. Not through PSE = 15% CGT on net gain.', 1, 'EXAM');

-- Explanation for TAX-HARD-003
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (44, 44, 'Net Estate = Gross Estate (worldwide) - Deductions - Standard Deduction (PHP 5M under TRAIN).', 'ESTATE TAX UNDER TRAIN LAW

For RESIDENT CITIZENS and RESIDENT ALIENS:
- Gross estate includes WORLDWIDE properties (Phil + foreign)

CALCULATION:

Gross Estate:
- Philippine properties:    PHP 15,000,000
- Foreign properties:       PHP  5,000,000
- Total Gross Estate:       PHP 20,000,000

Less: Deductions
- Expenses, losses, debts:  PHP  3,000,000
- Standard deduction:       PHP  5,000,000
- Total deductions:         PHP  8,000,000

NET TAXABLE ESTATE:         PHP 12,000,000

ESTATE TAX RATE (TRAIN Law):
- Single rate: 6% of net estate in excess of PHP 5,000,000 standard deduction
- Estate tax = (PHP 12,000,000) × 6% = PHP 720,000

KEY CHANGES UNDER TRAIN LAW:
1. Flat 6% rate (replaced graduated 5-20% rates)
2. PHP 5,000,000 standard deduction (not itemized)
3. Removed family home deduction, medical expenses, funeral expenses as separate items
4. Share of surviving spouse in conjugal/community property still excluded
', 'Estate Tax = 6% of (Gross Estate - Deductions - PHP 5M Standard Deduction)', 1, 'EXAM');

-- Explanation for TAX-HARD-004
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (45, 45, 'VAT Payable = Output VAT - Input VAT. Excess input VAT is carried forward to the next period.', 'VALUE-ADDED TAX COMPUTATION

FORMULA:
VAT Payable = Output VAT - Input VAT

GIVEN:
- Output VAT:                       PHP 240,000
- Input VAT (capital goods):        PHP 180,000
- Input VAT (purchases):            PHP 100,000
- Total Input VAT:                  PHP 280,000

COMPUTATION:
- Output VAT:                       PHP 240,000
- Less: Total Input VAT:           (PHP 280,000)
- EXCESS INPUT VAT:                (PHP  40,000)

TREATMENT OF EXCESS INPUT VAT:
- Generally: Carried forward to succeeding quarters
- May apply for refund/credit after 2 years from close of taxable quarter
- For zero-rated/effectively zero-rated sales: May claim refund within 2 years

INPUT VAT ON CAPITAL GOODS:
- Fully creditable against output VAT
- Capital goods = goods with useful life of more than one year
- Must be used in VAT-taxable business

NOTE: Unlike some jurisdictions, Philippine VAT allows immediate crediting of capital goods input VAT (no amortization requirement under current rules).
', 'VAT = Output - Input. Excess input VAT = Carry forward (not immediate refund)', 1, 'EXAM');

-- Explanation for TAX-HARD-005
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (46, 46, 'De minimis benefits within prescribed limits are exempt from fringe benefits tax.', 'FRINGE BENEFITS TAX (FBT)

FBT BASICS:
- Tax on benefits given to MANAGERIAL and SUPERVISORY employees
- Rate: 35% of grossed-up monetary value
- Paid by EMPLOYER (final tax on employee)
- Rank-and-file benefits are taxable as compensation income

EXEMPT FROM FBT:

1. DE MINIMIS BENEFITS (within limits):
   - Monetized unused vacation leave: 10 days/year
   - Rice subsidy: PHP 2,000/month
   - Uniform allowance: PHP 6,000/year
   - Medical cash allowance: PHP 1,500/quarter
   - Laundry allowance: PHP 300/month
   - Achievement awards: PHP 10,000/year
   - Christmas gift: PHP 5,000
   - Daily meal allowance not exceeding 25% of basic minimum wage

2. Benefits required by law (SSS, PhilHealth, Pag-IBIG)

3. Benefits given for employer''s convenience

4. Benefits to rank-and-file (taxed as compensation instead)

DE MINIMIS EXCESS:
- Excess over limits is taxable
- First PHP 90,000 of excess: included in 13th month/bonus exemption
- Further excess: taxable compensation
', 'De minimis = Tax-free if within limits. Excess goes to 13th month exemption pool.', 1, 'EXAM');

-- Explanation for TAX-HARD-006
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (47, 47, 'OSD for corporations = 40% of gross income. Taxable income = Gross income - OSD.', 'OPTIONAL STANDARD DEDUCTION (OSD)

FOR CORPORATIONS:
- OSD = 40% of GROSS INCOME
- Available to both domestic and resident foreign corporations
- In lieu of itemized deductions
- Irrevocable election for the taxable year

CALCULATION:

Gross income:                    PHP 10,000,000
Less: OSD (40% × 10M):          (PHP  4,000,000)
Taxable income:                  PHP  6,000,000

COMPARE WITH ITEMIZED:
Gross income:                    PHP 10,000,000
Less: Itemized deductions:      (PHP  7,000,000)
Taxable income:                  PHP  3,000,000

ANALYSIS:
- Itemized results in lower taxable income (PHP 3M vs PHP 6M)
- Corporation should have chosen ITEMIZED deductions
- BUT once OSD is elected, it is IRREVOCABLE for that year

FOR INDIVIDUALS:
- OSD = 40% of GROSS SALES/RECEIPTS
- Available to self-employed and professionals
- Not available to compensation income earners

WHY CHOOSE OSD?
- Simpler compliance (no need to track expenses)
- Fewer documentation requirements
- Beneficial when actual deductions < 40%
', 'Corporate OSD = 40% of Gross Income. Individual OSD = 40% of Gross Sales/Receipts.', 1, 'EXAM');

-- Explanation for TAX-HARD-007
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (48, 48, 'Non-resident foreign corporations engaged in business in the Philippines: 25% of taxable income (same as domestic corporations under CREATE).', 'CORPORATE INCOME TAX RATES UNDER CREATE LAW

DOMESTIC CORPORATIONS:
- Regular rate: 25% of taxable income
- Small corporations: 20% (net taxable income ≤ PHP 5M AND total assets ≤ PHP 100M, excluding land)

RESIDENT FOREIGN CORPORATIONS:
- Same as domestic: 25% of taxable income

NON-RESIDENT FOREIGN CORPORATIONS:

1. ENGAGED IN TRADE/BUSINESS IN THE PHILIPPINES:
   - 25% of taxable income from Philippine sources
   - Same rate as domestic corporations

2. NOT ENGAGED IN TRADE/BUSINESS:
   - 25% of GROSS INCOME from Philippine sources
   - No deductions allowed (final tax)

KEY DISTINCTION:
- "Engaged in business" = subject to tax on NET income (after deductions)
- "Not engaged in business" = subject to tax on GROSS income (no deductions)

WHEN IS FOREIGN CORP "ENGAGED IN BUSINESS"?
- Systematic, continuous, and regular business activities
- Having a branch, office, or agent in the Philippines
- Isolated or sporadic transactions do not constitute "engaged in business"
', 'Foreign corp engaged in PH business = 25% on taxable income. Not engaged = 25% on GROSS.', 1, 'EXAM');

-- Explanation for TAX-HARD-008
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (49, 49, 'Donor''s tax base for real property = HIGHER of FMV per BIR zonal value OR Assessor''s fair market value.', 'DONOR''S TAX UNDER TRAIN LAW

TAX BASE FOR REAL PROPERTY:
- HIGHER of:
  a) Fair market value per BIR (zonal value), or
  b) Fair market value per Provincial/City Assessor

CALCULATION:
- BIR zonal value: PHP 5,000,000
- Assessor''s FMV: PHP 4,000,000
- Tax base: PHP 5,000,000 (higher value)

DONOR''S TAX RATE (TRAIN Law):
- Single rate: 6% of total gifts in excess of PHP 250,000
- PHP 250,000 exemption per donor per year

TAX COMPUTATION:
- Taxable gift: PHP 5,000,000
- Less: Exemption: (PHP 250,000)
- Tax base: PHP 4,750,000
- Donor''s tax: PHP 4,750,000 × 6% = PHP 285,000

OTHER RULES:
- Donor''s tax paid by DONOR (not donee)
- Strangers: 30% of excess over PHP 250,000 (before TRAIN)
- After TRAIN: Same 6% rate regardless of relationship
- Tax due within 30 days from date of donation
', 'Real property donation: Use HIGHER value (BIR vs Assessor). Rate = 6% of excess over PHP 250K.', 1, 'EXAM');

-- Explanation for TAX-HARD-009
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (50, 50, 'Cash dividends from domestic corporations to individual resident citizens are subject to 10% final withholding tax under the NIRC as amended by CREATE Law.', 'Under Section 24(B)(2) of the NIRC as amended by RA 11534 (CREATE Law):

1. Cash and property dividends received by resident citizens from domestic corporations are subject to a FINAL TAX of 10%
2. This applies regardless of whether the corporation is publicly listed or closely held
3. The tax is withheld at source by the payor corporation
4. The CREATE Law unified the dividend tax rate at 10% (previously, listed companies had a 10% rate while others had varying rates)

COMPUTATION:
Cash dividend received: PHP 500,000
Final tax rate: 10%
Tax due: PHP 500,000 x 10% = PHP 50,000

Note: The accumulated earnings and paid-up capital figures are provided as distractors. For tax purposes on individual recipients, only the amount of dividend and the source (domestic corporation) matter.
', 'Individual + Dividend from Domestic Corp = 10% FINAL TAX (CREATE unified rate)', 1, 'EXAM');


-- ============================================================================
-- UPDATE legal_reference in a separate column (if needed) - using memory_tip for now
-- Note: The schema has reference_id (FK) not legal_reference text
-- ============================================================================

-- Store legal references in why_wrong_choices column temporarily
UPDATE question_explanations SET why_wrong_choices = 'Partnership Accounting - Admission of a Partner' WHERE question_id = 1;
UPDATE question_explanations SET why_wrong_choices = 'PFRS 3, Paragraphs 24-26' WHERE question_id = 2;
UPDATE question_explanations SET why_wrong_choices = 'PFRS 10, Intercompany Transactions Elimination' WHERE question_id = 3;
UPDATE question_explanations SET why_wrong_choices = 'PFRS 15, Paragraphs 39-45' WHERE question_id = 4;
UPDATE question_explanations SET why_wrong_choices = 'Home Office and Branch Accounting - Combined Statements' WHERE question_id = 5;
UPDATE question_explanations SET why_wrong_choices = 'Civil Code of the Philippines, Article 1813-1814; Partnership Liquidation' WHERE question_id = 6;
UPDATE question_explanations SET why_wrong_choices = 'PFRS 10, Paragraphs 5-9' WHERE question_id = 7;
UPDATE question_explanations SET why_wrong_choices = 'PAS 28, Paragraphs 10-14' WHERE question_id = 8;
UPDATE question_explanations SET why_wrong_choices = 'PSA 315, Paragraphs 15-17' WHERE question_id = 9;
UPDATE question_explanations SET why_wrong_choices = 'PSA 505, Paragraph 5-7; PSA 500, Paragraph A31' WHERE question_id = 10;
UPDATE question_explanations SET why_wrong_choices = 'PSA 700, Paragraphs 16-19; PSA 705' WHERE question_id = 11;
UPDATE question_explanations SET why_wrong_choices = 'PSA 320, Paragraphs 9-11' WHERE question_id = 12;
UPDATE question_explanations SET why_wrong_choices = 'PSA 240, Paragraphs 4-6' WHERE question_id = 13;
UPDATE question_explanations SET why_wrong_choices = 'PSA 260, Paragraph 16; PSA 240, Paragraph 41' WHERE question_id = 14;
UPDATE question_explanations SET why_wrong_choices = 'PSA 315, Paragraphs A106-A115' WHERE question_id = 15;
UPDATE question_explanations SET why_wrong_choices = 'PSA 570, Paragraphs 22-23' WHERE question_id = 16;
UPDATE question_explanations SET why_wrong_choices = 'PAS 21, Paragraphs 35-37' WHERE question_id = 17;
UPDATE question_explanations SET why_wrong_choices = 'PFRS 9, Paragraph 5.6.5' WHERE question_id = 18;
UPDATE question_explanations SET why_wrong_choices = 'PAS 16, Paragraphs 39-40' WHERE question_id = 19;
UPDATE question_explanations SET why_wrong_choices = 'PAS 37, Paragraph 14' WHERE question_id = 20;
UPDATE question_explanations SET why_wrong_choices = 'PFRS 9, Paragraphs 5.5.3-5.5.5' WHERE question_id = 21;
UPDATE question_explanations SET why_wrong_choices = 'PFRS 15, Paragraphs 60-65' WHERE question_id = 22;
UPDATE question_explanations SET why_wrong_choices = 'PAS 19, Paragraphs 120-130' WHERE question_id = 23;
UPDATE question_explanations SET why_wrong_choices = 'PAS 36, Paragraphs 100-103' WHERE question_id = 24;
UPDATE question_explanations SET why_wrong_choices = 'PFRS 16, Paragraphs 26-27' WHERE question_id = 25;
UPDATE question_explanations SET why_wrong_choices = 'Horngren''s Cost Accounting, Chapter on Standard Costing and Variance Analysis' WHERE question_id = 26;
UPDATE question_explanations SET why_wrong_choices = 'Brigham & Houston, Fundamentals of Financial Management - Capital Budgeting Chapter' WHERE question_id = 27;
UPDATE question_explanations SET why_wrong_choices = 'Garrison, Noreen, Brewer - Managerial Accounting, CVP Analysis Chapter' WHERE question_id = 28;
UPDATE question_explanations SET why_wrong_choices = 'Kaplan & Cooper - Cost and Effect: Using Integrated Cost Systems' WHERE question_id = 29;
UPDATE question_explanations SET why_wrong_choices = 'Hilton - Managerial Accounting, Cost Behavior and Estimation Chapter' WHERE question_id = 30;
UPDATE question_explanations SET why_wrong_choices = 'Garrison, Noreen, Brewer - Managerial Accounting, Relevant Costs for Decision Making' WHERE question_id = 31;
UPDATE question_explanations SET why_wrong_choices = 'Horngren''s Cost Accounting - CVP Analysis and Operating Leverage' WHERE question_id = 32;
UPDATE question_explanations SET why_wrong_choices = 'Horngren''s Cost Accounting - Relevant Costs for Decision Making' WHERE question_id = 33;
UPDATE question_explanations SET why_wrong_choices = 'Civil Code of the Philippines, Article 1506; Norkis Distributors vs. CA, G.R. No. 91029' WHERE question_id = 34;
UPDATE question_explanations SET why_wrong_choices = 'Negotiable Instruments Law (Act No. 2031), Sections 9, 30, 52, 57' WHERE question_id = 35;
UPDATE question_explanations SET why_wrong_choices = 'Civil Code of the Philippines, Article 1217' WHERE question_id = 36;
UPDATE question_explanations SET why_wrong_choices = 'Revised Corporation Code, Section 42; SEC Memorandum Circular on Stock Dividends' WHERE question_id = 37;
UPDATE question_explanations SET why_wrong_choices = 'Negotiable Instruments Law, Sections 23, 65, 66; Associated Bank vs. CA, G.R. No. 107382' WHERE question_id = 38;
UPDATE question_explanations SET why_wrong_choices = 'Civil Code of the Philippines, Articles 1676-1678' WHERE question_id = 39;
UPDATE question_explanations SET why_wrong_choices = 'Partnership Accounting; Civil Code Articles 1767-1867' WHERE question_id = 40;
UPDATE question_explanations SET why_wrong_choices = 'Revised Corporation Code, Section 42; SEC Rules on Dividends' WHERE question_id = 41;
UPDATE question_explanations SET why_wrong_choices = 'NIRC Section 24(B)(2), as amended by TRAIN Law' WHERE question_id = 42;
UPDATE question_explanations SET why_wrong_choices = 'NIRC Section 127(A); Revenue Regulations 06-2008' WHERE question_id = 43;
UPDATE question_explanations SET why_wrong_choices = 'NIRC Section 84-86, as amended by TRAIN Law' WHERE question_id = 44;
UPDATE question_explanations SET why_wrong_choices = 'NIRC Section 110-112; Revenue Regulations 16-2005' WHERE question_id = 45;
UPDATE question_explanations SET why_wrong_choices = 'NIRC Section 33; Revenue Regulations 03-98, 05-2011' WHERE question_id = 46;
UPDATE question_explanations SET why_wrong_choices = 'NIRC Section 34(L), as amended by CREATE Law' WHERE question_id = 47;
UPDATE question_explanations SET why_wrong_choices = 'NIRC Section 28(A), as amended by CREATE Law' WHERE question_id = 48;
UPDATE question_explanations SET why_wrong_choices = 'NIRC Section 99-102, as amended by TRAIN Law' WHERE question_id = 49;
UPDATE question_explanations SET why_wrong_choices = 'NIRC Section 24(B)(2) as amended by RA 11534 (CREATE Law)' WHERE question_id = 50;


-- ============================================================================
-- VERIFY COUNTS
-- ============================================================================
SELECT 'Practice Sets' as table_name, COUNT(*) as count FROM practice_sets WHERE practice_set_id >= 100
UNION ALL
SELECT 'Questions', COUNT(*) FROM questions WHERE question_id <= 50
UNION ALL
SELECT 'Choices', COUNT(*) FROM question_choices WHERE question_id <= 50
UNION ALL
SELECT 'Explanations', COUNT(*) FROM question_explanations WHERE question_id <= 50;

-- Expected: Practice Sets: 6, Questions: 50, Choices: 200 (50x4), Explanations: 50
