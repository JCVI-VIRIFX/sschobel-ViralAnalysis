#!/usr/local/bin/perl

use strict;

my $file = $ARGV[0];
my $map = $ARGV[1];
my $color_map = $ARGV[2];

my %groups;
my %colors;

open (IN, $file) || die "Cannot open $file. $!";
while (<IN>) {
    chomp $_;
    my @line = split /\t/, $_;
    $groups{$line[1]} = $line[0]; 
}
close(IN);

open (CMAP, $color_map) || die "Cannot open $color_map. $!";
while (<CMAP>) {
    chomp $_;
    my @line = split /\t/, $_;
    
    $colors{$line[0]} = $line[1];
}
close(CMAP);

open (MAP, $map) || die "Cannot open $map. $!";
while (<MAP>) {
    chomp $_;
    my @line = split /\t/, $_;
    
    print "$line[0]\t$line[1]\t$colors{$groups{$line[0]}}\n";
}
close(MAP);