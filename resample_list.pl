#!/usr/local/bin/perl

use strict;

my $list = $ARGV[0];
my $num = $ARGV[1];

open (IN, $list) || die "Cannot open $list. $!\n";

my @list;

while (<IN>) {
    chomp $_;

    push @list, $_;
}

my $n_items = @list;
my $i = 0;
my %seen;
while ($i < 50) {
    my $number = int(rand($n_items));
    if ($seen{$number}) {
	next;
    } else {
	$seen{$number} ++;
	print "$list[$number - 1]\n";
	$i ++;
    }
}
