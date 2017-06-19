'use strict';

function toRegex(str, options) {
  options = options || {};

  if (options && options.contains === true) {
    options.strictNegate = false;
  }

  var open = options.strictOpen !== false ? '^' : '';
  var close = options.strictClose !== false ? '$' : '';
  return new RegExp(open + toRegex.create(str, options) + close);
}

toRegex.create = function(str, options) {
  if (typeof str !== 'string') {
    throw new TypeError('expected a string');
  }
  if (options && options.strictNegate === false) {
    return '(?:(?!(?:' + str + ')).)*';
  }
  return '(?:(?!^(?:' + str + ')$).)*';
};

module.exports = toRegex;
