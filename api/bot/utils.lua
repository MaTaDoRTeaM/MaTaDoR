local clock = os.clock
function sleep(time)  -- seconds
  local t0 = clock()
  while clock() - t0 <= time do end
end

function scandir(directory)
  local i, t, popen = 0, {}, io.popen
  for filename in popen('ls -a "'..directory..'"'):lines() do
    i = i + 1
    t[i] = filename
  end
  return t
end

function plugins_names( )
  local files = {}
  for k, v in pairs(scandir("plugins")) do
    -- Ends with .lua
    if (v:match(".lua$")) then
      table.insert(files, v)
    end
  end
  return files
end

function is_sudo(msg)
  local var = false
  -- Check users id in config
  for v,user in pairs(_config.sudo_users) do
    if user == msg.from.id then
      var = true
    end
  end
  return var
end

function is_owner(msg)
  local var = false
  local data = load_data(_config.moderation.data)
  local user = msg.from.id
  if data[tostring(msg.chat.id)] then
    if data[tostring(msg.chat.id)]['owners'] then
      if data[tostring(msg.chat.id)]['owners'][tostring(msg.from.id)] then
        var = true
      end
    end
  end

  for v,user in pairs(_config.admins) do
    if user[1] == msg.from.id then
      var = true
  end
end

  for v,user in pairs(_config.sudo_users) do
    if user == msg.from.id then
        var = true
    end
  end
  return var
end

function is_admin(msg)
  local var = false
  local user = msg.from.id
  for v,user in pairs(_config.admins) do
    if user[1] == msg.from.id then
      var = true
  end
end

  for v,user in pairs(_config.sudo_users) do
    if user == msg.from.id then
        var = true
    end
  end
  return var
end

--Check if user is the mod of that group or not
function is_mod(msg)
  local var = false
  local data = load_data(_config.moderation.data)
  local usert = msg.from.id
  if data[tostring(msg.chat.id)] then
    if data[tostring(msg.chat.id)]['mods'] then
      if data[tostring(msg.chat.id)]['mods'][tostring(msg.from.id)] then
        var = true
      end
    end
  end

  if data[tostring(msg.chat.id)] then
    if data[tostring(msg.chat.id)]['owners'] then
      if data[tostring(msg.chat.id)]['owners'][tostring(msg.from.id)] then
        var = true
      end
    end
  end

  for v,user in pairs(_config.admins) do
    if user[1] == msg.from.id then
      var = true
  end
end

  for v,user in pairs(_config.sudo_users) do
    if user == msg.from.id then
        var = true
    end
  end
  return var
end

function is_sudo1(user_id)
  local var = false
  -- Check users id in config
  for v,user in pairs(_config.sudo_users) do
    if user == user_id then
      var = true
    end
  end
  return var
end

function is_owner1(chat_id, user_id)
  local var = false
  local data = load_data(_config.moderation.data)
  local user = user_id
  if data[tostring(chat_id)] then
    if data[tostring(chat_id)]['owners'] then
      if data[tostring(chat_id)]['owners'][tostring(user)] then
        var = true
      end
    end
  end

  for v,user in pairs(_config.admins) do
    if user[1] == user_id then
      var = true
  end
end

  for v,user in pairs(_config.sudo_users) do
    if user == user_id then
        var = true
    end
  end
  return var
end

function is_admin1(user_id)
  local var = false
  local user = user_id
  for v,user in pairs(_config.admins) do
    if user[1] == user_id then
      var = true
  end
end

  for v,user in pairs(_config.sudo_users) do
    if user == user_id then
        var = true
    end
  end
  return var
end

--Check if user is the mod of that group or not
function is_mod1(chat_id, user_id)
  local var = false
  local data = load_data(_config.moderation.data)
  local usert = user_id
  if data[tostring(chat_id)] then
    if data[tostring(chat_id)]['mods'] then
      if data[tostring(chat_id)]['mods'][tostring(usert)] then
        var = true
      end
    end
  end

  if data[tostring(chat_id)] then
    if data[tostring(chat_id)]['owners'] then
      if data[tostring(chat_id)]['owners'][tostring(usert)] then
        var = true
      end
    end
  end

  for v,user in pairs(_config.admins) do
    if user[1] == user_id then
      var = true
  end
end

  for v,user in pairs(_config.sudo_users) do
    if user == user_id then
        var = true
    end
  end
  return var
end

function is_filter(msg, text)
local var = false
local data = load_data(_config.moderation.data)
  if data[tostring(msg.chat.id)]['filterlist'] then
for k,v in pairs(data[tostring(msg.chat.id)]['filterlist']) do 
    if string.find(string.lower(text), string.lower(k)) then
       var = true
        end
     end
  end
 return var
end
function is_banned(user_id, chat_id)
  local var = false
  local data = load_data(_config.moderation.data)
  if data[tostring(chat_id)] then
    if data[tostring(chat_id)]['banned'] then
      if data[tostring(chat_id)]['banned'][tostring(user_id)] then
        var = true
      end
    end
  end
return var
end

 function is_silent_user(user_id, chat_id)
  local var = false
  local data = load_data(_config.moderation.data)
  if data[tostring(chat_id)] then
    if data[tostring(chat_id)]['is_silent_users'] then
      if data[tostring(chat_id)]['is_silent_users'][tostring(user_id)] then
        var = true
      end
    end
  end
return var
end

function get_var_inline(msg)
if msg.query then
if msg.query:match("-%d+") then
msg.chat = {}
msg.chat.id = "-"..msg.query:match("%d+")
    end
elseif not msg.query then
msg.chat.id = msg.chat.id
end

match_plugins(msg)
end
function get_var(msg)
msg.reply = {}
msg.fwd_from = {}
 msg.data = {}
msg.id = msg.message_id
if msg.reply_to_message then
msg.reply_id = msg.reply_to_message.message_id
msg.reply.id = msg.reply_to_message.from.id
if msg.reply_to_message.from.last_name then
msg.reply.print_name = msg.reply_to_message.from.first_name..' '..msg.reply_to_message.from.last_name
else
msg.reply.print_name = msg.reply_to_message.from.first_name
end
msg.reply.first_name = msg.reply_to_message.from.first_name
msg.reply.last_name = msg.reply_to_message.from.last_name
msg.reply.username = msg.reply_to_message.from.username
end
if msg.from.last_name then
msg.from.print_name = msg.from.first_name..' '..msg.from.last_name
else
msg.from.print_name = msg.from.first_name
end
if msg.forward_from then
msg.fwd_from.id = msg.forward_from.id
msg.fwd_from.first_name = msg.forward_from.first_name
msg.fwd_from.last_name = msg.forward_from.last_name
if msg.forward_from.last_name then
msg.fwd_from.print_name = msg.forward_from.first_name..' '..msg.forward_from.last_name
else
msg.fwd_from.print_name = msg.forward_from.first_name
end
msg.fwd_from.username = msg.forward_from.username
end
match_plugins(msg)
end
