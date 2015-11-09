#! /usr/local/bin/perl

use strict;
use Bio::SeqIO;

my $asm_file = $ARGV[0];
my $meta_file = $ARGV[1];

my $prefix = $ARGV[2];

my %asm_lookup;
my %metadata;

open (IN,$asm_file) || die "cannot open $asm_file. $!\n";

while (<IN>) {
    chomp $_;
    
    my @line = split /\t/, $_;
    
    $asm_lookup{$line[0]} = $line[1];
    #print "$line[0]\t$line[1]\n";
}

close IN;

open (META,$meta_file) || die "cannot open $meta_file. $!\n";

while (<META>) {
    chomp $_;
    
    my @line = split /\t/, $_;
    
    $metadata{$line[0]}->{$line[1]} = $line[2];
    #print "$line[0]\t$line[1]\t$line[2]\n";
}

close META;

my @files = <${prefix}_*.fasta>;

#print "@files\n";
my $outfile = "$prefix.fasta";
my $oseq = Bio::SeqIO->new(-file => ">$outfile", -format => "fasta");

foreach my $file (@files) {
    my $in = Bio::SeqIO->new(-file => "$file");

    while (my $seq = $in->next_seq()) {
        my $bac_id = $file;
        $bac_id =~ s/${prefix}_//;
        $bac_id =~ s/.fasta//;
        my $blind = $metadata{$bac_id}->{"blinded_number"};
        my $species_code = $metadata{$bac_id}->{"species_code"};
        my $display_id = $seq->display_id();
        my $segment = "$bac_id-$asm_lookup{$display_id}";
        $seq->display_id($segment);
        $seq->desc("$blind\t$species_code");
#        print "$segment\t$display_id\t$blind\t$species_code\n";
        $oseq->write_seq($seq);
    }
}
