require 'net/http'
require 'json'
require 'digest/md5'
require 'digest/sha1'
require 'json'


def http_get(url)
	Net::HTTP.get(URI(url)) 
end
def http_post(url,postdata)
	Net::HTTP.post_form(URI(url),postdata).body
end
def get_timestamp()
	json = JSON.parse http_get("https://api.submail.cn/service/timestamp.json")
	json["timestamp"]
end

def create_signatrue(request,config)
	appkey = config["appkey"]
	appid = config["appid"]
	signtype = config["signtype"]
	request["sign_type"] = signtype
	keys = request.keys.sort
	values = []
	keys.each do |k|
		values << "%s=%s"%[k,request[k]]
	end
	signstr = "%s%s%s%s%s"%[appid,appkey, values.join('&'),appid, appkey]
	puts signstr
	if signtype == "normal"
		appkey
	elsif signtype == "md5"
		Digest::MD5.hexdigest(signstr)
	else
		Digest::SHA1.hexdigest(signstr)
	end
end

class MailSend
	def initialize(config)
		@to = []
		@addressbook = []
		@from = ""
		@fromname = ""
		@reply = ""
		@cc = []
		@bcc = []
		@subject = ""
		@text = ""
		@html = ""
		@vars ={}
		@links = {}
		@headers = {}
		@config = config
	end
	def add_to(address, name)
		to = {}
		to["address"] = address
		to["name"] = name
		@to << to
	end
	def add_addressbook(addressbook)
		@addressbook = []
		@addressbook << addressbook
	end
	def set_sender(from, fromname)
		@from = from
		@fromname = fromname
	end
	def set_reply(reply)
		@reply = reply
	end
	def add_cc(address, name)
		cc = {}
		cc["address"] = address
		cc["name"] = name
		@cc << cc
	end

	def add_bcc(address, name)
		bcc = {}
		bcc["address"] = address
		bcc["name"] = name
		@bcc << bcc
	end
	def set_subject(subject)
		@subject = subject
	end
	def set_text(text)
		@text = text
	end
	def set_html(html)
		@html = html
	end
	def add_var(key, value)
		@vars[key] = value
	end

	def add_link(key, value)
		@links[key] = value
	end

	def add_header(key, value)
		@headers[key] = value
	end
	
	def build_request()
		request = {}
		if @to.length != 0
			to = []
			@to.each do |k| 
				to << "%s<%s>" %[k["name"], k["address"]]
			end
			request["to"] = to.join(",")
		end
		if @addressbook.length != 0
			request["addressbook"] = @addressbook.join(",")
		end
		if @from != ""
			request["from"] = @from
		end
		if @fromname != ""
			request["from_name"] = @fromname
		end
		if @reply != ""
			request["reply"] = @reply
		end
		if @cc.length != 0
			cc = []
			@cc.each do |k| 
				cc << "%s<%s>" %[k["name"], k["address"]]
			end
			request["cc"] = cc.join(",")
		end
		if @bcc.length != 0
			bcc = []
			@bcc.each do |k| 
				bcc << "%s<%s>" %[k["name"], k["address"]]
			end
			request["bcc"] = bcc.join(",")
		end
		if @subject != ""
			request["subject"] = @subject
		end
		if @text != ""
			request["text"] = @text
		end
		if @html != ""
			request["html"] = @html
		end
		if @vars.length != 0
			request["vars"] = JSON.generate @vars
		end
		if @links.length != 0
			request["links"] = JSON.generate @links
		end
		
		if @headers.length != 0
			request["headers"] = JSON.generate @headers
		end
		request
	end
	def mail_send()
		request = self.build_request()
		url = "https://api.submail.cn/mail/send.json"
		request["appid"] = @config["appid"]
		request["timestamp"] = get_timestamp()
		request["signature"] = create_signatrue(request, @config)
		http_post(url, request)
	end
end
class MailXSend
	def initialize(config)
		@to = []
		@addressbook = []
		@from = ""
		@fromname = ""
		@reply = ""
		@cc = []
		@bcc = []
		@subject = ""
		@project = ""
		@vars ={}
		@links = {}
		@headers = {}
		@config = config
	end
	def add_to(address, name)
		to = {}
		to["address"] = address
		to["name"] = name
		@to << to
	end
	def add_addressbook(addressbook)
		@addressbook = []
		@addressbook << addressbook
	end
	def set_sender(from, fromname)
		@from = from
		@fromname = fromname
	end
	def set_reply(reply)
		@reply = reply
	end
	def add_cc(address, name)
		cc = {}
		cc["address"] = address
		cc["name"] = name
		@cc << cc
	end

	def add_bcc(address, name)
		bcc = {}
		bcc["address"] = address
		bcc["name"] = name
		@bcc << bcc
	end
	def set_subject(subject)
		@subject = subject
	end
	def set_project(project)
		@project = project
	end
	def add_var(key, value)
		@vars[key] = value
	end

	def add_link(key, value)
		@links[key] = value
	end

	def add_header(key, value)
		@headers[key] = value
	end
	
	def build_request()
		request = {}
		if @to.length != 0
			to = []
			@to.each do |k| 
				to << "%s<%s>" %[k["name"], k["address"]]
			end
			request["to"] = to.join(",")
		end
		if @addressbook.length != 0
			request["addressbook"] = @addressbook.join(",")
		end
		if @from != ""
			request["from"] = @from
		end
		if @fromname != ""
			request["from_name"] = @fromname
		end
		if @reply != ""
			request["reply"] = @reply
		end
		if @cc.length != 0
			cc = []
			@cc.each do |k| 
				cc << "%s<%s>" %[k["name"], k["address"]]
			end
			request["cc"] = cc.join(",")
		end
		if @bcc.length != 0
			bcc = []
			@bcc.each do |k| 
				bcc << "%s<%s>" %[k["name"], k["address"]]
			end
			request["bcc"] = bcc.join(",")
		end
		if @subject != ""
			request["subject"] = @subject
		end
		if @project != ""
			request["project"] = @project
		end
		if @vars.length != 0
			request["vars"] = JSON.generate @vars
		end
		if @links.length != 0
			request["links"] = JSON.generate @links
		end
		
		if @headers.length != 0
			request["headers"] = JSON.generate @headers
		end
		request
	end
	def mail_xsend()
		request = self.build_request()
		url = "https://api.submail.cn/mail/xsend.json"
		request["appid"] = @config["appid"]
		request["timestamp"] = get_timestamp()
		request["signature"] = create_signatrue(request, @config)
		http_post(url, request)
	end
end

class MessageXSend
	def initialize(config)
		@to = []
		@addressbook = []
		@project = ""
		@vars ={}
		@config = config
	end
	def add_to(address)
		@to << address
	end
	def add_addressbook(addressbook)
		@addressbook << addressbook
	end
	def set_project(project)
		@project = project
	end
	def add_var(key, value)
		@vars[key] = value
	end
	
	def build_request()
		request = {}
		if @to.length != 0
			request["to"] = @to.join(",")
		end
		if @addressbook.length != 0
			request["addressbook"] = @addressbook.join(",")
		end
		if @project != ""
			request["project"] = @project
		end
		if @vars.length != 0
			request["vars"] = JSON.generate @vars
		end
		request
	end
	def message_xsend()
		request = self.build_request()
		url = "https://api.submail.cn/message/xsend.json"
		request["appid"] = @config["appid"]
		request["timestamp"] = get_timestamp()
		request["signature"] = create_signatrue(request, @config)
		http_post(url, request)
	end
end

class AddressBookMail
	def initialize(config)
		@address = ""
		@target = ""
		@config = config
	end
	def set_address(address,name)
		@address = "%s<%s>" %[name,address]
	end
	
	def set_addressbook(addressbook)
		@target = addressbook
	end

	def build_request()
		request = {}
		if @address != ""
			request["address"] = @address
		end
		if @target != ""
			request["target"] = @target
		end
		request
	end
	def mail_subscribe()
		url = "https://api.submail.cn/addressbook/mail/subscribe.json"
		request = self.build_request()
		request["appid"] = @config["appid"]
		request["timestamp"] = get_timestamp()
		request["signature"] = create_signatrue(request, @config)
		http_post(url, request)
	end
	def mail_unsubscribe()
		url = "https://api.submail.cn/addressbook/mail/unsubscribe.json"
		request = self.build_request()
		request["appid"] = @config["appid"]
		request["timestamp"] = get_timestamp()
		request["signature"] = create_signatrue(request, @config)
		http_post(url, request)
	end
end

class AddressBookMessage
	def initialize(config)
		@address = ""
		@target = ""
		@config = config
	end
	def set_address(address,name)
		@address = "%s<%s>" %[name,address]
	end
	
	def set_addressbook(addressbook)
		@target = addressbook
	end

	def build_request()
		request = {}
		if @address != ""
			request["address"] = @address
		end
		if @target != ""
			request["target"] = @target
		end
		request
	end
	def message_subscribe()
		url = "https://api.submail.cn/addressbook/message/subscribe.json"
		request = self.build_request()
		request["appid"] = @config["appid"]
		request["timestamp"] = get_timestamp()
		request["signature"] = create_signatrue(request, @config)
		http_post(url, request)
	end
	def message_unsubscribe()
		url = "https://api.submail.cn/addressbook/message/unsubscribe.json"
		request = self.build_request()
		request["appid"] = @config["appid"]
		request["timestamp"] = get_timestamp()
		request["signature"] = create_signatrue(request, @config)
		http_post(url, request)
	end
end


