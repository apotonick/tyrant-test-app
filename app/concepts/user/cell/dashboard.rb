module User::Cell
  class Dashboard < Trailblazer::Cell
    def debug
      CGI.escape_html model.inspect
    end
  end
end
