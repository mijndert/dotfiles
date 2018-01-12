"use strict";

const instanceData = new WeakMap();
const {posix, win32} = require("path");


/**
 * Collection of arbitrary values keyed to filesystem paths.
 * 
 * @class
 */
class PathMap extends Map {

	/**
	 * Instantiate a new PathMap.
	 *
	 * @param {*} [iterable] - An iterable in the format expected by {@link Map} constructors.
	 * @constructor
	 */
	constructor(iterable = null){
		super();
		this.forcePosix = true;
		this.ignoreCase = true;
		instanceData.set(this, new Map());
		if(null !== iterable)
			for(const [key, value] of iterable)
				this.set(key, value);
	}
	
	
	/**
	 * Apply transformations to a key before using it for storage and lookup.
	 *
	 * @internal
	 * @param {String} input
	 * @return {String}
	 */
	filterPath(input){
		if(!input) return "";
		if(this.forcePosix) input = this.normalisePath(input);
		if(this.ignoreCase) input = input.toLowerCase();
		return this.trimSlash(input);
	}
	
	
	/**
	 * Resolve a path and replace backslashes with forward-slashes.
	 *
	 * @internal
	 * @param {String} input
	 * @return {String}
	 */
	normalisePath(input){
		input = win32.normalize(input || "").replace(/\\/g, "/");
		input = posix.normalize(input);
		return this.trimSlash(input);
	}


	/**
	 * Repopulate the instance's internal data-store.
	 *
	 * Call this after changing `ignoreCase` or `forcePosix`.
	 */
	reindex(){
		const data = instanceData.get(this);
		data.clear();
		for(const [key, value] of this)
			data.set(this.filterPath(key), value);
	}
		

	/**
	 * Remove a trailing slash from a path, if needed.
	 *
	 * @internal
	 * @param {String} input
	 * @return {String}
	 */
	trimSlash(input){
		return (input.length > 1)
			? input.replace(/[\\\/]$/, "")
			: input;
	}

	
	/**
	 * Retrieve the value keyed to a path.
	 *
	 * @param {String} key
	 * @return {*}
	 */
	get(key){
		const data = instanceData.get(this);
		return data.get(this.filterPath(key));
	}
	
	
	/**
	 * Add or replace the value keyed to a filesystem path.
	 *
	 * @param {String} key
	 * @param {*} value
	 * @return {PathMap} Reference to the calling instance
	 */
	set(key, value){
		const data = instanceData.get(this);
		data.set(this.filterPath(key), value);
		return super.set(this.normalisePath(key), value);
	}
	
	
	/**
	 * Check if an entry exists that's been keyed to this pathname.
	 *
	 * @param {String} key
	 * @return {Boolean}
	 */
	has(key){
		const data = instanceData.get(this);
		return data.has(this.filterPath(key));
	}	
	
	
	/**
	 * Empty the contents of the PathMap.
	 */
	clear(){
		const data = instanceData.get(this);
		data.clear();
		return super.clear();
	}
	
	
	/**
	 * Remove an entry from the PathMap.
	 * 
	 * @param {String} key
	 * @return {Boolean} Whether an entry using this key existed and was deleted.
	 */
	delete(key){
		const data = instanceData.get(this);
		data.delete(this.filterPath(key));
		return super.delete(this.normalisePath(key));
	}
}

Object.defineProperty(PathMap.prototype, Symbol.toStringTag, {value: "PathMap"});
module.exports = PathMap;
