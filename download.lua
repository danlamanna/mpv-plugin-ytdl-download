utils = require 'mp.utils'

function subprocess_run(args)
   local result = utils.subprocess({
         args = args
   })

   if result["status"] < 0 or result["error"] ~= nil then
      mp.msg.log("error", "Failed to run command.")
      mp.osd_message("Failed to run command.")
   end
end

function download_video()
   local path = mp.get_property_native("path")

   if (string.sub(path, 0, 8) == 'https://' or
       string.sub(path, 0, 7) == 'http://') then
      subprocess_run({"systemd-run", "--user", "--remain-after-exit", "youtube-dl", path})
      mp.osd_message("Download spawned.")
   else
      local message = "Doesn't appear to be an http stream."
      mp.msg.log("warn", message)
      mp.osd_message(message)
   end
end

mp.add_key_binding("W", "download_video", download_video)
