#!/usr/local/bin/perl

use strict;
use Bio::SeqIO;

my $file = $ARGV[0];
my $ext = $file;
$ext =~ s/.*\.//;

my $in = Bio::SeqIO->new(-file => "$file");

my %seqs;
my %map;
while (my $seq = $in->next_seq()) {
    my $name = $seq->display_id();
    $name =~ s/\.[0-9A-Za-z]*$//;
	my $desc = $seq->desc();
	my $gene = $desc;
	$gene =~ s/.*gene=.//;
	$gene =~ s/".*//;
	$map{$name} = $desc;
    $seqs{$gene}->{$name} = $seq->seq();
    print "$name\t" . $gene . "\n"
}

foreach my $segment (keys %seqs) {
    my $outname = "$segment.$ext";
    open (OUT, ">$outname") || die "cannot open $outname. $!\n";
    foreach my $seq (keys %{$seqs{$segment}}) {
        print OUT ">$seq\n$seqs{$segment}->{$seq}\n";
    }
    close OUT;
}