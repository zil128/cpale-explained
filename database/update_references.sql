-- ============================================================================
-- Update References for All 50 MCQs
-- ============================================================================

-- FAR Questions References
UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: IASB Conceptual Framework for Financial Reporting (2018), Chapter 1, Paragraphs 1.2-1.4') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'FAR-CF-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: PAS 7 (IAS 7) Statement of Cash Flows, Paragraphs 6-7') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'FAR-CASH-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: PFRS 9 Financial Instruments, Paragraph 5.1.3; PFRS 15 Revenue from Contracts with Customers') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'FAR-REC-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: PAS 2 (IAS 2) Inventories, Paragraph 9') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'FAR-INV-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: PAS 16 (IAS 16) Property, Plant and Equipment, Paragraphs 16-19') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'FAR-PPE-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: PFRS 15 Revenue from Contracts with Customers, Paragraphs 31-38') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'FAR-REV-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: PFRS 9 Financial Instruments, Paragraphs 4.1.1-4.1.5') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'FAR-FI-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: PAS 38 (IAS 38) Intangible Assets, Paragraphs 54-56') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'FAR-INT-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: PAS 33 (IAS 33) Earnings Per Share, Paragraphs 19-20') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'FAR-EPS-Q001');

-- AFAR Questions References
UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: PFRS 3 Business Combinations, Paragraphs 32-35; PAS 36 Impairment of Assets, Paragraphs 80-99') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'AFAR-BC-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: PFRS 10 Consolidated Financial Statements, Paragraphs B86-B87') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'AFAR-CONSOL-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: PAS 28 (IAS 28) Investments in Associates and Joint Ventures, Paragraphs 10-15') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'AFAR-ASSOC-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: PAS 21 (IAS 21) The Effects of Changes in Foreign Exchange Rates, Paragraphs 21-22') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'AFAR-FC-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: PFRS 10 Consolidated Financial Statements, Paragraph 22; PAS 1 Presentation of Financial Statements') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'AFAR-NCI-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: PFRS 3 Business Combinations, Paragraphs 53') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'AFAR-BC-Q002');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: PFRS 11 Joint Arrangements, Paragraphs 24; PAS 28 Investments in Associates and Joint Ventures') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'AFAR-JV-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: PAS 36 (IAS 36) Impairment of Assets, Paragraphs 80-87') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'AFAR-BC-Q003');

-- AUD Questions References
UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: PSA 200 (ISA 200) Overall Objectives of the Independent Auditor, Paragraphs 3-5, 11') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'AUD-FRAME-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: PSA 500 (ISA 500) Audit Evidence, Paragraphs A5, A31') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'AUD-EVID-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: PSA 315 (ISA 315) Identifying and Assessing Risks of Material Misstatement, Appendix 1; COSO Internal Control Framework') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'AUD-IC-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: PSA 200 (ISA 200) Overall Objectives; PSA 315 (ISA 315) Risk Assessment') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'AUD-RISK-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: PSA 705 (ISA 705) Modifications to the Opinion in the Independent Auditors Report, Paragraphs 7-8') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'AUD-REPORT-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: PSA 580 (ISA 580) Written Representations, Paragraphs 4, 9') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'AUD-EVID-Q002');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: PSA 330 (ISA 330) The Auditors Responses to Assessed Risks, Paragraphs 4, 18') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'AUD-EVID-Q003');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: PSA 570 (ISA 570) Going Concern, Paragraphs 19-22') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'AUD-GC-Q001');

-- TAX Questions References
UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: National Internal Revenue Code (NIRC), Section 43 - Period for which Deductions and Credits Taken') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'TAX-INCOME-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: National Internal Revenue Code (NIRC), Section 32(B) - Exclusions from Gross Income') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'TAX-GROSS-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: National Internal Revenue Code (NIRC), Section 34(L) - Optional Standard Deduction') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'TAX-DED-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: Republic Act No. 11534 (CREATE Law), Section 27(A) - Rates of Income Tax on Domestic Corporations') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'TAX-CORP-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: National Internal Revenue Code (NIRC), Section 106 as amended by RA 9337') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'TAX-VAT-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: National Internal Revenue Code (NIRC), Section 24(B)(1) - Tax on Passive Income') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'TAX-WH-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: Republic Act No. 10963 (TRAIN Law), Section 84 - Rates of Estate Tax') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'TAX-ESTATE-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: Republic Act No. 10963 (TRAIN Law), Section 99 - Rates of Donors Tax') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'TAX-DONOR-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: National Internal Revenue Code (NIRC), Section 27(D)(4) - Intercorporate Dividends') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'TAX-PASSIVE-Q001');

-- MS Questions References
UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: Horngren, Cost Accounting: A Managerial Emphasis, Chapter 2 - Cost Terms, Concepts, and Classifications') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'MS-COST-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: Horngren, Cost Accounting: A Managerial Emphasis, Chapter 3 - Cost-Volume-Profit Analysis') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'MS-CVP-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: Horngren, Cost Accounting: A Managerial Emphasis, Chapter 3 - CVP Analysis; Contribution Margin Analysis') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'MS-CVP-Q002');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: Horngren, Cost Accounting: A Managerial Emphasis, Chapter 6 - Master Budget and Responsibility Accounting') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'MS-BUDGET-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: Horngren, Cost Accounting: A Managerial Emphasis, Chapter 7 - Flexible Budgets and Variance Analysis') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'MS-STD-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: Horngren, Cost Accounting: A Managerial Emphasis, Chapter 11 - Decision Making and Relevant Information') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'MS-DECISION-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: Horngren, Cost Accounting: A Managerial Emphasis, Chapter 11 - Make-or-Buy Decisions') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'MS-DECISION-Q002');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: Horngren, Cost Accounting: A Managerial Emphasis, Chapter 23 - Performance Measurement; DuPont Analysis') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'MS-PERF-Q001');

-- RFBT Questions References
UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: Civil Code of the Philippines, Article 1156 - Definition of Obligations') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'RFBT-OBLIG-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: Civil Code of the Philippines, Articles 1561, 1566-1567 - Warranty Against Hidden Defects') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'RFBT-SALES-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: Civil Code of the Philippines, Article 1919 - Extinguishment of Agency') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'RFBT-AGENCY-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: Civil Code of the Philippines, Article 1784 - When Partnership Acquires Juridical Personality') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'RFBT-PARTNER-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: Revised Corporation Code (RA 11232), Section 10 - Number and Qualifications of Incorporators') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'RFBT-CORP-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: Negotiable Instruments Law (Act No. 2031), Section 1 - Form of Negotiable Instruments') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'RFBT-NI-Q001');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: Civil Code of the Philippines, Articles 1390-1391 - Voidable Contracts') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'RFBT-OBLIG-Q002');

UPDATE question_explanations SET why_wrong_choices = CONCAT(why_wrong_choices, '\n\nReference: Civil Code of the Philippines, Articles 1548-1560 - Warranty Against Eviction') WHERE question_id = (SELECT question_id FROM questions WHERE question_code = 'RFBT-SALES-Q002');

-- Also update the original 3 FAR-LEASE questions
UPDATE question_explanations SET why_wrong_choices = CONCAT(COALESCE(why_wrong_choices, ''), '\n\nReference: IFRS 16 Leases, Paragraphs 9-11 - Identifying a Lease') WHERE question_id = 1;
UPDATE question_explanations SET why_wrong_choices = CONCAT(COALESCE(why_wrong_choices, ''), '\n\nReference: IFRS 16 Leases, Paragraphs 23-24 - Initial Measurement of ROU Asset') WHERE question_id = 2;
UPDATE question_explanations SET why_wrong_choices = CONCAT(COALESCE(why_wrong_choices, ''), '\n\nReference: IFRS 16 Leases, Paragraphs 18-21 - Lease Term Determination') WHERE question_id = 3;
