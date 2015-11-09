#!/usr/local/bin/perl

use strict;
use Bio::SeqIO;
use Bio::Seq;

my $seg_file = $ARGV[0];

open (IN, $seg_file) || die "cannot open $seg_file. $!\n";
my @segs;
my %order;
my $count;
while (<IN>) {
	chomp $_;
	my @line = split "\t", $_;
	push @segs, $line[0];
	$count ++;
	if ($line[1]) {
		$order{$line[1]} = $count;
	}
}

my %merged_seqs;

foreach my $seg (@segs) {
    my $fsafile = "$seg.fasta";
	my $mapfile = "$seg.map";

	my %map;
	open (MAP, "$mapfile") || die "Cannot open mapfile, $mapfile. $!\n";
	while (<MAP>) {
		chomp $_;
		
		my @line = split '\t', $_;
		$map{$line[0]} = $line[1];		
	}
	close MAP;

	my $in = Bio::SeqIO->new(-file => "$fsafile");
	
	while (my $seq = $in->next_seq()) {
		my $id = $seq->display_id();
		
		$merged_seqs{$map{$id}} .= $seq->seq();
	}
}


my @seqs;
foreach my $strain (keys %merged_seqs) {

	my $seq = new Bio::Seq();
	$seq->display_id($strain);
	$seq->seq($merged_seqs{$strain});

	push @seqs, $seq;	
}

my $outfile = "merged_viral_genes.fasta";
my $seqout = Bio::SeqIO->new( -format => 'fasta', -file => ">$outfile");
$seqout->write_seq(@seqs);


