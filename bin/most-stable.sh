#!/usr/bin/env bash

echo '修改日期 | 文件 | 相对时间'
echo '---      | ---  | ---'

for file in $(find src -name *.en.html -type f)
do
  if [ -f ${file/%.en.html/.zh.html} ]; then
    continue
  fi
  dates=`git log -1 --format="%ai|%ar" -- $file`
  echo ${dates%%|*} \| $file \| ${dates##*|}
done | sort -n | head -n 20
