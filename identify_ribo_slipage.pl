#!/usr/local/bin/perl

use strict;

use Bio::SeqIO;

my $file = $ARGV[0];

my $in = Bio::SeqIO->new(-file => "$file");
my %seqs;
while (my $seq = $in->next_seq()) {
    $seqs{$seq->display_id()} = $seq;
}

foreach my $seq (keys %seqs) {
    if ($seqs{$seq}->seq =~ /TCCTTTCGTC/) {
        print $seqs{$seq}->display_id . " ribosomal slippage detected.\n";
    } #elsif ($seqs{$seq}->seq =~ /PQ[EKRT]{3,7}RG/) {
      #  print $seqs{$seq}->desc . " probable high path virus\n";
    #}
}