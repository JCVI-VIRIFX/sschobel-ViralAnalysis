#!/usr/local/bin/perl

use strict;

my $file = $ARGV[0];

open (IN, $file) || die "Cannot open $file. $!\n";

my %both;
my %ha;
my %na;
my %ha2;
my %na2;

my $sep = '\|';

while (<IN>) {
    chomp $_;
    my @line = split /$sep/, $_; #//
    my @HA = split /,/, $line[0]; #/
    my @NA = split /,/, $line[1]; #/
    
    foreach my $ha (@HA) {
        foreach my $na (@NA) {
            $ha2{$ha}->{$na} ++;
            $na2{$na}->{$ha} ++;
        }
    }
    
    $both{$_} ++;
#    print "@line\n";
    $ha{$line[0]} ++;
    $na{$line[1]} ++;
}

print "BOTH:\n";
foreach my $sub (sort keys %both) {
    print "$sub\t$both{$sub}\n";
}
print "HA:\n";
foreach my $sub (sort keys %ha) {
    print "$sub\t$ha{$sub}\n";
}
print "NA:\n";
foreach my $sub (sort keys %na) {
    print "$sub\t$na{$sub}\n";
}
print "Single HA associations\n";
foreach my $ha (sort keys %ha2) {
    print "$ha => \n";
    foreach my $na (sort keys %{$ha2{$ha}}) {
        print "\t$na\t$ha2{$ha}->{$na}\n";
    }
}
print "Single NA associations\n";
foreach my $na (sort keys %na2) {
    print "$na => \n";
    foreach my $ha (sort keys %{$na2{$na}}) {
        print "\t$ha\t$na2{$na}->{$ha}\n";
    }
}
