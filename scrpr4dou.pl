#!/usr/bin/perl
# scrpr4dou.pl

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

my ($now, $today, $year) = get_datetime();

my ($journal, $page, $date) = get_user_input();

my ($page_begin, $page_final, $date_begin, $date_final);

# Page range
if ($page eq "range") {
	($page_begin, $page_final) = get_page_range();
}
# Date range
if ($date eq "range") {
	($date_begin, $date_final) = get_date_range();
}

die "Bye\n";

=pod

sub get_date_range {
	my $chck = 0;
	while ($chck == 0) {
		say "\nEspecifique o intervalo de data desejado informando:";
		print "\tData inicial no padrao dd/mm/aaaa: ";
		chomp(my $dt_bgn = <STDIN>);
		print "\tData final no padrao dd/mm/aaaa: ";
		chomp(my $dt_fnl = <STDIN>);
		if (date_val(date_split()) && date_val(date_split())) {
			$chck = 1;
			return ($dt_bgn, $dt_fnl);
		}
		else {
			
		}
	}
}
elsif ($date eq "all") {
}

say "\nJust do it!\n";

# Download DOU
for ($date) {
	when ("range") {
		die "Funcao ainda nao implementada\n";
	}
	when ("all") {
		die "Funcao ainda nao implementada\n";
	}
	when ("today") {
		my $_dir = dir_create();
		if ($journal eq "all" && $page eq "all") {
			say "Baixando todas as paginas de todos os jornais de hoje";
			for (my $_journal = 1; $_journal <= 3; $_journal++){
				for (my $_page = 1; $_page <= dou_pages($_journal, $today); $_page++) {
					dou_download($_journal, $_page, $today, $_dir);
				}
			}
		}
		elsif ($journal eq "dou1" && $page eq "all") {
			say "Baixando todas as paginas do jornal $journal de hoje";
			for (my $_page = 1; $_page <= dou_pages(1, $today); $_page++) {
				dou_download(1, $_page, $today, $_dir);
			}
		}
		elsif ($journal eq "dou2" && $page eq "all") {
			say "Baixando todas as paginas do jornal $opt_journal de hoje";
			for (my $_page = 1; $_page <= dou_pages(2, $today); $_page++) {
				dou_download(2, $_page, $today, $_dir);
			}
		}
		elsif ($journal eq "dou3" && $page eq "all") {
			say "Baixando todas as paginas do jornal $journal de hoje";
			for (my $_page = 1; $_page <= dou_pages(3, $today); $_page++) {
				dou_download(3, $_page, $today, $_dir);
			}
		}
		say "Finalizado";
	}
	default {
		my $_dir = dir_create();
		if ($journal eq "all" && $page eq "all") {
			say "Baixando todas as paginas de todos os jornais de $date";
			for (my $_journal = 1; $_journal <= 3; $_journal++){
				for (my $_page = 1; $_page <= dou_pages($_journal, $date); $_page++) {
					dou_download($_journal, $_page, $date, $_dir);
				}
			}
		}
		elsif ($journal eq "dou1" && $page eq "all") {
			say "Baixando todas as paginas do jornal $journal de $date";
			for (my $_page = 1; $_page <= dou_pages(1, $date); $_page++) {
				dou_download(1, $_page, $date, $_dir);
			}
		}
		elsif ($journal eq "dou2" && $page eq "all") {
			say "Baixando todas as paginas do jornal $journal de $date";
			for (my $_page = 1; $_page <= dou_pages(2, $date); $_page++) {
				dou_download(2, $_page, $date, $_dir);
			}
		}
		elsif ($journal eq "dou3" && $page eq "all") {
			say "Baixando todas as paginas do jornal $journal de $date";
			for (my $_page = 1; $_page <= dou_pages(3, $date); $_page++) {
				dou_download(3, $_page, $date, $_dir);
			}
		}
		say "Finalizado";
	}
}

=cut

# ##############################################
# #################### subs ####################
# ##############################################

# check_reach: check reachability
# args: host for reachability test
# returns: none
sub check_reach {
	say "Verificando conexao com $host";
	my $png = Net::Ping->new();
	die "Nao foi possivel se conectar\n" unless $png->ping(shift(@_));
        say "Conexao estabelecida\n";
        $png->close();
}

# get_datetime: get local date and time
# args: none
# returns: current date and time
sub get_datetime {
        my @tm = localtime(time);
	my $tdy = sprintf("%02d/%02d/%04d", $tm[3], $tm[4] + 1, $tm[5] + 1900);
        my $nw = sprintf("%02d_%02d_%04d_%02d_%02d_%02d", $tm[3], $tm[4] + 1, $tm[5] + 1900, $tm[2], $tm[1], $tm[0]);
        say sprintf("Data/hora do sistema: %s %02d:%02d:%02d\n", $tdy, $tm[2], $tm[1], $tm[0]);
        return ($nw, $tdy, $tm[5] + 1900);
}

# user_options: menu
# args: none
# returns: section, page and date for download 
sub get_user_input {
        my $pttrn = "(range|all|dou[1-3]), (range|all), (range|all|today|[0-9]{2}\/[0-9]{2}\/[0-9]{4})";
        my $chck = 0;
        while ($chck == 0) {
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
                chomp(my $str = <STDIN>);
                if ($str =~ m/^$pttrn$/) {
                        if ($3 eq "range" || $3 eq "all" || $3 eq "today" || date_val(date_split($3))) {
				$chck = 1;
				return ($1, $2, $3);
			}
                }
                say "\nString invalida pois se econtra fora do padrao pedido";
                say "Se atente ao espaco entre o valor da variavel e as virgulas da string";
                say "Exemplos de string:\n  all, all, today\n  dou1, all, 25/05/2006\n";
        }
}

# get_page_range: get from user the page range
# args: none
# returns: init and final pages
sub get_page_range {
	my $chck = 0;
	while ($chck == 0) {
		say "\n\tEspecifique o intervalo de pagina desejado informando:";
		print "\tPagina inicial: ";
		chomp(my $pg_bgn = <STDIN>);
		print "\tPagina final: ";
		chomp(my $pg_fnl = <STDIN>);
		if ($pg_bgn > 0 && $pg_fnl > $pg_bgn) {
			$chck = 1;
			say "\tIntervalo de paginas valido\n";
			return ($pg_bgn, $pg_fnl);
		}
		else {
			say "\tIntervalo de paginas invalido, tente novamente";
		}
	}
}

# get_date_range: get from user the date range
# args: none
# returns: init and final dates

# date_split: split for date entered by user
# args: formatted (dd/mm/yyyy) string representing a valid date
# returns: day, month, year
sub date_split {
	my $str_dt = shift(@_);
        return ((substr $str_dt, 0, 2), (substr $str_dt, 3, 2), (substr $str_dt, 6, 4));
}

# date_val: validation of date
# args: day, month, year
# returns: 1 or 0
sub date_val {
	my ($dy, $mnth, $yr) = @_;
        if ($yr >= 1990 && $yr <= $year) {
                if ($mnth == 1 || $mnth == 3 || $mnth == 5 || $mnth == 7 || $mnth == 8 || $mnth == 10 || $mnth == 12) {
                        return 1 if ($dy >= 1 && $dy <= 31);
                }
                elsif ($mnth == 4 || $mnth == 6 || $mnth == 9 || $mnth == 11) {
                        return 1 if ($dy >= 1 && $dy <= 30);
                }
                else {
                        if (($yr % 4 == 0 && $yr % 100  != 0) || $yr % 400 == 0) {
                                return 1 if ($dy >= 1 && $dy <= 29);
                        }
                        else {
                                return 1 if ($dy >= 1 && $dy <= 28);
                        }
                }
        }
        return 0;
}

# date_range: validation of date range
# args:
# returns: 
sub date_range {
	say "\n\tEspecifique o intervalo de data desejado informando:";
	print "\tData inicial no modelo dd/mm/aaaa: ";
	chomp(my $date_init = <STDIN>);
	print "\tData final tambem no modelo dd/mm/aaaa: ";
	chomp(my $date_final = <STDIN>);
	return ($date_init, $date_final) unless !(date_val(date_split($date_init)) && date_val(date_split($date_final)));
	die "Intervalo de data invalido\n";
}


#getsub get_date_range {
	my $chck = 0;
	while ($chck == 0) {
		say "\nEspecifique o intervalo de data desejado informando:";
		print "\tData inicial no padrao dd/mm/aaaa: ";
		chomp(my $dt_bgn = <STDIN>);
		print "\tData final no padrao dd/mm/aaaa: ";
		chomp(my $dt_fnl = <STDIN>);
		if (date_val(date_split()) && date_val(date_split())) {
			$chck = 1;
			return ($dt_bgn, $dt_fnl);
		}
		else {
			
		}
	}
}

=pod
# dir_create: directory creation
# args: now 
# returns: directory name 
sub dir_create {
	my $dr = sprintf("scrpr4dou_%s", shift(@_));
	say "Criando diretorio $dr";
	die "Nao foi possivel criar diretorio de output, execute o script com privilegios\n" unless mkdir($dr, 0755);
	return $dr;
}

# Check pdf or html
sub dou_check {
	my ($jornal, $page, $date) = @_;
	my $url = $url_base."/servel
}

# Check the number of pages on DOU in specific date
sub dou_pages {
	my ($jrnl, $dt) = @_;
	my $dwnld = get($url."/jsp/visualiza/index.jsp?jornal=$sctn&pagina=1&data=$dt&captchafield=firistAccess");
	if ($dwnld =~ /(&totalArquivos=)([0-9]+)"/) {
		return $2;
	}
	return 0;
}

# Download of DOU
sub dou_download {
	my ($sctn, $pg, $dt, $drctry) = @_;
	my $dwnld = sprintf("%s/servlet/INPDFViewer?jornal=%d&pagina=%d&data=%s&captchafield=firistAccess", $sctn, $pg, $dt);
	my $fl = sprintf("%04d_%02d_%02d_dou%04d_page%03d.pdf", (substr $dt, 6, 4), (substr $dt, 3, 2), (substr $dt, 0, 2), $sctn, $pg);
	my $pth = $drctry."/".$fl;
	getstore($dwnld, $pth);
	say "Salvando arquivo PDF $pth";
}

=cut

# Log keeper
sub signal_handler {
	if (open my $out, '>>', 'scrpr4dou.log') {
		my $msg = "$now: $!\n";
		print $out $msg;
		die "\n$msg";
	}
}
