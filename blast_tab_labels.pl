#!/usr/local/bin/perl

use strict;

my $file = $ARGV[0];
my $map = $ARGV[1];

open (MAP, $map) || die "cannot open $map. $!\n";

my %map;

while (<MAP>) {
    chomp $_;
    
    my @line = split /\t/, $_;
    
    $map{$line[0]} = $line[1];
}

close MAP;

open (IN, $file) || die "cannot open $file. $!\n";

while (<IN>) {
    chomp $_;
    my @line = split /\t/, $_;
    
    if ($map{$line[0]} && $map{$line[1]}) {
        my $comp1 = $map{$line[0]};
        my $comp2 =  $map{$line[1]};
        $comp1 =~ s/2011_.*/2011/;
        $comp2 =~ s/2011_.*/2011/;
        if ($comp1 eq $comp2 && $line[0] ne $line[1]) {
            print "$line[0]\t$line[1]\t";
            print "$map{$line[0]}\t$map{$line[1]}\t$line[2]\t$line[3]\t$line[4]\t$line[5]\t$line[6]\t$line[7]\t$line[8]\t$line[9]\t$line[10]\t$line[11]\n";
        }
    }
}