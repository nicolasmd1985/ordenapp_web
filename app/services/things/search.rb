module Things::Search

  def self.search_devise(params)
    user = User.find_by(email: params[:user_email])
    Thing.where("name LIKE '%#{params[:name]}%'").where(subsidiary_id: user.subsidiary_id)
  end

end
