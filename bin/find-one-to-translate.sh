#!/usr/bin/env bash

for file in $(find src -name *.en.html -type f)
do
  if [ -f ${file/%.en.html/.zh.html} ]; then
    continue
  fi
  dates=`git log -1 --format="%ai|%ar" -- $file`
  echo ${dates%%|*} \| $file \| ${dates##*|}
done | sort -n | awk -F'|' '{print $2 updated at $3}' | head -n 20
