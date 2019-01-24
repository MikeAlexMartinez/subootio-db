const format = require('pg-format');

module.exports = rebuildDb;

async function rebuildDb({
  activePool,
  schemaSql,
  superuser,
  readUser,
  writeUser
}) {
  let dbClient;

  // Validating input
  if (!superuser) {
    return new Error('superuser is required');
  }
  if (!readUser) {
    return new Error('a read user is required');
  }
  if (!writeUser) {
    return new Error('a write user is required');
  }
  if (!activePool) {
    return new Error('activePool is required');
  }
  if (!schemaSql) {
    return new Error('db schema is required');
  }

  // Rebuilding Schema
  console.log('Rebuilding DB Schema...');
  try {
    dbClient = await activePool.connect();
    await dbClient.query('BEGIN');

    const rebuildSql = format(schemaSql, superuser, writeUser, readUser);
    await dbClient.query(rebuildSql);

    await dbClient.query('COMMIT');
  } catch (e) {
    await dbClient.query('ROLLBACK');
    console.log('ERROR ENCOUNTERED!');
    console.error(e);
    return new Error({ originalError: e });
  } finally {
    dbClient.release();
  }

  console.log('Rebuild Operation Complete!');
  return true;
}