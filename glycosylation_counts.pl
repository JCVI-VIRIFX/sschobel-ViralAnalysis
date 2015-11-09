#!/usr/local/bin/perl

use strict;

use Bio::SeqIO;
use Bio::AlignIO;
use Data::Dumper;

my $file = $ARGV[0];

#my $seqin = Bio::SeqIO->new( -format => 'fasta', -file => "$file");
my $seqin = Bio::AlignIO->new(-file => "$file", -format => "clustalw");
my %hash;

my %sites;


while (my $aln = $seqin->next_aln()) {
    foreach my $seq ($aln->each_seq()) {
        my $name = $seq->display_id();
        my $sequence = $seq->seq();
#       print "$name\t";
        for (my $i = 0; $i < length($sequence); $i ++) {
            my $substr = substr($sequence,$i,3);
            if ($substr =~ /.-./) {
                $substr = substr($sequence,$i,4);
                $substr =~ s/-//;
            }
                if (($substr =~ /N.S/ || $substr =~ /N.T/) && $substr !~ /.P./) {
                    $hash{$name}->{count} ++;
                    $hash{$name}->{sites}->{$i} = $substr;
                    $sites{$i} ++;
#                   print "$i\t$substr\t";
                }
        }
#    print "\n";
    }
}

my @sites = sort {$a <=> $b} keys %sites;

foreach my $name (sort keys %hash) {
    print "$name\t$hash{$name}->{count}";
    
    foreach my $site (@sites) {
        if ($hash{$name}->{sites}->{$site}) {
            print "\t$site\t$hash{$name}->{sites}->{$site}";
        } else {
            print "\t\t";
        }
    }
    print "\n";
    
}

#print "@sites\n";