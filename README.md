Reproduction of a bug:

```ruby
class Post < ApplicationRecord
  has_one :content

  delegate :title, :title=, to: :resource_content

  scope :with_title, (title) { includes(:content).where('contents.title = ?', title).references(:contents) }

  def resource_content
    content || build_content
  end
end
```

```ruby
class Content < ApplicationRecord
  belongs_to :post, required: false
end
```

Enable caching.

```ruby
class PostsController < ApplicationController
  def index
    @posts = Post.with_title("some title")
  end
end
```

Posts#index view:

```
<%= cache [@posts] do %>
  <% @posts.each do |post| %>
    <%= post.title %>
  <% end %>
<% end %>
```

Attempting visit `/posts`:

```
ActionView::Template::Error (PG::UndefinedTable: ERROR:  missing FROM-clause entry for table "contents"

LINE 1: ...s"."updated_at") AS timestamp FROM "posts" WHERE (contents.t...

: SELECT COUNT(*) AS "size", MAX("posts"."updated_at") AS timestamp FROM "posts"
  WHERE (contents.title = 'first title')):
```

Traced to
[active_record/relation.rb:325](https://github.com/rails/rails/blob/master/activerecord/lib/active_record/relation.rb#L325).

