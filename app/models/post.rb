class Post < ApplicationRecord
  has_one :content, autosave: true, dependent: :delete

  delegate :title, :title=, to: :resource_content

  scope :with_title, -> (title) { includes(:content).where('contents.title = ?', title).references(:contents) }

  def resource_content
    content || build_content
  end

end
