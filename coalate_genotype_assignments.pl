#!/usr/bin/perl

use strict;
use FindBin;
use Getopt::Std;
use vars qw($opt_l $opt_m $opt_t $opt_c);

getopts("l:sr:m:sr:c:sr:t:sr");
my $usage = "usage: 
$0 
	-l <gene file>
	-m <strain_map_file>
	-c <coordinates file>
	-t <metadata file>

	Takes a list of DNA,RNA or, protein features, computes pairwise distance 
	and between each feature of a particualr category.  Next categories are 
	parsed into a matrix for each sample based on a specified percent identity 
	cutoff.
";

if(!defined($opt_l)){
	die $usage;
}
if(!defined($opt_m)){
	die $usage;
}
if (!defined($opt_c)) {
	die $usage;
}
if (!defined($opt_t)) {
	die $usage;
}

my $seg_file = $opt_l;
my $map_file = $opt_m;
my $metadata = $opt_t;
my $coords = $opt_c;

my @types = ("TRIG","pdm","N1_classical","N1_pdm","N2_1998","N2_2002","H1_alpha","H1_beta","H1_gamma","H1_pdm","H1_delta1","H1_delta2","H3");
my %type_codes = (
	"TRIG" => "T",
	"pdm" => "P",
	"N1_classical" => "N1c",
	"N1_pdm" => "N1p",
	"N2_1998" => "N298",
	"N2_2002" => "N202",
	"H1_alpha" => "H1a",
	"H1_beta" => "H1b",
	"H1_gamma" => "H1g",
	"H1_pdm" => "H1p",
	"H1_delta1" => "H1d1",
	"H1_delta2" => "H1d2",
	"H3" => "H3",
);

open (IN, $seg_file) || die "cannot open feature list file '$seg_file'. $!\n";
my @segs;
my %order;
my $count;
while (<IN>) {
	chomp $_;
	my @line = split "\t", $_;
	push @segs, $line[0];
	$count ++;
	if ($line[1]) {
		$order{$line[1]} = $count;
	}
}
close IN;

my %acc_map;

open (MAP, $map_file) || die "cannot open accession to strain_name map file '$map_file'. $!\n";
while (<MAP>) {
	chomp $_;
	
	my @line = split /\t/, $_;

	$acc_map{$line[0]} = $line[1];	

	if (!$line[0]) {
		print "@line\n"
	}
}
close MAP;


my %coords;

open (COORDS, $coords) || die "cannot open accession to strain_name map file '$coords'. $!\n";
while (<COORDS>) {
	chomp $_;
	
	my @line = split /\t/, $_;

	my $lat_lon = "$line[1]_$line[2]";

	$coords{$line[0]} = $lat_lon;

}
close COORDS;

my %metadata;

open (META, $metadata) || die "cannot open accession to strain_name map file '$metadata'. $!\n";
while (<META>) {
	chomp $_;
	
	my @line = split /\t/, $_;

	#print "$line[1]\n";

	$metadata{$line[0]}->{strain_name} = $line[1];	
	$metadata{$line[0]}->{date} = $line[2];	
	$metadata{$line[0]}->{segment_num} = $line[3];
	$metadata{$line[0]}->{subtype} = $line[4];	

	$metadata{$line[0]}->{date} =~ s/__//;
	$metadata{$line[0]}->{date} =~ s/_$//;	
	$metadata{$line[0]}->{date} =~ s/_/-/g;	

	if ($coords{$line[1]}) {
		$metadata{$line[0]}->{lat_lon} = $coords{$line[1]};
		#print "$coords{$line[1]}\n";
	}
}
close META;

my %genotypes;
my %acc_lookup;
my $count;
foreach my $seg (@segs) {
	foreach my $type (@types) {
		my $file = "${seg}_$type.txt";
		if (-e $file) {
			#print "Reading genotype assignments in file: $file\n";
			open (IN, "$file") || die "Cannot open $file. $!\n";
			while (<IN>) {
				chomp $_;
				if ($_ =~ /^$/ || $_ =~ /_____/) {
					next;
				} else {
					$_ =~ s/\s//g;
					my @line = split /\//, $_;
					my $last = pop @line;
					
					my @acc = split /_/, $last;
							
					my $strain_name = join('/', @line) . "/$acc[0]"; 
					if ($acc_map{$acc[1]}) {
						$count ++;
						#print "$count\t'$acc[1]'\t'$strain_name'\t'$acc_map{$acc[1]}'\n";
					}
					push @{$genotypes{$acc_map{$acc[1]}}->{$seg}}, $type_codes{$type};
					
					if ($metadata{$acc[1]}->{strain_name} ne $acc_map{$acc[1]}) {
						#print "MISMATCH: $metadata{$acc[1]}->{strain_name}\t$acc_map{$acc[1]}\n";
						$metadata{$acc[1]}->{strain_name} = $acc_map{$acc[1]};
					}
					push @{$acc_lookup{$metadata{$acc[1]}->{strain_name}}->{$seg}}, $acc[1];
#					print "$acc[1]\t$seg:$type\t$strain_name\t$metadata{$acc[1]}->{strain_name}\n";
				}
			}
			close IN;
		}
	}
}



foreach my $strain_name (keys %genotypes) {
	my $seg_txt;
	foreach my $seg (@segs) {
		if ($genotypes{$strain_name}->{$seg}) {
			my $this_seg = join ('-',@{$genotypes{$strain_name}->{$seg}});
			$seg_txt .= "$this_seg";
		} else {
			die "ERROR '$strain_name': '$seg' missing assignment\n";
		}
	}
	#print "${strain_name}_$seg_txt\n";
	foreach my $seg (@segs) {
		foreach my $acc (@{$acc_lookup{$strain_name}->{$seg}}) {
			$metadata{$acc}->{genotype} = $seg_txt;
		}
	}
}

foreach my $acc (sort keys %metadata) {
	print "$acc\t$metadata{$acc}->{strain_name}\t$metadata{$acc}->{genotype}\t$metadata{$acc}->{lat_lon}\t$metadata{$acc}->{date}\t$metadata{$acc}->{segment_num}\t$metadata{$acc}->{subtype}\n";
}

