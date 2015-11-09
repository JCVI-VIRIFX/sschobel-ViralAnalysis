#!/usr/local/bin/perl

use strict;
use Bio::SeqIO;
use Bio::DB::GenBank;
use Bio::DB::Query::GenBank;
use Data::Dumper;

##
my $list = $ARGV[0];
my $database = $ARGV[1];
my $format = $ARGV[2];

if (!$database) {
	$database = "nucleotide";
}
if (!$format) {
	$database = "GenBank";
}

my @outseqs;

## get from database
my $db = Bio::DB::GenBank->new();

print "Retreiving \"$list\".\n";

open (IN, $list) || die "cannot open $list. $!\n";
my $seqout = Bio::SeqIO->new( -format => "$format", -file => ">out.$format");

while (<IN>) {
    chomp $_;
    my $q = $_;
    my $query = Bio::DB::Query::GenBank->new(-query   =>"$q", -db      => "$database");
    my $seqobj = $db->get_Stream_by_query($query);
    while (my $seq =  $seqobj->next_seq) {
        my $acc = $seq->accession();
        my $string = $seq->desc();

        print $acc . "\t" . $string . "\n";
        $seqout->write_seq($seq);
    }
    
    sleep 1;
}
close IN;
