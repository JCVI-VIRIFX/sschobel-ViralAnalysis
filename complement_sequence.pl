#!/usr/local/bin/perl

use strict;

my $file = $ARGV[0];

open (IN, $file) || die "Cannot open $file. $!\n";

while (<IN>) {
    chomp $_;
    
    if ($_ =~ />/) {
    	print "$_\n";
    } else {
    	my $line = $_;
    	$line =~ tr/[AGCTU]/[UCGAA]/;
    	print "$line\n";
    }
}

close IN;