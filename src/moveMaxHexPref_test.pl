#/usr/bin/perl -w
use strict;
{
  print "print 'testing moveMaxPref0 ...'\n";
  print "init()\n";
  for (my $perm=123456;$perm>0;$perm=next_permutation($perm)){
    my @p=to_array($perm);
    my $iMax=max_index($perm);
    out_main(\@p,$iMax);
  }
  {
    my @p=(0,0,0,0,0,0);
    out_main(\@p,-1);
    @p   =(1,1,1,1,1,1);
    out_main(\@p, 0);
  }
  print "print 'finished test moveMaxPref0 !'\n";
}
sub out_main {
  my $rp   = shift;
  my $iMax = shift;
  for (my $i=0;$i<6;++$i){
    print "hp0$i = $rp->[$i]\n";
  }
  print <<EOF;
moveMaxHexPref0()
if move[0]!=$iMax
  print 'error: @$rp: ',move[0]
endif
EOF

}
sub max_index{
  for (my ($i,$t)=(0,shift);$t;$t=int($t/10)){
    if ($t%10==6){ return 5-$i; }
    ++$i;
  }
}
sub to_array {
  my @a;
  for (my $t=shift;$t;$t=int($t/10)){
    unshift(@a,$t%10);
  }
  return @a;
}
sub next_permutation{
  my $t=shift;
  for (my $i=$t+1;$i<=654321;++$i){
    my $cnt=0;
    for (my $j=$i;$j;$j=int($j/10)){
      $cnt |= 1<<($j%10);
    }
    if ($cnt==126){ return $i; }
  }
  return -1;
}
