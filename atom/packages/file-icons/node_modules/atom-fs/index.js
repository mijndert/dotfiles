"use strict";

const namedExports = new Map([
	["FileSystem", "./lib/filesystem.js"],
	["EntityType", "./lib/entity-type.js"],
	["System",     "./lib/system.js"], // TODO: Rename
	["Resource",   "./lib/resource.js"],
	["File",       "./lib/file.js"],
	["Directory",  "./lib/directory.js"]
]);

for(const [key, value] of namedExports)
	Object.defineProperty(module.exports, key, {
		configurable: false,
		writable:     false,
		enumerable:   false,
		value: require(value),
	});

global.AtomFS = module.exports.FileSystem;
