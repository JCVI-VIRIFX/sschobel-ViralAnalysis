#!/usr/local/bin/perl

use strict;

use Bio::AlignIO;
use Data::Dumper;

my $file = $ARGV[0];

my $alnin = Bio::AlignIO->new(-file => "$file", -format => "fasta");
my $alnout = Bio::AlignIO->new(-file => ">out.aln", -format => "clustalw");

while (my $aln = $alnin->next_aln()) {
    $alnout->write_aln($aln);
}