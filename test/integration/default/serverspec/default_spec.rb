require 'spec_helper'


  context linux_kernel_parameter('kernel.osrelease') do
    its(:value) { should eq '3.10.0-327.28.3.el7.x86_64' }
  end

  describe port(80) do
  it { should be_listening.with('tcp') }
  end

  describe port(9001) do
  it { should be_listening.with('tcp') }
  end