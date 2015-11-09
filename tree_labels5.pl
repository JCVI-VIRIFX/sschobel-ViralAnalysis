#!/usr/local/bin/perl

use strict;

my $file = $ARGV[0];
my $map = $ARGV[1];
my $meta = $ARGV[1];

my $new_file = "$file.new";

my %MAP;
my %color;

open (MAP, $map) || die "Cannot open $map. $!";
my %seen;

while (<MAP>) {
    chomp $_;
    
    my @line = split /\t/, $_;
    
    if ($line[2]) {
        $color{$line[0]} = $line[2];
    }
    
    if ($seen{$line[1]}) {
        $seen{$line[1]} ++;
        $MAP{$line[0]} = "${line[1]}_$seen{$line[1]}";
    } else {
        $seen{$line[1]} ++;    
        $MAP{$line[0]} = $line[1];
    }
    #print "$line[0] => $line[1]\n";
}
close MAP;

open (IN, $file) || die "Cannot open $file. $!\n";

my $taxlabels;
my $txt;
while (<IN>) {
    chomp $_;
    my $line = $_;
    if ($_ =~ /taxlabels/i) {
        $taxlabels = 1;
    }
    if ($_ =~ /end/i) {
        $taxlabels = 0;
    }
    foreach my $key (keys %MAP) {
        if ($taxlabels && $color{$key} && $line =~ /$key/) {
            $line .= " [&!color=$color{$key}]";
        }
        $line =~ s/$key...../$MAP{$key}/;
    }
    $txt .= "$line\n";
}
close IN;

#foreach my $key (keys %MAP) {
#    $txt =~ s/$key/$MAP{$key}/g
#}

print $txt;
