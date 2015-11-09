#!/usr/local/bin/perl

use strict;

my $file = $ARGV[0];
my $meta = $ARGV[1];
my $group_col = $ARGV[2];
my $col_file = $ARGV[3];

open (COL, $col_file) || die "Cannot open $col_file. $!";
my %color;

while (<COL>) {
    chomp $_;
    my @line = split /\t/, $_;
    $color{$line[0]} = $line[1];
    #print "$line[0]\t$line[1]\n";
}
close COL;

open (META, $meta) || die "Cannot open $meta. $!";
my $col = $group_col - 1;
my %groups;
my %meta;

while (<META>) {
    chomp $_;
    
    my @line = split /\t/, $_;
    
    push @{$groups{$line[$col]}}, $line[0];
#    foreach my $key (keys %MAP) {
#        if ($key =~ /$line[0]\./ || $key eq $line[0]) {
    $meta{$line[1]} = $line[$col];
    #print "$line[1]\t$color{$line[$col]}\n";
#        }
#    }
}
close META;

open (IN, $file) || die "Cannot open $file. $!\n";

my $txt;
my $txt2;
my %counts;

while (<IN>) {
    chomp $_;
    my @line = split "\t", $_;
    
    my $alt_line = $line[0];
    
    foreach my $key (keys %meta) {
        #print "$line[0]\t$key\n";
        if ($key =~ /$line[0]/) {
            $line[0] .= "$color{$meta{$key}}";
            $alt_line = "$meta{$key}$color{$meta{$key}}";
            #print "I got one!! $line[0] $meta{$key}\n";
        }
    }
    $txt .= join("\t",@line);
    $txt .= "\n";
    
    if ($alt_line =~ /A\/.*20.._/) {
        $alt_line =~ s/A\/.*(20.._H.N.)/Human-$1/;
    }
    
    $line[0] = $alt_line;
    my $txt_line .= join("\t",@line);
    $counts{$txt_line} ++;
    $txt2 .= "$txt_line\n";
}
close IN;


foreach my $key (keys %counts) {
    print "$counts{$key}-$key\n";
}