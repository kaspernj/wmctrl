class Wmctrl::WindowProcess
  def self.list
    res = Knj::Os.shellcmd("wmctrl -lp")
    ret = [] unless block_given?

    res.scan(/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(.+?)$/) do |match|
      window_process = Wmctrl::WindowProcess.new(
        window_id: match[0],
        pid: match[2].to_i,
        user: match[3],
        window_title: match[4]
      )

      if block_given?
        yield window_process
      else
        ret << window_process
      end
    end

    if block_given?
      return nil
    else
      return ret
    end
  end

  attr_reader :pid, :user, :window_title, :window_id

  def initialize(args)
    args.each do |key, val|
      instance_variable_set("@#{key}", val)
    end
  end

  def focus
    %x[wmctrl -ia #{window_id}]
  end

  def to_s
    "#<WindowProcess window_id=#{window_id}, pid=#{pid}, user=#{user}, window_title=#{window_title}>"
  end

  def inspect
    to_s
  end
end
