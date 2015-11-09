#!/usr/local/bin/perl

use strict;

my $file = $ARGV[0];


open (IN, $file) || die "Cannot open $file. $!\n";
open (INCLUDE, ">include.list") || die "Cannot open include.list. $!\n";
open (EXCLUDE, ">exclude.list") || die "Cannot open exclude.list. $!\n";
my %seqs;
my $id;
while (<IN>) {
	chomp $_;
	if ($_ =~ />/) {
		$id = $_;
		$id =~ s/>//;
	} else {
		my @line = split /\t/, $_;
		if ($line[0] < 2 && $line[1] > 300 && $line[2] eq "+" && $line[3] == 1) {
			#print INCLUDE "$id\n";
			print INCLUDE "${id}_$line[0]_$line[1]_$line[2]\n";
		} else {
			print EXCLUDE "$id\n";
		}
	}
}

close IN;