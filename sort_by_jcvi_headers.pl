#!/usr/local/bin/perl

use strict;
use Bio::SeqIO;

my $file = $ARGV[0];

my $in = Bio::SeqIO->new(-file => "$file");

my %seqs;
my %map;
while (my $seq = $in->next_seq()) {
    my $name = $seq->display_id();
    $name =~ s/_.*//;
    my @line = split /-/, $name; ##/
    $line[1] =~ s/[abc]//;
    my $desc = $seq->desc();
    $desc =~ s/.*A\//A\//;
    $desc =~ s/ /_/;
    $desc =~ s/\)\)$//;
    $desc =~ s/\(/_/g;
    $map{$name} = $desc;
    $seqs{$line[1]}->{$name} = $seq->seq();
    print "$name\t" . $desc . "\n";
}

foreach my $segment (keys %seqs) {
    my $outname = "$segment.fasta";
    open (OUT, ">$outname") || die "cannot open $outname. $!\n";
    foreach my $seq (keys %{$seqs{$segment}}) {
        print OUT ">$seq\n$seqs{$segment}->{$seq}\n";
    }
    close OUT;
}