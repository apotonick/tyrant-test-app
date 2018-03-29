module User::Operation
  class ResetPassword < Trailblazer::Operation
    class Form < Reform::Form
      property :password,         virtual: true
      property :password_confirm, virtual: true

      validates :password, :password_confirm, presence: true
      validate do
        errors.add(:password_confirm, "Passwords do not match") unless password == password_confirm
      end
    end

    class Present < Trailblazer::Operation
      step :find_user # @requires params[:id]

      step ->(ctx, model:, **) { ctx[:auth]    = Pro::Lib::Auth.new( ctx[:model][:auth_data].symbolize_keys ) } # FIXME. where to put this?
      step ->(ctx, params:, **) { ctx[:token]   = params[:token] } # FIXME: :input in check_token

      step Trailblazer::Activity::DSL::Helper.Subprocess(Tyrant::Forgot::CheckToken), id: :check_token
      step Contract::Build( constant: Form )

      def find_user(ctx, params:, **) # could be done via Model( User, :find_by )
        ctx[:model]   = User.find_by(id: params[:id])
      end
    end

    # TODO: only allow once? nah

    step Nested(Present)
    step Contract::Validate( key: :user )

    step ->(ctx, **) { ctx[:password] = ctx["contract.default"].password }
    step Trailblazer::Activity::DSL::Helper.Subprocess(Tyrant::Manage::UpdatePassword), id: :reset

    step ->(ctx, model:, auth:, **) { model.update_attributes(auth_data: auth.to_h) }
  end
end
