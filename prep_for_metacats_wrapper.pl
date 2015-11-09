#!/usr/local/bin/perl

use strict;

my $gene_list = $ARGV[0];
my $sequence_dir = $ARGV[1];
my $output_dir = $ARGV[2];
my $metadata = $ARGV[3];
my $map = $ARGV[4];

my $prep_exec = "/export/workspace/ViralAnalysis/prep_metacats_files.pl";

open (IN, $gene_list) || die "cannot open gene list file '$gene_list'. $!\n";
my @genes;
while (<IN>) {
	chomp $_;
	push @genes, $_;
}

foreach my $gene (@genes) {
	my $fasta = "$sequence_dir/$gene.fasta";
	my $dir = $output_dir . "/$gene";
	
	mkdir $dir;
	chdir $dir;
	
	if (-e $fasta) {
		#print "$fasta\n";
		for (my $i = 6; $i < 44; $i ++) {
			my $cmd = "$prep_exec $map $metadata $i $fasta";
			print "$cmd\n";
			system $cmd;
		}
	} else {
		die "$fasta does not exist\n";
	}	
}