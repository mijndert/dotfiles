"use babel";

import _ from 'lodash';

const DEFAULT_EXTS = 'html css js png gif jpg php php5 py rb erb coffee'.split(' ');
const DEFAULT_EXCLUSIONS = '.DS_Store .gitignore .git/ .svn/ .hg/'.split(' ');

export default function config() {
  var custom = {
    // port number
    port: atom.config.get('livereload.port'),

    // use HTTPS
    https: atom.config.get('livereload.useHTTPS') ? {} : null,

    // applyCSSLive
    applyCSSLive: atom.config.get('livereload.applyCSSLive') || true,

    // applyImageLive
    applyImageLive: atom.config.get('livereload.applyImageLive') || false,

    // delay for update
    delayForUpdate: atom.config.get('livereload.delayForUpdate'),

    // auto start
    autoStart: !!atom.config.get('livereload.autoStart'),

    // exts
    exts: atom.config.get('livereload.exts').split(','),

    // exclusions
    exclusions: atom.config.get('livereload.exclusions').split(',')
  };

  // exts
  custom.exts = _.chain(custom.exts).map( ext => ext.trim() ).concat(DEFAULT_EXTS).uniq().value();

  // exclusions
  custom.exclusions = _.chain(custom.exclusions).map( ex => ex.trim() ).concat(DEFAULT_EXCLUSIONS).uniq().map( pattern => { return new RegExp(pattern.replace(/([.\\\/])/g, '\\$1' )) } ).value();

  return custom;
}
