# Scraper DOU
<br/>
<br/>
<br/>
##### [pt-br] 

`scraper_dou` é um software escrito em [perl](http://www.perl.org "The Perl Programming Language") :camel: para web scraping, que consiste em uma técnica utilizada na computação para extrair informações de websites, nesse caso do website do DOU.

DOU é a abreviação de Diário Oficial da União, sendo veiculado para dar publicidade aos atos do governo no âmbito federal.

Esse pequeno projeto visa ajudar pessoas que querem automatizar a etapa de download dos arquivos pdf disponibilizados pela [Imprensa Nacional](http://portal.imprensanacional.gov.br).

Para iniciar basta executar o arquivo `scraper_dou.pl` usando [perl](http://www.perl.org "The Perl Programming Language") :camel:, i.e.:

```perl scraper_dou.pl```

Esse script [perl](http://www.perl.org "The Perl Programming Language") :camel: utiliza os módulos [`Net::Ping`](http://perldoc.perl.org/Net/Ping.html "Net::Ping - check a remote host for reachability") :octocat: e [`LWP::Simple`](http://github.com/libwww-perl/libwww-perl "Simple procedural interface to LWP") :octocat:, verifique se os possui antes de executar, fazendo:

```cpan -l | grep ^Net::Ping[^:]```

```cpan -l | grep ^LWP::Simple[^:]```

Mais informações na [documentação oficial](http://perldoc.perl.org/perlfaq3.html#How-do-I-find-which-modules-are-installed-on-my-system%3f "Perl Programming Documentation - FAQs - How do I find which modules are installed on my system?")

Se você não os tiver, instale-os:

```cpan Net::Ping````

```cpan LWP::Simple```

Mais informações [no site do CPAN](http://www.cpan.org/modules/INSTALL.html "Comprehensive Perl Archive Network - How to install CPAN modules")

Leia cuidadosamente e digite apenas o que for pedido. Aproveite! :grin:
<br/>
<br/>
<br/>
<br/>
##### [en-us]

`scraper_dou` is a software written in [perl](http://www.perl.org "The Perl Programming Language") :camel: for web scraping, which consists a computer software technique of extracting information from websites, in this case the DOU website.

DOU is an acronym in portuguese for Diario Oficial da Uniao, the official journal of the federal government of Brazil, like Federal Register from USA.

This small project is to help those who want to automate the download stage of pdf files from [Brazilian National Press](http://portal.imprensanacional.gov.br).

To start simply run the file `scraper_dou.pl` using [perl](http://www.perl.org "The Perl Programming Language") :camel:, i.e.:

```perl scraper_dou.pl```

This [perl](http://www.perl.org "The Perl Programming Language") :camel: script uses [`Net::Ping`](http://perldoc.perl.org/Net/Ping.html "Net::Ping - check a remote host for reachability") :octocat: and [`LWP::Simple`](http://github.com/libwww-perl/libwww-perl "Simple procedural interface to LWP") :octocat: modules, make sure you have them installed before running, doing:

```cpan -l | grep ^Net::Ping[^:]```

```cpan -l | grep ^LWP::Simple[^:]```

More info in the [official docs](http://perldoc.perl.org/perlfaq3.html#How-do-I-find-which-modules-are-installed-on-my-system%3f "Perl Programming Documentation - FAQs - How do I find which modules are installed on my system?")

If you do not have them, install:

```cpan Net::Ping```

```cpan LWP::Simple```

More info [in the CPAN website](http://www.cpan.org/modules/INSTALL.html "Comprehensive Perl Archive Network - How to install CPAN modules")

Carefully read and type only what is required. Enjoy! :grin:
