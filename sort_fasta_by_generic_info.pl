#!/usr/local/bin/perl

use strict;
use Bio::SeqIO;

my $file = $ARGV[0];

my $in = Bio::SeqIO->new(-file => "$file");

my %seqs;
my %map;

while (my $seq = $in->next_seq()) {
    my $name = $seq->display_id();
    my $desc = $seq->desc();

    my @line = split /\t/, $desc;
    
    $seqs{$line[1]}->{$name} = $seq->seq();
    $map{$line[1]}->{$name} = $line[0];
}

foreach my $segment (keys %seqs) {
    my $outname = "$segment.fasta";
    my $mapname = "$segment.map";
    open (OUT, ">$outname") || die "cannot open $outname. $!\n";
    open (MAP, ">$mapname") || die "cannot open $mapname. $!\n";
    foreach my $seq (keys %{$seqs{$segment}}) {
        print OUT ">$seq\n$seqs{$segment}->{$seq}\n";
        print MAP "$seq\t$map{$segment}->{$seq}\n";
    }
    close OUT;
    close MAP;
}