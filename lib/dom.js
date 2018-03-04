const parse5 = require('parse5')

function filter (node, cb) {
  let ret = []
  dfs(node, node => {
    if (cb(node)) {
      ret.push(node)
    }
  })
  return ret
}

function normalize(node) {
  node.innerHTML = parse5.serialize(node)
  if (node.attrs) {
    node.attrs.forEach(attr => {
      node.attrs[attr.name] = attr.value
    })
  }
}

function dfs (node, cb) {
  normalize(node)
  cb(node)
  let children = node.childNodes || []
  children.forEach(child => dfs(child, cb))
}

function queryTagname (node, name) {
  return filter(node, node => node.tagName === name)
}

module.exports = {filter, dfs, queryTagname}
