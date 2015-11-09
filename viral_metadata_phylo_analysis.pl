#!/usr/local/bin/perl

use strict;

my $metafile = $ARGV[0];
my $tree = $ARGV[1];
my $map = $ARGV[2];

my %check_meta = (
	"efantiexp" => 1,
	"efhospexp" => 1,
	"efinsuranceexp" => 1,
	"efpetotherexp" => 1,
	"rfatbspcdur" => 1,
	"rfatbspc" => 1,
	"rfdiagoth" => 1,
);

my %colors = (
	1 => ["#377eb8"],
	2 => ["#377eb8","#e41a1c"],
	3 => ["#377eb8","#e41a1c","#4daf4a"],
	4 => ["#377eb8","#e41a1c","#4daf4a","#984ea3"],
	5 => ["#377eb8","#e41a1c","#4daf4a","#984ea3","#ff7f00"],
	6 => ["#377eb8","#e41a1c","#4daf4a","#984ea3","#ff7f00","#ffff33"],
	7 => ["#377eb8","#e41a1c","#4daf4a","#984ea3","#ff7f00","#ffff33","#a65628"],
	8 => ["#377eb8","#e41a1c","#4daf4a","#984ea3","#ff7f00","#ffff33","#a65628","#f781bf"],
	9 => ["#377eb8","#e41a1c","#4daf4a","#984ea3","#ff7f00","#ffff33","#a65628","#f781bf","#999999"],
	10 => ["#a6cee3","#1f78b4","#b2df8a","#33a02c","#fb9a99","#e31a1c","#fdbf6f","#ff7f00","#cab2d6","#6a3d9a"],
	11 => ["#a6cee3","#1f78b4","#b2df8a","#33a02c","#fb9a99","#e31a1c","#fdbf6f","#ff7f00","#cab2d6","#6a3d9a","#ffff99"],
	12 => ["#a6cee3","#1f78b4","#b2df8a","#33a02c","#fb9a99","#e31a1c","#fdbf6f","#ff7f00","#cab2d6","#6a3d9a","#ffff99","#b15928"],
	13 => ["#a6cee3","#1f78b4","#b2df8a","#33a02c","#fb9a99","#e31a1c","#fdbf6f","#ff7f00","#cab2d6","#6a3d9a","#ffff99","#b15928","#006d2c"],
	14 => ["#a6cee3","#1f78b4","#b2df8a","#33a02c","#fb9a99","#e31a1c","#fdbf6f","#ff7f00","#cab2d6","#6a3d9a","#ffff99","#b15928","#006d2c","#253494"],
	15 => ["#a6cee3","#1f78b4","#b2df8a","#33a02c","#fb9a99","#e31a1c","#fdbf6f","#ff7f00","#cab2d6","#6a3d9a","#ffff99","#b15928","#006d2c","#253494","#253494"],
	16 => ["#a6cee3","#1f78b4","#b2df8a","#33a02c","#fb9a99","#e31a1c","#fdbf6f","#ff7f00","#cab2d6","#6a3d9a","#ffff99","#b15928","#006d2c","#253494","#253494","#253494"],
			
);

my $tree_cmd = "/home/sschobel/scripts/perl_scripts/phylogenetics/tree_labels3.pl";
my $legend_cmd = "/export/workspace/InfluenzaAnalysis/create_legend.R";
my $test_cmd = "/export/workspace/InfluenzaAnalysis/test_significance.R";
my $test_cmd = "/export/workspace/InfluenzaAnalysis/plot_metadata.R";

open (IN, $metafile) || die "cannot open $metafile. $!\n";

my $count;
my @header;
my @matrix;
while (<IN>) {
	chomp $_;
	my @line = split "\t", $_;
	if ($count) {
		#print "$line[0]\n";
		push @matrix, [@line];
	} else {
		@header = @line;
		$count ++;
	}
}


my @files;
for (my $i = 2; $i < @header; $i ++) {
	my @cols = (0,$i,1);
	my @results = &subset_matrix(\@matrix,\@header,\@cols);
	unless (@results) {
		next;
	}
	my $out_tree = $results[0];
	my $legend_prefix = $results[0];
	$legend_prefix =~ s/.tsv//;
	$out_tree =~ s/.tsv/.nxs/;
	
	my $cmd = "$tree_cmd $tree $map $results[0] 2 $results[1] > $out_tree";
	print "$cmd\n";
	system $cmd;
	
	my $cmd = "$legend_cmd -l $results[1] -o $legend_prefix";
	print "$cmd\n";
	system $cmd;
	
	my $cmd = "$test_cmd -l $results[0] -o $legend_prefix";
	print "$cmd\n";
	system $cmd;
	
	push @files, \@results;

}

sub subset_matrix {
	my $matrix = shift;
	my $header = shift;
	my $cols = shift;;
	
	my $htext;
	my $mtext;
	my $count;
	my %cat;
	my $desc = $$cols[1];
	my $desc2 = $$cols[2];
	
	if ($check_meta{$$header[$desc]}) {
		return;
	}
	my $prefix = "$$header[$desc]_to_$$header[$desc2]";
	foreach my $row (@$matrix) {
		foreach my $i (@$cols) {
			unless ($count) {
				$htext .= "$$header[$i]\t";
			}
			$mtext .= "$$row[$i]\t";
			if ($desc == $i) {
				$cat{$$row[$i]} ++;
			}
		}
		chomp $htext;
		chomp $mtext;
		$htext .= "\n";
		$mtext .= "\n";
		$count ++;
	}


	my $tsv = "$prefix.tsv";
	open (TSV, ">$tsv") || die "cannot open tsv file '$tsv'. $!\n";
	print TSV "$htext$mtext";
	close TSV;
	
	my $cat = "$prefix.cat";
	open (CAT, ">$cat") || die "cannot open categories file '$cat'. $!\n";
	my $cat_count = (keys %cat);
	my $i = 0;
	my $cat_txt;
	foreach my $cat (sort {$a <=> $b} (keys %cat)) {
		my $color_array = $colors{$cat_count};
		$cat_txt .= "$cat\t$$color_array[$i]\n";
		$i ++;
	}
	chomp $cat_txt;
	print CAT "$cat_txt\n";
	close CAT;
	
	my @files = ($tsv, $cat);
	
	return @files;
}