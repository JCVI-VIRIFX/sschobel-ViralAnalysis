#!/usr/local/bin/perl

use strict;

my $file = $ARGV[0];

open (IN, $file) || die "Cannot open $file. $!\n";

my %data;
my $count;
my %sites;
while (<IN>) {
	chomp $_;
	if ($_ eq "----------------------------------------------------------------------") {
		$count ++;
		if ($count == 1 || $count == 2) {
			next;
		} elsif ($count == 3) {
			$count = 0;
		}
	}
	if ($count == 2) {
		my @line = split '\s+', $_;
		$line[0] =~ s/\.[0-9]+$//;
		if ($line[5] =~ /\+/) {
			$data{$line[0]}->{$line[1]} = $line[2];
			$sites{$line[1]} ++;
			#print "$line[0]\t$line[1]\t$line[2]\n";
		}
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