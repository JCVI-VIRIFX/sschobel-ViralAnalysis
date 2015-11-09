#!/usr/local/bin/perl

use strict;
use Bio::SeqIO;

my $seg_file = $ARGV[0];
my $protein = $ARGV[1];
my $ext;

if ($protein) {
	$ext = "pep";
} else {
	$ext = "fasta";
}

open (IN, $seg_file) || die "cannot open $seg_file. $!\n";
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

my $ROOT = "/usr/local/devel/VIRIFX/software";

my %EXECS = (
    CA2PP => "$ROOT/ANDES/ClustalALN_to_PositionProfile.pl",
    PENT => "$ROOT/ANDES/Plot_Entropy.r",
    CENT => "$ROOT/ANDES/Compute_NormalizedShannonEntropy_for_Profile.pl",
    MAFFT => "/usr/local/bin/mafft",
);

my %ext = (
	'pep' => 'aa',
	'fasta' => 'nuc',
);

foreach my $seg (@segs) {
    my $alnfile = "$seg.$ext.aln";
    my $fsafile = "$seg.$ext";
	my $rdprof = "$seg.$ext.$ext{$ext}.prof";
	my $cout = "$seg.$ext.$ext{$ext}";
	my $ent = $cout .".ent";

    unless (-e $alnfile) {    
        my $cmd = $EXECS{MAFFT} . " --clustalout $fsafile > $alnfile";
        print "$cmd\n";
        system $cmd;
    }
    
    unless (-e $rdprof) {
	    my $cmd = $EXECS{CA2PP} . " -a $alnfile";
	    if ($protein) {
	    	$cmd .= " -m";
	    }
    	print "$cmd\n";
    	system $cmd;
    }
    
	my $cmd = $EXECS{CENT} . " -i $rdprof -o $cout";
	print "$cmd\n";
	system $cmd;
    
    my $cmd = $EXECS{PENT} . " -e $ent";
    print "$cmd\n";
	system $cmd;
    
}