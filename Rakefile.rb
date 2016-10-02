require 'oversion'
require 'gitrake'
require 'dockerimagerake'
require 'kitchen'

image_dir = File.expand_path("#{File.dirname(__FILE__)}/image")
image_name = 'docker-registry.ai-traders.com/java-ide'
ide_version = '0.6.0'

# This can be easily done in bash
desc 'Gets next_version from Consul and saves to version file'
task :save_version do
  version = OVersion.get_version()
  version_file = "#{image_dir}/etc_ide.d/variables/60-variables.sh"
  text = File.read(version_file)
  new_contents = text.gsub(/IMAGE_VERSION/, version)
  File.open(version_file, "w") {|file| file.puts new_contents }
end

# This can be easily done in bash
# This is in order to make tests fail fast. It can be hard to set ide configs
# correctly: to map all the files from /ide/identity into /ide/home.
# This step is not obligatory.
desc 'Builds docker image using correct base image and installs ide configs'
task :build_configs_image do
  Dir.chdir(image_dir) do
    Rake.sh('docker build -t ide_configs:temp -f Dockerfile_ide_configs .')
  end
end
task build_configs_image: [:save_version]

# This is in order to make tests fail fast.
desc 'Tests the docker image with ide configs installed'
task :test_ide_configs do
  ENV['KITCHEN_YAML'] = File.expand_path("#{File.dirname(__FILE__)}/.kitchen.yml")
  Rake.sh('kitchen test')
end

opts = DockerImageRake::Options.new(
  cookbook_dir: image_dir,
  repo_dir: File.expand_path("#{image_dir}/.."))
GitRake::GitTasks.new(opts)
img_opts = DockerImageRake::ImageOptions.new(opts,
  {image_name: image_name})
DockerImageRake::DockerImageTasks.new(img_opts)
task build: [:save_version]

desc 'Tests the end docker'
task :kitchen do
  ENV['KITCHEN_YAML'] = File.expand_path("#{File.dirname(__FILE__)}/.kitchen.image.yml")
  Rake.sh('kitchen test')
end

# Because we run end user tests which run ide command.
# End user tests are run inside ide docker container.
desc 'Install IDE to be able to run end user tests'
task :install_ide do
  Rake.sh("sudo bash -c \"`curl -L https://raw.githubusercontent.com/ai-traders/ide/#{ide_version}/install.sh`\"")
end

desc 'Run end user tests'
RSpec::Core::RakeTask.new(:end_user) do |t|
  # env variables like AIT_DOCKER_IMAGE_NAME are set by dockerimagerake gem
  t.rspec_opts = [].tap do |a|
    a.push('--pattern test/integration/end_user/spec/**/*_spec.rb')
    a.push('--color')
    a.push('--tty')
    a.push('--format documentation')
    a.push('--format h')
    a.push('--out ./rspec.html')
  end.join(' ')
end

desc 'Test if configuration files exist to fail fast'
task :end_user_prep do
  test_ide_work = File.join(
    File.dirname(__FILE__), 'test/integration/end_user/test_ide_work/')
  FileUtils.rm_r("#{test_ide_work}/stc-timefile") if File.directory?("#{test_ide_work}/stc-timefile")

  # copy real identity files into a directory which will be mounted as
  # /ide/identity
  real_identity_dir = File.join(
    File.dirname(__FILE__), 'test/integration/identities/real/')
  ::FileUtils.rm_rf(real_identity_dir)
  mkdir_p(real_identity_dir)
  mkdir_p("#{real_identity_dir}/.ssh")

  if File.file?("#{ENV['HOME']}/.ssh/id_rsa")
    cp("#{ENV['HOME']}/.ssh/id_rsa", "#{real_identity_dir}/.ssh")
  else
    fail "#{ENV['HOME']}/.ssh/id_rsa does not exist"
  end

  if File.file?("#{ENV['HOME']}/.gitconfig")
    cp("#{ENV['HOME']}/.gitconfig", "#{real_identity_dir}/.gitconfig")
  else
    fail "#{ENV['HOME']}/.gitconfig does not exist"
  end
end
task end_user: [:end_user_prep]
