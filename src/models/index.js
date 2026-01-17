const Database = require('./Database');
const MCQ = require('./MCQ');

const db = new Database();
const mcqModel = new MCQ(db);

module.exports = {
  Database,
  MCQ,
  db,
  mcqModel
};