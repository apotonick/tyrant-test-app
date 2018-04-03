module User::Operation
  class Signin < Trailblazer::Operation
    class Form < Reform::Form
      property :email,    virtual: true
      property :password, virtual: true

      validates :email,    presence: true
      validates :password, presence: true
    end

    class Present < Trailblazer::Operation
      step Model( User, :new )
      step Contract::Build( constant: Form )
    end

    def self.find_user_from_contract(ctx, **)
      ctx[:model] = User.find_by(email: ctx["contract.default"].email)
    end

    # TODO: only allow once? nah

    step Nested(Present)
    step Contract::Validate( key: :user )
    step method(:find_user_from_contract)

    step ->(ctx, model:, **) { ctx[:auth] = model.auth_data }
    step ->(ctx, **) { ctx[:password] = ctx["contract.default"].password } # FIXME
    step ->(ctx, model:, **) { ctx[:auth]    = Pro::Lib::Auth.new( ctx[:model][:auth_data].symbolize_keys ) } # FIXME. where to put this?

    step Trailblazer::Activity::DSL::Helper.Subprocess(Tyrant::Signin), id: :signup
    fail ->(ctx, model:, auth:, **) { model.update_attributes(auth_data: auth.to_h) }
  end
end
