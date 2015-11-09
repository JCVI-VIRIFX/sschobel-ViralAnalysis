#!/usr/local/bin/perl

use strict;
use Bio::SeqIO;
use Data::Dumper;

my $infile = $ARGV[0];

my $seqin = Bio::SeqIO->new( -format => 'GenBank', -file => "$infile");

my %header;
my %data;

## this code extracts metadata from the source field.  beware of metadata filtering here.
while (my $seq = $seqin->next_seq) {
	my @source = $seq->all_SeqFeatures();
	my $acc = $seq->display_id();
#	print "$acc";
	foreach my $feat (@source) {
		if ($feat->primary_tag() eq 'source') {
			foreach my $subfeat ($feat->all_tags()) {
				if ($subfeat eq 'PCR_primers') {
					next;
				}
				my @value = $feat->each_tag_value($subfeat);
#				print "\t$value[0]";
				$data{$acc}->{$subfeat} = $value[0];
				if (!$header{$subfeat}) {
					$header{$subfeat} ++;
				}
			}
		}
	}
#	print "\n";
}

## this code prints headers and metadata  beware of the metadata filtering here.
my $header_text = join("\t", sort keys %header);

print "accession\t$header_text\n";

foreach my $acc (keys %data) {
	if ($data{$acc}->{"host"} =~ /sex/ || $data{$acc}->{"sex"}) {
		print "$acc";
		foreach my $col (sort keys %header) {
			print "\t$data{$acc}->{$col}";
		}
		print "\n";
	}
}

