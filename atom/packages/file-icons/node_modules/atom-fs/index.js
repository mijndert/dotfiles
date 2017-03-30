"use strict";

/**
 * @file API entry point.
 *
 * Globalise a singleton instance of {@link FileSystem} that serves as
 * the grand hub of all Atom/filesystem communication. Prevent multiple
 * instances being created per process, even if version requirements
 * differ.
 *
 * This is an abstraction layer, so we can get away with the assumption
 * there'll only be a single, shared dependency between package modules.
 */

global.AtomFS = global.AtomFS || (function(){
	const namedExports = new Map([
		["FileSystem", "./lib/filesystem.js"],
		["EntityType", "./lib/entity-type.js"],
		["System",     "./lib/system.js"], // TODO: Rename
		["Resource",   "./lib/resource.js"],
		["File",       "./lib/file.js"],
		["Directory",  "./lib/directory.js"]
	]);
	const result = {};
	for(const [key, value] of namedExports)
		Object.defineProperty(result, key, {
			configurable: false,
			writable:     false,
			enumerable:   false,
			value: require(value),
		});
	return result;
}());

module.exports = global.AtomFS;
