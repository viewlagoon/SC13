#!/usr/bin/perl -W
use strict;
print "func bm_checkNeighborShape(hp_)\n";
rec(5,0,"if","  ");
print "endfunc\n";
sub myMax {
  my $a=shift;
  my $b=shift;
  return $a>=$b?$a:$b;
}
sub calc{
  my $i=shift;
  my @bits;
  for (my $j=0;$j<6;++$j){
    if ($i & (1<<$j)){ unshift(@bits,1); }
    else             { unshift(@bits,0); }
  }
  my ($cntChange,$cntOwned,$cntOwnedMax)=(0,0,1);
  for (my $j=0;$j<@bits;++$j){
    if ($bits[$j]!=$bits[($j+1)%6]){ ++$cntChange; }
    if ($bits[$j]==0              ){ $cntOwned=0; }
    else {
      $cntOwnedMax=myMax($cntOwnedMax,++$cntOwned);
    }
  }
  $cntChange/=2;
  my $res="hp_";
  if ($cntChange>1){
    $res.="*$cntChange";
  }
  if ($cntOwnedMax>1){
    $res.="/$cntOwnedMax";
  }
  return $res;
}
sub rec{
  my $i=shift;
  my $b=shift;
  my $if=shift;
  my $indent=shift;
  if ($i>=0){
    print "${indent}${if} bm_ownedT$i()\n";
    rec($i-1,$b*2+1,"if","$indent  "); 
    if ($i){
      rec($i-1,$b*2,"elif",$indent); 
    }
    else{
      print "${indent}endif\n";
      rec($i-1,$b*2,"unused",$indent); 
    }
  }
  else      {
    my $res=calc($b);
    print "${indent}return $res\n";
  }
}
