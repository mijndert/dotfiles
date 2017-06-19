# extglob [![NPM version](https://img.shields.io/npm/v/extglob.svg?style=flat)](https://www.npmjs.com/package/extglob) [![NPM monthly downloads](https://img.shields.io/npm/dm/extglob.svg?style=flat)](https://npmjs.org/package/extglob)  [![NPM total downloads](https://img.shields.io/npm/dt/extglob.svg?style=flat)](https://npmjs.org/package/extglob) [![Linux Build Status](https://img.shields.io/travis/jonschlinkert/extglob.svg?style=flat&label=Travis)](https://travis-ci.org/jonschlinkert/extglob) [![Windows Build Status](https://img.shields.io/appveyor/ci/jonschlinkert/extglob.svg?style=flat&label=AppVeyor)](https://ci.appveyor.com/project/jonschlinkert/extglob)

> Extended glob support for JavaScript. Adds (almost) the expressive power of regular expressions to glob patterns.

## Install

Install with [npm](https://www.npmjs.com/):

```sh
$ npm install --save extglob
```

* Convert an extglob string to a regex-compatible string.
* More complete (and correct) support than [minimatch](https://github.com/isaacs/minimatch) (minimatch fails a large percentage of the extglob tests)
* Handles [negation patterns](#extglob-patterns)
* Handles [nested patterns](#extglob-patterns)
* Organized code base, easy to maintain and make changes when edge cases arise
* As you can see by the [benchmarks](#benchmarks), extglob doesn't pay with speed for it's completeness, accuracy and quality.

**Heads up!**: This library only supports extglobs, to handle full glob patterns and other extended globbing features use [micromatch](https://github.com/jonschlinkert/micromatch) instead.

## Usage

The main export is a function that takes a string and options, and returns an object with the parsed AST and the compiled `.output`, which is a regex-compatible string that can be used for matching.

```js
var extglob = require('extglob');
console.log(extglob('!(xyz)*.js'));
```

## Extglob cheatsheet

Extended globbing patterns can be defined as follows (as described by the [bash man page](https://www.gnu.org/software/bash/manual/html_node/Pattern-Matching.html)):

| **pattern** | **regex equivalent** | **description** | 
| --- | --- | --- |
| `?(pattern-list)` | `(... | ...)?` | Matches zero or one occurrence of the given pattern(s) |
| `*(pattern-list)` | `(... | ...)*` | Matches zero or more occurrences of the given pattern(s) |
| `+(pattern-list)` | `(... | ...)+` | Matches one or more occurrences of the given pattern(s) |
| `@(pattern-list)` | `(... | ...)` <sup class="footnote-ref"><a href="#fn1" id="fnref1">[1]</a></sup> | Matches one of the given pattern(s) |
| `!(pattern-list)` | N/A | Matches anything except one of the given pattern(s) |

## API

### [extglob](index.js#L37)

Convert the given `extglob` pattern into a regex-compatible string. Returns an object with the compiled result and the parsed AST.

**Example**

```js
var extglob = require('extglob');
console.log(extglob('*.!(*a)'));
//=> '(?!\\.)[^/]*?\\.(?!(?!\\.)[^/]*?a\\b).*?'
```

**Params**

* `pattern` **{String}**
* `options` **{Object}**
* `returns` **{String}**

### [.match](index.js#L68)

Takes an array of strings and an extglob pattern and returns a new array that contains only the strings that match the pattern.

**Example**

```js
var extglob = require('extglob');
console.log(extglob.match(['a.a', 'a.b', 'a.c'], '*.!(*a)'));
//=> ['a.b', 'a.c']
```

**Params**

* `list` **{Array}**: Array of strings to match
* `pattern` **{String}**: Extglob pattern
* `options` **{Object}**
* `returns` **{Array}**: Returns an array of matches

### [.isMatch](index.js#L123)

Returns true if the specified `string` matches the given extglob `pattern`.

**Example**

```js
var extglob = require('extglob');

console.log(extglob.isMatch('a.a', '*.!(*a)'));
//=> false
console.log(extglob.isMatch('a.b', '*.!(*a)'));
//=> true
```

**Params**

* `string` **{String}**: String to match
* `pattern` **{String}**: Extglob pattern
* `options` **{String}**
* `returns` **{Boolean}**

### [.contains](index.js#L162)

Returns true if the given `string` contains the given pattern. Similar to `.isMatch` but the pattern can match any part of the string.

**Example**

```js
var extglob = require('extglob');
console.log(extglob.contains('aa/bb/cc', '*b'));
//=> true
console.log(extglob.contains('aa/bb/cc', '*d'));
//=> false
```

**Params**

* `str` **{String}**: The string to match.
* `pattern` **{String}**: Glob pattern to use for matching.
* `options` **{Object}**
* `returns` **{Boolean}**: Returns true if the patter matches any part of `str`.

### [.matcher](index.js#L196)

Takes an extglob pattern and returns a matcher function. The returned function takes the string to match as its only argument.

**Example**

```js
var extglob = require('extglob');
var isMatch = extglob.matcher('*.!(*a)');

console.log(isMatch('a.a'));
//=> false
console.log(isMatch('a.b'));
//=> true
```

**Params**

* `pattern` **{String}**: Extglob pattern
* `options` **{String}**
* `returns` **{Boolean}**

### [.create](index.js#L226)

Convert the given `extglob` pattern into a regex-compatible string. Returns an object with the compiled result and the parsed AST.

**Example**

```js
var extglob = require('extglob');
console.log(extglob.create('*.!(*a)').output);
//=> '(?!\\.)[^/]*?\\.(?!(?!\\.)[^/]*?a\\b).*?'
```

**Params**

* `str` **{String}**
* `options` **{Object}**
* `returns` **{String}**

### [.makeRe](index.js#L255)

Create a regular expression from the given `pattern` and `options`.

**Example**

```js
var extglob = require('extglob');
var re = extglob.makeRe('*.!(*a)');
console.log(re);
//=> /^[^\/]*?\.(?![^\/]*?a)[^\/]*?$/
```

**Params**

* `pattern` **{String}**: The pattern to convert to regex.
* `options` **{Object}**
* `returns` **{RegExp}**

## Options

Available options are based on the options from Bash (and the option names used in bash).

### options.nullglob

**Type**: `boolean`

**Default**: `undefined`

When enabled, the pattern itself will be returned when no matches are found.

### options.nonull

Alias for [options.nullglob](#optionsnullglob), included for parity with minimatch.

### options.cache

**Type**: `boolean`

**Default**: `undefined`

Functions are memoized based on the given glob patterns and options. Disable memoization by setting `options.cache` to false.

### options.failglob

**Type**: `boolean`

**Default**: `undefined`

Throw an error is no matches are found.

## Benchmarks

Last run on October 20, 2016

```sh
Benchmarking: (5 of 5)
 · negation-nested
 · negation-simple
 · range-false
 · range-true
 · star-simple

# benchmark/fixtures/isMatch/negation-nested.js (49 bytes)
  extglob x 1,988,591 ops/sec ±1.18% (84 runs sampled)
  minimatch x 73,335 ops/sec ±1.38% (84 runs sampled)

  fastest is extglob

# benchmark/fixtures/isMatch/negation-simple.js (43 bytes)
  extglob x 2,320,380 ops/sec ±1.71% (86 runs sampled)
  minimatch x 122,947 ops/sec ±1.28% (86 runs sampled)

  fastest is extglob

# benchmark/fixtures/isMatch/range-false.js (56 bytes)
  extglob x 1,729,572 ops/sec ±1.22% (84 runs sampled)
  minimatch x 112,566 ops/sec ±1.26% (85 runs sampled)

  fastest is extglob

# benchmark/fixtures/isMatch/range-true.js (56 bytes)
  extglob x 1,819,085 ops/sec ±1.28% (83 runs sampled)
  minimatch x 115,153 ops/sec ±1.50% (85 runs sampled)

  fastest is extglob

# benchmark/fixtures/isMatch/star-simple.js (46 bytes)
  extglob x 1,970,063 ops/sec ±1.46% (83 runs sampled)
  minimatch x 138,805 ops/sec ±1.31% (87 runs sampled)

  fastest is extglob
```

## Differences from Bash

This library has complete parity with Bash 4.3 with only a couple of minor differences.

* In some cases Bash returns true if the given string "contains" the pattern, whereas this library returns true if the string is an exact match for the pattern. You can relax this by setting `options.contains` to true.
* This library is more accurate than Bash and thus does not fail some of the tests that Bash 4.3 still lists as failing in their unit tests

## About

### Related projects

* [braces](https://www.npmjs.com/package/braces): Fastest brace expansion for node.js, with the most complete support for the Bash 4.3 braces… [more](https://github.com/jonschlinkert/braces) | [homepage](https://github.com/jonschlinkert/braces "Fastest brace expansion for node.js, with the most complete support for the Bash 4.3 braces specification.")
* [expand-brackets](https://www.npmjs.com/package/expand-brackets): Expand POSIX bracket expressions (character classes) in glob patterns. | [homepage](https://github.com/jonschlinkert/expand-brackets "Expand POSIX bracket expressions (character classes) in glob patterns.")
* [expand-range](https://www.npmjs.com/package/expand-range): Fast, bash-like range expansion. Expand a range of numbers or letters, uppercase or lowercase. See… [more](https://github.com/jonschlinkert/expand-range) | [homepage](https://github.com/jonschlinkert/expand-range "Fast, bash-like range expansion. Expand a range of numbers or letters, uppercase or lowercase. See the benchmarks. Used by micromatch.")
* [fill-range](https://www.npmjs.com/package/fill-range): Fill in a range of numbers or letters, optionally passing an increment or `step` to… [more](https://github.com/jonschlinkert/fill-range) | [homepage](https://github.com/jonschlinkert/fill-range "Fill in a range of numbers or letters, optionally passing an increment or `step` to use, or create a regex-compatible range with `options.toRegex`")
* [micromatch](https://www.npmjs.com/package/micromatch): Glob matching for javascript/node.js. A drop-in replacement and faster alternative to minimatch and multimatch. | [homepage](https://github.com/jonschlinkert/micromatch "Glob matching for javascript/node.js. A drop-in replacement and faster alternative to minimatch and multimatch.")

### Contributing

Pull requests and stars are always welcome. For bugs and feature requests, [please create an issue](../../issues/new).

### Contributors

| **Commits** | **Contributor**<br/> | 
| --- | --- | --- | --- | --- |
| 32 | [jonschlinkert](https://github.com/jonschlinkert) |
| 2 | [isiahmeadows](https://github.com/isiahmeadows) |
| 1 | [shinnn](https://github.com/shinnn) |

### Building docs

_(This document was generated by [verb-generate-readme](https://github.com/verbose/verb-generate-readme) (a [verb](https://github.com/verbose/verb) generator), please don't edit the readme directly. Any changes to the readme must be made in [.verb.md](.verb.md).)_

To generate the readme and API documentation with [verb](https://github.com/verbose/verb):

```sh
$ npm install -g verb verb-generate-readme && verb
```

### Running tests

Install dev dependencies:

```sh
$ npm install -d && npm test
```

### Author

**Jon Schlinkert**

* [github/jonschlinkert](https://github.com/jonschlinkert)
* [twitter/jonschlinkert](http://twitter.com/jonschlinkert)

### License

Copyright © 2016, [Jon Schlinkert](https://github.com/jonschlinkert).
Released under the [MIT license](https://github.com/jonschlinkert/extglob/blob/master/LICENSE).

***

_This file was generated by [verb-generate-readme](https://github.com/verbose/verb-generate-readme), v0.2.0, on October 20, 2016._

<hr class="footnotes-sep">
<section class="footnotes">
<ol class="footnotes-list">
<li id="fn1"  class="footnote-item">`@` isn't a RegEx character. <a href="#fnref1" class="footnote-backref">↩</a>

</li>
</ol>
</section>