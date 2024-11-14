module Matchable
    extend ActiveSupport::Concern
  
    included do
      include PgSearch::Model
      pg_search_scope :search_by_name,
        against: :name,
        using: {
          tsearch: { prefix: true },
          trigram: { threshold: 0.1 }
        }
    end
  end
  