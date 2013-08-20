require 'spec_helper'

describe NutshellCrm::Client do
  before :all do
    @api_username = "jim@demo.nutshell.com"
    @api_key = "43c789d483fd76547b1f157e3cf5e580b95b9d8c"

    @categories = ['Contacts', 'Accounts', 'Leads']
  end

  context 'client authentication errors' do
    it 'should set up a new client instance with an invalid username and raise an error' do
      lambda { NutshellCrm::Client.new('invalid@example.com', 'APIKEY123456') }.should raise_error
    end

    it 'should set up a new client instance with a valid username but invalid API key and raise an error' do
      nutshell = NutshellCrm::Client.new(@api_username, 'APIKEY123456')
      lambda { nutshell.find_leads({:status => 0}) }.should raise_error
    end
  end

  context 'after a new Nutshell client has been instantiated' do
    before(:all) do
      @nutshell = NutshellCrm::Client.new @api_username, @api_key
    end

    it 'should get a valid API service url that starts with https://' do
      @nutshell.api_url.should match 'https://'
    end

    it 'should consider global stub_response property settings' do
      @nutshell.stub_responses = false
      @nutshell.find_leads({:status => 0}).first['stub'].should_not be true
      @nutshell.stub_responses = true
      @nutshell.find_leads({:status => 0}).first['stub'].should be true
      @nutshell.stub_responses = nil
    end

    it 'should find open leads' do
      @nutshell.find_leads({:status => 0}).should_not be_empty
    end

    it 'should describe custom fields' do
      custom_fields = @nutshell.describe_custom_fields
      (custom_fields.all? { |k, v| @categories.include? k }).should be_true
    end

    it 'should find tags' do
      tags = @nutshell.find_tags
      (tags.all? { |k, v| @categories.include? k }).should be_true
    end

    it 'should get update times for each provisioning bin' do
      @nutshell.get_update_times.should_not be_empty
    end

    it 'should return universal search results' do
      @nutshell.search_universal('A').should_not be_empty
    end

    it 'should create a new tag and find it' do
      lambda {
        @nutshell.new_tag({:name => 'FOO2', :entityType => 'Leads'})
        @nutshell.new_tag({:name => 'FOO2', :entityType => 'Leads'})
      }.should raise_error
    end

    it 'should return product info' do
      product = @nutshell.get_product(1)
      product.should_not be_empty
    end

    #it 'should return mobile settings' do
    #  mobile_settings = @nutshell.get_mobile_settings
    #  mobile_settings.should_not be_empty
    #end

    it 'should return the logged in user' do
      user = @nutshell.get_user
    end

    it 'should get and edit a lead' do
      lead_id = 1001
      lead = @nutshell.get_lead(lead_id)
      rev = lead['rev']
      @nutshell.edit_lead(lead_id, rev, {:description => 'Testing edit.'})
    end

    it 'should return the sources' do
      @nutshell.search_sources('Cold')
    end

    it 'should update a process step' do
      step = @nutshell.get_lead(1001)['processes'][0]['steps'][0]
      current_status = step['status'].to_i

      if current_status < 2
        @nutshell.edit_step(step['id'], step['rev'], {:status => 2})
      else
        lambda { @nutshell.edit_step(step['id'], step['rev'], {:status => 2}) }.should raise_error
      end
    end

  end

  context "after a new Nutshell client has been instantiated with a cache" do

    let(:cache) { FakeCache.new }

    before do
      @nutshell = NutshellCrm::Client.new @api_username, @api_key, cache
    end

    it "gets lead with etag" do
      lead_id = 1001

      response = @nutshell.get_lead(lead_id, nil)

      second_response = @nutshell.get_lead(lead_id, nil)

      response["_notModified"].should be_nil
      second_response["_notModified"].should be_true
    end

    it "finds open leads with etag" do
      response = @nutshell.find_leads({:status => 0})

      second_response = @nutshell.find_leads({:status => 0})

      response.should be_instance_of(Array)

      second_response["_notModified"].should be_true
    end

  end


end