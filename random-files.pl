#!/usr/bin/perl
use Getopt::Std;
my %opt=();
getopts("df:j:r:",\%opt);
$nofolders = $opt{f} ? $opt{f} : 20;
$DEBUG = $opt{d} ? 1 : 0;
$jpegs = $opt{j} ? $opt{j} : "jpegs.list";
$ranpicfile = $opt{r} ? $opt{r} : "jpegs-random.list";
print "d,f,j,r: $opt{d}, $opt{f}, $opt{j}, $opt{r}\n" if $DEBUG;
open(JPEGS,$jpegs) || die "Cannot open jpegs listing file $jpegs!!\n";
@jpegs = <JPEGS>;
# remove newline character
$nopics = chomp @jpegs;
open(RAN,"> $ranpicfile") || die "Cannot open random picture file $ranpicfile!!\n";
for($i=0;$i<$nofolders;$i++) {
  $t = int(rand($nopics-2));
  print "random number is: $t\n" if $DEBUG;
  ($dateTime) = $jpegs[$t] =~ /(\d{8}_\d{6})/;
  if ($dateTime) {
    print "dateTime\n" if $DEBUG;
  }
  $priorPic = $jpegs[$t-2];
  $Pic = $jpegs[$t];
  $postPic = $jpegs[$t+2];
  print RAN qq($priorPic
$Pic
$postPic
);
}
close(RAN);