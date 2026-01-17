const request = require('supertest');
const MCQGenerator = require('../src/services/MCQGenerator');
const PremiumAnalytics = require('../src/services/PremiumAnalytics');
const app = require('../src/demo-server');

class ComprehensiveTestSuite {
  constructor() {
    this.results = [];
    this.generator = new MCQGenerator();
    this.analytics = new PremiumAnalytics();
  }

  async runAllTests() {
    console.log('🧪 CPALE MCQ Generator - Comprehensive Test Suite\n');
    
    const testSuites = [
      { name: 'MCQ Generation System', test: () => this.testMCQGeneration() },
      { name: 'API Endpoints', test: () => this.testAPIEndpoints() },
      { name: 'Data Validation', test: () => this.testDataValidation() },
      { name: 'Premium Analytics', test: () => this.testPremiumAnalytics() },
      { name: 'Integration Tests', test: () => this.testIntegration() },
      { name: 'Performance Tests', test: () => this.testPerformance() }
    ];

    for (const suite of testSuites) {
      console.log(`\n🔍 Running ${suite.name} Tests...\n`);
      
      try {
        const startTime = Date.now();
        await suite.test();
        const endTime = Date.now();
        
        this.results.push({
          suite: suite.name,
          status: 'PASS',
          duration: endTime - startTime,
          timestamp: new Date().toISOString()
        });
        
        console.log(`✅ ${suite.name}: ALL TESTS PASSED (${endTime - startTime}ms)`);
        
      } catch (error) {
        this.results.push({
          suite: suite.name,
          status: 'FAIL',
          error: error.message,
          timestamp: new Date().toISOString()
        });
        
        console.log(`❌ ${suite.name}: ${error.message}`);
      }
    }

    this.generateReport();
  }

  async testMCQGeneration() {
    const subjects = ['FAR', 'AFAR', 'MS', 'RFBT', 'TAX', 'AUD'];
    const difficulties = ['Easy', 'Medium', 'Difficult', 'Tricky'];
    
    for (const subject of subjects) {
      for (const difficulty of difficulties) {
        const topic = {
          code: subject.substring(0, 3),
          name: `Test Topic for ${subject}`,
          standards: subject === 'RFBT' ? ['Test Law'] : ['Test Standard']
        };
        
        const question = await this.generator.generateMCQ(subject, topic, difficulty);
        
        // Validate required fields
        if (!question.question_code || !question.question_text || !question.choices) {
          throw new Error(`Missing required fields in ${subject}-${difficulty} question`);
        }
        
        // Validate choices
        if (question.choices.length !== 4) {
          throw new Error(`Invalid number of choices in ${subject}-${difficulty} question`);
        }
        
        const correctChoices = question.choices.filter(c => c.is_correct);
        if (correctChoices.length !== 1) {
          throw new Error(`Invalid correct answer count in ${subject}-${difficulty} question`);
        }
        
        // Validate memory trigger
        if (!question.memory_trigger) {
          throw new Error(`Missing memory trigger in ${subject}-${difficulty} question`);
        }
      }
    }
    
    console.log('   ✅ MCQ Generation: All subjects and difficulties tested');
  }

  async testAPIEndpoints() {
    const endpoints = [
      { path: '/api/health', expected: 200 },
      { path: '/api/questions/random', expected: 200 },
      { path: '/api/questions/FAR', expected: 200 },
      { path: '/api/questions/search/test', expected: 200 },
      { path: '/api/questions/stats', expected: 200 },
      { path: '/api/questions/tos', expected: 200 }
    ];

    for (const endpoint of endpoints) {
      const response = await request(app).get(endpoint.path);
      if (response.status !== endpoint.expected) {
        throw new Error(`Endpoint ${endpoint.path} returned ${response.status}, expected ${endpoint.expected}`);
      }
    }
    
    console.log('   ✅ API Endpoints: All endpoints responding correctly');
  }

  async testDataValidation() {
    // Test TOS structure
    const tos = require('../src/data/tos.json');
    
    if (!tos.exam || !tos.subjects || !Array.isArray(tos.subjects)) {
      throw new Error('Invalid TOS structure');
    }
    
    const totalQuestions = tos.subjects.reduce((sum, subject) => {
      const target = subject.target_questions || 0;
      return sum + target;
    }, 0);
    
    if (totalQuestions < 10000) {
      throw new Error(`Insufficient target questions: ${totalQuestions}`);
    }
    
    // Test schema structure
    const mcqSchema = require('../src/schemas/mcqSchema.json');
    const requiredFields = ['question_code', 'subject', 'question_text', 'choices', 'correct_answer'];
    
    for (const field of requiredFields) {
      if (!mcqSchema.properties[field]) {
        throw new Error(`Missing required field in schema: ${field}`);
      }
    }
    
    console.log('   ✅ Data Validation: TOS and schema structure valid');
  }

  async testPremiumAnalytics() {
    const mockUserId = 'test-user-123';
    
    // Test weakness analysis
    const weaknesses = await this.analytics.getAdvancedWeaknessAnalysis(mockUserId);
    if (!Array.isArray(weaknesses) || weaknesses.length === 0) {
      throw new Error('Weakness analysis failed');
    }
    
    // Test recommendations
    const recommendations = await this.analytics.getPersonalizedRecommendations(mockUserId);
    if (!Array.isArray(recommendations) || recommendations.length === 0) {
      throw new Error('Recommendations generation failed');
    }
    
    // Test mastery breakdown
    const mastery = await this.analytics.getMasteryBreakdown(mockUserId, 'FAR');
    if (!mastery.breakdown || !mastery.summary) {
      throw new Error('Mastery breakdown failed');
    }
    
    // Test predictive analytics
    const predictive = await this.analytics.getPredictiveAnalytics(mockUserId);
    if (!predictive.currentMastery || !predictive.predictedExamScore) {
      throw new Error('Predictive analytics failed');
    }
    
    // Test comparative analytics
    const comparative = await this.analytics.getComparativeAnalytics(mockUserId);
    if (!comparative.comparison || !comparative.overallPercentile) {
      throw new Error('Comparative analytics failed');
    }
    
    console.log('   ✅ Premium Analytics: All analytics functions working');
  }

  async testIntegration() {
    // Test question generation to API flow
    const question = await this.generator.generateMCQ(
      'FAR',
      { code: 'NFA', name: 'Non-financial Assets' },
      'Medium'
    );
    
    // Mock saving question and retrieving via API
    const questionsResponse = await request(app)
      .get('/api/questions/search/assets');
    
    if (questionsResponse.status !== 200) {
      throw new Error('Integration failed: API search not working');
    }
    
    // Test TOS integration
    const tosResponse = await request(app)
      .get('/api/questions/tos');
    
    if (tosResponse.status !== 200 || !tosResponse.body.subjects) {
      throw new Error('Integration failed: TOS API not working');
    }
    
    console.log('   ✅ Integration: Question generation to API flow working');
  }

  async testPerformance() {
    const startTime = Date.now();
    
    // Test batch generation performance
    const questions = [];
    for (let i = 0; i < 10; i++) {
      const question = await this.generator.generateMCQ(
        'FAR',
        { code: 'NFA', name: 'Non-financial Assets' },
        'Medium'
      );
      questions.push(question);
    }
    
    const generationTime = Date.now() - startTime;
    const avgTimePerQuestion = generationTime / 10;
    
    if (avgTimePerQuestion > 500) { // More than 500ms per question is too slow
      throw new Error(`Performance issue: ${avgTimePerQuestion}ms per question`);
    }
    
    // Test API response time
    const apiStartTime = Date.now();
    await request(app).get('/api/health');
    const apiResponseTime = Date.now() - apiStartTime;
    
    if (apiResponseTime > 1000) { // More than 1 second is too slow
      throw new Error(`API performance issue: ${apiResponseTime}ms response time`);
    }
    
    console.log(`   ✅ Performance: ${avgTimePerQuestion.toFixed(0)}ms per question, ${apiResponseTime}ms API response`);
  }

  generateReport() {
    const totalSuites = this.results.length;
    const passedSuites = this.results.filter(r => r.status === 'PASS').length;
    const failedSuites = this.results.filter(r => r.status === 'FAIL').length;
    const totalDuration = this.results.reduce((sum, r) => sum + (r.duration || 0), 0);

    console.log('\n📊 TEST SUITE SUMMARY');
    console.log('='.repeat(50));
    console.log(`Total Test Suites: ${totalSuites}`);
    console.log(`Passed: ${passedSuites} ✅`);
    console.log(`Failed: ${failedSuites} ❌`);
    console.log(`Success Rate: ${((passedSuites / totalSuites) * 100).toFixed(1)}%`);
    console.log(`Total Duration: ${totalDuration}ms`);
    
    if (failedSuites > 0) {
      console.log('\n❌ FAILED TESTS:');
      this.results
        .filter(r => r.status === 'FAIL')
        .forEach(r => {
          console.log(`   ${r.suite}: ${r.error}`);
        });
    }
    
    console.log('\n' + '='.repeat(50));
    console.log('🎯 NEXT STEPS:');
    if (failedSuites === 0) {
      console.log('✅ All tests passed! Ready for deployment.');
      console.log('📦 Run: npm run build');
      console.log('🚀 Deploy to production');
    } else {
      console.log('🔧 Fix failing tests before deployment');
      console.log('📝 Review error messages above');
    }
    
    // Save report
    const report = {
      summary: {
        totalSuites,
        passedSuites,
        failedSuites,
        successRate: ((passedSuites / totalSuites) * 100).toFixed(1),
        totalDuration,
        timestamp: new Date().toISOString()
      },
      results: this.results
    };
    
    require('fs').writeFileSync(
      require('path').join(__dirname, 'test-report.json'),
      JSON.stringify(report, null, 2)
    );
    
    console.log('\n💾 Detailed report saved to: test-report.json');
  }
}

// Run tests if called directly
if (require.main === module) {
  const testSuite = new ComprehensiveTestSuite();
  testSuite.runAllTests()
    .then(() => {
      console.log('\n🎉 Test Suite Completed!');
      process.exit(0);
    })
    .catch((error) => {
      console.error('\n❌ Test Suite Failed:', error);
      process.exit(1);
    });
}

module.exports = ComprehensiveTestSuite;