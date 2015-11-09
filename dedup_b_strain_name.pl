#!/usr/local/bin/perl

use strict;

my $file = $ARGV[0];
my $meta = $ARGV[1];
my $color = $ARGV[2];
my $segment = $ARGV[3];

#my $in = Bio::SeqIO->new(-file => "$file");

my %strains;
my %subs;

open (IN, "$file") || die "cannot open $file. $!\n";

while (<IN>) {
    chomp $_;
    
    my @line = split /\t/, $_;
    
    $line[1] =~ s/_(H7N.)//;
    my $subtype = $1;
    $line[1] = uc $line[1];
    $line[1] =~ s/NORTHERN_SHOVERL/NORTHERN_SHOVELER/;
    $line[1] =~ s/GREEN_WINGED_TEAL/GREEN-WINGED_TEAL/;
    $line[1] =~ s/GUINEAFOWL/GUINEA_FOWL/;
    $line[1] =~ s/CHUCKAR/CHUKAR/;
    if ($subtype =~ /H7N/) {
        $subs{"$line[1]"} = $subtype;
    }
    # print "$line[0]\t$line[1]\n";
    push @{$strains{$line[1]}}, $line[0];
}

close IN;

#foreach my $strain (sort keys %subs) {
#    print "$strain\t$subs{$strain}\n";
#}

#exit();

open (META, $meta) || die "Cannot open $meta. $!";
my %meta;

while (<META>) {
    chomp $_;
    
    my @line = split /\t/, $_;
    
    $meta{$line[0]} = $line[1];
}
close META;

open (COLOR, $color) || die "Cannot open $color. $!";
my %color;

while (<COLOR>) {
    chomp $_;
    
    my @line = split /\t/, $_;
    
    $color{$line[0]} = $line[1];
}
close COLOR;

my $error;

foreach my $strain (sort keys %strains) {
    @{$strains{$strain}} = sort @{$strains{$strain}};
    if (@{$strains{$strain}} > 1) {
        if (${$strains{$strain}}[0] =~ /-$segment/) {
            if (@{$strains{$strain}} > 2 || ${$strains{$strain}}[1] =~ /-$segment/) {
                print "$strain\t@{$strains{$strain}}\n";
                $error ++;
            }
        } else {
             print "$strain\t@{$strains{$strain}}\n";
             $error ++;
        }
    } 
}

if ($error) {
    exit;
}


foreach my $strain (sort keys %strains) {
    @{$strains{$strain}} = sort @{$strains{$strain}};
    my $text;
    my %species;
    #print "$strain\t@{$strains{$strain}}\n";
    if (@{$strains{$strain}} > 1) {
        #print "$strain\t@{$strains{$strain}}\n";
        if (${$strains{$strain}}[0] =~ /-$segment/) {
            #print "$strain\t@{$strains{$strain}}\n";
            foreach my $id (@{$strains{$strain}}) {
                if ($id =~ /-$segment/) {
                    $text .= "$id\t$strain";
                }
            }
            if (@{$strains{$strain}} > 2) {
                #print "$strain\t@{$strains{$strain}}\n";
            }
        } else {
             #print "$strain\t@{$strains{$strain}}\n";
        }
    } else {
        $text .= "@{$strains{$strain}}\t$strain";
    }
    
    if ($subs{"$strain"}) {
        $text .= "_$subs{\"$strain\"}";
    }

    foreach my $species (keys %meta) {
        if ($text =~ /$species/ && !$species{$text}) {
            $species{$text} ++;
            print "$text\t$color{$meta{$species}}\n";
        }
    }
    if (!$species{$text}) {
        print "$text\n";
    }
}