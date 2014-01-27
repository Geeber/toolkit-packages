# Manifest registration of available toolkit modules.
#
# Author:: Greg Look

# scripts and utilities
package 'tools',    :default => true
package 'keychain', :dotfiles => ['zsh']

# shell configuration
package 'input',     :dotfiles => true, :default => true
package 'zsh',       :dotfiles => true, :when => ( File.basename(ENV['SHELL']) == 'zsh'  )
package 'cygwin',    :dotfiles => true, :when => ( File.directory? '/cygdrive' )

# application settings
package 'git',    :dotfiles => true, :default => true
package 'tmux',   :dotfiles => true
package 'vim',    :dotfiles => true, :default => true
package 'vundle', :into => '.vim'

# langauges
package 'java',  :into => 'util/java'
