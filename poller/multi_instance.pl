#!/usr/bin/perl

use strict;
use POSIX qw(strftime);

# gestion multi-instances
sub multiInstance
{
    my $pid=$$;
    
    chomp(my $cmdline=qx(cat /proc/$pid/cmdline));
    
    opendir(my $PROC,'/proc');
    
    while (my $dir=readdir($PROC))
    {
        if (-f "/proc/$dir/cmdline")
        {
            if ($dir ne $pid)
            {
                #print "this is $dir\n";
                #print "$dir\n";
                chomp(my $cmdline_test=qx(cat /proc/$dir/cmdline));
                if ($cmdline_test eq $cmdline)
                {
                    #print "La commande est déjà lancé, je l'ai trouvé, c'est $dir!\n";
                    foreach my $ligne (qx(cat /proc/$dir/status))
                    {
                        if (my ($status)=($ligne=~/State:\s+(\w+)\s+.*/))
                        {
                            if ($status=~/S|R/)
                            {
                                #print "Elle fonctionne ($status) donc je ne me lance pas\n";
                                print strftime("[%F %T]", localtime)," [ERR] - Un poll est déjà en cours ($status) \n";
                                die strftime("[%F %T]", localtime)," [STOP] - Fin du poll prématurément\n";
                            }
                            else
                            {
                                #print "Elle est bloqué ($status), donc je prend sa place\n";
                                print strftime("[%F %T]", localtime)," [WARN] - Un poll est déjà en cours, mais non actif ($status). Je le kill et prend sa place\n";
                                kill(9,$dir);
                            }
                        }
                    }         
                }
            }
        }
    }
    closedir($PROC);
}
# FIN gestion multi-instances

1;