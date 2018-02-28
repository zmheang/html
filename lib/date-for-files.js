#!/usr/bin/env node

const nodegit = require("nodegit");
const process = require('process');
const Promise = require('bluebird');
const path = require("path");

module.exports = function () {
  let repoDir = path.resolve(__dirname, "..");
  return Promise
    .resolve(nodegit.Repository.open(repoDir))
    .then(repo => repo.getMasterCommit())
    .then(firstCommit => filesInHistory(firstCommit.history()));
}

function filesInHistory(history) {
  return new Promise((resolve, reject) => {
    let files = {};
    let commits = [];

    history.on("commit", commit => commits.push(commit));
    history.on("error", reject);
    history.on("end", () => {
      return Promise.resolve(commits)
      .map(commit => {
        let date = commit.date();
        return Promise
        .resolve(commit.getDiff())
        .map(diff => diff.patches())
        .map(patches => patches.forEach(patch => {
            record(patch.oldFile().path(), date);
            record(patch.newFile().path(), date);
        }))
      })
      .then(() => resolve(files))
      .catch(e => reject(e))
    });
    history.start();

    function record(path, date) {
      if (files[path]) { return; }
      files[path] = date;
    }
  });
}
