#!/usr/bin/perl -W
use strict;
print "func vm_createUpDownTask()\n";
rec(5,0,"if","  ");
print "endfunc\n";
sub arg{
  my $a=shift;
  my $b=shift;
  my $c=shift;
  if ($a){ return (1,2,3); }
  if ($b){ return (2,3,1); }
  if ($c){ return (3,1,2); }
  die "arg FAILED";
  return (0,0,0);
}
sub select2{
  my $ud=shift;
  my $ag1=shift;
  my $ag2=shift;
  my $both=shift;
  my $indent=shift;
  my $cmp=">";
  my $du="u";
  if ($ud eq "u"){ $cmp="<"; $du="d"; }
  print "${indent}if y${ag1}${cmp}y${ag2}\n";
  print "${indent}  vm${ag1}_${ud}Task_=1\n";
  if ($both){
    print "${indent}  vm${ag2}_${du}Task_=1\n";
  }
  print "${indent}else\n";
  print "${indent}  vm${ag2}_${ud}Task_=1\n";
  if ($both){
    print "${indent}  vm${ag1}_${du}Task_=1\n";
  }
  print "${indent}endif\n";
}
sub calc{
  my $i=shift;
  my $indent=shift;
  my @bits;
  for (my $j=0;$j<6;++$j){
    if ($i & (1<<$j)){ unshift(@bits,1); }
    else             { unshift(@bits,0); }
  }
  my $cntU=$bits[0]+$bits[1]+$bits[2];
  my $cntD=$bits[3]+$bits[4]+$bits[5];
  my ($agU1,$agU2,$agD1,$agD2)=(0,0,0,0);
  if ($cntU==1){
    ($agU1,$agD1,$agD2)=arg($bits[0],$bits[1],$bits[2]);
    print "${indent}vm${agU1}_uTask_=1\n";
    select2("d",$agD1,$agD2,0,$indent);
    return;
  }
  elsif ($cntD==1){
    ($agD1,$agU1,$agU2)=arg($bits[3],$bits[4],$bits[5]);
    print "${indent}vm${agD1}_dTask_=1\n";
    select2("u",$agU1,$agU2,0,$indent);
    return;
  }
  #elsif ($cntU==0 or $cntD==0){
    print "${indent}if agMutAlone==1\n";
    select2("u",2,3,1,"  $indent");
    print "${indent}elif agMutAlone==2\n";
    select2("u",3,1,1,"  $indent");
    print "${indent}else\n";
    select2("u",1,2,1,"  $indent");
    print "${indent}endif\n";
    return;
  #}
}
sub rec{
  my $i=shift;
  my $b=shift;
  my $if=shift;
  my $indent=shift;
  my @cond=("vm1_uPref","vm2_uPref","vm3_uPref","vm1_dPref","vm2_dPref","vm3_dPref");
  if ($i>=0){
    print "${indent}${if} $cond[$i]()\n";
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
    calc($b,$indent);
  }
}
