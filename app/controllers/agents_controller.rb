```ruby
class AgentsController < ApplicationController
  before_action :set_agent, only: [:show, :edit, :update, :destroy, :report]

  # GET /agents/1/report
  def report
    @agent = Agent.find(params[:id])
    # Generate the report here
    # For example, you can use a service object or a model method to generate the report
    # Then, you can render the report as a PDF or a text file
    # Here, we'll just render a simple text report
    render plain: "Report for agent #{@agent.name}"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_agent
      @agent = Agent.find(params[:id])
    end
end
```
