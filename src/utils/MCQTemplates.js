const MCQTemplates = {
  FAR: {
    Easy: {
      questionTemplates: [
        "Which of the following is {concept} under {standard}?",
        "What is the proper {treatment} for {item} according to {standard}?",
        "Which {element} is {requirement} under {standard}?",
        "How should {transaction} be recorded in accordance with {standard}?"
      ],
      choiceTemplates: {
        correct: [
          "{correct_answer} as specified in {standard}",
          "{correct_answer} according to Philippine standards",
          "The {correct_treatment} is required under {standard}"
        ],
        incorrect: [
          "{distractor1} which violates {standard}",
          "{distractor2} which is inconsistent with IFRS",
          "{distractor3} which ignores {key_concept}",
          "{distractor4} which represents outdated practice"
        ]
      },
      memoryTriggers: [
        "{CONCEPT} = {KEY_PRINCIPLE}",
        "REMEMBER: {ACRONYM} = {EXPLANATION}",
        "{STANDARD} = {CORE_RULE}"
      ],
      laymanStories: [
        "Imagine a {scenario} where you need to {action}. The correct approach is to {correct_approach}.",
        "Think of {concept} like a {everyday_analogy}. Just as {analogy_explanation}, accounting standards require {accounting_requirement}."
      ]
    },
    Medium: {
      questionTemplates: [
        "Given the following data: {data}. What is the {calculation} under {standard}?",
        "{company} reported {financial_data}. How should {item} be presented in the {statement}?",
        "Under {standard}, when {condition} occurs, what is the {treatment}?",
        "Calculate the {ratio} given: {data}. Is this {compliance} with {standard}?"
      ],
      choiceTemplates: {
        correct: [
          "{calculation_result} computed using correct {method}",
          "{presentation_format} as required by {standard}",
          "{treatment} based on {conditions} in {standard}"
        ],
        incorrect: [
          "{wrong_result} using incorrect {method}",
          "{wrong_presentation} violating disclosure requirements",
          "{wrong_treatment} ignoring {critical_factor}",
          "{partial_answer} missing {required_adjustment}"
        ]
      },
      memoryTriggers: [
        "{CALCULATION} = {FORMULA}",
        "{STANDARD} REQUIRES = {REQUIREMENT}",
        "WHEN {CONDITION} THEN {TREATMENT}"
      ]
    },
    Difficult: {
      questionTemplates: [
        "{company} acquired {asset_details}. The {transaction_details}. Compute the {complex_calculation} and prepare the {disclosure} required by {standard} and {related_standards}.",
        "Given the {complex_scenario} with {multiple_conditions}, what is the {comprehensive_treatment} under {standard} considering {additional_factors}?",
        "Analyze the {complex_situation} and determine the {complex_judgment} required by {standard} and {interpretations}.",
        "{multinational_entity} with {complex_operations}. Prepare the {complex_disclosures} in accordance with {standard} and {regulatory_requirements}."
      ]
    },
    Tricky: {
      questionTemplates: [
        "All of the following are true regarding {concept} EXCEPT:",
        "Which of the following statements about {topic} is NOT correct?",
        "Under which condition would the {usual_treatment} be {inappropriate} according to {standard}?",
        "Identify the {misconception} in the following scenario: {tricky_scenario}."
      ]
    }
  },

  AFAR: {
    Easy: {
      questionTemplates: [
        "In a {partnership_type}, how are {profits_losses} allocated?",
        "What is the {entry} when {partner_contribution} is made?",
        "How is {partnership_item} treated in the books?",
        "When {partnership_event} occurs, what is the {accounting_treatment}?"
      ],
      memoryTriggers: [
        "PARTNERSHIP = {SHARE_IN_PROFIT_LOSS}",
        "CONTRIBUTION = {CAPITAL_ACCOUNT}",
        "ALLOCATION = {AGREEMENT_TERMS}"
      ]
    },
    Medium: {
      questionTemplates: [
        "{partnership_name} has {partners}. The {agreement_terms}. Given the {financial_data}, compute {allocations} and prepare {financial_statements}.",
        "Under {business_combination_type}, the {acquisition_details}. Calculate the {goodwill} and {non_controlling_interest} using {method}.",
        "{branch_details}. The home office uses {accounting_method}. Prepare the {consolidated_entries} for {transactions}."
      ]
    },
    Difficult: {
      questionTemplates: [
        "{complex_partnership} with {multiple_issues}. Prepare the {comprehensive_adjustments} and {final_entries} considering {legal_requirements} and {tax_implications}.",
        "{complex_acquisition} with {contingent_payments} and {earnout}. Compute the {allocation} and {subsequent_measurements} under {standard} and {interpretations}.",
        "{multinational_corp} with {foreign_operations}. Prepare the {translation_entries} and {consolidated_statements} under {multiple_standards}."
      ]
    }
  },

  MS: {
    Easy: {
      questionTemplates: [
        "What is the {purpose} of {management_concept}?",
        "Which {tool} is used for {business_purpose}?",
        "How does {technique} help in {decision}?",
        "What is the {formula} for {calculation}?"
      ],
      memoryTriggers: [
        "{CONCEPT} = {BUSINESS_PURPOSE}",
        "{TOOL} = {APPLICATION}",
        "{FORMULA} = {COMPONENTS}"
      ]
    },
    Medium: {
      questionTemplates: [
        "Given {business_scenario}, compute the {metric} using {method}.",
        "{company} has {data_points}. What is the {analysis_result}?",
        "Using {technique}, analyze the {business_situation} and recommend {action}.",
        "Calculate the {financial_ratio} and interpret the {business_implication}."
      ]
    },
    Difficult: {
      questionTemplates: [
        "{complex_business} with {multiple_factors}. Perform {comprehensive_analysis} using {advanced_techniques} and provide {strategic_recommendations}.",
        "Given {complex_data}, optimize the {resource_allocation} using {quantitative_methods} and {qualitative_considerations}.",
        "{company_case} requires {strategic_decision}. Prepare the {cost_benefit_analysis} and {risk_assessment}."
      ]
    }
  },

  RFBT: {
    Easy: {
      questionTemplates: [
        "What is the {legal_requirement} for {business_situation}?",
        "Under {law}, what is the {compliance_requirement}?",
        "Which {document} is required for {legal_action}?",
        "What is the {penalty} for {violation}?"
      ],
      memoryTriggers: [
        "{LAW} = {KEY_PROVISION}",
        "{REQUIREMENT} = {LEGAL_MANDATE}",
        "{PENALTY} = {CONSEQUENCE}"
      ]
    },
    Medium: {
      questionTemplates: [
        "{entity} wants to {business_action}. What are the {legal_requirements} under {applicable_laws}?",
        "Given {legal_scenario}, what is the {legal_consequence} and {proper_response}?",
        "Under {specific_law}, what are the {rights_and_obligations} of the {parties}?",
        "What {procedures} must be followed for {legal_process} under {multiple_laws}?"
      ]
    },
    Difficult: {
      questionTemplates: [
        "{complex_legal_situation} involving {multiple_jurisdictions} and {conflicting_laws}. Analyze the {legal_hierarchy} and determine the {proper_venue} and {applicable_rules}.",
        "{corporate_restructuring} with {regulatory_approvals}. What are the {disclosure_requirements} and {shareholder_protections} under {corporate_code} and {securities_laws}?",
        "{cross_border_transaction} with {tax_implications} and {exchange_controls}. Structure the {legal_compliance} framework."
      ]
    },
    Tricky: {
      questionTemplates: [
        "Which of the following {legal_actions} is {NOT} valid under {law}?",
        "All of the following are {requirements} EXCEPT:",
        "Under which circumstance would the {general_rule} NOT apply?",
        "Identify the {legal_exception} in the following {complex_scenario}."
      ]
    }
  },

  TAX: {
    Easy: {
      questionTemplates: [
        "What is the {tax_rate} for {income_type}?",
        "Which {deduction} is allowed for {tax_payer}?",
        "When is {tax_filing} due?",
        "What is the {tax_base} for {tax_type}?"
      ],
      memoryTriggers: [
        "{TAX_TYPE} = {RATE_PERCENTAGE}",
        "{DEDUCTION} = {REQUIREMENT}",
        "{FILING} = {DEADLINE}"
      ]
    },
    Medium: {
      questionTemplates: [
        "Given {taxpayer_situation}, compute the {tax_liability} using {applicable_law}.",
        "{taxable_entity} has {income_sources}. Calculate the {total_tax} considering {exemptions} and {credits}.",
        "What are the {tax_implications} of {transaction_type} under {tax_code}?",
        "Compute the {tax_withholding} on {payment_type} given the {conditions}."
      ]
    },
    Difficult: {
      questionTemplates: [
        "{complex_taxpayer} with {multiple_income_types} and {international_operations}. Prepare the {comprehensive_tax_return} under {tax_treaties} and {anti_avoidance_rules}.",
        "{tax_restructuring} with {tax_consequences}. Optimize the {tax_position} within {legal_limits} and {risk_tolerance}.",
        "{multinational_group} with {transfer_pricing} and {profit_allocation}. Prepare the {tax_documentation} for {audit_defense}."
      ]
    }
  },

  AUD: {
    Easy: {
      questionTemplates: [
        "What is the {audit_procedure} for {assertion}?",
        "Which {evidence} is sufficient for {audit_objective}?",
        "When should {audit_action} be performed?",
        "What is the {audit_risk} associated with {situation}?"
      ],
      memoryTriggers: [
        "{PROCEDURE} = {ASSERTION}",
        "{EVIDENCE} = {SUFFICIENCY}",
        "{RISK} = {MITIGATION}"
      ]
    },
    Medium: {
      questionTemplates: [
        "Given the {client_situation}, what {audit_procedures} should be performed to address {identified_risks}?",
        "{audit_scenario}. What is the {appropriate_response} under {auditing_standards}?",
        "How should the {audit_finding} be communicated to {stakeholders}?",
        "Assess the {internal_control_system} and recommend {improvements}."
      ]
    },
    Difficult: {
      questionTemplates: [
        "{complex_audit} with {significant_risks} and {management_overrides}. Design the {comprehensive_audit_approach} and {materiality_thresholds}.",
        "{audit_client} with {complex_estimates} and {judgment_areas}. Perform {substantive_procedures} and evaluate {reasonableness}.",
        "{public_entity} with {regulatory_requirements}. Prepare the {audit_report} with appropriate {opinions} and {emphasis_matters}."
      ]
    }
  }
};

module.exports = MCQTemplates;