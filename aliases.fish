fish_add_path -a (dirname (realpath (status -f)))/shell-scripts

if test -e /opt/homebrew/bin
    fish_add_path -p /opt/homebrew/bin
end

source (dirname (realpath (status -f)))/aliases.sh.fish

# Load fish script if present in current folder
if test -e ./.fishrc
   source ./.fishrc
end

# Load aliases if present in current folder
if test -e ./aliases.sh.fish 
    source ./aliases.sh.fish
end

# Load terraform vesion if specified for current folder
if test -e ./.terraform-version
    if command -q tfenv
        tfenv use
    end
end

# Load vesions of java tools if specified for current folder
if test -e ./.sdkmanrc
    if command -q sdk
        sdk env use
    end
end
