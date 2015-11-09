#!/usr/local/bin/perl

use strict;

my $mapfile = $ARGV[0];
my $metafile = $ARGV[1];

my %meta = (
"2009A" => {"range" => '09SW1477-09SW1491', "date" => "07/05/2009"},
"2009B" => {"range" => '09SW63-09SW80', "date" => "08/08/2009"},
"2009C" => {"range" => '09SW81-09SW100', "date" => "08/13/2009"},
"2010C" => {"range" => '10SW121-10SW139', "date" => "08/12/2010"},
"2010D" => {"range" => '10SW156-10SW156', "date" => "08/19/2010"},
"2010E" => {"range" => '10SW202-10SW220', "date" => "08/24/2010"},
"2011B" => {"range" => '11SW121-11SW140', "date" => "08/06/2011"},
"2011C" => {"range" => '11SW201-11SW220', "date" => "08/12/2011"},
"2011D" => {"range" => '11SW221-11SW240', "date" => "08/18/2011"},
"2011F" => {"range" => '11SW344-11SW349', "date" => "09/07/2011"},
"2011G" => {"range" => '11SW144-11SW149', "date" => "08/07/2011"},
"2011Ha" => {"range" => '11SW87-11SW119', "date" => "08/05/2011"},
"2011Hb" => {"range" => '11SW161-11SW200', "date" => "08/08/2011"}
);

open (MAP, $mapfile) || die "cannot open $mapfile. $!\n";

while (<MAP>) {
    chomp $_;
    
    my @line = split /\t/, $_;
    
    foreach my $key (keys %meta) {
        my $range = $meta{$key}->{"range"};
        my @coords = split /-/, $range; #/;
        $coords[0] =~ s/(.*SW)//;
        my $prefix = $1;
        $coords[1] =~ s/.*SW//;
        #print "$key\t$range\t$coords[0]\t$coords[1]\n";
        for (my $i = $coords[0]; $i <= $coords[1]; $i ++) {
            if ($line[1] =~ /${prefix}$i/) {
                print "$line[0]\t$line[1]\t$key\t${prefix}$i\t$meta{$key}->{'date'}\n";
            }
        }
    }
    
}