#!/usr/bin/perl
# test.pl

use 5.22.1;
use strict;
use warnings;
use LWP::Simple;
use Date::Calc::Iterator;

BEGIN {
        die "Antes de executar, instale o modulo LWP::Simple com o comando:\ncpan LWP::Simple\n" unless (eval{require LWP::Simple});
	die "Antes de executar, instale o modulo Date::Calc::Iterator com o comando:\ncpan Date::Calc::Iterator\n" unless (eval{require Date::Calc::Iterator});
}

print "\n============================== scrpr4dou ==============================\n";

=pod

say "=== Test1 ===";
my ($type, $size, $age, $exp, $server) = head $url2;
my @type = head($url2);
say $type[0];
($type[0] eq "application/pdf") ? say "pdf" : ($type[0] =~ /^text\/html;.*/) ? say "html" : say "not pdf";

say "=== Test2 ===";
my $file = get($url1);
if ($file =~ /(&totalArquivos=)([0-9]+)"/) {
	say "$2 pages";
}

sub check_dou_filetype {
        my $uri = shift(@_);
        my @fl = head($uri);
        return 0 unless ($fl[0] eq "application/pdf");
        return 1;
}

# my $url = "http://pesquisa.in.gov.br/imprensa/jsp/visualiza/index.jsp?jornal=1&pagina=1&data=10/06/2016&captchafield=firistAccess";
my $url = "http://pesquisa.in.gov.br/imprensa/servlet/INPDFViewer?jornal=10&pagina=1&data=14/06/2016&captchafield=firistAccess";
my $pth = "dou1pg1_2016_06_14.pdf";
check_dou_filetype($url) ? getstore($url, $pth) && say "Salvando arquivo PDF $pth" : say "Arquivo $pth nao sera salvo pois nao se trata de um PDF";

=cut

my $i1 = Date::Calc::Iterator->new(from => [2016,06,01], to => [2016,06,14]);
my @dates1;
push @dates1,$_ while $_ = $i1->next;
print join("\n", @dates1);
