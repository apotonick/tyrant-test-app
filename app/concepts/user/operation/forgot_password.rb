module User::Operation
  class ForgotPassword < Trailblazer::Operation
    class Form < Reform::Form
      property :email
      validates :email,    presence: true
    end

    class Present < Trailblazer::Operation
      step Model( User, :new )
      step Contract::Build( constant: Form )
    end

    # TODO: only allow once? nah

    step Nested(Present)
    step Contract::Validate( key: :user )
    step Signin.method(:find_user_from_contract)

    step ->(ctx, model:, **) { ctx[:auth] = model.auth_data }
    step Trailblazer::Activity::DSL::Helper.Subprocess(Tyrant::Forgot::Reset), id: :signup
    step ->(ctx, model:, auth:, **) { model.update_attributes(auth_data: auth.to_h) }

    step :send_email_with_token

    def send_email_with_token(ctx, token:, model:, **)
      url = %{http://localhost:3000/reset/#{token}/#{model.id}}
      ctx[:email_txt] = %{Go here to recover: <a href="#{url}">#{url}</a>}
    end
  end
end
