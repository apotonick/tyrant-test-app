module User::Operation
  class Signup < Trailblazer::Operation
    class Form < Reform::Form
      property :email,    virtual: true
      property :password, virtual: true

      validates :email,    presence: true
      validates :password, presence: true
    end

    class Present < Trailblazer::Operation
      step Model( OpenStruct, :new )
      step Contract::Build( constant: Form )
    end

    step Nested(Present)
    step Contract::Validate( key: :user )
  end
end
