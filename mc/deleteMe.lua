

-- get bounding box metadata
local http = require("socket.http")
local body, code = http.request("http://104.131.145.75/ImagePicker/list_crnn_metadata/")
if not body then error(code) end

-- split metadata into lines
lines=(body):split('\n')

-- output file
local output = io.open("output.txt", "w")


-- iterate
for i=1,#lines,1 do
   line=lines[i]
   column = (line):split('\t')
   pk = column[1]
   url = column[2]

   -- open image
   print(url)
   local body, code = http.request(url)
   if not body then error(code) end

   -- save to file
   local f = assert(io.open('temp.jpg', 'wb'))
   f:write(body)
   f:close()

   -- write output to text file
   output:write(pk .. "\t" .. "2\n")

end

