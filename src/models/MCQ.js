const Database = require('./Database');

class MCQ {
  constructor(db) {
    this.db = db;
  }

  async create(mcqData) {
    const connection = await this.db.getPool();
    const [result] = await connection.query(
      `INSERT INTO mcqs (
        question_code, subject, topic, subtopic, difficulty_level,
        question_text, choices, correct_answer, short_explanation,
        detailed_explanation, why_wrong_choices, memory_tip,
        standards_reference, tags, access_level, layman_story,
        latin_breakdown, formal_definition, elements_checklist,
        distinction_from_similar, references, computation_link,
        memory_trigger
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        mcqData.question_code,
        mcqData.subject,
        mcqData.topic,
        mcqData.subtopic || null,
        mcqData.difficulty_level,
        mcqData.question_text,
        JSON.stringify(mcqData.choices),
        mcqData.correct_answer,
        mcqData.short_explanation,
        mcqData.detailed_explanation,
        JSON.stringify(mcqData.why_wrong_choices),
        mcqData.memory_tip || null,
        JSON.stringify(mcqData.standards_reference || []),
        JSON.stringify(mcqData.tags || []),
        mcqData.access_level || 'FREE',
        mcqData.layman_story || null,
        JSON.stringify(mcqData.latin_breakdown || {}),
        mcqData.formal_definition || null,
        JSON.stringify(mcqData.elements_checklist || []),
        mcqData.distinction_from_similar || null,
        JSON.stringify(mcqData.references || []),
        mcqData.computation_link || null,
        mcqData.memory_trigger || null
      ]
    );
    return result.insertId;
  }

  async findById(id) {
    const connection = await this.db.getPool();
    const [rows] = await connection.query('SELECT * FROM mcqs WHERE id = ?', [id]);
    return rows[0];
  }

  async findByCode(questionCode) {
    const connection = await this.db.getPool();
    const [rows] = await connection.query('SELECT * FROM mcqs WHERE question_code = ?', [questionCode]);
    return rows[0];
  }

  async getRandom(filters = {}) {
    let query = 'SELECT * FROM mcqs WHERE 1=1';
    const params = [];

    if (filters.subject) {
      query += ' AND subject = ?';
      params.push(filters.subject);
    }

    if (filters.topic) {
      query += ' AND topic = ?';
      params.push(filters.topic);
    }

    if (filters.difficulty_level) {
      query += ' AND difficulty_level = ?';
      params.push(filters.difficulty_level);
    }

    if (filters.access_level) {
      query += ' AND access_level = ?';
      params.push(filters.access_level);
    }

    query += ' ORDER BY RAND() LIMIT ?';
    params.push(filters.limit || 1);

    const connection = await this.db.getPool();
    const [rows] = await connection.query(query, params);
    return rows;
  }

  async search(searchTerm, filters = {}) {
    let query = 'SELECT * FROM mcqs WHERE MATCH(question_text, detailed_explanation) AGAINST(? IN NATURAL LANGUAGE MODE)';
    const params = [searchTerm];

    if (filters.subject) {
      query += ' AND subject = ?';
      params.push(filters.subject);
    }

    if (filters.difficulty_level) {
      query += ' AND difficulty_level = ?';
      params.push(filters.difficulty_level);
    }

    query += ' LIMIT ?';
    params.push(filters.limit || 10);

    const connection = await this.db.getPool();
    const [rows] = await connection.query(query, params);
    return rows;
  }

  async getStats() {
    const connection = await this.db.getPool();
    const [rows] = await connection.query(`
      SELECT 
        subject,
        difficulty_level,
        COUNT(*) as count
      FROM mcqs 
      GROUP BY subject, difficulty_level
      ORDER BY subject, difficulty_level
    `);
    return rows;
  }

  async update(id, mcqData) {
    const connection = await this.db.getPool();
    const [result] = await connection.query(
      `UPDATE mcqs SET 
        subject = ?, topic = ?, subtopic = ?, difficulty_level = ?,
        question_text = ?, choices = ?, correct_answer = ?,
        short_explanation = ?, detailed_explanation = ?, why_wrong_choices = ?,
        memory_tip = ?, standards_reference = ?, tags = ?, access_level = ?,
        layman_story = ?, latin_breakdown = ?, formal_definition = ?,
        elements_checklist = ?, distinction_from_similar = ?, references = ?,
        computation_link = ?, memory_trigger = ?, updated_at = CURRENT_TIMESTAMP
      WHERE id = ?`,
      [
        mcqData.subject,
        mcqData.topic,
        mcqData.subtopic || null,
        mcqData.difficulty_level,
        mcqData.question_text,
        JSON.stringify(mcqData.choices),
        mcqData.correct_answer,
        mcqData.short_explanation,
        mcqData.detailed_explanation,
        JSON.stringify(mcqData.why_wrong_choices),
        mcqData.memory_tip || null,
        JSON.stringify(mcqData.standards_reference || []),
        JSON.stringify(mcqData.tags || []),
        mcqData.access_level || 'FREE',
        mcqData.layman_story || null,
        JSON.stringify(mcqData.latin_breakdown || {}),
        mcqData.formal_definition || null,
        JSON.stringify(mcqData.elements_checklist || []),
        mcqData.distinction_from_similar || null,
        JSON.stringify(mcqData.references || []),
        mcqData.computation_link || null,
        mcqData.memory_trigger || null,
        id
      ]
    );
    return result.affectedRows > 0;
  }

  async delete(id) {
    const connection = await this.db.getPool();
    const [result] = await connection.query('DELETE FROM mcqs WHERE id = ?', [id]);
    return result.affectedRows > 0;
  }
}

module.exports = MCQ;