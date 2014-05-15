# Pwnie Expres Plug UI Revision: 7.5.2011
# Copyright 2010-2015 Rapid Focus Security, LLC, DBA Pwnie Express
# pwnieexpress.com
#
# This file contains proprietary software distributed under the terms of the Rapid Focus Security, LLC End User License Agreement (EULA).
#
# Use of this software signifies your agreement to the Rapid Focus Security, LLC End User License Agreement (EULA).
#
# Rapid Focus Security, LLC EULA: http://pwnieexpress.com/pdfs/RFSEULA.pdf
#

require 'rubygems'
require 'sinatra'
require 'erb'
require 'methods.rb'

# External Password File
require 'secret.rb'

# SSL requirements
require 'webrick'
require 'webrick/https'
require 'openssl'

#fix webrick binding issue
Socket.do_not_reverse_lookup = true

#SSL settings for webrick
CERT_PATH = '/etc/ssl/private/'

webrick_options = {
        :BindingAddress     => '0.0.0.0',
        :Port               => 8443,
        :Logger             => WEBrick::Log::new($stderr, WEBrick::Log::DEBUG),
        :DocumentRoot       => '/var/pwnplug/plugui/public',
        :SSLEnable          => true,
        :SSLVerifyClient    => OpenSSL::SSL::VERIFY_NONE,
        :SSLCertificate     => OpenSSL::X509::Certificate.new(  File.open(File.join(CERT_PATH, "plugui_cert.pem")).read),
        :SSLPrivateKey      => OpenSSL::PKey::RSA.new(          File.open(File.join(CERT_PATH, "plugui_key.pem")).read),
        :SSLCertName        => [ [ "CN",WEBrick::Utils::getservername ] ]
}

class MyServer < Sinatra::Base

# Require basic auth

use Rack::Auth::Basic do |username, password|
  [username, password] == ['plugui', Secret ]
end

set :public, File.dirname(__FILE__) + '/public'

# Start pwnplugui code

#Handle '/' index uri
get '/?' do 
	 redirect '/system'
end

#system info page
get '/system' do
  @title="System Info"
  @system_current ="current"
	erb :system 
end

#basic setup page
get '/setup' do
  @title = "Basic Setup"
  @setup_current = "current"
  erb :setup
end

#clear logs and history
post '/setup/clear' do
  `sh /var/pwnplug/scripts/cleanup.sh`
  @alert = "History and Logs have been cleared"
  erb :setup
end

# Network config
get '/network-config' do
  @title = "Network Config"
  @setup_current ="current"
  erb :network_config
end

post '/network-config/static_ip' do
    @title = "Network Config"
    @setup_current ="current"
    @alert = "Static IP has been set. Server restarting."
    erb :network_config
    string = "auto eth0\niface eth0 inet static\naddress #{params[:ip]}\nnetmask #{params[:netmask]}\ngateway #{params[:gateway]}\n"
   append_to_file("/etc/network/interfaces",string)
   `echo "nameserver #{params[:dns]}" > /etc/resolv.conf && route del default & route del default & sleep 2`
   `/etc/init.d/networking restart`
end

post '/network-config/dhcp' do
    @title = "Network Config"
    @setup_current = "current"
    @alert = "DHCP lease renewed."
     append_to_file("/etc/network/interfaces","auto eth0\niface eth0 inet dhcp")
    `/etc/init.d/networking restart`
    erb :network_config
end

post '/network-config/hostname' do
    @title = "Network Config"
    @setup_current = "current"
    `echo #{params[:hostname]} > /etc/hostname &&/etc/init.d/hostname.sh start`
   @alert = "Hostname has been updated to \"#{params[:hostname]}\"."
   erb :network_config
end


#SMS alert
get '/sms-alert' do
  @title = "SMS Alert Config"
  @sms_current ="current"
  erb :sms
end

post '/sms-alert' do
    @title = "SMS Alert Config"
    @sms_current = "current"
  sms_config(params[:sms_recipient],params[:sms_sender],params[:smtp_server],params[:smtp_auth_user],params[:smtp_auth_password],params[:smtp_tls], params[:msg_subject],params[:msg_body])
  `sleep 2 && /var/pwnplug/scripts/sms_message.sh`
  @alert = "Configuration Saved & test message sent!"
  erb :sms
end

# Change password
get '/secret' do
  @title= "Change Plug UI Passsword"
  @setup_current = "current"
  erb :secret
end

post '/secret' do
  @title= "Change Plug UI Password"
  @setup_current = "current"
  if params[:new_secret] != params[:new_secret_confirmation]
    @alert = "Please enter the same password into both fields"
    erb :secret 
  else  
  `echo "Secret = '#{params[:new_secret]}'" > /var/pwnplug/plugui/secret.rb`
	Secret = params[:new_secret] 
   redirect '/'
	end
end 


get '/evil-ap' do
  @title = "Evil AP Config"
  @setup_current = "current"
  erb :evil_ap
end

post '/evil-ap' do
  evil_config(params[:ssid])
  `sh /var/pwnplug/scripts/evilap.sh`
  erb :evil_ap
end

post '/evil-ap/stop' do
	`sh /var/pwnplug/scripts/evilap_stop.sh`
	redirect '/evil-ap'	
end



# ssh keygen page
get '/ssh_keygen' do 
  @title="SSH Keys"
  @ssh_current = "current"
	erb :ssh_keygen
end

post '/ssh_keygen' do
  @title="SSH Keys"
  @ssh_current = "current"
  `rm -f /root/.ssh/id_rsa /root/.ssh/id_rsa.pub & ssh-keygen -t rsa -f /root/.ssh/id_rsa -P ""`
   erb :ssh_keygen
end

#script config page
get '/script' do
  @title ="Reverse Shells"
  @shell_current = "current"
  @alert = ""
	erb :script_form
end

#post to the script config page
post '/script' do
  @title ="Reverse Shells"
  @shell_current = "current"
  crontab_array = []
  #handles basic ssh script config from post
  if params[:tcp_ssh] == 'on'
   	if check_tcp_ssh(params[:tcp_ssh_ip],params[:tcp_ssh_port]) != true
     	clear_tunnel("reverse_ssh_config.sh","3333")
		  tcp_ssh(params[:tcp_ssh_ip],params[:tcp_ssh_port])
		end
	  crontab_array.push(build_string(params[:tcp_ssh_cron],"reverse_ssh.sh"))
  else
  	 clear_tunnel("reverse_ssh_config.sh","3333")
  end
  #handles http script config from post
  if params[:http_ssh] == 'on'
   if check_http_ssh(params[:http_ssh_ip]) != true
     clear_tunnel("reverse_ssh_over_HTTP_config.sh","3338")
     http_ssh(params[:http_ssh_ip])
   end
   crontab_array.push(build_string(params[:http_ssh_cron],"reverse_ssh_over_HTTP.sh"))
  else
   clear_tunnel("reverse_ssh_over_HTTP_config.sh","3338")
  end
  #handles ssl script config from post
  if params[:ssl_ssh] == 'on'
    if check_ssl_ssh(params[:ssl_ssh_ip]) != true
      clear_tunnel("reverse_ssh_over_SSL_config.sh","3336")
      ssl_ssh(params[:ssl_ssh_ip])
    end
    crontab_array.push(build_string(params[:ssl_ssh_cron],"reverse_ssh_over_SSL.sh"))
  else
   clear_tunnel("reverse_ssh_over_SSL_config.sh","3336")
  end	
  #handles dns script config from post
  if params[:dns_ssh] == 'on'
    if check_dns_ssh(params[:dns_ssh_ip]) != true
      clear_tunnel("reverse_ssh_over_DNS_config.sh","3335")
      dns_ssh(params[:dns_ssh_ip])
    end
   crontab_array.push(build_string(params[:dns_ssh_cron],"reverse_ssh_over_DNS.sh"))
  else
   clear_tunnel("reverse_ssh_over_DNS_config.sh","3335")
  end
  #handles icmp script config from post
  if params[:icmp_ssh] == 'on'
    if check_icmp_ssh(params[:icmp_ssh_ip]) != true
      clear_tunnel("reverse_ssh_over_ICMP_config.sh","3339")
      icmp_ssh(params[:icmp_ssh_ip])
    end
    crontab_array.push(build_string(params[:icmp_ssh_cron],"reverse_ssh_over_ICMP.sh"))
  else
   clear_tunnel("reverse_ssh_over_ICMP_config.sh","3339")
  end
  #handles gsm script config from post
 if params[:gsm_ssh] == 'on'
   if check_gsm_ssh(params[:gsm_ssh_ip],param_to_adapter(params[:gsm_ssh_adapter])) != true
      clear_tunnel("reverse_ssh_over_3G_config.sh","3337")
      gsm_ssh(params[:gsm_ssh_ip],param_to_adapter(params[:gsm_ssh_adapter]))
   end
   crontab_array.push(build_string(params[:gsm_ssh_cron],"reverse_ssh_over_3G.sh"))
  else
   clear_tunnel("reverse_ssh_over_3G_config.sh","3337")
  end

#handles Tor ssh script config from post
 if params[:tor_ssh] == 'on'
   if check_tor_ssh(params[:tor_ssh_address]) != true
     clear_tunnel("reverse_ssh_over_Tor_config.sh","3330")
     tor_ssh(params[:tor_ssh_address])
   end
   crontab_array.push(build_string(params[:tor_ssh_cron],"reverse_ssh_over_Tor.sh"))
  else
   clear_tunnel("reverse_ssh_over_Tor_config.sh","3330")
   system("/etc/init.d/tor stop")
  end


 new_commands = crontab_array.join("\n")
 crontab = "/etc/crontab"
 append_to_file(crontab,new_commands)
 @alert = "Reverse shell configuration updated."
 erb :script_form
end

get '/help' do
  @title = "Plugui Help"
  @help_current = "current"
  erb :help
end


end
Rack::Handler::WEBrick.run MyServer, webrick_options

