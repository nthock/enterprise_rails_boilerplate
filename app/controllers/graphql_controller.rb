class GraphqlController < ApplicationController
  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {}
    unless public_operations.include? operation_name
      if user.present?
        context[:current_user] = user[0]
      else
        request_http_token_authentication and return
      end
    end

    result = BackendRailsSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  end

  private

  # Handle form data, JSON body, or a blank value
  def ensure_hash(ambiguous_param)
    case ambiguous_param
    when String
      if ambiguous_param.present?
        ensure_hash(JSON.parse(ambiguous_param))
      else
        {}
      end
    when Hash, ActionController::Parameters
      ambiguous_param
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end

  def public_operations
    [
      'authenticateUser',
      'createUser',
      'acceptInvite',
      'forgetPassword',
      'resetForgotPassword'
    ]
  end

  def current_user
      if user.present?
        user[0]
      else
        request_http_token_authentication and return
      end
    end

    def user
      hmac_secret = Rails.application.secrets.hmac_secret
      authenticate_with_http_token { |t, _o| JWT.decode(t, hmac_secret, true, algorithm: 'HS256') }
    end
end
