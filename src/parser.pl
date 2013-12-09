#!/usr/bin/perl -w
use strict;
{
  my %h;
	my @cond=(1);
  my $fn="";
	my @str=();
  $h{_verbose}=0;
  for (;@ARGV;){
    my $sw=shift(@ARGV);
    if    ($sw=~/^-/){ $sw=$';
      if  ($sw=~/^h/){ showHelp(); exit; }
      if  ($sw=~/^v/){ ++$h{_verbose}; }
      if  ($sw=~/^q/){ $h{_verbose}=0; }
    }
    elsif ($sw=~/^(\w+)=(-?\w*)/){
      addHash(\%h,$1,$2);
    }
    elsif ($fn eq ""){ $fn=$sw; }
		else { die "ARGV invalid argument $sw"; }
  }
#########################################################
	open (FARG,"$fn") or die "FARG $fn $!";
  if ($h{_verbose}){ print STDERR "### parsed file: $fn ###\n"; }
	while (<FARG>){
		chomp;
		push (@str,$_);
	}
	close(FARG);
#########################################################
	my ($i,$iNext)=(0,0);
	for ($i=0;$i<@str;++$i){
    my $strT=$str[$i];
		if    ($strT!~/^\s*#\s*\$\s*/){
			my $line=lineStr($i);
		  if (ifCheck(\@cond))
			{ $strT=extract(\%h,$strT,$line); print "$strT\n"; }
			elsif ($h{_verbose}>=2) 
			{ print STDERR "$line skipped by 'if'. \@cond=(@cond)\n"; }
			next;
		}
		my $cur=$';
		my @tokens = ($cur=~/\s*('.*?'|[^;]+)/g);
		if ($h{_verbose}>=2){ print STDERR "tokens=(@tokens)\n"; }
		for my $tok (@tokens){
			my $iNx=0;
			if (ifCheck(\@cond)){ $iNx=copeCommandTrue (\%h,\@cond,$tok,$i); }
			else                { $iNx=copeCommandFalse(\%h,\@cond,$tok,$i); }
			if ($iNx!=$i){ $i=$iNx-1; last; }
		}
    #print STDERR "i=$i, cur=$cur, cond=@cond\n";
	}
  if ($h{_verbose}){ print STDERR "### end    file: $fn ###\n"; }
	@cond==1 or die "syntax error #\$if - else - endif. cond=(@cond)";
}
sub showHelp{
  print STDERR "parser.pl [-h : help] [-v : verbose+=1] [-q : verbose=0] [var_name=89] input_file(s)\n";
}

sub derefHash {
  my $rh  =shift;
  my $key =shift;
  my $line=shift;
  exists ($rh->{$key}) or die "$line undefined variable \@$key";
  return $rh->{$key};
}
sub addHash {
  my $rh  =shift;
  my $key =shift;
  my $val =shift;
  $rh->{$key}=$val;
  #print STDERR "declaration : $key -> $val\n";
}
sub ifCheck {
  my     $rc = shift;
  return $rc->[$#{$rc}]%2==1;
}
sub setElse {
  my $rc  =shift;
  my $line=shift;
  @$rc>1              or  die "$line invalid else (no match if?)";
  my $t=$rc->[$#{$rc}];
  ($t&8)              and die "$line invalid else (missing endwhile?)";
  my $u=($t>3?$t:3-$t);
  $rc->[$#{$rc}]=$u;
  #print STDERR "$line setElse $#{$rc} $u\n";
}
sub setEndif {
  my $rc  =shift;
  my $line=shift;
  @$rc>1             or  die "$line invalid endif (no match if?)";
  ($rc->[$#{$rc}]&8) and die "$line invalid endif (missing endwhile?)";
  pop (@$rc);
  #print STDERR "$line setEndif $#{$rc}\n";
}
sub setEndwhile {
  my $rc  =shift;
  my $line=shift;
  @$rc>1             or  die "$line invalid endwhile (no match while?)";
	my $t   =$rc->[$#{$rc}];
  ($t&8) or  die "$line invalid endwhile (missing endif?)";
  pop (@$rc);
  #print STDERR "$line setEndif $#{$rc}\n";
	return $t>>4;
}
sub copeCommandFalse {
  my $rh  =shift;
  my $rc  =shift;
  my $cur =shift;
	my $i   =shift;
  my $line=lineStr(1+$i);
	if ($cur=~/^else\b/)
	{ setElse    ($rc,$line); }
	elsif ($cur=~/^endif\b/)
	{ setEndif   ($rc,$line); }
	elsif ($cur=~/^endwhile\b/)
	{ setEndwhile($rc,$line); }
	elsif ($cur=~/^if\b/)
	{ push(@$rc,4); }
	elsif ($cur=~/^while\b/)
	{ push(@$rc,12); }
	return $i;
}
sub copeCommandTrue {
  my $rh  =shift;
  my $rc  =shift;
  my $cur =shift;
	my $i   =shift;
  my $line=lineStr(1+$i);
  if    ($cur=~/^\s*$/    ) { return $i; }
  $cur=extract($rh,$cur,$line);
  #print STDERR "$line $cur\n";
  if    ($cur=~/^else\s*/    ) {    setElse    ($rc,$line); }
  elsif ($cur=~/^endif\s*/   ) {    setEndif   ($rc,$line); }
  elsif ($cur=~/^endwhile\s*/) { $i=setEndwhile($rc,$line); }
  elsif ($cur=~/^if\s+(-?\w+)\s*([<=>!]=?)\s*(-?\w+)\s*/){
    my  ($lhs,$op,$rhs)=($1,$2,$3);
    push(@$rc,operate($lhs,$op,$rhs,$line));
  }
  elsif ($cur=~/^while\s+(-?\w+)\s*([<=>!]=?)\s*(-?\w+)\s*/){
    my  ($lhs,$op,$rhs)=($1,$2,$3);
		if (operate($lhs,$op,$rhs,$line)){ push(@$rc,9+($i<<4)); }
		else                             { push(@$rc,8); }
  }
  elsif ($cur=~/^\'(.*)\'\s*/) { #parse
    if ($rh->{_verbose}){ print "#--begin $1\n"; }
    #print STDERR "perl parser.pl $1\n";
    open(IN,"perl parser.pl $1 |") or die "$line invalid command $'\n";
    while(<IN>){ print; }
    close(IN);
    if ($rh->{_verbose}){ print "#--end   $1\n"; }
  }
  elsif ($cur=~/^\`(.*)\`\s*/) { #command line
    open(IN,"$1 | perl parser.pl |") or die "$line invalid command $'\n";
    while(<IN>){ print; }
    close(IN);
    print "\n";
  }
  elsif ($cur=~/^(\w+)\s*=\s*(-?\w*)\s*/  ){ addHash($rh,$1,$2); }
  elsif ($cur=~/^(\w+)\s*\+=\s*(-?\d+)\s*/){ addHash($rh,$1,derefHash($rh,$1,$line)+$2); }
  elsif ($cur=~/^(\w+)\s*\-=\s*(-?\d+)\s*/){ addHash($rh,$1,derefHash($rh,$1,$line)-$2); }
  elsif ($cur=~/^(\w+)\s*\*=\s*(-?\d+)\s*/){ addHash($rh,$1,derefHash($rh,$1,$line)*$2); }
  elsif ($cur=~/^(\w+)\s*\%=\s*(-?\d+)\s*/){ addHash($rh,$1,derefHash($rh,$1,$line)%$2); }
  elsif ($cur=~/^(\w+)\s*\/=\s*(-?\d+)\s*/){ addHash($rh,$1,int(derefHash($rh,$1,$line)/$2)); }
  else { die "$line invalid command line: $cur"; }
	return $i;
}
sub operate {
  my $lhs =shift;
  my $op  =shift;
  my $rhs =shift;
  my $line=shift;
  #print STDERR "lhs=$lhs, op=$op, rhs=$rhs\n";
  if    ($op eq "<" ){ return ($lhs< $rhs)?1:0; }
  elsif ($op eq ">" ){ return ($lhs> $rhs)?1:0; }
  elsif ($op eq "<="){ return ($lhs<=$rhs)?1:0; }
  elsif ($op eq ">="){ return ($lhs>=$rhs)?1:0; }
  elsif ($op eq "=="){ return ($lhs==$rhs)?1:0; }
  elsif ($op eq "!="){ return ($lhs!=$rhs)?1:0; }
  die "$line invalid operator $op"; return 0;
}
sub extract {
  my $rh  =shift;
  my $cur =shift;
	my $line=shift;
  for (;$cur=~/\@/;){
    if ($cur=~/\@(\w+)/ or
        $cur=~/\@\{\s*(\w+)\s*\}/){
      my ($hit,$keyT)=($&,$1);
      my $dere=derefHash($rh,$keyT,$line);
      #print STDERR "$line change $keyT to $h{$keyT}\n";
      $cur=~s/$hit/$dere/g;
    }
    else{ die "$line invalid @"; }
  }
  return $cur;
}
sub lineStr {
	my $iNx=shift;
	return "line $iNx: ";
}
