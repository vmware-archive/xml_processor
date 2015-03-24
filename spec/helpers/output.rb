def swallow_stderr(&block)
  real_stderr = $stderr
  $stderr = StringIO.new
  block.call
ensure
  $stderr = real_stderr
end