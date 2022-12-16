# webcrunch - discussion forums
- https://web-crunch.com/posts/lets-build-with-ruby-on-rails-discussion-forum

- GEMS
```
group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
  gem 'better_errors'
  gem 'binding_of_caller', '~> 1.0'
  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

# gem 'jquery-rails'
gem 'bulma-rails'
gem 'simple_form'
gem 'devise'
gem 'gravatar_image_tag'
gem 'friendly_id'
gem 'rolify'
gem 'cancancan'
gem 'redcarpet'
gem 'coderay'
```

- rails g simple_form:install
- rails g devise:install
- rails g devise:views
- rails g migration AddUsernameToUsers username
- rails g scaffold discussion title content:text
- rails g migration AddUserIdToDiscussions user_id:integer
- rails g scaffold Reply reply:text
- rails g scaffold channel channel
- rails g migration AddDiscussionIdToReplies discussion_id:integer
- rails db:migrate
- rails g migration AddUserIdToReplies user_id:integer
- rails g migration AddChannelIdToDiscussions channel_id:integer
- rails g migration  AddDiscussionIdToChannels discussion_id:integer
- rails db:migrate
- rails g rolify Role User
- rails generate friendly_id
- rails g migration AddSlugToDiscussions slug:uniq
- rails g migration AddSlugToChannels slug:uniq
- rails g migration AddSlugToReplies slug:uniq
- rails db:migrate
- update routes

```
Rails.application.routes.draw do
  resources :channels
  resources :discussions do
    resources :replies
  end

  root 'discussions#index'

  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end

```

- updated the devise for rails 7 turbo: https://dev.to/efocoder/how-to-use-devise-with-turbo-in-rails-7-9n9
- updated app controller

```
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end
end

```

- updated app.scss and functions.scss
- updated channels controller
- updated discussions controller
- updated replies controller
- updated app helper with markdown

```
module ApplicationHelper
  require 'redcarpet/render_strip'

  def has_role?(role)
    current_user && current_user.has_role?(role)
  end

  class CodeRayify < Redcarpet::Render::HTML
    def block_code(code, language)
      CodeRay.scan(code,language).div
    end
  end

  def markdown(text)
    coderayified = CodeRayify.new(:filter_html => true, :hard_wrap => true)
    options = {
      fenced_code_blocks: true,
      no_intra_emphasis: true,
      autolink: true,
      lax_html_blocks: true
    }
    markdown_to_html = Redcarpet::Markdown.new(coderayified, options)
    markdown_to_html.render(text).html_safe
  end

  def strip_markdown(text)
    markdown_to_plain_text = Redcarpet::Markdown.new(Redcarpet::Render::StripDown)
    markdown_to_plain_text.render(text).html_safe
  end

end

```

- updated discussions helper to check the authors

```

  def discussion_author(discussion)
    user_signed_in? && current_user.id == discussion.user_id
  end

  def reply_author(reply)
    user_signed_in? && current_user.id == reply.user_id
  end

end
```

- updated channel rb

```
  has_many :discussions
  has_many :users, through: :discussions
  resourcify

  extend FriendlyId
  friendly_id :channel, use: [:slugged, :finders]

  def should_generate_new_friendly_id?
    channel_changed?
  end

end

```

- updated discussion.rb

```
class Discussion < ApplicationRecord
  belongs_to :channel
  belongs_to :user
  has_many :replies, dependent: :destroy

  validates :title, :content, presence: true
  resourcify

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  def should_generate_new_friendly_id?
    title_changed?
  end
end

```

- created the models/ability.rb for rolify

```
class Ability
  include CanCan::Ability

  def initialize(user)
      user ||= User.new # guest user (not logged in)
      if user.has_role? :admin
        can :manage, :all
      else
        can :read, :all
      end

  end
end

```

- updated reply.rb

```
  belongs_to :discussion
  belongs_to :user
  validates :reply, presence: true

  extend FriendlyId
  friendly_id :reply, use: [:slugged, :finders]

  def should_generate_new_friendly_id?
    reply_changed?
  end

end

```

- updated user.rb

```
  has_many :discussions, dependent: :destroy
  has_many :channels, through: :discussions
end

```

- updated all the views
- using the markdown make sure to do

```ruby
this is where the code goes
```
- refresh and test, IT WORKED
## THE END