#!/bin/sh

ruby makeYomi.rb > a.txt
sort -u a.txt > b.txt
perl myYomi2Voca.pl b.txt > c.txt
