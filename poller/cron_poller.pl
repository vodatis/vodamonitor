#!/usr/bin/perl

use strict;
use DBI;
require "multi_instance.pl";

multiInstance();

my $dsn="dbi:mysql:vodamonitor";
my $login="root";
my $mdp="";


print strftime("[%F %T] - ", localtime),"[START] Debut poller \n";

my $dbh=DBI->connect($dsn,$login,$mdp) or die "Echec de la connexion\n";

