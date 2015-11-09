#!/usr/local/bin/perl

use strict;

use Bio::SeqIO;

my $file = $ARGV[0];

my $in = Bio::SeqIO->new(-file => "$file");
my %seqs;
while (my $seq = $in->next_seq()) {
	my $sequence = uc($seq->seq);
	$seq->seq($sequence);
    $seqs{$seq->display_id()} = $seq;
    #print "$sequence\n";
}

foreach my $seq (keys %seqs) {
    if ($seqs{$seq}->seq =~ /PQRETRG/) {
        print $seqs{$seq}->desc . " possible high path virus\n";
    } elsif ($seqs{$seq}->seq =~ /PQ[EKRT]{3,7}RG/) {
        print $seqs{$seq}->desc . " probable high path virus\n";
    }
}