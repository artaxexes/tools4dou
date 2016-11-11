#!/usr/bin/perl
# test.pl

BEGIN {
	die "Install DateTime" unless (eval{require DateTime});
	die "Install LWP" unless (eval{require LWP});
	die "Install PDF" unless (eval{require PDF});
}

use 5.22.1;
use strict;
use warnings;
use LWP::Simple;
use DateTime;
use PDF;

my $url = "http://pesquisa.in.gov.br/imprensa/jsp/visualiza/index.jsp?jornal=1&pagina=1&data=10/06/2016&captchafield=firistAccess";
$url = "http://pesquisa.in.gov.br/imprensa/servlet/INPDFViewer?jornal=2&pagina=1&data=17/06/2016&captchafield=firistAccess";

test04();

sub test01 {
	my $ua = LWP::UserAgent->new;
	$ua->timeout(10);
	my $response = $ua->get($url);
	if ($response->is_success) {
		print $response->decoded_content;
	}
	else {
		die $response->status_line;
	}
}

=pod
sub test02 {
	my $pdf=PDF->new ;
	$pdf=PDF->new(filename);
	my $result=$pdf->TargetFile( filename );
	print "is a pdf file\n" if ( $pdf->IsaPDF ) ;
	print "Has ",$pdf->Pages," Pages \n";
	print "Use a PDF Version  ",$pdf->Version ," \n";
	print "and it is crypted  " if ( $pdf->IscryptedPDF) ;
	print "filename with title",$pdf->GetInfo("Title"),"\n";
	print "and with subject ",$pdf->GetInfo("Subject"),"\n";
	print "was written by ",$pdf->GetInfo("Author"),"\n";
	print "in date ",$pdf->GetInfo("CreationDate"),"\n";
	print "using ",$pdf->GetInfo("Creator"),"\n";
	print "and converted with ",$pdf->GetInfo("Producer"),"\n";
	print "The last modification occurred ",$pdf->GetInfo("ModDate"),"\n";
	print "The associated keywords are ",$pdf->GetInfo("Keywords"),"\n";
	my ($startx,$starty, endx,endy) = $pdf->PageSize ($page) ;
}
=cut

sub test03 {
	my $string = 'EXONERAR(, a pedido,)?';
	my $file = 'dou.pdf';
	my @results_search = `pdftotext $file - | grep --basic-regexp \"$string\"`;
	my $result_count = scalar @results_search;
	say "$result_count results founded";
	foreach my $result (@results_search) {
		print $result;
	}
}

sub test04 {
	my ($a, $b, $c);
	$a = $b = $c = "linha 1\nlinha 2\nlinha 3";
	$a =~ s/^.*/!!/g; print "$a\n-------------\n";
	$b =~ s/^.*/!!/gs; print "$b\n-------------\n";
	$c =~ s/^.*/!!/gm; print "$c\n-------------\n";
}
