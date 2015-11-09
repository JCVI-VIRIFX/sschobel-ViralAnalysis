#!/usr/local/bin/perl 

use strict;

use Time::Local;
use POSIX qw(strftime);

my $file = $ARGV[0];
my $col = $ARGV[1];

open (IN, $file) || die "Cannot open $file. $!\n";

while (<IN>) {
    chomp $_;
    my @line = split /\t/, $_;
    my $date = $line[$col - 1];
    my ($day, $string, $year) = split '-', $date;

	my $month = &string_to_month($string);
    my $epoch = timelocal(0, 0, 0, $day, $month -1, $year -1900);
    my $week = strftime("%U", localtime($epoch));

    print "$_\t$year-$week\t$year-$string\n";
}

sub string_to_month {
	my $string = shift;
	
	my %map = (
		'Jan' => 1,
		'Feb' => 2,
		'Mar' => 3,
		'Apr' => 4,
		'May' => 5,
		'Jun' => 6,
		'Jul' => 7,
		'Aug' => 8,
		'Sep' => 9,
		'Oct' => 10,
		'Nov' => 11,
		'Dec' => 12,
	);
	
	return $map{$string};
}	