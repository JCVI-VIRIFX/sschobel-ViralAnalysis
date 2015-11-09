#!/usr/local/bin/perl

use strict;

my $file = $ARGV[0];

open (IN, $file) || die "Cannot open $file. $!\n";

my %SEQS;

my $segment;
my $subtype;
my $acc;
my $strain;
my $ha;
my $na;

while (<IN>) {
    chomp $_;
    
    if ($_ =~ />/) {
        my @line = split /\|/, $_; ## /
        $subtype = $line[3];
        $subtype =~ s/Subtype://;
        $ha = $subtype;
        $ha =~ s/N.*//;
        $na = $subtype;
        $na =~ s/.*N/N/;
        $strain = $line[1];
        $strain =~ s/Organism:Influenza A virus //;
        $strain =~ s/ /_/g;
        $acc = $line[0];
        $acc =~ s/>gb://;
        $segment = $line[2];
        $segment =~ s/Segment://;
        if ($subtype eq "mixed") {
            if ($segment == 4) {
                $subtype = "HA_$subtype";
                $ha = $subtype;
            } elsif ($segment == 6) {
                $subtype = "NA_$subtype";
                $na = $subtype;
            }
        }
        print "$acc\t$strain\t$segment\t$subtype\t$ha\t$na\n";
    } else {
        if ($segment == 4) {
            $SEQS{$ha}->{$acc}->{strain} = $strain;
            $SEQS{$ha}->{$acc}->{sequence} .= $_;
        } elsif ($segment == 6) {
            $SEQS{$na}->{$acc}->{strain} = $strain;
            $SEQS{$na}->{$acc}->{sequence} .= $_;
        }
        elsif ($segment == 1) {
            $SEQS{PB2}->{$acc}->{strain} = $strain;
            $SEQS{PB2}->{$acc}->{sequence} .= $_;
        }
        elsif ($segment == 2) {
            $SEQS{PB1}->{$acc}->{strain} = $strain;
            $SEQS{PB1}->{$acc}->{sequence} .= $_;
        }
        elsif ($segment == 3) {
            $SEQS{PA}->{$acc}->{strain} = $strain;
            $SEQS{PA}->{$acc}->{sequence} .= $_;
        }
        elsif ($segment == 5) {
            $SEQS{NP}->{$acc}->{strain} = $strain;
            $SEQS{NP}->{$acc}->{sequence} .= $_;
        }
        elsif ($segment == 7) {
            $SEQS{MP}->{$acc}->{strain} = $strain;
            $SEQS{MP}->{$acc}->{sequence} .= $_;
        }
        elsif ($segment == 8) {
            $SEQS{NS}->{$acc}->{strain} = $strain;
            $SEQS{NS}->{$acc}->{sequence} .= $_;
        }
    }
}

foreach my $subtype (keys %SEQS) {
    open (FSA, ">$subtype.fasta") || die "Cannot open $subtype.fasta. $!\n";
    open (MAP, ">$subtype.map") || die "Cannot open $subtype.map. $!\n";
    foreach my $acc (keys %{$SEQS{$subtype}}) {
        print FSA ">$acc\n$SEQS{$subtype}->{$acc}->{sequence}\n";
        print MAP "$acc\t$SEQS{$subtype}->{$acc}->{strain}\n";
    }

    close FSA;
    close MAP;
}