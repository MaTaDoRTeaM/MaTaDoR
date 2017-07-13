package.path = package.path..';.luarocks/share/lua/5.2/?.lua;.luarocks/share/lua/5.2/?/init.lua'
package.cpath = package.cpath..';.luarocks/lib/lua/5.2/?.so'
bot_token = "418516842:AAHlHyfOpUKIikXWO-ai5JXwMC08CiSv7Kw" --Put You Token Here
send_api = "https://api.telegram.org/bot"..bot_token
sudo_id = 377450049
require('./bot/methods')
require('./bot/utils')
require('./libs/JSON')
http = require('socket.http')
https = require('ssl.https')
URL = require('socket.url')
redis = (loadfile "./libs/redis.lua")()
json = (loadfile "./libs/JSON.lua")()
JSON = (loadfile "./libs/dkjson.lua")()
serpent = (loadfile "./libs/serpent.lua")()
function bot_run()
	bot = nil
	while not bot do
		bot = send_req(send_api.."/getMe")
	end
	bot = bot.result
	local runlog = bot.first_name.." [@"..bot.username.."]\nis run in: "..os.date("%F - %H:%M:%S")
	print(runlog)
	send_msg(sudo_id, runlog)
	last_update = last_update or 0
	last_cron = last_cron or os.time()
	startbot = true
end

function send_req(url)
	local dat, res = https.request(url)
	local tab = JSON.decode(dat)
	if res ~= 200 then return false end
	if not tab.ok then return false end
	return tab
end

function bot_updates(offset)
	local url = send_api.."/getUpdates?timeout=10"
	if offset then
		url = url.."&offset="..offset
	end
	return send_req(url)
end

function load_data(filename)
	local f = io.open(filename)
	if not f then
		return {}
	end
	local s = f:read('*all')
	f:close()
	local data = JSON.decode(s)
	return data
end

function save_data(filename, data)
	local s = JSON.encode(data)
	local f = io.open(filename, 'w')
	f:write(s)
	f:close()
end

function msg_valid(msg)
	local msg_time = os.time() - 60
	if msg.date < tonumber(msg_time) then
		print('\27[36m》》OLD MESSAGE《《\27[39m')
		return false
	end
    return true
end

-- Returns a table with matches or nil
function match_pattern(pattern, text, lower_case)
  if text then
    local matches = {}
    if lower_case then
      matches = { string.match(text:lower(), pattern) }
    else
      matches = { string.match(text, pattern) }
    end
      if next(matches) then
        return matches
      end
  end
  -- nil
end
  plugins = {}
function match_plugins(msg)
  for name, plugin in pairs(plugins) do
    match_plugin(plugin, name, msg)
  end
end

function match_plugin(plugin, plugin_name, msg)

  -- Go over patterns. If one matches it's enough.
if plugin.pre_process then
        --If plugin is for privileged users only
		local result = plugin.pre_process(msg)
		if result then
			print("pre process: ", plugin_name)
		end
	end
  for k, pattern in pairs(plugin.patterns) do
    local matches = match_pattern(pattern, msg.text or msg.caption or msg.query)
    if matches then
      print("msg matches: ", pattern)
      -- Function exists
      if plugin.run then
        -- If plugin is for privileged users only
          local result = plugin.run(msg, matches)
          if result then
            send_msg(msg.chat.id, result, msg.message_id, "md")
        end
      end
      -- One patterns matches
      return
    end
  end
end
local function handle_inline_keyboards_cb(msg)
  msg.text = '###cb:'..msg.data
  msg.cb = true
if msg.message then
  msg.old_text = msg.message.text
  msg.old_date = msg.message.date
  msg.message_id = msg.message.message_id
  msg.chat = msg.message.chat
  msg.message_id = msg.message.message_id
  msg.chat = msg.message.chat
else -- if keyboard send via
			msg.chat = {type = 'inline', id = msg.from.id, title = msg.from.first_name}
			msg.message_id = msg.inline_message_id
    end
  msg.cb_id = msg.id
  msg.date = os.time()
  msg.message = nil
  msg.target_id = msg.data:match('.*:(-?%d+)')
  return get_var(msg)
end
-- Save the content of _config to config.lua
function save_config( )
  serialize_to_file(_config, './data/config.lua')
  print ('saved config into ./data/config.lua')
end

-- Create a basic config.json file and saves it.
function create_config( )
	local server_user = io.popen("whoami"):read('*a')
	server_user = string.gsub(server_user, '^%s+', '')
	server_user = string.gsub(server_user, '%s+$', '')
	server_user = string.gsub(server_user, '[\n\r]+', ' ') 
	if server_user:match("^root$") then
		MaTaDoRTeaM = '/root/MaTaDoR/cli'
	elseif not server_user:match("^root$") then
		MaTaDoRTeaM = '/home/'..server_user..'/MaTaDoR/cli'
	end
  -- A simple config with basic plugins and ourselves as privileged user
  config = {
    enabled_plugins = {
    "core",
    "plugins"
    },
    sudo_users = {377450049,00000000},--Sudo users
    admins = {},
    disabled_channels = {},
    moderation = {data = ''..MaTaDoRTeaM..'/data/moderation.json'},
    info_text = [[
*》MaTaDoR Helper Bot V1*
	
》[MaTaDoR Helper](https://github.com/MaTaDoRTeam/MaTaDoR)

*》Admins :*
*》Founder & Developer :* [MahDiRoO](Telegram.Me/mahdiroo)
_》Developer :_ [JaVaD](Telegram.Me/javadsudo)
_》Developer & Sponser :_ [MAKAN](Telegram.Me/shaniloop)

*》Special thanks to :*
》[Xamarin](Telegram.Me/xamarin_developer)

*》Our channel :*
》[MaTaDoRTeaM](Telegram.Me/matadorTeam)
]],
  }
  serialize_to_file(config, './data/config.lua')
  print('saved config into ./data/config.lua')
end

-- Returns the config from config.lua file.
-- If file doesn't exist, create it.
function load_config( )
  local f = io.open('./data/config.lua', "r")
  -- If config.lua doesn't exist
  if not f then
    print ("Created new config file: data/config.lua")
    create_config()
  else
    f:close()
  end
  local config = loadfile ("./data/config.lua")()
  for v,user in pairs(config.sudo_users) do
    print("Sudo user: " .. user)
  end
  return config
end
_config = load_config( )

-- Enable plugins in config.json
function load_plugins()
  for k, v in pairs(_config.enabled_plugins) do
    print("Loading plugin", v)

    local ok, err =  pcall(function()
      local t = loadfile("plugins/"..v..'.lua')()
      plugins[v] = t
    end)

    if not ok then
      print('\27[31mError loading plugin '..v..'\27[39m')
	  print(tostring(io.popen("lua plugins/"..v..".lua"):read('*all')))
      print('\27[31m'..err..'\27[39m')
    end

  end
end

bot_run()
load_plugins()
while startbot do
	local res = bot_updates(last_update+1)
	if res then
		for i,v in ipairs(res.result) do
			last_update = v.update_id
			if v.edited_message then
				get_var(v.edited_message)
			elseif v.message then
          if msg_valid(v.message) then
				get_var(v.message)
          end
    elseif v.inline_query then
				get_var_inline(v.inline_query)
      elseif v.callback_query then
handle_inline_keyboards_cb(v.callback_query)
			end
		end
	else
		print("error while")
	end
	if last_cron < os.time() - 30 then
  for name, plugin in pairs(plugins) do
		if plugin.cron then
			local res, err = pcall(
				function()
					plugin.cron()
				end
        
			)
      end
			if not res then print('error: '..err) end
		end
		last_cron = os.time()
	end
end

