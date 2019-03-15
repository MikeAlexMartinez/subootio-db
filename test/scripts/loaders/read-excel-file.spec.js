// Node
const fs = require('fs');
const path = require('path');

// Testing
const expect = require('chai').expect;
const rewire = require('rewire');
const sinon = require('sinon');

// Testing Plan:
// it should call XLSX.readFile once
// should check that that process has access to the given file
// it should return error if filename not provided
// it should catch errors returned from readFile function
// if all okay should return ExcelWorkbook

describe('Module: read-excel-file', () => {
  let readExcelFileModule;
  let readExcelFile;

  beforeEach(() => {
    readExcelFileModule = rewire('../../../scripts/loaders/read-excel-file');
    readExcelFile = readExcelFileModule.__get__('readExcelFile');
  });

  describe('arguments:', () => {
    it('should return error when no filename passed',async () => {
      let error;
      try {
        await readExcelFile();
      } catch (e) {
        error = e;
      }
      expect(error).to.be.an('error');
      expect(error.message).to.equal('A filename is required');
    });
    
    it('should return error when non .xlsx filename passed',async () => {
      let error;
      try {
        await readExcelFile('someincorrectfilename.pdf');
      } catch (e) {
        error = e;
      }
      expect(error).to.be.an('error');
      expect(error.message).to.equal('Passed filename must end in .xlsx');
    });
  });

  describe('fs interactions:', () => {
    it('should call fs.accessSync once to check that we have read access to the file',async () => {
      const spy = sinon.spy();
      const mockFs = {
        accessSync: spy,
        constants: {
          R_OK: fs.constants.R_OK,
          W_OK: fs.constants.W_OK
        }
      };
      readExcelFileModule.__set__('fs', mockFs);
      try {
        await readExcelFile('test.xlsx');
      } catch (e) {
        // swallow error
      }
      expect(spy.callCount).to.equal(1);
    });
    
    it('should return error if access is not available',async () => {
      const mockFs = {
        accessSync: () => {
          throw new Error('File Access Unavailable');
        },
        constants: {
          R_OK: fs.constants.R_OK,
          W_OK: fs.constants.W_OK
        }
      };
      readExcelFileModule.__set__('fs', mockFs);
      let error;
      try {
        await readExcelFile('test.xlsx');
      } catch (e) {
        error = e;
      }
      expect(error).to.be.an('error');
      expect(error.message).to.equal('File Access Unavailable');
    });
  });

  describe('XLSX interactions:', () => {
    let mockFs;

    beforeEach(() => {
      mockFs = {
        accessSync: () => true,
        constants: {
          R_OK: fs.constants.R_OK,
          W_OK: fs.constants.W_OK
        }
      };
      readExcelFileModule.__set__('fs', mockFs);
    });

    it('should call XLSX.readFile once with passed parameter and file is available', async () => {
      const spy = sinon.spy();
      const xlsxMock = {
        readFile: spy
      };
      readExcelFileModule.__set__('XLSX', xlsxMock);
      try {
        await readExcelFile('test.xlsx');
      } catch (e) {
        // swallow
      }
      expect(spy.calledOnceWith('test.xlsx')).to.be.true;
    });

    it('should catch and return error when XLSX.readFile errors', async () => {
      const errorMessage = 'XLSX not functioning';
      const xlsxMock = {
        readFile: () => {
          throw new Error(errorMessage);
        }
      };
      readExcelFileModule.__set__('XLSX', xlsxMock);
      let error;
      try {
        await readExcelFile('test.xlsx');
      } catch (e) {
        error = e;
      }
      expect(error).to.be.an('error');
      expect(error.message).to.equal(errorMessage);
    });

    it('if all good should correctly return workbook object supplied by XLSX.readFile', async () => {
      const workbook = 'Workbook';
      const xlsxMock = {
        readFile: () => workbook
      };
      readExcelFileModule.__set__('XLSX', xlsxMock);
      const returnedWorkbook = await readExcelFile('test.xlsx');
      expect(returnedWorkbook).to.equal(workbook);
    });
  });
});