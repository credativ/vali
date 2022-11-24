# encoding: utf-8
require "logstash/devutils/rspec/spec_helper"
require "logstash/outputs/vali"
require "logstash/codecs/plain"
require "logstash/event"
require "net/http"
require 'webmock/rspec'
include Vali

describe LogStash::Outputs::Vali do

  let (:simple_vali_config) { {'url' => 'http://localhost:3100'} }

  context 'when initializing' do
    it "should register" do
      vali = LogStash::Plugin.lookup("output", "vali").new(simple_vali_config)
      expect { vali.register }.to_not raise_error
    end

    it 'should populate vali config with default or initialized values' do
      vali = LogStash::Outputs::Vali.new(simple_vali_config)
      expect(vali.url).to eql 'http://localhost:3100'
      expect(vali.tenant_id).to eql nil
      expect(vali.batch_size).to eql 102400
      expect(vali.batch_wait).to eql 1
    end
  end

  context 'when adding en entry to the batch' do
    let (:simple_vali_config) {{'url' => 'http://localhost:3100'}}
    let (:entry) {Entry.new(LogStash::Event.new({"message"=>"foobuzz","buzz"=>"bar","cluster"=>"us-central1","@timestamp"=>Time.at(1)}),"message")}
    let (:lbs) { {"buzz"=>"bar","cluster"=>"us-central1"}.sort.to_h}

    it 'should not add empty line' do
      plugin = LogStash::Plugin.lookup("output", "vali").new(simple_vali_config)
      emptyEntry = Entry.new(LogStash::Event.new({"message"=>"foobuzz","buzz"=>"bar","cluster"=>"us-central1","@timestamp"=>Time.at(1)}),"foo")
      expect(plugin.add_entry_to_batch(emptyEntry)).to eql true
      expect(plugin.batch).to eql nil
    end

    it 'should add entry' do
      plugin = LogStash::Plugin.lookup("output", "vali").new(simple_vali_config)
      expect(plugin.batch).to eql nil
      expect(plugin.add_entry_to_batch(entry)).to eql true
      expect(plugin.add_entry_to_batch(entry)).to eql true
      expect(plugin.batch).not_to be_nil
      expect(plugin.batch.streams.length).to eq 1
      expect(plugin.batch.streams[lbs.to_s]['entries'].length).to eq 2
      expect(plugin.batch.streams[lbs.to_s]['labels']).to eq lbs
      expect(plugin.batch.size_bytes).to eq 14
    end

    it 'should not add if full' do
      plugin = LogStash::Plugin.lookup("output", "vali").new(simple_vali_config.merge!({'batch_size'=>10}))
      expect(plugin.batch).to eql nil
      expect(plugin.add_entry_to_batch(entry)).to eql true # first entry is fine.
      expect(plugin.batch).not_to be_nil
      expect(plugin.batch.streams.length).to eq 1
      expect(plugin.batch.streams[lbs.to_s]['entries'].length).to eq 1
      expect(plugin.batch.streams[lbs.to_s]['labels']).to eq lbs
      expect(plugin.batch.size_bytes).to eq 7
      expect(plugin.add_entry_to_batch(entry)).to eql false # second entry goes over the limit.
      expect(plugin.batch).not_to be_nil
      expect(plugin.batch.streams.length).to eq 1
      expect(plugin.batch.streams[lbs.to_s]['entries'].length).to eq 1
      expect(plugin.batch.streams[lbs.to_s]['labels']).to eq lbs
      expect(plugin.batch.size_bytes).to eq 7
    end
  end

  context 'batch expiration' do
    let (:entry) {Entry.new(LogStash::Event.new({"message"=>"foobuzz","buzz"=>"bar","cluster"=>"us-central1","@timestamp"=>Time.at(1)}),"message")}

    it 'should not expire if empty' do
      vali = LogStash::Outputs::Vali.new(simple_vali_config.merge!({'batch_wait'=>0.5}))
      sleep(1)
      expect(vali.is_batch_expired).to be false
    end
    it 'should not expire batch if not old' do
      vali = LogStash::Outputs::Vali.new(simple_vali_config.merge!({'batch_wait'=>0.5}))
      expect(vali.add_entry_to_batch(entry)).to eql true
      expect(vali.is_batch_expired).to be false
    end
    it 'should expire if old' do
      vali = LogStash::Outputs::Vali.new(simple_vali_config.merge!({'batch_wait'=>0.5}))
      expect(vali.add_entry_to_batch(entry)).to eql true
      sleep(1)
      expect(vali.is_batch_expired).to be true
    end
  end

  context 'channel' do
    let (:event) {LogStash::Event.new({"message"=>"foobuzz","buzz"=>"bar","cluster"=>"us-central1","@timestamp"=>Time.at(1)})}

    it 'should send entry if batch size reached with no tenant' do
      vali = LogStash::Outputs::Vali.new(simple_vali_config.merge!({'batch_wait'=>0.5,'batch_size'=>10}))
      vali.register
      sent = Queue.new
      allow(vali).to receive(:send) do |batch|
        Thread.new do
          sent << batch
        end
      end
      vali.receive(event)
      vali.receive(event)
      sent.deq
      sent.deq
      vali.close
    end
    it 'should send entry while closing' do
      vali = LogStash::Outputs::Vali.new(simple_vali_config.merge!({'batch_wait'=>10,'batch_size'=>10}))
      vali.register
      sent = Queue.new
      allow(vali).to receive(:send) do | batch|
        Thread.new  do
          sent << batch
        end
      end
      vali.receive(event)
      vali.close
      sent.deq
    end
    it 'should send entry when batch is expiring' do
      vali = LogStash::Outputs::Vali.new(simple_vali_config.merge!({'batch_wait'=>0.5,'batch_size'=>10}))
      vali.register
      sent = Queue.new
      allow(vali).to receive(:send) do | batch|
        Thread.new  do
          sent << batch
        end
      end
      vali.receive(event)
      sent.deq
      sleep(0.01) # Adding a minimal sleep. In few cases @batch=nil might happen after evaluating for nil
      expect(vali.batch).to be_nil 
      vali.close
    end
  end

  context 'http requests' do
    let (:entry) {Entry.new(LogStash::Event.new({"message"=>"foobuzz","buzz"=>"bar","cluster"=>"us-central1","@timestamp"=>Time.at(1)}),"message")}

    it 'should send credentials' do
      conf = {
          'url'=>'http://localhost:3100/vali/api/v1/push',
          'username' => 'foo',
          'password' => 'bar',
          'tenant_id' => 't'
      }
      vali = LogStash::Outputs::Vali.new(conf)
      vali.register
      b = Batch.new(entry)
      post = stub_request(:post, "http://localhost:3100/vali/api/v1/push").with(
          basic_auth: ['foo', 'bar'],
          body: b.to_json,
          headers:{
              'Content-Type' => 'application/json' ,
              'User-Agent' => 'vali-logstash',
              'X-Scope-OrgID'=>'t',
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          }
      )
      vali.send(b)
      expect(post).to have_been_requested.times(1)
    end

    it 'should not send credentials' do
      conf = {
          'url'=>'http://foo.com/vali/api/v1/push',
      }
      vali = LogStash::Outputs::Vali.new(conf)
      vali.register
      b = Batch.new(entry)
      post = stub_request(:post, "http://foo.com/vali/api/v1/push").with(
          body: b.to_json,
          headers:{
              'Content-Type' => 'application/json' ,
              'User-Agent' => 'vali-logstash',
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          }
      )
      vali.send(b)
      expect(post).to have_been_requested.times(1)
    end
    it 'should retry 500' do
      conf = {
          'url'=>'http://foo.com/vali/api/v1/push',
          'retries' => 3,
      }
      vali = LogStash::Outputs::Vali.new(conf)
      vali.register
      b = Batch.new(entry)
      post = stub_request(:post, "http://foo.com/vali/api/v1/push").with(
          body: b.to_json,
      ).to_return(status: [500, "Internal Server Error"])
      vali.send(b)
      vali.close
      expect(post).to have_been_requested.times(3)
    end
    it 'should retry 429' do
      conf = {
          'url'=>'http://foo.com/vali/api/v1/push',
          'retries' => 2,
      }
      vali = LogStash::Outputs::Vali.new(conf)
      vali.register
      b = Batch.new(entry)
      post = stub_request(:post, "http://foo.com/vali/api/v1/push").with(
          body: b.to_json,
          ).to_return(status: [429, "stop spamming"])
      vali.send(b)
      vali.close
      expect(post).to have_been_requested.times(2)
    end
    it 'should not retry 400' do
      conf = {
          'url'=>'http://foo.com/vali/api/v1/push',
          'retries' => 11,
      }
      vali = LogStash::Outputs::Vali.new(conf)
      vali.register
      b = Batch.new(entry)
      post = stub_request(:post, "http://foo.com/vali/api/v1/push").with(
          body: b.to_json,
          ).to_return(status: [400, "bad request"])
      vali.send(b)
      vali.close
      expect(post).to have_been_requested.times(1)
    end
    it 'should retry exception' do
      conf = {
          'url'=>'http://foo.com/vali/api/v1/push',
          'retries' => 11,
      }
      vali = LogStash::Outputs::Vali.new(conf)
      vali.register
      b = Batch.new(entry)
      post = stub_request(:post, "http://foo.com/vali/api/v1/push").with(
          body: b.to_json,
          ).to_raise("some error").then.to_return(status: [200, "fine !"])
      vali.send(b)
      vali.close
      expect(post).to have_been_requested.times(2)
    end
  end
end
