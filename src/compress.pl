#!/usr/bin/perl
use strict;
my $verbose=0;
my %promised=(
  gb_agent_positions =>1,
  gb_remaining_turns                =>1,
	gb_turns_before_enabling_syzygies =>1,
  gb_field_size                     =>1,
  gb_hexel_owner                    =>1,
  gb_gate_positions                 =>1,
  gb_agent_status                   =>1,
  gb_team_id                        =>1,
  gb_random_value                   =>1,
  gb_storage                        =>1,
  gb_move   => 1,
  local     => 1,
  return    => 1,
  func      => 1,
  endfunc   => 1,
  print     => 1,
  while     => 1,
  endwhile  => 1,
  break     => 1,
  continue  => 1,
	elif      => 1,
  if        => 1,
  If        => 1,
  iF        => 1,
  IF        => 1,
  else      => 1,
  endif     => 1,
);

my %hash;
my $tmpFile="compress.tmp";
my $dbgFile="compress.dbg";
open (TMP,">$tmpFile") or die "$!";
while (<>){
  chomp;
  s/^\s*//g;
  s/\s*\(\s*\)/()/g;
  s/\s+/ /g;
  if (/^\s*print/){
    if ($verbose){ print TMP "$_\n"; }
    next;
  }
  /^#/     and next;
  /^\s*$/  and next;
  for (;;){
    if (/[a-zA-Z_]\w*/){
      print TMP "$`";
      my $strMat=$&;
      $_=$';
      if (!exists($promised{$strMat})){
        ++$hash{$strMat};
        $strMat=~s/$strMat/\{$strMat\}/;
      }
      print TMP "$strMat";
      next;
    }
    last;
  }
  print TMP "$_\n";
}
close(TMP);
open (TMP2,">$dbgFile") or die "$!";

my %subst;
for my $v (sort{$hash{$b} <=> $hash{$a}} keys %hash){
  my $i=0;
  my $str=getString();
  $subst{$v}=$str;
  print TMP2 "$v => $hash{$v}, str=$str\n";
}

open (IN,"$tmpFile") or die "$!";
while(<IN>){
  chomp;
  for (my $str=$_;;){
    if ($str=~/\{([a-zA-Z_]\w*)\}/){
      my $sstr=$1;
      if ($sstr eq "hm"){
        print STDERR "hit: $sstr=>$subst{$sstr}: $_\n";
      }
      $str=$';
      s/\{$sstr\}/$subst{$sstr}/g;
      #s/\@+$sstr/$sstr/g;
      next;
    }
    last;
  }
  print "$_\n";
}
print "\n";
close(IN);
#############################################################
{
  my $cnt=0;

  sub getString{
    my @ch=(  
      "0","1","2","3","4",
      "5","6","7","8","9",
      "A","B","C","D","E",
      "F",   ,"H",   ,"J",
      "K","L","M","N","O",
      "P","Q","R","S","T",
      "U","V","W","X","Y","Z",
      "a","b","c","d","e",
      "f",   ,"h",   ,"j",
      "k","l","m","n","o",
      "p","q","r","s","t",
      "u","v","w","x","y","z","_",
    );
    my $n=@ch;
    $n>0 or die "n=$n $!";
    my $str;
    do {
      $str="";
      my $i=$cnt++;
      #print STDERR "[$i]:";
      do {
        my $j=$i % $n;
        $i=($i-$j)/$n;
        $str=$ch[$j].$str;
      } while ($i);
    } while (checkStr($str));
    #print STDERR "\n";
    #$str="_".$str;
    return $str;
  }
}
sub checkStr {
  my $str=shift;
  if (exists ($promised{$str})){
    #print STDERR "checkStr: $str is promised.\n";
    return 1;
  }
  if ($str=~/^\d/){
    #print STDERR "checkStr: $str is start from number.\n";
    return 1;
  }
  return 0;
}
