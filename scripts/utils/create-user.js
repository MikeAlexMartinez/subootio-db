// Dependencies
const format = require('pg-format');

module.exports = createUser;

// create new user
function createUser({ activePool, user }) {
  return new Promise(async (res, rej) => {
    let dbClient;

    if (!user) {
      rej(new Error(`no user to create`));
    }

    const { username, password } = user;
    if (!username) {
      rej(new Error(`no username present on user`));
    }
    if (!password) {
      rej(new Error(`no password present for user`));
    }

    try {
      dbClient = await activePool.pool.connect();
      await dbClient.query('BEGIN');
      const sql = format(`
        DO
        $do$
        BEGIN
          IF NOT EXISTS (
            SELECT
            FROM pg_catalog.pg_roles
            WHERE rolname = '%1$s'
          ) THEN
            CREATE USER %1$s WITH PASSWORD '%2$s';
          END IF;
        END
        $do$
      `, username, password)
      await dbClient.query(sql);
      await dbClient.query('COMMIT')
    } catch (e) {
      await dbClient.query('ROLLBACK')
      console.log(`ERROR creating ${username}!`);
      rej(e);
    } finally {
      dbClient.release();
    }
    console.log(`Created ${username} successfully`);
    res();
  });
}