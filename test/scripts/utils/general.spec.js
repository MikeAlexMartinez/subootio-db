const expect = require('chai').expect;

const {
  createColumnHeaderString
} = require('../../../scripts/utils/general');

describe('Utils - General: ', () => {

  describe('Function: createColumnHeaderString', () => {
    describe('WithDates is true', () => {
      const headers = ['one', 'two', 'three'];
      const expected = 'one, two, three, date_created, date_modified';
      const actual = createColumnHeaderString({
        headers,
        withDates: true
      });
      expect(actual).to.equal(expected);
    });
    describe('WithDates is false', () => {
      const headers = ['one', 'two', 'three'];
      const expected = 'one, two, three';
      const actual = createColumnHeaderString({
        headers,
        withDates: false
      });
      expect(actual).to.equal(expected);
    });
  });
  

});
