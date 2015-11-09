#!/usr/local/bin/perl

use strict;
use Bio::SeqIO;

my $file = $ARGV[0];
my $map = $ARGV[1];

open (MAP, "$map") || "die cannot open $map. $!\n";

my %map;
my %m2;
my %sort_seqs;

while (<MAP>) {
    chomp $_;
    
    my @line = split /\t/, $_;
    $map{$line[0]} = $line[2];
    $m2{$line[2]}->{$line[0]} = $line[1];
}

my $in = Bio::SeqIO->new(-file => "$file");
my %seqs;

while (my $seq = $in->next_seq()) {
    $sort_seqs{$map{$seq->display_id()}}->{$seq->display_id()} = $seq;
}

foreach my $gene (keys %sort_seqs) {
    my $outfile = $gene . ".fasta";
    my $oseq = Bio::SeqIO->new(-file => ">$outfile", -format => "fasta");
    open (MAP, ">$gene.map") || die "cannot open $gene.map. $!\n";
    foreach my $seq (keys %{$sort_seqs{$gene}}) {
        $oseq->write_seq($sort_seqs{$gene}->{$seq});
        print MAP "$seq\t$m2{$gene}->{$seq}\n";
        
    }
}