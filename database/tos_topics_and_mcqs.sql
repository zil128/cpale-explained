-- ============================================================================
-- CPALE EXPLAINED - TOS Topics and MCQ Seeding
-- Based on PRBOA Resolution No. 30, Series of 2022
-- ============================================================================

-- Disable foreign key checks temporarily
SET FOREIGN_KEY_CHECKS = 0;

-- Clear existing data that references topics
DELETE FROM practice_sets WHERE topic_id IS NOT NULL;
DELETE FROM questions WHERE topic_id IS NOT NULL;

-- Clear existing topics and create fresh ones based on TOS
DELETE FROM topics WHERE topic_id > 0;
ALTER TABLE topics AUTO_INCREMENT = 1;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================================
-- FINANCIAL ACCOUNTING AND REPORTING (FAR) - Subject ID: 1
-- ============================================================================

INSERT INTO topics (subject_id, topic_code, topic_name, description, display_order, is_active) VALUES
-- Section 1: Development of Financial Reporting Framework
(1, 'FAR-1.0', 'Development of Financial Reporting Framework', 'Standard-Setting Bodies and Regulation of the Accountancy Profession', 1, TRUE),
(1, 'FAR-1.1', 'History and Functions of Standard-Setting Bodies', 'IASB, IFRIC, SIC, FRSC, PIC', 2, TRUE),
(1, 'FAR-1.2', 'Regulation of Accounting Profession', 'Professional Regulatory Board, APO, Sectors of Practice', 3, TRUE),

-- Section 2: Conceptual Framework and Accounting Process
(1, 'FAR-2.0', 'Conceptual Framework for Financial Reporting', 'Objectives, Qualitative Characteristics, Elements', 4, TRUE),
(1, 'FAR-2.1', 'The Accounting Process', 'Steps, Journals, Ledgers, Adjusting Entries', 5, TRUE),
(1, 'FAR-2.2', 'Presentation of Financial Statements', 'General Features, SFP, SCI, SCE, SCF', 6, TRUE),
(1, 'FAR-2.3', 'Statement of Financial Position', 'Definition of Elements, Classification', 7, TRUE),
(1, 'FAR-2.4', 'Statement of Comprehensive Income', 'Nature/Function of Expense, Continuing/Discontinued Operations', 8, TRUE),
(1, 'FAR-2.5', 'Statement of Cash Flows', 'Direct and Indirect Methods', 9, TRUE),
(1, 'FAR-2.6', 'Earnings Per Share', 'Basic EPS and Diluted EPS', 10, TRUE),

-- Section 3: Cash and Financial Assets
(1, 'FAR-3.0', 'Cash and Cash Equivalents', 'Nature, Composition, Bank Reconciliation, Petty Cash', 11, TRUE),
(1, 'FAR-3.1', 'Financial Assets at FVPL', 'Recognition, Measurement, Presentation', 12, TRUE),
(1, 'FAR-3.2', 'Financial Assets at FVOCI', 'Recognition, Measurement, Presentation', 13, TRUE),
(1, 'FAR-3.3', 'Financial Assets at Amortized Cost', 'Trade Receivables, Investment in Bonds', 14, TRUE),
(1, 'FAR-3.4', 'Investment in Associates and Joint Ventures', 'Equity Method', 15, TRUE),

-- Section 4: Non-financial Assets
(1, 'FAR-4.0', 'Inventories', 'Nature, Cost Flow Assumptions, LCNRV, Estimation Methods', 16, TRUE),
(1, 'FAR-4.1', 'Property, Plant and Equipment', 'Recognition, Depreciation, Revaluation, Impairment', 17, TRUE),
(1, 'FAR-4.2', 'Borrowing Costs', 'Capitalization of Borrowing Costs', 18, TRUE),
(1, 'FAR-4.3', 'Investment Property', 'Cost Model, Fair Value Model', 19, TRUE),
(1, 'FAR-4.4', 'Intangible Assets', 'Recognition, Amortization, Impairment', 20, TRUE),
(1, 'FAR-4.5', 'Biological Assets', 'Nature, Measurement, Agricultural Produce', 21, TRUE),
(1, 'FAR-4.6', 'Non-current Assets Held for Sale', 'Classification, Measurement', 22, TRUE),

-- Section 5-6: Liabilities
(1, 'FAR-5.0', 'Financial Liabilities', 'Classification, Effective Interest Method, Troubled Debt', 23, TRUE),
(1, 'FAR-6.0', 'Non-financial Liabilities and Provisions', 'Customer Loyalty, Warranties, Contingencies', 24, TRUE),

-- Section 7: Shareholders Equity
(1, 'FAR-7.0', 'Share Capital Transactions', 'Issuance, Treasury Shares, Retirement', 25, TRUE),
(1, 'FAR-7.1', 'Retained Earnings', 'Prior Period Errors, Dividends, Quasi-Reorganization', 26, TRUE),
(1, 'FAR-7.2', 'Other Comprehensive Income', 'Components of OCI', 27, TRUE),
(1, 'FAR-7.3', 'Book Value Per Share', 'Computation', 28, TRUE),

-- Section 8: Other Topics
(1, 'FAR-8.1', 'Share-based Payments', 'Equity-settled, Cash-settled', 29, TRUE),
(1, 'FAR-8.2', 'Leases', 'Lessee and Lessor Accounting, Sale-Leaseback', 30, TRUE),
(1, 'FAR-8.3', 'Income Tax', 'Current and Deferred Tax', 31, TRUE),
(1, 'FAR-8.4', 'Employee Benefits', 'Defined Benefit, Defined Contribution', 32, TRUE),
(1, 'FAR-8.5', 'Interim Reporting', 'Components, Recognition Principles', 33, TRUE),
(1, 'FAR-8.6', 'Operating Segments', 'Identification and Reporting', 34, TRUE),

-- Section 9: Other Frameworks
(1, 'FAR-9.0', 'Other Reporting Frameworks', 'PFRS for SMEs, Small Entities, Microenterprises', 35, TRUE);

-- ============================================================================
-- ADVANCED FINANCIAL ACCOUNTING AND REPORTING (AFAR) - Subject ID: 2
-- ============================================================================

INSERT INTO topics (subject_id, topic_code, topic_name, description, display_order, is_active) VALUES
-- Partnership
(2, 'AFAR-1.0', 'Partnership Formation', 'Nature, Scope, Initial Capital Contribution', 1, TRUE),
(2, 'AFAR-1.1', 'Partnership Operations and Dissolution', 'Admission, Withdrawal, Retirement of Partners', 2, TRUE),
(2, 'AFAR-1.2', 'Partnership Liquidation', 'Lump-sum and Installment Methods', 3, TRUE),

-- Corporate Liquidation
(2, 'AFAR-2.0', 'Corporate Liquidation', 'Statement of Affairs, Deficiency, Realization', 4, TRUE),

-- Joint Arrangements
(2, 'AFAR-3.0', 'Joint Operations', 'PFRS 11, Nature, Accounting Methods', 5, TRUE),
(2, 'AFAR-3.1', 'Joint Ventures', 'Equity Method Application', 6, TRUE),

-- Revenue Recognition
(2, 'AFAR-4.0', 'Revenue from Contracts - Five Steps', 'PFRS 15 Five-Step Model', 7, TRUE),
(2, 'AFAR-4.1', 'Revenue Recognition Issues', 'Right of Return, Principal-Agent, Licensing', 8, TRUE),
(2, 'AFAR-4.2', 'Long-term Construction Contracts', 'Percentage of Completion, Input/Output Methods', 9, TRUE),
(2, 'AFAR-4.3', 'Franchise Operations', 'Initial and Continuing Franchise Fees', 10, TRUE),
(2, 'AFAR-4.4', 'Consignment Sales', 'Consignor and Consignee Accounting', 11, TRUE),

-- Home Office and Branch
(2, 'AFAR-5.0', 'Home Office and Branch Accounting', 'Reciprocal Accounts, Combined Statements', 12, TRUE),

-- Business Combination
(2, 'AFAR-6.0', 'Business Combination - PFRS 3', 'Acquisition Method, Goodwill, Bargain Purchase', 13, TRUE),

-- Consolidated Financial Statements
(2, 'AFAR-7.0', 'Separate Financial Statements - PAS 27', 'Investment in Subsidiaries at Cost', 14, TRUE),
(2, 'AFAR-8.0', 'Consolidated Financial Statements - PFRS 10', 'Consolidation Procedures, NCI, Intercompany', 15, TRUE),

-- Derivatives and Foreign Currency
(2, 'AFAR-9.0', 'Derivatives and Hedging - PFRS 9', 'Forwards, Futures, Options, Hedge Accounting', 16, TRUE),
(2, 'AFAR-10.0', 'Foreign Currency Translation - PAS 21', 'Functional Currency, Presentation Currency', 17, TRUE),

-- Not-for-Profit and Government
(2, 'AFAR-11.0', 'Not-for-Profit Organizations', 'VHWO, Hospitals, Colleges, Churches', 18, TRUE),
(2, 'AFAR-12.0', 'Government Accounting', 'GAM, Budget Process, Journal Entries', 19, TRUE),

-- Cost Accounting
(2, 'AFAR-13.0', 'Cost Accounting Systems', 'Actual, Normal, Standard Costing', 20, TRUE),
(2, 'AFAR-13.1', 'Job-order Costing', 'Journal Entries, Cost Accumulation', 21, TRUE),
(2, 'AFAR-13.2', 'Process Costing', 'FIFO, Average Method, Lost Units', 22, TRUE),
(2, 'AFAR-13.3', 'Activity-Based Costing', 'ABC vs Traditional Costing', 23, TRUE),
(2, 'AFAR-13.4', 'Joint and By-Products', 'Joint Cost Allocation Methods', 24, TRUE),
(2, 'AFAR-13.5', 'Service Cost Allocation', 'Direct, Step-down, Reciprocal Methods', 25, TRUE),

-- Special Topics
(2, 'AFAR-14.0', 'Insurance Contracts - PFRS 17', 'Types, Recognition, Measurement', 26, TRUE),
(2, 'AFAR-14.1', 'Service Concession Arrangements', 'IFRIC 12, BOT Accounting', 27, TRUE);

-- ============================================================================
-- AUDITING (AUD) - Subject ID: 3
-- ============================================================================

INSERT INTO topics (subject_id, topic_code, topic_name, description, display_order, is_active) VALUES
-- Fundamentals
(3, 'AUD-1.0', 'Assurance Engagements', 'Nature, Objectives, Elements, Types', 1, TRUE),
(3, 'AUD-1.1', 'Introduction to Auditing', 'Philosophy, Objectives, Types of Audit', 2, TRUE),

-- Risk-based Audit
(3, 'AUD-2.0', 'Risk-based Audit Overview', 'Pre-engagement, Planning, Supervision', 3, TRUE),
(3, 'AUD-2.1', 'Audit Planning', 'Knowledge of Business, Materiality, Audit Risk', 4, TRUE),
(3, 'AUD-2.2', 'Understanding Entity and Environment', 'Industry, Internal Control Assessment', 5, TRUE),
(3, 'AUD-2.3', 'Internal Control', 'Components, Testing Controls, Documentation', 6, TRUE),
(3, 'AUD-2.4', 'Risk of Material Misstatement', 'Fraud, Significant Risks, Risk Assessment', 7, TRUE),

-- Audit Evidence
(3, 'AUD-3.0', 'Audit Objectives and Procedures', 'Nature, Audit Techniques, Sampling', 8, TRUE),
(3, 'AUD-3.1', 'Audit Evidence', 'Sufficiency, Appropriateness, Types', 9, TRUE),
(3, 'AUD-3.2', 'Audit Documentation', 'Working Papers, File Organization', 10, TRUE),

-- Completing the Audit
(3, 'AUD-4.0', 'Completing the Audit', 'Analytical Procedures, Subsequent Events', 11, TRUE),
(3, 'AUD-4.1', 'Going Concern', 'Assessment, Indicators, Reporting', 12, TRUE),
(3, 'AUD-4.2', 'Management Representations', 'Written Representations', 13, TRUE),

-- Audit Reports
(3, 'AUD-5.0', 'Unqualified Audit Report', 'Basic Elements, Standard Report', 14, TRUE),
(3, 'AUD-5.1', 'Modified Audit Reports', 'Qualified, Adverse, Disclaimer', 15, TRUE),
(3, 'AUD-5.2', 'Key Audit Matters', 'Communication, Reporting', 16, TRUE),

-- CIS Environment
(3, 'AUD-6.0', 'Auditing in CIS Environment', 'General Controls, Application Controls', 17, TRUE),
(3, 'AUD-6.1', 'Computer Assisted Audit Techniques', 'CAATs, E-commerce Audit', 18, TRUE),

-- Attestation Services
(3, 'AUD-7.0', 'Special Purpose Audit Engagements', 'Components, Compliance, Summarized FS', 19, TRUE),
(3, 'AUD-7.1', 'Review Engagements', 'Procedures, Reports', 20, TRUE),
(3, 'AUD-7.2', 'Agreed-upon Procedures', 'Nature, Reporting', 21, TRUE),
(3, 'AUD-7.3', 'Compilation Engagements', 'Preparation of Financial Information', 22, TRUE),

-- Governance and Ethics
(3, 'AUD-8.0', 'Corporate Governance', 'Principles, Board Responsibilities', 23, TRUE),
(3, 'AUD-8.1', 'Ethics and Professional Responsibilities', 'Code of Ethics, Independence', 24, TRUE),
(3, 'AUD-8.2', 'Quality Management', 'ISQM 1, Elements, Leadership', 25, TRUE),

-- Business Process Auditing
(3, 'AUD-9.0', 'Order to Cash Cycle', 'Revenue, Receivables Audit', 26, TRUE),
(3, 'AUD-9.1', 'Purchase to Pay Cycle', 'Purchases, Payables Audit', 27, TRUE),
(3, 'AUD-9.2', 'Inventory and Payroll Cycles', 'Plan to Inventory, Hire to Retire', 28, TRUE);

-- ============================================================================
-- TAXATION (TAX) - Subject ID: 4
-- ============================================================================

INSERT INTO topics (subject_id, topic_code, topic_name, description, display_order, is_active) VALUES
-- Principles
(4, 'TAX-1.0', 'Principles of Taxation', 'Nature, Classification, Situs, Double Taxation', 1, TRUE),
(4, 'TAX-1.1', 'Tax Administration', 'BIR Organization, BOI, PEZA, BCDA', 2, TRUE),

-- Tax Remedies
(4, 'TAX-2.0', 'Tax Remedies', 'Government Remedies, Taxpayer Remedies', 3, TRUE),

-- Income Tax
(4, 'TAX-3.0', 'Income Tax - Taxpayers and Tax Base', 'Classification of Taxpayers, Taxable Income', 4, TRUE),
(4, 'TAX-3.1', 'Gross Income', 'Inclusions, Exclusions', 5, TRUE),
(4, 'TAX-3.2', 'Deductions from Gross Income', 'Itemized, Optional Standard Deduction', 6, TRUE),
(4, 'TAX-3.3', 'Income Tax Computation', 'Individual, Corporate Tax', 7, TRUE),
(4, 'TAX-3.4', 'Withholding Taxes', 'Creditable, Final, Expanded', 8, TRUE),
(4, 'TAX-3.5', 'Income Tax Compliance', 'Returns, Filing, Payment', 9, TRUE),
(4, 'TAX-3.6', 'Special Laws on Income Tax', 'Senior Citizens, PWD, BMBE', 10, TRUE),

-- Transfer Taxes
(4, 'TAX-4.0', 'Estate Tax', 'Gross Estate, Deductions, Tax Computation', 11, TRUE),
(4, 'TAX-4.1', 'Donors Tax', 'Net Gifts, Exemptions, Tax Computation', 12, TRUE),

-- Business Taxes
(4, 'TAX-5.0', 'Value-Added Tax', 'Nature, VAT-able Transactions, Input/Output VAT', 13, TRUE),
(4, 'TAX-5.1', 'VAT Computation and Compliance', 'VAT Payable, Returns, Refund', 14, TRUE),
(4, 'TAX-5.2', 'Percentage Tax', 'Nature, Transactions Subject', 15, TRUE),

-- Other Taxes
(4, 'TAX-6.0', 'Documentary Stamp Tax', 'Transactions Subject, Tax Rates', 16, TRUE),
(4, 'TAX-7.0', 'Excise Tax', 'Nature, Transactions Subject', 17, TRUE),

-- Local Taxes
(4, 'TAX-8.0', 'Local Government Taxation', 'Taxing Powers, Types of Local Taxes', 18, TRUE),
(4, 'TAX-8.1', 'Real Property Tax', 'Assessment, Computation, Remedies', 19, TRUE),

-- Preferential Taxation
(4, 'TAX-9.0', 'PEZA and Special Economic Zones', 'Income Tax Incentives, VAT Incentives', 20, TRUE),
(4, 'TAX-9.1', 'Tax Treaties', 'DTA Models, Royalties, Dividends, Interest', 21, TRUE);

-- ============================================================================
-- MANAGEMENT SERVICES (MS) - Subject ID: 5
-- ============================================================================

INSERT INTO topics (subject_id, topic_code, topic_name, description, display_order, is_active) VALUES
-- Management Accounting Fundamentals
(5, 'MS-1.0', 'Management Accounting Fundamentals', 'Objectives, Role, Scope, Controller vs Treasurer', 1, TRUE),
(5, 'MS-1.1', 'Cost Terms and Behavior', 'Classification, Variable, Fixed, Mixed Costs', 2, TRUE),
(5, 'MS-1.2', 'Cost-Volume-Profit Analysis', 'Break-even, Target Profit, Sales Mix', 3, TRUE),
(5, 'MS-1.3', 'Standard Costing and Variance Analysis', 'Material, Labor, Overhead Variances', 4, TRUE),
(5, 'MS-1.4', 'Variable vs Absorption Costing', 'Product Cost, Period Cost, Reconciliation', 5, TRUE),
(5, 'MS-1.5', 'Financial Planning and Budgets', 'Master Budget, Flexible Budget, Zero-based', 6, TRUE),

-- Performance Measurement
(5, 'MS-2.0', 'Responsibility Accounting', 'Cost, Revenue, Profit, Investment Centers', 7, TRUE),
(5, 'MS-2.1', 'Transfer Pricing', 'Market-based, Cost-based, Negotiated Price', 8, TRUE),
(5, 'MS-2.2', 'Balanced Scorecard', 'Four Perspectives, Performance Measures', 9, TRUE),

-- Decision Making
(5, 'MS-3.0', 'Relevant Costing', 'Differential Analysis, Opportunity Costs', 10, TRUE),
(5, 'MS-3.1', 'Short-term Decisions', 'Make or Buy, Special Order, Drop/Continue', 11, TRUE),
(5, 'MS-3.2', 'Linear Programming', 'Graphical Method, Algebraic Method', 12, TRUE),

-- Financial Management
(5, 'MS-4.0', 'Financial Management Overview', 'Nature, Purpose, Role of Financial Managers', 13, TRUE),
(5, 'MS-4.1', 'Financial Statement Analysis', 'Vertical, Horizontal, Ratio Analysis', 14, TRUE),
(5, 'MS-4.2', 'Working Capital Management', 'Cash, Receivables, Inventory Management', 15, TRUE),
(5, 'MS-4.3', 'Capital Budgeting', 'NPV, IRR, Payback, Profitability Index', 16, TRUE),
(5, 'MS-4.4', 'Risk and Leverage', 'Operating, Financial, Total Leverage', 17, TRUE),
(5, 'MS-4.5', 'Capital Structure', 'Cost of Capital, WACC, Financing Decisions', 18, TRUE),
(5, 'MS-4.6', 'Financial Markets', 'Money Markets, Capital Markets, Valuation', 19, TRUE),

-- Economics
(5, 'MS-5.0', 'Macroeconomics', 'GDP, Business Cycle, Fiscal/Monetary Policy', 20, TRUE),
(5, 'MS-5.1', 'Microeconomics', 'Supply, Demand, Elasticity, Market Structure', 21, TRUE);

-- ============================================================================
-- REGULATORY FRAMEWORK FOR BUSINESS TRANSACTIONS (RFBT) - Subject ID: 6
-- ============================================================================

INSERT INTO topics (subject_id, topic_code, topic_name, description, display_order, is_active) VALUES
-- Obligations and Contracts
(6, 'RFBT-1.0', 'Obligations', 'Sources, Kinds, Nature and Effects', 1, TRUE),
(6, 'RFBT-1.1', 'Extinguishment of Obligations', 'Payment, Compensation, Novation', 2, TRUE),
(6, 'RFBT-1.2', 'Contracts', 'Essential Requisites, Consent, Defective Contracts', 3, TRUE),
(6, 'RFBT-1.3', 'Sales', 'Nature, Warranties, Installment Sales', 4, TRUE),
(6, 'RFBT-1.4', 'Credit Transactions', 'Pledge, Mortgage, Chattel Mortgage', 5, TRUE),

-- Special Laws
(6, 'RFBT-2.0', 'Bouncing Checks Law - BP 22', 'Requisites, Comparison with Estafa', 6, TRUE),
(6, 'RFBT-3.0', 'Consumer Protection', 'Product Quality, Deceptive Practices, Consumer Rights', 7, TRUE),
(6, 'RFBT-4.0', 'Financial Rehabilitation and Insolvency', 'Suspension of Payments, Rehabilitation, Liquidation', 8, TRUE),
(6, 'RFBT-5.0', 'Philippine Competition Act', 'Anti-competitive Agreements, Mergers', 9, TRUE),
(6, 'RFBT-6.0', 'Government Procurement Law', 'Bidding Procedures, Alternative Methods', 10, TRUE),

-- Business Organizations
(6, 'RFBT-7.0', 'Partnership Law', 'Formation, Management, Dissolution', 11, TRUE),
(6, 'RFBT-7.1', 'Corporation Law - Formation', 'Incorporation, AOI, By-laws', 12, TRUE),
(6, 'RFBT-7.2', 'Corporation Law - Capital Structure', 'Share Classification, Subscription', 13, TRUE),
(6, 'RFBT-7.3', 'Corporation Law - Corporate Powers', 'General, Specific, Ultra Vires', 14, TRUE),
(6, 'RFBT-7.4', 'Corporation Law - Stockholders', 'Rights, Meetings, Voting', 15, TRUE),
(6, 'RFBT-7.5', 'Corporation Law - Board of Directors', 'Duties, Liabilities, Meetings', 16, TRUE),
(6, 'RFBT-7.6', 'Corporation Law - Dissolution', 'Modes, Liquidation', 17, TRUE),
(6, 'RFBT-7.7', 'Special Corporations', 'One Person Corp, Foreign Corp', 18, TRUE),
(6, 'RFBT-7.8', 'Merger and Consolidation', 'Procedures, Effects', 19, TRUE),
(6, 'RFBT-7.9', 'Securities Regulation', 'SRC Rule 68, Registration', 20, TRUE),

-- Other Business Laws
(6, 'RFBT-8.0', 'Insurance Law', 'Elements, Insurable Interest, Claims', 21, TRUE),
(6, 'RFBT-8.1', 'Cooperatives', 'Organization, Types, Dissolution', 22, TRUE),
(6, 'RFBT-8.2', 'Banking Laws', 'PDIC, Bank Secrecy, Truth in Lending', 23, TRUE),
(6, 'RFBT-8.3', 'Anti-Money Laundering Act', 'Covered Persons, Customer Due Diligence', 24, TRUE),
(6, 'RFBT-8.4', 'Intellectual Property Law', 'Patents, Trademarks, Copyright', 25, TRUE),
(6, 'RFBT-8.5', 'Data Privacy Act', 'Principles, Processing, Rights of Data Subject', 26, TRUE),
(6, 'RFBT-8.6', 'E-Commerce Act', 'Legal Recognition, Electronic Documents', 27, TRUE),
(6, 'RFBT-8.7', 'Ease of Doing Business Act', 'Citizen Charter, Streamlined Procedures', 28, TRUE),
(6, 'RFBT-8.8', 'Labor Law Standards', 'Wages, Benefits, Leaves', 29, TRUE),
(6, 'RFBT-8.9', 'Social Security Law', 'Coverage, Benefits, Contributions', 30, TRUE);

-- Verify topics count
SELECT s.subject_code, s.subject_name, COUNT(t.topic_id) as topic_count
FROM subjects s
LEFT JOIN topics t ON s.subject_id = t.subject_id
GROUP BY s.subject_id
ORDER BY s.display_order;
