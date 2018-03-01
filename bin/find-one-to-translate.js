#!/usr/bin/env node

const path = require('path');
const git = require('../lib/git.js');
const moment = require('moment');

moment.locale('zh-cn');

let dates = git.dates();
let files = git.files();

Object.keys(dates).reverse().forEach(file => {
  let match = /^(.*)\.en\.html$/.exec(file);
  if (match) {
    let zhFile = path.resolve(__dirname, '..', match[1] + '.zh.html');
    let enFile = path.resolve(__dirname, '..', file);
    if (files[enFile] && !files[zhFile]) {
      let date = dates[file];
      let mm = moment(date);
      console.log(file, mm.fromNow());
    }
  }
})

