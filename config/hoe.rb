require 'snitch/version'

AUTHOR = 'John Nunemaker'  # can also be an array of Authors
EMAIL = "nunemaker@gmail.com"
DESCRIPTION = "Drop dead easy subversion commit notifications."
GEM_NAME = 'snitch' # what ppl will type to install your gem
RUBYFORGE_PROJECT = 'snitch' # The unix name for your project
HOMEPATH = "http://#{RUBYFORGE_PROJECT}.rubyforge.org"
DOWNLOAD_PATH = "http://rubyforge.org/projects/#{RUBYFORGE_PROJECT}"
EXTRA_DEPENDENCIES = [
 ['activesupport', '>= 1.3.1'],
 ['mojombo-grit', '>= 0.9.0']
]
EXTRA_DEV_DEPENDENCIES = [
  # ['rspec', '>= 1.1.5']
]

@config_file = "~/.rubyforge/user-config.yml"
@config = nil
RUBYFORGE_USERNAME = "jnunemaker"
def rubyforge_username
  unless @config
    begin
      @config = YAML.load(File.read(File.expand_path(@config_file)))
    rescue
      puts <<-EOS
ERROR: No rubyforge config file found: #{@config_file}
Run 'rubyforge setup' to prepare your env for access to Rubyforge
 - See http://newgem.rubyforge.org/rubyforge.html for more details
      EOS
      exit
    end
  end
  RUBYFORGE_USERNAME.replace @config["username"]
end


REV = nil
# UNCOMMENT IF REQUIRED:
# REV = YAML.load(`svn info`)['Revision']
VERS = Snitch::VERSION::STRING + (REV ? ".#{REV}" : "")
RDOC_OPTS = ['--quiet', '--title', 'snitch documentation',
    "--opname", "index.html",
    "--line-numbers",
    "--main", "README",
    "--inline-source"]

class Hoe
  def extra_deps
    @extra_deps.reject! { |x| Array(x).first == 'hoe' }
    @extra_deps
  end
end

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.new(GEM_NAME, VERS) do |p|
  p.developer(AUTHOR, EMAIL)
  p.description    = DESCRIPTION
  p.summary        = DESCRIPTION
  p.url            = HOMEPATH
  p.rubyforge_name = RUBYFORGE_PROJECT if RUBYFORGE_PROJECT
  p.test_globs     = ["test/**/test_*.rb"]
  p.clean_globs |= ['**/.*.sw?', '*.gem', '.config', '**/.DS_Store']  #An array of file patterns to delete on clean.

  # == Optional
  p.changes        = p.paragraphs_of("History.txt", 0..1).join("\n\n")
  p.extra_deps     = EXTRA_DEPENDENCIES
  p.extra_dev_deps = EXTRA_DEV_DEPENDENCIES

    p.spec_extras = {}    # A hash of extra values to set in the gemspec.
  end

CHANGES = $hoe.paragraphs_of('History.txt', 0..1).join("\\n\\n")
PATH    = (RUBYFORGE_PROJECT == GEM_NAME) ? RUBYFORGE_PROJECT : "#{RUBYFORGE_PROJECT}/#{GEM_NAME}"
$hoe.remote_rdoc_dir = File.join(PATH.gsub(/^#{RUBYFORGE_PROJECT}\/?/,''), 'rdoc')
$hoe.rsync_args = '-av --delete --ignore-errors'
$hoe.spec.post_install_message = File.open(File.dirname(__FILE__) + "/../PostInstall.txt").read rescue ""
