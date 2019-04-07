require 'awspec'
require 'httparty'
require 'rhcl'
# region = 'ap-southeast-2'
# ec2 = Aws::EC2::Client.new(region: region)
# azs = ec2.describe_availability_zones

# zone_names = azs.to_h[:availability_zones].first(2).map { |az| az[:zone_name] }

# bucket = 'rnd.badwolf.correia.ninja'
bucket = ENV['test_bucket']
url = 'http://' + bucket
resp = HTTParty.get(url)

example_main = Rhcl.parse(File.open('../../example/main.tf'))
puts example_main['variable']['allowed_ips']

describe resp do
  its(:code) {should eq 200}
end

describe s3_bucket(bucket) do
  it {should exist}
  its(:acl_owner) {should eq 'm'}
  its(:acl_grants_count) {should eq 1}
  # it { should have_versioning_enabled }
  it {should have_acl_grant(grantee: 'm', permission: 'FULL_CONTROL')}
  # it { should have_policy('{"Version":"2012-10-17","Statement":[{"Sid":"httpAccess","Effect":"Allow","Principal":{"AWS":"*"},"Action":"s3:*","Resource":["arn:aws:s3:::rnd.badwolf.correia.ninja/*","arn:aws:s3:::rnd.badwolf.correia.ninja"],"Condition":{"IpAddress":{"aws:SourceIp":"14.203.26.32/32"}}}]}') }
  it {should have_logging_enabled(target_bucket: 'logs.' + bucket)}
  it do
    should have_lifecycle_rule(
               id: bucket,
               noncurrent_version_expiration: {noncurrent_days: 90},
               transitions: [],
               status: 'Disabled'
           )
  end
end

describe s3_bucket('logs.' + bucket) do
  it {should exist}
  its(:acl_owner) {should eq 'm'}
  its(:acl_grants_count) {should eq 3}
  it {should have_server_side_encryption(algorithm: "AES256")}
  it {should have_acl_grant(grantee: 'm', permission: 'FULL_CONTROL')}
  it {should have_acl_grant(grantee: 'http://acs.amazonaws.com/groups/s3/LogDelivery', permission: 'WRITE')}
  it {should have_acl_grant(grantee: 'http://acs.amazonaws.com/groups/s3/LogDelivery', permission: 'READ_ACP')}
  it do
    should have_lifecycle_rule(
               id: 'logs.' + bucket,
               filter: {prefix: ''},
               noncurrent_version_expiration: {noncurrent_days: 90},
               expiration: {days: 90},
               transitions: [
                   {days: 30, storage_class: 'STANDARD_IA'},
                   {days: 60, storage_class: 'GLACIER'}
               ],
               status: 'Disabled'
           )
  end
end

