const initialModels = require('../../db/models/initial');
const {
  flatten
} = require('../../db/row-constructors');

module.exports = convertWorksheet;

async function convertWorksheet({
  worksheetName,
  worksheetData
}) {

  // if any arguments missing throw error
  // worksheetName
  // worksheetData
  // activePool
  if (!worksheetName || !worksheetData) {
    throw new Error(`worksheetName and worksheetData are required keys in the passed object`);
  }

  // fetch model
  const model = initialModels[worksheetName];
  if (!model) {
    throw new Error(`Model could not be found`);
  }

  // construct rows
  let dataToInsert;
  try {
    dataToInsert = flatten(worksheetData, model);
  } catch (e) {
    throw e;
  }

  // insert data into database
  return dataToInsert;
}
