class UsersController < ApplicationController
  def signup_form
    result = run User::Operation::Signup::Present

    render cell(User::Cell::Signup, result["contract.default"], layout: Pro::Cell::Layout), layout: false
  end

  def signup
    result = run User::Operation::Signup do |res|
      session[:user_id] = res[:model].id # actually "sign in".

      return redirect_to "/my"
    end

    render cell(User::Cell::Signup, result["contract.default"], layout: Pro::Cell::Layout), layout: false
  end

  def signout
    session[:user_id] = nil
    redirect_to "/signup"
  end

  def dashboard
    raise unless session[:user_id]

    result = run User::Operation::Dashboard, params: {id: session[:user_id]}

    render cell(User::Cell::Dashboard, result[:model], layout: Pro::Cell::Layout), layout: false
  end
end
