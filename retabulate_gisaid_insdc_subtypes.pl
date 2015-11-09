#!/usr/local/bin/perl

use strict;
use Text::CSV_XS;

my $file = $ARGV[0];

my @rows;
my @headers;
my $csv = Text::CSV_XS->new ({ binary => 1, auto_diag => 1 });
open my $fh, "<:encoding(utf8)", "$file" or die "$file: $!";
while (my $row = $csv->getline ($fh)) { 
	if ($row->[2] =~ m/PB1 Segment_Id/) {
		@headers = @$row;
	} else {
		push @rows, $row;
	}
}
close $fh;

foreach my $row (@rows) {
	$$row[9] =~ s/A \/ //;
	for (my $i = 1; $i < 9; $i ++) {
		if ($$row[$i+9] =~ /EPI/ || $$row[$i+9] =~ /A \/ H7N/ || $$row[9] =~ /EPI/) {
			next;
		}
		unless (!$$row[$i]) {
			$$row[$i] =~ s/ \| .*//;
			$headers[$i] =~ s/ Segment_Id//;
			print "$headers[$i]\t$$row[$i]\t$$row[$i+9]\t$$row[9]\n";
		}
	}
}