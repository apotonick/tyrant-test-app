class UsersController < ApplicationController
  def signup_form
    render cell(User::Cell::Signup, "nil", layout: Pro::Cell::Layout), layout: false
  end
end
