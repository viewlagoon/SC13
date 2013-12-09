#!/usr/bin/perl -w
use strict;
while(<>){
  /^\s*#/ and next;
  s/^\s*//g;
	s/\r\n/\n/g;
  print;
}

