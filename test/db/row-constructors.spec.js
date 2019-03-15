const { appendKeysWithDates } = require('../../db/row-constructors');

const expect = require('chai').expect;

describe('db: row-constructors', () => {
  describe('function: appendKeysWithDates()', () => {
    it('should return array with date strings added', () => {
      const expected = ['NOW()', 'NOW()'];
      const returned = appendKeysWithDates({}, []);
      expect(returned).to.deep.equal(expected);
    });
    it('should parse model and return passed values in array with dates', () => {
      const object = {
        test: 'test',
        oneMore: 'oneMore',
        another: 'value'
      };
      const model = ['test', 'another', 'oneMore'];
      const expected = ['test', 'value', 'oneMore', 'NOW()', 'NOW()'];
      const returned = appendKeysWithDates(object, model);
      expect(returned).to.deep.equal(expected);
    });
    it('should throw error if object is missing expected key', () => {
      let error;
      const obj = {
        test: 'test'
      };
      const model = ['test', 'missing'];
      try {
        appendKeysWithDates(
          obj,
          model
        );
      } catch (e) {
        error = e;
      }
      expect(error).to.be.an('error');
      expect(error.message).to.equal(`missing is missing from passed\nrow: ${JSON.stringify(obj)}\nfor model: ${JSON.stringify(model)}`);
    });
  });
});