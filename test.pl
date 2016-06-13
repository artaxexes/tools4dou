#!/usr/bin/perl
# test.pl

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

print "\n============================== scrpr4dou ==============================";
print "\n-----------------------------------------------------------------------";
print "\n\n                Web scraping do Diario Oficial da Uniao\n\n";

my $host = "pesquisa.in.gov.br";
check_reach($host);

my $url_base = "http://".$host."/imprensa";

my ($now, $today, $year) = system_datetime();

my ($journal, $page, $date) = user_options();

die "Bye\n";

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

# ##############################################
# #################### subs ####################
# ##############################################

sub check_reach {
        say "Verificando conexao com $host";
        my $test = Net::Ping->new();
        die "Nao foi possivel se conectar\n" unless $test->ping(shift(@_));
	say "Conexao estabelecida\n";
        $test->close();
}

sub system_datetime {
	my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time);
	$year += 1900;
	my $today = sprintf("%02d/%02d/%04d", $mday, $mon + 1, $year);
	my $now = sprintf("%s %02d:%02d:%02d", $today, $hour, $min, $sec);
	say "Data/hora do sistema: $now\n";
	return ($now, $today, $year);
}

sub user_options {
	my $pattern = "(range|all|dou[1-3]), (range|all), (range|all|today|[0-9]{2}\/[0-9]{2}\/[0-9]{4})";
	my $check = 0;
	while ($check == 0) {
        	say "Este script utiliza tres variaveis: secao, pagina, data";
        	say "Opcoes aceitas para cada variavel";
        	say "* secao: range ou all ou dou1 ou dou2 ou dou3";
        	say "  - range indica um intervalo de secoes";
        	say "  - all indica todas as secoes";
        	say "  - dou1 ou dou2 ou dou3 indica a secao correspondente";
        	say "* pagina: range ou all";
        	say "  - range indica um intervalo de paginas";
        	say "  - all indica todas as paginas";
        	say "* data: range ou all ou today ou dd/mm/aaaa";
        	say "  - range indica um intervalo de datas";
        	say "  - all indica todas as datas";
        	say "  - today indica a data atual, hoje";
        	say "  - dd/mm/aaaa indica uma data valida no formato especificado";
        	print "Digite sua string conforme sua necessidade: ";
        	chomp(my $input = <STDIN>);
        	if ($input =~ m/^$pattern$/) {
			if ($3 eq "range" || $3 eq "all" || $3 eq "today" || date_val(date_split($3))) {
				$check = 1;
				return ($1, $2, $3);
			}
		}
                say "\nString invalida pois se econtra fora do padrao informado";
                say "Se atente ao espaco entre o valor da variavel e as virgulas da string";
                say "Exemplos de string:\n  all, all, today\n  dou1, all, 25/05/2006\n";
	}
}

sub date_split {
	my $str_date = shift(@_);
        return ((substr $str_date, 0, 2), (substr $str_date, 3, 2), (substr $str_date, 6, 4));
}

sub date_val {
        my ($d, $m, $y) = @_;
        say "$d/$m/$y";
        if ($y >= 1990 && $y <= $year) {
                if ($m == 1 || $m == 3 || $m == 5 || $m == 7 || $m == 8 || $m == 10 || $m == 12) {
                        return 1 if ($d >= 1 && $d <= 31);
                }
                elsif ($m == 4 || $m == 6 || $m == 9 || $m == 11) {
                        return 1 if ($d >= 1 && $d <= 30);
                }
                else {
                        if (($y % 4 == 0 && $y % 100  != 0) || $y % 400 == 0) {
                                return 1 if ($d >= 1 && $d <= 29);
                        }
                        else {
                                return 1 if ($d >= 1 && $d <= 28);
                        }
                }
        }
        return 0;
}

sub signal_handler {
        die "\n$!\n";
}
