const format = require('pg-format');
const dedent = require('dedent');

const {
  createColumnHeaderString
} = require('../scripts/utils/general');

module.exports = {
  insertExcelData
};

async function insertExcelData(params) {
  let dbClient;

  // validate function waas called with params
  if (!(params)) {
    throw new Error('Argument with activePool, worksheetData and schema is required');
  }
  const { activePool, worksheetData, schema, models } = params;

  // validate parameter object
  if (!(activePool) || !(worksheetData) || !(schema)) {
    throw new Error('Argument with activePool, worksheetData and schema is required');
  }

  try {
    dbClient = await activePool.connect();
    await dbClient.query('BEGIN');
    for (let worksheet of worksheetData) {
      const { data, sheetName } = worksheet;
      const model = models[sheetName];
      const headers = createColumnHeaderString(model);

      const sql = format(`
        INSERT INTO %s.%s(%s)
        VALUES %L;
      `, schema, sheetName, headers, data);
      await dbClient.query(sql);
    }
    await dbClient.query('COMMIT');
  } catch (e) {
    await dbClient.query('ROLLBACK');
    throw e;
  } finally {
    if (dbClient) {
      dbClient.release();
    }
  }

  return;
}
