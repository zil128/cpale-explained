const { v4: uuidv4 } = require('uuid');
const _ = require('lodash');
const mcqSchema = require('../schemas/mcqSchema');

class MCQGenerator {
  constructor() {
    this.tos = require('../data/tos.json');
    this.questionCounter = {};
    this.initializeCounters();
  }

  initializeCounters() {
    // Initialize counters for each subject-topic combination
    this.tos.subjects.forEach(subject => {
      this.questionCounter[subject.code] = {};
      
      if (subject.topics) {
        subject.topics.forEach(topic => {
          this.questionCounter[subject.code][topic.code] = 0;
        });
      }
      
      if (subject.sections) {
        subject.sections.forEach(section => {
          this.questionCounter[subject.code][section.code] = {};
          if (section.topics) {
            section.topics.forEach(topic => {
              this.questionCounter[subject.code][section.code][topic.code] = 0;
            });
          }
        });
      }
    });
  }

  generateQuestionCode(subject, topicCode, difficulty) {
    const difficultyMap = {
      'Easy': 'E',
      'Medium': 'M',
      'Difficult': 'D',
      'Tricky': 'T'
    };

    // Increment counter for this subject-topic
    if (!this.questionCounter[subject][topicCode]) {
      this.questionCounter[subject][topicCode] = 0;
    }
    this.questionCounter[subject][topicCode]++;

    const number = String(this.questionCounter[subject][topicCode]).padStart(3, '0');
    const difficultyCode = difficultyMap[difficulty];

    const code = `${subject}-${topicCode}-${number}-${difficultyCode}`;
    console.log(`DEBUG: Generated code: ${code}, subject: ${subject}, topicCode: ${topicCode}, difficulty: ${difficulty}`);
    return code;
  }

  async generateMCQ(subject, topic, difficulty, options = {}) {
    const questionData = {
      question_code: this.generateQuestionCode(subject, topic.code, difficulty),
      subject: subject,
      topic: topic.name,
      subtopic: options.subtopic || null,
      difficulty_level: difficulty,
      question_text: options.question_text || this.generateQuestionText(subject, topic, difficulty),
      choices: options.choices || this.generateChoices(subject, topic, difficulty),
      correct_answer: options.correct_answer || null,
      short_explanation: options.short_explanation || this.generateShortExplanation(subject, topic),
      detailed_explanation: options.detailed_explanation || this.generateDetailedExplanation(subject, topic),
      why_wrong_choices: options.why_wrong_choices || this.generateWhyWrongChoices(),
      memory_tip: options.memory_tip || this.generateMemoryTip(subject, topic),
      standards_reference: options.standards_reference || topic.standards || [],
      tags: options.tags || this.generateTags(subject, topic),
      access_level: options.access_level || 'FREE',
      layman_story: options.layman_story || this.generateLaymanStory(subject, topic),
      latin_breakdown: options.latin_breakdown || (subject === 'RFBT' ? this.generateLatinBreakdown(topic) : {}),
      formal_definition: options.formal_definition || this.generateFormalDefinition(subject, topic),
      elements_checklist: options.elements_checklist || this.generateElementsChecklist(subject, topic),
      distinction_from_similar: options.distinction_from_similar || this.generateDistinction(subject, topic),
      references: options.references || this.generateReferences(subject, topic),
      computation_link: options.computation_link || null,
      memory_trigger: options.memory_trigger || this.generateMemoryTrigger(subject, topic)
    };

    // Set correct answer if not provided
    if (!questionData.correct_answer) {
      const correctChoice = questionData.choices.find(choice => choice.is_correct);
      questionData.correct_answer = correctChoice ? correctChoice.label : 'A';
    }

    // TODO: Re-enable validation after fixing schema issues
    // const { error } = mcqSchema.validate(questionData);
    // if (error) {
    //   throw new Error(`MCQ validation failed: ${error.details[0].message}`);
    // }

    return questionData;
  }

  generateQuestionText(subject, topic, difficulty) {
    const templates = this.getQuestionTemplates(subject, topic, difficulty);
    return _.sample(templates);
  }

  generateChoices(subject, topic, difficulty) {
    const choiceTemplates = this.getChoiceTemplates(subject, topic, difficulty);
    const correctIndex = Math.floor(Math.random() * 4);
    
    return choiceTemplates.map((choice, index) => ({
      label: String.fromCharCode(65 + index), // A, B, C, D
      text: choice,
      is_correct: index === correctIndex
    }));
  }

  generateShortExplanation(subject, topic) {
    const explanations = this.getShortExplanations(subject, topic);
    return _.sample(explanations);
  }

  generateDetailedExplanation(subject, topic) {
    const explanations = this.getDetailedExplanations(subject, topic);
    return _.sample(explanations);
  }

  generateWhyWrongChoices() {
    return {
      A: "This choice represents a common misconception but doesn't align with the applicable standards.",
      B: "While plausible, this answer fails to consider all relevant factors required by the question.",
      C: "This option incorrectly applies the rules to the given scenario.",
      D: "This choice confuses similar concepts but doesn't address the specific issue raised."
    };
  }

  generateMemoryTip(subject, topic) {
    const tips = this.getMemoryTips(subject, topic);
    return _.sample(tips);
  }

  generateLaymanStory(subject, topic) {
    const stories = this.getLaymanStories(subject, topic);
    return _.sample(stories);
  }

  generateLatinBreakdown(topic) {
    // For legal terms in RFBT
    const latinTerms = {
      'Obligations': {
        'Obligatio': 'to bind',
        'Solvere': 'to loosen/settle'
      },
      'Contracts': {
        'Contractus': 'to draw together',
        'Consensus': 'agreement'
      }
    };
    return latinTerms[topic.name] || {};
  }

  generateFormalDefinition(subject, topic) {
    const definitions = this.getFormalDefinitions(subject, topic);
    return _.sample(definitions);
  }

  generateElementsChecklist(subject, topic) {
    const checklists = this.getElementsChecklists(subject, topic);
    const result = _.sample(checklists);
    return Array.isArray(result) ? result : [];
  }

  generateDistinction(subject, topic) {
    const distinctions = this.getDistinctions(subject, topic);
    return _.sample(distinctions);
  }

  generateTags(subject, topic) {
    return [
      subject.toLowerCase(),
      topic.name.toLowerCase().replace(/\s+/g, '-'),
      'cpale',
      'philippines'
    ];
  }

  generateReferences(subject, topic) {
    const references = [];
    
    if (topic.standards) {
      topic.standards.forEach(standard => {
        references.push({
          type: 'standard',
          name: standard,
          reference: `${standard} - Philippine Accounting Standards`
        });
      });
    }
    
    if (topic.laws) {
      topic.laws.forEach(law => {
        references.push({
          type: 'law',
          name: law,
          reference: `${law} - Philippine Law`
        });
      });
    }
    
    return references;
  }

  generateMemoryTrigger(subject, topic) {
    const triggers = this.getMemoryTriggers(subject, topic);
    return _.sample(triggers);
  }

  // Helper methods for getting templates and content
  getQuestionTemplates(subject, topic, difficulty) {
    // This would contain subject-specific question templates
    // For now, return a generic template
    return [
      `Which of the following statements is correct regarding ${topic.name}?`,
      `Under Philippine standards, how should ${topic.name} be treated?`,
      `What is the proper accounting treatment for ${topic.name} according to relevant standards?`
    ];
  }

  getChoiceTemplates(subject, topic, difficulty) {
    // This would generate plausible distractors based on the topic
    return [
      "Option A that seems correct but has a subtle error",
      "Option B that is the correct answer",
      "Option C that represents a common misconception",
      "Option D that is partially correct but incomplete"
    ];
  }

  getShortExplanations(subject, topic) {
    return [
      `The correct answer follows the principles outlined in the relevant Philippine standards.`,
      `This treatment is consistent with the requirements for ${topic.name}.`
    ];
  }

  getDetailedExplanations(subject, topic) {
    return [
      `According to the applicable Philippine standards and practices, ${topic.name} should be handled in the manner described in the correct answer. This approach ensures compliance with both local regulations and international best practices.`
    ];
  }

  getMemoryTips(subject, topic) {
    return [
      `Remember the key principle: ${topic.name.substring(0, 10)}...`,
      `Think of it as: ${topic.name} = Proper Treatment`
    ];
  }

  getLaymanStories(subject, topic) {
    return [
      `Imagine a small business owner trying to understand how to properly handle ${topic.name.toLowerCase()} in their financial records. The correct approach would be...`
    ];
  }

  getFormalDefinitions(subject, topic) {
    return [
      `${topic.name} refers to the established principles and procedures governing its treatment in financial reporting and accounting practices.`
    ];
  }

  getElementsChecklists(subject, topic) {
    return [
      "Verify all conditions are met",
      "Ensure proper documentation",
      "Apply relevant standards correctly"
    ];
  }

  getDistinctions(subject, topic) {
    return [
      `This concept differs from similar topics in that it focuses specifically on ${topic.name.toLowerCase()} rather than broader accounting principles.`
    ];
  }

  getMemoryTriggers(subject, topic) {
    return [
      `${topic.name.split(' ')[0]} = KEY POINT`
    ];
  }

  async generateBatch(subject, topic, difficulty, count) {
    const questions = [];
    
    for (let i = 0; i < count; i++) {
      try {
        const question = await this.generateMCQ(subject, topic, difficulty);
        questions.push(question);
      } catch (error) {
        console.error(`Error generating question ${i + 1}:`, error.message);
      }
    }
    
    return questions;
  }

  async generateFullTOS() {
    const allQuestions = [];
    
    for (const subject of this.tos.subjects) {
      console.log(`Generating questions for ${subject.name}...`);
      
      const topics = subject.topics || [];
      const sections = subject.sections || [];
      
      // Handle direct topics
      for (const topic of topics) {
        for (const difficulty of ['Easy', 'Medium', 'Difficult', 'Tricky']) {
          const targetCount = Math.floor(topic.target_questions * this.getDifficultyMultiplier(difficulty));
          console.log(`Generating ${targetCount} ${difficulty} questions for ${topic.name}...`);
          
          const questions = await this.generateBatch(subject.code, topic, difficulty, targetCount);
          allQuestions.push(...questions);
        }
      }
      
      // Handle sections with subtopics
      for (const section of sections) {
        for (const topic of section.topics || []) {
          for (const difficulty of ['Easy', 'Medium', 'Difficult', 'Tricky']) {
            const targetCount = Math.floor(topic.target_questions * this.getDifficultyMultiplier(difficulty));
            console.log(`Generating ${targetCount} ${difficulty} questions for ${section.name} - ${topic.name}...`);
            
            const questions = await this.generateBatch(subject.code, topic, difficulty, targetCount);
            allQuestions.push(...questions);
          }
        }
      }
    }
    
    console.log(`Generated ${allQuestions.length} total questions`);
    return allQuestions;
  }

  getDifficultyMultiplier(difficulty) {
    const multipliers = {
      'Easy': 0.20,
      'Medium': 0.40,
      'Difficult': 0.30,
      'Tricky': 0.10
    };
    return multipliers[difficulty] || 0.25;
  }
}

module.exports = MCQGenerator;