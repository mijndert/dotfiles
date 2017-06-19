"use babel";

import EventEmitter from 'events';
import http from 'http';
import https from 'https';
import url from 'url';
import fs from 'fs';
import path from 'path';
import WebSocket from 'faye-websocket';
import chokidar from 'chokidar';
import _ from 'lodash';

const PROTOCOL_CONN_CHECK_1 = 'http://livereload.com/protocols/connection-check-1';
const PROTOCOL_MONITORING_7 = 'http://livereload.com/protocols/official-7';
const PROTOCOL_SAVING_1 = 'http://livereload.com/protocols/saving-1';

class Server extends EventEmitter {
  paths = [];
  sockets = [];
  app = null;
  watcher = null;
  _url = ''; // client url

  constructor(config) {
    super();
    this.config = _.assign({}, config);
    this.paths = [];
  }

  initServer() {
    var config = this.config;

    if (config.https === null) {
      this.app = http.createServer(this.handleRequest);
    } else {
      this.app = https.createServer(config.https, this.handleRequest);
    }

    this.app.on('error', err => {
      if (err.code === 'EADDRINUSE') {
        setTimeout(this.start.bind(this, 0), 100);

        this.debug(`LiveReload: port ${this.config.port} already in use. Trying another port...`);
        this.emit('newport');
      }
    });

    this.app.on('listening', () => {
      this.debug(`LiveReload: listening on port ${this.address.port}.`);
      this.emit('start');
    });

    this.app.on('upgrade', (request, socket, body) => {
      if (!WebSocket.isWebSocket(request)) return;
      var ws = new WebSocket(request, socket, body);

      ws.on('message', event => {
        var data = event.data, json;
        try {
          json = JSON.parse(event.data);
          if (typeof json.command === 'string') {
            this.handleCommand(json);
          }
        } catch(e) { }
      });

      ws.on('close', event => {
        this.sockets = this.sockets.filter( sock => (sock !== ws) );
        ws = null;
      });

      this.sockets.push(ws);
    });
  }

  start(port) {
    if (typeof port === 'undefined') {
      port = this.config.port;
    }
    if (!this.app) {
      this.initServer();
    }
    this.app.listen(port);
  }

  stop() {
    if (this.app) {
      this.app.close();
      this.app = null;
    }

    this.sockets = [];
    this.unwatch();

    this.emit('stop');
  }

  watch(paths) {
    paths = paths.filter( path => !/^atom\:\/\//.test(path) );

      if (paths.length < 1) return;

      this.paths = [...this.paths, ...paths];

      if (this.watcher) {
        this.watcher.watch(paths);
        return;
      }

      this.watcher = chokidar.watch(paths, {
        ignoreInitial: true,
        ignored: this.config.exclusions
      });

      var _refresh = this.refresh.bind(this);

      this.watcher
      .on('add', _refresh)
      .on('change', _refresh)
      .on('unlink', _refresh);
  }

  unwatch() {
    if (this.watcher) {
      this.watcher.unwatch(this.paths);
      this.watcher.close();
    }
    this.watcher = null;
    this.paths = [];
  }

  refresh(filepath) {
    var extname = path.extname(filepath).substring(1);

    if (this.config.exts.indexOf(extname) < 0) return;

    setTimeout(
      this.send.bind(this, {
        command: 'reload',
        path: filepath,
        liveCSS: this.config.applyCSSLive,
        liveImg: this.config.applyImageLive
      }),
      this.config.delayForUpdate
    );
  }

  handleRequest(req, res) {
    var content = '', status = 200, headers;

    switch (url.parse(req.url).pathname) {
      case '/':
        res.writeHead(200, {'Content-Type': 'application/json'});
        break;
      case '/livereload.js':
      case '/xlivereload.js':
        res.writeHead(200, {'Content-Type': 'text/javascript'});
        content = fs.readFileSync(__dirname + '/../node_modules/livereload-js/dist/livereload.js');
        break;
      default:
        res.writeHead(300, {'Content-Type': 'text/plain'});
        content = 'Not Found';
    }

    res.end(content);
  }

  handleCommand(command) {
    switch (command.command) {
      case 'hello':
        this.send({
          command: 'hello',
          protocols: [PROTOCOL_MONITORING_7],
          serverName: 'atom-livereload'
        });
        break;
      case 'ping':
      this.send({
        command: 'pong',
        token: command.token
      });
      break;
    }
  }

  get activated() {
    return !!this.app;
  }

  get address() {
    return this.app.address();
  }

  debug(text) {
    if (this.config.debug || true) {
      console.log(text);
    }
  }

  send(command) {
    this.sockets.forEach( sock => {
      sock.send(JSON.stringify(command));
    });
  }
}

export default Server;
