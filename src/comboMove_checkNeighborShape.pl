#!/usr/bin/perl -W
use strict;
print "func cm_checkNeighborShape()\n";
rec(5,0,"if","  ");
print "endfunc\n";
sub calc{
  my $i=shift;
  my @bits;
  for (my $j=0;$j<6;++$j){
    if ($i & (1<<$j)){ unshift(@bits,1); }
    else             { unshift(@bits,0); }
  }
  my ($cntChange,$cntZero)=(0,0);
  for (my $j=0;$j<@bits;++$j){
    if ($bits[$j]!=$bits[($j+1)%6]){ ++$cntChange; }
    if ($bits[$j]==0              ){ ++$cntZero  ; }
  }
  if ($cntChange>2){ return 7; }
  return $cntZero; 
}
sub rec{
  my $i=shift;
  my $b=shift;
  my $if=shift;
  my $indent=shift;
  if ($i>=0){
    print "${indent}${if} cm_breath$i()\n";
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
