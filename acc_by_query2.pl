#!/usr/local/bin/perl

use strict;
use Bio::SeqIO;
use Bio::DB::GenBank;
use Bio::DB::Query::GenBank;
use Data::Dumper;

##
my $q = $ARGV[0];
my $filter = $ARGV[1];

my %counts;

## get from database
my $db = Bio::DB::GenBank->new();

open (IN, $q) || die "cannot open $q. $!\n";

open (OUT, ">counts.list");

while (<IN>) {
    chomp;
    my $term = $_;
    print "Retreiving \"$_\".\n";
    my $query = Bio::DB::Query::GenBank->new(-query   =>"$term", -db      => 'nucleotide');
    my $seqobj = $db->get_Stream_by_query($query);

    my $count;

    while (my $seq =  $seqobj->next_seq) {
        if ($filter) {
            my $diff = $term;
            $diff =~ s/A\/[A-Za-z_]*\///;
#            print "MATCH: $diff\n";
#            print $seq->species()->species() . "\n";
            if ($seq->species()->species() =~ /$filter/ && ($seq->species()->species() =~ $diff || $seq->desc() =~ $diff) && $seq->species()->species() =~ /H3N2/ && ($seq->desc() =~ /[Hh]emagglutinin/ || $seq->desc() =~ /HA gene/ || $seq->desc() =~ /segment 4/)) {
                my $acc = $seq->accession();
                my $seqout = Bio::SeqIO->new( -format => 'GenBank', -file => ">$acc.gbf");
#    print Dumper $seq;
                print $acc . "\t" . $seq->species()->binomial() . "\t" . $seq->desc(). "\n";
                $seqout->write_seq($seq);
                $count ++;
            }
        } else {
            my $acc = $seq->accession();
            my $seqout = Bio::SeqIO->new( -format => 'GenBank', -file => ">$acc.gbf");
#    print Dumper $seq;
            print $acc . "\t" . $seq->species()->binomial() . "\n";
            $seqout->write_seq($seq);
        }
    }
    print OUT "$term\tC: $count\n";
    sleep 1;
}