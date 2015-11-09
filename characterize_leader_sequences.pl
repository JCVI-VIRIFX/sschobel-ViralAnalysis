#!/usr/local/bin/perl

use strict;
use Bio::SeqIO;

my $file = $ARGV[0];
my $len = $ARGV[1];
unless ($len) {
	$len = 10;
}

my $in = Bio::SeqIO->new(-file => "$file");

my %leaders;

my %seqs;

while (my $seq = $in->next_seq()) {
	my $sequence = $seq->seq();
	my $id = $seq->id();
#	push @{$seqs{$sequence}}, $id;

	my $leader = substr($sequence,0,$len);

	$leaders{$leader} ++;
}

foreach my $leader (sort {$leaders{$a} <=> $leaders{$b}} keys %leaders) {
	print "$leader\t$leaders{$leader}\n";
}

#open (OUT, ">unique.list") || die "Cannot open unique.list. $!\n";
#foreach my $sequence (keys %seqs) {
#	my $count = @{$seqs{$sequence}};
#	if ($count < 2) {
#		print OUT ${$seqs{$sequence}}[0] ."\n";
#	}
#}