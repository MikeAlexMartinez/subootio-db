'use strict';

module.exports = {
  createColumnHeaderString
};

function createColumnHeaderString({
  headers,
  withDates,
}) {
  const headersToStringify = withDates
    ? headers.concat(['date_created', 'date_modified'])
    : headers;
  return headersToStringify.join(', ');
}