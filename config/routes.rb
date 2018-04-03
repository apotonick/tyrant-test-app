Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get  "/signup",  to: "users#signup_form"
  post "/signup",  to: "users#signup"
  get  "/signout", to: "users#signout"
  get  "/forgot",  to: "users#forgot_form"
  post "/forgot",  to: "users#forgot"
  get  "/reset/:token/:id",  to: "users#reset_form", token: /[^\/]+/
  patch "/reset/:token/:id",  to: "users#reset", token: /[^\/]+/
  get  "/signin", to: "users#signin_form"
  post "/signin", to: "users#signin"

  get "/my",       to: "users#dashboard"
end
