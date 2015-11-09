#!/usr/local/bin/perl

use strict;

my $map_file = $ARGV[0];
my $sub_file = $ARGV[1];

my %subs;
open (SUB, $sub_file) || die "cannot open $sub_file. $!\n";
while (<SUB>) {
	chomp $_;
    my @line = split /\t/, $_;
#    print "$line[1]\t$line[3]\n";
    $subs{$line[1]} = $line[3];
    
}
close SUB;

open (MAP, $map_file) || die "Cannot open $map_file. $!\n";
while (<MAP>) {
	chomp $_;
    my @line = split /\t/, $_;
    
#    print "$line[0]\n";
    if ($subs{$line[0]}) {
    	print "$line[0]\t$line[1]_$subs{$line[0]}\t$line[2]\n";
    } else {
    	print "$line[0]\t$line[1]\t$line[2]\n";
    }
}

close MAP;