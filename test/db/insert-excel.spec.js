const dedent = require('dedent');

// Testing
const expect = require('chai').expect;
const rewire = require('rewire');
const sinon = require('sinon');

// Data
const {
  single,
  triple,
  tripleError
} = require('../__data__/worksheetData');

// Testing plan
// should verify that all the required parameters are passed.
// should only commmit if no errors where thrown during insertion
//    single sheet
//    multiple sheets
//    error during one sheet?
// should release connection with error or with success

describe('Module: insert-excel', () => {
  let insertExcelModule;
  let insertExcelData;

  beforeEach(() => {
    insertExcelModule = rewire('../../db/insert-excel');
  });

  describe('parameters: ', () => {
    beforeEach(() => {
      insertExcelData = insertExcelModule.__get__('insertExcelData');
    });

    // should error if no argument
    it('should error if no argument passed', async () => {
      let error;
      try {
        await insertExcelData();
      } catch (e) {
        error = e;
      }
      expect(error).to.be.an('error');
      expect(error.message).to.equal('Argument with activePool, worksheetData and schema is required');
    });

    it('should error if required key on argument not passed', async () => {
      let error;
      try {
        await insertExcelData({
          test: 'test'
        });
      } catch (e) {
        error = e;
      }
      expect(error).to.be.an('error');
      expect(error.message).to.equal('Argument with activePool, worksheetData and schema is required');
    });
  });

  describe('dbClient interactions: ', () => {
    let worksheetData;
    // should only commmit if no errors where thrown during insertion
    //    single sheet
    //    multiple sheets
    //    error during one sheet?
    describe('should make expected queries to the dbClient', async () => {
      const schema = 'predicts';
      const models = {
        test_one: ['id', 'name', 'description']
      };
      const worksheetData = [...single];
      const activePool 
      
      
      const expectedCalls = [
        'BEGIN',
        dedent(`
          INSERT INTO predicts.test_one(id, name, description, date_created, date_modified)
          VALUES (
            (1, 'name', 'desc', NOW(), NOw())
          );
        `),
        'COMMIT'
      ];
    });

  });
});