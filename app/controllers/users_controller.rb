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

  def forgot_form
    result = run User::Operation::ForgotPassword::Present

    render cell(User::Cell::ForgotPassword, result["contract.default"], layout: Pro::Cell::Layout), layout: false
  end

  def forgot
    result = run User::Operation::ForgotPassword do |res|
      # res[:token]
      return render cell(User::Cell::ResetResponse, res, layout: Pro::Cell::Layout), layout: false
    end

    render cell(User::Cell::ForgotPassword, result["contract.default"], layout: Pro::Cell::Layout), layout: false
  end

  def reset_form
    result = run User::Operation::ResetPassword::Present do |res|
      return render cell(User::Cell::ResetPassword, res["contract.default"], url: "/reset/#{res[:token]}/#{res[:model].id}", layout: Pro::Cell::Layout), layout: false
    end

    render html: "The reset link in invalid.", layout: false
    # redirect_to "/signup"
  end

  def reset
    result = run User::Operation::ResetPassword do |res|
      return redirect_to "/signin"
    end

    render cell(User::Cell::ResetPassword, result["contract.default"], url: "/reset/#{result[:token]}/#{result[:model].id}", layout: Pro::Cell::Layout), layout: false
  end

  def dashboard
    raise unless session[:user_id]

    result = run User::Operation::Dashboard, params: {id: session[:user_id]}

    render cell(User::Cell::Dashboard, result[:model], layout: Pro::Cell::Layout), layout: false
  end
end
