#!/usr/local/bin/perl

use strict;
use Bio::SeqIO;

my $file = $ARGV[0];
my $map = $ARGV[1];
my $col = $ARGV[2];

print "F: $file\nM: $map\nC: $col\n";
unless ($col) {
	die "You did not specify metadata column (count by 1).\n";
}

my $in = Bio::SeqIO->new(-file => "$file");

my %seqs;
my %map;
my %m2;
my %map_txt;

my %file_name = (
	1 => 'PB2',
	2 => 'PB1',
	3 => 'PA',
	4 => 'HA',
	5 => 'NP',
	6 => 'NA',
	7 => 'M',
	8 => 'NS',
	'PB2' => 'PB2',
	'PB1' => 'PB1',
	'PA' => 'PA',
	'HA' => 'HA',
	'NP' => 'NP',
	'NA'  => 'NA',
	'MP' => 'M',
	'NS' => 'NS',
);

open (MAP, "$map") || die "cannot open map file '$map'. $!\n";

my $ad_col = $col-1;
while (<MAP>) {
    chomp $_;
    
    my @line = split /\t/, $_;
    $map{$line[0]} = $line[1];
    $m2{$line[0]} = $line[$ad_col];
    
#    print "$line[0]\t$line[$ad_col]\n";
}

close MAP;

while (my $seq = $in->next_seq()) {
    my $name = $seq->display_id();

    $seqs{$m2{$name}}->{$name} = $seq->seq();
    $map_txt{$m2{$name}}->{$name} = "$name\t$map{$name}\n";
}

foreach my $segment (keys %seqs) {
    my $outname = "$file_name{$segment}.fasta";
    my $mapname = "$file_name{$segment}.map";
    open (OUT, ">$outname") || die "cannot open $outname. $!\n";
    open (MAP, ">$mapname") || die "cannot open $mapname. $!\n";
    foreach my $seq (keys %{$seqs{$segment}}) {
        print OUT ">$seq\n$seqs{$segment}->{$seq}\n";
        print MAP "$map_txt{$segment}->{$seq}";
    }
    close OUT;
    close MAP;
}