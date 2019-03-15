
const testOne = {
  sheetName: 'test_one',
  data: [
    [1, 'name', 'desc', 'NOW()', 'NOW()']
  ]
};
const testTwo = {
  sheetName: 'test_two',
  data: [
    [1, 'name', 'desc', 'NOW()', 'NOW()'],
    [2, 'name', 'desc', 'NOW()', 'NOW()'],
  ]
};
const testThree = {
  sheetName: 'test_three',
  data: [
    [1, 'name', 'desc', 'NOW()', 'NOW()'],
    [2, 'name', 'desc', 'NOW()', 'NOW()'],
    [3, 'name', 'desc', 'NOW()', 'NOW()']
  ]
};
const error = {};

module.exports = {
  single: [testOne],
  triple: [testOne, testTwo, testThree],
  tripleError: [testOne, error, testTwo]
};