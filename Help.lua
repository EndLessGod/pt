local URL = require "socket.url"
local https = require "ssl.https"
local serpent = require "serpent"
_Config = dofile('./Config.lua')
local json = (loadfile "./libs/JSON.lua")()
local token = _Config.token
local url = 'https://api.telegram.org/bot' .. token
local offset = 0
local redis = require('redis')
local redis = redis.connect('127.0.0.1', 6379)
local SUDO = _Config.SUDO
local Sudousernameapi = _Config.Sudousernameapi
local Channelusernameapi = _Config.Channelusernameapi
local Botusernameapi = _Config.Botusernameapi
local salechannelbot = _Config.salechannelbot
bot = dofile('./utils.lua')
function is_mod(chat,user)
local sudoapibot = _Config.sudoapibot
  local var = false
  for v,_user in pairs(sudoapibot) do
    if _user == user then
      var = true
    end
  end
 local hash = redis:sismember('OwnerList:'..chat,user)
 if hash then
 var = true
 end
 local hash2 = redis:sismember('ModList:'..chat,user)
 if hash2 then
 var = true
 end
 return var
 end
local function getUpdates()
  local response = {}
  local success, code, headers, status  = https.request{
    url = url .. '/getUpdates?timeout=20&limit=1&offset=' .. offset,
    method = "POST",
    sink = ltn12.sink.table(response),
  }

  local body = table.concat(response or {"no response"})
  if (success == 1) then
    return json:decode(body)
  else
    return nil, "Request Error"
  end
end

function vardump(value)
  print(serpent.block(value, {comment=false}))
end

function sendmsg(chat,text,keyboard)
if keyboard then
urlk = url .. '/sendMessage?chat_id=' ..chat.. '&text='..URL.escape(text)..'&parse_mode=html&reply_markup='..URL.escape(json:encode(keyboard))
else
urlk = url .. '/sendMessage?chat_id=' ..chat.. '&text=' ..URL.escape(text)..'&parse_mode=html'
end
https.request(urlk)
end
 function edit( message_id, text, keyboard)
  local urlk = url .. '/editMessageText?&inline_message_id='..message_id..'&text=' .. URL.escape(text)
    urlk = urlk .. '&parse_mode=Markdown'
  if keyboard then
    urlk = urlk..'&reply_markup='..URL.escape(json:encode(keyboard))
  end
    return https.request(urlk)
  end
function Canswer(callback_query_id, text, show_alert)
	local urlk = url .. '/answerCallbackQuery?callback_query_id=' .. callback_query_id .. '&text=' .. URL.escape(text)
	if show_alert then
		urlk = urlk..'&show_alert=true'
	end
  https.request(urlk)
	end
  function answer(inline_query_id, query_id , title , description , text , keyboard)
  local results = {{}}
         results[1].id = query_id
         results[1].type = 'article'
         results[1].description = description
         results[1].title = title
         results[1].message_text = text
  urlk = url .. '/answerInlineQuery?inline_query_id=' .. inline_query_id ..'&results=' .. URL.escape(json:encode(results))..'&parse_mode=Markdown&cache_time=' .. 1
  if keyboard then
   results[1].reply_markup = keyboard
  urlk = url .. '/answerInlineQuery?inline_query_id=' .. inline_query_id ..'&results=' .. URL.escape(json:encode(results))..'&parse_mode=Markdown&cache_time=' .. 1
  end
    https.request(urlk)
  end
function settings(chat,value) 
local hash = SUDO..'settings:'..chat..':'..value
  if value == 'file' or value == 'فایل' then
      text = 'فیلتر فایل'
   elseif value == 'inline' or value == 'اینلاین' or value == 'کیبرد شیشه ای' then
    text = 'فیلتردرون خطی(کیبرد شیشه ای)'
  elseif value == 'link' or value == 'لینک' then
    text = 'قفل ارسال لینک(تبلیغات)'
  elseif value == 'inlinegame' or value == 'بازی اینلاین' then
    text = 'فیلتر انجام بازی های(inline)'
    elseif value == 'username' or value == 'یوزرنیم' then
    text = 'قفل ارسال یوزرنیم(@)'
    elseif value == 'photo' or value == 'تصاویر' or value == 'عکس' then
    text = 'فیلتر تصاویر'
    elseif value == 'gif' or value == 'گیف' or value == 'تصاویر متحرک' then
    text = 'فیلتر تصاویر متحرک'
    elseif value == 'video' or value == 'ویدئو' or value == 'فیلم' then
    text = 'فیلتر ویدئو'
    elseif value == 'audio' or value == 'صدا' or value == 'ویس' then
    text = 'فیلتر صدا(audio-voice)'
    elseif value == 'music'or value == 'آهنگ'  then
    text = 'فیلتر آهنگ(MP3)'
    elseif value == 'text' or value == 'متن' then
    text = 'فیلتر متن'
    elseif value == 'sticker' or value == 'استیکر' or value == 'برچسب' then
    text = 'قفل ارسال برچسب'
    elseif value == 'contact' or value == 'مخاطبین' then
    text = 'فیلتر مخاطبین'
    elseif value == 'forward' or value == 'فوروارد' then
    text = 'فیلتر فوروارد'
    elseif value == 'persian' or value == 'فارسی' then
    text = 'فیلتر گفتمان(فارسی)'
    elseif value == 'english' or value == 'انگلیسی' then
    text = 'فیلتر گفتمان(انگلیسی)'
    elseif value == 'bots' or value == 'ربات' then
    text = 'قفل ورود ربات(API)'
    elseif value == 'tgservice' or value == 'سرویس' then
    text = 'فیلتر پیغام ورود،خروج افراد'
	elseif value == 'forwardchannel' or value == 'فوروارد از کانال' then
    text = 'فیلتر فوروارد مطالب از کانال'
	elseif value == 'viabot' or value == 'ربات اینلاین' then
    text = 'فیلتر استفاده از ربات اینلاین'
	elseif value == 'videoself' or value == 'فیلم سلفی' or value == 'ویدئو سلفی' then
    text = 'فیلتر ویدئو سلفی'
	elseif value == 'location' or value == 'موقعیت مکانی' then
    text = 'فیلتر موقعیت مکانی'
	elseif value == 'edittext' or value == 'ویرایش متن' then
    text = 'فیلتر ویرایش متن'
	elseif value == 'mention' or value == 'منشن' then
    text = 'فیلتر منشن'
	elseif value == 'webpage' or value == 'صفحات اینترنتی' then
    text = 'قفل ارسال صفحات اینترنتی'
	elseif value == 'forwarduser' or value == 'فوروارد کاربر' then 
    text = 'فیلتر فوروارد از کاربر'
	elseif value == 'spamtext' or value == 'متن بلند' then 
    text = 'قفل ارسال پیغام بلند'
    end
		if not text then
		return ''
		end
	if redis:get(hash) then
  redis:del(hash)
return text..'  غیرفعال گردید.'
		else 
		redis:set(hash,true)
return text..'  فعال گردید.'
end
    end
function fwd(chat_id, from_chat_id, message_id)
  local urlk = url.. '/forwardMessage?chat_id=' .. chat_id .. '&from_chat_id=' .. from_chat_id .. '&message_id=' .. message_id
  local res, code, desc = https.request(urlk)
  if not res and code then --if the request failed and a code is returned (not 403 and 429)
  end
  return res, code
end
function sleep(n) 
os.execute("sleep " .. tonumber(n)) 
end
local day = 86400
local daqiqe = 14400
local function run()
  while true do
    local updates = getUpdates()
    vardump(updates)
    if(updates) then
      if (updates.result) then
        for i=1, #updates.result do
          local msg = updates.result[i]
          offset = msg.update_id + 1
          if msg.inline_query then
            local q = msg.inline_query
						if q.from.id == _Config.cliidforpanel or q.from.id == _Config.sudoidforpanel then
            if q.query:match('%d+') then
              local chat = '-'..q.query:match('%d+')
			   local buton = redis:get('botdikme') 
	                      --'..buton..'
							local function is_lock(chat,value)
local hash = SUDO..'settings:'..chat..':'..value
 if redis:get(hash) then
    return true 
    else
    return false
    end
  end
  if redis:hget('sizepanel'..chat,'changepanelsize') == 'desktop' then
              local keyboard = {}
							keyboard.inline_keyboard = {
								{
                {text = '❤️ ['..(redis:scard("nazaryes") or 0)..']', callback_data = 'yvote'..chat},{text = '💔 ['..(redis:scard("nazarno") or 0)..']', callback_data = 'nvote'..chat}
			   
			   },{

				{text = 'فرایند اصلی', callback_data = 'bsd:'..chat} ,{text = 'واحد فروش', callback_data = 'aboute:'..chat}
                },{
				 {text = 'پشتیبانی', callback_data = 'supportbot:'..chat},{text = ''..(buton or "نرخ ربات")..'', callback_data = 'youradds:'..chat}
				  },{
				 {text = 'لیست ها', callback_data = 'groupinfo:'..chat},{text = '🗒راهنما ', callback_data = 'helpbot:'..chat}
				  },{
				 {text = 'تنظیمات ظاهری', callback_data = 'poptions:'..chat}
				 },{
				 {text = 'تنظیم نظرسنجی', callback_data = 'nazarsanji:'..chat}
				 },{
				 {text = '🔚خارج میشم', callback_data = 'cloces:'..chat}
				}
							}
            answer(q.id,'settings','Group settings',chat,'پنل خصوصی کاربر.\nشناسه گروه شما: '..chat..'',keyboard)
			else
			local keyboard = {}
							keyboard.inline_keyboard = {
								{
                {text = '❤️ ['..(redis:scard("nazaryes") or 0)..']', callback_data = 'yvote'..chat},{text = '💔 ['..(redis:scard("nazarno") or 0)..']', callback_data = 'nvote'..chat}
			   
			   },{

				{text = 'فرایند اصلی', callback_data = 'bsd:'..chat} ,{text = 'واحد فروش', callback_data = 'aboute:'..chat}
                },{
				 {text = 'پشتیبانی', callback_data = 'supportbot:'..chat},{text = ''..(buton or "نرخ ربات")..'', callback_data = 'youradds:'..chat}
				  },{
				 {text = 'لیست ها', callback_data = 'groupinfo:'..chat},{text = '🗒راهنما ', callback_data = 'helpbot:'..chat}
				  },{
				 {text = 'تنظیمات ظاهری', callback_data = 'poptions:'..chat}
				 },{
				 {text = 'تنظیم نظرسنجی', callback_data = 'nazarsanji:'..chat}
				 },{
				 {text = '🔚خارج میشم', callback_data = 'cloces:'..chat}
				}
							}
            answer(q.id,'settings','Group settings',chat,'به پنل شیشه ای ربات TeleBoT-V5خوش آمدید!.\nشناسه گروه شما: '..chat..'',keyboard)
			end
            end
            end
						end
          if msg.callback_query then
            local q = msg.callback_query
						local chat = ('-'..q.data:match('(%d+)') or '')
						if is_mod(chat,q.from.id) then
             if q.data:match('_') and not (q.data:match('next_page') or q.data:match('left_page') or q.data:match('mata_gte')) then
                Canswer(q.id,">کانال پشتیبانی:[@"..Channelusername.."]",true)
					elseif q.data:match('lock') then
							local lock = q.data:match('lock (.*)')
			 MUTE_MAX = (redis:get(SUDO..'muteall'..chat) or 0)
			 TIME_MAX = (redis:hget("flooding:settings:"..chat,"floodtime") or 3)
              MSG_MAX = (redis:hget("flooding:settings:"..chat,"floodmax") or 5)
			  NUM_CH_MAX = (redis:get('NUM_CH_MAX:'..chat) or 200)
			  WARN_MAX = (redis:get('Warn:Max:'..chat) or 3)
							local result = settings(chat,lock)
							if lock == 'link'  or lock == 'username' or lock == 'edittext' or lock == 'bots' or lock == 'webpage' or lock == 'mention' then
							q.data = 'left_page:'..chat
							elseif lock == 'muteall' then
								if redis:get('MuteAll:'..chat) then
								redis:del('MuteAll:'..chat)
									--result = "فیلتر تمامی گفتگو ها غیرفعال گردید.\n"
									Canswer(q.id,'فیلتر تمامی گفتگو ها غیرفعال گردید.\nتوضیحات: تمامی افراد محدود شده با ارسال اولین پیغام از سوی شما در گروه رفع محدودیت میگردند.',true)
									else
								redis:set('MuteAll:'..chat,true)
									--result = "فیلتر تمامی گفتگو ها فعال گردید!"
									Canswer(q.id,'فیلتر تمامی گفتگو ها همراه با محدود سازی کاربران فعال گردید!\nتوضیحات: کاربران پس از گفتگو در گروه به لیست افراد محدود از گفتگو اضاف میشوند و توانایی گفتگو از آن ها گرفته میشود.',true)
							end
							--------------------------------
							elseif lock == 'mutealllimit' then
								if redis:get('MuteAlllimit:'..chat) then
								redis:del('MuteAlllimit:'..chat)
									Canswer(q.id,'فیلتر تمامی گفتگو ها غیرفعال گردید.',true)
									else
								redis:set('MuteAlllimit:'..chat,true)
									Canswer(q.id,'فیلتر تمامی گفتگو ها بدون محدود سازی کاربران فعال گردید!\nتوضیحات: در این فیلتر  فقط پیغام کاربران حذف میشود و هیچ کاربری به لیست کاربران محدود افزوده نمیگردد.',true)
							end
						 q.data = 'next_page:'..chat
						 elseif lock == 'spamtext' then
						 q.data = 'mata_gte:'..chat
							elseif lock == 'spam' then
							local hash = redis:hget("flooding:settings:"..chat, "flood")
						if hash then
			if redis:hget("flooding:settings:"..chat, "flood") == 'kick' then
         			spam_status = 'مسدود سازی(کاربر)'
							redis:hset("flooding:settings:"..chat, "flood",'ban')
			  elseif redis:hget("flooding:settings:"..chat, "flood") == 'ban' then
              spam_status = 'سکوت(کاربر)'
			  redis:hset("flooding:settings:"..chat, "flood",'mute')
              elseif redis:hget("flooding:settings:"..chat, "flood") == 'mute' then
              spam_status = 'حذف پیغام(کاربر)'
			  redis:hset("flooding:settings:"..chat, "flood",'delete')
			  elseif redis:hget("flooding:settings:"..chat, "flood") == 'delete' then
              spam_status = '🔓'
							redis:hdel("flooding:settings:"..chat, "flood")
              end
          else
          spam_status = 'اخراج سازی(کاربر)'
					redis:hset("flooding:settings:"..chat, "flood",'kick')
          end
								result = 'عملکرد قفل ارسال هرزنامه : '..spam_status
								q.data = 'mata_gte:'..chat
								elseif lock == 'MSGMAXup' then
								if tonumber(MSG_MAX) == 20 then
									Canswer(q.id,'حداکثر عدد انتخابی برای این قابلیت [20] میباشد!',true)
									else
								MSG_MAX = tonumber(MSG_MAX) + 1
								redis:hset("flooding:settings:"..chat,"floodmax",MSG_MAX)
								q.data = 'mata_gte:'..chat
							  result = MSG_MAX
								end
								elseif lock == 'MSGMAXdown' then
								if tonumber(MSG_MAX) == 2 then
									Canswer(q.id,'حداقل عدد انتخابی مجاز  برای این قابلیت [2] میباشد!',true)
									else
								MSG_MAX = tonumber(MSG_MAX) - 1
								redis:hset("flooding:settings:"..chat,"floodmax",MSG_MAX)
								q.data = 'mata_gte:'..chat
								result = MSG_MAX
							end
								elseif lock == 'TIMEMAXup' then
								if tonumber(TIME_MAX) == 10 then
								Canswer(q.id,'حداکثر عدد انتخابی برای این قابلیت [10] میباشد!',true)
									else
								TIME_MAX = tonumber(TIME_MAX) + 1
								redis:hset("flooding:settings:"..chat ,"floodtime" ,TIME_MAX)
								q.data = 'mata_gte:'..chat
								result = TIME_MAX
									end
								elseif lock == 'TIMEMAXdown' then
								if tonumber(TIME_MAX) == 1 then
									Canswer(q.id,'حداقل عدد انتخابی مجاز  برای این قابلیت [1] میباشد!',true)
									else
								TIME_MAX = tonumber(TIME_MAX) - 1
								redis:hset("flooding:settings:"..chat ,"floodtime" ,TIME_MAX)
								q.data = 'mata_gte:'..chat
								result = TIME_MAX
									end
									-- NUM_CH_MAX = (redis:get('NUM_CH_MAX:'..chat) or 200)
									-----------------------
									elseif lock == 'MSGSPAMMAXup' then
								if tonumber(NUM_CH_MAX) == 4096 then
								Canswer(q.id,'حداکثر عدد انتخابی برای این قابلیت [4096] میباشد!',true)
									else
								NUM_CH_MAX = tonumber(NUM_CH_MAX) + 50
								redis:set('NUM_CH_MAX:'..chat,NUM_CH_MAX)
								q.data = 'mata_gte:'..chat
								result = NUM_CH_MAX
									end
								elseif lock == 'MSGSPAMMAXdown' then
								if tonumber(NUM_CH_MAX) == 100 then
									Canswer(q.id,'حداقل عدد انتخابی مجاز  برای این قابلیت [100] میباشد!',true)
									else
								NUM_CH_MAX = tonumber(NUM_CH_MAX) - 50
								redis:set('NUM_CH_MAX:'..chat,NUM_CH_MAX)
								q.data = 'mata_gte:'..chat
								result = NUM_CH_MAX
									end
									elseif lock == 'WARNMAXup' then
								if tonumber(WARN_MAX) == 20 then
								Canswer(q.id,'حداکثر عدد انتخابی برای این قابلیت [20] میباشد!',true)
									else
								WARN_MAX = tonumber(WARN_MAX) + 1
								redis:set('Warn:Max:'..chat,WARN_MAX)
								q.data = 'mata_gte:'..chat
								result = WARN_MAX
									end
								elseif lock == 'WARNMAXdown' then
								if tonumber(WARN_MAX) == 2 then
									Canswer(q.id,'حداقل عدد انتخابی مجاز  برای این قابلیت [2] میباشد!',true)
									else
								WARN_MAX = tonumber(WARN_MAX) - 1
								redis:set('Warn:Max:'..chat,WARN_MAX)
								q.data = 'mata_gte:'..chat
								result = WARN_MAX
									end
									-----------------------
								elseif lock == 'welcome' then
								local h = redis:get('Welcome:'..chat)
								if h == 'off' or not h then
								redis:set('Welcome:'..chat,'on')
         result = 'ارسال پیام خوش آمدگویی فعال گردید.'
								q.data = 'next_page:'..chat
          else
          redis:set('Welcome:'..chat,'off')
          result = 'ارسال پیام خوش آمدگویی غیرفعال گردید!'
								q.data = 'next_page:'..chat
									end
								else
								q.data = 'next_page:'..chat
								end
							Canswer(q.id,result)
							end
							-------------------------------------------------------------------------
							if q.data:match('firstmenu') then
							local chat = '-'..q.data:match('(%d+)$')
							local buton = redis:get('botdikme') 
	                      --'..buton..'
							local function is_lock(chat,value)
local hash = SUDO..'settings:'..chat..':'..value
 if redis:get(hash) then
    return true 
    else
    return false
    end
  end
  if redis:hget('sizepanel'..chat,'changepanelsize') == 'desktop' then
              local keyboard = {}
							keyboard.inline_keyboard = {
								{
                {text = '❤️ ['..(redis:scard("nazaryes") or 0)..']', callback_data = 'yvote'..chat},{text = '💔 ['..(redis:scard("nazarno") or 0)..']', callback_data = 'nvote'..chat}
			   
			   },{

				{text = 'فرایند اصلی', callback_data = 'bsd:'..chat} ,{text = 'واحد فروش', callback_data = 'aboute:'..chat}
                },{
				 {text = '👥پشتیبانی', callback_data = 'supportbot:'..chat},{text = ''..(buton or "📬نرخ ربات")..'', callback_data = 'youradds:'..chat}
				  },{
				 {text = 'لیست ها', callback_data = 'groupinfo:'..chat},{text = '🗒راهنما ', callback_data = 'helpbot:'..chat}
				  },{
				 {text = 'تنظیمات ظاهری', callback_data = 'poptions:'..chat}
				 },{
				 {text = 'تنظیم نظرسنجی', callback_data = 'nazarsanji:'..chat}
				 },{
				 {text = '🔚خارج میشم', callback_data = 'cloces:'..chat}
				}
							}
            edit(q.inline_message_id,'به بخش اصلی خوش آمدید.\nجهت مدیریت گروه از منوی زیر انتخاب کنید ...\n➖➖➖➖➖➖➖➖➖\nشناسه گروه شما: `'..chat..'`',keyboard)
			else
			local keyboard = {}
							keyboard.inline_keyboard = {
								{
                {text = '❤️ ['..(redis:scard("nazaryes") or 0)..']', callback_data = 'yvote'..chat},{text = '💔 ['..(redis:scard("nazarno") or 0)..']', callback_data = 'nvote'..chat}
			   
			   },{

				{text = 'فرایند اصلی', callback_data = 'bsd:'..chat} ,{text = 'واحد فروش', callback_data = 'aboute:'..chat}
                },{
				 {text = '👥پشتیبانی', callback_data = 'supportbot:'..chat},{text = ''..(buton or "📬نرخ ربات")..'', callback_data = 'youradds:'..chat}
				  },{
				 {text = 'لیست ها', callback_data = 'groupinfo:'..chat},{text = '🗒راهنما ', callback_data = 'helpbot:'..chat}
				  },{
				 {text = 'تنظیمات ظاهری', callback_data = 'poptions:'..chat}
				 },{
				 {text = 'تنظیم نظرسنجی', callback_data = 'nazarsanji:'..chat}
				 },{
				 {text = '🔚خارج میشم', callback_data = 'cloces:'..chat}
				}
							}
							edit(q.inline_message_id,'به بخش اصلی خوش آمدید.\nجهت مدیریت گروه از منوی زیر انتخاب کنید ...\n➖➖➖➖➖➖➖➖➖\nشناسه گروه شما: `'..chat..'`',keyboard)
							end
							end
							------------------------------------------------------------------------
			if q.data:match('supportbot') then
                           local chat = '-'..q.data:match('(%d+)$')
               local helpen = redis:get('supporttext')  
               if helpen then
               local keyboard = {}
              keyboard.inline_keyboard = {
                {
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
        }
              }
              edit(q.inline_message_id, ''..helpen..'',keyboard) 
        else
        local keyboard = {}
              keyboard.inline_keyboard = {
                {
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
        }
              }
        edit(q.inline_message_id,'با عرض پوزش در حال حاضر اپراتور های پاسخگویی ما در دسترس نمیباشند.\nدر روز های آینده مجدد به این بخش مراجعه کنید.',keyboard)
            end
      end
			if q.data:match('cloces') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
							}
              edit(q.inline_message_id,'✅ `پنل کاربری گروه با موفقیت بسته شد.`',keyboard)
            end
			--------------------------------------------------------------------------
			if q.data:match('enchangemenu') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							local keyboard = {}
							keyboard.inline_keyboard = {
								{
                 {text = 'Group Settings', callback_data = 'bsd:'..chat}
                },{
				 {text = 'Support', callback_data = 'supportbot:'..chat},{text = 'Your Ad', callback_data = 'youradds:'..chat}
				  },{
				 {text = 'Group information', callback_data = 'groupinfo:'..chat},{text = 'Help', callback_data = 'helpbot:'..chat}
				 },{
				 {text = '🔄Change language menu > FA', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`Welcome to support section.`\n*Select from the menu below:*',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('youradds') then
                           local chat = '-'..q.data:match('(%d+)$')
						   local adds = redis:get('gpadss')  
							 if adds then
							 local keyboard = {}
							keyboard.inline_keyboard = {
								{
								{text = '📞ثبت سفارش', callback_data = 'sabtsefaresh:'..chat}
                },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id, '\n`'..adds..'`',keyboard) --`مشاهده مطالب زیر به شما پیشنهاد میشود:`\n
			  else
			  local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
			  edit(q.inline_message_id,'`در حال حاضر تبلیغی برای نمایش وجود ندارد.`\nساعاتی دیگر مجدد بررسی کنید.',keyboard)
            end
			end
				if q.data:match('sabtsefaresh') then
				local chat = '-'..q.data:match('(%d+)$')
				Canswer(q.id,'برای ثبت سفارش تبلیغات با شناسه زیر در ارتباط باشید:\n@'..Sudousername..'\nیا در صورتی که با تلگرام نسخه دکستاپ این متن را مشاهده میکنید بر روی لینک زیر کلیک کنید:\nhttps://t.me/'..Sudousername..'',true)
				end
				if q.data:match('tabliqat') then
				local chat = '-'..q.data:match('(%d+)$')
				Canswer(q.id,'برای ثبت تبلیغات خود به صفحه اصلی پنل کاربری گروه و بخش تبلیغات شما مراجعه فرمایید.',true)
				end
				------------------------------------------------------------------------
							------------------------------------------------------------------------
			---************************************************************************--
			---************************************************************************--
			if q.data:match('nazarsanji') then
                           local chat = '-'..q.data:match('(%d+)$')
						   local keyboard = {}
							keyboard.inline_keyboard = {
								{
                  {text = '❤️ ['..(redis:scard("nazaryes") or 0)..']', callback_data = 'yvote'..chat},{text = '💔 ['..(redis:scard("nazarno") or 0)..']', callback_data = 'nvote'..chat}
                },{
				{text = '👀بازبینی نتایج', callback_data = 'dvreset'..chat}
				},{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`آخرین بروزرسانی نتایج در ساعت:` *['..os.date("%X")..']*\n`آیا از عملکرد ربات مدیریت گروه راضی هستید؟`',keyboard)
		--Canswer(q.id,'در حال تکمیل این بخش میباشیم و بزودی فعال میشود...',true)
            end
			if q.data:match('dvreset') then
                           local chat = '-'..q.data:match('(%d+)$')
						   local keyboard = {}
							keyboard.inline_keyboard = {
								{
                  {text = '❤️ ['..(redis:scard("nazaryes") or 0)..']', callback_data = 'yvote'..chat},{text = '💔 ['..(redis:scard("nazarno") or 0)..']', callback_data = 'nvote'..chat}
                },{
				{text = '👀بازبینی نتایج', callback_data = 'nazarsanji'..chat}
				},{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`آخرین بروزرسانی نتایج در ساعت:` *['..os.date("%X")..']*\n`آیا از عملکرد ربات مدیریت گروه راضی هستید؟`',keyboard)
		--Canswer(q.id,'در حال تکمیل این بخش میباشیم و بزودی فعال میشود...',true)
            end
			if q.data:match('yvote') then
                           local chat = '-'..q.data:match('(%d+)$')
						   local q = msg.callback_query
						   if not redis:sismember("nazaryes",q.from.id) and not redis:sismember("nazarno",q.from.id) then
						   redis:sadd("nazaryes",q.from.id)
						   
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              Canswer(q.id,'✅نظر شما با موفقیت ثبت شد.\nبا تشکر از مشارکت شما در نظرسنجی\n\nرای شما: ❤️ ['..(redis:scard("nazaryes") or 0)..']',true)
			  else
			  Canswer(q.id,'⛔️نظر شما از قبل در سیستم ثبت شده است و قادر به تغییر رای خود نمیباشید.',true)
            end
			end
			if q.data:match('nvote') then
                           local chat = '-'..q.data:match('(%d+)$')
						   local q = msg.callback_query
						   if not redis:sismember("nazarno",q.from.id) and not redis:sismember("nazaryes",q.from.id) then
						   redis:sadd("nazarno",q.from.id)
						   
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              Canswer(q.id,'✅نظر شما با موفقیت ثبت شد.\nبا تشکر از مشارکت شما در نظرسنجی\n\nرای شما: 💔 ['..(redis:scard("nazaryes") or 0)..']',true)
			   else
			  Canswer(q.id,'⛔️نظر شما از قبل در سیستم ثبت شده است و قادر به تغییر رای خود نمیباشید.',true)
            end
			end
			---************************************************************************--
							if q.data:match('poptions') then
                           local chat = '-'..q.data:match('(%d+)$')
						   local keyboard = {}
							keyboard.inline_keyboard = {
								{
                  {text = 'تغییر نمایش پنل گروه', callback_data = 'changepanel'..chat}
                --},{
				-- {text = '', callback_data = 'voicehelp:'..chat},{text = '---', callback_data = 'videohelp:'..chat}
                },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`به بخش تنظیمات پنل کاربری گروه خوش آمدید.`\n`از منوی زیر انتخاب کنید:`',keyboard)
		--Canswer(q.id,'در حال تکمیل این بخش میباشیم و بزودی فعال میشود...',true)
            end
							------************************************************************************----
							if q.data:match('changepanel') then
                           local chat = '-'..q.data:match('(%d+)$')
						   if redis:hget('sizepanel'..chat,'changepanelsize') == 'desktop' then
						   panelshow = 'Desktop(نسخه دسکتاپ)'
						   else
						   panelshow = 'Mobile(نسخه موبایل)'
						   end
						   local keyboard = {}
							keyboard.inline_keyboard = {
								{
                  {text = 'نمایش نسخه (Desktop) 🖥', callback_data = 'dpanel'..chat}
                },{
				 {text = 'نمایش نسخه (Mobile) 📱', callback_data = 'mpanel'..chat}
				 },{
				 {text = '🗒راهنما', callback_data = 'hchpanel'..chat}
                },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`به بخش تغییر نمایش پنل کاربری گروه خوش آمدید.`\n`در صورتی که نیاز به راهنمایی بیشتر در این مورد دارید ، دکمه راهنما را لمس کنید.`\n➖➖➖➖➖➖➖➖➖\nحالت نمایش فعلی پنل: `'..panelshow..'`\n`جهت تنظیم از منوی زیر انتخاب فرمایید:`',keyboard)
            end
			if q.data:match('hchpanel') then
				local chat = '-'..q.data:match('(%d+)$')
				Canswer(q.id,'🖊راهنما تغییر نمایش پنل کاربری گروه:\n\nشما میتوانید بر اساس کارکرد خود با هر یک از نسخه های تلگرام (Desktop) یا (Mobile) اقدام به تغییر نمایش پنل کاربری به منظور نمایش بهتر پنل کاربری نمایید.',true)
				end
							if q.data:match('dpanel') then
                           local chat = '-'..q.data:match('(%d+)$')
						   redis:hset('sizepanel'..chat,'changepanelsize','desktop')
							edit(q.inline_message_id,'`در حال تنظیم سایز پنل کاربری`،\nلطفا منتظر بمانید:\n»*│*███*│**10%*',keyboard)
			  sleep(2)
			  edit(q.inline_message_id,'`در حال تنظیم سایز پنل کاربری`،\nلطفا منتظر بمانید:\n»*│*█████*│**25%*',keyboard)
			  sleep(2)
			  edit(q.inline_message_id,'`در حال تنظیم سایز پنل کاربری`،\nلطفا منتظر بمانید:\n»*│*███████*│**44%*',keyboard)
			  sleep(2)
			  edit(q.inline_message_id,'`در حال تنظیم سایز پنل کاربری`،\nلطفا منتظر بمانید:\n»*│*█████████*│**60%*',keyboard)
			  sleep(2)
			  edit(q.inline_message_id,'`در حال تنظیم سایز پنل کاربری`،\nلطفا منتظر بمانید:\n»*│*███████████*│**89%*',keyboard)
			  sleep(2)
			  edit(q.inline_message_id,'`در حال تنظیم سایز پنل کاربری`،\nلطفا منتظر بمانید:\n»*│*█████████████*│**93%*',keyboard)
			  sleep(2)
			  edit(q.inline_message_id,'`در حال تنظیم سایز پنل کاربری`،\nلطفا منتظر بمانید:\n»*│*██████████████*│**100%*',keyboard)
			  sleep(1)
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'✅نمایش پنل کاربری گروه شما به نسخه *(Desktop)* 🖥 با موفقیت تغییر یافت\n`برای اعمال تغییرات بر روی گزینه بازگشت به منوی اصلی کلیک کنید.`',keyboard)
            end
			if q.data:match('mpanel') then
							redis:hset('sizepanel'..chat,'changepanelsize','mobile')
                           local chat = '-'..q.data:match('(%d+)$')
						   edit(q.inline_message_id,'`در حال تنظیم سایز پنل کاربری`،\nلطفا منتظر بمانید:\n»*│*██*│**8%*',keyboard)
			  sleep(2)
			  edit(q.inline_message_id,'`در حال تنظیم سایز پنل کاربری`،\nلطفا منتظر بمانید:\n»*│*███*│**15%*',keyboard)
			  sleep(2)
			  edit(q.inline_message_id,'`در حال تنظیم سایز پنل کاربری`،\nلطفا منتظر بمانید:\n»*│*██████*│**37%*',keyboard)
			  sleep(2)
			  edit(q.inline_message_id,'`در حال تنظیم سایز پنل کاربری`،\nلطفا منتظر بمانید:\n»*│*█████████*│**51%*',keyboard)
			  sleep(2)
			  edit(q.inline_message_id,'`در حال تنظیم سایز پنل کاربری`،\nلطفا منتظر بمانید:\n»*│*███████████*│**72%*',keyboard)
			  sleep(2)
			  edit(q.inline_message_id,'`در حال تنظیم سایز پنل کاربری`،\nلطفا منتظر بمانید:\n»*│*█████████████*│**84%*',keyboard)
			  sleep(2)
			  edit(q.inline_message_id,'`در حال تنظیم سایز پنل کاربری`،\nلطفا منتظر بمانید:\n»*│*██████████████*│**97%*',keyboard)
			  sleep(2)
			  edit(q.inline_message_id,'`در حال تنظیم سایز پنل کاربری`،\nلطفا منتظر بمانید:\n»*│*███████████████*│**100%*',keyboard)
			  sleep(1)
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'✅نمایش پنل کاربری گروه شما به نسخه *(Mobile)* 📱 با موفقیت تغییر یافت\n`برای اعمال تغییرات بر روی گزینه بازگشت به منوی اصلی کلیک کنید.`',keyboard)
            end
							---************************************************************************--
							------------------------------------------------------------------------
							if q.data:match('helpbot') then
                           local chat = '-'..q.data:match('(%d+)$')
						   if redis:hget('sizepanel'..chat,'changepanelsize') == 'desktop' then
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                  {text = 'راهنمای متنی', callback_data = 'helpsmn:'..chat}
                },{
				 {text = 'راهنمای صوتی', callback_data = 'voicehelp:'..chat},{text = 'راهنمای تصویری', callback_data = 'videohelp:'..chat}
                },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`به بخش راهنما خوش آمدید.`\n`از منوی زیر انتخاب کنید:`',keyboard)
			  else
			  local keyboard = {}
							keyboard.inline_keyboard = {
								{
                  {text = 'راهنمای متنی', callback_data = 'helpsmn:'..chat}
                },{
				 {text = 'راهنمای صوتی', callback_data = 'voicehelp:'..chat}
                },{
				{text = 'راهنمای تصویری', callback_data = 'videohelp:'..chat}
				},{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`به بخش راهنما خوش آمدید.`\n`از منوی زیر انتخاب کنید:`',keyboard)
            end
			end
			---------------------------------------
			if q.data:match('helpsmn') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                  {text = '📝 راهنما دستورات', callback_data = 'helptext:'..chat}
				 },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'helpbot:'..chat}
				}
							}
              edit(q.inline_message_id,'`به بخش مشاهده راهنما کارکرد با ربات خوش آمدید`\n`از منوی زیر انتخاب کنید:`',keyboard)
            end
			---------------------------------------
			---------------------------------------
			if q.data:match('helptext') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                  {text = '🇳🇿 راهنما انگلیسی', callback_data = 'helptexten:'..chat},{text = '🇮🇷 راهنما فارسی', callback_data = 'helpfat:'..chat}
				 },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'helpsmn:'..chat}
				}
							}
              edit(q.inline_message_id,'`به بخش راهنمای دستورات خوش آمدید`\n`از منوی زیر نوع نمایش زبان راهنما را انتخاب کنید:`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('helptexten') then
                           local chat = '-'..q.data:match('(%d+)$')
               local helpen = redis:get('helpen')  
               if helpen then
               local keyboard = {}
              keyboard.inline_keyboard = {
                {
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
        }
              }
              edit(q.inline_message_id, '[راهنمای مالکین گروه(اصلی-فرعی)]\n'..helpen..'',keyboard) 
        else
        local keyboard = {}
              keyboard.inline_keyboard = {
                {
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'helptext:'..chat}
        }
              }
        edit(q.inline_message_id,'`متن راهنما برای این بخش ثبت نشده است`\nبا مدیریت ربات در میان بگذارید.',keyboard)
            end
      end
	  ------------------------------------------
	  	if q.data:match('helpfat') then
                           local chat = '-'..q.data:match('(%d+)$')
               local helpfa = redis:get('helpfa')  
               if helpfa then
               local keyboard = {}
              keyboard.inline_keyboard = {
                {
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
        }
              }
              edit(q.inline_message_id, '[راهنمای مالکین گروه(اصلی-فرعی)]\n'..helpfa..'',keyboard) 
        else
        local keyboard = {}
              keyboard.inline_keyboard = {
                {
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'helptext:'..chat}
        }
              }
        edit(q.inline_message_id,'`متن راهنما برای این بخش ثبت نشده است`\nبا مدیریت ربات در میان بگذارید.',keyboard)
            end
      end
			-------------------------------------------------------------------------------------------------------------------------------------------
			if q.data:match('videohelp') then
                           local chat = '-'..q.data:match('(%d+)$')
               local helpen = redis:get('videohelp')  
               if helpen then
               local keyboard = {}
              keyboard.inline_keyboard = {
                {
                  {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'helpbot:'..chat}
        }
              }
              edit(q.inline_message_id, 'به بخش راهنمای تصویری ربات مدیریت گروه خوش آمدید.\n`برای هدایت به مطلب مورد نظر روی عنوان مورد نظر کلیک کنید:`\n'..helpen..'',keyboard) 
        else
        local keyboard = {}
              keyboard.inline_keyboard = {
                {
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
        }
              }
        edit(q.inline_message_id,'> راهنمای تصویری ثبت نشده است.',keyboard)
            end
      end
	  if q.data:match('voicehelp') then
                           local chat = '-'..q.data:match('(%d+)$')
               local helpen = redis:get('voicehelp')  
               if helpen then
               local keyboard = {}
              keyboard.inline_keyboard = {
                {
                  {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'helpbot:'..chat}
        }
              }
              edit(q.inline_message_id, 'به بخش راهنمای صوتی ربات مدیریت گروه خوش آمدید.\n`برای هدایت به مطلب مورد نظر روی عنوان مورد نظر کلیک کنید:`\n'..helpen..'',keyboard) 
        else
        local keyboard = {}
              keyboard.inline_keyboard = {
                {
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
        }
              }
        edit(q.inline_message_id,'> راهنمای صوتی ثبت نشده است.',keyboard)
            end
      end
							------------------------------------------------------------------------
							------------------------------------------------------------------------
							------------------------------------------------------------------------
							if q.data:match('groupinfo') then
                           local chat = '-'..q.data:match('(%d+)$')
						   if redis:hget('sizepanel'..chat,'changepanelsize') == 'desktop' then
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                  {text = '👤⁦لیست مالکین', callback_data = 'ownerlist:'..chat},{text = '👥لیست مدیران', callback_data = 'managerlist:'..chat}
                },{
				 {text = '📃مشاهده قوانین', callback_data = 'showrules:'..chat},{text = '🔖لینک ابرگروه', callback_data = 'slin:'..chat}
				 },{
				 {text = '🚫کاربران مسدود شده', callback_data = 'banlist:'..chat},{text = '🖊کلمات فیلتر شده', callback_data = 'filterlistword:'..chat}
				  },{
				 {text = '🔖کاربران حالت سکوت', callback_data = 'silentlistusers:'..chat},{text = '✅کاربران لیست مجاز', callback_data = 'alloweded:'..chat}
				 },{
				{text = '⏱مدت زمان فیلتر تمامی گفتگوها', callback_data = 'inmutechat:'..chat},{text = '⚠️لیست اخطار ها', callback_data = 'warnsda:'..chat} 
				  },{
				  {text = '🔋شارژ گروه', callback_data = 'szn:'..chat} 
				   },{
				{text = '📍محل تبلیغات شما', callback_data = 'tabliqat'..chat}
                },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`به بخش اطلاعات گروه خوش آمدید.`\n`از منوی زیر انتخاب کنید:`',keyboard)
			  else
			  local keyboard = {}
							keyboard.inline_keyboard = {
								{
                  {text = '👤⁦لیست مالکین', callback_data = 'ownerlist:'..chat}
                },{
				{text = '👥لیست مدیران', callback_data = 'managerlist:'..chat}
				 },{
				 {text = '🔖لینک ابرگروه', callback_data = 'slin:'..chat}
				  },{
				  {text = '📃مشاهده قوانین', callback_data = 'showrules:'..chat}
				   },{
				   {text = '🚫کاربران مسدود شده', callback_data = 'banlist:'..chat}
				    },{
					{text = '🖊کلمات فیلتر شده', callback_data = 'filterlistword:'..chat}
					 },{
					 {text = '✅کاربران لیست مجاز', callback_data = 'alloweded:'..chat}
					 },{
					 {text = '⏱مدت زمان فیلتر تمامی گفتگوها', callback_data = 'inmutechat:'..chat}
					 },{
					  {text = '🔖کاربران حالت سکوت', callback_data = 'silentlistusers:'..chat}
					  },{
					  {text = '⚠️لیست اخطار ها', callback_data = 'warnsda:'..chat} 
					  },{
					  {text = '🛂تنظیمات ادمین ها', callback_data = 'stadmins:'..chat}
					  },{
					  {text = '🔋شارژ گروه', callback_data = 'szn:'..chat}
				 },{
				 {text = '📍محل تبلیغات شما', callback_data = 'tabliqat'..chat}
                },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`به بخش اطلاعات گروه خوش آمدید.`\n`از منوی زیر انتخاب کنید:`',keyboard)
            end
			end
			------------------------------------------------------------------------
			------------------------------------------------------------------------
			if q.data:match('inmutechat') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                  {text = 'مشاهده باقی مانده فیلتر تمامی گفتگوها', callback_data = 'tmuteall:'..chat}
                },{
				 {text = 'تمدید رایگان سرویس خود', callback_data = 'tonv:'..chat}
				 },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id,'`به بخش اطلاعات فیلتر تمامی گفتگوها خوش آمدید.`\n`از منوی زیر انتخاب کنید:`',keyboard)
            end
							if q.data:match('tmuteall') then
                           local chat = '-'..q.data:match('(%d+)$')
						    local time = redis:ttl('MuteAll:'..chat) 
local days = math.floor(time / 86400)
time = time - days * 86400
local hour = math.floor(time /3600)
time = time - hour * 3600
local minute = math.floor(time / 60)
time = time - minute * 60
sec = time
          if tonumber(time) < 0 then
            t = 'فیتلر تمامی گفتگو ها غیرفعال میباشد.'
            else
          t = '`>تا غیرفعال شدن فیلتر تمامی گفتگو ها` ['..hour..'] `ساعت و`  ['..minute..'] `و دقیقه` ['..sec..'] `ثانیه دیگر باقی مانده است.`'
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                  {text = '🔄بروزرسانی میزان فیلتر تمامی گفتگوها', callback_data = 'tremuteall:'..chat}
				 },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id,'`آخرین بروزرسانی در ساعت:` *['..os.date("%X")..']*\n'..t..'',keyboard)
            end
			end
			if q.data:match('tremuteall') then
                           local chat = '-'..q.data:match('(%d+)$')
						     local time = redis:ttl('MuteAll:'..chat) 
local days = math.floor(time / 86400)
time = time - days * 86400
local hour = math.floor(time /3600)
time = time - hour * 3600
local minute = math.floor(time / 60)
time = time - minute * 60
sec = time
          if tonumber(time) < 0 then
            t = 'فیتلر تمامی گفتگو ها غیرفعال میباشد.'
            else
          t = '`>تا غیرفعال شدن فیلتر تمامی گفتگو ها` ['..hour..'] `ساعت و`  ['..minute..'] `و دقیقه` ['..sec..'] `ثانیه دیگر باقی مانده است.`'
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                  {text = '🔄بروزرسانی میزان فیلتر تمامی گفتگوها', callback_data = 'tmuteall:'..chat}
				 },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id,'`آخرین بروزرسانی در ساعت:` *['..os.date("%X")..']*\n'..t..'',keyboard)
            end
			end
			----######################################################-----
			------------------------------------------------------------------------
							if q.data:match('szn') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                  {text = 'مشاهده باقی مانده شارژ گروه', callback_data = 'chargegp:'..chat}
                },{
				 {text = 'تمدید رایگان سرویس خود', callback_data = 'tonv:'..chat}
				 },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id,'`به بخش اطلاعات شارژ گروه خوش آمدید.`\n`از منوی زیر انتخاب کنید:`',keyboard)
            end
			----######################################################-----
			if q.data:match('chargegp') then
                           local chat = '-'..q.data:match('(%d+)$')
						   local ex = redis:ttl("charged:"..chat)
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
							{text = '🔄بروزرسانی میزان شارژ گروه', callback_data = 'upcharge:'..chat}
				   },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'szn:'..chat}
				}
							}
							if ex == -1 then
              edit(q.inline_message_id,'خبر خوش😃\n`طرح دائمی/مادام العمر(نامحدود روز) برای گروه شما فعال شده است و نیاز به تمدید ندارید.`',keyboard)
			  else
			   local time = redis:ttl("charged:"..chat)
local days = math.floor(time / 86400)
time = time - days * 86400
local hour = math.floor(time /3600)
time = time - hour * 3600
local minute = math.floor(time / 60)
time = time - minute * 60
sec = time
		 --edit(q.inline_message_id,'`آخرین بروزرسانی در ساعت:` *['..os.date("%X")..']*\n>تا پایان مدت زمان کارکرد ربات در گروه شما:\n ['..days..'] روز\n ['..hour..'] ساعت\n ['..minute..'] دقیقه\nدیگر باقی مانده است.',keyboard)
		 Canswer(q.id,'آخرین بروزرسانی در ساعت: ['..os.date("%X")..']\n>تا پایان مدت زمان کارکرد ربات در گروه شما:\n ['..days..'] روز\n ['..hour..'] ساعت\n ['..minute..'] دقیقه\nدیگر باقی مانده است.',true)
            end
			end
			if q.data:match('upcharge') then
                           local chat = '-'..q.data:match('(%d+)$')
						   local ex = redis:ttl("charged:"..chat)
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
							{text = '🔄بروزرسانی میزان شارژ گروه', callback_data = 'chargegp:'..chat}
				   },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat} --,{text = 'صفحه قبلی ◀️', callback_data = 'szn:'..chat}
				}
							}
							if ex == -1 then
              edit(q.inline_message_id,'خبر خوش😃\n`طرح دائمی/مادام العمر(نامحدود روز) برای گروه شما فعال شده است و نیاز به تمدید ندارید.`',keyboard)
			  else
			   local time = redis:ttl("charged:"..chat)
local days = math.floor(time / 86400)
time = time - days * 86400
local hour = math.floor(time /3600)
time = time - hour * 3600
local minute = math.floor(time / 60)
time = time - minute * 60
sec = time
		 edit(q.inline_message_id,'`آخرین بروزرسانی در ساعت:` *['..os.date("%X")..']*\n>تا پایان مدت زمان کارکرد ربات در گروه شما:\n ['..days..'] روز\n ['..hour..'] ساعت\n ['..minute..'] دقیقه\nدیگر باقی مانده است.',keyboard)
            end
			end
			--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--
			if q.data:match('hadiye') then
			local chat = '-'..q.data:match('(%d+)$')
			local codegift = {"604800","518400","691200","1296000","1036800","432000","1209600","950400","777600","864000","1123200"}
			local charges = redis:ttl("charged:"..chat)
						    --local timegp = redis:ttl("charged:"..chat)
							local gift = codegift[math.random(#codegift)] + charges
							local daygif = codegift[math.random(#codegift)]
							local chlogs = tonumber(-1001115602781)
							if not redis:get("donehediye:"..chat) then
						   redis:setex("charged:"..chat,gift,true)
						   redis:set("donehediye:"..chat,true)
						   local time = redis:ttl("charged:"..chat)
local days = math.floor(daygif / 86400)
time = time - days * 86400
local hour = math.floor(time /3600)
time = time - hour * 3600
local minute = math.floor(time / 60)
time = time - minute * 60
sec = time 
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
								{text = 'نمایش میزان جدید شارژ گروه', callback_data = 'chargegp:'..chat}
				   },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat} --,{text = 'صفحه قبلی ◀️', callback_data = 'szn:'..chat}
				}
							}
              edit(q.inline_message_id,'✨تبریک✨\n['..days..'] `روز شارژ هدیه گروه از طرف تیم` [FreeManager] `به شما تعلق گرفت.`\nاز منوی زیر انتخاب کنید:',keyboard)
			  sendmsg(chlogs,'🎁گزارش دریافت هدیه گروه:\nمیزان شارژ دریافتی هدیه: ['..days..'] روز\nشناسه گروه دریافت کننده هدیه: ['..chat..']')
			  else
			  local keyboard = {}
							keyboard.inline_keyboard = {
								{
	
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat} 
				}
							}
		 edit(q.inline_message_id,'>شما قبلا هدیه کانال ['..Botusername..'](https://t.me/'..Channelusername..') را دریافت کرده اید.\nدر نظر داشته باشید در هر گروه فقط یکبار قادر به دریافت هدیه ما میباشد.\n\nبا احترام ، مدیریت '..Botusername..'',keyboard)
            end
			end
			--end
			--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--
			----######################################################-----
			if q.data:match('tonv') then
                           local chat = '-'..q.data:match('(%d+)$')
							local freecharge = 604800
						    if not redis:get("charged:"..chat) then
						   redis:setex("charged:"..chat,freecharge,true)
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
								{text = 'نمایش میزان جدید شارژ گروه', callback_data = 'chargegp:'..chat}
				   },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat} 
				}
							}
              edit(q.inline_message_id,'خبر خوش😃\n*7* `روز شارژ هدیه به گروه شما تعلق گرفت.`\nاز منوی زیر انتخاب کنید:',keyboard)
			  else
			  local time = redis:ttl("charged:"..chat)
local days = math.floor(time / 86400)
time = time - days * 86400
local hour = math.floor(time /3600)
time = time - hour * 3600
local minute = math.floor(time / 60)
time = time - minute * 60
sec = time
			  local keyboard = {}
							keyboard.inline_keyboard = {
								{
	
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat} ,{text = 'صفحه قبلی ◀️', callback_data = 'szn:'..chat}
				}
							}
		 edit(q.inline_message_id,'>لطفا ['..days..'] روز و ['..hour..'] ساعت دیگر جهت تمدید رایگان شارژ گروه خود مراجعه کنید.\n',keyboard)
            end
			end
			----######################################################-----
							------------------------------------------------------------------------
							if q.data:match('managerlist') then
                           local chat = '-'..q.data:match('(%d+)$')
						   local list = redis:smembers('ModList:'..chat) 
          local t = '`>لیست مدیران گروه:` \n\n'
          for k,v in pairs(list) do
          t = t..k.." - *"..v.."*\n" 
          end
          t = t..'\n`>برای مشاهده کاربر از دستور زیر استفاده کنید`\n*/whois* `[آیدی کاربر]`'
          if #list == 0 then
          t = '`>مدیریت برای این گروه ثبت نشده است.`'
          end
		  if redis:hget('sizepanel'..chat,'changepanelsize') == 'desktop' then
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'حذف لیست مدیران', callback_data = 'removemanagers:'..chat}
				   },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id, ''..t..'',keyboard)
			  else
			  local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'مشاهده مدیران', callback_data = 'showmanagers:'..chat}
				   },{
				   {text = 'حذف لیست مدیران', callback_data = 'removemanagers:'..chat}
				   },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				     },{
					 {text = 'صفحه قبلی ◀️', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id, ''..t..'',keyboard)
			  end
            end
			------------------------------------------------------------------------
							if q.data:match('warnsda') then
                           local chat = '-'..q.data:match('(%d+)$')
						   local comn = redis:hkeys(chat..':warn')
local t = 'لیست کاربران دارای اخطار:\n'
for k,v in pairs (comn) do
local cont = redis:hget(chat..':warn', v)
t = t..k..'- *['..v..']* > تعداد اخطار ها: `'..(cont - 1)..'`\n'
end
          t = t..'\n`>برای مشاهده کاربر از دستور زیر استفاده کنید`\n*/whois* `[شناسه کاربر]`'
          if #comn == 0 then
          t = '`لیست اخطار برای این گروه ثبت نشده است.`'
          end
		  if redis:hget('sizepanel'..chat,'changepanelsize') == 'desktop' then
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'حذف لیست اخطار ها', callback_data = 'removewarns:'..chat}
				   },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id, ''..t..'',keyboard)
			  else
			  local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'مشاهده مدیران', callback_data = 'showmanagers:'..chat}
				   },{
				    {text = 'حذف لیست اخطار ها', callback_data = 'removewarns:'..chat}
				   },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				     },{
					 {text = 'صفحه قبلی ◀️', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id, ''..t..'',keyboard)
			  end
            end
			if q.data:match('removewarns') then 
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
				 {text = '❌خیر', callback_data = 'vc6u:'..chat},{text = '✅بله', callback_data = 'lwqsd:'..chat}
                },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'managerlist:'..chat}
				}
							}
              edit(q.inline_message_id,'⚠️هشدار!\n`با انجام این عمل لیست اخطار های کاربران حذف میگردد.`\n`آیا اطمیان دارید؟`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('lwqsd') then
                           local chat = '-'..q.data:match('(%d+)$')
						   redis:del(chat..':warn')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`>> لیست اخطار های این گروه با موفقیت بازنشانی گردید.`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('vc6u') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`درخواست شما لغو گردید.`',keyboard)
            end
			------------------------------------------------------------------------
							if q.data:match('alloweded') then
                           local chat = '-'..q.data:match('(%d+)$')
						   local list = redis:smembers('allowedusers:'..chat) 
          local t = '`>لیست کاربران مجاز گروه:` \n\n'
          for k,v in pairs(list) do
          t = t..k.." - *"..v.."*\n" 
          end
          t = t..'\n`>برای مشاهده کاربر از دستور زیر استفاده کنید`\n*/whois* `[آیدی کاربر]`'
          if #list == 0 then
          t = '`>لیست کاربران مجاز گروه خالی میباشد.`'
          end
		  if redis:hget('sizepanel'..chat,'changepanelsize') == 'desktop' then
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'حذف لیست کاربران مجاز', callback_data = 'rallow:'..chat}
				   },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id, ''..t..'',keyboard)
			  else
			  local keyboard = {}
							keyboard.inline_keyboard = {
								{
				   {text = 'حذف لیست کاربران مجاز', callback_data = 'rallow:'..chat}
				   },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				     },{
					 {text = 'صفحه قبلی ◀️', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id, ''..t..'',keyboard)
			  end
            end
							------------------------------------------------------------------------
							if q.data:match('showmanagers') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'managerlist:'..chat}
				}
							}
              edit(q.inline_message_id,'`با عرض پوزش،در حال حاضر سیستم انتخابی غیرفعال میباشد.`',keyboard)
            end
							------------------------------------------------------------------------
							------------------------------------------------------------------------
							if q.data:match('ownerlist') then
                           local chat = '-'..q.data:match('(%d+)$')
						   local list = redis:smembers('OwnerList:'..chat) 
          local t = '`>لیست مالکین گروه:` \n\n'
          for k,v in pairs(list) do
          t = t..k.." - *"..v.."*\n" 
          end
          t = t..'\n`>برای مشاهده کاربر از دستور زیر استفاده کنید`\n*/whois* `[آیدی کاربر]`'
          if #list == 0 then
          t = '`>لیست مالکان گروه خالی میباشد!`'
          end
		  if redis:hget('sizepanel'..chat,'changepanelsize') == 'desktop' then
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'حذف لیست مالکین', callback_data = 'removeowners:'..chat}
				   },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id, ''..t..'',keyboard)
			  else
			  local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'مشاهده مالکین', callback_data = 'showowners:'..chat}
				   },{
				   {text = 'حذف لیست مالکین', callback_data = 'removeowners:'..chat}
				   },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				   },{
				   {text = 'صفحه قبلی ◀️', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id, ''..t..'',keyboard)
			  end
            end
							------------------------------------------------------------------------
							if q.data:match('showowners') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'ownerlist:'..chat}
				}
							}
              edit(q.inline_message_id,'`با عرض پوزش،در حال حاضر سیستم انتخابی غیرفعال میباشد.`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('showrules') then
                           local chat = '-'..q.data:match('(%d+)$')
						   local rules = redis:get('Rules:'..chat) 
          if not rules then
          rules = '`>قوانین برای گروه تنظیم نشده است.`'
          end
		  if redis:hget('sizepanel'..chat,'changepanelsize') == 'desktop' then
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
							{text = 'حذف قوانین', callback_data = 'removerules:'..chat},{text = '🔄بروزرسانی قوانین', callback_data = 'rresetshow:'..chat}
				   },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id, '`آخرین بروزرسانی قوانین در ساعت:` *['..os.date("%X")..']*\nقوانین گروه:\n `'..rules..'`',keyboard)
           else
		   local keyboard = {}
							keyboard.inline_keyboard = {
								{
							{text = 'حذف قوانین', callback_data = 'removerules:'..chat}
				   },{
				   {text = '🔄بروزرسانی قوانین', callback_data = 'rresetshow:'..chat}
				   },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				   },{
				   {text = 'صفحه قبلی ◀️', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id, '`آخرین بروزرسانی قوانین در ساعت:` *['..os.date("%X")..']*\nقوانین گروه:\n `'..rules..'`',keyboard)
		   end
		   end
			------------------------------------------------------------------------
							if q.data:match('rresetshow') then
                           local chat = '-'..q.data:match('(%d+)$')
						    local rules = redis:get(SUDO..'grouprules'..chat)
          if not rules then
          rules = '`>قوانین برای گروه تنظیم نشده است.`'
          end
		  if redis:hget('sizepanel'..chat,'changepanelsize') == 'desktop' then
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
							{text = 'حذف قوانین', callback_data = 'removerules:'..chat},{text = '🔄بروزرسانی قوانین', callback_data = 'showrules'..chat}
				   },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id, '`آخرین بروزرسانی قوانین در ساعت:` *['..os.date("%X")..']*\nقوانین گروه:\n `'..rules..'`',keyboard)
           else
		   local keyboard = {}
							keyboard.inline_keyboard = {
								{
							{text = 'حذف قوانین', callback_data = 'removerules:'..chat}
				   },{
				   {text = '🔄بروزرسانی قوانین', callback_data = 'rresetshow:'..chat}
				   },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				   },{
				   {text = 'صفحه قبلی ◀️', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id, '`آخرین بروزرسانی قوانین در ساعت:` *['..os.date("%X")..']*\nقوانین گروه:\n `'..rules..'`',keyboard)
		   end
		   end
			------------------------------------------------------------------------
							if q.data:match('slin') then
                           local chat = '-'..q.data:match('(%d+)$')
						   if redis:hget('sizepanel'..chat,'changepanelsize') == 'desktop' then
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
							{text = 'لینک هایپر', callback_data = 'linkgroup:'..chat},{text = 'لینک معمولی', callback_data = 'mro:'..chat}
				   },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id, '`مایل به دریافت لینک به چه شکل میباشید؟`',keyboard)
			  else
			  local keyboard = {}
							keyboard.inline_keyboard = {
								{
							{text = 'لینک هایپر', callback_data = 'linkgroup:'..chat}
				   },{
				   {text = 'لینک معمولی', callback_data = 'mro:'..chat}
				   },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				   },{
				   {text = 'صفحه قبلی ◀️', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id, '`مایل به دریافت لینک به چه شکل میباشید؟`',keyboard)
			  end
            end
							------------------------------------------------------------------------
							if q.data:match('linkgroup') then
                           local chat = '-'..q.data:match('(%d+)$')
						   local links = redis:get('Link:'..chat) 
          if not links then
          links = '`>لینک ورود به گروه تنظیم نشده است.`\n`ثبت لینک جدید با دستور زیر امکان پذیر است:`\n*/setlink* `link`'
          else
		  links = '`>لینک ورود به ابرگروه:`\n[برای ورود به گروه کلیک کنید.]('..links..')'
		  end
		  if redis:hget('sizepanel'..chat,'changepanelsize') == 'desktop' then
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
								{text = 'حذف لینک ابرگروه', callback_data = 'removegrouplink:'..chat}
				   },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'slin:'..chat}
				}
							}
              edit(q.inline_message_id, ''..links..'',keyboard)
			  else
			  local keyboard = {}
							keyboard.inline_keyboard = {
								{
								{text = 'حذف لینک ابرگروه', callback_data = 'removegrouplink:'..chat}
				   },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				    },{
					{text = 'صفحه قبلی ◀️', callback_data = 'slin:'..chat}
				}
							}
              edit(q.inline_message_id, ''..links..'',keyboard)
			  end
            end
			------------------------------------------------------------------------
							if q.data:match('mro') then
                           local chat = '-'..q.data:match('(%d+)$')
						   local links = redis:get('Link:'..chat)
          if not links then
          links = '`>لینک ورود به گروه تنظیم نشده است.`\n`ثبت لینک جدید با دستور زیر امکان پذیر است:`\n*/setlink* `link`'
          else
		  links = '`>لینک ورود به ابرگروه:`\n '..links..''
		  end
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
								{text = 'حذف لینک ابرگروه', callback_data = 'removegrouplink:'..chat}
				   },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'slin:'..chat}
				}
							}
              edit(q.inline_message_id, ''..links..'',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('banlist') then
                           local chat = '-'..q.data:match('(%d+)$')
						  local list = redis:smembers('BanUser:'..chat) 	
          local t = '`>لیست افراد مسدود شده از گروه:` \n\n'
          for k,v in pairs(list) do
          t = t..k.." - *"..v.."*\n" 
          end
          t = t..'\n`>برای مشاهده کاربر از دستور زیر استفاده کنید`\n*/whois* `[آیدی کاربر]`'
          if #list == 0 then
          t = '`>لیست افراد مسدود شده از گروه خالی میباشد.`'
          end
		   if redis:hget('sizepanel'..chat,'changepanelsize') == 'desktop' then
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'حذف لیست', callback_data = 'removebanlist:'..chat}
				   },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id, ''..t..'',keyboard)
			  else
			  local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'مشاهده کاربران', callback_data = 'showusers:'..chat}
				    },{
				   {text = 'حذف لیست', callback_data = 'removebanlist:'..chat}
				   },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				    },{
				   {text = 'صفحه قبلی ◀️', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id, ''..t..'',keyboard)
			  end
            end
							------------------------------------------------------------------------
							if q.data:match('showusers') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'banlist:'..chat}
				}
							}
              edit(q.inline_message_id,'`با عرض پوزش،در حال حاضر سیستم انتخابی غیرفعال میباشد.`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('silentlistusers') then
                           local chat = '-'..q.data:match('(%d+)$')
						  local list = redis:smembers('MuteList:'..chat) 
          local t = '`>لیست کاربران حالت سکوت` \n\n'
          for k,v in pairs(list) do
          t = t..k.." - *"..v.."*\n" 
          end
          t = t..'\n`>برای مشاهده کاربر از دستور زیر استفاده کنید`\n*/whois* `[آیدی کاربر]`'
          if #list == 0 then
          t = '`>لیست کاربران حالت سکوت خالی میباشد!`'
          end
		  if redis:hget('sizepanel'..chat,'changepanelsize') == 'desktop' then
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'حذف لیست', callback_data = 'removesilentlist:'..chat}
				   },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id, ''..t..'',keyboard)
			  else
			  local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'مشاهده کاربران', callback_data = 'showusersmutelist:'..chat}
				   },{
				   {text = 'حذف لیست', callback_data = 'removesilentlist:'..chat}
				   },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				   },{
				   {text = 'صفحه قبلی ◀️', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id, ''..t..'',keyboard)
			  end
            end
							------------------------------------------------------------------------
							if q.data:match('showusersmutelist') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'silentlistusers:'..chat}
				}
							}
              edit(q.inline_message_id,'`با عرض پوزش،در حال حاضر سیستم انتخابی غیرفعال میباشد.`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('filterlistword') then
                           local chat = '-'..q.data:match('(%d+)$')
						   local list = redis:smembers('Filters:'..chat) 
          local t = '`>لیست کلمات فیلتر شده در گروه:` \n\n'
          for k,v in pairs(list) do
          t = t..k.." - *"..v.."*\n" 
          end
          if #list == 0 then
          t = '`>لیست کلمات فیلتر شده خالی میباشد`'
          end
		   if redis:hget('sizepanel'..chat,'changepanelsize') == 'desktop' then
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'حذف لیست', callback_data = 'removefilterword:'..chat},{text = '🔄بروزرسانی لیست', callback_data = 'resetlist:'..chat}
				   },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id, '`آخرین بروزرسانی لیست در ساعت:` *['..os.date("%X")..']*\n'..t..'',keyboard)
			  else
			  local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'حذف لیست', callback_data = 'removefilterword:'..chat}
				     },{
				   {text = '🔄بروزرسانی لیست', callback_data = 'resetlist:'..chat}
				   },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				     },{
				   {text = 'صفحه قبلی ◀️', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id, '`آخرین بروزرسانی لیست در ساعت:` *['..os.date("%X")..']*\n'..t..'',keyboard)
			  end
            end
							--########################################################################--
							if q.data:match('resetlist') then
                           local chat = '-'..q.data:match('(%d+)$')
						     local list = redis:smembers('Filters:'..chat) 
          local t = '`>لیست کلمات فیلتر شده در گروه:` \n\n'
          for k,v in pairs(list) do
          t = t..k.." - *"..v.."*\n" 
          end
          if #list == 0 then
          t = '`>لیست کلمات فیلتر شده خالی میباشد`'
          end
		   if redis:hget('sizepanel'..chat,'changepanelsize') == 'desktop' then
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'حذف لیست', callback_data = 'removefilterword:'..chat},{text = '🔄بروزرسانی لیست', callback_data = 'filterlistword'..chat}
				   },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id, '`آخرین بروزرسانی لیست در ساعت:` *['..os.date("%X")..']*\n'..t..'',keyboard)
			  else
			  local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'حذف لیست', callback_data = 'removefilterword:'..chat}
				     },{
				   {text = '🔄بروزرسانی لیست', callback_data = 'resetlist:'..chat}
				   },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				     },{
				   {text = 'صفحه قبلی ◀️', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id, '`آخرین بروزرسانی لیست در ساعت:` *['..os.date("%X")..']*\n'..t..'',keyboard)
			  end
            end
							--########################################################################--
							--########################################################################--
							if q.data:match('removemanagers') then 
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
				 {text = '❌خیر', callback_data = 'n26s:'..chat},{text = '✅بله', callback_data = 'lyas3:'..chat}
                },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'managerlist:'..chat}
				}
							}
              edit(q.inline_message_id,'هشدار!\n`با انجام این عمل لیست مدیران گروه حذف میگردد.`\n`آیا اطمیان دارید؟`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('lyas3') then
                           local chat = '-'..q.data:match('(%d+)$')
						   redis:del('ModList:'..chat)
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`>لیست مدیران گروه با موفقیت بازنشانی شد.`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('n26s') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`درخواست شما لغو گردید.`',keyboard)
            end
			-----------------------------------------------
			if q.data:match('rallow') then --rallow
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
				 {text = '❌خیر', callback_data = 'n56s:'..chat},{text = '✅بله', callback_data = 'alrem:'..chat}
                },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'managerlist:'..chat}
				}
							}
              edit(q.inline_message_id,'هشدار!\n`با انجام این عمل لیست کاربران مجاز گروه حذف میگردد.`\n`آیا اطمیان دارید؟`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('alrem') then
                           local chat = '-'..q.data:match('(%d+)$')
						   redis:del('allowedusers:'..chat)
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`>لیست کاربران مجاز گروه با موفقیت بازنشانی شد.`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('n56s') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`درخواست شما لغو گردید.`',keyboard)
            end
						--########################################################################--
						if q.data:match('removeowners') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
				 {text = '❌خیر', callback_data = 'x9ie4:'..chat},{text = '✅بله', callback_data = 'loq0:'..chat}
                },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'ownerlist:'..chat}
				}
							}
              edit(q.inline_message_id,'هشدار!\n`با انجام این عمل لیست مالکین گروه حذف میگردد.`\n`آیا اطمیان دارید؟`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('loq0') then
                           local chat = '-'..q.data:match('(%d+)$')
						  redis:del('OwnerList:'..chat)
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`>لیست مالکین گروه با موفقیت بازنشانی گردید.`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('x9ie4') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`درخواست شما لغو گردید.`',keyboard) 
            end
							--########################################################################--
							if q.data:match('removerules') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
				 {text = '❌خیر', callback_data = 'vu74c:'..chat},{text = '✅بله', callback_data = '9uncs:'..chat}
                },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'showrules:'..chat}
				}
							}
              edit(q.inline_message_id,'هشدار!\n`با انجام این عمل متن قوانین تنظیم شده گروه حذف میگردد.`\n`آیا اطمیان دارید؟`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('9uncs') then
                           local chat = '-'..q.data:match('(%d+)$')
						  redis:del('Rules:'..chat) 
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`>قوانین گروه با موفقیت بازنشانی گردید.`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('vu74c') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`درخواست شما لغو گردید.`',keyboard) 
            end
							--########################################################################--
							if q.data:match('removegrouplink') then
                           local chat = '-'..q.data:match('(%d+)$')
						   redis:del('Link:'..chat)
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`>لینک ثبت شده با موفقیت بازنشانی گردید.`',keyboard)
            end
							--########################################################################--
								if q.data:match('removebanlist') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
				 {text = '❌خیر', callback_data = 'ql3oe:'..chat},{text = '✅بله', callback_data = 'trq2oj:'..chat}
                },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'banlist:'..chat}
				}
							}
              edit(q.inline_message_id,'هشدار!\n`با انجام این عمل لیست کاربران مسدود شده از گروه حذف میگردد.`\n`آیا اطمیان دارید؟`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('trq2oj') then
                           local chat = '-'..q.data:match('(%d+)$')
						  redis:del('BanUser:'..chat)
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`>لیست کاربران مسدود شده از گروه با موفقیت بازنشانی گردید.`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('ql3oe') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`درخواست شما لغو گردید.`',keyboard) 
            end
							--########################################################################--
								if q.data:match('removesilentlist') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
				 {text = '❌خیر', callback_data = 'b19ire:'..chat},{text = '✅بله', callback_data = 'jjawr4:'..chat}
                },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'silentlistusers:'..chat}
				}
							}
              edit(q.inline_message_id,'هشدار!\n`با انجام این عمل لیست کاربران حالت سکوت گروه حذف میگردد.`\n`آیا اطمیان دارید؟`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('jjawr4') then
                           local chat = '-'..q.data:match('(%d+)$')
						  redis:del('MuteList:'..chat)
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`>لیست افراد کاربران لیست سکوت با موفقیت حذف گردید.`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('b19ire') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`درخواست شما لغو گردید.`',keyboard) 
            end
							--########################################################################--
							if q.data:match('removefilterword') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
				 {text = '❌خیر', callback_data = 'fi3ls:'..chat},{text = '✅بله', callback_data = 'q8ldr3c:'..chat}
                },{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat},{text = 'صفحه قبلی ◀️', callback_data = 'filterlistword:'..chat}
				}
							}
              edit(q.inline_message_id,'هشدار!\n`با انجام این عمل لیست تمامی کلمات فیلترشده گروه حذف میگردد.`\n`آیا اطمیان دارید؟`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('q8ldr3c') then
                           local chat = '-'..q.data:match('(%d+)$')
						  redis:del('Filters:'..chat)
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`>تمامی کلمات فیلتر شده با موفقیت حذف گردیدند.`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('fi3ls') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`درخواست شما لغو گردید.`',keyboard) 
            end
							--########################################################################--
							--********************************************************************--
							if q.data:match('bsd') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
								{text = 'قفل های اصلی', callback_data = 'groupsettings:'..chat}
                },{
				{text = 'قفل های فرعی', callback_data = 'next_page:'..chat} 
				},{
				{text = 'تنظیمات پیشرفته', callback_data = 'mata_gte:'..chat} 
				},{
                   {text = 'بازگشت', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`به بخش انتخاب نمایش تنظیمات خوش آمدید.`\n`از منوی زیر انتخاب کنید:`',keyboard)
            end
							--********************************************************************--
							--********************************************************************--
							------------------------------------------------------------------------
							if q.data:match('groupsettings') then
							local chat = '-'..q.data:match('(%d+)$')
							local function is_lock(chat,value)
local hash = SUDO..'settings:'..chat..':'..value
 if redis:get(hash) then
    return true 
    else
    return false
    end
  end

local function getsettings(value)
       if value == "charge" then
       local ex = redis:ttl("charged:"..chat)
       if ex == -1 then
        return "نامحدود!"
       else
        local d = math.floor(ex / day ) + 1
        return "["..d.."] روز دیگر"
       end
        elseif value == 'muteall' then
				local h = redis:ttl('MuteAll:'..chat)
          if h == -1 then
        return '🔐'
				elseif h == -2 then
        return '🔓'
       else
        return "تا ["..h.."] ثانیه دیگر فعال است"
       end
	   elseif value == 'mutealllimit' then
        local h = redis:ttl('MuteAlllimit:'..chat)
       if h == -1 then
        return '🔐'
				elseif h == -2 then
			  return '🔓'
       else
        return "تا ["..h.."] ثانیه دیگر فعال است"
       end
        elseif value == 'welcome' then
					local hash = redis:get('Welcome:'..chat)
        if hash == 'on' then
         return 'فعال'
          else
          return 'غیرفعال'
          end
        elseif value == 'spam' then
		local hash = redis:hget("flooding:settings:"..chat, "flood")
        if hash then
		   if redis:hget("flooding:settings:"..chat, "flood") == 'kick' then
         return 'اخراج(کاربر)'
			 elseif redis:hget("flooding:settings:"..chat, "flood") == 'ban' then
              return 'مسدود سازی(کاربر)'
			 elseif redis:hget("flooding:settings:"..chat, "flood") == 'mute' then
              return 'سکوت(کاربر)'
			  elseif redis:hget("flooding:settings:"..chat, "flood") == 'delete' then
              return 'حذف پیغام(کاربر)'
              end
          else
          return '🔓'
          end
        elseif is_lock(chat,value) then
          return '🔐'
          else
          return '🔓'
          end
        end
		if redis:hget('sizepanel'..chat,'changepanelsize') == 'desktop' then
             		local keyboard = {}
            	keyboard.inline_keyboard = {
	            	{
					 {text= 'وب ['..getsettings('webpage')..']' ,callback_data=chat..':lock webpage'},{text= 'لینک ['..getsettings('link')..']' ,callback_data=chat..':lock link'}
					  },{
					 {text= 'منشن ['..getsettings('mention')..']' ,callback_data=chat..':lock mention'},{text= 'ویرایش متن ['..getsettings('edittext')..']' ,callback_data=chat..':lock edittext'}
					  },{
					 {text= 'یوزرنیم(@) ['..getsettings('username')..']' ,callback_data=chat..':lock username'},{text= 'ورود ربات ['..getsettings('bots')..']' ,callback_data=chat..':lock bots'}
					  },{
				{text = 'تبلیغات', callback_data = 'tabliqat'..chat}
				   },{
				    {text = '↗️پرش به بخش فیلترها', callback_data = 'next_page:'..chat},{text = '↗️پرش به بخش هرزنامه|اخطار', callback_data = 'mata_gte:'..chat}
				 },{
				    {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
                }
							}
            edit(q.inline_message_id,'تنظیمات-ابرگروه(قفل ها):',keyboard)
			else
			local keyboard = {}
            	keyboard.inline_keyboard = {
	            	{
					 {text = 'قفل لینک', callback_data = chat..'_link'},{text=getsettings('link'),callback_data=chat..':lock link'}
                },{
				{text = 'قفل وب', callback_data = chat..'_webpage'},{text=getsettings('webpage'),callback_data=chat..':lock webpage'}
                },{
				{text = 'قفل منشن', callback_data = chat..'_mention'},{text=getsettings('mention'),callback_data=chat..':lock mention'}
                },{
				 {text = 'قفل ادیت', callback_data = chat..'_edittext'},{text=getsettings('edittext'),callback_data=chat..':lock edittext'}
                },{
				{text = 'قفل یوزر', callback_data = chat..'_username'},{text=getsettings('username'),callback_data=chat..':lock username'} 
                },{
				 {text = 'قفل ربات', callback_data = chat..'_bots'},{text=getsettings('bots'),callback_data=chat..':lock bots'}
				},{
				{text = 'تبلیغات', callback_data = 'tabliqat'..chat}
				   },{
				   {text = 'فرایند فرعی', callback_data = 'next_page:'..chat},{text = 'پیشرفته', callback_data = 'mata_gte:'..chat}
				 },{
				    {text = 'بازگشت ◀️', callback_data = 'firstmenu:'..chat}
                }
							}
            edit(q.inline_message_id,'به تنظیمات اصلی ربات خوش آمدید!',keyboard)
			end
            end
			------------------------------------------------------------------------
            if q.data:match('left_page') then
							local chat = '-'..q.data:match('(%d+)$')
							local function is_lock(chat,value)
local hash = SUDO..'settings:'..chat..':'..value
 if redis:get(hash) then
    return true
    else
    return false
    end
 end
local function getsettings(value)
       if value == "charge" then
       local ex = redis:ttl("charged:"..chat)
       if ex == -1 then
        return "نامحدود!"
       else
        local d = math.floor(ex / day ) + 1
        return "["..d.."] روز دیگر"
       end
        elseif value == 'spam' then
		local hash = redis:hget("flooding:settings:"..chat, "flood")
        if hash then
		   if redis:hget("flooding:settings:"..chat, "flood") == 'kick' then
         return 'اخراج(کاربر)'
			 elseif redis:hget("flooding:settings:"..chat, "flood") == 'ban' then
              return 'مسدود سازی(کاربر)'
			 elseif redis:hget("flooding:settings:"..chat, "flood") == 'mute' then
              return 'سکوت(کاربر)'
			  elseif redis:hget("flooding:settings:"..chat, "flood") == 'delete' then
              return 'حذف پیغام(کاربر)'
              end
          else
          return '🔓'
          end
        elseif is_lock(chat,value) then
          return '🔐'
          else
          return '🔓'
          end
        end
							if redis:hget('sizepanel'..chat,'changepanelsize') == 'desktop' then
             			local keyboard = {}
            	keyboard.inline_keyboard = {
	            	{
					 {text= 'صفحات وب ['..getsettings('webpage')..']' ,callback_data=chat..':lock webpage'},{text= 'لینک ['..getsettings('link')..']' ,callback_data=chat..':lock link'}
					  },{
					 {text= 'منشن ['..getsettings('mention')..']' ,callback_data=chat..':lock mention'},{text= 'ویرایش متن ['..getsettings('edittext')..']' ,callback_data=chat..':lock edittext'}
					  },{
					 {text= 'یوزرنیم(@) ['..getsettings('username')..']' ,callback_data=chat..':lock username'},{text= 'ورود ربات ['..getsettings('bots')..']' ,callback_data=chat..':lock bots'}
					  },{
				{text = '📍محل تبلیغات شما', callback_data = 'tabliqat'..chat}
				   },{
				    {text = 'فرایند فرعی', callback_data = 'next_page:'..chat},{text = 'پیشرفته', callback_data = 'mata_gte:'..chat}
				 },{
				    {text = 'بازگشت  ◀️', callback_data = 'firstmenu:'..chat}
                }
							}
            edit(q.inline_message_id,'به تنظیمات اصلی ربات خوش آمدید!',keyboard)
			else
			local keyboard = {}
            	keyboard.inline_keyboard = {
	            	{
					 {text = 'قفل  لینک', callback_data = chat..'_link'},{text=getsettings('link'),callback_data=chat..':lock link'}
                },{
				{text = 'قفل وب', callback_data = chat..'_webpage'},{text=getsettings('webpage'),callback_data=chat..':lock webpage'}
                },{
				{text = 'قفل منشن', callback_data = chat..'_mention'},{text=getsettings('mention'),callback_data=chat..':lock mention'}
                },{
				 {text = 'قفل ادیت', callback_data = chat..'_edittext'},{text=getsettings('edittext'),callback_data=chat..':lock edittext'}
                },{
				{text = 'قفل یوزر', callback_data = chat..'_username'},{text=getsettings('username'),callback_data=chat..':lock username'} 
                },{
				 {text = 'قفل ربات', callback_data = chat..'_bots'},{text=getsettings('bots'),callback_data=chat..':lock bots'}
				},{
				{text = 'تبلیغات', callback_data = 'tabliqat'..chat}
				   },{
				 {text = 'فرایند فرعی', callback_data = 'next_page:'..chat},{text = 'پیشرفته', callback_data = 'mata_gte:'..chat}
				 },{
				    {text = 'بازگشت ◀️', callback_data = 'firstmenu:'..chat}
                }
							}
            edit(q.inline_message_id,'به تنظیمات اصلی ربات خوش آمدید!',keyboard)
			end
            end
						if q.data:match('next_page') then
							local chat = '-'..q.data:match('(%d+)$')
							local function is_lock(chat,value)
local hash = SUDO..'settings:'..chat..':'..value
 if redis:get(hash) then
    return true 
    else
    return false
    end
  end
local function getsettings(value)
        if value == "charge" then
       local ex = redis:ttl("charged:"..chat)
       if ex == -1 then
        return "نامحدود!"
       else
        local d = math.floor(ex / day ) + 1
        return "["..d.."] روز دیگر"
       end
        elseif value == 'muteall' then
        local h = redis:ttl('MuteAll:'..chat)
       if h == -1 then
        return '🔐'
				elseif h == -2 then
			  return '🔓'
       else
        return "تا ["..h.."] ثانیه دیگر فعال است"
       end
	   elseif value == 'mutealllimit' then
        local h = redis:ttl('MuteAlllimit:'..chat)
       if h == -1 then
        return '🔐'
				elseif h == -2 then
			  return '🔓'
       else
        return "تا ["..h.."] ثانیه دیگر فعال است"
       end
        elseif value == 'welcome' then
        local hash = redis:get('Welcome:'..chat)
        if hash == 'on' then
         return 'فعال'
          else
          return 'غیرفعال'
          end
        elseif value == 'spam' then
		local hash = redis:hget("flooding:settings:"..chat, "flood")
        if hash then
		   if redis:hget("flooding:settings:"..chat, "flood") == 'kick' then
         return 'اخراج(کاربر)'
			 elseif redis:hget("flooding:settings:"..chat, "flood") == 'ban' then
              return 'مسدود سازی(کاربر)'
			 elseif redis:hget("flooding:settings:"..chat, "flood") == 'mute' then
              return 'سکوت(کاربر)'
			  elseif redis:hget("flooding:settings:"..chat, "flood") == 'delete' then
              return 'حذف پیغام(کاربر)'
              end
          else
          return '🔓'
          end
        elseif is_lock(chat,value) then
          return '✅'
          else
          return '🚫'
          end
        end
		if redis:hget('sizepanel'..chat,'changepanelsize') == 'desktop' then
         		local MSG_MAX = (redis:hget("flooding:settings:"..chat,"floodmax") or 5)
								local TIME_MAX = (redis:hget("flooding:settings:"..chat,"floodtime") or 3)
								 MUTE_MAX = (redis:get(SUDO..'muteall'..chat) or 0)
				local keyboard = {}
							keyboard.inline_keyboard = {
								{
								{text= 'تصاویر ['..getsettings('photo')..']' ,callback_data=chat..':lock photo'},{text= 'ویدئو ['..getsettings('video')..']' ,callback_data=chat..':lock video'}
								},{
								{text= 'ویدئو سلفی ['..getsettings('videoself')..']' ,callback_data=chat..':lock videoself'},{text= 'صدا ['..getsettings('audio')..']' ,callback_data=chat..':lock audio'}
								},{
								{text= 'گیف ['..getsettings('gif')..']' ,callback_data=chat..':lock gif'},{text= 'آهنگ ['..getsettings('music')..']' ,callback_data=chat..':lock music'}
								},{
								{text= 'فایل ['..getsettings('file')..']' ,callback_data=chat..':lock file'},{text= 'استیکر ['..getsettings('sticker')..']' ,callback_data=chat..':lock sticker'}
								},{
								{text= 'مخاطبین ['..getsettings('contact')..']' ,callback_data=chat..':lock contact'},{text= 'فوروارد ['..getsettings('forward')..']' ,callback_data=chat..':lock forward'}
								},{
								{text= 'مطالب کانال ['..getsettings('forwardchannel')..']' ,callback_data=chat..':lock forwardchannel'},{text= 'مطالب کاربر ['..getsettings('forwarduser')..']' ,callback_data=chat..':lock forwarduser'}
								},{
								{text= 'بازی ['..getsettings('inlinegame')..']' ,callback_data=chat..':lock inlinegame'},{text= 'اینلاین ['..getsettings('inline')..']' ,callback_data=chat..':lock inline'}
								},{
								{text= '[Via @BOT] ['..getsettings('viabot')..']' ,callback_data=chat..':lock viabot'},{text= 'موقعیت مکانی ['..getsettings('location')..']' ,callback_data=chat..':lock location'}
								},{
								{text= 'سرویس ['..getsettings('tgservice')..']' ,callback_data=chat..':lock tgservice'},{text= 'متن ['..getsettings('text')..']' ,callback_data=chat..':lock text'}
								},{
								{text= 'فارسی ['..getsettings('persian')..']' ,callback_data=chat..':lock persian'},{text= 'انگلیسی ['..getsettings('english')..']' ,callback_data=chat..':lock english'}
								},{
								 {text=getsettings('welcome'),callback_data=chat..':lock welcome'}, {text = 'پیغام خوش آمدگویی', callback_data = chat..'_welcome'}
				  },{
				 {text = '👇🏻فیلتر تمامی گفتگو ها(محدودیت کاربران)👇🏻', callback_data = chat..'_muteall'}
				 },{
				 {text=getsettings('muteall'),callback_data=chat..':lock muteall'} 
                },{
				{text = '👇🏻فیلتر تمامی گفتگو ها(عدم محدودیت کاربران)👇🏻', callback_data = chat..'_mutealllimit'}
				},{
				{text=getsettings('mutealllimit'),callback_data=chat..':lock mutealllimit'} 
                },{
				  {text = '↖️بازگشت به تنظیمات قفل ها', callback_data = 'left_page:'..chat},{text = '↗️پرش به بخش هرزنامه|اخطار', callback_data = 'mata_gte:'..chat}
				   },{
				  {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
                }
							}
              edit(q.inline_message_id,'تنظیمات-ابرگروه(فیلتر ها + بخش بیشتر)\nجهت تنظیم اقدام کنید یا در صورت تمایل به منوی قبل بازگردید:',keyboard)
			  elseif redis:hget('sizepanel'..chat,'changepanelsize') == 'mobile' then
local MSG_MAX = (redis:hget("flooding:settings:"..chat,"floodmax") or 5)
								local TIME_MAX = (redis:hget("flooding:settings:"..chat,"floodtime") or 3)
				local keyboard = {}
							keyboard.inline_keyboard = {
								{
								 {text = 'عکس', callback_data = chat..'_photo'},{text=getsettings('photo'),callback_data=chat..':lock photo'}
                },{
                 {text = 'ویدئو', callback_data = chat..'_video'},{text=getsettings('video'),callback_data=chat..':lock video'} 
				 },{
                 {text = 'سلفی', callback_data = chat..'_videoself'},{text=getsettings('videoself'),callback_data=chat..':lock videoself'} 
                },{
                 {text = 'صدا', callback_data = chat..'_audio'},{text=getsettings('audio'),callback_data=chat..':lock audio'} 
                },{
                {text = ' گیف', callback_data = chat..'_gif'},{text=getsettings('gif'),callback_data=chat..':lock gif'} 
                },{
                 {text = 'آهنگ', callback_data = chat..'_music'},{text=getsettings('music'),callback_data=chat..':lock music'} 
                },{
                  {text = 'فایل', callback_data = chat..'_file'},{text=getsettings('file'),callback_data=chat..':lock file'}
                },{
                 {text = 'استیکر', callback_data = chat..'_sticker'},{text=getsettings('sticker'),callback_data=chat..':lock sticker'} 
                },{ 
                  {text = 'شماره', callback_data = chat..'_contact'},{text=getsettings('contact'),callback_data=chat..':lock contact'}
                },{
                  {text = 'فوروارد', callback_data = chat..'_forward'},{text=getsettings('forward'),callback_data=chat..':lock forward'}
                },{
				{text = ' تبچی کانال', callback_data = chat..'_forwardchannel'},{text=getsettings('forwardchannel'),callback_data=chat..':lock forwardchannel'}
                },{
				{text = 'تبلیغ تبچی)', callback_data = chat..'_forwarduser'},{text=getsettings('forwarduser'),callback_data=chat..':lock forwarduser'}
                },{
                  {text = 'بازی', callback_data = chat..'_inlinegame'},{text=getsettings('inlinegame'),callback_data=chat..':lock inlinegame'}
                },{
				{text = 'اینلاین', callback_data = chat..'_inline'},{text=getsettings('inline'),callback_data=chat..':lock inline'}
                },{
				{text = 'چت ربات', callback_data = chat..'_viabot'},{text=getsettings('viabot'),callback_data=chat..':lock viabot'}
				  },{
				 {text = 'مکان', callback_data = chat..'_location'},{text=getsettings('location'),callback_data=chat..':lock location'}
				 },{
				{text = 'تلگرام', callback_data = chat..'_tgservice'},{text=getsettings('tgservice'),callback_data=chat..':lock tgservice'}
                },{
				{text = 'چت', callback_data = chat..'_text'},{text=getsettings('text'),callback_data=chat..':lock text'}
                },{
                 {text = 'فارسی', callback_data = chat..'_persian'} ,{text=getsettings('persian'),callback_data=chat..':lock persian'}
                },{
                  {text = 'انگلیسی', callback_data = chat..'_english'},{text=getsettings('english'),callback_data=chat..':lock english'}
                },{
				 {text = 'محدودیت همه', callback_data = chat..'_muteall'},{text=getsettings('muteall'),callback_data=chat..':lock muteall'} 
                },{
				{text = 'محدویت حذف پیام', callback_data = chat..'_mutealllimit'},{text=getsettings('mutealllimit'),callback_data=chat..':lock mutealllimit'} 
                },{
                 {text=getsettings('welcome'),callback_data=chat..':lock welcome'}, {text = 'خوش آمد', callback_data = chat..'_welcome'}
				  },{
				  {text = 'فرایند اصلی', callback_data = 'left_page:'..chat},{text = 'پیشرفته', callback_data = 'mata_gte:'..chat}
				   },{
				  {text = 'بازگشت ◀️', callback_data = 'firstmenu:'..chat}
                }
							}
              edit(q.inline_message_id,'تنظیمات-ابرگروه(فیلتر ها + بخش بیشتر)\nجهت تنظیم اقدام کنید یا در صورت تمایل به منوی قبل بازگردید:',keyboard)
			elseif not redis:hget('sizepanel'..chat,'changepanelsize') then
local MSG_MAX = (redis:hget("flooding:settings:"..chat,"floodmax") or 5)
								local TIME_MAX = (redis:hget("flooding:settings:"..chat,"floodtime") or 3)
								 MUTE_MAX = (redis:get(SUDO..'muteall'..chat) or 0)
				local keyboard = {}
							keyboard.inline_keyboard = {
								{
								{text= 'تصاویر ['..getsettings('photo')..']' ,callback_data=chat..':lock photo'},{text= 'ویدئو ['..getsettings('video')..']' ,callback_data=chat..':lock video'}
								},{
								{text= 'ویدئو سلفی ['..getsettings('videoself')..']' ,callback_data=chat..':lock videoself'},{text= 'صدا ['..getsettings('audio')..']' ,callback_data=chat..':lock audio'}
								},{
								{text= 'گیف ['..getsettings('gif')..']' ,callback_data=chat..':lock gif'},{text= 'آهنگ ['..getsettings('music')..']' ,callback_data=chat..':lock music'}
								},{
								{text= 'فایل ['..getsettings('file')..']' ,callback_data=chat..':lock file'},{text= 'استیکر ['..getsettings('sticker')..']' ,callback_data=chat..':lock sticker'}
								},{
								{text= 'مخاطبین ['..getsettings('contact')..']' ,callback_data=chat..':lock contact'},{text= 'فوروارد ['..getsettings('forward')..']' ,callback_data=chat..':lock forward'}
								},{
								{text= 'مطالب کانال ['..getsettings('forwardchannel')..']' ,callback_data=chat..':lock forwardchannel'},{text= 'مطالب کاربر ['..getsettings('forwarduser')..']' ,callback_data=chat..':lock forwarduser'}
								},{
								{text= 'بازی ['..getsettings('inlinegame')..']' ,callback_data=chat..':lock inlinegame'},{text= 'اینلاین ['..getsettings('inline')..']' ,callback_data=chat..':lock inline'}
								},{
								{text= '[Via @BOT] ['..getsettings('viabot')..']' ,callback_data=chat..':lock viabot'},{text= 'موقعیت مکانی ['..getsettings('location')..']' ,callback_data=chat..':lock location'}
								},{
								{text= 'سرویس ['..getsettings('tgservice')..']' ,callback_data=chat..':lock tgservice'},{text= 'متن ['..getsettings('text')..']' ,callback_data=chat..':lock text'}
								},{
								{text= 'فارسی ['..getsettings('persian')..']' ,callback_data=chat..':lock persian'},{text= 'انگلیسی ['..getsettings('english')..']' ,callback_data=chat..':lock english'}
								},{
								 {text=getsettings('welcome'),callback_data=chat..':lock welcome'}, {text = 'پیغام خوش آمدگویی', callback_data = chat..'_welcome'}
				  },{
				 {text = '👇🏻فیلتر تمامی گفتگو ها(محدودیت کاربران)👇🏻', callback_data = chat..'_muteall'}
				 },{
				 {text=getsettings('muteall'),callback_data=chat..':lock muteall'} 
                },{
				{text = '👇🏻فیلتر تمامی گفتگو ها(عدم محدودیت کاربران)👇🏻', callback_data = chat..'_mutealllimit'}
				},{
				{text=getsettings('mutealllimit'),callback_data=chat..':lock mutealllimit'} 
                },{
				  {text = '↖️بازگشت به تنظیمات قفل ها', callback_data = 'left_page:'..chat},{text = '↗️پرش به بخش هرزنامه|اخطار', callback_data = 'mata_gte:'..chat}
				   },{
				  {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
                }
							}
              edit(q.inline_message_id,'تنظیمات-ابرگروه(فیلتر ها + بخش بیشتر)\nجهت تنظیم اقدام کنید یا در صورت تمایل به منوی قبل بازگردید:',keyboard)
            end
			end
			----***************************************************************-------
			if q.data:match('mata_gte') then
							local chat = '-'..q.data:match('(%d+)$')
							local function is_lock(chat,value)
local hash = SUDO..'settings:'..chat..':'..value
 if redis:get(hash) then
    return true 
    else
    return false
    end
  end
local function getsettings(value)
        if value == "charge" then
       local ex = redis:ttl("charged:"..chat)
       if ex == -1 then
        return "نامحدود!"
       else
        local d = math.floor(ex / day ) + 1
        return "["..d.."] روز دیگر"
       end
        elseif value == 'muteall' then
        local h = redis:ttl('MuteAll:'..chat)
       if h == -1 then
        return '🔐'
				elseif h == -2 then
			  return '🔓'
       else
        return "تا ["..h.."] ثانیه دیگر فعال است"
       end
	   elseif value == 'mutealllimit' then
        local h = redis:ttl('MuteAlllimit:'..chat)
       if h == -1 then
        return '🔐'
				elseif h == -2 then
			  return '🔓'
       else
        return "تا ["..h.."] ثانیه دیگر فعال است"
       end
        elseif value == 'welcome' then
        local hash = redis:get('Welcome:'..chat)
        if hash == 'on' then
         return 'فعال'
          else
          return 'غیرفعال'
          end
        elseif value == 'spam' then
		local hash = redis:hget("flooding:settings:"..chat, "flood")
        if hash then
		   if redis:hget("flooding:settings:"..chat, "flood") == 'kick' then
         return 'اخراج(کاربر)'
			 elseif redis:hget("flooding:settings:"..chat, "flood") == 'ban' then
              return 'مسدود سازی(کاربر)'
			 elseif redis:hget("flooding:settings:"..chat, "flood") == 'mute' then
              return 'سکوت(کاربر)'
			  elseif redis:hget("flooding:settings:"..chat, "flood") == 'delete' then
              return 'حذف پیغام(کاربر)'
              end
          else
          return '🔓'
          end
        elseif is_lock(chat,value) then
          return '🔐'
          else
          return '🔓'
          end
        end
		if redis:hget('sizepanel'..chat,'changepanelsize') == 'desktop' then
         		local MSG_MAX = (redis:hget("flooding:settings:"..chat,"floodmax") or 5)
								local TIME_MAX = (redis:hget("flooding:settings:"..chat,"floodtime") or 3)
								 MUTE_MAX = (redis:get(SUDO..'muteall'..chat) or 0)
								 NUM_CH_MAX = (redis:get('NUM_CH_MAX:'..chat) or 200)
			  WARN_MAX = (redis:get('Warn:Max:'..chat) or 3)
				local keyboard = {}
							keyboard.inline_keyboard = {
								{
                 {text=getsettings('spam'),callback_data=chat..':lock spam'} ,{text = 'عملکرد قفل ارسال هرزنامه', callback_data = chat..'_spam'}
					},{
					{text=getsettings('spamtext'),callback_data=chat..':lock spamtext'},{text = 'حذف پیغام بلند(جدید)', callback_data = chat..'_spamtext'}
                },{
                 {text = '⬇️حداکثر پیغام مجاز ارسال هرزنامه⬇️', callback_data = chat..'_MSG_MAX'}
                },{
									{text='➖',callback_data=chat..':lock MSGMAXdown'},{text = ''..tostring(MSG_MAX)..'', callback_data = chat..'_MSG_MAX'},{text='➕',callback_data=chat..':lock MSGMAXup'}
				   },{
                 {text = '⬇️حداکثر زمان مجاز ارسال هرزنامه⬇️', callback_data = chat..'_TIME_MAX'}
                },{
									{text='➖',callback_data=chat..':lock TIMEMAXdown'},{text = ''..tostring(TIME_MAX)..'', callback_data = chat..'_TIME_MAX'},{text='➕',callback_data=chat..':lock TIMEMAXup'}
				  },{
                 {text = '⬇️حداکثر کارکتر مجاز در پیغام⬇️(جدید)', callback_data = chat..'_NUM_CH_MAX'}
                },{
									{text='➖',callback_data=chat..':lock MSGSPAMMAXdown'},{text = ''..tostring(NUM_CH_MAX)..'', callback_data = chat..'_NUM_CH_MAX'},{text='➕',callback_data=chat..':lock MSGSPAMMAXup'}
				   },{
				   {text = '⬇️حداکثر اخطار مجاز برای کاربران⬇️(جدید)', callback_data = chat..'_WARN_MAX'}
                },{
									{text='➖',callback_data=chat..':lock WARNMAXdown'},{text = ''..tostring(WARN_MAX)..'', callback_data = chat..'_WARN_MAX'},{text='➕',callback_data=chat..':lock WARNMAXup'}
				   },{
				   {text = '↖️بازگشت به تنظیمات قفل ها', callback_data = 'left_page:'..chat},{text = '↗️بازگشت به بخش فیلترها', callback_data = 'next_page:'..chat}
				  },{
				  {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
                }
							}
              edit(q.inline_message_id,'تنظیمات-ابرگروه(هرزنامه + اخطار)\nجهت تنظیم اقدام کنید یا در صورت تمایل به منوی قبل بازگردید:',keyboard)
			  elseif redis:hget('sizepanel'..chat,'changepanelsize') == 'mobile' then
local MSG_MAX = (redis:hget("flooding:settings:"..chat,"floodmax") or 5)
								local TIME_MAX = (redis:hget("flooding:settings:"..chat,"floodtime") or 3)
								 MUTE_MAX = (redis:get(SUDO..'muteall'..chat) or 0)
								 NUM_CH_MAX = (redis:get('NUM_CH_MAX:'..chat) or 200)
			  WARN_MAX = (redis:get('Warn:Max:'..chat) or 3)
				local keyboard = {}
							keyboard.inline_keyboard = {
								{
                 {text=getsettings('spam'),callback_data=chat..':lock spam'} ,{text = 'عملکرد قفل ارسال هرزنامه', callback_data = chat..'_spam'}
					},{
					 {text=getsettings('spamtext'),callback_data=chat..':lock spamtext'},{text = 'حذف پیغام بلند(جدید)', callback_data = chat..'_spamtext'}
                },{
                 {text = '⬇️حداکثر پیغام مجاز ارسال هرزنامه⬇️', callback_data = chat..'_MSG_MAX'}
                },{
									{text='➖',callback_data=chat..':lock MSGMAXdown'},{text = ''..tostring(MSG_MAX)..'', callback_data = chat..'_MSG_MAX'},{text='➕',callback_data=chat..':lock MSGMAXup'}
				   },{
                 {text = '⬇️حداکثر زمان مجاز ارسال هرزنامه⬇️', callback_data = chat..'_TIME_MAX'}
                },{
									{text='➖',callback_data=chat..':lock TIMEMAXdown'},{text = ''..tostring(TIME_MAX)..'', callback_data = chat..'_TIME_MAX'},{text='➕',callback_data=chat..':lock TIMEMAXup'}
				  },{
                 {text = '⬇️حداکثر کارکتر مجاز در پیغام⬇️(جدید)', callback_data = chat..'_NUM_CH_MAX'}
                },{
									{text='➖',callback_data=chat..':lock MSGSPAMMAXdown'},{text = ''..tostring(NUM_CH_MAX)..'', callback_data = chat..'_NUM_CH_MAX'},{text='➕',callback_data=chat..':lock MSGSPAMMAXup'}
				   },{
				   {text = '⬇️حداکثر اخطار مجاز برای کاربران⬇️(جدید)', callback_data = chat..'_WARN_MAX'}
                },{
									{text='➖',callback_data=chat..':lock WARNMAXdown'},{text = ''..tostring(WARN_MAX)..'', callback_data = chat..'_WARN_MAX'},{text='➕',callback_data=chat..':lock WARNMAXup'}
				   },{
				  {text = '↖️بازگشت به تنظیمات قفل ها', callback_data = 'left_page:'..chat},{text = '↗️بازگشت به بخش فیلترها', callback_data = 'next_page:'..chat}
				  },{
				  {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
                }
							}
              edit(q.inline_message_id,'تنظیمات-ابرگروه(هرزنامه + اخطار)\nجهت تنظیم اقدام کنید یا در صورت تمایل به منوی قبل بازگردید:',keyboard)
			elseif not redis:hget('sizepanel'..chat,'changepanelsize') then
local MSG_MAX = (redis:hget("flooding:settings:"..chat,"floodmax") or 5)
								local TIME_MAX = (redis:hget("flooding:settings:"..chat,"floodtime") or 3)
								 MUTE_MAX = (redis:get(SUDO..'muteall'..chat) or 0)
								 NUM_CH_MAX = (redis:get('NUM_CH_MAX:'..chat) or 200)
			  WARN_MAX = (redis:get('Warn:Max:'..chat) or 3)
				local keyboard = {}
							keyboard.inline_keyboard = {
								{
                 {text=getsettings('spam'),callback_data=chat..':lock spam'} ,{text = 'عملکرد قفل ارسال هرزنامه', callback_data = chat..'_spam'}
					},{
					{text=getsettings('spamtext'),callback_data=chat..':lock spamtext'},{text = 'حذف پیغام بلند(جدید)', callback_data = chat..'_spamtext'}
                },{
                 {text = '⬇️حداکثر پیغام مجاز ارسال هرزنامه⬇️', callback_data = chat..'_MSG_MAX'}
                },{
									{text='➖',callback_data=chat..':lock MSGMAXdown'},{text = ''..tostring(MSG_MAX)..'', callback_data = chat..'_MSG_MAX'},{text='➕',callback_data=chat..':lock MSGMAXup'}
				   },{
                 {text = '⬇️حداکثر زمان مجاز ارسال هرزنامه⬇️', callback_data = chat..'_TIME_MAX'}
                },{
									{text='➖',callback_data=chat..':lock TIMEMAXdown'},{text = ''..tostring(TIME_MAX)..'', callback_data = chat..'_TIME_MAX'},{text='➕',callback_data=chat..':lock TIMEMAXup'}
				  },{
                 {text = '⬇️حداکثر کارکتر مجاز در پیغام⬇️(جدید)', callback_data = chat..'_NUM_CH_MAX'}
                },{
									{text='➖',callback_data=chat..':lock MSGSPAMMAXdown'},{text = ''..tostring(NUM_CH_MAX)..'', callback_data = chat..'_NUM_CH_MAX'},{text='➕',callback_data=chat..':lock MSGSPAMMAXup'}
				   },{
				   {text = '⬇️حداکثر اخطار مجاز برای کاربران⬇️(جدید)', callback_data = chat..'_WARN_MAX'}
                },{
									{text='➖',callback_data=chat..':lock WARNMAXdown'},{text = ''..tostring(WARN_MAX)..'', callback_data = chat..'_WARN_MAX'},{text='➕',callback_data=chat..':lock WARNMAXup'}
				   },{
				  {text = '↖️بازگشت به تنظیمات قفل ها', callback_data = 'left_page:'..chat},{text = '↗️بازگشت به بخش فیلترها', callback_data = 'next_page:'..chat}
				  },{
				  {text = 'بازگشت به منوی اصلی ◀️', callback_data = 'firstmenu:'..chat}
                }
							}
              edit(q.inline_message_id,'تنظیمات-ابرگروه(هرزنامه + اخطار)\nجهت تنظیم اقدام کنید یا در صورت تمایل به منوی قبل بازگردید:',keyboard)
            end
			end
			---*****************************************************************------
            else Canswer(q.id,'شما مالک/مدیر گروه نیستید و امکان تغییر تنظیمات را ندارید!\nربات خود را دریافت کنید:\nhttps://t.me/'..salechannelbot..'',true)
						end
						end
          if msg.message and msg.message.date > (os.time() - 5) and msg.message.text then
     end
      end
    end
  end
    end
end

return run()
