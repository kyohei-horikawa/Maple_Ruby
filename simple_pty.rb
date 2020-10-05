require "pty"
require "timeout"

$maple = "/Library/Frameworks/Maple.framework/Versions/Current/bin/maple"
res = Array.new

command = <<EOS
x:=3:
x*5;
EOS
# command = <<EOS
# y:=x^2+4*x+6:
# latex(solve(y,x)[1]);
# EOS

PTY.getpty($maple) do |i, o|
  begin
    Timeout.timeout(1) do
      loop { i.getc }
    end
  rescue Timeout::Error
  end

  o.puts command

  begin
    Timeout.timeout(1) do
      loop do
        res << i.gets
      end
    end
  rescue Timeout::Error
  end

  p res
end
