#!/usr/bin/env node

const path = require('path');
const dateForFiles = require('../lib/date-for-files.js');
const moment = require('moment');
const fs = require('fs');

moment.locale('zh-cn');

let files = {};

markFiles(path.resolve(__dirname, '../src'))

let dates = dateForFiles()

Object.keys(dates).reverse().forEach(file => {
  let match = /^(.*)\.en\.html$/.exec(file);
  if (match) {
    let zhFile = path.resolve(__dirname, '..', match[1] + '.zh.html');
    if (!files[zhFile]) {
      let date = dates[file];
      let mm = moment(date);
      console.log(file, mm.fromNow());
    }
  }
})

function markFiles(dir) {
  fs.readdirSync(dir).forEach(file => {
    var fullpath = path.resolve(dir, file);
    if (/\.(en|zh)\.html$/.test(file)) {
      files[fullpath] = true;
    }
    else if (/^[\w-]+$/.test(file)) {
      markFiles(fullpath);
    }
  });
}

