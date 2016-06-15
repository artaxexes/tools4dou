#!/usr/bin/perl
# scrpr4dou.pl

BEGIN {
	die "Antes de executar, instale o modulo DateTime\n" unless(eval{require DateTime});
	die "Antes de executar, instale o modulo Net::Ping\n" unless (eval{require Net::Ping});
	die "Antes de executar, instale o modulo LWP::Simple\n" unless (eval{require LWP::Simple});
}

use 5.22.1;
use strict;
use warnings;
use sigtrap qw(handler signal_handler normal-signals old-interface-signals);
use DateTime;
use Net::Ping;
use LWP::Simple;

print "\n============================== scrpr4dou ==============================";
print "\n-----------------------------------------------------------------------";
print "\n\n                Web scraping do Diario Oficial da Uniao\n\n";

# specify and check dou host/url
my $dou_host = "pesquisa.in.gov.br";
check_dou_reach($dou_host);
my $dou_url = "http://".$dou_host."/imprensa";

# get date and time
my ($now, $today, $year) = get_curr_datetime();

# get user input for dou download
my ($section, $page, $date) = get_user_input();

my ($section_begin, $section_final, $page_begin, $page_final, $date_begin, $date_final);

# specify section range
if ($section eq "range") {
	($section_begin, $section_final) = get_section_range();
}
# specify page range
if ($page eq "range") {
	($page_begin, $page_final) = get_page_range();
}
# specify date range
if ($date eq "range") {
	($date_begin, $date_final) = get_date_range();
}

say "\nJust do it!\n";

# dou download call
for ($date) {
	(/range/ || /all/) and do {
		(($date_begin = '02/01/1990') && ($date_final = $today)) if ($date eq 'all');
		die 'Intervalo invalido' unless ((defined $date_begin) && (defined $date_final) && (check_date_range($date_begin, $date_final)));
		my $begin = DateTime->new(year => (substr $date_begin, 6, 4), month => (substr $date_begin, 3, 2), day => (substr $date_begin, 0, 2));
		my $final = DateTime->new(year => (substr $date_final, 6, 4), month => (substr $date_final, 3, 2), day => (substr $date_final, 0, 2));
		#my ($dy_bgn, $mnth_bgn, $yr_bgn) = detached_date_str($date_begin);
		#my ($dy_fnl, $mnth_fnl, $yr_fnl) = detached_date_str($date_final);
		my $dir = create_dir($now);
		while($begin <= $final) {
			my $_date = $begin->dmy('/');
			if ($section eq "all") {
				if ($page eq "all") {
					say "Baixando todas as paginas de todas as secoes de $_date";
					for (my $i = 1; $i <= 3; $i++){
						my $page_i = check_dou_pages($i, $_date, $dou_url);
						say "Baixando $page_i paginas da secao $i de $_date";
						for (my $j = 1; $j <= $page_i; $j++) {
							dou_download($dou_url, $i, $j, $_date, $dir);
						}
					}
				}
				elsif ((defined $page_begin) && (defined $page_final)) {
					say "Baixando da pagina $page_begin a $page_final de todas as secoes de $_date";
					for (my $i = 1; $i <= 3; $i++){
						my $page_i = check_dou_pages($i, $_date, $dou_url);
						if ($page_begin < $page_i) {
							$page_final = $page_i if ($page_final > $page_i);
							say "Baixando ".(($page_final - $page_begin) + 1)." paginas da secao $i de $_date";
							for (my $j = $page_begin; $j <= $page_final; $j++) {
								dou_download($dou_url, $i, $j, $_date, $dir);
							}
						}
						else {
							say "Esta secao possui $page_i paginas";
						}
					}
				}
			}
			elsif (($section eq "dou1") || ($section eq "dou2") || ($section eq "dou3")) {
				my $i = (substr $section, -1);
				if ($page eq "all") {
					my $page_i = check_dou_pages($i, $_date, $dou_url);
					say "Baixando todas as $page_i paginas da secao $i de $_date";
					for (my $j = 1; $j <= $page_i; $j++) {
						dou_download($dou_url, $i, $j, $_date, $dir);
					}
				}
				elsif ((defined $page_begin) && (defined $page_final)) {
					say "Baixando da pagina $page_begin a $page_final da secao $i de $_date";
					my $page_i = check_dou_pages($i, $_date, $dou_url);
					if ($page_begin < $page_i) {
						$page_final = $page_i if ($page_final > $page_i);
						say "Baixando ".(($page_final - $page_begin) + 1)." paginas da secao $i de $_date";
						for (my $j = $page_begin; $j <= $page_final; $j++) {
							dou_download($dou_url, $i, $j, $_date, $dir);
						}
					}
					else {
						say "Esta secao possui $page_i paginas";
					}
				}
			}
			$begin->add(days => 1);
		}
		last;
	};
	(/[0-9]{2}\/[0-9]{2}\/[0-9]{4}/ || /today/) and do {
		my $dir = create_dir($now);
		$date = $today if ($date eq "today");
		if ($section eq "all") {
			if ($page eq "all") {
				say "Baixando todas as paginas de todas as secoes de $date";
				for (my $i = 1; $i <= 3; $i++){
					my $page_i = check_dou_pages($i, $date, $dou_url); 
					say "Baixando $page_i paginas da secao $i de $date";
					for (my $j = 1; $j <= $page_i; $j++) {
						dou_download($dou_url, $i, $j, $date, $dir);
					}
				}
			}
			elsif ((defined $page_begin) && (defined $page_final)) {
				say "Baixando da pagina $page_begin a $page_final de todas as secoes de $date";
				for (my $i = 1; $i <= 3; $i++){
					my $page_i = check_dou_pages($i, $date, $dou_url);
					if ($page_begin < $page_i) {
						$page_final = $page_i if ($page_final > $page_i);
						say "Baixando ".(($page_final - $page_begin) + 1)." paginas da secao $i de $date";
						for (my $j = $page_begin; $j <= $page_final; $j++) {
							dou_download($dou_url, $i, $j, $date, $dir);
						}
					}
					else {
						say "Esta secao possui $page_i paginas";
					}
				}
			}
		}
		elsif (($section eq "dou1") || ($section eq "dou2") || ($section eq "dou3")) {
			my $i = (substr $section, -1);
			if ($page eq "all") { 
				my $page_i = check_dou_pages($i, $date, $dou_url);
				say "Baixando todas as $page_i paginas da secao $i de $date";
				for (my $j = 1; $j <= $page_i; $j++) {
					dou_download($dou_url, $i, $j, $date, $dir);
				}
			}
			elsif ((defined $page_begin) && (defined $page_final)) {
				say "Baixando da pagina $page_begin a $page_final da secao $i de $date";
				my $page_i = check_dou_pages($i, $date, $dou_url);
				if ($page_begin < $page_i) {
					$page_final = $page_i if ($page_final > $page_i);
					say "Baixando ".(($page_final - $page_begin) + 1)." paginas da secao $i de $date";
					for (my $j = $page_begin; $j <= $page_final; $j++) {
						dou_download($dou_url, $i, $j, $date, $dir);
					}
				}
				else {
					say "Esta secao possui $page_i paginas";
				}
			}
		}
		last;
	};
}
say "Finalizado";

# #################### get subs ####################

# get_curr_datetime: get current date and time
# args: none
# returns: now, today and current year
sub get_curr_datetime {
        my @tm = localtime(time);
	my $tdy = sprintf("%02d/%02d/%04d", $tm[3], $tm[4] + 1, $tm[5] + 1900);
        my $nw = sprintf("%04d_%02d_%02d_%02dh%02dm%02ds", $tm[5] + 1900, $tm[4] + 1, $tm[3], $tm[2], $tm[1], $tm[0]);
	#my $nw = sprintf("%02d_%02d_%04d_%02d_%02d_%02d", $tm[3], $tm[4] + 1, $tm[5] + 1900, $tm[2], $tm[1], $tm[0]);
        say sprintf("Data/hora do sistema: %s %02d:%02d:%02d\n", $tdy, $tm[2], $tm[1], $tm[0]);
        return ($nw, $tdy, $tm[5] + 1900);
}

# get_user_input: menu for user
# args: none
# returns: section, page and date 
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
                        if (($3 eq "range") || ($3 eq "all") || ($3 eq "today") || (check_date(detach_date_str($3)))) {
				$chck = 1;
				return ($1, $2, $3);
			}
                }
                say "\nString invalida pois se econtra fora do padrao pedido";
                say "Se atente ao espaco entre o valor da variavel e as virgulas da string";
                say "Exemplos de string:\n  all, all, today\n  dou1, all, 25/05/2006\n";
        }
}

# get_section_range: get the section range from user
# args: none
# returns: init and final pages
sub get_section_range {
	my $chck = 0;
	while ($chck == 0) {
		say "\n\tEspecifique o intervalo de secoes desejado informando:";
		print "\tSecao inicial: ";
		chomp(my $sctn_bgn = <STDIN>);
		print "\tSecao final: ";
		chomp(my $sctn_fnl = <STDIN>);
		if (check_section_range()) {
			$chck = 1;
			say "\tIntervalo de secoes valido\n";
			return ($sctn_bgn, $sctn_fnl);
		}
		say "\tIntervalo de secoes invalido, tente novamente";
	}
}

# get_page_range: get the page range from user
# args: none
# returns: init and final pages
sub get_page_range {
	my $chck = 0;
	while ($chck == 0) {
		say "\n\tEspecifique o intervalo de paginas desejado informando:";
		print "\tPagina inicial: ";
		chomp(my $pg_bgn = <STDIN>);
		print "\tPagina final: ";
		chomp(my $pg_fnl = <STDIN>);
		if (($pg_bgn > 0) && ($pg_fnl > $pg_bgn)) {
			$chck = 1;
			say "\tIntervalo de paginas valido\n";
			return ($pg_bgn, $pg_fnl);
		}
		say "\tIntervalo de paginas invalido, tente novamente";
	}
}

# get_date_range: get the date range from user
# args: none
# returns: init and final dates
sub get_date_range {
	my $chck = 0;
	while ($chck == 0) {
		say "\n\tEspecifique o intervalo de datas desejado informando:";
		print "\tData inicial no padrao dd/mm/aaaa: ";
		chomp(my $dt_bgn = <STDIN>);
		print "\tData final no padrao dd/mm/aaaa: ";
		chomp(my $dt_fnl = <STDIN>);
		if (check_date(detach_date_str($dt_bgn)) && check_date(detach_date_str($dt_fnl))) {
			$chck = 1;
			return ($dt_bgn, $dt_fnl);
		}
		say "\tIntervalo de datas invalido, tente novamente";
	}
}

# ################### check subs ###################

# check_dou_reach: check reachability of DOU website
# args: host for reachability test
# returns: none
sub check_dou_reach {
	my $url = shift(@_);
	say "Verificando conexao com $url";
	my $png = Net::Ping->new();
	die "Nao foi possivel se conectar\n" unless $png->ping($url);
        say "Conexao estabelecida\n";
        $png->close();
}

# check_dou_filetype: check DOU filetype
# args: url
# returns: 1 or 0
sub check_dou_filetype {
	my $url = shift(@_);
	my @fl = head($url);
	return 0 unless ($fl[0] eq "application/pdf");
	return 1;
}

# check_dou_pages: check the number of pages on DOU in specific section/date
# args: section, date
# returns: number os pages
sub check_dou_pages {
	my ($sctn, $dt, $url) = @_;
	my $dwnld = get($url."/jsp/visualiza/index.jsp?jornal=$sctn&pagina=1&data=$dt&captchafield=firistAccess");
	if ($dwnld =~ /(&totalArquivos=)([0-9]+)"/) {
		return $2;
	}
	return 0;
}

# check_date: date validation
# args: day, month, year
# returns: 1 or 0
sub check_date {
	my ($dy, $mnth, $yr) = @_;
        if (($yr >= 1990) && ($yr <= $year)) {
                if (($mnth == 1) || ($mnth == 3) || ($mnth == 5) || ($mnth == 7) || ($mnth == 8) || ($mnth == 10) || ($mnth == 12)) {
                        return 1 if (($dy >= 1) && ($dy <= 31));
                }
                elsif (($mnth == 4) || ($mnth == 6) || ($mnth == 9) || ($mnth == 11)) {
                        return 1 if (($dy >= 1) && ($dy <= 30));
                }
                else {
                        if ((($yr % 4 == 0) && ($yr % 100 != 0)) || ($yr % 400 == 0)) {
                                return 1 if (($dy >= 1) && ($dy <= 29));
                        }
                        else {
                                return 1 if (($dy >= 1) && ($dy <= 28));
                        }
                }
        }
        return 0;
}

# check_date_range: check date range
# args: begin and final dates
# returns: 1 or 0
sub check_date_range {
	my ($dt_bgn, $dt_fnl) = @_;
	my ($dy_bgn, $mnth_bgn, $yr_bgn) = detach_date_str($dt_bgn);
	my ($dy_fnl, $mnth_fnl, $yr_fnl) = detach_date_str($dt_fnl);
	if ($yr_fnl >= $yr_bgn) {
                if ($mnth_fnl >= $mnth_bgn) {
                        if ($dy_fnl > $dy_bgn) {
                                return 1;
                        }
                }
        }
	return 0;
}

# ################### other subs ###################

# detach_date_str: detach date string
# args: a valid date in formatted string (dd/mm/yyyy)
# returns: day, month, year
sub detach_date_str {
	my $dt_str = shift(@_);
        return ((substr $dt_str, 0, 2), (substr $dt_str, 3, 2), (substr $dt_str, 6, 4));
}

# create_dir: create directory
# args: current date and time
# returns: directory name 
sub create_dir {
	my $dr = sprintf("scrpr4dou_%s", shift(@_));
	say "Criando diretorio $dr";
	die "Nao foi possivel criar diretorio de output, execute o script com privilegios\n" unless mkdir($dr, 0755);
	return $dr;
}

# dou_download: pdf download
# args: section, page, date and directory
# returns: none
sub dou_download {
	my ($url, $sctn, $pg, $dt, $drctry) = @_;
	my $dwnld = sprintf("%s/servlet/INPDFViewer?jornal=%d&pagina=%d&data=%s&captchafield=firistAccess", $url, $sctn, $pg, $dt);
	my $fl = sprintf("%04d_%02d_%02d_dou%04d_page%03d.pdf", (substr $dt, 6, 4), (substr $dt, 3, 2), (substr $dt, 0, 2), $sctn, $pg);
	my $pth = $drctry."/".$fl;
	check_dou_filetype($dwnld) ? getstore($dwnld, $pth) && say "Salvando arquivo PDF $pth" : say "Arquivo $pth nao sera salvo pois nao se trata de um PDF";
}

# signal_handler: log keeper
# args: signal
# returns: none
sub signal_handler {
	if (open my $out, '>>', 'scrpr4dou.log') {
		my $msg = "$now: $!\n";
		print $out $msg;
		die "\n$msg";
	}
}
