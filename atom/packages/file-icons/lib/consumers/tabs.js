"use strict";

const {CompositeDisposable} = require("atom");
const Tab = require("./tab.js");
const UI  = require("../ui.js");


class Tabs{
	
	init(){
		this.active = false;
		this.tabs = new Set();
		this.tabsByElement = new WeakMap();
		const workspace = atom.views.getView(atom.workspace);
		this.tabElements = workspace.getElementsByClassName("tab");
		
		setImmediate(_=> this.checkPackage());
		this.disposables = new CompositeDisposable(
			atom.packages.onDidActivatePackage(_=> this.checkPackage()),
			atom.packages.onDidDeactivatePackage(_=> this.checkPackage()),
			atom.packages.onDidActivateInitialPackages(_=> this.checkPackage()),
			
			UI.delay.onOpenArchive(editor => {
				const tabEl = this.tabForEditor(editor);
				this.add(tabEl);
			}),
			
			UI.delay.onOpenEditor(editor => {
				const tabEl = this.tabForEditor(editor);
				this.add(tabEl);
			}),
			
			UI.delay.onSaveNewFile(args => {
				const tab = this.tabForEditor(args.editor);
				this.fixIcon(tab);
				this.add(tab);
			})
		);
	}
	
	
	reset(){
		this.active = false;
		this.tabs.forEach(tab => this.remove(tab));
		this.tabs.clear();
		this.tabs = null;
		
		this.tabElements = null;
		this.tabsByElement = null;
		this.disposables.dispose();
		this.disposables = null;
	}
	
	
	/**
	 * Query the activation status of the Tabs package.
	 *
	 * @private
	 */
	checkPackage(){
		const tabsPackage = atom.packages.activePackages["tabs"];
		
		if(tabsPackage && !this.active){
			this.active = true;
			this.package = tabsPackage.mainModule;
			for(const bar of this.package.tabBarViews)
				for(const tab of bar.getTabs())
					this.add(tab);
		}
		
		else if(!tabsPackage && this.active){
			this.active = false;
			this.package = null;
			for(const tab of this.tabs)
				this.remove(tab);
		}
	}
	
	
	add(tabElement){
		if(this.shouldAdd(tabElement)){
			const tab = new Tab(tabElement, tabElement.item);
			this.tabs.add(tab);
			this.tabsByElement.set(tabElement, tab);
			
			const disposable = tab.onDidDestroy(_=> {
				this.disposables.remove(disposable);
				disposable.dispose();
				this.remove(tabElement);
			});
			this.disposables.add(disposable);
		}
	}
	
	
	/**
	 * Determine if an element should be used to register a {Tab} instance.
	 *
	 * @param {HTMLElement} element
	 * @return {Boolean}
	 */
	shouldAdd(element){
		if(!element || this.tabsByElement.has(element))
			return false;
		
		const {item} = element;
		if(atom.workspace.isTextEditor(item) && undefined !== item.buffer.getPath())
			return true;
		
		if("ArchiveEditor" === item.constructor.name)
			return true;
		
		return false;
	}
	
	
	remove(tabElement){
		const tab = this.tabsByElement.get(tabElement);
		if(tab){
			this.tabs.delete(tab);
			this.tabsByElement.delete(tabElement);
			tab.destroy();
		}
	}
	
	
	tabForEditor(editor){
		const {length} = this.tabElements;
		for(let i = 0; i < length; ++i){
			const el = this.tabElements[i];
			if(el.item !== editor) continue;
			const {type} = el.dataset;
			if("TextEditor" === type || "ArchiveEditor" === type)
				return el;
		}
		return null;
	}
	
	
	fixIcon(tab){
		
		// TODO: Remove check/updateIcon() once atom/tabs#402 is public
		if("function" === typeof tab.updateIcon)
			tab.updateIcon();
		
		tab.itemTitle.classList.add("icon");
	}
	
	
	get length(){
		return this.tabs
			? this.tabs.size
			: 0;
	}
	
	
	closeAll(){
		const workspace = atom.views.getView(atom.workspace);
		atom.commands.dispatch(workspace, "tabs:close-all-tabs");
	}
	
	
	// TODO: A hot cup of Chai. Now.
	ls(){
		const tabs = [];
		for(const paneItem of atom.workspace.getPaneItems()){
			const name = paneItem.getFileName();
			const tab = this.tabForEditor(paneItem);
			tabs.push(tab);
			Object.defineProperty(tabs, name, {value: tab.itemTitle});
		}
		return tabs;
	}
}


module.exports = new Tabs();
