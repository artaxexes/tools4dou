#!/usr/bin/perl
# test.plx

use 5.22.1;
use strict;
use warnings;
use LWP::Simple;
use Net::Ping;

# Check reachability
my $host = "pesquisa.in.gov.br";
my $url_base = "http://".$host."/imprensa/";
say $url_base;
say "Verificando conexao com $host";
my $p = Net::Ping->new();
die "Nao foi possivel se conectar\n" unless $p->ping($host);
say "Conexao estabelecida\n";
$p->close();

my $url1 = "http://pesquisa.in.gov.br/imprensa/jsp/visualiza/index.jsp?jornal=1&pagina=1&data=10/06/2016&captchafield=firistAccess";
my $url2 = "http://pesquisa.in.gov.br/imprensa/servlet/INPDFViewer?jornal=1&pagina=1&data=10/07/2016&captchafield=firistAccess";

say "=== Test1 ===";
my ($type, $size, $age, $exp, $server) = head $url2;
say $type;
($type eq "application/pdf") ? say "pdf" : ($type =~ /^text\/html;.*/) ? say "html" : say "not pdf";

say "=== Test3 ===";
my $file = get($url1);
if ($file =~ /(&totalArquivos=)([0-9]+)"/) {
	say "$2 pages";
}
