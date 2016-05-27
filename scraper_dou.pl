#!/usr/bin/perl

use strict;
use warnings;
use Net::Ping;
use LWP::Simple;

BEGIN {
	die "Antes de executar, instale o modulo Net::Ping com o comando:\ncpan Net::Ping\n" unless (eval{require Net::Ping});
	die "Antes de executar, instale o modulo LWP::Simple com o comando:\ncpan LWP::Simple\n" unless (eval{require LWP::Simple});
}

print "========================= Scraper DOU =========================\n";
print "---------------------------------------------------------------\n";

# Check a Imprensa Nacional host for reachability
my $host = "portal.imprensanacional.gov.br";
my $p = Net::Ping->new();
print "Verificando conexao com http://$host\n";
die "http://$host esta offline\n" unless $p->ping($host);
print "http://$host esta online\n";
$p->close();

# System datetime
my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time);
my $dt = sprintf("%02d/%02d/%04d", $mday, $mon + 1, $year + 1900);
print "Data/hora do sistema: $dt, $hour:$min:$sec\n";

# Input options
my $pattern = "(0|dou[1-3]);(-1|[0-9]+);(0|1|[0-9]{2}\/[0-9]{2}\/[0-9]{4})";
my $val_string = 0;
while ($val_string == 0) {
	print "\n\nPadrao para download do DOU com tres variaveis: jornal;pagina;data\n";
	print "Opcoes aceitas para cada variavel:\n";
	print "jornal = 0 ou dou1 ou dou2 ou dou3; onde 0 indica download de todos os DOUs e dou1/dou2/dou3 indica o jornal correspondente\n";
	print "pagina = -1 ou #pagina; onde -1 indica download de todas as paginas e #pagina o numero correspondente da pagina\n";
	print "data = 0 ou 1 ou dd/mm/aaaa; onde 0 indica todas as datas, 1 indica hoje e dd/mm/aaaa indica uma data valida no formato especificado\n";
	print "Digite a string: ";
	my $input = <STDIN>;
	chomp($input);
	if ($input =~ m/^$pattern$/) {
		print "$1\n$2\n$3\n";
		$val_string = 1;
	}
	else {
		print "\nString fora do padrao, leia atentamente as instrucoes!\n\n";
	}
}

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

if ($val_jornal == 1 and $val_page == 1 and $val_date == 1) {
	print "Argumentos ok, let's do it!\n";
	my $date_string = localtime();
	my $directory = "Scraper_DOU" . $date_string;
	unless(-e $directory or mkdir($directory, 0755)) {
		die "Nao foi possivel criar $directory\n";
	}
	if ($page == -1) {
		my $pagesNumber = CheckPagesNumber($jornal, $date);
		for (my $index = 1; $index <= $pagesNumber; $index++) {
			my $url = sprintf("http://pesquisa.in.gov.br/imprensa/servlet/INPDFViewer?jornal=%d&pagina=%d&data=%d&captchafield=firistAcces", $jornal, $index, $date);
			my $file = sprintf("%04d_%02d_%02d_DOU%02d_page%03d.pdf", (substr $date, 6, 4), (substr $date, 3, 2), (substr $date, 0, 2), $jornal, $index);
			getstore($url, $directory . "/" . $file);
			print "Salvando arquivo PDF $directory/$file\n";
		}
	}
	elsif ($page == 0) {
		print "Tente depois\n";
	}
	else {
		my $url = sprintf("http://pesquisa.in.gov.br/imprensa/servlet/INPDFViewer?jornal=%d&pagina=%d&data=%d&captchafield=firistAcces", $jornal, $page, $date);
		my $file = sprintf("%04d_%02d_%02d_DOU%02d_page%03d.pdf", (substr $date, 6, 4), (substr $date, 3, 2), (substr $date, 0, 2), $jornal, $page);
		getstore($url, $directory . "/" . $file);
		print "Salvando arquivo PDF $directory/$file\n";
	}
}
print "Pronto!\n";
