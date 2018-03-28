module User::Operation
  class Dashboard < Trailblazer::Operation
    step Model( User, :find )
  end
end
