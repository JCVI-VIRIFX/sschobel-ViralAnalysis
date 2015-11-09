#!/usr/local/bin/perl

use strict;

my $file = $ARGV[0];

open (IN, $file) || die "Cannot open $file. $!\n";

my $taxa;

while (<IN>) {
    chomp $_;
    
    if ($_ =~ /begin taxa/) {
        $taxa = 1;
    } elsif ($_ =~ /end/) {
        $taxa = 0;
    }
    
    if ($taxa) {
        my $line = $_;
        $line =~ s/\[\&\!color\=\#.*\]//;
        print "$line\n";
    }    
}