module HistoriesHelper

  def histories_limited(thing)
    thing.histories.where(origin: 'Mobile').limit(5).order(created_at: :desc)
  end

  def all_histories(thing)
    thing.histories.where(origin: 'Mobile').order(created_at: :desc)
  end

end
