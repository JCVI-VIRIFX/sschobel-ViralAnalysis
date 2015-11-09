#!/usr/local/bin/perl

use strict;

use Bio::DB::GenBank;
use Bio::DB::Query::GenBank;
use Data::Dumper;

my $file = $ARGV[0];

open (IN, $file) || die "Cannot open $file. $!\n";

my $db = Bio::DB::GenBank->new();

my @cols = ("organism","serotype","serotype","serotype","country","lat_lon","collection_date","host","note");

open (OUT, ">>tmp.csv") || die "cannot open outfile\n";

while (<IN>) {
    chomp $_;
    print "retrieving $_\n";
    my $query = Bio::DB::Query::GenBank->new(-query   =>"$_", -db      => 'nucleotide');
    my $seqobj = $db->get_Stream_by_query($query);
    my $acc;
    while (my $seq = $seqobj->next_seq()) {
        if ($seq->desc() =~ /segment 4/ || $seq->desc() =~ /\(HA\)/) {
            print $seq->accession() . "\n";
            foreach my $feat ( $seq->get_SeqFeatures() ) {
                if ($feat->primary_tag() =~ /source/) {
#                    print Dumper $feat;
                    foreach my $col (@cols) {
                        if ($feat->has_tag($col)) {
                        my @data = $feat->get_tag_values($col);
                            print OUT "$data[0]";
                        }
                        print OUT "\t";
                    }
                    print OUT "\n";
                }
            }
        }
    }
    sleep 1;
}

close IN;