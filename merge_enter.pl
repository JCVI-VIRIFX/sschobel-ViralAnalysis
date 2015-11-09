#!/usr/local/bin/perl

use strict;
use Bio::SeqIO;

my $dir = $ARGV[0];

my @files = <$dir/ENTE*>;
my %genes;
my %map;

foreach my $file (@files) {
	print "working on $file.\n";
	my @path = split /\//, $file; 
	
	my $last = pop @path;	
	
	my $fasta = "$file/${last}_hits_top_seqs.fa";

	print "fasta file is $fasta.\n";
	my $in = Bio::SeqIO->new(-file => "$fasta");
	while (my $seq = $in->next_seq()) {
		my $gene = $seq->display_id();
		my $new_id = $gene;
		$new_id =~ s/-Enter/-$last/;
		$seq->display_id($new_id);
		push @{$genes{$gene}}, $seq;
		$map{$gene} .= "$new_id\t$last\n";
	}
}

foreach my $gene (keys %genes) {
#	print "$gene\t$genes{$gene}\n";
	my $map_file = "$gene.map";
	my $outfile = "$gene.fasta";
	my $seqout = Bio::SeqIO->new( -format => 'fasta', -file => ">$outfile");
	$seqout->write_seq(@{$genes{$gene}});
	open (MAP, ">$map_file");
	print MAP $map{$gene};
	close MAP;
}

