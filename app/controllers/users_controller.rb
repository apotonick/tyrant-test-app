class UsersController < ApplicationController
  def signup_form
    result = run User::Operation::Signup::Present

    render cell(User::Cell::Signup, result["contract.default"], layout: Pro::Cell::Layout), layout: false
  end

  def signup
    result = run User::Operation::Signup do |res|
      return redirect_to "/my"
    end

    render cell(User::Cell::Signup, result["contract.default"], layout: Pro::Cell::Layout), layout: false
  end
end
