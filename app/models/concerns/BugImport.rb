module BugImport
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

  def self.import
    Bug.find_in_batches do |bugs|
      bulk_index(bugs)
    end
  end

  def self.prepare_records(bugs)
    bugs.map do |bug|
      { index: { _id: bug.id, data: bug.as_indexed_json } }
    end
  end

  def self.bulk_index(bugs)
    Bug.__elasticsearch__.client.bulk({
      index: ::Bug.__elasticsearch__.index_name,
      type: ::Bug.__elasticsearch__.document_type,
      body: prepare_records(bugs)
    })
  end
end