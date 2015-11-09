#!/usr/local/bin/perl

use strict;
use Bio::SeqIO;

my $file = $ARGV[0];

my $in = Bio::SeqIO->new(-file => "$file");

my %seqs;
my %map;
while (my $seq = $in->next_seq()) {
    my $name = $seq->display_id();
    $name =~ s/\.[0-9]*$//;
    my $desc = $seq->desc();
    $desc =~ s/.*gene=\"//;
    $desc =~ s/\".*//;
    $map{$name} = $desc;
    $seqs{$desc}->{$name} = $seq->seq();
    print "$name\t" . $desc . "\n";
}


foreach my $gene (keys %seqs) {
    my $outname = "$gene.fasta";
    open (OUT, ">$outname") || die "cannot open $outname. $!\n";
    foreach my $seq (keys %{$seqs{$gene}}) {
        print OUT ">$seq\n$seqs{$gene}->{$seq}\n";
    }
    close OUT;
}