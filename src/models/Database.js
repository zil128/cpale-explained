const mysql = require('mysql2/promise');

class Database {
  constructor() {
    this.pool = mysql.createPool({
      host: process.env.DB_HOST || 'localhost',
      user: process.env.DB_USER || 'root',
      password: process.env.DB_PASSWORD || '',
      database: process.env.DB_NAME || 'cpale_mcq',
      waitForConnections: true,
      connectionLimit: 10,
      queueLimit: 0
    });
  }

  async initialize() {
    try {
      const connection = await this.pool.getConnection();
      
      // Create database if not exists
      await connection.query(`CREATE DATABASE IF NOT EXISTS \`${process.env.DB_NAME || 'cpale_mcq'}\``);
      await connection.query(`USE \`${process.env.DB_NAME || 'cpale_mcq'}\``);
      
      // Create tables
      await this.createTables(connection);
      
      connection.release();
      console.log('Database initialized successfully');
    } catch (error) {
      console.error('Database initialization failed:', error);
      throw error;
    }
  }

  async createTables(connection) {
    // Users table first (no dependencies)
    await connection.query(`
      CREATE TABLE IF NOT EXISTS users (
        id INT AUTO_INCREMENT PRIMARY KEY,
        email VARCHAR(255) UNIQUE NOT NULL,
        password VARCHAR(255) NOT NULL,
        name VARCHAR(255) NOT NULL,
        phone VARCHAR(20),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        INDEX idx_email (email)
      )
    `);

    // Subjects table
    await connection.query(`
      CREATE TABLE IF NOT EXISTS subjects (
        id INT AUTO_INCREMENT PRIMARY KEY,
        code VARCHAR(10) UNIQUE NOT NULL,
        name VARCHAR(100) NOT NULL,
        total_items INT NOT NULL,
        weight_percent DECIMAL(5,2) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);

    // Topics table
    await connection.query(`
      CREATE TABLE IF NOT EXISTS topics (
        id INT AUTO_INCREMENT PRIMARY KEY,
        subject_code VARCHAR(10) NOT NULL,
        name VARCHAR(200) NOT NULL,
        weight_percent DECIMAL(5,2) NOT NULL,
        items INT NOT NULL,
        standards JSON,
        FOREIGN KEY (subject_code) REFERENCES subjects(code),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);

    // MCQs table
    await connection.query(`
      CREATE TABLE IF NOT EXISTS mcqs (
        id INT AUTO_INCREMENT PRIMARY KEY,
        question_code VARCHAR(20) UNIQUE NOT NULL,
        subject VARCHAR(10) NOT NULL,
        topic VARCHAR(100) NOT NULL,
        subtopic VARCHAR(100),
        difficulty_level ENUM('Easy', 'Medium', 'Difficult', 'Tricky') NOT NULL,
        question_text TEXT NOT NULL,
        choices JSON NOT NULL,
        correct_answer ENUM('A', 'B', 'C', 'D') NOT NULL,
        short_explanation TEXT NOT NULL,
        detailed_explanation TEXT NOT NULL,
        why_wrong_choices JSON NOT NULL,
        memory_tip VARCHAR(100),
        standards_reference JSON,
        tags JSON,
        access_level ENUM('FREE', 'PREMIUM') DEFAULT 'FREE',
        layman_story TEXT,
        latin_breakdown JSON,
        formal_definition TEXT,
        elements_checklist JSON,
        distinction_from_similar TEXT,
        standards_references JSON,
        computation_link VARCHAR(500),
        memory_trigger VARCHAR(100),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        INDEX idx_subject (subject),
        INDEX idx_topic (topic),
        INDEX idx_difficulty (difficulty_level),
        INDEX idx_access_level (access_level),
        INDEX idx_question_code (question_code),
        FULLTEXT idx_question_text (question_text),
        FULLTEXT idx_explanation (detailed_explanation)
      )
    `);

    // User progress table
    await connection.query(`
      CREATE TABLE IF NOT EXISTS user_progress (
        id INT AUTO_INCREMENT PRIMARY KEY,
        user_id INT NOT NULL,
        question_code VARCHAR(20) NOT NULL,
        is_correct BOOLEAN NOT NULL,
        time_taken INT,
        difficulty_level ENUM('Easy', 'Medium', 'Difficult', 'Tricky') NOT NULL,
        attempted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (question_code) REFERENCES mcqs(question_code),
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        INDEX idx_user_id (user_id),
        INDEX idx_difficulty (difficulty_level),
        UNIQUE KEY unique_user_question (user_id, question_code)
      )
    `);

    // Analytics table
    await connection.query(`
      CREATE TABLE IF NOT EXISTS analytics (
        id INT AUTO_INCREMENT PRIMARY KEY,
        user_id INT NOT NULL,
        subject VARCHAR(10) NOT NULL,
        topic VARCHAR(100) NOT NULL,
        difficulty_level ENUM('Easy', 'Medium', 'Difficult', 'Tricky') NOT NULL,
        total_attempts INT DEFAULT 0,
        correct_attempts INT DEFAULT 0,
        average_time DECIMAL(8,2),
        mastery_score DECIMAL(5,2),
        last_attempted TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        INDEX idx_user_id (user_id),
        INDEX idx_subject_topic (subject, topic),
        UNIQUE KEY unique_user_subject_topic_difficulty (user_id, subject, topic, difficulty_level)
      )
    `);
  }

  async getPool() {
    return this.pool;
  }

  async close() {
    await this.pool.end();
  }
}

module.exports = Database;