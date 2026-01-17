const Joi = require('joi');

const mcqSchema = Joi.object({
  question_code: Joi.string()
    .regex(/^[A-Z]{3}-[A-Z]{3}-\d{3}-[A-Z]$/)
    .required()
    .description('Format: {SUBJECT}-{TOPIC_CODE}-{NUMBER}-{DIFFICULTY}'),
  
  subject: Joi.string()
    .valid('FAR', 'AFAR', 'MS', 'RFBT', 'TAX', 'AUD')
    .required(),
  
  topic: Joi.string()
    .required()
    .max(100),
  
  subtopic: Joi.string()
    .allow(null, '')
    .max(100),
  
  difficulty_level: Joi.string()
    .valid('Easy', 'Medium', 'Difficult', 'Tricky')
    .required(),
  
  question_text: Joi.string()
    .required()
    .min(10)
    .max(1000),
  
  choices: Joi.array()
    .items(
      Joi.object({
        label: Joi.string().valid('A', 'B', 'C', 'D').required(),
        text: Joi.string().required().min(1).max(500),
        is_correct: Joi.boolean().required()
      })
    )
    .length(4)
    .required(),
  
  correct_answer: Joi.string()
    .valid('A', 'B', 'C', 'D')
    .required(),
  
  short_explanation: Joi.string()
    .required()
    .min(5)
    .max(200),
  
  detailed_explanation: Joi.string()
    .required()
    .min(10)
    .max(2000),
  
  why_wrong_choices: Joi.object({
    A: Joi.string().allow(null, ''),
    B: Joi.string().allow(null, ''),
    C: Joi.string().allow(null, ''),
    D: Joi.string().allow(null, '')
  }).required(),
  
  memory_tip: Joi.string()
    .optional()
    .max(100),
  
  standards_reference: Joi.array()
    .items(Joi.string().max(50))
    .optional(),
  
  tags: Joi.array()
    .items(Joi.string().max(50))
    .optional(),
  
  access_level: Joi.string()
    .valid('FREE', 'PREMIUM')
    .default('FREE'),
  
  layman_story: Joi.string()
    .optional()
    .max(500),
  
  latin_breakdown: Joi.object()
    .pattern(Joi.string(), Joi.string())
    .optional(),
  
  formal_definition: Joi.string()
    .optional()
    .max(1000),
  
  elements_checklist: Joi.array()
    .items(Joi.string().max(100))
    .allow(null),
  
  distinction_from_similar: Joi.string()
    .optional()
    .max(500),
  
  references: Joi.array()
    .items(
      Joi.object({
        type: Joi.string().valid('law', 'standard', 'section', 'article').required(),
        name: Joi.string().required(),
        reference: Joi.string().required()
      })
    )
    .optional(),
  
  computation_link: Joi.string()
    .uri()
    .optional(),
  
  memory_trigger: Joi.string()
    .optional()
    .max(100)
});

module.exports = mcqSchema;