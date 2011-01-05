#!/usr/bin/perl

use strict;

require "multi_instance.pl";

multiInstance();

my $srv = shift;


chomp(my $uptime=qx(ssh -p 6400 $srv uptime 2>/dev/null));

if ($uptime=~/up/)
{
    print "Le temps de fonctionnement de $srv est $uptime\n"; 
}
else
{
    print "Erreur sur $srv\n";
}
