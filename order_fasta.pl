#!/usr/local/bin/perl

use strict;
use Bio::SeqIO;

my $file = $ARGV[0];
my $order = $ARGV[1];

my $in = Bio::SeqIO->new(-file => "$file");

my %seqs;
while (my $seq = $in->next_seq()) {
    my $name = $seq->display_id();

	print "HI\n";
	$seqs{$name} = $seq->seq();		
}

open (IN, "$order") || die "Cannot open order file $!\n";

my @seqs;
while (<IN>) {
	chomp $_;
	my $name = $_;
	my $sequence = $seqs{$name};
	my $seq = new Bio::Seq();
	$seq->display_id($name);
	$seq->seq($sequence);
	push @seqs, $seq;
	
	print "'$name'\t$sequence\n";
}

close IN;

my $outfile = "ordered.fasta";
my $seqout = Bio::SeqIO->new( -format => 'fasta', -file => ">$outfile");
$seqout->write_seq(@seqs);