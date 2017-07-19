'use strict';

/**
 * Lazily required module dependencies
 */

var utils = require('lazy-cache')(require);
var fn = require;
require = utils;

/**
 * Utils
 */

require('kind-of', 'typeOf');
require('is-accessor-descriptor', 'isAccessor');
require('is-data-descriptor', 'isData');
require = fn;

/**
 * Expose `utils`
 */

module.exports = utils;
