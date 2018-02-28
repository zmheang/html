const gitlog = require('gitlog');
const options = { repo: __dirname + '/..',
  number: 10000,
  fields: ['hash' , 'authorDate']
};

module.exports = function() {
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
