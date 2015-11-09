#!/usr/local/bin/perl

use strict;

my $file = $ARGV[0];
my $map = $ARGV[1];
my $acc = $ARGV[2];

my $new_file = "$file.new";

my %MAP;
my %seen;

open (MAP, $map) || die "Cannot open $map. $!";
while (<MAP>) {
    chomp $_;
    
    my @line = split /\t/, $_;
    
    if ($seen{$line[1]}) {
        $seen{$line[1]} ++;
        #$MAP{$line[0]} = $line[1];
        $MAP{$line[0]} = "${line[1]}_$seen{$line[1]}";
    } else {
        $seen{$line[1]} ++;    
        $MAP{$line[0]} = $line[1];
    }
    #print "$line[0] => $line[1]\n";
}
close MAP;

open (IN, $file) || die "Cannot open $file. $!\n";


while (<IN>) {
    chomp $_;
    if ($_ =~ />(.*)/) {
        if ($MAP{$1}) {
        	if ($acc) {
            	print ">$MAP{$1}\n";
        	} else {
        		print ">$MAP{$1}:$1\n";
        	}
        } else {
            print "$_\n";
        }
    } else {
        print "$_\n";
    }
}
close IN;


