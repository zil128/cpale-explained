-- ============================================================================
-- CPALE Explained - 50 FREE MCQs Seed Data
-- Distributed across 6 subjects with comprehensive explanations
-- ============================================================================

-- First, add topics for subjects that don't have them yet
-- ============================================================================
-- AFAR Topics (subject_id = 2)
-- ============================================================================
INSERT INTO topics (subject_id, topic_code, topic_name, display_order) VALUES
(2, 'AFAR-BC', 'Business Combinations', 1),
(2, 'AFAR-CONSOL', 'Consolidated Financial Statements', 2),
(2, 'AFAR-ASSOC', 'Investments in Associates', 3),
(2, 'AFAR-JV', 'Joint Ventures', 4),
(2, 'AFAR-FC', 'Foreign Currency Transactions', 5),
(2, 'AFAR-NFP', 'Not-for-Profit Organizations', 6);

-- ============================================================================
-- AUD Topics (subject_id = 3) - Note: AT in DB but we use AUD
-- ============================================================================
INSERT INTO topics (subject_id, topic_code, topic_name, display_order) VALUES
(3, 'AUD-FRAME', 'Auditing Framework and Standards', 1),
(3, 'AUD-PLAN', 'Audit Planning and Risk Assessment', 2),
(3, 'AUD-IC', 'Internal Control', 3),
(3, 'AUD-EVID', 'Audit Evidence', 4),
(3, 'AUD-SAMP', 'Audit Sampling', 5),
(3, 'AUD-REPORT', 'Audit Reports', 6);

-- ============================================================================
-- TAX Topics (subject_id = 4)
-- ============================================================================
INSERT INTO topics (subject_id, topic_code, topic_name, display_order) VALUES
(4, 'TAX-INCOME', 'Income Taxation Principles', 1),
(4, 'TAX-GROSS', 'Gross Income', 2),
(4, 'TAX-DED', 'Deductions', 3),
(4, 'TAX-CORP', 'Corporate Taxation', 4),
(4, 'TAX-VAT', 'Value Added Tax', 5),
(4, 'TAX-ESTATE', 'Estate and Donor Tax', 6);

-- ============================================================================
-- MS/MAS Topics (subject_id = 5)
-- ============================================================================
INSERT INTO topics (subject_id, topic_code, topic_name, display_order) VALUES
(5, 'MS-COST', 'Cost Concepts and Classifications', 1),
(5, 'MS-CVP', 'Cost-Volume-Profit Analysis', 2),
(5, 'MS-BUDGET', 'Budgeting', 3),
(5, 'MS-STD', 'Standard Costing and Variance Analysis', 4),
(5, 'MS-DECISION', 'Decision Making', 5),
(5, 'MS-PERF', 'Performance Measurement', 6);

-- ============================================================================
-- RFBT Topics (subject_id = 6)
-- ============================================================================
INSERT INTO topics (subject_id, topic_code, topic_name, display_order) VALUES
(6, 'RFBT-OBLIG', 'Obligations and Contracts', 1),
(6, 'RFBT-SALES', 'Sales', 2),
(6, 'RFBT-AGENCY', 'Agency', 3),
(6, 'RFBT-PARTNER', 'Partnership', 4),
(6, 'RFBT-CORP', 'Corporation Code', 5),
(6, 'RFBT-NI', 'Negotiable Instruments', 6);

-- ============================================================================
-- Create Practice Sets for new topics
-- ============================================================================
-- Get topic IDs dynamically - we'll use variables
SET @afar_bc = (SELECT topic_id FROM topics WHERE topic_code = 'AFAR-BC');
SET @afar_consol = (SELECT topic_id FROM topics WHERE topic_code = 'AFAR-CONSOL');
SET @aud_frame = (SELECT topic_id FROM topics WHERE topic_code = 'AUD-FRAME');
SET @aud_evid = (SELECT topic_id FROM topics WHERE topic_code = 'AUD-EVID');
SET @tax_income = (SELECT topic_id FROM topics WHERE topic_code = 'TAX-INCOME');
SET @tax_vat = (SELECT topic_id FROM topics WHERE topic_code = 'TAX-VAT');
SET @ms_cvp = (SELECT topic_id FROM topics WHERE topic_code = 'MS-CVP');
SET @ms_budget = (SELECT topic_id FROM topics WHERE topic_code = 'MS-BUDGET');
SET @rfbt_sales = (SELECT topic_id FROM topics WHERE topic_code = 'RFBT-SALES');
SET @rfbt_oblig = (SELECT topic_id FROM topics WHERE topic_code = 'RFBT-OBLIG');

-- Practice sets for FAR topics
INSERT INTO practice_sets (topic_id, set_code, set_name, set_type, is_paid) VALUES
(1, 'FAR-CF-PS-01', 'Conceptual Framework Practice Set 1', 'PRACTICE', 0),
(2, 'FAR-CASH-PS-01', 'Cash Practice Set 1', 'PRACTICE', 0),
(3, 'FAR-REC-PS-01', 'Receivables Practice Set 1', 'PRACTICE', 0),
(4, 'FAR-INV-PS-01', 'Inventory Practice Set 1', 'PRACTICE', 0),
(5, 'FAR-PPE-PS-01', 'PPE Practice Set 1', 'PRACTICE', 0);

-- Practice sets for other subjects (using variable topic IDs)
INSERT INTO practice_sets (topic_id, set_code, set_name, set_type, is_paid)
SELECT @afar_bc, 'AFAR-BC-PS-01', 'Business Combinations Practice Set 1', 'PRACTICE', 0
WHERE @afar_bc IS NOT NULL;

INSERT INTO practice_sets (topic_id, set_code, set_name, set_type, is_paid)
SELECT @afar_consol, 'AFAR-CONSOL-PS-01', 'Consolidation Practice Set 1', 'PRACTICE', 0
WHERE @afar_consol IS NOT NULL;

INSERT INTO practice_sets (topic_id, set_code, set_name, set_type, is_paid)
SELECT @aud_frame, 'AUD-FRAME-PS-01', 'Audit Framework Practice Set 1', 'PRACTICE', 0
WHERE @aud_frame IS NOT NULL;

INSERT INTO practice_sets (topic_id, set_code, set_name, set_type, is_paid)
SELECT @aud_evid, 'AUD-EVID-PS-01', 'Audit Evidence Practice Set 1', 'PRACTICE', 0
WHERE @aud_evid IS NOT NULL;

INSERT INTO practice_sets (topic_id, set_code, set_name, set_type, is_paid)
SELECT @tax_income, 'TAX-INCOME-PS-01', 'Income Tax Practice Set 1', 'PRACTICE', 0
WHERE @tax_income IS NOT NULL;

INSERT INTO practice_sets (topic_id, set_code, set_name, set_type, is_paid)
SELECT @tax_vat, 'TAX-VAT-PS-01', 'VAT Practice Set 1', 'PRACTICE', 0
WHERE @tax_vat IS NOT NULL;

INSERT INTO practice_sets (topic_id, set_code, set_name, set_type, is_paid)
SELECT @ms_cvp, 'MS-CVP-PS-01', 'CVP Analysis Practice Set 1', 'PRACTICE', 0
WHERE @ms_cvp IS NOT NULL;

INSERT INTO practice_sets (topic_id, set_code, set_name, set_type, is_paid)
SELECT @ms_budget, 'MS-BUDGET-PS-01', 'Budgeting Practice Set 1', 'PRACTICE', 0
WHERE @ms_budget IS NOT NULL;

INSERT INTO practice_sets (topic_id, set_code, set_name, set_type, is_paid)
SELECT @rfbt_sales, 'RFBT-SALES-PS-01', 'Sales Practice Set 1', 'PRACTICE', 0
WHERE @rfbt_sales IS NOT NULL;

INSERT INTO practice_sets (topic_id, set_code, set_name, set_type, is_paid)
SELECT @rfbt_oblig, 'RFBT-OBLIG-PS-01', 'Obligations Practice Set 1', 'PRACTICE', 0
WHERE @rfbt_oblig IS NOT NULL;
