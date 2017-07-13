function send_msg(chat_id, text, reply_to_message_id, markdown)

	local url = send_api .. '/sendMessage?chat_id=' .. chat_id .. '&text=' .. URL.escape(text..'')

	if reply_to_message_id then
		url = url .. '&reply_to_message_id=' .. reply_to_message_id
	end

  if markdown == 'md' or markdown == 'markdown' then
    url = url..'&parse_mode=Markdown'
  elseif markdown == 'html' then
    url = url..'&parse_mode=HTML'
  end

	return send_req(url)

end

 function edit(chat_id, message_id, text, keyboard, markdown)
	
	local url = send_api .. '/editMessageText?chat_id=' .. chat_id .. '&message_id='..message_id..'&text=' .. URL.escape(text..'')
	
	if markdown then
		url = url .. '&parse_mode=Markdown'
	end
	
	url = url .. '&disable_web_page_preview=true'
	
	if keyboard then
		url = url..'&reply_markup='..JSON.encode(keyboard)
	end
	
	return send_req(url)

end
function send(chat_id, text, keyboard, markdown)
	
	local url = send_api.. '/sendMessage?chat_id=' .. chat_id
	
	if markdown then
		url = url .. '&parse_mode=Markdown'
	end
	
	url = url..'&text='..URL.escape(text..'')
	
	url = url..'&reply_markup='..JSON.encode(keyboard)
	
	return send_req(url)

end
function send_document(chat_id, name)
	local send = send_api.."/sendDocument"
	local curl_command = 'curl -s "'..send..'" -F "chat_id='..chat_id..'" -F "document=@'..name..'"'
	return io.popen(curl_command):read("*all")
end

function fwd_msg(chat_id, from_chat_id, message_id)

	local url = send_api .. '/forwardMessage?chat_id=' .. chat_id .. '&from_chat_id=' .. from_chat_id .. '&message_id=' .. message_id

	return send_req(url)

end
function edit_key(chat_id, message_id, reply_markup)
 
 local url = send_api .. '/editMessageReplyMarkup?chat_id=' .. chat_id ..
  '&message_id='..message_id..
  '&reply_markup='..URL.escape(JSON.encode(reply_markup))
 
 return send_req(url)

end
function send_key(chat_id, text, keyboard, reply_to_message_id, markdown)
 
 local url = send_api .. '/sendMessage?chat_id=' .. chat_id
 
	if reply_to_message_id then
		url = url .. '&reply_to_message_id=' .. reply_to_message_id
	end

  if markdown == 'md' or markdown == 'markdown' then
    url = url..'&parse_mode=Markdown'
  elseif markdown == 'html' then
    url = url..'&parse_mode=HTML'
  end
 
 url = url..'&text='..URL.escape(text..'')
 
 url = url..'&disable_web_page_preview=true'
 
	url = url..'&reply_markup='..URL.escape(JSON.encode(keyboard))
 return send_req(url)
end

 function edit_msg(chat_id, message_id, text, keyboard, markdown)
	
	local url = send_api .. '/editMessageText?chat_id=' .. chat_id .. '&message_id='..message_id..'&text=' .. URL.escape(text..'')
	
	if markdown then
		url = url .. '&parse_mode=Markdown'
	end
	
	url = url .. '&disable_web_page_preview=true'
	
	if keyboard then
		url = url..'&reply_markup='..JSON.encode(keyboard)
	end
	
	return send_req(url)

end

 function edit_inline(message_id, text, keyboard)
  local urlk = send_api .. '/editMessageText?&inline_message_id='..message_id..'&text=' .. URL.escape(text..'')
    urlk = urlk .. '&parse_mode=Markdown'
  if keyboard then
    urlk = urlk..'&reply_markup='..URL.escape(json:encode(keyboard))
  end
    return send_req(urlk)
  end

 function get_alert(callback_query_id, text, show_alert)
	
	local url = send_api .. '/answerCallbackQuery?callback_query_id=' .. callback_query_id .. '&text=' .. URL.escape(text)
	
	if show_alert then
		url = url..'&show_alert=true'
	end
	
	return send_req(url)
	
end

function send_inline(inline_query_id, query_id , title , description , text , keyboard)
local results = {{}}
 results[1].id = query_id
results[1].type = 'article'
results[1].description = description
results[1].title = title
results[1].message_text = text..''
  url = send_api .. '/answerInlineQuery?inline_query_id=' .. inline_query_id ..'&results=' .. URL.escape(json:encode(results))..'&parse_mode=Markdown&cache_time=' .. 1
url = send_api .. '&parse_mode=Markdown'
  if keyboard then
   results[1].reply_markup = keyboard
  url = send_api .. '/answerInlineQuery?inline_query_id=' .. inline_query_id ..'&results=' .. URL.escape(json:encode(results))..'&parse_mode=Markdown&cache_time=' .. 1
  end
    return send_req(url)
  end

function edit_key(chat_id, message_id, reply_markup)
	
	local url = send_api .. '/editMessageReplyMarkup?chat_id=' .. chat_id ..
		'&message_id='..message_id..
		'&reply_markup='..URL.escape(JSON.encode(reply_markup))
	
	return send_req(url)

end

function string:input()
	if not self:find(' ') then
		return false
	end
	return self:sub(self:find(' ')+1)
end

function serialize_to_file(data, file, uglify)
  file = io.open(file, 'w+')
  local serialized
  if not uglify then
    serialized = serpent.block(data, {
        comment = false,
        name = '_'
      })
  else
    serialized = serpent.dump(data)
  end
  file:write(serialized)
  file:close()
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

function check_markdown(text) --markdown escape ( when you need to escape markdown , use it like : check_markdown('your text')
		str = text
		if str:match('_') then
			output = str:gsub('_',[[\_]])
		elseif str:match('*') then
			output = str:gsub('*','\\*')
		elseif str:match('`') then
			output = str:gsub('`','\\`')
		else
			output = str
		end
	return output
end

function getChatMember(chat_id, user_id)
 local url = send_api .. '/getChatMember?chat_id=' .. chat_id .. '&user_id=' .. user_id
   return send_req(url)
end

function leave_group(chat_id)
  local url = send_api .. '/leaveChat?chat_id=' .. chat_id
  return send_req(url)
end

function del_msg(chat_id, message_id)
local url = send_api..'/deletemessage?chat_id='..chat_id..'&message_id='..message_id
return send_req(url)
end
function kick_user(user_id, chat_id)
local url = send_api .. '/kickChatMember?chat_id=' .. chat_id .. '&user_id=' .. user_id
return send_req(url)
end
