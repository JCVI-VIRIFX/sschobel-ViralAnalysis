#!/usr/local/bin/perl

use strict;

my $meta1 = $ARGV[0];
my $meta2 = $ARGV[1];

my %META1;

open (META1, $meta1) || die "Cannot open $meta1. $!";
my $count;
my @header1;
while (<META1>) {
    chomp $_;
    
    my @line = split /\t/, $_;
  	if ($count == 0) {
    	foreach my $item (@line) {
    		push @header1, $item;
    	}
    } else {
    	for (my $i = 0; $i < @header1; $i ++) {
    		$META1{$line[3]}->{$header1[$i]} = $line[$i];
    	}    	
    }
	$count ++;
}
close META1;

my %META2;

open (META2, $meta2) || die "Cannot open $meta2. $!";
my $count;
my @header2;
while (<META2>) {
    chomp $_;
    
    my @line = split /\t/, $_;
    if ($count == 0) {
    	foreach my $item (@line) {
    		push @header2, $item;
    	}
    } else {
    	for (my $i = 0; $i < @header2; $i ++) {
    		$META2{$line[3]}->{$header2[$i]} = $line[$i];
    	}
    }
    $count ++;
}
close META2;

my %merged_metadata = %META2; 

foreach my $item (keys %META1) {
	if ($merged_metadata{$item}) {
		foreach my $key (keys $META1{$item}) {
			$merged_metadata{$item}->{$key} = $META1{$item}->{$key};
		}
	}
}

my %seen;
my @merged_header;
foreach my $item (@header2) {
	push @merged_header, $item;
	$seen{$item} ++;
}

foreach my $item (@header1) {
	unless ($seen{$item}) {
		push @merged_header, $item;
	}
}

print join("\t", @merged_header) . "\n";

foreach my $item (keys %merged_metadata) {
	my $row;
	foreach my $key (@merged_header) {
		$row .= "$merged_metadata{$item}->{$key}\t"; 
	}
	chop $row;
	print $row . "\n";
}
