require 'spec_helper'

describe ApplicationHelper do
  subject { ApplicationHelper }
  let(:page) { build :page, { title: 'Some page', url: 'url/to' } }
  describe '.link_to' do
    it 'create link from regular args' do
      title = 'some link'
      url = 'http://google.com/'
      link_to(title, url).should include(title, url)
    end
    it 'create link to Page object' do
      link_to(page).should include(page.title, "/#{page.url}")
    end
    it 'create link to Page object with custom title' do
      custom_title = 'My awesome link'
      link_to(custom_title, page).should include(custom_title, "/#{page.url}")
    end
    it 'create link to Page with CSS class' do
      css_class = 'button'
      link_to(page, class: css_class).should include(css_class)
    end
    it 'raise exception if Page object misplaced' do
      expect { link_to('title', 'url', page) }.to raise_error
    end
  end
end