#!/usr/local/bin/perl

use strict;

use TIGR::GLKLib;


my $infile = $ARGV[0];
my $server = "SYBPROD";
my $db = "giv3";

my $glk = TIGR::GLKLib::newConnect($server, $db, 'access', 'access');

open (IN, "$infile") || die "Cannot open $infile. $!\n";

while (<IN>) {
    chomp $_;
    my $bac_id = $_;
    
    my $eid = $glk->getExtentByTypeRef('SAMPLE', $bac_id);
    my $atts = $glk->getExtentAttributes($eid);

    foreach my $at (keys %$atts) {
#        if ($at eq "country" || $at eq "district" || $at eq "species_code" || $at eq "collection_date") {
            print "$bac_id,$at=>$$atts{$at}\n";
#        }
    }
}