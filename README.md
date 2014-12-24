crypt
=====

Perl
----

Aquest script necessita instal·lar llibreries. Per no actualitzar per error
alguna de la eBD millor fer-ho amb el perl del sistema

Assegura't no estar executant això amb el perl de la eBD, per exemple pots
fer en comptes de:

  perl Makefile.PL

fes:

  /usr/bin/perl Makefile.PL

i en comptes de cpan, /usr/bin/cpan


Requeriments
------------

De sistema a instalar amb cpan o amb la eina del sistema ( rpm o deb )

Crypt::CBC
Crypt::OpenSSL::AES
XML::Simple

També es requereix instal·lar el mòdul eBD::Process de gitub:

https://github.com/frankiejol/ebd-process


Taules
------

Al principi del script es poden configurar les taules i els camps d'entrada sortida


Provar
------

Es pot provar desde el sistema operatiu per detectar millor errades i mòduls que falten.
Cal ficar abans l'alias de la eBD , i com a argument el id d'un registre.

  $ EBD_ALIAS="laebdquesigui" ./cbc.pl id

