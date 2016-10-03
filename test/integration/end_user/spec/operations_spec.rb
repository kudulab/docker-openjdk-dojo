require_relative './spec_helper'
require 'English'
require 'open3'

context 'operations' do

  before :all do
    generate_idefiles()
  end

  after :all do
    rm_idefiles()
  end

  context 'when full identity' do
    it 'is correctly initialized; pwd shows /ide/work' do
      cmd = "cd #{test_ide_work} && ide \"pwd && whoami\""

      output, exit_status = run_cmd(cmd)

      expect(output).to include('ide init finished')
      expect(output).to include('/ide/work')
      expect(output).to include('ide')
      expect(output).to include('using java-ide')
      expect(output).not_to include('root')
      expect(exit_status).to eq 0
    end
    it 'has java installed and it is invocable' do
      cmd = "cd #{test_ide_work} && ide \"java -version\""

      output, exit_status = run_cmd(cmd)

      expect(output).to include('openjdk version "1.8')
      expect(exit_status).to eq 0
    end
    it 'has correct environment variables set' do
      cmd = "cd #{test_ide_work} && ide \"env | grep JAVA\""

      output, exit_status = run_cmd(cmd)

      expect(output).to include('JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk')
      expect(output).to include('JAVA_VERSION=8u92')
      expect(output).to include('JAVA_ALPINE_VERSION=8.92.14-r1')
      expect(exit_status).to eq 0
    end
    it 'has gradle installed and it is invocable' do
      cmd = "cd #{test_ide_work} && ide \"gradle --version\""

      output, exit_status = run_cmd(cmd)

      expect(output).to include('Gradle 3.1')
      expect(exit_status).to eq 0
    end
    it 'has maven installed and it is invocable' do
      cmd = "cd #{test_ide_work} && ide \"mvn --version\""

      output, exit_status = run_cmd(cmd)

      expect(output).to include('Apache Maven 3.3.9')
      expect(exit_status).to eq 0
    end
  end
end
