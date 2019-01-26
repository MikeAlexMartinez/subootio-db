// Node Dependencies
const fs = require('fs')

// 3rd Party Dependencies
const XLSX = require('xlsx');

module.exports = readExcelFile;

async function readExcelFile(filename) {
  // check filename
  if (!filename) {
    throw new Error('A filename is required');
  }

  // should end in .xlsx
  const re = /.*.xlsx$/;
  if (!re.test(filename)) {
    throw new Error('Passed filename must end in .xlsx');
  }

  // should be accessible and readable to the node process
  try {
    fs.accessSync(filename, fs.constants.R_OK | fs.constants.W_OK);
  } catch (e) {
    throw e;
  }

  // read and return file
  let workbook;
  try {
    workbook = await XLSX.readFile(filename);
  } catch (e) {
    throw e;
  }

  return workbook;
}