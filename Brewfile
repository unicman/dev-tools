################################################################################
# File: Brewfile
#
# Date (M/D/Y)         Name            Description
# 02/21/2020           unicman         Created
################################################################################

brew "python3"
brew "dos2unix"
brew "tree" # Provides tree representation of folder structure in terminal window.

cask "rectangle" # Provides keyboard shortcuts for moving windows in Mac
cask "postman" # Cool REST API Client

# DOES NOT WORK IN Ventura
# cask "caffeine" # Avoids laptop to go to sleep when lid is closed. Instead
                # command to be used - sudo pmset -b sleep 0; sudo pmset -b disablesleep 1
cask "adobe-acrobat-reader" # For annotating and filling up PDF forms.
cask "brave-browser"
cask "github"
cask "maczip" # To preview Zip archives instead of Mac OS default behavior to extract.

# Load all brewfiles under ~/.config/brewfile.d
Dir.glob("#{Dir.home()}/.config/brewfile.d/*") do |brewfile|
    eval(IO.read(File.symlink?(brewfile) ? File.readlink(brewfile) : brewfile), binding)
end

