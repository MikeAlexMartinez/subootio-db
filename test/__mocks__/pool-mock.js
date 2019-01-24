'use strict';

module.exports = PoolMock;

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