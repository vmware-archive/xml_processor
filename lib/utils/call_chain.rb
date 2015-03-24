class CallChain
  def initialize(*processes)
    @processes = processes
  end

  def invoke(arg)
    run(arg, @processes)
  end

  private

  def run(arg, processes)
    if processes.empty?
      arg
    else
      output = processes.first.call(arg)
      run(output, processes.drop(1))
    end
  end
end
