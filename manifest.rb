# Manifest registration of available toolkit modules.
#
# Author:: Greg Look

# scripts and utilities
package 'tools',    :default => true
package 'keychain', :dotfiles => ['zsh']

# shell configuration
package 'input',     :default => true,              :dotfiles => true
package 'bash',      :when => shell?('bash'),       :dotfiles => true
package 'zsh',       :when => shell?('zsh'),        :dotfiles => true
package 'cygwin',    :when => file?('/Cygwin.bat'), :dotfiles => true
package 'solarized', :dotfiles => ['vim', 'zsh']

# application settings
package 'git',     :when => installed?('git'),  :dotfiles => true
package 'gradle', :dotfiles => true, :when => ( File.directory? '~/gradle' )
package 'tmux',    :when => installed?('tmux'), :dotfiles => ['tmux.conf', 'zsh']
package 'vim',     :when => installed?('vim'),  :dotfiles => true
package 'vundle',  :into => '.vim'
package 'synergy', :into => 'util/synergy'

# programming languages
package 'java',  :into => 'util/java'
package 'lein',  :when => installed?('lein'),           :dotfiles => true
package 'rbenv', :when => file?(ENV['HOME'], '.rbenv'), :dotfiles => true
package 'virtualenv', :dotfiles => true

# misc packages
package 'gentoo', :into => 'admin/gentoo'
package 'gtd',    :dotfiles => ['vim']
