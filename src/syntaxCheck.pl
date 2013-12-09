use strict;
use warnings;
my $funcStack=0;
my @ifStack  =(0,0);
my @useElse  =();
my $line     =0;
my %funcName;
while(<>){
  ++$line;
  if (/^func/){
    /^function/ and print STDERR "line $line: suggest 'function' -> 'func'\n"; 
    if (/^func\s+(\w+)\(/){
      $ifStack[0]  and die "line $line: if func $!";
      $funcStack++ and die "line $line: funcStack=$funcStack $!";
      exists($funcName{$1}) and die "line $line: multiple definition of $1 $!";
      $funcName{$1}=1;
    }
  }
  if (/^endfunc/){
    /^endfunction/ and print STDERR "line $line: suggest 'endfunction' -> 'endfunc'\n";
    if (/^endfunc\s*\n/){
      $ifStack[1]  and die "line $line: if endfunc $!";
      --$funcStack and die "line $line: funcStack=$funcStack $!";
    }
  }
  if (/^\s*if\s/){
    ++$ifStack[$funcStack];
    push(@useElse,0);
  }
  if (/^\s*else/){
    @useElse              or  die "line $line: (no if) else $!";
    $useElse[$#useElse]++ and die "line $line: else else $!";
  }
  if (/^\s*endif/){
    --$ifStack[$funcStack]>=0 or die "line $line: (no if) endif $!";
    pop (@useElse);
  }
}
$funcStack  and die "end of file: funcStack=$funcStack";
$ifStack[0] and die "end of file: ifStack[0]=$ifStack[0] $!";
$ifStack[1] and die "end of file: ifStack[1]=$ifStack[1] $!";

