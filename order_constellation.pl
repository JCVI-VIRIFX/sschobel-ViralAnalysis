#!/usr/local/bin/perl

use strict;

my $list = $ARGV[0];
my $constellation = $ARGV[1];

my @list;
	
open (IN, $list) || die "Cannot open $list. $!\n";
while (<IN>) {
	chomp $_;
	push @list, $_;
}
close IN;

my %cons;

open (CON, $constellation) || die "Cannot open $constellation. $!\n";
while (<CON>) {
	chomp $_;
	my $con = $_;
	my @con = split '\t', $_;
	$cons{$con[0]} = $con;
	 
}
close CON;

foreach my $taxa (@list) {
	print "$cons{$taxa}\n";
}