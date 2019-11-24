bind_service 'default' do
  action [:create, :start]
end

bind_config 'default' do
  ipv6_listen true
  options [
    'check-names slave ignore',
    'multi-master yes',
    'provide-ixfr yes',
    'recursive-clients 10000',
    'request-ixfr yes',
    'allow-notify { acl-dns-masters; acl-dns-slaves; }',
    'allow-query { example-lan; localhost; }',
    'allow-query-cache { example-lan; localhost; }',
    'allow-recursion { example-lan; localhost; }',
    'allow-transfer { acl-dns-masters; acl-dns-slaves; }',
    'allow-update-forwarding { any; }',
  ]
end

bind_acl 'acl-dns-masters' do
  entries [
    '! 10.1.1.2',
    '10/8',
  ]
end

bind_acl 'acl-dns-slaves' do
  entries [
    'acl-dns-masters',
  ]
end

bind_acl 'lan' do
  entries [
    '10.1/16',
  ]
end
