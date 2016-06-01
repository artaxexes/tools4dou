#!/usr/bin/perl

use 5.22.1;
use strict;
use warnings;
use Net::Ping;
use LWP::Simple;

BEGIN {
	die "Antes de executar, instale o modulo Net::Ping com o comando:\ncpan Net::Ping\n" unless (eval{require Net::Ping});
	die "Antes de executar, instale o modulo LWP::Simple com o comando:\ncpan LWP::Simple\n" unless (eval{require LWP::Simple});
}

say "========================= Scraper DOU =========================";
say "---------------------------------------------------------------";

# Check a Imprensa Nacional host for reachability
my $host = "portal.imprensanacional.gov.br";
my $p = Net::Ping->new();
say "Verificando conexao com http://$host";
die "http://$host esta offline\n" unless $p->ping($host);
say "http://$host esta online";
$p->close();

# System datetime
my ($curr_sec, $curr_min, $curr_hour, $curr_mday, $curr_mon, $curr_year, $curr_wday, $curr_yday, $isdst) = localtime(time);
my $curr_date = sprintf("%02d/%02d/%04d", $curr_mday, $curr_mon + 1, $curr_year + 1900);
say sprintf("Data/hora do sistema: %s %02dh%02dm%02ds", $curr_date, $curr_hour, $curr_min, $curr_sec);

# Input options
my $input_pattern = "(range|all|dou[1-3]), (range|all), (range|all|today|[0123][0-9]\/[01][0-9]\/[0-9]{4})";
my $opt_journal = "";
my $opt_page = "";
my $opt_date = "";
my $val_string = 0;
while ($val_string == 0) {
	say "\nDownload do Diario Oficial da Uniao baseado em tres variaveis: jornal, pagina, data";
	say "Opcoes aceitas para cada variavel:";
	say "* jornal = range ou all ou dou1 ou dou2 ou dou3";
	say "\t- range indica um intervalo de jornais";
	say "\t- all indica todos os jornais";
	say "\t- dou1 ou dou2 ou dou3 indica o jornal correspondente";
	say "* pagina = range ou all";
	say "\t- range indica um intervalo de paginas";
	say "\t- all indica todas as paginas";
	say "* data = range ou all ou today ou dd/mm/aaaa";
	say "\t- range indica um intervalo de datas";
	say "\t- all indica todas as datas";
	say "\t- today indica a data atual";
	say "\t- dd/mm/aaaa indica uma data valida no formato especificado";
	print "Digite sua string para download do DOU: ";
	chomp(my $input = <STDIN>);
	if ($input =~ m/^$input_pattern$/) {
		$opt_journal =  $1;
		$opt_page = $2;
		$opt_date = $3;
		if ($opt_date ne "range" && $opt_date ne "all" && $opt_date ne "today") {
			$val_string = 1 unless !(date_val(date_split($opt_date)));
		}
	}
	else {
		say "\nString fora do padrao, leia atentamente as instrucoes e tente novamente!\n";
	}
}

die "\nTesting\n";

# Page options
my $page_range = 0;
my $page_init = 0;
my $page_final = 0;
if ($opt_page eq "range") {
	while ($page_range == 0) {
		say "\n\tEspecifique o intervalo de pagina desejado informando:";
		print "\tPagina inicial: ";
		chomp($page_init = <STDIN>);
		print "\tPagina final: ";
		chomp($page_final = <STDIN>);
		if ($page_init > $page_final && $page_init > 0 && $page_final > 0) {
			$page_range = 1;
			say "\tIntervalo de paginas valido\n";
		}
		else {
			say "\tIntervalo de paginas invalido, tente novamente";
		}
	}
}

# Date options
my $date_range = 0;
my $date_init = "";
my $date_final = "";
my $date_all = 0;
if ($opt_date eq "range") {
}
elsif ($opt_date eq "all") {
}

say "Just do it";

# Download DOU
for ($opt_date) {
	when ("range") {
		die "Funcao ainda nao implementada\n";
	}
	when ("all") {
		die "Funcao ainda nao implementada\n";
	}
	when ("today") {
		my $_dir = dir_create();
		if ($opt_journal eq "all" && $opt_page eq "all") {
			say "Baixando todas as paginas de todos os jornais de hoje";
			for (my $_journal = 1; $_journal <= 3; $_journal++){
				for (my $_page = 1; $_page <= dou_pages($_journal, $curr_date); $_page++) {
					dou_download($_journal, $_page, $curr_date, $_dir);
				}
			}
		}
		elsif ($opt_journal eq "dou1" && $opt_page eq "all") {
			say "Baixando todas as paginas do jornal $opt_journal de hoje";
			for (my $_page = 1; $_page <= dou_pages(1, $curr_date); $_page++) {
				dou_download(1, $_page, $curr_date, $_dir);
			}
		}
		elsif ($opt_journal eq "dou2" && $opt_page eq "all") {
			say "Baixando todas as paginas do jornal $opt_journal de hoje";
			for (my $_page = 1; $_page <= dou_pages(2, $curr_date); $_page++) {
				dou_download(2, $_page, $curr_date, $_dir);
			}
		}
		elsif ($opt_journal eq "dou3" && $opt_page eq "all") {
			say "Baixando todas as paginas do jornal $opt_journal de hoje";
			for (my $_page = 1; $_page <= dou_pages(3, $curr_date); $_page++) {
				dou_download(3, $_page, $curr_date, $_dir);
			}
		}
		say "Finalizado";
	}
	default {
		my $_dir = dir_create();
		if ($opt_journal eq "all" && $opt_page eq "all") {
			say "Baixando todas as paginas de todos os jornais de $3";
			for (my $_journal = 1; $_journal <= 3; $_journal++){
				for (my $_page = 1; $_page <= dou_pages($_journal, $3); $_page++) {
					dou_download($_journal, $_page, $3, $_dir);
				}
			}
		}
		elsif ($opt_journal eq "dou1" && $opt_page eq "all") {
			say "Baixando todas as paginas do jornal $opt_journal de $3";
			for (my $_page = 1; $_page <= dou_pages(1, $3); $_page++) {
				dou_download(1, $_page, $3, $_dir);
			}
		}
		elsif ($opt_journal eq "dou2" && $opt_page eq "all") {
			say "Baixando todas as paginas do jornal $opt_journal de $3";
			for (my $_page = 1; $_page <= dou_pages(2, $3); $_page++) {
				dou_download(2, $_page, $3, $_dir);
			}
		}
		elsif ($opt_journal eq "dou3" && $opt_page eq "all") {
			say "Baixando todas as paginas do jornal $opt_journal de $3";
			for (my $_page = 1; $_page <= dou_pages(3, $3); $_page++) {
				dou_download(3, $_page, $3, $_dir);
			}
		}
		say "Finalizado";
	}
}

# Split for date entered by user
sub date_split {
        return ((substr $3, 0, 2), (substr $3, 3, 2), (substr $3, 6, 4));
}

# Validation of date entered by user
sub date_val {
	my ($_day, $_month, $_year) = @_;
        print "\n$_day/$_month/$_year\n";
        if ($_year >= 1990 && $_year <= $curr_year) {
                if ($_month ~~ [1, 3, 5, 7, 8, 10, 12]) {
                        return 1 unless !($_day >= 1 && $_day <= 31);
                }
                elsif ($_month ~~ [4, 6, 9, 11]) {
                        return 1 unless !($_day >= 1 && $_day <= 30);
                }
                else {
                        if (($_year % 4 == 0 && $_year % 100  != 0) || $_year % 400 == 0) {
                                return 1 unless !($_day >= 1 && $_day <= 29);
                        }
                        else {
                                return 1 unless !($_day >= 1 && $_day <= 28);
                        }
                }
        }
        return 0;
}

# Validation of the date range entered 
sub date_range {
	say "\n\tEspecifique o intervalo de data desejado informando:";
	print "\tData inicial no modelo dd/mm/aaaa: ";
	chomp(my $date_init = <STDIN>);
	print "\tData final tambem no modelo dd/mm/aaaa: ";
	chomp(my $date_final = <STDIN>);
	return ($date_init, $date_final) unless !(date_val(date_split($date_init)) && date_val(date_split($date_final)));
	die "Intervalo de data invalido\n";
}

# Directory creation
sub dir_create {
	my $_dir = sprintf("scraper_dou_%04d_%02d_%02d_%02d_%02d_%02d", $curr_year + 1900, $curr_mon + 1, $curr_mday, $curr_hour, $curr_min, $curr_sec);
	say "Criando diretorio $_dir";
	mkdir($_dir, 0755);
	return $_dir;
}

# Check the number of pages on DOU in specific date
sub dou_pages {
	my ($_journal, $_date) = @_;
	my $url = get("http://pesquisa.in.gov.br/imprensa/jsp/visualiza/index.jsp?jornal=$_journal&pagina=1&data=$_date&captchafield=firistAccess");
	if ($url =~ /(&totalArquivos=)([0-9]+)"/) {
		return $2;
	}
	return 0;
}

# Download of DOU
sub dou_download {
	my ($_journal, $_page, $_date, $_dir) = @_;
	my $_url = "http://pesquisa.in.gov.br/imprensa/servlet/INPDFViewer?jornal=$_journal&pagina=$_page&data=$_date&captchafield=firistAcces";
	my $_file = sprintf("%04d_%02d_%02d_dou%04d_page%03d.pdf", (substr $_date, 6, 4), (substr $_date, 3, 2), (substr $_date, 0, 2), $_journal, $_page);
	my $_path = $_dir . "/" . $_file;
	getstore($_url, $_path);
	say "Salvando arquivo PDF $_path";
}
