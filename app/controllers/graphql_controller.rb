# frozen_string_literal: true

class GraphqlController < ApplicationController
  skip_before_action :verify_authenticity_token
  # If accessing from outside this domain, nullify the session
  # This allows for outside API access while preventing CSRF attacks,
  # but you'll have to authenticate your user separately
  # protect_from_forgery with: :null_session
  DEFAULT_CONTEXT = {
    current_user: nil
  }.freeze

  def execute    
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]    
    context = {
      # Query context goes here, for example:
      current_user: current_user_graph
    }
    result = OrdenappSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?
    handle_error_in_development(e)
  end

  private

  def current_user_graph
    return {} if authorization_token.nil?  
    authorization_token.slice! "Bearer "    
    decoded = JsonWebToken.decode(authorization_token)
    if decoded.nil? || decoded.empty?
      return {}
    end      
    return User.find(decoded[:user_id])    
  end

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { errors: [{ message: e.message, backtrace: e.backtrace }], data: {} }, status: 500
  end

  def authorization_token
    @authorization_token ||= request.headers['Authorization']
  end
end
