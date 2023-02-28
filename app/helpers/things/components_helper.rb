module Things
  module ComponentsHelper

    def options_for_select_thing_components(subsidiary, selected_value)
      options =  Thing.where(subsidiary_id: subsidiary).order(:name).limit(300).map{|x| [x.name, x.id]}
      options_for_select options, selected_value
    end

  end
end
