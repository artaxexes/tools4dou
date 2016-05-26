#!/usr/bin/perl

BEGIN {
	die "Esse script faz uso do modulo DateTime\nInstale-o com o comando:\ncpan DateTime\n" unless (eval{require DateTime});
	die "Esse script faz uso do modulo LWP::Simple\nInstale-o com o comando:\ncpan LWP::Simple\n" unless (eval{require LWP::Simple});
}

use strict;
use warnings;
use DateTime;
use LWP::Simple;

print "===== Scraper DOU =====\n";

my $dt = DateTime->now;
$dt = $dt->dmy("/");
print "Today: $dt";
