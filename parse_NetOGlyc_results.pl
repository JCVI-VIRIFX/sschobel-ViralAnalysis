#!/usr/local/bin/perl

use strict;

my $file = $ARGV[0];

open (IN, $file) || die "Cannot open $file. $!\n";

my %data;
my $count;
my %sites;
while (<IN>) {
	chomp $_;

	if ($_ =~ /POSITIVE/) {
		my @line = split '\s+', $_;
		$data{$line[0]}->{$line[3]} = '+';
		$sites{$line[3]} ++;
#		print "$line[0]\t$line[3]\n";
	}
}

print "sites\t" . join("\t",sort {$a <=> $b} keys %sites) . "\n";
foreach my $id (keys %data) {
	print "$id";
	foreach my $site (sort {$a <=> $b} keys %sites) {
		print "\t$data{$id}->{$site}";
	}
	print "\n";
}