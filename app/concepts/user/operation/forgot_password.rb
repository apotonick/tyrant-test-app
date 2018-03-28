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
    step :find_user

    step ->(ctx, model:, **) { ctx[:auth] = model.auth_data }
    step Trailblazer::Activity::DSL::Helper.Subprocess(Tyrant::Forgot::Reset), id: :signup
    step ->(ctx, model:, auth:, **) { model.update_attributes(auth_data: auth.to_h) }

    step :send_email_with_token

    def find_user(ctx, **)
      ctx[:model] = User.find_by(email: ctx["contract.default"].email)
    end

    def send_email_with_token(ctx, token:, model:, **)
      ctx[:email_txt] = "Go here to recover: http://localhost:3000/reset/#{token}/#{model.id}"
    end
  end
end
