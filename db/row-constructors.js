'use strict';

module.exports = {
  appendKeysWithDates,
  flatten
};

function flatten(worksheetData, model) {
  const convertedArr = [];
  for(let i = 0; i < worksheetData.length; i++) {
    const activeRow = worksheetData[i];
    try {
      const flatArr = appendKeysWithDates(activeRow, model);
      convertedArr.push(flatArr);
    } catch (e) {
      throw e;
    }
  }
  return convertedArr;
}

function appendKeysWithDates(row, model) {
  const arr = [];

  // Add keys from object
  for( let i = 0; i < model.length; i++) {
    const key = model[i];

    // validate that object has expected key
    if (row.hasOwnProperty(key)) {
      arr.push(row[key]);
    } else {
      throw new Error(`${key} is missing from passed\nrow: ${JSON.stringify(row)}\nfor model: ${model}`);
    }
  }

  // Add Dates
  const returnArr = arr.concat(['NOW()', 'NOW()']);

  return returnArr;
}