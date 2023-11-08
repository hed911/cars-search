class BaseParser
  def format(results)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end
