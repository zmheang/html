const gitlog = require('gitlog');
const fs = require('fs');
const path = require('path');
const Promise = require('bluebird')
const sourceFilename = path.resolve(__dirname, '../html/source')
const options = { repo: __dirname + '/..',
  number: 10000,
  fields: ['hash' , 'authorDate']
};

exports.readSource = function () {
  return Promise.fromCallback(cb => fs.readFile(sourceFilename, 'utf8', cb))
}

exports.dates = function () {
  let commits = gitlog(options);
  let dates = {};

  commits.forEach(commit => {
    commit.files.forEach(file => {
      if (!dates[file]) {
        dates[file] = new Date(commit.authorDate);
      }
    })
  });
  return dates;
}

exports.files = function () {
  let files = {};
  markFiles(path.resolve(__dirname, '../src'), files);
  return files;
}

function markFiles(dir, dates) {
  fs.readdirSync(dir).forEach(file => {
    var fullpath = path.resolve(dir, file);
    if (/\.(en|zh)\.html$/.test(file)) {
      dates[fullpath] = true;
    }
    else if (/^[\w-]+$/.test(file)) {
      markFiles(fullpath, dates);
    }
  });
}
