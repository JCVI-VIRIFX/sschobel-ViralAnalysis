#!/usr/local/bin/perl

use strict;
use Bio::SeqIO;

my $file = $ARGV[0];
my $outfile = "tmp.fasta";

my $in = Bio::SeqIO->new(-file => "$file");
my %seqs;
my @ids;

while (my $seq = $in->next_seq()) {
    if ($seqs{$seq->display_id()}) {
        push @ids, $seq->display_id();
    }
     $seqs{$seq->display_id()} = $seq;
}

my $oseq = Bio::SeqIO->new(-file => ">$outfile", -format => "fasta");

foreach my $seq (keys %seqs) {
    $oseq->write_seq($seqs{$seq});
}

foreach my $id (@ids) {
    print "$id\n";
}