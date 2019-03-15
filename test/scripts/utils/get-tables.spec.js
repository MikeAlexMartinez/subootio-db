// Testing
const expect = require('chai').expect;
const rewire = require('rewire');

const dedent = require('dedent');

const { DbConnectionMock, defineQueryReturnData } = require('../../__mocks__/pool-mock');

const preMappedMockTables = [
  {table_name: 'table_one'},
  {table_name: 'table_two'},
  {table_name: 'table_three'}
];

const mockTables = [
  'table_one',
  'table_two',
  'table_three'
];

// Testing
// should query dbClient with expected sql statement
// should throw errors up the stack
// dbClient should be released
// should error if activePool or schema is undefined

describe('utils: get-tables()', () => {
  let getTableNamesModule;
  let getTableNames;

  beforeEach(() => {
    getTableNamesModule = rewire('../../../scripts/utils/get-tables');
    getTableNames = getTableNamesModule.__get__('getTableNames');
  });

  describe('arguments:', () => {
    it('should return error when no activepool is passed',async () => {
      let error;
      try {
        await getTableNames({
          schema: 'predicts'
        });
      } catch (e) {
        error = e;
      }
      expect(error).to.be.an('error');
      expect(error.message).to.equal('An activePool is required');
    });
    it('should return error when no schema is passed',async () => {
      let error;
      try {
        await getTableNames({
          activePool: 'test'
        });
      } catch (e) {
        error = e;
      }
      expect(error).to.be.an('error');
      expect(error.message).to.equal('A schema must be provided in the function parameter object.');
    });
  });

  describe('Client should always be released', () => {
    it('should be released when an error occurs', async () => {
      const errorMessage = 'Error Querying Data';
      const dbConnection = new DbConnectionMock(
        () => Promise.reject(new Error(errorMessage))
      );
      const activePool = {
        connect: () => Promise.resolve(dbConnection)
      };
      let error;
      try {
        await getTableNames({
          activePool,
          schema: 'predicts'
        })
      } catch (e) {
        error = e;
      }
      expect(error.message).to.equal(errorMessage);
      expect(dbConnection.release.callCount).to.equal(1);
    });
    it('should be released even when an error doesn\'t occur', async () => {
      const returnData = defineQueryReturnData([preMappedMockTables]);
      const dbConnection = new DbConnectionMock(returnData);
      const activePool = {
        connect: () => Promise.resolve(dbConnection)
      };
      let error;
      try {
        await getTableNames({
          activePool,
          schema: 'predicts'
        });
      } catch (e) {
        error = e;
      }
      expect(error).to.be.undefined;
      expect(dbConnection.release.callCount).to.equal(1);
    });
  });
  
  describe('DB Query', () => {
    it('should query the database with the expected SQL statement', async () => {
      let generatedSql;
      const returnData = defineQueryReturnData([preMappedMockTables], (sql) => {
        generatedSql = dedent(sql);
      });
      const dbConnection = new DbConnectionMock(returnData);
      const activePool = {
        connect: () => Promise.resolve(dbConnection)
      };
      let error;
      try {
        await getTableNames({
          activePool,
          schema: 'predicts'
        });
      } catch (e) {
        error = e
      }
      const expectSql = dedent(`
        SELECT table_name
        FROM information_schema.tables
        WHERE table_type='BASE TABLE'
        AND table_schema='predicts'
      `)
      expect(error).to.be.undefined;
      expect(generatedSql).to.equal(expectSql);
    });
  });

  describe('should return the tables', () => {
    it('if all is okay', async () => {
      const returnData = defineQueryReturnData([preMappedMockTables]);
      const dbConnection = new DbConnectionMock(returnData);
      const activePool = {
        connect: () => Promise.resolve(dbConnection)
      };
      let error;
      let tables;
      try {
        tables = await getTableNames({
          activePool,
          schema: 'predicts'
        });
      } catch (e) {
        console.error(e);
        error = e
      }
      expect(error).to.be.undefined;
      expect(tables).to.deep.equal(mockTables);
    });
  });
});
