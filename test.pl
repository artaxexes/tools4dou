#!/usr/bin/perl
# test.pl

use 5.22.1;
use strict;
use warnings;
use LWP::Simple;
use Date::Calc qw(Date_to_Text);
use Date::Calc::Iterator;

BEGIN {
        die "Modulo LWP::Simple necessario, instale-o\n" unless (eval{require LWP::Simple});
	die "Modulo Date::Calc::Iterator necessario, instale-o\n" unless (eval{require Date::Calc::Iterator});
}

=pod

# my $url = "http://pesquisa.in.gov.br/imprensa/jsp/visualiza/index.jsp?jornal=1&pagina=1&data=10/06/2016&captchafield=firistAccess";
# my $url = "http://pesquisa.in.gov.br/imprensa/servlet/INPDFViewer?jornal=10&pagina=1&data=14/06/2016&captchafield=firistAccess";

=cut

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
