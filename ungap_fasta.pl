#!/usr/local/bin/perl

use strict;
use Bio::SeqIO;

my $file = $ARGV[0];

my $outfile = "tmp.fasta";
my $in = Bio::SeqIO->new(-file => "$file");
my $oseq = Bio::SeqIO->new(-file => ">$outfile", -format => "fasta");

while (my $seq = $in->next_seq()) {
	my $sequence = $seq->seq();
	$sequence =~ s/-//g;
	$seq->seq($sequence);
	$oseq->write_seq($seq);
}