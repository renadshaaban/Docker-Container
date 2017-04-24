require 'elasticsearch/model'
require "bunny"
class Bug < ApplicationRecord

	include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  settings index: { number_of_shards: 1 }
  has_one :state
  enum status: {new_: 0, inprogress: 1, closed: 2}
  enum priority: {minor:0, major:1, critical:2}
  #validates_uniqueness_of :application_token, :scope => :number
  after_create :init

  def init
    puts "d5al init"
    related_bugs=Bug.where(:application_token => self.application_token).where.not(:id => self.id)
    if related_bugs.any?
      x=related_bugs.map(&:number).max
      self.number=x +1
      puts "awel case"
    else
      self.number=1
      puts "2nd case"
    end
    self.save!
  end

  def as_indexed_json(options={})
    self.as_json({
      only: [:comment]
    })
  end

  def self.search(query)
    __elasticsearch__.search(
  query: { query_string: {
    query: " application_token:\"#{query}\" OR status:\"#{query}\" OR number:\"#{query}\" OR *comment search #{query}*"
  }}
  ) 
  end

  def self.post(q)
    
    q.subscribe do |delivery_info, metadata, payload|
      puts "YAMOSAHEL"
      puts "opaaaa"
      puts "Received #{payload}"
      attributes=eval(payload)
      puts attributes
      s=State.create(:device => attributes[:device], :os=> attributes[:os], :memory => attributes[:memory], :storage => [:storage])
      b=Bug.create(:application_token => attributes[:application_token], :state_id =>s.id, :priority => attributes[:priority],
        :number =>attributes[:number],:status => attributes[:status], :comment => attributes[:comment])
      puts metadata
      
    end
  end


end
# OR