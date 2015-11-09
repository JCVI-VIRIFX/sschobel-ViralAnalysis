#!/usr/local/bin/perl

use strict;

my $file = $ARGV[0];
my $map = $ARGV[1];

my $new_file = "$file.new";

my %MAP;
my %color;

open (MAP, $map) || die "Cannot open $map. $!";
while (<MAP>) {
    chomp $_;
    
    my @line = split /\t/, $_;
    
    $MAP{$line[0]} = $line[1];
    $color{$line[0]} = $line[2];
    
    print "$line[0] => $line[1], $line[2]\n";
}
close MAP;

open (IN, $file) || die "Cannot open $file. $!\n";


my $start;
my $first;
my $text;
my $taxa;
my $beg;
my $tree;
my $rest;
my $count;


while (<IN>) {
    #chomp $_;
    $_ =~ s/\r\n$//g;
    chomp $_;
    

    print "$_\n";

}
close IN;


#print "#NEXUS\nbegin taxa;\ndimensions ntax=$count;\ntaxlabels\n$taxa;\nend;\nbegin trees;\ntranslate\n$tree${rest}end;\n";
