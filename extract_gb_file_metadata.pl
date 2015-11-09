#!/usr/local/bin/perl

use strict;
use Bio::SeqIO;
use Bio::DB::GenBank;
use Bio::DB::Query::GenBank;
use Data::Dumper;

my $file = $ARGV[0];

my $seqin = Bio::SeqIO->new( -format => 'GenBank', -file => "$file");