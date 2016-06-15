#!/usr/bin/perl
# test.pl

BEGIN {
	die "Modulo DateTime necessario, instale-o\n" unless (eval{require DateTime});
	die "Modulo LWP::Simple necessario, instale-o\n" unless (eval{require LWP::Simple});
	die "Modulo Date::Calc::Iterator necessario, instale-o\n" unless (eval{require Date::Calc::Iterator});
}

use 5.22.1;
use strict;
use warnings;
use LWP::Simple;
use DateTime;
use Date::Calc::Iterator;

=pod

# my $url = "http://pesquisa.in.gov.br/imprensa/jsp/visualiza/index.jsp?jornal=1&pagina=1&data=10/06/2016&captchafield=firistAccess";
# my $url = "http://pesquisa.in.gov.br/imprensa/servlet/INPDFViewer?jornal=10&pagina=1&data=14/06/2016&captchafield=firistAccess";

=cut

test04();

sub test01 {
        my $url = shift;
        my @info = head($url);
        return 0 unless ($info[0] eq "application/pdf");
        return 1;
}

sub test02 {
	my $url = shift;
	my $file = get($url);
	if ($file =~ /(&totalArquivos=)([0-9]+)"/) {
		say "$2 pages";
	}
}

sub test03 {
	my (@date_begin, @date_final) = @_;
	my $i = Date::Calc::Iterator->new(from => [@date_begin], to => [@date_final]);
	#my $i = Date::Calc::Iterator->new(from => [2016,06,01], to => [2016,06,14]);
	my @dts;
	push(@dts,$_) while $_ = $i->next;
	foreach my $dt (@dts) {
		print sprintf("%02d/%02d/%04d\n", @{$dt}[2], @{$dt}[1], @{$dt}[0]);
	}
}

sub test04 {
	my $date1 = DateTime->new(year => '2016', month => '06', day => '01');
	my $date2 = DateTime->new(year => '2016', month => '06', day => '15');
	my ($date, $date_begin, $date_final);
	while($date1 <= $date2) {
		$date = $date1->dmy('/');
		$date1->add(days => 1);
	}
	$date = 'all';
	(($date_begin = '02/01/1990') && ($date_final = $date2->dmy('/'))) if ($date eq 'all');
	my $test = DateTime->new(year => (substr $date_begin, 6, 4), month => (substr $date_begin, 3, 2), day => (substr $date_begin, 0, 2));
	say $test->dmy('/');
	#say $date_begin;
	#say $date_final;
	for ($date) {
		(/[0-9]{2}\/[0-9]{2}\/[0-9]{4}/ || /today/) and do { say '15/06/2016'; last; };
		(/nothing/ || /empty/) and do { say 'nothing or empty'; last; };
		say 'default';
	}
}
