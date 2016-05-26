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
print "-----------------------\n";

my $dt = DateTime->now;
$dt = $dt->dmy("/");

print "Jornal\n";
print "* -1 para todos\n";
print "* 0 para especificar um intervalo\n";
print "* 1 para DOU1\n";
print "* 2 para DOU2\n";
print "* 3 para DOU3\n";
print "Digite: ";
my $jornal = <STDIN>;
chomp($jornal);

print "\nPagina\n";
print "* -1 para todas\n";
print "* 0 para especificar um intervalo\n";
print "* Numero correspondente ao da pagina desejada\n";
print "Digite: ";
my $page = <STDIN>;
chomp($page);

print "\nData\n";
print "* 1 para hoje\n";
print "* 2 para especificar data\n";
print "* 3 para especificar um intervalo\n";
print "Digite: ";
my $opt_date = <STDIN>;
chomp($opt_date);

# Jornal
my $val_jornal = 1;

# Page
my $val_page = 1;

sub CheckPagesNumber {
	my @args = @_;
	my $url = get("http://pesquisa.in.gov.br/imprensa/jsp/visualiza/index.jsp?jornal=$args[0]&pagina=1&data=$args[1]&captchafield=firistAccess");
	if ($url =~ /(&totalArquivos=)([0-9]+)"/) {
		return $2;
	}
	else {
		return -1;
	}
}

# Date
my $val_date = 0;
while ($val_date == 0) {

}
