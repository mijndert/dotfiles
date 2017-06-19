"use babel";

class LivereloadView extends HTMLDivElement {
  _link = null;
  _tooltip = null;
  _command = null;

  initialize(state) {
    // add content
    this.innerHTML = '<a href="#" data-url></a>';
    this.firstChild.addEventListener('click', event => this.handleClick(event), false);

    // add classes
    this.classList.add('livereload-status', 'inline-block');

    this.url = '';
    this.text = 'Off';
    this.tooltip = '';
  }

  attach() {
    // Register command that toggles this view
    this._command = atom.commands.add( 'atom-workspace', { 'livereload:toggle': this.toggle.bind(this) } )
  }

  detach() {
    this._tooltip.dispose();
    this._command.dispose();
  }

  serialize() {
    return this._activated;
  }

  destroy() {
    try { this.detach() } catch(e){};
    this.remove();
  }

  toggle() {
    var event = new Event('toggle');
    this.dispatchEvent(event);
  }

  handleClick(event) {
    event.preventDefault();
    if (this.url) {
      atom.clipboard.write(this.url, 'url');
    }
  }

  set text(text) {
    this.firstChild.textContent = 'LiveReload: ' + text;
  }

  get text() {
    return this.firstChild.textContent;
  }

  set url(url) {
    this.firstChild.dataset.url = url;
  }

  get url() {
    return this.firstChild.dataset.url;
  }

  set tooltip(text) {
    if (this._tooltip) this._tooltip.dispose();
    this._tooltip = atom.tooltips.add( this, { title: text } );
  }
}

export default document.registerElement('livereload-status-bar', {prototype:LivereloadView.prototype});
