'use strict';

const sinon = require('sinon');

module.exports = {
  PoolMock,
  DbConnectionMock,
  defineQueryReturnData
};

function defineQueryReturnData (data, calledWithFn) {
  let count;
  
  return (str) => {
    if (!(count)) {
      count = 0;
    } else {
      count++;
    }
    const returnData = data[count];

    if (calledWithFn) {
      calledWithFn(str, count);
    }

    return new Promise((res) => {
      res({
        rows: returnData
      });
    });
  };
};

function DbConnectionMock(fn) {
  this.query = fn;
  return {
    query: this.query,
    release: sinon.spy()
  };
}

function PoolMock({
  user,
  host,
  database,
  password,
  port
}) {
  this.config = {
    user,
    host,
    database,
    password,
    port
  };
  this.connect = () => Promise.resolve({
    result: 'Success',
    host: this.config.host
  });
  this.on = () => {};
  this.query = (str) => {
    return [];
  };
  return this;
}