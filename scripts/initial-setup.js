const path = require('path');

const XLSX = require('xlsx');

const createPool = require('./utils/create-pool');
const readExcelFile = require('./loaders/read-excel-file');
const getTableNames = require('./utils/get-tables');
const convertWorksheet = require('./utils/convert-worksheet');
const initialModels = require('../db/models/initial');

(async function initialSetup() {
  let activePool;
  let workbook;
  let tableNames;

  // connect to db
  try {
    activePool = await createPool();
  } catch (e) {
    console.error(e);
    exit(2);
  }

  // Plan
  // Read Excel File
  try {
    const filePath = path.resolve(
      path.dirname(__filename),
      '../data/initial-setup-data.xlsx'
    );
    console.log(filePath);
    workbook = await readExcelFile(filePath);
  } catch (e) {
    console.error(e);
    exit(3);
  }

  // Get list of table names
  try {
    tableNames = await getTableNames({
      activePool,
      schema: 'predicts'
    })
  } catch (e) {
    console.error(e);
    exit(4);
  }

  const sheetNames = workbook.SheetNames;
  // For each sheet in file
  const dataToInsert = sheetNames.map((sheetName) => {
    // verify it exists in db
    if (!tableNames.includes(sheetName)) {
      console.warn(`${sheetName} not present!`);
    } else {
      // If so add any missing fields
      const worksheetObj = workbook.Sheets[sheetName];
      const worksheetArr = XLSX.utils.sheet_to_json(worksheetObj);

      try {
        const worksheetData = convertWorksheet({
          worksheetName: sheetName,
          worksheetData: worksheetArr
        });

        return {
          sheetName,
          data: worksheetData
        };
      } catch (e) {
        console.error(e);
        exit(5);
      }
    }
  });

  console.log(dataToInsert);

  process.exit(0);
  console.log('Initial Setup Complete');

})().catch(e => console.error(e));

process.on('uncaughtException', (err) => {
  console.error(err.stack);
  process.exit(1);
});

function exit(number) {
  process.exit(number);
}
