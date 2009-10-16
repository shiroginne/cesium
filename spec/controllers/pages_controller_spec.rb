require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PagesController do

  describe "GET show" do

    before do
      @url = ['contacts', 'info']
      @content = 'some content'
      @page = mock_model Post
      @page.stub(:draft?).and_return(false)
      @page.stub(:build_page).and_return(@content)
    end

    it "should find proper page by url" do
      Page.should_receive(:find_page).with("/#{@url.join('/')}")
      get :show, :url => @url
    end

    it "should redirect to admin controller if page not found or draft and url is /" do
      Page.stub!(:find_page).and_return(nil)
      get :show, :url => []
      response.should redirect_to(admin_pages_url)
    end

    it "should render 404 if page not found or draft and url is not /" do
      Page.stub!(:find_page).and_return(nil)
      get :show, :url => @url
      response.status.should match /404/  #render :file => "#{RAILS_ROOT}/public/404.html"
    end

    it "should render content if page found ant not draft" do
      Page.stub!(:find_page).and_return(@page)
      get :show, :url => @url
      response.should be_success
      response.body.should eql @content
    end

  end

end
