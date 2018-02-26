const fs = require('fs');
const spawnSync = require('child_process').spawnSync
const path = require('path');
const skeletonPath = path.resolve(__dirname, '../skeleton.html');

const skeleton = fs.readFileSync(skeletonPath, 'utf8');
const rFile = /<file src="([^"]*?)">/g;
const root = path.resolve(__dirname, '..');

let match;
let target = '';
let begin = 0;
let fast = false;

process.argv.forEach(arg => {
  if (arg === 'fast' ) {
    fast = true;
    console.error('fast mode enabled, skipping file update date');
  }
});

while (match = rFile.exec(skeleton)) {
    let enPath = 'src/' + match[1] + '.en.html';
    let zhPath = 'src/' + match[1] + '.zh.html';

    let enModified = modified(enPath);
    let zhModified = modified(zhPath);
    let content;
    try {
      content = fs.readFileSync(path.resolve(root, zhPath), 'utf8');
    } catch (e) {
        if (e.code === 'ENOENT') {
          content = fs.readFileSync(path.resolve(root, enPath), 'utf8');
        } else {
          throw e;
        }
    }

    let zhLink = `https://github.com/whatwg-cn/html/edit/master/${zhPath}`;
    let enLink = `https://github.com/whatwg-cn/html/blob/master/${enPath}`;

    if (!zhModified) {
      let content = '从 ' + enLink + ' 拷贝英文源码至此，开始翻译';
      zhLink = `https://github.com/whatwg-cn/html/new/master/${zhPath}`;
      zhLink += '?filename=' + path.basename(zhPath);
      zhLink += '&value=' + encodeURIComponent(content);
    }

    content = content.replace(
      /<h[2-6](\s[^>]+)?>[\s\S]*?<\/h[2-6]>/,
      (match) => {
        let attr =  'class="translate-info"';
        attr += ` data-zh-file="${zhLink}"`;
        attr += ` data-zh-date="${zhModified}"`;
        attr += ` data-en-file="${enLink}"`;
        attr += ` data-en-date="${enModified}"`;
        return `${match}\n<div ${attr}></div>`;
      }
    )

    target += skeleton.slice(begin, match.index);
    target += content;
    begin = match.index + match[0].length;
}

target += skeleton.slice(begin);
process.stdout.write(target);

function modified(file) {
  if (fast) return 'Unkown due to fast build';
  let result = spawnSync('git', ['log', '-1', '--format="%ai (%ar)"', '--', file]);
  if (result.error) {
    throw result.error;
  }
  let str = String(result.stdout);
  return str.trim().replace(/"/g, '');
}
