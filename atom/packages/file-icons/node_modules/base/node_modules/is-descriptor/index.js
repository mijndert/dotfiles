/*!
 * is-descriptor <https://github.com/jonschlinkert/is-descriptor>
 *
 * Copyright (c) 2015, 2017, Jon Schlinkert.
 * Released under the MIT License.
 */

'use strict';

var utils = require('./utils');

module.exports = function isDescriptor(obj, key) {
  if (utils.typeOf(obj) !== 'object') {
    return false;
  }
  if ('get' in obj) {
    return utils.isAccessor(obj, key);
  }
  return utils.isData(obj, key);
};
