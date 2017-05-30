require('cutorch')
require('nn')
require('cunn')
require('cudnn')
require('optim')
require('paths')
require('nngraph')

require('libcrnn')
require('utilities')
require('inference')
require('CtcCriterion')
require('DatasetLmdb')
require('LstmLayer')
require('BiRnnJoin')
require('SharedParallelTable')


cutorch.setDevice(1)
torch.setnumthreads(4)
torch.setdefaulttensortype('torch.FloatTensor')

local modelDir = '/home/ubuntu/crnn/model/crnn_demo/'
paths.dofile(paths.concat(modelDir, 'config.lua'))
local modelLoadPath = paths.concat(modelDir, 'crnn_demo_model.t7')
gConfig = getConfig()
gConfig.modelDir = modelDir
gConfig.maxT = 0
local model, criterion = createModel(gConfig)
local snapshot = torch.load(modelLoadPath)
loadModelState(model, snapshot)
model:evaluate()

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

   -- TODO: test whether we can do away with reload
   local img = loadAndResizeImage('temp.jpg')
   local text, raw = recognizeImageLexiconFree(model, img)

   -- write output to text file
   output:write(pk .. "\t" .. "crnn-lexiconFree\t" .. text .. "\t" .. raw .. "\n")

end
