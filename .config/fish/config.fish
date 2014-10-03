set fish_greeting ''
function fish_prompt ; ~/src/github.com/burke/wunderprompt/prompt $status ; end

eval (gdircolors -b ~/.sshdrc.d/LS_COLORS | grep -v export | sed 's/LS_COLORS=/set -x LS_COLORS /')
function ls ;gls --color=auto -F $argv ; end

set -x EDITOR vim
set -x GOPATH $HOME

set -x PATH /Users/burke/src/chromium.googlesource.com/chromium/tools/depot_tools $PATH
set -x PATH /usr/local/bin $PATH
set -x PATH /usr/texbin $PATH
set -x PATH /Users/burke/src/code.google.com/p/go/bin $PATH
set -x PATH $HOME/bin $PATH
set -x PATH $HOME/bin/_git $PATH
set -x PATH /usr/local/Cellar/macvim/7.4-71/MacVim.app/Contents/MacOS $PATH
set -x PATH ~/.rbenv/shims ~/.rbenv/bin $PATH

eval (cat ~/.sshrc.d/aliases \
  | grep -v '^#' \
  | grep -vE '^\s*$' \
  | sed 's/\&\&/ ; and /g' \
  | sed 's/\$(/(/g' \
  | sed 's/^\([^ :]*\)[[:space:]]*:\(.*\)/function \1; \2 $argv; end;/')

set -x PYTHONPATH /lib/python2.7/site-packages

set -x CDPATH . $HOME/src/github.com $HOME/src/github.com/burke $HOME/src/github.com/Shopify $HOME/src/hobos

function ap ; awk "{print \$$argv[1]}"  ; end
function def          ; ag "def $argv" ; end
function cros_sdk; cd ~/src/coreos ; vagrant ssh -c "coreos/chromite/bin/cros_sdk" ; or sh -c 'vagrant up && vagrant ssh -c coreos/chromite/bin/cros_sdk' ; end
function psag ; ps aux | g $argv[1] | gvg ; end
function gh ; cd (_gh $argv) ; end
function ghs ; cd (_gh Shopify $argv) ; end
function   gfr ; git fetch $argv ; and git reset --hard FETCH_HEAD ; end
function ggh ; open (git remote show -n origin | grep "github.com:" | head -1 | awk '{print $3}' | sed 's/:/\//' | sed 's#git@#https://#' | sed 's/\.git$//') ; end
function ghg ; open https://github.com/$argv ; end
function ghgb ; ghg burke/$argv ; end
function ghgs ; ghg shopify/$argv ; end
function mi ; gem install --no-ri --no-rdoc $argv ; and reh ; end
function gbt ; git branch --track $argv[1] origin/$argv[1] ; end
function up ; while [ ! -d .git -a `pwd` != "/" ]; cd ".."; end ; end

rbenv rehash 2>/dev/null

#rbenv shell (rbenv global)
