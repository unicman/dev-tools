fish_add_path (dirname (realpath (status -f)))/shell-scripts

source (dirname (realpath (status -f)))/aliases.sh.fish

if test -e ./.fishrc
   source ./.fishrc
end

if test -e ./aliases.sh.fish 
    source ./aliases.sh.fish
end
