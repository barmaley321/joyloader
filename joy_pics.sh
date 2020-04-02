#!/bin/sh

#url examples:
#joyreactor.cc/tag/anon/9061
#joyreactor.cc/19727

#output:
folder=gifs

#category:
tag=Игры

#ftype=jpeg
ftype=gif

#page range:
for i in {2133..2130}; do

  wget joyreactor.cc/tag/$tag/$i;

  #picks up only uniq numeric pic id's aka *-1234567.jpeg:
  cat $i| grep -oE "http://img10.joyreactor.cc/pics/post/[a-zA-Z0-9/%-]*\.$ftype" | grep -oE "[0-9]*\.$ftype" | sort| uniq > id;

  #pics up all urls:
  cat $i| grep -oE "http://img10.joyreactor.cc/pics/post/[a-zA-Z0-9/%-]*\.$ftype" | sort | uniq > all_url;

  #pics up urls with "full" in it:
  cat $i| grep -oE "http://img10.joyreactor.cc/pics/post/full[a-zA-Z0-9/%-]*\.$ftype" | sort | uniq > full_url;

  #if grep returns something in "full", it will download from /post/full/imgname; else it will download /post/imgname (aka no link to bigger image):
  while read line; do
    cat all_url| if grep $line | grep -q full;
                   then cat all_url | grep $line |grep full | wget -P $folder -i -;
                   else cat all_url | grep $line | wget -P $folder -i -;
                 fi;
  done < id;

  rm $i;
  rm all_url
  rm full_url
done

#get previous page
#cat 2133 | grep -oE "href='/tag[a-zA-Z0-9/%' =>]*Дальше" | grep -Eo "[0-9]{4}"

