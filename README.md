# A first pass at sharing my bash environment

## Instalation
1. Put this folder anywhere
2. Copy the conf.sample file, name it conf, and edit conf define the variables within
        cp best-bash/conf.sample best-bash/conf
        vi conf
3. Add a symbolic link from your home folder to the bash_profile file in this directory
        ln -s /path/to/this/folder/best-bash/conf /home/username/.bash_profile

