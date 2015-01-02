require 'fog'

t = Fog::Image.new(
  :provider => 'OpenStack',
  :openstack_api_key => ENV['OS_PASSWORD'],
  :openstack_username => ENV['OS_USERNAME'],
  :openstack_auth_url => ENV['OS_AUTH_URL'] + '/tokens',
  :openstack_tenant => ENV['OS_TENANT_NAME']
)
t.list_public_images_detailed.data[:body]['images'].each do |image|
  if image['owner'] == '0c7155756fc649a4afa5694ef4a33dc0' && image['name'] == ENV['IMAGE_NAME']
    print image['id'] + "\n"
  end
end
