#!/usr/local/bin/perl

use strict;

my $file = $ARGV[0];
my $map = $ARGV[1];
my $meta = $ARGV[2];
my $group_col = $ARGV[3];
my $col_file = $ARGV[4];

my $new_file = "$file.new";

my %MAP;

open (MAP, $map) || die "Cannot open $map. $!";
my %seen;

while (<MAP>) {
    chomp $_;
    
    my @line = split /\t/, $_;
    
    if ($seen{$line[1]}) {
        $seen{$line[1]} ++;
        $MAP{$line[0]} = "${line[1]}_$seen{$line[1]}";
    } else {
        $seen{$line[1]} ++;    
        $MAP{$line[0]} = $line[1];
    }
}
close MAP;

open (COL, $col_file) || die "Cannot open $col_file. $!";
my %color;

while (<COL>) {
    chomp $_;
    
    my @line = split /\t/, $_;
    
    $color{$line[0]} = $line[1];
    
    #print "$line[0] => $line[1]\n";
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
    foreach my $key (keys %MAP) {
        if ($key =~ /$line[0]\./ || $key eq $line[0]) {
            $meta{$key} = $color{$line[$col]};
            #print $key ."\n";
        }
    }
}
close META;

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
        if ($meta{$key} && $taxlabels && $line =~ /$key/) {
            $line .= " [&!color=$meta{$key}]";
        }
        $line =~ s/$key/$MAP{$key}/;
    }
    $txt .= "$line\n";
}
close IN;
#exit;
print $txt;
