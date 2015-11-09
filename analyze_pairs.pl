#!/usr/local/bin/perl

use strict;

my $DIR = "/usr/local/projects/VHTNGS/sample_data_new/giv3/WBC/%BACID%/assembly_by_segment/%SEG%/%SEG%_100x_contigs.fasta";

my @segs = ("HA","MP","NA","NP","NS","PA","PB1","PB2");

my $list = $ARGV[0];
my @list;

open (IN, "$list") || die "cannot open $list. $!\n";

while (<IN>) {
    chomp $_;
    push @list, $_;
}

close IN;

foreach my $sample (@list) {
    print "Working on bac_id $sample:\n";
    foreach my $seg (@segs) {
        my $path = $DIR;
        $path =~ s/%BACID%/$sample/;
        $path =~ s/%SEG%/$seg/g;
        print "$path\n";
        system "residues $path";
    }
}