module User::Operation
  class Signup < Trailblazer::Operation
    class Form < Reform::Form
      property :email
      property :password, virtual: true

      validates :email,    presence: true
      validates :password, presence: true
    end

    class Present < Trailblazer::Operation
      step Model( User, :new )
      step Contract::Build( constant: Form )
    end

    step Nested(Present)
    step Contract::Validate( key: :user )

    step ->(ctx, **) { ctx[:password] = ctx["contract.default"] }
    step Trailblazer::Activity::DSL::Helper.Subprocess(Tyrant::Signup::Password), id: :signup
    step ->(ctx, model:, auth:, **) { model.auth_data = auth.to_h }
    step Contract::Persist()
  end
end
