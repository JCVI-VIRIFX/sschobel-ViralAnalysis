#!/usr/local/bin/perl

use strict;

my $list = $ARGV[0];
my $total = $ARGV[1];
die "You must specify subsample population size.\n" unless ($total);

my @list;

open (IN, "$list") || die "cannot open $list. $!\n";

while (<IN>) {
    chomp $_;
    push @list, $_;
}
close IN;

my $range = @list;

die "Subsample size must be smaller than sample size.\n" if $total > $range;

my $count = 0;
my %seen;

while ($count < $total) {
    my $random_number = int(rand($range));
    unless ($seen{$random_number}) {
        print $list[$random_number] . "\n";
        $count ++;
    }
    $seen{$random_number} ++;
}