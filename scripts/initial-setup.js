const path = require('path');

const XLSX = require('xlsx');

const createPool = require('./utils/create-pool');
const readExcelFile = require('./loaders/read-excel-file');
const getTableNames = require('./utils/get-tables');

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

  console.log(workbook.SheetNames);
  console.log(tableNames);
  // For each sheet in file
    // verify it exists in db
    // If so add any missing fields
    // insert into db.
    // fin
})().catch(e => console.error(e));

process.on('uncaughtException', (err) => {
  console.error(err.stack);
  process.exit(1);
});

function exit(number) {
  process.exit(number);
}