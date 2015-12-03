#!/usr/bin/perl

use warnings;
use strict;

open (FILE1, $ARGV[0]); #FPGA file first, assumed to be at least 4x shorter than proc file
open (FILE2, $ARGV[1]);

my $match_count = 0;

while (<FILE1>){
    my $fpga_line = $_;
    #print $fpga_line;
    if($fpga_line =~ m/([0-9a-f]{15})[0-9a-f]/){
        my $cache_line = $1;
        print $cache_line."\n";
        for(my $i=0; $i<4; $i++){
            my $proc_line = <FILE2>;
            if($proc_line =~ m/([0-9a-f]{15})[0-9a-f]/){
                #print $proc_line;
                print $1."\n";
            }else{
                print "PARSING ERROR!";
                exit(1);
            }
            if($cache_line eq $1){
                print "Match\n";
                $match_count++;
            }
        }
    } else{
        print "PARSING ERROR!";
        exit(1);
    }
}

print $match_count." matches\n";
