const fs = require('fs');
const path = require('path');
const { v4: uuidv4 } = require('uuid');

class MCQGenerator {
    constructor() {
        this.subjects = ['FAR', 'AFAR', 'MS', 'RFBT', 'TAX', 'AUD'];
        this.difficultyLevels = ['EASY', 'MEDIUM', 'HARD'];
        this.accessLevels = ['FREE', 'BASIC', 'ADVANCE'];
        
        // Topic mappings for each subject
        this.topics = {
            FAR: [
                { id: 1, name: 'Conceptual Framework', subtopics: ['Qualitative Characteristics', 'Elements', 'Recognition'] },
                { id: 2, name: 'Cash and Financial Assets', subtopics: ['Cash Equivalents', 'Receivables', 'Investments'] },
                { id: 3, name: 'Non-financial Assets', subtopics: ['Property, Plant & Equipment', 'Intangible Assets', 'Impairment'] },
                { id: 4, name: 'Financial Liabilities', subtopics: ['Bonds Payable', 'Leases', 'Provisions'] },
                { id: 5, name: "Shareholders' Equity", subtopics: ['Share Capital', 'Retained Earnings', 'Reserves'] },
                { id: 6, name: 'Revenue', subtopics: ['PFRS 15', 'Construction Contracts', 'Franchise Fees'] },
                { id: 7, name: 'Events After Reporting Period', subtopics: ['Adjusting Events', 'Non-adjusting Events'] },
                { id: 8, name: 'Accounting Changes', subtopics: ['Changes in Accounting Policy', 'Estimates', 'Errors'] },
                { id: 9, name: 'Financial Statements', subtopics: ['Statement of Financial Position', 'Statement of Comprehensive Income', 'Statement of Cash Flows'] }
            ],
            AFAR: [
                { id: 10, name: 'Partnership Accounting', subtopics: ['Formation', 'Admission', 'Retirement', 'Liquidation'] },
                { id: 11, name: 'Branch Accounting', subtopics: ['Home Office-Branch Transactions', 'Branch Financial Statements'] },
                { id: 12, name: 'Business Combinations', subtopics: ['Goodwill', 'Non-controlling Interest', 'Consolidation'] },
                { id: 13, name: 'Revenue Recognition', subtopics: ['PFRS 15 Implementation', 'Contract Assets', 'Performance Obligations'] },
                { id: 14, name: 'Financial Instruments', subtopics: ['Classification', 'Measurement', 'Impairment', 'Hedge Accounting'] },
                { id: 15, name: 'PFRS 9 Implementation', subtopics: ['Amortized Cost', 'FVTPL', 'FVTOCI'] },
                { id: 16, name: 'Related Party Transactions', subtopics: ['Disclosures', 'Measurement'] },
                { id: 17, name: 'Consolidation', subtopics: ['Full Consolidation', 'Proportionate Consolidation', 'Equity Method'] },
                { id: 18, name: 'Foreign Currency', subtopics: ['Foreign Currency Transactions', 'Translation', 'Hedging'] },
                { id: 19, name: 'Interim Reporting', subtopics: ['PAS 34', 'Discrete vs Integral'] },
                { id: 20, name: 'Segment Reporting', subtopics: ['IFRS 8', 'Operating Segments', 'Geographical Segments'] },
                { id: 21, name: 'Earnings Per Share', subtopics: ['Basic EPS', 'Diluted EPS', 'Complex Capital Structure'] },
                { id: 22, name: 'Government Accounting', subtopics: ['NGAS', 'Fund Accounting', 'Government Financial Statements'] }
            ],
            MS: [
                { id: 23, name: 'Cost Concepts and Objectives', subtopics: ['Cost Behavior', 'Cost Classification', 'Cost Accumulation'] },
                { id: 24, name: 'CVP Analysis', subtopics: ['Break-even Analysis', 'Margin of Safety', 'Operating Leverage'] },
                { id: 25, name: 'Budgeting', subtopics: ['Master Budget', 'Flexible Budget', 'Capital Budgeting'] },
                { id: 26, name: 'Decision Making', subtopics: ['Relevant Costing', 'Make or Buy', 'Special Orders'] },
                { id: 27, name: 'Standard Costing', subtopics: ['Variance Analysis', 'Material Variances', 'Labor Variances'] },
                { id: 28, name: 'Financial Statement Analysis', subtopics: ['Ratio Analysis', 'Trend Analysis', 'Common Size'] },
                { id: 29, name: 'Working Capital Management', subtopics: ['Cash Management', 'Receivables Management', 'Inventory Management'] },
                { id: 30, name: 'Capital Budgeting', subtopics: ['NPV', 'IRR', 'Payback Period', 'ARR'] },
                { id: 31, name: 'Performance Measurement', subtopics: ['ROI', 'Residual Income', 'Balanced Scorecard'] },
                { id: 32, name: 'Quality Control', subtopics: ['Cost of Quality', 'Statistical Quality Control', 'TQM'] },
                { id: 33, name: 'Operations Research', subtopics: ['Linear Programming', 'Queuing Theory', 'Simulation'] },
                { id: 34, name: 'Business Economics', subtopics: ['Supply and Demand', 'Market Structure', 'GDP'] },
                { id: 35, name: 'Strategic Planning', subtopics: ['SWOT Analysis', 'Competitive Strategy', 'Corporate Strategy'] }
            ],
            RFBT: [
                { id: 36, name: 'Obligations and Contracts', subtopics: ['Obligations', 'Contracts', 'Damages'] },
                { id: 37, name: 'Sales', subtopics: ['Contract of Sale', 'Transfer of Ownership', 'Warranties'] },
                { id: 38, name: 'Agency', subtopics: ['Agency Relationship', 'Authority', 'Liability'] },
                { id: 39, name: 'Partnership', subtopics: ['Formation', 'Rights and Duties', 'Dissolution'] },
                { id: 40, name: 'Corporations', subtopics: ['Formation', 'Corporate Powers', 'Board of Directors'] },
                { id: 41, name: 'Negotiable Instruments', subtopics: ['Checks', 'Promissory Notes', 'Bills of Exchange'] },
                { id: 42, name: 'Insurance', subtopics: ['Insurance Contracts', 'Life Insurance', 'Property Insurance'] },
                { id: 43, name: 'Transportation', subtopics: ['Carriage of Goods', 'Common Carriers', 'Bill of Lading'] },
                { id: 44, name: 'Securities Regulation', subtopics: ['SEC Registration', 'Disclosure Requirements', 'Insider Trading'] },
                { id: 45, name: 'Intellectual Property', subtopics: ['Patents', 'Trademarks', 'Copyrights'] },
                { id: 46, name: 'Labor Law', subtopics: ['Employee Rights', 'Termination', 'Labor Standards'] },
                { id: 47, name: 'Competition Law', subtopics: ['Anti-trust', 'Monopolies', 'Unfair Competition'] },
                { id: 48, name: 'Consumer Protection', subtopics: ['Consumer Rights', 'Product Liability', 'Warranties'] },
                { id: 49, name: 'Environmental Law', subtopics: ['Environmental Compliance', 'Pollution Control', 'Corporate Responsibility'] },
                { id: 50, name: 'Data Privacy', subtopics: ['Data Protection', 'Privacy Rights', 'BIR Compliance'] },
                { id: 51, name: 'Cybercrime Law', subtopics: ['Cybercrime Prevention', 'Digital Evidence', 'Online Fraud'] },
                { id: 52, name: 'AML/CFT', subtopics: ['Anti-Money Laundering', 'Covered Transactions', 'KYC'] },
                { id: 53, name: 'Corporate Governance', subtopics: ['Board Responsibilities', 'Shareholder Rights', 'Ethics'] },
                { id: 54, name: 'Business Ethics', subtopics: ['Code of Conduct', 'Conflict of Interest', 'Corporate Social Responsibility'] },
                { id: 55, name: 'International Business Law', subtopics: ['International Contracts', 'Trade Law', 'Investment Law'] },
                { id: 56, name: 'E-commerce Law', subtopics: ['Electronic Contracts', 'Digital Signatures', 'Online Transactions'] },
                { id: 57, name: 'Banking Law', subtopics: ['Bank Operations', 'Loans and Credit', 'Bank Secrecy'] },
                { id: 58, name: 'Alternative Dispute Resolution', subtopics: ['Arbitration', 'Mediation', 'Conciliation'] }
            ],
            TAX: [
                { id: 59, name: 'Tax Principles', subtopics: ['Taxation Power', 'Tax Base', 'Tax Rates'] },
                { id: 60, name: 'Remedies and Prescriptions', subtopics: ['Assessment', 'Collection', 'Prescription Period'] },
                { id: 61, name: 'Income Taxation', subtopics: ['Corporate Income Tax', 'Individual Income Tax', 'Withholding Tax'] },
                { id: 62, name: 'Transfer Taxes', subtopics: ['Estate Tax', 'Donor\'s Tax', 'Capital Gains Tax'] },
                { id: 63, name: 'VAT', subtopics: ['VAT Registration', 'VAT Returns', 'Input VAT', 'Output VAT'] },
                { id: 64, name: 'Excise Taxes', subtopics: ['Petroleum Products', 'Alcohol', 'Tobacco', 'Automobiles'] },
                { id: 65, name: 'Percentage Taxes', subtopics: ['Common Carrier Tax', 'Amusement Tax', 'Professional Tax'] },
                { id: 66, name: 'Documentary Stamp Tax', subtopics: ['DST on Instruments', 'DST Rates', 'DST Exemptions'] },
                { id: 67, name: 'Local Taxation', subtopics: ['Real Property Tax', 'Business Tax', 'Community Tax'] }
            ],
            AUD: [
                { id: 68, name: 'Audit Fundamentals', subtopics: ['Audit Objectives', 'Assertions', 'Professional Skepticism'] },
                { id: 69, name: 'Professional Ethics', subtopics: ['Independence', 'Confidentiality', 'Integrity'] },
                { id: 70, name: 'Audit Planning', subtopics: ['Risk Assessment', 'Materiality', 'Audit Strategy'] },
                { id: 71, name: 'Audit Evidence', subtopics: ['Procedures', 'Documentation', 'Sufficiency'] },
                { id: 72, name: 'Internal Control', subtopics: ['Control Environment', 'Risk Assessment', 'Control Activities'] },
                { id: 73, name: 'Audit Reports', subtopics: ['Unmodified Opinion', 'Qualified Opinion', 'Adverse Opinion'] },
                { id: 74, name: 'Audit Sampling', subtopics: ['Statistical Sampling', 'Non-statistical Sampling', 'Risk Assessment'] },
                { id: 75, name: 'Computer Auditing', subtopics: ['CAATs', 'IT Controls', 'Data Analytics'] },
                { id: 76, name: 'Forensic Accounting', subtopics: ['Fraud Detection', 'Investigation', 'Litigation Support'] },
                { id: 77, name: 'Audit Risk', subtopics: ['Inherent Risk', 'Control Risk', 'Detection Risk'] },
                { id: 78, name: 'Quality Control', subtopics: ['Firm Quality Control', 'Engagement Quality Control', 'Review'] },
                { id: 79, name: 'Government Auditing', subtopics: ['COA Audits', 'Performance Audits', 'Compliance Audits'] }
            ]
        };

        // Content templates for generating realistic MCQs
        this.contentTemplates = this.loadContentTemplates();
    }

    loadContentTemplates() {
        return {
            FAR: {
                concepts: [
                    'qualitative characteristics', 'faithful representation', 'relevance', 'comparability', 'verifiability',
                    'cash equivalents', 'present value', 'fair value', 'amortized cost', 'impairment loss',
                    'depreciation', 'depletion', 'amortization', 'recoverable amount', 'carrying amount',
                    'effective interest method', 'straight-line method', 'declining balance', 'units of production',
                    'contingent liability', 'provision', 'constructive obligation', 'legal obligation', 'present obligation',
                    'share premium', 'share capital', 'retained earnings', 'other comprehensive income', 'accumulated losses',
                    'performance obligation', 'contract asset', 'contract liability', 'transaction price', 'variable consideration',
                    'adjusting event', 'non-adjusting event', 'subsequent event', 'authorization date', 'reporting date',
                    'cumulative effect', 'retrospective application', 'prospective application', 'change in estimate', 'change in accounting policy'
                ],
                standards: ['PAS 1', 'PAS 2', 'PAS 7', 'PAS 8', 'PAS 10', 'PAS 12', 'PAS 16', 'PAS 18', 'PAS 19', 'PAS 20', 'PAS 24', 'PAS 33', 'PAS 34', 'PAS 36', 'PAS 37', 'PAS 38', 'PFRS 9', 'PFRS 15', 'PFRS 16'],
                scenarios: [
                    'ABC Company acquired equipment', 'XYZ Corporation issued bonds', 'LMN Enterprises recognized revenue',
                    'QRS Inc. has a contingent liability', 'TUV Partnership needs to record depreciation', 'WXY Corp. is preparing financial statements',
                    'A small business owner is calculating', 'An audit client reported', 'A publicly listed entity disclosed',
                    'During the year-end assessment', 'In the preparation of the statement', 'For the interim reporting period'
                ]
            },
            AFAR: {
                concepts: [
                    'partnership formation', 'admission of partner', 'retirement of partner', 'partnership liquidation', 'bonus method',
                    'home office accounting', 'branch accounting', 'reciprocal accounts', 'intracompany transactions', 'consolidated statements',
                    'business combination', 'goodwill', 'bargain purchase', 'non-controlling interest', 'acquisition method',
                    'financial asset classification', 'amortized cost', 'fair value through OCI', 'fair value through profit or loss', 'expected credit losses',
                    'related party transaction', 'disclosure requirements', 'arm\'s length transaction', 'control', 'significant influence',
                    'full consolidation', 'equity method', 'proportionate consolidation', 'investment entity', 'subsidiary',
                    'foreign currency transaction', 'translation adjustment', 'functional currency', 'reporting currency', 'hedge accounting',
                    'interim financial statements', 'discrete view', 'integral view', 'seasonality', 'temporary earnings',
                    'operating segment', 'geographical segment', 'business segment', 'segment assets', 'segment liabilities',
                    'basic earnings per share', 'diluted earnings per share', 'potential ordinary shares', 'stock options', 'convertible securities',
                    'national government accounting system', 'fund accounting', 'appropriation', 'allotment', 'obligation'
                ],
                standards: ['PFRS 3', 'PFRS 10', 'PFRS 12', 'PFRS 15', 'PFRS 16', 'PFRS 9', 'PAS 24', 'PAS 27', 'PAS 28', 'PAS 34', 'PAS 110', 'PAS 112', 'NGAS'],
                scenarios: [
                    'A partnership was formed by', 'During the admission of a new partner', 'When a partner retired from the firm',
                    'The home office recorded', 'The branch prepared', 'In the consolidation worksheet',
                    'Parent Company acquired', 'The business combination resulted in', 'Non-controlling interest was calculated as',
                    'The financial asset was classified as', 'Expected credit losses were measured using', 'The effective interest rate was',
                    'Related party disclosures included', 'The transaction was not at arm\'s length', 'Control was determined based on',
                    'The subsidiary was consolidated using', 'Equity method was applied because', 'Translation adjustments arose from',
                    'Interim reporting required', 'Segment revenue included', 'Basic EPS was calculated as'
                ]
            },
            MS: {
                concepts: [
                    'variable cost', 'fixed cost', 'mixed cost', 'step cost', 'relevant cost', 'sunk cost', 'opportunity cost',
                    'contribution margin', 'break-even point', 'margin of safety', 'operating leverage', 'financial leverage',
                    'master budget', 'flexible budget', 'static budget', 'capital budget', 'operating budget', 'cash budget',
                    'make-or-buy decision', 'special order decision', 'keep-or-drop decision', 'sell-or-process further', 'outsourcing decision',
                    'standard cost', 'variance analysis', 'material price variance', 'material quantity variance', 'labor rate variance', 'labor efficiency variance',
                    'liquidity ratios', 'solvency ratios', 'profitability ratios', 'activity ratios', 'market ratios', 'DuPont analysis',
                    'working capital', 'cash conversion cycle', 'inventory turnover', 'receivables turnover', 'payables turnover',
                    'net present value', 'internal rate of return', 'payback period', 'accounting rate of return', 'profitability index',
                    'return on investment', 'residual income', 'economic value added', 'balanced scorecard', 'key performance indicators',
                    'cost of quality', 'prevention costs', 'appraisal costs', 'internal failure costs', 'external failure costs',
                    'linear programming', 'queuing theory', 'simulation', 'decision tree analysis', 'sensitivity analysis',
                    'gross domestic product', 'inflation rate', 'unemployment rate', 'interest rates', 'exchange rates',
                    'SWOT analysis', 'Porter\'s five forces', 'competitive advantage', 'core competency', 'value chain'
                ],
                standards: ['Managerial Accounting Standards', 'Cost Accounting Standards', 'Budgeting and Planning', 'Performance Measurement'],
                scenarios: [
                    'A manufacturing company produces', 'The cost behavior analysis showed', 'In the break-even calculation',
                    'The budget preparation included', 'Management is considering a', 'The variance analysis revealed',
                    'Financial statement analysis indicated', 'The working capital management involved', 'Capital budgeting techniques included',
                    'Performance measurement used', 'Quality costs were classified as', 'Operations research techniques applied',
                    'Economic analysis considered', 'Strategic planning involved', 'The decision analysis required'
                ]
            },
            RFBT: {
                concepts: [
                    'juridical necessity', 'give, to do, or not to do', 'specific obligation', 'generic obligation', 'alternative obligation', 'facultative obligation',
                    'contract of sale', 'transfer of ownership', 'warranty against hidden defects', 'warranty of title', 'right of redemption',
                    'agency relationship', 'actual authority', 'apparent authority', 'ratification', 'agency by estoppel',
                    'universal partnership', 'particular partnership', 'partnership property', 'industrial partner', 'capitalist partner',
                    'corporate powers', 'ultra vires acts', 'board of directors', 'stockholders', 'corporate officers',
                    'negotiable instrument', 'holder in due course', 'presentment for payment', 'dishonored check', 'crossed check',
                    'insurance contract', 'insurable interest', 'utmost good faith', 'subrogation', 'indemnity',
                    'common carrier', 'bill of lading', 'carrier\'s liability', 'force majeure', 'act of God',
                    'SEC registration', 'prospectus requirement', 'insider trading', 'tender offer', 'proxy solicitation',
                    'patent infringement', 'trademark dilution', 'copyright violation', 'trade secret', 'intellectual property',
                    'just causes for dismissal', 'separation pay', 'illegal dismissal', 'constructive dismissal', 'labor standards',
                    'anti-trust violation', 'monopolistic practice', 'restraint of trade', 'price fixing', 'market allocation',
                    'consumer rights', 'product liability', 'implied warranty', 'deceptive trade practices', 'unfair competition',
                    'environmental compliance', 'pollution control', 'corporate social responsibility', 'sustainable development', 'green accounting',
                    'data privacy', 'personal information', 'consent', 'data breach', 'privacy policy',
                    'cybercrime prevention', 'digital evidence', 'online fraud', 'identity theft', 'cybersecurity',
                    'covered transaction', 'suspicious transaction', 'KYC requirements', 'AML compliance', 'beneficial ownership',
                    'board responsibilities', 'fiduciary duties', 'conflict of interest', 'related party transactions', 'corporate governance',
                    'code of conduct', 'business ethics', 'professional integrity', 'moral responsibility', 'ethical decision-making',
                    'international contracts', 'choice of law', 'dispute resolution', 'trade barriers', 'investment protection',
                    'electronic contracts', 'digital signatures', 'online transactions', 'e-commerce regulations', 'cyber transactions',
                    'bank secrecy', 'deposit insurance', 'loan documentation', 'credit investigation', 'banking regulations',
                    'arbitration agreement', 'mediation process', 'conciliation meeting', 'alternative dispute resolution', 'court litigation'
                ],
                scenarios: [
                    'Under the Civil Code', 'According to the Corporation Code', 'The Supreme Court ruled that',
                    'In the case of', 'The legal principle states that', 'Jurisprudence establishes that',
                    'The contract stipulates that', 'The law requires that', 'The regulation provides that',
                    'The legal consequence is', 'The liability arises from', 'The obligation is extinguished when',
                    'The court may order', 'The parties may agree to', 'The remedy available is',
                    'The prescriptive period is', 'The cause of action accrues when', 'The jurisdiction is proper because'
                ]
            },
            TAX: {
                concepts: [
                    'inherent power of taxation', 'legislative power', 'non-delegable power', 'revenue purpose', 'public purpose',
                    'assessment of taxes', 'collection of taxes', 'prescriptive period', 'tax refund', 'tax compromise',
                    'corporate income tax', 'individual income tax', 'progressive tax rates', 'taxable income', 'gross income',
                    'estate tax', 'donor\'s tax', 'capital gains tax', 'documentary stamp tax', 'transfer tax',
                    'VAT registration', 'VAT return', 'input VAT', 'output VAT', 'VAT-exempt transactions',
                    'excise tax on petroleum', 'excise tax on alcohol', 'excise tax on tobacco', 'excise tax on automobiles', 'specific tax',
                    'percentage tax on common carriers', 'percentage tax on amusements', 'professional tax', 'business tax', 'local taxes',
                    'real property tax', 'community tax', 'business permit', 'zonal valuation', 'market value',
                    'tax exemption', 'tax credit', 'tax deduction', 'tax incentive', 'tax holiday',
                    'tax avoidance', 'tax evasion', 'tax fraud', 'criminal liability', 'civil liability',
                    'BIR authority', 'tax audit', 'tax investigation', 'letter of authority', 'tax assessment notice'
                ],
                scenarios: [
                    'Under the National Internal Revenue Code', 'The TRAIN Law provides that', 'The CREATE Law reduced',
                    'According to BIR regulations', 'The tax rule states that', 'Revenue issuances provide that',
                    'The taxpayer is required to', 'The tax liability is computed as', 'The tax base includes',
                    'The tax return must be filed', 'The tax payment is due on', 'The tax assessment covers',
                    'The prescriptive period begins', 'The tax exemption applies to', 'The tax credit is available for',
                    'The BIR may assess', 'The taxpayer may claim', 'The tax court has jurisdiction over'
                ]
            },
            AUD: {
                concepts: [
                    'audit objectives', 'financial statement assertions', 'professional skepticism', 'due care', 'professional competence',
                    'audit independence', 'integrity', 'objectivity', 'confidentiality', 'professional behavior',
                    'audit planning', 'risk assessment', 'materiality', 'audit risk', 'audit strategy',
                    'audit evidence', 'sufficient appropriate evidence', 'audit procedures', 'audit documentation', 'working papers',
                    'internal control', 'control environment', 'risk assessment', 'control activities', 'information and communication',
                    'unmodified opinion', 'qualified opinion', 'adverse opinion', 'disclaimer of opinion', 'emphasis of matter',
                    'audit sampling', 'statistical sampling', 'non-statistical sampling', 'sampling risk', 'sampling error',
                    'computer-assisted audit techniques', 'IT controls', 'general controls', 'application controls', 'data analytics',
                    'fraud risk', 'fraud triangle', 'fraud detection', 'fraud investigation', 'forensic accounting',
                    'inherent risk', 'control risk', 'detection risk', 'audit risk model', 'risk of material misstatement',
                    'quality control policies', 'engagement quality control review', 'peer review', 'inspection', 'monitoring',
                    'government auditing', 'performance audit', 'compliance audit', 'financial audit', 'COA audit'
                ],
                scenarios: [
                    'Under Philippine Standards on Auditing', 'The auditor must consider', 'Audit procedures should include',
                    'The audit risk assessment identified', 'Materiality was set at', 'The audit plan addressed',
                    'Audit evidence was obtained through', 'The working papers documented', 'The audit report expressed',
                    'Internal control weaknesses were', 'The fraud risk assessment considered', 'Professional skepticism required',
                    'The auditor concluded that', 'Audit findings indicated', 'Management representations included',
                    'The quality control review ensured', 'Peer review findings addressed', 'The engagement team demonstrated'
                ]
            }
        };
    }

    generateQuestionCode(subject, topic, difficulty, questionNumber) {
        const subjectCode = subject;
        const topicCode = topic.toString().padStart(2, '0');
        const difficultyCode = difficulty.charAt(0);
        const questionNum = questionNumber.toString().padStart(3, '0');
        
        return `${subjectCode}-${topicCode}-${questionNum}-${difficultyCode}`;
    }

    generateMCQ(subject, topicId, difficulty, accessLevel = 'FREE') {
        const topic = this.topics[subject].find(t => t.id === topicId);
        const templates = this.contentTemplates[subject];
        
        // Select random concept and scenario
        const concept = templates.concepts[Math.floor(Math.random() * templates.concepts.length)];
        const scenario = templates.scenarios[Math.floor(Math.random() * templates.scenarios.length)];
        const standard = templates.standards && templates.standards.length > 0 
            ? templates.standards[Math.floor(Math.random() * templates.standards.length)]
            : 'applicable Philippine standards';
        
        // Generate question based on difficulty
        let questionText, choices, correctAnswer, explanation;
        
        switch (difficulty) {
            case 'EASY':
                questionText = `Which of the following statements about ${concept} is correct?`;
                choices = this.generateEasyChoices(subject, concept, standard);
                break;
            case 'MEDIUM':
                questionText = `${scenario} ${concept}. What is the proper accounting treatment under ${standard}?`;
                choices = this.generateMediumChoices(subject, concept, standard);
                break;
            case 'HARD':
                questionText = `${scenario} involving ${concept} and multiple considerations. Compute the required amounts and prepare the necessary disclosures in accordance with ${standard} and related standards.`;
                choices = this.generateHardChoices(subject, concept, standard);
                break;
        }
        
        correctAnswer = choices.find(c => c.is_correct).label;
        
        // Generate comprehensive explanation
        explanation = this.generateExplanation(subject, concept, standard, choices, correctAnswer);
        
        // Generate memory tip
        const memoryTip = this.generateMemoryTip(subject, concept, standard);
        
        // Generate layman story
        const laymanStory = this.generateLaymanStory(subject, concept, scenario);
        
        return {
            question_code: this.generateQuestionCode(subject, topicId, difficulty, Math.floor(Math.random() * 1000)),
            subject: subject,
            topic: topic.name,
            subtopic: topic.subtopics[Math.floor(Math.random() * topic.subtopics.length)],
            difficulty_level: difficulty,
            access_level: accessLevel,
            question_text: questionText,
            choices: choices,
            correct_answer: correctAnswer,
            short_explanation: explanation.short,
            detailed_explanation: explanation.detailed,
            why_wrong_choices: explanation.whyWrong,
            memory_tip: memoryTip,
            legal_reference: standard,
            layman_story: laymanStory,
            tags: [subject.toLowerCase(), concept.toLowerCase().replace(/\s+/g, '-'), 'cpale', 'philippines'],
            standards_reference: [standard]
        };
    }

    generateEasyChoices(subject, concept, standard) {
        const correctChoice = {
            label: 'C',
            text: `The correct treatment of ${concept} as specified in ${standard}`,
            is_correct: true
        };
        
        const incorrectChoices = [
            {
                label: 'A',
                text: `An incorrect approach that violates ${standard}`,
                is_correct: false
            },
            {
                label: 'B',
                text: `A common misconception about ${concept}`,
                is_correct: false
            },
            {
                label: 'D',
                text: `An outdated treatment no longer accepted under ${standard}`,
                is_correct: false
            }
        ];
        
        // Shuffle choices
        const allChoices = [correctChoice, ...incorrectChoices];
        return this.shuffleChoices(allChoices);
    }

    generateMediumChoices(subject, concept, standard) {
        const correctChoice = {
            label: 'B',
            text: `Apply the ${concept} principles using the correct method under ${standard}`,
            is_correct: true
        };
        
        const incorrectChoices = [
            {
                label: 'A',
                text: `Use an incorrect calculation method that violates ${standard}`,
                is_correct: false
            },
            {
                label: 'C',
                text: `Ignore a critical requirement of ${standard}`,
                is_correct: false
            },
            {
                label: 'D',
                text: `Provide a partial answer that misses important considerations`,
                is_correct: false
            }
        ];
        
        const allChoices = [correctChoice, ...incorrectChoices];
        return this.shuffleChoices(allChoices);
    }

    generateHardChoices(subject, concept, standard) {
        const correctChoice = {
            label: 'D',
            text: `The comprehensive solution addressing all aspects of ${concept} under ${standard} and related standards`,
            is_correct: true
        };
        
        const incorrectChoices = [
            {
                label: 'A',
                text: `A solution that only addresses some aspects and ignores others`,
                is_correct: false
            },
            {
                label: 'B',
                text: `An approach that violates fundamental principles of ${standard}`,
                is_correct: false
            },
            {
                label: 'C',
                text: `A solution with calculation errors and incorrect applications`,
                is_correct: false
            }
        ];
        
        const allChoices = [correctChoice, ...incorrectChoices];
        return this.shuffleChoices(allChoices);
    }

    shuffleChoices(choices) {
        const shuffled = [...choices].sort(() => Math.random() - 0.5);
        // Reassign labels A, B, C, D
        return shuffled.map((choice, index) => ({
            ...choice,
            label: String.fromCharCode(65 + index) // A, B, C, D
        }));
    }

    generateExplanation(subject, concept, standard, choices, correctAnswer) {
        const correctChoice = choices.find(c => c.label === correctAnswer);
        const incorrectChoices = choices.filter(c => c.label !== correctAnswer);
        
        return {
            short: `The correct answer follows the principles of ${concept} as outlined in ${standard}.`,
            detailed: `Under ${standard}, ${concept} must be handled in accordance with the established principles. The correct approach ensures compliance with both Philippine standards and international best practices. This treatment is consistent with the requirements and provides reliable financial information.`,
            whyWrong: incorrectChoices.reduce((acc, choice) => {
                acc[choice.label] = `This choice is incorrect because it fails to properly apply the principles of ${concept} under ${standard}.`;
                return acc;
            }, {})
        };
    }

    generateMemoryTip(subject, concept, standard) {
        const acronyms = {
            'qualitative characteristics': 'RELEVANCE + FAITHFUL REPRESENTATION',
            'cash equivalents': '3 MONTHS or less maturity',
            'depreciation': 'COST - SALVAGE / USEFUL LIFE',
            'break-even point': 'FIXED COSTS / CONTRIBUTION MARGIN',
            'audit risk': 'IR x CR x DR',
            'alternative obligation': 'MANY things due, deliver ONE',
            'facultative obligation': 'ONE thing due, may substitute'
        };
        
        const baseTip = acronyms[concept.toLowerCase()] || `${concept.toUpperCase()} = KEY PRINCIPLE`;
        return `CPALE Trigger: ${baseTip}`;
    }

    generateLaymanStory(subject, concept, scenario) {
        return `Imagine a small business owner trying to understand how to properly handle ${concept} in their financial records. ${scenario} The correct approach would be to follow the established principles and ensure compliance with applicable standards.`;
    }

    generateBatchMCQs(subject, countPerDifficulty, accessLevel = 'FREE') {
        const batch = [];
        const topics = this.topics[subject];
        
        for (const difficulty of this.difficultyLevels) {
            const count = countPerDifficulty[difficulty] || 0;
            
            for (let i = 0; i < count; i++) {
                // Randomly select a topic
                const topicId = topics[Math.floor(Math.random() * topics.length)].id;
                
                // Generate MCQ
                const mcq = this.generateMCQ(subject, topicId, difficulty, accessLevel);
                batch.push(mcq);
            }
        }
        
        return batch;
    }

    generateAllSubjectsMCQs() {
        const allMCQs = {};
        
        // Target distribution for 10,000+ MCQs
        const distribution = {
            FAR: { EASY: 800, MEDIUM: 800, HARD: 400 },      // 2,000 total
            AFAR: { EASY: 800, MEDIUM: 800, HARD: 400 },     // 2,000 total
            MS: { EASY: 600, MEDIUM: 600, HARD: 300 },       // 1,500 total
            RFBT: { EASY: 600, MEDIUM: 600, HARD: 300 },     // 1,500 total
            TAX: { EASY: 600, MEDIUM: 600, HARD: 300 },       // 1,500 total
            AUD: { EASY: 400, MEDIUM: 400, HARD: 200 }       // 1,000 total
        };
        
        // Generate FREE questions (50 per subject = 300 total)
        for (const subject of this.subjects) {
            allMCQs[subject] = {
                FREE: this.generateBatchMCQs(subject, { EASY: 20, MEDIUM: 20, HARD: 10 }, 'FREE'),
                BASIC: [],
                ADVANCE: []
            };
        }
        
        // Generate BASIC and ADVANCE questions
        for (const subject of this.subjects) {
            const subjectDistribution = distribution[subject];
            
            // BASIC questions (25% of total)
            const basicDistribution = {};
            for (const difficulty of this.difficultyLevels) {
                basicDistribution[difficulty] = Math.floor(subjectDistribution[difficulty] * 0.25);
            }
            allMCQs[subject].BASIC = this.generateBatchMCQs(subject, basicDistribution, 'BASIC');
            
            // ADVANCE questions (75% of total)
            const advanceDistribution = {};
            for (const difficulty of this.difficultyLevels) {
                advanceDistribution[difficulty] = Math.floor(subjectDistribution[difficulty] * 0.75);
            }
            allMCQs[subject].ADVANCE = this.generateBatchMCQs(subject, advanceDistribution, 'ADVANCE');
        }
        
        return allMCQs;
    }

    saveToJSON(mcqs, filename) {
        const filePath = path.join(__dirname, '..', 'data', filename);
        const dir = path.dirname(filePath);
        
        // Create directory if it doesn't exist
        if (!fs.existsSync(dir)) {
            fs.mkdirSync(dir, { recursive: true });
        }
        
        fs.writeFileSync(filePath, JSON.stringify(mcqs, null, 2));
        console.log(`Saved ${Object.keys(mcqs).length} subjects to ${filename}`);
    }

    generateSQLInserts(mcqs) {
        let sql = '';
        
        for (const [subject, accessLevels] of Object.entries(mcqs)) {
            for (const [accessLevel, questions] of Object.entries(accessLevels)) {
                for (const question of questions) {
                    // Insert question
                    sql += `INSERT INTO questions (question_code, topic_id, question_text, difficulty_level, access_level) VALUES\n`;
                    sql += `('${question.question_code}', '${question.topic_id || 1}', '${question.question_text.replace(/'/g, "\\'")}', '${question.difficulty_level}', '${question.access_level}');\n\n`;
                    
                    // Insert choices
                    sql += `SET @last_question_id = LAST_INSERT_ID();\n`;
                    for (const choice of question.choices) {
                        sql += `INSERT INTO question_choices (question_id, choice_label, choice_text, is_correct, display_order) VALUES\n`;
                        sql += `(@last_question_id, '${choice.label}', '${choice.text.replace(/'/g, "\\'")}', ${choice.is_correct}, ${choice.label.charCodeAt(0) - 64});\n`;
                    }
                    sql += '\n';
                    
                    // Insert explanation
                    sql += `INSERT INTO question_explanations (question_id, short_explanation, exam_explanation, why_wrong_choices, memory_tip, legal_reference) VALUES\n`;
                    sql += `(@last_question_id, '${question.short_explanation.replace(/'/g, "\\'")}', '${question.detailed_explanation.replace(/'/g, "\\'")}', '${JSON.stringify(question.why_wrong_choices).replace(/'/g, "\\'")}', '${question.memory_tip.replace(/'/g, "\\'")}', '${question.legal_reference}');\n\n`;
                }
            }
        }
        
        return sql;
    }

    saveToSQL(mcqs, filename) {
        const filePath = path.join(__dirname, '..', 'database', filename);
        const dir = path.dirname(filePath);
        
        if (!fs.existsSync(dir)) {
            fs.mkdirSync(dir, { recursive: true });
        }
        
        const sql = this.generateSQLInserts(mcqs);
        fs.writeFileSync(filePath, sql);
        console.log(`Saved SQL inserts to ${filename}`);
    }
}

module.exports = MCQGenerator;