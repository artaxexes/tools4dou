# scrpr4dou
<br/>
<br/>
<br/>
<br/>
##### [pt-br] 
<br/>
<br/>
`scrpr4dou` é um software escrito em [perl](http://www.perl.org "The Perl Programming Language") :camel: para web scraping, que consiste em uma técnica utilizada na computação para extrair informações de websites, nesse caso do website do DOU.
<br/>
<br/>
DOU é a abreviação de Diário Oficial da União, sendo veiculado para dar publicidade aos atos do governo no âmbito federal.
<br/>
<br/>
Esse pequeno projeto visa ajudar pessoas que querem automatizar a etapa de download dos arquivos pdf disponibilizados pela [Imprensa Nacional](http://portal.imprensanacional.gov.br).
<br/>
<br/>
Para iniciar basta tornar o arquivo `scrpr4dou.pl` executavel e executa-lo com os comandos...
<br/>
```
sudo chmod +x scrpr4dou.pl
./scrpr4dou.pl
```
<br/>
...ou simplesmente executa-lo usando [perl](http://www.perl.org "The Perl Programming Language") :camel:, i.e.:
<br/>
```perl scrpr4dou.pl```
<br/>
<br/>
Esse script [perl](http://www.perl.org "The Perl Programming Language") :camel: utiliza os módulos [`Net::Ping`](http://perldoc.perl.org/Net/Ping.html "Net::Ping - check a remote host for reachability") :octocat: e [`LWP::Simple`](http://github.com/libwww-perl/libwww-perl "Simple procedural interface to LWP") :octocat:, verifique se os possui antes de executar, fazendo:
<br/>
```cpan -l | grep ^Net::Ping[^:]```
<br/>
```cpan -l | grep ^LWP::Simple[^:]```
<br/>
Mais informações na [documentação oficial](http://perldoc.perl.org/perlfaq3.html#How-do-I-find-which-modules-are-installed-on-my-system%3f "Perl Programming Documentation - FAQs - How do I find which modules are installed on my system?")
<br/>
<br/>
Se você não os tiver, instale-os:
<br/>
```cpan Net::Ping````
<br/>
```cpan LWP::Simple```
<br/>
Mais informações [no site do CPAN](http://www.cpan.org/modules/INSTALL.html "Comprehensive Perl Archive Network - How to install CPAN modules")
<br/>
<br/>
Leia cuidadosamente e digite apenas o que for pedido. Aproveite! :grin:
<br/>
<br/>
<br/>
<br/>
##### [en-us]
<br/>
<br/>
`scrpr4dou` is a software written in [perl](http://www.perl.org "The Perl Programming Language") :camel: for web scraping, which consists a computer software technique of extracting information from websites, in this case the DOU website.
<br/>
<br/>
DOU is an acronym in portuguese for Diario Oficial da Uniao, the official journal of the federal government of Brazil, like Federal Register from USA.
<br/>
<br/>
This small project is to help those who want to automate the download stage of pdf files from [Brazilian National Press](http://portal.imprensanacional.gov.br).
<br/>
To start simply make the file `scrpr4dou.pl` executable and run it with the commands...

```
sudo chmod +x scrpr4dou.pl
./scrpr4dou.pl
```

...or simply run it using [perl](http://www.perl.org "The Perl Programming Language") :camel:, i.e.:

```perl scrpr4dou.pl```

This [perl](http://www.perl.org "The Perl Programming Language") :camel: script uses [`Net::Ping`](http://perldoc.perl.org/Net/Ping.html "Net::Ping - check a remote host for reachability") :octocat: and [`LWP::Simple`](http://github.com/libwww-perl/libwww-perl "Simple procedural interface to LWP") :octocat: modules, make sure you have them installed before running, doing:

```cpan -l | grep ^Net::Ping[^:]```

```cpan -l | grep ^LWP::Simple[^:]```

More info in the [official docs](http://perldoc.perl.org/perlfaq3.html#How-do-I-find-which-modules-are-installed-on-my-system%3f "Perl Programming Documentation - FAQs - How do I find which modules are installed on my system?")

If you do not have them, install:

```cpan Net::Ping```

```cpan LWP::Simple```

More info [in the CPAN website](http://www.cpan.org/modules/INSTALL.html "Comprehensive Perl Archive Network - How to install CPAN modules")

Carefully read and type only what is required. Enjoy! :grin:
