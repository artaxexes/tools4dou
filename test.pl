#!/usr/bin/perl

use 5.22.1;
use strict;
use warnings;
use sigtrap qw(handler signal_handler normal-signals old-interface-signals);
use Net::Ping;
use LWP::Simple;

BEGIN {
	die "Antes de executar, instale o modulo Net::Ping com o comando:\ncpan Net::Ping\n" unless (eval{require Net::Ping});
	die "Antes de executar, instale o modulo LWP::Simple com o comando:\ncpan LWP::Simple\n" unless (eval{require LWP::Simple});
}

say "\n============================== scrpr4dou ==============================";
say "-----------------------------------------------------------------------\n";

# Check a Imprensa Nacional host for reachability
my $host = "portal.imprensanacional.gov.br";
say "Verificando conexao com http://$host...";
my $p = Net::Ping->new();
die "Nao foi possivel se conectar\n" unless $p->ping($host);
say "Conexao estabelecida\n";
$p->close();

# System datetime
my ($curr_sec, $curr_min, $curr_hour, $curr_mday, $curr_mon, $curr_year, $curr_wday, $curr_yday, $isdst) = localtime(time);
$curr_mon += 1;
$curr_year += 1900;
my $curr_date = sprintf("%02d/%02d/%04d", $curr_mday, $curr_mon, $curr_year);
my $curr_now = sprintf("%s %02d:%02d:%02d", $curr_date, $curr_hour, $curr_min, $curr_sec);
say "Data/hora do sistema: $curr_now"; 

say "\nJust do it!\n";

my $html_url = "http://pesquisa.in.gov.br/imprensa/jsp/visualiza/index.jsp?jornal=1&pagina=1&data=10/06/2016&captchafield=firistAccess";
my $pdf_url = "http://pesquisa.in.gov.br/imprensa/servlet/INPDFViewer?jornal=1&pagina=1&data=10/06/2017&captchafield=firistAccess";

my $html_file = get($html_url);
if ($html_file =~ /(&totalArquivos=)([0-9]+)"/) {
	say "Pages: $2";
}

my ($doc_type, $doc_length, $doc_mod, $doc_exp, $doc_server) = head($pdf_url);
print "\nContent: $doc_type\nLength: $doc_length\nModified: $doc_mod\nExpires: $doc_exp\nServer: $doc_server\n";
