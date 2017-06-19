"use babel";

import {CompositeDisposable} from 'atom';
import LivereloadView from './livereload-view';
import config from './config';
import Server from './server';
import options from '../options.json';

function createView(self) {
  var view = new LivereloadView();

  view.addEventListener('toggle', () => {
    var server = self.server;
    if (server.activated) {
      // turning off the server
      [view.url, view.text, view.tooltip] = ['', '...', 'Stopping LiveReload server...'];
      server.stop();
    } else {
      // turning on the server
      [view.url, view.text, view.tooltip] = ['', '...', 'Starting LiveReload server...'];
      server.start();
    }
  });

  return view;
}

function createServer(self) {
  var server = new Server(config());

  server.on('newport', () => {
    self.view.tooltip = 'Trying another port...';
  });

  server.on('start', port => {
    var view = self.view;

    view.url = (server.config.useHTTPS ? 'https' : 'http') + `://localhost:${server.address.port}/livereload.js`;
    view.text = server.address.port;
    view.tooltip = 'Click to copy the URL to clipboard';

    let paths = atom.project.getPaths();
    server.watch(paths);
  });

  server.on('stop', () => {
    [self.view.url, self.view.text, self.view.tooltip] = ['', 'Off', 'LiveReload server is currently turned off.'];
    server.unwatch();
  });

  return server;

}

export default {
  view: null,
  server: null,
  activated: false,
  config: options,

  activate(state) {
    this.server = createServer(this);

    this.view = createView(this);
    this.view.initialize(state);
    this.view.attach();

    if (this.server.config.autoStart && !this.server.activated) {
      this.view.dispatchEvent(new Event('toggle'));
    }
  },

  deactivate() {
    if (this.statusBarTile) this.statusBarTile.destory();
    this.statusBarTile = null;

    this.view.detach();
    this.view.destroy();
    if (this.server) {
      this.server.stop();
      this.server = null;
    }
  },

  serialize() {
    return { activated: (this.server && this.server.activated)  };
  },

  consumeStatusBar(statusBar) {
    this.statusBarTile = statusBar.addRightTile({item:this.view, priority:100});
  }
};
