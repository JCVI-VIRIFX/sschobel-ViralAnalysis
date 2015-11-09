#!/usr/local/bin/perl

use strict;

my $map = $ARGV[0];
my $meta = $ARGV[1];
my $group_col = $ARGV[2];
my $fasta = $ARGV[3];

my %MAP;
open (MAP, $map) || die "Cannot open $map. $!";
while (<MAP>) {
    chomp $_;
    
    my @line = split /\t/, $_;
    
	$MAP{$line[0]} = $line[1];
}
close MAP;

open (META, $meta) || die "Cannot open $meta. $!";
my $col = $group_col - 1;
my %groups;
my %meta;
my @header;

while (<META>) {
    chomp $_;
    
    my @line = split /\t/, $_;

	unless (@header) {
		@header = split /\t/, $_;
	}
    
    foreach my $key (keys %MAP) {
        if ($MAP{$key} =~ /\/$line[0]\//) {
        	$line[$col] =~ s/ /_/g;
        	$line[$col] =~ s/\//-/g;
        	push @{$meta{$line[$col]}}, $key;
        }
    }
}
close META;

my @outfasta;
my @outlist;
my $catcmd = "cat";
my $outfile = "$header[$col].fasta";
my $outstats = "$header[$col].stats";
open (STATS, ">$outstats") || die "cannot open stats file for writing '$outstats'. $!\n";
foreach my $key (keys %meta) {
	unless ($key eq "") {
		my $prefix = "$header[$col]:$key";
		my $fastaout = $prefix . ".fasta";
		my $listfile = $prefix . ".list";
		print "$header[$col]: $key\t" . @{$meta{$key}} . "\n";
		print STATS "$header[$col]: $key\t" . @{$meta{$key}} . "\n";
		open (OUT, ">$listfile") || die "cannot open $listfile. $!\n";
		print OUT join("\n", @{$meta{$key}}) . "\n";
		my $cmd = "/export/workspace/ViralAnalysis/filter_fasta_by_list.pl $fasta $listfile";
		system $cmd;
		my $mvcmd = "mv tmp.fasta $fastaout";
		system $mvcmd;
		my $sedcmd = "sed 's/>/>$prefix:/' $fastaout -i";
		system $sedcmd;
		$catcmd .= " $fastaout";
		push @outfasta, $fastaout;
		push @outlist, $listfile;
	}
}
$catcmd .= " > $outfile";
if (@outfasta) {
	system $catcmd;
}
unlink @outfasta;
unlink @outlist;
