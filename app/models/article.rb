class Article < ActiveRecord::Base
  has_many :collection_articles
  has_many :collections, through: :collection_articles

  validates_presence_of :url

  def archive
    self.archived = true
    self.save
  end

  def archived?
    !!archived
  end

  def upvote
    self.priority += 1
    self.save
  end

  def downvote
    self.priority -= 1
    self.save
  end

  def vote_links
    if self.priority < 1
      upvote
    elsif self.priority < 2
      dowvote
    end
  end

  def linkify
    link = self.url.gsub(/^(https|http):\/\//, "")
    "http://#{link}"
  end

  def readability
    url = "https://www.readability.com/api/content/v1/parser?url=#{self.linkify}&token=1d8b4f869348fc78387fbcd7fc495dba8890be85"
    response = RestClient.get(url)
    parsed_response = JSON.parse(response)
    parsed_response["content"].html_safe
  end

  accepts_nested_attributes_for :collections
end
