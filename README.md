# A first pass at sharing my bash environment

## Instalation
1. Put this folder anywhere and cd to the directory.
        cd /wherever/best-bash
2. Copy the conf.sample file, name it conf, and edit conf define the variables within.
        cp conf.sample conf
        vi conf
3. Add a symbolic link from your home folder .bash_profile file to the best-bash conf file.
        ln -s conf ~/.bash_profile
