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



def writescript(file,script)
	scripts_dir = '/var/pwnplug/script_configs/'
	f = File.open(scripts_dir + file,"w")
	f.write(script)
	f.close
end

def tcp_ssh(ip,port)
	filename = "reverse_ssh_config.sh"
	script   = "SSH_receiver=#{ ip }\nSSH_receiver_port=#{ port }\n"
	writescript(filename,script)
end

def check_tcp_ssh(ip,port)
	filename = "reverse_ssh_config.sh"
	script   = "SSH_receiver=#{ ip }\nSSH_receiver_port=#{ port }\n"
	if `cat filename` == script
  	true
  end
end

def http_ssh(ip)
	filename = "reverse_ssh_over_HTTP_config.sh"
	script   = "HTTPtunnel_receiver=#{ ip }\n"
	writescript(filename,script)
end

def check_http_ssh(ip)
	filename = "reverse_ssh_over_HTTP_config.sh"
	script   = "HTTPtunnel_receiver=#{ ip }\n"
	if `cat filename` == script
  	true
  end
end

def ssl_ssh(ip)
	filename = "reverse_ssh_over_SSL_config.sh"
	script   = "stunnel_receiver=#{ ip  }\n"
	writescript(filename,script)
end

def check_ssl_ssh(ip)
	filename = "reverse_ssh_over_SSL_config.sh"
	script   = "stunnel_receiver=#{ ip  }\n"
	if `cat filename` == script
  	true
  end
end

def dns_ssh(ip)
	filename = "reverse_ssh_over_DNS_config.sh"
	script	 = "DNStunnel_receiver=#{ ip }\n"
	writescript(filename,script)
end

def check_dns_ssh(ip)
	filename = "reverse_ssh_over_DNS_config.sh"
	script	 = "DNStunnel_receiver=#{ ip }\n"
	if `cat filename` == script
  	true
  end
end


def icmp_ssh(ip)
	filename = "reverse_ssh_over_ICMP_config.sh"
	script   = "SSH_receiver=#{ ip }\n"
	writescript(filename,script)
end

def check_icmp_ssh(ip)
	filename = "reverse_ssh_over_ICMP_config.sh"
	script   = "SSH_receiver=#{ ip }\n"
	if `cat filename` == script
  	true
  end
end

def gsm_ssh(ip,adapter)
	filename = "reverse_ssh_over_3G_config.sh"
	script   = "PPP_peer=#{ adapter }\nSSH_receiver=#{ ip }\n"
	writescript(filename,script)
end

def check_gsm_ssh(ip,adapter)
	filename = "reverse_ssh_over_3G_config.sh"
	script   = "PPP_peer=#{ adapter }\nSSH_receiver=#{ ip }\n"
	if `cat filename` == script
  	true
  end
end

# addition for SSH over Tor
def tor_ssh(address)
        filename = "reverse_ssh_over_Tor_config.sh"
        script   = "Tor_receiver=#{ address }\n"
        writescript(filename,script)
end

def check_tor_ssh(address)
        filename = "reverse_ssh_over_Tor_config.sh"
        script   = "Tor_receiver=#{ address }\n"
        if `cat filename` == script
        true
  end
end





#the following method deals with writing the SMS config file
def sms_config(sms_recipient,sms_sender,smtp_server,smtp_auth_user,smtp_auth_password,smtp_tls,msg_subject,msg_body)
  filename = "sms_message_config.sh"
  script   = "sms_recipient=#{sms_recipient}\nsms_sender=#{sms_sender}\nsmtp_server=#{smtp_server}\nsmtp_auth_user=#{smtp_auth_user}\nsmtp_auth_password=#{smtp_auth_password}\nsmtp_tls=#{smtp_tls}\nmsg_subject=#{msg_subject}\nmsg_body=#{msg_body}\n"
 	writesms(filename,script)
end

def check_sms_tls(value)
  current = call_value('smtp_tls','sms_message_config.sh')
  if current == value
    "selected=\"selected\""
  else
    ""
  end  
end

def writesms(file,script)
	scripts_dir = '/var/pwnplug/script_configs/'
	f = File.open(scripts_dir + file,"w")
	f.write(script)
	f.close
end

# evil ap config writer
def evil_config(ssid)
  filename = "evilap_config.sh"
	script   = "ssid=#{ssid}\n"
	write_evil(filename,script)
end

def write_evil(file,script)
  scripts_dir = '/var/pwnplug/script_configs/'
	f = File.open(scripts_dir + file,"w")
	f.write(script)
	f.close
end

# these next methods deal with rewriting the /etc/crontab file
def param_to_cron(param)
  if param == "Every Minute"
    "* * * * *"
  elsif param == "Every 5 Minutes"
    "*/5 * * * *"
  elsif param == "Every 15 Minutes"
    "*/15 * * * *"
  elsif param == "Every 60 Minutes"
    "0 * * * *"
  else
    "* * * * *"
  end
end

def cron_timer_options(name,script)
	out = "<p>\n<select name=\"" +
	 name + 
	 "\">\n<option " + 
	 selected_cron_timer(script,'*') + 
	 "\" name=\"Every Minute\">Every Minute</option>\n<option "+ 
	 selected_cron_timer(script,'*/5') + 
	 "\" name=\"Every 5 Minutes\">Every 5 Minutes</option>\n<option "+ 
	 selected_cron_timer(script,'*/15') + 
	 "\" name=\"Every 15 Minutes\">Every 15 Minutes</option>\n<option "+ 
	 selected_cron_timer(script,'0') +
	 "\" name=\"Every 60 Minutes\">Every 60 Minutes</option>\n</select>\n</p>"
    out
end

def selected_cron_timer(file,timer)
  if `grep "#{ file }" /etc/crontab | awk '{print$1}'`.chomp == timer
     'selected="selected"'
  else
    ""
  end
end

def check_cron_make_checked(file)
  if `grep -o "#{ file }" /etc/crontab`.chomp == "#{ file }"
    'checked="checked"'
  end
end

#convert the 3G/GSM adapter options to a valid input
def param_to_adapter(param)
  if param == "Unlocked GSM"
    "e160"
  elsif param == "Verizon/Virgin Mobile"
    "1xevdo"
  else
    "e160"
  end
end

def build_string(timer,command)
	cron = param_to_cron(timer)
	string = cron + " root /var/pwnplug/scripts/" + command
	string
end

def append_to_file(file,string)
	delimiter = "### DO NOT EDIT THIS LINE OR BELOW\n"
	#check for delimiter
	if `cat #{file} | grep #{delimiter}` == ""
	  `echo #{delimiter} >> #{file}`
	end
	write_file = File.open(file,'r')
	write_file_string = write_file.read
	write_file.close

	write_file_array = write_file_string.split(delimiter)
	write_file_array.pop
	write_file_array.push(string)
	
	write_file_new = File.open(file,'w')
	joined_string = write_file_array.join(delimiter)
	write_file_new.write(joined_string+"\n")
	write_file_new.close
end

#use to $ `ps ax | grep $command` to see if command is running
def is_running(port)
  command = `ps ax |grep -v grep |grep -o "ssh -NR #{port}"`
  if command != ""
    "Connected to SSH receiver on localhost:" + port + " ."
  else
    "Not Running"
  end
end

def call_value(variable,file)
  script = "/var/pwnplug/script_configs/" + file
  `grep "#{variable}" #{script} | awk -F"=" '{print$2}'`
end


def selected_adapter(adapter)
  if `grep -o "#{ adapter }" /var/pwnplug/script_configs/reverse_ssh_over_3G_config.sh` != ""
    'selected="selected"'
  end
end



def clear_tunnel(script_config,process)
  config_file = "/var/pwnplug/script_configs/" + script_config
	`echo " " > #{ config_file }`
  `for pid in \`ps ax |grep -v grep |grep "ssh -NR #{ process }" | awk '{print $1}'\`; do kill -9 $pid; done`
end
