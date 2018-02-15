#!/usr/bin/env bash

[ "$1" == "-t" ] || [ "$1" == "--table" ]
table=$?

if [ $table == 0 ]; then
  echo '修改日期 | 文件 | 相对时间'
  echo '---      | ---  | ---'
fi

for file in $(find src -name *.en.html -type f)
do
  if [ -f ${file/%.en.html/.zh.html} ]; then
    continue
  fi
  dates=`git log -1 --format="%ai|%ar" -- $file`
  if [ $table == 0 ]; then
    echo ${dates%%|*} \| $file \| ${dates##*|}
  else
    echo  $file, updated ${dates##*|}
  fi
done | sort -n | head -n 20
