#!/usr/local/bin/perl

use strict;


my $file = $ARGV[0];

open (IN, $file) || die "cannot open $file. $!\n";

my $bac_id;

my %data;

while (<IN>) {
    chomp $_;
    
    if ($_ =~ /INFO/) {
        $bac_id = $_;
        $bac_id =~ s/INFO:.\s\[//;
        $bac_id =~ s/\/.*//;
        my $num = $_;
        $num =~ s/.*\[//;
        $num =~ s/\].*//;
#        if ($num != 1) {
            $data{$bac_id}->{counts} .= $num . " ";
#        }
    } else {
        $data{$bac_id}->{types} .= $_ . " ";
#        print "$bac_id\t$_\n";
    }
}


my %mixed;

foreach my $bac (sort keys %data) {
    if ($data{$bac}->{counts} ne '1 1 ') {
#        print "$bac\t$data{$bac}->{types}\t$data{$bac}->{counts}\n";
        $mixed{$bac} ++;
    }
}

foreach my $bac_id (sort keys %mixed) {
    print "$bac_id\t$data{$bac_id}->{types}\t$data{$bac_id}->{counts}\n";
#    print "HA CONTIG(S)\n";
#    my $cmd = "residues /usr/local/projects/VHTNGS/sample_data_new/giv3/*/$bac_id/assembly_by_segment/HA/HA_100x_contigs.fasta";
#    system $cmd;
#    print "NA CONTIG(S)\n";
#    my $cmd = "residues /usr/local/projects/VHTNGS/sample_data_new/giv3/*/$bac_id/assembly_by_segment/NA/NA_100x_contigs.fasta";
#    system $cmd;
#    print "\n***************************\n";
}
