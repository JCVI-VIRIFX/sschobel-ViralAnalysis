#!/usr/local/bin/perl

use strict;

my $file = $ARGV[0];
my $meta = $ARGV[1];
my $map = $ARGV[2];

my $new_file = "$file.new";

open (META, $meta) || die "Cannot open $meta. $!";
my %meta;

while (<META>) {
    chomp $_;
    
    my @line = split /\t/, $_;
    
    $meta{$line[0]} = $line[1];
}
close META;

open (MAP, $map) || die "Cannot open $map. $!";
my %map;

while (<MAP>) {
    chomp $_;
    
    my @line = split /\t/, $_;
    
    $map{$line[0]} = $meta{$line[1]};
    
    #print "$line[0]\t$line[1]\t$meta{$line[1]}\n";
}
close MAP;

open (IN, $file) || die "Cannot open $file. $!\n";

my $taxlabels;
my $txt;
while (<IN>) {
    chomp $_;
    my $line = $_;
    if ($_ =~ /end;/i) {
        $taxlabels = 0;
    }
    foreach my $key (keys %map) {
        if ($taxlabels && $line =~ /$key/) {
            $line .= " [&!color=$map{$key}]";
        } 
    }
    if ($taxlabels && $line !~ /color/) {
        $line .= " [&!color=#000000]";
    }
    $txt .= "$line\n";
    if ($_ =~ /taxlabels/i) {
        $taxlabels = 1;
    }
}
close IN;

print $txt;
