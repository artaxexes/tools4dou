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
my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time);
my $dt = sprintf("%02d/%02d/%04d", $mday, $mon + 1, $year + 1900);
say "Data/hora do sistema: $dt, $hour:$min:$sec";

# Input options
my $inputPattern = "(range|all|dou[1-3]);(range|all|[0-9]+);(range|all|today|[0123][0-9]\/[01][0-9]\/[0-9]{4})";
my $optJournal = "";
my $optPage = "";
my $optDate = "";
my $valString = 0;
while ($valString == 0) {
	say "\nPadrao para download do DOU com tres variaveis: jornal;pagina;data";
	say "Opcoes aceitas para cada variavel:";
	say "* jornal = range ou all ou dou1 ou dou2 ou dou3; onde range indica um intervalo de jornais, all indica todos os jornais e dou1/dou2/dou3 indica o jornal correspondente";
	say "* pagina = range ou all ou numero da pagina; onde range indica um intervalo de paginas, all indica todas as paginas e numero da pagina indica a pagina correspondente";
	say "* data = range ou all ou today ou dd/mm/aaaa; onde range indica um intervalo de datas, all indica todas as datas e dd/mm/aaaa indica uma data valida no formato especificado";
	print "Digite sua string para download: ";
	chomp(my $input = <STDIN>);
	if ($input =~ m/^$inputPattern$/) {
		$optJournal =  $1;
        	$optPage = $2;
        	$optDate = $3;
		if ($optDate ne "range" && $optDate ne "all" && $optDate ne "today") {
			$valString = 1 unless !date_val(date_split($optDate));
		}
		else {
			$valString = 1;
		}
	}
	else {
		say "\nString fora do padrao, leia atentamente as instrucoes e tente novamente!";
	}
}

die "Finish\n";

# Date validation
my $date = "";
my $date_is_range = 0;
my $val_date = 0;
while ($val_date == 0) {
	if ($opt_date == 1) {
		$date = sprintf("%02d/%02d/%s", localtime[3], localtime[4], localtime[5] + 1900);
		print "Hoje: $date\n";
		$val_date = 1;
	}
	elsif ($opt_date == 2) {
		print "\tDia desejado: ";
		my $day = <STDIN>;
		chomp($day);
		print "\tMes desejado: ";
		my $month = <STDIN>;
		chomp($month);
		print "\tAno desejado: ";
		my $year = <STDIN>;
		chomp($year);
		$date = sprintf("%02d/%02d/%04d", $day, $month, $year);
		print "\tData desejada: $date\n";
		$val_date = 1;
	}
	elsif ($opt_date == 3) {
		$date_is_range = 1;
		# Initial date
		print "Dia inicial: ";
		my $init_day = <STDIN>;
		chomp($init_day);
		print "Mes inicial: ";
		my $init_month = <STDIN>;
		chomp($init_month);
		print "Ano inicial: ";
		my $init_year = <STDIN>;
		chomp($init_year);
		# Final date
		print "Dia final: ";
		my $final_day = <STDIN>;
		chomp($final_day);
		print "Mes final: ";
		my $final_month = <STDIN>;
		chomp($final_month);
		print "Ano final: ";
		my $final_year = <STDIN>;
		chomp($final_year);
		my $init_date = sprintf("%02d/%02d/%04d", $init_day, $init_month, $init_year);
		my $final_date = sprintf("%02d/%02d/%04d", $final_day, $final_month, $final_year);
		my $init_date_obj = DateTime->new(year => $init_year, month => $init_month, day => $init_day);
		my $final_date_obj = DateTime->new(year => $final_year, month => $final_month, day => $final_day);
		print $final_date_obj->subtract_datetime($init_date_obj);
		print "\tIntervalo de data desejado: $init_date a $final_date";
		$val_date = 1;
	}
	else {
		print "Opcao invalida para data\n";
	}
}

if ($val_journal == 1 and $val_page == 1 and $val_date == 1) {
	print "Argumentos ok, let's do it!\n";
	my $date_string = localtime();
	my $directory = "Scraper_DOU" . $date_string;
	unless(-e $directory or mkdir($directory, 0755)) {
		die "Nao foi possivel criar $directory\n";
	}
	if ($page == -1) {
		my $pagesNumber = dou_pages($journal, $date);
		for (my $index = 1; $index <= $pagesNumber; $index++) {
			my $url = sprintf("http://pesquisa.in.gov.br/imprensa/servlet/INPDFViewer?jornal=%d&pagina=%d&data=%d&captchafield=firistAcces", $journal, $index, $date);
			my $file = sprintf("%04d_%02d_%02d_DOU%02d_page%03d.pdf", (substr $date, 6, 4), (substr $date, 3, 2), (substr $date, 0, 2), $journal, $index);
			getstore($url, $directory . "/" . $file);
			print "Salvando arquivo PDF $directory/$file\n";
		}
	}
	elsif ($page == 0) {
		print "Tente depois\n";
	}
	else {
		my $url = sprintf("http://pesquisa.in.gov.br/imprensa/servlet/INPDFViewer?jornal=%d&pagina=%d&data=%d&captchafield=firistAcces", $journal, $page, $date);
		my $file = sprintf("%04d_%02d_%02d_DOU%02d_page%03d.pdf", (substr $date, 6, 4), (substr $date, 3, 2), (substr $date, 0, 2), $journal, $page);
		getstore($url, $directory . "/" . $file);
		print "Salvando arquivo PDF $directory/$file\n";
	}
}

print "Pronto!\n";

sub date_split {
        return ((substr $3, 0, 2), (substr $3, 3, 2), (substr $3, 6, 4));
}

sub date_val {
	my ($_day, $_month, $_year) = @_;
        print "\n$_day/$_month/$_year\n";
        if ($_year >= 1990 && $_year <= $year) {
                print "\n$_year\n";
                if ($_month ~~ [1, 3, 5, 7, 8, 10, 12]) {
                        iprint "\n$month\n";
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

sub dou_pages {
	my ($journal, $date) = @_;
	my $url = get("http://pesquisa.in.gov.br/imprensa/jsp/visualiza/index.jsp?jornal=$journal&pagina=1&data=$date&captchafield=firistAccess");
	if ($url =~ /(&totalArquivos=)([0-9]+)"/) {
		return $2;
	}
	else {
		return -1;
	}
}

sub dou_download {

}
