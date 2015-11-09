#!/usr/local/bin/perl

use strict;
use Bio::SeqIO;

my $file = $ARGV[0];

my $outfile = "tmp.fasta";
my $in = Bio::SeqIO->new(-file => "$file");
my $oseq = Bio::SeqIO->new(-file => ">$outfile", -format => "fasta");

while (my $seq = $in->next_seq()) {
	my $end = $seq->trunc(($seq->length()-3), $seq->length());
	if ($end->seq() =~ /TAA/i || $end->seq() =~ /TAG/i || $end->seq() =~ /TGA/i) {
		my $trunc = $seq->trunc(1, ($seq->length()-3));
#		print $trunc->length() . "\n";
		$oseq->write_seq($trunc);
	} else {
		print "Record " . $seq->primary_id() . " does not have a stop codon.\n";
		$oseq->write_seq($seq);
	}
}