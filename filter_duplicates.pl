#!/usr/local/bin/perl

use strict;

use Bio::SeqIO;

my $root = $ARGV[0];

my @files = <*.fasta>;

my %stats;

foreach my $file (@files) {
    if ($file =~ /tmp.fasta/) {
        next;
    }
    my $in = Bio::SeqIO->new(-file => "$file");
    my %seqs;
    while (my $seq = $in->next_seq()) {
        $seqs{$seq->display_id()} = $seq;
    }
    my $outfile = $file;
    $outfile =~ s/([HN]..?)_partition/tmp/;
    my $type = $1;
#    print $file . "\n" . $outfile . "\n";
    my $out = Bio::SeqIO->new(-file => ">$outfile", -format => "fasta");
    
    my $count;
    foreach my $seq (values %seqs) {
        if ($seq->display_id() =~ /California/) {
            $stats{$type}->{"California"} ++;
        } elsif ($seq->display_id() =~ /Alaska/) {
            $stats{$type}->{"Alaska"} ++;            
        } elsif ($seq->display_id() =~ /Japan/) {
            $stats{$type}->{"Japan"} ++;            
        } else {
            $stats{$type}->{"Other"} ++;
        }
        $out->write_seq($seq);
        $stats{$type}->{"ALL"} ++;
    }
    system("mv $outfile $file");
#    print "T: $count\n";
}

my @loc_order = ("California","Alaska","Japan","Other","ALL");

my @type_order = sort keys %stats;

print "\t" . (join "\t", @loc_order) . "\n";

foreach my $type (@type_order) {
    print "$type";
    foreach my $loc (@loc_order) {
        print "\t$stats{$type}->{$loc}";
    }
    print "\n";

}


