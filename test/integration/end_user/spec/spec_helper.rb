# .../test/integration
TEST_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '../../'))

def test_ide_work
  File.expand_path("#{TEST_ROOT}/end_user/test_ide_work")
end

def docker_image
  if ENV['AIT_DOCKER_IMAGE_NAME'].nil?
    fail "ENV['AIT_DOCKER_IMAGE_NAME'] is not set"
  end
  if ENV['AIT_DOCKER_IMAGE_TAG'].nil?
    fail "ENV['AIT_DOCKER_IMAGE_TAG'] is not set"
  end
  "#{ENV['AIT_DOCKER_IMAGE_NAME']}:"\
  "#{ENV['AIT_DOCKER_IMAGE_TAG']}"
end

def full_identity
  "#{TEST_ROOT}/identities/full"
end

def generate_idefiles()
  File.write("#{test_ide_work}/Idefile", "IDE_DRIVER=docker
IDE_DOCKER_IMAGE=\"#{docker_image}\"
IDE_IDENTITY=\"#{full_identity}\"
")
end

def rm_idefiles()
  FileUtils.rm("#{test_ide_work}/Idefile")
end

# improving String class
class String
  def cyan
    "\033[36m#{self}\033[0m"
  end
end

# Runs bash command and prints stdout and stderr line by line.
# Returns stdout+stderr and exit status.
def run_cmd(cmd)
  puts "running: #{cmd}".cyan
  total_output = ''
  _stdin, stdout, stderr, wait_thr = Open3.popen3(cmd)
  stdout.each_line do |line|
    puts line
    total_output += line
  end
  stderr.each_line do |line|
    puts line
    total_output += line
  end
  return total_output, wait_thr.value.exitstatus
end
