require "pty"
require "timeout"

$maple = "/Library/Frameworks/Maple.framework/Versions/Current/bin/maple"

class Maple
  def initialize
    @command = ""
    @res = Array.new
    @flag = true
  end

  def define_symbol(symbol, val)
    @command += "#{symbol}:=#{val}:"
  end

  def define_calc(val1, operator, val2)
    @command += "#{val1}#{operator}#{val2};"
  end

  def plot(y, min, max)
    t = Time.new
    str = t.strftime("%Y-%m-%d %H:%M:%S")
    tmp = <<EOS
      interface(plotdevice = jpeg):
      filena:=[seq(`plot` || i || `.jpeg` , i=1)];
      plotname := filena [1] ;
      plotsetup (jpeg, plotoutput = plotname);
      plot (#{y}, x=#{min} .. #{max});
EOS

    @command += tmp

    exec_command()

    `open plot1.jpeg`
  end

  def latex_solve(y, x)
    @command += "latex(solve(#{y},#{x})[1]);"
    @flag = false
  end

  def solve(y, x)
    @command += "solve(#{y},#{x});"
  end

  def latex_factor(y)
    @command += "latex(factor(#{y}));"
    @flag = false
  end

  def factor(y)
    @command += "factor(#{y});"
  end

  def exec_command()
    PTY.getpty($maple) do |i, o|
      begin
        Timeout.timeout(1) do
          loop { i.getc }
        end
      rescue Timeout::Error
      end

      p @command
      o.puts @command

      begin
        Timeout.timeout(1) do
          loop do
            @res << i.gets
          end
        end
      rescue Timeout::Error
      end

      if @flag
        return @res[-2].gsub!(/\e\[;*\d*m\s*/, "")
      else
        return @res[-1].gsub!(/\e\[;*\d*m\s*/, "")
      end
    end
  end
end
