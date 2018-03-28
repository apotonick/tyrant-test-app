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

    step Nested(Present)
    step Contract::Validate( key: :user )

    # step ->(ctx, **) { ctx[:password] = ctx["contract.default"] }
    # step Trailblazer::Activity::DSL::Helper.Subprocess(Tyrant::Signup::Password), id: :signup
    # step ->(ctx, model:, auth:, **) { model.auth_data = auth.to_h }
  end
end
