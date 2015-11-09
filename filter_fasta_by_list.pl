#!/usr/local/bin/perl

use strict;
use Bio::SeqIO;

my $file = $ARGV[0];
my $list = $ARGV[1];
my $exclude = $ARGV[2];

open (LIST, "$list") || "die cannot open $list. $!\n";

my %list;

while (<LIST>) {
    chomp $_;

    $list{$_} = 1;
}
close LIST;

my $outfile = "tmp.fasta";
my $in = Bio::SeqIO->new(-file => "$file");
my $oseq = Bio::SeqIO->new(-file => ">$outfile", -format => "fasta");

while (my $seq = $in->next_seq()) {
    if ($exclude) {
        if ($list{$seq->display_id()}) {
            next;
        } else {
            #$seq->desc(undef);
            $oseq->write_seq($seq);
        }
    } else {
        if ($list{$seq->display_id()}) {
            #$seq->desc(undef);
            $oseq->write_seq($seq);
        } else {
            next;
        }
    }
}
