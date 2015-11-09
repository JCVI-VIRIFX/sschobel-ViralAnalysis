#!/usr/local/bin/perl

use strict;

my $file = $ARGV[0];
my $map = $ARGV[1];
my $random_sample = $ARGV[2];
my $trim_burnin = $ARGV[3];

my $new_file = "$file.new";

my %MAP;
open (MAP, $map) || die "Cannot open $map. $!";
while (<MAP>) {
    chomp $_;
    
    my @line = split /\t/, $_;
	if ($line[1] ne "") {    
		$MAP{$line[0]} = $line[1];
	} else {
		$MAP{$line[0]} = "NULL";
	}
}
close MAP;

open (IN, $file) || die "Cannot open $file. $!\n";

my $taxlabels;
my $translate;
my $txt;
my $states = "#NEXUS\n\nbegin states;\n";
my @trees;
my $count;
while (<IN>) {
    chomp $_;
    my $line = $_;
    if ($_ =~ /Begin/i) {
        $taxlabels = 1;
    }
    if ($_ =~ /^tree/i) {
        $taxlabels = 0;
        if ($translate) {
        $txt .= $states . "End;\n\nbegin trees;\n"
        }
        $translate = 0;
    }
    if ($_ =~ /Translate/i) {
    	$translate = 1;
    	next;
    }
    
    
    if ($taxlabels && $translate) {
    	foreach my $key (keys %MAP) {
    		if ($line =~ /'$key'/) {
        		$line =~ s/'$key'/'$MAP{$key}'/;
        		$line =~ s/\'//g;
        		$line =~ s/,//g;
        		$line =~ s/^\s*//;
    		}
    	}
    	if ($line =~ /;/) {
    		next;
    	}
    	$states .= "$line\n";
    } elsif (!$taxlabels) {
    	if ($line =~ /^tree/) {
    		$line =~ s/ \[\&lnP\=.*\] = \[\&R\]/ = [&R]/;
    		$line =~ s/\[\&rate\=[.0-9E-]*\]//g;
    		push @trees, $line;
    		$count ++;
    	}
    }
}
close IN;

my $len = @trees;

if ($trim_burnin) {
	my $trim = sprintf("%.0f", ($len * $trim_burnin));
	my $end = $len - 1;
	@trees = @trees[$trim..$end];
	my $new_len = @trees;
	#print "C: $count\nT: $trim\nL: $len\nN: $new_len\n";
}

my $len = @trees;
my $target = $random_sample/$len;

#print "T: $target\nL: $len\n";

if ($random_sample) {
	foreach my $tree (@trees) {
		my $random_number = rand(1);
		if ($random_number <= $target) {
			$txt .= "$tree\n";
		}
	}
} else {
	$txt .= join("\n",@trees);
	$txt .= "\n";
}

$txt .= "End;\n";

print $txt;
