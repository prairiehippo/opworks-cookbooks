node[:deploy].each do |app_name, deploy|

  template "#{deploy[:deploy_to]}/current/sites/default/settings.php" do
    source "settings.php.erb"
    mode '0660'
    group deploy[:group]

    if platform?("ubuntu")
      owner "www-data"
    elsif platform?("amazon")   
      owner "apache"
    end

    # variables(
    #   :host =>     (node[:drupalapp][:database][:host] rescue nil),
    #   :user =>     (node[:drupalapp][:database][:username] rescue nil),
    #   :password => (node[:drupalapp][:database][:password] rescue nil),
    #   :db =>       (node[:drupalapp][:database][:database] rescue nil),
    #   :table =>    (node[:phpapp][:dbtable] rescue nil),
    #   :deploy => (deploy rescue nil)
    # )

    variables(
      :database => deploy[:database],
      :memcached => deploy[:memcached],
      :layers => node[:opsworks][:layers],
      :stack_name => node[:opsworks][:stack][:name],
      :config_file_path => "#{deploy[:deploy_to]}/shared/config/opsworks.php",
    )

   only_if do
     File.directory?("#{deploy[:deploy_to]}/current")
   end
  end
end
