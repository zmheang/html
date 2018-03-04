#!/usr/bin/env node

const Promise = require('bluebird')
const utils = require('../lib/utils.js')
const parse5 = require('parse5')
const dom = require('../lib/dom.js')
const repo = require('../lib/repo.js')

Promise.all([
  utils.readStdin(),
  repo.readSource().then(extractDfns)
])
.spread((content, dfns) => content.replace(/<span>(.+?)<\/span>/g, (str, idstr) => {
  let id = normalize(idstr)
  let value = dfns[id]
  return value ? `<span data-x="${id}">${value}</span>` : str 
}))
.then(translated => process.stdout.write(translated))
.catch(e => {
  if (e.code === 'ENOENT') {
    console.error('html/source not found, `npm run build` first')
  }
  console.error(e.message, e.stack)
})

function extractDfns (content){
  let root = parse5.parse(content)
  let dfns = {}
  dom
  .dfs(root, node => {
    if (/^dfn|span$/.test(node.nodeName) && node.attrs['data-x']) {
      var id = normalize(node.attrs['data-x'])
      var value = node.innerHTML
    }
    if (!utils.hasChinese(value)) {
      return
    }
    if (node.nodeName === 'dfn' || !dfns[id]) {
      dfns[id] = value
    }
  })
  return dfns
}

function normalize(id) {
  return id.trim().replace(/\s+/g, '-').toLowerCase()
}
